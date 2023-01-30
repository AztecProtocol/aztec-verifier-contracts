// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {StandardVerificationKey} from "../keys/StandardVerificationKey.sol";
import {BaseStandardVerifier} from "../BaseStandardVerifier.sol";

contract StandardVerifier is BaseStandardVerifier {
    function getVerificationKeyHash() public pure override(BaseStandardVerifier) returns (bytes32) {
        return StandardVerificationKey.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override {
        StandardVerificationKey.loadVerificationKey(vk, _omegaInverseLoc);
    }
}
