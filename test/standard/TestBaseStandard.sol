// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {TestBase} from "../base/TestBase.sol";
import {DifferentialFuzzer} from "../base/DifferentialFuzzer.sol";
import {BaseStandardVerifier} from "../../src/standard/BaseStandardVerifier.sol";
import {IVerifier} from "../../src/interfaces/IVerifier.sol";

contract TestBaseStandard is TestBase {
    IVerifier public verifier;
    DifferentialFuzzer public fuzzer;
    uint256 public PUBLIC_INPUT_COUNT;

    function setUp() public virtual {
        fuzzer = new DifferentialFuzzer().with_plonk_flavour(DifferentialFuzzer.PlonkFlavour.Standard);
    }

    function testValidProof() public {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);
        assertTrue(verifier.verify(proof, publicInputs), "The proof is not valid");
    }

    function testProofFailure() public {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);

        // Invalidates the proof by adding 1 to one of the elements
        assembly {
            let where := add(add(proof, 0x20), mul(0x20, 2))
            mstore(where, add(where, 0x01))
        }

        vm.expectRevert(abi.encodeWithSelector(BaseStandardVerifier.PROOF_FAILURE.selector));
        verifier.verify(proof, publicInputs);
    }

    function testPublicInputsNotInP(uint256 _offset) public {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);

        uint256 toReplace = bound(_offset, 0, publicInputs.length - 1);
        uint256 p = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        publicInputs[toReplace] = bytes32(p);

        vm.expectRevert(BaseStandardVerifier.PUBLIC_INPUT_GE_P.selector);
        verifier.verify(proof, publicInputs);
    }
}
