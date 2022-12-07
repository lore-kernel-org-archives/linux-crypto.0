Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA36C63705
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 13:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLGN72 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 08:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLGN7S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 08:59:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D470D5BD78
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 05:59:17 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q15so16631798pja.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Dec 2022 05:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VUmk0rgc9lOkWV+hZsb7izFv/K4EbuRmRzXdHPUrwg=;
        b=jNPoXna5+f+MKmJTpiNfrEdoznqtFT+kv/vXPwO9KxWRytlg5iKqQyNtFctims6FFH
         G042WrOaN79SQSbd/kTvbVvibvJDm6I87f1OFv375FVVmiw21tYNQ7mdedxWpPOED7r8
         wDj4Sf+8zLRMH1FPF/fxrXb7dSlmqWphhrBQSxMT3vgV8eXg8aGpyclH8nw+zOF7bhL2
         FRpOJeRrYP/lTnS7g8qNnrQGZtzxq2pu55CcuJd50varh7KAqK+lY5ZdUeX3ONjZ46+z
         VNrS89vU8mqlSlxU7rwn7xD5R33Tietlmu6N55VfTxajnV9RoaQjDC2O1sg2Gfps0mHR
         i/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+VUmk0rgc9lOkWV+hZsb7izFv/K4EbuRmRzXdHPUrwg=;
        b=c4hUJqdkdaQFiiZfZE4RbhD6WvKrNNINIW4N7WVdyTTquwy3bbneZuT/NRyAtO9DFo
         EYA4hrKKGOx3djMZOEP0wroAnTolkUyVjdbmZSAG6LWKggyhpPXUKw7YowdZd0CfCbBR
         9Ol9JSK9f508sBBXFkXqUVEIzlVQdW9SIT0X89YPy2Qtryff8kiD/9zyQGk5nuY0xScV
         R4jcYfmls0daeDQFOQGMslnTdq8kEtsGsFJxoG+P7YLjQWiPZyzKqZisO9s3cAVZoU7g
         gvBS5oNTpRzhaamw2M13gRlISdn5PkPcT4TZRTJkfnGQK2WWDywsm0DlD6UECpUqkFxk
         1ruw==
X-Gm-Message-State: ANoB5pkFbWaHAG7HJm26KsC/zE2Z5q+G4zJ7XnhnFjhYMumSB5gAPqGI
        P98KldpjBRcX80cD+Y9esfjwpvK1Cm+RHA==
X-Google-Smtp-Source: AA0mqf7Vyr1igm90vkcqPVNIBQv77Kq1UsffzFFmXvfsMvNCuiZTmmCvCHSVWJsvvKV6SLCkBe8mCA==
X-Received: by 2002:a17:903:410b:b0:189:911a:6b5a with SMTP id r11-20020a170903410b00b00189911a6b5amr640799pld.31.1670421556677;
        Wed, 07 Dec 2022 05:59:16 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001885041d7b8sm14554619pln.293.2022.12.07.05.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:59:15 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     elliott@hpe.com, jussi.kivilinna@iki.fi, ebiggers@kernel.org,
        ap420073@gmail.com
Subject: [PATCH v7 2/4] crypto: aria: do not use magic number offsets of aria_ctx
Date:   Wed,  7 Dec 2022 13:58:53 +0000
Message-Id: <20221207135855.459181-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221207135855.459181-1-ap420073@gmail.com>
References: <20221207135855.459181-1-ap420073@gmail.com>
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
 arch/x86/kernel/asm-offsets.c           |  9 +++++++++
 crypto/aria_generic.c                   |  4 ++++
 3 files changed, 24 insertions(+), 15 deletions(-)

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
index cb50589a7102..9a31f7942f5c 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
 #define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
+#include <crypto/aria.h>
 #include <linux/sched.h>
 #include <linux/stddef.h>
 #include <linux/hardirq.h>
@@ -109,6 +110,14 @@ static void __used common(void)
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
 
+#if IS_ENABLED(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64)
+	/* Offset for fields in aria_ctx */
+	BLANK();
+	OFFSET(ARIA_CTX_enc_key, aria_ctx, enc_key);
+	OFFSET(ARIA_CTX_dec_key, aria_ctx, dec_key);
+	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
+#endif
+
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 		BLANK();
 		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
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

