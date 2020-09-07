Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B43C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 06:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB16E21556
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 06:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cpwhUVZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIGGf4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 02:35:56 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:53866 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgIGGfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 02:35:55 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0876ZjMt118602;
        Mon, 7 Sep 2020 01:35:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599460545;
        bh=+E0Bz8oYaz6TxpzyyA62p7uL4mx1t7E2TXkzLrwOgC8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=cpwhUVZa2Tm2elPjviWr2Ld57O7j60y7R9nbHKH2Nc5lXPUa5mxGH18q/PeXFnAtd
         xZireRZyA2u/aIN6d66Qlog5KrvT55PqHdDHrZW8zEz103XSZZTgdH4dvG1r56w8uw
         gsjLHKYS1DgqhbFZ/LXYcbc+WfW0qkPUjfZfRBCY=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0876ZjEi006543
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 01:35:45 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 01:35:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 01:35:44 -0500
Received: from [10.250.160.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0876ZdfB022001;
        Mon, 7 Sep 2020 01:35:41 -0500
Subject: Re: [PATCH] crypto: sa2ul - Select CRYPTO_AUTHENC
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
CC:     <kbuild-all@lists.01.org>, <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <202009071150.Sk8aGITA%lkp@intel.com>
 <20200907045857.GA11307@gondor.apana.org.au>
 <20200907062240.GA15899@gondor.apana.org.au>
From:   "J, KEERTHY" <j-keerthy@ti.com>
Message-ID: <e839b3fb-19c8-51fd-cbb6-fbd14d9c2488@ti.com>
Date:   Mon, 7 Sep 2020 12:05:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907062240.GA15899@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 9/7/2020 11:52 AM, Herbert Xu wrote:
> Resend with new subject.

Thanks Herbert.

Reviewed-by: Keerthy <j-keerthy@ti.com>

>   
> ---8<---
> The sa2ul driver uses crypto_authenc_extractkeys and therefore
> must select CRYPTO_AUTHENC.
> 
> Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index aa3a4ed07a66..c2950127def6 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -873,6 +873,7 @@ config CRYPTO_DEV_SA2UL
>   	select CRYPTO_AES
>   	select CRYPTO_AES_ARM64
>   	select CRYPTO_ALGAPI
> +	select CRYPTO_AUTHENC
>   	select HW_RANDOM
>   	select SG_SPLIT
>   	help
> 
