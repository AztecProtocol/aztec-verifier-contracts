// Verification Key Hash: a4983c603d90d9d65f82ed9e0b284f502017120dfeff0f401623e17615b853de
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2UltraVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0xa4983c603d90d9d65f82ed9e0b284f502017120dfeff0f401623e17615b853de;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000010) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000002) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x21082ca216cbbf4e1c6e4f4594dd508c996dfbe1174efb98b11509c6e306460b) // vk.work_root
            mstore(add(_vk, 0x60), 0x2d5e098bb31e86271ccb415b196942d755b0a9c3f21dd9882fa3d63ab1000001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x2d755136a4fefe5196c86905173ed8bb2a9bbbed1c6db1018f368c7905f81d9c) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x081609c96478e3d9111268ada02c4eb8b472692e483dafe2bc238f61227b10b3) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x2bb58c9fd877a2ab7e1328bf025e6be067d158e5af916c42017540e29c41defb) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x2e329a1409e6b2e1ffa6bcabff83c295cf5736dede9fc943c17ee9abeada04d7) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x18be0e9bb4247ae0b2a3f03ff2b63bba93d1e5ae5dbfe7f2117c243e8e5cf58e) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x128fde33f3a3e87a34d3e5d4c1d191562945ea9fc5668a65ca8891f71c396e8f) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x1a4328efd8724c440f693459253d72a0d5db0fe2bafe1802412fc255e4062daa) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x0692646e213872f47547846b13d9521342b09aea3b99b7e2e7173c7a1cba33f0) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x01a42e2f5e96636fa5e351edb7216705dccd4472bf61377a30edd029d6b62491) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x2231c6b92b39d6beac316eec42d071d1834ff26c3b47b91395ba7e69ebf9a7f3) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x00e04db972b1a269290caa19c21549bfe20dca4a1c09b6c8a4ef428731da323e) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x14542885e9a34d0d3b560d89c8c08275258413936e3c92a18e46048136e17cd2) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x22f1e3ed9d38a71a54c92317c905b561750db3a311c0e726f86b022476a0452d) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x180a52fce7a39700530f19446b84a44d1c725fed57ac09d9b65c98127706a277) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x2cbce7beee3076b78dace04943d69d0d9e28aa6d00e046852781a5f20816645c) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x2bc27ec2e1612ea284b08bcc55b6f2fd915d11bfedbdc0e59de09e5b28952080) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x0ad34b5e8db72a5acf4427546c7294be6ed4f4d252a79059e505f9abc1bdf3ed) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x1e5b26790a26eb340217dd9ad28dbf90a049f42a3852acd45e6f521f24b4900e) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x155a0f51fec78c33ffceb7364d69d7ac27e570ae50bc180509764eb3fef94815) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x1c1c4720bed44a591d97cbc72b6e44b644999713a8d3c66e9054aa5726324c76) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x1347ec3b3a59dcbf5f21d32964588470a5825df501b80b4b625af8e7b4fb8ae8) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x02c934df56040256be73463b6c31dc3c9c667c882dbd933ac05aee66c4884028) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x300383a80af313cc916f731ca2f1593b338f73f12cf4a91b0f9dc7d2c2118530) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x144e751cb644c90cfb3e6d140a8f8f0ec6fde4889701976fbfc3ef31a54a8a05) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x2d408059e4b5cdfa8d61704132bde83e2f61d4ee210687d79f3c1ec446325ace) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x298c670f1dba4e10f9fc26ce4dcbe6a692db61cd80c52453021bf04e4cec15ed) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x0524d1338927d3de5bc82389267cc1b1eb190f6a9529ec06e6378ef0ac660d9a) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x3040fa6c88dcc8534fbd7fdff1ccdf33495a1936a996bd5eeba7849fabf1c755) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x02c397073c8abce6d4140c9b961209dd783bff1a1cfc999bb29859cfb16c46fc) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x2b7bba2d1efffce0d033f596b4d030750599be670db593af86e1923fe8a1bb18) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x2c71c58b66498f903b3bbbda3d05ce8ffb571a4b3cf83533f3f71b99a04f6e6b) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x039dce37f94d1bbd97ccea32a224fe2afaefbcbd080c84dcea90b54f4e0a858f) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x27dc44977efe6b3746a290706f4f7275783c73cfe56847d848fd93b63bf32083) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x0a5366266dd7b71a10b356030226a2de0cbf2edc8f085b16d73652b15eced8f5) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x136097d79e1b0ae373255e8760c49900a7588ec4d6809c90bb451005a3de3077) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x13dd7515ccac4095302d204f06f0bff2595d77bdf72e4acdb0b0b43969860d98) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x16ff3501369121d410b445929239ba057fe211dad1b706e49a3b55920fac20ec) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x1e190987ebd9cf480f608b82134a00eb8007673c1ed10b834a695adf0068522a) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x00f0d27122b98e623f07161a39e4d711f93193a90d0c59ac063c4f9d0bfbca46) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x00284f9da7a5ab3c5d9f850501ebd581ba83144bb5202a1d6d8ffc95578a046a) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x20545a910ea2977acb8ead4bbcef90073201df2ecac19f40b280785953254c54) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x14e39e8bbe54a3bf399fc604c90162ee1f660936deeefffc63ced8752aea8974) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x033ece808758e0c08e902fb9f1a50de06863aead017ad89cb22626f59a1c82ef) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x15b8b58d95d6c131a8fa2884d4a03b313944adf910a17209895b6ac5811dd554) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x1bdec50e2047f0aec888ac0d55cffe602b28105876d1640faf26d11fdf4b8c7e) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x0b79dc0f7c13141dd008a8f42025d40f3598ceaa5cb7652cb7fa457439a802db) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x02e40daf409556c02bfc85eb303402b774954d30aeb0337eb85a71e6373428de) // vk.work_root_inverse
        }
    }
}
