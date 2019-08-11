Return-Path: <SRS0=+H67=WH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0B2C0650F
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 950A82084D
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Aug 2019 22:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pbNLyV8b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfHKW7b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Aug 2019 18:59:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52706 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfHKW7b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Aug 2019 18:59:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so10539608wms.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Aug 2019 15:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NdlkfYolXkiJlDnDSe4O3QjW41knJBAaFb7TIELDbHQ=;
        b=pbNLyV8bnXHnNatF6b/yKRL+M/BxVcZIk7gICdle+gopoNDWbwOojNw/cJirgcUHGw
         +GDnRMsor26jbxCA1P/zlrX2nU1hg0I6ShjytVlVQQvTVugZ6wpV5nedwJwtTwb4MtNH
         QiL09d8sz4JuJJ5JP6lFiYtJ9519/vwJtXzhf7DYBJYoQ0GiXMS902B5zQVupLRBvT4h
         gRtIv4M3+k/j9xmOXAvuB7T0hKP3S+h1wM8j5xy+2pQkEnd7oe8uVWy5+VwhswpTT88o
         Yxdh3yc7nHyYQhCmzyco7psQLFlu5s6Bk20RbV3bLHgCGjElKkcsu8C61IFIgYXA6NGV
         6+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NdlkfYolXkiJlDnDSe4O3QjW41knJBAaFb7TIELDbHQ=;
        b=uiNWF+p6Ej5g3a4V0liaAIESpZPlyf3OrAS4sOWD8t8xs+7/62dsBflYgrjNbfv1qg
         JCToXnRposF3vhEynoYubX4fNl8983TmP5GObnzIGp88RCG91D3JVurL/HgbltOlldpc
         aj0Hiz5GHRPKn6H7WCw/ACipxh/X5eu6Trg4ttjmyAyjmZ2+AOw0nH0r8/gbrwELcT08
         A6yGdU64e5H1td8lPKk+WATtpYmTzIdE0nsW9zNzy3UmBMIrvw/EckwAG3g6XnQNGCkC
         HNPHKD/qLzBiQUjWBG+8iI6rHqpke0NHpTNJjEF1AFBPC3WoRCDwUmNhRAU8OGgCZkWL
         zUjw==
X-Gm-Message-State: APjAAAU8d60yXfi27SGtsM/JmFUpEii4n7C0vj6bDouX+8DLUZr3jLVK
        MWRNVfR7O167PvA4Xqbqkf1J0hkRSD3Njg==
X-Google-Smtp-Source: APXvYqzMdKP+BBMI8AJdZ1zJhqQteKiCJ27Gje1RUHj9eTJ41ZwfVGEpRCvwS7m8ZUhiIYGnJAagmw==
X-Received: by 2002:a1c:968c:: with SMTP id y134mr23989984wmd.75.1565564367293;
        Sun, 11 Aug 2019 15:59:27 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:5df1:4fcc:7bd1:4860])
        by smtp.gmail.com with ESMTPSA id a17sm5930888wmm.47.2019.08.11.15.59.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 15:59:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/3] crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
Date:   Mon, 12 Aug 2019 01:59:11 +0300
Message-Id: <20190811225912.19412-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
References: <20190811225912.19412-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Provide an accelerated implementation of aegis128 by wiring up the
SIMD hooks in the generic driver to an implementation based on NEON
intrinsics, which can be compiled to both ARM and arm64 code.

This results in a performance of 2.2 cycles per byte on Cortex-A53,
which is a performance increase of ~11x compared to the generic
code.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Kconfig               |   5 +
 crypto/Makefile              |  12 ++
 crypto/aegis128-neon-inner.c | 147 ++++++++++++++++++++
 crypto/aegis128-neon.c       |  43 ++++++
 4 files changed, 207 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8880c1fc51d8..455a3354e291 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -306,6 +306,11 @@ config CRYPTO_AEGIS128
 	help
 	 Support for the AEGIS-128 dedicated AEAD algorithm.
 
+config CRYPTO_AEGIS128_SIMD
+	bool "Support SIMD acceleration for AEGIS-128"
+	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
+	default y
+
 config CRYPTO_AEGIS128_AESNI_SSE2
 	tristate "AEGIS-128 AEAD algorithm (x86_64 AESNI+SSE2 implementation)"
 	depends on X86 && 64BIT
diff --git a/crypto/Makefile b/crypto/Makefile
index 92e985714ff6..99a9fa9087d1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -91,6 +91,18 @@ obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
+
+ifeq ($(ARCH),arm)
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
+CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
+aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
+endif
+ifeq ($(ARCH),arm64)
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -mcpu=generic+crypto
+CFLAGS_REMOVE_aegis128-neon-inner.o += -mgeneral-regs-only
+aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
+endif
+
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
new file mode 100644
index 000000000000..3d8043c4832b
--- /dev/null
+++ b/crypto/aegis128-neon-inner.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#ifdef CONFIG_ARM64
+#include <asm/neon-intrinsics.h>
+
+#define AES_ROUND	"aese %0.16b, %1.16b \n\t aesmc %0.16b, %0.16b"
+#else
+#include <arm_neon.h>
+
+#define AES_ROUND	"aese.8 %q0, %q1 \n\t aesmc.8 %q0, %q0"
+#endif
+
+#define AEGIS_BLOCK_SIZE	16
+
+#include <stddef.h>
+
+void *memcpy(void *dest, const void *src, size_t n);
+void *memset(void *s, int c, size_t n);
+
+struct aegis128_state {
+	uint8x16_t v[5];
+};
+
+static struct aegis128_state aegis128_load_state_neon(const void *state)
+{
+	return (struct aegis128_state){ {
+		vld1q_u8(state),
+		vld1q_u8(state + 16),
+		vld1q_u8(state + 32),
+		vld1q_u8(state + 48),
+		vld1q_u8(state + 64)
+	} };
+}
+
+static void aegis128_save_state_neon(struct aegis128_state st, void *state)
+{
+	vst1q_u8(state, st.v[0]);
+	vst1q_u8(state + 16, st.v[1]);
+	vst1q_u8(state + 32, st.v[2]);
+	vst1q_u8(state + 48, st.v[3]);
+	vst1q_u8(state + 64, st.v[4]);
+}
+
+static inline __attribute__((always_inline))
+uint8x16_t aegis_aes_round(uint8x16_t w)
+{
+	uint8x16_t z = {};
+
+	/*
+	 * We use inline asm here instead of the vaeseq_u8/vaesmcq_u8 intrinsics
+	 * to force the compiler to issue the aese/aesmc instructions in pairs.
+	 * This is much faster on many cores, where the instruction pair can
+	 * execute in a single cycle.
+	 */
+	asm(AES_ROUND : "+w"(w) : "w"(z));
+	return w;
+}
+
+static inline __attribute__((always_inline))
+struct aegis128_state aegis128_update_neon(struct aegis128_state st,
+					   uint8x16_t m)
+{
+	m       ^= aegis_aes_round(st.v[4]);
+	st.v[4] ^= aegis_aes_round(st.v[3]);
+	st.v[3] ^= aegis_aes_round(st.v[2]);
+	st.v[2] ^= aegis_aes_round(st.v[1]);
+	st.v[1] ^= aegis_aes_round(st.v[0]);
+	st.v[0] ^= m;
+
+	return st;
+}
+
+void crypto_aegis128_update_neon(void *state, const void *msg)
+{
+	struct aegis128_state st = aegis128_load_state_neon(state);
+
+	st = aegis128_update_neon(st, vld1q_u8(msg));
+
+	aegis128_save_state_neon(st, state);
+}
+
+void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
+					unsigned int size)
+{
+	struct aegis128_state st = aegis128_load_state_neon(state);
+	uint8x16_t msg;
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+
+		msg = vld1q_u8(src);
+		st = aegis128_update_neon(st, msg);
+		vst1q_u8(dst, msg ^ s);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		uint8_t buf[AEGIS_BLOCK_SIZE] = {};
+
+		memcpy(buf, src, size);
+		msg = vld1q_u8(buf);
+		st = aegis128_update_neon(st, msg);
+		vst1q_u8(buf, msg ^ s);
+		memcpy(dst, buf, size);
+	}
+
+	aegis128_save_state_neon(st, state);
+}
+
+void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
+					unsigned int size)
+{
+	struct aegis128_state st = aegis128_load_state_neon(state);
+	uint8x16_t msg;
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		msg = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		st = aegis128_update_neon(st, msg);
+		vst1q_u8(dst, msg);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		uint8x16_t s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		uint8_t buf[AEGIS_BLOCK_SIZE];
+
+		vst1q_u8(buf, s);
+		memcpy(buf, src, size);
+		msg = vld1q_u8(buf) ^ s;
+		vst1q_u8(buf, msg);
+		memcpy(dst, buf, size);
+
+		st = aegis128_update_neon(st, msg);
+	}
+
+	aegis128_save_state_neon(st, state);
+}
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
new file mode 100644
index 000000000000..c1c0a1686f67
--- /dev/null
+++ b/crypto/aegis128-neon.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Linaro Ltd <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/cpufeature.h>
+#include <asm/neon.h>
+
+#include "aegis.h"
+
+void crypto_aegis128_update_neon(void *state, const void *msg);
+void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
+					unsigned int size);
+void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
+					unsigned int size);
+
+bool crypto_aegis128_have_simd(void)
+{
+	return cpu_have_feature(cpu_feature(AES));
+}
+
+void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
+{
+	kernel_neon_begin();
+	crypto_aegis128_update_neon(state, msg);
+	kernel_neon_end();
+}
+
+void crypto_aegis128_encrypt_chunk_simd(union aegis_block *state, u8 *dst,
+					const u8 *src, unsigned int size)
+{
+	kernel_neon_begin();
+	crypto_aegis128_encrypt_chunk_neon(state, dst, src, size);
+	kernel_neon_end();
+}
+
+void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
+					const u8 *src, unsigned int size)
+{
+	kernel_neon_begin();
+	crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
+	kernel_neon_end();
+}
-- 
2.17.1

