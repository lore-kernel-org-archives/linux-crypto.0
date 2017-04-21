From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Fri, 21 Apr 2017 19:11:27 +0800
Message-ID: <20170421111127.GA13925@gondor.apana.org.au>
References: <2439869.UPpkkqdW7f@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42802 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1038287AbdDULLz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 07:11:55 -0400
Content-Disposition: inline
In-Reply-To: <2439869.UPpkkqdW7f@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 10, 2017 at 01:59:21PM +0200, Stephan Müller wrote:
>
> @@ -757,12 +887,14 @@ static void aead_sock_destruct(struct sock *sk)
>  	af_alg_release_parent(sk);
>  }
>  
> -static int aead_accept_parent(void *private, struct sock *sk)
> +static int aead_accept_parent_nokey(void *private, struct sock *sk)
>  {
>  	struct aead_ctx *ctx;
>  	struct alg_sock *ask = alg_sk(sk);
> -	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
> -	unsigned int ivlen = crypto_aead_ivsize(private);
> +	struct aead_tfm *tfm = private;
> +	struct crypto_aead *aead = tfm->aead;
> +	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(aead);
> +	unsigned int ivlen = crypto_aead_ivsize(aead);
>  
>  	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
>  	if (!ctx)
> @@ -789,7 +921,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
>  
>  	ask->private = ctx;
>  
> -	aead_request_set_tfm(&ctx->aead_req, private);
> +	aead_request_set_tfm(&ctx->aead_req, aead);
>  	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				  af_alg_complete, &ctx->completion);
>  

Please don't mix unrelated cleanups like this with the real change.
 It makes reviewing harder than necessary.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
