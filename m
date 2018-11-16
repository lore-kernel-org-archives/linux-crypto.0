Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:53393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbeKPM6n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 07:58:43 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 358e1c43
        for <linux-crypto@vger.kernel.org>;
        Fri, 16 Nov 2018 02:42:34 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a3a1fcff (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 16 Nov 2018 02:42:33 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 32so19514409ota.12
        for <linux-crypto@vger.kernel.org>; Thu, 15 Nov 2018 18:48:06 -0800 (PST)
MIME-Version: 1.0
References: <20181111093630.28107-1-martin@strongswan.org> <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
In-Reply-To: <20181116022059.aob3ruc7umg32go6@gondor.apana.org.au>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 15 Nov 2018 18:47:54 -0800
Message-ID: <CAHmME9ppj_VDFhApxnnTX1ppn5QdzHH9kYNHkKwP8GKLvJ+Z+g@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: x86/chacha20 - SIMD performance improvements
To: Martin Willi <martin@strongswan.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Samuel Neves <sneves@dei.uc.pt>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

This is nice work, and given that it's quite clean -- and that it's
usually hard to screw up chacha in subtle ways when test vectors pass
(unlike, say, poly1305 or curve25519), I'd be inclined to roll with
your implementation if it can eventually become competitive with Andy
Polyakov's, which I'm currently working on for Zinc (which no longer
has pre-generated code, addressing the biggest hurdle; v9 will be sent
shortly). Specifically, I'm not quite sure the improvements here tip
the balance apply to all avx2 microarchitectures, and most
importantly, there are still no AVX-512 paths, which means it's
considerably slower on all newer generation Intel chips. Andy's has
the AVX-512VL implementation for Skylake (using ymm, so as not to hit
throttling) and AVX-512F for Cannon Lake and beyond (using zmm). I've
attached some measurements below showing how stark the difference is.

The take away is that while Andy's implementation is still ahead in
terms of performance today, I'd certainly encourage your efforts to
gain parity with that, and I'd be happy have that when the performance
and fuzzing time is right for it. So please do keep chipping away at
it; I think it's a potentially useful effort.

Regards,
Jason

size old zinc
---- ---- ----
0 64 54
16 386 372
32 388 396
48 388 420
64 366 350
80 708 666
96 708 692
112 706 736
128 692 648
144 1036 682
160 1036 708
176 1036 730
192 1016 658
208 1360 684
224 1362 708
240 1360 732
256 644 500
272 990 526
288 988 556
304 988 576
320 972 500
336 1314 532
352 1316 558
368 1318 578
384 1308 506
400 1644 532
416 1644 556
432 1644 594
448 1624 508
464 1970 534
480 1970 556
496 1968 582
512 660 624
528 1016 682
544 1016 702
560 1018 728
576 998 654
592 1344 680
608 1344 708
624 1344 730
640 1326 654
656 1670 686
672 1670 708
688 1670 732
704 1652 658
720 1998 682
736 1998 710
752 1996 734
768 1256 662
784 1606 688
800 1606 714
816 1606 736
832 1584 660
848 1948 688
864 1950 714
880 1948 736
896 1912 688
912 2258 718
928 2258 744
944 2256 768
960 2238 692
976 2584 718
992 2584 744
1008 2584 770



On Thu, Nov 15, 2018 at 6:21 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Nov 11, 2018 at 10:36:24AM +0100, Martin Willi wrote:
> > This patchset improves performance of the ChaCha20 SIMD implementations
> > for x86_64. For some specific encryption lengths, performance is more
> > than doubled. Two mechanisms are used to achieve this:
> >
> > * Instead of calculating the minimal number of required blocks for a
> >   given encryption length, functions producing more blocks are used
> >   more aggressively. Calculating a 4-block function can be faster than
> >   calculating a 2-block and a 1-block function, even if only three
> >   blocks are actually required.
> >
> > * In addition to the 8-block AVX2 function, a 4-block and a 2-block
> >   function are introduced.
> >
> > Patches 1-3 add support for partial lengths to the existing 1-, 4- and
> > 8-block functions. Patch 4 makes use of that by engaging the next higher
> > level block functions more aggressively. Patch 5 and 6 add the new AVX2
> > functions for 2 and 4 blocks. Patches are based on cryptodev and would
> > need adjustments to apply on top of the Adiantum patchset.
> >
> > Note that the more aggressive use of larger block functions calculate
> > blocks that may get discarded. This may have a negative impact on energy
> > usage or the processors thermal budget. However, with the new block
> > functions we can avoid this over-calculation for many lengths, so the
> > performance win can be considered more important.
> >
> > Below are performance numbers measured with tcrypt using additional
> > encryption lengths; numbers in kOps/s, on my i7-5557U. old is the
> > existing, new the implementation with this patchset. As comparison
> > the numbers for zinc in v6:
> >
> >  len  old  new zinc
> >    8 5908 5818 5818
> >   16 5917 5828 5726
> >   24 5916 5869 5757
> >   32 5920 5789 5813
> >   40 5868 5799 5710
> >   48 5877 5761 5761
> >   56 5869 5797 5742
> >   64 5897 5862 5685
> >   72 3381 4979 3520
> >   80 3364 5541 3475
> >   88 3350 4977 3424
> >   96 3342 5530 3371
> >  104 3328 4923 3313
> >  112 3317 5528 3207
> >  120 3313 4970 3150
> >  128 3492 5535 3568
> >  136 2487 4570 3690
> >  144 2481 5047 3599
> >  152 2473 4565 3566
> >  160 2459 5022 3515
> >  168 2461 4550 3437
> >  176 2454 5020 3325
> >  184 2449 4535 3279
> >  192 2538 5011 3762
> >  200 1962 4537 3702
> >  208 1962 4971 3622
> >  216 1954 4487 3518
> >  224 1949 4936 3445
> >  232 1948 4497 3422
> >  240 1941 4947 3317
> >  248 1940 4481 3279
> >  256 3798 4964 3723
> >  264 2638 3577 3639
> >  272 2637 3567 3597
> >  280 2628 3563 3565
> >  288 2630 3795 3484
> >  296 2621 3580 3422
> >  304 2612 3569 3352
> >  312 2602 3599 3308
> >  320 2694 3821 3694
> >  328 2060 3538 3681
> >  336 2054 3565 3599
> >  344 2054 3553 3523
> >  352 2049 3809 3419
> >  360 2045 3575 3403
> >  368 2035 3560 3334
> >  376 2036 3555 3257
> >  384 2092 3785 3715
> >  392 1691 3505 3612
> >  400 1684 3527 3553
> >  408 1686 3527 3496
> >  416 1684 3804 3430
> >  424 1681 3555 3402
> >  432 1675 3559 3311
> >  440 1672 3558 3275
> >  448 1710 3780 3689
> >  456 1431 3541 3618
> >  464 1428 3538 3576
> >  472 1430 3527 3509
> >  480 1426 3788 3405
> >  488 1423 3502 3397
> >  496 1423 3519 3298
> >  504 1418 3519 3277
> >  512 3694 3736 3735
> >  520 2601 2571 2209
> >  528 2601 2677 2148
> >  536 2587 2534 2164
> >  544 2578 2659 2138
> >  552 2570 2552 2126
> >  560 2566 2661 2035
> >  568 2567 2542 2041
> >  576 2639 2674 2199
> >  584 2031 2531 2183
> >  592 2027 2660 2145
> >  600 2016 2513 2155
> >  608 2009 2638 2133
> >  616 2006 2522 2115
> >  624 2000 2649 2064
> >  632 1996 2518 2045
> >  640 2053 2651 2188
> >  648 1666 2402 2182
> >  656 1663 2517 2158
> >  664 1659 2397 2147
> >  672 1657 2510 2139
> >  680 1656 2394 2114
> >  688 1653 2497 2077
> >  696 1646 2393 2043
> >  704 1678 2510 2208
> >  712 1414 2391 2189
> >  720 1412 2506 2169
> >  728 1411 2384 2145
> >  736 1408 2494 2142
> >  744 1408 2379 2081
> >  752 1405 2485 2064
> >  760 1403 2376 2043
> >  768 2189 2498 2211
> >  776 1756 2137 2192
> >  784 1746 2145 2146
> >  792 1744 2141 2141
> >  800 1743 2222 2094
> >  808 1742 2140 2100
> >  816 1735 2134 2061
> >  824 1731 2135 2045
> >  832 1778 2222 2223
> >  840 1480 2132 2184
> >  848 1480 2134 2173
> >  856 1476 2124 2145
> >  864 1474 2210 2126
> >  872 1472 2127 2105
> >  880 1463 2123 2056
> >  888 1468 2123 2043
> >  896 1494 2208 2219
> >  904 1278 2120 2192
> >  912 1277 2121 2170
> >  920 1273 2118 2149
> >  928 1272 2207 2125
> >  936 1267 2125 2098
> >  944 1265 2127 2060
> >  952 1267 2126 2049
> >  960 1289 2213 2204
> >  968 1125 2123 2187
> >  976 1122 2127 2166
> >  984 1120 2123 2136
> >  992 1118 2207 2119
> > 1000 1118 2120 2101
> > 1008 1117 2122 2042
> > 1016 1115 2121 2048
> > 1024 2174 2191 2195
> > 1032 1748 1724 1565
> > 1040 1745 1782 1544
> > 1048 1736 1737 1554
> > 1056 1738 1802 1541
> > 1064 1735 1728 1523
> > 1072 1730 1780 1507
> > 1080 1729 1724 1497
> > 1088 1757 1783 1592
> > 1096 1475 1723 1575
> > 1104 1474 1778 1563
> > 1112 1472 1708 1544
> > 1120 1468 1774 1521
> > 1128 1466 1718 1521
> > 1136 1462 1780 1501
> > 1144 1460 1719 1491
> > 1152 1481 1782 1575
> > 1160 1271 1647 1558
> > 1168 1271 1706 1554
> > 1176 1268 1645 1545
> > 1184 1265 1711 1538
> > 1192 1265 1648 1530
> > 1200 1264 1705 1493
> > 1208 1262 1647 1498
> > 1216 1277 1695 1581
> > 1224 1120 1642 1563
> > 1232 1115 1702 1549
> > 1240 1121 1646 1538
> > 1248 1119 1703 1527
> > 1256 1115 1640 1520
> > 1264 1114 1693 1505
> > 1272 1112 1642 1492
> > 1280 1552 1699 1574
> > 1288 1314 1525 1573
> > 1296 1315 1522 1551
> > 1304 1312 1521 1548
> > 1312 1311 1564 1535
> > 1320 1309 1518 1524
> > 1328 1302 1527 1508
> > 1336 1303 1521 1500
> > 1344 1333 1561 1579
> > 1352 1157 1524 1573
> > 1360 1152 1520 1546
> > 1368 1154 1522 1545
> > 1376 1153 1562 1536
> > 1384 1151 1525 1526
> > 1392 1149 1523 1504
> > 1400 1148 1517 1480
> > 1408 1167 1561 1589
> > 1416 1030 1516 1558
> > 1424 1028 1516 1546
> > 1432 1027 1522 1537
> > 1440 1027 1564 1523
> > 1448 1026 1507 1512
> > 1456 1025 1515 1491
> > 1464 1023 1522 1481
> > 1472 1037 1559 1577
> > 1480  927 1518 1559
> > 1488  926 1514 1548
> > 1496  926 1513 1534
>
> Nice work Martin!
>
> In light of this, and the grumblings over the wholesale replacment
> of the existing chacha20 implementations, could we add the zinc
> interface in a piecemeal fashion?
>
> That is, instead of adding a bunch of new implementations through
> zinc and then converting the crypto users over, we instead convert
> the existing implementations over to zinc in-place.  This would
> also resolve the complaints over not being able to choose different
> implementations through the crypto API and leaving that choice
> solely up to zinc.
>
> After that is done, wireguard could then proceed in parallel with
> replacing any implementations should the need arise.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
