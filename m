Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3D2C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 05:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiDMFz6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 01:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbiDMFz6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 01:55:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E13E38DB5
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 22:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C08F61B84
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 05:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEA2C385AA;
        Wed, 13 Apr 2022 05:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649829216;
        bh=ffA8Ck5Ner0hO8yk+sLPWxYviMDUp/PT2I0A/QmHAVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gVcDI4lVanRBTYjPlmSJnfXrRpX64ir5Iz+/pHBAAwyD98HtFTRvLafF458Ek3hLl
         A+mnzhDbbN6/l4UKCaBStMu7IfHIFxNq/+eOT9CSE1uS6pEm2C7MaBgrKcFm7lEM19
         RbAOElJaiuC1VCll7jfU78HBo02094yBOd9/1+wdoM7qe2m/Oet0kbv3TV9a9sQrQo
         fabXGJDmeN9bwd6eqmqcJCiU0lXkhkDhreH7TaqqHztqrbYl8tZLlfmhe220ycl83E
         A+eWrZ0Q71y92uE0hm9JnKGbGptUVGSlQi4DwUbUmHiyBOzyD2MvqrffDmvypmT4tl
         aCQJn1z4cUKgQ==
Date:   Tue, 12 Apr 2022 22:53:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 7/8] crypto: arm64/polyval: Add PMULL accelerated
 implementation of POLYVAL
Message-ID: <YlZlXq96e96Bg6tL@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-8-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-8-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Many of the comments I made on the x86 version apply to this too, but a few
unique comments below:

On Tue, Apr 12, 2022 at 05:28:15PM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated version of POLYVAL for ARM64 CPUs with
> Crypto Extension support.

As I've mentioned, it seems to be "Crypto Extensions", not "Crypto Extension".
That's what everything else in the kernel says, at least.  It's just a nit, but
it's unclear whether you intentionally decided to not change this, or missed it.

> diff --git a/arch/arm64/crypto/polyval-ce-core.S b/arch/arm64/crypto/polyval-ce-core.S
[..]
> +	.text
> +	.align	4
> +
> +	.arch	armv8-a+crypto
> +	.align	4

Having '.align' twice is redundant, right?

> +
> +.Lgstar:
> +	.quad	0xc200000000000000, 0xc200000000000000
> +
> +/*
> + * Computes the product of two 128-bit polynomials in X and Y and XORs the
> + * components of the 256-bit product into LO, MI, HI.
> + *
> + * X = [X_1 : X_0]
> + * Y = [Y_1 : Y_0]
> + *
> + * The multiplication produces four parts:
> + *   LOW: The polynomial given by performing carryless multiplication of X_0 and
> + *   Y_0
> + *   MID: The polynomial given by performing carryless multiplication of (X_0 +
> + *   X_1) and (Y_0 + Y_1)
> + *   HIGH: The polynomial given by performing carryless multiplication of X_1
> + *   and Y_1
> + *
> + * We compute:
> + *  LO += LOW
> + *  MI += MID
> + *  HI += HIGH
> + *
> + * Later, the 256-bit result can be extracted as:
> + *   [HI_1 : HI_0 + HI_1 + MI_1 + LO_1 :: LO_1 + HI_0 + MI_0 + LO_0 : LO_0]

What does the double colon mean?

> + * This step is done when computing the polynomial reduction for efficiency
> + * reasons.
> + */
> +.macro karatsuba1 X Y

A super brief explanation of why Karatsuba multiplication is used instead of
schoolbook multiplication would be helpful.

> +	X .req \X
> +	Y .req \Y
> +	ext	v25.16b, X.16b, X.16b, #8
> +	ext	v26.16b, Y.16b, Y.16b, #8
> +	eor	v25.16b, v25.16b, X.16b
> +	eor	v26.16b, v26.16b, Y.16b
> +	pmull	v27.1q, v25.1d, v26.1d
> +	pmull2	v28.1q, X.2d, Y.2d
> +	pmull	v29.1q, X.1d, Y.1d
> +	eor	MI.16b, MI.16b, v27.16b
> +	eor	HI.16b, HI.16b, v28.16b
> +	eor	LO.16b, LO.16b, v29.16b
> +	.unreq X
> +	.unreq Y
> +.endm

Maybe move the pmull into v27 and the eor into MI down a bit, since they have
more dependencies?  I.e.

	ext	v25.16b, X.16b, X.16b, #8
	ext	v26.16b, Y.16b, Y.16b, #8
	eor	v25.16b, v25.16b, X.16b
	eor	v26.16b, v26.16b, Y.16b
	pmull2	v28.1q, X.2d, Y.2d
	pmull	v29.1q, X.1d, Y.1d
	pmull	v27.1q, v25.1d, v26.1d
	eor	HI.16b, HI.16b, v28.16b
	eor	LO.16b, LO.16b, v29.16b
	eor	MI.16b, MI.16b, v27.16b

I don't know whether it will actually matter on arm64, but on lower-powered
arm32 CPUs this sort of thing definitely can matter.

> +.macro karatsuba1_store X Y
> +	X .req \X
> +	Y .req \Y
> +	ext	v25.16b, X.16b, X.16b, #8
> +	ext	v26.16b, Y.16b, Y.16b, #8
> +	eor	v25.16b, v25.16b, X.16b
> +	eor	v26.16b, v26.16b, Y.16b
> +	pmull	MI.1q, v25.1d, v26.1d
> +	pmull2	HI.1q, X.2d, Y.2d
> +	pmull	LO.1q, X.1d, Y.1d
> +	.unreq X
> +	.unreq Y
> +.endm

Likewise above.

> diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
[...]
> +struct polyval_async_ctx {
> +	struct cryptd_ahash *cryptd_tfm;
> +};

struct polyval_async_ctx is no longer used.

> +static int polyval_setkey(struct crypto_shash *tfm,
> +			const u8 *key, unsigned int keylen)
> +{
> +	struct polyval_ctx *ctx = crypto_shash_ctx(tfm);
> +	int i;
> +
> +	if (keylen != POLYVAL_BLOCK_SIZE)
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(u128) != POLYVAL_BLOCK_SIZE);

Where does 'sizeof(u128)' come from?  This file doesn't use u128 at all.

- Eric
