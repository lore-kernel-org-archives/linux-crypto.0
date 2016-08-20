From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 1/2] crypto: marvell - Use an unique pool to copy
 results of requests
Date: Sat, 20 Aug 2016 08:26:27 +0200
Message-ID: <20160820082627.70a4cb55@bbrezillon>
References: <1471522334-24839-1-git-send-email-romain.perier@free-electrons.com>
        <1471522334-24839-2-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:43437 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751164AbcHTG1C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Aug 2016 02:27:02 -0400
In-Reply-To: <1471522334-24839-2-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Romain,

On Thu, 18 Aug 2016 14:12:13 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> So far, we used a dedicated dma pool to copy the result of outer IV for
> cipher requests. Instead of using a dma pool per outer data, we prefer
> use a common dma pool that contains the part of the SRAM that is likely
> to be used by the 'complete' operation, later. In this way, any type of
> result can be retrieved by DMA for cipher or ahash requests.

Can't we just re-use the op_pool (and drop the cesa_iv/result pool)? It
may be suboptimal in term of memory usage, but adding more pools also
adds some overhead.

> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/crypto/marvell/cesa.c   |  4 ++--
>  drivers/crypto/marvell/cesa.h   |  6 +++---
>  drivers/crypto/marvell/cipher.c |  2 +-
>  drivers/crypto/marvell/tdma.c   | 16 ++++++++--------
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
> index 37dadb2..4d308ad 100644
> --- a/drivers/crypto/marvell/cesa.c
> +++ b/drivers/crypto/marvell/cesa.c
> @@ -375,8 +375,8 @@ static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
>  	if (!dma->padding_pool)
>  		return -ENOMEM;
>  
> -	dma->iv_pool = dmam_pool_create("cesa_iv", dev, 16, 1, 0);
> -	if (!dma->iv_pool)
> +	dma->result_pool = dmam_pool_create("cesa_result", dev, 96, 1, 0);

It's better to use a sizeof(xxx) here to avoid bugs if the context size
grows.

The rest looks good.

Thanks,

Boris

> +	if (!dma->result_pool)
>  		return -ENOMEM;
>  
>  	cesa->dma = dma;
> diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
> index e423d33..3be1aa3 100644
> --- a/drivers/crypto/marvell/cesa.h
> +++ b/drivers/crypto/marvell/cesa.h
> @@ -277,7 +277,7 @@ struct mv_cesa_op_ctx {
>  #define CESA_TDMA_DUMMY				0
>  #define CESA_TDMA_DATA				1
>  #define CESA_TDMA_OP				2
> -#define CESA_TDMA_IV				3
> +#define CESA_TDMA_RESULT			3
>  
>  /**
>   * struct mv_cesa_tdma_desc - TDMA descriptor
> @@ -393,7 +393,7 @@ struct mv_cesa_dev_dma {
>  	struct dma_pool *op_pool;
>  	struct dma_pool *cache_pool;
>  	struct dma_pool *padding_pool;
> -	struct dma_pool *iv_pool;
> +	struct dma_pool *result_pool;
>  };
>  
>  /**
> @@ -839,7 +839,7 @@ mv_cesa_tdma_desc_iter_init(struct mv_cesa_tdma_chain *chain)
>  	memset(chain, 0, sizeof(*chain));
>  }
>  
> -int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
> +int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
>  			  u32 size, u32 flags, gfp_t gfp_flags);
>  
>  struct mv_cesa_op_ctx *mv_cesa_dma_add_op(struct mv_cesa_tdma_chain *chain,
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index d19dc96..bd575b1 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -373,7 +373,7 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
>  
>  	/* Add output data for IV */
>  	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
> -	ret = mv_cesa_dma_add_iv_op(&basereq->chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
> +	ret = mv_cesa_dma_add_result_op(&basereq->chain, CESA_SA_CRYPT_IV_SRAM_OFFSET,
>  				    ivsize, CESA_TDMA_SRC_IN_SRAM, flags);
>  
>  	if (ret)
> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
> index 9fd7a5f..499a1d3 100644
> --- a/drivers/crypto/marvell/tdma.c
> +++ b/drivers/crypto/marvell/tdma.c
> @@ -69,8 +69,8 @@ void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq)
>  		if (type == CESA_TDMA_OP)
>  			dma_pool_free(cesa_dev->dma->op_pool, tdma->op,
>  				      le32_to_cpu(tdma->src));
> -		else if (type == CESA_TDMA_IV)
> -			dma_pool_free(cesa_dev->dma->iv_pool, tdma->data,
> +		else if (type == CESA_TDMA_RESULT)
> +			dma_pool_free(cesa_dev->dma->result_pool, tdma->data,
>  				      le32_to_cpu(tdma->dst));
>  
>  		tdma = tdma->next;
> @@ -209,29 +209,29 @@ mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
>  	return new_tdma;
>  }
>  
> -int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
> +int mv_cesa_dma_add_result_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
>  			  u32 size, u32 flags, gfp_t gfp_flags)
>  {
>  
>  	struct mv_cesa_tdma_desc *tdma;
> -	u8 *iv;
> +	u8 *result;
>  	dma_addr_t dma_handle;
>  
>  	tdma = mv_cesa_dma_add_desc(chain, gfp_flags);
>  	if (IS_ERR(tdma))
>  		return PTR_ERR(tdma);
>  
> -	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, gfp_flags, &dma_handle);
> -	if (!iv)
> +	result = dma_pool_alloc(cesa_dev->dma->result_pool, gfp_flags, &dma_handle);
> +	if (!result)
>  		return -ENOMEM;
>  
>  	tdma->byte_cnt = cpu_to_le32(size | BIT(31));
>  	tdma->src = src;
>  	tdma->dst = cpu_to_le32(dma_handle);
> -	tdma->data = iv;
> +	tdma->data = result;
>  
>  	flags &= (CESA_TDMA_DST_IN_SRAM | CESA_TDMA_SRC_IN_SRAM);
> -	tdma->flags = flags | CESA_TDMA_IV;
> +	tdma->flags = flags | CESA_TDMA_RESULT;
>  	return 0;
>  }
>  
