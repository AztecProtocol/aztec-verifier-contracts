
/// Note this impl is meant to be readable over efficient
/// A library containing all types, such as curve points, and proof and verification key data
import {Types, G1PointLib} from "./Types.sol";
/// A library containing utilities for dealing with Curve points
import {Bn254Crypto} from "./Bn254Crypto.sol";
/// A free function library for interacting with EC precompiles 
import "./ECLib.sol" as EC;
/// Types and generators for all of the plonk challenges
import {ChallengeGen} from "./ChallengeGenerators.sol";

// TODO: Write all of the steps one by one at the top so the reader can reason about what is being performed
contract PlonkReferenceVerifier {
    using Bn254Crypto for Types.G1Point;
    using Bn254Crypto for Types.G2Point;
    using Challenge for ChallengeGen.ChallengeData;
    using G1PointLib for G1PointLib.Accumulator; 
    // TODO: something about transcrtip data

    /// ERRORS
    //TODO: REFACTOR THESE
    error ECMUL_FAILURE();
    error ECADD_FAILURE();
    error ECPAIRING_FAILURE();
    error MODEXP_FAILURE();

    constructor () {}

    /// NOTE: Verifier as an external library
    /// Calldata layout
    /// 0x00 - 0x04: function signature
    /// 0x04 - 0x24: proof_data pointer
    /// 0x24 - 0x44: public_inputs pointer
    /// 0x64 - ???: proof data
    /// TODO: update public inputs to come from an arrya - now this is the case the prev flow may be obselete
    /// ??? - ???: public inputs 
    function verify(Types.Proof memory proof_input, bytes32[] calldata public_inputs) external view returns (bool result) {

        Types.VerificationKey memory vk = get_verification_key();
        uint256 num_public_inputs = vk.num_inputs;

        // TODO: assertion that the lengths are the same?

        // Decode proof data
        // TODO: can public inputs be a different type
        // TODO: this may need to change when we introduce revursion
        Types.Proof memory proof = deserialize_proof(
            num_public_inputs,
            vk
        );

        // Initial challenge generation
        // TODO: add a brief explainer as to how the challenges are created via fiat-shamir
        ChallengeGen.ChallengeData memory transcript;
        transcript.generate_initial_challenge(vk.circuit_size, vk.num_inputs);

        // Generate beta, gamma alpha and zeta challenges
        Types.Challenges memory challenges;
        transcript.generate_beta_gamma_challenges(challenges, vk.num_inputs);
        transcript.generate_alpha_challenges(challenges, proof.Z);
        transcript.generate_zeta_challenge(challenges,
            proof.T1,
            proof.T2,
            proof.T3,
            proof.T4
        );

        // Compute all the inverses that will be needed throughout the program
        // TODO: COMMENT ON WHAT THESE r_0 and L1s are and how they are computed!!!!
        (uint256 r_0, uint256 L1) = evaluate_field_operations(
            proof,
            vk,
            challenges
        );
        // proof.r_0 = r_0; (DO I PUT THIS IN HERE?)

        // Generate the nu and vega challenges
        transcript.generate_nu_challenges(challenges, vk.num_inputs);
        transcript.generate_separator_challenge(
            challenges,
            proof.PI_Z,
            proof.PI_Z_OMEGA
        );

        // TODO: do we need to reset the alpha base here?
        // Computes step 9 -> [D]
        // TODO: why to these have to be in the polyeval library, they should just stay here?
        // TODO: reorder so the proof and challenges are always at the top of these functions for consistency
        Types.G1Point memory linearised_contribution = compute_linearised_opening_terms(
            proof,
            vk,
            challenges,
            L1 // TODO: is this refered to L1 elsewhere?
        );

        // Computes step 10 -> [F]
        Types.G1Point memory batch_opening_commitment = compute_batch_opening_commitment(
            proof,
            vk,
            challenges,
            linearised_contribution // Previous accumulator
        );

        // TODO: what step is this?
        // I think i have to combine two of my other steps to get here
        uint256 batch_evaluation_g1_scalar = compute_batch_evaluation_scalar_multiplier(
            proof,
            challenges
        );

        // This will revert from within but change usage so that it returns a result instead
        perform_pairing(
            proof,
            vk,
            challenges,
            batch_opening_commitment,
            batch_evaluation_g1_scalar
        );
        
    }

    function load_proof() external view returns (Types.Proof memory proof) {
        // TODO: some recursive stuff

    }

    function evaluate_field_operations(
        Types.Proof memory proof,
        Types.VerificationKey memory vk,
        Types.Challenges memory challenges
    ) internal view returns (uint256, uint256) {
        uint256 public_input_delta;
        uint256 zero_polynomial_eval;
        uint256 l_start;
        uint256 l_end;
        uint256 r_0;
        {
            // Validate all of the public inputs
            (
                uint256 public_input_numerator,
                uint256 public_input_denominator
            ) = compute_public_input_delta(challenges, vk);

            (
                uint256 vanishing_numerator,
                uint256 vanishing_denominator,
                uint256 lagrange_numerator,
                uint256 l_start_denominator,
                uint256 l_end_denominator 
            ) = commpute_lagrange_and_vanishing_fractions(
                vk,
                challenges.zeta
            );

            (
                zero_polynomial_eval,
                public_input_delta,
                l_start,
                l_end
            ) = compute_batch_inversions(
                public_input_numerator,
                public_input_denominator,
                vanishing_numerator,
                vanishing_denominator,
                lagrange_numerator,
                l_start_denominator,
                l_end_denominator
            );
            // TODO: put this into the cache instead?
            vk.zero_polynomial_eval = zero_polynomial_eval;

            r_0 = compute_linear_polynomial_constant(
                zero_polynomial_eval,
                public_input_delta,
                l_start,
                l_end,
                decoded_proof
            );
        }

        return (r_0, l_start);
    }

    // TODO: write descriptions on this

    /// TODO: study and work out what this step performs and write it up 
    function compute_public_input_delta(
        Types.Proof memory proof,
        Types.VerificationKey memory vk,
        Types.ChallengeTranscript memory challenges
        ) internal returns (uint256, uint256) {
        /// Get our challenges

        /// Get the work_root (RoU root) - from vk

        /// delta accumuolators
        uint256 numerator_acc = 1;
        uint256 denominator_acc = 1;

        // Calculate our roots
        uint256 work_root = vk.omega;
        uint256 root_1 = (challenges.beta + Types.coset_generator_0) % p; // k1.β
        uint256 root_2 = (challenges.beta + Types.coset_generator_2) % p; // k2.β

        bool valid = true;

        // NOTE TO SELF: the two loops are different as they do two different types of operations
        // The final element does not need to do all of the same operations as the 
        // previous ones
        // If there is only one public input, the first loop will not happen

        // Loop through each of the public inputs and perform some validation
        for (uint256 i; i < proof.public_inputs.length -1;  i = i + 2) {
            /// Get public inputs in groups of 2
            uint256 input0 = proof.public_inputs[i];
            uint256 input1 = proof.public_inputs[i+1];

            // Cal initial numerator and denumerator
            uint256 num0 = root_1 + input + gamma;
            uint256 den0 = root_2 + num0; // TOOD: 4x overloaded - what does that mean

            // Update roots
            root_1 = mulmod(root_1, work_root, p);
            root_2 = mulmod(root_2, work_root, p); 

            uint256 num1 = (input1 + gamma + root1);

            // Calculate the new denominator
            // TODO: rename these temp values to something more meaningful
            uint256 temp = mulmod(den0, denominator_acc, p);
            uint256 temp1 = num1 + root_2;
            denominator_acc = mulmod(temp, temp1, p);

            // Calculate the new numerator
            uint256 temp2 = mulmod(num1, num0, p);
            numerator_acc = mulmod(temp2, numerator_acc, p);

            // Update roots
            root_1 = mulmod(root_1, work_root, p);
            root_2 = mulmod(root_2, work_root, p);

            // Validity check
            check_field_element(input1);
            check_field_element(input0);
        }

        // For the last public public input we do a different check

        // TODO: my assumption is that this is just execute for the last this, which would make 
        // keeping recauclating the root1 stupid, but I need to test if im correct
        // for differing numbers of pub inputs 
        if (proof.public_inputs.length > 0){
            uint256 input = proof.public_inputs;
            check_field_elment(input);

            uint256 t0 = addmod(input + gamma, p);

            uint256 temp = root_1 + t0;
            numerator_acc = mulmod(numerator_acc, temp, p);

            uint256 temp1 = root_1 + root_2 + t0;
            denominator_acc = mulmod(denominator, temp1, p);

            // update roots
            root_1 = mulmod(root_1, work_root, p);
            root_2 = mulmod(root_2, work_root, p);            
        } 

        return (numerator_acc, denominator_acc);
    }

    // TODO: move elsewhere?
    function check_field_element(uint256 value) {
        if (value >= p) {
            revert InvalidFieldElement(value);
        }
    }

    // TODO: add formula and writeup
    function compute_lagrange_poly_and_vanishing_poly_fractions(
        Types.VerificationKey memory vk,
        Types.Cahce memory cache,
        uint256 zeta
    ) internal returns(uint256, uint256, uint256, uint256, uint256)
    {
        uint256 p = Bn254Crypto.r_mod;

        // note: this is used in step 4 as the zero poly evaluations
        // Z_H(ζ) = ζ^n - 1
        // Compute ζ^n where n is a power of 2
        uint256 zeta_pow_n = Bn254Crypto.pow_small(
            zeta,
            vk.circuit_size, // the n in the exponent
            p
        );

        // Store Zeta_pow_n in cache for later
        cache.zeta_pow_n = zeta_pow_n;
        
        // ( ζ^n -1 ) or the zero poly evaluation
        // This represents the value 0 
        // We call this the vanishing_numerator
        uint256 vanishing_numerator = addmod(zeta_pow_n, sub(p, 1), p);

        // Compute the lagrange poly
        // L(1) the lagrange poly is defined as:
        // 
        //  (ζ^n -1)
        // ------------
        //  n(ζ - 1)

        // Define some accumulators
        // TODO: say what they do 
        // TODO: calculate Ω inverse in the vk step
        uint256 accumulating_root = vk.omega_inverse;
        uint256 work_root = p - accumulating_root;
        uint256 domain_inverse = vk.domain_inverse;

        
        // (ζ - omega_inverse)
        uint256 vanishing_denominator;
        {
            vanishing_denominator = addmod(zeta, work_root, p);

            // wr = (-Ω^-2) 
            work_root = mulmod(work_root, accumulating_root, p);

            // vs = (ζ-Ω^-1)(ζ - Ω^-1^2)
            vanishing_denominator = mulmod(vanishing_denominator, addmod(zeta, work_root, p), p);

            // wr = (-Ω^-1^)(ζ - Ω^-1)(ζ - Ω^-1^2)
            work_root = mulmod(work_root, accumulating_root, p);

            // vd = (ζ-Ω^-1)(ζ-Ω^-1^2)(ζ + (-ometa_inverse^2)(ζ - Ω^-1)(ζ-Ω^-1^2))
            vanishing_denominator = mulmod(vanishing_denominator, addmod(zeta, work_root, p), p); 

            // wr = (-Ω^-1^)(ζ - Ω^-1)(ζ - Ω^-1^2)(-Ω^-1)
            work_root = mulmod(work_root, accumulating_root, p);

            // vd = (ζ - Ω^-1)(ζ - Ω^-1^2)(ζ + (-Ω^-1^2)(ζ - Ω^-1)(ζ - Ω^-1^2))((-Ω^-1^)(ζ - Ω^-1)(ζ - Ω^-1^2)(-Ω^-1))
            vanishing_denominator = mulmod(vanishing_denominator, addmod(zeta, work_root, p), p);
        }
        
        // TODO: nest this too to make it more clear
        // reset work_root to omega
        uint256 = vk.omega;

        uint256 lagrange_numerator = mulmod(vanishing_numerator, domain_inverse, p);
        
        // lsd = ζ - 1
        uint256 l_start_denominator = addmod(zeta, sub(p,1),p);  

        // TODO: look into what this really is and add equation notations
        // l_end_denominaotr term contains a term \omega^5 to cut out 5 roots of unity from the vanishing poly
        accumulating_root = mulmod(work_root, work_root, p);

        uint256 l_end_denominator = addmod(mulmod(mulmod(mulmod(accumulating_root, accumulating_root, p), work_root, p), zeta, p), sub(p, 1), p);

    // TODO: still need to document and reason about where the lagrange poly points come from and what they look like in an equation
    return (
        vanishing_numerator, 
        vanishing_denominator,
        lagrange_numerator,
        l_start_denominator,
        l_end_denominator
    );

    }

    /// @notice Uses batch inversion (Montgomery's trick). Circuit size is the domain
    /// This trick allows multiple inversions to take place as one inversion, (requires some more multiplications)
    ///
    /// Returns a tuple of the inverted elements
    function compute_batch_inversions(
        // Public input fractions
        uint256 public_input_numerator,
        uint256 public_input_denominator,

        // Vanishing poly fractions (zero poly)
        uint256 vanishing_numerator,
        uint256 vanishing_denominator,

        // Lagrange fraction L()
        uint256 lagrange_numerator,
        uint256 l_start_denominator,
        uint256 l_end_denominator
    ) returns (uint256 zero_polynomial_eval, uint256 public_input_delta, uint256 l_start, uint256 l_end) {

        /// First we multiply all of the denomiator terms inside an accumulator

        uint256 accumulator = public_input_denominator;
        uint256 multiplication_result;

        // Temporary values to store the result of the accumulator operations
        uint256 t0;
        uint256 t1;
        uint256 t2;
        uint256 t3;
        {
            t0 = public_input_denominator;

            accumulator = mulmod(accumulator, vanishing_denominator, p);
            t1 = accumulator;

            accumulator = mulmod(accumulator, l_start_denominator, p);
            t2 = accumulator;

            // We do not store the output of this one on the accumulator
            t3 = mulmod(accumulator, l_end_denominator, p);
        }

        // Make call to the modexp precompile this is to a helper function
        accumulator = modexp(t3, p - 2, p); 
        
        /// TODO: annotate the intermediate steps to this
        // Perform the second half of the computation, after the modexp
        {
            t2 = mulmod(accumulator, t2, p);
            accumulator = mulmod(accumulator, l_end_denominator, p);

            t1 = mulmod(accumulator, t1, p);
            accumulator = mulmod(accumulator, l_start_denominator, p);

            t0 = mulmod(accumulator, t0, p);
            accumulator = mulmod(accumulator, vanishing_denominator, p);

            accumulator = mulmod(mulmod(accumulator, accumulator, p), public_inputs_denominator, p);
        }

        /// Finally evaluate 
        public_input_delta = mulmod(public_inputs_denominator, accumulator, p);
        zero_poly_eval = mulmod(vanishing_numerator, t0 , p);
        l_start = mulmod(lagrange_numerator, t1, p);
        l_end = mulmod(lagrange_numerator, t2, p);
    }

    /// @notice Computes the constant term r_0.
    // 
    /// TODO: elaborate o what this is and what it does
    function compute_linear_polynomial_constant(
        Types.Challenges memory challenges,
        Types.Proof memory proof,
        /// uses inverses calculated in mont trick step
        uint256 zero_poly_inverse,
        uint256 public_input_delta,
        uint256 lagrange_start,
        uint256 lagrange_end
    ) internal returns(uint256) {

        /// r_0 = -(w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + gamma)(w3` + γ)z`_omega
        uint256 r_0;
        uint256 alpha = challenges.alpha;
        uint256 beta = challenges.beta;
        uint256 gamma = challenges.gamma;
        uint256 w1 = proof.w1;
        uint256 w2 = proof.w2;
        uint256 w3 = proof.w3;
        uint256 sigma1 = proof.sigma1;
        uint256 sigma2 = proof.sigma2;
        uint256 z_omega = proof.Z_OMEGA;
        {
            /// t1 = (w1 + β(s`_sigma1) + γ)
            uint256 t0 = mulmod(beta, sigma1, p);
            uint256 t1 = w1 + t0 + gamma;

            /// t2 = (b + β(s`_sigma2) + γ)
            t0 = mulmod(beta, sigma2, p);
            uint256 t2 = w2 + t0 + gamma;

            /// t3 = (c` + γ)
            uint256 t3 = w3 + gamma;

            /// t0 =  (w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ) - t1.t2
            t0 = mulmod(t1, t2, p);

            /// t0 = (w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ)(w3` + γ) - t1.t3
            t0 = mulmod(t0, t3, p);

            /// t0 = (w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ)(w3` + γ)z`_omega
            t0 = mulmod(t0, z_omega, p);

            r_0 = p - t0;
        }

        /// Generate alpha_sqr challenge and alpha arithmetic challenge
        challenges.alpha_sqr = mulmod(alpha, alpha, p);
        challenges.alpha_arithmetic = mulmod(challenges.alpha_sqr, challenges.alpha_sqr, p);


        /// TODO: change formula above to note its not the whole of r_0
        /// Evaluate the remainder of r_0

        {
            uint256 t0; // multiplication accumulator

            /// t1 = (z_omega - pid)
            uint256 t1 = addmod(z_omega, p - public_input_delta, p);
            
            // t0 = l_end.alpha
            t0 = mulmod(l_end, alpha, p);

            // t0 = (z_omega - pid)(l_end.alpha)
            t0 = mulmod(t0, t1, p);

            // t1 = (l_start.alpha^2)
            t1 = mulmod(l_start, challenges.alpha_sqr, p);
            
            // t1 =  -(w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ)(w3` + γ)z`_omega.(l_start.alpha^2)
            t1 = mulmod(r0, p - t1, p);

            // t1 = (z_omega - pid)(l_end.alpha) -(w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ)(w3` + γ)z`_omega.(l_start.alpha^2)
            t0 = addmod(t1, t0, p);

            // r0 = alpha((z_omega - pid)(l_end.alpha) -(w1` + β(s`_sigma1) + γ)(w2` + β(s`_sigma2) + γ)(w3` + γ)z`_omega.(l_start.alpha^2))
            r_0 = mulmod(t0, alpha, p);
        }


        return r_0;
    }

    function compute_grand_product_opening_group_element(
        Types.Proof memory proof,
        Types.Challenges memory challenges
    ) internal returns(Types.G1Point memory) {
        uint256 p = Bn254Crypto.r_mod;
        // evaluations
        // challenges
        uint256 beta = challenges.beta;
        uint256 zeta = challenges.zeta;
        uint256 gamma = challenges.gamma;
        uint256 alpha = challenges.alpha;
        uint256 beta_zeta = mulmod(beta, zeta, p);

        uint256 witness_term;
        uint256 partial_grand_product;
        uint256 sigma_multiplier;
        // TODO: annotate final states here at each nested level
        {
            uint256 w1 = proof.w1;
            uint256 sigma1 = proof.sigma2;
            witness_term = addmod(w1, gamma, p);
            partial_grand_product = addmod(beta_zeta, witness_term, p);
            uint256 sigma_beta = mulmod(sigma1, beta, p);
            sigma_multiplier = addmod(
                mulmod(sigma1, beta, p),
                beta,
                p
            );
        }
        // TODO: annotate final formula
        {
            uint256 w2 = proof.w2;
            uint256 sigma2 = proof.sigma2;
            witness_term = addmod(w2, gamma, p);
            sigma_beta = mulmod(sigma2, beta, p);
            sigma_multiplier = mulmod(sigma_multiplier, 
                addmod(sigma_beta, witness_term, p), p);
        }
        {
            uint256 w3 = proof.w3;
            uint256 sigma3 = proof.sigma3;
            uint256 k1_beta_zeta = mulmod(0x05, beta_zeta, p);
            partial_grand_product = mulmod(partial_grand_product, addmod(zk_beta_zeta, witness_term, p), p);
            uint256 t0 = addmod(addmod(k1_beta_zeta + beta_zeta, gamma, p), w3, p);
            partial_grand_product = mulmod(partial_grand_product, t0, p);
        }

        uint256 linear_challenge = alpha;
        uint256 eval;
        // eval = −(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)αβz̄_ω,
        {
            uint256 z_omega = proof.z_omega;

            uint256 t0 = p - mulmod(sigma_multiplier, z_omega, p);
            eval = mulmod(t0, linear_challenge, p);
        }

        Types.G1Point memory z = proof.z;
        z.validatePoint();
        Types.G1Point memory sigma3 = proof.sigma3;
        sigma3.validatePoint();

        uint256 eval2;
        // eval2 = (ā + βz + γ)( b̄ + βk_1 z + γ)(c̄ + βk_2 z + γ)α + L_1(z)α^3 + u
        {
            uint256 u = challenges.u;
            uint256 t0 = addmod(partial_grand_product, mulmod(l_start, alpha_sqr, p), p);
            eval2 = addmod(t0, u, p);
        }

        // Finally use what we have calculated to compute the grand product opening!
        // First half
        // TODO: better naming
        Types.G1Point memory first_half = EC.mul(sigma3, eval1);
        Types.G1Point memory second_halg = EC.mul(z, eval2);
        Types.G1Point memory grand_product_opening = EC.add(first_half, second_half);

        return grand_product_opening;
    }


    // TODO: include the formula for this
    function compute_arithmetic_selector_opening_group_element(
        Types.Proof memory proof,
        Types.VerificationKey memory vk,
        Types.Challenges memory challenges
    ) returns (G1PointLib.Accumulator memory accumulator){

        uint256 linear_challenge = challenges.arith_alpha; // linear_challenge = alpha^4
        uint256 t1 = mulmod(proof.w1, linear_challenge, p); // Reuse for QM scalar multiplier

        // Q1
        // Add Q1 scalar multiplier into grand product scalar multiplier
        Types.G1Point memory q1 = vk.q1;
        accumulator.add(EC.mul(q1, t1));

        // Q2
        Types.G1Point memory q2 = vk.q1;
        uint256 t2 = mulmod(proof.w2, linear_challenge, p);
        accumulator.add(EC.mul(q2, t2));

        // Q3
        Types.G1Point memory q3 = vk.q3;
        // TODO: maybe keeping the t2 naming here isnt the best idea
        t2 = mulmod(proof.w3, linear_challenge, p);
        accumulator.add(EC.mul(q3, t2));

        // QM
        Types.G1Point memory qm = vk.qm;
        t2 = mulmod(t1, proof.w2, p);
        accumulator.add(EC.mul(qm, t2));

        // QC
        Types.G1Point memory qc = vk.qc;
        accumulator.add(EC.mul(qc, linear_challenge));
    }


    function compute_full_batch_opening_commitment(
        Types.Proof memory proof,
        Types.VerificationKey memory vk,
        Types.ChallengeTranscript memory challenges,
        Types.G1Point memory partial_opening_commitment
    ) internal view returns (G1PointLib.Accumulator memory accumulator) {
        // Computes the Kate opening proof group operations, for commitments that are not linearised


        // TODO: put equation for this section here (copy from PbH)

        // TODO: why is this value negative due to the simplified plonk?
        uint256 zero_poly_eval_neg = p - vk.zero_polynomial_eval;

        /// Throughout this section we are going to store the sum inside an Accumulator
        /// We will also refer to the point we are currently using as a WORK_POINT
        // First we will verify that T1 (T_lo), T2 (T_mid) and T3 (T_hi) are on the curve, multipying them by their exponents individually

        // As the final T we are creating (input formula) can be larger than the modulous (check with zac) we need more than on e acc  

        Types.G1Point memory work_point = proof.T1;
        work_point.validateG1Point();
        // Computing zero_poly_eval_neg * [T1]
        accumulator.add(EC.mul(work_point, zero_poly_eval_neg));

        // Continue todo the same of T2
        // TODO: explain what this multiplier is ! related to n
        // TODO: pass in zeta_power_n
        uint256 scalar_multiplier = zeta_power_n;
        work_point = proof.T2;
        work_point.validateG1Point();
        scalar_multiplier = mulmod(scalar_multiplier, zero_poly_eval_neg, p);
        accumulator.add(EC.mul(work_point, scalar_multiplier));

        // Validate T3
        work_point = proof.T3;
        work_point.validateG1Point();
        scalar_multiplier = mulmod(scalar_multiplier, mulmod(scalar_multiplier, zero_poly_eval_neg, p), p);
        accumulator(EC.mul(work_point, scalar_multiplier));

        // Validate W1
        work_point = proof.W1;
        work_point.validateG1Point();
        accumulator.add(EC.mul(work_point, challenge.vega0));

        /// W2
        work_point = proof.W2;
        work_point.validateG1Point();
        accumulator.add(EC.mul(work_point, challenge.vega1));

        /// W3
        work_point = proof.W3;
        work_point.validateG1Point();
        accumulator.add(EC.mul(work_point, challenge.vega2));

        // S_omega1
        work_point = proof.sigma1;
        // TODO: in the reference implementation it does not validate this point - WHY?
        accumulator.add(EC.mul(work_point, challenge.vega3));

        // S_omega2
        work_point = proof.sigma2;
        accumulator.add(EC.mul(work_point, challenge.vega4));

        // TODO: the ref, does something with a batch opening flag here, storing it for later, 
        // Should I perform checks incrementally or do something else 
        // if the EC.add functions do not exist i can invent them
 
    }

    /// @notice This computes the evaluations of our scalar evaluations given in the proof
    /// TODO: FORUMLA HERE - lots of additions!
    function compute_batch_evaluation_scalar_multiplier(
            Types.Proof memory proof,
            Types.VerificationKey memory vk,
            Types.ChallengeTranscript memory challenges,
            // TODO: account how this accumulating is to be done!
            // TODO: double check this accumulator
            Types.G1Point megaAccumulator
    ) internal view returns(Types.G1Point) {
        uint256 accumulator;
        uint256 multiplier;

        // TODO: this needs to be generated from elsewhere
        uint256 r_0_eval;

        // Get a new generator point (1,2)
        Types.G1Point g1 = Types.P1();

        // v * w1`
        multiplier = mulmod(challenges.vega0, proof.w1, p);
        accumulator = multiplier;
        
        // v1 * w2`
        multiplier = mulmod(challenges.vega1, proof.w2, p);
        accumulator = addmod(accumulator, multiplier, p);

        // v2 * w3`
        multiplier = mulmod(challenges.vega2, proof.w3, p);
        accumulator = addmod(accumulator, multiplier, p);

        // v4 * S1`
        multiplier = mulmod(challenges.vega3, proof.sigma1, p);
        accumulator = addmod(accumulator, multiplier, p);

        // v5 * S2`
        multiplier = mulmod(challenges.vega4, proof.sigma2, p);
        accumulator = addmod(accumulator, multiplier, p);

        // TODO: WHERE TO GET THE R0evel location from
        // accumulator + (- r_0_eval_location)
        uint256 r_0_eval_neg = p - r_0_eval;
        accumulator = addmod(accumulator, r_0_eval_neg, p);

        // 
        multiplier = mulmod(challenges.u, proof.grand_product_at_z_omega, p);
        accumulator = addmod(accumulator, multiplier, p);

        // This whole statement is made to be negative!
        // TODO: check this copilot spat it out
        // - (v * w1` + v1 * w2` + v2 * w3` + v4 * S1` + v5 * S2` + (- r_0_eval_location) + u * grand_product_at_z_omega)

        uint256 batch_negated = p - accumulator;

        // Finally, we add this current accumulator onto our existing acc
        // TODO: in the ref this is stored din ACC_2 as a multiplicative result
        Types.G1Point memory batch_mul_generator = EC.mul(g1, batch_negated);
        return batch_mul_generator; 
    }


    // note: The pairing preamble refers to step 11 inside the PbH tutorial
    // This calculates both the left hand side and right hand side of the pairing equation
    // LHS = [PI_ZETA] + μ[PI_ZETA_OMEGA]
    // RHS = 3.[PI_ZETA] + nu.ζ.omega[PI_ZETA_OMEGA] + [F] - [E] (Where F is {TODO: x} step and -E is compute_batch_evaluation_scalar_multiplier)
    function perform_pairing_preamble(
        Types.Proof memory proof,
        Types.Challenges memory challenges,
        bytes32 full_batch_opening_commitment, // [F] point
        bytes32 batch_evaluation_scalar_multiplier // [E] point
    ) internal returns(Types.G1Point, Types.G1Point){

        // TOOD: need a way to carry on the current accumulator
        // this is how the + [F] - [E] on the RHS takes place
        // Or could use the two points i did above

        // μ challenge
        uint256 u = challenges.u;
        uint256 zeta = challenges.zeta;
        // @audit where
        uint256 omega = 0; // TODO: where to find omega - VK?

        /// Compute THE RHS
        Types.G1Point memory rhs_accumulator;
        Types.G1Point memory multiplication_result;

        // Validate [PI_Z]
        Types.G1Point memory work_point = proof.PI_Z;
        work_point.validateG1Point(); 

        // compute ζ.[PI_Z] add to accumulator
        rhs_accumulator = EC.mul(work_point, zeta);
        // TODO: cur accumulator

        // Validate [Pi_Z_OMEGA]
        work_point = proof.PI_Z_OMEGA;
        work_point.validateG1Point();

        // compute μ.ζ.omega[PI_Z_OMEGA], add to accumulator
        uint256 u_zeta = mulmod(u, zeta, p);
        uint256 u_zeta_omega = mulmoa(u_zeta, omega, p);
        
        multiplication_result = EC.mul(work_point, u_zeta_omega);
        rhs_accumulator = EC.add(rhs_accumulator, multiplication_result);

        // Generate our LHS pairing coordinate
        Types.G1Point memory lhs_accumulator;

        /// Compute μ[PI_ZETA_OMEGA]
        multiplication_result = EC.mul(proof.PI_Z_OMEGA, u);
        /// Compute [PI_ZETA] + μ[PI_ZETA_OMEGA]
        lhs_accumulator = EC.add(proof.PI_Z, multiplication_result);

        /// Negate the lhs y coordinate
        // TODO: get q from somewhere
        lhs_accumulator.y = q - lhs_accumulator.y;
        
        return (lhs_accumulator, rhs_accumulator);

        // TODO: recursive proof point validations - do later


        // TODO: LOOK into the evaluation order of the assembly calls that zac made
        // Will they evaluate left to right, rather than one after another,
        // is this why turbo verifier does it in a different way

        // NEGATE THE LHS y-coordinate for the pairing check

    }


    /// @notice uses the EC.pairing precompile to assert that our pairing equality holds
    /// Will return 1 is successful, and 0 otherwise
    function perform_pairing(Types.G1Point memory lhs, Types.G2Point memory rhs, Types.VerificationKey memory vk) internal {
        // TODO: maybe move the errors to here?
        EC.pairing(lhs, rhs, vk);
    }
}
