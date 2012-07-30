From: Alexander Boyko <alexander_boyko@xyratex.com>
Subject: [PATCH v2] crypto api: add crc32 pclmulqdq implementation and wrappers
 for table implementation
Date: Mon, 30 Jul 2012 12:56:31 +0400
Message-ID: <50164C3F.5020906@xyratex.com>
References: <500EA8CA.6040705@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xyratex195.xyratex.com ([194.131.166.195]:52713 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752604Ab2G3I4k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 04:56:40 -0400
In-Reply-To: <500EA8CA.6040705@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



From: Alexander Boyko <alexander_boyko@xyratex.com>

This patch adds crc32 algorithms to shash crypto api. One is wrapper to
generic crc32_le function. Second is crc32 pclmulqdq implementation. It
use hardware provided PCLMULQDQ instruction to accelerate the CRC32
disposal. This instruction present from Intel Westmere and AMD Bulldozer
CPUs.

kernel 3.5rc7

Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>
---
Changes from V1 to V2:
- Add irq_fpu_usable() check.

  arch/x86/crypto/Makefile            |    3
  arch/x86/crypto/crc32-pclmul_asm.S  |  246 ++++++++++++++++++++++++++
  arch/x86/crypto/crc32-pclmul_glue.c |  202 +++++++++++++++++++++
  crypto/Kconfig                      |   21 ++
  crypto/Makefile                     |    1
  crypto/crc32.c                      |  158 ++++++++++++++++
  6 files changed, 631 insertions(+)
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e191ac0..5a0c931 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) +=
ghash-clmulni-intel.o

  obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
  obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
+obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o

  aes-i586-y := aes-i586-asm_32.o aes_glue.o
  twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
@@ -37,6 +38,8 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
fpu.o

  ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o
ghash-clmulni-intel_glue.o

+crc32-pclmul-y := crc32-pclmul_asm.o crc32-pclmul_glue.o
+
  # enable AVX support only when $(AS) can actually assemble the
instructions
  ifeq ($(call as-instr,vpxor %xmm0$(comma)%xmm1$(comma)%xmm2,yes,no),yes)
  AFLAGS_sha1_ssse3_asm.o += -DSHA1_ENABLE_AVX_SUPPORT
diff --git a/arch/x86/crypto/crc32-pclmul_asm.S
b/arch/x86/crypto/crc32-pclmul_asm.S
new file mode 100644
index 0000000..c833501
--- /dev/null
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -0,0 +1,246 @@
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
+ * version 2 along with this program; If not, see
http://www.gnu.org/licenses
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
+ * PCLMULQDQ is a new instruction in Intel SSE4.2, the reference can be
found
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
+#include <asm/inst.h>
+
+
+.align 16
+/*
+ * [x4*128+32 mod P(x) << 32)]'  << 1   = 0x154442bd4
+ * #define CONSTANT_R1  0x154442bd4LL
+ *
+ * [(x4*128-32 mod P(x) << 32)]' << 1   = 0x1c6e41596
+ * #define CONSTANT_R2  0x1c6e41596LL
+ */
+.Lconstant_R2R1:
+	.octa 0x00000001c6e415960000000154442bd4
+/*
+ * [(x128+32 mod P(x) << 32)]'   << 1   = 0x1751997d0
+ * #define CONSTANT_R3  0x1751997d0LL
+ *
+ * [(x128-32 mod P(x) << 32)]'   << 1   = 0x0ccaa009e
+ * #define CONSTANT_R4  0x0ccaa009eLL
+ */
+.Lconstant_R4R3:
+	.octa 0x00000000ccaa009e00000001751997d0
+/*
+ * [(x64 mod P(x) << 32)]'       << 1   = 0x163cd6124
+ * #define CONSTANT_R5  0x163cd6124LL
+ */
+.Lconstant_R5:
+	.octa 0x00000000000000000000000163cd6124
+.Lconstant_mask32:
+	.octa 0x000000000000000000000000FFFFFFFF
+/*
+ * #define CRCPOLY_TRUE_LE_FULL 0x1DB710641LL
+ *
+ * Barrett Reduction constant (u64`) = u` = (x**64 / P(x))` = 0x1F7011641LL
+ * #define CONSTANT_RU  0x1F7011641LL
+ */
+.Lconstant_RUpoly:
+	.octa 0x00000001F701164100000001DB710641
+
+#define CONSTANT %xmm0
+
+#ifdef __x86_64__
+#define BUF     %rdi
+#define LEN     %rsi
+#define CRC     %edx
+#else
+#define BUF     %eax
+#define LEN     %edx
+#define CRC     %ecx
+#endif
+
+
+
+.text
+/**
+ *      Calculate crc32
+ *      BUF - buffer (16 bytes aligned)
+ *      LEN - sizeof buffer (16 bytes aligned), LEN should be grater
than 63
+ *      CRC - initial crc32
+ *      return %eax crc32
+ *      uint crc32_pclmul_le_16(unsigned char const *buffer,
+ *	                     size_t len, uint crc32)
+ */
+.globl crc32_pclmul_le_16
+.align 4, 0x90
+crc32_pclmul_le_16:/* buffer and buffer size are 16 bytes aligned */
+	movdqa  (BUF), %xmm1
+	movdqa  0x10(BUF), %xmm2
+	movdqa  0x20(BUF), %xmm3
+	movdqa  0x30(BUF), %xmm4
+	movd    CRC, CONSTANT
+	pxor    CONSTANT, %xmm1
+	sub     $0x40, LEN
+	add     $0x40, BUF
+#ifndef __x86_64__
+	/* This is for position independent code(-fPIC) support for 32bit */
+	call    delta
+delta:
+	pop     %ecx
+#endif
+	cmp     $0x40, LEN
+	jb      less_64
+
+#ifdef __x86_64__
+	movdqa .Lconstant_R2R1(%rip), CONSTANT
+#else
+	movdqa .Lconstant_R2R1 - delta(%ecx), CONSTANT
+#endif
+
+loop_64:/*  64 bytes Full cache line folding */
+	prefetchnta    0x40(BUF)
+	movdqa  %xmm1, %xmm5
+	movdqa  %xmm2, %xmm6
+	movdqa  %xmm3, %xmm7
+#ifdef __x86_64__
+	movdqa  %xmm4, %xmm8
+#endif
+	PCLMULQDQ 00, CONSTANT, %xmm1
+	PCLMULQDQ 00, CONSTANT, %xmm2
+	PCLMULQDQ 00, CONSTANT, %xmm3
+#ifdef __x86_64__
+	PCLMULQDQ 00, CONSTANT, %xmm4
+#endif
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	PCLMULQDQ 0x11, CONSTANT, %xmm6
+	PCLMULQDQ 0x11, CONSTANT, %xmm7
+#ifdef __x86_64__
+	PCLMULQDQ 0x11, CONSTANT, %xmm8
+#endif
+	pxor    %xmm5, %xmm1
+	pxor    %xmm6, %xmm2
+	pxor    %xmm7, %xmm3
+#ifdef __x86_64__
+	pxor    %xmm8, %xmm4
+#else
+	/* xmm8 unsupported for x32 */
+	movdqa  %xmm4, %xmm5
+	PCLMULQDQ 00, CONSTANT, %xmm4
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pxor    %xmm5, %xmm4
+#endif
+
+	pxor    (BUF), %xmm1
+	pxor    0x10(BUF), %xmm2
+	pxor    0x20(BUF), %xmm3
+	pxor    0x30(BUF), %xmm4
+
+	sub     $0x40, LEN
+	add     $0x40, BUF
+	cmp     $0x40, LEN
+	jge     loop_64
+less_64:/*  Folding cache line into 128bit */
+#ifdef __x86_64__
+	movdqa  .Lconstant_R4R3(%rip), CONSTANT
+#else
+	movdqa  .Lconstant_R4R3 - delta(%ecx), CONSTANT
+#endif
+	prefetchnta     (BUF)
+
+	movdqa  %xmm1, %xmm5
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pxor    %xmm5, %xmm1
+	pxor    %xmm2, %xmm1
+
+	movdqa  %xmm1, %xmm5
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pxor    %xmm5, %xmm1
+	pxor    %xmm3, %xmm1
+
+	movdqa  %xmm1, %xmm5
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pxor    %xmm5, %xmm1
+	pxor    %xmm4, %xmm1
+
+	cmp     $0x10, LEN
+	jb      fold_64
+loop_16:/* Folding rest buffer into 128bit */
+	movdqa  %xmm1, %xmm5
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pxor    %xmm5, %xmm1
+	pxor    (BUF), %xmm1
+	sub     $0x10, LEN
+	add     $0x10, BUF
+	cmp     $0x10, LEN
+	jge     loop_16
+
+fold_64:
+	/* perform the last 64 bit fold, also adds 32 zeroes
+	 * to the input stream */
+	PCLMULQDQ 0x01, %xmm1, CONSTANT /* R4 * xmm1.low */
+	psrldq  $0x08, %xmm1
+	pxor    CONSTANT, %xmm1
+
+	/* final 32-bit fold */
+	movdqa  %xmm1, %xmm2
+#ifdef __x86_64__
+	movdqa  .Lconstant_R5(%rip), CONSTANT
+	movdqa  .Lconstant_mask32(%rip), %xmm3
+#else
+	movdqa  .Lconstant_R5 - delta(%ecx), CONSTANT
+	movdqa  .Lconstant_mask32 - delta(%ecx), %xmm3
+#endif
+	psrldq  $0x04, %xmm2
+	pand    %xmm3, %xmm1
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	pxor    %xmm2, %xmm1
+
+	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
+#ifdef __x86_64__
+	movdqa  .Lconstant_RUpoly(%rip), CONSTANT
+#else
+	movdqa  .Lconstant_RUpoly - delta(%ecx), CONSTANT
+#endif
+	movdqa  %xmm1, %xmm2
+	pand    %xmm3, %xmm1
+	PCLMULQDQ 0x10, CONSTANT, %xmm1
+	pand    %xmm3, %xmm1
+	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	pxor    %xmm2, %xmm1
+	pextrd  $0x01, %xmm1, %eax
+
+	ret
diff --git a/arch/x86/crypto/crc32-pclmul_glue.c
b/arch/x86/crypto/crc32-pclmul_glue.c
new file mode 100644
index 0000000..0c7647e
--- /dev/null
+++ b/arch/x86/crypto/crc32-pclmul_glue.c
@@ -0,0 +1,202 @@
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
+ * version 2 along with this program; If not, see
http://www.gnu.org/licenses
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
+ * Wrappers for kernel crypto shash api to pclmulqdq crc32 imlementation.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/crc32.h>
+#include <crypto/internal/hash.h>
+
+#include <asm/cpufeature.h>
+#include <asm/cpu_device_id.h>
+#include <asm/i387.h>
+
+#define CHKSUM_BLOCK_SIZE	1
+#define CHKSUM_DIGEST_SIZE	4
+
+#define PCLMUL_MIN_LEN		64L     /* minimum size of buffer
+					 * for crc32_pclmul_le_16 */
+#define SCALE_F			16L	/* size of xmm register */
+#define SCALE_F_MASK		(SCALE_F - 1)
+
+asmlinkage u32 crc32_pclmul_le_16(unsigned char const *buffer, size_t len,
+				  u32 crc32);
+
+static u32 __attribute__((pure))
+	crc32_pclmul_le(u32 crc, unsigned char const *p, size_t len)
+{
+	unsigned int iquotient;
+	unsigned int iremainder;
+	unsigned int prealign;
+
+	if (len < PCLMUL_MIN_LEN + SCALE_F_MASK || !irq_fpu_usable())
+		return crc32_le(crc, p, len);
+
+	if ((long)p & SCALE_F_MASK) {
+		/* align p to 16 byte */
+		prealign = SCALE_F - ((long)p & SCALE_F_MASK);
+
+		crc = crc32_le(crc, p, prealign);
+		len -= prealign;
+		p = (unsigned char *)(((unsigned long)p + SCALE_F_MASK) &
+				     ~SCALE_F_MASK);
+	}
+	iquotient = len & (~SCALE_F_MASK);
+	iremainder = len & SCALE_F_MASK;
+
+	kernel_fpu_begin();
+	crc = crc32_pclmul_le_16(p, iquotient, crc);
+	kernel_fpu_end();
+
+	if (iremainder)
+		crc = crc32_le(crc, p + iquotient, iremainder);
+
+	return crc;
+}
+
+static int crc32_pclmul_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = 0;
+
+	return 0;
+}
+
+static int crc32_pclmul_setkey(struct crypto_shash *hash, const u8 *key,
+			unsigned int keylen)
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
+static int crc32_pclmul_init(struct shash_desc *desc)
+{
+	u32 *mctx = crypto_shash_ctx(desc->tfm);
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = *mctx;
+
+	return 0;
+}
+
+static int crc32_pclmul_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = crc32_pclmul_le(*crcp, data, len);
+	return 0;
+}
+
+/* No final XOR 0xFFFFFFFF, like crc32_le */
+static int __crc32_pclmul_finup(u32 *crcp, const u8 *data, unsigned int
len,
+				u8 *out)
+{
+	*(__le32 *)out = cpu_to_le32(crc32_pclmul_le(*crcp, data, len));
+	return 0;
+}
+
+static int crc32_pclmul_finup(struct shash_desc *desc, const u8 *data,
+			      unsigned int len, u8 *out)
+{
+	return __crc32_pclmul_finup(shash_desc_ctx(desc), data, len, out);
+}
+
+static int crc32_pclmul_final(struct shash_desc *desc, u8 *out)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*(__le32 *)out = cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32_pclmul_digest(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *out)
+{
+	return __crc32_pclmul_finup(crypto_shash_ctx(desc->tfm), data, len,
+				    out);
+}
+
+static struct shash_alg alg = {
+	.setkey		= crc32_pclmul_setkey,
+	.init		= crc32_pclmul_init,
+	.update		= crc32_pclmul_update,
+	.final		= crc32_pclmul_final,
+	.finup		= crc32_pclmul_finup,
+	.digest		= crc32_pclmul_digest,
+	.descsize	= sizeof(u32),
+	.digestsize	= CHKSUM_DIGEST_SIZE,
+	.base		= {
+			.cra_name		= "crc32",
+			.cra_driver_name	= "crc32-pclmul",
+			.cra_priority		= 200,
+			.cra_blocksize		= CHKSUM_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(u32),
+			.cra_module		= THIS_MODULE,
+			.cra_init		= crc32_pclmul_cra_init,
+	}
+};
+
+static const struct x86_cpu_id crc32pclmul_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, crc32pclmul_cpu_id);
+
+
+static int __init crc32_pclmul_mod_init(void)
+{
+
+	if (!x86_match_cpu(crc32pclmul_cpu_id)) {
+		pr_info("PCLMULQDQ-NI instructions are not detected.\n");
+		return -ENODEV;
+	}
+	return crypto_register_shash(&alg);
+}
+
+static void __exit crc32_pclmul_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(crc32_pclmul_mod_init);
+module_exit(crc32_pclmul_mod_fini);
+
+MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("crc32");
+MODULE_ALIAS("crc32-pclmul");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8e84225..744eae8 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -326,6 +326,27 @@ config CRYPTO_CRC32C_INTEL
  	  gain performance compared with software implementation.
  	  Module will be crc32c-intel.

+config CRYPTO_CRC32
+	tristate "CRC32 CRC algorithm"
+	select CRYPTO_HASH
+	select CRC32
+	help
+	  CRC-32-IEEE 802.3 cyclic redundancy-check algorithm.
+	  Shash crypto api wrappers to crc32_le function.
+
+config CRYPTO_CRC32_PCLMUL
+	tristate "CRC32 PCLMULQDQ hardware acceleration"
+	depends on X86
+	select CRYPTO_HASH
+	select CRC32
+	help
+	  From Intel Westmere and AMD Bulldozer processor with SSE4.2
+	  and PCLMULQDQ supported, the processor will support
+	  CRC32 PCLMULQDQ implementation using hardware accelerated PCLMULQDQ
+	  instruction. This option will create 'crc32-plcmul' module,
+	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
+	  and gain better performance as compared with the table implementation.
+
  config CRYPTO_GHASH
  	tristate "GHASH digest algorithm"
  	select CRYPTO_GF128MUL
diff --git a/crypto/Makefile b/crypto/Makefile
index 30f33d6..5c44998 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
  obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
  obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
+obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
  obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
  obj-$(CONFIG_CRYPTO_LZO) += lzo.o
  obj-$(CONFIG_CRYPTO_RNG2) += rng.o
diff --git a/crypto/crc32.c b/crypto/crc32.c
new file mode 100644
index 0000000..9d1c415
--- /dev/null
+++ b/crypto/crc32.c
@@ -0,0 +1,158 @@
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
+ * version 2 along with this program; If not, see
http://www.gnu.org/licenses
+ *
+ * Please  visit http://www.xyratex.com/contact if you need additional
+ * information or have any questions.
+ *
+ * GPL HEADER END
+ */
+
+/*
+ * Copyright 2012 Xyratex Technology Limited
+ */
+
+/*
+ * This is crypto api shash wrappers to crc32_le.
+ */
+
+#include <linux/crc32.h>
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+
+#define CHKSUM_BLOCK_SIZE	1
+#define CHKSUM_DIGEST_SIZE	4
+
+static u32 __crc32_le(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_le(crc, p, len);
+}
+
+/** No default init with ~0 */
+static int crc32_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = 0;
+
+	return 0;
+}
+
+
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR policy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int crc32_setkey(struct crypto_shash *hash, const u8 *key,
+			unsigned int keylen)
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
+static int crc32_init(struct shash_desc *desc)
+{
+	u32 *mctx = crypto_shash_ctx(desc->tfm);
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = *mctx;
+
+	return 0;
+}
+
+static int crc32_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = __crc32_le(*crcp, data, len);
+	return 0;
+}
+
+/* No final XOR 0xFFFFFFFF, like crc32_le */
+static int __crc32_finup(u32 *crcp, const u8 *data, unsigned int len,
+			 u8 *out)
+{
+	*(__le32 *)out = cpu_to_le32(__crc32_le(*crcp, data, len));
+	return 0;
+}
+
+static int crc32_finup(struct shash_desc *desc, const u8 *data,
+		       unsigned int len, u8 *out)
+{
+	return __crc32_finup(shash_desc_ctx(desc), data, len, out);
+}
+
+static int crc32_final(struct shash_desc *desc, u8 *out)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*(__le32 *)out = cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32_digest(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	return __crc32_finup(crypto_shash_ctx(desc->tfm), data, len,
+			     out);
+}
+static struct shash_alg alg = {
+	.setkey		= crc32_setkey,
+	.init		= crc32_init,
+	.update		= crc32_update,
+	.final		= crc32_final,
+	.finup		= crc32_finup,
+	.digest		= crc32_digest,
+	.descsize	= sizeof(u32),
+	.digestsize	= CHKSUM_DIGEST_SIZE,
+	.base		= {
+		.cra_name		= "crc32",
+		.cra_driver_name	= "crc32-table",
+		.cra_priority		= 100,
+		.cra_blocksize		= CHKSUM_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(u32),
+		.cra_module		= THIS_MODULE,
+		.cra_init		= crc32_cra_init,
+	}
+};
+
+static int __init crc32_mod_init(void)
+{
+	return crypto_register_shash(&alg);
+}
+
+static void __exit crc32_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(crc32_mod_init);
+module_exit(crc32_mod_fini);
+
+MODULE_AUTHOR("Alexander Boyko <alexander_boyko@xyratex.com>");
+MODULE_DESCRIPTION("CRC32 calculations wrapper for lib/crc32");
+MODULE_LICENSE("GPL");
--
