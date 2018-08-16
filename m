From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] crypto: Remove mcryptd
Date: Thu, 16 Aug 2018 14:55:20 +0800
Message-ID: <20180816065520.pojqi7pplpnknlv5@gondor.apana.org.au>
References: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
 <20180720035325.m5tzeuqsfej3y6wd@gondor.apana.org.au>
 <1532651107.19157.24.camel@megha-Z97X-UD7-TH>
 <20180808095621.h7ecacftx5ofe5ki@gondor.apana.org.au>
 <1533868833.19050.19.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1533868833.19050.19.camel@megha-Z97X-UD7-TH>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 09, 2018 at 07:40:33PM -0700, Megha Dey wrote:
>
> 1. 
> @@ -495,7 +534,10 @@ static void cryptd_skcipher_encrypt(struct
> crypto_async_request *base,
>         skcipher_request_set_crypt(subreq, req->src, req->dst,
> req->cryptlen, req->iv);
>  
> -       err = crypto_skcipher_encrypt(subreq);
> +       subreq->base.data = req->base.data;
> +       subreq->base.complete = rctx->complete;
> +       rctx->desc = *subreq;
> +       err = crypto_skcipher_encrypt(&rctx->desc);
>         skcipher_request_zero(subreq);
> 
> This change is necessary because for the multibuffer algorithms, the
> inner algorithm needs a pointer to the original request. In the slow
> path, since we allocate a skcipher_request on the stack, there is no
> easy way to retrieve the request. In the mcryptd_layer, we had extra
> logic to store this pointer. 

Why do you need the original request?

I think the fact that you need this at all indicates that you're
not using cryptd correctly.  cryptd should be completely transparent
to the underlying algorithm.  All it's doing is making sure that
the underlying algorithm gets called in a context that allows SIMD
use.

> Lastly, for hashes, we have
> struct cryptd_hash_request_ctx {
>         crypto_completion_t complete;
>         struct shash_desc desc;
> };
> 
> If we were to use this(with the added fields for multibuffer), we should
> update the shash_desc to ahash_request since we are an async algorithm
> right?

That's a good point.  More importantly, you also need to extend
cryptd to allow an ASYNC underlying algorithm, for skcipher as well
as hashes.  This is not as simple as just modifying the type/mask
during algorithm creation.  But you also need to modify the run-time
(e.g., cryptd_skcipher_encrypt) to defer the completion in case of an
async return value.

The same change also needs to be made to crypto/simd.c, but at least
there the run-time doesn't need any changes AFAICS.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
