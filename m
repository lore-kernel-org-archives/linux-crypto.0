Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A174C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 00:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbiBSAes (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Feb 2022 19:34:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiBSAer (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Feb 2022 19:34:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4A3177E6F
        for <linux-crypto@vger.kernel.org>; Fri, 18 Feb 2022 16:34:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C38161F97
        for <linux-crypto@vger.kernel.org>; Sat, 19 Feb 2022 00:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C22C340E9;
        Sat, 19 Feb 2022 00:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645230868;
        bh=jvCI3AnrYXKKS9HilvBTYIJJpalCUHUXHi6S5cwCJQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1dGqAmu1me3GmqAKLQ/2gy/IK4mPG80+LcTTqNivwJBPhhcLWIa3T/y+BdSzVkQX
         9VEbSoW+SVAGmS8s4yIa/LxFidVzknwn6BbP5GEUu37F28p5PwFRYxVZywOFelsM8+
         HV3IHuNcZsSYQ3PrOdhKOwwGVxe/Dn0sTuoVmbqwZIJeSFOP0EKret+vOWca+gQQ/j
         BbtIicomyEgbdvwl5No2EkkH9FTUZ7o1z7BJRwr2FjiNrg4+wsAn2k4emWXSSkoYGM
         6PAJPjjHFe3Z4yxH01xzcqMcdPfnIjifnqZdUNcNc6sAPSrUTM5ulnd852BXz66QrL
         /XQBVdN8r1LDQ==
Date:   Fri, 18 Feb 2022 16:34:26 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 6/7] crypto: x86/polyval: Add PCLMULQDQ
 accelerated implementation of POLYVAL
Message-ID: <YhA7Ej8UfyCwkTNa@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210232812.798387-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Huck, sorry for the slow reviews.  Some comments on this:

On Thu, Feb 10, 2022 at 11:28:11PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
> new file mode 100644
> index 000000000000..bec1a2046b18
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni_asm.S
> @@ -0,0 +1,414 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2021 Google LLC
> + *
> + * Use of this source code is governed by an MIT-style
> + * license that can be found in the LICENSE file or at
> + * https://opensource.org/licenses/MIT.
> + */

You're intending this file to be GPL-2.0 only, right?  (That's what I'd
recommend.)  In that case, the mention of the MIT license needs to be removed.

> +Lgstar:
> +	.quad 0xc200000000000000, 0xc200000000000000

Local labels need to start with ".L", not just "L" (note the period).

> +/*
> + * Performs schoolbook1_iteration on two lists of 128-bit polynomials of length
> + * b pointed to by OP1 and OP2.
> + */

How about renaming OP1 and OP2 to MSG and KEY_POWERS, respectively?  (Or KEYS
instead of KEY_POWERS if you want something less verbose.)  The naming and
comments make it sound like OP1 and OP2 are interchangable, but they actually
aren't.  schoolbook1_iteration assumes that OP1 may be unaligned while OP2 is
aligned, which implies that OP1 is the message and OP2 is the key powers.

> +.macro schoolbook1 b
> +	.set by, \b
> +	.set i, 0
> +	.rept (by)
> +		schoolbook1_iteration i 0
> +		.set i, (i +1)
> +	.endr
> +.endm

Rename 'b' to 'count' to make it clear what it is?

Also, the line '.set by, \b' is unnecessary, since you could just use the macro
argument directly instead.  (I mentioned unnecessary .set statements elsewhere
on v1.  Make sure to go through and address the same issue everywhere.)

I.e., this could be:

.macro schoolbook1 count
        .set i, 0
	.rept \count
		schoolbook1_iteration i 0
		.set i, i + 1
	.endr
.endm

> +/*
> + * Computes the product of two 128-bit polynomials at the memory locations
> + * specified by (OP1 + 16*i) and (OP2 + 16*i) and XORs the components of the
> + * 256-bit product into LO, MI, HI.
> + *
> + * The multiplication produces four parts:
> + *   LOW: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of each polynomial
> + *   MID1: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of the first polynomial and the top 64-bits of the second
> + *   MID2: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of the second polynomial and the top 64-bits of the first
> + *   HIGH: The polynomial given by performing carryless multiplication of the
> + *   top 64-bits of each polynomial
> + *
> + * We compute:
> + *  LO ^= LOW
> + *  Mi ^= MID1 ^ MID2
> + *  Hi ^= HIGH

Mi => MI, and Hi => HI?

> + *
> + * Later, the 256-bit result can be extracted as:
> + *   [HI_H : HI_L ^ MI_H : LO_H ^ MI_L : LO_L]
> + * This step is done when computing the polynomial reduction for efficiency
> + * reasons.
> + *
> + * If xor_sum == 1 then XOR the value of SUM into m_0.

In comments, please make it clear whether something is an additional behavior or
an alternative behavior.  In this case it's the former, so:

	If xor_sum == 1, then also XOR ...

> + * This avoids an extra multication of SUM and h^N.

multication => multiplication

> +.macro schoolbook1_iteration i xor_sum
> +	.set i, \i
> +	.set xor_sum, \xor_sum
> +	movups (16*i)(OP1), %xmm0
> +	.if(i == 0 && xor_sum == 1)
> +		pxor SUM, %xmm0
> +	.endif
> +	vpclmulqdq $0x01, (16*i)(OP2), %xmm0, %xmm1
> +	vpxor %xmm1, MI, MI
> +	vpclmulqdq $0x00, (16*i)(OP2), %xmm0, %xmm2
> +	vpxor %xmm2, LO, LO
> +	vpclmulqdq $0x11, (16*i)(OP2), %xmm0, %xmm3
> +	vpxor %xmm3, HI, HI
> +	vpclmulqdq $0x10, (16*i)(OP2), %xmm0, %xmm4
> +	vpxor %xmm4, MI, MI

Perhaps the above multiplications and XORs should be reordered slightly so that
each XOR doesn't depend on the previous instruction?  A good ordering might be:

	vpclmulqdq $0x01, (16*\i)(OP2), %xmm0, %xmm1
	vpclmulqdq $0x10, (16*\i)(OP2), %xmm0, %xmm2
	vpclmulqdq $0x00, (16*\i)(OP2), %xmm0, %xmm3
	vpclmulqdq $0x11, (16*\i)(OP2), %xmm0, %xmm4
	vpxor %xmm1, MI, MI
	vpxor %xmm3, LO, LO
	vpxor %xmm4, HI, HI
	vpxor %xmm2, MI, MI

With that, no instruction would depend on either of the previous two
instructions.

This might be more important in the ARM64 version than the x86_64 version, as
x86_64 CPUs are pretty aggressive about internally reordering instructions.  But
it's something to consider in both versions.

Likewise in schoolbook1_noload.

> +/*
> + * Computes the 128-bit reduction of PL, PH. Stores the result in PH.
> + *
> + * This macro computes p(x) mod g(x) where p(x) is in montgomery form and g(x) =
> + * x^128 + x^127 + x^126 + x^121 + 1.
> + *
> + * The montgomery form of a polynomial p(x) is p(x)x^{128}. Montgomery reduction
> + * works by simultaneously dividing by x^{128} and computing the modular
> + * reduction.
> + *
> + * Suppose we wish to reduce the montgomery form of p(x) = [P_3 : P_2 : P_1 :
> + * P_0] where P_i is a polynomial of degree at most 64 represented as 64-bits.
> + * Thus we would like to compute:
> + *   p(x) / x^{128} mod g(x)
> + *   = (P_3*x^{192} + P_2*x^{128} + P_1*x^{64} + P_0) / x^{128} mod g(x)

This doesn't explain why there is an additional factor of x^128 that must be
removed.  That's one of the key parts to understanding this.

> + * We now focus on dividing P_1*x^{64} + P_0 by x^{128}. We do this by making
> + * P_1*x^{64} + P_0 divisble by x^{128} then bitshifting. To add divisibility,
> + * we consider the polynomials mod x^{128}.
> + *
> + * Let c(x) = P_1*x^{64} + P_0.
> + *
> + * Now let m(x) = c(x) mod x^{128}
> + * and
> + * Let z(x) = [c(x) + m(x)g(x)] / x^{128}
> + *
> + * First notice that:
> + * c(x) + m(x)g(x) = c(x) mod g(x).
> + * Furthermore, g(x) mod x^{128} = 1, so we have
> + * c(x) + m(x)g(x) = c(x) + c(x) = 0 (mod x^{128}).

I don't understand this explanation.  m(x) = c(x), so m(x) seems to have no
purpose.  Also, g(x) mod x^{128} is not 1.

I stopped reading here due to the above issues.  I think this explanation is too
long and misses the mark somewhat.  I think that something shorter that explains
the intuition behind the algorithm used would be much more helpful.  E.g.:

    "We have a 256-bit polynomial P_3 : P_2 : P_1 : P_0 that is the product of
    two 128-bit polynomials in Montgomery form.  We need to reduce it mod g(x).
    Also, since polynomials in Montgomery form have an "extra" factor of x^128,
    this product has two extra factors of x^128.  To get it back into Montgomery
    form, we need to remove one of these factors by dividing by x^128.

    To accomplish both of these goals, we add multiples of g(x) that cancel out
    the low 128 bits P_1 : P_0, leaving just the high 128 bits, which is the
    answer.

    Since the only nonzero term in the low 64 bits of g(x) is the constant term,
    the multiple of g(x) needed to cancel out P_0 is P_0 itself.  The CPU can
    only do 64x64 bit multiplications, so split P_0 * g(x) into x^128 * P_0 +
    x^64 * g*(x) * P_0 + P_0, where g*(x) is bits 64-127 of g(x).  Adding this
    to the original polynomial gives P_3 : P_2 + P_0 + T_1 : P_1 + T_0 : 0,
    where T = T_1 : T_0 = g*(x) * P0.  Thus, bits 0-63 got "folded" into bits
    64-191.

    Repeating this same process on the next 64 bits "folds" bits 64-127 into
    bits 128-255, giving the answer in bits 128-255."

I think that covers everything except the optimization you've implemented where
you avoid a second pshufd, which makes the second "fold" step in your code
appear a bit different from the first.  But do I understand correctly that the
math is still the same in both steps in your version, and the difference between
the steps is just where in the registers each part is stored?

> +/*
> + * Compute schoolbook multiplication for 8 blocks
> + * M_0h^8 + ... + M_7h^1 (no constant term)

Some places say M while other say m.  It's probably best to use 'm', since the
key is 'h' (both lower-case).

> + *
> + * If reduce is set, computes the montgomery reduction of the
> + * previous full_stride call and XORs with the first message block.

computes => also computes

> + * (M_0 + REDUCE(PL, PH))h^8 + ... + M_7h^1 (no constant term)

"I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0."

> +/*
> + * Perform polynomial evaluation as specified by POLYVAL. If nblocks = k, this
> + * routine multiplies the value stored at accumulator by h^k and XORs the
> + * evaluated polynomial into it.
> + *
> + * Computes h^k * accumulator + h^kM_0 + ... + h^1M_{k-1} (No constant term)

The above explanation is confusing, especially the second sentence.  How about:

 * Perform polynomial evaluation as specified by POLYVAL.  This computes:
 *
 *      h^k * accumulator + h^k * M_0 + ... + h^1 * m_{k-1}
 *
 * ... where k=nblocks, h is the hash key, and m_i are the message blocks.

Also, perhaps use n instead of k, given that k could be confused with the key?

> + * rsi - pointer to precomputed key struct

pointer to the precomputed key powers h^8 ... h^1

> + * rcx - location to XOR with evaluated polynomial

pointer to the current accumulator

> + *
> + * void clmul_polyval_update(const u8 *in, const struct polyhash_ctx* ctx,

polyval_ctx, not polyhash_ctx

> +#define POLYVAL_BLOCK_SIZE	16
> +#define POLYVAL_DIGEST_SIZE	16

Why not get the above definitions by including <crypto/polyval.h>?

Or to put it another way, what is the purpose of having that header file if all
the POLYVAL implementations aren't going to include it?

> +static int polyval_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	struct polyval_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *buf = dctx->buffer;
> +
> +	if (dctx->bytes) {
> +		kernel_fpu_begin();
> +		clmul_polyval_mul((u8 *)buf,
> +			(u8 *)&ctx->key_powers[NUM_PRECOMPUTE_POWERS-1]);

The cast of buf to 'u8 *' is unnecessary.

> +		.cra_driver_name	= "__polyval-pclmulqdqni",

__polyval-clmulni

> +static int __init polyval_pclmulqdqni_mod_init(void)

polyval_clmulni_mod_init

> +{
> +	int err;
> +
> +	if (!x86_match_cpu(pcmul_cpu_id))
> +		return -ENODEV;
> +
> +	err = crypto_register_shash(&polyval_alg);
> +	if (err)
> +		goto err_out;
> +	err = crypto_register_ahash(&polyval_async_alg);
> +	if (err)
> +		goto err_shash;
> +
> +	return 0;
> +
> +err_shash:
> +	crypto_unregister_shash(&polyval_alg);
> +err_out:
> +	return err;
> +}
> +
> +static void __exit polyval_pclmulqdqni_mod_exit(void)

polyval_clmulni_mod_exit

> +MODULE_ALIAS_CRYPTO("polyval");

Add:

MODULE_ALIAS_CRYPTO("polyval-clmulni");

Otherwise this module won't be loaded if someone requests this by implementation
name.

>  config CRYPTO_POLYVAL
>  	tristate
> +	select CRYPTO_CRYPTD
>  	select CRYPTO_GF128MUL
>  	select CRYPTO_HASH
>  	help
>  	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
>  	  cryptographic hash function.
>  
> +config CRYPTO_POLYVAL_CLMUL_NI
> +	tristate "POLYVAL hash function (CLMUL-NI accelerated)"
> +	depends on X86 && 64BIT
> +	select CRYPTO_POLYVAL
> +	help
> +	  This is the x86_64 CLMUL-NI accelerated implementation of POLYVAL. It is
> +	  used to efficiently implement HCTR2 on x86-64 processors that support
> +	  carry-less multiplication instructions.

Shouldn't the 'select CRYPTO_CRYPTD' be under CRYPTO_POLYVAL_CLMUL_NI, not
CRYPTO_POLYVAL?

- Eric
