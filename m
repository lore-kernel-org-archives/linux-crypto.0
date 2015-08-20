From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v1 3/4] Crypto: Add support for APM X-Gene SoC CRC32C h/w
 accelerator driver
Date: Thu, 20 Aug 2015 11:18:28 +0530
Message-ID: <20150820054828.GY13546@localhost>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
 <1438258268-3099-4-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.j.williams@intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Rameshwar Prasad Sahu <rsahu@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:46008 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbbHTFqX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 01:46:23 -0400
Content-Disposition: inline
In-Reply-To: <1438258268-3099-4-git-send-email-rsahu@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 30, 2015 at 05:41:07PM +0530, Rameshwar Prasad Sahu wrote:
> +	nents = sg_nents(req->src);
> +	sg_count = dma_map_sg(dev, req->src, nents, DMA_TO_DEVICE);
> +	if (!sg_count) {
> +		dev_err(dev, "Failed to map src sg");
> +		return -ENOMEM;
mapping error shouldn't be no mem error

> +	}
> +
> +	if (sg_count > XGENE_DMA_MAX_FLYBY_SRC_CNT) {
> +		dev_err(dev, "Unsupported src sg len\n");
would be worth printing length

> +		goto err;
> +	}
> +
> +	flags = DMA_CTRL_ACK;
why ACK?

> +
> +	tx = dchan->device->device_prep_dma_crc32c(dchan, req->src,
> +						   req->nbytes,
> +						   reqctx->seed,
> +						   req->result,
> +						   flags);
We should add helper for this

-- 
~Vinod
