Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D4A134AD;
	Sun, 19 Nov 2023 19:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDebwZKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E537C433C7;
	Sun, 19 Nov 2023 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700423375;
	bh=Y65QvSsXHqm7VX9AgZ5BI+hkRtsvRDz99qPdNHT4aK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NDebwZKRzTY+jbu34I1hOcnskpgvZxP1VCMbL15KXFLd06R0pzFNB/x58zVKpNCuc
	 6scI15eSTKaDeIsb4QjT4GQ+w0FaPGLIk8cnW0rYrPtPgBjsGcWyucqn/asayFHZAN
	 WK8vLf40QTB+aT7pc3FK/xueJlV8ElIrEcgsaOIUH/oR5fhrri7uen9KFk2kwLwzfu
	 Tfo6cs/DnI07Dz8nNIA0SICm5u0ZFAw2cWRDnNoe2gkuaRsQe8WpirvvwzPMq0HHTU
	 p3yk/BVUI+XR4XXgvjKw+9EUm6yvVj4SkAQ+WNpST5lniVxsnzhuxolkXYJMmXsIEJ
	 Xpkcm+ne9B6/w==
Date: Sun, 19 Nov 2023 19:49:30 +0000
From: Simon Horman <horms@kernel.org>
To: Srujana Challa <schalla@marvell.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, bbrezillon@kernel.org, arno@natisbad.org,
	kuba@kernel.org, ndabilpuram@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH v1 02/10] crypto: octeontx2: add SGv2 support for CN10KB
 or CN10KA B0
Message-ID: <20231119194930.GG186930@vergenet.net>
References: <20231103053306.2259753-1-schalla@marvell.com>
 <20231103053306.2259753-3-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103053306.2259753-3-schalla@marvell.com>

On Fri, Nov 03, 2023 at 11:02:58AM +0530, Srujana Challa wrote:

Hi Srujana,

some minor feedback from my side.

> Scatter Gather input format for CPT has changed on CN10KB/CN10KA B0 HW
> to make it comapatible with NIX Scatter Gather format to support SG mode

nit: compatible

> for inline IPsec. This patch modifies the code to make the driver works
> for the same. This patch also enables CPT firmware load for these chips.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>

...

> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h

...

> +static inline int sgv2io_components_setup(struct pci_dev *pdev,
> +					  struct otx2_cpt_buf_ptr *list,
> +					  int buf_count, u8 *buffer)
> +{
> +	struct cn10kb_cpt_sglist_component *sg_ptr = NULL;
> +	int ret = 0, i, j;
> +	int components;
> +
> +	if (unlikely(!list)) {
> +		dev_err(&pdev->dev, "Input list pointer is NULL\n");
> +		return -EFAULT;
> +	}
> +
> +	for (i = 0; i < buf_count; i++) {
> +		if (unlikely(!list[i].vptr))
> +			continue;
> +		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
> +						  list[i].size,
> +						  DMA_BIDIRECTIONAL);
> +		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
> +			dev_err(&pdev->dev, "Dma mapping failed\n");
> +			ret = -EIO;
> +			goto sg_cleanup;
> +		}
> +	}
> +	components = buf_count / 3;
> +	sg_ptr = (struct cn10kb_cpt_sglist_component *)buffer;
> +	for (i = 0; i < components; i++) {
> +		sg_ptr->len0 = list[i * 3 + 0].size;
> +		sg_ptr->len1 = list[i * 3 + 1].size;
> +		sg_ptr->len2 = list[i * 3 + 2].size;
> +		sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
> +		sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
> +		sg_ptr->ptr2 = list[i * 3 + 2].dma_addr;
> +		sg_ptr->valid_segs = 3;
> +		sg_ptr++;
> +	}
> +	components = buf_count % 3;
> +
> +	sg_ptr->valid_segs = components;
> +	switch (components) {
> +	case 2:
> +		sg_ptr->len1 = list[i * 3 + 1].size;
> +		sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
> +		fallthrough;
> +	case 1:
> +		sg_ptr->len0 = list[i * 3 + 0].size;
> +		sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
> +		break;
> +	default:
> +		break;
> +	}
> +	return ret;

The above fields of sg_ptr all have big-endian types
but are being assigned values in host byte-order.

As flagged by Sparse.

> +
> +sg_cleanup:
> +	for (j = 0; j < i; j++) {
> +		if (list[j].dma_addr) {
> +			dma_unmap_single(&pdev->dev, list[j].dma_addr,
> +					 list[j].size, DMA_BIDIRECTIONAL);
> +		}
> +
> +		list[j].dma_addr = 0;
> +	}
> +	return ret;
> +}
> +
> +static inline struct otx2_cpt_inst_info *cn10k_sgv2_info_create(struct pci_dev *pdev,
> +					      struct otx2_cpt_req_info *req,
> +					      gfp_t gfp)

nit: I think it would be nicer to format the above as in a way
that indentation isn't pushed so far to the right that alignment
with the opening parentheses becomes impossible:

static inline struct otx2_cpt_inst_info *
cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
		       gfp_t gfp)

Running ./checkpatch.pl --strict over this patch-set might also be useful.

...
