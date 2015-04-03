From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: remove instance when test failed
Date: Fri, 3 Apr 2015 17:58:28 +0800
Message-ID: <20150403095828.GA19273@gondor.apana.org.au>
References: <3394653.LODBE1uz62@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3394653.LODBE1uz62@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 02, 2015 at 07:05:27PM +0200, Stephan Mueller wrote:
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 83b04e0..215c604 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -545,6 +545,10 @@ unlock:
>  		goto err;
>  
>  	crypto_wait_for_test(larval);
> +
> +	/* Remove instance if test failed */
> +	if (!(inst->alg.cra_flags & CRYPTO_ALG_TESTED))
> +		crypto_unregister_instance(inst);

Unfortunately I don't think this is safe because the moment you
release the mutex the instance can be freed.  So you'll need to
hold a reference to it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
