Return-Path: <SRS0=31iC=U5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A372C4646D
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56FEB20665
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jAEh968g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfF3Quw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jun 2019 12:50:52 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43606 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF3Quv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jun 2019 12:50:51 -0400
Received: by mail-lf1-f68.google.com with SMTP id j29so7094419lfk.10
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jun 2019 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2fhhk6ne1j0h8wXOjZ8yduwEiqI6CLZ1Ulh6iFFMD0A=;
        b=jAEh968gR96glnrSDtAfXCGYi1z5e9bjORafRgvqTNM0jqJLnnVRytGQG5VgpKqCOx
         n/osaKyUx6UbWDItmBF04oeeyikdKoIRQW6ygIioH2KjejjTgnSxnFZ4w9RQFA1Mlrom
         S5TKzoBjVI6FmQCwHO642U/9spuh5/ZjE4Xh5nQQT2xUmOWHyMz80IfG9gPmPpAoxANP
         X0OQDx1KdqXD0q6hyHMy4CY8UTJj9hD+IP+WKtqT3zZ3Ea38bRR85GZ4nzVsR72JrZOO
         urKukDXJSy4aiz83UrKezwOY2st+CuaIHCcKt3VlQtFekSM7icoOEmaEzaqopAn1alZq
         LKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2fhhk6ne1j0h8wXOjZ8yduwEiqI6CLZ1Ulh6iFFMD0A=;
        b=DxfljT8UmYLoQbwkC8Rpne2bwZY1kf6OggjRmDkPEU1RIAvAcVnzXiRYx7A0U7E2bM
         E0dPAsw1m8gbmrL4JQW3ynBJgZD42G4QI2z2ObsBZZtDAtuNHW/3xl43K5ee+Je8el0R
         STiahI2Y1fzdVMVFWQv6XW4zv6xcnUAQ7HJQPhkQgXH8MlhanIkDL2EqwNk62PXUgwa4
         jyoUx0UXM+Ssbosfd41eqNrC8x43Yp56ckmtnvxzsOQylnssPKHKLU96Rrs7TAZn0ITF
         Tumwda4L5sx/LcdLX9O6+5lvwXvfeNf9v+9jYg/0jQZ8jLrhXvN2AK2/4mnFGbJ9N4W2
         k5zQ==
X-Gm-Message-State: APjAAAUsC3sFIO7NsbSAonVeqZKTYyAGpV2uLG8brXUnNAU4ewjpkuW3
        Sf222xalPF1AMGD9F0EXgjukIbGCIwVWqQ==
X-Google-Smtp-Source: APXvYqypx5PRMg5hz05naAsnyYmO0KOCPoSwSQtBPpxAOXlF1tbFLd6u21DePGESY4RTdai5Va7vWg==
X-Received: by 2002:a19:6a01:: with SMTP id u1mr9521835lfu.141.1561913448221;
        Sun, 30 Jun 2019 09:50:48 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id t15sm2097367lff.94.2019.06.30.09.50.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 09:50:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 6/7] crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
Date:   Sun, 30 Jun 2019 18:50:30 +0200
Message-Id: <20190630165031.26365-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
References: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
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
index 000000000000..520514f72508
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
+static uint8x16_t __attribute__((always_inline)) aegis_aes_round(uint8x16_t w)
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

