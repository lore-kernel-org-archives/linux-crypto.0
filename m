Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB5AC4741F
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 17:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1482074B
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 17:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKER4y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Nov 2020 12:56:54 -0500
Received: from foss.arm.com ([217.140.110.172]:38944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKER4y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Nov 2020 12:56:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F7DC14BF;
        Thu,  5 Nov 2020 09:56:53 -0800 (PST)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B88293F719;
        Thu,  5 Nov 2020 09:56:51 -0800 (PST)
Date:   Thu, 5 Nov 2020 17:56:48 +0000
From:   Dave Martin <Dave.Martin@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        l00374334 <liqiang64@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201105175647.GI6882@arm.com>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
 <20201103180031.GO6882@arm.com>
 <20201104175032.GA15020@sirena.org.uk>
 <20201104181256.GG6882@arm.com>
 <20201104184905.GB4812@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104184905.GB4812@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 04, 2020 at 06:49:05PM +0000, Mark Brown wrote:
> On Wed, Nov 04, 2020 at 06:13:06PM +0000, Dave Martin wrote:
> > On Wed, Nov 04, 2020 at 05:50:33PM +0000, Mark Brown wrote:
> 
> > > I think at a minimum we'd want to handle the vector length explicitly
> > > for kernel mode SVE, vector length independent code will work most of
> > > the time but at the very least it feels like a landmine waiting to cause
> > > trouble.  If nothing else there's probably going to be cases where it
> > > makes a difference for performance.  Other than that I'm not currently
> 
> ...
> 
> > The main reasons for constraining the vector length are a) to hide
> > mismatches between CPUs in heterogeneous systems, b) to ensure that
> > validated software doesn't run with a vector length it wasn't validated
> > for, and c) testing.
> 
> > For kernel code, it's reasonable to say that all code should be vector-
> > length agnostic unless there's a really good reason not to be.  So we
> > may not care too much about (b).
> 
> > In that case, just setting ZCR_EL1.LEN to max in kernel_sve_begin() (or
> > whatever) probably makes sense.
> 
> I agree, that's most likely a good default.
> 
> > For (c), it might be useful to have a command-line parameter or debugfs
> > widget to constrain the vector length for kernel code; perhaps globally
> > or perhaps per driver or algo.
> 
> I think a global control would be good for testing, it seems simpler and
> easier all round.  The per thing tuning seems more useful for cases
> where we run into something like a performance reason to use a limited
> set of vector lengths but I think we should only add that when we have
> at least one user for it, some examples of actual restrictions we want
> would probably be helpful for designing the interface.

Ack; note that an algo that wants to use a particular vector length can
do so by means of the special predicate patterns VLnnn, POW2, MUL3 etc.
So setting an explicit limit in ZCR_EL1.LEN should hopefully be an
uncommon requirement.

> 
> > Nonetheless, working up a candidate algorithm to help us see whether
> > there is a good use case seems like a worthwhile project, so I don't
> > want to discourage that too much.
> 
> Definitely worth exploring.

Cheers
---Dave
