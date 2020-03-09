Return-Path: <SRS0=CB0V=42=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA20EC10F27
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 17:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D10D920727
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 17:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgCIRwI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 13:52:08 -0400
Received: from foss.arm.com ([217.140.110.172]:55246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbgCIRwI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 13:52:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 743421FB;
        Mon,  9 Mar 2020 10:52:07 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC8933F67D;
        Mon,  9 Mar 2020 10:52:05 -0700 (PDT)
Date:   Mon, 9 Mar 2020 17:52:03 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
Message-ID: <20200309175203.GE4124965@arrakis.emea.arm.com>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
 <20200228133718.GB4019108@arrakis.emea.arm.com>
 <20200228152219.GA4956@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228152219.GA4956@sirena.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 28, 2020 at 03:22:19PM +0000, Mark Brown wrote:
> On Fri, Feb 28, 2020 at 01:37:18PM +0000, Catalin Marinas wrote:
> > I wonder whether it would be easier to merge all these patches at
> > 5.7-rc1, once most of the major changes went in.
> 
> Only thing I can think that doing that might cause issue with is if
> people are doing work that's not likely to make it in this cycle then
> it'd be some extra rebasing or carrying of out of tree patches they'd
> need to do (plus obviously this series might pick up new conflicts
> itself).  It's not a completely automated process unfortunately,
> especially with trying to fix up some of the problems with the existing
> annotations changing the output.  But yeah, we could do that.

I queued this series for 5.7, apart from patch 12. I'll try to fix any
conflicts with whatever patches I'm adding but may drop some of them if
they conflict badly with code in -next (not likely). We'll revisit at
-rc1 to see what's left.

Thanks.

-- 
Catalin
