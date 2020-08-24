Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF41C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 12:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A4420706
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 12:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cwLZuqZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgHXMbf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 08:31:35 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43268 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgHXMbP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 08:31:15 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07OCUn1t118442;
        Mon, 24 Aug 2020 07:30:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598272249;
        bh=G3jOmFrbP+uzsfmTSwT9TZt+0Q5hxGsSRu0ozTBuKDk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=cwLZuqZdt87F6idavqlp30iryIo+x6eGLV3rhpvd4p24uwfOdBQ2XLArz5q/PkOTF
         ycRO8fClqfaRjz5d1VH1LwbNdOkcwEg2lbp8LhIaC9wJUczJQ4H97pcQk1XnIyD75y
         rq8CZ0BqaFZaiOPvxRhq3XoPXpLlWLovOsyvHU2c=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07OCUn5r018916
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 07:30:49 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 24
 Aug 2020 07:30:48 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 24 Aug 2020 07:30:48 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OCUkiC032893;
        Mon, 24 Aug 2020 07:30:47 -0500
Subject: Re: [PATCHv6 2/7] crypto: sa2ul: Add crypto driver
To:     Nathan Chancellor <natechancellor@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <j-keerthy@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>
References: <20200713083427.30117-1-t-kristo@ti.com>
 <20200713083427.30117-3-t-kristo@ti.com>
 <20200821221729.GA204847@ubuntu-n2-xlarge-x86>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <4edf3f40-c0fe-b964-dd38-b38c0539ab34@ti.com>
Date:   Mon, 24 Aug 2020 15:30:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821221729.GA204847@ubuntu-n2-xlarge-x86>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/08/2020 01:17, Nathan Chancellor wrote:
> On Mon, Jul 13, 2020 at 11:34:22AM +0300, Tero Kristo wrote:
>> From: Keerthy <j-keerthy@ti.com>
>>
>> Adds a basic crypto driver and currently supports AES/3DES
>> in cbc mode for both encryption and decryption.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> [t-kristo@ti.com: major re-work to fix various bugs in the driver and to
>>   cleanup the code]
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> ---
>>   drivers/crypto/Kconfig  |   14 +
>>   drivers/crypto/Makefile |    1 +
>>   drivers/crypto/sa2ul.c  | 1388 +++++++++++++++++++++++++++++++++++++++
>>   drivers/crypto/sa2ul.h  |  380 +++++++++++
>>   4 files changed, 1783 insertions(+)
>>   create mode 100644 drivers/crypto/sa2ul.c
>>   create mode 100644 drivers/crypto/sa2ul.h
> 
> <snip>
> 
>> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
>> new file mode 100644
>> index 000000000000..860c7435fefa
>> --- /dev/null
>> +++ b/drivers/crypto/sa2ul.c
>> @@ -0,0 +1,1388 @@
> 
> <snip>
> 
>> +static int sa_run(struct sa_req *req)
>> +{
>> +	struct sa_rx_data *rxd;
>> +	gfp_t gfp_flags;
>> +	u32 cmdl[SA_MAX_CMDL_WORDS];
>> +	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
>> +	struct device *ddev;
>> +	struct dma_chan *dma_rx;
>> +	int sg_nents, src_nents, dst_nents;
>> +	int mapped_src_nents, mapped_dst_nents;
>> +	struct scatterlist *src, *dst;
>> +	size_t pl, ml, split_size;
>> +	struct sa_ctx_info *sa_ctx = req->enc ? &req->ctx->enc : &req->ctx->dec;
>> +	int ret;
>> +	struct dma_async_tx_descriptor *tx_out;
>> +	u32 *mdptr;
>> +	bool diff_dst;
>> +	enum dma_data_direction dir_src;
>> +
>> +	gfp_flags = req->base->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
>> +		GFP_KERNEL : GFP_ATOMIC;
>> +
>> +	rxd = kzalloc(sizeof(*rxd), gfp_flags);
>> +	if (!rxd)
>> +		return -ENOMEM;
>> +
>> +	if (req->src != req->dst) {
>> +		diff_dst = true;
>> +		dir_src = DMA_TO_DEVICE;
>> +	} else {
>> +		diff_dst = false;
>> +		dir_src = DMA_BIDIRECTIONAL;
>> +	}
>> +
>> +	/*
>> +	 * SA2UL has an interesting feature where the receive DMA channel
>> +	 * is selected based on the data passed to the engine. Within the
>> +	 * transition range, there is also a space where it is impossible
>> +	 * to determine where the data will end up, and this should be
>> +	 * avoided. This will be handled by the SW fallback mechanism by
>> +	 * the individual algorithm implementations.
>> +	 */
>> +	if (req->size >= 256)
>> +		dma_rx = pdata->dma_rx2;
>> +	else
>> +		dma_rx = pdata->dma_rx1;
>> +
>> +	ddev = dma_rx->device->dev;
>> +
>> +	memcpy(cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
>> +
>> +	sa_update_cmdl(req, cmdl, &sa_ctx->cmdl_upd_info);
>> +
>> +	if (req->type != CRYPTO_ALG_TYPE_AHASH) {
>> +		if (req->enc)
>> +			req->type |=
>> +				(SA_REQ_SUBTYPE_ENC << SA_REQ_SUBTYPE_SHIFT);
>> +		else
>> +			req->type |=
>> +				(SA_REQ_SUBTYPE_DEC << SA_REQ_SUBTYPE_SHIFT);
>> +	}
>> +
>> +	cmdl[sa_ctx->cmdl_size / sizeof(u32)] = req->type;
>> +
>> +	/*
>> +	 * Map the packets, first we check if the data fits into a single
>> +	 * sg entry and use that if possible. If it does not fit, we check
>> +	 * if we need to do sg_split to align the scatterlist data on the
>> +	 * actual data size being processed by the crypto engine.
>> +	 */
>> +	src = req->src;
>> +	sg_nents = sg_nents_for_len(src, req->size);
>> +
>> +	split_size = req->size;
>> +
>> +	if (sg_nents == 1 && split_size <= req->src->length) {
>> +		src = &rxd->rx_sg;
>> +		sg_init_table(src, 1);
>> +		sg_set_page(src, sg_page(req->src), split_size,
>> +			    req->src->offset);
>> +		src_nents = 1;
>> +		dma_map_sg(ddev, src, sg_nents, dir_src);
>> +	} else {
>> +		mapped_src_nents = dma_map_sg(ddev, req->src, sg_nents,
>> +					      dir_src);
>> +		ret = sg_split(req->src, mapped_src_nents, 0, 1, &split_size,
>> +			       &src, &src_nents, gfp_flags);
>> +		if (ret) {
>> +			src_nents = sg_nents;
>> +			src = req->src;
>> +		} else {
>> +			rxd->split_src_sg = src;
>> +		}
>> +	}
>> +
>> +	if (!diff_dst) {
>> +		dst_nents = src_nents;
>> +		dst = src;
>> +	} else {
>> +		dst_nents = sg_nents_for_len(req->dst, req->size);
>> +
>> +		if (dst_nents == 1 && split_size <= req->dst->length) {
>> +			dst = &rxd->tx_sg;
>> +			sg_init_table(dst, 1);
>> +			sg_set_page(dst, sg_page(req->dst), split_size,
>> +				    req->dst->offset);
>> +			dst_nents = 1;
>> +			dma_map_sg(ddev, dst, dst_nents, DMA_FROM_DEVICE);
>> +		} else {
>> +			mapped_dst_nents = dma_map_sg(ddev, req->dst, dst_nents,
>> +						      DMA_FROM_DEVICE);
>> +			ret = sg_split(req->dst, mapped_dst_nents, 0, 1,
>> +				       &split_size, &dst, &dst_nents,
>> +				       gfp_flags);
>> +			if (ret) {
>> +				dst_nents = dst_nents;
> 
> This causes a clang warning:
> 
> drivers/crypto/sa2ul.c:1152:15: warning: explicitly assigning value of
> variable of type 'int' to itself [-Wself-assign]
>                                  dst_nents = dst_nents;
>                                  ~~~~~~~~~ ^ ~~~~~~~~~
> 1 warning generated.
> 
> Was the right side supposed to be something else? Otherwise, this line
> can be removed, right?

This is definitely a bug in the code, thanks for catching. I'll check 
what this was actually supposed to be and fix... Too many iterations of 
the code behind.

-Tero

> 
>> +				dst = req->dst;
>> +			} else {
>> +				rxd->split_dst_sg = dst;
>> +			}
>> +		}
>> +	}
>> +
>> +	if (unlikely(src_nents != sg_nents)) {
>> +		dev_warn_ratelimited(sa_k3_dev, "failed to map tx pkt\n");
>> +		ret = -EIO;
>> +		goto err_cleanup;
>> +	}
>> +
>> +	rxd->tx_in = dmaengine_prep_slave_sg(dma_rx, dst, dst_nents,
>> +					     DMA_DEV_TO_MEM,
>> +					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>> +	if (!rxd->tx_in) {
>> +		dev_err(pdata->dev, "IN prep_slave_sg() failed\n");
>> +		ret = -EINVAL;
>> +		goto err_cleanup;
>> +	}
>> +
>> +	rxd->req = (void *)req->base;
>> +	rxd->enc = req->enc;
>> +	rxd->ddev = ddev;
>> +	rxd->src = src;
>> +	rxd->dst = dst;
>> +	rxd->iv_idx = req->ctx->iv_idx;
>> +	rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
>> +	rxd->tx_in->callback = req->callback;
>> +	rxd->tx_in->callback_param = rxd;
>> +
>> +	tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, src,
>> +					 src_nents, DMA_MEM_TO_DEV,
>> +					 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>> +
>> +	if (!tx_out) {
>> +		dev_err(pdata->dev, "OUT prep_slave_sg() failed\n");
>> +		ret = -EINVAL;
>> +		goto err_cleanup;
>> +	}
>> +
>> +	/*
>> +	 * Prepare metadata for DMA engine. This essentially describes the
>> +	 * crypto algorithm to be used, data sizes, different keys etc.
>> +	 */
>> +	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
>> +
>> +	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
>> +				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
>> +			   sa_ctx->epib);
>> +
>> +	ml = sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS * sizeof(u32));
>> +	dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
>> +
>> +	dmaengine_submit(tx_out);
>> +	dmaengine_submit(rxd->tx_in);
>> +
>> +	dma_async_issue_pending(dma_rx);
>> +	dma_async_issue_pending(pdata->dma_tx);
>> +
>> +	return -EINPROGRESS;
>> +
>> +err_cleanup:
>> +	dma_unmap_sg(ddev, req->src, sg_nents, DMA_TO_DEVICE);
>> +	kfree(rxd->split_src_sg);
>> +
>> +	if (req->src != req->dst) {
>> +		dst_nents = sg_nents_for_len(req->dst, req->size);
>> +		dma_unmap_sg(ddev, req->dst, dst_nents, DMA_FROM_DEVICE);
>> +		kfree(rxd->split_dst_sg);
>> +	}
>> +
>> +	kfree(rxd);
>> +
>> +	return ret;
>> +}
> 
> Cheers,
> Nathan
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
