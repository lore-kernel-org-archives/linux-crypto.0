Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5008CC433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 20:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352796AbiEAUqx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 16:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbiEAUqx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 16:46:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E9C546AE
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 13:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B3C7B80EA5
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 20:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9B2C385A9;
        Sun,  1 May 2022 20:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651437803;
        bh=HkaB2k1urETW+5hoz+XEbl1Sx5RDJ+nPdkGne0xbums=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtIf1cqtk3qBYRRrTDD1GIdSxJqGwI8XDcCq+/GMHoc48NNGF5zeYN8qZlxdEyayM
         WZ27ATCxAsAMjoYxjbZlcah1U4ODd6PntYME1Bay8/aJuyNpVygbujovM3TCsLr4ph
         dKZ+Nsu8WF+nwk6QEn09H/kL8dJgcGzKYTtvhhLsOI20xpEkX8QYvlWnVVkh2QLg02
         FSs74jOWjiCYCs/0MpNZhO3PuCfJQb7ovpI17FgRVvj/h/mIbBXSb80nlvzw2OqklT
         hkCAzGU09IvwdvRMZWSIzPiSl863qKz+F20QJmVvaBk6qKRp8G6B4LKs/Kq//yn9JT
         nfFzTlFkkNNVQ==
Date:   Sun, 1 May 2022 13:43:15 -0700
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
Subject: Re: [PATCH v5 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <Ym7w47ngugGohQE/@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:57AM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
[...]
> + * The implementation below saves a XOR instruction by computing P_1 + T_0 : P_0
> + * + T_1 and XORing into dest, rather than separately XORing P_1 : P_0 and T_0 :
> + * T1 into dest.  This allows us to reuse P_1 + T_0 when computing V.

T1 => T_1

> +/*
> + * Perform montgomery multiplication in GF(2^128) and store result in op1.
> + *
> + * Computes op1*op2*x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1
> + * If op1, op2 are in montgomery form,	this computes the montgomery
> + * form of op1*op2.
> + *
> + * void clmul_polyval_mul(u8 *op1, const u8 *op2);
> + */

There's a tab in the middle of the text above.

> diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
> new file mode 100644
> index 000000000000..53d145c5bd40
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni_glue.c
> @@ -0,0 +1,200 @@
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

Same comments as on the arm64 version regarding the file comments

> +#include <crypto/gf128mul.h>

As in the arm64 version, <crypto/gf128mul.h> is unneeded.

> +static int polyval_x86_update(struct shash_desc *desc,
> +			 const u8 *src, unsigned int srclen)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);

Maybe use 'tctx' for the pointer to the polyval_tfm_ctx instead of just ctx, to
clearly distinguish it from dctx?  Likewise everywhere else.

> +	nblocks = srclen/POLYVAL_BLOCK_SIZE;
> +	internal_polyval_update(ctx, src, nblocks, dctx->buffer);
> +	srclen -= nblocks*POLYVAL_BLOCK_SIZE;
> +
> +	if (srclen) {
> +		dctx->bytes = POLYVAL_BLOCK_SIZE - srclen;
> +		src += nblocks*POLYVAL_BLOCK_SIZE;

As on the arm64 version, the length of SIMD regions need to be limited, with 4K
bytes being a good number.

> +static int polyval_x86_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +
> +	if (dctx->bytes) {
> +		internal_polyval_mul(dctx->buffer,
> +				     ctx->key_powers[NUM_KEY_POWERS-1]);
> +	}
> +
> +	dctx->bytes = 0;

As on the arm64 version, the line 'dctx->bytes = 0;' is unnecessary.

> +static const struct x86_cpu_id pcmul_cpu_id[] = {
> +	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL), /* Pickle-Mickle-Duck */
> +	{}
> +};
> +MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
> +
> +static int __init polyval_clmulni_mod_init(void)
> +{
> +	if (!x86_match_cpu(pcmul_cpu_id))
> +		return -ENODEV;
> +
> +	return crypto_register_shash(&polyval_alg);
> +}
> +
> +static void __exit polyval_clmulni_mod_exit(void)
> +{
> +	crypto_unregister_shash(&polyval_alg);
> +}
> +
> +module_init(polyval_clmulni_mod_init);
> +module_exit(polyval_clmulni_mod_exit);

Doesn't this need to check for AVX support too?

> diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
> index bf2b03b7bfc0..4f712b480cdd 100644
> --- a/crypto/polyval-generic.c
> +++ b/crypto/polyval-generic.c
> @@ -46,7 +46,6 @@
>  
>  #include <asm/unaligned.h>
>  #include <crypto/algapi.h>
> -#include <crypto/gf128mul.h>
>  #include <crypto/polyval.h>
>  #include <crypto/internal/hash.h>
>  #include <linux/crypto.h>
> @@ -66,8 +65,8 @@ struct polyval_desc_ctx {
>  	u32 bytes;
>  };
>  
> -static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
> -			     const u8 src[POLYVAL_BLOCK_SIZE])
> +void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
> +		     const u8 src[POLYVAL_BLOCK_SIZE])
>  {
>  	u64 a = get_unaligned((const u64 *)&src[0]);
>  	u64 b = get_unaligned((const u64 *)&src[8]);
> @@ -76,6 +75,44 @@ static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
>  	put_unaligned(swab64(b), (u64 *)&dst[0]);
>  }

copy_and_reverse() isn't used outside of this file, so it should be left static.

> +/*
> + * Performs multiplication in the POLYVAL field using the GHASH field as a
> + * subroutine.  This function is used as a fallback for hardware accelerated
> + * implementations when simd registers are unavailable.
> + *
> + * Note: This function is not used for polyval-generic, instead we use the 4k
> + * lookup table implementation for finite field multiplication.
> + */
> +void polyval_mul_non4k(u8 *op1, const u8 *op2)
> +{
> +	be128 a, b;
> +
> +	// Assume one argument is in Montgomery form and one is not.
> +	copy_and_reverse((u8 *)&a, op1);
> +	copy_and_reverse((u8 *)&b, op2);
> +	gf128mul_x_lle(&a, &a);
> +	gf128mul_lle(&a, &b);
> +	copy_and_reverse(op1, (u8 *)&a);
> +}
> +
> +/*
> + * Perform a POLYVAL update using non4k multiplication.  This function is used
> + * as a fallback for hardware accelerated implementations when simd registers
> + * are unavailable.
> + *
> + * Note: This function is not used for polyval-generic, instead we use the 4k
> + * lookup table implementation of finite field multiplication.
> + */
> +void polyval_update_non4k(const u8 *key, const u8 *in,
> +			  size_t nblocks, u8 *accumulator)
> +{
> +	while (nblocks--) {
> +		crypto_xor(accumulator, in, POLYVAL_BLOCK_SIZE);
> +		polyval_mul_non4k(accumulator, key);
> +		in += POLYVAL_BLOCK_SIZE;
> +	}
> +}

The above two functions need EXPORT_SYMBOL_GPL, as they are potentially being
called from a different module.

> diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
> index b14c38aa9166..bf64fb6c665f 100644
> --- a/include/crypto/polyval.h
> +++ b/include/crypto/polyval.h
> @@ -8,10 +8,19 @@
>  #ifndef _CRYPTO_POLYVAL_H
>  #define _CRYPTO_POLYVAL_H
>  
> +#include <crypto/gf128mul.h>

<crypto/gf128mul.h> doesn't appear to be needed here.

- Eric
