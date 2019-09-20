Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8526FC4CEC9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 08:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5142E2086A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 08:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405197AbfITIdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 04:33:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404945AbfITIdu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 04:33:50 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 526151DA269D57266B53;
        Fri, 20 Sep 2019 16:33:48 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 16:33:39 +0800
Subject: Re: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
To:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>
References: <20190919140650.1289963-2-arnd@arndb.de>
 <20190919140917.1290556-1-arnd@arndb.de>
CC:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Mao Wenan <maowenan@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com>
Date:   Fri, 20 Sep 2019 09:33:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190919140917.1290556-1-arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/09/2019 15:09, Arnd Bergmann wrote:
> To avoid missing arm64 specific warnings that get introduced
> in this driver, allow compile-testing on all 64-bit architectures.
>
> The only actual arm64 specific code in this driver is an open-
> coded 128 bit MMIO write. On non-arm64 the same can be done
> using memcpy_toio. What I also noticed is that the mmio store
> (either one) is not endian-safe, this will only work on little-
> endian configurations, so I also add a Kconfig dependency on
> that, regardless of the architecture.
> Finally, a depenndecy on CONFIG_64BIT is needed because of the

nit: spelling mistake

> writeq().
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: actually add !CPU_BIG_ENDIAN dependency as described in the
> changelog
> ---
>  drivers/crypto/hisilicon/Kconfig | 9 ++++++---
>  drivers/crypto/hisilicon/qm.c    | 6 ++++++
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index ebaf91e0146d..7bfcaa7674fd 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -16,14 +16,15 @@ config CRYPTO_DEV_HISI_SEC
>
>  config CRYPTO_DEV_HISI_QM
>  	tristate
> -	depends on ARM64 && PCI && PCI_MSI
> +	depends on ARM64 || COMPILE_TEST
> +	depends on PCI && PCI_MSI
>  	help
>  	  HiSilicon accelerator engines use a common queue management
>  	  interface. Specific engine driver may use this module.
>
>  config CRYPTO_HISI_SGL
>  	tristate
> -	depends on ARM64
> +	depends on ARM64 || COMPILE_TEST
>  	help
>  	  HiSilicon accelerator engines use a common hardware scatterlist
>  	  interface for data format. Specific engine driver may use this
> @@ -31,7 +32,9 @@ config CRYPTO_HISI_SGL
>
>  config CRYPTO_DEV_HISI_ZIP
>  	tristate "Support for HiSilicon ZIP accelerator"
> -	depends on ARM64 && PCI && PCI_MSI
> +	depends on PCI && PCI_MSI
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	depends on !CPU_BIG_ENDIAN || COMPILE_TEST
>  	select CRYPTO_DEV_HISI_QM
>  	select CRYPTO_HISI_SGL
>  	select SG_SPLIT
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index f975c393a603..a8ed699081b7 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -331,6 +331,12 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
>  	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
>  	unsigned long tmp0 = 0, tmp1 = 0;
>

Hi Arnd,

> +	if (!IS_ENABLED(CONFIG_ARM64)) {
> +		memcpy_toio(fun_base, src, 16);
> +		wmb();
> +		return;
> +	}
> +
>  	asm volatile("ldp %0, %1, %3\n"
>  		     "stp %0, %1, %2\n"
>  		     "dsb sy\n"
>

As I understand, this operation needs to be done atomically. So - even 
though your change is just for compile testing - the memcpy_to_io() may 
not do the same thing on other archs, right?

I just wonder if it's right to make that change, or at least warn the 
imaginary user of possible malfunction for !arm64.

Thanks,
John



