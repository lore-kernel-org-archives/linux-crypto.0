Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445E2C11F64
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2D361406
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jul 2021 19:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhGAUBp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jul 2021 16:01:45 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:50622 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGAUBo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jul 2021 16:01:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1942460A59C3;
        Thu,  1 Jul 2021 21:59:13 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FoQFlT8xppKX; Thu,  1 Jul 2021 21:59:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 805066108478;
        Thu,  1 Jul 2021 21:59:12 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f_EY7arTg1CS; Thu,  1 Jul 2021 21:59:12 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 633BC610846D;
        Thu,  1 Jul 2021 21:59:12 +0200 (CEST)
Date:   Thu, 1 Jul 2021 21:59:12 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>
Message-ID: <668688914.13281.1625169552349.JavaMail.zimbra@nod.at>
In-Reply-To: <20210701185638.3437487-2-sean.anderson@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com> <20210701185638.3437487-2-sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] crypto: mxs-dcp: Check for DMA mapping errors
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: mxs-dcp: Check for DMA mapping errors
Thread-Index: Frt7LHYmwPo69SYeE5SlEF4En5NW4w==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Sean Anderson" <sean.anderson@seco.com>
> An: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "davem"
> <davem@davemloft.net>
> CC: "horia geanta" <horia.geanta@nxp.com>, "aymen sghaier" <aymen.sghaier@nxp.com>, "richard" <richard@nod.at>,
> "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>, "Marek Vasut" <marex@denx.de>, "Sean Anderson"
> <sean.anderson@seco.com>
> Gesendet: Donnerstag, 1. Juli 2021 20:56:37
> Betreff: [PATCH v2 1/2] crypto: mxs-dcp: Check for DMA mapping errors

> After calling dma_map_single(), we must also call dma_mapping_error().
> This fixes the following warning when compiling with CONFIG_DMA_API_DEBUG:
> 
> [  311.241478] WARNING: CPU: 0 PID: 428 at kernel/dma/debug.c:1027
> check_unmap+0x79c/0x96c
> [  311.249547] DMA-API: mxs-dcp 2280000.crypto: device driver failed to check
> map error[device address=0x00000000860cb080] [size=32 bytes] [mapped as single]
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> (no changes since v1)
> 
> drivers/crypto/mxs-dcp.c | 45 +++++++++++++++++++++++++++++++---------
> 1 file changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index d6a7784d2988..f397cc5bf102 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -170,15 +170,19 @@ static struct dcp *global_sdcp;
> 
> static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
> {
> +	int dma_err;
> 	struct dcp *sdcp = global_sdcp;
> 	const int chan = actx->chan;
> 	uint32_t stat;
> 	unsigned long ret;
> 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
> -
> 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
> 					      DMA_TO_DEVICE);
> 
> +	dma_err = dma_mapping_error(sdcp->dev, desc_phys);
> +	if (dma_err)
> +		return dma_err;
> +

Minor nit, you don't need to propagate the return code from dma_mapping_error().
It just returns 0 for success and -ENOMEM on failure.
So treating it as boolean function is fine, IMHO and keeps the code simpler.
But it is a matter of taste. :-)

> 	reinit_completion(&sdcp->completion[chan]);
> 
> 	/* Clear status register. */
> @@ -216,18 +220,29 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
> static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
> 			   struct skcipher_request *req, int init)
> {
> +	dma_addr_t key_phys, src_phys, dst_phys;
> 	struct dcp *sdcp = global_sdcp;
> 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
> 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
> 	int ret;
> 
> -	dma_addr_t key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
> -					     2 * AES_KEYSIZE_128,
> -					     DMA_TO_DEVICE);
> -	dma_addr_t src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
> -					     DCP_BUF_SZ, DMA_TO_DEVICE);
> -	dma_addr_t dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
> -					     DCP_BUF_SZ, DMA_FROM_DEVICE);
> +	key_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_key,
> +				  2 * AES_KEYSIZE_128, DMA_TO_DEVICE);
> +	ret = dma_mapping_error(sdcp->dev, key_phys);
> +	if (ret)
> +		return ret;
> +
> +	src_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
> +				  DCP_BUF_SZ, DMA_TO_DEVICE);
> +	ret = dma_mapping_error(sdcp->dev, src_phys);
> +	if (ret)
> +		goto err_src;
> +
> +	dst_phys = dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
> +				  DCP_BUF_SZ, DMA_FROM_DEVICE);
> +	ret = dma_mapping_error(sdcp->dev, dst_phys);
> +	if (ret)
> +		goto err_dst;
> 
> 	if (actx->fill % AES_BLOCK_SIZE) {
> 		dev_err(sdcp->dev, "Invalid block size!\n");
> @@ -265,10 +280,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
> 	ret = mxs_dcp_start_dma(actx);
> 
> aes_done_run:
> +	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
> +err_dst:
> +	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
> +err_src:
> 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
> 			 DMA_TO_DEVICE);
> -	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
> -	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
> 
> 	return ret;
> }
> @@ -557,6 +574,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
> 	dma_addr_t buf_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
> 					     DCP_BUF_SZ, DMA_TO_DEVICE);
> 
> +	ret = dma_mapping_error(sdcp->dev, buf_phys);
> +	if (ret)
> +		return ret;
> +
> 	/* Fill in the DMA descriptor. */
> 	desc->control0 = MXS_DCP_CONTROL0_DECR_SEMAPHORE |
> 		    MXS_DCP_CONTROL0_INTERRUPT |
> @@ -589,6 +610,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
> 	if (rctx->fini) {
> 		digest_phys = dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
> 					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
> +		ret = dma_mapping_error(sdcp->dev, digest_phys);
> +		if (ret)
> +			goto done_run;
> +
> 		desc->control0 |= MXS_DCP_CONTROL0_HASH_TERM;
> 		desc->payload = digest_phys;
> 	}

Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
