From: James Hogan <jhogan@kernel.org>
Subject: [PATCH v3 2/3] MIPS: crypto: Add crc32 and crc32c hw accelerated module
Date: Fri,  9 Feb 2018 22:11:06 +0000
Message-ID: <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
Cc: James Hogan <jhogan@kernel.org>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752908AbeBIWLX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Feb 2018 17:11:23 -0500
In-Reply-To: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
In-Reply-To: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Marcin Nowakowski <marcin.nowakowski@mips.com>

This module registers crc32 and crc32c algorithms that use the
optional CRC32[bhwd] and CRC32C[bhwd] instructions in MIPSr6 cores.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@mips.com>
Signed-off-by: James Hogan <jhogan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-mips@linux-mips.org
Cc: linux-crypto@vger.kernel.org
---
Changes in v3:
 - Convert to using assembler macros to support CRC instructions on
   older toolchains, using the helpers merged for 4.16. This removes the
   need to hardcode either rt or rs (i.e. as $v0 (CRC_REGISTER) and
   $at), and drops the C "register" keywords sprinkled everywhere.
 - Minor whitespace rearrangement of _CRC32 macro.
 - Add SPDX-License-Identifier to crc32-mips.c and the crypo Makefile.
 - Update copyright from ImgTec to MIPS Tech, LLC.
 - Update imgtec.com email addresses to mips.com.

Changes in v2:
 - minor code refactoring as suggested by JamesH which produces
   a better assembly output for 32-bit builds
---
 arch/mips/Kconfig             |   4 +-
 arch/mips/Makefile            |   3 +-
 arch/mips/crypto/Makefile     |   6 +-
 arch/mips/crypto/crc32-mips.c | 346 +++++++++++++++++++++++++++++++++++-
 crypto/Kconfig                |   9 +-
 5 files changed, 368 insertions(+)
 create mode 100644 arch/mips/crypto/Makefile
 create mode 100644 arch/mips/crypto/crc32-mips.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ac0f5bb10f0b..cccd17c07bfc 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2023,6 +2023,7 @@ config CPU_MIPSR6
 	select CPU_HAS_RIXI
 	select HAVE_ARCH_BITREVERSE
 	select MIPS_ASID_BITS_VARIABLE
+	select MIPS_CRC_SUPPORT
 	select MIPS_SPRAM
 
 config EVA
@@ -2490,6 +2491,9 @@ config MIPS_ASID_BITS
 config MIPS_ASID_BITS_VARIABLE
 	bool
 
+config MIPS_CRC_SUPPORT
+	bool
+
 #
 # - Highmem only makes sense for the 32-bit kernel.
 # - The current highmem code will only work properly on physically indexed
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index d1ca839c3981..44a6ed53d018 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -222,6 +222,8 @@ xpa-cflags-y				:= $(mips-cflags)
 xpa-cflags-$(micromips-ase)		+= -mmicromips -Wa$(comma)-fatal-warnings
 toolchain-xpa				:= $(call cc-option-yn,$(xpa-cflags-y) -mxpa)
 cflags-$(toolchain-xpa)			+= -DTOOLCHAIN_SUPPORTS_XPA
+toolchain-crc				:= $(call cc-option-yn,$(mips-cflags) -Wa$(comma)-mcrc)
+cflags-$(toolchain-crc)			+= -DTOOLCHAIN_SUPPORTS_CRC
 
 #
 # Firmware support
@@ -330,6 +332,7 @@ libs-y			+= arch/mips/math-emu/
 # See arch/mips/Kbuild for content of core part of the kernel
 core-y += arch/mips/
 
+drivers-$(CONFIG_MIPS_CRC_SUPPORT) += arch/mips/crypto/
 drivers-$(CONFIG_OPROFILE)	+= arch/mips/oprofile/
 
 # suspend and hibernation support
diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
new file mode 100644
index 000000000000..e07aca572c2e
--- /dev/null
+++ b/arch/mips/crypto/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for MIPS crypto files..
+#
+
+obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
new file mode 100644
index 000000000000..8d4122f37fa5
--- /dev/null
+++ b/arch/mips/crypto/crc32-mips.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * crc32-mips.c - CRC32 and CRC32C using optional MIPSr6 instructions
+ *
+ * Module based on arm64/crypto/crc32-arm.c
+ *
+ * Copyright (C) 2014 Linaro Ltd <yazen.ghannam@linaro.org>
+ * Copyright (C) 2018 MIPS Tech, LLC
+ */
+
+#include <linux/unaligned/access_ok.h>
+#include <linux/cpufeature.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <asm/mipsregs.h>
+
+#include <crypto/internal/hash.h>
+
+enum crc_op_size {
+	b, h, w, d,
+};
+
+enum crc_type {
+	crc32,
+	crc32c,
+};
+
+#ifndef TOOLCHAIN_SUPPORTS_CRC
+#define _ASM_MACRO_CRC32(OP, SZ, TYPE)					  \
+_ASM_MACRO_3R(OP, rt, rs, rt2,						  \
+	".ifnc	\\rt, \\rt2\n\t"					  \
+	".error	\"invalid operands \\\"" #OP " \\rt,\\rs,\\rt2\\\"\"\n\t" \
+	".endif\n\t"							  \
+	_ASM_INSN_IF_MIPS(0x7c00000f | (__rt << 16) | (__rs << 21) |	  \
+			  ((SZ) <<  6) | ((TYPE) << 8))			  \
+	_ASM_INSN32_IF_MM(0x00000030 | (__rs << 16) | (__rt << 21) |	  \
+			  ((SZ) << 14) | ((TYPE) << 3)))
+_ASM_MACRO_CRC32(crc32b,  0, 0);
+_ASM_MACRO_CRC32(crc32h,  1, 0);
+_ASM_MACRO_CRC32(crc32w,  2, 0);
+_ASM_MACRO_CRC32(crc32d,  3, 0);
+_ASM_MACRO_CRC32(crc32cb, 0, 1);
+_ASM_MACRO_CRC32(crc32ch, 1, 1);
+_ASM_MACRO_CRC32(crc32cw, 2, 1);
+_ASM_MACRO_CRC32(crc32cd, 3, 1);
+#define _ASM_SET_CRC ""
+#else /* !TOOLCHAIN_SUPPORTS_CRC */
+#define _ASM_SET_CRC ".set\tcrc\n\t"
+#endif
+
+#define _CRC32(crc, value, size, type)		\
+do {						\
+	__asm__ __volatile__(			\
+		".set	push\n\t"		\
+		_ASM_SET_CRC			\
+		#type #size "	%0, %1, %0\n\t"	\
+		".set	pop"			\
+		: "+r" (crc)			\
+		: "r" (value));			\
+} while (0)
+
+#define CRC32(crc, value, size) \
+	_CRC32(crc, value, size, crc32)
+
+#define CRC32C(crc, value, size) \
+	_CRC32(crc, value, size, crc32c)
+
+static u32 crc32_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
+{
+	u32 crc = crc_;
+
+#ifdef CONFIG_64BIT
+	while (len >= sizeof(u64)) {
+		u64 value = get_unaligned_le64(p);
+
+		CRC32(crc, value, d);
+		p += sizeof(u64);
+		len -= sizeof(u64);
+	}
+
+	if (len & sizeof(u32)) {
+#else /* !CONFIG_64BIT */
+	while (len >= sizeof(u32)) {
+#endif
+		u32 value = get_unaligned_le32(p);
+
+		CRC32(crc, value, w);
+		p += sizeof(u32);
+		len -= sizeof(u32);
+	}
+
+	if (len & sizeof(u16)) {
+		u16 value = get_unaligned_le16(p);
+
+		CRC32(crc, value, h);
+		p += sizeof(u16);
+	}
+
+	if (len & sizeof(u8)) {
+		u8 value = *p++;
+
+		CRC32(crc, value, b);
+	}
+
+	return crc;
+}
+
+static u32 crc32c_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
+{
+	u32 crc = crc_;
+
+#ifdef CONFIG_64BIT
+	while (len >= sizeof(u64)) {
+		u64 value = get_unaligned_le64(p);
+
+		CRC32C(crc, value, d);
+		p += sizeof(u64);
+		len -= sizeof(u64);
+	}
+
+	if (len & sizeof(u32)) {
+#else /* !CONFIG_64BIT */
+	while (len >= sizeof(u32)) {
+#endif
+		u32 value = get_unaligned_le32(p);
+
+		CRC32C(crc, value, w);
+		p += sizeof(u32);
+		len -= sizeof(u32);
+	}
+
+	if (len & sizeof(u16)) {
+		u16 value = get_unaligned_le16(p);
+
+		CRC32C(crc, value, h);
+		p += sizeof(u16);
+	}
+
+	if (len & sizeof(u8)) {
+		u8 value = *p++;
+
+		CRC32C(crc, value, b);
+	}
+	return crc;
+}
+
+#define CHKSUM_BLOCK_SIZE	1
+#define CHKSUM_DIGEST_SIZE	4
+
+struct chksum_ctx {
+	u32 key;
+};
+
+struct chksum_desc_ctx {
+	u32 crc;
+};
+
+static int chksum_init(struct shash_desc *desc)
+{
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = mctx->key;
+
+	return 0;
+}
+
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR policy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
+			 unsigned int keylen)
+{
+	struct chksum_ctx *mctx = crypto_shash_ctx(tfm);
+
+	if (keylen != sizeof(mctx->key)) {
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	mctx->key = get_unaligned_le32(key);
+	return 0;
+}
+
+static int chksum_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = crc32_mips_le_hw(ctx->crc, data, length);
+	return 0;
+}
+
+static int chksumc_update(struct shash_desc *desc, const u8 *data,
+			 unsigned int length)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	ctx->crc = crc32c_mips_le_hw(ctx->crc, data, length);
+	return 0;
+}
+
+static int chksum_final(struct shash_desc *desc, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	put_unaligned_le32(ctx->crc, out);
+	return 0;
+}
+
+static int chksumc_final(struct shash_desc *desc, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	put_unaligned_le32(~ctx->crc, out);
+	return 0;
+}
+
+static int __chksum_finup(u32 crc, const u8 *data, unsigned int len, u8 *out)
+{
+	put_unaligned_le32(crc32_mips_le_hw(crc, data, len), out);
+	return 0;
+}
+
+static int __chksumc_finup(u32 crc, const u8 *data, unsigned int len, u8 *out)
+{
+	put_unaligned_le32(~crc32c_mips_le_hw(crc, data, len), out);
+	return 0;
+}
+
+static int chksum_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksum_finup(ctx->crc, data, len, out);
+}
+
+static int chksumc_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	return __chksumc_finup(ctx->crc, data, len, out);
+}
+
+static int chksum_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
+{
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	return __chksum_finup(mctx->key, data, length, out);
+}
+
+static int chksumc_digest(struct shash_desc *desc, const u8 *data,
+			 unsigned int length, u8 *out)
+{
+	struct chksum_ctx *mctx = crypto_shash_ctx(desc->tfm);
+
+	return __chksumc_finup(mctx->key, data, length, out);
+}
+
+static int chksum_cra_init(struct crypto_tfm *tfm)
+{
+	struct chksum_ctx *mctx = crypto_tfm_ctx(tfm);
+
+	mctx->key = ~0;
+	return 0;
+}
+
+static struct shash_alg crc32_alg = {
+	.digestsize		=	CHKSUM_DIGEST_SIZE,
+	.setkey			=	chksum_setkey,
+	.init			=	chksum_init,
+	.update			=	chksum_update,
+	.final			=	chksum_final,
+	.finup			=	chksum_finup,
+	.digest			=	chksum_digest,
+	.descsize		=	sizeof(struct chksum_desc_ctx),
+	.base			=	{
+		.cra_name		=	"crc32",
+		.cra_driver_name	=	"crc32-mips-hw",
+		.cra_priority		=	300,
+		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+		.cra_alignmask		=	0,
+		.cra_ctxsize		=	sizeof(struct chksum_ctx),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	chksum_cra_init,
+	}
+};
+
+static struct shash_alg crc32c_alg = {
+	.digestsize		=	CHKSUM_DIGEST_SIZE,
+	.setkey			=	chksum_setkey,
+	.init			=	chksum_init,
+	.update			=	chksumc_update,
+	.final			=	chksumc_final,
+	.finup			=	chksumc_finup,
+	.digest			=	chksumc_digest,
+	.descsize		=	sizeof(struct chksum_desc_ctx),
+	.base			=	{
+		.cra_name		=	"crc32c",
+		.cra_driver_name	=	"crc32c-mips-hw",
+		.cra_priority		=	300,
+		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+		.cra_alignmask		=	0,
+		.cra_ctxsize		=	sizeof(struct chksum_ctx),
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	chksum_cra_init,
+	}
+};
+
+static int __init crc32_mod_init(void)
+{
+	int err;
+
+	err = crypto_register_shash(&crc32_alg);
+
+	if (err)
+		return err;
+
+	err = crypto_register_shash(&crc32c_alg);
+
+	if (err) {
+		crypto_unregister_shash(&crc32_alg);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit crc32_mod_exit(void)
+{
+	crypto_unregister_shash(&crc32_alg);
+	crypto_unregister_shash(&crc32c_alg);
+}
+
+MODULE_AUTHOR("Marcin Nowakowski <marcin.nowakowski@mips.com");
+MODULE_DESCRIPTION("CRC32 and CRC32C using optional MIPS instructions");
+MODULE_LICENSE("GPL v2");
+
+module_cpu_feature_match(MIPS_CRC32, crc32_mod_init);
+module_exit(crc32_mod_exit);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index f7911963bb79..52717a03068e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -495,6 +495,15 @@ config CRYPTO_CRC32_PCLMUL
 	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
 	  and gain better performance as compared with the table implementation.
 
+config CRYPTO_CRC32_MIPS
+	tristate "CRC32c and CRC32 CRC algorithm (MIPS)"
+	depends on MIPS_CRC_SUPPORT
+	select CRYPTO_HASH
+	help
+	  CRC32c and CRC32 CRC algorithms implemented using mips crypto
+	  instructions, when available.
+
+
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
-- 
git-series 0.9.1
