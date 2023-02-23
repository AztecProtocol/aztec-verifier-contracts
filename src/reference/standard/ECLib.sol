// TODO: should i consolidate this with the Bn254 Crypto files?
import {Types} from "./Types.sol";

function mul(Types.G1Point point, uint256 scalar) internal returns (Types.G1Point) {
    uint256[4] memory input;
    input[0] = point.x;
    input[1] = point.y;
    input[2] = scalar;

    uint256[2] memory out;
    bool success;
    assembly {
        success := staticcall(gas(), 7, input, 0x80, out, 0x40)
    }
    // TODO: custom error?
    if (!success) revert ECMUL_FAILURE();

    //TODO refactor
    return Types.G1Point(out[0], out[1]);
}

function add(Types.G1Point a, Types.G1Point b) internal returns (Types.G1Point) {
    uint256[4] memory input;
    input[0] = a.x;
    input[1] = a.y;
    input[2] = b.x;
    input[3] = b.y;

    uint256[2] memory out;
    bool success;
    assembly {
        success := staticcall(gas(), 6, input, 0x80, out, 0x40)
    }
    // TODO: custom error?
    if (!success) revert ECMUL_FAILURE();

    //TODO refactor
    return Types.G1Point(out[0], out[1]);
}

/// [0; 31] (32 bytes)      x1
/// [32; 63] (32 bytes)     y1
/// [64; 95] (32 bytes)     x3
/// [96; 127] (32 bytes     x2
/// [128; 159] (32 bytes    y3
/// [160; 191] (32 bytes)   y2
// TODO: convert this into standard sol if possible
function pairing(
    Types.G1Point memory lhs,
    Types.G1Point memory rhs,
    Types.VerificationKey memory vk
) {
    bool success = false;
    assembly {
        mstore(0x00, rhs.x)
        mstore(0x20, rhs.y)
        // TODO: use g2 point from the library gen instead
        mstore(0x40, 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2) // this is [1]_2
        mstore(0x60, 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed)
        mstore(0x80, 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b)
        mstore(0xa0, 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa)

        mstore(0xc0, lhs.x)
        mstore(0xe0, lhs.y)
        mstore(0x100, vk.g2.x0)
        mstore(0x120, vk.g2.x1)
        mstore(0x140, vk.g2.y0)
        mstore(0x160, vk.g2.y1)

        success := staticcall(gas(), 8, 0x00, 0x180, 0x00, 0x20)
    }
    if (!success) revert ECPAIRING_FAILURE();
}

/// @notice this assumes that all of the inputs are 1 word long 32 bytes
function modexp(
    uint256 base, 
    uint256 exponent,
    uint256 p
) returns (uint256 result) {

    bool success = false;
    assembly {
        ptr := mload(0x40)
        mstore(ptr, 0x20)
        mstore(add(ptr, 0x20), 0x20)
        mstore(add(ptr, 0x40), 0x40)
        mstore(add(ptr, 0x60), base)
        mstore(add(ptr, 0x80), exponent)
        mstore(add(ptr, 0xa0), p)
        success := staticcall(gas(), 0x05, ptr, 0xc0, 0x00, 0x20)

    }
    if (!success) revert MODEXP_FAILURE();
    
    // Return the result
    assembly {
        result := mload(0x00)
    }
}