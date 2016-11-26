From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm/crc32 - accelerated support based on x86 SSE implementation
Date: Sat, 26 Nov 2016 20:15:14 +0000
Message-ID: <1480191314-2331-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1480191314-2331-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34149 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbcKZUPc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Nov 2016 15:15:32 -0500
Received: by mail-wm0-f44.google.com with SMTP id u144so33397146wmu.1
        for <linux-crypto@vger.kernel.org>; Sat, 26 Nov 2016 12:15:31 -0800 (PST)
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
 arch/arm/crypto/Kconfig         |   5 +
 arch/arm/crypto/Makefile        |   2 +
 arch/arm/crypto/crc32-ce-core.S | 257 ++++++++++++++++++++
 arch/arm/crypto/crc32-ce-glue.c | 129 ++++++++++
 4 files changed, 393 insertions(+)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index fce801fa52a1..be5cb5a7d3fa 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -125,4 +125,9 @@ config CRYPTO_CRCT10DIF_ARM_CE
 	depends on KERNEL_MODE_NEON && CRC_T10DIF
 	select CRYPTO_HASH
 
+config CRYPTO_CRC32_ARM_CE
+	tristate "CRC32 digest algorithm using CRC and/or PMULL instructions"
+	depends on KERNEL_MODE_NEON && CRC32
+	select CRYPTO_HASH
+
 endif
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index fc77265014b7..b578a1820ab1 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -14,6 +14,7 @@ ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
 ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
+ce-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
 
 ifneq ($(ce-obj-y)$(ce-obj-m),)
 ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
@@ -38,6 +39,7 @@ sha2-arm-ce-y	:= sha2-ce-core.o sha2-ce-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
 ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
 crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
+crc32-arm-ce-y:= crc32-ce-core.o crc32-ce-glue.o
 
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
new file mode 100644
index 000000000000..ef671f040672
--- /dev/null
+++ b/arch/arm/crypto/crc32-ce-core.S
@@ -0,0 +1,257 @@
+/*
+ * Accelerated CRC32 using ARM CRC, NEON and Crypto Extensions instructions
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
+	.text
+	.align		4
+	.arch		armv8-a
+	.arch_extension	crc
+	.fpu		crypto-neon-fp-armv8
+
+	/*
+	 * [x4*128+32 mod P(x) << 32)]'  << 1   = 0x154442bd4
+	 * #define CONSTANT_R1  0x154442bd4LL
+	 *
+	 * [(x4*128-32 mod P(x) << 32)]' << 1   = 0x1c6e41596
+	 * #define CONSTANT_R2  0x1c6e41596LL
+	 */
+.Lconstant_R2R1:
+	.quad		0x0000000154442bd4
+	.quad		0x00000001c6e41596
+
+	/*
+	 * [(x128+32 mod P(x) << 32)]'   << 1   = 0x1751997d0
+	 * #define CONSTANT_R3  0x1751997d0LL
+	 *
+	 * [(x128-32 mod P(x) << 32)]'   << 1   = 0x0ccaa009e
+	 * #define CONSTANT_R4  0x0ccaa009eLL
+	 */
+.Lconstant_R4R3:
+	.quad		0x00000001751997d0
+	.quad		0x00000000ccaa009e
+
+	/*
+	 * [(x64 mod P(x) << 32)]'       << 1   = 0x163cd6124
+	 * #define CONSTANT_R5  0x163cd6124LL
+	 */
+.Lconstant_R5:
+	.quad		0x0000000163cd6124
+
+.Lconstant_mask32:
+	.quad		0x00000000FFFFFFFF
+
+	/*
+	 * #define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
+	 *
+	 * Barrett Reduction constant (u64`) = u` = (x**64 / P(x))`
+	 *                                                      = 0x1F7011641LL
+	 * #define CONSTANT_RU  0x1F7011641LL
+	 */
+.Lconstant_RUpoly:
+	.quad		0x00000001DB710641
+	.quad		0x00000001F7011641
+
+	dCONSTANTl	.req	d0
+	dCONSTANTh	.req	d1
+	qCONSTANT	.req	q0
+
+	BUF		.req	r0
+	LEN		.req	r1
+	CRC		.req	r2
+
+	qzr		.req	q9
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
+	vld1.8		{q1-q2}, [BUF]!
+	vld1.8		{q3-q4}, [BUF]!
+	vmov.i8		qzr, #0
+	vmov.i8		qCONSTANT, #0
+	vmov		dCONSTANTl[0], CRC
+	veor.8		d2, d2, dCONSTANTl
+	sub		LEN, LEN, #0x40
+	cmp		LEN, #0x40
+	blt		less_64
+
+	vldr		dCONSTANTl, .Lconstant_R2R1
+	vldr		dCONSTANTh, .Lconstant_R2R1 + 8
+
+loop_64:		/* 64 bytes Full cache line folding */
+	sub		LEN, LEN, #0x40
+
+	vmull.p64	q5, d3, dCONSTANTh
+	vmull.p64	q6, d5, dCONSTANTh
+	vmull.p64	q7, d7, dCONSTANTh
+	vmull.p64	q8, d9, dCONSTANTh
+
+	vmull.p64	q1, d2, dCONSTANTl
+	vmull.p64	q2, d4, dCONSTANTl
+	vmull.p64	q3, d6, dCONSTANTl
+	vmull.p64	q4, d8, dCONSTANTl
+
+	veor.8		q1, q1, q5
+	vld1.8		{q5}, [BUF]!
+	veor.8		q2, q2, q6
+	vld1.8		{q6}, [BUF]!
+	veor.8		q3, q3, q7
+	vld1.8		{q7}, [BUF]!
+	veor.8		q4, q4, q8
+	vld1.8		{q8}, [BUF]!
+
+	veor.8		q1, q1, q5
+	veor.8		q2, q2, q6
+	veor.8		q3, q3, q7
+	veor.8		q4, q4, q8
+
+	cmp		LEN, #0x40
+	bge		loop_64
+
+less_64:		/* Folding cache line into 128bit */
+	vldr		dCONSTANTl, .Lconstant_R4R3
+	vldr		dCONSTANTh, .Lconstant_R4R3 + 8
+
+	vmull.p64	q5, d3, dCONSTANTh
+	vmull.p64	q1, d2, dCONSTANTl
+	veor.8		q1, q1, q5
+	veor.8		q1, q1, q2
+
+	vmull.p64	q5, d3, dCONSTANTh
+	vmull.p64	q1, d2, dCONSTANTl
+	veor.8		q1, q1, q5
+	veor.8		q1, q1, q3
+
+	vmull.p64	q5, d3, dCONSTANTh
+	vmull.p64	q1, d2, dCONSTANTl
+	veor.8		q1, q1, q5
+	veor.8		q1, q1, q4
+
+	teq		LEN, #0
+	beq		fold_64
+
+loop_16:		/* Folding rest buffer into 128bit */
+	subs		LEN, LEN, #0x10
+
+	vld1.8		{q2}, [BUF]!
+	vmull.p64	q5, d3, dCONSTANTh
+	vmull.p64	q1, d2, dCONSTANTl
+	veor.8		q1, q1, q5
+	veor.8		q1, q1, q2
+
+	bne		loop_16
+
+fold_64:
+	/* perform the last 64 bit fold, also adds 32 zeroes
+	 * to the input stream */
+	vmull.p64	q2, d2, dCONSTANTh
+	vext.8		q1, q1, qzr, #8
+	veor.8		q1, q1, q2
+
+	/* final 32-bit fold */
+	vldr		dCONSTANTl, .Lconstant_R5
+	vldr		d6, .Lconstant_mask32
+	vmov.i8		d7, #0
+
+	vext.8		q2, q1, qzr, #4
+	vand.8		d2, d2, d6
+	vmull.p64	q1, d2, dCONSTANTl
+	veor.8		q1, q1, q2
+
+	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
+	vldr		dCONSTANTl, .Lconstant_RUpoly
+	vldr		dCONSTANTh, .Lconstant_RUpoly + 8
+
+	vand.8		q2, q1, q3
+	vext.8		q2, qzr, q2, #8
+	vmull.p64	q2, d5, dCONSTANTh
+	vand.8		q2, q2, q3
+	vmull.p64	q2, d4, dCONSTANTl
+	veor.8		q1, q1, q2
+	vmov		r0, s5
+
+	bx		lr
+ENDPROC(crc32_pmull_le)
+
+ENTRY(crc32_armv8_le)
+	mov		ip, r2
+0:	subs		ip, ip, #8
+	bmi		4f
+	ldrd		r2, r3, [r1], #8
+ARM_BE8(rev		r2, r2		)
+ARM_BE8(rev		r3, r3		)
+	crc32w		r0, r0, r2
+	crc32w		r0, r0, r3
+	b		0b
+
+4:	tst		ip, #4
+	beq		2f
+	ldr		r3, [r1], #4
+ARM_BE8(rev		r3, r3		)
+	crc32w		r0, r0, r3
+2:	tst		ip, #2
+	beq		1f
+	ldrh		r3, [r1], #2
+ARM_BE8(rev16		r3, r3		)
+	crc32h		r0, r0, r3
+1:	tst		ip, #1
+	bxeq		lr
+	ldrb		r3, [r1]
+	crc32b		r0, r0, r3
+	bx		lr
+ENDPROC(crc32_armv8_le)
diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
new file mode 100644
index 000000000000..61916b6b40e9
--- /dev/null
+++ b/arch/arm/crypto/crc32-ce-glue.c
@@ -0,0 +1,129 @@
+/*
+ * Accelerated CRC32 using ARM CRC, NEON and Crypto Extensions instructions
+ *
+ * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
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
+#include <asm/simd.h>
+#include <asm/unaligned.h>
+
+#define PMULL_MIN_LEN		64L	/* minimum size of buffer
+					 * for crc32_pmull_le_16 */
+#define SCALE_F			16L	/* size of NEON register */
+
+asmlinkage u32 crc32_pmull_le(const u8 buf[], u32 len, u32 init_crc);
+asmlinkage u32 crc32_armv8_le(u32 init_crc, const u8 buf[], u32 len);
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
+	if (length >= PMULL_MIN_LEN && may_use_simd() &&
+	    (elf_hwcap2 & HWCAP2_PMULL)) {
+		kernel_neon_begin();
+		*crc = crc32_pmull_le(data, round_down(length, SCALE_F), *crc);
+		kernel_neon_end();
+
+		data += round_down(length, SCALE_F);
+		length %= SCALE_F;
+	}
+
+	if (length > 0) {
+		if (elf_hwcap2 & HWCAP2_CRC32)
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
+	.base.cra_driver_name	= "crc32-arm-ce",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= 1,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init crc32_pmull_mod_init(void)
+{
+	if (!(elf_hwcap2 & (HWCAP2_PMULL|HWCAP2_CRC32)))
+		return -ENODEV;
+
+	return crypto_register_shash(&crc32_pmull_alg);
+}
+
+static void __exit crc32_pmull_mod_exit(void)
+{
+	crypto_unregister_shash(&crc32_pmull_alg);
+}
+
+module_init(crc32_pmull_mod_init);
+module_exit(crc32_pmull_mod_exit);
+
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("crc32");
-- 
2.7.4
