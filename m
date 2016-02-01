From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/4] crypto x86/sha1_mb: Fix load failure
Date: Mon, 1 Feb 2016 16:17:51 +0800
Message-ID: <20160201081751.GC5818@gondor.apana.org.au>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
 <1453885718-24599-2-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58151 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbcBAIR5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 03:17:57 -0500
Content-Disposition: inline
In-Reply-To: <1453885718-24599-2-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 05:08:35PM +0800, Rui Wang wrote:
>
> +static int sha1_mb_async_import(struct ahash_request *req, const void *in)
> +{
> +	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
> +	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
> +	struct crypto_shash *child = mcryptd_ahash_child(mcryptd_tfm);
> +	struct mcryptd_hash_request_ctx *rctx;
> +	struct shash_desc *desc;
> +	int err;
> +
> +	memcpy(mcryptd_req, req, sizeof(*req));
> +	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
> +	rctx = ahash_request_ctx(mcryptd_req);
> +	desc = &rctx->desc;
> +	desc->tfm = child;
> +	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> +	err = crypto_shash_init(desc);
> +	if (err)
> +		return err;

What is this desc for?

> +	return crypto_ahash_import(mcryptd_req, in);
> +}

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
