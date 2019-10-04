Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2471C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86E61222C2
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 13:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T1B2A3Qh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388849AbfJDNwc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 09:52:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54319 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbfJDNwc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 09:52:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id p7so5931046wmp.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 06:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=evmVQTADAbH2bwbt5sski1rHfNC4vLA8SFu2OOlAWyc=;
        b=T1B2A3QhpvtfT7xaS3U8Q+be9NpmzHvU6SqkPP218KWKdpnIDZNblrHoM80yesInI0
         Gd2hGc73eh1GMgAkJ3Rj8CyCTC0lzlKYtW8lNwBB4rYAPCt0kYUjCWcad0sWyw1UR4HP
         BJR0jT2l/O3aPVtiFrwNKpq7LnF6b9+ZQeZLX/iIl5/pDsir8qJnw1aNFsrFp0l2kXSL
         Fexn5hhCO86qUoXJW1asIlugJizJJAUpU3/KT29X6/XFQY7lAHvqKZTBoTZuNOywBQsE
         zmcYUIAN5hZu2KMstxuaScwfKtR7OMg6w8R+RKFVr2QpY/9fjC8tVsH2nhXqObNlUAq9
         nSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=evmVQTADAbH2bwbt5sski1rHfNC4vLA8SFu2OOlAWyc=;
        b=E8MOeZE72AK5sU+1eF9u2XUcOWLI/olRtJgKlF/GUslWQOIJeHoHmj3Vp2BnJlAf4K
         a4iORSFKJEgs1X1DIDyVsuQXb3HbayIgUUGpKWZxAm1rJxCaNRIuLtvPGLYFCnn5Z5ea
         e/1xPy3VeLlT1qdtJ8nCm0PmFEXvSDZqa1PBJQey+RuAsEjA6KXWIgbY+mChyxmduAB9
         woSAY86kjJJNHiLfZPD77tz+xkbM2tt2eCJ3XZ4/uEI4D3cyx76Ya6V7NA0aPm+ZpuH4
         FAl4CA/32JiZenwR/LE3b05i7Lg8iVgEIyyi6XGj/SJuIVzpelkmAegsWh8WL73DiipC
         BVSg==
X-Gm-Message-State: APjAAAVg4Hr5sr+pQB/GLsv911mtDYE25mja73dprtdlqmhaMYPikoXO
        LL6n3RiOpbrNt15TsQIbbGGrR24uZg5b7D2limNDWw==
X-Google-Smtp-Source: APXvYqz7ysmg0Au5HnFggUnLaoYSO+7aRitoLPtaTfS+T9K+IXpfq+sLpjZ6+9BQWEiKvbHjnwa9e0BqFJ/RHRGa7sA=
X-Received: by 2002:a7b:c451:: with SMTP id l17mr10011017wmi.61.1570197149890;
 Fri, 04 Oct 2019 06:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu-+3AWNAK0WWSFQT15Q3r6ak7wGr3ZROyJ35-4GN6=iJQ@mail.gmail.com> <20191004134233.GD112631@zx2c4.com>
In-Reply-To: <20191004134233.GD112631@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 15:52:17 +0200
Message-ID: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
> > On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > ...
> > >
> > > In the future, I would like to extend these interfaces to use static calls,
> > > so that the accelerated implementations can be [un]plugged at runtime. For
> > > the time being, we rely on weak aliases and conditional exports so that the
> > > users of the library interfaces link directly to the accelerated versions,
> > > but without the ability to unplug them.
> > >
> >
> > As it turns out, we don't actually need static calls for this.
> > Instead, we can simply permit weak symbol references to go unresolved
> > between modules (as we already do in the kernel itself, due to the
> > fact that ELF permits it), and have the accelerated code live in
> > separate modules that may not be loadable on certain systems, or be
> > blacklisted by the user.
>
> You're saying that at module insertion time, the kernel will override
> weak symbols with those provided by the module itself? At runtime?
>

Yes.

> Do you know offhand how this patching works? Is there a PLT that gets
> patched, and so the calls all go through a layer of function pointer
> indirection? Or are all call sites fixed up at insertion time and the
> call instructions rewritten with some runtime patching magic?
>

No magic. Take curve25519 for example, when built for ARM:

00000000 <curve25519>:
   0:   f240 0300       movw    r3, #0
                        0: R_ARM_THM_MOVW_ABS_NC        curve25519_arch
   4:   f2c0 0300       movt    r3, #0
                        4: R_ARM_THM_MOVT_ABS   curve25519_arch
   8:   b570            push    {r4, r5, r6, lr}
   a:   4604            mov     r4, r0
   c:   460d            mov     r5, r1
   e:   4616            mov     r6, r2
  10:   b173            cbz     r3, 30 <curve25519+0x30>
  12:   f7ff fffe       bl      0 <curve25519_arch>
                        12: R_ARM_THM_CALL      curve25519_arch
  16:   b158            cbz     r0, 30 <curve25519+0x30>
  18:   4620            mov     r0, r4
  1a:   2220            movs    r2, #32
  1c:   f240 0100       movw    r1, #0
                        1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
  20:   f2c0 0100       movt    r1, #0
                        20: R_ARM_THM_MOVT_ABS  .LANCHOR0
  24:   f7ff fffe       bl      0 <__crypto_memneq>
                        24: R_ARM_THM_CALL      __crypto_memneq
  28:   3000            adds    r0, #0
  2a:   bf18            it      ne
  2c:   2001            movne   r0, #1
  2e:   bd70            pop     {r4, r5, r6, pc}
  30:   4632            mov     r2, r6
  32:   4629            mov     r1, r5
  34:   4620            mov     r0, r4
  36:   f7ff fffe       bl      0 <curve25519_generic>
                        36: R_ARM_THM_CALL      curve25519_generic
  3a:   e7ed            b.n     18 <curve25519+0x18>

curve25519_arch is a weak reference. It either gets satisfied at
module load time, or it doesn't.

If it does get satisfied, the relocations covering the movw/movt pair
and the one covering the bl instruction get updated so that they point
to the arch routine.

If it does not get satisfied, the relocations are disregarded, in
which case the cbz instruction at offset 0x10 jumps over the bl call.

Note that this does not involve any memory accesses. It does involve
some code patching, but only of the kind the module loader already
does.

> Unless the method is the latter, I would assume that static calls are
> much faster in general? Or the approach already in this series is
> perhaps fine enough, and we don't need to break this apart into
> individual modules complicating everything?

The big advantage this approach has over Zinc is that the accelerated
code does not have to stay resident in memory if the cpu is incapable
of executing it.
