From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 7/8] crypto/arm64: sm3 - new v8.2 Crypto Extensions implementation
Date: Fri, 19 Jan 2018 12:04:39 +0000
Message-ID: <20180119120440.31556-8-ard.biesheuvel@linaro.org>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38063 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754232AbeASMF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:29 -0500
Received: by mail-wm0-f66.google.com with SMTP id 141so3048774wme.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:29 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Implement the Chinese SM3 secure hash algorithm using the new
special instructions that have been introduced as an optional
extension in ARMv8.2.

Tested-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig       |   6 +
 arch/arm64/crypto/Makefile      |   3 +
 arch/arm64/crypto/sm3-ce-core.S | 141 ++++++++++++++++++++
 arch/arm64/crypto/sm3-ce-glue.c |  92 +++++++++++++
 4 files changed, 242 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 3321b2c9a2b5..285c36c7b408 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -41,6 +41,12 @@ config CRYPTO_SHA3_ARM64
 	select CRYPTO_HASH
 	select CRYPTO_SHA3
 
+config CRYPTO_SM3_ARM64_CE
+	tristate "SM3 digest algorithm (ARMv8.2 Crypto Extensions)"
+	depends on KERNEL_MODE_NEON
+	select CRYPTO_HASH
+	select CRYPTO_SM3
+
 config CRYPTO_GHASH_ARM64_CE
 	tristate "GHASH/AES-GCM using ARMv8 Crypto Extensions"
 	depends on KERNEL_MODE_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 4ca2d146e213..cee9b8d9830b 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -20,6 +20,9 @@ sha512-ce-y := sha512-ce-glue.o sha512-ce-core.o
 obj-$(CONFIG_CRYPTO_SHA3_ARM64) += sha3-ce.o
 sha3-ce-y := sha3-ce-glue.o sha3-ce-core.o
 
+obj-$(CONFIG_CRYPTO_SM3_ARM64_CE) += sm3-ce.o
+sm3-ce-y := sm3-ce-glue.o sm3-ce-core.o
+
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
diff --git a/arch/arm64/crypto/sm3-ce-core.S b/arch/arm64/crypto/sm3-ce-core.S
new file mode 100644
index 000000000000..27169fe07a68
--- /dev/null
+++ b/arch/arm64/crypto/sm3-ce-core.S
@@ -0,0 +1,141 @@
+/*
+ * sm3-ce-core.S - SM3 secure hash using ARMv8.2 Crypto Extensions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.irp		b, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
+	.set		.Lv\b\().4s, \b
+	.endr
+
+	.macro		sm3partw1, rd, rn, rm
+	.inst		0xce60c000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3partw2, rd, rn, rm
+	.inst		0xce60c400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3ss1, rd, rn, rm, ra
+	.inst		0xce400000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3tt1a, rd, rn, rm, imm2
+	.inst		0xce408000 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3tt1b, rd, rn, rm, imm2
+	.inst		0xce408400 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3tt2a, rd, rn, rm, imm2
+	.inst		0xce408800 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
+	.endm
+
+	.macro		sm3tt2b, rd, rn, rm, imm2
+	.inst		0xce408c00 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
+	.endm
+
+	.macro		round, ab, s0, t0, t1, i
+	sm3ss1		v5.4s, v8.4s, \t0\().4s, v9.4s
+	shl		\t1\().4s, \t0\().4s, #1
+	sri		\t1\().4s, \t0\().4s, #31
+	sm3tt1\ab	v8.4s, v5.4s, v10.4s, \i
+	sm3tt2\ab	v9.4s, v5.4s, \s0\().4s, \i
+	.endm
+
+	.macro		qround, ab, s0, s1, s2, s3, s4
+	.ifnb		\s4
+	ext		\s4\().16b, \s1\().16b, \s2\().16b, #12
+	ext		v6.16b, \s0\().16b, \s1\().16b, #12
+	ext		v7.16b, \s2\().16b, \s3\().16b, #8
+	sm3partw1	\s4\().4s, \s0\().4s, \s3\().4s
+	.endif
+
+	eor		v10.16b, \s0\().16b, \s1\().16b
+
+	round		\ab, \s0, v11, v12, 0
+	round		\ab, \s0, v12, v11, 1
+	round		\ab, \s0, v11, v12, 2
+	round		\ab, \s0, v12, v11, 3
+
+	.ifnb		\s4
+	sm3partw2	\s4\().4s, v7.4s, v6.4s
+	.endif
+	.endm
+
+	/*
+	 * void sm3_ce_transform(struct sm3_state *sst, u8 const *src,
+	 *                       int blocks)
+	 */
+	.text
+ENTRY(sm3_ce_transform)
+	/* load state */
+	ld1		{v8.4s-v9.4s}, [x0]
+	rev64		v8.4s, v8.4s
+	rev64		v9.4s, v9.4s
+	ext		v8.16b, v8.16b, v8.16b, #8
+	ext		v9.16b, v9.16b, v9.16b, #8
+
+	adr_l		x8, .Lt
+	ldp		s13, s14, [x8]
+
+	/* load input */
+0:	ld1		{v0.16b-v3.16b}, [x1], #64
+	sub		w2, w2, #1
+
+	mov		v15.16b, v8.16b
+	mov		v16.16b, v9.16b
+
+CPU_LE(	rev32		v0.16b, v0.16b		)
+CPU_LE(	rev32		v1.16b, v1.16b		)
+CPU_LE(	rev32		v2.16b, v2.16b		)
+CPU_LE(	rev32		v3.16b, v3.16b		)
+
+	ext		v11.16b, v13.16b, v13.16b, #4
+
+	qround		a, v0, v1, v2, v3, v4
+	qround		a, v1, v2, v3, v4, v0
+	qround		a, v2, v3, v4, v0, v1
+	qround		a, v3, v4, v0, v1, v2
+
+	ext		v11.16b, v14.16b, v14.16b, #4
+
+	qround		b, v4, v0, v1, v2, v3
+	qround		b, v0, v1, v2, v3, v4
+	qround		b, v1, v2, v3, v4, v0
+	qround		b, v2, v3, v4, v0, v1
+	qround		b, v3, v4, v0, v1, v2
+	qround		b, v4, v0, v1, v2, v3
+	qround		b, v0, v1, v2, v3, v4
+	qround		b, v1, v2, v3, v4, v0
+	qround		b, v2, v3, v4, v0, v1
+	qround		b, v3, v4
+	qround		b, v4, v0
+	qround		b, v0, v1
+
+	eor		v8.16b, v8.16b, v15.16b
+	eor		v9.16b, v9.16b, v16.16b
+
+	/* handled all input blocks? */
+	cbnz		w2, 0b
+
+	/* save state */
+	rev64		v8.4s, v8.4s
+	rev64		v9.4s, v9.4s
+	ext		v8.16b, v8.16b, v8.16b, #8
+	ext		v9.16b, v9.16b, v9.16b, #8
+	st1		{v8.4s-v9.4s}, [x0]
+	ret
+ENDPROC(sm3_ce_transform)
+
+	.section	".rodata", "a"
+	.align		3
+.Lt:	.word		0x79cc4519, 0x9d8a7a87
diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
new file mode 100644
index 000000000000..3b4948f7e26f
--- /dev/null
+++ b/arch/arm64/crypto/sm3-ce-glue.c
@@ -0,0 +1,92 @@
+/*
+ * sm3-ce-glue.c - SM3 secure hash using ARMv8.2 Crypto Extensions
+ *
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sm3.h>
+#include <crypto/sm3_base.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("SM3 secure hash using ARMv8 Crypto Extensions");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+
+asmlinkage void sm3_ce_transform(struct sm3_state *sst, u8 const *src,
+				 int blocks);
+
+static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int len)
+{
+	if (!may_use_simd())
+		return crypto_sm3_update(desc, data, len);
+
+	kernel_neon_begin();
+	sm3_base_do_update(desc, data, len, sm3_ce_transform);
+	kernel_neon_end();
+
+	return 0;
+}
+
+static int sm3_ce_final(struct shash_desc *desc, u8 *out)
+{
+	if (!may_use_simd())
+		return crypto_sm3_finup(desc, NULL, 0, out);
+
+	kernel_neon_begin();
+	sm3_base_do_finalize(desc, sm3_ce_transform);
+	kernel_neon_end();
+
+	return sm3_base_finish(desc, out);
+}
+
+static int sm3_ce_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	if (!may_use_simd())
+		return crypto_sm3_finup(desc, data, len, out);
+
+	kernel_neon_begin();
+	sm3_base_do_update(desc, data, len, sm3_ce_transform);
+	kernel_neon_end();
+
+	return sm3_ce_final(desc, out);
+}
+
+static struct shash_alg sm3_alg = {
+	.digestsize		= SM3_DIGEST_SIZE,
+	.init			= sm3_base_init,
+	.update			= sm3_ce_update,
+	.final			= sm3_ce_final,
+	.finup			= sm3_ce_finup,
+	.descsize		= sizeof(struct sm3_state),
+	.base.cra_name		= "sm3",
+	.base.cra_driver_name	= "sm3-ce",
+	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
+	.base.cra_blocksize	= SM3_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_priority	= 200,
+};
+
+static int __init sm3_ce_mod_init(void)
+{
+	return crypto_register_shash(&sm3_alg);
+}
+
+static void __exit sm3_ce_mod_fini(void)
+{
+	crypto_unregister_shash(&sm3_alg);
+}
+
+module_cpu_feature_match(SM3, sm3_ce_mod_init);
+module_exit(sm3_ce_mod_fini);
-- 
2.11.0
