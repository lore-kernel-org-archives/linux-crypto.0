From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto : async implementation for sha1-mb
Date: Thu, 2 Jun 2016 18:33:31 +0800
Message-ID: <20160602103331.GA16969@gondor.apana.org.au>
References: <1464730941-8847-1-git-send-email-megha.dey@intel.com>
 <1464730941-8847-3-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fenghua.yu@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: Megha Dey <megha.dey@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464730941-8847-3-git-send-email-megha.dey@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 31, 2016 at 02:42:21PM -0700, Megha Dey wrote:
>
> @@ -416,8 +421,8 @@ static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
>  
>  	if (unlikely(err == -EINPROGRESS))
>  		goto out;
> -
> -	err = shash_ahash_mcryptd_finup(req, &rctx->desc);
> +	rctx->out = req->result;
> +	err = shash_ahash_mcryptd_finup(req, &rctx->areq);

These shash_ahash functions should be renamed.

Also why are they exported?

> @@ -439,17 +444,18 @@ static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
>  static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
>  {
>  	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
> -	struct crypto_shash *child = ctx->child;
> +	struct crypto_ahash *child = ctx->child;
>  	struct ahash_request *req = ahash_request_cast(req_async);
>  	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
> -	struct shash_desc *desc = &rctx->desc;
> +	struct ahash_request *desc = &rctx->areq;
> +	struct crypto_async_request *base = &desc->base;
>  
>  	if (unlikely(err == -EINPROGRESS))
>  		goto out;
> +	base->tfm = &child->base;
> +	base->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */

You should not be touching crypto_async_request directly.  Use
the proper ahash interface to set the child request.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
