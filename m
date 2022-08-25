Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB536C3F6B0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 09:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240296AbiHYJaj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 05:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240130AbiHYJaV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 05:30:21 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B845EDF3;
        Thu, 25 Aug 2022 02:30:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oR9Bh-00Eyep-6u; Thu, 25 Aug 2022 19:30:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 25 Aug 2022 17:30:09 +0800
Date:   Thu, 25 Aug 2022 17:30:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>
Subject: Re: [PATCH v3 10/16] crypto: ux500/hash: Implement .export and
 .import
Message-ID: <YwdBIfASgGMDONx4@gondor.apana.org.au>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
 <20220816140049.102306-11-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816140049.102306-11-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 16, 2022 at 04:00:43PM +0200, Linus Walleij wrote:
>
> -static int ahash_noimport(struct ahash_request *req, const void *in)
> +static int ahash_import(struct ahash_request *req, const void *in)
>  {
> -	return -ENOSYS;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
> +	struct hash_device_data *device_data = ctx->device;
> +	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
> +	const struct hash_state *hstate = in;
> +	int hash_mode = HASH_OPER_MODE_HASH;
> +	u32 cr;
> +	s32 count;
> +
> +	/* Restore software state */
> +	req_ctx->length = hstate->length;
> +	req_ctx->index = hstate->index;
> +	req_ctx->dma_mode = hstate->dma_mode;
> +	req_ctx->hw_initialized = hstate->hw_initialized;
> +	memcpy(req_ctx->buffer, hstate->buffer, HASH_BLOCK_SIZE);
> +
> +	/*
> +	 * Restore hardware state
> +	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
> +	 * prepare the initialize the HASH accelerator to compute the message
> +	 * digest of a new message.
> +	 */
> +	HASH_INITIALIZE;
> +
> +	cr = hstate->temp_cr;
> +	writel_relaxed(cr & HASH_CR_RESUME_MASK, &device_data->base->cr);
> +
> +	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
> +		hash_mode = HASH_OPER_MODE_HMAC;
> +	else
> +		hash_mode = HASH_OPER_MODE_HASH;
> +
> +	for (count = 0; count < HASH_CSR_COUNT; count++) {
> +		if ((count >= 36) && (hash_mode == HASH_OPER_MODE_HASH))
> +			break;
> +		writel_relaxed(hstate->csr[count],
> +			       &device_data->base->csrx[count]);
> +	}
> +
> +	writel_relaxed(hstate->csfull, &device_data->base->csfull);
> +	writel_relaxed(hstate->csdatain, &device_data->base->csdatain);
> +	writel_relaxed(hstate->str_reg, &device_data->base->str);
> +	writel_relaxed(cr, &device_data->base->cr);
> +
> +	return 0;
>  }

At any time we may have multiple requests outstanding for a given
tfm/device, so I'm a bit worried with the direct writes to hardware
in the import function.

Normally import just transfers data from the caller into the
request object as a "soft" state, while the actual update/final
functions will then move them into the hardware state as needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
