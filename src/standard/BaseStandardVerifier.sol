// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

/**
 * @title Standard Plonk proof verification contract
 * @dev Top level Plonk proof verification contract, which allows Plonk proof to be verified
 * https://eprint.iacr.org/2019/953.pdf
 * https://raw.githubusercontent.com/AztecProtocol/plonk-with-lookups-private/new-stuff/PLONK-VIP%20edition.pdf?token=GHSAT0AAAAAABYVBBXOZ4OAUTU7ZSPDMDKIY77D4XA?
 */
abstract contract BaseStandardVerifier {
    // VERIFICATION KEY MEMORY LOCATIONS
    uint256 internal constant N_LOC = 0x200 + 0x00;
    uint256 internal constant NUM_INPUTS_LOC = 0x200 + 0x20;
    uint256 internal constant OMEGA_LOC = 0x200 + 0x40;
    uint256 internal constant DOMAIN_INVERSE_LOC = 0x200 + 0x60;
    uint256 internal constant Q1_X_LOC = 0x200 + 0x80;
    uint256 internal constant Q1_Y_LOC = 0x200 + 0xa0;
    uint256 internal constant Q2_X_LOC = 0x200 + 0xc0;
    uint256 internal constant Q2_Y_LOC = 0x200 + 0xe0;
    uint256 internal constant Q3_X_LOC = 0x200 + 0x100;
    uint256 internal constant Q3_Y_LOC = 0x200 + 0x120;
    uint256 internal constant QM_X_LOC = 0x200 + 0x140;
    uint256 internal constant QM_Y_LOC = 0x200 + 0x160;
    uint256 internal constant QC_X_LOC = 0x200 + 0x180;
    uint256 internal constant QC_Y_LOC = 0x200 + 0x1a0;
    uint256 internal constant SIGMA1_X_LOC = 0x200 + 0x1c0;
    uint256 internal constant SIGMA1_Y_LOC = 0x200 + 0x1e0;
    uint256 internal constant SIGMA2_X_LOC = 0x200 + 0x200;
    uint256 internal constant SIGMA2_Y_LOC = 0x200 + 0x220;
    uint256 internal constant SIGMA3_X_LOC = 0x200 + 0x240;
    uint256 internal constant SIGMA3_Y_LOC = 0x200 + 0x260;
    uint256 internal constant CONTAINS_RECURSIVE_PROOF_LOC = 0x200 + 0x280;
    uint256 internal constant RECURSIVE_PROOF_PUBLIC_INPUT_INDICES_LOC = 0x200 + 0x2a0;
    uint256 internal constant G2X_X0_LOC = 0x200 + 0x2c0;
    uint256 internal constant G2X_X1_LOC = 0x200 + 0x2e0;
    uint256 internal constant G2X_Y0_LOC = 0x200 + 0x300;
    uint256 internal constant G2X_Y1_LOC = 0x200 + 0x320;
    // 26

    // ### PROOF DATA MEMORY LOCATIONS
    uint256 internal constant W1_X_LOC = 0x200 + 0x340 + 0x00;
    uint256 internal constant W1_Y_LOC = 0x200 + 0x340 + 0x20;
    uint256 internal constant W2_X_LOC = 0x200 + 0x340 + 0x40;
    uint256 internal constant W2_Y_LOC = 0x200 + 0x340 + 0x60;
    uint256 internal constant W3_X_LOC = 0x200 + 0x340 + 0x80;
    uint256 internal constant W3_Y_LOC = 0x200 + 0x340 + 0xa0;
    uint256 internal constant Z_X_LOC = 0x200 + 0x340 + 0xc0;
    uint256 internal constant Z_Y_LOC = 0x200 + 0x340 + 0xe0;
    uint256 internal constant T1_X_LOC = 0x200 + 0x340 + 0x100;
    uint256 internal constant T1_Y_LOC = 0x200 + 0x340 + 0x120;
    uint256 internal constant T2_X_LOC = 0x200 + 0x340 + 0x140;
    uint256 internal constant T2_Y_LOC = 0x200 + 0x340 + 0x160;
    uint256 internal constant T3_X_LOC = 0x200 + 0x340 + 0x180;
    uint256 internal constant T3_Y_LOC = 0x200 + 0x340 + 0x1a0;
    uint256 internal constant W1_EVAL_LOC = 0x200 + 0x340 + 0x1c0;
    uint256 internal constant W2_EVAL_LOC = 0x200 + 0x340 + 0x1e0;
    uint256 internal constant W3_EVAL_LOC = 0x200 + 0x340 + 0x200;
    uint256 internal constant SIGMA1_EVAL_LOC = 0x200 + 0x340 + 0x220;
    uint256 internal constant SIGMA2_EVAL_LOC = 0x200 + 0x340 + 0x240;
    uint256 internal constant Z_OMEGA_EVAL_LOC = 0x200 + 0x340 + 0x260;
    uint256 internal constant PI_Z_X_LOC = 0x200 + 0x340 + 0x280;
    uint256 internal constant PI_Z_Y_LOC = 0x200 + 0x340 + 0x2a0;
    uint256 internal constant PI_Z_OMEGA_X_LOC = 0x200 + 0x340 + 0x2c0;
    uint256 internal constant PI_Z_OMEGA_Y_LOC = 0x200 + 0x340 + 0x2e0;
    // 24

    // ### CHALLENGES MEMORY OFFSETS
    uint256 internal constant C_BETA_LOC = 0x200 + 0x340 + 0x300 + 0x00;
    uint256 internal constant C_GAMMA_LOC = 0x200 + 0x340 + 0x300 + 0x20;
    uint256 internal constant C_ALPHA_LOC = 0x200 + 0x340 + 0x300 + 0x40;
    uint256 internal constant C_ARITHMETIC_ALPHA_LOC = 0x200 + 0x340 + 0x300 + 0x60;
    uint256 internal constant C_ZETA_LOC = 0x200 + 0x340 + 0x300 + 0x80;
    uint256 internal constant C_CURRENT_LOC = 0x200 + 0x340 + 0x300 + 0xa0; // @note Can be removed
    uint256 internal constant C_V0_LOC = 0x200 + 0x340 + 0x300 + 0xc0;
    uint256 internal constant C_V1_LOC = 0x200 + 0x340 + 0x300 + 0xe0;
    uint256 internal constant C_V2_LOC = 0x200 + 0x340 + 0x300 + 0x100;
    uint256 internal constant C_V3_LOC = 0x200 + 0x340 + 0x300 + 0x120;
    uint256 internal constant C_V4_LOC = 0x200 + 0x340 + 0x300 + 0x140;
    uint256 internal constant C_V5_LOC = 0x200 + 0x340 + 0x300 + 0x160;
    uint256 internal constant C_U_LOC = 0x200 + 0x340 + 0x300 + 0x180;
    // 13

    // ### LOCAL VARIABLES MEMORY OFFSETS
    uint256 internal constant DELTA_NUMERATOR_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x00;
    uint256 internal constant DELTA_DENOMINATOR_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x20;
    uint256 internal constant ZETA_POW_N_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x40;
    uint256 internal constant PUBLIC_INPUT_DELTA_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x60;
    uint256 internal constant ZERO_POLY_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x80;
    uint256 internal constant L_START_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0xa0;
    uint256 internal constant L_END_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0xc0;
    uint256 internal constant R_ZERO_EVAL_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0xe0;
    uint256 internal constant ACCUMULATOR_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x100;
    uint256 internal constant ACCUMULATOR_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x120;
    uint256 internal constant ACCUMULATOR2_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x140;
    uint256 internal constant ACCUMULATOR2_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x160;
    uint256 internal constant PAIRING_LHS_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x180;
    uint256 internal constant PAIRING_LHS_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x1a0;
    uint256 internal constant PAIRING_RHS_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x1c0;
    uint256 internal constant PAIRING_RHS_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x1e0;
    // 16

    // ### SUCCESS FLAG MEMORY LOCATIONS
    uint256 internal constant GRAND_PRODUCT_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0x00;
    uint256 internal constant ARITHMETIC_TERM_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0x20;
    uint256 internal constant BATCH_OPENING_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0x40;
    uint256 internal constant OPENING_COMMITMENT_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0x60;
    uint256 internal constant PAIRING_PREAMBLE_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0x80;
    uint256 internal constant PAIRING_SUCCESS_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xa0;
    uint256 internal constant RESULT_FLAG = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xc0;
    // 7

    // misc stuff
    uint256 internal constant OMEGA_INVERSE_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0;
    uint256 internal constant C_ALPHA_SQR_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0x20;
    // 2

    // ### RECURSION VARIABLE MEMORY LOCATIONS
    uint256 internal constant RECURSIVE_P1_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0x40;
    uint256 internal constant RECURSIVE_P1_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0x60;
    uint256 internal constant RECURSIVE_P2_X_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0x80;
    uint256 internal constant RECURSIVE_P2_Y_LOC = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0xa0;

    uint256 internal constant PUBLIC_INPUTS_HASH_LOCATION = 0x200 + 0x340 + 0x300 + 0x1a0 + 0x200 + 0xe0 + 0xc0;

    bytes4 internal constant PUBLIC_INPUT_INVALID_BN128_G1_POINT_SELECTOR = 0xeba9f4a6;
    bytes4 internal constant RECURSIVE_PROOF_INVALID_BN128_G1_POINT_SELECTOR = 0x5b6552fb;
    bytes4 internal constant PUBLIC_INPUT_GE_P_SELECTOR = 0x374a972f;
    bytes4 internal constant MOD_EXP_FAILURE_SELECTOR = 0xf894a7bc;
    bytes4 internal constant PAIRING_PREAMBLE_FAILURE_SELECTOR = 0x58b33075;
    bytes4 internal constant PROOF_FAILURE_SELECTOR = 0x0711fcec;

    bytes4 internal constant ERR_S = 0xf7b44074;

    error ERR(bytes32, bytes32, bytes32);

    error PUBLIC_INPUT_COUNT_INVALID(uint256 expected, uint256 actual);
    error RECURSIVE_PROOF_INVALID_BN128_G1_POINT();
    error PUBLIC_INPUT_INVALID_BN128_G1_POINT();
    error PUBLIC_INPUT_GE_P();
    error MOD_EXP_FAILURE();
    error PAIRING_PREAMBLE_FAILURE();
    error PROOF_FAILURE();

    /**
     * @notice Get the verification key hash
     * @dev To be implemented in the child contract
     * @return hash The verification key hash
     */
    function getVerificationKeyHash() public pure virtual returns (bytes32);

    /**
     * @notice Load the verification key into memory
     * @dev To be implemented in the child contract
     * @param _vk - The memory location to store the verification key
     */
    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure virtual;

    /**
     * @notice Verify a Standard Plonk proof
     * @param _proof - The serialized proof
     * @param _publicInputs - An array of the public inputs
     * @return True if proof is valid, reverts otherwise
     */
    function verify(bytes calldata _proof, bytes32[] calldata _publicInputs) external returns (bool) {
        loadVerificationKey(N_LOC, OMEGA_INVERSE_LOC);
        // @note - The order of the checks in this implementation differs from the paper to save gas.
        // @todo - Add the ordering in here.

        uint256 requiredPublicInputCount;
        assembly {
            requiredPublicInputCount := mload(NUM_INPUTS_LOC)
        }
        if (requiredPublicInputCount != _publicInputs.length) {
            revert PUBLIC_INPUT_COUNT_INVALID(requiredPublicInputCount, _publicInputs.length);
        }

        assembly {
            let q := 21888242871839275222246405745257275088696311157297823662689037894645226208583 // EC group order
            let p := 21888242871839275222246405745257275088548364400416034343698204186575808495617 // Prime field order

            /**
             * LOAD PROOF INTO MEMORY
             */
            {
                // calldataload(0x04) is the offset of the proof = 0x40
                // We add 0x24 to skip the selector + the length of the proof
                let data_ptr := add(calldataload(0x04), 0x24)

                // @follow-up Should we use the same naming as in the paper to reduce confusion? Seems like a no-brainer.
                // @note The proof is stored differently than the paper with the following order:
                // [a]1, [b]1, [c]1, [z]1, [tlo]1, [tmid]1, [thi]1,  ̄a,  ̄b,  ̄c,  ̄sσ1,  ̄sσ2,  ̄zω,  [Wz]1, [Wzω]1,
                mstore(W1_X_LOC, mod(calldataload(add(data_ptr, 0x20)), q)) // [a]1
                mstore(W1_Y_LOC, mod(calldataload(data_ptr), q))
                mstore(W2_X_LOC, mod(calldataload(add(data_ptr, 0x60)), q)) // [b]1
                mstore(W2_Y_LOC, mod(calldataload(add(data_ptr, 0x40)), q))
                mstore(W3_X_LOC, mod(calldataload(add(data_ptr, 0xa0)), q)) // [c]1
                mstore(W3_Y_LOC, mod(calldataload(add(data_ptr, 0x80)), q))
                mstore(Z_X_LOC, mod(calldataload(add(data_ptr, 0xe0)), q)) // [z]1
                mstore(Z_Y_LOC, mod(calldataload(add(data_ptr, 0xc0)), q))
                mstore(T1_X_LOC, mod(calldataload(add(data_ptr, 0x120)), q)) // [tlo]1
                mstore(T1_Y_LOC, mod(calldataload(add(data_ptr, 0x100)), q))
                mstore(T2_X_LOC, mod(calldataload(add(data_ptr, 0x160)), q)) // [tmid]1
                mstore(T2_Y_LOC, mod(calldataload(add(data_ptr, 0x140)), q))
                mstore(T3_X_LOC, mod(calldataload(add(data_ptr, 0x1a0)), q)) // [thi]1
                mstore(T3_Y_LOC, mod(calldataload(add(data_ptr, 0x180)), q))
                mstore(W1_EVAL_LOC, mod(calldataload(add(data_ptr, 0x1c0)), p)) //  ̄a
                mstore(W2_EVAL_LOC, mod(calldataload(add(data_ptr, 0x1e0)), p)) //  ̄b
                mstore(W3_EVAL_LOC, mod(calldataload(add(data_ptr, 0x200)), p)) //  ̄c
                mstore(SIGMA1_EVAL_LOC, mod(calldataload(add(data_ptr, 0x220)), p)) //   ̄sσ1
                mstore(SIGMA2_EVAL_LOC, mod(calldataload(add(data_ptr, 0x240)), p)) //  ̄sσ2
                mstore(Z_OMEGA_EVAL_LOC, mod(calldataload(add(data_ptr, 0x260)), p)) //  ̄zω
                mstore(PI_Z_X_LOC, mod(calldataload(add(data_ptr, 0x2a0)), q)) // [Wz]1
                mstore(PI_Z_Y_LOC, mod(calldataload(add(data_ptr, 0x280)), q))
                mstore(PI_Z_OMEGA_X_LOC, mod(calldataload(add(data_ptr, 0x2e0)), q)) // [Wzω]1
                mstore(PI_Z_OMEGA_Y_LOC, mod(calldataload(add(data_ptr, 0x2c0)), q))
            }

            /**
             * LOAD RECURSIVE PROOF INTO MEMORY
             */
            {
                if mload(CONTAINS_RECURSIVE_PROOF_LOC) {
                    let public_inputs_ptr := add(calldataload(0x24), 0x24)
                    let index_counter := add(shl(5, mload(RECURSIVE_PROOF_PUBLIC_INPUT_INDICES_LOC)), public_inputs_ptr)

                    // Loads the recursive proof into memory.
                    // Each coordinate consist of 4 chunks of 68 bits, but take up 4 words in the proof.
                    // While this might "waste" a bit of space on the contract side, it improves circuit efficiency

                    let x0 := calldataload(index_counter)
                    x0 := add(x0, shl(68, calldataload(add(index_counter, 0x20))))
                    x0 := add(x0, shl(136, calldataload(add(index_counter, 0x40))))
                    x0 := add(x0, shl(204, calldataload(add(index_counter, 0x60))))
                    let y0 := calldataload(add(index_counter, 0x80))
                    y0 := add(y0, shl(68, calldataload(add(index_counter, 0xa0))))
                    y0 := add(y0, shl(136, calldataload(add(index_counter, 0xc0))))
                    y0 := add(y0, shl(204, calldataload(add(index_counter, 0xe0))))
                    let x1 := calldataload(add(index_counter, 0x100))
                    x1 := add(x1, shl(68, calldataload(add(index_counter, 0x120))))
                    x1 := add(x1, shl(136, calldataload(add(index_counter, 0x140))))
                    x1 := add(x1, shl(204, calldataload(add(index_counter, 0x160))))
                    let y1 := calldataload(add(index_counter, 0x180))
                    y1 := add(y1, shl(68, calldataload(add(index_counter, 0x1a0))))
                    y1 := add(y1, shl(136, calldataload(add(index_counter, 0x1c0))))
                    y1 := add(y1, shl(204, calldataload(add(index_counter, 0x1e0))))
                    // Store the recursive proof coordinates in memory
                    mstore(RECURSIVE_P1_X_LOC, x0)
                    mstore(RECURSIVE_P1_Y_LOC, y0)
                    mstore(RECURSIVE_P2_X_LOC, x1)
                    mstore(RECURSIVE_P2_Y_LOC, y1)

                    // validate these are valid bn128 G1 points
                    if iszero(and(and(lt(x0, q), lt(x1, q)), and(lt(y0, q), lt(y1, q)))) {
                        mstore(0x00, RECURSIVE_PROOF_INVALID_BN128_G1_POINT_SELECTOR)
                        revert(0x00, 0x04)
                    }
                }
            }

            /**
             * STEP 4. Generate challenges
             */
            {
                /**
                 * Generate initial challenge
                 */
                mstore(0x00, shl(224, mload(N_LOC)))
                mstore(0x04, shl(224, mload(NUM_INPUTS_LOC)))
                let challenge := keccak256(0x00, 0x08)
                mstore(PUBLIC_INPUTS_HASH_LOCATION, challenge)

                /**
                 * Generate beta challenge
                 */
                // The public input location is stored at 0x24, we then add 0x24 to skip selector and the length of public inputs
                let public_inputs_start := add(calldataload(0x24), 0x24)
                // copy the public inputs over
                let public_input_size := mul(mload(NUM_INPUTS_LOC), 0x20)
                calldatacopy(add(PUBLIC_INPUTS_HASH_LOCATION, 0x20), public_inputs_start, public_input_size)
                // copy W1, W2, W3 into challenge. Each point is 0x40 bytes, so load 0xc0 = 3 * 0x40 bytes
                let proof_ptr := add(calldataload(0x04), 0x24)
                calldatacopy(add(add(PUBLIC_INPUTS_HASH_LOCATION, 0x20), public_input_size), proof_ptr, 0xc0)

                // Challenge is the old challenge + public inputs + W1, W2, W3 (0x20 + public_input_size + 0xc0)
                let challenge_bytes_size := add(0x20, add(public_input_size, 0xc0))
                // β = H(initial_challenge, public_inputs, W1, W2, W3)
                challenge := keccak256(PUBLIC_INPUTS_HASH_LOCATION, challenge_bytes_size)
                mstore(C_BETA_LOC, mod(challenge, p))

                /**
                 * Generate gamma challenge
                 */
                mstore(0x00, challenge)
                mstore8(0x20, 0x01)
                // γ = H(β, 0x01)
                challenge := keccak256(0x00, 0x21)
                mstore(C_GAMMA_LOC, mod(challenge, p))

                /**
                 * Generate alpha challenge
                 */
                mstore(0x00, challenge)
                mstore(0x20, mload(Z_Y_LOC))
                mstore(0x40, mload(Z_X_LOC))
                // α = H(γ, Z)
                challenge := keccak256(0x00, 0x60)
                mstore(C_ALPHA_LOC, mod(challenge, p))

                /**
                 * Generate zeta challenge
                 * Using mstore instead of calldatacopy to read the ones where mod have been applied
                 */
                mstore(0x00, challenge)
                mstore(0x20, mload(T1_Y_LOC))
                mstore(0x40, mload(T1_X_LOC))
                mstore(0x60, mload(T2_Y_LOC))
                mstore(0x80, mload(T2_X_LOC))
                mstore(0xa0, mload(T3_Y_LOC))
                mstore(0xc0, mload(T3_X_LOC))
                // z = H(α, T1, T2, T3)
                challenge := keccak256(0x00, 0xe0)
                mstore(C_ZETA_LOC, mod(challenge, p))

                /**
                 * GENERATE NU CHALLENGES (evaluation challenge)
                 */
                mstore(0x00, challenge)
                // Skip over W1, W2, W3, Z, T1, T2, T3
                calldatacopy(0x20, add(proof_ptr, 0x1c0), 0xc0) // 6 * 0x20 = 0xc0
                // v = H(z, W1_EVAL, W2_EVAL, W3_EVAL, SIGMA1_EVAL, SIGMA2_EVAL, Z_OMEGA_EVAL)
                challenge := keccak256(0x00, 0xe0) // hash length = 0xe0 (0x20 + num field elements), we include the previous challenge in the hash

                mstore(C_V0_LOC, mod(challenge, p))

                mstore(0x00, challenge)
                mstore8(0x20, 0x01)
                mstore(C_V1_LOC, mod(keccak256(0x00, 0x21), p))

                mstore8(0x20, 0x02)
                mstore(C_V2_LOC, mod(keccak256(0x00, 0x21), p))

                mstore8(0x20, 0x03)
                mstore(C_V3_LOC, mod(keccak256(0x00, 0x21), p))

                mstore8(0x20, 0x04)
                mstore(C_V4_LOC, mod(keccak256(0x00, 0x21), p))

                mstore8(0x20, 0x05)
                challenge := keccak256(0x00, 0x21)
                mstore(C_V5_LOC, mod(challenge, p))

                /**
                 * GENERATE SEPARATOR CHALLENGE
                 * Using mstore instead of calldatacopy to read the ones where mod have been applied
                 */
                mstore(0x00, challenge)
                mstore(0x20, mload(PI_Z_Y_LOC))
                mstore(0x40, mload(PI_Z_X_LOC))
                mstore(0x60, mload(PI_Z_OMEGA_Y_LOC))
                mstore(0x80, mload(PI_Z_OMEGA_X_LOC))
                // u = H(C_V5, PI_Z, PI_Z_OMEGA)
                mstore(C_U_LOC, mod(keccak256(0x00, 0xa0), p))
            }

            /**
             * EVALUATE FIELD OPERATIONS
             */

            /**
             * COMPUTE PUBLIC INPUT DELTA
             * In the permutation argument, we will be generating some "residue" from the public inputs. This will impact `r_0`
             * In the Plonk paper (https://eprint.iacr.org/2019/953.pdf) we take this into account by using a `PI` polynomial.
             * However, computing the `PI` polynomial require us to compute `L_1(zeta),...,L_m(zeta)` for `m` public inputs.
             * This could be expensive, and we can actually compute the `L_m(zeta)` only, and then use a `DELTA_PUBLIC_INPUTS`
             * get us to the same result.
             * Let β and γ be challenges, and wᵢ the i'th public input, :
             * Let σ be the permutation and σ' be when applying σ and then mapping it into H' (H′ = H ∪ (k1 H) ∪ (k2 H)).
             * For the public inputs, let σ'(i) = ζᵢ where ζᵢ are distinct elements disjoint from [n].
             * These can be disjoined from [n] by defining σ'(i) = ζ * ωⁱ
             * Then we can define ΔPI (`DELTA_PUBLIC_INPUTS`) as:
             * ΔPI = ∏ᵢ∈ℓ(wᵢ + β σ(i) + γ) / ∏ᵢ∈ℓ(wᵢ + β σ'(i) + γ)
             * @follow-up The values for sigma and sigma' need some elaboration. I don't understand where they come from.
             * Or at least not why they are like they are here.
             * Below we compute the numerator and denominator separately.
             * Why do we have this here but not in the plonk paper? Plonk paper is using a `PI` polynomial to handle this.
             * The PI polynomial requires the
             * @todo Make clearer what this is doing and why such that readers get the reasoning behind it.
             * @follow-up Write out the product up here
             * @follow-up Why is this not part of the plonk paper, but only the extra github document?
             * Helping figuring out the "offset" that is made to the permutation argument due to the public inputs
             * All the wires are cancelled, so we would sit back with just the residue from the public inputs.
             */
            {
                let beta := mload(C_BETA_LOC) // β
                let gamma := mload(C_GAMMA_LOC) // γ
                let work_root := mload(OMEGA_LOC) // ω
                let numerator_value := 1
                let denominator_value := 1

                let p_clone := p // move p to the front of the stack
                let valid_inputs := true

                // Load the starting point of the public inputs (jump over the selector and the length of public inputs [0x24])
                let public_inputs_ptr := add(calldataload(0x24), 0x24)

                // endpoint_ptr = public_inputs_ptr + num_inputs * 0x20. // every public input is 0x20 bytes
                let endpoint_ptr := add(public_inputs_ptr, mul(mload(NUM_INPUTS_LOC), 0x20))

                // root_1 = β * 0x05
                let root_1 := mulmod(beta, 0x05, p_clone) // k1.β
                // root_2 = β * 0x0c
                let root_2 := mulmod(beta, 0x0c, p_clone) // k2.β
                // @note 0x05 + 0x07 == 0x0c == external coset generator

                for {} lt(public_inputs_ptr, endpoint_ptr) { public_inputs_ptr := add(public_inputs_ptr, 0x20) } {
                    // Load the next public input
                    let input := calldataload(public_inputs_ptr)

                    // check that wᵢ < p (delays check to the end of the loop for gas savings for success case)
                    valid_inputs := and(valid_inputs, lt(input, p_clone))

                    // t0 = wᵢ + γ
                    let t := addmod(input, gamma, p_clone)

                    // numerator_value *= (β.σ(i) + wᵢ + γ)
                    // numerator_value *= (β.k1.ωⁱ + wᵢ + γ)
                    numerator_value := mulmod(numerator_value, add(root_1, t), p_clone)

                    // denominator_value *= (β.σ'(i) + wᵢ + γ)
                    // denominator_value *= (β.k2.ωⁱ + wᵢ + γ)
                    denominator_value := mulmod(denominator_value, add(root_2, t), p_clone)

                    // Multiply the roots by ω  to "move to next element" in the cosets.
                    root_1 := mulmod(root_1, work_root, p_clone)
                    root_2 := mulmod(root_2, work_root, p_clone)
                }

                // Revert if not all public inputs are field elements (i.e. < p)
                if iszero(valid_inputs) {
                    mstore(0x00, PUBLIC_INPUT_GE_P_SELECTOR)
                    revert(0x00, 0x04)
                }

                mstore(DELTA_NUMERATOR_LOC, numerator_value)
                mstore(DELTA_DENOMINATOR_LOC, denominator_value)
            }

            /**
             * STEP 5 and 6: Compute lagrange- and vanishing poly fractions
             */
            {
                let zeta := mload(C_ZETA_LOC)

                // compute zeta^n, where n is a power of 2
                let vanishing_numerator := zeta
                {
                    // pow_small
                    let exponent := mload(N_LOC)
                    let count := 1
                    for {} lt(count, exponent) { count := add(count, count) } {
                        vanishing_numerator := mulmod(vanishing_numerator, vanishing_numerator, p)
                    }
                }
                mstore(ZETA_POW_N_LOC, vanishing_numerator)
                vanishing_numerator := addmod(vanishing_numerator, sub(p, 1), p)

                let accumulating_root := mload(OMEGA_INVERSE_LOC)
                let work_root := sub(p, accumulating_root)
                let domain_inverse := mload(DOMAIN_INVERSE_LOC)

                let vanishing_denominator := addmod(zeta, work_root, p)
                work_root := mulmod(work_root, accumulating_root, p)
                vanishing_denominator := mulmod(vanishing_denominator, addmod(zeta, work_root, p), p)
                work_root := mulmod(work_root, accumulating_root, p)
                vanishing_denominator := mulmod(vanishing_denominator, addmod(zeta, work_root, p), p)
                vanishing_denominator :=
                    mulmod(vanishing_denominator, addmod(zeta, mulmod(work_root, accumulating_root, p), p), p)

                work_root := mload(OMEGA_LOC)

                let lagrange_numerator := mulmod(vanishing_numerator, domain_inverse, p)
                let l_start_denominator := addmod(zeta, sub(p, 1), p)

                // l_end_denominator term contains a term \omega^5 to cut out 5 roots of unity from vanishing poly
                accumulating_root := mulmod(work_root, work_root, p)

                let l_end_denominator :=
                    addmod(
                        mulmod(mulmod(mulmod(accumulating_root, accumulating_root, p), work_root, p), zeta, p), sub(p, 1), p
                    )

                /**
                 * Compute inversions using Montgomery's batch inversion trick
                 */
                let accumulator := mload(DELTA_DENOMINATOR_LOC)
                let t0 := accumulator
                accumulator := mulmod(accumulator, vanishing_denominator, p)
                let t1 := accumulator
                accumulator := mulmod(accumulator, l_start_denominator, p)
                let t2 := accumulator
                {
                    mstore(0, 0x20)
                    mstore(0x20, 0x20)
                    mstore(0x40, 0x20)
                    mstore(0x60, mulmod(accumulator, l_end_denominator, p))
                    mstore(0x80, sub(p, 2))
                    mstore(0xa0, p)
                    if iszero(staticcall(gas(), 0x05, 0x00, 0xc0, 0x00, 0x20)) {
                        mstore(0x0, MOD_EXP_FAILURE_SELECTOR)
                        revert(0x00, 0x04)
                    }
                    accumulator := mload(0x00)
                }

                t2 := mulmod(accumulator, t2, p)
                accumulator := mulmod(accumulator, l_end_denominator, p)

                t1 := mulmod(accumulator, t1, p)
                accumulator := mulmod(accumulator, l_start_denominator, p)

                t0 := mulmod(accumulator, t0, p)
                accumulator := mulmod(accumulator, vanishing_denominator, p)

                accumulator := mulmod(mulmod(accumulator, accumulator, p), mload(DELTA_DENOMINATOR_LOC), p)

                // Compute the values where we needed inverses
                // public_input_delta = delta_numerator * accumulator
                mstore(PUBLIC_INPUT_DELTA_LOC, mulmod(mload(DELTA_NUMERATOR_LOC), accumulator, p))
                // z_h = vanishing_numerator * t_0
                mstore(ZERO_POLY_LOC, mulmod(vanishing_numerator, t0, p))
                // l_start = lagrange_numerator * t_1
                mstore(L_START_LOC, mulmod(lagrange_numerator, t1, p))
                // l_end = lagrange_numerator * t_2
                mstore(L_END_LOC, mulmod(lagrange_numerator, t2, p))
            }

            /**
             * STEP 8: COMPUTE CONSTANT TERM (r_0) OF LINEARISATION POLYNOMIAL
             */
            {
                let alpha := mload(C_ALPHA_LOC)
                let beta := mload(C_BETA_LOC)
                let gamma := mload(C_GAMMA_LOC)

                // r_0_0 = (ā + βs̄_σ1 + γ)
                let r_0_0 := add(add(mload(W1_EVAL_LOC), mulmod(beta, mload(SIGMA1_EVAL_LOC), p)), gamma)
                // r_0_1 = (b̄ + βs̄_σ2 + γ)
                let r_0_1 := add(add(mload(W2_EVAL_LOC), mulmod(beta, mload(SIGMA2_EVAL_LOC), p)), gamma)
                // r_0_2 = (c̄ + γ)
                let r_0_2 := add(mload(W3_EVAL_LOC), gamma)
                // r_0_s = (ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)(c̄ + γ)z̄_ω
                let r_0_s := mulmod(mulmod(mulmod(r_0_0, r_0_1, p), r_0_2, p), mload(Z_OMEGA_EVAL_LOC), p)

                // α^2 = α * α
                let alpha_sqr := mulmod(alpha, alpha, p)
                mstore(C_ALPHA_SQR_LOC, alpha_sqr)
                // α^4 = α^2 * α^2 [stored now for later use]
                mstore(C_ARITHMETIC_ALPHA_LOC, mulmod(alpha_sqr, alpha_sqr, p))

                // l_1_a2 = L_1 * α^2
                let l_1_a2 := mulmod(mload(L_START_LOC), alpha_sqr, p)
                // l_n_a = L_n * α
                let l_n_a := mulmod(mload(L_END_LOC), alpha, p)
                // t_0 = z̄_ω - ∆PI
                let t_0 := addmod(mload(Z_OMEGA_EVAL_LOC), sub(p, mload(PUBLIC_INPUT_DELTA_LOC)), p)

                // @note that our r_0 looks different from the paper.
                // This related to the public input delta that we mentioned earlier.
                // So we are replacing PI with (z̄_ω - ∆PI) * L_n * α^2.
                // @follow-up Elaborate on this replacement
                // @note that our r_0 differs on the power of alpha from the paper. The alpha is a challenge
                // so having a different challenge is fine, as long as both verifier and prover use the same.

                // r_0 = α * (t_0 * l_n_a - l_1_a2 - r_0_s)
                // r_0 = α * ((z_ω - ∆PI) * L_n * α - (L_1 * α^2) - (ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)(c̄ + γ)z̄_ω))
                // r_0 = (z_ω - ∆PI) * L_n * α^2 - L_1 * α^3 - α(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)(c̄ + γ)z̄_ω)

                mstore(
                    R_ZERO_EVAL_LOC,
                    mulmod(addmod(mulmod(t_0, l_n_a, p), addmod(sub(p, l_1_a2), sub(p, r_0_s), p), p), alpha, p)
                )
            }

            /**
             * COMPUTE LINEARISED OPENING TERMS
             */
            {
                // /**
                //  * COMPUTE GRAND PRODUCT OPENING GROUP ELEMENT
                //  */
                let beta := mload(C_BETA_LOC)
                let zeta := mload(C_ZETA_LOC)
                let gamma := mload(C_GAMMA_LOC)
                let alpha := mload(C_ALPHA_LOC)
                let beta_zeta := mulmod(beta, zeta, p)

                let witness_term := addmod(mload(W1_EVAL_LOC), gamma, p)
                let partial_grand_product := addmod(beta_zeta, witness_term, p)
                let sigma_multiplier := addmod(mulmod(mload(SIGMA1_EVAL_LOC), beta, p), witness_term, p)
                witness_term := addmod(mload(W2_EVAL_LOC), gamma, p)
                sigma_multiplier :=
                    mulmod(sigma_multiplier, addmod(mulmod(mload(SIGMA2_EVAL_LOC), beta, p), witness_term, p), p)
                let k1_beta_zeta := mulmod(0x05, beta_zeta, p)
                //  partial_grand_product = mulmod( mulmod( partial_grand_product, w2 + k1.beta.zeta + gamma , p), k2.beta.zeta + gamma + w3, p)
                partial_grand_product :=
                    mulmod(
                        mulmod(
                            partial_grand_product,
                            addmod(k1_beta_zeta, witness_term, p), // w2 + k1.beta.zeta + gamma
                            p
                        ),
                        addmod(addmod(add(k1_beta_zeta, beta_zeta), gamma, p), mload(W3_EVAL_LOC), p), // k2.beta.zeta + gamma + w3 where k2 = k1+1
                        p
                    )

                let linear_challenge := alpha // Owing to the simplified Plonk, nu =1, linear_challenge = nu * alpha = alpha

                mstore(0x00, mload(SIGMA3_X_LOC))
                mstore(0x20, mload(SIGMA3_Y_LOC))
                mstore(
                    0x40,
                    mulmod(
                        mulmod(sub(p, mulmod(sigma_multiplier, mload(Z_OMEGA_EVAL_LOC), p)), beta, p),
                        linear_challenge,
                        p
                    )
                )

                // Validate Z
                let success
                {
                    let x := mload(Z_X_LOC)
                    let y := mload(Z_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q))
                    mstore(0x60, x)
                    mstore(0x80, y)
                }
                mstore(
                    0xa0,
                    addmod(
                        mulmod(
                            addmod(partial_grand_product, mulmod(mload(L_START_LOC), mload(C_ALPHA_SQR_LOC), p), p),
                            linear_challenge,
                            p
                        ),
                        mload(C_U_LOC),
                        p
                    )
                )
                // 0x00 = mload(SIGMA3_X_LOC),
                // 0x20 = mload(SIGMA3_Y_LOC),
                // 0x40 = −(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)αβz̄_ω,
                // 0x60 = mload(Z_X_LOC),
                // 0x80 = mload(Z_Y_LOC),
                // 0xa0 = (ā + βz + γ)( b̄ + βk_1 z + γ)(c̄ + βk_2 z + γ)α + L_1(z)α^3 + u
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            // Why ACCUMULATOR_X_LOC := ACCUMULATOR_X_LOC + ACCUMULATOR2_X_LOC? Inner parenthesis is executed before?
                            and(
                                staticcall(gas(), 7, 0x60, 0x60, ACCUMULATOR_X_LOC, 0x40),
                                // [ACCUMULATOR_X_LOC, ACCUMULATOR_X_LOC + 0x40) = ((ā + βz + γ)( b̄ + βk_1 z + γ)(c̄ + βk_2 z + γ)α + L_1(z)α^3 + u)*[z]_1
                                staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                            )
                        )
                    )
                // [ACCUMULATOR2_X_LOC, ACCUMULATOR2_X_LOC + 0x40) = −(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)αβz̄_ω * [s_σ3]_1

                mstore(GRAND_PRODUCT_SUCCESS_FLAG, success)
            }

            /**
             * COMPUTE ARITHMETIC SELECTOR OPENING GROUP ELEMENT
             * @follow-up Elaborate on naming to easily match with the paper (part of step 9?)
             */
            {
                let linear_challenge := mload(C_ARITHMETIC_ALPHA_LOC) // Owing to simplified Plonk, nu = 1,  linear_challenge = C_ARITHMETIC_ALPHA (= alpha^4)

                let t1 := mulmod(mload(W1_EVAL_LOC), linear_challenge, p) // reuse this for QM scalar multiplier
                // Q1
                mstore(0x00, mload(Q1_X_LOC))
                mstore(0x20, mload(Q1_Y_LOC))
                mstore(0x40, t1)

                // add Q1 scalar mul into grand product scalar mul
                // Observe that ACCUMULATOR_X_LOC and ACCUMULATOR2_X_LOC are 0x40 bytes apart. Below, ACCUMULATOR2_X_LOC
                // captures new terms Q1, Q2, and so on and they get accumulated to ACCUMULATOR_X_LOC
                let success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        // [ACCUMULATOR_X_LOC, ACCUMULATOR_X_LOC + 0x40) = ((ā + βz + γ)( b̄ + βk_1 z + γ)(c̄ + βk_2 z + γ)α + L_1(z)α^3 + u)*[z]_1 −(ā + βs̄_σ1 + γ)( b̄ + βs̄_σ2 + γ)αβz̄_ω * [s_σ3]_1
                        staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                    )
                // [ACCUMULATOR2_X_LOC, ACCUMULATOR2_X_LOC + 0x40) = ā * [q_L]_1

                // Q2
                mstore(0x00, mload(Q2_X_LOC))
                mstore(0x20, mload(Q2_Y_LOC))
                mstore(0x40, mulmod(mload(W2_EVAL_LOC), linear_challenge, p))
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                        )
                    )

                // Q3
                mstore(0x00, mload(Q3_X_LOC))
                mstore(0x20, mload(Q3_Y_LOC))
                mstore(0x40, mulmod(mload(W3_EVAL_LOC), linear_challenge, p))
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                        )
                    )

                // QM
                mstore(0x00, mload(QM_X_LOC))
                mstore(0x20, mload(QM_Y_LOC))
                mstore(0x40, mulmod(t1, mload(W2_EVAL_LOC), p))
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40), // ecAdd
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40) // ecMul
                        )
                    )

                // QC
                mstore(0x00, mload(QC_X_LOC))
                mstore(0x20, mload(QC_Y_LOC))
                mstore(0x40, linear_challenge)
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                        )
                    )

                mstore(ARITHMETIC_TERM_SUCCESS_FLAG, success)
            }

            /**
             * COMPUTE BATCH OPENING COMMITMENT
             */
            {
                // previous scalar_multiplier = 1, z^n, z^2n
                // scalar_multiplier owing to the simplified Plonk = 1 * -Z_H(z), z^n * -Z_H(z), z^2n * -Z_H(z)
                // VALIDATE T1
                let success
                {
                    let x := mload(T1_X_LOC)
                    let y := mload(T1_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q))
                    mstore(0x00, x)
                    mstore(0x20, y)
                    mstore(0x40, sub(p, mload(ZERO_POLY_LOC)))
                    // mstore(ACCUMULATOR2_X_LOC, x)
                    // mstore(ACCUMULATOR2_Y_LOC, y)
                }
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                        )
                    )

                // VALIDATE T2
                let scalar_multiplier := mload(ZETA_POW_N_LOC)
                {
                    let x := mload(T2_X_LOC)
                    let y := mload(T2_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                mstore(0x40, mulmod(scalar_multiplier, sub(p, mload(ZERO_POLY_LOC)), p))

                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                // VALIDATE T3
                {
                    let x := mload(T3_X_LOC)
                    let y := mload(T3_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                mstore(0x40, mulmod(scalar_multiplier, mulmod(scalar_multiplier, sub(p, mload(ZERO_POLY_LOC)), p), p))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                // VALIDATE W1
                {
                    let x := mload(W1_X_LOC)
                    let y := mload(W1_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                mstore(0x40, mload(C_V0_LOC))

                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                // VALIDATE W2
                {
                    let x := mload(W2_X_LOC)
                    let y := mload(W2_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                mstore(0x40, mload(C_V1_LOC))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                // VALIDATE W3
                {
                    let x := mload(W3_X_LOC)
                    let y := mload(W3_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                mstore(0x40, mload(C_V2_LOC))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                mstore(0x00, mload(SIGMA1_X_LOC))
                mstore(0x20, mload(SIGMA1_Y_LOC))
                mstore(0x40, mload(C_V3_LOC))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                mstore(0x00, mload(SIGMA2_X_LOC))
                mstore(0x20, mload(SIGMA2_Y_LOC))
                mstore(0x40, mload(C_V4_LOC))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                mstore(BATCH_OPENING_SUCCESS_FLAG, success)
            }

            /**
             * Step 11. COMPUTE BATCH EVALUATION SCALAR MULTIPLIER
             */
            {
                let v0w1 := mulmod(mload(C_V0_LOC), mload(W1_EVAL_LOC), p)
                let v1w2 := mulmod(mload(C_V1_LOC), mload(W2_EVAL_LOC), p)
                let v2w3 := mulmod(mload(C_V2_LOC), mload(W3_EVAL_LOC), p)
                let v3sig1 := mulmod(mload(C_V3_LOC), mload(SIGMA1_EVAL_LOC), p)
                let v4sig2 := mulmod(mload(C_V4_LOC), mload(SIGMA2_EVAL_LOC), p)
                let r0neg := sub(p, mload(R_ZERO_EVAL_LOC)) // Change owing to the simplified Plonk @follow-up
                let uzomega := mulmod(mload(C_U_LOC), mload(Z_OMEGA_EVAL_LOC), p)

                // -E = (p - (−r0 + v ̄a + v2 ̄b + v3 ̄c +v4 ̄sσ1 + v5 ̄sσ2 + u ̄zω)) * [1]1

                mstore(0x00, 0x01) // [1].x
                mstore(0x20, 0x02) // [1].y
                // Yul stack optimizer doing some work here...
                mstore(
                    0x40,
                    sub(
                        p,
                        addmod(
                            uzomega,
                            addmod(
                                r0neg, addmod(v4sig2, addmod(v3sig1, addmod(v2w3, addmod(v1w2, v0w1, p), p), p), p), p
                            ),
                            p
                        )
                    )
                )

                let success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                        staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                    )
                mstore(OPENING_COMMITMENT_SUCCESS_FLAG, success)
            }

            /**
             * Step 12: PERFORM PAIRING PREAMBLE
             */
            {
                let u := mload(C_U_LOC)
                let zeta := mload(C_ZETA_LOC)
                let success
                // VALIDATE PI_Z
                {
                    let x := mload(PI_Z_X_LOC)
                    let y := mload(PI_Z_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                // compute zeta.[PI_Z] and add into accumulator
                mstore(0x40, zeta)
                success :=
                    and(
                        success,
                        and(
                            staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, ACCUMULATOR_X_LOC, 0x40),
                            staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40)
                        )
                    )

                // VALIDATE PI_Z_OMEGA
                {
                    let x := mload(PI_Z_OMEGA_X_LOC)
                    let y := mload(PI_Z_OMEGA_Y_LOC)
                    let xx := mulmod(x, x, q)
                    success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                    mstore(0x00, x)
                    mstore(0x20, y)
                }
                // compute u.zeta.omega.[PI_Z_OMEGA] and add into accumulator
                mstore(0x40, mulmod(mulmod(u, zeta, p), mload(OMEGA_LOC), p))
                success :=
                    and(
                        staticcall(gas(), 6, ACCUMULATOR_X_LOC, 0x80, PAIRING_RHS_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x00, 0x60, ACCUMULATOR2_X_LOC, 0x40))
                    )

                mstore(0x00, mload(PI_Z_X_LOC))
                mstore(0x20, mload(PI_Z_Y_LOC))
                mstore(0x40, mload(PI_Z_OMEGA_X_LOC))
                mstore(0x60, mload(PI_Z_OMEGA_Y_LOC))
                mstore(0x80, u)
                success :=
                    and(
                        staticcall(gas(), 6, 0x00, 0x80, PAIRING_LHS_X_LOC, 0x40),
                        and(success, staticcall(gas(), 7, 0x40, 0x60, 0x40, 0x40))
                    )
                // negate lhs y-coordinate
                mstore(PAIRING_LHS_Y_LOC, sub(q, mload(PAIRING_LHS_Y_LOC)))

                if mload(CONTAINS_RECURSIVE_PROOF_LOC) {
                    // VALIDATE RECURSIVE P1
                    {
                        let x := mload(RECURSIVE_P1_X_LOC)
                        let y := mload(RECURSIVE_P1_Y_LOC)
                        let xx := mulmod(x, x, q)
                        success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                        mstore(0x00, x)
                        mstore(0x20, y)
                    }

                    // compute u.u.[recursive_p1] and write into 0x60
                    mstore(0x40, mulmod(u, u, p))
                    success := and(success, staticcall(gas(), 7, 0x00, 0x60, 0x60, 0x40))
                    // VALIDATE RECURSIVE P2
                    {
                        let x := mload(RECURSIVE_P2_X_LOC)
                        let y := mload(RECURSIVE_P2_Y_LOC)
                        let xx := mulmod(x, x, q)
                        success := and(success, eq(mulmod(y, y, q), addmod(mulmod(x, xx, q), 3, q)))
                        mstore(0x00, x)
                        mstore(0x20, y)
                    }
                    // compute u.u.[recursive_p2] and write into 0x00
                    // 0x40 still contains u*u
                    success := and(success, staticcall(gas(), 7, 0x00, 0x60, 0x00, 0x40))

                    // compute u.u.[recursiveP1] + rhs and write into rhs
                    mstore(0xa0, mload(PAIRING_RHS_X_LOC))
                    mstore(0xc0, mload(PAIRING_RHS_Y_LOC))
                    success := and(success, staticcall(gas(), 6, 0x60, 0x80, PAIRING_RHS_X_LOC, 0x40))

                    // compute u.u.[recursiveP2] + lhs and write into lhs
                    mstore(0x40, mload(PAIRING_LHS_X_LOC))
                    mstore(0x60, mload(PAIRING_LHS_Y_LOC))
                    success := and(success, staticcall(gas(), 6, 0x00, 0x80, PAIRING_LHS_X_LOC, 0x40))
                }

                if iszero(success) {
                    mstore(0x0, PAIRING_PREAMBLE_FAILURE_SELECTOR)
                    revert(0x00, 0x04)
                }
                mstore(PAIRING_PREAMBLE_SUCCESS_FLAG, success)
            }

            /**
             * PERFORM PAIRING
             */
            {
                // rhs paired with [1]_2
                // lhs paired with [x]_2

                mstore(0x00, mload(PAIRING_RHS_X_LOC))
                mstore(0x20, mload(PAIRING_RHS_Y_LOC))
                mstore(0x40, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2) // this is [1]_2
                mstore(0x60, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
                mstore(0x80, 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
                mstore(0xa0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)

                mstore(0xc0, mload(PAIRING_LHS_X_LOC))
                mstore(0xe0, mload(PAIRING_LHS_Y_LOC))
                mstore(0x100, mload(G2X_X0_LOC))
                mstore(0x120, mload(G2X_X1_LOC))
                mstore(0x140, mload(G2X_Y0_LOC))
                mstore(0x160, mload(G2X_Y1_LOC))

                let success := staticcall(gas(), 8, 0x00, 0x180, 0x00, 0x20)
                mstore(PAIRING_SUCCESS_FLAG, success)
                mstore(RESULT_FLAG, mload(0x00))
            }
            if iszero(
                and(
                    and(
                        and(
                            and(
                                and(
                                    and(mload(PAIRING_SUCCESS_FLAG), mload(RESULT_FLAG)),
                                    mload(PAIRING_PREAMBLE_SUCCESS_FLAG)
                                ),
                                mload(OPENING_COMMITMENT_SUCCESS_FLAG)
                            ),
                            mload(BATCH_OPENING_SUCCESS_FLAG)
                        ),
                        mload(ARITHMETIC_TERM_SUCCESS_FLAG)
                    ),
                    mload(GRAND_PRODUCT_SUCCESS_FLAG)
                )
            ) {
                mstore(0x0, PROOF_FAILURE_SELECTOR)
                revert(0x00, 0x04)
            }
            {
                mstore(0x00, 0x01)
                return(0x00, 0x20) // Proof succeeded!
            }
        }
    }
}
