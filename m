From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Tue, 20 May 2008 19:47:23 -0700 (PDT)
Message-ID: <20080520.194723.268247612.davem@davemloft.net>
References: <20080517.020122.229980431.davem@davemloft.net>
	<20080517091451.GE19540@Chamillionaire.breakpoint.cc>
	<20080517095625.GA17878@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@ml.breakpoint.cc, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42897
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbYEUCr2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 22:47:28 -0400
In-Reply-To: <20080517095625.GA17878@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 17 May 2008 17:56:25 +0800

> If you pull my cryptodev-2.6 tree then you'll be able to run
> the above test.

Performance is significantly increased on Niagara2 by using
the little-endian loads inside of the transformation loop, as
expected.   The numbers below are first before, then after,
the patch at the very end of this email is applied.

And this is what I suggested in the first place.  Was was not
suggesting that the endian converting preparation loop be retained.
Rather, I was suggesting that the in[] array be accessed with the
special loads.

-------------------- before patch --------------------

[452862.338505] testing speed of rmd128
[452862.354441] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   6064 cycles/operation,  379 cycles/byte
[452862.354535] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):  12016 cycles/operation,  187 cycles/byte
[452862.354672] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):  10800 cycles/operation,  168 cycles/byte
[452862.354795] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  31584 cycles/operation,  123 cycles/byte
[452862.355098] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):  26576 cycles/operation,  103 cycles/byte
[452862.355357] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):  24768 cycles/operation,   96 cycles/byte
[452862.355616] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  90112 cycles/operation,   88 cycles/byte
[452862.356482] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  41088 cycles/operation,   40 cycles/byte
[452862.356857] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  44656 cycles/operation,   43 cycles/byte
[452862.357248] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates): 135312 cycles/operation,   66 cycles/byte
[452862.358413] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  78352 cycles/operation,   38 cycles/byte
[452862.359152] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  86464 cycles/operation,   42 cycles/byte
[452862.359887] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  74336 cycles/operation,   36 cycles/byte
[452862.360543] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 258112 cycles/operation,   63 cycles/byte
[452862.362769] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates): 164992 cycles/operation,   40 cycles/byte
[452862.364202] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates): 146704 cycles/operation,   35 cycles/byte
[452862.365472] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 164176 cycles/operation,   40 cycles/byte
[452862.366938] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 470432 cycles/operation,   57 cycles/byte
[452862.371087] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 219328 cycles/operation,   26 cycles/byte
[452862.372977] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 212880 cycles/operation,   25 cycles/byte
[452862.374874] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 237872 cycles/operation,   29 cycles/byte
[452862.376857] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 222240 cycles/operation,   27 cycles/byte

-------------------- after patch --------------------

[453226.216294] testing speed of rmd128
[453226.216322] test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2784 cycles/operation,  174 cycles/byte
[453226.216381] test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   5296 cycles/operation,   82 cycles/byte
[453226.216448] test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   4336 cycles/operation,   67 cycles/byte
[453226.216506] test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  13360 cycles/operation,   52 cycles/byte
[453226.216640] test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   9856 cycles/operation,   38 cycles/byte
[453226.216745] test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   9008 cycles/operation,   35 cycles/byte
[453226.216842] test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  46032 cycles/operation,   44 cycles/byte
[453226.217254] test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  28640 cycles/operation,   27 cycles/byte
[453226.217519] test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  27808 cycles/operation,   27 cycles/byte
[453226.217777] test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  89600 cycles/operation,   43 cycles/byte
[453226.218558] test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  54800 cycles/operation,   26 cycles/byte
[453226.219046] test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  53168 cycles/operation,   25 cycles/byte
[453226.219519] test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  52864 cycles/operation,   25 cycles/byte
[453226.219991] test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 176640 cycles/operation,   43 cycles/byte
[453226.221511] test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates): 131008 cycles/operation,   31 cycles/byte
[453226.222592] test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates): 103840 cycles/operation,   25 cycles/byte
[453226.223502] test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates): 102960 cycles/operation,   25 cycles/byte
[453226.224402] test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 353760 cycles/operation,   43 cycles/byte
[453226.227424] test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 214496 cycles/operation,   26 cycles/byte
[453226.229271] test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 207952 cycles/operation,   25 cycles/byte
[453226.231063] test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 218960 cycles/operation,   26 cycles/byte
[453226.232922] test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 205664 cycles/operation,   25 cycles/byte

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 89a535a..9cf1a6d 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -44,7 +44,7 @@ struct rmd128_ctx {
 #define F4(x, y, z) (y ^ (z & (x ^ y)))	/* z ? x : y */
 
 #define ROUND(a, b, c, d, f, k, x, s)  { \
-	(a) += f((b), (c), (d)) + le32_to_cpu(x) + (k); \
+	(a) += f((b), (c), (d)) + le32_to_cpup(&(x)) + (k);	\
 	(a) = rol32((a), (s)); \
 }
 
