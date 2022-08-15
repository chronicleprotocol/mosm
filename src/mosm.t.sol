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

contract MosmTest is DSTest {
    Mosm mosm;
    Unauthorized u;
    Hevm hevm;
    uint256 testprice = 258679000000000000000;

    function setUp() public {
        mosm = new Mosm();
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

        orcl[0] = address(0x2d6691a7Ca09FcFC8a069953AD4Ba4De11DbFFd6);
        orcl[1] = address(0xEF7a293Adaec73c5E134040DDAd13a15CEB7231A);
        orcl[2] = address(0xEd1fBB08C70D1d510cF6C6a8B31f69917F0eCd46);
        orcl[3] = address(0xd4D2CBda7CA421A68aFdb72f16Ad38b8f0Ea3199);
        orcl[4] = address(0x94e71Afc1C876762aF8aaEd569596E6Fe2d42d86);
        orcl[5] = address(0x1379F663AE24cFD7cDaad6d8E0fa0dBf2F7D51fb);
        orcl[6] = address(0x2a4B7b59323B8bC4a78d04a88E853469ED6ea1d4);
        orcl[7] = address(0x8797FDdF08612100a8B821CD52f8B71dB75Fa9aC);
        orcl[8] = address(0xdB3E64F17f5E6Af7161dCd01401464835136Af6C);
        orcl[9] = address(0xCD63177834dDD54aDdD2d9F9845042A21360023A);
        orcl[10] = address(0x832A0149Beea1e4cb7175b3062Edd10E1b40A951);
        orcl[11] = address(0xb158f2EC0E44c7cE533C5e41ca5FB09575f1e210);
        orcl[12] = address(0x555faE91fb4b03473704045737b8b5F628E9E5E5);
        orcl[13] = address(0x8b8668B708D4edee400Dfd00e9A9038781eb5904);
        orcl[14] = address(0x06B80b4034FEc8566857f0B9180b025e933093e4);

        price[0] = uint256(0x00000000000000000000000000000000000000000000000da04773c0e7dc8000);
        price[1] = uint256(0x00000000000000000000000000000000000000000000000dadaf5fa2ace38000);
        price[2] = uint256(0x00000000000000000000000000000000000000000000000dc37cafcfdb070000);
        price[3] = uint256(0x00000000000000000000000000000000000000000000000dd2cb5477ce488000);
        price[4] = uint256(0x00000000000000000000000000000000000000000000000dda50e698aa8b8000);
        price[5] = uint256(0x00000000000000000000000000000000000000000000000dee1b120a84408000);
        price[6] = uint256(0x00000000000000000000000000000000000000000000000df1f6b99173cf8000);
        price[7] = uint256(0x00000000000000000000000000000000000000000000000e05e46bf5bd458000);
        price[8] = uint256(0x00000000000000000000000000000000000000000000000e0d89f78a64830000);
        price[9] = uint256(0x00000000000000000000000000000000000000000000000e25afb05259b10000);
        price[10] = uint256(0x00000000000000000000000000000000000000000000000e2f0a37c02c4e0000);
        price[11] = uint256(0x00000000000000000000000000000000000000000000000e39eb8b98cc360000);
        price[12] = uint256(0x00000000000000000000000000000000000000000000000e4cab42f05fc38000);
        price[13] = uint256(0x00000000000000000000000000000000000000000000000e549b69e88b498000);
        price[14] = uint256(0x00000000000000000000000000000000000000000000000e68f023a57f3c0000);

        ts[0] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3710);
        ts[1] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3711);
        ts[2] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3712);
        ts[3] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3713);
        ts[4] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3714);
        ts[5] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3715);
        ts[6] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3716);
        ts[7] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3717);
        ts[8] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a3719);
        ts[9] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371a);
        ts[10] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371b);
        ts[11] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371c);
        ts[12] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371d);
        ts[13] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371e);
        ts[14] = uint256(0x000000000000000000000000000000000000000000000000000000005c4a371f);

        r[0] = bytes32(0xcde732167a15601b67d9a5a03c14739f05a4128966d5e14157a97178c2b66268);
        r[1] = bytes32(0x5f7533150ce566f568f0157a9bcb119e84bc0fcee585a8e8fff14b10b7e87ce9);
        r[2] = bytes32(0xa5e83de72de8cd96edc991b774dbef19dfec5905a3b0438c8b4b14d799c234fb);
        r[3] = bytes32(0x9a13768dad10e3b2d22e37c5ba74b5fa5d71569efeaa45f8333fdcc799826861);
        r[4] = bytes32(0x18f7edbf9fa29b6965cd2b63f4a771847af0a1f5e29c0542d14659c3d22d9f39);
        r[5] = bytes32(0xa9f717be8c0f61aa4a9313858ef46defe4080e81565abe6f3c7b691be81b7512);
        r[6] = bytes32(0x1d4ddab4935b842e58a4f68813508693c968345d965f0ea65e2cb66d2d87278b);
        r[7] = bytes32(0xdb29ff83b98180bffb0a369972efa7f75a377621f4be9abd98bac8497b6cc7d7);
        r[8] = bytes32(0xbfe4434091e228a0d57a67ae1cec2d1f24eb470acbc99d3e44477e5ba86ec192);
        r[9] = bytes32(0xbfe9e874ce4b86886167310e252cb3e792f7577c78c6317131b3b23bd2bac23a);
        r[10] = bytes32(0x494a00afbf51e94a00fb802464a329788b1787cca413e9606e48b0d4c5db186a);
        r[11] = bytes32(0xd48a4227257fe62489dd5a876213f0c73dd28b5bbd0062b97c97ad359341a6d0);
        r[12] = bytes32(0x1036209fd741421b13c947b723c6c36723337831f261261a9f972c92c1024e9c);
        r[13] = bytes32(0xddbf5d9d124da617f20aabeadce531bc7bf5a5cc87eee996cd7a7acff335e659);
        r[14] = bytes32(0x46ad81c37b4fd40b16c428accb368bba91312a5b4491a747abb31594faaa30df);

        s[0] = bytes32(0x7db1ca5ef537cd229d35c88395393f23c8f2bb4708d65d66bb625879686e87b5);
        s[1] = bytes32(0x6c2ee3a98dfeca39f1b9b79ddcb446be70e771e0737c296c537bfb01ed9f5eb4);
        s[2] = bytes32(0x1c29866da2db9480c8a7f2a691c194e3deb1c69b50c68005c1f70f20845ae127);
        s[3] = bytes32(0x7f6aa4bc4be9b59e95653563e6e82c44b26543a7e7f76e4ca5981d3a061f0c06);
        s[4] = bytes32(0x34fa2d01cd9d6d90376754d63f064079b8369c301545a55d47b1d281ddbe6c0e);
        s[5] = bytes32(0x7f414a67c20e574065134c43562956ae0c5831540b2a11d27f0cbf55c1a17838);
        s[6] = bytes32(0x54923524bf791d2e53955ca9016ac24f26c509a28a3bd297a4e2bf92be5c143a);
        s[7] = bytes32(0x4d81a95311ed8d44ec77725aaa9d7e376156de27a1400c61858e47945102df0a);
        s[8] = bytes32(0x304b355b420a75f432002c527ea1d1d073bbbe9383e8cc0b35a73e6ab4f8e643);
        s[9] = bytes32(0x6b115625e7b015434b85d5d3c2a0627564b78df43a12b8ea6f5fc778395fafde);
        s[10] = bytes32(0x036ff783f19deb152c42ec06238d9cb9de8697765103b32936d6d2cb441fada8);
        s[11] = bytes32(0x525cd8d3baf77dad049c7092cbbef6979e36924b88cc90faf09256c24552cf9d);
        s[12] = bytes32(0x242043c823bf48009cbf79e6114de1ce57fd2a031190966d00b89a16871534ed);
        s[13] = bytes32(0x69dd6213ef7c960ce7123a50dabd2a45d477c8ae3eca2bb860ec75902a23ca81);
        s[14] = bytes32(0x6573f1f517c89503a1116377f7ac80cbfe2b24bbc5dc1147d03da725198f8cc5);

        v[0] = uint8(0x1c);
        v[1] = uint8(0x1b);
        v[2] = uint8(0x1c);
        v[3] = uint8(0x1b);
        v[4] = uint8(0x1b);
        v[5] = uint8(0x1b);
        v[6] = uint8(0x1c);
        v[7] = uint8(0x1c);
        v[8] = uint8(0x1b);
        v[9] = uint8(0x1c);
        v[10] = uint8(0x1b);
        v[11] = uint8(0x1b);
        v[12] = uint8(0x1c);
        v[13] = uint8(0x1c);
        v[14] = uint8(0x1b);

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

        // ----------- oracles:
        orcl[0] = address(0x645F3BA6ed86D6f0965797563Fda6847932d78Df);
        orcl[1] = address(0xa10ffb7e9842c7555575a25C53B6525A5a3f031d);
        orcl[2] = address(0xd0d005224d30975a0A6eD382Ae2909c2c453D2a3);
        orcl[3] = address(0x72C14464834831471eC11D1c9B9Fd2DE177Ab192);
        orcl[4] = address(0x9E4f867264b636E8C72cA0C0Be0ECEfa313DFCB9);
        orcl[5] = address(0x54Bf85C4072FE58d291A49f97d40bA1C3E177c16);
        orcl[6] = address(0x3280F2601A6fC5cCa9b79E73501689053c9751Db);
        orcl[7] = address(0xD1a5F6D8505317A25Cf63876BE7721C14ADFB569);
        orcl[8] = address(0x2A3f1f975e2ed36bcc287D8A22956551B24D79B4);
        orcl[9] = address(0x465C2617d41ba087EceC74830Ec08Ca4B36B8910);
        orcl[10] = address(0x4b606049aAb6A1f969706b3E773B1c565Dab6964);
        orcl[11] = address(0xAA360C3fb2B7E96F4BbD16Ad240A4C9b7a970495);
        orcl[12] = address(0x7E66d64f550FB92589f2220682ffe9e59539d04F);
        orcl[13] = address(0xE45Fbc125196280DC2B853695D913f94d727938c);
        orcl[14] = address(0x9Ff0B627B21762361f112F46A5253C8866c33dE0);
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
        ts[0] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[1] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[2] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[3] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[4] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[5] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[6] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[7] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[8] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[9] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[10] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[11] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[12] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[13] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        ts[14] = uint256(0x000000000000000000000000000000000000000000000000000000005c567118);
        // ---------------- r:
        r[0] = bytes32(0x613e408c91648d5624b146e2c59c5cf36e0ff49bb722ef8c209127f4bd745263);
        r[1] = bytes32(0x9ee2a246395f27d90ed24f6e5a145e1cd5201ab2ab1f5c86d90aa9337b5075d1);
        r[2] = bytes32(0x0f4e98c9b48d44acc95c70f04a1589014bb4e010d4473ab8f21f17c672b8511e);
        r[3] = bytes32(0xaef3d6f2cdabbda54457e37f3449481cf86801e7741500304dfcdb7f86034770);
        r[4] = bytes32(0xfc2bcedee67db0b462e1c679fded625bffbcf66e2596afc35b1d6b885327c3c7);
        r[5] = bytes32(0xdbaa87f758f90a0bbf65654b815c14ed470a80b42d5c06742d6a934ce3d96a8d);
        r[6] = bytes32(0x862e65775d3327e11e36dd699be28e48e676c4547d8b4e7ec45a2c2d895c6d65);
        r[7] = bytes32(0x6b4525518fc28af73e2d3cf139da6c0fd28d10b48ecd9c448b4eb47de9a0fae2);
        r[8] = bytes32(0x60b65a1f781717ebe42d7c730002b46cc5f0b6859040868dfc9e22fbaf32e3e7);
        r[9] = bytes32(0x822a5cb19a15c99ee49f01d4e3feb32037c6fac605119c5dd0ef734226297c37);
        r[10] = bytes32(0x749d60665ee9a35332ee76e2d9106ff091f32a09eb0a85e1a968a4efa2e11a9b);
        r[11] = bytes32(0xa1fc317469f55a658a774df7ce75c7525c0d9411848c46d2582134c53c8855e4);
        r[12] = bytes32(0x643e3a1404af01c36f92ac612a3044b0c173d0ee62078fe60ab386cd690309e6);
        r[13] = bytes32(0x95c2ecd13bd4d41d052f6ce2ec944a9f69749324b9266a2609b333611c3fbd0f);
        r[14] = bytes32(0x0af2ef07a559b4a30287008bace6098e4a87f7d6184f830a7a3fc6e24c075fbb);
        // ---------------- s:
        s[0] = bytes32(0x7fcee972a18bdde1f4737f01ecb3ad4a8b161c69f8353ca21e0a6e0dc2c9990b);
        s[1] = bytes32(0x4b1b3b288169a9d8e2e1b8a1c56f2f82929eeaa230cc38dd21289a65de2a7ef2);
        s[2] = bytes32(0x0388a7548a1ec66f1e4d9a9537a8dc2f8a8e174bf46e702c583508c7c786bc5e);
        s[3] = bytes32(0x7a88b417cbd7e63bab6e39716afbcbe8295f552ca25cbae777b7f684a852be99);
        s[4] = bytes32(0x2c94d9953b682eacc4edb4ee21fb5033b79b915a72005c69edcbfbcbf376ca33);
        s[5] = bytes32(0x0dac68978787e95f8c5156e10ab98572c2003bfc0c52bd4b831cd689bbc6738b);
        s[6] = bytes32(0x063e7f0fbd5dc34557752128c0b1dce86df96cf8f7a500b6e9672493bf60dd6f);
        s[7] = bytes32(0x1243e937ecada1ce581d074af595f366246f749cc0e04d445bfabeae0b026b2f);
        s[8] = bytes32(0x18224dd257510d4c55dc7a5f9d367b243200f2047e911ba2c53e4f49e247acc9);
        s[9] = bytes32(0x5b10ecacc5617377117309b821166885c16dc3fc20a4b4b0a9a9816fe5bd5bbe);
        s[10] = bytes32(0x5373854d82356b9941f9032a7ca1f62db43e51a021a2466716cd11eb4d4b36c3);
        s[11] = bytes32(0x2bc4a72fc68b3450418b228df9e7ecbf88f4f72b9df0fd53c5f0b35d2add8eb9);
        s[12] = bytes32(0x14593d3d41527a6f877f6673bb7faed2af7a7a072e5034484b6715265efb75d1);
        s[13] = bytes32(0x35c14757b7490b4eca10ba0cb60d6af7055be486ae7f254856cf542f3f77ba31);
        s[14] = bytes32(0x1e92ad121cf065cd988027beb1e94175d985a089bd693ae710bda5118c7aeeed);
        // ---------------- v:
        v[0] = uint8(0x1b);
        v[1] = uint8(0x1c);
        v[2] = uint8(0x1c);
        v[3] = uint8(0x1c);
        v[4] = uint8(0x1c);
        v[5] = uint8(0x1c);
        v[6] = uint8(0x1c);
        v[7] = uint8(0x1c);
        v[8] = uint8(0x1c);
        v[9] = uint8(0x1b);
        v[10] = uint8(0x1c);
        v[11] = uint8(0x1c);
        v[12] = uint8(0x1c);
        v[13] = uint8(0x1c);
        v[14] = uint8(0x1c);

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
        mosm.median_poke(price, ts, v, r, s);
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
        mosm.median_poke(price, ts, v, r, s);
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
        mosm.median_poke(price, ts, v, r, s);

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
        mosm.median_poke(price, ts, v, r, s);

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
        mosm.median_poke(price, ts, v, r, s);

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

        mosm.median_poke(price, ts, v, r, s);
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

        mosm.median_poke(price, ts, v, r, s);

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

        // Can skip intervals and poke further out into the future
        hevm.warp(uint(mosm.hop())*3);
        mosm.poke();

        // Update median price
        mosm.drop(orcl);
        (, price, ts, r, s, v) = medianInit2();
        mosm.median_poke(price, ts, v, r, s);

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
