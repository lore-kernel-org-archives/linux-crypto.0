From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 01/11] crypto: caam - Add cache coherency support
Date: Tue, 16 Jun 2015 11:29:04 +0800
Message-ID: <20150616032904.GA20116@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56881 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbbFPDvK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 23:51:10 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:49PM -0700, Victoria Milhoan wrote:
> Freescale i.MX6 ARM platforms do not support hardware cache coherency.  This
> patch adds cache coherency support to the CAAM driver.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>

What about caamalg.c?

> @@ -807,7 +815,7 @@ static int ahash_update_ctx(struct ahash_request *req)
>  		 * allocate space for base edesc and hw desc commands,
>  		 * link tables
>  		 */
> -		edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +
> +		edesc = kzalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN +

Please put this into a separate patch as it appears to have nothing
to do with the change description.

> @@ -351,12 +381,22 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>  
>  	jrp->inpring[jrp->inp_ring_write_index] = desc_dma;
>  
> +	dma_sync_single_for_device(dev, inpbusaddr,
> +					sizeof(dma_addr_t) * JOBR_DEPTH,
> +					DMA_TO_DEVICE);
> +
>  	smp_wmb();

While you're at it can you add a comment regarding what this
barrier is meant to protect?

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

Please remove this unrelated hunk.

> diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
> index 3b91821..6365585 100644
> --- a/drivers/crypto/caam/sg_sw_sec4.h
> +++ b/drivers/crypto/caam/sg_sw_sec4.h
> @@ -98,6 +98,7 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  	} else {
>  		dma_map_sg(dev, sg, nents, dir);
>  	}
> +
>  	return nents;

Ditto

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
