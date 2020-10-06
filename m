Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45465C41604
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 09:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08DC8206B5
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 09:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFJiW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:38:22 -0400
Received: from foss.arm.com ([217.140.110.172]:43058 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgJFJiW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 05:38:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C931113E;
        Tue,  6 Oct 2020 02:38:22 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC4E23F71F;
        Tue,  6 Oct 2020 02:38:20 -0700 (PDT)
Date:   Tue, 6 Oct 2020 10:38:17 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect
 branches
Message-ID: <20201006093817.GV6642@arm.com>
References: <20201005181804.1331237-1-jeremy.linton@arm.com>
 <CAMj1kXEkrRvp5Xd_+D_V7Nr1uiKnfAEdZU4kciC5R7_H8aRNZA@mail.gmail.com>
 <c7959ca7-5212-0dfb-2ebc-6247083d356b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7959ca7-5212-0dfb-2ebc-6247083d356b@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 05, 2020 at 02:24:47PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 10/5/20 1:54 PM, Ard Biesheuvel wrote:
> >On Mon, 5 Oct 2020 at 20:18, Jeremy Linton <jeremy.linton@arm.com> wrote:
> >>
> >>The AES code uses a 'br x7' as part of a function called by
> >>a macro, that ends up needing a BTI_J as a target.
> >
> >Could we instead just drop the tail call, i.e, replace it with a ret
> >and do a 'bl' after it returns? The indirect call does not really
> >serve a purpose here anyway
> 
> Yes, that is an option, it adds an extra ret. Which probably doesn't mean
> much in most cases. I assumed this code was optimized this way because it
> mattered somewhere.

Since this really does seem to be a tail-call and since x16 and x17
appear to be otherwise unused here, can we not just use x16 or x17
instead of x7?

This relies on there being no other calls to veneered functions in the
mix, but this code is all in a single section so that shouldn't be a
concern.

Due to the magic status of x16 and x17 in br instructions, the resulting
jump should be compatible with BTI c.  I think this matches how the
compiler should typically compile tail-calls.

Cheers
---Dave
