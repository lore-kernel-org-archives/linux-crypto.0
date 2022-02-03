Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3DCC433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Feb 2022 03:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346775AbiBCD2X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 22:28:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42952 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiBCD2W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 22:28:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837B761684
        for <linux-crypto@vger.kernel.org>; Thu,  3 Feb 2022 03:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A33C004E1;
        Thu,  3 Feb 2022 03:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643858901;
        bh=GanPX+REtdFc3lY3IuZ3z0DaAmwKSNWMr7nM3zMuurY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJ88fqZ06bCycATKYd2yuGd79Sbu+AVEbLjZGsqvjhO2SpGaKXO9JPmieBWiNBnwI
         La5COp5Ukqkg11if/Iq79Qp2PEn/P1YOKkYtnfe8rDDk9MjQppw/uMtNZFfeVWWwAD
         yo2quCzn4bP/FimVoPdffd5zgiErQn4WhEqYr/+2mu4YmI7eFw9s+19ZlFlfFk44dl
         iMlfpARjomG6o8C6UXwrY8sr4sQZ/t8mmyH1+JxEqJXGNmcJYLNWhGu4PBirzbCuOG
         EAXPVtorj6SmON0ep+53XxzxS/hG+JLCDbYghhRmVDzeYz4fyhO3V3RRHOFZ2QCLE1
         Ej0k9BlZW/oNw==
Date:   Wed, 2 Feb 2022 19:28:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 6/7] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YftL1GKq/PfuYxvJ@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125014422.80552-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[Note that many of these comments will apply to the arm64 version too.]

On Mon, Jan 24, 2022 at 07:44:21PM -0600, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for x86-64 CPUs with
> PCLMULQDQ support.
> 
> This implementation is accelerated using PCLMULQDQ instructions to
> perform the finite field computations.  For added efficiency, 8 blocks
> of the plaintext are processed simultaneously by precomputing the first

plaintext => message

> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index ed187fcd0b01..0214c5f22606 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -69,6 +69,9 @@ libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
>  obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
>  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
>  
> +obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI_INTEL) += polyval-clmulni-intel.o
> +polyval-clmulni-intel-y := polyval-clmulni-intel_asm.o polyval-clmulni-intel_glue.o
> +

IMO this should be named just polyval-clmulni.  Including "intel" is a bit
gratuituous, given that AMD supports this too, and this is in the x86 directory.
I guess that some of the authors of some of the existing files wanted to include
their company name.  Doesn't actually matter, though; it's up to you.

> diff --git a/arch/x86/crypto/polyval-clmulni-intel_asm.S b/arch/x86/crypto/polyval-clmulni-intel_asm.S
> new file mode 100644
> index 000000000000..4339b58e610d
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni-intel_asm.S
> @@ -0,0 +1,319 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2021 Google LLC
> + *
> + * Use of this source code is governed by an MIT-style
> + * license that can be found in the LICENSE file or at
> + * https://opensource.org/licenses/MIT.
> + */
> +/*
> + * This is an efficient implementation of POLYVAL using intel PCLMULQDQ-NI
> + * instructions. It works on 8 blocks at a time, computing the 256 degree
> + * polynomial p(x) = h^8m_0 + ... + h^1m_7. It then computes the modular
> + * reduction of p(x) and XORs p(x) with the current digest.
> + */

What does "256 degree polynomial" mean here?

> +/*
> + * Accepts operand lists of length b in rdi and rsi.

In general the first sentence of a comment describing a function or macro should
be a summary of what it does, not some particular detail.

> + * Computes the product of
> + * each rdi,rsi pair then XORs the products into A, B, C, D.

Where are A, B, and rsi used?

> + * If first == 1 then XOR the value of SUM into the first block processed.
> + * This avoids an extra multication of SUM and h^N.

first == 1 on the *last* call per 8 blocks.  Perhaps it needs a better name?

> + * All other xmm registers clobbered

This doesn't appear to be true; the code relies on GSTAR not being clobbered.

> +.macro schoolbook1_iteration i first
> +	.set first, \first
> +	.set i, \i
> +	movups (16*i)(OP1), %xmm0
> +	.if(i == 0 && first == 1)
> +		pxor SUM, %xmm0
> +	.endif

I don't think the ".set" statements are necessary here.  You can just use \i and
\first directly.

> +/*
> + * Computes first schoolbook step of values loaded into xmm0 and xmm1. Used to
> + * multiply intermediate register values rather than memory stored values.
> + *
> + * XORs product into C, D, EF
> + * Preserves SUM
> + * All other xmm registers clobbered
> + */
> +.macro schoolbook1_noload
> +	vpclmulqdq $0x01, %xmm0, %xmm1, %xmm2
> +	vpxor %xmm2, EF, EF
> +	vpclmulqdq $0x00, %xmm0, %xmm1, %xmm3
> +	vpxor %xmm3, C, C
> +	vpclmulqdq $0x11, %xmm0, %xmm1, %xmm4
> +	vpxor %xmm4, D, D
> +	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm5
> +	vpxor %xmm5, EF, EF
> +.endm

So C holds the low part of the product, EF the middle part, and D the high part.
How about giving these better names, like LO, MID, and HI?

> +/*
> + * Computes the 128-bit reduction of PL, PH. Stores the result in PH.
> + *
> + * PL, PH, Z, T.
> + * All other xmm registers are preserved.
> + */
> +.macro montgomery_reduction
> +	movdqa PL, T
> +	pclmulqdq $0x00, GSTAR, T # T = [X0 * g*(x)]
> +	pshufd $0b01001110, T, Z # Z = [T0 : T1]
> +	pxor Z, PL # PL = [X1 ^ T0 : X0 ^ T1]
> +	pxor PL, PH # PH = [X1 ^ T0 ^ X3 : X0 ^ T1 ^ X2]
> +	pclmulqdq $0x11, GSTAR, PL # PL = [X1 ^ T0 * g*(x)]
> +	pxor PL, PH
> +.endm

This really needs a comment that describes at a high level what is going on --
adding multiples of the reduction polynomial to cancel out the low-order parts.
And also how Montgomery multiplication works in this context.  The one-line
comments don't help much, especially since "X" is never defined.

Also, it seems like you've implemented an optimization that avoids a second
pshufd instruction, over the simpler approach of folding 64 bits up twice in the
same way.  Can you add a comment that explains this?

Also what do the names T and Z mean?  If they're just temporary values, TMP1 and
TMP2 might be better names.

> +/*
> + * Compute schoolbook multiplication for 8 blocks
> + * (M_0h + REDUCE(PL, PH))h^8 + ... + M_{7}h^1 (no constant term)

Shouldn't M_0h be just M_0?

Also, isn't the REDUCE part conditional on \reduce?

> +/*
> + * Perform polynomial evaluation as specified by POLYVAL. Multiplies the value
> + * stored at accumulator by h^k and XORs the evaluated polynomial into it.

What is 'k'?

> + *
> + * Computes h^k*accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)
> + *
> + * rdi (OP1) - pointer to message blocks
> + * rsi - pointer to precomputed key struct
> + * rdx - number of blocks to hash
> + * rcx - location to XOR with evaluated polynomial
> + *
> + * void clmul_polyval_update(const u8 *in, const struct polyhash_key* keys,
> + *			     size_t nblocks, ble128* accumulator);
> + */

struct polyhash_key isn't defined anywhere.

> diff --git a/arch/x86/crypto/polyval-clmulni-intel_glue.c b/arch/x86/crypto/polyval-clmulni-intel_glue.c
> new file mode 100644
> index 000000000000..64a432b67b49
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni-intel_glue.c
> @@ -0,0 +1,165 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Accelerated POLYVAL implementation with Intel PCLMULQDQ-NI
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
> + * This implementation of POLYVAL uses montgomery multiplication
> + * accelerated by PCLMULQDQ-NI to implement the finite field
> + * operations.
> + *
> + */
> +
> +#include <crypto/algapi.h>
> +#include <crypto/gf128mul.h>
> +#include <crypto/internal/hash.h>
> +#include <linux/crypto.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <asm/simd.h>
> +
> +#define POLYVAL_BLOCK_SIZE	16
> +#define POLYVAL_DIGEST_SIZE	16

How about including <crypto/polyval.h> (added by an earlier patch) to get these
definitions?

> +#define NUM_PRECOMPUTE_POWERS	8
> +
> +struct polyval_ctx {
> +	be128 key_powers[NUM_PRECOMPUTE_POWERS];
> +};

There should be a comment that says what order the key_powers are in.

Also why is the type be128?  These aren't big endian.

> +static int polyval_setkey(struct crypto_shash *tfm,
> +			const u8 *key, unsigned int keylen)
> +{
> +	struct polyval_ctx *ctx = crypto_shash_ctx(tfm);
> +	int i;
> +
> +	if (keylen != POLYVAL_BLOCK_SIZE)
> +		return -EINVAL;

This could use a:

	BUILD_BUG_ON(POLYVAL_BLOCK_SIZE != sizeof(be128));

> +
> +	memcpy(&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key, sizeof(be128));
> +
> +	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
> +		memcpy(&ctx->key_powers[i], key, sizeof(be128));
> +		clmul_polyval_mul(&ctx->key_powers[i], &ctx->key_powers[i+1]);
> +	}

It appears this is using the SIMD registers without first executing
kernel_fpu_begin(), which isn't valid.

> +static int polyval_update(struct shash_desc *desc,
> +			 const u8 *src, unsigned int srclen)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	struct polyval_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *dst = dctx->buffer;
> +	u8 *pos;
> +	unsigned int nblocks;
> +	int n;
> +
> +	kernel_fpu_begin();
> +	if (dctx->bytes) {
> +		n = min(srclen, dctx->bytes);
> +		pos = dst + POLYVAL_BLOCK_SIZE - dctx->bytes;
> +
> +		dctx->bytes -= n;
> +		srclen -= n;
> +
> +		while (n--)
> +			*pos++ ^= *src++;
> +
> +		if (!dctx->bytes)
> +			clmul_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);

Casting u8 to be128 violates alignment rules.  Given that clmul_polyval_mul()
uses the unaligned load/store instructions on this argument, its type should be
a byte pointer.

> +static int polyval_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	struct polyval_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *buf = dctx->buffer;
> +
> +	if (dctx->bytes) {
> +		kernel_fpu_begin();
> +		clmul_polyval_mul((be128 *)dst, &ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);
> +		kernel_fpu_end();
> +	}

The above call to clmul_polyval_mul() is incorrect as it is reading from *dst
before writing to it.  Presumably non-block-multiple messages aren't being
tested?  I don't think that such messages make sense, so how about returning an
error in that case instead?

> +static struct shash_alg polyval_alg = {
> +	.digestsize	= POLYVAL_DIGEST_SIZE,
> +	.init		= polyval_init,
> +	.update		= polyval_update,
> +	.final		= polyval_final,
> +	.setkey		= polyval_setkey,
> +	.descsize	= sizeof(struct polyval_desc_ctx),
> +	.base		= {
> +		.cra_name		= "polyval",
> +		.cra_driver_name	= "polyval-pclmulqdqni",

How about "polyval-clmulni", like "ghash-clmulni"?  pclmulqdqni is a mouthful.

> +		.cra_priority		= 200,
> +		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
> +		.cra_ctxsize		= sizeof(struct polyval_ctx),
> +		.cra_module		= THIS_MODULE,
> +	},
> +};
> +
> +static int __init polyval_mod_init(void)
> +{
> +	return crypto_register_shash(&polyval_alg);
> +}
> +
> +static void __exit polyval_mod_exit(void)
> +{
> +	crypto_unregister_shash(&polyval_alg);
> +}

Hmm, so this isn't being wrapped with an ahash like the ghash implementation is.
Unfortunately, I don't think that's allowed, since you are assuming that the
code is always called in a context where SIMD instructions are usable.  I don't
think that's the case on x86; the other x86 crypto code goes to some length to
avoid this.

Unless anyone else has any better idea, I think you'll have to make the shash an
internal algorithm, and wrap it with an ahash algorithm, like "ghash-clmulni"
does.

Ideally you'd refactor the ahash helper code from ghash-clmulni into
crypto/simd.c, as otherwise you'll need to copy+paste essentially.

> +
> +subsys_initcall(polyval_mod_init);
> +module_exit(polyval_mod_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
> +MODULE_ALIAS_CRYPTO("polyval");

A MODULE_ALIAS_CRYPTO for the cra_driver_name should be added too.

- Eric
