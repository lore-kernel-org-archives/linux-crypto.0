Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3782C2D0A3
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 02:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7568920756
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 02:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgKECcn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 21:32:43 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7145 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbgKECcm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 21:32:42 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CRSGr3pZCz15Qn0;
        Thu,  5 Nov 2020 10:32:36 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 5 Nov 2020
 10:32:35 +0800
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Dave Martin <Dave.Martin@arm.com>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
 <20201103180031.GO6882@arm.com>
 <8c62099c-46b5-924f-d044-e442af4aab08@huawei.com>
 <20201104144914.GZ6882@arm.com>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <99e9fc5a-986a-98bf-ca5f-44b896e0759d@huawei.com>
Date:   Thu, 5 Nov 2020 10:32:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20201104144914.GZ6882@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/4 22:49, Dave Martin 写道:
> On Wed, Nov 04, 2020 at 05:19:18PM +0800, Li Qiang wrote:

...

>>>
>>> I haven't tried to understand this algorithm in detail, but there should
>>> probably be no need for this special case to handle the trailing bytes.
>>>
>>> You should search for examples of speculative vectorization using
>>> WHILELO etc., to get a better feel for how to do this.
>>
>> Yes, I have considered this problem, but I have not found a good way to achieve it,
>> because before the end of the loop is reached, the decreasing sequence used for
>> calculation is determined.
>>
>> For example, buf is divided into 32-byte blocks. This sequence should be 32,31,...,2,1,
>> if there are only 10 bytes left at the end of the loop, then this sequence
>> should be 10,9,8,...,2,1.
>>
>> If I judge whether the end of the loop has been reached in the body of the loop,
>> and reset the starting point of the sequence according to the length of the tail,
>> it does not seem very good.
> 
> That would indeed be inefficient, since the adjustment is only needed on
> the last iteration.
> 
> Can you do instead do the adjustment after the loop ends?
> 
> For example, if
> 
> 	y = x[n] * 32 + x[n+1] * 31 + x[n+2] * 30 ...
> 
> then 
> 
> 	y - (x[n] * 22 + x[n+1] * 22 + x[n+2] * 22 ...)
> 
> equals
> 
> 	x[n] + 10 + x[n+1] * 9 + x[n+2] * 8 + ,,,
> 
> (This isn't exactly what the algorithm demands, but hopefully you see the
> general idea.)
> 
> [...]
> 
> Cheers
> ---Dave
> .
> 

This idea seems feasible, so that the judgment can be made only once after the
end of the loop, and the extra part is subtracted, and there is no need to enter
another loop to process the trailing bytes.

I will try this solution later. Thank you! :)

-- 
Best regards,
Li Qiang
