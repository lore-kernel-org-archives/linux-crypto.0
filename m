Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7333AC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43185218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KZ4LMAa3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGCIz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:56 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46621 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGCIz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:56 -0400
Received: by mail-lf1-f67.google.com with SMTP id z15so1162186lfh.13
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=egvNxjOeLhrDD4jglz9NICY+N4jVUR+FprZkEgKOqVQ=;
        b=KZ4LMAa35wv7F+9AmmOxAHZZGNcLvHGuT38/3e6gOMEeOka2NOy+XcS6GeVC2vVQ7H
         2hlhf4eI+ljjKO7K6oRPFoy2ECbpOUKSo8L13rbksB1jWRNleSFcBkKf6kwV1wmSe7RV
         XcOyQb429/xmgf6VyX575bgKAJvwGeApXNNHW0AKvZA/VtIOzoa9ae5s8avwWDdP8WWa
         LEwD3pPifBs9NbkEdUoxlgnCCANRKv6JFs6NT/yujaT7jCKUTj0eu/PO80172XtQy0B4
         sErER3NJvQNwP741olaMu7tEaqsnecDQ5RWTY6IF98ftWiMxI3KVU2aDLb0sF4Q/CUMZ
         S0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=egvNxjOeLhrDD4jglz9NICY+N4jVUR+FprZkEgKOqVQ=;
        b=EpE0CUpeUOuyJyVR5KRK4DYE78YXNBjUiF9sAAEDz4xmpBZLgtnAkmtldsusaVjjFw
         4pnxcZhXyQShh8jxkSOJqKJOhDefCINiz4DPSySgAgI6Ierafk7GsvUs6l7/9zuwcpLo
         U4Madic7lvumT1ICLKOb/dL53F/a/FlaLy2CC4yfhX/AmiyGj9obrdFbNT8jRgWYY25/
         UlWCUDmO0F5tJI2st6tpWuIE24tBWRfv66m//G71LlPtDKm/3R0KoHlV6K1E/EvuXAqz
         7ldsiKVfoeHhGsfrzJ3nQqiihJV2V43VO6kJD3b80bGtwLFpFA6EE+KHC2CkAN9uOrJE
         Vk/Q==
X-Gm-Message-State: APjAAAUXRFkKvD3fr/Pk60JqNohNBo0wZpGrCQKzXgt86BrgBZYE3YAs
        ykloKgn7dIVrjq7GH3aQKtG02cBr7N6QMJ9K
X-Google-Smtp-Source: APXvYqyq+qbFagpJj6Z+gDgvfS2slCfRqPwujcLyWymAnRAl9f/VWnxTCbD3eCHL0xgUUoSehs31Aw==
X-Received: by 2002:a19:850a:: with SMTP id h10mr10713503lfd.142.1562144153197;
        Wed, 03 Jul 2019 01:55:53 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 6/7] crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
Date:   Wed,  3 Jul 2019 10:55:11 +0200
Message-Id: <20190703085512.13915-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
References: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
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
---
 crypto/Kconfig               |   5 +
 crypto/Makefile              |  11 ++
 crypto/aegis128-neon-inner.c | 149 ++++++++++++++++++++
 crypto/aegis128-neon.c       |  43 ++++++
 4 files changed, 208 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7b4f537cdc9f..56fcb5b00466 100644
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
index 362a36f0bd2f..b3e16b4fb414 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -91,6 +91,17 @@ obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
 aegis128-y := aegis128-core.o
+
+ifeq ($(ARCH),arm)
+CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp -mfpu=crypto-neon-fp-armv8
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
index 000000000000..26e9450a5833
--- /dev/null
+++ b/crypto/aegis128-neon-inner.c
@@ -0,0 +1,149 @@
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
+static uint8x16_t aegis_aes_round(uint8x16_t w)
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
+static struct aegis128_state aegis128_update_neon(struct aegis128_state st,
+						  uint8x16_t m)
+{
+	uint8x16_t t;
+
+	t        = aegis_aes_round(st.v[3]);
+	st.v[3] ^= aegis_aes_round(st.v[2]);
+	st.v[2] ^= aegis_aes_round(st.v[1]);
+	st.v[1] ^= aegis_aes_round(st.v[0]);
+	st.v[0] ^= aegis_aes_round(st.v[4]) ^ m;
+	st.v[4] ^= t;
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
+	uint8x16_t tmp;
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		uint8x16_t s = vld1q_u8(src);
+
+		tmp = s ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		st = aegis128_update_neon(st, s);
+		vst1q_u8(dst, tmp);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		uint8_t buf[AEGIS_BLOCK_SIZE] = {};
+		uint8x16_t msg;
+
+		memcpy(buf, src, size);
+		msg = vld1q_u8(buf);
+		tmp = msg ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		st = aegis128_update_neon(st, msg);
+		vst1q_u8(buf, tmp);
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
+	uint8x16_t tmp;
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		tmp = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		st = aegis128_update_neon(st, tmp);
+		vst1q_u8(dst, tmp);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		uint8_t buf[AEGIS_BLOCK_SIZE] = {};
+		uint8x16_t msg;
+
+		memcpy(buf, src, size);
+		msg = vld1q_u8(buf) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4];
+		vst1q_u8(buf, msg);
+		memcpy(dst, buf, size);
+
+		memset(buf + size, 0, AEGIS_BLOCK_SIZE - size);
+		msg = vld1q_u8(buf);
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

