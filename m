From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH net-next v7 26/28] crypto: port ChaCha20 to Zinc
Date: Sat, 06 Oct 2018 15:07:02 +0200
Message-ID: <186b7905c7e0aafbf73758b54de6b645bf7d7f45.camel@strongswan.org>
References: <20181006025709.4019-1-Jason@zx2c4.com>
         <20181006025709.4019-27-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Samuel Neves <sneves@dei.uc.pt>, Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181006025709.4019-27-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

> Now that ChaCha20 is in Zinc, we can have the crypto API code simply
> call into it.

>  delete mode 100644 arch/x86/crypto/chacha20-avx2-x86_64.S
>  delete mode 100644 arch/x86/crypto/chacha20-ssse3-x86_64.S

I did some more testing with that new Zinc ChaCha20 code on x64, and
I'm still not convinced that it is an improvement compared to the
existing implementation.

>From a performance perspective, Zinc is in faster when working on sizes
that are not a multiple of chacha block sizes. This is due to the more
aggressive use of SSE/AVX code paths compared to the conservative use
in the existing implementation; instead of calculating two separate
blocks that are actually required, one can calculate four of them and
just discards two. This certainly improves benchmark results, but also
has some side effects regarding energy usage, thermal budget or even
shared hyper-threading resources.

One can certainly argue that the more aggressive approach is
preferable. However, I did some fairly trivial (non-optimized) changes
to the existing implementations to use a similar aggressive approach.
Numbers for SSE are slightly in favor of the existing implementation,
while the AVX path is almost on par, see below (produces some
interesting graphs, btw.).

When looking at your code, the assembly generated from Perl is
certainly harder to work with. The plain C version does make some heavy
use of macros and other tricks, but with a very questionable effect at
least on my system.


That being said, I think that whole mystic Zinc thing does not really
help in having a common base to work with or handling questions like
these above. In the end, these are just some crypto function that it
provides, and this IMHO can very well live under where it belongs to.

Best regards
Martin

---

ChaCha20 benchmark using tcrypt, numbers in kOps/s, current
implementation with a more aggressive SSE/AVX use vs. zinc:

 size crnt zinc
    8 5750 5818
   16 5843 5726
   24 5746 5757
   32 5820 5813
   40 5761 5710
   48 5735 5761
   56 5723 5742
   64 5871 5685
   72 3714 3520
   80 3587 3475
   88 3686 3424
   96 3580 3371
  104 3712 3313
  112 3582 3207
  120 3679 3150
  128 3567 3568
  136 3674 3690
  144 3525 3599
  152 3684 3566
  160 3593 3515
  168 3682 3437
  176 3564 3325
  184 3671 3279
  192 3573 3762
  200 3667 3702
  208 3576 3622
  216 3662 3518
  224 3566 3445
  232 3654 3422
  240 3565 3317
  248 3640 3279
  256 3720 3723
  264 3615 3639
  272 3594 3597
  280 3587 3565
  288 3502 3484
  296 3605 3422
  304 3620 3352
  312 3592 3308
  320 3488 3694
  328 3580 3681
  336 3585 3599
  344 3587 3523
  352 3486 3419
  360 3579 3403
  368 3601 3334
  376 3581 3257
  384 3498 3715
  392 3601 3612
  400 3600 3553
  408 3596 3496
  416 3495 3430
  424 3591 3402
  432 3568 3311
  440 3576 3275
  448 3501 3689
  456 3563 3618
  464 3592 3576
  472 3581 3509
  480 3480 3405
  488 3556 3397
  496 3563 3298
  504 3567 3277
  512 3656 3735
  520 2575 2209
  528 2524 2148
  536 2571 2164
  544 2519 2138
  552 2570 2126
  560 2510 2035
  568 2526 2041
  576 2633 2199
  584 2151 2183
  592 2113 2145
  600 2159 2155
  608 2108 2133
  616 2157 2115
  624 2104 2064
  632 2159 2045
  640 2104 2188
  648 2142 2182
  656 2115 2158
  664 2151 2147
  672 2113 2139
  680 2146 2114
  688 2097 2077
  696 2137 2043
  704 2101 2208
  712 2137 2189
  720 2117 2169
  728 2132 2145
  736 2107 2142
  744 2136 2081
  752 2105 2064
  760 2136 2043
  768 2166 2211
  776 2122 2192
  784 2129 2146
  792 2126 2141
  800 2094 2094
  808 2126 2100
  816 2133 2061
  824 2134 2045
  832 2103 2223
  840 2143 2184
  848 2130 2173
  856 2135 2145
  864 2084 2126
  872 2134 2105
  880 2128 2056
  888 2131 2043
  896 2093 2219
  904 2127 2192
  912 2130 2170
  920 2127 2149
  928 2082 2125
  936 2113 2098
  944 2126 2060
  952 2120 2049
  960 2085 2204
  968 2088 2187
  976 1927 2166
  984 1943 2136
  992 1911 2119
 1000 1959 2101
 1008 2116 2042
 1016 2124 2048
 1024 2152 2195
 1032 1729 1565
 1040 1708 1544
 1048 1726 1554
 1056 1702 1541
 1064 1724 1523
 1072 1699 1507
 1080 1719 1497
 1088 1767 1592
 1096 1536 1575
 1104 1506 1563
 1112 1529 1544
 1120 1518 1521
 1128 1526 1521
 1136 1518 1501
 1144 1535 1491
 1152 1507 1575
 1160 1525 1558
 1168 1500 1554
 1176 1524 1545
 1184 1516 1538
 1192 1532 1530
 1200 1511 1493
 1208 1512 1498
 1216 1505 1581
 1224 1518 1563
 1232 1513 1549
 1240 1533 1538
 1248 1504 1527
 1256 1532 1520
 1264 1510 1505
 1272 1525 1492
 1280 1539 1574
 1288 1518 1573
 1296 1522 1551
 1304 1520 1548
 1312 1508 1535
 1320 1524 1524
 1328 1522 1508
 1336 1515 1500
 1344 1496 1579
 1352 1517 1573
 1360 1522 1546
 1368 1515 1545
 1376 1494 1536
 1384 1516 1526
 1392 1522 1504
 1400 1520 1480
 1408 1501 1589
 1416 1511 1558
 1424 1516 1546
 1432 1516 1537
 1440 1502 1523
 1448 1516 1512
 1456 1510 1491
 1464 1509 1481
 1472 1496 1577
 1480 1514 1559
 1488 1512 1548
 1496 1513 1534
