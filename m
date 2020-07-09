Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76AEC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8342074B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgGIM4K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:56:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36198 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgGIM4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:56:09 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtW5Q-0003zg-PM; Thu, 09 Jul 2020 22:55:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:55:36 +1000
Date:   Thu, 9 Jul 2020 22:55:36 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v5] x86/crypto: aesni: Fix build with LLVM_IAS=1
Message-ID: <20200709125536.GF31057@gondor.apana.org.au>
References: <20200703143206.3994-1-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703143206.3994-1-sedat.dilek@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 03, 2020 at 04:32:06PM +0200, Sedat Dilek wrote:
> When building with LLVM_IAS=1 means using Clang's Integrated Assembly (IAS)
> from LLVM/Clang >= v10.0.1-rc1+ instead of GNU/as from GNU/binutils
> I see the following breakage in Debian/testing AMD64:
> 
> <instantiation>:15:74: error: too many positional arguments
>  PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
>                                                                          ^
>  arch/x86/crypto/aesni-intel_asm.S:1598:2: note: while in macro instantiation
>  GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
>  ^
> <instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
>  GHASH_4_ENCRYPT_4_PARALLEL_dec %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
>  ^
> arch/x86/crypto/aesni-intel_asm.S:1599:2: note: while in macro instantiation
>  GCM_ENC_DEC dec
>  ^
> <instantiation>:15:74: error: too many positional arguments
>  PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
>                                                                          ^
> arch/x86/crypto/aesni-intel_asm.S:1686:2: note: while in macro instantiation
>  GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
>  ^
> <instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
>  GHASH_4_ENCRYPT_4_PARALLEL_enc %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
>  ^
> arch/x86/crypto/aesni-intel_asm.S:1687:2: note: while in macro instantiation
>  GCM_ENC_DEC enc
> 
> Craig Topper suggested me in ClangBuiltLinux issue #1050:
> 
> > I think the "too many positional arguments" is because the parser isn't able
> > to handle the trailing commas.
> >
> > The "unknown use of instruction mnemonic" is because the macro was named
> > GHASH_4_ENCRYPT_4_PARALLEL_DEC but its being instantiated with
> > GHASH_4_ENCRYPT_4_PARALLEL_dec I guess gas ignores case on the
> > macro instantiation, but llvm doesn't.
> 
> First, I removed the trailing comma in the PRECOMPUTE line.
> 
> Second, I substituted:
> 1. GHASH_4_ENCRYPT_4_PARALLEL_DEC -> GHASH_4_ENCRYPT_4_PARALLEL_dec
> 2. GHASH_4_ENCRYPT_4_PARALLEL_ENC -> GHASH_4_ENCRYPT_4_PARALLEL_enc
> 
> With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.
> 
> I confirmed that this works with Linux-kernel v5.7.5 final.
> 
> NOTE: This patch is on top of Linux v5.7 final.
> 
> Thanks to Craig and especially Nick for double-checking and his comments.
> 
> Suggested-by: Craig Topper <craig.topper@intel.com>
> Suggested-by: Craig Topper <craig.topper@gmail.com>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1050
> Link: https://bugs.llvm.org/show_bug.cgi?id=24494
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
> Changes v4->v5:
> - Drop "5.7" tag from subject line as requested by Herbert Xu
> - Add Link to LLVM bug #24494 (thanks Nick)
> 
> Changes v3->v4:
> - Add <> around email address as desired by Nick
> - Add Nick's Reviewed-by
> 
> Changes v2->v3:
> - Add this Changelog
> 
> Changes v1->v2:
> - Replace Cc by Suggested-by for Craig
> - Replace Cc by Suggested-by for Nick (dropped Cc as desired)
> - Really follow the suggestions of Craig
> - Drop unneeded comments for my build-environment and Links
> 
>  arch/x86/crypto/aesni-intel_asm.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
