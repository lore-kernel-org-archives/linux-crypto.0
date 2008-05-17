From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Sat, 17 May 2008 10:20:56 +0200
Message-ID: <20080517082056.GB19540@Chamillionaire.breakpoint.cc>
References: <20080515200706.GA3081@Chamillionaire.breakpoint.cc> <20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53003 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYEQIU7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 04:20:59 -0400
Content-Disposition: inline
In-Reply-To: <20080517081003.GA19540@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Siewior | 2008-05-17 10:10:03 [+0200]:

>diff --git a/crypto/rmd128.c b/crypto/rmd128.c
>index 146a167..0d946a3 100644
>--- a/crypto/rmd128.c
>+++ b/crypto/rmd128.c
>-static inline void le32_to_cpu_array(u32 *buf, unsigned int words)
>-{
>-	while (words--) {
>-		le32_to_cpus(buf);
>-		buf++;
>-	}
>-}
>-
>-static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
>-{
>-	while (words--) {
>-		cpu_to_le32s(buf);
>-		buf++;
>-	}
>-}
>-
>-static inline void rmd128_transform_helper(struct rmd128_ctx *ctx)
>+static void rmd128_transform_helper(struct rmd128_ctx *ctx)
> {
>-	le32_to_cpu_array(ctx->buffer, sizeof(ctx->buffer) / sizeof(u32));
> 	rmd128_transform(ctx->state, ctx->buffer);
> }
Now, before someone asks why is it better to do the endian conversion in
rmd128_transform() instead in those inline functions, here are some
numbers:

Original code fixed:
~~~~~~~~~~~~~~~~~~~~
testing speed of rmd128
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    104 cycles/operation,    6 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    201 cycles/operation,    3 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    161 cycles/operation,    2 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    518 cycles/operation,    2 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    367 cycles/operation,    1 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    331 cycles/operation,    1 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   1793 cycles/operation,    1 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1048 cycles/operation,    1 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1005 cycles/operation,    0 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   3493 cycles/operation,    1 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2003 cycles/operation,    0 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   1919 cycles/operation,    0 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   1904 cycles/operation,    0 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   6893 cycles/operation,    1 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   3913 cycles/operation,    0 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   3745 cycles/operation,    0 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   3701 cycles/operation,    0 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  13694 cycles/operation,    1 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   7732 cycles/operation,    0 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   7396 cycles/operation,    0 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   7311 cycles/operation,    0 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   7305 cycles/operation,    0 cycles/byte

moved cpu_to_le32 into rmd128_transform()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
testing speed of rmd128
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    103 cycles/operation,    6 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    197 cycles/operation,    3 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    159 cycles/operation,    2 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    510 cycles/operation,    1 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    361 cycles/operation,    1 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    327 cycles/operation,    1 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   1771 cycles/operation,    1 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1034 cycles/operation,    1 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    992 cycles/operation,    0 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   3451 cycles/operation,    1 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   1979 cycles/operation,    0 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   1896 cycles/operation,    0 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   1882 cycles/operation,    0 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   6812 cycles/operation,    1 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   3864 cycles/operation,    0 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   3697 cycles/operation,    0 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   3655 cycles/operation,    0 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  13533 cycles/operation,    1 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   7638 cycles/operation,    0 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   7304 cycles/operation,    0 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   7219 cycles/operation,    0 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   7214 cycles/operation,    0 cycles/byte

Switched from cpu_to_le32 to cpu_to_le32p:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
testing speed of rmd128
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    122 cycles/operation,    7 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    235 cycles/operation,    3 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    197 cycles/operation,    3 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):    609 cycles/operation,    2 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    458 cycles/operation,    1 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    424 cycles/operation,    1 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   2106 cycles/operation,    2 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):   1367 cycles/operation,    1 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):   1324 cycles/operation,    1 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   4104 cycles/operation,    2 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):   2625 cycles/operation,    1 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):   2539 cycles/operation,    1 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):   2524 cycles/operation,    1 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):   8099 cycles/operation,    1 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   5140 cycles/operation,    1 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):   4968 cycles/operation,    1 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):   4924 cycles/operation,    1 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  16089 cycles/operation,    1 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):  10169 cycles/operation,    1 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):   9826 cycles/operation,    1 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):   9739 cycles/operation,    1 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):   9733 cycles/operation,    1 cycles/byte

Sebastian
