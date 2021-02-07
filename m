Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FF2C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 09:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C0D964E02
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 09:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhBGJt4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:49:56 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12445 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGJtw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 04:49:52 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYPTv5vDszjGFZ;
        Sun,  7 Feb 2021 17:48:03 +0800 (CST)
Received: from [10.67.102.118] (10.67.102.118) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 17:49:03 +0800
Subject: Re: [PATCH 3/3] crypto: hisilicon/sec - fixes shash test error
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        <wangzhou1@hisilicon.com>, "Zaibo Xu" <xuzaibo@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1612519857-30714-1-git-send-email-liulongfang@huawei.com>
 <1612519857-30714-4-git-send-email-liulongfang@huawei.com>
 <20210205114435.GA17031@gondor.apana.org.au>
 <70c0e041-9bcc-aa67-a0ad-a1a202f2e708@huawei.com>
 <CAMj1kXF71nPwMVNM-xwo2UNXW6xq3G=QTCNahLNS7fCfhdSMsA@mail.gmail.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <29e527d9-5b0e-5054-b0b4-d8b72e1c917c@huawei.com>
Date:   Sun, 7 Feb 2021 17:49:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXF71nPwMVNM-xwo2UNXW6xq3G=QTCNahLNS7fCfhdSMsA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/2/7 16:02, Ard Biesheuvel wrote:
> On Sun, 7 Feb 2021 at 03:47, liulongfang <liulongfang@huawei.com> wrote:
>>
>> On 2021/2/5 19:44, Herbert Xu write:
>>> On Fri, Feb 05, 2021 at 06:10:57PM +0800, Longfang Liu wrote:
>>>> If this configuration item is not turned on,
>>>> the allocation of crypto_tfm will fail when
>>>> the shash algorithm calculates the hash
>>>> through the software.
>>>>
>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>> ---
>>>>  arch/arm64/configs/defconfig | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
>>>> index 8383016..7cfc9b6 100644
>>>> --- a/arch/arm64/configs/defconfig
>>>> +++ b/arch/arm64/configs/defconfig
>>>> @@ -117,7 +117,7 @@ CONFIG_KVM=y
>>>>  CONFIG_ARM64_CRYPTO=y
>>>>  CONFIG_CRYPTO_SHA1_ARM64_CE=y
>>>>  CONFIG_CRYPTO_SHA2_ARM64_CE=y
>>>> -CONFIG_CRYPTO_SHA512_ARM64_CE=m
>>>> +CONFIG_CRYPTO_SHA512_ARM64_CE=y
>>>
>>> If this is truly needed then it should be enabled through Kconfig.
>>>
>>> Cheers,
>>>
>> Hi Herbert,
>> The option select CRYPTO_SHA512 already exists in Kconfig.
> 
> In that case, how can the shash TFM allocation fail?
> 
Hi
After comparison and investigation, the problem is that the header
file "crypto/internal/hash.h" is not added. After adding this header file,
which CRYPTO_SHA512_ARM64_C compilation option does not need to be enabled.
I will modify it in the next patch.
>> Can I change it to this: select CRYPTO_SHA512 || CRYPTO_SHA512_ARM64_CE
> 
> No, you cannot select expressions like that.
> 
> Could you please explain the problem you are trying to solve?
> .
> 
When allocation shash TFM with hmac(sha512)-cbc(aes) algorithm,
TFM will return an error.
Thanks
Longfang.
