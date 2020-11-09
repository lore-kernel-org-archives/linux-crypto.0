Return-Path: <SRS0=FTK2=EP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CC8C2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 06:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E5A2071E
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 06:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgKIG36 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 01:29:58 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7470 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIG36 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 01:29:58 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CV1Lm2NvRzhhF4;
        Mon,  9 Nov 2020 14:29:52 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 14:29:52 +0800
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <20201104175742.GA846@sol.localdomain>
 <2dad168c-f6cb-103c-04ce-cc3c2561e01b@huawei.com>
 <CAMj1kXG+YJvHLFDMk7ABAD=WthxLx5Uh0LAXCP6+2tXEySj7eg@mail.gmail.com>
 <5b528637-5cb9-a134-2936-7925afae95c6@huawei.com>
 <20201105182155.GA2555324@gmail.com>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <9b6eb382-9965-562b-346e-5afaca1589c7@huawei.com>
Date:   Mon, 9 Nov 2020 14:29:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201105182155.GA2555324@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/6 2:21, Eric Biggers 写道:
> On Thu, Nov 05, 2020 at 05:05:53PM +0800, Li Qiang wrote:
>>
>>
>> 在 2020/11/5 15:51, Ard Biesheuvel 写道:
>>> Note that NEON intrinsics can be compiled for 32-bit ARM as well (with
>>> a bit of care - please refer to lib/raid6/recov_neon_inner.c for an
>>> example of how to deal with intrinsics that are only available on
>>> arm64) and are less error prone, so intrinsics should be preferred if
>>> feasible.
>>>
>>> However, you have still not explained how optimizing Adler32 makes a
>>> difference for a real-world use case. Where is libdeflate used on a
>>> hot path?
>>> .
>>
>> Sorry :(, I have not specifically searched for the use of this algorithm
>> in the kernel.
>>
>> When I used perf to test the performance of the libz library before,
>> I saw that the adler32 algorithm occupies a lot of hot spots.I just
>> saw this algorithm used in the kernel code, so I think optimizing this
>> algorithm may have some positive optimization effects on the kernel.:)
> 
> Adler32 performance is important for zlib compression/decompression, which has a
> few use cases in the kernel such as btrfs compression.  However, these days
> those few kernel use cases are mostly switching to newer algorithms like lz4 and
> zstd.  Also as I mentioned, your patch doesn't actually wire up your code to be
> used by the kernel's implementation of zlib compression/decompression.
> 
> I think you'd be much better off contributing to a userspace project, where
> DEFLATE/zlib/gzip support still has a long tail of use cases.  The official zlib
> isn't really being maintained and isn't accepting architecture-specific
> optimizations, but there are some performance-oriented forks of zlib (e.g.
> https://chromium.googlesource.com/chromium/src/third_party/zlib/ and
> https://github.com/zlib-ng/zlib-ng), as well as other projects like libdeflate
> (https://github.com/ebiggers/libdeflate).  Generally I'm happy to accept
> architecture-specific optimizations in libdeflate, but they need to be testable.
> 
> - Eric
> .
> 

Thank you for your answers and suggestions. I have not seen these repositories
before. Regarding the SVE implementation of adler32, I will focus on the
repositories you mentioned later.:)

-- 
Best regards,
Li Qiang
