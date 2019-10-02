Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC688C352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 17:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95A0B21848
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 17:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfJBRXh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 13:23:37 -0400
Received: from foss.arm.com ([217.140.110.172]:50256 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBRXh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 13:23:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9970F1000;
        Wed,  2 Oct 2019 10:23:36 -0700 (PDT)
Received: from arrakis.emea.arm.com (unknown [10.1.196.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 963D23F706;
        Wed,  2 Oct 2019 10:23:35 -0700 (PDT)
Date:   Wed, 2 Oct 2019 18:23:33 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
Message-ID: <20191002172333.GB3386@arrakis.emea.arm.com>
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
 <CAKwvOdmr2VX0MObnRScW4suijOLQL24HL3+TPKk8Rkcz0_0ZbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmr2VX0MObnRScW4suijOLQL24HL3+TPKk8Rkcz0_0ZbA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 09:47:41AM -0700, Nick Desaulniers wrote:
> On Wed, Oct 2, 2019 at 12:55 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Now that the Clang compiler has taken it upon itself to police the
> > compiler command line, and reject combinations for arguments it views
> > as incompatible, the AEGIS128 no longer builds correctly, and errors
> > out like this:
> >
> >   clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
> >   architecture does not support it [-Winvalid-command-line-argument]
> >
> > So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
> > FPU profile we specify. Since neither were actually supported by GCC
> > versions before 4.8, let's tighten the Kconfig dependencies as well so
> > we won't run into errors when building with an ancient compiler.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Thank you Ard, this fixes the build error for us.  Do you know if the
> "crypto extensions" are mandatory ISA extensions? 

I think they are optional (or at least most of them).

> I'm running into some inconsistencies between how clang parses target
> arch between command line flag, function __attribute__, assembler
> directive, and disassembler.  I see arch's like: armv8-a+crc,
> armv8-a+sve, armv8-a+fp16, armv8-a+memtag, armv8-a+lse, but I'm not
> familiar with the `+...` part of the target arch.

This page shows the possible combinations:

https://sourceware.org/binutils/docs/as/AArch64-Extensions.html#AArch64-Extensions

Basically if it's an optional feature in ARMv8.0, you pass armv8-a+...
For optional features only in higher versions, it would be
armv8.5-a+memtag. The table above also states whether it's enabled by
default (i.e. mandatory) in an architecture version. SB for example is
supported from 8.0 but only required in 8.5.

-- 
Catalin
