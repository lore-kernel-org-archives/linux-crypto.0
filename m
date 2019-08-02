Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBDBC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357D5204EC
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zo26S0Go"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392898AbfHBPQJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 11:16:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43394 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbfHBPPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 11:15:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so3009125wru.10
        for <linux-crypto@vger.kernel.org>; Fri, 02 Aug 2019 08:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TlVvhVRKhldZAjA+dsxP3GAvHSktet3CoiBjkDLc8JY=;
        b=zo26S0Go0qqUPlu9DsiOLCEiDOQMgUYzLWsC0x4LLrnJxvx/UTxGD6euyFhCIFdEoo
         2pnZfDCr9CqM3wzeP7SoHt2wgki6Rxt2VuYTk8GKXE4Qo2tsiHW0xVKiGQvqEU7YqfxP
         g+KU7N2YkulYt/eQrYQldeIM0JoluwGpm43QDiz7b1Lv4lZrDvLiX1oQSEmuUrqotlR+
         Ke1RTDdvSceeRPUT3dBuka3mJxYCi/+v1X2Ew/Y+PryKb8q1u/YsFMfCb6uMf/vC03fL
         bxbPQ07D/XOXTKjaDwb8izOVyeZ8ZA9hwsWtLvZo9KN01o2QMmqPzdKrErOduepcvsgY
         07Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TlVvhVRKhldZAjA+dsxP3GAvHSktet3CoiBjkDLc8JY=;
        b=WuB9ArhyZscfo/sSHbB2I2nIB22Bqx2McA3Oe/hBjROIgQr1h3hq6dbRb1xyxstjMB
         fPRSh7i6pjvil5v0zEo14l+yCz6cNURl/VRwmmIlYKLAczKN3qMI2EcowDboRHlT4O3h
         DFcyrbgiMUz3Gt0c73PUTyWYVFo98hkxay5tLiNXh50sUiMsjurB/HF7AbCp0pVUvtw3
         nb1uDZoGj2xJHIh2HYEOUsk06/pdIRsG2cnxesi6q3a7qOHCufDsk98WRfau08526iQQ
         tmaJZuYwYAtuWOahyu8ybXwcv/PBTbUyzBd0zaCmSO3sgBOl8o5M9goTV38i/6ip5kyP
         /RQg==
X-Gm-Message-State: APjAAAVB9MzSrf2DcwSLZvBu5dehYJMidYOHbqJMO9Kipd7IOSTuR9Td
        L5hhwE7laqleWE56YCHux1AGzoVkSRsBBA==
X-Google-Smtp-Source: APXvYqxi65WjCD+1q8we+utV6Veq+dy9xlkb0WZngfyvMstQKS3vanRDi7ZuvkrxavSXROIzu8T3aQ==
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr10403366wrs.93.1564758937944;
        Fri, 02 Aug 2019 08:15:37 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a424:b400:cc84:8d83:a434:dd7])
        by smtp.gmail.com with ESMTPSA id o3sm63294321wrs.59.2019.08.02.08.15.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:15:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH RFC 3/3] crypto: arm64/aegis128 - implement plain NEON version
Date:   Fri,  2 Aug 2019 18:15:10 +0300
Message-Id: <20190802151510.17074-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
References: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide a version of the core AES transform to the aegis128 SIMD
code that does not rely on the special AES instructions, but uses
plain NEON instructions instead. This allows the SIMD version of
the aegis128 driver to be used on arm64 systems that do not
implement those instructions (which are not mandatory in the
architecture), such as the Raspberry Pi 3.

Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Makefile              |  5 ++
 crypto/aegis128-neon-inner.c | 53 ++++++++++++++++++++
 crypto/aegis128-neon.c       | 16 +++++-
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 99a9fa9087d1..c3760c7616ac 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -99,6 +99,11 @@ aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
 ifeq ($(ARCH),arm64)
 CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
+CFLAGS_aegis128-neon-inner.o += -ffixed-q14 -ffixed-q15
+CFLAGS_aegis128-neon-inner.o += -ffixed-q16 -ffixed-q17 -ffixed-q18 -ffixed-q19
+CFLAGS_aegis128-neon-inner.o += -ffixed-q20 -ffixed-q21 -ffixed-q22 -ffixed-q23
+CFLAGS_aegis128-neon-inner.o += -ffixed-q24 -ffixed-q25 -ffixed-q26 -ffixed-q27
+CFLAGS_aegis128-neon-inner.o += -ffixed-q28 -ffixed-q29 -ffixed-q30 -ffixed-q31
 CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index 6aca2f425b6d..7aa4cef3c2de 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -17,6 +17,8 @@
 
 #include <stddef.h>
 
+extern int aegis128_have_aes_insn;
+
 void *memcpy(void *dest, const void *src, size_t n);
 void *memset(void *s, int c, size_t n);
 
@@ -49,6 +51,32 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
 {
 	uint8x16_t z = {};
 
+#ifdef CONFIG_ARM64
+	if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
+		uint8x16_t v;
+
+		// shift rows
+		asm("tbl %0.16b, {%0.16b}, v14.16b" : "+w"(w));
+
+		// sub bytes
+		asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
+		w -= 0x40;
+		asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
+
+		// mix columns
+		w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
+		w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
+		asm("tbl %0.16b, {%1.16b}, v15.16b" : "=w"(v) : "w"(v ^ w));
+		w ^= v;
+
+		return w;
+	}
+#endif
+
 	/*
 	 * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
 	 * to force the compiler to issue the aese/aesmc instructions in pairs.
@@ -149,3 +177,28 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 
 	aegis128_save_state_neon(st, state);
 }
+
+#ifdef CONFIG_ARM64
+void crypto_aegis128_init_neon(void)
+{
+	u64 tmp;
+
+	asm volatile(
+	    "adrp		%0, crypto_aes_sbox		\n\t"
+	    "add		%0, %0, :lo12:crypto_aes_sbox	\n\t"
+	    "mov		v14.16b, %1.16b			\n\t"
+	    "mov		v15.16b, %2.16b			\n\t"
+	    "ld1		{v16.16b-v19.16b}, [%0], #64	\n\t"
+	    "ld1		{v20.16b-v23.16b}, [%0], #64	\n\t"
+	    "ld1		{v24.16b-v27.16b}, [%0], #64	\n\t"
+	    "ld1		{v28.16b-v31.16b}, [%0]		\n\t"
+	    : "=&r"(tmp)
+	    : "w"((uint8x16_t){ // shift rows permutation vector
+			0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
+			0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb, }),
+	      "w"((uint8x16_t){ // ror32 permutation vector
+			0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
+			0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,	})
+	);
+}
+#endif
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index c1c0a1686f67..72f9d48e4963 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -14,14 +14,24 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
 
+void crypto_aegis128_init_neon(void);
+
+int aegis128_have_aes_insn __ro_after_init;
+
 bool crypto_aegis128_have_simd(void)
 {
-	return cpu_have_feature(cpu_feature(AES));
+	if (cpu_have_feature(cpu_feature(AES))) {
+		aegis128_have_aes_insn = 1;
+		return true;
+	}
+	return IS_ENABLED(CONFIG_ARM64);
 }
 
 void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
 {
 	kernel_neon_begin();
+	if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
+		crypto_aegis128_init_neon();
 	crypto_aegis128_update_neon(state, msg);
 	kernel_neon_end();
 }
@@ -30,6 +40,8 @@ void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
 	kernel_neon_begin();
+	if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
+		crypto_aegis128_init_neon();
 	crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
 	kernel_neon_end();
 }
@@ -38,6 +50,8 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
 					const u8 *src, unsigned int size)
 {
 	kernel_neon_begin();
+	if (IS_ENABLED(CONFIG_ARM64) && !aegis128_have_aes_insn)
+		crypto_aegis128_init_neon();
 	crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
 	kernel_neon_end();
 }
-- 
2.17.1

