Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B99C00A89
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 09:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6931920715
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 09:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgKEJGC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:06:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7593 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgKEJGB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Nov 2020 04:06:01 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CRd0d3SFczLqXg;
        Thu,  5 Nov 2020 17:05:53 +0800 (CST)
Received: from [10.110.54.32] (10.110.54.32) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 5 Nov 2020
 17:05:54 +0800
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
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
From:   Li Qiang <liqiang64@huawei.com>
Message-ID: <5b528637-5cb9-a134-2936-7925afae95c6@huawei.com>
Date:   Thu, 5 Nov 2020 17:05:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXG+YJvHLFDMk7ABAD=WthxLx5Uh0LAXCP6+2tXEySj7eg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.110.54.32]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



在 2020/11/5 15:51, Ard Biesheuvel 写道:
> Note that NEON intrinsics can be compiled for 32-bit ARM as well (with
> a bit of care - please refer to lib/raid6/recov_neon_inner.c for an
> example of how to deal with intrinsics that are only available on
> arm64) and are less error prone, so intrinsics should be preferred if
> feasible.
> 
> However, you have still not explained how optimizing Adler32 makes a
> difference for a real-world use case. Where is libdeflate used on a
> hot path?
> .

Sorry :(, I have not specifically searched for the use of this algorithm
in the kernel.

When I used perf to test the performance of the libz library before,
I saw that the adler32 algorithm occupies a lot of hot spots.I just
saw this algorithm used in the kernel code, so I think optimizing this
algorithm may have some positive optimization effects on the kernel.:)

-- 
Best regards,
Li Qiang
