From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/crc32 - accelerated support based on x86 SSE implementation
Date: Sat, 26 Nov 2016 20:15:13 +0000
Message-ID: <1480191314-2331-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1480191314-2331-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38367 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcKZUPa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Nov 2016 15:15:30 -0500
Received: by mail-wm0-f44.google.com with SMTP id f82so120089794wmf.1
        for <linux-crypto@vger.kernel.org>; Sat, 26 Nov 2016 12:15:29 -0800 (PST)
In-Reply-To: <1480191314-2331-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a combination of the the Intel algorithm implemented using SSE
and PCLMULQDQ instructions from arch/x86/crypto/crc32-pclmul_asm.S, and
the new CRC32 extensions introduced for both 32-bit and 64-bit ARM in
version 8 of the architecture.

The PMULL/NEON algorithm is faster, but operates on blocks of at least
64 bytes, and on multiples of 16 bytes only. For the remaining input,
or for all input on systems that lack the PMULL 64x64->128 instructions,
the CRC32 instructions will be used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig         |   6 +
 arch/arm64/crypto/Makefile        |   3 +
 arch/arm64/crypto/crc32-ce-core.S | 246 ++++++++++++++++++++
 arch/arm64/crypto/crc32-ce-glue.c | 124 ++++++++++
 4 files changed, 379 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 1b50671ffec3..11dc2ac1f2e5 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -58,4 +58,10 @@ config CRYPTO_CRC32_ARM64
 	tristate "CRC32 and CRC32C using optional ARMv8 instructions"
 	depends on ARM64
 	select CRYPTO_HASH
+
+config CRYPTO_CRC32_ARM64_CE
+	tristate "CRC32 digest algorithm using PMULL instructions"
+	depends on ARM64 && KERNEL_MODE_NEON
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 36fd3eb4201b..144387805a46 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -20,6 +20,9 @@ ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM64_CE) += crct10dif-ce.o
 crct10dif-ce-y := crct10dif-ce-core.o crct10dif-ce-glue.o
 
+obj-$(CONFIG_CRYPTO_CRC32_ARM64_CE) += crc32-ce.o
+crc32-ce-y:= crc32-ce-core.o crc32-ce-glue.o
+
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
 CFLAGS_aes-ce-cipher.o += -march=armv8-a+crypto
 
diff --git a/arch/arm64/crypto/crc32-ce-core.S b/arch/arm64/crypto/crc32-ce-core.S
new file mode 100644
index 000000000000..eff7fe100dab
--- /dev/null
+++ b/arch/arm64/crypto/crc32-ce-core.S
@@ -0,0 +1,246 @@
+/*
+ * Accelerated CRC32 using arm64 CRC, NEON and Crypto Extensions instructions
+ *
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see http://www.gnu.org/licenses
+ *
+ * Please  visit http://www.xyratex.com/contact if you need additional
+ * information or have any questions.
+ *
+ * GPL HEADER END
+ */
+
+/*
+ * Copyright 2012 Xyratex Technology Limited
+ *
+ * Using hardware provided PCLMULQDQ instruction to accelerate the CRC32
+ * calculation.
+ * CRC32 polynomial:0x04c11db7(BE)/0xEDB88320(LE)
+ * PCLMULQDQ is a new instruction in Intel SSE4.2, the reference can be found
+ * at:
+ * http://www.intel.com/products/processor/manuals/
+ * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
+ * Volume 2B: Instruction Set Reference, N-Z
+ *
+ * Authors:   Gregory Prestas <Gregory_Prestas@us.xyratex.com>
+ *	      Alexander Boyko <Alexander_Boyko@xyratex.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+
+	.text
+	.align		4
+	.cpu		generic+crypto+crc
+
+	/*
+	 * [x4*128+32 mod P(x) << 32)]'  << 1   = 0x154442bd4
+	 * #define CONSTANT_R1  0x154442bd4LL
+	 *
+	 * [(x4*128-32 mod P(x) << 32)]' << 1   = 0x1c6e41596
+	 * #define CONSTANT_R2  0x1c6e41596LL
+	 */
+.Lconstant_R2R1:
+	.octa		0x00000001c6e415960000000154442bd4
+
+	/*
+	 * [(x128+32 mod P(x) << 32)]'   << 1   = 0x1751997d0
+	 * #define CONSTANT_R3  0x1751997d0LL
+	 *
+	 * [(x128-32 mod P(x) << 32)]'   << 1   = 0x0ccaa009e
+	 * #define CONSTANT_R4  0x0ccaa009eLL
+	 */
+.Lconstant_R4R3:
+	.octa		0x00000000ccaa009e00000001751997d0
+
+	/*
+	 * [(x64 mod P(x) << 32)]'       << 1   = 0x163cd6124
+	 * #define CONSTANT_R5  0x163cd6124LL
+	 */
+.Lconstant_R5:
+	.octa		0x00000000000000000000000163cd6124
+.Lconstant_mask32:
+	.octa		0x000000000000000000000000FFFFFFFF
+
+	/*
+	 * #define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
+	 *
+	 * Barrett Reduction constant (u64`) = u` = (x**64 / P(x))`
+	 *                                                      = 0x1F7011641LL
+	 * #define CONSTANT_RU  0x1F7011641LL
+	 */
+.Lconstant_RUpoly:
+	.octa		0x00000001F701164100000001DB710641
+
+	vCONSTANT	.req	v0
+	dCONSTANT	.req	d0
+	qCONSTANT	.req	q0
+
+	BUF		.req	x0
+	LEN		.req	x1
+	CRC		.req	x2
+
+	vzr		.req	v9
+
+	/**
+	 * Calculate crc32
+	 * BUF - buffer
+	 * LEN - sizeof buffer (multiple of 16 bytes), LEN should be > 63
+	 * CRC - initial crc32
+	 * return %eax crc32
+	 * uint crc32_pmull_le(unsigned char const *buffer,
+	 *                     size_t len, uint crc32)
+	 */
+ENTRY(crc32_pmull_le)
+	bic		LEN, LEN, #15
+	ld1		{v1.16b-v4.16b}, [BUF], #0x40
+	movi		vzr.16b, #0
+	fmov		dCONSTANT, CRC
+	eor		v1.16b, v1.16b, vCONSTANT.16b
+	sub		LEN, LEN, #0x40
+	cmp		LEN, #0x40
+	b.lt		less_64
+
+	ldr		qCONSTANT, .Lconstant_R2R1
+
+loop_64:		/* 64 bytes Full cache line folding */
+	sub		LEN, LEN, #0x40
+
+	pmull2		v5.1q, v1.2d, vCONSTANT.2d
+	pmull2		v6.1q, v2.2d, vCONSTANT.2d
+	pmull2		v7.1q, v3.2d, vCONSTANT.2d
+	pmull2		v8.1q, v4.2d, vCONSTANT.2d
+
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	pmull		v2.1q, v2.1d, vCONSTANT.1d
+	pmull		v3.1q, v3.1d, vCONSTANT.1d
+	pmull		v4.1q, v4.1d, vCONSTANT.1d
+
+	eor		v1.16b, v1.16b, v5.16b
+	ld1		{v5.16b}, [BUF], #0x10
+	eor		v2.16b, v2.16b, v6.16b
+	ld1		{v6.16b}, [BUF], #0x10
+	eor		v3.16b, v3.16b, v7.16b
+	ld1		{v7.16b}, [BUF], #0x10
+	eor		v4.16b, v4.16b, v8.16b
+	ld1		{v8.16b}, [BUF], #0x10
+
+	eor		v1.16b, v1.16b, v5.16b
+	eor		v2.16b, v2.16b, v6.16b
+	eor		v3.16b, v3.16b, v7.16b
+	eor		v4.16b, v4.16b, v8.16b
+
+	cmp		LEN, #0x40
+	b.ge		loop_64
+
+less_64:		/* Folding cache line into 128bit */
+	ldr		qCONSTANT, .Lconstant_R4R3
+
+	pmull2		v5.1q, v1.2d, vCONSTANT.2d
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v5.16b
+	eor		v1.16b, v1.16b, v2.16b
+
+	pmull2		v5.1q, v1.2d, vCONSTANT.2d
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v5.16b
+	eor		v1.16b, v1.16b, v3.16b
+
+	pmull2		v5.1q, v1.2d, vCONSTANT.2d
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v5.16b
+	eor		v1.16b, v1.16b, v4.16b
+
+	cbz		LEN, fold_64
+
+loop_16:		/* Folding rest buffer into 128bit */
+	subs		LEN, LEN, #0x10
+
+	ld1		{v2.16b}, [BUF], #0x10
+	pmull2		v5.1q, v1.2d, vCONSTANT.2d
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v5.16b
+	eor		v1.16b, v1.16b, v2.16b
+
+	b.ne		loop_16
+
+fold_64:
+	/* perform the last 64 bit fold, also adds 32 zeroes
+	 * to the input stream */
+	ext		v2.16b, v1.16b, v1.16b, #8
+	pmull2		v2.1q, v2.2d, vCONSTANT.2d
+	ext		v1.16b, v1.16b, vzr.16b, #8
+	eor		v1.16b, v1.16b, v2.16b
+
+	/* final 32-bit fold */
+	ldr		qCONSTANT, .Lconstant_R5
+	ldr		q3, .Lconstant_mask32
+
+	ext		v2.16b, v1.16b, vzr.16b, #4
+	and		v1.16b, v1.16b, v3.16b
+	pmull		v1.1q, v1.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v2.16b
+
+	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
+	ldr		qCONSTANT, .Lconstant_RUpoly
+
+	and		v2.16b, v1.16b, v3.16b
+	ext		v2.16b, vzr.16b, v2.16b, #8
+	pmull2		v2.1q, v2.2d, vCONSTANT.2d
+	and		v2.16b, v2.16b, v3.16b
+	pmull		v2.1q, v2.1d, vCONSTANT.1d
+	eor		v1.16b, v1.16b, v2.16b
+	mov		w0, v1.s[1]
+
+	ret
+ENDPROC(crc32_pmull_le)
+
+ENTRY(crc32_armv8_le)
+0:	subs		x2, x2, #16
+	b.mi		8f
+	ldp		x3, x4, [x1], #16
+CPU_BE(	rev		x3, x3		)
+CPU_BE(	rev		x4, x4		)
+	crc32x		w0, w0, x3
+	crc32x		w0, w0, x4
+	b		0b
+
+8:	tbz		x2, #3, 4f
+	ldr		x3, [x1], #8
+CPU_BE(	rev		x3, x3		)
+	crc32x		w0, w0, x3
+4:	tbz		x2, #2, 2f
+	ldr		w3, [x1], #4
+CPU_BE(	rev		w3, w3		)
+	crc32w		w0, w0, w3
+2:	tbz		x2, #1, 1f
+	ldrh		w3, [x1], #2
+CPU_BE(	rev16		w3, w3		)
+	crc32h		w0, w0, w3
+1:	tbz		x2, #0, 0f
+	ldrb		w3, [x1]
+	crc32b		w0, w0, w3
+0:	ret
+ENDPROC(crc32_armv8_le)
diff --git a/arch/arm64/crypto/crc32-ce-glue.c b/arch/arm64/crypto/crc32-ce-glue.c
new file mode 100644
index 000000000000..567203f29ac6
--- /dev/null
+++ b/arch/arm64/crypto/crc32-ce-glue.c
@@ -0,0 +1,124 @@
+/*
+ * Accelerated CRC32 using arm64 NEON and Crypto Extensions instructions
+ *
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/cpufeature.h>
+#include <linux/crc32.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/unaligned.h>
+
+#define PMULL_MIN_LEN		64L	/* minimum size of buffer
+					 * for crc32_pmull_le_16 */
+#define SCALE_F			16L	/* size of NEON register */
+
+asmlinkage u32 crc32_pmull_le(const u8 buf[], u64 len, u32 init_crc);
+asmlinkage u32 crc32_armv8_le(u32 init_crc, const u8 buf[], u64 len);
+
+static int crc32_pmull_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = 0;
+	return 0;
+}
+
+static int crc32_pmull_setkey(struct crypto_shash *hash, const u8 *key,
+			      unsigned int keylen)
+{
+	u32 *mctx = crypto_shash_ctx(hash);
+
+	if (keylen != sizeof(u32)) {
+		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	*mctx = le32_to_cpup((__le32 *)key);
+	return 0;
+}
+
+static int crc32_pmull_init(struct shash_desc *desc)
+{
+	u32 *mctx = crypto_shash_ctx(desc->tfm);
+	u32 *crc = shash_desc_ctx(desc);
+
+	*crc = *mctx;
+	return 0;
+}
+
+static int crc32_pmull_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	u32 *crc = shash_desc_ctx(desc);
+
+	if (length >= PMULL_MIN_LEN) {
+		kernel_neon_begin_partial(10);
+		*crc = crc32_pmull_le(data, round_down(length, SCALE_F), *crc);
+		kernel_neon_end();
+
+		data += round_down(length, SCALE_F);
+		length %= SCALE_F;
+	}
+
+	if (length > 0) {
+		if (elf_hwcap & HWCAP_CRC32)
+			*crc = crc32_armv8_le(*crc, data, length);
+		else
+			*crc = crc32_le(*crc, data, length);
+	}
+
+	return 0;
+}
+
+static int crc32_pmull_final(struct shash_desc *desc, u8 *out)
+{
+	u32 *crc = shash_desc_ctx(desc);
+
+	put_unaligned_le32(*crc, out);
+	return 0;
+}
+
+static struct shash_alg crc32_pmull_alg = {
+	.setkey			= crc32_pmull_setkey,
+	.init			= crc32_pmull_init,
+	.update			= crc32_pmull_update,
+	.final			= crc32_pmull_final,
+	.descsize		= sizeof(u32),
+	.digestsize		= sizeof(u32),
+
+	.base.cra_ctxsize	= sizeof(u32),
+	.base.cra_init		= crc32_pmull_cra_init,
+	.base.cra_name		= "crc32",
+	.base.cra_driver_name	= "crc32-arm64-ce",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= 1,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init crc32_pmull_mod_init(void)
+{
+	return crypto_register_shash(&crc32_pmull_alg);
+}
+
+static void __exit crc32_pmull_mod_exit(void)
+{
+	crypto_unregister_shash(&crc32_pmull_alg);
+}
+
+module_cpu_feature_match(PMULL, crc32_pmull_mod_init);
+module_exit(crc32_pmull_mod_exit);
+
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
