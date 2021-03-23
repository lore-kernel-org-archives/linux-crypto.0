Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB0CC433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 07:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7C3619C0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 07:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCWHla (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Mar 2021 03:41:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13666 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCWHlU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Mar 2021 03:41:20 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F4NXS2xtcznTX3;
        Tue, 23 Mar 2021 15:38:48 +0800 (CST)
Received: from [10.67.101.248] (10.67.101.248) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 23 Mar 2021 15:41:09 +0800
Subject: Re: [PATCH -next] crypto: hisilicon/hpre: fix link error
To:     Yang Yingliang <yangyingliang@huawei.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210323072716.3146252-1-yangyingliang@huawei.com>
CC:     <xuzaibo@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From:   tanghui20 <tanghui20@huawei.com>
Message-ID: <9194c58f-f240-b993-5fec-2a994b26f0eb@huawei.com>
Date:   Tue, 23 Mar 2021 15:41:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210323072716.3146252-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is a patch similar to yours that was send in advance, as follows:
https://www.spinics.net/lists/linux-crypto/msg54238.html

On 2021/3/23 15:27, Yang Yingliang wrote:
> Fix the follow link error by select config CRYPTO_ECC and CRYPTO_ECDH.
>
> ERROR: modpost: "ecc_get_curve25519" [drivers/crypto/hisilicon/hpre/hisi_hpre.ko] undefined!
> ERROR: modpost: "ecc_get_curve" [drivers/crypto/hisilicon/hpre/hisi_hpre.ko] undefined!
> ERROR: modpost: "crypto_ecdh_decode_key" [drivers/crypto/hisilicon/hpre/hisi_hpre.ko] undefined!
>
> Fixes: 90274769cf79 ("crypto: hisilicon/hpre - add 'CURVE25519' algorithm")
> Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/crypto/hisilicon/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index c45adb15ce8d..d87c89af2a7f 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -69,6 +69,8 @@ config CRYPTO_DEV_HISI_HPRE
>  	select CRYPTO_DEV_HISI_QM
>  	select CRYPTO_DH
>  	select CRYPTO_RSA
> +	select CRYPTO_ECC
> +	select CRYPTO_ECDH
>  	help
>  	  Support for HiSilicon HPRE(High Performance RSA Engine)
>  	  accelerator, which can accelerate RSA and DH algorithms.
>
