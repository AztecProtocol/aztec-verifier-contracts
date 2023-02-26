// Verification Key Hash: 687bfadc7876aa32d1e320726bde2f296a42d7057d7a6f047f2572c426153147
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library RecursiveStandardVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0x687bfadc7876aa32d1e320726bde2f296a42d7057d7a6f047f2572c426153147;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000800000) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000010) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x0210fe635ab4c74d6b7bcf70bc23a1395680c64022dd991fb54d4506ab80c59d) // vk.work_root
            mstore(add(_vk, 0x60), 0x30644e121894ba67550ff245e0f5eb5a25832df811e8df9dd100d30c2c14d821) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x2cdbba14b85273f2002c50c2c9766f3127cfface092a8e167e53f519dfe2ec8b) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x1e355b05a1a0fcb0bfbcc1860204643e35070b5c7aed536c550c327c11ed8f4f) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x15ad481d0c9cceb91c09424562856506de09abdf9ef9a836f1f0f7781704f68f) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x11c1dec38c92be1ade3738cc3437c0e7e7eeb71265ad7aee3b37de6d74ec5713) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x2dde590e7cc9ef9d0bdab58f50dab3c64c59e52d0f7b5746318755975ba659bd) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x2f0175ddb245a1f4f993c26de034e8e55135d94d4766082a10920effcc4dc700) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x136987801a1b9c7fe01319ac9c56c019c1c8c8db7e82b56ceac15f98182467dc) // vk.QM.x
            mstore(add(_vk, 0x160), 0x040d81eeb9de8bea58eedcf992a99dd2dfe7bc223f595d22464db106b71d794d) // vk.QM.y
            mstore(add(_vk, 0x180), 0x09096c5316e71f1b64e0f64abb352d5be551123a413b1b9b7f52b11ccb5315f2) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x14e4139f1700e24b458ae2b72b74dcdc542efcdaee77b0dd4c369505551eec1a) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x067a13769eec2b2025f63f8e52e77453f6980e99b5e76f8e448f4e879ab1ae70) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x0bc8f466ca3b038d354ae0d55c24276d177bbc594e55009e797af6e1b03891a9) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x09607358cb523186581a1978a421e657ee0f53f043f6b6ca1d565166419d204c) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x2cca56a985f8f718326fbc581d8315519d86fc1c69bfd90c6badbf954869e327) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x2067ecfe4b2e6fc63c97c6ace7fd6ae714e0533221495df4326cdfc1555c3fd9) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x183a05b991898dbd7ffd9a37dd91a7a09081f36d16f9e2900c8f1654835b6a95) // vk.SIGMA3.y
            mstore(add(_vk, 0x280), 0x01) // vk.contains_recursive_proof
            mstore(add(_vk, 0x2a0), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x2c0), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x2e0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x300), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x320), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x2165a1a5bda6792b1dd75c9f4e2b8e61126a786ba1a6eadf811b03e7d69ca83b) // vk.work_root_inverse
        }
    }
}
