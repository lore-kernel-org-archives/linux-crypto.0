From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/16] crypto: prevent helper ciphers from being used
Date: Thu, 19 Mar 2015 18:16:30 +1100
Message-ID: <20150319071630.GA2902@gondor.apana.org.au>
References: <21952258.n2qYaab1Is@tachyon.chronox.de>
 <109752153.14abfcUJ8X@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53981 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbCSHQe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 03:16:34 -0400
Content-Disposition: inline
In-Reply-To: <109752153.14abfcUJ8X@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 19, 2015 at 07:57:36AM +0100, Stephan Mueller wrote:
>
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index db201bca..2cd83ad 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -688,7 +688,7 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
>  			goto err;
>  		}
>  
> -		tfm = __crypto_alloc_tfm(alg, type, mask);
> +		tfm = __crypto_alloc_tfm_safe(alg, type, mask);

Rather than changing every algorithm type, I'd rather suggest
that you modify crypto_alg_mod_lookup so that it's kept in one
spot.  Just copy what we currently do for CRYPTO_ALG_TESTED.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
