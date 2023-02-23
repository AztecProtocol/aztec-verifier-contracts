// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {Add2StandardVerificationKey as VK} from "../keys/Add2StandardVerificationKey.sol";
import {BaseStandardVerifier as BASE} from "../BaseStandardVerifier.sol";

contract Add2StandardVerifier is BASE {
    function getVerificationKeyHash() public pure override(BASE) returns (bytes32) {
        return VK.verificationKeyHash();
    }

    function loadVerificationKey(uint256 vk, uint256 _omegaInverseLoc) internal pure virtual override(BASE) {
      VK.loadVerificationKey(vk, _omegaInverseLoc);
    }
}
