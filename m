From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 1/2] crypto: marvell/cesa - fix memory leak
Date: Thu, 17 Mar 2016 10:44:12 +0100
Message-ID: <20160317104412.755a74ad@bbrezillon>
References: <1458206495-11369-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Romain Perier <romain.perier@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458206495-11369-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 17 Mar 2016 10:21:34 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Crypto requests are not guaranteed to be finalized (->final() call),
> and can be freed at any moment, without getting any notification from
> the core. This can lead to memory leaks of the ->cache buffer.
> 
> Make this buffer part of the request object, and allocate an extra buffer
> from the DMA cache pool when doing DMA operations.
> 
> As a side effect, this patch also fixes another bug related to cache
> allocation and DMA operations. When the core allocates a new request and
> import an existing state, a cache buffer can be allocated (depending
> on the state). The problem is, at that very moment, we don't know yet
> whether the request will use DMA or not, and since everything is
> likely to be initialized to zero, mv_cesa_ahash_alloc_cache() thinks it
> should allocate a buffer for standard operation. But when
> mv_cesa_ahash_free_cache() is called, req->type has been set to
> CESA_DMA_REQ in the meantime, thus leading to an invalind dma_pool_free()
> call (the buffer passed in argument has not been allocated from the pool).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Reported-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Forgot to add

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Cc: stable@vger.kernel.org # 4.3+

> ---
>  drivers/crypto/marvell/cesa.h |  3 +-
>  drivers/crypto/marvell/hash.c | 86 +++++++++----------------------------------
>  2 files changed, 20 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
> index bd985e7..74071e4 100644
> --- a/drivers/crypto/marvell/cesa.h
> +++ b/drivers/crypto/marvell/cesa.h
> @@ -588,6 +588,7 @@ struct mv_cesa_ahash_dma_req {
>  	struct mv_cesa_tdma_req base;
>  	u8 *padding;
>  	dma_addr_t padding_dma;
> +	u8 *cache;
>  	dma_addr_t cache_dma;
>  };
>  
> @@ -609,7 +610,7 @@ struct mv_cesa_ahash_req {
>  		struct mv_cesa_ahash_std_req std;
>  	} req;
>  	struct mv_cesa_op_ctx op_tmpl;
> -	u8 *cache;
> +	u8 cache[CESA_MAX_HASH_BLOCK_SIZE];
>  	unsigned int cache_ptr;
>  	u64 len;
>  	int src_nents;
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 683cca9..f07c1fa 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -45,69 +45,25 @@ mv_cesa_ahash_req_iter_next_op(struct mv_cesa_ahash_dma_iter *iter)
>  	return mv_cesa_req_dma_iter_next_op(&iter->base);
>  }
>  
> -static inline int mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_req *creq,
> -						gfp_t flags)
> +static inline int
> +mv_cesa_ahash_dma_alloc_cache(struct mv_cesa_ahash_dma_req *req, gfp_t flags)
>  {
> -	struct mv_cesa_ahash_dma_req *dreq = &creq->req.dma;
> -
> -	creq->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
> -				     &dreq->cache_dma);
> -	if (!creq->cache)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -
> -static inline int mv_cesa_ahash_std_alloc_cache(struct mv_cesa_ahash_req *creq,
> -						gfp_t flags)
> -{
> -	creq->cache = kzalloc(CESA_MAX_HASH_BLOCK_SIZE, flags);
> -	if (!creq->cache)
> +	req->cache = dma_pool_alloc(cesa_dev->dma->cache_pool, flags,
> +				    &req->cache_dma);
> +	if (!req->cache)
>  		return -ENOMEM;
>  
>  	return 0;
>  }
>  
> -static int mv_cesa_ahash_alloc_cache(struct ahash_request *req)
> -{
> -	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> -	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
> -		      GFP_KERNEL : GFP_ATOMIC;
> -	int ret;
> -
> -	if (creq->cache)
> -		return 0;
> -
> -	if (creq->req.base.type == CESA_DMA_REQ)
> -		ret = mv_cesa_ahash_dma_alloc_cache(creq, flags);
> -	else
> -		ret = mv_cesa_ahash_std_alloc_cache(creq, flags);
> -
> -	return ret;
> -}
> -
> -static inline void mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_req *creq)
> -{
> -	dma_pool_free(cesa_dev->dma->cache_pool, creq->cache,
> -		      creq->req.dma.cache_dma);
> -}
> -
> -static inline void mv_cesa_ahash_std_free_cache(struct mv_cesa_ahash_req *creq)
> -{
> -	kfree(creq->cache);
> -}
> -
> -static void mv_cesa_ahash_free_cache(struct mv_cesa_ahash_req *creq)
> +static inline void
> +mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
>  {
> -	if (!creq->cache)
> +	if (!req->cache)
>  		return;
>  
> -	if (creq->req.base.type == CESA_DMA_REQ)
> -		mv_cesa_ahash_dma_free_cache(creq);
> -	else
> -		mv_cesa_ahash_std_free_cache(creq);
> -
> -	creq->cache = NULL;
> +	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
> +		      req->cache_dma);
>  }
>  
>  static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
> @@ -146,6 +102,7 @@ static inline void mv_cesa_ahash_dma_cleanup(struct ahash_request *req)
>  	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
>  
>  	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
> +	mv_cesa_ahash_dma_free_cache(&creq->req.dma);
>  	mv_cesa_dma_cleanup(&creq->req.dma.base);
>  }
>  
> @@ -161,8 +118,6 @@ static void mv_cesa_ahash_last_cleanup(struct ahash_request *req)
>  {
>  	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
>  
> -	mv_cesa_ahash_free_cache(creq);
> -
>  	if (creq->req.base.type == CESA_DMA_REQ)
>  		mv_cesa_ahash_dma_last_cleanup(req);
>  }
> @@ -445,14 +400,6 @@ static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
>  static int mv_cesa_ahash_cache_req(struct ahash_request *req, bool *cached)
>  {
>  	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
> -	int ret;
> -
> -	if (((creq->cache_ptr + req->nbytes) & CESA_HASH_BLOCK_SIZE_MSK) &&
> -	    !creq->last_req) {
> -		ret = mv_cesa_ahash_alloc_cache(req);
> -		if (ret)
> -			return ret;
> -	}
>  
>  	if (creq->cache_ptr + req->nbytes < 64 && !creq->last_req) {
>  		*cached = true;
> @@ -505,10 +452,17 @@ mv_cesa_ahash_dma_add_cache(struct mv_cesa_tdma_chain *chain,
>  			    gfp_t flags)
>  {
>  	struct mv_cesa_ahash_dma_req *ahashdreq = &creq->req.dma;
> +	int ret;
>  
>  	if (!creq->cache_ptr)
>  		return 0;
>  
> +	ret = mv_cesa_ahash_dma_alloc_cache(ahashdreq, flags);
> +	if (ret)
> +		return ret;
> +
> +	memcpy(ahashdreq->cache, creq->cache, creq->cache_ptr);
> +
>  	return mv_cesa_dma_add_data_transfer(chain,
>  					     CESA_SA_DATA_SRAM_OFFSET,
>  					     ahashdreq->cache_dma,
> @@ -848,10 +802,6 @@ static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
>  	if (!cache_ptr)
>  		return 0;
>  
> -	ret = mv_cesa_ahash_alloc_cache(req);
> -	if (ret)
> -		return ret;
> -
>  	memcpy(creq->cache, cache, cache_ptr);
>  	creq->cache_ptr = cache_ptr;
>  



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
