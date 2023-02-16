// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {TestBase} from "./base/TestBase.sol";
import {StandardVerifier} from "../src/standard/instance/StandardVerifier.sol";
import {BaseStandardVerifier} from "../src/standard/BaseStandardVerifier.sol";

import {DifferentialFuzzer} from "./base/DifferentialFuzzer.sol";

contract StandardTest is TestBase {
    StandardVerifier public verifier;
    DifferentialFuzzer public fuzzer;

    uint256 public constant PUBLIC_INPUT_COUNT = 4;

    function setUp() public {
        verifier = new StandardVerifier();
        fuzzer = new DifferentialFuzzer().with_flavour(DifferentialFuzzer.PlonkFlavour.Standard);
    }

    function testFuzzProof(
        uint256 input1,
        uint256 input2,
        uint256 input3,
        uint256 input4
    ) public {

        uint256[] memory public_inputs = new uint256[](4);
        public_inputs[0] = input1;
        public_inputs[1] = input2;
        public_inputs[2] = input3;
        public_inputs[3] = input4;

        bytes memory proofData = fuzzer.with_public_inputs(public_inputs).generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);
        assertTrue(verifier.verify(proof, publicInputs), "The proof is not valid");
    }

    function testValidProof() public {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);
        assertTrue(verifier.verify(proof, publicInputs), "The proof is not valid");
    }

    function testProofFailure() public {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);

        assembly {
            let where := add(add(proof, 0x20), mul(0x20, 2))
            mstore(where, add(where, 0x01))
        }

        vm.expectRevert(abi.encodeWithSelector(BaseStandardVerifier.PROOF_FAILURE.selector));
        verifier.verify(proof, publicInputs);
    }

    function _testVerifierInvalidBn128G1() public {
        // NOTE: This test only makes sense if we are doing a recursive proof.

        _testVerifierInvalidBn128Component(0x40); // x0
        _testVerifierInvalidBn128Component(0xc0); // y0
        _testVerifierInvalidBn128Component(0x140); // x1
        _testVerifierInvalidBn128Component(0x1c0); // y1
    }

    function _testVerifierInvalidBn128Component(uint256 _offset) internal {
        bytes memory proofData = fuzzer.generate_proof();
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, PUBLIC_INPUT_COUNT);

        {
            uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

            assembly {
                mstore(add(proof, _offset), and(shr(0, q), 0x0fffffffffffffffff))
                mstore(add(proof, add(_offset, 0x20)), and(shr(68, q), 0x0fffffffffffffffff))
                mstore(add(proof, add(_offset, 0x40)), and(shr(136, q), 0x0fffffffffffffffff))
                mstore(add(proof, add(_offset, 0x60)), and(shr(204, q), 0x0fffffffffffffffff))
            }
        }

        vm.expectRevert(BaseStandardVerifier.PUBLIC_INPUT_INVALID_BN128_G1_POINT.selector);
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

    function _testPublicRecursiveInputsNotInP(uint256 _offset) public {
        // The last 68 bit limb in each point (except the last, as that is check in another testLastPublicInputNotInP)
        revert("To be implemented");
    }
}
