Return-Path: <SRS0=EIvj=EK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A77FC2D0A3
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 18:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F28662083B
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 18:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgKDSNM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:13:12 -0500
Received: from foss.arm.com ([217.140.110.172]:41536 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbgKDSNM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 13:13:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8473414BF;
        Wed,  4 Nov 2020 10:13:11 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18CC63F718;
        Wed,  4 Nov 2020 10:13:09 -0800 (PST)
Date:   Wed, 4 Nov 2020 18:13:06 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        l00374334 <liqiang64@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201104181256.GG6882@arm.com>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
 <20201103180031.GO6882@arm.com>
 <20201104175032.GA15020@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104175032.GA15020@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 04, 2020 at 05:50:33PM +0000, Mark Brown wrote:
> On Tue, Nov 03, 2020 at 06:00:32PM +0000, Dave Martin wrote:
> > On Tue, Nov 03, 2020 at 03:34:27PM +0100, Ard Biesheuvel wrote:
> 
> > > First of all, I don't think it is safe at the moment to use SVE in the
> > > kernel, as we don't preserve all state IIRC. My memory is a bit hazy,
> 
> > I'm not convinced that it's safe right now.  SVE in the kernel is
> > unsupported, partly due to cost and partly due to the lack of a
> > compelling use case.
> 
> I think at a minimum we'd want to handle the vector length explicitly
> for kernel mode SVE, vector length independent code will work most of
> the time but at the very least it feels like a landmine waiting to cause
> trouble.  If nothing else there's probably going to be cases where it
> makes a difference for performance.  Other than that I'm not currently
> seeing any issues since we're handling SVE in the same paths we handle
> the rest of the FPSIMD stuff.

Having a random vector length could be good for testing ;)

I was tempted to add that as a deliberate feature, but that sort of
nothing doesn't really belong in the kernel...


Anyway:

The main reasons for constraining the vector length are a) to hide
mismatches between CPUs in heterogeneous systems, b) to ensure that
validated software doesn't run with a vector length it wasn't validated
for, and c) testing.

For kernel code, it's reasonable to say that all code should be vector-
length agnostic unless there's a really good reason not to be.  So we
may not care too much about (b).

In that case, just setting ZCR_EL1.LEN to max in kernel_sve_begin() (or
whatever) probably makes sense.

For (c), it might be useful to have a command-line parameter or debugfs
widget to constrain the vector length for kernel code; perhaps globally
or perhaps per driver or algo.


Otherwise, I agree that using SVE in the kernel _should_ probably work
safely, using the same basic mechanism as kernel_mode_neon().  Also,
it shouldn't have higher overheads than kernel-mode-NEON now.


> 
> > I think it would be preferable to see this algo accelerated for NEON
> > first, since all AArch64 hardware can benefit from that.
> 
> ...
> 
> > much of a problem.  kernel_neon_begin() may incur a save of the full SVE
> > state anyway, so in some ways it would be a good thing if we could
> > actually make use of all those registers.
> 
> > SVE hardware remains rare, so as a general policy I don't think we
> > should accept SVE implementations of any algorithm that does not
> > already have a NEON implementation -- unless the contributor can
> > explain why nobody with non-SVE hardware is going to care about the
> > performance of that algo.
> 
> I tend to agree here, my concerns are around the cost of maintaining a
> SVE implementation relative to the number of users who'd benefit from it
> rather than around the basic idea of using SVE at all.  If we were
> seeing substantial performance benefits over an implementation using
> NEON, or had some other strong push to use SVE like a really solid
> understanding of why SVE is a good fit for the algorithm but NEON isn't,
> then it'd be worth finishing up the infrastructure.  The infrastructure
> itself doesn't seem fundamentally problematic.

Agreed

Nonetheless, working up a candidate algorithm to help us see whether
there is a good use case seems like a worthwhile project, so I don't
want to discourage that too much.

Cheers
---Dave
