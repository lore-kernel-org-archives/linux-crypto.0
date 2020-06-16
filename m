Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2DAC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 10:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D8F2074D
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 10:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="JHgdgqDb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgFPKVe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:21:34 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:34122 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFPKVe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 06:21:34 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05GALUwM031045;
        Tue, 16 Jun 2020 05:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592302890;
        bh=zo3Ue3rSGUn6jGlsa5vPrFHoLBq6KIxudd5yOoGomzQ=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=JHgdgqDbS+ESkCI8yD2jNTxqFthw864WTiNq3SRL5FLA86hD6iMr09F8/Q/FX4aXB
         1GTbYaYbzUrtyk5gLLqiJHLStx2NdEjVuMlMdtNsWFFluPtWegIruKEzLAEcswxPq8
         lBVcF0oXfSCeNOAJ6oZjF7JtHjPHihRBOWYvemEo=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05GALTdt058099
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 05:21:29 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 16
 Jun 2020 05:21:29 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 16 Jun 2020 05:21:29 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05GALSDR071299;
        Tue, 16 Jun 2020 05:21:28 -0500
Subject: Re: [PATCH] crypto: omap-des - Fix sparse/compiler warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20200615113620.GA20552@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <f6efc4a8-2239-e977-3db6-15f6f91718a5@ti.com>
Date:   Tue, 16 Jun 2020 13:21:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615113620.GA20552@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 15/06/2020 14:36, Herbert Xu wrote:
> This patch fixes sparse endianness warnings as well as compiler
> warnings on 64-bit hosts.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks fine to me:

Reviewed-by: Tero Kristo <t-kristo@ti.com>

> 
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index 8eda43319204..c9d38bcfd1c7 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -87,7 +87,7 @@ struct omap_des_ctx {
>   	struct omap_des_dev *dd;
>   
>   	int		keylen;
> -	u32		key[(3 * DES_KEY_SIZE) / sizeof(u32)];
> +	__le32		key[(3 * DES_KEY_SIZE) / sizeof(u32)];
>   	unsigned long	flags;
>   };
>   
> @@ -461,7 +461,7 @@ static int omap_des_crypt_dma_start(struct omap_des_dev *dd)
>   					crypto_skcipher_reqtfm(dd->req));
>   	int err;
>   
> -	pr_debug("total: %d\n", dd->total);
> +	pr_debug("total: %zd\n", dd->total);
>   
>   	if (!dd->pio_only) {
>   		err = dma_map_sg(dd->dev, dd->in_sg, dd->in_sg_len,
> @@ -504,7 +504,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
>   
>   static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
>   {
> -	pr_debug("total: %d\n", dd->total);
> +	pr_debug("total: %zd\n", dd->total);
>   
>   	omap_des_dma_stop(dd);
>   
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
