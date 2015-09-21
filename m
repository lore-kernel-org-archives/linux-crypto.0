From: Vincent Donnefort <vdonnefort@gmail.com>
Subject: Re: [PATCH] crypto: marvell: properly handle
 CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests
Date: Mon, 21 Sep 2015 11:15:38 +0200
Message-ID: <20150921091537.GA7584@ns3274321.ip-5-39-88.eu>
References: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	linux-arm-kernel@lists.infradead.org,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	stable@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442589936-18042-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Thomas,

Your patch fixes the problem on my side.

Tested-by: Vincent Donnefort <vdonnefort@gmail.com>

On Fri, Sep 18, 2015 at 05:25:36PM +0200, Thomas Petazzoni wrote:
> The mv_cesa_queue_req() function calls crypto_enqueue_request() to
> enqueue a request. In the normal case (i.e the queue isn't full), this
> function returns -EINPROGRESS. The current Marvell CESA crypto driver
> takes this into account and cleans up the request only if an error
> occured, i.e if the return value is not -EINPROGRESS.
> 
> Unfortunately this causes problems with
> CRYPTO_TFM_REQ_MAY_BACKLOG-flagged requests. When such a request is
> passed to crypto_enqueue_request() and the queue is full,
> crypto_enqueue_request() will return -EBUSY, but will keep the request
> enqueued nonetheless. This situation was not properly handled by the
> Marvell CESA driver, which was anyway cleaning up the request in such
> a situation. When later on the request was taken out of the backlog
> and actually processed, a kernel crash occured due to the internal
> driver data structures for this structure having been cleaned up.
> 
> To avoid this situation, this commit adds a
> mv_cesa_req_needs_cleanup() helper function which indicates if the
> request needs to be cleaned up or not after a call to
> crypto_enqueue_request(). This helper allows to do the cleanup only in
> the appropriate cases, and all call sites of mv_cesa_queue_req() are
> fixed to use this new helper function.
> 
> Reported-by: Vincent Donnefort <vdonnefort@gmail.com>
> Fixes: db509a45339fd ("crypto: marvell/cesa - add TDMA support")
> Cc: <stable@vger.kernel.org> # v4.2+
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>  drivers/crypto/marvell/cesa.h   | 27 +++++++++++++++++++++++++++
>  drivers/crypto/marvell/cipher.c |  7 +++----
>  drivers/crypto/marvell/hash.c   |  8 +++-----
>  3 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
> index b60698b..bc2a55b 100644
> --- a/drivers/crypto/marvell/cesa.h
> +++ b/drivers/crypto/marvell/cesa.h
> @@ -687,6 +687,33 @@ static inline u32 mv_cesa_get_int_mask(struct mv_cesa_engine *engine)
>  
>  int mv_cesa_queue_req(struct crypto_async_request *req);
>  
> +/*
> + * Helper function that indicates whether a crypto request needs to be
> + * cleaned up or not after being enqueued using mv_cesa_queue_req().
> + */
> +static inline int mv_cesa_req_needs_cleanup(struct crypto_async_request *req,
> +					    int ret)
> +{
> +	/*
> +	 * The queue still had some space, the request was queued
> +	 * normally, so there's no need to clean it up.
> +	 */
> +	if (ret == -EINPROGRESS)
> +		return false;
> +
> +	/*
> +	 * The queue had not space left, but since the request is
> +	 * flagged with CRYPTO_TFM_REQ_MAY_BACKLOG, it was added to
> +	 * the backlog and will be processed later. There's no need to
> +	 * clean it up.
> +	 */
> +	if (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
> +		return false;
> +
> +	/* Request wasn't queued, we need to clean it up */
> +	return true;
> +}
> +
>  /* TDMA functions */
>  
>  static inline void mv_cesa_req_dma_iter_init(struct mv_cesa_dma_iter *iter,
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index 0745cf3..3df2f4e 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -189,7 +189,6 @@ static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
>  {
>  	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
>  	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
> -
>  	creq->req.base.engine = engine;
>  
>  	if (creq->req.base.type == CESA_DMA_REQ)
> @@ -431,7 +430,7 @@ static int mv_cesa_des_op(struct ablkcipher_request *req,
>  		return ret;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS)
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ablkcipher_cleanup(req);
>  
>  	return ret;
> @@ -551,7 +550,7 @@ static int mv_cesa_des3_op(struct ablkcipher_request *req,
>  		return ret;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS)
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ablkcipher_cleanup(req);
>  
>  	return ret;
> @@ -693,7 +692,7 @@ static int mv_cesa_aes_op(struct ablkcipher_request *req,
>  		return ret;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS)
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ablkcipher_cleanup(req);
>  
>  	return ret;
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index ae9272e..e8d0d71 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -739,10 +739,8 @@ static int mv_cesa_ahash_update(struct ahash_request *req)
>  		return 0;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS) {
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ahash_cleanup(req);
> -		return ret;
> -	}
>  
>  	return ret;
>  }
> @@ -766,7 +764,7 @@ static int mv_cesa_ahash_final(struct ahash_request *req)
>  		return 0;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS)
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ahash_cleanup(req);
>  
>  	return ret;
> @@ -791,7 +789,7 @@ static int mv_cesa_ahash_finup(struct ahash_request *req)
>  		return 0;
>  
>  	ret = mv_cesa_queue_req(&req->base);
> -	if (ret && ret != -EINPROGRESS)
> +	if (mv_cesa_req_needs_cleanup(&req->base, ret))
>  		mv_cesa_ahash_cleanup(req);
>  
>  	return ret;
> -- 
> 2.5.2
> 
