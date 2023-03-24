// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

import {TestBase} from "../base/TestBase.sol";
import {RecursiveStandardVerifier} from "../../src/standard/instance/RecursiveStandardVerifier.sol";
import {DifferentialFuzzer} from "../base/DifferentialFuzzer.sol";
import {IVerifier} from "../../src/interfaces/IVerifier.sol";
import {BaseStandardVerifier} from "../../src/standard/BaseStandardVerifier.sol";

contract RecursiveStandardTest is TestBase {
    IVerifier internal verifier;

    // inputs 5, 10, 15
    // proof generated and pasted here as it takes an insane amount of time to generate
    bytes proofData =
        hex"000000000000000000000000000000000000000000000002A5EAF064C236F135000000000000000000000000000000000000000000000001B5054A68EAB93A48000000000000000000000000000000000000000000000009AE62B191F36C187B0000000000000000000000000000000000000000000000000002C6B08871A9A100000000000000000000000000000000000000000000000C43EB74491B3D3E4100000000000000000000000000000000000000000000000DBB31EA6D1A64DA080000000000000000000000000000000000000000000000076AD06F906E6ECCE0000000000000000000000000000000000000000000000000000136C552F12CF10000000000000000000000000000000000000000000000027BB05013A8750E4600000000000000000000000000000000000000000000000CA8D27849A2A2D3B900000000000000000000000000000000000000000000000C90BC45387B9196EB00000000000000000000000000000000000000000000000000013026AA848ECE00000000000000000000000000000000000000000000000C5FD542FAC7D0E7B6000000000000000000000000000000000000000000000003864A81169CF9106500000000000000000000000000000000000000000000000DEA641350A656E0140000000000000000000000000000000000000000000000000001C8CE42AD5AA72C48327CD2C6EA3D605586B3DC2D982135C337355881AC652E1C41D84C2CCD701D53007BCCED78619D98A586D401B6F035C7B772E3871457C7519814BF6EAEAA0984EF71D2490B3D2286C2C68FCB969C442A7E7EF3B34D3350DDE10C449EE8DA1AFD753C896393637219D28B81B89E05BD209C09243898BDD6D9E04E62E901F4047C64A792238D1C141F0573558F7B72553101D277F232128D2539B5589CC8E527312B030A5D883460520D827EC964C8A657B0FD5FA718A9B3B030981BBBDFDE1BA880B4BFE7794EC165BACDAE6796A45CE5E939DCE7086ACED4840A60B174B509B19DE06ACF93302A8F3E5948E61DA5D134184A566DF6153F7D8D12F46D53F007CD5AB23B8A1A727D351ECC13E2DBF6D0D43679CCA2B7052D0D73EDB7B937B7186F3621C5A5564E8CB25515BBA0261126BA30B06F8128B572AFBBF9AB27B63D02D2960BD794E887F14F63E9A1F2E72E83D5034048780053B8A00215FCD53BFD2142510ABADA9AD026B27AB012F506C474AE99E7620F94DC19573A3F67C5176A1BDBDEC7B8C09891651D83A532BE8A66F8BF7350A4832A229A36AC90223CFB861F8874F94B4E03EB74217C0C037652C3BAC5FEC57A589E14132F58D67FE949680FDF8742D6398E07844FAB9555E1B95813CA2313E00D9DF7DB2DB793B9E8C7A81C6EE1FE5419D2909F0F670AEE495408A590D5ACD5DB6CA9562A94D5E62649C12322EC2C255221E721E4BBDC18F0E79C58F26EF07DF85E2F26BD19E60C7D4AB110250FAC6177FDBD8E7C7303FC507CA31BE1E73177F0676272F318076AAB550227F2E4804F614695AA27BE259158BEFB231F532ED184A81C1FCC6759CB3A2FD514D008B71DE595C5886D46FFDCA620D36C66CC2088074499BDC75149081146A80A4F9275A93DC388B3668ACC1D00D341C69CA8EA14CA49156A56CC91C5DD7D3D1939CD888449D527222D4DC10446994BD5AA082C89548433268A5A2C79903DC023AB8586AE7A3F0DF6A775AE0C64CEDCDA5228420F5E05CF3FC4B720A233E14916CFB62AF5CF56898E8B9B976344A5252C030985F07A61FFE2233D07E1213AC6";

    function setUp() public {
        verifier = IVerifier(address(new RecursiveStandardVerifier()));
    }

    function testProof() public {
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, 16);
        assertTrue(verifier.verify(proof, publicInputs), "The proof is not valid");
    }

    function testInvalidRecursiveProofPoint() public {
        _invalidBn128Component(0);
        _invalidBn128Component(4);
        _invalidBn128Component(8);
        _invalidBn128Component(12);
    }

    function _invalidBn128Component(uint256 _index) internal {
        (bytes32[] memory publicInputs, bytes memory proof) = splitProof(proofData, 16);

        uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

        publicInputs[_index] = bytes32((q >> 0) & 0x0fffffffffffffffff);
        publicInputs[_index + 1] = bytes32((q >> 68) & 0x0fffffffffffffffff);
        publicInputs[_index + 2] = bytes32((q >> 136) & 0x0fffffffffffffffff);
        publicInputs[_index + 3] = bytes32((q >> 204) & 0x0fffffffffffffffff);

        vm.expectRevert(abi.encodeWithSelector(BaseStandardVerifier.RECURSIVE_PROOF_INVALID_BN128_G1_POINT.selector));
        verifier.verify(proof, publicInputs);
    }
}
