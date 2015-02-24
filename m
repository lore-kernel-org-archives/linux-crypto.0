From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 5/5] crypto: talitos: Add software backlog queue handling
Date: Tue, 24 Feb 2015 20:21:52 +0200
Message-ID: <54ECC140.9090100@freescale.com>
References: <1424449276-5288-1-git-send-email-mort@bork.org>
 <1424449276-5288-6-git-send-email-mort@bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Martin Hicks <mort@bork.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:39808
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753509AbbBXSWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 13:22:25 -0500
In-Reply-To: <1424449276-5288-6-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2/20/2015 6:21 PM, Martin Hicks wrote:
> I was running into situations where the hardware FIFO was filling up, and
> the code was returning EAGAIN to dm-crypt and just dropping the submitted
> crypto request.
> 
> This adds support in talitos for a software backlog queue.  When requests
> can't be queued to the hardware immediately EBUSY is returned.  The queued
> requests are dispatched to the hardware in received order as hardware FIFO
> slots become available.
> 
> Signed-off-by: Martin Hicks <mort@bork.org>

Hi Martin,

Thanks for the effort!
Indeed we noticed that talitos (and caam) don't play nicely with
dm-crypt, lacking a backlog mechanism.

Please run checkpatch --strict and fix the errors, warnings.

> ---
>  drivers/crypto/talitos.c |   92 +++++++++++++++++++++++++++++++++++-----------
>  drivers/crypto/talitos.h |    3 ++
>  2 files changed, 74 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index d3472be..226654c 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -183,43 +183,72 @@ static int init_device(struct device *dev)
>  }
>  
>  /**
> - * talitos_submit - submits a descriptor to the device for processing
> + * talitos_handle_queue - performs submissions either of new descriptors
> + *                        or ones waiting in the queue backlog.
>   * @dev:	the SEC device to be used
>   * @ch:		the SEC device channel to be used
> - * @edesc:	the descriptor to be processed by the device
> - * @context:	a handle for use by caller (optional)

The "context" kernel-doc should have been removed in patch 4/5.

> + * @edesc:	the descriptor to be processed by the device (optional)
>   *
>   * desc must contain valid dma-mapped (bus physical) address pointers.
>   * callback must check err and feedback in descriptor header
> - * for device processing status.
> + * for device processing status upon completion.
>   */
> -int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc)
> +int talitos_handle_queue(struct device *dev, int ch, struct talitos_edesc *edesc)
>  {
>  	struct talitos_private *priv = dev_get_drvdata(dev);
> -	struct talitos_request *request = &edesc->req;
> +	struct talitos_request *request, *orig_request = NULL;
> +	struct crypto_async_request *async_req;
>  	unsigned long flags;
>  	int head;
> +	int ret = -EINPROGRESS; 
>  
>  	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
>  
> +	if (edesc) {
> +		orig_request = &edesc->req;
> +		crypto_enqueue_request(&priv->chan[ch].queue, &orig_request->base);
> +	}

The request goes through the SW queue even if there are empty slots in
the HW queue, doing unnecessary crypto_queue_encrypt() and
crypto_queue_decrypt(). Trying to use the HW queue first would be better.

> +
> +flush_another:
> +	if (priv->chan[ch].queue.qlen == 0) {
> +		spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
> +		return 0;
> +	}
> +
>  	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
>  		/* h/w fifo is full */
>  		spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
> -		return -EAGAIN;
> +		return -EBUSY;
>  	}
>  
> -	head = priv->chan[ch].head;
> +	/* Dequeue the oldest request */
> +	async_req = crypto_dequeue_request(&priv->chan[ch].queue);
> +
> +	request = container_of(async_req, struct talitos_request, base);
>  	request->dma_desc = dma_map_single(dev, request->desc,
>  					   sizeof(*request->desc),
>  					   DMA_BIDIRECTIONAL);
>  
>  	/* increment fifo head */
> +	head = priv->chan[ch].head;
>  	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
>  
> -	smp_wmb();
> -	priv->chan[ch].fifo[head] = request;
> +	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
> +
> +	/*
> +	 * Mark a backlogged request as in-progress, return EBUSY because
> +	 * the original request that was submitted is backlogged.

s/is backlogged/is backlogged or dropped
Original request will not be enqueued by crypto_queue_enqueue() if the
CRYPTO_TFM_REQ_MAY_BACKLOG flag is not set (since SW queue is for
backlog only) - that's the case for IPsec requests.

> +	 */
> +	if (request != orig_request) {
> +		struct crypto_async_request *areq = request->context;
> +		areq->complete(areq, -EINPROGRESS);
> +		ret = -EBUSY;
> +	}
> +
> +	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
>  
>  	/* GO! */
> +	priv->chan[ch].fifo[head] = request;
>  	wmb();
>  	out_be32(priv->chan[ch].reg + TALITOS_FF,
>  		 upper_32_bits(request->dma_desc));
> @@ -228,9 +257,18 @@ int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc)
>  
>  	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
>  
> -	return -EINPROGRESS;
> +	/*
> +	 * When handling the queue via the completion path, queue more
> +	 * requests if the hardware has room.
> +	 */
> +	if (!edesc) {
> +		spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
> +		goto flush_another;
> +	}

This is better - avoids releasing and reacquiring the lock:

if (!edesc) {
	goto flush_another;
}

spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);


> +
> +	return ret;
>  }
> -EXPORT_SYMBOL(talitos_submit);
> +EXPORT_SYMBOL(talitos_handle_queue);
>  
>  /*
>   * process what was done, notify callback of error if not
> @@ -284,6 +322,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>  	}
>  
>  	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
> +
> +	talitos_handle_queue(dev, ch, NULL);
>  }
>  
>  /*
> @@ -1038,8 +1078,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
>  	edesc->req.callback = callback;
>  	edesc->req.context = areq;
>  
> -	ret = talitos_submit(dev, ctx->ch, edesc);
> -	if (ret != -EINPROGRESS) {
> +	ret = talitos_handle_queue(dev, ctx->ch, edesc);
> +	if (ret != -EINPROGRESS && ret != -EBUSY) {

Again, factor in CRYPTO_TFM_REQ_MAY_BACKLOG.
Only when talitos_handle_queue() returns -EBUSY *and*
CRYPTO_TFM_REQ_MAY_BACKLOG is set, the request is backlogged.

Thus the 2nd condition should be:
!(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)

Other places need similar fix.


>  		ipsec_esp_unmap(dev, edesc, areq);
>  		kfree(edesc);
>  	}
> @@ -1080,6 +1120,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>  						 unsigned int ivsize,
>  						 int icv_stashing,
>  						 u32 cryptoflags,
> +						 struct crypto_async_request *areq,
>  						 bool encrypt)
>  {
>  	struct talitos_edesc *edesc;
> @@ -1170,6 +1211,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
>  						     edesc->dma_len,
>  						     DMA_BIDIRECTIONAL);
>  	edesc->req.desc = &edesc->desc;
> +	/* A copy of the crypto_async_request to use the crypto_queue backlog */
> +	memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_request));

Why not have a
struct crypto_async_request *base;
instead of
struct crypto_async_request base;
in talitos_request structure?

This way:
1. memcopy above is avoided
2. talitos_request structure gets smaller - remember that
talitos_request is now embedded in talitos_edesc structure, which gets
kmalloc-ed for every request

That would be similar to previous driver behaviour.

Caller is expected not to destroy the request if the return code from
the Crypto API / backend driver is -EINPROGRESS or -EBUSY (when
MAY_BACKLOG flag is set).

>  
>  	return edesc;
>  }
> @@ -1184,7 +1227,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
>  	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
>  				   iv, areq->assoclen, areq->cryptlen,
>  				   ctx->authsize, ivsize, icv_stashing,
> -				   areq->base.flags, encrypt);
> +				   areq->base.flags, &areq->base, encrypt);
>  }
>  
>  static int aead_encrypt(struct aead_request *req)
> @@ -1413,8 +1456,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
>  	edesc->req.callback = callback;
>  	edesc->req.context = areq;
>  
> -	ret = talitos_submit(dev, ctx->ch, edesc);
> -	if (ret != -EINPROGRESS) {
> +	ret = talitos_handle_queue(dev, ctx->ch, edesc);
> +	if (ret != -EINPROGRESS && ret != -EBUSY) {
>  		common_nonsnoop_unmap(dev, edesc, areq);
>  		kfree(edesc);
>  	}
> @@ -1430,7 +1473,7 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
>  
>  	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
>  				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
> -				   areq->base.flags, encrypt);
> +				   areq->base.flags, &areq->base, encrypt);
>  }
>  
>  static int ablkcipher_encrypt(struct ablkcipher_request *areq)
> @@ -1596,8 +1639,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
>  	edesc->req.callback = callback;
>  	edesc->req.context = areq;
>  
> -	ret = talitos_submit(dev, ctx->ch, edesc);
> -	if (ret != -EINPROGRESS) {
> +	ret = talitos_handle_queue(dev, ctx->ch, edesc);
> +	if (ret != -EINPROGRESS && ret != -EBUSY) {
>  		common_nonsnoop_hash_unmap(dev, edesc, areq);
>  		kfree(edesc);
>  	}
> @@ -1612,7 +1655,7 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
>  	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
>  
>  	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
> -				   nbytes, 0, 0, 0, areq->base.flags, false);
> +				   nbytes, 0, 0, 0, areq->base.flags, &areq->base, false);
>  }
>  
>  static int ahash_init(struct ahash_request *areq)
> @@ -2690,6 +2733,13 @@ static int talitos_probe(struct platform_device *ofdev)
>  		}
>  
>  		atomic_set(&priv->chan[i].submit_count, -priv->chfifo_len);
> +
> +		/*
> +		 * The crypto_queue is used to manage the backlog only.  While
> +		 * the hardware FIFO has space requests are dispatched
> +		 * immediately.
> +		 */
> +		crypto_init_queue(&priv->chan[i].queue, 0);
>  	}
>  
>  	dma_set_mask(dev, DMA_BIT_MASK(36));
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 91faa76..a6f73e2 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -65,6 +65,7 @@ struct talitos_desc {
>   * @context: caller context (optional)
>   */
>  struct talitos_request {
> +	struct crypto_async_request base;
>  	struct talitos_desc *desc;
>  	dma_addr_t dma_desc;
>  	void (*callback) (struct device *dev, struct talitos_desc *desc,
> @@ -91,6 +92,8 @@ struct talitos_channel {
>  	spinlock_t tail_lock ____cacheline_aligned;
>  	/* index to next in-progress/done descriptor request */
>  	int tail;
> +
> +	struct crypto_queue queue;
>  };
>  
>  struct talitos_private {
> 
