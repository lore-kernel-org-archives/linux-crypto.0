Return-Path: <SRS0=TSvm=5P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E076C43331
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Mar 2020 13:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1209E20771
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Mar 2020 13:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgC3Ngg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Mar 2020 09:36:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726497AbgC3Ngg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Mar 2020 09:36:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4EA718E6AE31056C26F6;
        Mon, 30 Mar 2020 21:36:19 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 21:36:10 +0800
Subject: Re: [PATCH -next] crypto: hisilicon - Fix build error
To:     YueHaibing <yuehaibing@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Jonathan.Cameron@huawei.com>,
        <xuzaibo@huawei.com>, <shiju.jose@huawei.com>,
        <ebiggers@google.com>, <yaohongbo@huawei.com>,
        <maowenan@huawei.com>, <arnd@arndb.de>
References: <20200330083643.28824-1-yuehaibing@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5E81F5CA.9040808@hisilicon.com>
Date:   Mon, 30 Mar 2020 21:36:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200330083643.28824-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/3/30 16:36, YueHaibing wrote:
> When UACCE is m, CRYPTO_DEV_HISI_QM cannot be built-in.
> But CRYPTO_DEV_HISI_QM is selected by CRYPTO_DEV_HISI_SEC2
> and CRYPTO_DEV_HISI_HPRE unconditionally, which may leads this:
> 
> drivers/crypto/hisilicon/qm.o: In function 'qm_alloc_uacce':
> drivers/crypto/hisilicon/qm.c:1579: undefined reference to 'uacce_alloc'
> 
> Add Kconfig dependency to enforce usable configurations.
> 
> Fixes: 47c16b449921 ("crypto: hisilicon - qm depends on UACCE")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Forgot to do the same thing like ZIP. Thanks for fixing this :)
so Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>

Best,
Zhou

> ---
>  drivers/crypto/hisilicon/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 095850d01dcc..f09c6cf7823e 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -27,6 +27,7 @@ config CRYPTO_DEV_HISI_SEC2
>  	select CRYPTO_SHA256
>  	select CRYPTO_SHA512
>  	depends on PCI && PCI_MSI
> +	depends on UACCE || UACCE=n
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>  	help
>  	  Support for HiSilicon SEC Engine of version 2 in crypto subsystem.
> @@ -58,6 +59,7 @@ config CRYPTO_DEV_HISI_ZIP
>  config CRYPTO_DEV_HISI_HPRE
>  	tristate "Support for HISI HPRE accelerator"
>  	depends on PCI && PCI_MSI
> +	depends on UACCE || UACCE=n
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>  	select CRYPTO_DEV_HISI_QM
>  	select CRYPTO_DH
> 

