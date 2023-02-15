// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {TestBase} from "./base/TestBase.sol";
import {UltraVerifier} from "../src/ultra/instance/UltraVerifier.sol";

import {DifferentialFuzzer} from "./base/DifferentialFuzzer.sol";

contract UltraTest is TestBase {
    UltraVerifier public verifier;
    DifferentialFuzzer.PlonkFlavour public flavour;

    function setUp() public {
        // Deploy the verifier contract
        verifier = new UltraVerifier();
        flavour = DifferentialFuzzer.PlonkFlavour.Ultra;
    }

    function testUltraProof() public {
        bytes memory proof = new DifferentialFuzzer().with_flavour(flavour).generate_proof();

        assertTrue(verifier.verify(proof));
    }

    function testFuzzProof(
        uint256 input1,
        uint256 input2,
        uint256 input3
    ) public {

        // TODO: move flavour to constructor
        uint256[] memory public_inputs = new uint256[](3);
        public_inputs[0] = input1;
        public_inputs[1] = input2;
        public_inputs[2] = input3;

        bytes memory proof = new DifferentialFuzzer()
            .with_flavour(flavour)
            .with_public_inputs(public_inputs)
            .generate_proof();

        verifier.verify(proof);
    }
}
