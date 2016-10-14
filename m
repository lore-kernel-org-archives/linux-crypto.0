From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v4 2/2] crypto: marvell - Don't break chain for
 computable last ahash requests
Date: Fri, 14 Oct 2016 12:40:19 +0200
Message-ID: <20161014124019.2e9a685c@bbrezillon>
References: <20161005075633.12711-1-romain.perier@free-electrons.com>
        <20161005075633.12711-3-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:54508 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752758AbcJNKlK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2016 06:41:10 -0400
In-Reply-To: <20161005075633.12711-3-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed,  5 Oct 2016 09:56:33 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Currently, the driver breaks chain for all kind of hash requests in order to
> don't override intermediate states of partial ahash updates. However, some final
> ahash requests can be directly processed by the engine, and so without
> intermediate state. This is typically the case for most for the HMAC requests
> processed via IPSec.
> 
> This commits adds a TDMA descriptor to copy context for these of requests
> into the "op" dma pool, then it allow to chain these requests at the DMA level.
> The 'complete' operation is also updated to retrieve the MAC digest from the
> right location.
> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Minor comments below, otherwise it looks good.

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
> 
> Changes in v4:
>  - Remove the dummy descriptor at the end of the chain, when a TDMA_RESULT
>    is present. So, we re-wrote a bit the code of ahash_complete accordingly.
> 
> Changes in v3:
>  - Copy the whole context back to RAM and not just the digest. Also
>    fixed a rebase issue ^^ (whoops)
> 
> Changes in v2:
>  - Replaced BUG_ON by an error
>  - Add a variable "break_chain", with "type" to break the chain
> 
>  drivers/crypto/marvell/hash.c | 65 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 9f28468..2a92605 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -312,24 +312,40 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
>  	int i;
>  
>  	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
> -	for (i = 0; i < digsize / 4; i++)
> -		creq->state[i] = readl_relaxed(engine->regs + CESA_IVDIG(i));
>  
> -	if (creq->last_req) {
> +	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ &&
> +	    (creq->base.chain.last->flags & CESA_TDMA_TYPE_MSK) == CESA_TDMA_RESULT) {

Maybe it's time to create an helper to extract the TDMA desc type (as
you did for the CESA req type with mv_cesa_req_get_type()).

> +		__le32 *data = NULL;
> +
>  		/*
> -		 * Hardware's MD5 digest is in little endian format, but
> -		 * SHA in big endian format
> +		 * Result is already in the correct endianess when the SA is
> +		 * used
>  		 */
> -		if (creq->algo_le) {
> -			__le32 *result = (void *)ahashreq->result;
> +		data = creq->base.chain.last->op->ctx.hash.hash;
> +		for (i = 0; i < digsize / 4; i++)
> +			creq->state[i] = cpu_to_le32(data[i]);
>  
> -			for (i = 0; i < digsize / 4; i++)
> -				result[i] = cpu_to_le32(creq->state[i]);
> -		} else {
> -			__be32 *result = (void *)ahashreq->result;
> +		memcpy(ahashreq->result, data, digsize);
> +	} else {
> +		for (i = 0; i < digsize / 4; i++)
> +			creq->state[i] = readl_relaxed(engine->regs +
> +						       CESA_IVDIG(i));
> +		if (creq->last_req) {
> +			/*
> +			* Hardware's MD5 digest is in little endian format, but
> +			* SHA in big endian format
> +			*/
> +			if (creq->algo_le) {
> +				__le32 *result = (void *)ahashreq->result;
> +
> +				for (i = 0; i < digsize / 4; i++)
> +					result[i] = cpu_to_le32(creq->state[i]);
> +			} else {
> +				__be32 *result = (void *)ahashreq->result;
>  
> -			for (i = 0; i < digsize / 4; i++)
> -				result[i] = cpu_to_be32(creq->state[i]);
> +				for (i = 0; i < digsize / 4; i++)
> +					result[i] = cpu_to_be32(creq->state[i]);
> +			}
>  		}
>  	}
>  
> @@ -504,6 +520,12 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
>  						CESA_SA_DESC_CFG_LAST_FRAG,
>  				      CESA_SA_DESC_CFG_FRAG_MSK);
>  
> +		ret = mv_cesa_dma_add_result_op(chain,
> +						CESA_SA_CFG_SRAM_OFFSET,
> +						CESA_SA_DATA_SRAM_OFFSET,
> +						CESA_TDMA_SRC_IN_SRAM, flags);
> +		if (ret)
> +			return ERR_PTR(-ENOMEM);
>  		return op;
>  	}
>  
> @@ -564,6 +586,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
>  	struct mv_cesa_op_ctx *op = NULL;
>  	unsigned int frag_len;
>  	int ret;
> +	u32 type;
>  
>  	basereq->chain.first = NULL;
>  	basereq->chain.last = NULL;
> @@ -635,7 +658,15 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
>  		goto err_free_tdma;
>  	}
>  
> -	if (op) {
> +	/*
> +	 * If results are copied via DMA, this means that this
> +	 * request can be directly processed by the engine,
> +	 * without partial updates. So we can chain it at the
> +	 * DMA level with other requests.
> +	 */

Can you move this comment where it really belongs: when you
conditionally set the CESA_TDMA_BREAK_CHAIN flag.

> +	type = basereq->chain.last->flags & CESA_TDMA_TYPE_MSK;
> +
> +	if (op && type != CESA_TDMA_RESULT) {
>  		/* Add dummy desc to wait for crypto operation end */
>  		ret = mv_cesa_dma_add_dummy_end(&basereq->chain, flags);
>  		if (ret)
> @@ -648,8 +679,10 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
>  	else
>  		creq->cache_ptr = 0;
>  
> -	basereq->chain.last->flags |= (CESA_TDMA_END_OF_REQ |
> -				       CESA_TDMA_BREAK_CHAIN);
> +	basereq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
> +
> +	if (type != CESA_TDMA_RESULT)
> +		basereq->chain.last->flags |= CESA_TDMA_BREAK_CHAIN;
>  
>  	return 0;
>  
