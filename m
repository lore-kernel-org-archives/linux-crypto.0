Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E0FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Mar 2021 02:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D072B61A1E
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Mar 2021 02:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhCYCH6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:07:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13684 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhCYCHk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Mar 2021 22:07:40 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F5T2V02q3znTV4;
        Thu, 25 Mar 2021 10:05:06 +0800 (CST)
Received: from [10.67.101.248] (10.67.101.248) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 10:07:28 +0800
Subject: Re: [PATCH -next] crypto: hisilicon/hpre - fix build error without
 CONFIG_CRYPTO_ECDH
To:     'Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Weili Qian <qianweili@huawei.com>,
        Meng Yu <yumeng18@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shukun Tan <tanshukun1@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20210324144239.997757-1-weiyongjun1@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
From:   tanghui20 <tanghui20@huawei.com>
Message-ID: <72f92d6b-8584-0891-827c-7f50311418dc@huawei.com>
Date:   Thu, 25 Mar 2021 10:07:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210324144239.997757-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thinks, there is a similar patch to yours that was send in advance:
https://www.spinics.net/lists/linux-crypto/msg54238.html

On 2021/3/24 22:42, 'Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> GCC reports build error as following:
>
> x86_64-linux-gnu-ld: drivers/crypto/hisilicon/hpre/hpre_crypto.o: in function `hpre_ecdh_set_secret':
> hpre_crypto.c:(.text+0x269c): undefined reference to `crypto_ecdh_decode_key'
>
> Fix it by selecting CRYPTO_ECDH.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/hisilicon/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index c45adb15ce8d..bb327d6e365a 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -69,6 +69,7 @@ config CRYPTO_DEV_HISI_HPRE
>  	select CRYPTO_DEV_HISI_QM
>  	select CRYPTO_DH
>  	select CRYPTO_RSA
> +	select CRYPTO_ECDH
>  	help
>  	  Support for HiSilicon HPRE(High Performance RSA Engine)
>  	  accelerator, which can accelerate RSA and DH algorithms.
>
> .
>
