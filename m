Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B695FC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbiKRTqj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiKRTqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D85DEBC
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9065262782
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E88C433C1;
        Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800786;
        bh=pclA3LA8eoFmKTrqSAJh4mYcWrvybcXjZP/RNOkyKcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baeL6vobI7CZ5qsql2NjsgVd2NX3vsNjyXPqOkD9r/8ri1L43BvyGRYwqJ0GWLo8V
         bzIXh8dC3LswOmK2RxnFmlzWXc29fOD0mpjm+gOuALMNvDUI2SQi5Oxxk5uVnLtZbw
         o0W7thLe8AvO/Qwq36p6xejmKTQUFOlSj3ILSaaV3D3tYASC9TGKcG96t85shGigaL
         NQBOjzO2gixywvwmeeKbGmmQauoK1asj8ojR3LvtTspf3acolK5b+QljHMGT1nVNl2
         3IJ7fMnrIsjJRzvB3MMY0vl8n4OZ7IVPQ5HVQUOsR+OSNbeKihX1YRizy/38SbXyJf
         V2ZCXa5Bu7EMQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:17 -0800
Message-Id: <20221118194421.160414-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sm4_aesni_avx_ctr_enc_blk8(), sm4_aesni_avx_cbc_dec_blk8(),
sm4_aesni_avx_cfb_dec_blk8(), sm4_aesni_avx2_ctr_enc_blk16(),
sm4_aesni_avx2_cbc_dec_blk16(), and sm4_aesni_avx2_cfb_dec_blk16() are
called via indirect function calls.  Therefore they need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
Otherwise, the code crashes with a CFI failure.

(Or at least that should be the case.  For some reason the CFI checks in
sm4_avx_cbc_decrypt(), sm4_avx_cfb_decrypt(), and sm4_avx_ctr_crypt()
are not always being generated, using current tip-of-tree clang.
Anyway, this patch is a good idea anyway.)

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sm4-aesni-avx-asm_64.S  | 7 ++++---
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index 4767ab61ff489..22b6560eb9e1e 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -14,6 +14,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define rRIP         (%rip)
@@ -420,7 +421,7 @@ SYM_FUNC_END(sm4_aesni_avx_crypt8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_ctr_enc_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_ctr_enc_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
@@ -495,7 +496,7 @@ SYM_FUNC_END(sm4_aesni_avx_ctr_enc_blk8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
@@ -545,7 +546,7 @@ SYM_FUNC_END(sm4_aesni_avx_cbc_dec_blk8)
  *                                 const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
+SYM_TYPED_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (8 blocks)
diff --git a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
index 4732fe8bb65b6..23ee39a8ada8c 100644
--- a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
@@ -14,6 +14,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define rRIP         (%rip)
@@ -282,7 +283,7 @@ SYM_FUNC_END(__sm4_crypt_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_ctr_enc_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_ctr_enc_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
@@ -395,7 +396,7 @@ SYM_FUNC_END(sm4_aesni_avx2_ctr_enc_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
@@ -449,7 +450,7 @@ SYM_FUNC_END(sm4_aesni_avx2_cbc_dec_blk16)
  *                                   const u8 *src, u8 *iv)
  */
 .align 8
-SYM_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
+SYM_TYPED_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
 	/* input:
 	 *	%rdi: round key array, CTX
 	 *	%rsi: dst (16 blocks)
-- 
2.38.1

