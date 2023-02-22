// Verification Key Hash: 7b35134386519c997aa67d63dd0fcfb17cb24fa05a07cc38bb622898d4776cfb
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library StandardVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0x7b35134386519c997aa67d63dd0fcfb17cb24fa05a07cc38bb622898d4776cfb;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000020000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000004) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x1bf82deba7d74902c3708cc6e70e61f30512eca95655210e276e5858ce8f58e5) // vk.work_root
            mstore(add(_vk, 0x60), 0x30643640b9f82f90e83b698e5ea6179c7c05542e859533b48b9953a2f5360801) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x0c3f92fad6603420c9804572662fa6260179232c543edeaa359f3ac38fd1a477) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x1af7ccd568fb27084ed6670e228320750886c692f1af974bdc213fb88514f449) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x047c245637e90c650e84a5175c271e94732866a166f3ba5d5a3dbed59ea12ef6) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x2f62bfbb0be97ae1f520b833689bb62f91aee89be9ee465e2164eae275b39673) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x1ebc37057b55e5df3173d1b2f1ae86513af88a06a0a91fe1438a8b91fe8cc6fa) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x2a40602e45274d53e0c6ce74efa162261f38e4c177c49cc1690b3b8a3a2a718f) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x2739ea241b48c9e7932b6719e29043e734fc5c6e197078043206eca8d5533e84) // vk.QM.x
            mstore(add(_vk, 0x160), 0x24c834247475b5764eebe3deaee4dd3fefec7b25dac0fd88e9ba3b06d62035a8) // vk.QM.y
            mstore(add(_vk, 0x180), 0x22e68b36acb348e48e2218972fb6c7143626f97d0839414781679956b4f3cac2) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x133ef0681ffbf0d0b2aeaf419b1daa0dc7fcecdee138bc51b659e062780cb377) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x21119a79adf416a2a73d6c8660bf51d9a29eb650ca5e46ac29ea4f9155a7b68e) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x05a5643058588ec38b256e6dc2060417084ca4134988ef095af489fc5a00e956) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x27fc975886304cfa64c5860ee2f128310d1bd609ffe2485b3b4d530d723a10bf) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x124db1c97d325b054505d017c2d58300f60a580d35b1cf2e88eec014c0676bc9) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x2cf926e59736203eb31dfb51276cc65e2cdc1bfda58a7909d6f4e2dc2b3ae0a1) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x204d58edfc04c2449d9764bed792780587b1a815a9e1f9bc3e32062921a4a976) // vk.SIGMA3.y
            mstore(add(_vk, 0x280), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x2a0), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x2c0), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x2e0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x300), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x320), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x244cf010c43ca87237d8b00bf9dd50c4c01c7f086bd4e8c920e75251d96f0d22) // vk.work_root_inverse
        }
    }
}
