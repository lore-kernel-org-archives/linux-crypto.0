Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F716C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 19:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2112F21556
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 19:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576091180;
	bh=LkOzKJFV2DBa/4avtVwHZDrQXWd514uVebIpA+Rk054=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fFYKxkNNTKtXoe8+YInjbqx8A+ZC3GTyptQKbk+k3aeZv6KoKp8iHQEHsE4bWVtg2
	 M/Z841Unl5dRhoh6H54aLunbaWaWaJtKDxDa4tlm8ZvmcdWPbbOnRyN7gs3uI0QxEG
	 6t/4YvoM9NzVvI0w2vxrR0DDV/1vgWtWe/BKntvo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLKTGT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 14:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbfLKTGT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 14:06:19 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 664C320836;
        Wed, 11 Dec 2019 19:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576091178;
        bh=LkOzKJFV2DBa/4avtVwHZDrQXWd514uVebIpA+Rk054=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zv2l5KgAlmc6pV5Q/dkBdhby8aA/OrSI7doA5ZH4w+3TTSajouYU4JSeFoDB0Gzqr
         MZc1H0kVwY8Yhsbpe+yKfiDlHelWnYbm9ll7n8kP6pJvfNRsQJNnfBzgt8Sg1s7+du
         1LPH2Xz3kc95nNCi00RSQTawNlfDyLKqQzq5Tpao=
Date:   Wed, 11 Dec 2019 11:06:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-next v1] crypto: poly1305 - add new 32 and 64-bit
 generic versions
Message-ID: <20191211190615.GC82952@gmail.com>
References: <20191211170936.385572-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191211170936.385572-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 11, 2019 at 06:09:36PM +0100, Jason A. Donenfeld wrote:
> These two C implementations from Zinc -- a 32x32 one and a 64x64 one,
> depending on the platform -- come from Andrew Moon's public domain
> poly1305-donna portable code, modified for usage in the kernel. The
> precomputation in the 32-bit version and the use of 64x64 multiplies in
> the 64-bit version make these perform better than the code it replaces.
> Moon's code is also very widespread and has received many eyeballs of
> scrutiny.

Isn't the existing implementation in the kernel already based on the 32x32 code
from Andrew Moon?  Can you elaborate on how the new code is different?

> 
> There's a bit of interference between the x86 implementation, which
> relies on internal details of the old scalar implementation. Soon the
> x86 implementation will be replaced with a faster one that doesn't rely
> on this, but for now, we inline the bits of the old implementation that
> the x86 implementation relied on. Also, since we now support a slightly
> larger key space, via the union, some offsets had to be fixed up.
> 
> Nonce calculation was folded in with the emit function, to take
> advantage of 64x64 arithmetic. However, Adiantum appeared to rely on no
> nonce handling in emit, so this path was conditionalized. I don't have
> an Adiantum rig handy, so I'd appreciate a review from somebody who does
> and can make sure this doesn't break it.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Eric Biggers <ebiggers@kernel.org>

You can run the self-tests.  But I tried and it doesn't get past nhpoly1305:

[    0.856458] alg: shash: nhpoly1305-generic test failed (wrong result) on test vector 1, cfg="init+update+final aligned buffer"

> diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
> index 479b0cab2a1a..6e275d3e5969 100644
> --- a/include/crypto/internal/poly1305.h
> +++ b/include/crypto/internal/poly1305.h
> @@ -24,35 +24,7 @@ static inline void poly1305_core_init(struct poly1305_state *state)
>  void poly1305_core_blocks(struct poly1305_state *state,
>  			  const struct poly1305_key *key, const void *src,
>  			  unsigned int nblocks, u32 hibit);
> -void poly1305_core_emit(const struct poly1305_state *state, void *dst);
> -
> -/*
> - * Poly1305 requires a unique key for each tag, which implies that we can't set
> - * it on the tfm that gets accessed by multiple users simultaneously. Instead we
> - * expect the key as the first 32 bytes in the update() call.
> - */
> -static inline
> -unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
> -					const u8 *src, unsigned int srclen)
> -{
> -	if (!dctx->sset) {
> -		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
> -			poly1305_core_setkey(dctx->r, src);
> -			src += POLY1305_BLOCK_SIZE;
> -			srclen -= POLY1305_BLOCK_SIZE;
> -			dctx->rset = 1;
> -		}
> -		if (srclen >= POLY1305_BLOCK_SIZE) {
> -			dctx->s[0] = get_unaligned_le32(src +  0);
> -			dctx->s[1] = get_unaligned_le32(src +  4);
> -			dctx->s[2] = get_unaligned_le32(src +  8);
> -			dctx->s[3] = get_unaligned_le32(src + 12);
> -			src += POLY1305_BLOCK_SIZE;
> -			srclen -= POLY1305_BLOCK_SIZE;
> -			dctx->sset = true;
> -		}
> -	}
> -	return srclen;
> -}
> +void poly1305_core_emit(const struct poly1305_state *state, const u32 nonce[4],
> +			void *dst);

Adding nonce support here makes the comment above this code outdated.

	/*
	 * Poly1305 core functions.  These implement the ε-almost-∆-universal hash
	 * function underlying the Poly1305 MAC, i.e. they don't add an encrypted nonce
	 * ("s key") at the end.  They also only support block-aligned inputs.
	 */

> diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
> index 74c6e1cd73ee..dec2bd6b5aee 100644
> --- a/include/crypto/poly1305.h
> +++ b/include/crypto/poly1305.h
> @@ -14,11 +14,17 @@
>  #define POLY1305_DIGEST_SIZE	16
>  
>  struct poly1305_key {
> -	u32 r[5];	/* key, base 2^26 */
> +	union {
> +		u32 r[5];	/* key, base 2^26 */
> +		u64 r64[3];
> +	};
>  };
>  
>  struct poly1305_state {
> -	u32 h[5];	/* accumulator, base 2^26 */
> +	union {
> +		u32 h[5];	/* accumulator, base 2^26 */
> +		u64 h64[3];
> +	};
>  };

It would be helpful to include comments for the r64 and h64 fields, like there
are for the r and h fields.  What base is being used?

> diff --git a/lib/crypto/poly1305-donna32.c b/lib/crypto/poly1305-donna32.c
> new file mode 100644
> index 000000000000..39b3fde68dcf
> --- /dev/null
> +++ b/lib/crypto/poly1305-donna32.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0 OR MIT
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + *
> + * This is based in part on Andrew Moon's poly1305-donna, which is in the
> + * public domain.
> + */
> +
> +#include <linux/kernel.h>
> +#include <asm/unaligned.h>
> +#include <crypto/internal/poly1305.h>
> +
> +void poly1305_core_setkey(struct poly1305_key *key, const u8 raw_key[16])
> +{
> +	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
> +	key[0].r[0] = (get_unaligned_le32(&raw_key[0])) & 0x3ffffff;
> +	key[0].r[1] = (get_unaligned_le32(&raw_key[3]) >> 2) & 0x3ffff03;
> +	key[0].r[2] = (get_unaligned_le32(&raw_key[6]) >> 4) & 0x3ffc0ff;
> +	key[0].r[3] = (get_unaligned_le32(&raw_key[9]) >> 6) & 0x3f03fff;
> +	key[0].r[4] = (get_unaligned_le32(&raw_key[12]) >> 8) & 0x00fffff;
> +
> +	/* s = 5*r */
> +	key[1].r[0] = key[0].r[1] * 5;
> +	key[1].r[1] = key[0].r[2] * 5;
> +	key[1].r[2] = key[0].r[3] * 5;
> +	key[1].r[3] = key[0].r[4] * 5;
> +}
> +EXPORT_SYMBOL(poly1305_core_setkey);

This assumes the struct poly1305_key is actually part of an array.  This is
probably what's causing the self-tests to fail, since some callers provide only
a single struct poly1305_key.

Shouldn't this detail be hidden in struct poly1305_key?  Or at least the
functions should take 'struct poly1305_key key[2]' to make this assumption
explicit.

- Eric
