Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505F4C10F14
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 18:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25DA521848
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 18:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XmAGwmR9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJBSJd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 14:09:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32793 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBSJd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 14:09:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so119706wrs.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 11:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aqoM8oLbrDx7ZQ2SkBSfm2NBm8BYf6NxPoPrVnxfYVk=;
        b=XmAGwmR9HsE9sSlchJc9ny/vg8idckIdz7Aap/XdsSxcSI+yuCqHV6ybSNALkD3aEQ
         vcmhuyUabu3TUw/b4awVUJJBhWPXILpacbkGJyFEKnf1swaPr+rIPbWPjWt/NiuYndxu
         KoqcUnnwPYcWlGAcHIUYcyaOAwiDrTItCxJZxyGC2VbmySXkfMVvlMvGu6Mi6mk3hzro
         xp2zGikWj7h2EfQB520UzvatDXYW9w1uLTJkb1Fgtsu4ALhcf5ugbKUAvNfYzFYAgSXs
         US/cqsgO5gB/ATbC5c833ks33lWUzlvnIT/31e4v7MxLGmJbIhxnEQmh4lCOfgkxq1lL
         O1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aqoM8oLbrDx7ZQ2SkBSfm2NBm8BYf6NxPoPrVnxfYVk=;
        b=BM86EiVKEb0aSyJMlbuWwYbij5+av5SBRuBwk8joThSugjZuEIONgg4S1KJtgZUBFb
         5zou3D5YF6JGF3xdGRobcqq/V2034ZoKJCLt1qMHitrkFda0hhHLYcWDh557ZIsdQXAX
         4OZnh3rpN1y+4OjFR7oywU4Rc0cHsUZqOsaJ8audYmTOA/KZNzADeOlBHM5ScNQQ0rA6
         FlNs7PsEEg4w8+vyqTUzepF1MM6NOohI+spNJf0JctXpJJSwWgZFZUsMRu8koBzB0GWL
         mwseVctdPkiSDyO2Htc1rVZ//KqTA0WZ741VHtNAQQl9gsr+8dMdljJrZKvYMNftDmVj
         Y6vw==
X-Gm-Message-State: APjAAAWTl+RJzY9WrjMc7MZlaJe8fbusJsSz9AWqNuTNCfo6OSA/533v
        CdCE9LihhRDDmm5mWUNzAY2SbTehFCRXcdI6VgEarg==
X-Google-Smtp-Source: APXvYqxylAhXvafW2I/xcph16wU6SVIz+GY1WjzZN4o/4/0ksP3I00ysDYni9hY0xVEqugUVvMDHmjXPMt8uAjWCOyo=
X-Received: by 2002:adf:fe88:: with SMTP id l8mr3561354wrr.32.1570039770886;
 Wed, 02 Oct 2019 11:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
 <CAKwvOdmr2VX0MObnRScW4suijOLQL24HL3+TPKk8Rkcz0_0ZbA@mail.gmail.com> <20191002172333.GB3386@arrakis.emea.arm.com>
In-Reply-To: <20191002172333.GB3386@arrakis.emea.arm.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 2 Oct 2019 20:09:18 +0200
Message-ID: <CAKv+Gu_Tytff_hiTETu0h=Wvyr47ygBNGO-EVhJf4hMXug0D6w@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Oct 2019 at 19:23, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Wed, Oct 02, 2019 at 09:47:41AM -0700, Nick Desaulniers wrote:
> > On Wed, Oct 2, 2019 at 12:55 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Now that the Clang compiler has taken it upon itself to police the
> > > compiler command line, and reject combinations for arguments it views
> > > as incompatible, the AEGIS128 no longer builds correctly, and errors
> > > out like this:
> > >
> > >   clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
> > >   architecture does not support it [-Winvalid-command-line-argument]
> > >
> > > So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
> > > FPU profile we specify. Since neither were actually supported by GCC
> > > versions before 4.8, let's tighten the Kconfig dependencies as well so
> > > we won't run into errors when building with an ancient compiler.
> > >
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Thank you Ard, this fixes the build error for us.  Do you know if the
> > "crypto extensions" are mandatory ISA extensions?
>
> I think they are optional (or at least most of them).
>

This is 32-bit ARM so I don't think any of the extensions are
mandatory. And the crypto ones are export controlled, so they are
definitely not mandatory, except for certain combinations (PMULL
requires AES, and SHA512 requires SHA256).

I don't think 32-bit ARM cores with crypto extensions are widely
available in the field, but since the intrinsics can be compiled to
either ISA, it was rather trivial to retain support for it (and 32-bit
VMs running on a 64-bit hosts may benefit as well)

> > I'm running into some inconsistencies between how clang parses target
> > arch between command line flag, function __attribute__, assembler
> > directive, and disassembler.  I see arch's like: armv8-a+crc,
> > armv8-a+sve, armv8-a+fp16, armv8-a+memtag, armv8-a+lse, but I'm not
> > familiar with the `+...` part of the target arch.
>
> This page shows the possible combinations:
>
> https://sourceware.org/binutils/docs/as/AArch64-Extensions.html#AArch64-Extensions
>
> Basically if it's an optional feature in ARMv8.0, you pass armv8-a+...
> For optional features only in higher versions, it would be
> armv8.5-a+memtag. The table above also states whether it's enabled by
> default (i.e. mandatory) in an architecture version. SB for example is
> supported from 8.0 but only required in 8.5.
>

I am not convinced (but I haven't checked) that this is used in the
same way on 32-bit.
