// Verification Key Hash: 0a9345b776c3fabf6ec9df2ee911233de89fe59270e109c033e395dcfb217f5a
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library RecursiveUltraVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0x0a9345b776c3fabf6ec9df2ee911233de89fe59270e109c033e395dcfb217f5a;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000080000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000010) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x2260e724844bca5251829353968e4915305258418357473a5c1d597f613f6cbd) // vk.work_root
            mstore(add(_vk, 0x60), 0x3064486657634403844b0eac78ca882cfd284341fcb0615a15cfcd17b14d8201) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x18651374a581144d522f744ab91ef438b661c4610e255a55652eb1bbcd2ac6d2) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x25e30789ccc02e8bd9641ff517e8846150774c6e5a9ba8488e52577d9519f651) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x0a3b06084b8c5d2f76b8fbfc013edfb063e6671180ce0dcbd1b6a8246950e2c4) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x173fbce33b481122e58e82df2d3147bc3d7592cb46c786c537a2c34a14c716e4) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x2f49f8e030c864ee2e9d4d5d91bd6004561b804e9fd6c6a83e5d0321be3f3cf8) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x295a53a8c76f31aab7ec529c7f444a7530ec4d35b95ea4479c713de99e2c3cb7) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x1dd62c31d1bbfebdb2498d4abd4226a15fa97618e86c5d3beb315c927cc445f7) // vk.Q4.x
            mstore(add(_vk, 0x160), 0x2d0d045bc57089dfac7ae2a9bc8e24843d17e0eb00cc14b2f4e5eceac79593da) // vk.Q4.y
            mstore(add(_vk, 0x180), 0x230ffd55b219aed44d146fb456a883838cefce518b1d2ff4fb762ed7adc2953c) // vk.Q_M.x
            mstore(add(_vk, 0x1a0), 0x03eae9e480ec22d10151262a68fb4de84f2bed619e171de0edbfbeb477e8419b) // vk.Q_M.y
            mstore(add(_vk, 0x1c0), 0x25a36db38017650b70ac37c39f2f37ea8dba08f230bbcadd8c3faf8a02d03584) // vk.Q_C.x
            mstore(add(_vk, 0x1e0), 0x096b048e2dbffc49ec31a6d3cb278cfbce9656821a362942ee8f3d5059b13c27) // vk.Q_C.y
            mstore(add(_vk, 0x200), 0x30282b4923b5690c3f80ec0be1987f235a226d087156c177f459d21ea779e372) // vk.Q_ARITHMETIC.x
            mstore(add(_vk, 0x220), 0x1df7fc208d23db6a696e96524001680a37b62066b5225c43b78652c0c40d622f) // vk.Q_ARITHMETIC.y
            mstore(add(_vk, 0x240), 0x0dd699f2462ad6fba6156f27a1023721ef973ca8a0773099cb79ece728449ce3) // vk.QSORT.x
            mstore(add(_vk, 0x260), 0x1233c5d80d69a21e71f654ab634af428472458e371be1574bf6b3fb780d9aced) // vk.QSORT.y
            mstore(add(_vk, 0x280), 0x03bec5c9693cba9a4af95f066604f1b7fee38c9f280614f16e6041745d5b1ea2) // vk.Q_ELLIPTIC.x
            mstore(add(_vk, 0x2a0), 0x04dd5aa0359ccbd61c574c79cac545ea23c0175ae00f15e7a3865cf37a768143) // vk.Q_ELLIPTIC.y
            mstore(add(_vk, 0x2c0), 0x16c4fd2403b2172195bf0e3658e020fd8834aafbc847448fbd8c9139cb9e30e6) // vk.Q_AUX.x
            mstore(add(_vk, 0x2e0), 0x06186e3fb66b78d9cefd89a014c58bf62ea3f684dbb491e88dd2731f19b8f999) // vk.Q_AUX.y
            mstore(add(_vk, 0x300), 0x1b748107a1f31b4a322bfe83c1279e4d9119b7bac13ff7e1f5f0ccad65cc5121) // vk.SIGMA1.x
            mstore(add(_vk, 0x320), 0x17b62c63c51fb477ccd163737dc52adc1dcb6a374975fa9ac0df7cfca2567782) // vk.SIGMA1.y
            mstore(add(_vk, 0x340), 0x1b5af208bc74e0d8846dd8a006dc897b1b5f9d2a559ffeead729e1f32f6d676f) // vk.SIGMA2.x
            mstore(add(_vk, 0x360), 0x29ecc45308cd7119b7d1063a040f0229e18afbbadfdb584bce66cc11db90dfcc) // vk.SIGMA2.y
            mstore(add(_vk, 0x380), 0x00567dc3e1b0ecf080af99b578562ec165a7ff0702e4b1caa9f96c56292fefa2) // vk.SIGMA3.x
            mstore(add(_vk, 0x3a0), 0x2bb0107beb0273a8f9cd5b1204aedec2b5f4bfae0cf9d4e120023597c6339144) // vk.SIGMA3.y
            mstore(add(_vk, 0x3c0), 0x2d8b48a0e713577ce139d79910120f6ea66a87db2d69636529061cbf17a9a862) // vk.SIGMA4.x
            mstore(add(_vk, 0x3e0), 0x09dc0e13f3dbb539dc518eb055aaabc954442a17d54c1e74a73b66bf83da4460) // vk.SIGMA4.y
            mstore(add(_vk, 0x400), 0x2f61a890b9f1dff4ef5c8b0eafe9b71c7a23dc4c8a6791d9c01418310f4a7b2e) // vk.TABLE1.x
            mstore(add(_vk, 0x420), 0x07c8a51d1881fcdfe1cb7dcefc48a44047c7f5386797d5f8553ce2e12e8daba0) // vk.TABLE1.y
            mstore(add(_vk, 0x440), 0x1adf56913dea23b7b14c952933b0b40fc476dc2697a758ec9df73802b0596c2f) // vk.TABLE2.x
            mstore(add(_vk, 0x460), 0x212a1759e19285a35a70a245cca6477f89b6f156e4425cf52cfccb4594f59152) // vk.TABLE2.y
            mstore(add(_vk, 0x480), 0x1527f8c19085ac209ebddbccae4dd0ca58b078e56fd20d651ce3a3194697b191) // vk.TABLE3.x
            mstore(add(_vk, 0x4a0), 0x02247dca9c3cb09318aa6100a2a7c628281c69bc41cfda34aa72c263b69344b4) // vk.TABLE3.y
            mstore(add(_vk, 0x4c0), 0x12eea56d2ada3befa5db215ea5ebbd37b5ce95fcd1cf7adb94d5a1784876b4f7) // vk.TABLE4.x
            mstore(add(_vk, 0x4e0), 0x190df1146fbdd5cc79e8817ebcd6311e35cf5cc38795cee26371a707d685e05a) // vk.TABLE4.y
            mstore(add(_vk, 0x500), 0x1d46eb4d38367acfa8dd12e87ac861e4ce62de175e9a9518567939d1ccf5e8aa) // vk.TABLE_TYPE.x
            mstore(add(_vk, 0x520), 0x2253f9a9d40ad2cec0cc92e8dd05edff642cfb5a5dc651b35e66618fc163d98f) // vk.TABLE_TYPE.y
            mstore(add(_vk, 0x540), 0x1e114f21d183dd2205b1498ccf35bcab40988c2cadbeac4f3ba11aacb5e04d7c) // vk.ID1.x
            mstore(add(_vk, 0x560), 0x153e91c4df59576b85d65a13f0f42b270d29fa29c5fb3afcb63869c81338831b) // vk.ID1.y
            mstore(add(_vk, 0x580), 0x2fd8595f0dec28ab18acc5c5f9f21d9f11453f9ab559a6dd697ae7fb817efbbf) // vk.ID2.x
            mstore(add(_vk, 0x5a0), 0x13e90d3f8751744e9342a8a4118721e9291d848f4ffaf6ba6a080b27d6fe43e2) // vk.ID2.y
            mstore(add(_vk, 0x5c0), 0x0ac6eff083baddc435fb7eac05242c18848862ae5112cb32e3f1915990a005dd) // vk.ID3.x
            mstore(add(_vk, 0x5e0), 0x1c900f035471e8cce4c8c1aa131acc0377c899e4e00ceb0fe257838e58e42dbc) // vk.ID3.y
            mstore(add(_vk, 0x600), 0x2d8bf9cea2f3c9a3766df0e15e4f2fa07487fc5179fa58cafe8f4df420259460) // vk.ID4.x
            mstore(add(_vk, 0x620), 0x07ed23e44953aa6681ead4cd5a8fc5c705653513aa74e4fc029e04e37aa5b93d) // vk.ID4.y
            mstore(add(_vk, 0x640), 0x01) // vk.contains_recursive_proof
            mstore(add(_vk, 0x660), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x680), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x6a0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x6c0), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x6e0), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x06e402c0a314fb67a15cf806664ae1b722dbc0efe66e6c81d98f9924ca535321) // vk.work_root_inverse
        }
    }
}
