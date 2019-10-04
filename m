Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEC1C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB25A21D81
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aZl6BK2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388870AbfJDO40 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:56:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42909 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389533AbfJDO4Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:56:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id n14so7571270wrw.9
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bQVOZgeQsxDkkNYPHAzn+sJ4Z5dlrmGTmqGRADug4q0=;
        b=aZl6BK2PX6SUnjhTDa9QIKvQB/YU5D0dFwCTvgZKrkfYB1i4CVz6ql4Rd7S80UIDU3
         Zj4yzaUH7SCp0UPGmO3idiStVLvnheNoNYarTxFVJAbo76peXz7rGatZ+YXrTu+pM6FJ
         6qAfO4PTwh4x7fYPB7SUxCKQf5fwmc1XEHwxnlQtHvmClhdSDa87cIfFOlnsYeS/tnnr
         lGodQIOTZK6oXISZLFPn+naw78tqMIjNnVqmRddXtCOb/n0GWIJiXYD3EdfpZMbjSxsX
         6jFkUb1Sj4KDGJBmTaUKzpvF9sCKLakB9fSD4wxynyIdZyXrrLFnm8Eo+6m7s09vC49X
         1RYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bQVOZgeQsxDkkNYPHAzn+sJ4Z5dlrmGTmqGRADug4q0=;
        b=dZHNQjuASQPH49k+4xcWOp2qJLBHVo+PK/J5sg5P9Z/WKEAS8FprzFsYS3gyiqgtgg
         OlNMa0d33rjAp+dxjyySZAvZgyuCA+dacs3LMBHw4bw4DVsreLXwy3Fq1DieNB9BPrxr
         pZlB4LAjVDAcT6aeRTDie312I8YnJqPlMozfKmguCAEct3apLIocfpv08PZX80YuWXjR
         c3sF+fRKG6jUinStdhLmR5au5Y5HoMNEGNE9UPw7xFGpBX8ZhrobuGE8PFOvOKkvAkkz
         FPSjxy//3QdV+OpDfH+drxo4+Pfy90UanL9WW7dw6MfQGDITq0dlFML1QZIB35IGvgIM
         nF4w==
X-Gm-Message-State: APjAAAXOHJuF8WTA6B04Uhg2SAJEWUCAGXTtiIvbSNGPhLqgvhI635b/
        EiRNJihznDGWRgX6H8ADeei5ceUK47nY7fQx83QWScvp6GU2XQ==
X-Google-Smtp-Source: APXvYqy7/uwHolAmMOF5xoufCH6Zct5Aj6ePmcVQenHWNPHZQWvp8ySR2NSEgj93yWfyhdAVQDAh202SNlr1m4arix8=
X-Received: by 2002:adf:fb11:: with SMTP id c17mr12768170wrr.0.1570200983095;
 Fri, 04 Oct 2019 07:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
 <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net>
In-Reply-To: <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 16:56:10 +0200
Message-ID: <CAKv+Gu87Co3BobUeC_x2TLE9vy-sDHzj3aiK=LFetwC2jz3aig@mail.gmail.com>
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

On Fri, 4 Oct 2019 at 16:53, Andy Lutomirski <luto@amacapital.net> wrote:
>
>
>
> > On Oct 4, 2019, at 6:52 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> =
wrote:
> >
> > =EF=BB=BFOn Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c4.c=
om> wrote:
> >>
> >>> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
> >>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> >>>>
> >>> ...
> >>>>
> >>>> In the future, I would like to extend these interfaces to use static=
 calls,
> >>>> so that the accelerated implementations can be [un]plugged at runtim=
e. For
> >>>> the time being, we rely on weak aliases and conditional exports so t=
hat the
> >>>> users of the library interfaces link directly to the accelerated ver=
sions,
> >>>> but without the ability to unplug them.
> >>>>
> >>>
> >>> As it turns out, we don't actually need static calls for this.
> >>> Instead, we can simply permit weak symbol references to go unresolved
> >>> between modules (as we already do in the kernel itself, due to the
> >>> fact that ELF permits it), and have the accelerated code live in
> >>> separate modules that may not be loadable on certain systems, or be
> >>> blacklisted by the user.
> >>
> >> You're saying that at module insertion time, the kernel will override
> >> weak symbols with those provided by the module itself? At runtime?
> >>
> >
> > Yes.
> >
> >> Do you know offhand how this patching works? Is there a PLT that gets
> >> patched, and so the calls all go through a layer of function pointer
> >> indirection? Or are all call sites fixed up at insertion time and the
> >> call instructions rewritten with some runtime patching magic?
> >>
> >
> > No magic. Take curve25519 for example, when built for ARM:
> >
> > 00000000 <curve25519>:
> >   0:   f240 0300       movw    r3, #0
> >                        0: R_ARM_THM_MOVW_ABS_NC        curve25519_arch
> >   4:   f2c0 0300       movt    r3, #0
> >                        4: R_ARM_THM_MOVT_ABS   curve25519_arch
> >   8:   b570            push    {r4, r5, r6, lr}
> >   a:   4604            mov     r4, r0
> >   c:   460d            mov     r5, r1
> >   e:   4616            mov     r6, r2
> >  10:   b173            cbz     r3, 30 <curve25519+0x30>
> >  12:   f7ff fffe       bl      0 <curve25519_arch>
> >                        12: R_ARM_THM_CALL      curve25519_arch
> >  16:   b158            cbz     r0, 30 <curve25519+0x30>
> >  18:   4620            mov     r0, r4
> >  1a:   2220            movs    r2, #32
> >  1c:   f240 0100       movw    r1, #0
> >                        1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
> >  20:   f2c0 0100       movt    r1, #0
> >                        20: R_ARM_THM_MOVT_ABS  .LANCHOR0
> >  24:   f7ff fffe       bl      0 <__crypto_memneq>
> >                        24: R_ARM_THM_CALL      __crypto_memneq
> >  28:   3000            adds    r0, #0
> >  2a:   bf18            it      ne
> >  2c:   2001            movne   r0, #1
> >  2e:   bd70            pop     {r4, r5, r6, pc}
> >  30:   4632            mov     r2, r6
> >  32:   4629            mov     r1, r5
> >  34:   4620            mov     r0, r4
> >  36:   f7ff fffe       bl      0 <curve25519_generic>
> >                        36: R_ARM_THM_CALL      curve25519_generic
> >  3a:   e7ed            b.n     18 <curve25519+0x18>
> >
> > curve25519_arch is a weak reference. It either gets satisfied at
> > module load time, or it doesn't.
> >
> > If it does get satisfied, the relocations covering the movw/movt pair
> > and the one covering the bl instruction get updated so that they point
> > to the arch routine.
> >
> > If it does not get satisfied, the relocations are disregarded, in
> > which case the cbz instruction at offset 0x10 jumps over the bl call.
> >
> > Note that this does not involve any memory accesses. It does involve
> > some code patching, but only of the kind the module loader already
> > does.
>
> Won=E2=80=99t this have the counterintuitive property that, if you load t=
he modules in the opposite order, the reference won=E2=80=99t be re-resolve=
d and performance will silently regress?
>

Indeed, the arch module needs to be loaded first

> I think it might be better to allow two different modules to export the s=
ame symbol but only allow one of them to be loaded.

That is what I am doing for chacha and poly

> Or use static calls.
