From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Mon, 2 Jun 2008 22:17:39 +0200
Message-ID: <20080602201739.GA19706@Chamillionaire.breakpoint.cc>
References: <20080517.020122.229980431.davem@davemloft.net> <20080517091451.GE19540@Chamillionaire.breakpoint.cc> <20080517095625.GA17878@gondor.apana.org.au> <20080520.194723.268247612.davem@davemloft.net> <20080526110508.GB14743@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60025 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbYFBURv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 16:17:51 -0400
Content-Disposition: inline
In-Reply-To: <20080526110508.GB14743@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-05-26 21:05:08 [+1000]:

>Sebastian, if you're still seeing worse results on powerpc could you
>post the actual numbers with/without this patch?

le32:
~~~~~
|testing speed of rmd128
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    105 cycles/operation,    6 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    201 cycles/operation,    3 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    161 cycles/operation,    2 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    519 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    365 cycles/operation,    1 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    329 cycles/operation,    1 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   1798 cycles/operation,    1 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1038 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    994 cycles/operation,    0 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   3503 cycles/operation,    1 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1981 cycles/operation,    0 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   1896 cycles/operation,    0 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   1881 cycles/operation,    0 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   6914 cycles/operation,    1 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   3870 cycles/operation,    0 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   3698 cycles/operation,    0 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   3654 cycles/operation,    0 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  13736 cycles/operation,    1 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   7649 cycles/operation,    0 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   7305 cycles/operation,    0 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   7215 cycles/operation,    0 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   7210 cycles/operation,    0 cycles/byte
|
|testing speed of rmd160
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    144 cycles/operation,    9 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    276 cycles/operation,    4 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    237 cycles/operation,    3 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    706 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    552 cycles/operation,    2 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    517 cycles/operation,    2 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2432 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1671 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1628 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4731 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   3211 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   3124 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   3109 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   9332 cycles/operation,    2 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   6290 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   6116 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   6072 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  18532 cycles/operation,    2 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  12450 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  12102 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  12011 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  12006 cycles/operation,    1 cycles/byte
|
|testing speed of rmd256
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    116 cycles/operation,    7 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    217 cycles/operation,    3 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    178 cycles/operation,    2 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    551 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    399 cycles/operation,    1 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    365 cycles/operation,    1 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   1890 cycles/operation,    1 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1147 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1104 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   3677 cycles/operation,    1 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2190 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2104 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2089 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   7251 cycles/operation,    1 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   4276 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   4104 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   4060 cycles/operation,    0 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  14398 cycles/operation,    1 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   8447 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   8103 cycles/operation,    0 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   8015 cycles/operation,    0 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   8011 cycles/operation,    0 cycles/byte
|
|testing speed of rmd320
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    144 cycles/operation,    9 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    270 cycles/operation,    4 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    231 cycles/operation,    3 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    680 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    529 cycles/operation,    2 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    493 cycles/operation,    1 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2326 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1579 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1535 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4521 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   3026 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2939 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2925 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   8911 cycles/operation,    2 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   5922 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   5748 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   5703 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  17690 cycles/operation,    2 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  11711 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  11363 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  11275 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  11271 cycles/operation,    1 cycles/byte

le32p:
~~~~~~
|testing speed of rmd128
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    124 cycles/operation,    7 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    238 cycles/operation,    3 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    199 cycles/operation,    3 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    613 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    462 cycles/operation,    1 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    426 cycles/operation,    1 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2118 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1371 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1328 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4127 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2630 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2545 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2531 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   8144 cycles/operation,    1 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   5149 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   4979 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   4936 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  16176 cycles/operation,    1 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  10187 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   9847 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   9761 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   9756 cycles/operation,    1 cycles/byte
|
|testing speed of rmd160
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    161 cycles/operation,   10 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    311 cycles/operation,    4 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    273 cycles/operation,    4 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    796 cycles/operation,    3 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    645 cycles/operation,    2 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    610 cycles/operation,    2 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2737 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1992 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1949 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   5325 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   3835 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   3749 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   3734 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  10501 cycles/operation,    2 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   7520 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   7348 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   7305 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  20853 cycles/operation,    2 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  14892 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  14547 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  14460 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  14456 cycles/operation,    1 cycles/byte
|
|testing speed of rmd256
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    129 cycles/operation,    8 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    245 cycles/operation,    3 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    206 cycles/operation,    3 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    626 cycles/operation,    2 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    475 cycles/operation,    1 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    443 cycles/operation,    1 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2155 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1418 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1370 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4194 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2717 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2621 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2606 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   8271 cycles/operation,    2 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   5318 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   5126 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   5077 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  16426 cycles/operation,    2 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  10518 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  10134 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  10037 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  10033 cycles/operation,    1 cycles/byte
|
|testing speed of rmd320
|test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    167 cycles/operation,   10 cycles/byte
|test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    319 cycles/operation,    4 cycles/byte
|test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    280 cycles/operation,    4 cycles/byte
|test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    809 cycles/operation,    3 cycles/byte
|test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    658 cycles/operation,    2 cycles/byte
|test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    623 cycles/operation,    2 cycles/byte
|test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2774 cycles/operation,    2 cycles/byte
|test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   2028 cycles/operation,    1 cycles/byte
|test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1985 cycles/operation,    1 cycles/byte
|test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   5394 cycles/operation,    2 cycles/byte
|test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   3902 cycles/operation,    1 cycles/byte
|test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   3815 cycles/operation,    1 cycles/byte
|test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   3801 cycles/operation,    1 cycles/byte
|test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  10634 cycles/operation,    2 cycles/byte
|test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   7650 cycles/operation,    1 cycles/byte
|test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   7476 cycles/operation,    1 cycles/byte
|test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   7433 cycles/operation,    1 cycles/byte
|test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  21115 cycles/operation,    2 cycles/byte
|test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  15145 cycles/operation,    1 cycles/byte
|test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):  14799 cycles/operation,    1 cycles/byte
|test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):  14711 cycles/operation,    1 cycles/byte
|test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):  14706 cycles/operation,    1 cycles/byte

This is mpc8544 with gcc-4.1.1. The other powerpc machine I have
available and could run a test is a ps3. Unfortunately I have to
suspend this for two weeks.
Arnd told me, that the powerpc folks were discussing an index field in
their in/out macros. I check that once I'm back again.

Sebastian
