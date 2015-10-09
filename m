From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3 5/5] crypto: marvell: factor out common import
 functions
Date: Fri, 9 Oct 2015 21:55:05 +0200
Message-ID: <20151009215505.4c05c425@bbrezillon>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
	<E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38051 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753771AbbJITzI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:55:08 -0400
In-Reply-To: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 09 Oct 2015 20:43:54 +0100
Russell King <rmk+kernel@arm.linux.org.uk> wrote:

> As all the import functions are virtually identical, factor out their
> common parts into a generic mv_cesa_import().  This performs the
> actual import, and we pass the data pointers and current length into
> this function.

Nice factorization indeed. Actually I think this can be done in other
places of this driver, but that's another story.

> 
> We have to switch a % const operation to do_div() to avoid provoking
> gcc to use the expensive 64-bit by 64-bit modulus operation.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Thanks.

> ---
>  drivers/crypto/marvell/hash.c | 88 +++++++++++--------------------------------
>  1 file changed, 21 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index b7c2c05f1a01..4f328b2a3a22 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -822,12 +822,13 @@ static int mv_cesa_md5_export(struct ahash_request *req, void *out)
>  	return 0;
>  }
>  
> -static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
> +static int mv_cesa_import(struct ahash_request *req, const void *hash, u64 len,
> +			  const void *cache)
>  {
> -	const struct md5_state *in_state = in;
>  	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
>  	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
>  	unsigned int digsize = crypto_ahash_digestsize(ahash);
> +	unsigned int blocksize;
>  	unsigned int cache_ptr;
>  	int ret;
>  
> @@ -835,16 +836,17 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
>  	if (ret)
>  		return ret;
>  
> -	if (in_state->byte_count >= sizeof(in_state->block))
> +	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
> +	if (len >= blocksize)
>  		mv_cesa_update_op_cfg(&creq->op_tmpl,
>  				      CESA_SA_DESC_CFG_MID_FRAG,
>  				      CESA_SA_DESC_CFG_FRAG_MSK);
>  
> -	creq->len = in_state->byte_count;
> -	memcpy(creq->state, in_state->hash, digsize);
> +	creq->len = len;
> +	memcpy(creq->state, hash, digsize);
>  	creq->cache_ptr = 0;
>  
> -	cache_ptr = creq->len % sizeof(in_state->block);
> +	cache_ptr = do_div(len, blocksize);
>  	if (!cache_ptr)
>  		return 0;
>  
> @@ -852,12 +854,20 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
>  	if (ret)
>  		return ret;
>  
> -	memcpy(creq->cache, in_state->block, cache_ptr);
> +	memcpy(creq->cache, cache, cache_ptr);
>  	creq->cache_ptr = cache_ptr;
>  
>  	return 0;
>  }
>  
> +static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
> +{
> +	const struct md5_state *in_state = in;
> +
> +	return mv_cesa_import(req, in_state->hash, in_state->byte_count,
> +			      in_state->block);
> +}
> +
>  static int mv_cesa_md5_digest(struct ahash_request *req)
>  {
>  	int ret;
> @@ -924,37 +934,9 @@ static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
>  static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
>  {
>  	const struct sha1_state *in_state = in;
> -	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> -	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> -	unsigned int digsize = crypto_ahash_digestsize(ahash);
> -	unsigned int cache_ptr;
> -	int ret;
> -
> -	ret = crypto_ahash_init(req);
> -	if (ret)
> -		return ret;
> -
> -	if (in_state->count >= SHA1_BLOCK_SIZE)
> -		mv_cesa_update_op_cfg(&creq->op_tmpl,
> -				      CESA_SA_DESC_CFG_MID_FRAG,
> -				      CESA_SA_DESC_CFG_FRAG_MSK);
>  
> -	creq->len = in_state->count;
> -	memcpy(creq->state, in_state->state, digsize);
> -	creq->cache_ptr = 0;
> -
> -	cache_ptr = creq->len % SHA1_BLOCK_SIZE;
> -	if (!cache_ptr)
> -		return 0;
> -
> -	ret = mv_cesa_ahash_alloc_cache(req);
> -	if (ret)
> -		return ret;
> -
> -	memcpy(creq->cache, in_state->buffer, cache_ptr);
> -	creq->cache_ptr = cache_ptr;
> -
> -	return 0;
> +	return mv_cesa_import(req, in_state->state, in_state->count,
> +			      in_state->buffer);
>  }
>  
>  static int mv_cesa_sha1_digest(struct ahash_request *req)
> @@ -1034,37 +1016,9 @@ static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
>  static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
>  {
>  	const struct sha256_state *in_state = in;
> -	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
> -	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> -	unsigned int digsize = crypto_ahash_digestsize(ahash);
> -	unsigned int cache_ptr;
> -	int ret;
>  
> -	ret = crypto_ahash_init(req);
> -	if (ret)
> -		return ret;
> -
> -	if (in_state->count >= SHA256_BLOCK_SIZE)
> -		mv_cesa_update_op_cfg(&creq->op_tmpl,
> -				      CESA_SA_DESC_CFG_MID_FRAG,
> -				      CESA_SA_DESC_CFG_FRAG_MSK);
> -
> -	creq->len = in_state->count;
> -	memcpy(creq->state, in_state->state, digsize);
> -	creq->cache_ptr = 0;
> -
> -	cache_ptr = creq->len % SHA256_BLOCK_SIZE;
> -	if (!cache_ptr)
> -		return 0;
> -
> -	ret = mv_cesa_ahash_alloc_cache(req);
> -	if (ret)
> -		return ret;
> -
> -	memcpy(creq->cache, in_state->buf, cache_ptr);
> -	creq->cache_ptr = cache_ptr;
> -
> -	return 0;
> +	return mv_cesa_import(req, in_state->state, in_state->count,
> +			      in_state->buf);
>  }
>  
>  struct ahash_alg mv_sha256_alg = {



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
