From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 3/7] crypto: marvell: Copy IV vectors by DMA transfers
 for acipher requests
Date: Wed, 15 Jun 2016 22:07:16 +0200
Message-ID: <20160615220716.6ad3b856@bbrezillon>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
 <1466018134-10779-4-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Russell King <linux@arm.linux.org.uk>, Arnaud Ebalard <arno@natisbad.org>,
 linux-crypto@vger.kernel.org,
 Gregory Clement <gregory.clement@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1466018134-10779-4-git-send-email-romain.perier@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 15 Jun 2016 21:15:30 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Adding a TDMA descriptor at the end of the request for copying the
> output IV vector via a DMA transfer. This is required for processing
> cipher requests asynchroniously in chained mode, otherwise the content

		  asynchronously

> of the IV vector will be overwriten for each new finished request.

BTW, Not sure the term 'asynchronously' is appropriate here. The
standard (AKA non-DMA) processing is also asynchronous. The real reason
here is that you want to chain the requests and offload as much
processing as possible to the DMA and crypto engine. And as you
explained, this is only possible if we retrieve the updated IV using
DMA. 

> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/crypto/marvell/cesa.c   |  4 ++++
>  drivers/crypto/marvell/cesa.h   |  5 +++++
>  drivers/crypto/marvell/cipher.c | 40 +++++++++++++++++++++++++++-------------
>  drivers/crypto/marvell/tdma.c   | 29 +++++++++++++++++++++++++++++
>  4 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index fb403e1..93700cd 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -312,6 +312,10 @@ static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
>  	if (!dma->padding_pool)
>  		return -ENOMEM;
>  
> +	dma->iv_pool = dmam_pool_create("cesa_iv", dev, 16, 1, 0);
> +	if (!dma->iv_pool)
> +		return -ENOMEM;
> +
>  	cesa->dma = dma;
>  
>  	return 0;
> diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
> index 74071e4..74b84bd 100644
> --- a/drivers/crypto/marvell/cesa.h
> +++ b/drivers/crypto/marvell/cesa.h
> @@ -275,6 +275,7 @@ struct mv_cesa_op_ctx {
>  #define CESA_TDMA_DUMMY				0
>  #define CESA_TDMA_DATA				1
>  #define CESA_TDMA_OP				2
> +#define CESA_TDMA_IV				4

Should be 3 and not 4: TDMA_TYPE is an enum, not a bit field.

>  
>  /**
>   * struct mv_cesa_tdma_desc - TDMA descriptor
> @@ -390,6 +391,7 @@ struct mv_cesa_dev_dma {
>  	struct dma_pool *op_pool;
>  	struct dma_pool *cache_pool;
>  	struct dma_pool *padding_pool;
> +	struct dma_pool *iv_pool;
>  };
>  
>  /**
> @@ -790,6 +792,9 @@ mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
>  	memset(chain, 0, sizeof(*chain));
>  }
>  
> +int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
> +			  u32 size, u32 flags, gfp_t gfp_flags);
> +
>  struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
>  					const struct mv_cesa_op_ctx *op_templ,
>  					bool skip_ctx,
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index 8d0fabb..f42620e 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -118,6 +118,7 @@ static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *req,
>  	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
>  	struct mv_cesa_engine *engine = sreq->base.engine;
>  	size_t len;
> +	unsigned int ivsize;
>  
>  	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
>  				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> @@ -127,6 +128,10 @@ static int mv_cesa_ablkcipher_std_process(struct ablkcipher_request *req,
>  	if (sreq->offset < req->nbytes)
>  		return -EINPROGRESS;
>  
> +	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
> +	memcpy_fromio(req->info,
> +		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET, ivsize);
> +
>  	return 0;
>  }
>  
> @@ -135,23 +140,23 @@ static int mv_cesa_ablkcipher_process(struct crypto_async_request *req,
>  {
>  	struct ablkcipher_request *ablkreq = ablkcipher_request_cast(req);
>  	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(ablkreq);
> -	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
> -	struct mv_cesa_engine *engine = sreq->base.engine;
> -	int ret;
>  
> -	if (creq->req.base.type == CESA_DMA_REQ)
> +	if (creq->req.base.type == CESA_DMA_REQ) {
> +		int ret;
> +		struct mv_cesa_tdma_req *dreq;
> +		unsigned int ivsize;
> +
>  		ret = mv_cesa_dma_process(&creq->req.dma, status);
> -	else
> -		ret = mv_cesa_ablkcipher_std_process(ablkreq, status);
> +		if (ret)
> +			return ret;
>  
> -	if (ret)
> +		dreq = &creq->req.dma;
> +		ivsize = crypto_ablkcipher_ivsize(
> +					     crypto_ablkcipher_reqtfm(ablkreq));

Sometime it's better to offend the < 80 characters rule than doing
funky stuff ;).

> +		memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);
>  		return ret;
> -
> -	memcpy_fromio(ablkreq->info,
> -		      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
> -		      crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq)));
> -
> -	return 0;
> +	}

Missing blank line.

> +	return mv_cesa_ablkcipher_std_process(ablkreq, status);

This version is more readable IMHO:

	struct mv_cesa_tdma_req *dreq;
	unsigned int ivsize;
	int ret;

	if (creq->req.base.type == CESA_STD_REQ)
		return mv_cesa_ablkcipher_std_process(ablkreq, status);

	ret = mv_cesa_dma_process(&creq->req.dma, status);
	if (ret)
		return ret;

	dreq = &creq->req.dma;
	ivsize =
	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
	memcpy_fromio(ablkreq->info, dreq->chain.last->data, ivsize);

	return 0;

>  
>  static void mv_cesa_ablkcipher_step(struct crypto_async_request *req)
> @@ -302,6 +307,7 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
>  	struct mv_cesa_tdma_chain chain;
>  	bool skip_ctx = false;
>  	int ret;
> +	unsigned int ivsize;
>  
>  	dreq->base.type = CESA_DMA_REQ;
>  	dreq->chain.first = NULL;
> @@ -360,6 +366,14 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
>  
>  	} while (mv_cesa_ablkcipher_req_iter_next_op(&iter));
>  
> +	/* Add output data for IV */
> +	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
> +	ret = mv_cesa_dma_add_iv_op(&chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
> +				    ivsize, CESA_TDMA_SRC_IN_SRAM, flags);
> +
> +	if (ret)
> +		goto err_free_tdma;
> +
>  	dreq->chain = chain;
>  
>  	return 0;
> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
> index d493714..88c87be 100644
> --- a/drivers/crypto/marvell/tdma.c
> +++ b/drivers/crypto/marvell/tdma.c
> @@ -68,6 +68,9 @@ void mv_cesa_dma_cleanup(struct mv_cesa_tdma_req *dreq)
>  		if (tdma->flags & CESA_TDMA_OP)

I realize this test is wrong.

It should be
		type = tdma->flags & CESA_TDMA_TYPE_MSK;
		if (type == CESA_TDMA_OP)

>  			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
>  				      le32_to_cpu(tdma->src));
> +		else if (tdma->flags & CESA_TDMA_IV)

and here
		else if (type == CESA_TDMA_IV)

> +			dma_pool_free(cesa_dev->dma->iv_pool, tdma->data,
> +				      le32_to_cpu(tdma->dst));
>  
>  		tdma = tdma->next;
>  		dma_pool_free(cesa_dev->dma->tdma_desc_pool, old_tdma,
> @@ -120,6 +123,32 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
>  	return new_tdma;
>  }
>  
> +int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
> +			  u32 size, u32 flags, gfp_t gfp_flags)
> +{
> +
> +	struct mv_cesa_tdma_desc *tdma;
> +	u8 *cache;

Why do you name that one cache? iv would be a better name.

> +	dma_addr_t dma_handle;
> +
> +	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
> +	if (IS_ERR(tdma))
> +		return PTR_ERR(tdma);
> +
> +	cache = dma_pool_alloc(cesa_dev->dma->iv_pool, flags, &dma_handle);
> +	if (!cache)
> +		return -ENOMEM;
> +
> +	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
> +	tdma->src = src;
> +	tdma->dst = cpu_to_le32(dma_handle);
> +	tdma->data = cache;
> +
> +	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
> +	tdma->flags = flags | CESA_TDMA_DATA | CESA_TDMA_IV;

You should not mix 2 different types, it's either CESA_TDMA_DATA or
CESA_TDMA_IV, and in this case it should be CESA_TDMA_IV.

> +	return 0;
> +}
> +
>  struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
>  					const struct mv_cesa_op_ctx *op_templ,
>  					bool skip_ctx,



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
