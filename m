From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/3] crypto: talitos - Add ablkcipher algorithms
Date: Tue, 24 Mar 2009 18:57:50 -0500
Message-ID: <20090324185750.22ef71a8.kim.phillips@freescale.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:54935 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbZCXXjX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 19:39:23 -0400
In-Reply-To: <1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 15 Mar 2009 20:21:49 -0500
Lee Nipper <lee.nipper@gmail.com> wrote:

> Add these ablkcipher algorithms:
> cbc(aes),
> cbc(des3_ede).
> 
> ipsec_esp_edesc is renamed to talitos_edesc
> to use it in ablkcipher routines.

erm...actually that shows up in the prior patch (1/3) :).

> +	if (sg_count == 1) {
> +		desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
> +	} else {
> +		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
> +					  &edesc->link_tbl[0]);
> +		if (sg_count > 1) {
> +			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
> +			desc->ptr[3].ptr = cpu_to_be32(edesc->dma_link_tbl);
> +			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
> +						   edesc->dma_len, DMA_BIDIRECTIONAL);
> +		} else {
> +			/* Only one segment now, so no link tbl needed */
> +			desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
> +		}
> +	}

can we change this to something like:

if (sg_count > 1 && sg_to_link_tbl(areq->src, sg_count, cryptlen,
				   &edesc->link_tbl[0] > 1) {
	desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
	desc->ptr[3].ptr = cpu_to_be32(edesc->dma_link_tbl);
	dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
				   edesc->dma_len, DMA_BIDIRECTIONAL);
} else {
	/* Only one segment, no link tbl needed */
	desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
}

for readability's sake?

> +
> +	/* cipher out */
> +	desc->ptr[4].len = cpu_to_be16(cryptlen);
> +	desc->ptr[4].j_extent = 0;
> +
> +	if (areq->src != areq->dst) {
> +		sg_count = talitos_map_sg(dev, areq->dst,
> +					  edesc->dst_nents ? : 1,
> +					  DMA_FROM_DEVICE,
> +					  edesc->dst_is_chained);
> +	}

braces not necessary

> +	/* iv out */
> +	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv, 0,
> +			       DMA_FROM_DEVICE);

it seems that the device's IV output is not being used anywhere, and
ablkciphers don't have givencrypt's, so this should be safe to remove.

> @@ -1641,6 +1950,14 @@ static int talitos_probe(struct of_device *ofdev,
>  		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
>  			struct talitos_crypto_alg *t_alg;
>  
> +			/* For testing, we can omit the AEAD algorithms
> +			 * and use the ABLKCIPHER algorithms for IPsec.
> +			 */
> +			if (testablkcipher &&
> +			    ((driver_algs[i].alg.cra_flags & CRYPTO_ALG_TYPE_MASK)
> +					== CRYPTO_ALG_TYPE_AEAD))
> +				continue;
> +

I'd rather let aead tests continue to fail until they get their own
tests; it'll serve as a good reminder to get around to it one day.

Thanks,

Kim
