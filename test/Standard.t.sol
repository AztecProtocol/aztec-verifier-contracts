// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TestBase} from "./TestBase.sol";
import {MockVerifier} from "../src/standard/instance/MockVerifier.sol";

contract StandardTest is TestBase {
    MockVerifier public verifier;

    function setUp() public {
        // Deploy the verifier contract
        verifier = new MockVerifier();
    }

    function testWithRollupProofData() public {
        string memory path = "data/standard/mock_rollup_proof_data_3x2.dat";
        (
            ,
            /*bytes memory proofData*/
            bytes memory proof,
            uint256 inputHash,
            bool expected
        ) = readRollupProofData(path);

        // Run verification and check that result is equal the expected value
        assertEq(verifier.verify(proof, inputHash), expected);

        // Print the proof data, includes the public inputs that we hash.
        // emit log("ProofData: ");
        // printBytes(proofData, 0);

        // Print the proof bytes (with public inputs, here the public input hash)
        emit log("Proof bytes:");
        printBytes(proof, 0);
    }

    function testWithProofOnly() public {
        string memory path = "data/standard/mock_proof.dat";
        // Read the proof bytes directly, no need for extra parsing
        bytes memory proof = vm.readFileBinary(path);
        // The input has for the proof is the first word of the proof.
        uint256 inputHash = uint256(readWordByIndex(proof, 0));
        // Check that the proof is valid
        assertTrue(verifier.verify(proof, inputHash));
    }
}
