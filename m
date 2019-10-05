Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99998C47404
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 07:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF2D2084D
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 07:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JOgox7h0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfJEHYt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 03:24:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34925 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfJEHYs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 03:24:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so9609695wrt.2
        for <linux-crypto@vger.kernel.org>; Sat, 05 Oct 2019 00:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oXumP7isg67q+b5DBmTeeHFwTKSHVytPFJVSkr9ZKk0=;
        b=JOgox7h0oOMz7oKv3Y45i2QVRArBN8yYCfoZGBMIyUoN3NuMMT8TC2BLoSCAZjMTfY
         PIwlM6PNLEmEvjTcx1Y76IAFAzNrAoH7cuT/ggasYvhFYqoJq9EPmzR49ohFFnSFRXoT
         vV/AkISginXU/yBKeAYThKvYPPaykwrm3oeNVt129mcqsP4IR3+N9SNNR/PeMwknSXe5
         xwNC1uArAn5vK9fhEDxrOCY62QGUPm99eXAF2pS1PZ4MEmHVG1FzxCwu0iy7JZZb6OQo
         PtB3EXY2Akze6b6u4iARBu/2/hWncMbJGzGhem0oSwHZOiOXSbrkCp8BZtXwVBx1F2Fe
         3rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oXumP7isg67q+b5DBmTeeHFwTKSHVytPFJVSkr9ZKk0=;
        b=ZQ1Tf+WwYMLCu0PksVz+iFwlaneW2jISzV0+IMM409sSmCisjLK+k/pBFkXJbrX1hD
         EQVMqW5AGEcv/9r4acp+Sz1Gv6FA0aGn7g6LV4UtL+s6VzXa4YDtkx+Gckj+akbiXGxr
         /FqRFIEbP6hQRoWtdcWmtOr/wSY+1w8JnB+14hAi35lXS28JtXdz4pcT6QZ4vTMjh6PX
         TdwuFB2ZK15LXuHtG5BBNaHXKaz+Yg2CYgKn06DDAWnR44QVjA/uhV3jXlA2HRM0gkDB
         vZ5/ssvikwCPwm2o1BrzY3QbCVpsJFk9F+YZpD7SswI0NhZleCF6ITYRr54a8LNdm+yl
         IDtw==
X-Gm-Message-State: APjAAAVGMP24atUdRTyEKS3OropoRWUuqAbYCvLtjS5iI8I4lIZmcHgZ
        y7fZ8WOHt+/A6Q+OefN9A5ICNAaavdc49bzU8f8K/Q==
X-Google-Smtp-Source: APXvYqxWTbUljZ2Wv7s9oAU86Z4Klxhnv5w9UUlf9hJ5oxfy7or01JMFmjmf4GsTF1r8VozW2dB3utA7VyttWvqXNwg=
X-Received: by 2002:adf:e5cb:: with SMTP id a11mr14254198wrn.200.1570260285679;
 Sat, 05 Oct 2019 00:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
 <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net> <CAKv+Gu87Co3BobUeC_x2TLE9vy-sDHzj3aiK=LFetwC2jz3aig@mail.gmail.com>
In-Reply-To: <CAKv+Gu87Co3BobUeC_x2TLE9vy-sDHzj3aiK=LFetwC2jz3aig@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 5 Oct 2019 09:24:33 +0200
Message-ID: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 16:56, Ard Biesheuvel <ard.biesheuvel@linaro.org> wro=
te:
>
> On Fri, 4 Oct 2019 at 16:53, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> >
> >
> > > On Oct 4, 2019, at 6:52 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org=
> wrote:
> > >
> > > =EF=BB=BFOn Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c4=
.com> wrote:
> > >>
> > >>> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
> > >>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.=
org> wrote:
> > >>>>
> > >>> ...
> > >>>>
> > >>>> In the future, I would like to extend these interfaces to use stat=
ic calls,
> > >>>> so that the accelerated implementations can be [un]plugged at runt=
ime. For
> > >>>> the time being, we rely on weak aliases and conditional exports so=
 that the
> > >>>> users of the library interfaces link directly to the accelerated v=
ersions,
> > >>>> but without the ability to unplug them.
> > >>>>
> > >>>
> > >>> As it turns out, we don't actually need static calls for this.
> > >>> Instead, we can simply permit weak symbol references to go unresolv=
ed
> > >>> between modules (as we already do in the kernel itself, due to the
> > >>> fact that ELF permits it), and have the accelerated code live in
> > >>> separate modules that may not be loadable on certain systems, or be
> > >>> blacklisted by the user.
> > >>
> > >> You're saying that at module insertion time, the kernel will overrid=
e
> > >> weak symbols with those provided by the module itself? At runtime?
> > >>
> > >
> > > Yes.
> > >
> > >> Do you know offhand how this patching works? Is there a PLT that get=
s
> > >> patched, and so the calls all go through a layer of function pointer
> > >> indirection? Or are all call sites fixed up at insertion time and th=
e
> > >> call instructions rewritten with some runtime patching magic?
> > >>
> > >
> > > No magic. Take curve25519 for example, when built for ARM:
> > >
> > > 00000000 <curve25519>:
> > >   0:   f240 0300       movw    r3, #0
> > >                        0: R_ARM_THM_MOVW_ABS_NC        curve25519_arc=
h
> > >   4:   f2c0 0300       movt    r3, #0
> > >                        4: R_ARM_THM_MOVT_ABS   curve25519_arch
> > >   8:   b570            push    {r4, r5, r6, lr}
> > >   a:   4604            mov     r4, r0
> > >   c:   460d            mov     r5, r1
> > >   e:   4616            mov     r6, r2
> > >  10:   b173            cbz     r3, 30 <curve25519+0x30>
> > >  12:   f7ff fffe       bl      0 <curve25519_arch>
> > >                        12: R_ARM_THM_CALL      curve25519_arch
> > >  16:   b158            cbz     r0, 30 <curve25519+0x30>
> > >  18:   4620            mov     r0, r4
> > >  1a:   2220            movs    r2, #32
> > >  1c:   f240 0100       movw    r1, #0
> > >                        1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
> > >  20:   f2c0 0100       movt    r1, #0
> > >                        20: R_ARM_THM_MOVT_ABS  .LANCHOR0
> > >  24:   f7ff fffe       bl      0 <__crypto_memneq>
> > >                        24: R_ARM_THM_CALL      __crypto_memneq
> > >  28:   3000            adds    r0, #0
> > >  2a:   bf18            it      ne
> > >  2c:   2001            movne   r0, #1
> > >  2e:   bd70            pop     {r4, r5, r6, pc}
> > >  30:   4632            mov     r2, r6
> > >  32:   4629            mov     r1, r5
> > >  34:   4620            mov     r0, r4
> > >  36:   f7ff fffe       bl      0 <curve25519_generic>
> > >                        36: R_ARM_THM_CALL      curve25519_generic
> > >  3a:   e7ed            b.n     18 <curve25519+0x18>
> > >
> > > curve25519_arch is a weak reference. It either gets satisfied at
> > > module load time, or it doesn't.
> > >
> > > If it does get satisfied, the relocations covering the movw/movt pair
> > > and the one covering the bl instruction get updated so that they poin=
t
> > > to the arch routine.
> > >
> > > If it does not get satisfied, the relocations are disregarded, in
> > > which case the cbz instruction at offset 0x10 jumps over the bl call.
> > >
> > > Note that this does not involve any memory accesses. It does involve
> > > some code patching, but only of the kind the module loader already
> > > does.
> >
> > Won=E2=80=99t this have the counterintuitive property that, if you load=
 the modules in the opposite order, the reference won=E2=80=99t be re-resol=
ved and performance will silently regress?
> >
>
> Indeed, the arch module needs to be loaded first
>

Actually, this can be addressed by retaining the module dependencies
as before, but permitting the arch module to be omitted at load time.

> > I think it might be better to allow two different modules to export the=
 same symbol but only allow one of them to be loaded.
>
> That is what I am doing for chacha and poly
>
> > Or use static calls.

Given that static calls don't actually exist yet, I propose to proceed
with the approach above, and switch to static calls once all
architectures where it matters have an implementation that does not
use function pointers (which is how static calls will be implemented
generically)
