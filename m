Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8648C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 05:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD3A221E3
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 05:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600234806;
	bh=DGzk1FYMqVf3XKlnC8yTOsC1L+mp4oKhLz2OKFkhgEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=LQ67GjC3TCihL3qChHA0lj1Kry9ib4aFxUaxGLFSVy/CHW/asmop4nIEgH4XszdWS
	 gZrAAou+8vj1R0crAWW8WIeCjpYScZ2a1TowHRUAxxZN936P2EuPkpwOuviO4Y3GrU
	 EKjiz2yDK32mGBp+WEexRVs5Ne5gjpdYW/NZcNuw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgIPFkF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 01:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgIPFkF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 01:40:05 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 101022076B
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2020 05:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600234804;
        bh=DGzk1FYMqVf3XKlnC8yTOsC1L+mp4oKhLz2OKFkhgEM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bDCmqOKNtYtwnR1PPdqV+iSzbHxZdGOTop5vQX7rzMXL5sLl0JLJ7OB3KKGfuhAiL
         ppszU/cDdyMbYjYRgIYj/I8GVMbXAba2mlUSB+s6c2fCojQk6iJ1QU5GTGaR7cz+q7
         IPQTYxYwKFFMuJQ8PNJic46c29NuCc/TWgn26xjg=
Received: by mail-ot1-f48.google.com with SMTP id g96so5518401otb.12
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 22:40:04 -0700 (PDT)
X-Gm-Message-State: AOAM532ViKcSs/yX3BDs8xrvahxYzrSEeVYURbgLzsyvXwuBIakzALBF
        +j5pMV/5YFzDuSUTAXpi8+TX4pqowcFBUbHO3XI=
X-Google-Smtp-Source: ABdhPJyu+dZd/jSTsNbDYqTuLF5zQNdSoVpRJdP8aO01rKN/9pe8pSPsl8clqqfwyenig7pWAL7KlVoHeWH795ilJOc=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr14914184otk.108.1600234803396;
 Tue, 15 Sep 2020 22:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200915094619.32548-1-ardb@kernel.org> <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
 <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com> <CAKwvOd=n6Ny-8UfrVTWqa07g6=9Q_N_ou4f9DkFGwhFFvdtWPw@mail.gmail.com>
In-Reply-To: <CAKwvOd=n6Ny-8UfrVTWqa07g6=9Q_N_ou4f9DkFGwhFFvdtWPw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 16 Sep 2020 08:39:51 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHWXzmJTJnbXyNYynJSGnXUU0ucv=sqK6zL3tGPs5-86Q@mail.gmail.com>
Message-ID: <CAMj1kXHWXzmJTJnbXyNYynJSGnXUU0ucv=sqK6zL3tGPs5-86Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
To:     Nick Desaulniers <ndesaulniers@google.com>
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

On Wed, 16 Sep 2020 at 02:55, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Sep 15, 2020 at 2:32 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Tue, 15 Sep 2020 at 21:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > On Tue, Sep 15, 2020 at 2:46 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > The ADRL pseudo instruction is not an architectural construct, but a
> > > > convenience macro that was supported by the ARM proprietary assembler
> > > > and adopted by binutils GAS as well, but only when assembling in 32-bit
> > > > ARM mode. Therefore, it can only be used in assembler code that is known
> > > > to assemble in ARM mode only, but as it turns out, the Clang assembler
> > > > does not implement ADRL at all, and so it is better to get rid of it
> > > > entirely.
> > > >
> > > > So replace the ADRL instruction with a ADR instruction that refers to
> > > > a nearer symbol, and apply the delta explicitly using an additional
> > > > instruction.
> > > >
> > > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > > Cc: Stefan Agner <stefan@agner.ch>
> > > > Cc: Peter Smith <Peter.Smith@arm.com>
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > ---
> > > > I will leave it to the Clang folks to decide whether this needs to be
> > > > backported and how far, but a Cc stable seems reasonable here.
> > > >
> > > >  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
> > > >  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
> > > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
> > > > index 9f96ff48e4a8..8aeb2e82f915 100644
> > > > --- a/arch/arm/crypto/sha256-armv4.pl
> > > > +++ b/arch/arm/crypto/sha256-armv4.pl
> > > > @@ -175,7 +175,6 @@ $code=<<___;
> > > >  #else
> > > >  .syntax unified
> > > >  # ifdef __thumb2__
> > > > -#  define adrl adr
> > > >  .thumb
> > > >  # else
> > > >  .code   32
> > > > @@ -471,7 +470,8 @@ sha256_block_data_order_neon:
> > > >         stmdb   sp!,{r4-r12,lr}
> > > >
> > > >         sub     $H,sp,#16*4+16
> > > > -       adrl    $Ktbl,K256
> > > > +       adr     $Ktbl,.Lsha256_block_data_order
> > > > +       add     $Ktbl,$Ktbl,#K256-.Lsha256_block_data_order
> > > >         bic     $H,$H,#15               @ align for 128-bit stores
> > > >         mov     $t2,sp
> > > >         mov     sp,$H                   @ alloca
> > > > diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
> > > > index ea04b2ab0c33..1861c4e8a5ba 100644
> > > > --- a/arch/arm/crypto/sha256-core.S_shipped
> > > > +++ b/arch/arm/crypto/sha256-core.S_shipped
> > > > @@ -56,7 +56,6 @@
> > > >  #else
> > > >  .syntax unified
> > > >  # ifdef __thumb2__
> > > > -#  define adrl adr
> > > >  .thumb
> > > >  # else
> > > >  .code   32
> > > > @@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
> > > >         stmdb   sp!,{r4-r12,lr}
> > > >
> > > >         sub     r11,sp,#16*4+16
> > > > -       adrl    r14,K256
> > > > +       adr     r14,.Lsha256_block_data_order
> > > > +       add     r14,r14,#K256-.Lsha256_block_data_order
> > >
> > > Hi Ard,
> > > Thanks for the patch.  With this patch applied:
> > >
> > > $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1
> > > -j71 defconfig
> > > $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
> > > ...
> > > arch/arm/crypto/sha256-core.S:2038:2: error: out of range immediate fixup value
> > >  add r14,r14,#K256-.Lsha256_block_data_order
> > >  ^
> > >
> > > :(
> > >
> >
> > Strange. Could you change it to
> >
> > sub r14,r14,#.Lsha256_block_data_order-K256
> >
> > and try again?
> >
> > If that does work, it means the Clang assembler does not update the
> > instruction type for negative addends (add to sub in this case), which
> > would be unfortunate, since it would be another functionality gap.
>
> Works.  Can you describe the expected functionality a bit more, so we
> can come up with a bug report/test case?  (an `add` with a negative
> operand should be converted to a `sub` with a positive operand, IIUC?)
>

That is it, really. Not sure if this is laid out in a spec anywhere,
although the ELF psABI for ARM covers some similar territory when it
comes to turning add into sub instructions and vice versa, as well as
manipulating the U bit of LDR instructions.

> Also, there's a similar adrl in arch/arm/crypto/sha512-core.S, err, is
> that generated?

Indeed. I missed that one as it has been removed from the upstream
OpenSSL version, but I'll add a fix there as well.
