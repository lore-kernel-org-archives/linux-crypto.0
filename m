From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC 05/11] crypto: caam - Add cache coherency support to
 Freescale CAAM scatterlist implementation
Date: Wed, 17 Jun 2015 09:44:09 +0200
Message-ID: <20150617074409.GL7947@pengutronix.de>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-6-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551AbbFQHoK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 03:44:10 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-6-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:53PM -0700, Victoria Milhoan wrote:
> Add cache coherency support to the CAAM scatterlist implementation.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> ---
>  drivers/crypto/caam/sg_sw_sec4.h | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
> index 6365585..6730b01 100644
> --- a/drivers/crypto/caam/sg_sw_sec4.h
> +++ b/drivers/crypto/caam/sg_sw_sec4.h
> @@ -91,9 +91,14 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  {
>  	if (unlikely(chained)) {
>  		int i;
> +	struct scatterlist *tsg = sg;
> +
> +	/* We use a local copy of the sg pointer to avoid moving the
> +	 * head of the list pointed to by sg as we wall the list.
> +	 */
>  		for (i = 0; i < nents; i++) {
> -			dma_map_sg(dev, sg, 1, dir);
> -			sg = sg_next(sg);
> +			dma_map_sg(dev, tsg, 1, dir);
> +			tsg = scatterwalk_sg_next(tsg);
>  		}
>  	} else {
>  		dma_map_sg(dev, sg, nents, dir);
> @@ -106,6 +111,9 @@ static int dma_unmap_sg_chained(struct device *dev, struct scatterlist *sg,
>  				unsigned int nents, enum dma_data_direction dir,
>  				bool chained)
>  {
> +	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
> +		dma_sync_sg_for_cpu(dev, sg, nents, dir);
> +
>  	if (unlikely(chained)) {
>  		int i;
>  		for (i = 0; i < nents; i++) {

You don't need to sync here, because you unmap it directly afterwards.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
