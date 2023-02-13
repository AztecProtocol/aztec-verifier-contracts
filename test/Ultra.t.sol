// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TestBase} from "./base/TestBase.sol";
import {UltraVerifier} from "../src/ultra/instance/UltraVerifier.sol";

contract UltraTest is TestBase {
    UltraVerifier public verifier;

    function setUp() public {
        // Deploy the verifier contract
        verifier = new UltraVerifier();
    }

    function testUltraProof() public {
        string memory path = "data/ultra/UltraProof.dat";
        // string memory path = "data/standard/standard_proof.dat";
        // Read the proof bytes directly, no need for extra parsing
        // bytes memory proof = vm.readFileBinary(path);
        // bytes memory rawBytes = vm.readFileBinary(path);

        // Extract the [data], which contains proof and the rollup data that is hashed into the input hash.
        // bytes memory proofData = new bytes(rawBytes.length - 5); //

        bytes memory proof = readProofData(path);
        // The input has for the proof is the first word of the proof.
        // uint256 inputHash = uint256(readWordByIndex(proof, 0));
        // // Check that the proof is valid
        // assertTrue(verifier.verify(proof, inputHash));
        // Check that the proof is valid
        assertTrue(verifier.verify(proof));
    }
}
