// Verification Key Hash: 63e194aef6054b9f2c5a044fe91ab635d97bab5889d03489f38ae51218b8eb15
// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

library Add2StandardVerificationKey {
    function verificationKeyHash() internal pure returns(bytes32) {
        return 0x63e194aef6054b9f2c5a044fe91ab635d97bab5889d03489f38ae51218b8eb15;
    }

    function loadVerificationKey(uint256 _vk, uint256 _omegaInverseLoc) internal pure {
        assembly {
            mstore(add(_vk, 0x00), 0x0000000000000000000000000000000000000000000000000000000000000200) // vk.circuit_size
            mstore(add(_vk, 0x20), 0x0000000000000000000000000000000000000000000000000000000000000002) // vk.num_inputs
            mstore(add(_vk, 0x40), 0x0f1ded1ef6e72f5bffc02c0edd9b0675e8302a41fc782d75893a7fa1470157ce) // vk.work_root
            mstore(add(_vk, 0x60), 0x304c1c4ba7c10759a3741d93a64097b0f99fce54557c93d8fb40049926080001) // vk.domain_inverse
            mstore(add(_vk, 0x80), 0x23a059d3dbe0ebf2fed046943117dd8fb46899c6d7057988857d6812401f0363) // vk.Q1.x
            mstore(add(_vk, 0xa0), 0x1051aadd0794e93ef4a311f324ab4ea06c455e02caae82959e38ccafa44885e9) // vk.Q1.y
            mstore(add(_vk, 0xc0), 0x02c1c8c139673cffb0e45dadd27db9fa64e82980d0cc6a2919b0b300df7100d1) // vk.Q2.x
            mstore(add(_vk, 0xe0), 0x24e3a78fc2d14a6571c51fac3abd10261897fd95b6bffcbe990fb1cdb6584be4) // vk.Q2.y
            mstore(add(_vk, 0x100), 0x0e478d21deee7e924acc3bc6f339fa74619c8af5785ae4961c5780db5c6366db) // vk.Q3.x
            mstore(add(_vk, 0x120), 0x060f752b1a7be3f69c8a87eb11250c76c2d0e3e20801dcc856f8bacaea63a991) // vk.Q3.y
            mstore(add(_vk, 0x140), 0x1b7ecb10739573853a7e060e5f5cfb96bea06caf91d59b27fe951e622baf0c8c) // vk.QM.x
            mstore(add(_vk, 0x160), 0x1c12c878c1f342c99e074dc650b65338247ae75ed334eca3940110234eb180f8) // vk.QM.y
            mstore(add(_vk, 0x180), 0x216e9bebb05800387cf21e6ce26b2c21813fa88e86df1c3a1c2ba468c9a11352) // vk.QC.x
            mstore(add(_vk, 0x1a0), 0x0d75fb7b6afd475768cf07ad89d75ff87aa0ead74e61c60961180e6682ff9a56) // vk.QC.y
            mstore(add(_vk, 0x1c0), 0x19ee733175072c70bcd8c066a8d8491e0e4c70df3f05b23e55d04ce64a0d17ad) // vk.SIGMA1.x
            mstore(add(_vk, 0x1e0), 0x125af87b1dfd7a32b6da3ddaebd18fd39244741eaae3e6b8bf18a3e18f1a6b32) // vk.SIGMA1.y
            mstore(add(_vk, 0x200), 0x2fa1a2493c4868bd3226161fa471c7c6a0855e68982b086206ad1fed1fc16f72) // vk.SIGMA2.x
            mstore(add(_vk, 0x220), 0x127c30cd177f90874721f19145a880de033dd460061fb68314c2d0e766268b33) // vk.SIGMA2.y
            mstore(add(_vk, 0x240), 0x305a7d46c7cb520b68e77951fa533484753d3e461ad3fd47cfba8d879a092101) // vk.SIGMA3.x
            mstore(add(_vk, 0x260), 0x0c6716b5df6cf0a81a22cfc9ab10872104fdcb5b7f1a3da60d8e63035e7bc3b4) // vk.SIGMA3.y
            mstore(add(_vk, 0x280), 0x00) // vk.contains_recursive_proof
            mstore(add(_vk, 0x2a0), 0) // vk.recursive_proof_public_input_indices
            mstore(add(_vk, 0x2c0), 0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1) // vk.g2_x.X.c1 
            mstore(add(_vk, 0x2e0), 0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0) // vk.g2_x.X.c0 
            mstore(add(_vk, 0x300), 0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4) // vk.g2_x.Y.c1 
            mstore(add(_vk, 0x320), 0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55) // vk.g2_x.Y.c0 
            mstore(_omegaInverseLoc, 0x09d8f821aa9995b3546875d5e4fcfcab4c277a07f0bcc0c852f26c0faf6b3e4e) // vk.work_root_inverse
        }
    }
}
