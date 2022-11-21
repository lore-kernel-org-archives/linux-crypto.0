Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33808C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 00:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiKUAkZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Nov 2022 19:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiKUAkW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Nov 2022 19:40:22 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8990C13F3E
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:21 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso9404451pjt.0
        for <linux-crypto@vger.kernel.org>; Sun, 20 Nov 2022 16:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSILp4vuZ/9/PSrg60kgFdMgohA9w2zNBfI2tU7OgkU=;
        b=WcDoDaj0lT0XrLNS3JJ3EMTOlSIX+o5s7tPHHMZYQDeRf+rZ4kjMrw97i0tTbaM7Et
         ox9WTWGTdQr5f8YYt96S/Ne1NFCXKkIs0GBZhc3EsZaB96K+qA/In5y2XoJiSVAVWQBP
         4WDrqWiyghZCMDQn/I8nM85eisdco+wF2fMkzMgXnNmi4pZ5/8nRvWsHRW0BuqVzmoF/
         Dj/AFqfUubuLYrzsazwSjFxDrGrpLj+YzylIELgeYI62/pix0wJRb5PxvZlGd2P+9foP
         5onpg+bENjGgE2jVrI5o9edBYJjWHqbrci51t5CTzMUuiMaQkVOwKzcg0WM4KB3ImYBl
         7IQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSILp4vuZ/9/PSrg60kgFdMgohA9w2zNBfI2tU7OgkU=;
        b=E/PLmtGC6uLUoiSS+ySegW1VeZ3n11+BpNoBX72W74XuYSWckHpTqdcrrQOOc8pCNa
         AG9O4qYxik6TgaIm4sqvMgEqPnvOBo6RIw4zzk56OGS3+mmOgDn9xX/4BgO8h9lkmXHM
         RruYh/W50nV5plRXI7HqeGM9v/hDo0ElH91ZM6/7lLBkVbr+lyvkz329l1nSjYIRGPmx
         5/WO5i8H7lNOY/VPga+37z7XI4GqZM1/istfkVtv1yDSBVeZGBuhEGpPvLVdHPMMHrx6
         qFxMT2V3oT5G4GZUmskRc8x+zLeTc1Eg/YYUmLX75+jiobEjDWyXOmtf53upW3DQcZXE
         nk6w==
X-Gm-Message-State: ANoB5plVyMby6WD23RBR2KSRB25z9O1fB+1rzX+6Xg/XNo0e0qhCs9xY
        uEKFrIrrvCfibdUH+Ey27WUTDn9EG94=
X-Google-Smtp-Source: AA0mqf6JaIhwcrgGrJZewUGDccIXjNmJ7x/cPFnlUlX/M+Qs7kMFmeoPqvOw1Y0GJag5PCs7DtzKLg==
X-Received: by 2002:a17:902:f813:b0:187:12cc:d6f1 with SMTP id ix19-20020a170902f81300b0018712ccd6f1mr4556807plb.63.1668991220863;
        Sun, 20 Nov 2022 16:40:20 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902680d00b001837b19ebb8sm8075682plk.244.2022.11.20.16.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 16:40:20 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v6 2/4] crypto: aria: do not use magic number offsets of aria_ctx
Date:   Mon, 21 Nov 2022 00:39:53 +0000
Message-Id: <20221121003955.2214462-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121003955.2214462-1-ap420073@gmail.com>
References: <20221121003955.2214462-1-ap420073@gmail.com>
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

v6:
 - Rebase for "CFI fixes" patchset.
   https://lore.kernel.org/linux-crypto/20221118194421.160414-1-ebiggers@kernel.org/T/#t

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
2.34.1

