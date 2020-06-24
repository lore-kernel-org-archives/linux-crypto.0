Return-Path: <SRS0=lcHd=AF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08475C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jun 2020 05:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D0920857
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jun 2020 05:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhBYWGte"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbgFXFPu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jun 2020 01:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgFXFPt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jun 2020 01:15:49 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1341C061573;
        Tue, 23 Jun 2020 22:15:47 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q5so905962wru.6;
        Tue, 23 Jun 2020 22:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIA/ExOu85ZSunscHkuj5kA/ZoCm0L2G7SDD9aGfW5M=;
        b=MhBYWGtenEmFdq1lg9SSQ4B12EdmGHQjSvL1wimaM64lCIAs3JJSRhUxP63wsOjrXc
         +2Mf992fAcpo1HjSBpLJ8afuNDcLvMbebYF9paQMrcaQq+m/hxDlt/aifphrANxQorsb
         RU4bFPUL4iD2shrdjkC4R3YamzYbh509wUujmqgNT7BMSMPhS4klCxd+Pj2Qzcx4RxKv
         +qL8TKFVYYlSscY0+460RSxbR4W2QIOLwvGwPx2OzDcTph4cmC0tNWD5YVBFHgHCEoag
         O3iGn85jfMB3eGzKDGjNByyvvdbA7Jm3nK1WKSf/0M2T4UXbPPzCAZkc0kZO1nWWy+ft
         RSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gIA/ExOu85ZSunscHkuj5kA/ZoCm0L2G7SDD9aGfW5M=;
        b=Elg70a7yUP5bqW4jqn4CVcMwXsm1G1eipzqnaghJrREtf21abwSj1xZUN77QvB1Dlw
         3EAnbfhQyURB1IfIuB3Jgvu/lK814gb0s4/N+Rl/H36i/qvW/MO2lIZC7sjQqi5jgZrU
         a4tGUT3eDkfKFhkxxzCM6RZqxLWCiqdYuiTZq0RH8T5WtT0ECoUrMYxOoewaJ871WeH/
         cFl+nZkNj8l4pGqinSXYDG4Yc6CpYmjIUMH1DyALpN+opJi13dLKpZ/eoh2Pakisw67l
         h2L06w+tuhKEstZNKm+oeCaIZNSj7CAuFwhwhxnbD0VywB9qrtYa5p2Hhk18wn6FzHk5
         hFAA==
X-Gm-Message-State: AOAM532sPudil5v+ZuXq3jmyXtxohVS5z4QovCi6viRN5MOpeXEzH6hm
        vGItBt9LFXRv+hqhJun5jTs=
X-Google-Smtp-Source: ABdhPJwwwGdf0sg6ubSaSu5fxRvhaXBYAh+qyPZrE9egFVk9gunAwXpKpN1t9u0fHH6xDW5nCKjkrQ==
X-Received: by 2002:adf:e60e:: with SMTP id p14mr4723451wrm.31.1592975746408;
        Tue, 23 Jun 2020 22:15:46 -0700 (PDT)
Received: from localhost.localdomain ([46.114.107.103])
        by smtp.gmail.com with ESMTPSA id f2sm6137195wmj.39.2020.06.23.22.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 22:15:45 -0700 (PDT)
From:   Sedat Dilek <sedat.dilek@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.7 v4] x86/crypto: aesni: Fix build with LLVM_IAS=1
Date:   Wed, 24 Jun 2020 07:15:38 +0200
Message-Id: <20200624051538.5355-1-sedat.dilek@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building with LLVM_IAS=1 means using Clang's Integrated Assembly (IAS)
from LLVM/Clang >= v10.0.1-rc1+ instead of GNU/as from GNU/binutils
I see the following breakage in Debian/testing AMD64:

<instantiation>:15:74: error: too many positional arguments
 PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
                                                                         ^
 arch/x86/crypto/aesni-intel_asm.S:1598:2: note: while in macro instantiation
 GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
 ^
<instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
 GHASH_4_ENCRYPT_4_PARALLEL_dec %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
 ^
arch/x86/crypto/aesni-intel_asm.S:1599:2: note: while in macro instantiation
 GCM_ENC_DEC dec
 ^
<instantiation>:15:74: error: too many positional arguments
 PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
                                                                         ^
arch/x86/crypto/aesni-intel_asm.S:1686:2: note: while in macro instantiation
 GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
 ^
<instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
 GHASH_4_ENCRYPT_4_PARALLEL_enc %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
 ^
arch/x86/crypto/aesni-intel_asm.S:1687:2: note: while in macro instantiation
 GCM_ENC_DEC enc

Craig Topper suggested me in ClangBuiltLinux issue #1050:

> I think the "too many positional arguments" is because the parser isn't able
> to handle the trailing commas.
>
> The "unknown use of instruction mnemonic" is because the macro was named
> GHASH_4_ENCRYPT_4_PARALLEL_DEC but its being instantiated with
> GHASH_4_ENCRYPT_4_PARALLEL_dec I guess gas ignores case on the
> macro instantiation, but llvm doesn't.

First, I removed the trailing comma in the PRECOMPUTE line.

Second, I substituted:
1. GHASH_4_ENCRYPT_4_PARALLEL_DEC -> GHASH_4_ENCRYPT_4_PARALLEL_dec
2. GHASH_4_ENCRYPT_4_PARALLEL_ENC -> GHASH_4_ENCRYPT_4_PARALLEL_enc

With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.

I confirmed that this works with Linux-kernel v5.7.5 final.

NOTE: This patch is on top of Linux v5.7 final.

Thanks to Craig and especially Nick for double-checking and his comments.

Suggested-by: Craig Topper <craig.topper@intel.com>
Suggested-by: Craig Topper <craig.topper@gmail.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1050
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
Changes v3->v4:
- Add <> around email address as desired by Nick
- Add Nick's Reviewed-by

Changes v2->v3:
- Add this Changelog

Changes v1->v2:
- Replace Cc by Suggested-by for Craig
- Replace Cc by Suggested-by for Nick (dropped Cc as desired)
- Really follow the suggestions of Craig
- Drop unneeded comments for my build-environment and Links

 arch/x86/crypto/aesni-intel_asm.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index cad6e1bfa7d5..c216de287742 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -266,7 +266,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	PSHUFB_XMM %xmm2, %xmm0
 	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
 
-	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7
 	movdqu HashKey(%arg2), %xmm13
 
 	CALC_AAD_HASH %xmm13, \AAD, \AADLEN, %xmm0, %xmm1, %xmm2, %xmm3, \
@@ -978,7 +978,7 @@ _initial_blocks_done\@:
 * arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
-.macro GHASH_4_ENCRYPT_4_PARALLEL_ENC TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro GHASH_4_ENCRYPT_4_PARALLEL_enc TMP1 TMP2 TMP3 TMP4 TMP5 \
 TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
 	movdqa	  \XMM1, \XMM5
@@ -1186,7 +1186,7 @@ aes_loop_par_enc_done\@:
 * arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
-.macro GHASH_4_ENCRYPT_4_PARALLEL_DEC TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro GHASH_4_ENCRYPT_4_PARALLEL_dec TMP1 TMP2 TMP3 TMP4 TMP5 \
 TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
 	movdqa	  \XMM1, \XMM5
-- 
2.27.0

