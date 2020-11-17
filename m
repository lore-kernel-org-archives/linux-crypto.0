Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7573C2D0E4
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 12:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B35722203
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 12:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgKQMqI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 07:46:08 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7636 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQMqI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 07:46:08 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cb5Jw45DWz15MbQ;
        Tue, 17 Nov 2020 20:45:52 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Nov 2020
 20:45:55 +0800
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
 <484ad2c8-3905-fc98-237c-f7eb4045edbc@huawei.com>
 <20201112111745.GS6882@arm.com>
 <72514954-ea04-6aa3-73d8-bb0fc39b6de2@huawei.com>
 <20201116155636.GZ6882@arm.com>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <ab2a10f0-82eb-8e31-f53f-0bcae6977504@huawei.com>
Date:   Tue, 17 Nov 2020 20:45:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116155636.GZ6882@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/16 23:56, Dave Martin 写道:
>> --8<--
>> 	...
>> 	adler_A .req    x10
>> 	adler_B .req    x11
>> 	
>> 	.macro	adler32_core
>> 	ld1b	zX.h, p0/z, [x1]	// load bytes
>> 	inch	x1
>>
>> 	uaddv	d0, p0, zX.h
>> 	mul	zX.h, p0/m, zX.h, zJ.h	// Sum [j=0 .. v-1] j*X[j+n]
>> 	mov	x9, v0.d[0]
>> 	uaddv	d1, p0, zX.h
>> 	add	adler_A, adler_A, x9	// A[n+v] = An + Sum [j=0 ... v-1] X[j]
>> 	mov	x9, v1.d[0]
>> 	madd	adler_B, x7, adler_A, adler_B	// Bn + v*A[n+v]
>> 	sub	adler_B, adler_B, x9		// B[n+v] = Bn + v*A[n+v] - Sum [j=0 .. v-1] j*X[j+n]
>> 	.endm
> If this has best performance, I find that quite surprising.  Those uaddv
> instructions will stop the vector lanes flowing independently inside the
> loop, so if an individual element load is slow arriuaddving then everything
> will have to wait.

I don't know much about this problem, do you mean that the uaddv instruction used in
the loop has a great impact on performance?

> 
> A decent hardware prefetcher may tend to hide that issue for sequential
> memory access, though: i.e., if the hardware does a decent job of
> fetching data before the actual loads are issued, the data may appear to
> arrive with minimal delay.
> 
> The effect might be a lot worse for algorithms that have less
> predictable memory access patterns.
> 
> Possibly you do win some additional performance due to processing twice
> as many elements at once, here.

I think so. Compared to loading bytes into zX.h, if you load them directly into zX.b,
and then use uunpklo/uunpkhi for register expansion, the performance will be more better(20% faster).
This may be the reason.

-- 
Best regards,
Li Qiang
