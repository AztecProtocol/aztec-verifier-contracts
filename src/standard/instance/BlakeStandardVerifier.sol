// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {BlakeStandardVerificationKey as VK} from "../keys/BlakeStandardVerificationKey.sol";
import {BaseStandardVerifier as BASE} from "../BaseStandardVerifier.sol";

contract BlakeStandardVerifier is BASE {
    function getVerificationKeyHash() public pure override(BASE) returns (bytes32) {
        return VK.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override(BASE) {
      VK.loadVerificationKey(vk, _omegaInverseLoc);
    }
}
