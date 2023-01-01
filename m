Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CBCC3DA7D
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Jan 2023 09:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjAAJNP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Jan 2023 04:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjAAJNO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Jan 2023 04:13:14 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53795FB9
        for <linux-crypto@vger.kernel.org>; Sun,  1 Jan 2023 01:13:12 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w203so383080pfc.12
        for <linux-crypto@vger.kernel.org>; Sun, 01 Jan 2023 01:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7PblET/JPCaN/XieDyKJG3ZqPclmmA6nXCaO7S6B1M=;
        b=L2P1db7LmzAVPlbyKkRvVOCLVHJaEIvBwkcPK1JKfajxoL3J18+Mlirh06Vvu8EYBO
         DQiymhLzzaS34bqWnJvuEBnrNocRv8AOUOlzMr9pI3hTTqojNKB+A0nwlaBUWOZZ8VLh
         NtlX/t5w905hkYZ5ltn6tNsxxUfIcdFASPSys1Zp0fu1svJqUi8isXVpZe5X143B1tyP
         yU/yuhxwXpnovPtQELrgmyyJNQR9cvGHwBQba3n7A+TFWERLnBIujn6JSkIPiufdQ/rK
         cbTNaH9oCctwvYV4KWGeXiTbFzkcvf9YMYwb6NGjLyKIjoVLD23H3U8VsubF9bXZe0xq
         Grnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7PblET/JPCaN/XieDyKJG3ZqPclmmA6nXCaO7S6B1M=;
        b=WFJIMv48+ouLqp5KPtQBteRSIqSn1tPvCxLfMT+0Lwx4KlCeb0KpCeKQ6zpatPkZoy
         myBfwKKYmnsQlz414z6VZFuI0iJzkYrgTULReUTt/HZyAjCfy/Ted9dYi39ZBipbaIiZ
         siAaL0seB00rchJHpJ3YTl6pB8ZCgY83Wv/6IJgwOlRulxCBlUk3CjGih8+SGeEdvcnb
         thzNgObSeqGChbqkPmNRA+QTs1UnSae39h9ot8ZjA0N8OZWSqYSfutC2kWLdEAgKe8L7
         ztRPSuE/f93UI6K2kKMbGYXhoGYZKKYOarPMFiGdXoUNbH7NZ7FKkwyt8xTEJRsWOP/7
         SgQw==
X-Gm-Message-State: AFqh2koxaZSpUUeKr1joDwhcsXPbfGLNAkMqMjcEHJIs9CfgKsViPZ0V
        YnQGX3JMsat8pF9b/mVJyY1i2hLyoUNDyQ==
X-Google-Smtp-Source: AMrXdXugi4csOh2CIQc8Pm3sTFtw0JbU9pPu0KFK41lR0C5Ns2GS51KdO+ZbVzH7i8/IJ3OxUCFBJA==
X-Received: by 2002:a05:6a00:d1:b0:580:eb71:40f0 with SMTP id e17-20020a056a0000d100b00580eb7140f0mr30796962pfj.23.1672564391525;
        Sun, 01 Jan 2023 01:13:11 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa79d1a000000b0058130f1eca1sm10951327pfp.182.2023.01.01.01.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 01:13:10 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v8 2/4] crypto: aria: do not use magic number offsets of aria_ctx
Date:   Sun,  1 Jan 2023 09:12:50 +0000
Message-Id: <20230101091252.700117-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230101091252.700117-1-ap420073@gmail.com>
References: <20230101091252.700117-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

aria-avx assembly code accesses members of aria_ctx with magic number
offset. If the shape of struct aria_ctx is changed carelessly,
aria-avx will not work.
So, we need to ensure accessing members of aria_ctx with correct
offset values, not with magic numbers.

It adds ARIA_CTX_enc_key, ARIA_CTX_dec_key, and ARIA_CTX_rounds in the
asm-offsets.c So, correct offset definitions will be generated.
aria-avx assembly code can access members of aria_ctx safely with
these definitions.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v8:
 - Rebase

v7:
 - Use IS_ENABLED() instead of defined()

v6:
 - Rebase for "CFI fixes" patchset.

v5:
 - No changes.

v4:
 - Add BUILD_BUG_ON() to check size of fields of aria_ctx.

v3:
 - Patch introduced.

 arch/x86/crypto/aria-aesni-avx-asm_64.S | 26 +++++++++++--------------
 arch/x86/kernel/asm-offsets.c           |  8 ++++++++
 crypto/aria_generic.c                   |  4 ++++
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index 03ae4cd1d976..be6adc6e7458 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -8,13 +8,9 @@
 
 #include <linux/linkage.h>
 #include <linux/cfi_types.h>
+#include <asm/asm-offsets.h>
 #include <asm/frame.h>
 
-/* struct aria_ctx: */
-#define enc_key 0
-#define dec_key 272
-#define rounds 544
-
 /* register macros */
 #define CTX %rdi
 
@@ -874,7 +870,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
 		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		%rax, %r9, 10);
-	cmpl $12, rounds(CTX);
+	cmpl $12, ARIA_CTX_rounds(CTX);
 	jne .Laria_192;
 	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -887,7 +883,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
 		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		%rax, %r9, 12);
-	cmpl $14, rounds(CTX);
+	cmpl $14, ARIA_CTX_rounds(CTX);
 	jne .Laria_256;
 	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -923,7 +919,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_encrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -948,7 +944,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_decrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq dec_key(CTX), %r9;
+	leaq ARIA_CTX_dec_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1056,7 +1052,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	leaq (%rdx), %r11;
 	leaq (%rcx), %rsi;
 	leaq (%rcx), %rdx;
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	call __aria_aesni_avx_crypt_16way;
 
@@ -1157,7 +1153,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 		     %xmm0, %xmm1, %xmm2, %xmm3,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
 		     %rax, %r9, 10);
-	cmpl $12, rounds(CTX);
+	cmpl $12, ARIA_CTX_rounds(CTX);
 	jne .Laria_gfni_192;
 	aria_ff_gfni(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1174,7 +1170,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 		     %xmm0, %xmm1, %xmm2, %xmm3,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
 		     %rax, %r9, 12);
-	cmpl $14, rounds(CTX);
+	cmpl $14, ARIA_CTX_rounds(CTX);
 	jne .Laria_gfni_256;
 	aria_ff_gfni(%xmm1, %xmm0, %xmm3, %xmm2,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
@@ -1218,7 +1214,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1243,7 +1239,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq dec_key(CTX), %r9;
+	leaq ARIA_CTX_dec_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1275,7 +1271,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	leaq (%rdx), %r11;
 	leaq (%rcx), %rsi;
 	leaq (%rcx), %rdx;
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	call __aria_aesni_avx_gfni_crypt_16way;
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 82c783da16a8..ef9e951415c5 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
 #define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
+#include <crypto/aria.h>
 #include <linux/sched.h>
 #include <linux/stddef.h>
 #include <linux/hardirq.h>
@@ -111,5 +112,12 @@ static void __used common(void)
 #ifdef CONFIG_CALL_DEPTH_TRACKING
 	OFFSET(X86_call_depth, pcpu_hot, call_depth);
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64)
+	/* Offset for fields in aria_ctx */
+	BLANK();
+	OFFSET(ARIA_CTX_enc_key, aria_ctx, enc_key);
+	OFFSET(ARIA_CTX_dec_key, aria_ctx, dec_key);
+	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
+#endif
 
 }
diff --git a/crypto/aria_generic.c b/crypto/aria_generic.c
index 4cc29b82b99d..d96dfc4fdde6 100644
--- a/crypto/aria_generic.c
+++ b/crypto/aria_generic.c
@@ -178,6 +178,10 @@ int aria_set_key(struct crypto_tfm *tfm, const u8 *in_key, unsigned int key_len)
 	if (key_len != 16 && key_len != 24 && key_len != 32)
 		return -EINVAL;
 
+	BUILD_BUG_ON(sizeof(ctx->enc_key) != 272);
+	BUILD_BUG_ON(sizeof(ctx->dec_key) != 272);
+	BUILD_BUG_ON(sizeof(int) != sizeof(ctx->rounds));
+
 	ctx->key_length = key_len;
 	ctx->rounds = (key_len + 32) / 4;
 
-- 
2.34.1

