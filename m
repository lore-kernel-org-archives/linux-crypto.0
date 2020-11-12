Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F1EC2D0A3
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 07:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4CA22083E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 07:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgKLHVI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 02:21:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7209 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLHVH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 02:21:07 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CWtL82xLHzkh9l;
        Thu, 12 Nov 2020 15:20:48 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 15:20:54 +0800
Subject: Re: [PATCH 0/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Dave Martin <Dave.Martin@arm.com>
CC:     <alexandre.torgue@st.com>, <catalin.marinas@arm.com>,
        <gaoguijin@huawei.com>, <colordev.jiang@huawei.com>,
        <luchunhua@huawei.com>, <linux-crypto@vger.kernel.org>,
        <mcoquelin.stm32@gmail.com>, <liliang889@huawei.com>,
        <will@kernel.org>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>,
        <herbert@gondor.apana.org.au>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201105165301.GH6882@arm.com>
 <f323de50-c358-88e7-6588-7d14542f2754@huawei.com>
 <20201110104629.GJ6882@arm.com>
 <89a9bdcc-b96e-2f2d-6c52-ca44e0e3472c@huawei.com>
 <20201110160708.GL6882@arm.com>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <484ad2c8-3905-fc98-237c-f7eb4045edbc@huawei.com>
Date:   Thu, 12 Nov 2020 15:20:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201110160708.GL6882@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/11 0:07, Dave Martin 写道:
>>>>> 	add     zA.s, pP/m, zA.s, zX.s        // zA.s += zX.s
>>>>>
>>>>> 	msb     zX.s, pP/m, zJ.s, zB.s        // zX.s := zB.s - zX.s * zJ.s
>>>>>
>>>>> 	movprfx zB, zA
>>>>> 	mad     zB.s, pP/m, zV.s, zX.s        // zB.s := zX.s + zA.s * V
>> I found the bug I encountered earlier, that is, the calculation of zB here
>> needs to use pA with all elements activated. The reason is the same as my
>> previous guess, because all elements of zA should be involved when calculating zB.
>> Because the original calculation formula is like this.
>>
>> For example:
>> In the last loop:
>> 	left byte is:	  3 |   4 |  \0 |
>> 	zA.s is:	100 | 200 | 100 | 200 (sum = 600)
>> 	pP.s is:	  1 |   1 |   0 |   0 (Only activate the first 2 channels)
>>
>> At this time, if the calculation of zB only takes the first 2 active elements, the data
>> is incomplete, because according to the description of the original algorithm, zB is always
>> based on the sum of all the accumulated bytes.
> Yes, you're quite right here: zX is partial: only the elements pP are
> valid; but all elements of zA and zB are always valid.  I was focusing
> too much on the handling of the partial input block.
> 
>> Here we can simply change the prediction register used in the two sentences related to
>> zB to the one that is all true (it is pA in our code), like this:
>> 	msb     zX.s, pA/m, zJ.s, zB.s        // zX.s := zB.s - zX.s * zJ.s
> Are you sure about this?  In a final partial block, the trailing
> elements of zX.s beyond pP will be leftover junk from the last
> iteration.

Yes, I have verified this code and it is correct. The reason is that if pP is used here,
the inactive elements of zB will be ignored in zX, which will cause data loss.(I think it is
because the zB data is covered by the multiplication and addition results of zX, zA, and zV
using movprfx and mad. Have I got that right?) :)

On the other hand zX uses the prediction register pP/z when loading data, the value of the
inactive element is 0, the inactive element in zX will not affect the final result, the inactive
element in zB will be directly assigned to the inactive element of zX element.

Then in the next instruction, it will be added to zB along with zX.

> 
> This might require a bit more thought in order to get the final block
> handling correct.
> 
>> trailloop:			// Last cycle entrance
>>         cntp    x6, p1, p0.s	// Get active element count of last cycle
>>         cpy     zV.s, p1/m, w6	// Set zV to the actual value.
> Note that you can also write "mov" here, but I'm not sure which alias is
> preferred>
>> loop:				// Core loop entrance
>>         ld1b    zX.s, p0/z, [x1]
>>         incw    x1
>>
>>         add     zA.s, p0/m, zA.s, zX.s	// The calculation of zA still needs to use p0
>>         msb     zX.s, p1/m, zJ.s, zB.s	// Change p register here
>>         movprfx zB, zA
>>         mad     zB.s, p1/m, zV.s, zX.s	// Change p register here
> As discussed above, are you sure this is correct now?
> 
>> start:
>>         whilelo p0.s, x1, xLimit
>>         b.last  loop		// The condition for the core loop to continue is that b.last is true
>>         b.first trailloop	// If b.last is false and b.first is true, it means the last cycle
>>
>>         uaddv   d0, p1, zA.s
>>         uaddv   d1, p1, zB.s
>>
>>         mov     x12, v0.2d[0]
>>         mov     x13, v1.2d[0]
> The "2" here seems not to be required by the syntax, although it's
> harmless.

Yes I deleted it.

> 
>>         add     x10, x10, x12
>>         add     x11, x11, x13
>>         add     x11, x11, x2
> If x10 and x11 are used as accmulators by the caller, I guess this works.

X10 and X11 are part A and part B of the initial value of adler32 passed in by the caller.

> 
>>         mod65521        10, 14, 12
>>         mod65521        11, 14, 12
>>         lsl     x11, x11, #16
>>         orr     x0, x10, x11
>>         ret
>> -->8--
>>
>> After this modification, The test results are correct when the data length is less than about 8 Kbyte,
>> part A will still be correct after 8K, and an overflow error will occur in part B. This is because A
>> only accumulates all the bytes, and the accumulative acceleration of B expands faster, because the
>> accumulative formula of B is:
>> 	B = (1 + D1) + (1 + D1 + D2) + ... + (1 + D1 + D2 + ... + Dn) (mod 65521)
>>            = n×D1 + (n−1)×D2 + (n−2)×D3 + ... + Dn + n (mod 65521)
>>
>> If we take the average value of Dx to 128 and n to 8192:
>> 	B = (1 + 2 + ... + 8129) * 128 + 8192
>> 	  = 4,295,499,776 (32bit overflow)
>>
>> So I think the 32-bit accumulator is still not enough for part B here. :)
>>
>> -- 
>> Best regards,
>> Li Qiang
> That makes sense.  I hadn't tried to calculate the actual bound.
> 
> It may be worth trying this with 64-bit accumulators.  This will
> probably slow things down, but it depends on the relative computation /
> memory throughput exhibited by the hardware.

If a 64-bit wide vector register is used, for most scenes where the amount of data is not particularly large,
is it wasted more vector resources?

Maybe we can also try to use 16-bit wide vector registers to load data and calculations,
and accumulate them into the scalar register xn before overflow, just like my original patch,
but I can try to use ascending order to change the processing of the last loop Be more elegant.

> 
> I think the code can't be bulletproof without breaking the input into
> chunks anyway, though.

I don't quite understand what it means here. Does it mean that the input bytes are read into the vector in
blocks for calculation (this is how it is done now) or the intermediate results are stored in different elements
of the vector in blocks during the calculation process? :-)

> 
> Cheers
> ---Dave
> .
-- 
Best regards,
Li Qiang
