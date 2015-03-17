From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: prevent helper ciphers from being allocated
 by users
Date: Tue, 17 Mar 2015 22:23:50 +1100
Message-ID: <20150317112350.GA11671@gondor.apana.org.au>
References: <13986065.EbkBp8M36a@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <13986065.EbkBp8M36a@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 13, 2015 at 10:09:21PM +0100, Stephan Mueller wrote:
>  
> +struct crypto_tfm *__crypto_alloc_tfm_safe(struct crypto_alg *alg, u32 type,
> +					   u32 mask)
> +{
> +	/*
> +	 * Prevent all ciphers from being loaded which have a cra_priority
> +	 * of 0. Those cipher implementations are helper ciphers and
> +	 * are not intended for general consumption.
> +	 *
> +	 * The only exceptions are the compression algorithms which
> +	 * have no priority.
> +	 */
> +	if (!alg->cra_priority &&
> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=
> +	      CRYPTO_ALG_TYPE_PCOMPRESS) &&
> +	    ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) !=
> +	      CRYPTO_ALG_TYPE_COMPRESS))
> +		return ERR_PTR(-ENOENT);

How about adding a flag to all these internal algorithms and then
change crypto_alg_mod_lookup to disable that flag by default?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
