// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4;

/**
 * @title AsmLog
 * @notice A placeholder contract that contains an assembly function to log inside verifier contracts
 * The content is to be included in the verifier contracts as needed. This is a workaround for the
 * lack of a log function in assembly.
 * @dev This contract is not intended to be deployed or used. It is only a placeholder for the assembly
 * If you want to use the logging, copy it inside the assembly scope you need it in.
 */
contract AsmLog {
    function f() public {
        assembly {
            function appendBytes32(input, result) {
                if eq(input, 0x00) {
                    let len := mload(result)
                    mstore(result, add(len, 0x40))
                    mstore(
                        add(add(result, len), 0x20), 0x3030303030303030303030303030303030303030303030303030303030303030
                    )
                    mstore(
                        add(add(result, len), 0x40), 0x3030303030303030303030303030303030303030303030303030303030303030
                    )
                }
                if iszero(eq(input, 0x00)) {
                    let table := 0x15000

                    // Store lookup table that maps an integer from 0 to 99 into a 2-byte ASCII equivalent
                    // Store lookup table that maps an integer from 0 to ff into a 2-byte ASCII equivalent
                    mstore(add(table, 0x1e), 0x3030303130323033303430353036303730383039306130623063306430653066)
                    mstore(add(table, 0x3e), 0x3130313131323133313431353136313731383139316131623163316431653166)
                    mstore(add(table, 0x5e), 0x3230323132323233323432353236323732383239326132623263326432653266)
                    mstore(add(table, 0x7e), 0x3330333133323333333433353336333733383339336133623363336433653366)
                    mstore(add(table, 0x9e), 0x3430343134323433343434353436343734383439346134623463346434653466)
                    mstore(add(table, 0xbe), 0x3530353135323533353435353536353735383539356135623563356435653566)
                    mstore(add(table, 0xde), 0x3630363136323633363436353636363736383639366136623663366436653666)
                    mstore(add(table, 0xfe), 0x3730373137323733373437353736373737383739376137623763376437653766)
                    mstore(add(table, 0x11e), 0x3830383138323833383438353836383738383839386138623863386438653866)
                    mstore(add(table, 0x13e), 0x3930393139323933393439353936393739383939396139623963396439653966)
                    mstore(add(table, 0x15e), 0x6130613161326133613461356136613761386139616161626163616461656166)
                    mstore(add(table, 0x17e), 0x6230623162326233623462356236623762386239626162626263626462656266)
                    mstore(add(table, 0x19e), 0x6330633163326333633463356336633763386339636163626363636463656366)
                    mstore(add(table, 0x1be), 0x6430643164326433643464356436643764386439646164626463646464656466)
                    mstore(add(table, 0x1de), 0x6530653165326533653465356536653765386539656165626563656465656566)
                    mstore(add(table, 0x1fe), 0x6630663166326633663466356636663766386639666166626663666466656666)
                    /**
                     * Convert `input` into ASCII.
                     *
                     * Slice 2 base-10  digits off of the input, use to index the ASCII lookup table.
                     *
                     * We start from the least significant digits, write results into mem backwards,
                     * this prevents us from overwriting memory despite the fact that each mload
                     * only contains 2 byteso f useful data.
                     *
                     */

                    let base := input
                    function slice(v, tableptr) {
                        mstore(0x1e, mload(add(tableptr, shl(1, and(v, 0xff)))))
                        mstore(0x1c, mload(add(tableptr, shl(1, and(shr(8, v), 0xff)))))
                        mstore(0x1a, mload(add(tableptr, shl(1, and(shr(16, v), 0xff)))))
                        mstore(0x18, mload(add(tableptr, shl(1, and(shr(24, v), 0xff)))))
                        mstore(0x16, mload(add(tableptr, shl(1, and(shr(32, v), 0xff)))))
                        mstore(0x14, mload(add(tableptr, shl(1, and(shr(40, v), 0xff)))))
                        mstore(0x12, mload(add(tableptr, shl(1, and(shr(48, v), 0xff)))))
                        mstore(0x10, mload(add(tableptr, shl(1, and(shr(56, v), 0xff)))))
                        mstore(0x0e, mload(add(tableptr, shl(1, and(shr(64, v), 0xff)))))
                        mstore(0x0c, mload(add(tableptr, shl(1, and(shr(72, v), 0xff)))))
                        mstore(0x0a, mload(add(tableptr, shl(1, and(shr(80, v), 0xff)))))
                        mstore(0x08, mload(add(tableptr, shl(1, and(shr(88, v), 0xff)))))
                        mstore(0x06, mload(add(tableptr, shl(1, and(shr(96, v), 0xff)))))
                        mstore(0x04, mload(add(tableptr, shl(1, and(shr(104, v), 0xff)))))
                        mstore(0x02, mload(add(tableptr, shl(1, and(shr(112, v), 0xff)))))
                        mstore(0x00, mload(add(tableptr, shl(1, and(shr(120, v), 0xff)))))
                    }

                    let len := mload(result)
                    mstore(result, add(len, 0x40))
                    slice(base, table)
                    mstore(add(add(len, result), 0x40), mload(0x1e))
                    base := shr(128, base)
                    slice(base, table)
                    mstore(add(add(len, result), 0x20), mload(0x1e))
                }
            }

            function initErrorPtr() -> errorPtr, revertPtr {
                // place this in a memory region we know we will never reach with legit data
                revertPtr := 0x10000
                mstore(revertPtr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(add(revertPtr, 0x04), 0x20)
                mstore(add(revertPtr, 0x24), 0)
                errorPtr := add(revertPtr, 0x24)
            }

            function append0x(stringPtr) {
                let stringLen := mload(stringPtr)
                mstore(add(stringPtr, add(stringLen, 0x20)), "0x")
                mstore(stringPtr, add(stringLen, 2))
            }

            function appendComma(stringPtr) {
                let stringLen := mload(stringPtr)

                mstore(add(stringPtr, add(stringLen, 0x20)), ", ")
                mstore(stringPtr, add(stringLen, 2))
            }

            function err(varA, varB, varC) {
                let errorPtr := 0
                let revertPtr := 0
                // Prettier and forge fmt cannot handle this line below.
                errorPtr, revertPtr := initErrorPtr()
                errorPtr := add(revertPtr, 0x24)
                append0x(errorPtr)
                appendBytes32(varA, errorPtr)
                appendComma(errorPtr)
                append0x(errorPtr)
                appendBytes32(varB, errorPtr)
                appendComma(errorPtr)
                append0x(errorPtr)
                appendBytes32(varC, errorPtr)
                appendComma(errorPtr)
                revert(revertPtr, add(mload(errorPtr), 0x44))
            }
        }
    }
}
