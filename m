Return-Path: <SRS0=lcHd=AF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3618C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jun 2020 05:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47692088E
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jun 2020 05:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpwv6Wfi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388512AbgFXFSD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jun 2020 01:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgFXFSC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jun 2020 01:18:02 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2DCC061573;
        Tue, 23 Jun 2020 22:18:01 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x9so959760ila.3;
        Tue, 23 Jun 2020 22:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Dvrm0jt0eeOGBRaaXN4jnIZFCH1twjn8iR3FCC+o0QI=;
        b=bpwv6WfibYrw0awWEAme/ZtmxBqYOn8OKOYXctw+iwyZ/UOEmNlhPZ98G7m90+kEKt
         vMztXt8WFbgiClAJjkI1qH7NAo0opSOKBfDqrXvLSwq7kJosMuFB/mlmCzjVSE02ukZB
         oBPMmzNIWsmMC4jRH61yisj5JmUukipLK1R/62I9wI2ZuprmHhJywXlzAIPc1WRWXhOv
         aQ/yKhPbzGdriHAanEyLA1D/GHGLzzIJ4TUTWlrczr1el84cwgs6QiLmUjZ8mb9CsfRc
         Uu5kW8pQ8UoR+zozXVRWiCGnbSGHiHzf5sD9FzjFzbZulFJjYgsBcGME7jUi+6m/ehMi
         2AAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Dvrm0jt0eeOGBRaaXN4jnIZFCH1twjn8iR3FCC+o0QI=;
        b=hz9G6BAuHOZz1ICtu9jRI5MvV76OFHUOn7ETkSnH0TStDJs6JqDlsXNc8ldupln6mq
         PTA1Yh7w5rxRthIkoNeh8E0LCcMp/VDC7hcdGs1TyP3TZS5ggkvnIBWABOLmH6wGNWxg
         kPXbxlqriZMYZcj6k4iXUcIEsvZNGYIkZiv97ls96Vaxp8/DxYuEA2MDxn7Z8PK9O3Vf
         skCdeYRojH9JdzPo+smM3uUYJA6mtSVv5yBGhP1UnBpIqj7hM3Urk3zqILGzuuUlnp5a
         WVYgPFVQ6z4H4NtZFec/MPTBEJdyx2AML3v64oUX6kcEINBzySklfMHww4oB3ckNZMcf
         RBCw==
X-Gm-Message-State: AOAM532NfcMQH1/qoICEcoUgdbWDbxk/UGI8/PqyWqz47O+goZ+/J1nS
        3MxBFQTP6GG/jc8UxZUAI9b2TO26dwzhvvRlp3M=
X-Google-Smtp-Source: ABdhPJx1oGLisT/nrJue3rSlNrXs2pJw5TDxAXVVqq05lPsSI33Tn4nSvWWaCuZeD/ttTnSYCVtdYAilMzeircTkIGY=
X-Received: by 2002:a92:940f:: with SMTP id c15mr27539274ili.204.1592975880267;
 Tue, 23 Jun 2020 22:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200623025628.18467-1-sedat.dilek@gmail.com> <CAKwvOdmR10E2uzKnq2Jt0DSw9+3uvjSfqidxppCoYmhNZPLx5Q@mail.gmail.com>
In-Reply-To: <CAKwvOdmR10E2uzKnq2Jt0DSw9+3uvjSfqidxppCoYmhNZPLx5Q@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 24 Jun 2020 07:17:56 +0200
Message-ID: <CA+icZUVPpHcZainwq0ZpgWeuagCo1JWdM7+6TakOudeHXhBgmQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 v2] x86/crypto: aesni: Fix build with LLVM_IAS=1
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
        Craig Topper <craig.topper@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 23, 2020 at 8:44 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Mon, Jun 22, 2020 at 7:56 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
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
>
> Thanks for the note, still applies cleanly on top of linux-next today for me.
>
> >
> > Thanks to Craig and especially Nick for double-checking and his comments.
> >
> > Suggested-by: Craig Topper <craig.topper@intel.com>
> > Suggested-by: Craig Topper <craig.topper@gmail.com>
> > Suggested-by: Nick Desaulniers ndesaulniers@google.com
>
> ^ oh, may have missed <> around email addr.
>
> > Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1050
> > Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Following the same testing methodology from V1
> (https://lore.kernel.org/patchwork/comment/1456822/) I verified for
> GCC+GAS this is no functional change.
>
> $ wget https://lore.kernel.org/patchwork/patch/1261340/mbox/ -O sedat_v3.patch
> $ git am sedat_v3.patch
> $ make -j71 arch/x86/crypto/aesni-intel_asm.o
> $ llvm-objdump -dr arch/x86/crypto/aesni-intel_asm.o > postpatch_v3.txt
> $ diff -u <(cat prepatch.txt | tr -s ' ' | cut -d '    ' -f 2-) <(cat
> postpatch_v3.txt| tr -s ' ' | cut -d '   ' -f 2-) | less
> (no output)
>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>

Thanks a lot for your feedback.

I have sent a v4 with corrected email-address and your Reviewed-by.

- Sedat -

[1] https://lore.kernel.org/patchwork/patch/1263102/
[2] https://lore.kernel.org/lkml/20200624051538.5355-1-sedat.dilek@gmail.com/

> > ---
> >  arch/x86/crypto/aesni-intel_asm.S | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> > index cad6e1bfa7d5..c216de287742 100644
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
> > @@ -978,7 +978,7 @@ _initial_blocks_done\@:
> >  * arg1, %arg3, %arg4 are used as pointers only, not modified
> >  * %r11 is the data offset value
> >  */
> > -.macro GHASH_4_ENCRYPT_4_PARALLEL_ENC TMP1 TMP2 TMP3 TMP4 TMP5 \
> > +.macro GHASH_4_ENCRYPT_4_PARALLEL_enc TMP1 TMP2 TMP3 TMP4 TMP5 \
> >  TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
> >
> >         movdqa    \XMM1, \XMM5
> > @@ -1186,7 +1186,7 @@ aes_loop_par_enc_done\@:
> >  * arg1, %arg3, %arg4 are used as pointers only, not modified
> >  * %r11 is the data offset value
> >  */
> > -.macro GHASH_4_ENCRYPT_4_PARALLEL_DEC TMP1 TMP2 TMP3 TMP4 TMP5 \
> > +.macro GHASH_4_ENCRYPT_4_PARALLEL_dec TMP1 TMP2 TMP3 TMP4 TMP5 \
> >  TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
> >
> >         movdqa    \XMM1, \XMM5
> > --
>
> --
> Thanks,
> ~Nick Desaulniers
