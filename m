Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD29C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 21:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C39A20B1F
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 21:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600205597;
	bh=xEbkG6kGcBqKkC6AlZm3Qz7Y5BmyDrs4OfJ9MYbXq9k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KzaiWic6eP8KgemOu6oLwvloLIOBmL/iMvLmVPAhBjyXGnfeq2cPRaIZDvgWOpr7j
	 JK0h35mgzMkgye3cQgYi7TVyODaWpROqdR4R57T7inUhHpE3wmCkUDXfZ0UM5hwFvG
	 noZUCjCZOMIavfcF726z41gFiglSULdzGXEVRTVo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgIOVc6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728128AbgIOVcF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 17:32:05 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0319820731
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 21:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600205525;
        bh=xEbkG6kGcBqKkC6AlZm3Qz7Y5BmyDrs4OfJ9MYbXq9k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=w9Gz9AMp1CSIBR0vsdHuHYxJE7C1ShEuzGFuwt45Hpy5TC0VJ27BXLvQUyDXt4EjY
         fUyLGW1sO+BLgL7XZFqJAXWYoS6lXcPlTSeOxl0KMTN9ezcAs4E5K+WosI6+0bwAFS
         a3vdMrEQZTfUWbQXuKgdw+/83LdPP/vNYTrQDW1Y=
Received: by mail-ot1-f43.google.com with SMTP id c10so4664419otm.13
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 14:32:04 -0700 (PDT)
X-Gm-Message-State: AOAM5300VL3mGblRGwx15LcSBi28GlYr6aPQWBtlzF2N197bEyVgDSqN
        hGN5divWPVu07TMak1GqtiXpRgfp8xd2OFUkbiw=
X-Google-Smtp-Source: ABdhPJxEXMWEq1lrFntQiXLkQzIOybBYZOc4P+UQuKGYX0xzabXHAMILBWz3c3EBq6UM4TUZWzrqiYrBkBqsj+XvNYc=
X-Received: by 2002:a9d:6193:: with SMTP id g19mr13970948otk.108.1600205524339;
 Tue, 15 Sep 2020 14:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200915094619.32548-1-ardb@kernel.org> <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
In-Reply-To: <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 16 Sep 2020 00:31:53 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
Message-ID: <CAMj1kXFtm4Ue0=6qBaKO73Ft1PmKC52chJrbaA8nRLsV5m807g@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 15 Sep 2020 at 21:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Tue, Sep 15, 2020 at 2:46 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > The ADRL pseudo instruction is not an architectural construct, but a
> > convenience macro that was supported by the ARM proprietary assembler
> > and adopted by binutils GAS as well, but only when assembling in 32-bit
> > ARM mode. Therefore, it can only be used in assembler code that is known
> > to assemble in ARM mode only, but as it turns out, the Clang assembler
> > does not implement ADRL at all, and so it is better to get rid of it
> > entirely.
> >
> > So replace the ADRL instruction with a ADR instruction that refers to
> > a nearer symbol, and apply the delta explicitly using an additional
> > instruction.
> >
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Stefan Agner <stefan@agner.ch>
> > Cc: Peter Smith <Peter.Smith@arm.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > I will leave it to the Clang folks to decide whether this needs to be
> > backported and how far, but a Cc stable seems reasonable here.
> >
> >  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
> >  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
> > index 9f96ff48e4a8..8aeb2e82f915 100644
> > --- a/arch/arm/crypto/sha256-armv4.pl
> > +++ b/arch/arm/crypto/sha256-armv4.pl
> > @@ -175,7 +175,6 @@ $code=<<___;
> >  #else
> >  .syntax unified
> >  # ifdef __thumb2__
> > -#  define adrl adr
> >  .thumb
> >  # else
> >  .code   32
> > @@ -471,7 +470,8 @@ sha256_block_data_order_neon:
> >         stmdb   sp!,{r4-r12,lr}
> >
> >         sub     $H,sp,#16*4+16
> > -       adrl    $Ktbl,K256
> > +       adr     $Ktbl,.Lsha256_block_data_order
> > +       add     $Ktbl,$Ktbl,#K256-.Lsha256_block_data_order
> >         bic     $H,$H,#15               @ align for 128-bit stores
> >         mov     $t2,sp
> >         mov     sp,$H                   @ alloca
> > diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
> > index ea04b2ab0c33..1861c4e8a5ba 100644
> > --- a/arch/arm/crypto/sha256-core.S_shipped
> > +++ b/arch/arm/crypto/sha256-core.S_shipped
> > @@ -56,7 +56,6 @@
> >  #else
> >  .syntax unified
> >  # ifdef __thumb2__
> > -#  define adrl adr
> >  .thumb
> >  # else
> >  .code   32
> > @@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
> >         stmdb   sp!,{r4-r12,lr}
> >
> >         sub     r11,sp,#16*4+16
> > -       adrl    r14,K256
> > +       adr     r14,.Lsha256_block_data_order
> > +       add     r14,r14,#K256-.Lsha256_block_data_order
>
> Hi Ard,
> Thanks for the patch.  With this patch applied:
>
> $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1
> -j71 defconfig
> $ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
> ...
> arch/arm/crypto/sha256-core.S:2038:2: error: out of range immediate fixup value
>  add r14,r14,#K256-.Lsha256_block_data_order
>  ^
>
> :(
>

Strange. Could you change it to

sub r14,r14,#.Lsha256_block_data_order-K256

and try again?

If that does work, it means the Clang assembler does not update the
instruction type for negative addends (add to sub in this case), which
would be unfortunate, since it would be another functionality gap.



> Would the adr_l macro you wrote in
> https://lore.kernel.org/linux-arm-kernel/nycvar.YSQ.7.78.906.2009141003360.4095746@knanqh.ubzr/T/#t
> be helpful here?
>
> >         bic     r11,r11,#15             @ align for 128-bit stores
> >         mov     r12,sp
> >         mov     sp,r11                  @ alloca
> > --
> > 2.17.1
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
