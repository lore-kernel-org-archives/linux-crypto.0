From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: mcryptd - remove pointless wrapper functions
Date: Thu, 25 Jan 2018 13:17:49 -0800
Message-ID: <8f04498f-ae78-fcfd-7952-f475b4acd4b6@linux.intel.com>
References: <20180125030907.679-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:31608 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751204AbeAYVRu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jan 2018 16:17:50 -0500
In-Reply-To: <20180125030907.679-1-ebiggers3@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/24/2018 07:09 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There is no need for ahash_mcryptd_{update,final,finup,digest}(); we
> should just call crypto_ahash_*() directly.
> 

This clean up could have been done when we made sha1-mb async.  Looks
reasonable.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/mcryptd.c               | 34 ++++------------------------------
>  include/crypto/internal/hash.h |  5 -----
>  2 files changed, 4 insertions(+), 35 deletions(-)
> 
> diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
> index fe5129d6ff4e..f14152147ce8 100644
> --- a/crypto/mcryptd.c
> +++ b/crypto/mcryptd.c
> @@ -367,7 +367,7 @@ static void mcryptd_hash_update(struct crypto_async_request *req_async, int err)
>  		goto out;
>  
>  	rctx->out = req->result;
> -	err = ahash_mcryptd_update(&rctx->areq);
> +	err = crypto_ahash_update(&rctx->areq);
>  	if (err) {
>  		req->base.complete = rctx->complete;
>  		goto out;
> @@ -394,7 +394,7 @@ static void mcryptd_hash_final(struct crypto_async_request *req_async, int err)
>  		goto out;
>  
>  	rctx->out = req->result;
> -	err = ahash_mcryptd_final(&rctx->areq);
> +	err = crypto_ahash_final(&rctx->areq);
>  	if (err) {
>  		req->base.complete = rctx->complete;
>  		goto out;
> @@ -420,7 +420,7 @@ static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
>  	if (unlikely(err == -EINPROGRESS))
>  		goto out;
>  	rctx->out = req->result;
> -	err = ahash_mcryptd_finup(&rctx->areq);
> +	err = crypto_ahash_finup(&rctx->areq);
>  
>  	if (err) {
>  		req->base.complete = rctx->complete;
> @@ -455,7 +455,7 @@ static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
>  						rctx->complete, req_async);
>  
>  	rctx->out = req->result;
> -	err = ahash_mcryptd_digest(desc);
> +	err = crypto_ahash_init(desc) ?: crypto_ahash_finup(desc);
>  
>  out:
>  	local_bh_disable();
> @@ -612,32 +612,6 @@ struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
>  }
>  EXPORT_SYMBOL_GPL(mcryptd_alloc_ahash);
>  
> -int ahash_mcryptd_digest(struct ahash_request *desc)
> -{
> -	return crypto_ahash_init(desc) ?: ahash_mcryptd_finup(desc);
> -}
> -
> -int ahash_mcryptd_update(struct ahash_request *desc)
> -{
> -	/* alignment is to be done by multi-buffer crypto algorithm if needed */
> -
> -	return crypto_ahash_update(desc);
> -}
> -
> -int ahash_mcryptd_finup(struct ahash_request *desc)
> -{
> -	/* alignment is to be done by multi-buffer crypto algorithm if needed */
> -
> -	return crypto_ahash_finup(desc);
> -}
> -
> -int ahash_mcryptd_final(struct ahash_request *desc)
> -{
> -	/* alignment is to be done by multi-buffer crypto algorithm if needed */
> -
> -	return crypto_ahash_final(desc);
> -}
> -
>  struct crypto_ahash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
>  {
>  	struct mcryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
> diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> index 27040a46d50a..a0b0ad9d585e 100644
> --- a/include/crypto/internal/hash.h
> +++ b/include/crypto/internal/hash.h
> @@ -126,11 +126,6 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
>  int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
>  int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
>  
> -int ahash_mcryptd_update(struct ahash_request *desc);
> -int ahash_mcryptd_final(struct ahash_request *desc);
> -int ahash_mcryptd_finup(struct ahash_request *desc);
> -int ahash_mcryptd_digest(struct ahash_request *desc);
> -
>  int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
>  
>  static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
> 
