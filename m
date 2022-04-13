Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4890AC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 05:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiDMFVC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 01:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiDMFU7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 01:20:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726DB4F45E
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 22:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160D361BD6
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 05:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E9DC385A4;
        Wed, 13 Apr 2022 05:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649827117;
        bh=YF7s/uh4r2IfvRPpRiLQpidvPG4vDPRr2Md+fbiMFIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NyhlYkW55CvPKOVhahJkdJlUkScvBgmfBXJGH8nWB6lCnOVSt0E696tu1iKdx+GxO
         krHfMqRmJ7ATyuCE/BNioPT7SkboMtYuuDM0PRjtSYUphe2fQDXCVbqv+lFEmCh1n7
         yFTpiQ5kjEatUPwH+Vu8Yp2u2if/7oz0LhTdVteD7rXmNY78MiRLsmTO4c/mzlC7YY
         NILCNAcFZUMm7oArgG0JtzuJVjPUAsLXtoR+0AvMIwvT+qS8Ij0t24k5eWmd4lK81X
         8R8d3PwqkjrqNs4GZ8aFuIz0mcZ4armz401TT2o/LnvlSszmoMjBQAjqE7AZ75fHK1
         PBix6bHrWsZYw==
Date:   Tue, 12 Apr 2022 22:18:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YlZdK8u0hL8hxzxh@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:14PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
[...]
> +/*
> + * Computes the product of two 128-bit polynomials at the memory locations
> + * specified by (MSG + 16*i) and (KEY_POWERS + 16*i) and XORs the components of the
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
> + *  LO += LOW
> + *  MI += MID1 + MID2
> + *  HI += HIGH
> + *
> + * LO = [L0_1 : LO_0]
> + * MI = [MI_1 : MI_0]
> + * HI = [HI_1 : HI_0]

One of the "LO" has a 0 instead of an O.

> +.macro schoolbook1_iteration i xor_sum
> +	movups (16*\i)(MSG), %xmm0
> +	.if (\i == 0 && \xor_sum == 1)
> +		pxor SUM, %xmm0
> +	.endif
> +	vpclmulqdq $0x00, (16*\i)(KEY_POWERS), %xmm0, %xmm2
> +	vpclmulqdq $0x01, (16*\i)(KEY_POWERS), %xmm0, %xmm1
> +	vpclmulqdq $0x11, (16*\i)(KEY_POWERS), %xmm0, %xmm3
> +	vpclmulqdq $0x10, (16*\i)(KEY_POWERS), %xmm0, %xmm4
> +	vpxor %xmm2, LO, LO
> +	vpxor %xmm1, MI, MI
> +	vpxor %xmm4, MI, MI
> +	vpxor %xmm3, HI, HI
> +.endm

Can you allocate the xmm1-xmm4 registers in a logical order?  Either in order as
they are first used, or in the same order as the vpclmulqdq constants.  It
doesn't actually matter, of course, but I don't understand the logic here.  Did
you also consider my suggestion
https://lore.kernel.org/r/YhA%2FtAaDi%2F3e35Q1@sol.localdomain which would avoid
adjacent instructions that depend on each other, like the XORs into MI that you
have?  In that version I had allocated the registers in the same order as the
vpclmulqdq constants, so there was some logic behind it; it wasn't just random.
(Whereas what you have here seems "random" to me!)

> +
> +/*
> + * Performs the same computation as schoolbook1_iteration, except we expect the
> + * arguments to already be loaded into xmm0 and xmm1.
> + */
> +.macro schoolbook1_noload
> +	vpclmulqdq $0x01, %xmm0, %xmm1, MI
> +	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm2
> +	vpclmulqdq $0x00, %xmm0, %xmm1, LO
> +	vpclmulqdq $0x11, %xmm0, %xmm1, HI
> +	vpxor %xmm2, MI, MI
> +.endm

The comment should be updated to to mention the second difference from
schoolbook1_iteration:

"... and we set the result registers LO, MI, and HI directly rather than XOR'ing
into them."

> + * So our final computation is:
> + *   T = T_1 : T_0 = g*(x) * P_0
> + *   V = V_1 : V_0 = g*(x) * (T_0 + P_1)

Above should use "P_1 + T_0" to keep using a consistent order.

> rather than directly XORing P_1 : P_0, T_0 : T1 into dest.

"rather than separately XORing P_1 : P_0 and T_0 : T_1 into dest"

> +/*
> + * Compute schoolbook multiplication for 8 blocks
> + * m_0h^8 + ... + m_7h^1
> + *
> + * If reduce is set, also computes the montgomery reduction of the
> + * previous full_stride call and XORs with the first message block.
> + * (m_0 + REDUCE(PL, PH))h^8 + ... + m_7h^1.
> + * I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0.
> + *
> + * Sets PL, PH
> + * Clobbers LO, HI, MI
> + *
> + */

The "Sets PL, PH ... Clobbers LO, HI, MI" part is incomplete.  PL and PH are
sometimes used as inputs, not just set, and other registers are clobbered too.

This part of the comment should either be complete, or it should be removed.

> +.macro full_stride reduce
> +	pxor LO, LO
> +	pxor HI, HI
> +	pxor MI, MI
> +
> +	schoolbook1_iteration 7 0
> +	.if (\reduce)

.if expressions don't need parentheses around them; this isn't C.

> diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
> new file mode 100644
> index 000000000000..4f62284f980c
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni_glue.c
[...]

> +#include <crypto/algapi.h>
> +#include <crypto/cryptd.h>
> +#include <crypto/gf128mul.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
> +#include <crypto/polyval.h>
> +#include <linux/crypto.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <asm/cpu_device_id.h>
> +#include <asm/simd.h>

Includes that are no longer required should be removed.  At least
<crypto/cryptd.h> is no longer required.

> +static void reverse_be128(be128 *x)
> +{
> +	__be64 a = x->a;
> +	__be64 b = x->b;
> +
> +	x->a = swab64(b);
> +	x->b = swab64(a);
> +}

This is generating warnings from 'sparse':

	arch/x86/crypto/polyval-clmulni_glue.c:56:16: warning: cast from restricted __be64
	arch/x86/crypto/polyval-clmulni_glue.c:56:14: warning: incorrect type in assignment (different base types)
	arch/x86/crypto/polyval-clmulni_glue.c:56:14:    expected restricted __be64 [usertype] a
	arch/x86/crypto/polyval-clmulni_glue.c:56:14:    got unsigned long long [usertype]
	arch/x86/crypto/polyval-clmulni_glue.c:57:16: warning: cast from restricted __be64
	arch/x86/crypto/polyval-clmulni_glue.c:57:14: warning: incorrect type in assignment (different base types)
	arch/x86/crypto/polyval-clmulni_glue.c:57:14:    expected restricted __be64 [usertype] b
	arch/x86/crypto/polyval-clmulni_glue.c:57:14:    got unsigned long long [usertype]

Make sure to run 'make C=2' on changed files.

> +
> +static void generic_polyval_mul(u8 *op1, const u8 *op2)
> +{
> +	be128 a, b;
> +
> +	// Assume one argument is in Montgomery form and one is not.
> +	memcpy(&a, op1, sizeof(a));
> +	memcpy(&b, op2, sizeof(b));
> +	reverse_be128(&a);
> +	reverse_be128(&b);
> +	gf128mul_x_lle(&a, &a);
> +	gf128mul_lle(&a, &b);
> +	reverse_be128(&a);
> +	memcpy(op1, &a, sizeof(a));
> +}
> +
> +static void generic_polyval_update(const u8 *in, struct polyval_ctx *keys,
> +			  size_t nblocks, u8 *accumulator)
> +{
> +	while (nblocks--) {
> +		crypto_xor(accumulator, in, POLYVAL_BLOCK_SIZE);
> +		generic_polyval_mul(accumulator, keys->key_powers[7]);
> +		in += POLYVAL_BLOCK_SIZE;
> +	}
> +}

The above is hardcoding 7, whereas other places are using
NUM_PRECOMPUTE_POWERS-1 for the same thing.

The naming of NUM_PRECOMPUTE_POWERS is also not great.  It's missing a "D" at
the end of "PRECOMPUTE", right?  I think NUM_KEY_POWERS would make more sense.

generic_polyval_update() is also duplicated in both
arch/x86/crypto/polyval-clmulni_glue.c and arch/arm64/crypto/polyval-ce-glue.c.
How about putting it in crypto/polyval.c to share the code?  It would need to be
passed the key directly, rather than the implementation-specific polyval_ctx,
but otherwise it would work, right?

> +
> +static void internal_polyval_update(const u8 *in, struct polyval_ctx *keys,
> +			  size_t nblocks, u8 *accumulator)

struct polyval_ctx should be 'const', everywhere except in ->setkey().

> +static int polyval_init(struct shash_desc *desc)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +
> +	memset(dctx, 0, sizeof(*dctx));
> +
> +	return 0;
> +}
> +
> +static int polyval_setkey(struct crypto_shash *tfm,
> +			const u8 *key, unsigned int keylen)
> +{
> +	struct polyval_ctx *ctx = crypto_shash_ctx(tfm);
> +	int i;
> +
> +	if (keylen != POLYVAL_BLOCK_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(ctx->key_powers[NUM_PRECOMPUTE_POWERS-1], key,
> +	       POLYVAL_BLOCK_SIZE);
> +
> +	for (i = NUM_PRECOMPUTE_POWERS-2; i >= 0; i--) {
> +		memcpy(ctx->key_powers[i], key, POLYVAL_BLOCK_SIZE);
> +		internal_polyval_mul(ctx->key_powers[i], ctx->key_powers[i+1]);
> +	}
> +
> +	return 0;
> +}

polyval_setkey() is the first step, so it would make sense to put its definition
before polyval_init() so that everything more or less goes in order.

Also: the names of these functions, and polyval_update and polyval_final below,
collide with the same-named functions in crypto/polyval-generic.c.  This is sort
of okay since these are all static, but it is bad practice as it can create
confusing stack traces and require that the functions be renamed if/when things
get refactored in the future.  How about calling these
polyval_x86_{setkey,init,update,final}()?

Similarly, polyval_arm64_{setkey,init,update,final} in the arm64 version.

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index aa06af0e0ebe..c6aec88213b1 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -787,6 +787,16 @@ config CRYPTO_POLYVAL
>  	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
>  	  cryptographic hash function.
>  
> +config CRYPTO_POLYVAL_CLMUL_NI
> +	tristate "POLYVAL hash function (CLMUL-NI accelerated)"
> +	depends on X86 && 64BIT
> +	select CRYPTO_CRYPTD
> +	select CRYPTO_POLYVAL
> +	help
> +	  This is the x86_64 CLMUL-NI accelerated implementation of POLYVAL. It is
> +	  used to efficiently implement HCTR2 on x86-64 processors that support
> +	  carry-less multiplication instructions.

Selecting CRYPTO_CRYPTD is no longer required.

- Eric
