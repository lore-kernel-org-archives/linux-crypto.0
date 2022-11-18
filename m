Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A83C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 07:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiKRHXr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 02:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiKRHXm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 02:23:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B6763CF8
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:40 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id h193so4267910pgc.10
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 23:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hx1Gs7DKMSwlqX+L3NMTuQE+VIiAEjC78bnqZxl3Cn8=;
        b=I0XDnA3hU/VVNMfNiXnAAg2+4b8iW3X1e3Zgdc3IjvrEyaRfOWwl5FrhU/ZZyDvcQj
         mCOeY4dMsQwuCMKZyAG76hhUx2t4h7knrxVKFvq4Tz1AfhPpbXVbCRDleqWYZEghV0iM
         X7XaV6v0cAvjlmbe8HWEQX+Y6Gdboxe4UKKwWoGG9F15ihtCrZRrH58lqhPgkarRPqDD
         J5yiidLjxzhWYgXwanwQzlPldvH3flt4koU7JCyiZbwdmkNjM+UaaZJNsWbkNjg528PM
         wH1aYRClDGgKddmR+4Ndzs15L0SK6HEYFFxF6Snl9hVnU8p2HF3IdYykKS5OpQftyecE
         4DxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hx1Gs7DKMSwlqX+L3NMTuQE+VIiAEjC78bnqZxl3Cn8=;
        b=cTQv2941BRSRMoyQcl7NjsJsx0F2YWsN8oP34G68alAU4bQ1lcufpfeAyv091wr8Cd
         3J6yOmiuKNIOAZLcW+JKbPk7QcdiT/04hBEXGOHPr9lM/1katVNFyl24ZuhMeDcfvytI
         4vq0z2NhdKIhUL5eTSKsiz83Ome1qwDZNMbon4uvEuzWUz9WPZ31jbf5PZRaJLSE9iRF
         uDlhowT85ws8pDUWH/CZYn8DK9axATLaQAjaS8H4BZ8nVMNaRyCSqwQUM6M2arI1cyAM
         pxvcqvTwROotFjQpg54+DXOfUs5XsZRyFcyEFPK3arrek/XjEs0ed7EVde2lwUV3DLE1
         mglQ==
X-Gm-Message-State: ANoB5pnKGJwTFXzQ3/7yGPoK5yzIFfnkWK7tIpymcdV7v6Zp7fw/SfgZ
        XNf5NU7aE1OwnRySMf4Ikb5WBKzFZSc=
X-Google-Smtp-Source: AA0mqf56Xktl7afcUEeI0G5Y9/ojBFqnOrnB+M8DKExho8P6oAHBTnmt10I7hYd+D6q0ifyYxgKt/Q==
X-Received: by 2002:aa7:8487:0:b0:56c:3bb4:28a8 with SMTP id u7-20020aa78487000000b0056c3bb428a8mr6529951pfn.83.1668756220152;
        Thu, 17 Nov 2022 23:23:40 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id ix9-20020a170902f80900b001782a0d3eeasm2734228plb.115.2022.11.17.23.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 23:23:39 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v5 2/4] crypto: aria: do not use magic number offsets of aria_ctx
Date:   Fri, 18 Nov 2022 07:22:50 +0000
Message-Id: <20221118072252.10770-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118072252.10770-1-ap420073@gmail.com>
References: <20221118072252.10770-1-ap420073@gmail.com>
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

v5:
 - No changes.

v4:
 - Add BUILD_BUG_ON() to check size of fields of aria_ctx.

v3:
 - Patch introduced.

 arch/x86/crypto/aria-aesni-avx-asm_64.S | 26 +++++++++++--------------
 arch/x86/kernel/asm-offsets.c           | 11 +++++++++++
 crypto/aria_generic.c                   |  4 ++++
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index c75fd7d015ed..e47e7e54e08f 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -8,11 +8,7 @@
 
 #include <linux/linkage.h>
 #include <asm/frame.h>
-
-/* struct aria_ctx: */
-#define enc_key 0
-#define dec_key 272
-#define rounds 544
+#include <asm/asm-offsets.h>
 
 /* register macros */
 #define CTX %rdi
@@ -873,7 +869,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
 		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		%rax, %r9, 10);
-	cmpl $12, rounds(CTX);
+	cmpl $12, ARIA_CTX_rounds(CTX);
 	jne .Laria_192;
 	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -886,7 +882,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	aria_fo(%xmm9, %xmm8, %xmm11, %xmm10, %xmm12, %xmm13, %xmm14, %xmm15,
 		%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		%rax, %r9, 12);
-	cmpl $14, rounds(CTX);
+	cmpl $14, ARIA_CTX_rounds(CTX);
 	jne .Laria_256;
 	aria_ff(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -922,7 +918,7 @@ SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -947,7 +943,7 @@ SYM_FUNC_START(aria_aesni_avx_decrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq dec_key(CTX), %r9;
+	leaq ARIA_CTX_dec_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1055,7 +1051,7 @@ SYM_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	leaq (%rdx), %r11;
 	leaq (%rcx), %rsi;
 	leaq (%rcx), %rdx;
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	call __aria_aesni_avx_crypt_16way;
 
@@ -1156,7 +1152,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 		     %xmm0, %xmm1, %xmm2, %xmm3,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
 		     %rax, %r9, 10);
-	cmpl $12, rounds(CTX);
+	cmpl $12, ARIA_CTX_rounds(CTX);
 	jne .Laria_gfni_192;
 	aria_ff_gfni(%xmm1, %xmm0, %xmm3, %xmm2, %xmm4, %xmm5, %xmm6, %xmm7,
 		%xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1173,7 +1169,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 		     %xmm0, %xmm1, %xmm2, %xmm3,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
 		     %rax, %r9, 12);
-	cmpl $14, rounds(CTX);
+	cmpl $14, ARIA_CTX_rounds(CTX);
 	jne .Laria_gfni_256;
 	aria_ff_gfni(%xmm1, %xmm0, %xmm3, %xmm2,
 		     %xmm4, %xmm5, %xmm6, %xmm7,
@@ -1217,7 +1213,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1242,7 +1238,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 
 	FRAME_BEGIN
 
-	leaq dec_key(CTX), %r9;
+	leaq ARIA_CTX_dec_key(CTX), %r9;
 
 	inpack16_pre(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		     %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14,
@@ -1274,7 +1270,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	leaq (%rdx), %r11;
 	leaq (%rcx), %rsi;
 	leaq (%rcx), %rdx;
-	leaq enc_key(CTX), %r9;
+	leaq ARIA_CTX_enc_key(CTX), %r9;
 
 	call __aria_aesni_avx_gfni_crypt_16way;
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cb50589a7102..32192a91c65b 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -7,6 +7,7 @@
 #define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
+#include <crypto/aria.h>
 #include <linux/sched.h>
 #include <linux/stddef.h>
 #include <linux/hardirq.h>
@@ -109,6 +110,16 @@ static void __used common(void)
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
 
+#if defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) ||  \
+	defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64_MODULE)
+
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
2.17.1

