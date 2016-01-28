From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: skcipher - return the correct request to the
 user
Date: Thu, 28 Jan 2016 12:53:36 +0800
Message-ID: <20160128045336.GA7782@gondor.apana.org.au>
References: <20160127171350.32579.49931.stgit@tstruk-mobl1>
 <20160127171355.32579.12218.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59411 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161583AbcA1Exm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 23:53:42 -0500
Content-Disposition: inline
In-Reply-To: <20160127171355.32579.12218.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 09:13:56AM -0800, Tadeusz Struk wrote:
>
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 69230e9..a9d54c0 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -142,6 +142,15 @@ static int skcipher_setkey_ablkcipher(struct crypto_skcipher *tfm,
>  	return err;
>  }
>  
> +static void skcipher_complete(struct crypto_async_request *req_base, int err)
> +{
> +	void *subreq = ablkcipher_request_cast(req_base);
> +	struct skcipher_request *req =
> +			container_of(subreq, struct skcipher_request, __ctx);
> +
> +	req->base.complete(&req->base, err);
> +}
> +
>  static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
>  				     int (*crypt)(struct ablkcipher_request *))
>  {
> @@ -151,7 +160,7 @@ static int skcipher_crypt_ablkcipher(struct skcipher_request *req,
>  
>  	ablkcipher_request_set_tfm(subreq, *ctx);
>  	ablkcipher_request_set_callback(subreq, skcipher_request_flags(req),
> -					req->base.complete, req->base.data);
> +					skcipher_complete, req->base.data);
>  	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
>  				     req->iv);

Rather than playing with lots of casts, just set the ablkcipher
callback data to req and be done with it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
