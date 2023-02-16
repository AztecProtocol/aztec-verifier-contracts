// Verification Key Hash: 2ae470a93010e1f08682e8e1e2a45fee351281999a8f573ac0945828787b0db2
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library ultraadd2VerificationKey {
    function verificationKeyHash() internal pure returns(bytes32) {
        return 0x2ae470a93010e1f08682e8e1e2a45fee351281999a8f573ac0945828787b0db2;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000400) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000002) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x06fd19c17017a420ebbebc2bb08771e339ba79c0a8d2d7ab11f995e1bc2e5912) // vk.work_root
            mstore(add(_vk, 0x60), 0x3058355f447953c1ade231a513e0f80710e9db4e679b02351f90fd168b040001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x105809ef37500844a167894c5862d892d9eed535bb20a121dd7e8d2d14eceaf4) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x10285a2f3aebab33b30ecf0d41ce54ba841e27c4c90be69d957be4d66987bf92) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x23cd2121ed150baaa19d3b08ef297d9c71d5f80ba2919b079e73f007d6b3cccb) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x2917e2de16234eed34870606ee8ea2e85b04d7e1c8a44db4374f6a434e7a3cfe) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x1b850eedd1992e1ad2bd9f8a692c4e5b289c29faca376438f66f2b3112cf1822) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x245942d28b0fc74104f44c1b40d65848b6868b849119bd400311fa50db2839a6) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x1102f434f54be07a76559541be5b25c6632900be99c6c7bea4aad309d338f889) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x258e29c4c142b9ad2353c4f9141f51d3eaf05ec120c64ceba0a6225e9790f14e) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x036a00260bc7e8c41b710aa55b676101e49cf4d91b5c0e10a037ea0576501ca5) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x1f2ef438e33f1dfdebfc2b7c69c6c6913755107e837b63b0fda38b32b6609f44) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x23f8301c31554d5595b2a7cd4ed37afaca60789dbd2732e959bd2dd7342e3c90) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x129d3e41e286ee80ea7b8ac6d9cf609b080aed5f54070e8056345caa7c415d22) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x2c56de9c2230b8e4d97131148382d16750c3305b53c854cc7271c625bf5de5c9) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x22506a01f198025984ddc0007d429b55643a7de85245819327f30002d998d647) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x26da490b6641c4d393cd973a7180e860ea6c9e3ea971c053a55dc89603fa6581) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x1f2977aeed515f58aa7cdef4bfaf1041ca059ccddb655a6a6873f542d1f34c0d) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x273d40dd3bce751580483c8ead88f94535448de8088456fe83376e05cccbdc98) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x2be69038eb9852beb166fd7755183ce25790491400ac1b7fc47628525702f1c3) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x0b75803d020993aae12fff4b302511645807e72d327c5926373e9e8020dd24c2) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x24c953be9c18ddcafc2845fa8b22fb449ff1e375e71f9a4f199f390aba584c4e) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x165e2c7ced09afa52bca985593174adbcd0d32f6904ebffb93b7c90022ba5b77) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x0c44e08a59fccccd40a88e082da711ec1bf378f22ee1d322e03cf53bbd381cd3) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x138784888ee1ade0b34fb94aca6232f8d44b72bfc9920a5fce4e6ecd8bdcfaf1) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x22df21ffe2025b665aadbc6d8247032fb49ffa70e46ff339dd7ccf9fc1bdbcfe) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x17129146a5085fb34b54fb818dd0a6b52bead71ceef1d843ab7b536ca329eb6c) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x1352f1b9aa530bf2a42900079669707026a8b10f97f838a81c4229c2c773f1fa) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x2a62a0f759b8f249d36682a2d3c5f398773b96a9e4ec0feaaaa283f896794e8f) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x0910e0da5ce85a4ce0e3ae110b9a72e1c9bfa15b86f44247ad0b1e149c640e45) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x2a8f38a4936cba151811671d5afeec5d7466709833ba96686626ff1ad1da4b7b) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x0146ad4600c8edb6d0e56554c645120149cf7845ed8d2934f882de29bf3d05a6) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x0108ef8c537ae19c420007cfcacf061de82808857de55bb1c111540df0f49ac8) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x0446adf3fc100bbb58aeccf275df0982d9b2eaf43d36d15127b44975069cc00d) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x19c364f5c0a4b4ab46439ec4f6b41e85bcb447b3b3d56c498fffb24a8e17803c) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x261fa22dc105a5fb00af42838f77daf11f3dbfbc45adb698569860513d115f0b) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x1e500c8c409983cf62fa4a2a223db1e322b5e25669fa77f09677ea7d4bea1271) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x12a6c081b534d611b686901b6ffed9897e341d3b9ba734b7a2c51c3cd5d05ccb) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x1c10d1c88a68ba01fa9f6c3010e9ae93892ca0617b390ccac9c78d9835e993ef) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x0462aba4c9975a98994d929f88cbc50b4f6eb3a942f6a6948fac6ba0edc8557c) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x1148645ba8b5eaa4a647e097c93b810ede9c1308e4d027ab6662a337450f2c58) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x248cfbf60b2bb3ea7af46a442fe0c1a9db412ac37aa1883f9d5d71a57d0be856) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x165b501bbd8ecab6fb1fc175a58b5839ba48142cc81c6e322404fe7d17f4d94e) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x1c6c5cdbdad59b22910e76205d3b52cdd48dc4a342ef8cdf602b594780dde1b2) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x1b77b013f7ec039d03330b40adaa0dbb37e9739a8fcf3f597b32f21d84284bda) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x0129f142f97e86b459671221887dbccafb7be01c23f90a161939e9e26d8af719) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x27ff6e953307d624882dba20af994fc9c11c33492652d11a6ec855b714ed4b99) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x2bef7b1c096ec0286ab6f1913751cd6d0e629cee3a2819a3fd78d5b417b126f5) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1 
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0 
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1 
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0 
            mstore(_omegaInverseLoc, 0x1c4042c7de3c86d66ed809157a2c7f0aed42b68e6e43404ecaa2e1e9b2e5cc71) // vk.work_root_inverse
        }
    }
}
