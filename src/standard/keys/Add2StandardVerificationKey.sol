// Verification Key Hash: e410f39dfc7537f104969e2254484357486d374efc6ac7914495509320be3a19
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2StandardVerificationKey {
    function verificationKeyHash() internal pure returns (bytes32) {
        return 0xe410f39dfc7537f104969e2254484357486d374efc6ac7914495509320be3a19;
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
            mstore(add(_vk, 0x140), 0x0d82d51f2f75d806285fd248c819b82508eb63672a733f20de1a97644be4f540) // vk.QM.x
            mstore(add(_vk, 0x160), 0x06cd3b0e3460533b9e5ea2cdc0fcbbd002f9100cbba8a29f13b11513c53c59d0) // vk.QM.y
            mstore(add(_vk, 0x180), 0x21791de65f9a28ec7024b1a87ab4f3f45ea38a93b2f810c5633ddb54927c1c96) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x29fa14a969c5d81ed3abbbfb11220a926511a0439502c86885a8c6f0327aa7ad) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x17c9af8cf13bae69689dfad7b2b8b877b7e99a7c088559bd8ef9ee1701eff891) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x260e9fb8616972867096fc5eeada74f34c1656d8f93424e4370591920b804d23) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x14ade5ff72bcb07ab6bbabc05c57cb4802c8f00ea90d7c8004f53eacbf57f7ef) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x2cf7179965aade17d9ad8bfc367e257f73236139107c5ab16b607b9b51e1e780) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x006e1982e3892fe7a5b31b81482fcf5c015f0f1496208c393a428a0712bec7fa) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x05b173666aacce76f398c7af1074c81f6d0a2d1cde316f682b6559858e7abc42) // vk.SIGMA3.y
            mstore(add(_vk, 0x280), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x2a0), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x2c0), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1
            mstore(add(_vk, 0x2e0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0
            mstore(add(_vk, 0x300), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1
            mstore(add(_vk, 0x320), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0
            mstore(_omegaInverseLoc, 0x130b17119778465cfb3acaee30f81dee20710ead41671f568b11d9ab07b95a9b) // vk.work_root_inverse
        }
    }
}
