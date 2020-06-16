Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F3FC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 10:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B78120767
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 10:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="W15PEUWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgFPKUk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:20:40 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:46702 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgFPKUj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 06:20:39 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05GAKVZi050063;
        Tue, 16 Jun 2020 05:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592302831;
        bh=8c0BBu6lQJK8eZCExXBshGpTkinxCY9m/XfPXee6PXE=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=W15PEUWKBLHYcAd2D08XZV2zzd45pgXLY36Rdtc2xYryYmb+6k2lYYI3hqLNxmrQV
         ThsUQCRRd0OsOMn8KFsaWHYqR2CL/GYIKqEVbXNRTCwPiMIKbPYXekMuAKWMJHDhp3
         L1r75Db6fVTRfVCl6dU9x4Dga5iYlYY4rUdXW1os=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05GAKVuv030891
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 05:20:31 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 16
 Jun 2020 05:20:30 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 16 Jun 2020 05:20:30 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05GAKTTu109123;
        Tue, 16 Jun 2020 05:20:29 -0500
Subject: Re: [PATCH] crypto: omap-sham - Fix sparse/compiler warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20200615113738.GB20552@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <34a06971-71c4-eb1c-61e3-37512f75113a@ti.com>
Date:   Tue, 16 Jun 2020 13:20:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615113738.GB20552@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/06/2020 14:37, Herbert Xu wrote:
> This patch fixes sparse endianness warnings as well as compiler
> warnings on 64-bit hosts.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks okay to me.

Reviewed-by: Tero Kristo <t-kristo@ti.com>

> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 82691a057d2a..954d703f2981 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -357,10 +357,10 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
>   
>   	if (big_endian)
>   		for (i = 0; i < d; i++)
> -			hash[i] = be32_to_cpu(in[i]);
> +			hash[i] = be32_to_cpup((__be32 *)in + i);
>   	else
>   		for (i = 0; i < d; i++)
> -			hash[i] = le32_to_cpu(in[i]);
> +			hash[i] = le32_to_cpup((__le32 *)in + i);
>   }
>   
>   static int omap_sham_hw_init(struct omap_sham_dev *dd)
> @@ -522,7 +522,7 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, size_t length,
>   	int mlen;
>   	struct sg_mapping_iter mi;
>   
> -	dev_dbg(dd->dev, "xmit_cpu: digcnt: %d, length: %d, final: %d\n",
> +	dev_dbg(dd->dev, "xmit_cpu: digcnt: %zd, length: %zd, final: %d\n",
>   						ctx->digcnt, length, final);
>   
>   	dd->pdata->write_ctrl(dd, length, final, 0);
> @@ -588,7 +588,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, size_t length,
>   	struct dma_slave_config cfg;
>   	int ret;
>   
> -	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
> +	dev_dbg(dd->dev, "xmit_dma: digcnt: %zd, length: %zd, final: %d\n",
>   						ctx->digcnt, length, final);
>   
>   	if (!dma_map_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE)) {
> @@ -871,7 +871,7 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
>   		nbytes += req->nbytes - rctx->offset;
>   
>   	dev_dbg(rctx->dd->dev,
> -		"%s: nbytes=%d, bs=%d, total=%d, offset=%d, bufcnt=%d\n",
> +		"%s: nbytes=%d, bs=%d, total=%d, offset=%d, bufcnt=%zd\n",
>   		__func__, nbytes, bs, rctx->total, rctx->offset,
>   		rctx->bufcnt);
>   
> @@ -932,7 +932,7 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
>   	return 0;
>   }
>   
> -struct omap_sham_dev *omap_sham_find_dev(struct omap_sham_reqctx *ctx)
> +static struct omap_sham_dev *omap_sham_find_dev(struct omap_sham_reqctx *ctx)
>   {
>   	struct omap_sham_dev *dd;
>   
> @@ -1023,7 +1023,7 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
>   	bool final = (ctx->flags & BIT(FLAGS_FINUP)) &&
>   			!(dd->flags & BIT(FLAGS_HUGE));
>   
> -	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %d, final: %d",
> +	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %zd, final: %d",
>   		ctx->total, ctx->digcnt, final);
>   
>   	if (ctx->total < get_block_size(ctx) ||
> @@ -1036,7 +1036,7 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
>   		err = omap_sham_xmit_dma(dd, ctx->total, final);
>   
>   	/* wait for dma completion before can take more data */
> -	dev_dbg(dd->dev, "update: err: %d, digcnt: %d\n", err, ctx->digcnt);
> +	dev_dbg(dd->dev, "update: err: %d, digcnt: %zd\n", err, ctx->digcnt);
>   
>   	return err;
>   }
> @@ -1097,7 +1097,7 @@ static int omap_sham_finish(struct ahash_request *req)
>   			err = omap_sham_finish_hmac(req);
>   	}
>   
> -	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
> +	dev_dbg(dd->dev, "digcnt: %zd, bufcnt: %zd\n", ctx->digcnt, ctx->bufcnt);
>   
>   	return err;
>   }
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
