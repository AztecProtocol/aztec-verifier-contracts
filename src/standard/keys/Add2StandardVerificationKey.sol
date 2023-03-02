// Verification Key Hash: 4df0caae71984b1fdf1c2ae7f59cc344a047a55dfcc501fe1f5a545dead6da46
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2StandardVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0x4df0caae71984b1fdf1c2ae7f59cc344a047a55dfcc501fe1f5a545dead6da46;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000010) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000003) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x21082ca216cbbf4e1c6e4f4594dd508c996dfbe1174efb98b11509c6e306460b) // vk.work_root
            mstore(add(_vk, 0x60), 0x2d5e098bb31e86271ccb415b196942d755b0a9c3f21dd9882fa3d63ab1000001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x0fe8527a8494f827e4b332060e5569bdfe47aadc475cb1f03b4d222b0804e463) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x2d051f6d8a9eec7ae2622b4b259fb91d942a8892632cffcdad4c03e2c9081593) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x21be04985f898ef5e2a80f32fbaa16cd3eb8c451c243db46144b97113c8e556a) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x2913bcdde62d6d2143aa6a0fed511ca527994df2cba6a780baa29dddac161de9) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x15bf0818d578953a624a127aa04d4b0aa1b09d3fe69b9a29e2546a41e9b08049) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x0148f0d2abf2ca1fe6cc20fdef0a8d4a88eb9602eaf48f0c1c02445c27cb9592) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x2950076760523510abcfe90fa550b964e84b338f73af5222cdbbaefdacd4484e) // vk.QM.x
            mstore(add(_vk, 0x160), 0x2e4e3e272c7b78ad894559812d7766e05615a8f7050a43d7ed1367adf30a9319) // vk.QM.y
            mstore(add(_vk, 0x180), 0x1798c37010a4285e1774c1ad35779886380ee5ceee0ba183927e2a2103301a68) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x2935f9e4d47a8e39aa0107f31a84584b47d903cfeb9690f6d850dc8ea7d2f4ea) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x01ecc67f1bfa2bbb86cf8bb4e0126f26d1998d2871dfb63be41a814d9dae0641) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x1767040901bc39fbb71f1b58e2ac3a3dadf3fdac67b11cea10ac5fcdeabd553b) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x0cd59a6cd61ad5acb5ec6398fd2fc53a16680345aee361c35b4d9c6aeac70d7d) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x1853a7fb46d9e53316aa89bd00bf179b46ffb4db8914442d570e2b0ac85d778a) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x20f38971706f7905e8dcc0622ce683860d50ba85ee36e45d2ca7a3a665691ada) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x008eb31389fdbeaf4641531f806e162fdcfee12d9690b3743f416ec41abb6d36) // vk.SIGMA3.y
            mstore(add(_vk, 0x280), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x2a0), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x2c0), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x2e0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x300), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x320), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x02e40daf409556c02bfc85eb303402b774954d30aeb0337eb85a71e6373428de) // vk.work_root_inverse
        }
    }
}
