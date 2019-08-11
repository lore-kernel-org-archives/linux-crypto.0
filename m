Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC6FC433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A4C2084D
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wy/cf3sM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfHKW7c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 18:59:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38097 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfHKW7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 18:59:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id m125so6123494wmm.3
        for <linux-crypto@vger.kernel.org>; Sun, 11 Aug 2019 15:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AWsY2soOMxAD12H34LvTvFzff/WUbKiZ2Byzr98+9CE=;
        b=wy/cf3sMMgiSvzTXFMbmS7h0Mhvph+S/NHLixX1zQdYlr683eAAoVKqRmwqhsqquR9
         12euTzNqgruvc8jguJyQStdac7TcEHZxSpfSRERPeUDdMGfRVhLdnaKYAyQzb3I0uaZY
         rNVTQgiQslhz9pmrfrRbKI9ToZk4stlk+NxEQCueNd9OY+B/dc7+8jGb406/AC8yeQK5
         mY9+2IsXhzPeAqbO7EdLcGbCuQHvqn13LMzIvxuGGuAlT2Xv8pN6gPQKCk+ozzoHoQmU
         llw449Gne0ww0PTYYyltJ4nA6jdCvuLWKM9CfBdC+H3hIeM9jMzDnOlisIHnxZzzafXS
         ahaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AWsY2soOMxAD12H34LvTvFzff/WUbKiZ2Byzr98+9CE=;
        b=hWeXwMmNn2ksZP2NXPUhVz0RcCnyWxyJDUXMHtR++vQbgTD8WxD8I5CnhcutB/YhHx
         4CtATJ1+RXtcHP1NOQFLmufhKvfRnN5OQ1LdMjtwUGD7fFtSC3CDzR4V2J0PmMwuehhE
         fkqmNX39J220JMeMPfEFkGckTlfzoS0b1A5jKFhuz28d10tQV5syeWFHhoj0NbCjgcdU
         CxODzAH6l7DroIohlfG2mMlO91hU5CU1MBHCUTZWJoUPIkTXuSIwTTdGzxj9d1gYr/nF
         NhR0vIQoNfsZXqvFSOLsxR9D7KM8vGjmdxE5RdgKcPnLTBnjuRxyuEnCYZwuzN+/q691
         P4Dg==
X-Gm-Message-State: APjAAAV/N8Jd9/QRz69LsPVOnebTJHg/YO7jYEzXj7CN5ViwR7gx69n+
        HzhxCyO14vM780Hyk6JB2chciAAmj3tTMA==
X-Google-Smtp-Source: APXvYqyYdi02jzLVcvQq3H4NR8X0UNZPHvmjYB7akbU+vHk6HkTmdgRkrGuJvqTjupR2yYdJAFZ/Ew==
X-Received: by 2002:a1c:61d4:: with SMTP id v203mr23504532wmb.164.1565564369426;
        Sun, 11 Aug 2019 15:59:29 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:5df1:4fcc:7bd1:4860])
        by smtp.gmail.com with ESMTPSA id a17sm5930888wmm.47.2019.08.11.15.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 15:59:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v2 3/3] crypto: arm64/aegis128 - implement plain NEON version
Date:   Mon, 12 Aug 2019 01:59:12 +0300
Message-Id: <20190811225912.19412-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
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

Since GCC makes a mess of this when using the tbl/tbx intrinsics
to perform the sbox substitution, preload the Sbox into v16..v31
in this case and use inline asm to emit the tbl/tbx instructions.
Clang does not support this approach, nor does it require it, since
it does a much better job at code generation, so there we use the
intrinsics as usual.

Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Makefile              |  9 ++-
 crypto/aegis128-neon-inner.c | 65 ++++++++++++++++++++
 crypto/aegis128-neon.c       |  8 ++-
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 99a9fa9087d1..0d2cdd523fd9 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -98,7 +98,14 @@ CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
 ifeq ($(ARCH),arm64)
-CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
+aegis128-cflags-y := -ffreestanding -mcpu=generic+crypto
+aegis128-cflags-$(CONFIG_CC_IS_GCC) += -ffixed-q16 -ffixed-q17 -ffixed-q18 \
+				       -ffixed-q19 -ffixed-q20 -ffixed-q21 \
+				       -ffixed-q22 -ffixed-q23 -ffixed-q24 \
+				       -ffixed-q25 -ffixed-q26 -ffixed-q27 \
+				       -ffixed-q28 -ffixed-q29 -ffixed-q30 \
+				       -ffixed-q31
+CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
 CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
 aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
 endif
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index 3d8043c4832b..ed55568afd1b 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -17,6 +17,8 @@
 
 #include <stddef.h>
 
+extern int aegis128_have_aes_insn;
+
 void *memcpy(void *dest, const void *src, size_t n);
 void *memset(void *s, int c, size_t n);
 
@@ -24,6 +26,8 @@ struct aegis128_state {
 	uint8x16_t v[5];
 };
 
+extern const uint8x16x4_t crypto_aes_sbox[];
+
 static struct aegis128_state aegis128_load_state_neon(const void *state)
 {
 	return (struct aegis128_state){ {
@@ -49,6 +53,46 @@ uint8x16_t aegis_aes_round(uint8x16_t w)
 {
 	uint8x16_t z = {};
 
+#ifdef CONFIG_ARM64
+	if (!__builtin_expect(aegis128_have_aes_insn, 1)) {
+		static const uint8x16_t shift_rows = {
+			0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
+			0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb,
+		};
+		static const uint8x16_t ror32by8 = {
+			0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
+			0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,
+		};
+		uint8x16_t v;
+
+		// shift rows
+		w = vqtbl1q_u8(w, shift_rows);
+
+		// sub bytes
+		if (!IS_ENABLED(CONFIG_CC_IS_GCC)) {
+			v = vqtbl4q_u8(crypto_aes_sbox[0], w);
+			v = vqtbx4q_u8(v, crypto_aes_sbox[1], w - 0x40);
+			v = vqtbx4q_u8(v, crypto_aes_sbox[2], w - 0x80);
+			v = vqtbx4q_u8(v, crypto_aes_sbox[3], w - 0xc0);
+		} else {
+			asm("tbl %0.16b, {v16.16b-v19.16b}, %1.16b" : "=w"(v) : "w"(w));
+			w -= 0x40;
+			asm("tbx %0.16b, {v20.16b-v23.16b}, %1.16b" : "+w"(v) : "w"(w));
+			w -= 0x40;
+			asm("tbx %0.16b, {v24.16b-v27.16b}, %1.16b" : "+w"(v) : "w"(w));
+			w -= 0x40;
+			asm("tbx %0.16b, {v28.16b-v31.16b}, %1.16b" : "+w"(v) : "w"(w));
+		}
+
+		// mix columns
+		w = (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b);
+		w ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v);
+		w ^= vqtbl1q_u8(v ^ w, ror32by8);
+
+		return w;
+	}
+#endif
+
 	/*
 	 * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
 	 * to force the compiler to issue the aese/aesmc instructions in pairs.
@@ -73,10 +117,27 @@ struct aegis128_state aegis128_update_neon(struct aegis128_state st,
 	return st;
 }
 
+static inline __attribute__((always_inline))
+void preload_sbox(void)
+{
+	if (!IS_ENABLED(CONFIG_ARM64) ||
+	    !IS_ENABLED(CONFIG_CC_IS_GCC) ||
+	    __builtin_expect(aegis128_have_aes_insn, 1))
+		return;
+
+	asm("ld1	{v16.16b-v19.16b}, [%0], #64	\n\t"
+	    "ld1	{v20.16b-v23.16b}, [%0], #64	\n\t"
+	    "ld1	{v24.16b-v27.16b}, [%0], #64	\n\t"
+	    "ld1	{v28.16b-v31.16b}, [%0]		\n\t"
+	    :: "r"(crypto_aes_sbox));
+}
+
 void crypto_aegis128_update_neon(void *state, const void *msg)
 {
 	struct aegis128_state st = aegis128_load_state_neon(state);
 
+	preload_sbox();
+
 	st = aegis128_update_neon(st, vld1q_u8(msg));
 
 	aegis128_save_state_neon(st, state);
@@ -88,6 +149,8 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 	struct aegis128_state st = aegis128_load_state_neon(state);
 	uint8x16_t msg;
 
+	preload_sbox();
+
 	while (size >= AEGIS_BLOCK_SIZE) {
 		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
 
@@ -120,6 +183,8 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 	struct aegis128_state st = aegis128_load_state_neon(state);
 	uint8x16_t msg;
 
+	preload_sbox();
+
 	while (size >= AEGIS_BLOCK_SIZE) {
 		msg = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
 		st = aegis128_update_neon(st, msg);
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index c1c0a1686f67..751f9c195aa4 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -14,9 +14,15 @@ void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
 
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
-- 
2.17.1

