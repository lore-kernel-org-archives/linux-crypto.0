Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D735C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDFC120707
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 03:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RD9+BaGc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgFWDP3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 23:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbgFWDP2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 23:15:28 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F88C061573;
        Mon, 22 Jun 2020 20:15:28 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t8so17969755ilm.7;
        Mon, 22 Jun 2020 20:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=fycVmvQpV3ngTb7UtojX19Ert3cNTVVV8Z4M/O1NFbE=;
        b=RD9+BaGcr2Ox3hWA+zPaHdhehOXryuY/OS3w5arkNDlT7fKknvETgAYIlOSBeAwFib
         dhI/K7THA/zc2bnFfgRcR6nVKEJ+l9wX/BQqGRPgc9UMtaAIvlfOIKEMonrPudpAoZTZ
         2fUhsm9MiwJI2EgPXZzLX0WuwLNTaQUwfqBpVvPiGXr5jIeOoy84/BNUk12H3qKB4Wim
         Ad3b5rRbOIqWqE/GRS/lDvyBFrBg+2urA1N1ZoVE4UtzOQP24tkAnFuf10DYR8p9HgCg
         RicTRyOlpk1bcy79tzLmZy524OD1ZjkjqFQ83OjWnL75EX60zP6UP2RQg//yNC/lc4SL
         rfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=fycVmvQpV3ngTb7UtojX19Ert3cNTVVV8Z4M/O1NFbE=;
        b=hhJccEngZTyFd7f+gAL+vfpan544VjU0XEGZNrjXcUMMGNkZH255srlqV4rfCQJCOo
         ZApr9xSnnzGU85zvscT78pseE8sxJgaepFt6EmNM/5xi8s/5w7o7lalq1ITVxZB1kd7S
         eRcEa+wWUunFxR77QYAUQPIhqVy+BVDEENFV9YhBgRB83BzXlToHdGxqSwT4GtQqe4xA
         k/ZobB21Na2DGr+b1onOh9gg/Y5F3R1LjiaEUNZyGLQgHlv4Qj6XqXx27PCpk3PspsgY
         ej4kznWVH+K2usylDw5W3xs1E+OrAz+GXztQeKfp1m0DlsKWc2XjBBR7arwA2Fl7nBAx
         q7pA==
X-Gm-Message-State: AOAM532Z+SP2BTYqLruwcoeSkKkXRxEr/lLKOp/t6JJxlTITYXeCRrIM
        KGIjVTGtWwTI/5E3y035yrOcijHXZw68Khpx5rg=
X-Google-Smtp-Source: ABdhPJyECOBkuB9gLhUiv9pnw5uqMcGNYAUageeAVpGuY/ygP6zrf9g67YsTw2qeHmOXoA6oqIj7xZv/tc9dd6HIOjM=
X-Received: by 2002:a92:5b8d:: with SMTP id c13mr7460218ilg.226.1592882127586;
 Mon, 22 Jun 2020 20:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200622155018.6043-1-sedat.dilek@gmail.com> <CAKwvOdn0EnKnGToVC1Bw5di6ucSFkKNOUko1yekkcVhw5nzXZg@mail.gmail.com>
In-Reply-To: <CAKwvOdn0EnKnGToVC1Bw5di6ucSFkKNOUko1yekkcVhw5nzXZg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 23 Jun 2020 05:15:20 +0200
Message-ID: <CA+icZUW53PLenrduqQh6nm126RACiXUJMwa6kugzLdoWKBA7xA@mail.gmail.com>
Subject: Re: [PATCH 5.7] x86/crypto: aesni: Fix build with LLVM_IAS=1
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>,
        Jian Cai <jiancai@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 22, 2020 at 10:33 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Jun 22, 2020 at 8:50 AM Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >
> > When building with LLVM_IAS=1 means using Clang's Integrated Assembly (IAS)
> > from LLVM/Clang >= v10.0.1-rc1+ instead of GNU/as from GNU/binutils
> > I see the following breakage in Debian/testing AMD64:
> >
> > <instantiation>:15:74: error: too many positional arguments
> >  PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
> >                                                                          ^
> >  arch/x86/crypto/aesni-intel_asm.S:1598:2: note: while in macro instantiation
> >  GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
> >  ^
> > <instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
> >  GHASH_4_ENCRYPT_4_PARALLEL_dec %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
> >  ^
> > arch/x86/crypto/aesni-intel_asm.S:1599:2: note: while in macro instantiation
> >  GCM_ENC_DEC dec
> >  ^
> > <instantiation>:15:74: error: too many positional arguments
> >  PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
> >                                                                          ^
> > arch/x86/crypto/aesni-intel_asm.S:1686:2: note: while in macro instantiation
> >  GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
> >  ^
> > <instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
> >  GHASH_4_ENCRYPT_4_PARALLEL_enc %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
> >  ^
> > arch/x86/crypto/aesni-intel_asm.S:1687:2: note: while in macro instantiation
> >  GCM_ENC_DEC enc
>
> === I think from here to...
>
>
> >
> > Craig Topper suggested me in ClangBuiltLinux issue #1050:
> >
> > > I think the "too many positional arguments" is because the parser isn't able
> > > to handle the trailing commas.
> > >
> > > The "unknown use of instruction mnemonic" is because the macro was named
> > > GHASH_4_ENCRYPT_4_PARALLEL_DEC but its being instantiated with
> > > GHASH_4_ENCRYPT_4_PARALLEL_dec I guess gas ignores case on the
> > > macro instantiation, but llvm doesn't.
>
> Yep, see also:
> commit 6f5459da2b87 ("arm64: alternative: fix build with clang
> integrated assembler")
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f5459da2b8736720afdbd67c4bd2d1edba7d0e3
>
> >
> > First, I removed the trailing comma in the PRECOMPUTE line.
> >
> > Second, I substituted:
> > 1. GCM_ENC_DEC dec -> GCM_ENC_DEC DEC
> > 2. GCM_ENC_DEC enc -> GCM_ENC_DEC ENC
> >
> > With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.
> >
> > As llvm-toolchain I used v10.0.1-rc1+ and v11.0.0-git pre-releases:
> > 1. release/10.x Git: 2dc664d578f0e9c8ea5975eed745e322fa77bffe
> > 2.       master Git: 8da5b9083691b557f50f72ab099598bb291aec5f (default)
> >
> > Just for the sake of completeness:
> > 1. CONFIG_DEBUG_INFO_DWARF4=y
> > 2. OBJDUMP=llvm-objdump (passed to my make-line)
> >
> > Please have a look into "llvm.rst" kernel-doc for further informations and
> > how to pass LLVM kbuild-options to your make-line.
> >
> > I confirmed that this works with Linux-kernel v5.7.3 and v5.7.5 final.
> >
> > NOTE: This patch is on top of Linux v5.7 final.
> >
> > Thanks to Craig and the folks from the ClangBuiltLinux project.
>
> ===...here can be cut out from the commit message.
>
> >
> > Cc: Craig Topper <craig.topper@intel.com>
> > Cc: Craig Topper <craig.topper@gmail.com>
>
> I'd pick one or the other email addresses, and just use that one.
> Craig seems to commit to LLVM with craig.topper@intel.com, so I
> recommend that one.
>
> > Cc: Nick Desaulniers ndesaulniers@google.com
>
> Thanks for the explicit CC, though I do monitor the below list actively.
>
> > Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1050
> > Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/kbuild/llvm.rst
>
> ^ probably don't need that link either.
>
> >
> > ---
> >  arch/x86/crypto/aesni-intel_asm.S | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> > index cad6e1bfa7d5..983eb2eec51a 100644
> > --- a/arch/x86/crypto/aesni-intel_asm.S
> > +++ b/arch/x86/crypto/aesni-intel_asm.S
> > @@ -266,7 +266,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
> >         PSHUFB_XMM %xmm2, %xmm0
> >         movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
> >
> > -       PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
> > +       PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7
> >         movdqu HashKey(%arg2), %xmm13
> >
> >         CALC_AAD_HASH %xmm13, \AAD, \AADLEN, %xmm0, %xmm1, %xmm2, %xmm3, \
>
>
> There's a comparison on L386
>  386 .ifc \operation, dec
> Also, L407, L393, L672, L808, L841, L935, L941, L947,
>
> If we change the `\operation` macro parameter to be `DEC` instead of
> `dec`, does this comparison still hold true?  I would expect not if
> LLVM's integrated assembler is case sensitive?  Otherwise we're
> probably missing instructions for the case of `DEC`.  In that case,
> that should probably get fixed.
>
> Interesting, looks like GAS *is* case sensitive for `.ifc` directives?
> ```
> $ cat foo.s
> .macro foo op
> .ifc \op, dec
>   subq r8, r9
> .else
>   addq $0, r8
> .endif
> .endm
> foo DEC
>
> $ clang foo.s -c
> $ llvm-objdump -d foo.o
> ...
>        0: 48 83 04 25 00 00 00 00 00    addq    $0, 0
> $ as foo.s -c
> $ llvm-objdump -d foo.o
> ...
>        0: 48 83 04 25 00 00 00 00 00    addq    $0, 0
> ```
> In that case, it seems that this patch probably breaks the DEC case
> for both toolchains.
>
> Just to triple check, forgetting LLVM for a minute, let's compare the
> disassembly before and after.
>
> $ make -j71 defconfig
> $ make -j71 menuconfig
> <enable CRYPTO_AES_NI_INTEL>
> $ make -j71 arch/x86/crypto/aesni-intel_asm.o
> $ llvm-objdump -dr arch/x86/crypto/aesni-intel_asm.o > prepatch.txt
> <apply your patch>
> $ make -j71 arch/x86/crypto/aesni-intel_asm.o
> $ llvm-objdump -dr arch/x86/crypto/aesni-intel_asm.o > postpatch.txt
> $ diff -u <(cat prepatch.txt | tr -s ' ' | cut -d '   ' -f 2-) <(cat
> postpatch.txt| tr -s ' ' | cut -d '      ' -f 2-) | less
>
> It's not the easiest to tell, since I should have left off `-r` for
> relocations from objdump, but you can clearly see cases of different
> disassembly.  Even the address of labels changes due to missing
> instructions.
>
> In that case, it's probably a smaller change to just renamed the macros
> GHASH_4_ENCRYPT_4_PARALLEL_ENC
> GHASH_4_ENCRYPT_4_PARALLEL_DEC
>
> to
>
> GHASH_4_ENCRYPT_4_PARALLEL_enc
> GHASH_4_ENCRYPT_4_PARALLEL_dec
>
> respectively, though using ALL CAPS is likely more consistent at the
> cost of more lines changed.  Also, sorry I didn't catch this on the
> earlier thread; my mistake.
>
> > @@ -1596,7 +1596,7 @@ SYM_FUNC_START(aesni_gcm_dec)
> >         FUNC_SAVE
> >
> >         GCM_INIT %arg6, arg7, arg8, arg9
> > -       GCM_ENC_DEC dec
> > +       GCM_ENC_DEC DEC
> >         GCM_COMPLETE arg10, arg11
> >         FUNC_RESTORE
> >         ret
> > @@ -1684,7 +1684,7 @@ SYM_FUNC_START(aesni_gcm_enc)
> >         FUNC_SAVE
> >
> >         GCM_INIT %arg6, arg7, arg8, arg9
> > -       GCM_ENC_DEC enc
> > +       GCM_ENC_DEC ENC
> >
> >         GCM_COMPLETE arg10, arg11
> >         FUNC_RESTORE
> > @@ -1719,7 +1719,7 @@ SYM_FUNC_END(aesni_gcm_init)
> >  */
> >  SYM_FUNC_START(aesni_gcm_enc_update)
> >         FUNC_SAVE
> > -       GCM_ENC_DEC enc
> > +       GCM_ENC_DEC ENC
> >         FUNC_RESTORE
> >         ret
> >  SYM_FUNC_END(aesni_gcm_enc_update)
> > @@ -1734,7 +1734,7 @@ SYM_FUNC_END(aesni_gcm_enc_update)
> >  */
> >  SYM_FUNC_START(aesni_gcm_dec_update)
> >         FUNC_SAVE
> > -       GCM_ENC_DEC dec
> > +       GCM_ENC_DEC DEC
> >         FUNC_RESTORE
> >         ret
> >  SYM_FUNC_END(aesni_gcm_dec_update)
> > --
>

Thanks for your feedback and double-checking Nick.

I have submitted a v3 of my patch - should have all relevant material.

- Sedat -

[1] https://lore.kernel.org/lkml/20200623030600.18848-1-sedat.dilek@gmail.com/
[2] https://lore.kernel.org/patchwork/patch/1261340/
[3] https://github.com/ClangBuiltLinux/linux/issues/1050#issuecomment-647879758
