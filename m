Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0091CC0018C
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 03:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A96A023719
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 03:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLQDIT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 22:08:19 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9898 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbgLQDIT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 22:08:19 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CxH364gCNz7Fq4;
        Thu, 17 Dec 2020 11:06:58 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Thu, 17 Dec 2020
 11:07:29 +0800
Subject: Re: [PATCH v4 4/5] crypto: hisilicon/hpre - add 'ECDH' algorithm
To:     Stephan Mueller <smueller@chronox.de>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
References: <13db294664a6b2e26a892dd544c714d3e385b0cc.camel@chronox.de>
 <3903e2e8-165f-51b5-056c-24b8ce52e842@huawei.com>
 <711de58c-4f7c-4643-4b8b-6af98ed1a7bc@huawei.com>
 <b38e3b40ef198166bff193940b8c82c41db6f13c.camel@chronox.de>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <06fa1f72-fad8-a3e5-987a-d322918ac30a@huawei.com>
Date:   Thu, 17 Dec 2020 11:07:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <b38e3b40ef198166bff193940b8c82c41db6f13c.camel@chronox.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/12/17 4:10, Stephan Mueller 写道:
> Am Mittwoch, dem 16.12.2020 um 10:39 +0800 schrieb yumeng:
>>
>>
>>
>>> Am Freitag, den 11.12.2020, 14:30 +0800 schrieb Meng Yu:
>>>>
>>>> +/* size in bytes of the n prime */
>>>> +#define HPRE_ECC_NIST_P128_N_SIZE      16
>>>
>>> Do we truly need P-128? Besides, I do not see that curve being defined in
>>> contemporary cipher specs.
>>>
>>>> +#define HPRE_ECC_NIST_P192_N_SIZE      24
>>>> +#define HPRE_ECC_NIST_P224_N_SIZE      28
>>>> +#define HPRE_ECC_NIST_P256_N_SIZE      32
>>>> +#define HPRE_ECC_NIST_P320_N_SIZE      40
>>>
>>> Do we truly need P-320? Besides, I do not see that curve being defined in
>>> contemporary cipher specs.
>>
>> Yes, in rfc 5903, only P-256, P-384 and P-521 is defined, but in
>> 'rfc5639' and  "SEC 2: Recommended Elliptic Curve Domain Parameters",
>> other curves like P-128, P-192, P-224, and P-320 curve parameters are
>> found, and they are used in 'openssl';
>> How about your idea?
> 
> Who is going to use that curve considering that common protocols that are
> implemented in the kernel do not use it?
> 
> Thanks
> Stephan
> 

I see in "SEC 2: Recommended Elliptic Curve Domain ParametersVersion2.0"
that 'Recommend Elliptic Curve Domain Parameters over Fp' are secp192,
secp224, secp256, secp384, and secp521, secp128 and secp320 are not
recommended.
So you mean it's better not to include secp128 and secp320, right?

Thanks,

