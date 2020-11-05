Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42384C55178
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 18:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D480921D46
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604600518;
	bh=+OtMxMqFHQbVi8HakvWqVl7xz/M4YezzWnkgDLi3czE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EOZ01B95BxsLzVi8aq6K4KXC7bW2cqr44raPxt7I7YK60OWQezebazvn5Et50SOQW
	 0hCB5sOUIJb30cArsm5PrqGP9rnFr1iVz3+pJTDo8PROTz+zmO9vZHJapxLp/AwUR1
	 Qq2LzL8nJduziBWw3Q3OCNc9SBt5Lmx9vW662YD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgKESV6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Nov 2020 13:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgKESV6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Nov 2020 13:21:58 -0500
Received: from gmail.com (unknown [104.132.1.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63062078E;
        Thu,  5 Nov 2020 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604600517;
        bh=+OtMxMqFHQbVi8HakvWqVl7xz/M4YezzWnkgDLi3czE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BIrK13uqz3GXI6KOTz/+g9XFoSvg3wJWzrlyNeeJ62M9XfUU7GZkaN+PV977Q+DPd
         ghDTCMIQiTHAQDJh+Is4xSutKF/lrjhoK0ywBiQdw+WYN8+me/UNg8A0OulrPvGxue
         dBkEVpgdKxbTcwRETNSmrGPbB3Z8f70ERpnXPxEM=
Date:   Thu, 5 Nov 2020 10:21:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Li Qiang <liqiang64@huawei.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201105182155.GA2555324@gmail.com>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <20201104175742.GA846@sol.localdomain>
 <2dad168c-f6cb-103c-04ce-cc3c2561e01b@huawei.com>
 <CAMj1kXG+YJvHLFDMk7ABAD=WthxLx5Uh0LAXCP6+2tXEySj7eg@mail.gmail.com>
 <5b528637-5cb9-a134-2936-7925afae95c6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b528637-5cb9-a134-2936-7925afae95c6@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 05, 2020 at 05:05:53PM +0800, Li Qiang wrote:
> 
> 
> 在 2020/11/5 15:51, Ard Biesheuvel 写道:
> > Note that NEON intrinsics can be compiled for 32-bit ARM as well (with
> > a bit of care - please refer to lib/raid6/recov_neon_inner.c for an
> > example of how to deal with intrinsics that are only available on
> > arm64) and are less error prone, so intrinsics should be preferred if
> > feasible.
> > 
> > However, you have still not explained how optimizing Adler32 makes a
> > difference for a real-world use case. Where is libdeflate used on a
> > hot path?
> > .
> 
> Sorry :(, I have not specifically searched for the use of this algorithm
> in the kernel.
> 
> When I used perf to test the performance of the libz library before,
> I saw that the adler32 algorithm occupies a lot of hot spots.I just
> saw this algorithm used in the kernel code, so I think optimizing this
> algorithm may have some positive optimization effects on the kernel.:)

Adler32 performance is important for zlib compression/decompression, which has a
few use cases in the kernel such as btrfs compression.  However, these days
those few kernel use cases are mostly switching to newer algorithms like lz4 and
zstd.  Also as I mentioned, your patch doesn't actually wire up your code to be
used by the kernel's implementation of zlib compression/decompression.

I think you'd be much better off contributing to a userspace project, where
DEFLATE/zlib/gzip support still has a long tail of use cases.  The official zlib
isn't really being maintained and isn't accepting architecture-specific
optimizations, but there are some performance-oriented forks of zlib (e.g.
https://chromium.googlesource.com/chromium/src/third_party/zlib/ and
https://github.com/zlib-ng/zlib-ng), as well as other projects like libdeflate
(https://github.com/ebiggers/libdeflate).  Generally I'm happy to accept
architecture-specific optimizations in libdeflate, but they need to be testable.

- Eric
