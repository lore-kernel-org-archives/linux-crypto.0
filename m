Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76753C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 09:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4310B206E2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 09:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7Cbu9PM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgGJJAY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJJAY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 05:00:24 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF4C08C5CE;
        Fri, 10 Jul 2020 02:00:24 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c16so5253605ioi.9;
        Fri, 10 Jul 2020 02:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=PQuO5zFgwnJ/fFTSGnuawAYd7hcX4BgBcubdCPScc78=;
        b=K7Cbu9PMuNivnQjUiB7K9FnQ8bMf2BlniBC1CUy7HZNah5WBb8BGOMTEOf3G+wVvg4
         U3WmneibCk4xkNHsl7kGzgX+z/kspVjSJ3Wv9eOL+bnsQSTiwlBUoEDCKYlWHo6xRBI+
         T9FUgY/jfcLFwU92ej845NPel4op8agE+Dh8HZCzGA+8dtCPZHG1PloFNXO9qvbdiTOL
         Xi8Crb7hWqeZunP/d9znu5eorC1yv2UTMqBX+ljuTCirPwBoOMWT1hybRMioyDNJMVtx
         cstaxx7cxStxENqp92Sg17tVpSPPIg72TAjGYRKnoIMyrzu51wUeMvBsqM23iB8yIXfV
         IW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=PQuO5zFgwnJ/fFTSGnuawAYd7hcX4BgBcubdCPScc78=;
        b=E0qKh1fJWtUrDPdnZFMcjR4WyxB4slpKlzLs2ikN2edAsHwzyFngGOAWk2hp25PrPZ
         eHhRuGTQ09AkqE+Y2YBuX/uQVslMlITmoFcXqHrY4gLbNwKE71bXp6oVrhpNE8DRMOtH
         ZdZS61/7sKJ2apxCwGWq9sZ9GZSW9uI3vsyz8EA9yXK5LX5baF8bHqhVhGDwUw70x/jS
         FiDsss6lkjUiCLTLHEFL3SnthZkH5MByBUZojUHNKNJOhLfnxLZXLlip1YvewaAIKB97
         yLvFV3sw00KK2+WQNV3Tx8jD9NXLn70SrkjGMPTODEa+kp5f76J34V0YEiZS9rgm7x6t
         JF/Q==
X-Gm-Message-State: AOAM530f5lIpynEa17aOmoyYw57pnEOfKs8786wYTJPJC7pLoasdwF+M
        3GgvNQ4mUak/ClSb/bepLFyskmH+H6tosicKzSI=
X-Google-Smtp-Source: ABdhPJwY7/veQzW95h8o4adm8/3tQsz0euKi9nMlO6Bw2+IqqvPFNPQqDdTGD8zvIc0YJWUAYzFmPdxl3rXv4D0nxZs=
X-Received: by 2002:a05:6638:2591:: with SMTP id s17mr25749153jat.23.1594371623502;
 Fri, 10 Jul 2020 02:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200703143206.3994-1-sedat.dilek@gmail.com> <20200709125536.GF31057@gondor.apana.org.au>
In-Reply-To: <20200709125536.GF31057@gondor.apana.org.au>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 10 Jul 2020 11:00:11 +0200
Message-ID: <CA+icZUXj4TKEduA5A0fpdvha6E2fV6aZXOZ8BXvD5G4eYBHqsg@mail.gmail.com>
Subject: Re: [PATCH v5] x86/crypto: aesni: Fix build with LLVM_IAS=1
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 9, 2020 at 2:56 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 03, 2020 at 04:32:06PM +0200, Sedat Dilek wrote:
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
> >
> > First, I removed the trailing comma in the PRECOMPUTE line.
> >
> > Second, I substituted:
> > 1. GHASH_4_ENCRYPT_4_PARALLEL_DEC -> GHASH_4_ENCRYPT_4_PARALLEL_dec
> > 2. GHASH_4_ENCRYPT_4_PARALLEL_ENC -> GHASH_4_ENCRYPT_4_PARALLEL_enc
> >
> > With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.
> >
> > I confirmed that this works with Linux-kernel v5.7.5 final.
> >
> > NOTE: This patch is on top of Linux v5.7 final.
> >
> > Thanks to Craig and especially Nick for double-checking and his comments.
> >
> > Suggested-by: Craig Topper <craig.topper@intel.com>
> > Suggested-by: Craig Topper <craig.topper@gmail.com>
> > Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1050
> > Link: https://bugs.llvm.org/show_bug.cgi?id=24494
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> > ---
> > Changes v4->v5:
> > - Drop "5.7" tag from subject line as requested by Herbert Xu
> > - Add Link to LLVM bug #24494 (thanks Nick)
> >
> > Changes v3->v4:
> > - Add <> around email address as desired by Nick
> > - Add Nick's Reviewed-by
> >
> > Changes v2->v3:
> > - Add this Changelog
> >
> > Changes v1->v2:
> > - Replace Cc by Suggested-by for Craig
> > - Replace Cc by Suggested-by for Nick (dropped Cc as desired)
> > - Really follow the suggestions of Craig
> > - Drop unneeded comments for my build-environment and Links
> >
> >  arch/x86/crypto/aesni-intel_asm.S | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Patch applied.  Thanks.

[ CC Arnd ]

Thanks Herbert.

Last Monday I switched over from Linux v5.7.y to v5.8-rc4 and my patch
applied cleanly - I was able to build and boot on bare metal.

One request :

We (ClangBuiltLinux folks) need at least Arnd's patch (see [1])...

   "x86: crypto: fix building crc32c with clang ias"

...to be full compliant with LLVM_IAS=1.

We had some discussion internally (see [2]-[4]).
Looking at Arnd's patch again: It was also sent to linux-crypto ML
(May 27, 2020, 2:17 p.m. UTC).

If you pick this directly, feel free to add my:

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

If you have any other wishes/requirements, please let me know.

Regards,
- Sedat -

P.S.: If you are interested in the status of LLVM_IAS=1 see [5] - it
needs to be updated to my recent experiments with Linux v5.8-rc4.
P.S.S.: BTW, a recent version of llvm-toolchain v11.0.0-git is full
compliant with LLVM=1 - no GNU/binutils/tools used just LLVM/utilities
(beyond GNU/make) :-).

[1] https://lore.kernel.org/patchwork/patch/1248401/
[2] https://github.com/ClangBuiltLinux/linux/issues/1010
[3] https://github.com/ClangBuiltLinux/linux/issues/1010#issuecomment-653759336
[4] https://github.com/ClangBuiltLinux/linux/issues/1010#issuecomment-656406876
[5] https://github.com/ClangBuiltLinux/linux/issues/1049

ADDENDUM: Demonstrate/show used Clang's integrated assembler (IAS):

$ llvm-dwarfdump-11 arch/x86/crypto/crc32c-intel.o
...
0x0000adc3: DW_TAG_compile_unit
              DW_AT_stmt_list   (0x00000b94)
              DW_AT_ranges      (0x00000040
                 [0x0000000000000350, 0x0000000000001430)
                 [0x0000000000000000, 0x000000000000000a))
              DW_AT_name        ("arch/x86/crypto/crc32c-pcl-intel-asm_64.S")
              DW_AT_comp_dir    ("/home/dileks/src/linux-kernel/git")
              DW_AT_producer    ("Debian clang version
11.0.0-++20200701093119+ffee8040534-1~exp1 ")
              DW_AT_language    (DW_LANG_Mips_Assembler)
...
- EOT -
