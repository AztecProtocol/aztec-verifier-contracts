// Verification Key Hash: 0f13567be759591214bac9cfe0b028e9355e1a4afe79e500bcf51d786dfb55a4
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2UltraVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0x0f13567be759591214bac9cfe0b028e9355e1a4afe79e500bcf51d786dfb55a4;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000008) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000002) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x2b337de1c8c14f22ec9b9e2f96afef3652627366f8170a0a948dad4ac1bd5e80) // vk.work_root
            mstore(add(_vk, 0x60), 0x2a57c4a4850b6c2481463cffb1512d51832d6b3f6a82427f1b65b6e172000001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x0930f0db5d9029310d09cf06d601438174a426beb20de66abd2e5c65e28aa72d) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x0ea64630899aa482edcd3f98cbb3e38005a5ebf5522ae749c8f39c83b1200a0e) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x0155152fbb3939dc32220d3b4f72e4d00431dbc11d8c37cbed2c9df3f1d75107) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x02967fb4837ec0b9c664ac533e2afb211a324fcd35fd99dc66b001d1989aa6dc) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x13b9f80bfcf54144b6fb567dd84413ef286b5e21a33b6665a36fc7b0b493fe3d) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x230eeedb0c082a23b4b242200c40a5e36d372e5bb53d2f8d1a48df157229c7f7) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x1d539ccbfc556d0ad59307a218de65eef0c9e088fd2d45aa40311082d1f2809b) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x177004deeb1f9d401fd7b1af1a5ac8a2c848beceb6ab7806fd3b88037b8410fc) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x0d82d51f2f75d806285fd248c819b82508eb63672a733f20de1a97644be4f540) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x06cd3b0e3460533b9e5ea2cdc0fcbbd002f9100cbba8a29f13b11513c53c59d0) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x21791de65f9a28ec7024b1a87ab4f3f45ea38a93b2f810c5633ddb54927c1c96) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x29fa14a969c5d81ed3abbbfb11220a926511a0439502c86885a8c6f0327aa7ad) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x2fee28a554d0307fb666a9bd9c8b1477f139508491b5915c005b7d7a32a3e607) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x020ee7c8c264459c59bf8652e3bc0568d8285540b79eef4178ceed75ab8c6770) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x20690fd4869db418306046b38161dce38e900b42c314ba803088e8fbf125203f) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x048a85e0bbac7c60ad3d78f601f63c1e2fa856bf7951b8292b1e88185993629c) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x2623ad892dc62b1fa7d0a650f0d4706f457719495073d3666d77a625aeab0c51) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x295f6f10976c37bd9c6f96bb7187d5dbfcc8a467e021c03b13f74a9f79c3a10c) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x03560a3b334e887532f605c9cb7628c13ef9a937cc12420fb38d9ab8e848e85e) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x15adc8bb1e01c835f48959d1237bd69bcebf08a4599cdda0fb96312d4dc0c7a9) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x174545084ed478bdd59e82a5933f21ed52763c78fa49a0cee86c734ed6595ed4) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x0a0b6269cfa154945443bbaa7812019894b682a16fa60da02f9ce5912c543847) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x210c4ca7086371bbeb2ac5027bb7672f1c3e4477c891c5316d7d45848e805f2e) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x02fdcd3fbd7c416eb9879f088766ed5ae08a97cd170e93870c5bf6d54f3096ad) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x2f21595a10fbf6c07f8a614d110738db0b8942c1c59d0c4767fd4c4203471303) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x1ed0e7a59aca1fdbf4617ac114cda2cd8393f4d5eb19ca870bc0e4734d7f282d) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x09950b0f8925d503c3b119bf59307aa18fb1c03e39a503e7412c23721b9ca129) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x086e2bc8cce431216556b72217c721464413f22661c9c265d5548a1c7163e7bd) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x1f54baa07558e5fb055bd9ba49c0679c5d6e08a6605ab4513748ac0fa017dd1c) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x24aec62a9d9763499267dc98c334281e1ee7ee29bbb5e4b080c6091c1433ce62) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x28cf3e22bcd53782ebc3e0490e27e51a96755946ff16f0d6632365f0eb0ab4d4) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x234ce541f1f5117dd404cfaf01a22943148d7d8c9ba43f2133fab4201435a364) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x3016955028b6390f446c3fd0c5b424a7fb95ffb461d9514a1070e2d2403982ef) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x13ef666111b0be56a235983d397d2a08863c3b7cd7cddc20ba79ce915051c56e) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x217f7c4235161e9a3c16c45b6ca499e3993f465fc9f56e93ac769e597b752c1c) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x256467bfcb63d9fdcb5dde397757ad8ffa4cd96bc67b0b7df5678271e1114075) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x0e52d1bd75812c33c6f3d79ee4b94c54e5eb270bb64bde6e6ececadfd8c3236c) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x0ff417d256be43e73c8b1aa85bdda3484a2c641dce55bc2dd64ef0cd790a7fea) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x270b9ccfe99ba0e60f50ce3b52be3dd65dc844eaa715eb104a37dc3ef32e0bcb) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x1ebb28b3e9a92580b724e6b9f905c4a1389c87793d5116b05efda839be5b2db1) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x0868357b28039385c5a5058b6d358ebb29f26f9890d6cc6401f4921d5884edca) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x1060afe929554ca473103f5e68193c36fb6e229dde8edf7ec858b12d7e8be485) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x0b1c02619282755533457230b19b4a15226e07e207744c0857074dcab883af4a) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x0d928deafed363659688ed4ccdef521f2a0277e4807e6e1cbabca21dde5eb5e1) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x2eea648c8732596b1314fe2a4d2f05363f0c994e91cecad25835338edee2294f) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x0ab49886c2b94bd0bd3f6ed1dbbe2cb2671d2ae51d31c1210433c3972bb64578) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x130b17119778465cfb3acaee30f81dee20710ead41671f568b11d9ab07b95a9b) // vk.work_root_inverse
        }
    }
}
