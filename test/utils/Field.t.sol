// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";

interface IField{
    function invert(uint256 _x, uint256 _mod) external pure returns (uint256 output);
    function fieldpow(uint256 _base, uint256 _exp, uint256 _mod) external pure returns (uint256 result);
    function powSmall(uint256 base, uint256 exponent, uint256 modulus) external  pure returns (uint256);
    function reverse256(uint256 input) external pure returns (uint256 v);
    function extractLimbs(uint256 x) external pure returns (uint256, uint256, uint256, uint256);
    function uint8ArrayToBytes32(uint8[32] memory input) external pure returns (bytes32);
}
interface ISqrt{
    function sqrt(uint256 _x, uint256 _mod) external pure returns (uint256);
}

interface ICommonUtils{
    function log2(uint256 _x) external pure returns (uint256);
}

contract FieldTest is Test {
        IField field;
        ISqrt sqrt;
        ICommonUtils commonUtils;

    function setUp() public {
        string memory field_wrappers = vm.readFile("test/utils/mocks/FieldWrappers.huff");
        field = IField(HuffDeployer.deploy_with_code("utils/Field", field_wrappers));

        string memory sqrt_wrappers = vm.readFile("test/utils/mocks/SqrtWrappers.huff");
        sqrt = ISqrt(HuffDeployer.deploy_with_code("utils/Sqrt", sqrt_wrappers));

        string memory commonUtils_wrappers = vm.readFile("test/utils/mocks/CommonUtilsWrappers.huff");
        commonUtils = ICommonUtils(HuffDeployer.deploy_with_code("utils/CommonUtils", commonUtils_wrappers));
    }

    function testPallasInvertFr() public {
        uint256 pallasScalar = 0x241485a5238caca98c32f3113a90f0fd5e7f62f4caecb639b938d7a0a4e08867;
        uint256 pallasRMod = 28948022309329048855892746252171976963363056481941647379679742748393362948097;
        uint256 inverted = field.invert(pallasScalar, pallasRMod);
        assertEq(bytes32(inverted), bytes32(0x1ec5d74264fcb22d01cb7c46b1f129637e5fd7990100b3b64e7e937360bcbfac));
    }

    function testVestaInvertFr() public {
        /* s/pallas/vesta */
        uint256 vestaScalar = 0x32642babe229d616c0221a7c8fb94f442088f6947752b98115240705ca7d15ec;
        uint256 vestaRMod = 28948022309329048855892746252171976963363056481941560715954676764349967630337;
        uint256 inverted = field.invert(vestaScalar, vestaRMod);
        assertEq(bytes32(inverted), bytes32(0x130b3c43d6025758f4e5ed60d9e70fa5f7f5a40ec523584f696237878975aa6f));
    }

    function testPallasPowSmall() public {
        uint256 base = 0x2bd477403f0713e5b5028dd7b3b0c2a6f21a606ebd5a19a9dd00f7e4149ca4c7;
        uint64 exponent = 12024954401023057353;
        uint256 pallasRMod = 28948022309329048855892746252171976963363056481941647379679742748393362948097;
        uint256 result = field.powSmall(base, exponent, pallasRMod);
        uint256 expected = 0x362242b2a1f2674375360e8398bdab0d1cc56f295be9ac6e39c17bc8bbc4a114;
        assertEq(bytes32(expected), bytes32(result));
    }

    function testVestaPowSmall() public {
        uint256 base = 0x28a66bbc0fd68c99ca92677d02d515daeddcebd8440b568bf32ba9a5d56b37c5;
        uint64 exponent = 771196355631305937;
        uint256 vestaRMod = 28948022309329048855892746252171976963363056481941560715954676764349967630337;
        uint256 result = field.powSmall(base, exponent, vestaRMod);
        uint256 expected = 0x3f0ca3245ac5c4dfe10dce43c1694588c2f4f8bc144bca88ed622987acb8ac25;
        assertEq(bytes32(expected), bytes32(result));
    }
    
    function testSqrt() public view {

        uint256 pallasRMod = 28948022309329048855892746252171976963363056481941560715954676764349967630337;
        uint256 vestaRMod = 28948022309329048855892746252171976963363056481941647379679742748393362948097;

        uint256 smallP = 32183;
        assert((sqrt.sqrt(392, smallP) == 15294) || (sqrt.sqrt(392, smallP) == smallP - 15294));
        assert((sqrt.sqrt(1994, smallP) == 5397) || (sqrt.sqrt(1994, smallP) == smallP - 5397));

        uint256 mediumP = 738283496539;
        assert(
            (sqrt.sqrt(4958723045, mediumP) == 34190259867)
                || (sqrt.sqrt(4958723045, mediumP) == mediumP - 34190259867)
        );
        assert(
            (sqrt.sqrt(619100439513669, mediumP) == 721501758733)
                || (sqrt.sqrt(619100439513669, mediumP) == mediumP - 721501758733)
        );

        assert(
            (
                sqrt.sqrt(39192938138472398475092837459827349058720398457082340503458, pallasRMod)
                    == 6952326682511089053505497910269311565103218810361727881723961806337596520691
            )
                || (
                    sqrt.sqrt(39192938138472398475092837459827349058720398457082340503458, pallasRMod)
                        == pallasRMod - 6952326682511089053505497910269311565103218810361727881723961806337596520691
                )
        );
        assert(
            (
                sqrt.sqrt(8234882384828389199345394599345003450304929342349912032349, vestaRMod)
                    == 12180706984407879127889907639794534706595779502336066753700348335280986255802
            )
                || (
                    sqrt.sqrt(8234882384828389199345394599345003450304929342349912032349, vestaRMod)
                        == vestaRMod - 12180706984407879127889907639794534706595779502336066753700348335280986255802
                )
        );
    }

    function testLog2() public view {
        commonUtils.log2(64);
    }
}