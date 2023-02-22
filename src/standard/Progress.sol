// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;
// gas cost at 5000 optimizer runs 0.8.10: 287,589 (includes 21,000 base cost)

/**
 * @title Standard Plonk proof verification contract
 * @dev Top level Plonk proof verification contract, which allows Plonk proof to be verified
 */
abstract contract BaseStandardVerifier {
    // VERIFICATION KEY MEMORY LOCATIONS

    /**
     * @dev Verify a Plonk proof
     * @param - array of serialized proof data
     * @param - public input hash as computed from the broadcast data
     * @return True if proof is valid, reverts otherwise
     */
    function verify(bytes calldata) external view returns (bool) {
        loadVerificationKey(N_LOC, OMEGA_INVERSE_LOC);

        assembly {
            let q := 21888242871839275222246405745257275088696311157297823662689037894645226208583 // EC group order
            let p := 21888242871839275222246405745257275088548364400416034343698204186575808495617 // Prime field order

            /**
             * LOAD PROOF FROM CALLDATA
             */
            {
                let data_ptr := add(calldataload(0x04), 0x24)
                if mload(CONTAINS_RECURSIVE_PROOF_LOC) {
                    let index_counter := add(mul(mload(RECURSIVE_PROOF_PUBLIC_INPUT_INDICES_LOC), 32), data_ptr)

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
                    mstore(RECURSIVE_P1_X_LOC, x0)
                    mstore(RECURSIVE_P1_Y_LOC, y0)
                    mstore(RECURSIVE_P2_X_LOC, x1)
                    mstore(RECURSIVE_P2_Y_LOC, y1)

                    // validate these are valid bn128 G1 points
                    if iszero(and(and(lt(x0, q), lt(x1, q)), and(lt(y0, q), lt(y1, q)))) {
                        mstore(0x00, PUBLIC_INPUT_INVALID_BN128_G1_POINT_SELECTOR)
                        revert(0x00, 0x04)
                    }
                }

                // Just loads the proof data - leaving the public inputs where they are
                let public_input_byte_length := mul(mload(NUM_INPUTS_LOC), 32)
                data_ptr := add(data_ptr, public_input_byte_length)

                mstore(W1_X_LOC, mod(calldataload(add(data_ptr, 0x20)), q))
                mstore(W1_Y_LOC, mod(calldataload(data_ptr), q))
                mstore(W2_X_LOC, mod(calldataload(add(data_ptr, 0x60)), q))
                mstore(W2_Y_LOC, mod(calldataload(add(data_ptr, 0x40)), q))
                mstore(W3_X_LOC, mod(calldataload(add(data_ptr, 0xa0)), q))
                mstore(W3_Y_LOC, mod(calldataload(add(data_ptr, 0x80)), q))
                mstore(Z_X_LOC, mod(calldataload(add(data_ptr, 0xe0)), q))
                mstore(Z_Y_LOC, mod(calldataload(add(data_ptr, 0xc0)), q))
                mstore(T1_X_LOC, mod(calldataload(add(data_ptr, 0x120)), q))
                mstore(T1_Y_LOC, mod(calldataload(add(data_ptr, 0x100)), q))
                mstore(T2_X_LOC, mod(calldataload(add(data_ptr, 0x160)), q))
                mstore(T2_Y_LOC, mod(calldataload(add(data_ptr, 0x140)), q))
                mstore(T3_X_LOC, mod(calldataload(add(data_ptr, 0x1a0)), q))
                mstore(T3_Y_LOC, mod(calldataload(add(data_ptr, 0x180)), q))
                mstore(W1_EVAL_LOC, mod(calldataload(add(data_ptr, 0x1c0)), p))
                mstore(W2_EVAL_LOC, mod(calldataload(add(data_ptr, 0x1e0)), p))
                mstore(W3_EVAL_LOC, mod(calldataload(add(data_ptr, 0x200)), p))
                mstore(SIGMA1_EVAL_LOC, mod(calldataload(add(data_ptr, 0x220)), p))
                mstore(SIGMA2_EVAL_LOC, mod(calldataload(add(data_ptr, 0x240)), p))
                mstore(Z_OMEGA_EVAL_LOC, mod(calldataload(add(data_ptr, 0x260)), p))
                mstore(PI_Z_X_LOC, mod(calldataload(add(data_ptr, 0x2a0)), q))
                mstore(PI_Z_Y_LOC, mod(calldataload(add(data_ptr, 0x280)), q))
                mstore(PI_Z_OMEGA_X_LOC, mod(calldataload(add(data_ptr, 0x2e0)), q))
                mstore(PI_Z_OMEGA_Y_LOC, mod(calldataload(add(data_ptr, 0x2c0)), q))
            }

            /**
             * EVALUATE FIELD OPERATIONS
             */

            /**
             * COMPUTE PUBLIC INPUT DELTA
             */
            {

            }

            /**
             * Compute lagrange poly and vanishing poly fractions
             */



            /**
             * COMPUTE LINEARISED OPENING TERMS
             */
            {

            /**
             * COMPUTE ARITHMETIC SELECTOR OPENING GROUP ELEMENT
             */