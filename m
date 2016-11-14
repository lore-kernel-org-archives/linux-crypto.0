From: Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH 7/16] crypto: simd - Add simd skcipher helper
Date: Sun, 13 Nov 2016 18:27:40 -0800
Message-ID: <20161114022740.GD4778@google.com>
References: <20161113114354.GA8169@gondor.apana.org.au>
 <E1c5tEA-0002AE-UP@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36019 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933489AbcKNC1p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 21:27:45 -0500
Received: by mail-pg0-f50.google.com with SMTP id f188so47792620pgc.3
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2016 18:27:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <E1c5tEA-0002AE-UP@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 13, 2016 at 07:45:38PM +0800, Herbert Xu wrote:
> This patch adds the simd skcipher helper which is meant to be
> a replacement for ablk helper.  It replaces the underlying blkcipher
> interface with skcipher, and also presents the top-level algorithm
> as an skcipher.

I assume this means it's planned for all users of ablk_helper to be migrated to
crypto_simd, and ablk_helper will be removed?

> +	salg = kzalloc(sizeof(*alg), GFP_KERNEL);
> +	if (!salg) {
> +		salg = ERR_PTR(-ENOMEM);
> +		goto out_put_tfm;
> +	}

Shouldn't this be 'sizeof(*salg)'?

> +	tfm = crypto_alloc_skcipher(basename, CRYPTO_ALG_INTERNAL,
> +				    CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(tfm))
> +		return ERR_CAST(tfm);
> +
> +	ialg = crypto_skcipher_alg(tfm);

It seems this really just needs an algorithm and not a transform.  Perhaps it
should be calling crypto_find_alg() directly?

> +	err = -ENAMETOOLONG;
> +	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", algname) >=
> +	    CRYPTO_MAX_ALG_NAME)
> +		goto out_free_salg;
> +
> +	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
> +		     drvname) >= CRYPTO_MAX_ALG_NAME)
> +		goto out_free_salg;

Could use strscpy() or strlcpy() here.

> +static int simd_skcipher_encrypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_request *subreq;
> +	struct crypto_skcipher *child;
> +
> +	subreq = skcipher_request_ctx(req);
> +	*subreq = *req;
> +
> +	if (!may_use_simd() ||
> +	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
> +		child = &ctx->cryptd_tfm->base;
> +	else
> +		child = cryptd_skcipher_child(ctx->cryptd_tfm);
> +
> +	skcipher_request_set_tfm(subreq, child);
> +
> +	return crypto_skcipher_encrypt(subreq);
> +}
> +
> +static int simd_skcipher_decrypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct simd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_request *subreq;
> +	struct crypto_skcipher *child;
> +
> +	subreq = skcipher_request_ctx(req);
> +	*subreq = *req;
> +
> +	if (!may_use_simd() ||
> +	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
> +		child = &ctx->cryptd_tfm->base;
> +	else
> +		child = cryptd_skcipher_child(ctx->cryptd_tfm);
> +
> +	skcipher_request_set_tfm(subreq, child);
> +
> +	return crypto_skcipher_decrypt(subreq);
> +}

These are the same except for the
crypto_skcipher_encrypt/crypto_skcipher_decrypt at the end, so they could be
mostly shared.
