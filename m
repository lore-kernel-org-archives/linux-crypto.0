Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB8FC43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 23:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2C920739
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 23:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="csWN6xgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgIOX4D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 19:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgIOXzx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 19:55:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B16C06174A
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 16:55:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j7so2180331plk.11
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 16:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sn/Sypno4GfL9IE1y53yEPFfiB756BHa96VhDjyiPXk=;
        b=csWN6xgFG/5PPRlKG40yGIAH/n/GescweWDsJt+YigcCg1vDDxcG4DBMhTwwQJbr7T
         311O16kFBNRT074TyaKKDHaOxl9XBFcl/ekNERQ5RLlyGxW3OHstpLKBsVT6UtLxK8RA
         E7iSgdONClHUnEeeMpbMNbJRxFbLks13UPd7D602D0GPE0d02GtifYP8g3y4/PxgQ9jb
         7L2MCfV2qaQc7DLo56bhC5PzlgjVE8CVUZsS+EbPdUjK9Gyh7IdK/rd9FKfwG5MhESSv
         6QTKpk74sQxwcFaZd0Djyo3wdNUVR8hKLdMcdJr0i27kG/dxfwFoLZEooYdPJ//aF3l3
         vg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sn/Sypno4GfL9IE1y53yEPFfiB756BHa96VhDjyiPXk=;
        b=HweWbBNeCgqhjdFOthoxx/HgVFXq6ueyELumeJ2XmiJQo2gvaxjXpXJbkM1l/ryRXm
         mgU6SKbLb+5vD4RfThbgIzomrO92GdkYTovWBnyo6N79I5T593N1QEgafvqzdNlwPhnI
         2tGo3Qycfm4HdHGpqWFP2cKoX7oo+JQmkUZfqFQVAJYATrL0hocD+Yg3iDvExQNeqi3K
         NJmzhQNr/bIM12ZGiLnt3sabUelnq5IuD1BtceLaEtEEJX2sVWXoi0Vz2BbdJzf0k39K
         CNznKz/NFz9RkYyIwZi8j9eE4RzCc3wcGavma3yg/eHRw5p9WL4XuAhFJKbhzCVjUtni
         GPPw==
X-Gm-Message-State: AOAM531sfU1VZb+xTykt48JZQB7GbpLaF8jWtesWSk9IGIWDS4u28Pn/
        qKwfgEdQsIq+Agsu2SxAi3oHuxsTJCw2IYgwtCOGww==
X-Google-Smtp-Source: ABdhPJy0J4zdrwtfjGVJ5zJpFoAiLEUwPPycCdeEX++11iXUFcIt4bW+HBz6j0BwMVg+Re0QTq02Ph0nlhdicHaovAk=
X-Received: by 2002:a17:902:a504:b029:d1:e5e7:bdd8 with SMTP id
 s4-20020a170902a504b02900d1e5e7bdd8mr3735678plq.56.1600214152341; Tue, 15 Sep
 2020 16:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200915094619.32548-1-ardb@kernel.org> <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
 <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
In-Reply-To: <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 15 Sep 2020 16:55:40 -0700
Message-ID: <CAKwvOd=n6Ny-8UfrVTWqa07g6=9Q_N_ou4f9DkFGwhFFvdtWPw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>,
        Jian Cai <jiancai@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15, 2020 at 2:32 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 15 Sep 2020 at 21:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Tue, Sep 15, 2020 at 2:46 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > The ADRL pseudo instruction is not an architectural construct, but a
> > > convenience macro that was supported by the ARM proprietary assembler
> > > and adopted by binutils GAS as well, but only when assembling in 32-bit
> > > ARM mode. Therefore, it can only be used in assembler code that is known
> > > to assemble in ARM mode only, but as it turns out, the Clang assembler
> > > does not implement ADRL at all, and so it is better to get rid of it
> > > entirely.
> > >
> > > So replace the ADRL instruction with a ADR instruction that refers to
> > > a nearer symbol, and apply the delta explicitly using an additional
> > > instruction.
> > >
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Stefan Agner <stefan@agner.ch>
> > > Cc: Peter Smith <Peter.Smith@arm.com>
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > > I will leave it to the Clang folks to decide whether this needs to be
> > > backported and how far, but a Cc stable seems reasonable here.
> > >
> > >  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
> > >  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
> > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
> > > index 9f96ff48e4a8..8aeb2e82f915 100644
> > > --- a/arch/arm/crypto/sha256-armv4.pl
> > > +++ b/arch/arm/crypto/sha256-armv4.pl
> > > @@ -175,7 +175,6 @@ $code=<<___;
> > >  #else
> > >  .syntax unified
> > >  # ifdef __thumb2__
> > > -#  define adrl adr
> > >  .thumb
> > >  # else
> > >  .code   32
> > > @@ -471,7 +470,8 @@ sha256_block_data_order_neon:
> > >         stmdb   sp!,{r4-r12,lr}
> > >
> > >         sub     $H,sp,#16*4+16
> > > -       adrl    $Ktbl,K256
> > > +       adr     $Ktbl,.Lsha256_block_data_order
> > > +       add     $Ktbl,$Ktbl,#K256-.Lsha256_block_data_order
> > >         bic     $H,$H,#15               @ align for 128-bit stores
> > >         mov     $t2,sp
> > >         mov     sp,$H                   @ alloca
> > > diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
> > > index ea04b2ab0c33..1861c4e8a5ba 100644
> > > --- a/arch/arm/crypto/sha256-core.S_shipped
> > > +++ b/arch/arm/crypto/sha256-core.S_shipped
> > > @@ -56,7 +56,6 @@
> > >  #else
> > >  .syntax unified
> > >  # ifdef __thumb2__
> > > -#  define adrl adr
> > >  .thumb
> > >  # else
> > >  .code   32
> > > @@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
> > >         stmdb   sp!,{r4-r12,lr}
> > >
> > >         sub     r11,sp,#16*4+16
> > > -       adrl    r14,K256
> > > +       adr     r14,.Lsha256_block_data_order
> > > +       add     r14,r14,#K256-.Lsha256_block_data_order
> >
> > Hi Ard,
> > Thanks for the patch.  With this patch applied:
> >
> > $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1
> > -j71 defconfig
> > $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
> > ...
> > arch/arm/crypto/sha256-core.S:2038:2: error: out of range immediate fixup value
> >  add r14,r14,#K256-.Lsha256_block_data_order
> >  ^
> >
> > :(
> >
>
> Strange. Could you change it to
>
> sub r14,r14,#.Lsha256_block_data_order-K256
>
> and try again?
>
> If that does work, it means the Clang assembler does not update the
> instruction type for negative addends (add to sub in this case), which
> would be unfortunate, since it would be another functionality gap.

Works.  Can you describe the expected functionality a bit more, so we
can come up with a bug report/test case?  (an `add` with a negative
operand should be converted to a `sub` with a positive operand, IIUC?)

Also, there's a similar adrl in arch/arm/crypto/sha512-core.S, err, is
that generated?
-- 
Thanks,
~Nick Desaulniers
