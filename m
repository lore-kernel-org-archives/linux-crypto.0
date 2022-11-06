Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFE0C4332F
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 14:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKFOhy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 09:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiKFOht (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 09:37:49 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69B4DEB8
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 06:37:47 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u6so8919372plq.12
        for <linux-crypto@vger.kernel.org>; Sun, 06 Nov 2022 06:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hD6uAvy9J7vwxqLchDyF0qqglXabp73+7LquhHbZf4s=;
        b=MhzHmvLfGyjCkqfD5GFpymXzXGLchi28u57te9p67zpzFy0t1Fdaz2/BCQxS+3OkiX
         TutrnptQYt/BIgPvHv0ejmfeBHRhn+ebFomuEndhf4hXiCGVh3fUrYnKZ2FrEw7nnsfm
         rVRq7oASaqzfmC/OqCk0oqGdFaMCwMM0RNnVEPL8u6gWSX4tEGFuowhZ16u8LXuOTgBq
         yU5UCdRhTxVHOBGjTM1QxB07836peKVyfo23boioeFqcQxpRY6zl0Y1HGCsk09Z1NcC1
         Sije2VPx4RQ5J7UKo6mhJhHVfc68q+ON3UgYvZNZbDM4Ce1bTeGyRfQd430xChbebsyo
         X/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hD6uAvy9J7vwxqLchDyF0qqglXabp73+7LquhHbZf4s=;
        b=opGn+jNxkbsppYTuA/vxI5aZ5nkkbUETjZOvmeiKLhG25SBaRQnJDcMwCi3GUDjWme
         sNDU/eJ8eQEJBiSO1QSBz7ZQKbagD/67ctX5+Ii715Y26ygJdTaX4U0/0c78GPfDKc4I
         gkUUREJ1hN0NBThvid+VPemgmMZ0PRshmrtpa7gNVPXD6NgXtEtGllajqX5Gwbzyp6zW
         6FSUeiE+HYWwl2q8D6KxDLVlfzUwQq0VrVwLmK9a1jf4cDSPpxwk0LItlolm6dXAJuEW
         NNicG7uk7pAALW/bvuF8jtrQFPt2LdLuoGmtvVEtqVAdoZumSx9K+G+O0pCQXUBtXAQb
         URHA==
X-Gm-Message-State: ANoB5plHXjYJgydNgWXvoyZvRNneVL5QW8TSL7PjF1E1wNNX1HjneLAy
        KAhNG0j8jtKt1ZMqSLLIZz1b2f/2pD8ofw==
X-Google-Smtp-Source: AA0mqf5ElSG9if6Yc3fybKIIGG3zIA4B04nxJ3ERufrj0yHeoPL0tQb64zW8foLYTVzEj9mzRQFq+g==
X-Received: by 2002:a17:902:8304:b0:188:6863:d334 with SMTP id bd4-20020a170902830400b001886863d334mr12198653plb.9.1667745467259;
        Sun, 06 Nov 2022 06:37:47 -0800 (PST)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k26-20020aa7973a000000b0056da2ad6503sm2696580pfg.39.2022.11.06.06.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 06:37:46 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Cc:     ap420073@gmail.com
Subject: [PATCH v3 2/4] crypto: aria: do not use magic number offsets of aria_ctx
Date:   Sun,  6 Nov 2022 14:36:25 +0000
Message-Id: <20221106143627.30920-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221106143627.30920-1-ap420073@gmail.com>
References: <20221106143627.30920-1-ap420073@gmail.com>
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

v3:
 - Patch introduced.

 arch/x86/crypto/aria-aesni-avx-asm_64.S | 26 +++++++++++--------------
 arch/x86/kernel/asm-offsets.c           | 11 +++++++++++
 2 files changed, 22 insertions(+), 15 deletions(-)

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
-- 
2.17.1

