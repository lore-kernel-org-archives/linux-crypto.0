From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC 01/11] crypto: caam - Add cache coherency support
Date: Wed, 17 Jun 2015 10:23:03 +0200
Message-ID: <20150617082303.GM7947@pengutronix.de>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57665 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbbFQIXF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 04:23:05 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:49PM -0700, Victoria Milhoan wrote:
> Freescale i.MX6 ARM platforms do not support hardware cache coherency.  This
> patch adds cache coherency support to the CAAM driver.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> ---
>  drivers/crypto/caam/caamhash.c   | 28 +++++++++++++++++----------
>  drivers/crypto/caam/caamrng.c    | 10 +++++++++-
>  drivers/crypto/caam/jr.c         | 42 +++++++++++++++++++++++++++++++++++++++-
>  drivers/crypto/caam/key_gen.c    |  4 +++-
>  drivers/crypto/caam/sg_sw_sec4.h |  1 +
>  5 files changed, 72 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index ba0532e..1662c65 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -500,6 +500,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
>  #endif
>  	}
>  	dma_unmap_single(jrdev, src_dma, *keylen, DMA_TO_DEVICE);
> +	dma_sync_single_for_cpu(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
>  	dma_unmap_single(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
>  
>  	*keylen = digestsize;
> @@ -608,8 +609,11 @@ static inline void ahash_unmap(struct device *dev,
>  	if (edesc->src_nents)
>  		dma_unmap_sg_chained(dev, req->src, edesc->src_nents,
>  				     DMA_TO_DEVICE, edesc->chained);
> -	if (edesc->dst_dma)
> +	if (edesc->dst_dma) {
> +		dma_sync_single_for_cpu(dev, edesc->dst_dma, dst_len,
> +					DMA_FROM_DEVICE);
>  		dma_unmap_single(dev, edesc->dst_dma, dst_len, DMA_FROM_DEVICE);
> +	}
>  
>  	if (edesc->sec4_sg_bytes)
>  		dma_unmap_single(dev, edesc->sec4_sg_dma,
> @@ -624,8 +628,12 @@ static inline void ahash_unmap_ctx(struct device *dev,
>  	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
>  	struct caam_hash_state *state = ahash_request_ctx(req);
>  
> -	if (state->ctx_dma)
> +	if (state->ctx_dma) {
> +		if ((flag == DMA_FROM_DEVICE) || (flag == DMA_BIDIRECTIONAL))
> +			dma_sync_single_for_cpu(dev, state->ctx_dma,
> +						ctx->ctx_len, flag);
>  		dma_unmap_single(dev, state->ctx_dma, ctx->ctx_len, flag);
> +	}
>  	ahash_unmap(dev, edesc, req, dst_len);
>  }

Unneeded syncing, dma_unmap does it as long as it is not told otherwise.

(...)

> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 26a544b..a8c4af9 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -80,9 +80,12 @@ static struct caam_rng_ctx *rng_ctx;
>  
>  static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
>  {
> -	if (bd->addr)
> +	if (bd->addr) {
> +		dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE,
> +					DMA_FROM_DEVICE);
>  		dma_unmap_single(jrdev, bd->addr, RN_BUF_SIZE,
>  				 DMA_FROM_DEVICE);
> +	}
>  }
> 

dito

>  static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
> @@ -108,6 +111,10 @@ static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
>  
>  	atomic_set(&bd->empty, BUF_NOT_EMPTY);
>  	complete(&bd->filled);
> +
> +	/* Buffer refilled, invalidate cache */
> +	dma_sync_single_for_cpu(jrdev, bd->addr, RN_BUF_SIZE, DMA_FROM_DEVICE);
> +

This seems to be okay, though.

>  #ifdef DEBUG
>  	print_hex_dump(KERN_ERR, "rng refreshed buf@: ",
>  		       DUMP_PREFIX_ADDRESS, 16, 4, bd->buf, RN_BUF_SIZE, 1);
> @@ -211,6 +218,7 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
>  	print_hex_dump(KERN_ERR, "rng shdesc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
>  		       desc, desc_bytes(desc), 1);
>  #endif
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index b8b5d47..a693bf7 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -168,6 +168,9 @@ static void caam_jr_dequeue(unsigned long devarg)
>  	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
>  	u32 *userdesc, userstatus;
>  	void *userarg;
> +	dma_addr_t outbusaddr;
> +
> +	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
>  
>  	while (rd_reg32(&jrp->rregs->outring_used)) {
>  
> @@ -177,10 +180,19 @@ static void caam_jr_dequeue(unsigned long devarg)
>  
>  		sw_idx = tail = jrp->tail;
>  		hw_idx = jrp->out_ring_read_index;
> +		dma_sync_single_for_cpu(dev, outbusaddr,
> +					sizeof(struct jr_outentry) * JOBR_DEPTH,
> +					DMA_FROM_DEVICE);
>  

This one and ...

(...)

> @@ -321,7 +346,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>  	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
>  	struct caam_jrentry_info *head_entry;
>  	int head, tail, desc_size;
> -	dma_addr_t desc_dma;
> +	dma_addr_t desc_dma, inpbusaddr;
>  
>  	desc_size = (*desc & HDR_JD_LENGTH_MASK) * sizeof(u32);
>  	desc_dma = dma_map_single(dev, desc, desc_size, DMA_TO_DEVICE);
> @@ -330,6 +355,11 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>  		return -EIO;
>  	}
>  
> +	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
> +	dma_sync_single_for_device(dev, inpbusaddr,
> +					sizeof(dma_addr_t) * JOBR_DEPTH,
> +					DMA_TO_DEVICE);
> +
>  	spin_lock_bh(&jrp->inplock);
>  
>  	head = jrp->head;
> @@ -351,12 +381,22 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>  
>  	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
>  
> +	dma_sync_single_for_device(dev, inpbusaddr,
> +					sizeof(dma_addr_t) * JOBR_DEPTH,
> +					DMA_TO_DEVICE);
> +

... these one are also unnecessary, because the buffers are mapped with
dma_alloc_coherent.

>  	smp_wmb();
>  
>  	jrp->inp_ring_write_index = (jrp->inp_ring_write_index + 1) &
>  				    (JOBR_DEPTH - 1);
>  	jrp->head = (head + 1) & (JOBR_DEPTH - 1);
>  
> +	/*
> +	 * Ensure that all job information has been written before
> +	 * notifying CAAM that a new job was added to the input ring.
> +	 */
> +	wmb();
> +
>  	wr_reg32(&jrp->rregs->inpring_jobadd, 1);
>  
>  	spin_unlock_bh(&jrp->inplock);
> diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
> index e1eaf4f..6481f71 100644
> --- a/drivers/crypto/caam/key_gen.c
> +++ b/drivers/crypto/caam/key_gen.c
> @@ -71,6 +71,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
>  	}
>  
>  	init_job_desc(desc, 0);
> +
>  	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
>  
>  	/* Sets MDHA up into an HMAC-INIT */
> @@ -111,7 +112,8 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
>  			       split_key_pad_len, 1);
>  #endif
>  	}
> -
> +	dma_sync_single_for_cpu(jrdev, dma_addr_out, split_key_pad_len,
> +				DMA_FROM_DEVICE);
>  	dma_unmap_single(jrdev, dma_addr_out, split_key_pad_len,
>  			 DMA_FROM_DEVICE);
>  out_unmap_in:

unneeded.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
