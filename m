Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C62C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 09:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1082F64ED7
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 09:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhBTJs1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 04:48:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12986 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhBTJs0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 04:48:26 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DjNqk29NDzjQNd;
        Sat, 20 Feb 2021 17:46:10 +0800 (CST)
Received: from [10.67.102.118] (10.67.102.118) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 20 Feb 2021 17:47:35 +0800
Subject: Re: [PATCH v2 3/3] crypto: hisilicon/sec - fixes shash test error
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <wangzhou1@hisilicon.com>, <xuzaibo@huawei.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1612692280-11386-1-git-send-email-liulongfang@huawei.com>
 <1612692280-11386-4-git-send-email-liulongfang@huawei.com>
 <20210210064328.GA15849@gondor.apana.org.au>
 <0afaed85-eeb0-236c-817f-a0f9cf02c65a@huawei.com>
 <20210218020647.GB30659@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <a235fc8b-6ff4-cf6e-84f5-ed6019e752db@huawei.com>
Date:   Sat, 20 Feb 2021 17:47:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210218020647.GB30659@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/2/18 10:06, Herbert Xu wrote:
> On Thu, Feb 18, 2021 at 10:01:58AM +0800, liulongfang wrote:
>>
>>>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>>> index d2c4a2c..988faf7 100644
>>>> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>>>> @@ -7,6 +7,7 @@
>>>>  #include <crypto/des.h>
>>>>  #include <crypto/hash.h>
>>>>  #include <crypto/internal/aead.h>
>>>> +#include <crypto/internal/hash.h>
>>>
>>> Please explain what exactly in this file needs this header file.
>>>
>>> As it stands you could just be hiding real bugs.
>>>
>>> Thanks,
>>>
>> The crypto_alloc_shash() interface in the header file
>> will be used in the function sec_aead_ctx_init(),
>> If this header file is not added, calling the interface
>> crypto_alloc_shash() during the initialization of the
>> aead algorithm will return an error.
> 
> This makes no sense whatsoever as crypto_alloc_shash is defiend
> by crypto/hash.h and you've already included that.
> 
> Cheers,
> 
On this kernel version, those modules set to Y will not use the sha512 algorithm.
And our SEC module selects it "select CRYPTO_SHA512", so it is compiled into
ko: "sha512_generic.ko".
Because we did not load the "sha512_generic.ko" when we loaded the ko of SEC,
the sha512 algorithm test failed, Therefore, before using SEC,
we need to load this ko first, so this patch is not required, please ignore it.
Thanks
Longfang.
