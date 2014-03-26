From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64: add support for GHASH secure hash using ARMv8 Crypto Extensions
Date: Wed, 26 Mar 2014 21:02:57 +0100
Message-ID: <1395864177-30115-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, steve.capper@linaro.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48903 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbaCZUCk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Mar 2014 16:02:40 -0400
Received: by mail-wg0-f49.google.com with SMTP id a1so1634605wgh.8
        for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2014 13:02:39 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a port to ARMv8 (Crypto Extensions) of the Intel implementation of the
GHASH Secure Hash (used in the Galois/Counter chaining mode). It relies on the
optional PMULL/PMULL2 instruction (polynomial multiply long, what Intel call
carry-less multiply).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Only mildly tested, mainly because the internal tcrypt routine only supplies
a single test vector for ghash. 

Again, this patch requires the NEON patches to allow kernel mode NEON in 
(soft)irq context.


 arch/arm64/crypto/Kconfig         |   5 ++
 arch/arm64/crypto/Makefile        |   3 +
 arch/arm64/crypto/ghash-ce-core.S | 119 +++++++++++++++++++++++++++++++
 arch/arm64/crypto/ghash-ce-glue.c | 143 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 270 insertions(+)
 create mode 100644 arch/arm64/crypto/ghash-ce-core.S
 create mode 100644 arch/arm64/crypto/ghash-ce-glue.c

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2e869f4b925a..7b5da897a904 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -42,4 +42,9 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_AES
 	select CRYPTO_ABLK_HELPER
 
+config CRYPTO_GHASH_ARM64_CE
+	tristate "GHASH (for GCM chaining mode) using ARMv8 Crypto Extensions"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 23fbe222cba8..8ad5c8fc8527 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -33,3 +33,6 @@ CFLAGS_aes-glue-ce.o	:= -DUSE_V8_CRYPTO_EXTENSIONS
 
 $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
 	$(call if_changed_dep,cc_o_c)
+
+obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
+ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
new file mode 100644
index 000000000000..a150ad7cae65
--- /dev/null
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -0,0 +1,119 @@
+/*
+ * Accelerated GHASH implementation with ARMv8 PMULL instructions.
+ *
+ * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * Based on arch/x86/crypto/ghash-pmullni-intel_asm.S
+ *
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *           Vinodh Gopal
+ *           Erdinc Ozturk
+ *           Deniz Karakoyunlu
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	DATA	.req	v0
+	SHASH	.req	v1
+	T1	.req	v2
+	T2	.req	v3
+	T3	.req	v4
+	T4	.req	v5
+	IN1	.req	v5
+
+	.text
+	.arch		armv8-a+crypto
+	.align		3
+
+	/*
+	 * void pmull_ghash_update(char *dst, const char *src, u32 blocks,
+	 * 			   const be128 *shash, const char *head);
+	 */
+ENTRY(pmull_ghash_update)
+	ld1		{DATA.2d}, [x0]
+	ld1		{SHASH.2d}, [x3]
+
+	/* do the head block first, if supplied */
+	cbz		x4, 0f
+	ld1		{IN1.2d}, [x4], #16
+	b		1f
+
+0:	sub		w2, w2, #1
+	ld1		{IN1.2d}, [x1], #16
+1:	rev64		IN1.16b, IN1.16b
+CPU_LE(	ext		IN1.16b, IN1.16b, IN1.16b, #8	)
+	eor		DATA.16b, DATA.16b, IN1.16b
+
+	/* multiply DATA by SHASH in GF(2^128) */
+	eor		T4.16b, T4.16b, T4.16b
+	ext		T2.16b, DATA.16b, DATA.16b, #8
+	ext		T3.16b, SHASH.16b, SHASH.16b, #8
+	eor		T2.16b, T2.16b, DATA.16b
+	eor		T3.16b, T3.16b, SHASH.16b
+
+	pmull2		T1.1q, SHASH.2d, DATA.2d	// a1 * b1
+	pmull		DATA.1q, SHASH.1d, DATA.1d	// a0 * b0
+	pmull		T2.1q, T2.1d, T3.1d		// (a1 + a0)(b1 + b0)
+	eor		T2.16b, T2.16b, T1.16b		// (a0 * b1) + (a1 * b0)
+	eor		T2.16b, T2.16b, DATA.16b
+
+	ext		T3.16b, T4.16b, T2.16b, #8
+	ext		T2.16b, T2.16b, T4.16b, #8
+	eor		DATA.16b, DATA.16b, T3.16b
+	eor		T1.16b, T1.16b, T2.16b	// <T1:DATA> is result of
+						// carry-less multiplication
+
+	/* first phase of the reduction */
+	shl		T3.2d, DATA.2d, #1
+	eor		T3.16b, T3.16b, DATA.16b
+	shl		T3.2d, T3.2d, #5
+	eor		T3.16b, T3.16b, DATA.16b
+	shl		T3.2d, T3.2d, #57
+	ext		T2.16b, T4.16b, T3.16b, #8
+	ext		T3.16b, T3.16b, T4.16b, #8
+	eor		DATA.16b, DATA.16b, T2.16b
+	eor		T1.16b, T1.16b, T3.16b
+
+	/* second phase of the reduction */
+	ushr		T2.2d, DATA.2d, #5
+	eor		T2.16b, T2.16b, DATA.16b
+	ushr		T2.2d, T2.2d, #1
+	eor		T2.16b, T2.16b, DATA.16b
+	ushr		T2.2d, T2.2d, #1
+	eor		T1.16b, T1.16b, T2.16b
+	eor		DATA.16b, DATA.16b, T1.16b
+
+	cbnz		w2, 0b
+
+	st1		{DATA.2d}, [x0]
+	ret
+ENDPROC(pmull_ghash_update)
+
+	/*
+	 * void pmull_ghash_setkey(be128 *shash, const u8 *key);
+	 *
+	 * Calculate hash_key << 1 mod poly
+	 */
+ENTRY(pmull_ghash_setkey)
+	ldp		x2, x3, [x1]
+	movz		x4, #0xc200, lsl #48	// BE GF(2^128) multiply mask
+CPU_LE(	rev		x5, x2		)
+CPU_LE(	rev		x6, x3		)
+CPU_BE(	mov		x5, x3		)
+CPU_BE(	mov		x6, x2		)
+	asr		x7, x5, #63
+	lsl		x2, x6, #1
+	and		x1, x4, x7
+	extr		x3, x5, x6, #63
+	and		x7, x7, #1
+	eor		x3, x3, x1
+	eor		x2, x2, x7
+	stp		x2, x3, [x0]
+	ret
+ENDPROC(pmull_ghash_setkey)
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
new file mode 100644
index 000000000000..1147646a3155
--- /dev/null
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -0,0 +1,143 @@
+/*
+ * Accelerated GHASH implementation with ARMv8 PMULL instructions.
+ *
+ * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <crypto/gf128mul.h>
+#include <crypto/internal/hash.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("GHASH secure hash using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
+
+asmlinkage void pmull_ghash_update(char *dst, const char *src, unsigned int len,
+				   const be128 *shash, const char *head);
+
+asmlinkage void pmull_ghash_setkey(be128 *shash, const u8 *key);
+
+struct ghash_desc_ctx {
+	u8 digest[GHASH_DIGEST_SIZE];
+	u8 buf[GHASH_BLOCK_SIZE];
+	u32 count;
+};
+
+static int ghash_init(struct shash_desc *desc)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	*dctx = (struct ghash_desc_ctx){};
+	return 0;
+}
+
+static int ghash_update(struct shash_desc *desc, const u8 *src,
+			unsigned int len)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	unsigned int partial = dctx->count % GHASH_BLOCK_SIZE;
+
+	dctx->count += len;
+
+	if ((partial + len) >= GHASH_BLOCK_SIZE) {
+		be128 *skey = crypto_shash_ctx(desc->tfm);
+		int blocks;
+
+		if (partial) {
+			int p = GHASH_BLOCK_SIZE - partial;
+
+			memcpy(dctx->buf + partial, src, p);
+			src += p;
+			len -= p;
+		}
+
+		blocks = len / GHASH_BLOCK_SIZE;
+		len %= GHASH_BLOCK_SIZE;
+
+		kernel_neon_begin_partial(6);
+		pmull_ghash_update(dctx->digest, src, blocks, skey,
+				   partial ? dctx->buf : NULL);
+		kernel_neon_end();
+
+		src += blocks * GHASH_BLOCK_SIZE;
+		partial = 0;
+	}
+	if (len)
+		memcpy(dctx->buf + partial, src, len);
+	return 0;
+}
+
+static int ghash_final(struct shash_desc *desc, u8 *dst)
+{
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	int i;
+
+	if (dctx->count % GHASH_BLOCK_SIZE) {
+		be128 *skey = crypto_shash_ctx(desc->tfm);
+
+		kernel_neon_begin_partial(6);
+		pmull_ghash_update(dctx->digest, NULL, 0, skey, dctx->buf);
+		kernel_neon_end();
+	}
+	for (i = 0; i < GHASH_DIGEST_SIZE; i++)
+		dst[i] = dctx->digest[GHASH_DIGEST_SIZE - i - 1];
+
+	return 0;
+}
+
+static int ghash_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	be128 *skey = crypto_shash_ctx(tfm);
+
+	if (keylen != GHASH_BLOCK_SIZE) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	pmull_ghash_setkey(skey, key);
+	return 0;
+}
+
+static struct shash_alg ghash_alg = {
+	.digestsize	= GHASH_DIGEST_SIZE,
+	.init		= ghash_init,
+	.update		= ghash_update,
+	.final		= ghash_final,
+	.setkey		= ghash_setkey,
+	.descsize	= sizeof(struct ghash_desc_ctx),
+	.base		= {
+		.cra_name		= "ghash",
+		.cra_driver_name	= "ghash-ce",
+		.cra_priority		= 200,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		= GHASH_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(be128),
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int __init ghash_ce_mod_init(void)
+{
+	return crypto_register_shash(&ghash_alg);
+}
+
+static void __exit ghash_ce_mod_exit(void)
+{
+	crypto_unregister_shash(&ghash_alg);
+}
+
+module_cpu_feature_match(PMULL, ghash_ce_mod_init);
+module_exit(ghash_ce_mod_exit);
-- 
1.8.3.2
