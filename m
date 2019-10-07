Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE445C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 05:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89EC92133F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 05:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nOohKweY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJGFYM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 01:24:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39837 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGFYM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 01:24:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so10895782wml.4
        for <linux-crypto@vger.kernel.org>; Sun, 06 Oct 2019 22:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F/OfvLOABhucYfH5q8nqlEfLvtY/EvmJ3skaU3XkvVE=;
        b=nOohKweYeu+/mk3W7PBLqMW5qEJU1l/NsG/gYTMAMdP25/MEjLYH4GvqtJTnvU4l5y
         vx4SfXaG54qyNJUCkvik8NeVOjpWPG8W57g70IBCp89XeAo0ENgs9rJHCPFc9SvS3E7B
         uttSyCr3sxSehoIrZe8rxHn19Hwd/HM1FZlkjx2x+zmmvl0HIxro3AzTKhodHaUnpp/p
         YaU4fpNV28bYEmkDuvXtRHS3VwaIf5FiPIv8XlSVOkrUMkmfK3gONEh4TEmxkgHdT7Qk
         /Op7Use9ecj49f2fSHNVJb6lQ2NRJqz4p/JWDBBalOteoBP4fKtl05DZi8XgEwK0CYVx
         C5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F/OfvLOABhucYfH5q8nqlEfLvtY/EvmJ3skaU3XkvVE=;
        b=RMSXvVwfpLaKDAttsdraQ6j6g/uOPrXLRdtX+ZXEdlg0SXllzVCvkwlpVs79wV2clD
         X2EDMPcTrWp0wPn1HuiqeCDxbG9Aiq3wWZvDp4uVQV1zivT4ii4GEdeohrjRAyha3msg
         8qL2gIFMXsl3kGDu6itMtnSdvCrf777/OlCcJxDWU7Df9Zp25xhktVCYSHJ04XmNHM8U
         ovUS6hWt+WjlsNOahUlSiI/hp07gEWf0lDvDdc0yGze4pRo+a9DN9yS3SQ4rIdUky5yv
         9Yua7Noz6A8qV/6sLdnn2bt8xxO6xm49razkpMURnJZF8D5IbcfX3fybae5eSwJcfWWD
         aJtw==
X-Gm-Message-State: APjAAAXf59KlCehT6a9XdKoX5NaxfHThG3vm43r9LY7rUQC0v6CHosy8
        IvfVFR0nNic13vzH6QYu81LMNtZTTZQrMKIZTPUCburhnGw=
X-Google-Smtp-Source: APXvYqzysZIDBSW7SSnZ4od5pe3KomiHqO+e+fMuBCNQ0sh1GMTRbeFHgumya3CU66fNb7Dfi4ke74IxSTpdEJYQJPk=
X-Received: by 2002:a1c:2546:: with SMTP id l67mr19504021wml.10.1570425847826;
 Sun, 06 Oct 2019 22:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
 <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net>
In-Reply-To: <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 7 Oct 2019 07:23:56 +0200
Message-ID: <CAKv+Gu8s6AuZfdVUSmpgi-eY_9oZr-j4sdFygUOR3uvQXji+rQ@mail.gmail.com>
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

On Mon, 7 Oct 2019 at 06:44, Andy Lutomirski <luto@amacapital.net> wrote:
>
>
>
> > On Oct 5, 2019, at 12:24 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org>=
 wrote:
> >
> > =EF=BB=BFOn Fri, 4 Oct 2019 at 16:56, Ard Biesheuvel <ard.biesheuvel@li=
naro.org> wrote:
> >>
> >>> On Fri, 4 Oct 2019 at 16:53, Andy Lutomirski <luto@amacapital.net> wr=
ote:
> >>>
> >>>
> >>>
> >>>> On Oct 4, 2019, at 6:52 AM, Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> >>>>
> >>>> =EF=BB=BFOn Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c=
4.com> wrote:
> >>>>>
> >>>>>> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
> >>>>>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro=
.org> wrote:
> >>>>>>>
> >>>>>> ...
> >>>>>>>
> >>>>>>> In the future, I would like to extend these interfaces to use sta=
tic calls,
> >>>>>>> so that the accelerated implementations can be [un]plugged at run=
time. For
> >>>>>>> the time being, we rely on weak aliases and conditional exports s=
o that the
> >>>>>>> users of the library interfaces link directly to the accelerated =
versions,
> >>>>>>> but without the ability to unplug them.
> >>>>>>>
> >>>>>>
> >>>>>> As it turns out, we don't actually need static calls for this.
> >>>>>> Instead, we can simply permit weak symbol references to go unresol=
ved
> >>>>>> between modules (as we already do in the kernel itself, due to the
> >>>>>> fact that ELF permits it), and have the accelerated code live in
> >>>>>> separate modules that may not be loadable on certain systems, or b=
e
> >>>>>> blacklisted by the user.
> >>>>>
> >>>>> You're saying that at module insertion time, the kernel will overri=
de
> >>>>> weak symbols with those provided by the module itself? At runtime?
> >>>>>
> >>>>
> >>>> Yes.
> >>>>
> >>>>> Do you know offhand how this patching works? Is there a PLT that ge=
ts
> >>>>> patched, and so the calls all go through a layer of function pointe=
r
> >>>>> indirection? Or are all call sites fixed up at insertion time and t=
he
> >>>>> call instructions rewritten with some runtime patching magic?
> >>>>>
> >>>>
> >>>> No magic. Take curve25519 for example, when built for ARM:
> >>>>
> >>>> 00000000 <curve25519>:
> >>>>  0:   f240 0300       movw    r3, #0
> >>>>                       0: R_ARM_THM_MOVW_ABS_NC        curve25519_arc=
h
> >>>>  4:   f2c0 0300       movt    r3, #0
> >>>>                       4: R_ARM_THM_MOVT_ABS   curve25519_arch
> >>>>  8:   b570            push    {r4, r5, r6, lr}
> >>>>  a:   4604            mov     r4, r0
> >>>>  c:   460d            mov     r5, r1
> >>>>  e:   4616            mov     r6, r2
> >>>> 10:   b173            cbz     r3, 30 <curve25519+0x30>
> >>>> 12:   f7ff fffe       bl      0 <curve25519_arch>
> >>>>                       12: R_ARM_THM_CALL      curve25519_arch
> >>>> 16:   b158            cbz     r0, 30 <curve25519+0x30>
> >>>> 18:   4620            mov     r0, r4
> >>>> 1a:   2220            movs    r2, #32
> >>>> 1c:   f240 0100       movw    r1, #0
> >>>>                       1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
> >>>> 20:   f2c0 0100       movt    r1, #0
> >>>>                       20: R_ARM_THM_MOVT_ABS  .LANCHOR0
> >>>> 24:   f7ff fffe       bl      0 <__crypto_memneq>
> >>>>                       24: R_ARM_THM_CALL      __crypto_memneq
> >>>> 28:   3000            adds    r0, #0
> >>>> 2a:   bf18            it      ne
> >>>> 2c:   2001            movne   r0, #1
> >>>> 2e:   bd70            pop     {r4, r5, r6, pc}
> >>>> 30:   4632            mov     r2, r6
> >>>> 32:   4629            mov     r1, r5
> >>>> 34:   4620            mov     r0, r4
> >>>> 36:   f7ff fffe       bl      0 <curve25519_generic>
> >>>>                       36: R_ARM_THM_CALL      curve25519_generic
> >>>> 3a:   e7ed            b.n     18 <curve25519+0x18>
> >>>>
> >>>> curve25519_arch is a weak reference. It either gets satisfied at
> >>>> module load time, or it doesn't.
> >>>>
> >>>> If it does get satisfied, the relocations covering the movw/movt pai=
r
> >>>> and the one covering the bl instruction get updated so that they poi=
nt
> >>>> to the arch routine.
> >>>>
> >>>> If it does not get satisfied, the relocations are disregarded, in
> >>>> which case the cbz instruction at offset 0x10 jumps over the bl call=
.
> >>>>
> >>>> Note that this does not involve any memory accesses. It does involve
> >>>> some code patching, but only of the kind the module loader already
> >>>> does.
> >>>
> >>> Won=E2=80=99t this have the counterintuitive property that, if you lo=
ad the modules in the opposite order, the reference won=E2=80=99t be re-res=
olved and performance will silently regress?
> >>>
> >>
> >> Indeed, the arch module needs to be loaded first
> >>
> >
> > Actually, this can be addressed by retaining the module dependencies
> > as before, but permitting the arch module to be omitted at load time.
>
> I think that, to avoid surprises, you should refuse to load the arch modu=
le if the generic module is loaded, too.
>

Most arch code depends on CPU features that may not be available given
the context, either because they are SIMD or because they are optional
CPU instructions. So we need both modules at the same time anyway, so
that we can fall back to the generic code at runtime.

So what I'd like is to have the generic module provide the library
interface, but rely on arch modules that are optional.

We already have 95% of what we need with weak references. We have the
ability to test for presence of the arch code at runtime, and we even
have code patching for all architectures (through static relocations).

However, one could argue that this is more a [space] optimization than
anything else, so I am willing to park this discussion until support
for static calls has been merged, and proceed with something simpler.
