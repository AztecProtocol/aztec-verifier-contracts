
/// Note this impl is meant to be readable over efficient


// TODO: Write all of the steps one by one at the top so the reader can reason about what is being performed
contract PlonkReferenceVerifier {
    using Bn254Crypto for Types.G1Point;
    using Bn254Crypto for Types.G2Point;
    using Challenge for ChallengeGen.ChallengeData;
    // TODO: something about transcrtip data

    constructor () {}

    /// NOTE: Verifier as an external library
    /// Calldata layout
    /// 0x00 - 0x04: function signature
    /// 0x04 - 0x24: proof_data pointer
    /// 0x24 - 0x44: public_inputs pointer
    /// 0x64 - ???: proof data
    /// TODO: update public inputs to come from an arrya
    /// ??? - ???: public inputs 
    function verify(bytes calldata proof_input, bytes32[] calldata public_inputs) external view returns (bool result) {

        Types.VerificationKey memory vk = get_verification_key();
        uint256 num_public_inputs = vk.num_inputs;

        // TODO: assertion that the lengths are the same?

        // Decode proof data
        // TODO: can public inputs be a different type
        Types.Proof memory proof = deserialize_proof(
            num_public_inputs,
            vk
        )

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
        )

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
        Types.G1Point memory linearised_contribution = PolynomialEval.compute_linearised_opening_terms(
            challenges,
            L1, // TODO: is this refered to L1 elsewhere?
            vk,
            proof
        );

        // Computes step 10 -> [F]
        Types.G1Point memory batch_opening_commitment = PolynomialEval.compute_batch_opening_commitment(
            challenges,
            vk,
            linearised_contribution, // Previous accumulator
            proof
        );

        // TODO: what step is this?
        // I think i have to combine two of my other steps to get here
        uint256 batch_evaluation_g1_scalar = PolynomialEval.compute_batch_evaluation_scalar_multiplier(
            proof,
            challenges
        );

        // This will revert from within but change usage so that it returns a result instead
        perform_pairing(
            batch_opening_commitment,
            batch_evaluation_g1_scalar,
            challenges,
            proof,
            vk
        );
        
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
            ) = PolynomialEval.compute_public_input_delta(challenges, vk);

            (
                uint256 vanishing_numerator,
                uint256 vanishing_denominator,
                uint256 lagrange_numerator,
                uint256 l_start_denominator,
                uint256 l_end_denominator 
            ) = PolynomialEval.commpute_lagrange_and_vanishing_fractions(
                vk,
                challenges.zeta
            );

            (
                zero_polynomial_eval,
                public_input_delta,
                l_start,
                l_end
            ) = PolynomialEval.compute_batch_inversions(
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

            r_0 = PolynomialEval.compute_linear_polynomial_constant(
                zero_polynomial_eval,
                public_input_delta,
                l_start,
                l_end,
                decoded_proof
            );
        }

        return (r_0, l_start);
    }
}


library Types {
    uint256 constant PROGRAM_WIDTH = 3;
    // TODO: this might not be correct    
    uint256 constant NUM_NU_CHALLENGE = 5;

    uint256 constant coset_generator0 = 0x5;
    uint256 constant coset_generator1 = 0x6;
    uint256 constant coset_generator2 = 0x7;
    uint256 constant coset_generator7 = 0xc;
    

    struct G1Point  {
        uint256 x;
        uint256 y;
    }

    struct G2Point  {
        uint256 x0;
        uint256 x1;
        uint256 y0;
        uint256 y1;
    }

    struct Proof {
        G1Point W1;
        G1Point W2;
        G1Point W3;
        G1Point Z;
        G1Point T1;
        G1Point T2;
        G1Point T3;
        uint256 w1;
        uint256 w2;
        uint256 w3;
        uint256 sigma1;
        uint256 sigma2;
        uint256 grand_product_at_z_omega;
        G1Point PI_Z;
        G1Point PI_Z_OMEGA;
        uint256[] publicInputs;
    }

    struct ChallengeTranscript {
        uint256 alpha_base;
        uint256 alpha;
        uint256 zeta;
        uint256 beta;
        uint256 gamma;
        uint256 u;
        uint256 vega0;
        uint256 vega1;
        uint256 vega2;
        uint256 vega3;
        uint256 vega4;
        uint256 vega5;
    }

    struct VerificationKey {
        uint256 circuit_size;
        uint256 num_inputs;
        uint256 work_root_omega; // TODO: (i think its Ω) what is the work root? Is it the generator for the roots of unity?
        uint256 domain_inverse;
        G1Point Q1;
        G1Point Q2;
        G1Point Q3;
        G1Point QM;
        G1Point QC;
        G1Point SIGMA1;
        G1Point SIGMA2;
        G1Point SIGMA3;
        bool contains_recursive_proof;
        uint256 recursive_point_indices;
        G2Point g2;
    }

    /// Values that are required between arithmetic steps
    struct Cache {
        uint256 zeta_pow_n;
    }
}



library PolynomialEval {
    using G1PointLib for G1PointLib.Accumulator;

    /// Helper function to get the public inputs at a given index
    
    // function get_public_input_at_index() internal returns (uint256 , uint256){
    //     // use calldataload asm

    // }

    // TODO: write descriptions on this

    /// TODO: study and work out what this step performs and write it up 
    function compute_public_input_delta(
        Types.ChallengeTranscript memory challenges,
        Types.Proof memory proof,
        Types.VerificationKey memory vk,
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
        for (uint256 i; i < proof.public_inputs.length -1 , i = i + 2) {
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
            uint256 input = proof.public_inputs
            check_field_elment(input)

            uint256 t0 = addmod(input + gamma, p);

            uint256 temp = root_1 + t0;
            numerator_acc = mulmod(numerator_acc, temp, p);

            uint256 temp1 = root_1 + root_2 + t0;
            denominator_acc = mulmod(denominator, temp1, p);

            // update roots
            root_1 = mulmod(root_1, work_root, p);
            root_2 = mulmod(root_2, work_root, p);            
        } 

        return (numerator_acc, denominator_acc)
    }

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
        )

        // Store Zeta_pow_n in cache for later
        cache.zeta_pow_n = zeta_pow_n;
        
        // ( ζ^n -1 ) or the zero poly evaluation
        // This represents the value 0 
        // We call this the vanishing_numerator
        uint256 vanishing_numerator = addmod(zeta_pow_n, sub(p, 1), p)

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
        accumulating_root = mulmod(work_root, work_root, p)l

        uint256 l_end_denominator = addmod(mulmod(mulmod(mulmod(accumulating_root, accumulating_root, p), work_root, p), zeta, p), sub(p, 1), p);

    // TODO: still need to document and reason about where the lagrange poly points come from and what they look like in an equation
    return (
        vanishing_numerator, 
        vanishing_denominator,
        lagrange_numerator,
        l_start_denominator,
        l_end_denominator
    )

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
            t3 = mulmod(accumulator, l_end_denominator, p)
        }

        // Make call to the modexp precompile this is to a helper function
        accumulator = modexp(t3, p - 2, p); 
        
        /// TODO: annotate the intermediate steps to this
        // Perform the second half of the computation, after the modexp
        {
            t2 = mulmod(accumulator, t2, p);
            accumulator = mulmod(accumulator, l_end_denominator, p);

            t1 := mulmod(accumulator, t1, p);
            accumulator := mulmod(accumulator, l_start_denominator, p);

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
        /// uses inverses calculated in mont trick step
        uint256 zero_poly_inverse,
        uint256 public_input_delta,
        uint256 lagrange_start,
        uint256 lagrange_end,
        Types.Challenges memory challenges,
        Types.Proof memory proof
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
            uint256 t1 = addmod(z_omega, p - public_input_delta, p)
            
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


    function compute_linearised_opening_terms(
        Types.Challenges memory challenges,
        uint256 
    )


    function compute_grand_product_opening_group_element() {
        Types.Challenges memory challenges,
        Types.Proof memory proof
    } internal returns(Types.G1Point memory) {
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
            witness_term = addmod(w2, gamma, p)
            sigma_beta = mulmod(sigma2, beta, p);
            sigma_multiplier = mulmod(sigma_multiplier, 
                addmod(sigma_beta, witness_term, p), p);
        }
        {
            uint256 w3 = proof.w3;
            uint256 sigma3 = proof.sigma3;
            uint256 k1_beta_zeta = mulmod(0x05, beta_zeta, p);
            partial_grand_product = mulmod(partial_grand_product, addmod(zk_beta_zeta, witness_term, p), p);
            uint256 t0 = addmod(addmod(k1_beta_zeta + beta_zeta, gamma, p);, w3, p);
            partial_grand_product = mulmod(partial_grand_product, t0, p);
        }

        uint256 linear_challenge = alpha;
        uint256 eval;
        // eval = −(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)αβz̄_ω,
        {
            uint256 z_omega = proof.z_omega;

            uint256 t0 = p - mulmod(sigma_multiplier, z_omega, p)
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
        Types.G1Point memory first_half = ecMul(sigma3, eval1);
        Types.G1Point memory second_halg = ecMul(z, eval2);
        Types.G1Point memory grand_product_opening = ecAdd(first_half, second_half);

        return grand_product_opening;
    }

    //////////////////////////////////////////////////////////////////////////////
    // TODO: is it worth adding a special type for the accumulator additions 
    // like point_accumulator.add(point); - we see the pattern alot

    // TODO: include the formula for this
    function compute_arithmetic_selector_opening_group_element(
        Types.Challenges memory challenges,
        Types.Proof memory proof,
        Types.VerificationKey memory vk
    ) returns (Types.G1Point memory accumulator){
        uint256 linear_challenge = challenges.arith_alpha // linear_challenge = alpha^4

        // Accumulators to evaluate the final opening
        G1PointLib.Accumulator memory accumulator;
        Types.G1Point memory multiplication_result;

        uint256 t1 = mulmod(proof.w1, linear_challenge, p); // Reuse for QM scalar multiplier

        // Q1
        // Add Q1 scalar multiplier into grand product scalar multiplier
        Types.G1Point memory q1 = vk.q1;;
        accumulator.add(ecMul(q1, t1));

        // Q2
        Types.G1Point memory q2 = vk.q1;
        uint256 t2 = mulmod(proof.w2, linear_challenge, p);
        accumulator.add(ecMul(q2, t2));

        // Q3
        Types.G1Point memory q3 = vk.q3;
        // TODO: maybe keeping the t2 naming here isnt the best idea
        t2 = mulmod(proof.w3, linear_challenge, p);
        multiplication_result = ecMul(q3, t2);
        accumulator = ecAdd(accumulator, multiplication_result);

        // QM
        Types.G1Point memory qm = vk.qm;
        t2 = mulmod(t1, proof.w2, p);
        multiplication_result = ecMul(qm, t2);
        accumulator = ecAdd(accumulator, multiplication_result);

        // QC
        Types.G1Point memory qc = vk.qc;
        multiplication_result = ecMul(qc, linear_challenge);
        accumulator = ecAdd(accumulator, multiplication_result);
    }


    function compute_full_batch_opening_commitment(
        Types.ChallengeTranscript memory challenges,
        Types.VerificationKey memory vk,
        Types.G1Point memory partial_opening_commitment,
        Types.Proof memory proof
    ) internal view returns (Types.G1Point memory) {
        // Computes the Kate opening proof group operations, for commitments that are not linearised


        // TODO: put equation for this section here (copy from PbH)

        // TODO: why is this value negative due to the simplified plonk?
        uint256 zero_poly_eval_neg = p - vk.zero_polynomial_eval;

        /// Throughout this section we are going to store the sum inside an Accumulator
        /// We will also refer to the point we are currently using as a WORK_POINT
        // First we will verify that T1 (T_lo), T2 (T_mid) and T3 (T_hi) are on the curve, multipying them by their exponents individually

        // As the final T we are creating (input formula) can be larger than the modulous (check with zac) we need more than on e acc  
        Types.G1Point memory accumulator;
        Types.G1Point memory multiplication_result;

        Types.G1Point memory work_point = proof.T1;
        work_point.validateG1Point();
        
        // Computing zero_poly_eval_neg * [T1]
        multiplication_result = ecMul(work_point, zero_poly_eval_neg);
        accumulator = ecAdd(accumulator, multiplication_result);

        // Continue todo the same of T2
        // TODO: explain what this multiplier is ! related to n
        // TODO: pass in zeta_power_n
        let scalar_multiplier = zeta_power_n;
        work_point = proof.T2;
        work_point.validateG1Point();
        scalar_multiplier = mulmod(scalar_multiplier, zero_poly_eval_neg, p);

        multiplication_result = ecMul(work_point, scalar_multiplier);
        accumulator = ecAdd(accumulator, multiplication_result);

        // Validate T3
        work_point = proof.T3;
        work_point.validateG1Point();

        scalar_multiplier = mulmod(scalar_multiplier, mulmod(scalar_multiplier, zero_poly_eval_neg, p), p);

        multiplication_result = ecMul(work_point, scalar_multiplier);
        accumulator = ecAdd(accumulator, multiplication_result);

        // Validate W1
        work_point = proof.W1;
        work_point.validateG1Point();

        /////////////////////////////////////////////////////
        // LIGHTBULB
        // V1 all the way to V5 is just vega^ some power!
        /////////////////////////////////////////////////////

        multiplication_result = ecMul(work_point, challenge.vega0);
        accumulator = ecAdd(accumulator, multiplication_result);

        /// W2
        work_point = proof.W2;
        work_point.validateG1Point();

        multiplication_result = ecMul(work_point, challenge.vega1);
        accumulator = ecAdd(accumulator, multiplication_result);

        /// W3
        work_point = proof.W3;
        work_point.validateG1Point();

        multiplication_result = ecMul(work_point, challenge.vega2);
        accumulator = ecAdd(accumulator, multiplication_result);

        // S_omega1
        work_point = proof.sigma1;
        // TODO: in the reference implementation it does not validate this point - WHY?

        multiplication_result = ecMul(work_point, challenge.vega3);
        accumulator = ecAdd(accumulator, multiplication_result);

        // S_omega2
        work_point = proof.sigma2;

        multiplication_result = ecMul(work_point, challenge.vega4);
        accumulator = ecAdd(accumulator, multiplication_result);

        // TODO: the ref, does something with a batch opening flag here, storing it for later, 
        // Should I perform checks incrementally or do something else 
        // if the ecAdd functions do not exist i can invent them
 
    }

    /// @notice This computes the evaluations of our scalar evaluations given in the proof
    /// TODO: FORUMLA HERE - lots of additions!
    function compute_batch_evaluation_scalar_multiplier(
            Types.ChallengeTranscript memory challenges,
            // TODO: account how this accumulating is to be done!
            Types.G1Point megaAccumulator;
            Types.VerificationKey memory vk,
            Types.Proof memory proof
    ) internal view returns(Types.G1Point) {
        uint256 accumulator;
        uint256 multiplier;

        // TODO: this needs to be generated from elsewhere
        uint256 r_0_eval

        // Get a new generator point (1,2)
        Types.G1Point g1 = Types.P1()

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
        Types.G1Point memory batch_mul_generator = ecMul(g1, batch_negated);
        return batch_mul_generator; 
    }


    // note: The pairing preamble refers to step 11 inside the PbH tutorial
    // This calculates both the left hand side and right hand side of the pairing equation
    // LHS = [PI_ZETA] + μ[PI_ZETA_OMEGA]
    // RHS = 3.[PI_ZETA] + nu.ζ.omega[PI_ZETA_OMEGA] + [F] - [E] (Where F is {TODO: x} step and -E is compute_batch_evaluation_scalar_multiplier)
    function perform_pairing_preamble(
        Types.Challenges memory challenges,
        Types.Proof memory proof,
        bytes32 full_batch_opening_commitment, // [F] point
        bytes32 batch_evaluation_scalar_multiplier // [E] point
    ) internal returns(Types.G1Point, Types.G1Point){

        // TOOD: need a way to carry on the current accumulator
        // this is how the + [F] - [E] on the RHS takes place
        // Or could use the two points i did above

        // μ challenge
        let u = challenges.u;
        let zeta = challenges.zeta;
        let omega = // TODO: where to find omega - VK?

        /// Compute THE RHS
        Types.G1Point memory rhs_accumulator;
        Types.G1Point memory multiplication_result;

        // Validate [PI_Z]
        Types.G1Point memory work_point = proof.PI_Z;
        work_point.validateG1Point(); 

        // compute ζ.[PI_Z] add to accumulator
        rhs_accumulator = ecMul(work_point, zeta);
        // TODO: cur accumulator

        // Validate [Pi_Z_OMEGA]
        work_point = proof.PI_Z_OMEGA;
        work_point.validateG1Point();

        // compute μ.ζ.omega[PI_Z_OMEGA], add to accumulator
        uint256 u_zeta = mulmod(u, zeta, p);
        uint256 u_zeta_omega = mulmoa(u_zeta, omega, p);
        
        multiplication_result = ecMul(work_point, u_zeta_omega);
        rhs_accumulator = ecAdd(rhs_accumulator, multiplication_result);

        // Generate our LHS pairing coordinate
        Types.G1Point memory lhs_accumulator;

        /// Compute μ[PI_ZETA_OMEGA]
        multiplication_result = ecMul(proof.PI_Z_OMEGA, u);
        /// Compute [PI_ZETA] + μ[PI_ZETA_OMEGA]
        lhs_accumulator = ecAdd(proof.PI_Z, multiplication_result);

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


    /// @notice uses the ecPairing precompile to assert that our pairing equality holds
    /// Will return 1 is successful, and 0 otherwise
    function perform_pairing(Types.G1Point memory lhs, Types.G2Point memory rhs, Types.VerificationKey memory vk) internal {
        // TODO: maybe move the errors to here?
        ecPairing(lhs, rhs, vk);
    }
}

/// @notice Convience library for adding ECpoints to an accumulator
library G1PointLib {
    struct Accumulator{
        Types.G1Point point;
    }

    function add(Accumulator memory self, Types.G1Point memory other) internal {
        self = ecAdd(self, other);
    }
}


library ChallengeGen {

    struct ChallengeData {
        bytes32 current_challenge;
    }

    /// @notice The initial challenge is a hash of the size of the circuit and the 
    /// number of inputs in the circuit - keep in mind that the final hash is of 64bits
    /// @audit 
    function generate_initial_challenge(ChallegeData memory self, uint256 circuit_size, uint256 number_of_inputs) {
        /// Squash into uint 32s
        // TODO: ensure that these remain 32 bits when hashing
        uint32 circuit_size_32 = uint32(circuit_size);
        uint32 number_of_inputs_32 = uint32(number_of_inputs);
        self.current_challenge = keccak(abi.encodePacked(circuit_size_32, number_of_inputs_32));
    }

    /// @notice The beta challenge is a hash of all of the public inputs, aswell as the first
    /// curve points in our proof, W1, W2, and W3

    /// In cases where the public inputs are extremely large (rollups), we may want to hash the public inputs beforehand and
    /// provide a hash to the verifier instead.
    function generate_beta_gamma_challenges(ChallengeData memory self, Types.Challenges memory challenges, uint256 num_public_inputs) {
        bytes32 challenge;
        bytes32 old_challenge = self.current_challenge;
        uint256 p = Bn254Crypto.r_mod;

        // slice all of the public inputs and the first 3 wires from calldata
        // TODO: remove assembly
        uint256 inputs_start;
        uint256 num_calldata_bytes;

        // Calculate β keccak(initial_challenge, public_inputs, W1, W2, W3)
        assembly {
            let ptr = mload(0x40);

            mstore(ptr, old_challenge);

            inputs_start := add(calldataload(0x04), 0x24)
            // TODO: 0xc0 to a constant as W1 + W2 + W3?
            num_calldata_bytes := add(0xc0, shl(num_public_inputs, 5))
            calldatacopy(add(ptr, 0x20), inputs_start, num_calldata_bytes)

            // TODO: why need to add 0x20 here?
            challenge := keccak256(ptr, add(num_calldata_bytes, 0x20))
            challenge := mod(challenge, p)
        }
        challenges.beta = challenge;

        // Calc γ keccak(β, 0x01)
        // γ is calcaulated by appending 1 to the β challenge, then hashing
        assembly {
            mstore(0x00, challenge)
            mstore(0x20, 0x01)
            challenge := keccak256(0x0, 0x21);
            challenge := mod(challenge, p)
        }
        challenges.gamma = challenge;

        // Store current challenge to be used to generate further challenges
        self.current_challenge = challenge;
    }

    /// @notice The alpha challenege is generated by appending and hashing the 
    // grand_product_opening point (Z) with the previous challenge γ
    // TODO: ^ double check name given above
    function generate_alpha_challenge(ChallengeData memory self, Types.Challenges memory challenges, Types.G1Point memory Z) {
        bytes32 prev_challenges = self.current_challenge;
        bytes32 alpha = keccak256(abi.encodePacked(prev_challenges, Z.x, Z.y));
        alpha = alpha % Bn254Crypto.r_mod;

        challenges.alpha = alpha;
        self.current_challenge = alpha;
    }

    /// @notice The zeta challenge is generated by hashing the previous challenge alpha
    /// with the T1, T2, T3 points from our proof data (T_lo, T_mid, T_hi) 
    // TODO: elaborate on what points T1,T2,T3 actually make up
    function generate_zeta_chellenge(ChallengeData memory self, Types.Challenges memory challenges, Types.G1Point memory T1, Types.G1Point memory T2, Types.G1Point memory T3, ) internal {
        bytes32 prev_challenges = self.current_challenge;
        bytes32 zeta = keccak256(abi.encodePacked(prev_challenges, T1.x, T1.y, T2.x, T2.y, T3.x, T3.y));
        zeta = zeta % Bn254Crypto.r_mod;

        challenges.zeta = zeta;
        self.current_challenge = zeta;
    }

    /// @notice The Nu challenges are generated by hashing the parts of the transcript that we have not 
    /// introduced into our challenges yet.
    /// Before we included the public inputs and W1, W2, W3 in the β and γ challenge,
    /// We included Z in alpha challenge and T1, T2, T3 in the zeta challenge
    /// 
    /// In vega (seperator challenges ) we include our evaluations for all of our polys, 
    /// ( w1eval, w2eval, w3eval, sigma1Eval, sigma2Eval and zetaOmegaEval ) ill refer to it as evals
    /// hash them then create multiple flavours by hashing them with an increasing counter
    /// 
    /// note: all below are mod p
    /// 
    /// v0 = keccak(evals)
    /// v1 = keccak(evals, 2)
    /// v2 = keccak(evals, 2)
    /// v3 = keccak(evals, 3)
    /// v4 = keccak(evals, 4)
    /// v5 = keccak(evals, 5)

    /// The nu challenges are then generated by hashing the final vega challenge with the evaluation of points PI_Z nd P_Z_OMEGA
    /// nu = keccak(v5, PI_Z, P_Z_OMEGA)
    function generate_nu_and_vega_challenges(ChallengeData memory self, Types.Challenges memory challenges, Types.Proof memory proof) {
        bytes32 prev_challenges = self.current_challenge;
        uint256 p = Bn254Crypto.r_mod;

        /// Create the hash of all of the evaluation points
        bytes32 v0_challenge = keccak256(abi.encodePacked(pev_challenges, proof.w1, proof.w2, proof.w3, proof.sigma1, proof.sigma2, proof.grand_product_at_z_omega));
        challenges.v0 = v0_challengel % p;

        bytes32 v1_challenge = keccak256(abi.encodePacked(v0_challenge, 1));
        challenges.v1 = v1_challenge % p;
        
        bytes32 v2_challenge = keccak256(abi.encodePacked(v0_challenge, 1));
        challenges.v2 = v2_challenge % p;

        bytes32 v3_challenge = keccak256(abi.encodePacked(v0_challenge, 1));
        challenges.v3 = v3_challenge % p;

        bytes32 v4_challenge = keccak256(abi.encodePacked(v0_challenge, 1));
        challenges.v4 = v4_challenge % p;

        bytes32 v5_challenge = keccak256(abi.encodePacked(v0_challenge, 1));
        challenges.v5 = v5_challenge % p;

        /// Save for use in seperator challenge
        self.current_challenge = challenges.v5;
    }

    function generate_seperator_vega_challenges(ChallengeData memory self, Types.Challenges memory challenges, Types.Proof memory proof) {
        bytes32 prev_challenges = self.current_challenge;

        /// Generate nu
        bytes32 nu_challenge = keccak256(abi.encodePacked(prev_challenges, proof.pi_z.x, proof.pi_z.y proof.pi_z_omega.x, proof.pi_z_omega.y));
        challenges.nu = nu_challenge % p;
    }
}

library Bn254Crypto {
    /// @notice the size of the prime field
    uint256 constant p_mod = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    
    /// @notice the order size of the group
    uint256 constant r_mod = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    /// @notice The point foes not exist on the G1 curve
    error NotWellFormed(G1Point point);

    /// @notice Perform a modular exponentiation.
    /// @dev Ideal for small exponents. (64 bits or less), it is cheaper than the precompile
    function pow_small(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) internal pure returns (uint256) {
        uint256 result = 1;
        uint256 input = base;
        uint256 count = 1;

        assembly {
            let endpoint := add(exponent, 0x01);
            for { } lt(count, endpoint) { } {
                if and(exponent, count) {
                    result := mulmod(result, input, modulus)
                }
                input := mulmod(input, input, modulus)
            }
        }

        return result;
    }

    /// @notice Invert a field element
    /// TODO: double check wording around here
    /// @dev Inverses are used in montgomery multiplication trick
    /// @dev uses the precompile for inversion
    function invert(uint256 fr) internal view returns (uint256) {
        uint256 output;
        bool success;
        uint256 p = r_mod;
        assembly {
            let mPtr := mload(0x40)
            mstore(mPtr, 0x20)
            mstore(add(mPtr, 0x20), 0x20)
            mstore(add(mPtr, 0x40), 0x20)
            mstore(add(mPtr, 0x60), fr)
            mstore(add(mPtr, 0x80), sub(p, 2))
            mstore(add(mPtr, 0xa0), p)
            success := staticcall(gas(), 0x05, mPtr, 0xc0, 0x00, 0x20)
            output := mload(0x00)
        }
        require(success, "pow precompile call failed!");
        return output;
    }
    
    /// @notice create a new G1Point
    /// @dev This method also perform r_mod reduction
    function new_g1(uint256 x, uint256 y)
        internal
        pure
        returns (Types.G1Point memory)
    {
        uint256 xValue;
        uint256 yValue;
        assembly {
            xValue := mod(x, r_mod)
            yValue := mod(y, r_mod)
        }
        return Types.G1Point(xValue, yValue);
    }

    /// @notice create a new G2Point
    function new_g2(
        uint256 x0,
        uint256 x1,
        uint256 y0,
        uint256 y1
    ) internal pure returns (Types.G2Point memory) {
        return Types.G2Point(x0, x1, y0, y1);
    }

    /// @notice Get the generator of G1
    function P1() internal pure returns (Types.G1Point memory) {
        return new_g1(1, 2);
    }

    /// @notice Get the generator of G2
    function P2() internal pure returns (Types.G2Point memory) {
        return
            Types.G2Point({
                x0: 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2,
                x1: 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed,
                y0: 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b,
                y1: 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            });
    }

    /// @notice Evaluate the pairing product
    /// @notice e(a1, a2).e(-b1, b2) == 1
    /// @dev This loads eithersize of the points into memory and calls the ecPairing precompile
    function pairingProd2(
        Types.G1Point memory a1,
        Types.G2Point memory a2,
        Types.G1Point memory b1,
        Types.G2Point memory b2
    ) internal view returns (bool) {
        validateG1Point(a1);
        validateG1Point(b1);
    }
    

    // TODO: maybe just to this in standard solidity rather than all asm
    // Can do that on the second pass through!
    // Maybe making small tests for each point
    // x != 0
    // y != 0
    // x < p
    // y < p
    // y^2 = x^3 + 3 mod p
    function validateG1Point(Types.G1Point memory point) internal pure {
        bool is_well_formed;
        uint256 p = p_mod;

        assembly {
            let x := mload(point);
            let y := mload(add(point, 0x20));

            is_well_formed := and (
                and(and(lt(x, p), lt(y, p)), not(or(iszero(x), iszero(y)))),
                eq(mulmod(y,y,p), addmod(mulmod(x, mulmod(x,x,p), p), 3, p))
            )
        }

        if (!is_well_formed) {
            revert NotWellFormed(point);
        }
    }
}


 //TODO: REFACTOR THESE
error ECMUL_FAILURE();
error ECADD_FAILURE();
error ECPAIRING_FAILURE();
error MODEXP_FAILURE();

function ecMul(Types.G1Point point, uint256 scalar) returns Types.G1Point {
    uint256[4] memory input;
    input[0] = point.x;
    input[1] = point.y;
    input[2] = scalar;

    uint256[2] memory out;
    bool success;
    assembly {
        success := staticcall(gas(), 7, input, 0x80, out, 0x40)
    }
    // TODO: custom error?
    if (!success) revert ECMUL_FAILURE();

    //TODO refactor
    return Types.G1Point(out[0], out[1]);
}

function ecAdd(Types.G1Point a, Types.G1Point b) returns Types.G1Point {
    uint256[4] memory input;
    input[0] = a.x;
    input[1] = a.y;
    input[2] = b.x;
    input[3] = b.y;

    uint256[2] memory out;
    bool success;
    assembly {
        success := staticcall(gas(), 6, input, 0x80, out, 0x40)
    }
    // TODO: custom error?
    if (!success) revert ECMUL_FAILURE();

    //TODO refactor
    return Types.G1Point(out[0], out[1]);
}

/// [0; 31] (32 bytes)      x1
/// [32; 63] (32 bytes)     y1
/// [64; 95] (32 bytes)     x3
/// [96; 127] (32 bytes     x2
/// [128; 159] (32 bytes    y3
/// [160; 191] (32 bytes)   y2
// TODO: convert this into standard sol if possible
function ecPairing(
    Types.G1Point memory lhs,
    Types.G1Point memory rhs,
    Types.VerificationKey memory vk
) {
    bool success = false;
    assembly {
        mstore(0x00, rhs.x)
        mstore(0x20, rhs.y)
        // TODO: use g2 point from the library gen instead
        mstore(0x40, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2) // this is [1]_2
        mstore(0x60, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
        mstore(0x80, 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
        mstore(0xa0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)

        mstore(0xc0, lhs.x)
        mstore(0xe0, lhs.y)
        mstore(0x100, vk.g2.x0)
        mstore(0x120, vk.g2.x1)
        mstore(0x140, vk.g2.y0)
        mstore(0x160, vk.g2.y1)

        success := staticcall(gas(), 8, 0x00, 0x180, 0x00, 0x20);
    }
    if (!success) revert ECPAIRING_FAILURE();
}

/// @notice this assumes that all of the inputs are 1 word long 32 bytes
function modexp(
    uint256 base, 
    uint256 exponent,
    uint256 p
) returns (uint256) {

    bool success = false;
    assembly {
        ptr = mload(0x40);
        mstore(ptr, 0x20);
        mstore(add(ptr, 0x20), 0x20)
        mstore(add(ptr, 0x40), 0x40)
        mstore(add(ptr, 0x60), base)
        mstore(add(ptr, 0x80), exponent)
        mstore(add(ptr, 0xa0), p)
        success := staticcall(gas(), 0x05, ptr, 0xc0, 0x00, 0x20)

    }
    if (!success) revert MODEXP_FAILURE();
    
    // Return the result
    assembly {
        return mload(0x00)
    }
}