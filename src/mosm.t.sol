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
    uint256 testprice = 108000000000000000000;

    function setUp() public {
        mosm = new Mosm();
        u = new Unauthorized(mosm);
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    }

    function medianInit() public returns
        (address[] memory, uint256[] memory, uint32[] memory, bytes32[] memory, bytes32[] memory, uint8[] memory) {

        address[] memory orcl = new address[](15);
        uint256[] memory price = new uint256[](15);
        uint32[] memory ts = new uint32[](15);
        bytes32[] memory r = new bytes32[](15);
        bytes32[] memory s = new bytes32[](15);
        uint8[] memory v = new uint8[](15);

        // ----------- accounts:
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
        ts[0] = uint32(0x62fbbbfe);
        ts[1] = uint32(0x62fbbbfe);
        ts[2] = uint32(0x62fbbbfe);
        ts[3] = uint32(0x62fbbbfe);
        ts[4] = uint32(0x62fbbbfe);
        ts[5] = uint32(0x62fbbbfe);
        ts[6] = uint32(0x62fbbbfe);
        ts[7] = uint32(0x62fbbbfe);
        ts[8] = uint32(0x62fbbbfe);
        ts[9] = uint32(0x62fbbbfe);
        ts[10] = uint32(0x62fbbbfe);
        ts[11] = uint32(0x62fbbbfe);
        ts[12] = uint32(0x62fbbbfe);
        ts[13] = uint32(0x62fbbbfe);
        ts[14] = uint32(0x62fbbbfe);
        // ---------------- r:
        r[0] = bytes32(0xc90aa359dc7647268bc9128dc36727de6f7b110154890278b03fa35ed98318df);
        r[1] = bytes32(0x318dc4b4d44584a31bf7c53cce25c80de097ecef0616136239e858dad0d65591);
        r[2] = bytes32(0xbf918136b7d0b0bd3495ce38e2161e53f9d1d4a56717cf10bc0dece2c45cea77);
        r[3] = bytes32(0x3a52abbaa60ba806bfcf5748083cc991790722821b3843d01901f359eebb33c1);
        r[4] = bytes32(0x3e625b49e202038d278d96110eaa80cc6ba5665ed912949122ca7c43e047c92d);
        r[5] = bytes32(0x29549ecfc63e56db02d728804fd878bff9a331775c8a565a7f1bdd244a128917);
        r[6] = bytes32(0x94b553059947eb931746b0dd5c3a4c1bba052fabedb97ebdb6c5920634442a79);
        r[7] = bytes32(0x4c6d1e884a3b9c89bd36973144c6910371a023ab4c4780e021887933012097cd);
        r[8] = bytes32(0x54ee0173faaea34c764a679f0e0e736097a8bc62e0e125859731559be7044890);
        r[9] = bytes32(0x3cc5d11e0f20454e02955dbaa700665a95db6415eb51e38fec352f9bb7f5b61b);
        r[10] = bytes32(0x703b061ff53a13bbb6bae5ec6dbde3031d02e2fd4c27415c44bdab27b46d2e3f);
        r[11] = bytes32(0x96b7f2acafe6fec5481ddc77fac735ee7537f7fc4e615f650b9170bb4ae3506c);
        r[12] = bytes32(0x4db47b85c4f9f2d252ac84cf184b5492406d0569a214d8da767f8f2c16f7e38c);
        r[13] = bytes32(0x26703e23859e510f7745d1c892f26367440abbc1d29fcca2b88576c5fcf45efa);
        r[14] = bytes32(0x52328d363a990e2c14bb1a1630d66c82fe73a7c4376b621365bc8f92c057b172);
        // ---------------- s:
        s[0] = bytes32(0x633bf26dff94fbd7c09ac5c570bddd1a49e6a99739ce40207dfefd758d00cd06);
        s[1] = bytes32(0x73dc937f2b7a95b1233f0a4b549027240277803dcbb2d4e8c6640a2611305911);
        s[2] = bytes32(0x6f923abba40adee7915550d106764f3da71ad2b34085423afc462166981b785a);
        s[3] = bytes32(0x40e072edf603dbc7c71dba9611bc6099423250901d353ecb18cace222262e6e1);
        s[4] = bytes32(0x4b8c1a2ffd30c238838a1fc2377f94fe93020cd4eb0e966afb1a13a547e6b76e);
        s[5] = bytes32(0x63a3197414c6b2ae4ec62b98707b52aa50162050e618bd2b93563b60655c3bdd);
        s[6] = bytes32(0x6447a7ce3f97f90775ffe178aa1a9fbabfdee48b49098f589a17e65f29a52518);
        s[7] = bytes32(0x3fead419647b6d6f4ce37ffa57fbbf6a381a846b969d3ac2cb9e196d6fdff13c);
        s[8] = bytes32(0x3bc48c0638bcfba9f1834de26f695ac3504b4d10aa376637bae542a65f3a8823);
        s[9] = bytes32(0x419217e68f47a628f9a2346e16b040534553dda8b67d735fcaf0409a0d677005);
        s[10] = bytes32(0x52673c9b6e33443d37c15ae397dc9b09fd06fbeb3173f589a70f05d7c82a112b);
        s[11] = bytes32(0x1928e2bee6ce618b90ba15019b9f22524fc2cd6a18482f80a723bd03b487e478);
        s[12] = bytes32(0x3408ce0e133325145a2dcd74bc31badb6400dbf285e68803b22385ee6cda2bca);
        s[13] = bytes32(0x6e6cbf00f78b4316111ce37fee4f5b84190f30de44e79ed582cb6fe6be9c08de);
        s[14] = bytes32(0x18ce98478ee82aa091e09a2a8a0c6ae9b6315e12e7bfd679606fc80a0246bbbb);
        // ---------------- v:
        v[0] = uint8(0x1c);
        v[1] = uint8(0x1c);
        v[2] = uint8(0x1c);
        v[3] = uint8(0x1c);
        v[4] = uint8(0x1c);
        v[5] = uint8(0x1b);
        v[6] = uint8(0x1c);
        v[7] = uint8(0x1b);
        v[8] = uint8(0x1b);
        v[9] = uint8(0x1c);
        v[10] = uint8(0x1c);
        v[11] = uint8(0x1c);
        v[12] = uint8(0x1c);
        v[13] = uint8(0x1b);
        v[14] = uint8(0x1b);

        mosm.setBar(15);
        mosm.lift(orcl);

        return (orcl, price, ts, r, s, v);
    }

    function medianInit2() public returns
        (address[] memory, uint256[] memory, uint32[] memory, bytes32[] memory, bytes32[] memory, uint8[] memory) {

        address[] memory orcl = new address[](15);
        uint256[] memory price = new uint256[](15);
        uint32[] memory ts = new uint32[](15);
        bytes32[] memory r = new bytes32[](15);
        bytes32[] memory s = new bytes32[](15);
        uint8[] memory v = new uint8[](15);

        // ----------- accounts:
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
        price[0] = uint256(0x0000000000000000000000000000000000000000000000058788cb94b1d80000);
        price[1] = uint256(0x00000000000000000000000000000000000000000000000595698248593c0000);
        price[2] = uint256(0x000000000000000000000000000000000000000000000005a34a38fc00a00000);
        price[3] = uint256(0x000000000000000000000000000000000000000000000005b12aefafa8040000);
        price[4] = uint256(0x000000000000000000000000000000000000000000000005bf0ba6634f680000);
        price[5] = uint256(0x000000000000000000000000000000000000000000000005ccec5d16f6cc0000);
        price[6] = uint256(0x000000000000000000000000000000000000000000000005dacd13ca9e300000);
        price[7] = uint256(0x000000000000000000000000000000000000000000000005e8adca7e45940000);
        price[8] = uint256(0x000000000000000000000000000000000000000000000005f68e8131ecf80000);
        price[9] = uint256(0x000000000000000000000000000000000000000000000006046f37e5945c0000);
        price[10] = uint256(0x000000000000000000000000000000000000000000000006124fee993bc00000);
        price[11] = uint256(0x0000000000000000000000000000000000000000000000062030a54ce3240000);
        price[12] = uint256(0x0000000000000000000000000000000000000000000000062e115c008a880000);
        price[13] = uint256(0x0000000000000000000000000000000000000000000000063bf212b431ec0000);
        price[14] = uint256(0x00000000000000000000000000000000000000000000000649d2c967d9500000);
        // -------------- age, a.k.a. ts:
        ts[0] = uint32(0x62fbbc55);
        ts[1] = uint32(0x62fbbc55);
        ts[2] = uint32(0x62fbbc55);
        ts[3] = uint32(0x62fbbc55);
        ts[4] = uint32(0x62fbbc55);
        ts[5] = uint32(0x62fbbc55);
        ts[6] = uint32(0x62fbbc55);
        ts[7] = uint32(0x62fbbc55);
        ts[8] = uint32(0x62fbbc55);
        ts[9] = uint32(0x62fbbc55);
        ts[10] = uint32(0x62fbbc55);
        ts[11] = uint32(0x62fbbc55);
        ts[12] = uint32(0x62fbbc55);
        ts[13] = uint32(0x62fbbc55);
        ts[14] = uint32(0x62fbbc55);
        // ---------------- r:
        r[0] = bytes32(0x6d87433fe06b6b3db416ec01ae3d0c1d36eb58d1f4f453a7148dcfd7b172eb41);
        r[1] = bytes32(0x108bfa8f53e0e4e5aa5325a41e550816d63378bb4735c49dbcc6c8d4d8721b7e);
        r[2] = bytes32(0x9a8b4f07a486b3a51c750cc1438949d90b2fcf25e4e0dbb2ba817c0360ace86c);
        r[3] = bytes32(0xd40d09ba4bba91ebab4e109873149428e63a5b8736f4b1002c8d158edee5dadd);
        r[4] = bytes32(0x9d1d4a7e5fbd13e7b9bb219c810a896f285ba01571a6a215fbb99ccbe27f0ff1);
        r[5] = bytes32(0xa99a15de24d9783f350999541513107b725499c4b616ec6e37e3e2a9823b3c49);
        r[6] = bytes32(0x8b78711fea5be145f639c6e7fbf5667c8ad03d83a8c7e439078000ab4969eb3b);
        r[7] = bytes32(0x92ac15cab5025990b429ad367407fc31c3702fb06b09d552e1306a8eb8f3096d);
        r[8] = bytes32(0x6e98770bebf868dc52cc29fe37c0fa432e5666a3a991081f23d31371cfbe911d);
        r[9] = bytes32(0x73e760328d38743427694abfb4b8e7885d9d3a9fad4977c5c0120cdcc587f86b);
        r[10] = bytes32(0x0dae5a8707b5a9428c7a514798ceee7393f0e16ccb16d1af530a48557debf7ec);
        r[11] = bytes32(0x0f850fefe892f91f2da825453a80990b3c8eaa3b06fb2f4bfef1f0dbf04c1687);
        r[12] = bytes32(0x0a1df69d7e3066e08589035e5aba60df4587efae2d60c4aeef465f74d34e6f63);
        r[13] = bytes32(0x9c0886b7b08f36dc8a06f6c8ecc5536b4ae0067d95acf3160680c6240b1e1967);
        r[14] = bytes32(0xad1236fee85f115c76d6949a62ecae35032ee18d8a0a5cd3e99ae9d22e8b2a27);
        // ---------------- s:
        s[0] = bytes32(0x066a5d90c56b25f8ca659b9f189948ec2fb7944bd7a80158561e4d2a82760639);
        s[1] = bytes32(0x5e48796f0983596fa943d14758497b36b6253978af45b9e8e9bb6d351b33aa0f);
        s[2] = bytes32(0x156e388b07854a54c6a9f13013261fe5f1cbf9c0369ff067634a603c2fd00c39);
        s[3] = bytes32(0x4f4e0b7bc156713264f36aa3c15c12594f672a7097361aff19590f6c65091cfc);
        s[4] = bytes32(0x7ce7faad1ec8ecc9c99eceef3864d43fcc24a01dbe1527c77b1ea26d60f33a94);
        s[5] = bytes32(0x73dadac136bea2af1983a7a443499cf28703c78eb064b423486861eeb59de781);
        s[6] = bytes32(0x032917bacca2129cebfa98d732df76c8ca3c5a0ff02ef04fb51e2d2aad0a45fb);
        s[7] = bytes32(0x21875b6f58d5a694daec3684ade864c5f48ba14dbb65a3009c80273465427e9b);
        s[8] = bytes32(0x07f4ccd97bb2651b0a8e034b14b0cd9242d5cb17f1f4915eb59b8ff7daf49c67);
        s[9] = bytes32(0x0750b5a77a875d5293ca86a6256425cf096e3994930b2ff6fc09e41ff761bd4b);
        s[10] = bytes32(0x019ac685aff0ad95b8b6db62d9cac0d1246905bbff60c581e0e22e879e889ee1);
        s[11] = bytes32(0x676ed3720ca9620f5425fb12efe3caf2d05a25e4e2763f9528896f57114ab515);
        s[12] = bytes32(0x669dbf5235b4c5a61caf4e959f9d1939dc75ead3ba70a655bce503280a7fd811);
        s[13] = bytes32(0x6379c0fcd715b9f8d7d56cdd0a405a92a0de5b3c6a29699355a5cb744fdac031);
        s[14] = bytes32(0x6375d1a689a5347604c0fcead48a3ceefcebc1beb3c8c911c8e21fc76047a152);
        // ---------------- v:
        v[0] = uint8(0x1c);
        v[1] = uint8(0x1c);
        v[2] = uint8(0x1c);
        v[3] = uint8(0x1c);
        v[4] = uint8(0x1c);
        v[5] = uint8(0x1c);
        v[6] = uint8(0x1b);
        v[7] = uint8(0x1c);
        v[8] = uint8(0x1b);
        v[9] = uint8(0x1c);
        v[10] = uint8(0x1b);
        v[11] = uint8(0x1b);
        v[12] = uint8(0x1c);
        v[13] = uint8(0x1b);
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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
         uint32[] memory ts,
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

        // Can skip intervals and poke in the future
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
