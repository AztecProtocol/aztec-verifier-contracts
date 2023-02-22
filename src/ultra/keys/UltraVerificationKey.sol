// Verification Key Hash: d7c4c13de2bcc593c3f12b3b7ec0653d2732d4d1ad6a32555476bab556ce7e68
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library UltraVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0xd7c4c13de2bcc593c3f12b3b7ec0653d2732d4d1ad6a32555476bab556ce7e68;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000008000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000004) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x2d1ba66f5941dc91017171fa69ec2bd0022a2a2d4115a009a93458fd4e26ecfb) // vk.work_root
            mstore(add(_vk, 0x60), 0x3063edaa444bddc677fcd515f614555a777997e0a9287d1e62bf6dd004d82001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x03551ddf6190f81349696d15b86bc849bc7e676afce8eea4f4dd3fef8871d678) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x2df36d02bffffc69de314032f0abc35f12a198e9016e0dfe6223f0c6343d5fc5) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x27dedb01affaaf128daebace3b343ef8a4524b77c4b29f08b53cf9b4027116db) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x01095c69147ae199af3243a3a7c9050907444ed2172cbe9d57ed41f0b53c3b2b) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x2c9d44c9c92b6c5723acafcae346e610aede9ec4c5c065a7d1b26364456b423c) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x1363eac70b5caa723ca6caf4448e667a7729bf13f6540cabbebf64adf1e06a7c) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x03605e030cf59021aa101e196a2012ba95eaba56e86889333ef06bbce1136f4f) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x16df7b003bbe28dc4a904a58f14180c12a4cbb9a8684c7e08307478b9862005b) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x29d14d97c5f254ae0719aa461a9a5e2092f3501fb95a69575032f7ab56f1a3d3) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x1cf54756b0a979dbbd9f069bc04ea0755c969902a706e7cfae53b45bd6f8d2cc) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x25662bf75f9eca24cfe8d1ca8e7f8cd06496b3ace467269af986a755aebe6946) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x2418d7a87c29aada5170afa489ee0066417c2630f4d3e1a893c27e9b25d52ed5) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x044f278fdba84003d8361a7956c44a787f8a8e706c9dcf6c31822c4d439dad14) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x0fac168f57659063512cbd35f2dcaabf4c1514ff1b2e6eb09b1ec7a55a6733df) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x1e1cb02eb46f76e0d0717219c9289d7f563fd1a8ae33ab10a1ebcdc60bc6b8b1) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x1b602ca3a42b8b1f40ef9de415cfc51a265c4e45284de61ce90ccd5ae0899ac2) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x21959276775cd4749236c8bf773a9b2403cecb45fbf70e6439f73d75442e8850) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x017714509f01d1a9ee7ebaf4d50745e33a14150b4fe9850a27e44de56d88cb14) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x2e76c4474fcb457db84fb273ccc10a4647a1a37444369f2f275bb74540f5e2d0) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x209035caddd02a78acd0ed617a85d782533bd142c6cad8e3338f3142b919c3a4) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x118a8b7edfccbdf8600bb4ebd38aae2c14661395ec65ece1e0f12c18051b11be) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x1d2c5ca2a9341bbfdd8fa5aa03905593f910e10cf9c74f76501493357ff81753) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x0b246910546c907abe7fe529f0602805746a33c0c0edc63f364179fd55ec9838) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x1c0165f838d622bf16dcbd51cb3bf37579ab7294a209c88dd43854e52b3ca10d) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x1dc772532255b8edeb5f2429fdf401a6e474a0431f22f3bcfef9634c18eeaac6) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x1885bb6b9f4f79708e3f9ddcef970029f1d3a1fbb1f81d22933d9f720e2a5db2) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x05d8c63558000f6c3653d83a37ee47948ae1c6a205faf0517b4da3e97026ce96) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x1abae37520e5c14c4c89ea73b5eb6348fec6637db2b429d645e020ae2c5edd21) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x06c5d3c2a64587cf9dc278c6892854fc8f1aba4183115224cb2eda4c1aab64b8) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x132622df9222e04fa9c4cf2895212a49556038d4fdc6d0d7a15b1067bb446efa) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x2dbc1ac72b2f0c530b3bdbef307395e6059f82ce9f3beea34ff6c3a04ca112bc) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x23e9676a2c36926b3e10b1102f06aa3a9828d1422ae9e6ea77203025cd18ada0) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x298b6eb4baf5c75d4542a2089226886cc3ef984af332cae76356af6da70820fe) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x1bb16a4d3b60d47e572e02fac8bf861df5ba5f96942054e0896c7d4d602dc5c7) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x1f5976fc145f0524228ca90c221a21228ff9be92d487b56890a39c3bc0d22bf2) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x0f43d83a0d9eb36476e05c8d1280df98ec46ce93ae238597a687a4937ebec6cc) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x28d89b328ca1844048389a9d4646a5fda4df96734416b92d1171994fdd07a165) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x1c9d8f44d1500de4bb22762fb3c67dbb498bfd6f6d3f7fbbdef2722220ad0b21) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x2de55bd0b5b250c49fbb4d285293e498564e8553dfc794c626b28735cd0d446c) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x13e7c4f7880f6369c5e42e4e5e339e27eabbf5bf5aca2937b975b23988ada439) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x04321fa1a66150ce03473907991e1e043416f8669aa5f6fc55cb8569ac624528) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x2f91533eae7ba6c97d648f429e7695461901cfcac4d76ff921db54eac9b022ec) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x0aa39884f4a55ae8ccf1cc69279478f7c468ce1f03089501a85953845834d19f) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x07d38c72c9921a031a4143e838b47e584363e26d992bcfbf3538ecb30d572f48) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x0e49ac52ad441792405370364714c8f866c68e82c4e2f11fc4200a92ba16eae1) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x24bd49284199206c0e0b90a8b766aaf76a2f29ed82a213886e38c06dd0b521cd) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x05d33766e4590b3722701b6f2fa43d0dc3f028424d384e68c92a742fb2dbc0b4) // vk.work_root_inverse
        }
    }
}
