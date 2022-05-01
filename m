Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47418C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 20:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiEAUZU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 16:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiEAUZU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 16:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B52393D0
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 13:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE6161018
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 20:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC20DC385A9;
        Sun,  1 May 2022 20:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651436512;
        bh=nq2tgBxmX99KHa0tH8GkpFgnkfmQDbB5XJSHDeTZEWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=baX9sttII7EpLm4Kzy8B//ZNJwF5elQqqhjIjSb1bTvmd/areCP4CnL1KcsugXspE
         ZzKQwE7mJbYx7H43J0/eNRqCpi4Zm/4niAz9S0r9FkqJtz/ywO5zpFKZQDbqm8o4F2
         Psu3tj46pDLe/WvP4SD/TzZd4o7RpJx5lV7rpRju7ri1cmAXezSqwEc3u7d7tym4b4
         9csjoYHkR3CzGs/8F1eggF9X2V74ASO8Qj856acYa0LLcwomexKY8NmyGpb1RLjM0Y
         y54/RDvo1XwP0R/gvqSblCRYdtmSXosG2dSRaUYPPqW6Xh5gVXtHWKy2hRtQLQYzCw
         GpbAK2Zf84ulQ==
Date:   Sun, 1 May 2022 13:21:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 7/8] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <Ym7r1vt4G1xX58Kv@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-8-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:58AM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for ARM64 CPUs with
> Crypto Extensions support.
> 
> This implementation is accelerated using PMULL instructions to perform
> the finite field computations.  For added efficiency, 8 blocks of the
> message are processed simultaneously by precomputing the first 8
> powers of the key.
> 
> Karatsuba multiplication is used instead of Schoolbook multiplication
> because it was found to be slightly faster on ARM64 CPUs.  Montgomery
> reduction must be used instead of Barrett reduction due to the
> difference in modulus between POLYVAL's field and other finite fields.
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/Kconfig              |   5 +
>  arch/arm64/crypto/Makefile             |   3 +
>  arch/arm64/crypto/polyval-ce-core.S    | 369 +++++++++++++++++++++++++
>  arch/arm64/crypto/polyval-ce-glue.c    | 194 +++++++++++++
>  arch/x86/crypto/polyval-clmulni_glue.c |   2 +-
>  5 files changed, 572 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/crypto/polyval-ce-core.S
>  create mode 100644 arch/arm64/crypto/polyval-ce-glue.c

This patch shouldn't be changing arch/x86/.  It looks like that hunk was folded
into the wrong patch.

> diff --git a/arch/arm64/crypto/polyval-ce-core.S b/arch/arm64/crypto/polyval-ce-core.S
> new file mode 100644
> index 000000000000..87e7223ea9b6
> --- /dev/null
> +++ b/arch/arm64/crypto/polyval-ce-core.S
> @@ -0,0 +1,369 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Implementation of POLYVAL using ARMv8 Crypto Extensions.
> + *
> + * Copyright 2021 Google LLC
> + */

This file is looking good, just a few readability suggestions:

> +BLOCKS_LEFT	.req	x2
> +KEY_START	.req	x10
> +EXTRA_BYTES	.req	x11
> +TMP	.req	x13

It would help to also define and use aliases for the other arguments to
pmull_polyval_update(), e.g.:

KEY_POWERS	.req	x0
MSG		.req	x1
BLOCKS_LEFT	.req	x2
ACCUMULATOR	.req	x3

Note that the x86 implementation does this for the first three.

> +/*
> + * Computes the 256-bit polynomial represented by LO, HI, MI. Stores
> + * the result in PL, PH.
> + * [PH : PL] =
> + *   [HI_1 : HI_0 + HI_1 + MI_1 + LO_1 : LO_1 + LO_0 + MI_0 + HI_0 : LO_0]
> + */
> +.macro karatsuba2
> +	// v4 = [HI_1 + MI_1 : HI_0 + MI_0]
> +	eor	v4.16b, HI.16b, MI.16b
> +	// v4 = [HI_1 + MI_1 + LO_1 : HI_0 + MI_0 + LO_0]
> +	eor	v4.16b, v4.16b, LO.16b
> +	// v5 = [HI_0 : LO_1]
> +	ext	v5.16b, LO.16b, HI.16b, #8
> +	// v4 = [HI_0 + HI_1 + MI_1 + LO_1 : LO_1 + LO_0 + MI_0 + HI_0]
> +	eor	v4.16b, v4.16b, v5.16b
> +	// HI = [HI_0 : HI_1]
> +	ext	HI.16b, HI.16b, HI.16b, #8
> +	// LO = [LO_0 : LO_1]
> +	ext	LO.16b, LO.16b, LO.16b, #8
> +	// PH = [HI_1 : HI_0 + HI_1 + MI_1 + LO_1]
> +	ext	PH.16b, v4.16b, HI.16b, #8
> +	// PL = [LO_1 + LO_0 + MI_0 + HI_0 : LO_0]
> +	ext	PL.16b, LO.16b, v4.16b, #8
> +.endm

You know that I'm very picky about ordering :-)  I got a little confused while
reading this because "HI_0 + MI_0 + LO_0" changes to "LO_0 + MI_0 + HI_0"
partway through.  It would be better to use a consistent order the whole time,
probably "HI_0 + MI_0 + LO_0" since that maps naturally onto what the first two
lines do.  Note, the comment above the macro will need to be updated too.

> +/*
> + * Computes the 128-bit reduction of PL, PH. Stores the result in dest.
> + *
> + * This macro computes p(x) mod g(x) where p(x) is in montgomery form and g(x) =
> + * x^128 + x^127 + x^126 + x^121 + 1.
> + *
> + * We have a 256-bit polynomial P_H : P_L = P_3 : P_2 : P_1 : P_0 that is the
> + * product of two 128-bit polynomials in Montgomery form.  We need to reduce it
> + * mod g(x).  Also, since polynomials in Montgomery form have an "extra" factor
> + * of x^128, this product has two extra factors of x^128.  To get it back into
> + * Montgomery form, we need to remove one of these factors by dividing by x^128.
> + *
> + * To accomplish both of these goals, we add multiples of g(x) that cancel out
> + * the low 128 bits P_1 : P_0, leaving just the high 128 bits. Since the low
> + * bits are zero, the polynomial division by x^128 can be done by right shifting.
> + *
> + * Since the only nonzero term in the low 64 bits of g(x) is the constant term,
> + * the multiple of g(x) needed to cancel out P_0 is P_0 * g(x).  The CPU can
> + * only do 64x64 bit multiplications, so split P_0 * g(x) into x^128 * P_0 +
> + * x^64 * g*(x) * P_0 + P_0, where g*(x) is bits 64-127 of g(x).  Adding this to
> + * the original polynomial gives P_3 : P_2 + P_0 + T_1 : P_1 + T_0 : 0, where T
> + * = T_1 : T_0 = g*(x) * P_0.  Thus, bits 0-63 got "folded" into bits 64-191.
> + *
> + * Repeating this same process on the next 64 bits "folds" bits 64-127 into bits
> + * 128-255, giving the answer in bits 128-255. This time, we need to cancel P_1
> + * + T_0 in bits 64-127. The multiple of g(x) required is (P_1 + T_0) * g(x) *
> + * x^64. Adding this to our previous computation gives P_3 + P_1 + T_0 + V_1 :
> + * P_2 + P_0 + T_1 + V_0 : 0 : 0, where V = V_1 : V_0 = g*(x) * (P_1 + T_0).
> + *
> + * So our final computation is:
> + *   T = T_1 : T_0 = g*(x) * P_0
> + *   V = V_1 : V_0 = g*(x) * (P_1 + T_0)
> + *   p(x) / x^{128} mod g(x) = P_3 + P_1 + T_0 + V_1 : P_2 + P_0 + T_1 + V_0
> + *
> + * The implementation below saves a XOR instruction by computing P_1 + T_0 : P_0
> + * + T_1 and XORing it into dest, rather than separately XORing P_1 : P_0, T_0 :
> + * T1 into dest.  This allows us to reuse P_1 + T_0 when computing V.
> + */

Can you get this comment in sync with the x86 version?  They should be identical
(there's nothing x86 or arm64 specific here), but there are some updates you
made to the x86 version that didn't make it into here.

> +.macro montgomery_reduction dest
> +	DEST .req \dest
> +	// TMP_V = T_1 : T_0 = P_0 * g*(x)
> +	pmull	TMP_V.1q, GSTAR.1d, PL.1d

Put GSTAR as the last argument, to match the comment?  Likewise for the other
3 multiplications with GSTAR in the file.

> +	eor	DEST.16b, TMP_V.16b, PH.16b

Similarly, swapping TMP_V and PH above (and in partial_reduce) would make the
code match the comments naturally.

> +/*
> + * Handle any extra blocks before
> + * full_stride loop.
> + */

It's after full_stride loop, not before.  Also this comment can fit on one line:

/* Handle any extra blocks after the full_stride loop. */

> +.macro partial_stride
> +	add	x0, KEY_START, #(STRIDE_BLOCKS << 4)
> +	sub	x0, x0, BLOCKS_LEFT, lsl #4
> +	// Clobber key register
> +	ld1	{KEY1.16b}, [x0], #16
> +
> +	ld1	{TMP_V.16b}, [x1], #16
> +	eor	SUM.16b, SUM.16b, TMP_V.16b
> +	karatsuba1_store KEY1 SUM
> +	sub	BLOCKS_LEFT, BLOCKS_LEFT, #1
> +
> +	tst	BLOCKS_LEFT, #4
> +	beq	.Lpartial4BlocksDone
> +	ld1	{M0.16b, M1.16b,  M2.16b, M3.16b}, [x1], #64
> +	// Clobber key registers
> +	ld1	{KEY8.16b, KEY7.16b, KEY6.16b,	KEY5.16b}, [x0], #64
> +	karatsuba1 M0 KEY8
> +	karatsuba1 M1 KEY7
> +	karatsuba1 M2 KEY6
> +	karatsuba1 M3 KEY5
> +.Lpartial4BlocksDone:
> +	tst	BLOCKS_LEFT, #2
> +	beq	.Lpartial2BlocksDone
> +	ld1	{M0.16b, M1.16b}, [x1], #32
> +	// Clobber key registers
> +	ld1	{KEY8.16b, KEY7.16b}, [x0], #32
> +	karatsuba1 M0 KEY8
> +	karatsuba1 M1 KEY7
> +.Lpartial2BlocksDone:
> +	tst	BLOCKS_LEFT, #1
> +	beq	.LpartialDone
> +	ld1	{M0.16b}, [x1], #16
> +	// Clobber key registers
> +	ld1	{KEY8.16b}, [x0], #16
> +	karatsuba1 M0 KEY8
> +.LpartialDone:
> +	karatsuba2
> +	montgomery_reduction SUM
> +.endm

I don't understand the purpose of the "Clobber key registers" comments above.
"Clobber" makes it sound like they are being reused for something other than the
key powers, but they aren't.

> diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
> new file mode 100644
> index 000000000000..fd8e016d3a73
> --- /dev/null
> +++ b/arch/arm64/crypto/polyval-ce-glue.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerated POLYVAL implementation with ARMv8 Crypto Extensions
> + * instructions. This file contains glue code.
> + *
> + * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
> + * Copyright (c) 2009 Intel Corp.
> + *   Author: Huang Ying <ying.huang@intel.com>
> + * Copyright 2021 Google LLC
> + */
> +/*
> + * Glue code based on ghash-clmulni-intel_glue.c.
> + *
> + * This implementation of POLYVAL uses montgomery multiplication accelerated by
> + * ARMv8 Crypto Extensions instructions to implement the finite field operations.
> + *
> + */

There's an extra newline in the second block comment.  Also, given that there's
a standalone block comment that describes the file, the description at the very
top should be a one-line summary.  So maybe something like:

// SPDX-License-Identifier: GPL-2.0-only
/*
 * Glue code for POLYVAL using ARMv8 Crypto Extensions
 *
 * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
 * Copyright (c) 2009 Intel Corp.
 *   Author: Huang Ying <ying.huang@intel.com>
 * Copyright 2021 Google LLC
 */

/*
 * Glue code based on ghash-clmulni-intel_glue.c.
 *
 * This implementation of POLYVAL uses montgomery multiplication accelerated by
 * ARMv8 Crypto Extensions instructions to implement the finite field operations.
 */

> +
> +#include <crypto/algapi.h>
> +#include <crypto/gf128mul.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
> +#include <crypto/polyval.h>
> +#include <linux/crypto.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/cpufeature.h>
> +#include <asm/neon.h>
> +#include <asm/simd.h>
> +#include <asm/unaligned.h>

<crypto/gf128mul.h> and <asm/unaligned.h> don't appear to be used.

> +	memcpy(ctx->key_powers[NUM_KEY_POWERS-1], key,
> +	       POLYVAL_BLOCK_SIZE);

This fits on one line.

> +static int polyval_arm64_update(struct shash_desc *desc,
> +			 const u8 *src, unsigned int srclen)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *pos;
> +	unsigned int nblocks;
> +	unsigned int n;
> +
> +	if (dctx->bytes) {
> +		n = min(srclen, dctx->bytes);
> +		pos = dctx->buffer + POLYVAL_BLOCK_SIZE - dctx->bytes;
> +
> +		dctx->bytes -= n;
> +		srclen -= n;
> +
> +		while (n--)
> +			*pos++ ^= *src++;
> +
> +		if (!dctx->bytes)
> +			internal_polyval_mul(dctx->buffer,
> +				ctx->key_powers[NUM_KEY_POWERS-1]);
> +	}
> +
> +	nblocks = srclen/POLYVAL_BLOCK_SIZE;
> +	internal_polyval_update(ctx, src, nblocks, dctx->buffer);
> +	srclen -= nblocks*POLYVAL_BLOCK_SIZE;

This is executing a kernel_neon_begin()/kernel_neon_end() section of unbounded
length.  To allow the task to be preempted occasionally, it needs to handle the
input in chunks, e.g. 4K at a time, like the existing code for other algorithms
does.  Something like the following would work:

@@ -122,13 +118,16 @@ static int polyval_arm64_update(struct shash_desc *desc,
 				ctx->key_powers[NUM_KEY_POWERS-1]);
 	}
 
-	nblocks = srclen/POLYVAL_BLOCK_SIZE;
-	internal_polyval_update(ctx, src, nblocks, dctx->buffer);
-	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
+	while (srclen >= POLYVAL_BLOCK_SIZE) {
+		/* Allow rescheduling every 4K bytes. */
+		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
+		internal_polyval_update(ctx, src, nblocks, dctx->buffer);
+		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
+		src += nblocks * POLYVAL_BLOCK_SIZE;
+	}
 
 	if (srclen) {
 		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
-		src += nblocks*POLYVAL_BLOCK_SIZE;
 		pos = dctx->buffer;
 		while (srclen--)
 			*pos++ ^= *src++;

> +	struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);

struct polyval_tfm_ctx should be const everywhere except in ->setkey.

> +static int polyval_arm64_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +
> +	if (dctx->bytes) {
> +		internal_polyval_mul(dctx->buffer,
> +			ctx->key_powers[NUM_KEY_POWERS-1]);
> +	}
> +
> +	dctx->bytes = 0;
> +	memcpy(dst, dctx->buffer, POLYVAL_BLOCK_SIZE);
> +
> +	return 0;
> +}

The line 'dctx->bytes = 0;' is unnecessary.

> +static int __init polyval_ce_mod_init(void)
> +{
> +	if (!cpu_have_named_feature(PMULL))
> +		return -ENODEV;
> +	return crypto_register_shash(&polyval_alg);
> +}

The cpu_have_named_feature() check above is unnecessary since it is already
included in what module_cpu_feature_match() expands into.

- Eric
