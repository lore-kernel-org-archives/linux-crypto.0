From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 26 Jan 2016 18:28:14 +0800
Message-ID: <20160126102814.GA19419@gondor.apana.org.au>
References: <4445045.XP4c23S4mB@positron.chronox.de>
 <6838062.nWpazeNV2T@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57024 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933887AbcAZK2X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 05:28:23 -0500
Content-Disposition: inline
In-Reply-To: <6838062.nWpazeNV2T@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 07:20:59AM +0100, Stephan Mueller wrote:
>
> +/*
> + * Implementation of the KDF in counter mode according to SP800-108 section 5.1.
> + *
> + * The caller must provide Label || 0x00 || Context in src. This src pointer
> + * may also be NULL if the caller wishes not to provide anything.
> + */
> +static int crypto_kdf_ctr_random(struct crypto_rng *rng,
> +				 const u8 *src, unsigned int slen,
> +				 u8 *dst, unsigned int dlen)
> +{
> +	struct crypto_kdf_ctx *ctx = crypto_tfm_ctx(crypto_rng_tfm(rng));
> +	struct shash_desc *desc = &ctx->shash;
> +	unsigned int h = crypto_shash_digestsize(desc->tfm);
> +	int err = 0;
> +	u8 *dst_orig = dst;
> +	u32 i = 1;
> +	u8 iteration[sizeof(u32)];
> +
> +	/* enforce the note from above */
> +	if (dlen != h && src == dst)
> +		return -EINVAL;

Why is this an RNG? It always produces exactly h bytes so it looks
like a hash function to me, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
