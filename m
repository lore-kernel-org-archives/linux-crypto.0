Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DDBC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E6F22083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JCK771zE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfF1RIQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40232 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1RIP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so7043007wre.7
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pl6rgvK8O4r0l+FZOe/I16ciKJFVn0p0xgITZq5Cfpc=;
        b=JCK771zETGF3OokXVwahC28/u9TgS5P+8SUtUDkjj3m2SHRrtxJL/4PvppDelb2o2I
         hnXYtygyD3uSwPaPoDlW6aWJgNOzw7w92JAgPMrvCOCiCEa3zanmop15Ydvugz3roref
         8hAXcMk+pyMM1lK8pap2N+TBDesy0Bi6CihDs32PdQ6Cd3GCD4/Y85ZqOp7LbwaZ51nf
         QF5VHWeB18A4QGpMY/dAX0ghtJQ/XFBY+mVjabr5GObXm2se3VtxxFlLPC+1SxZSZcWL
         pn0IZILTaOTmS84D5IPoaMc6TB7sl1PrR31BZsdowJAxKHP3c47zApJIDYvSOea2QJd5
         oI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pl6rgvK8O4r0l+FZOe/I16ciKJFVn0p0xgITZq5Cfpc=;
        b=lDzdrTJXcdvqXbr8dfXdVjwNadgirwIOXSvTqoBH2haX3n+CMD18/7ikzBaQB7F+Wy
         1DArRwdWkYv4XEYD1GukLraneVWgKIYlNT8wIi7SCt/7Uv9TAvBWKdX2Ub7dn2H1Cin5
         AANd3VMMI40PxkTpUkZcYUiV3+8OJKU5NmJHaqFcSIJo5LK7HAxzW4G3dV8vZCJ7rsBc
         oPeA7+7eAKQtG3ZfqBY1PUJb9PpB429RS7FG0PPcXRDQa9vg8oc4dXWCg2eGVzQCmOYH
         WpAhL+Yn2NssQBgPXAq8Mrd/2BSsjBgR6AfgvT3b52KSIvk65tKe53d8eAPmi5yifZLs
         RBUw==
X-Gm-Message-State: APjAAAWdXSgydH3eMTuU0RZLsgZ4c+o4rJcqBOh9a1lrnLHSopKrSXHK
        xpNtgbkdJm+T2yicE3gQT3ib53RLjm8/yA==
X-Google-Smtp-Source: APXvYqyQR3VsBGfTHhV0AVqrJDAtK6N+21gSMuYm5yS+w2ZiF+Jj8i3dO0TItje52lpUmQOhxiLrRw==
X-Received: by 2002:a05:6000:11c2:: with SMTP id i2mr5172431wrx.199.1561741692928;
        Fri, 28 Jun 2019 10:08:12 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 6/7] crypto: aegis128 - provide a SIMD implementation based on NEON intrinsics
Date:   Fri, 28 Jun 2019 19:07:45 +0200
Message-Id: <20190628170746.28768-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 crypto/aegis128-neon-inner.c | 132 ++++++++++++++++++++
 crypto/aegis128-neon.c       |  43 +++++++
 4 files changed, 191 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4b948dac21db..1af99189d2b6 100644
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
 config CRYPTO_AEGIS128L
 	tristate "AEGIS-128L AEAD algorithm"
 	select CRYPTO_AEAD
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
index 000000000000..0479970a2f25
--- /dev/null
+++ b/crypto/aegis128-neon-inner.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#ifdef CONFIG_ARM64
+#include <asm/neon-intrinsics.h>
+#else
+#include <arm_neon.h>
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
+static struct aegis128_state aegis128_update_neon(struct aegis128_state st,
+						  uint8x16_t m)
+{
+	uint8x16_t z = {};
+	uint8x16_t t;
+
+	t        = vaesmcq_u8(vaeseq_u8(st.v[3], z));
+	st.v[3] ^= vaesmcq_u8(vaeseq_u8(st.v[2], z));
+	st.v[2] ^= vaesmcq_u8(vaeseq_u8(st.v[1], z));
+	st.v[1] ^= vaesmcq_u8(vaeseq_u8(st.v[0], z));
+	st.v[0] ^= vaesmcq_u8(vaeseq_u8(st.v[4], z)) ^ m;
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
2.20.1

