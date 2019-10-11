Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9906BECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 11:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780B9214E0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 11:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfJKLZL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 07:25:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3737 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727549AbfJKLZL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 07:25:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 15C2DD8D4BD010629DE2;
        Fri, 11 Oct 2019 19:25:10 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 19:25:08 +0800
Subject: Re: [PATCH 1/2] crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm
 Kconfig
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <1570792690-74597-1-git-send-email-wangzhou1@hisilicon.com>
CC:     <linux-crypto@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DA06693.3020901@hisilicon.com>
Date:   Fri, 11 Oct 2019 19:25:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1570792690-74597-1-git-send-email-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/11 19:18, Zhou Wang wrote:
> To avoid compile error in some platforms, select NEED_SG_DMA_LENGTH in
> qm Kconfig.
> 
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Reported-by: kbuild test robot <lkp@intel.com>

sorry to make the head of this patch as 1/2, it should be "PATCH", there
is only one patch.

> ---
>  drivers/crypto/hisilicon/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index 82fb810d..a71f2bf 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -18,6 +18,7 @@ config CRYPTO_DEV_HISI_QM
>  	tristate
>  	depends on ARM64 || COMPILE_TEST
>  	depends on PCI && PCI_MSI
> +	select NEED_SG_DMA_LENGTH
>  	help
>  	  HiSilicon accelerator engines use a common queue management
>  	  interface. Specific engine driver may use this module.
> 



