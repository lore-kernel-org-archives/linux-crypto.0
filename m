Return-Path: <SRS0=7Iqi=AE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5A3C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 02:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 312B82076A
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jun 2020 02:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEQ7YxmZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbgFWC4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731690AbgFWC4p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 22:56:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884FFC061573;
        Mon, 22 Jun 2020 19:56:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so11168550wrv.9;
        Mon, 22 Jun 2020 19:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/BofogEfeQVfNgtBmc2nr4iEEvcla131+c62MG7kwA=;
        b=vEQ7YxmZkw4i1jY213l04Kxe69/SGvtG7G1SdY0lGUgr1i3qDNKysprhO8yJW95q6h
         /AFhvX7Tz6x021sCBU0fMGqllc41TuMYfOfAOnfZRpSQCwCNXV2wnwLKRVas/9lWBWO7
         J39PpL8d1yUZBmmDC22LFutwTCGgmW1BH3MnbJPVNV5+8w3u7ijU21w9J3aY4vyOT9+E
         yh2Q5SQulHZspuajvuStFl1TQ9slXhoIQxuHeJg566dBLkDWRDs8qrN8t6HH5yqzWM7D
         VTkK2489DIP2hf0I8KFbgWdVZ/qVEnT5w/dVjJE0bnDuf4Ydg8KIbZG6iQxPN8yGBtfb
         +YlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/BofogEfeQVfNgtBmc2nr4iEEvcla131+c62MG7kwA=;
        b=eBst1pD0TUntMElowW69paWP0DU5d/GE/Vzbm16lZZ8HhD+FsMSSdN4iEXeQh4RcdB
         cHsF2pJESNNApfiJ6DkIrfYAE3ofoMvP+TqMpOTDsBOcHPi4yUV48PRQal5oLGMrtd2+
         XW1UbKV/KK11pxrksdLHNja3MOsVTfZ8BXZw1Jfg3VgiNRu1fIaqsmwG9wTCUNuIOEqT
         SfiglW4JqTzIGaCnuNKOgWfRkmUYut7sVg1j0Ewad8gC0noFAyg88ML0G9rSUFUhsbiG
         QINV02zGk/eOrmA+CqeoBcFBwb4ImmV/H3Gx1sq73F8ZlRpLeFQBT8elB7ufRNED57eH
         AKvA==
X-Gm-Message-State: AOAM532VoPV8J88HPQ8d4PGvTQBB8kZf7IMo0djD9YAikgc5rVYslErR
        lAWmn35o0rYv+fuRWmboHhY=
X-Google-Smtp-Source: ABdhPJzgLhWjEMhIWXiGtmsAzMyIqNAW/sVxTbrAeW80IdtGbxc/Xvke7jLJdg3Bk0+zP6wy2rtilg==
X-Received: by 2002:a5d:5191:: with SMTP id k17mr14638169wrv.20.1592881002258;
        Mon, 22 Jun 2020 19:56:42 -0700 (PDT)
Received: from localhost.localdomain ([46.114.107.138])
        by smtp.gmail.com with ESMTPSA id 33sm14071179wri.16.2020.06.22.19.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 19:56:41 -0700 (PDT)
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
        Craig Topper <craig.topper@gmail.com>
Subject: [PATCH 5.7 v2] x86/crypto: aesni: Fix build with LLVM_IAS=1
Date:   Tue, 23 Jun 2020 04:56:28 +0200
Message-Id: <20200623025628.18467-1-sedat.dilek@gmail.com>
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
Suggested-by: Nick Desaulniers ndesaulniers@google.com
Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1050
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
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

