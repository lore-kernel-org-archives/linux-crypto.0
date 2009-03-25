From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 3/3] crypto: talitos - Add ahash algorithms (1st cut,
 digest only)
Date: Tue, 24 Mar 2009 19:11:14 -0500
Message-ID: <20090324191114.203adeae.kim.phillips@freescale.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-4-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:56620 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbZCXXwr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 19:52:47 -0400
In-Reply-To: <1237166510-7312-4-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 15 Mar 2009 20:21:50 -0500
Lee Nipper <lee.nipper@gmail.com> wrote:

> +	/* first DWORD empty */
> +	desc->ptr[0].len = 0;
> +	desc->ptr[0].ptr = 0;
> +	desc->ptr[0].j_extent = 0;
> +
> +	/* second DWORD empty */
> +	desc->ptr[1].len = 0;
> +	desc->ptr[1].ptr = 0;
> +	desc->ptr[1].j_extent = 0;
> +
> +	/* cipher key */
> +	if (ctx->keylen)
> +		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
> +				       (char *)&ctx->key, 0, DMA_TO_DEVICE);
> +	else {
> +		desc->ptr[2].len = 0;
> +		desc->ptr[2].ptr = 0;
> +		desc->ptr[2].j_extent = 0;
> +	}

just

map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
		       (char *)&ctx->key, 0, DMA_TO_DEVICE);

should do since theoretically the device should ignore pointer entries
with len == 0 and j_extent == 0 (unless you have observed otherwise
practically).

> +	if (sg_count == 1) {
> +		desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
> +	} else {
> +		sg_count = sg_to_link_tbl(areq->src, sg_count, length,
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

same readability comment as in prior patch.

> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 575981f..85deb0a 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -162,6 +162,8 @@
>  #define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
>  #define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
>  #define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
> +#define	DESC_HDR_MODE0_MDEU_SHA384	cpu_to_be32(0x00000000) /*MDEUB*/
> +#define	DESC_HDR_MODE0_MDEU_SHA512	cpu_to_be32(0x00200000) /*MDEUB*/
>  #define	DESC_HDR_MODE0_MDEU_MD5_HMAC	(DESC_HDR_MODE0_MDEU_MD5 | \
>  					 DESC_HDR_MODE0_MDEU_HMAC)
>  #define	DESC_HDR_MODE0_MDEU_SHA256_HMAC	(DESC_HDR_MODE0_MDEU_SHA256 | \
> @@ -183,6 +185,9 @@
>  #define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
>  #define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
>  #define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
> +#define	DESC_HDR_MODE1_MDEU_SHA384	cpu_to_be32(0x00000000) /*MDEUB*/
> +#define	DESC_HDR_MODE1_MDEU_SHA512	cpu_to_be32(0x00000200) /*MDEUB*/

DESC_HDR_MODE0_MDEUB_SHA384 instead of having the comment?

Kim
