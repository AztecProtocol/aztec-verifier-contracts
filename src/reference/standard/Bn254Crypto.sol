
import {Types} from "./Types.sol";


/// TODO: Create aliases for the field size in the main?
library Bn254Crypto {
    /// @notice the size of the prime field
    uint256 constant p_mod = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
    
    /// @notice the order size of the group
    uint256 constant r_mod = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

    /// @notice The point foes not exist on the G1 curve
    error NotWellFormed(G1Point point);

    /// @notice Perform a modular exponentiation.
    /// @dev Ideal for small exponents. (64 bits or less), it is cheaper than the precompile
    function pow_small(
        uint256 base,
        uint256 exponent,
        uint256 modulus
    ) internal pure returns (uint256) {
        uint256 result = 1;
        uint256 input = base;
        uint256 count = 1;

        assembly {
            let endpoint := add(exponent, 0x01)
            for { } lt(count, endpoint) { } {
                if and(exponent, count) {
                    result := mulmod(result, input, modulus)
                }
                input := mulmod(input, input, modulus)
            }
        }

        return result;
    }

    /// @notice Invert a field element
    /// TODO: double check wording around here
    /// @dev Inverses are used in montgomery multiplication trick
    /// @dev uses the precompile for inversion
    function invert(uint256 fr) internal view returns (uint256) {
        uint256 output;
        bool success;
        uint256 p = r_mod;
        assembly {
            let mPtr := mload(0x40)
            mstore(mPtr, 0x20)
            mstore(add(mPtr, 0x20), 0x20)
            mstore(add(mPtr, 0x40), 0x20)
            mstore(add(mPtr, 0x60), fr)
            mstore(add(mPtr, 0x80), sub(p, 2))
            mstore(add(mPtr, 0xa0), p)
            success := staticcall(gas(), 0x05, mPtr, 0xc0, 0x00, 0x20)
            output := mload(0x00)
        }
        require(success, "pow precompile call failed!");
        return output;
    }
    
    /// @notice create a new G1Point
    /// @dev This method also perform r_mod reduction
    function new_g1(uint256 x, uint256 y)
        internal
        pure
        returns (Types.G1Point memory)
    {
        uint256 xValue;
        uint256 yValue;
        assembly {
            xValue := mod(x, r_mod)
            yValue := mod(y, r_mod)
        }
        return Types.G1Point(xValue, yValue);
    }

    /// @notice create a new G2Point
    function new_g2(
        uint256 x0,
        uint256 x1,
        uint256 y0,
        uint256 y1
    ) internal pure returns (Types.G2Point memory) {
        return Types.G2Point(x0, x1, y0, y1);
    }

    /// @notice Get the generator of G1
    function P1() internal pure returns (Types.G1Point memory) {
        return new_g1(1, 2);
    }

    /// @notice Get the generator of G2
    function P2() internal pure returns (Types.G2Point memory) {
        return
            Types.G2Point({
                x0: 0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2,
                x1: 0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed,
                y0: 0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b,
                y1: 0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa
            });
    }

    /// @notice Evaluate the pairing product
    /// @notice e(a1, a2).e(-b1, b2) == 1
    /// @dev This loads eithersize of the points into memory and calls the ecPairing precompile
    function pairingProd2(
        Types.G1Point memory a1,
        Types.G2Point memory a2,
        Types.G1Point memory b1,
        Types.G2Point memory b2
    ) internal view returns (bool) {
        validateG1Point(a1);
        validateG1Point(b1);
    }
    

    // TODO: maybe just to this in standard solidity rather than all asm
    // Can do that on the second pass through!
    // Maybe making small tests for each point
    // x != 0
    // y != 0
    // x < p
    // y < p
    // y^2 = x^3 + 3 mod p
    function validateG1Point(Types.G1Point memory point) internal pure {
        bool is_well_formed;
        uint256 p = p_mod;

        assembly {
            let x := mload(point)
            let y := mload(add(point, 0x20))

            is_well_formed := and (
                and(and(lt(x, p), lt(y, p)), not(or(iszero(x), iszero(y)))),
                eq(mulmod(y,y,p), addmod(mulmod(x, mulmod(x,x,p), p), 3, p))
            )
        }

        if (!is_well_formed) {
            revert NotWellFormed(point);
        }
    }
}
