// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.5.10;

import "ds-test/test.sol";
import {DSValue} from "ds-value/value.sol";

import "./mosm.sol";

interface Hevm {
    function warp(uint256) external;
}

contract Unauthorized {
    Mosm m;
    constructor(Mosm m_) public {
        m = m_;
    }
    function doMedianPeek() public view returns (uint256,bool) {
        return m.median_peek();
    }
    function doPeep() public view returns (bytes32,bool) {
        return m.peep();
    }
    function doOsmPeek() public view returns (bytes32,bool) {
        return m.peek();
    }
}

contract TestMosmETHUSD is Mosm {
    bytes32 public constant wat = "ETHUSD";

    function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        return ecrecover(
            keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
            v, r, s
        );
    }
}

contract MosmTest is DSTest {
    TestMosmETHUSD mosm;
    Unauthorized u;
    Hevm hevm;
    uint256 testprice = 258000000000000000000;

    function setUp() public {
        mosm = new TestMosmETHUSD();
        u = new Unauthorized(mosm);
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    }

    function medianInit() public returns
        (address[] memory, uint256[] memory, uint256[] memory, bytes32[] memory, bytes32[] memory, uint8[] memory) {

        address[] memory orcl = new address[](15);
        uint256[] memory price = new uint256[](15);
        uint256[] memory ts = new uint256[](15);
        bytes32[] memory r = new bytes32[](15);
        bytes32[] memory s = new bytes32[](15);
        uint8[] memory v = new uint8[](15);

        // ----------- accounts:
        orcl[0] = address(0xD62F2495678F4Ecd0db1730ebe07B6D21FF76397);
        orcl[1] = address(0x22C5f295a5E5d16034A76d72eCA89Fe2a5433Da1);
        orcl[2] = address(0x32DDb3c008FD5c2b10c8911893C8D7B5F3d313eD);
        orcl[3] = address(0x9aE2A121803472837250ba9EC584fAaf2696E6d7);
        orcl[4] = address(0x9b941A934309a272Ded4Fbf7fEDCdF2976d3729D);
        orcl[5] = address(0x383DE40590D357dB29d6B3502c92536FBB08d716);
        orcl[6] = address(0xbd2dC7A99c8A35955D36a30a2b763E9a23375484);
        orcl[7] = address(0x20c7b8bb91068cEfF199b8Df184AD432Fcb2811B);
        orcl[8] = address(0xd56e1469898c49cbE856FFE55988392030deA579);
        orcl[9] = address(0x61244679E3bbC629e9bDb46bDd4f665da6B7c2C1);
        orcl[10] = address(0x51d946B3392faF34823B5440A5b066Bb6fa41cAD);
        orcl[11] = address(0xCc9C477562cD82fD7A14b48b98fd78c3FBf82F39);
        orcl[12] = address(0x4495a0b4188949c98e8e1F14FeCB32529d5Ca192);
        orcl[13] = address(0x6faED1C635Af2954caD8e08f12c8722c4bdF1F31);
        orcl[14] = address(0xcfdFAC3A09a304F369B044d6b6cEE58428dF1563);
        // ----------- prices:
        price[0] = uint256(0x00000000000000000000000000000000000000000000000d9b5322251f0c0000);
        price[1] = uint256(0x00000000000000000000000000000000000000000000000da933d8d8c6700000);
        price[2] = uint256(0x00000000000000000000000000000000000000000000000db7148f8c6dd40000);
        price[3] = uint256(0x00000000000000000000000000000000000000000000000dc4f5464015380000);
        price[4] = uint256(0x00000000000000000000000000000000000000000000000dd2d5fcf3bc9c0000);
        price[5] = uint256(0x00000000000000000000000000000000000000000000000de0b6b3a764000000);
        price[6] = uint256(0x00000000000000000000000000000000000000000000000dee976a5b0b640000);
        price[7] = uint256(0x00000000000000000000000000000000000000000000000dfc78210eb2c80000);
        price[8] = uint256(0x00000000000000000000000000000000000000000000000e0a58d7c25a2c0000);
        price[9] = uint256(0x00000000000000000000000000000000000000000000000e18398e7601900000);
        price[10] = uint256(0x00000000000000000000000000000000000000000000000e261a4529a8f40000);
        price[11] = uint256(0x00000000000000000000000000000000000000000000000e33fafbdd50580000);
        price[12] = uint256(0x00000000000000000000000000000000000000000000000e41dbb290f7bc0000);
        price[13] = uint256(0x00000000000000000000000000000000000000000000000e4fbc69449f200000);
        price[14] = uint256(0x00000000000000000000000000000000000000000000000e5d9d1ff846840000);
        // -------------- age, a.k.a. ts:
        ts[0] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[1] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[2] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[3] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[4] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[5] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[6] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[7] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[8] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[9] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[10] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[11] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[12] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[13] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        ts[14] = uint256(0x00000000000000000000000000000000000000000000000000000000636a96dc);
        // ---------------- r:
        r[0] = bytes32(0x35d8f64caa0e32b877e8aeb143eac00cc372b578bef8e2d7e5c2c495f91edf05);
        r[1] = bytes32(0x61dd79d54157ef0fc5dabea67b59b67a2dbd2024136700491bccaad7c8942315);
        r[2] = bytes32(0x4290177bb69c6dc6257b3e9bebb439763533dadb13d2b1d2f99ef56e25f7e79f);
        r[3] = bytes32(0xa86bfdeda25efdbb10528fa7612c7cf2159708c5ed0aa6e436c26f3837e1bf5b);
        r[4] = bytes32(0x00627cc3ff9a5db1ace41c03f49dd4b35e090b27629627a49ec07a244cfa7e8d);
        r[5] = bytes32(0x7094cf2f991d6abade7182b317075c0c594a7bf4ca5ec031e5b25eb567b4419b);
        r[6] = bytes32(0x6713f7367c5264624582209941cf9de2b2e11dbd0581baefc7883c116259d8b1);
        r[7] = bytes32(0x2490aa0a79c578570ab7306d2c3c81d74aa33c008394395c58accb1f3a8681c2);
        r[8] = bytes32(0x60e8e1442ab1576d3b4d6f3ff254010e01bb659c39841741d2d1e2b25b7a79d2);
        r[9] = bytes32(0x8d9b17bc997674e45d57834a79b5f3f8154c74b85bad23260411c32b899a9826);
        r[10] = bytes32(0x0af236ad575937cf5d8e5ce9215d66361721d18e5e9e84dec1f258a359e26aec);
        r[11] = bytes32(0xd3797829d7510f31c4ad7db5d55f1a1a9660277c16d076b2f0b78553c9a9d315);
        r[12] = bytes32(0xe7a78c87859fa1463c801d7386f508f52be2e25b438234286d06094b621ef73f);
        r[13] = bytes32(0xbac53afc5b42994aaae80b5330fdf303635c832cbd7c20ba562b02157f3579d6);
        r[14] = bytes32(0x278fd8ac65e64234fb5c71a8282eb7b880ebffcf713ad861c54e6826b2aadc2a);
        // ---------------- s:
        s[0] = bytes32(0x1e70eda8837472027f3b32565ceb8788f34ef90204d41037991aefb04a98fed2);
        s[1] = bytes32(0x1bc7bc92f764f1afd24b2cd3028ce4b87a40d23f9cb6e8159ed76ddb87c41228);
        s[2] = bytes32(0x2024c87bb867a4ac8f73d67eb0b43dae5d463ee2b180e5cc1cb2def7c1c5e396);
        s[3] = bytes32(0x0790d6023236deeb8f9e27f5624bb3bbe23b68d85886a59d0f86b718985d4343);
        s[4] = bytes32(0x31fee84b7ef4176a50f46076af0ddb9d096467bd3e29c7a0a26905b896006b7d);
        s[5] = bytes32(0x06078ac05248dfb7a6263cbe7a6ca6a04546df93e67be77533606fee82cfe829);
        s[6] = bytes32(0x7dcd976bc9d89380b6d6eced67972649390ec2b6324d8ed0e8bc715cd07283d4);
        s[7] = bytes32(0x0355c13dd52ccdc86a05efc4b7cc122ec78a6a785450166509f8e436a2e05db8);
        s[8] = bytes32(0x7a397ca32b3e440a85f7cc888c5d4916492abcf562124d584a19ecae25a30fed);
        s[9] = bytes32(0x788ef8eb29d57c8b1bef76313b0b7074e3534b824450df359f57c8b8bf7ec9fc);
        s[10] = bytes32(0x6f11acc6d2691cbab5e25c8f467e6dc731ab14a5f9a5f1d4d925ea961bb940a8);
        s[11] = bytes32(0x5d00a36c35ec82ba5b43d5ce960da016575a440fa4b140f0da03794c1f74580c);
        s[12] = bytes32(0x084bf94357729448a92c1c4e44fffa6269c780896565b529dde9f4e9d3cea7e4);
        s[13] = bytes32(0x5080d8cac0c096860e570bfa12fb38cf75b6eeb8b3a84dc05a424cae099f6201);
        s[14] = bytes32(0x7221e1685e3c594e8172c6fb38f397414b59b48a25051763a6bec9c1bca6c387);
        // ---------------- v:
        v[0] = uint8(0x1c);
        v[1] = uint8(0x1c);
        v[2] = uint8(0x1b);
        v[3] = uint8(0x1c);
        v[4] = uint8(0x1b);
        v[5] = uint8(0x1c);
        v[6] = uint8(0x1c);
        v[7] = uint8(0x1b);
        v[8] = uint8(0x1c);
        v[9] = uint8(0x1b);
        v[10] = uint8(0x1b);
        v[11] = uint8(0x1b);
        v[12] = uint8(0x1b);
        v[13] = uint8(0x1c);
        v[14] = uint8(0x1c);

        mosm.setBar(15);
        mosm.lift(orcl);

        return (orcl, price, ts, r, s, v);
    }

    function medianInit2() public returns
        (address[] memory, uint256[] memory, uint256[] memory, bytes32[] memory, bytes32[] memory, uint8[] memory) {

        address[] memory orcl = new address[](15);
        uint256[] memory price = new uint256[](15);
        uint256[] memory ts = new uint256[](15);
        bytes32[] memory r = new bytes32[](15);
        bytes32[] memory s = new bytes32[](15);
        uint8[] memory v = new uint8[](15);

        // ----------- accounts:
        orcl[0] = address(0xD62F2495678F4Ecd0db1730ebe07B6D21FF76397);
        orcl[1] = address(0x22C5f295a5E5d16034A76d72eCA89Fe2a5433Da1);
        orcl[2] = address(0x32DDb3c008FD5c2b10c8911893C8D7B5F3d313eD);
        orcl[3] = address(0x9aE2A121803472837250ba9EC584fAaf2696E6d7);
        orcl[4] = address(0x9b941A934309a272Ded4Fbf7fEDCdF2976d3729D);
        orcl[5] = address(0x383DE40590D357dB29d6B3502c92536FBB08d716);
        orcl[6] = address(0xbd2dC7A99c8A35955D36a30a2b763E9a23375484);
        orcl[7] = address(0x20c7b8bb91068cEfF199b8Df184AD432Fcb2811B);
        orcl[8] = address(0xd56e1469898c49cbE856FFE55988392030deA579);
        orcl[9] = address(0x61244679E3bbC629e9bDb46bDd4f665da6B7c2C1);
        orcl[10] = address(0x51d946B3392faF34823B5440A5b066Bb6fa41cAD);
        orcl[11] = address(0xCc9C477562cD82fD7A14b48b98fd78c3FBf82F39);
        orcl[12] = address(0x4495a0b4188949c98e8e1F14FeCB32529d5Ca192);
        orcl[13] = address(0x6faED1C635Af2954caD8e08f12c8722c4bdF1F31);
        orcl[14] = address(0xcfdFAC3A09a304F369B044d6b6cEE58428dF1563);
        // ----------- prices:
        price[0] = uint256(0x00000000000000000000000000000000000000000000000579a814e10a740000);
        price[1] = uint256(0x0000000000000000000000000000000000000000000000058788cb94b1d80000);
        price[2] = uint256(0x00000000000000000000000000000000000000000000000595698248593c0000);
        price[3] = uint256(0x000000000000000000000000000000000000000000000005a34a38fc00a00000);
        price[4] = uint256(0x000000000000000000000000000000000000000000000005b12aefafa8040000);
        price[5] = uint256(0x000000000000000000000000000000000000000000000005bf0ba6634f680000);
        price[6] = uint256(0x000000000000000000000000000000000000000000000005ccec5d16f6cc0000);
        price[7] = uint256(0x000000000000000000000000000000000000000000000005dacd13ca9e300000);
        price[8] = uint256(0x000000000000000000000000000000000000000000000005e8adca7e45940000);
        price[9] = uint256(0x000000000000000000000000000000000000000000000005f68e8131ecf80000);
        price[10] = uint256(0x000000000000000000000000000000000000000000000006046f37e5945c0000);
        price[11] = uint256(0x000000000000000000000000000000000000000000000006124fee993bc00000);
        price[12] = uint256(0x0000000000000000000000000000000000000000000000062030a54ce3240000);
        price[13] = uint256(0x0000000000000000000000000000000000000000000000062e115c008a880000);
        price[14] = uint256(0x0000000000000000000000000000000000000000000000063bf212b431ec0000);
        // -------------- age, a.k.a. ts:
        ts[0] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[1] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[2] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[3] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[4] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[5] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[6] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[7] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[8] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[9] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[10] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[11] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[12] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[13] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        ts[14] = uint256(0x00000000000000000000000000000000000000000000000000000000636a9841);
        // ---------------- r:
        r[0] = bytes32(0x2f0752d9139a506189898fb78d66b42ba1d7702af434eec660fe758f7c2d44fe);
        r[1] = bytes32(0x63ddbb97f1700fc1b5e4fb48d0257e3b5e3cb0d64c473319307f84cd291577e3);
        r[2] = bytes32(0x78b7abae63b92e177561538cd2eced01a982d5623a74a096d27d5a88dfef6188);
        r[3] = bytes32(0xa8a4715642f98548fecbb8748c2f00dde243b634daad7f19695c6f7dd0ab7a6d);
        r[4] = bytes32(0x3bbe0e1a85f7a4de9379779761c9ff886ad4dd07b8e7e129b6f2afde3b3e9649);
        r[5] = bytes32(0x575c7b7aa1cf8ee648e0297a747e9eb257747d828598ba2e10baed3e91f18c93);
        r[6] = bytes32(0x2ea806822997fddccc8be5f632a4c92ce14dc40d8087a65e1a176c0412a227b7);
        r[7] = bytes32(0x6bc08172e8b5ffb9707c19bc30ff6c99e26e0158dcb80959b48a576ef5e08e51);
        r[8] = bytes32(0x10e6da16e8cea4603b2cb346a8e108c694430f6687538eb72ea7078732b35724);
        r[9] = bytes32(0x9f2f2f8d0c935fe9ec619c3b4149d2344d40a1c8369e65a90870e9addd34a85f);
        r[10] = bytes32(0xfe8db536234d1d09311af5496ab4e8e351608fb28294ff8ed36dc04e7862a234);
        r[11] = bytes32(0xd5e55d8be3e271d0c4ee850174050e2c362f73e17e194fe3a1a7244b6b901007);
        r[12] = bytes32(0xcc59240697e154f0298ba1a88fd7135c877c4e3bd839fa2c85f5ead778125ca4);
        r[13] = bytes32(0xa9a07954f91b470de8739ede8386688be788a1581457011f5b141b0b1efd50cf);
        r[14] = bytes32(0x35912a18b88696397536141da5c8ef4a0e2a327c5cef013288172930a86846bb);
        // ---------------- s:
        s[0] = bytes32(0x23e7a51a54a0af41b519f8f29dd2392ce9acdeedf8c770c0f65f37df9435fe08);
        s[1] = bytes32(0x435fc6e5bfa655a644d9470835e4a87d27216f3da70feefbc0ffd158313765f1);
        s[2] = bytes32(0x2a2a66c45b5054224e87379b9bc91dcb68daccbde96ca73cf7aecb8ef42d3151);
        s[3] = bytes32(0x3426d992396741b8289a2a950e91598892074208b0523bf08fac64901a8a2764);
        s[4] = bytes32(0x046316e4a2b2452195a5c73ce4cc0ca51ba8f444756e3fe2d1e93d4741131fdc);
        s[5] = bytes32(0x4ae952658ae6b3d3966b6e208e402b1ea09bb1812f6ca11892e78bf65e4a126f);
        s[6] = bytes32(0x4a3d85faf2c24914bb873e1faca7fd37107d7ac4e634ef6f9a685214df4f54aa);
        s[7] = bytes32(0x29f9028546a6a904f37f89094fd007c289718b40a66276773b7865c8b7d36003);
        s[8] = bytes32(0x775257fa79d2034e8fc601b9e0834dff6f842450bc9496f59c2bd5d7d0fff9b6);
        s[9] = bytes32(0x42438e1d3698fd7176c3a3f275e9774e302772bbf46d42390e9d37c288743aec);
        s[10] = bytes32(0x7a224af42d043885506166c08b98148e9d39ecbe9bad4d67325e5028de07fe1b);
        s[11] = bytes32(0x2d237ccdcc7a3a8cd3f5224ed132ef94d8448f452f677eda9a67a46a904e9cbd);
        s[12] = bytes32(0x3e2c8eebab48a3b6880fc9cf67ecce6a7615885818e97b1f44a95d8261396c47);
        s[13] = bytes32(0x596a4c9af5fabc756f0b9fe6b123c33c032ff11a6a1d53a9bc8f751e4eb68f66);
        s[14] = bytes32(0x427ae701125ccf0c99d087cdcd111089591a7f36ca1c6633cae453db7efc6d0d);
        // ---------------- v:
        v[0] = uint8(0x1b);
        v[1] = uint8(0x1b);
        v[2] = uint8(0x1c);
        v[3] = uint8(0x1b);
        v[4] = uint8(0x1b);
        v[5] = uint8(0x1b);
        v[6] = uint8(0x1c);
        v[7] = uint8(0x1b);
        v[8] = uint8(0x1c);
        v[9] = uint8(0x1b);
        v[10] = uint8(0x1b);
        v[11] = uint8(0x1c);
        v[12] = uint8(0x1c);
        v[13] = uint8(0x1c);
        v[14] = uint8(0x1b);

        mosm.setBar(15);
        mosm.lift(orcl);

        return (orcl, price, ts, r, s, v);
    }

    function testMedianSlot() public {
        address[] memory a = new address[](1);
        a[0] = address(0x0a00000000000000000000000000000000000000);
        address[] memory b = new address[](1);
        b[0] = address(0x0B00000000000000000000000000000000000000);
        mosm.lift(a);
        mosm.lift(b);
        mosm.drop(a);
        mosm.lift(a);
    }

    function testFailMedianSlot() public {
        address[] memory a = new address[](1);
        a[0] = address(0x0a00000000000000000000000000000000000000);
        address[] memory b = new address[](1);
        b[0] = address(0x0A11111111111111111111111111111111111111);
        mosm.lift(a);
        mosm.lift(b);
    }

    function testMedian() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();

        // Whitelist addresses
        address[] memory f = new address[](2);
        f[0] = address(this);
        f[1] = address(u);
        mosm.median_kiss(f);

        // Poke median price
        uint256 gas = gasleft();
        mosm.poke(price, ts, v, r, s);
        gas = gas - gasleft();
        emit log_named_uint("gas", gas);
        (uint256 val, bool ok) = mosm.median_peek();
        uint256 val_osm_check = val;

        // Verify whitelisted can read
        emit log_named_decimal_uint("median", val, 18);
        (val, ok) = u.doMedianPeek();
        assertTrue(ok);

        // Update OSM and verify it matches median
        hevm.warp(uint(mosm.hop()));
        mosm.poke();
        bytes32 bval;
        (bval, ok) = mosm.peek();
        assertTrue(uint256(bval) == 0);
        (bval, ok) = mosm.peep();
        assertTrue(uint256(bval) == testprice);

        hevm.warp(uint(mosm.hop())*2+1);
        mosm.poke();
        (bval, ok) = mosm.peek();
        assertTrue(ok);
        assertTrue(val_osm_check == uint256(bval));
    }

    function testFailMedianPoke() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();

        price[7] = 0x1; // Alter one of the prices
        mosm.poke(price, ts, v, r, s);
    }

    // OSM tests pulled from https://github.com/makerdao/osm/blob/master/src/osm.t.sol
    function testOsmSetHop() public {
        assertEq(uint(mosm.hop()), 3600);
        mosm.step(uint16(7200));
        assertEq(uint(mosm.hop()), 7200);
    }

    function testFailOsmSetHopZero() public {
        mosm.step(uint16(0));
    }

    function testOsmVoidAndPoke() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();
        mosm.poke(price, ts, v, r, s);

        assertTrue(mosm.stopped() == 0);

        // Initial OSM poke, current value is 0, next value is Median
        hevm.warp(uint(mosm.hop()));
        mosm.poke();
        (bytes32 val, bool has) = mosm.peek();
        assertEq(uint(val), 0);
        assertTrue(!has);

        (val, has) = mosm.peep();
        assertEq(uint(val), testprice);
        assertTrue(has);

        // Second OSM poke, current value is Median
        hevm.warp(uint(mosm.hop() * 2));
        mosm.poke();
        (val, has) = mosm.peek();
        assertEq(uint(val), testprice);
        assertTrue(has);

        mosm.void();
        assertTrue(mosm.stopped() == 1);
        (val, has) = mosm.peek();
        assertEq(uint(val), 0);
        assertTrue(!has);
        (val, has) = mosm.peep();
        assertEq(uint(val), 0);
        assertTrue(!has);
    }

    function testFailOsmPoke() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();
        mosm.poke(price, ts, v, r, s);

        mosm.poke();
        hevm.warp(uint(mosm.hop() - 1));
        mosm.poke();
    }

    function testFailOsmWhitelistPeep() public view {
        u.doPeep();
    }

    function testOsmWhitelistPeep() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();
        mosm.poke(price, ts, v, r, s);

        hevm.warp(uint(mosm.hop()));
        mosm.poke();
        (bytes32 val, bool has) = mosm.peek();
        assertEq(uint(val), 0);
        assertTrue(!has);

        mosm.kiss(address(u));
        (val, has) = u.doPeep();
        assertEq(uint(val), testprice);
        assertTrue(has);
    }

    function testFailOsmWhitelistPeek() public view {
        u.doOsmPeek();
    }

    function testOsmWhitelistPeek() public {
        (, uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();

        mosm.poke(price, ts, v, r, s);
        hevm.warp(uint(mosm.hop()));
        mosm.poke();
        (bytes32 val, bool has) = mosm.peek();
        assertEq(uint(val), 0);
        assertTrue(!has);
        hevm.warp(uint(mosm.hop() * 2));
        mosm.poke();

        mosm.kiss(address(u));
        (val, has) = u.doOsmPeek();
        assertEq(uint(val), testprice);
        assertTrue(has);
    }

    function testOsmKiss() public {
        assertTrue(mosm.bud("osm",address(u)) == 0);
        mosm.kiss(address(u));
        assertTrue(mosm.bud("osm",address(u)) == 1);
    }

    function testOsmDiss() public {
        mosm.kiss(address(u));
        assertTrue(mosm.bud("osm",address(u)) == 1);
        mosm.diss(address(u));
        assertTrue(mosm.bud("osm", address(u)) == 0);
    }

    function testOsmInterval() public {
        (address[] memory orcl,
         uint256[] memory price,
         uint256[] memory ts,
         bytes32[] memory r,
         bytes32[] memory s,
         uint8[] memory v) = medianInit();

        mosm.poke(price, ts, v, r, s);

        // Initial condition after deploy: You cannot poke if era() has not
        // exceeded (zzz + hop)
        (bool ok,) = address(mosm).call(abi.encodeWithSelector(0x18178358));
        assertTrue(!ok);
        
        // Can poke after interval passes
        hevm.warp(uint(mosm.hop()));
        mosm.poke();
    
        // Cannot poke again within interval
        hevm.warp(uint(mosm.hop()) + 1);
        (ok,) = address(mosm).call(abi.encodeWithSelector(0x18178358));
        assertTrue(!ok);

        // Can skip intervals and poke in the future
        hevm.warp(uint(mosm.hop())*3);
        mosm.poke();

        // Update median price
        mosm.drop(orcl);
        (, price, ts, r, s, v) = medianInit2();
        mosm.poke(price, ts, v, r, s);

        // You can poke the future...
        hevm.warp((uint(mosm.hop())*5)-1);
        mosm.poke();
        // ... however, you must now wait the full interval before you poke
        // again (no top-of-the-hour stretching/contracting)
        hevm.warp(uint(mosm.hop())*5);
        (ok,) = address(mosm).call(abi.encodeWithSelector(0x18178358));
        assertTrue(!ok);

        hevm.warp(uint(mosm.hop())*6);
        mosm.poke();

        // Bonus test, this one fails because it's a no-op; no internal price changes
        hevm.warp(uint(mosm.hop())*7);
        (ok,) = address(mosm).call(abi.encodeWithSelector(0x18178358));
        assertTrue(!ok);
        assertTrue(mosm.noop(price[7]));
    }
}
