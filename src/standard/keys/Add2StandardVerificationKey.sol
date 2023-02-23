// Verification Key Hash: cde6b0ae29262dee7f121972a7ac677dd6143f74ed59c46ca04f47635662ad62
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2StandardVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0xcde6b0ae29262dee7f121972a7ac677dd6143f74ed59c46ca04f47635662ad62;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000010) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000002) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x21082ca216cbbf4e1c6e4f4594dd508c996dfbe1174efb98b11509c6e306460b) // vk.work_root
            mstore(add(_vk, 0x60), 0x2d5e098bb31e86271ccb415b196942d755b0a9c3f21dd9882fa3d63ab1000001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x1c224bfe1b77fd4ca9de58caca7f6c5419b51c1899cbbcab2a59a523376240cd) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x125a87aab7a7434084a8987e011c5662829b644be58c69d1d95119f4dadf6501) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x029591591bf13a5f0a34aef38331c8aaf6e5b0d21f2cc8d7ffb5ab4cf2ec0193) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x1ea9374898e658cadce1f9e531f74891bbaff17c567c626b8cf47c22e0fd3ba8) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x289acc9d799a9699982b64a447efe2f8464b39a6f82af36dd68d5c21c87d0e3b) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x195e5d8e8d7efabbabeb44a6dfdee4aaf3a7b45dbdcb613e18caa65807aeed29) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x10f06340cd5a2dd7a0d860d8c325adeffecec817828e1c394c201ad8adfd9c18) // vk.QM.x
            mstore(add(_vk, 0x160), 0x02e0ba0d0aa987f3ab11a0eb6da484347656e9640ca284795fab2fc2bc01b1c6) // vk.QM.y
            mstore(add(_vk, 0x180), 0x1660b1537d389ee3d261243d8adb7d710e886feb15677b1c55e5084f592a3e32) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x105c91c8cc0172043932a13f25cb63f8f8cf28244f5c15387012ccb51d56a522) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x20b99d014bf0135c1411081af7194cf6e49ec0a7f548d0833f1a507eb77568a9) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x18abaa9c9f9aa38b5e90860b9a1bec7fe7053619a794897f8d4d9baf4fefc55f) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x1066ea620a00bb3e8baee7cc09eb52ec115d8209c0ccd76d266445d201b025c1) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x0aa0eca1f9a7ce0c0460156edc10378d541a3dd4bb3e059139c03f9ded1778b6) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x088ad8f1a461bc211def9469b3f8fabb1ca6d730e5103b6dae03ea13efc0c342) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x1d909cbeb6fb5962e00baf792fd7416b43adc66325bc82acd7fb4db07c30fc57) // vk.SIGMA3.y
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
