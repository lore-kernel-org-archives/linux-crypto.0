From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: authenc - move saved IV in front of the
	ablkcipher request
Date: Tue, 2 Mar 2010 22:10:49 +0800
Message-ID: <20100302141049.GB3808@gondor.apana.org.au>
References: <20100223062109.GD29013@secunet.com> <20100223062237.GE29013@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42868 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352Ab0CBOKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Mar 2010 09:10:51 -0500
Content-Disposition: inline
In-Reply-To: <20100223062237.GE29013@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 23, 2010 at 07:22:37AM +0100, Steffen Klassert wrote:
>
> @@ -558,13 +556,18 @@ static int crypto_authenc_init_tfm(struct crypto_tfm *tfm)
>  	ctx->auth = auth;
>  	ctx->enc = enc;
>  
> -	tfm->crt_aead.reqsize = max_t(unsigned int,
> -				crypto_ahash_reqsize(auth) + ctx->reqoff +
> -				sizeof(struct authenc_request_ctx) +
> +	ctx->reqoff = ALIGN(2 * crypto_ahash_digestsize(auth) +
> +			    crypto_ahash_alignmask(auth),
> +			    crypto_ahash_alignmask(auth) + 1) +
> +		      crypto_ablkcipher_ivsize(enc);
> +
> +	tfm->crt_aead.reqsize = sizeof(struct authenc_request_ctx) +
> +				ctx->reqoff +
> +				max_t(unsigned int,
> +				crypto_ahash_reqsize(auth) +
>  				sizeof(struct ahash_request),
>  				sizeof(struct skcipher_givcrypt_request) +
> -				crypto_ablkcipher_reqsize(enc) +
> -				crypto_ablkcipher_ivsize(enc));
> +				crypto_ablkcipher_reqsize(enc));

Hmm, I just noticed that both before and after the patch we're
only including the hash request size for the encrypt case, and
not the givencrypt case.  Is there a reason for this?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
