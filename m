Return-Path: <SRS0=Mcmw=PN=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:31919 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAEMpw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Jan 2019 07:45:52 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 05/16] crypto: skcipher - add helper for simple block cipher modes
Date: Sat, 05 Jan 2019 13:03:40 +0100
Message-ID: <4030532.EK8pHEC8rB@tauon.chronox.de>
In-Reply-To: <20190104041625.3259-6-ebiggers@kernel.org>
References: <20190104041625.3259-1-ebiggers@kernel.org> <20190104041625.3259-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 4. Januar 2019, 05:16:14 CET schrieb Eric Biggers:

Hi Eric,

> From: Eric Biggers <ebiggers@google.com>
> 
> The majority of skcipher templates (including both the existing ones and
> the ones remaining to be converted from the "blkcipher" API) just wrap a
> single block cipher algorithm.  This includes cbc, cfb, ctr, ecb, kw,
> ofb, and pcbc.  Add a helper function skcipher_alloc_instance_simple()
> that handles allocating an skcipher instance for this common case.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Apart from the comment below:

Reviewed-by: Stephan Mueller <smueller@chronox.de>

> +struct skcipher_instance *
> +skcipher_alloc_instance_simple(struct crypto_template *tmpl, struct rtattr
> **tb, +			       struct crypto_alg **cipher_alg_ret)
> +{
> +	struct crypto_attr_type *algt;
> +	struct crypto_alg *cipher_alg;
> +	struct skcipher_instance *inst;
> +	struct crypto_spawn *spawn;
> +	u32 mask;
> +	int err;
> +
> +	algt = crypto_get_attr_type(tb);
> +	if (IS_ERR(algt))
> +		return ERR_CAST(algt);
> +
> +	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
> +		return ERR_PTR(-EINVAL);

Why not using crypto_check_attr_type? I understand that it does not return 
algt for the next check, but maybe we can consolidate the code a bit here?

> +
> +	mask = CRYPTO_ALG_TYPE_MASK |
> +		crypto_requires_off(algt->type, algt->mask,
> +				    CRYPTO_ALG_NEED_FALLBACK);


Ciao
Stephan
