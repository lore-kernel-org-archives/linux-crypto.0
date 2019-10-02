Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63923C4360C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 21:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B7292070B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 21:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfJBVdE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 17:33:04 -0400
Received: from foss.arm.com ([217.140.110.172]:55336 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfJBVdE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 17:33:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BC251000;
        Wed,  2 Oct 2019 14:33:03 -0700 (PDT)
Received: from mbp (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F54C3F534;
        Wed,  2 Oct 2019 14:33:02 -0700 (PDT)
Date:   Wed, 2 Oct 2019 22:32:55 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
Message-ID: <20191002213255.GA6931@mbp>
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
 <CAKwvOdmr2VX0MObnRScW4suijOLQL24HL3+TPKk8Rkcz0_0ZbA@mail.gmail.com>
 <20191002172333.GB3386@arrakis.emea.arm.com>
 <CAKv+Gu_Tytff_hiTETu0h=Wvyr47ygBNGO-EVhJf4hMXug0D6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Tytff_hiTETu0h=Wvyr47ygBNGO-EVhJf4hMXug0D6w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 08:09:18PM +0200, Ard Biesheuvel wrote:
> On Wed, 2 Oct 2019 at 19:23, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, Oct 02, 2019 at 09:47:41AM -0700, Nick Desaulniers wrote:
> > > I'm running into some inconsistencies between how clang parses target
> > > arch between command line flag, function __attribute__, assembler
> > > directive, and disassembler.  I see arch's like: armv8-a+crc,
> > > armv8-a+sve, armv8-a+fp16, armv8-a+memtag, armv8-a+lse, but I'm not
> > > familiar with the `+...` part of the target arch.
> >
> > This page shows the possible combinations:
> >
> > https://sourceware.org/binutils/docs/as/AArch64-Extensions.html#AArch64-Extensions
> >
> > Basically if it's an optional feature in ARMv8.0, you pass armv8-a+...
> > For optional features only in higher versions, it would be
> > armv8.5-a+memtag. The table above also states whether it's enabled by
> > default (i.e. mandatory) in an architecture version. SB for example is
> > supported from 8.0 but only required in 8.5.
> 
> I am not convinced (but I haven't checked) that this is used in the
> same way on 32-bit.

Ah, I didn't realise this was about 32-bit. I don't think the above
applies in this case.

-- 
Catalin
