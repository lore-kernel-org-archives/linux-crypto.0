Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3C6C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Feb 2022 23:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiBPXQ1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Feb 2022 18:16:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiBPXQ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Feb 2022 18:16:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0872AAB01
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 15:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEDB861BA9
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 23:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA33EC004E1;
        Wed, 16 Feb 2022 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645053372;
        bh=aXuxrBm/LtfHFLRXKof35rtSKzLSnLYy94QzKTOQMGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HLJTVhbXW2PGub1rks7Gy+ddyPGjF2tVwT0900QQ1y2spLoulfHw0uMmXAIddlkRI
         P+1m9sAoIrzIyNEk9cOyCWHb1xKNcX3A4m9AY9ifEbnK1iZhP0bEjioUfzhH2sawwB
         PXG5BWLJWViIFygpn+HxuwlNGqOa3Qg07A5e1WRbHbc04GC9Nb2pgiLotK7VMrsQlQ
         NTr4Sk4OATjdGHTQh5HnTkSyo3y1sloqemsE2q52T2Q48BLnPp2kC38ZgeoffqXOBx
         AmnuST//hRdg+FjtEebYxIjnNjx8cimDGpx3LGB3VQXI5HOpJWMFQAJknJn51qxd5l
         2gGD1h/gjmMNA==
Date:   Wed, 16 Feb 2022 15:16:10 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 2/7] crypto: polyval - Add POLYVAL support
Message-ID: <Yg2FuiT15YwvgRpP@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210232812.798387-3-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 11:28:07PM +0000, Nathan Huckleberry wrote:
> +config CRYPTO_POLYVAL
> +	tristate
> +	select CRYPTO_GF128MUL
> +	select CRYPTO_HASH
> +	help
> +	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpose
> +	  cryptographic hash function.

As with XCTR: as this option is no longer user-selectable, no one will see this
help text.  I think it should just be removed.

> +static int polyval_update(struct shash_desc *desc,
> +			 const u8 *src, unsigned int srclen)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *dst = dctx->buffer;

The dst variable doesn't seem to serve a purpose.  It would be clearer to just
write dctx->buffer directly (or &dctx->buffer[...], etc).

> +	u8 *pos;
> +	u8 tmp[POLYVAL_BLOCK_SIZE];
> +	int n;
> +
> +	if (dctx->bytes) {
> +		n = min(srclen, dctx->bytes);
> +		pos = dst + dctx->bytes - 1;
> +
> +		dctx->bytes -= n;
> +		srclen -= n;
> +
> +		while (n--)
> +			*pos-- ^= *src++;
> +
> +		if (!dctx->bytes)
> +			gf128mul_4k_lle((be128 *)dst, ctx->gf128);

I thought I mentioned this on v1, but the cast to be128 is violating alignment
rules.  If the alignment to be128 is needed then a union should be used, e.g.:

struct polyval_desc_ctx {
        union {
                u8 buffer[POLYVAL_BLOCK_SIZE];
                be128 buffer128;
        };
        u32 bytes;
};

> +static int polyval_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
> +	const struct polyval_tfm_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	u8 *buf = dctx->buffer;
> +
> +	if (dctx->bytes)
> +		gf128mul_4k_lle((be128 *)buf, ctx->gf128);
> +	dctx->bytes = 0;
> +
> +	reverse_block(buf);
> +	memcpy(dst, buf, POLYVAL_BLOCK_SIZE);
> +
> +	return 0;
> +}

Same issues as polyval_update().

> +
> diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
> new file mode 100644
> index 000000000000..fd0c6e124b65
> --- /dev/null
> +++ b/include/crypto/polyval.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Common values for the Polyval hash algorithm
> + *
> + * Copyright 2021 Google LLC
> + */
> +
> +#ifndef _CRYPTO_POLYVAL_H
> +#define _CRYPTO_POLYVAL_H
> +
> +#include <linux/types.h>
> +#include <linux/crypto.h>
> +
> +#define POLYVAL_BLOCK_SIZE	16
> +#define POLYVAL_DIGEST_SIZE	16
> +
> +struct polyval_desc_ctx {
> +	u8 buffer[POLYVAL_BLOCK_SIZE];
> +	u32 bytes;
> +};
> +
> +#endif

As-is, polyval_desc_ctx is only used by crypto/polyval-generic.c, so it
shouldn't be in this header.  Either it should be moved to polyval-generic.c, or
all implementations should be made to use the same struct.

- Eric
