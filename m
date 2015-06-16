From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 01/11] crypto: caam - Add cache coherency support
Date: Tue, 16 Jun 2015 09:35:22 +0800
Message-ID: <20150616013522.GA18662@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51126 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbFPBf1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 21:35:27 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-2-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:49PM -0700, Victoria Milhoan wrote:
>
> @@ -177,10 +180,19 @@ static void caam_jr_dequeue(unsigned long devarg)
>  
>  		sw_idx = tail = jrp->tail;
>  		hw_idx = jrp->out_ring_read_index;
> +		dma_sync_single_for_cpu(dev, outbusaddr,
> +					sizeof(struct jr_outentry) * JOBR_DEPTH,
> +					DMA_FROM_DEVICE);
>  
>  		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
>  			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
>  
> +			/*
> +			 * Ensure that tail is read before using it as part of
> +			 * the index into the software ring.
> +			 */
> +			smp_read_barrier_depends();
> +
>  			if (jrp->outring[hw_idx].desc ==
>  			    jrp->entinfo[sw_idx].desc_addr_dma)
>  				break; /* found */

smp_read_barrier_depends should be avoided and replaced with RCU
helpers where possible.  So what you could do here is mark jrp->tail
as rcu and then use the correct RCU helper to access it which will
do the smp_rad_barrier_depends for you.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
