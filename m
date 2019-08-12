Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D572C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E67AE2075B
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fp+SCcIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfHLRbh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 13:31:37 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42607 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHLRbg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 13:31:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so48196089plb.9
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xZ1P69bCy5klgv2VIXX39SeNII1vbEy/cgF/CbLJCqg=;
        b=fp+SCcIb4H6VDhyYodItsBkz4CTCT7P8ft9KYeVtimUmcFttvb7pSpShNqdfo2xAq+
         iSD+svRNsuylwYVcb5r6sAyYxy9p0XdI09qN8iO1vbsJUuxNTSQuxsLYQ4eCuV3vMbF6
         vsHkC89RVRnu9EZouj2xqlfs9ki69D07C/ypfQORq9zdM4sQpLwwYp5k79DegjhUQNtS
         i2etiBKz2HPXKUUbb3Lxl26YLgeEt2W0Pd8Qi18etVlvOZviRjW9JquLikqFpQLfdQ4k
         4bf1t4g2AqxVZs9gogXZn9ObrPHBVzoun5IQwI8d1YIbl6o99i86GhciTRmDiC20t2ia
         dD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xZ1P69bCy5klgv2VIXX39SeNII1vbEy/cgF/CbLJCqg=;
        b=MFU+RhOnQUNuXnXKlatItpANdgjY4SjwtbycCZzoYa9DtfBGrUvd6IEG7FKtXwqyiN
         OkrelqC0NxALhFrpddCea4iGRcb/JtXpDcEk88Zqtqgvaq6WnTf0CTW1e7reOAS3AO5m
         JnuIm5Q7MR5mmo6Eni2q90B6FbBEBqzGFQczyFGVcYpl9pW1atWmkliQT3SD/4fUhxoT
         HhZ2cYIR5k0SyENGcG+P5/hwpN9wo/AXTpopkGBvWzElAhxe4yaEE86FbW1WNKAFFW6Y
         xOFNgeh5brDEOgjloX65YCPuK2zNrPR3HCQBqZQgdvxslrHgLNeCe/xY8eFRk7Dxhmec
         7fnA==
X-Gm-Message-State: APjAAAVpsygn3C6FzHZLxiwEpi6PnhEV2cHu7jF7E/vtgcU+YXLYv1Hq
        fZSFLULTx85CdzJDq6Sk0eCgRcPsuwjLcJvlcac+vE7ZFL4=
X-Google-Smtp-Source: APXvYqxRqMfOTc+G8aKjQtVVcC9fCDLVEEJT1s83XGgIeeO5MxP4OoqwVkbFbgXFecspNhcrWnvtY6psvy0WSt1jxao=
X-Received: by 2002:a17:902:3363:: with SMTP id a90mr32338228plc.119.1565631095499;
 Mon, 12 Aug 2019 10:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
 <20190811225912.19412-4-ard.biesheuvel@linaro.org> <CAKwvOd=uxi8qmQEjOudvSUVW6vc42b-SmoV91DeWfBkp3kOJcQ@mail.gmail.com>
 <CAKv+Gu9KKvCXAm=1hJ-owkL4BTi=hmCXA8ag_rTvdnUgn_zvUg@mail.gmail.com>
In-Reply-To: <CAKv+Gu9KKvCXAm=1hJ-owkL4BTi=hmCXA8ag_rTvdnUgn_zvUg@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 10:31:24 -0700
Message-ID: <CAKwvOd=9KP9j7SkyCJ6xBWmVQn8nSsP78PasdtBO5aDFcSm2Rg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] crypto: arm64/aegis128 - implement plain NEON version
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 10:22 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 12 Aug 2019 at 19:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Sun, Aug 11, 2019 at 3:59 PM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > > diff --git a/crypto/Makefile b/crypto/Makefile
> > > index 99a9fa9087d1..0d2cdd523fd9 100644
> > > --- a/crypto/Makefile
> > > +++ b/crypto/Makefile
> > > @@ -98,7 +98,14 @@ CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
> > >  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
> > >  endif
> > >  ifeq ($(ARCH),arm64)
> > > -CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
> > > +aegis128-cflags-y := -ffreestanding -mcpu=generic+crypto
> > > +aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
> > > +                                      -ffixed-q19 -ffixed-q20 -ffixed-q21 \
> > > +                                      -ffixed-q22 -ffixed-q23 -ffixed-q24 \
> > > +                                      -ffixed-q25 -ffixed-q26 -ffixed-q27 \
> > > +                                      -ffixed-q28 -ffixed-q29 -ffixed-q30 \
> > > +                                      -ffixed-q31
> >
> > I've filed https://bugs.llvm.org/show_bug.cgi?id=42974 for a feature
> > request for this in Clang.
> >
>
> Good. But even GCC has issues here. Most notably, something like
>
> register uint8x16_t foo asm ("v16");
>
> should permit a register that is excluded from general allocation to
> be used explicitly, but this throws a warning on GCC and an error with
> Clang.

Consider filing bugs against GCC's issue tracker so that they're aware
of the issue if you think there's more that can be improved on their
end (for bugs in Clang, I'm always happy to help submit bug reports).
What is the warning?

for -ffixed-q* and `asm ("v16")`, on aarch64, what are the q registers
and v registers?  I assume they're related to NEON, but I'd only even
worked with w* and x* GPRs.  I *think* the explicit register syntax
works for GPRs in Clang; maybe the v* and q* registers being broken is
just oversight and can be fixed.

> > With those 2 recommendations:
> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > in regards to compiling w/ Clang.  Someone else should review the
> > implementation of this crypto routine.
-- 
Thanks,
~Nick Desaulniers
