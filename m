Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 911A9C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 18:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E2D2067D
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 18:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LJXFZhaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHLSOn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 14:14:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42410 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfHLSOn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 14:14:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id b16so8687834wrq.9
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=td30Df60zYQdPauBnpDDGLnmsKaqAG05ryFV6T8tnYI=;
        b=LJXFZhazAaYyE1NX23w2Ir2SROLQSTsrtJUvEfonLL6kK2jFvBEDZfyaPdGuKhAe69
         xMJ+GmTvpsM4RK01gt7kNCfbpP19Wlq0YnwtjjLxRvwiDnNrWe3CnmmTSFcK7aKCTI7Y
         aoo5eKDYB3pPFuyBSj7NwwU4hV/WAJtt1wyU0VyWhjM1sMu3+BOigWbaFB/oyMRAQUS5
         xUbL/mUmyanwvng6bj9qAgnkBiwORoqAavw8NumaTw2V5tTxVWCNUvXj0ikBX1s1kXf7
         f4j9KO6HebbpaMinmA7u/KewKtxFwcf5p0unxK7220b0yTi1MGQ5VX4xJPjw0Ak2FDvZ
         C49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=td30Df60zYQdPauBnpDDGLnmsKaqAG05ryFV6T8tnYI=;
        b=jOnSu9zkRS3N8HLi3vE0M6/zHaoyBtPk2YmfElJNEuzeKOXiXemERcb/RP/a+COZhG
         4p2QtRfyG1u2QX62WpprpANGvYgucJiiRvR2/oF1O7qfzq/cSPqks6udsry1lEhB+TtR
         b5p3T53zP7+eh9C2VzZ67WykvSdigDOpQsjkUjU6wRSvfQDrsYrKEuzEKt2PvS1lAxDJ
         GbKvOPqf7QDEEz/x6Lfh6Zy/XsMqspk6VzrKGquMw8pxKuEsYqqh/ytjNSdrC+nslnaS
         hQ+kfA9XpX5Xo1SZvZwA93pLoGM0S8FZ5hvbOLzcy/aBQTynQDAr9AQYopr3YVX1LVJ3
         sSwA==
X-Gm-Message-State: APjAAAWlkC0CpA+splJQskzBOwZAG5/OwzYJllt9kVWJPnnGdiqEUhWs
        9XXvCbLUwN9DMCOvrxNPpYQ32vlVjrO9WRdPQtFQCg==
X-Google-Smtp-Source: APXvYqxZcP6s29ZLbaENCkKaUzUxll5WY7bQCSlcW2ERvvXMZ0NtNN7kvXKsScPEMeuQWlpJ+LaDpCIW8ardSrcmA3g=
X-Received: by 2002:adf:e8c2:: with SMTP id k2mr41186046wrn.198.1565633680343;
 Mon, 12 Aug 2019 11:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
 <20190811225912.19412-4-ard.biesheuvel@linaro.org> <CAKwvOd=uxi8qmQEjOudvSUVW6vc42b-SmoV91DeWfBkp3kOJcQ@mail.gmail.com>
 <CAKv+Gu9KKvCXAm=1hJ-owkL4BTi=hmCXA8ag_rTvdnUgn_zvUg@mail.gmail.com> <CAKwvOd=9KP9j7SkyCJ6xBWmVQn8nSsP78PasdtBO5aDFcSm2Rg@mail.gmail.com>
In-Reply-To: <CAKwvOd=9KP9j7SkyCJ6xBWmVQn8nSsP78PasdtBO5aDFcSm2Rg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 12 Aug 2019 21:14:28 +0300
Message-ID: <CAKv+Gu8jnAyAF_ABmNTmP8QRzLNXj919OzGywjg05jCBsD_b-Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] crypto: arm64/aegis128 - implement plain NEON version
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Aug 2019 at 20:31, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Mon, Aug 12, 2019 at 10:22 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Mon, 12 Aug 2019 at 19:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > On Sun, Aug 11, 2019 at 3:59 PM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > > diff --git a/crypto/Makefile b/crypto/Makefile
> > > > index 99a9fa9087d1..0d2cdd523fd9 100644
> > > > --- a/crypto/Makefile
> > > > +++ b/crypto/Makefile
> > > > @@ -98,7 +98,14 @@ CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
> > > >  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
> > > >  endif
> > > >  ifeq ($(ARCH),arm64)
> > > > -CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
> > > > +aegis128-cflags-y := -ffreestanding -mcpu=generic+crypto
> > > > +aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
> > > > +                                      -ffixed-q19 -ffixed-q20 -ffixed-q21 \
> > > > +                                      -ffixed-q22 -ffixed-q23 -ffixed-q24 \
> > > > +                                      -ffixed-q25 -ffixed-q26 -ffixed-q27 \
> > > > +                                      -ffixed-q28 -ffixed-q29 -ffixed-q30 \
> > > > +                                      -ffixed-q31
> > >
> > > I've filed https://bugs.llvm.org/show_bug.cgi?id=42974 for a feature
> > > request for this in Clang.
> > >
> >
> > Good. But even GCC has issues here. Most notably, something like
> >
> > register uint8x16_t foo asm ("v16");
> >
> > should permit a register that is excluded from general allocation to
> > be used explicitly, but this throws a warning on GCC and an error with
> > Clang.
>
> Consider filing bugs against GCC's issue tracker so that they're aware
> of the issue if you think there's more that can be improved on their
> end (for bugs in Clang, I'm always happy to help submit bug reports).
> What is the warning?
>

Cheers.

With Clang, I get

$ clang -target aarch64-linux-gnu -S -o - -O2 neon.c
neon.c:4:1: error: bad type for named register variable
register uint8x16_t foo asm ("v0");
^
1 error generated.

but given that -fixed-vNN is not implemented either, this is not
unexpected. But the latter is much more useful if the former is
supported as well.

I can't actually get the GCC warning to reproduce, so it might have
been operator error :-) But if I define the sbox like this

register uint8x16x4_t sbox0 asm ("v16");
register uint8x16x4_t sbox1 asm ("v20");
register uint8x16x4_t sbox2 asm ("v24");
register uint8x16x4_t sbox3 asm ("v28");

and use it in the sbox substitution, GCC emits lots of code like

     2bc:       4eb01e08        mov     v8.16b, v16.16b
     2c0:       4eb11e29        mov     v9.16b, v17.16b
     2c4:       4eb21e4a        mov     v10.16b, v18.16b
     2c8:       4eb31e6b        mov     v11.16b, v19.16b
     ..
     2d4:       4e0e610e        tbl     v14.16b, {v8.16b-v11.16b}, v14.16b
     2d8:       4e0d610d        tbl     v13.16b, {v8.16b-v11.16b}, v13.16b

i.e., it moves the register contents around rather than use it in the
tbl/tbx instructions directly, and the resulting code is absolutely
dreadful.

I will bring this up with the GCC developers, but it might be more
useful to grab someone internally rather than go via the bugzilla.





> for -ffixed-q* and `asm ("v16")`, on aarch64, what are the q registers
> and v registers?  I assume they're related to NEON, but I'd only even
> worked with w* and x* GPRs.  I *think* the explicit register syntax
> works for GPRs in Clang; maybe the v* and q* registers being broken is
> just oversight and can be fixed.
>

Yes. NEON/FP registers are referenced in different ways based on context:

v0.16b, v0.8h, v0.4s, v0.2d for SIMD bytes, halfwords, single words double words

q0/d0/s0 etc for scalar 128/64/32 bit FP


> > > With those 2 recommendations:
> > > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > > in regards to compiling w/ Clang.  Someone else should review the
> > > implementation of this crypto routine.
> --
> Thanks,
> ~Nick Desaulniers
