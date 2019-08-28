Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C64C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 05:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B89322CF8
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 05:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfH1Fr6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 01:47:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbfH1Fr5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 01:47:57 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AE68D3FF867C41A3AA02;
        Wed, 28 Aug 2019 13:47:55 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 28 Aug 2019
 13:47:45 +0800
Subject: Re: [PATCH -next] crypto: hisilicon: select CRYPTO_LIB_DES while
 compiling SEC driver
To:     Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20190826115914.182700-1-maowenan@huawei.com>
 <20190827135722.00000e6a@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <wangzhou1@hisilicon.com>, <liguozhu@hisilicon.com>,
        <john.garry@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <affd8de1-ae35-a1d0-534a-d9cdfac90de8@huawei.com>
Date:   Wed, 28 Aug 2019 13:47:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190827135722.00000e6a@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2019/8/27 20:57, Jonathan Cameron wrote:
> On Mon, 26 Aug 2019 19:59:14 +0800
> Mao Wenan <maowenan@huawei.com> wrote:
> 
>> When CRYPTO_DEV_HISI_SEC=y, below compilation error is found after 
>> 'commit 894b68d8be4b ("crypto: hisilicon/des - switch to new verification routines")':
>>
>> drivers/crypto/hisilicon/sec/sec_algs.o: In function `sec_alg_skcipher_setkey_des_cbc':
>> sec_algs.c:(.text+0x11f0): undefined reference to `des_expand_key'
>> drivers/crypto/hisilicon/sec/sec_algs.o: In function `sec_alg_skcipher_setkey_des_ecb':
>> sec_algs.c:(.text+0x1390): undefined reference to `des_expand_key'
>> make: *** [vmlinux] Error 1
>>
>> This because DES library has been moved to lib/crypto in this commit 
>> '04007b0e6cbb ("crypto: des - split off DES library from generic DES cipher driver")'.
>> Fix this by selecting CRYPTO_LIB_DES in CRYPTO_DEV_HISI_SEC.
>>
>> Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
>> Fixes: 04007b0e6cbb ("crypto: des - split off DES library from generic DES cipher driver")
>> Fixes: 894b68d8be4b ("crypto: hisilicon/des - switch to new verification routines")
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> Ah. It's that that third one that really introduced the dependency so possibly
> only that one should be listed with a fixes tag.  However the right fix
> at that point was to select CRYPTO_DES which then changed to CRYPTO_LIB_DES
> only after the second patch.
> 
> It's not a fix for the first patch so that should probably not be there.

Thanks， that's right, I will send v2 and keep two fixes,
Fixes: 04007b0e6cbb ("crypto: des - split off DES library from generic DES cipher driver")
Fixes: 894b68d8be4b ("crypto: hisilicon/des - switch to new verification routines")

then remove fix tag because it only introduces one driver:
Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")

> 
> Otherwise, looks correct to me.
> 
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> thanks,
> 
> Jonathan
> 
> 
> 
>> ---
>>  drivers/crypto/hisilicon/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
>> index fa8aa06..ebaf91e 100644
>> --- a/drivers/crypto/hisilicon/Kconfig
>> +++ b/drivers/crypto/hisilicon/Kconfig
>> @@ -4,6 +4,7 @@ config CRYPTO_DEV_HISI_SEC
>>  	tristate "Support for Hisilicon SEC crypto block cipher accelerator"
>>  	select CRYPTO_BLKCIPHER
>>  	select CRYPTO_ALGAPI
>> +	select CRYPTO_LIB_DES
>>  	select SG_SPLIT
>>  	depends on ARM64 || COMPILE_TEST
>>  	depends on HAS_IOMEM
> 
> 
> 
> .
> 

