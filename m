From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 4/6] crypto: ecdsa: add ECDSA SW implementation
Date: Sun, 05 Feb 2017 10:51:55 +0100
Message-ID: <23226140.jIxROAf0uE@tauon.atsec.com>
References: <1486120375-13070-1-git-send-email-nkumbhar@nvidia.com> <1486120375-13070-5-git-send-email-nkumbhar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
To: Nitin Kumbhar <nkumbhar@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55756 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbdBEJwE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2017 04:52:04 -0500
In-Reply-To: <1486120375-13070-5-git-send-email-nkumbhar@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 3. Februar 2017, 16:42:53 CET schrieb Nitin Kumbhar:

Hi Nitin,

> +
> +int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
> +		      unsigned int keylen)
> +{
> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
> +	struct ecdsa params;
> +	unsigned int ndigits;
> +	unsigned int nbytes;
> +	u8 *params_qx, *params_qy;
> +	u64 *ctx_qx, *ctx_qy;
> +	int err = 0;
> +
> +	if (crypto_ecdsa_parse_pub_key(key, keylen, &params))
> +		return -EINVAL;
> +
> +	ndigits = ecdsa_supported_curve(params.curve_id);
> +	if (!ndigits)
> +		return -EINVAL;
> +
> +	err = ecc_is_pub_key_valid(params.curve_id, ndigits,
> +				   params.key, params.key_size);
> +	if (err)
> +		return err;
> +
> +	ctx->curve_id = params.curve_id;
> +	ctx->ndigits = ndigits;
> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
> +
> +	params_qx = params.key;
> +	params_qy = params_qx + ECC_MAX_DIGIT_BYTES;
> +
> +	ctx_qx = ctx->public_key;
> +	ctx_qy = ctx_qx + ECC_MAX_DIGITS;
> +
> +	vli_copy_from_buf(ctx_qx, ndigits, params_qx, nbytes);
> +	vli_copy_from_buf(ctx_qy, ndigits, params_qy, nbytes);
> +
> +	memset(&params, 0, sizeof(params));
> +	return 0;
> +}
> +
> +int ecdsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
> +		       unsigned int keylen)
> +{
> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
> +	struct ecdsa params;
> +	unsigned int ndigits;
> +	unsigned int nbytes;
> +
> +	if (crypto_ecdsa_parse_priv_key(key, keylen, &params))
> +		return -EINVAL;
> +
> +	ndigits = ecdsa_supported_curve(params.curve_id);
> +	if (!ndigits)
> +		return -EINVAL;
> +
> +	ctx->curve_id = params.curve_id;
> +	ctx->ndigits = ndigits;
> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
> +
> +	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> +			     (const u8 *)params.key, params.key_size) < 0)
> +		return -EINVAL;
> +
> +	vli_copy_from_buf(ctx->private_key, ndigits, params.key, nbytes);
> +
> +	memset(&params, 0, sizeof(params));

Please use memzero_explicit as otherwise this memset will be optimized away. I 
think it could be used for the set_pub_key too, but there we do not have 
sensitive data and thus it would not be strictly needed.

> +	return 0;
> +}


Ciao
Stephan
