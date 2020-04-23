Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D8BC54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075BA20857
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgDWL7N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 07:59:13 -0400
Received: from foss.arm.com ([217.140.110.172]:38452 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgDWL7N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 07:59:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B77CD31B;
        Thu, 23 Apr 2020 04:59:12 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4D003F6CF;
        Thu, 23 Apr 2020 04:59:11 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:59:05 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200423115905.GE4963@gaia>
References: <20200325114110.23491-1-broonie@kernel.org>
 <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
 <20200422180027.GH3585@gaia>
 <20200423111803.GG4808@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423111803.GG4808@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 23, 2020 at 12:18:03PM +0100, Mark Brown wrote:
> On Wed, Apr 22, 2020 at 07:00:28PM +0100, Catalin Marinas wrote:
> > On Wed, Mar 25, 2020 at 11:50:38AM +0000, Mark Brown wrote:
> > > Since BTI is a mandatory feature of v8.5 there is no BTI arch_extension,
> > > you can only enable it by moving the base architecture to v8.5.  You'd
> > > need to use .arch and that feels likely to find us sharp edges to run
> > > into.
> 
> > For MTE, .arch armv8-a+memtag won't work since this is only available
> > with armv8.5-a. My preference would be to have the highest arch version
> > supported by the kernel in the assembler.h file, i.e. ".arch armv8.5-a"
> > followed by .arch_extension in each .S file, as needed.
> 
> I think we decided that .arch_extension was too new to be used for
> things like the crypto stuff where we still support older toolchains?

.arch_extension would be issued conditionally only for features like
CONFIG_ARM64_MTE which already have a dependency on a newer toolchain.

However, '.arch_extension memtag' is not sufficient for MTE, it needs a
prior '.arch armv8.5-a'.

> > Forcing .S files to armv8.5 would not cause any problems with
> > the base armv8.0 that the kernel image support since it shouldn't change
> > the opcodes gas generates. The .S files would use alternatives anyway
> > (or simply have code not called).
> 
> We do loose the checking that the assembler does that nobody used a
> newer feature by mistake but yeah, shouldn't affect the output.

We may need some push/pop_arch macros to contain the supported features.

The gas documentation says that .arch_extension may be used multiple
times to add or remove extensions. However, I couldn't find a way to
remove memtag after adding it (tried -memtag, !memtag, empty string). So
I may go with a '.arch armv8.0-a' as a base, followed by temporary
setting of '.arch armv8.5-a+memtag' (and hope we don't need combinations
of such extensions).

> > The inline asm is slightly more problematic, especially with the clang
> > builtin assembler which goes in a single pass. But we could do something
> > similar to what we did with the LSE atomics and raising the base of the
> > inline asm to armv8.5 (or 8.6 etc., whatever we need in the future).
> 
> FWIW I did something different to this for BTI so I wasn't using the
> instructions directly so I was going to abandon this series.

I can't work around this easily for MTE, there are more instructions
with register encoding. I'll see if the push/pop idea works or just
leave it to whoever does the next feature, figure out how it interacts
with MTE ;).

-- 
Catalin
