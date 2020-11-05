Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D718DC2D0A3
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 02:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8905120825
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 02:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgKECt7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 21:49:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7056 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgKECt6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 21:49:58 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CRSfn0D8gzhgRL;
        Thu,  5 Nov 2020 10:49:53 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 5 Nov 2020
 10:49:51 +0800
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@st.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <20201104175742.GA846@sol.localdomain>
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <2dad168c-f6cb-103c-04ce-cc3c2561e01b@huawei.com>
Date:   Thu, 5 Nov 2020 10:49:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20201104175742.GA846@sol.localdomain>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

ÔÚ 2020/11/5 1:57, Eric Biggers Ð´µÀ:
> On Tue, Nov 03, 2020 at 08:15:06PM +0800, l00374334 wrote:
>> From: liqiang <liqiang64@huawei.com>
>>
>> 	In the libz library, the checksum algorithm adler32 usually occupies
>> 	a relatively high hot spot, and the SVE instruction set can easily
>> 	accelerate it, so that the performance of libz library will be
>> 	significantly improved.
>>
>> 	We can divides buf into blocks according to the bit width of SVE,
>> 	and then uses vector registers to perform operations in units of blocks
>> 	to achieve the purpose of acceleration.
>>
>> 	On machines that support ARM64 sve instructions, this algorithm is
>> 	about 3~4 times faster than the algorithm implemented in C language
>> 	in libz. The wider the SVE instruction, the better the acceleration effect.
>>
>> 	Measured on a Taishan 1951 machine that supports 256bit width SVE,
>> 	below are the results of my measured random data of 1M and 10M:
>>
>> 		[root@xxx adler32]# ./benchmark 1000000
>> 		Libz alg: Time used:    608 us, 1644.7 Mb/s.
>> 		SVE  alg: Time used:    166 us, 6024.1 Mb/s.
>>
>> 		[root@xxx adler32]# ./benchmark 10000000
>> 		Libz alg: Time used:   6484 us, 1542.3 Mb/s.
>> 		SVE  alg: Time used:   2034 us, 4916.4 Mb/s.
>>
>> 	The blocks can be of any size, so the algorithm can automatically adapt
>> 	to SVE hardware with different bit widths without modifying the code.
>>
>>
>> Signed-off-by: liqiang <liqiang64@huawei.com>
> 
> Note that this patch does nothing to actually wire up the kernel's copy of libz
> (lib/zlib_{deflate,inflate}/) to use this implementation of Adler32.  To do so,
> libz would either need to be changed to use the shash API, or you'd need to
> implement an adler32() function in lib/crypto/ that automatically uses an
> accelerated implementation if available, and make libz call it.
> 
> Also, in either case a C implementation would be required too.  There can't be
> just an architecture-specific implementation.

Okay, thank you for the problems and suggestions you gave. I will continue to
improve my code.

> 
> Also as others have pointed out, there's probably not much point in having a SVE
> implementation of Adler32 when there isn't even a NEON implementation yet.  It's
> not too hard to implement Adler32 using NEON, and there are already several
> permissively-licensed NEON implementations out there that could be used as a
> reference, e.g. my implementation using NEON instrinsics here:
> https://github.com/ebiggers/libdeflate/blob/v1.6/lib/arm/adler32_impl.h
> 
> - Eric
> .
> 

I am very happy to get this NEON implementation code. :)

-- 
Best regards,
Li Qiang
