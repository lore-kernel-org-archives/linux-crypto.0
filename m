Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379B3C433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 05:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA07C20709
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 05:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3h2fVMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgIBFwj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 01:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgIBFwh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 01:52:37 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7991C061244
        for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2020 22:52:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id o64so3317983qkb.10
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2020 22:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+PJSvdhXLudZXyy/3pKaI3QkaElzXMSL36DUdCZ5fI=;
        b=Y3h2fVMF4kLmI1ZX1gfGoyTT1iFHuGG3ECkmrExLD3nI/BlakOBMEDceWLwfaOiwPC
         u4yiB1V82J0DPo+qopaUcspfAV1zyU32F7Ke6nGg5qMmgZwk55zlLTqRe0mxEwtND6vp
         MJ82tourCtziChkp1SJObHqcKglf4o67Vrr/MLae5wAK6nAzCfqTqsgL19nBqb0oRO2f
         RdKgSceqRDaDZaZO5aa67HNJ/EGaDnG3hEdCfef4y5PBWB9wvlYiDgHwEQwadGtQD1h4
         F+xFd2F+zzxl6SprM05FuQzEbVgkLtUMIBwpl41Evf7D0sZeCUmN3Ih/86SLscSnoxUX
         7vSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+PJSvdhXLudZXyy/3pKaI3QkaElzXMSL36DUdCZ5fI=;
        b=PhmsZgRD7X2/XuJ6RAmtChD8/EvGX5KgDgRlsSWPcPP4fwv1s8dfXEmxtU/PD51RCR
         qmO0eE84qW0aRqqNjBSSkCZeBHjaa7uAPNP9OJCDFEKXFZwnflk2k6jK5S86Pa26Vdo3
         D00khnfxknZVzLvPRvTjkO191oj30shRSUlK6047+vHaIPED1T4bMJ/T6ybShyIXr6Ot
         jzdRuvTM/jH1KcIl0T0h8CJvFUVLKJ+M/RgBqiF58rkwHZCV0/CPTPVPJnpx5YkhpU77
         FK0I+BcDYAALejBy+mi4XOxfU51r+hJMreaPhuSDmIhrxBzxnftqF1ddmf2RQpCYUgdY
         u6UQ==
X-Gm-Message-State: AOAM530/Xm+CUMhWMQ6Qt1V2j4EiLaZREXnAlcDsbemULxlnv3jXtt55
        /4RwGcrxCzCvDypqZ0p76BZpNJwTuPICTdfClJI=
X-Google-Smtp-Source: ABdhPJy/Ru+/bWG+opnEKnF3yQizsKkItYNrjkoRJDg4pMjANkwakhqgj8HOy/2HNnPIoDgbR2rs44V7AtYmZDWjUDU=
X-Received: by 2002:a37:97c6:: with SMTP id z189mr5589295qkd.74.1599025956912;
 Tue, 01 Sep 2020 22:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200827173831.95039-1-ubizjak@gmail.com> <20200901191611.GA869399@zx2c4.com>
In-Reply-To: <20200901191611.GA869399@zx2c4.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Wed, 2 Sep 2020 07:52:26 +0200
Message-ID: <CAFULd4YFPFsuZuQRCq1A4u1azNrdtfSxymYA=nM1X=6neycT-g@mail.gmail.com>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in poly1305-x86_64-cryptogams.pl
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Polyakov <appro@cryptogams.org>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 1, 2020 at 9:16 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Uros,
>
> Any benchmarks for this? Seems like it's all in initialization code,
> right? I'm CC'ing Andy into this.

This patch should have no performance effect, it saves REX prefix byte
when the optimization is applied to legacy registers.

Uros.

> Jason
>
> On Thu, Aug 27, 2020 at 07:38:31PM +0200, Uros Bizjak wrote:
> > x86_64 zero extends 32bit operations, so for 64bit operands,
> > XORL r32,r32 is functionally equal to XORQ r64,r64, but avoids
> > a REX prefix byte when legacy registers are used.
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > ---
> >  arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> > index 137edcf038cb..7d568012cc15 100644
> > --- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> > +++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> > @@ -246,7 +246,7 @@ $code.=<<___ if (!$kernel);
> >  ___
> >  &declare_function("poly1305_init_x86_64", 32, 3);
> >  $code.=<<___;
> > -     xor     %rax,%rax
> > +     xor     %eax,%eax
> >       mov     %rax,0($ctx)            # initialize hash value
> >       mov     %rax,8($ctx)
> >       mov     %rax,16($ctx)
> > @@ -2853,7 +2853,7 @@ $code.=<<___;
> >  .type        poly1305_init_base2_44,\@function,3
> >  .align       32
> >  poly1305_init_base2_44:
> > -     xor     %rax,%rax
> > +     xor     %eax,%eax
> >       mov     %rax,0($ctx)            # initialize hash value
> >       mov     %rax,8($ctx)
> >       mov     %rax,16($ctx)
> > @@ -3947,7 +3947,7 @@ xor128_decrypt_n_pad:
> >       mov     \$16,$len
> >       sub     %r10,$len
> >       xor     %eax,%eax
> > -     xor     %r11,%r11
> > +     xor     %r11d,%r11d
> >  .Loop_dec_byte:
> >       mov     ($inp,$otp),%r11b
> >       mov     ($otp),%al
> > @@ -4085,7 +4085,7 @@ avx_handler:
> >       .long   0xa548f3fc              # cld; rep movsq
> >
> >       mov     $disp,%rsi
> > -     xor     %rcx,%rcx               # arg1, UNW_FLAG_NHANDLER
> > +     xor     %ecx,%ecx               # arg1, UNW_FLAG_NHANDLER
> >       mov     8(%rsi),%rdx            # arg2, disp->ImageBase
> >       mov     0(%rsi),%r8             # arg3, disp->ControlPc
> >       mov     16(%rsi),%r9            # arg4, disp->FunctionEntry
> > --
> > 2.26.2
> >
>
> --
> Jason A. Donenfeld
> Deep Space Explorer
> fr: +33 6 51 90 82 66
> us: +1 513 476 1200
> www.jasondonenfeld.com
> www.zx2c4.com
> zx2c4.com/keys/AB9942E6D4A4CFC3412620A749FC7012A5DE03AE.asc
