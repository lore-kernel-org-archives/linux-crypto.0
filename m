Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B45277818;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732199; cv=none; b=DpO3Y/OW2zgNGlvMMMstlH1s3vIbj5xW6I+nkKZ7Ztbp99FLjj8dFsth7DcY2ONNQ6KH7UoQ/5TdYbV0aWydOI3a+OUNWKuJVx+ViDTtmYlhz/7CKXLII75+B84csA1DaNJYdncNol95aNpACoM8k1LPyn8/5GPlIWHdNQkKb5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732199; c=relaxed/simple;
	bh=GOujaf6AeVir3vIRStzcGHH3O67wB6Z4gyjbS/4cdVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/mg/BbSe9N4tY5fNsRWyCXosagMVWWuk71iKGWqnwjHIHxXAaiNRh44hW+WP0DpeEwPtUSG/raHpf0maJqZ0AGqBU9nm8w6rSd7H5RX1beUcl3n7l6IYEQ6sC0T2KH4OV5MubIMqDCQzlhfqKcL7q/R17xR9m6FSu04V9vbfEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7da6BLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7da6BLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E695C19421;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732198;
	bh=GOujaf6AeVir3vIRStzcGHH3O67wB6Z4gyjbS/4cdVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7da6BLtzTRjctamKJO7nKgshS+quh735NM/0n2RAjRdZA70O9KA4kteQp+yMyh+H
	 3GmDJU6ndYRnz9XkPXDFC7K5fs4Xf52SVu76FVtgD8uV5ErMTdeTE1ztub7FAIp3Av
	 7JE89bCftZ74jbeXt1LBFThSdBMgGvjq5hnNaohu4ecN0iIS+ym6yI6ANAE8vZeiWm
	 PC9dtOQghKFcDUGYRrTUeYJu0xCKp64iovnEFJE8FPKym9iPDbNFljlBIDvnXMjFnp
	 Zkiks5iuIy6sSj1Pu+DU9lVuHmu3jdslC5FTAF8cgplpiqL0bGXN4XqPMfcWtIHsFj
	 1PA+JhHWdo+Ig==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/9] lib/crypto: x86/polyval: Migrate optimized code into library
Date: Sun,  9 Nov 2025 15:47:20 -0800
Message-ID: <20251109234726.638437-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migrate the x86_64 implementation of POLYVAL into lib/crypto/, wiring it
up to the POLYVAL library interface.  This makes the POLYVAL library be
properly optimized on x86_64.

This drops the x86_64 optimizations of polyval in the crypto_shash API.
That's fine, since polyval will be removed from crypto_shash entirely
since it is unneeded there.  But even if it comes back, the crypto_shash
API could just be implemented on top of the library API, as usual.

Adjust the names and prototypes of the assembly functions to align more
closely with the rest of the library code.

Also replace a movaps instruction with movups to remove the assumption
that the key struct is 16-byte aligned.  Users can still align the key
if they want (and at least in this case, movups is just as fast as
movaps), but it's inconvenient to require it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |  10 -
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/polyval-clmulni_glue.c        | 180 ------------------
 include/crypto/polyval.h                      |   3 +
 lib/crypto/Kconfig                            |   1 +
 lib/crypto/Makefile                           |   1 +
 .../crypto/x86/polyval-pclmul-avx.S           |  40 ++--
 lib/crypto/x86/polyval.h                      |  83 ++++++++
 8 files changed, 107 insertions(+), 214 deletions(-)
 delete mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 rename arch/x86/crypto/polyval-clmulni_asm.S => lib/crypto/x86/polyval-pclmul-avx.S (91%)
 create mode 100644 lib/crypto/x86/polyval.h

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 48d3076b6053..3fd2423d3cf8 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -351,20 +351,10 @@ config CRYPTO_NHPOLY1305_AVX2
 	  NHPoly1305 hash function for Adiantum
 
 	  Architecture: x86_64 using:
 	  - AVX2 (Advanced Vector Extensions 2)
 
-config CRYPTO_POLYVAL_CLMUL_NI
-	tristate "Hash functions: POLYVAL (CLMUL-NI)"
-	depends on 64BIT
-	select CRYPTO_POLYVAL
-	help
-	  POLYVAL hash function for HCTR2
-
-	  Architecture: x86_64 using:
-	  - CLMUL-NI (carry-less multiplication new instructions)
-
 config CRYPTO_SM3_AVX_X86_64
 	tristate "Hash functions: SM3 (AVX)"
 	depends on 64BIT
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SM3
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 6409e3009524..5f2fb4f148fe 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -51,13 +51,10 @@ aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-xts-avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
-obj-$(CONFIG_CRYPTO_POLYVAL_CLMUL_NI) += polyval-clmulni.o
-polyval-clmulni-y := polyval-clmulni_asm.o polyval-clmulni_glue.o
-
 obj-$(CONFIG_CRYPTO_NHPOLY1305_SSE2) += nhpoly1305-sse2.o
 nhpoly1305-sse2-y := nh-sse2-x86_64.o nhpoly1305-sse2-glue.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_AVX2) += nhpoly1305-avx2.o
 nhpoly1305-avx2-y := nh-avx2-x86_64.o nhpoly1305-avx2-glue.o
 
diff --git a/arch/x86/crypto/polyval-clmulni_glue.c b/arch/x86/crypto/polyval-clmulni_glue.c
deleted file mode 100644
index 6b466867f91a..000000000000
--- a/arch/x86/crypto/polyval-clmulni_glue.c
+++ /dev/null
@@ -1,180 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Glue code for POLYVAL using PCMULQDQ-NI
- *
- * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
- * Copyright (c) 2009 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- * Copyright 2021 Google LLC
- */
-
-/*
- * Glue code based on ghash-clmulni-intel_glue.c.
- *
- * This implementation of POLYVAL uses montgomery multiplication
- * accelerated by PCLMULQDQ-NI to implement the finite field
- * operations.
- */
-
-#include <asm/cpu_device_id.h>
-#include <asm/fpu/api.h>
-#include <crypto/internal/hash.h>
-#include <crypto/polyval.h>
-#include <crypto/utils.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#define POLYVAL_ALIGN	16
-#define POLYVAL_ALIGN_ATTR __aligned(POLYVAL_ALIGN)
-#define POLYVAL_ALIGN_EXTRA ((POLYVAL_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
-#define POLYVAL_CTX_SIZE (sizeof(struct polyval_tfm_ctx) + POLYVAL_ALIGN_EXTRA)
-#define NUM_KEY_POWERS	8
-
-struct polyval_tfm_ctx {
-	/*
-	 * These powers must be in the order h^8, ..., h^1.
-	 */
-	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE] POLYVAL_ALIGN_ATTR;
-};
-
-struct polyval_desc_ctx {
-	u8 buffer[POLYVAL_BLOCK_SIZE];
-};
-
-asmlinkage void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
-	const u8 *in, size_t nblocks, u8 *accumulator);
-asmlinkage void clmul_polyval_mul(u8 *op1, const u8 *op2);
-
-static inline struct polyval_tfm_ctx *polyval_tfm_ctx(struct crypto_shash *tfm)
-{
-	return PTR_ALIGN(crypto_shash_ctx(tfm), POLYVAL_ALIGN);
-}
-
-static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
-	const u8 *in, size_t nblocks, u8 *accumulator)
-{
-	kernel_fpu_begin();
-	clmul_polyval_update(keys, in, nblocks, accumulator);
-	kernel_fpu_end();
-}
-
-static void internal_polyval_mul(u8 *op1, const u8 *op2)
-{
-	kernel_fpu_begin();
-	clmul_polyval_mul(op1, op2);
-	kernel_fpu_end();
-}
-
-static int polyval_x86_setkey(struct crypto_shash *tfm,
-			const u8 *key, unsigned int keylen)
-{
-	struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(tfm);
-	int i;
-
-	if (keylen != POLYVAL_BLOCK_SIZE)
-		return -EINVAL;
-
-	memcpy(tctx->key_powers[NUM_KEY_POWERS-1], key, POLYVAL_BLOCK_SIZE);
-
-	for (i = NUM_KEY_POWERS-2; i >= 0; i--) {
-		memcpy(tctx->key_powers[i], key, POLYVAL_BLOCK_SIZE);
-		internal_polyval_mul(tctx->key_powers[i],
-				     tctx->key_powers[i+1]);
-	}
-
-	return 0;
-}
-
-static int polyval_x86_init(struct shash_desc *desc)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx, 0, sizeof(*dctx));
-
-	return 0;
-}
-
-static int polyval_x86_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
-	unsigned int nblocks;
-
-	do {
-		/* Allow rescheduling every 4K bytes. */
-		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
-		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
-		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
-		src += nblocks * POLYVAL_BLOCK_SIZE;
-	} while (srclen >= POLYVAL_BLOCK_SIZE);
-
-	return srclen;
-}
-
-static int polyval_x86_finup(struct shash_desc *desc, const u8 *src,
-			     unsigned int len, u8 *dst)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = polyval_tfm_ctx(desc->tfm);
-
-	if (len) {
-		crypto_xor(dctx->buffer, src, len);
-		internal_polyval_mul(dctx->buffer,
-				     tctx->key_powers[NUM_KEY_POWERS-1]);
-	}
-
-	memcpy(dst, dctx->buffer, POLYVAL_BLOCK_SIZE);
-
-	return 0;
-}
-
-static struct shash_alg polyval_alg = {
-	.digestsize	= POLYVAL_DIGEST_SIZE,
-	.init		= polyval_x86_init,
-	.update		= polyval_x86_update,
-	.finup		= polyval_x86_finup,
-	.setkey		= polyval_x86_setkey,
-	.descsize	= sizeof(struct polyval_desc_ctx),
-	.base		= {
-		.cra_name		= "polyval",
-		.cra_driver_name	= "polyval-clmulni",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
-		.cra_ctxsize		= POLYVAL_CTX_SIZE,
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-__maybe_unused static const struct x86_cpu_id pcmul_cpu_id[] = {
-	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL),
-	{}
-};
-MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
-
-static int __init polyval_clmulni_mod_init(void)
-{
-	if (!x86_match_cpu(pcmul_cpu_id))
-		return -ENODEV;
-
-	if (!boot_cpu_has(X86_FEATURE_AVX))
-		return -ENODEV;
-
-	return crypto_register_shash(&polyval_alg);
-}
-
-static void __exit polyval_clmulni_mod_exit(void)
-{
-	crypto_unregister_shash(&polyval_alg);
-}
-
-module_init(polyval_clmulni_mod_init);
-module_exit(polyval_clmulni_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("POLYVAL hash function accelerated by PCLMULQDQ-NI");
-MODULE_ALIAS_CRYPTO("polyval");
-MODULE_ALIAS_CRYPTO("polyval-clmulni");
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index f8aaf4275fbd..b28b8ef11353 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -46,10 +46,13 @@ struct polyval_elem {
 struct polyval_key {
 #ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
 #ifdef CONFIG_ARM64
 	/** @h_powers: Powers of the hash key H^8 through H^1 */
 	struct polyval_elem h_powers[8];
+#elif defined(CONFIG_X86)
+	/** @h_powers: Powers of the hash key H^8 through H^1 */
+	struct polyval_elem h_powers[8];
 #else
 #error "Unhandled arch"
 #endif
 #else /* CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
 	/** @h: The hash key H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 430723994142..9d04b3771ce2 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -143,10 +143,11 @@ config CRYPTO_LIB_POLYVAL
 
 config CRYPTO_LIB_POLYVAL_ARCH
 	bool
 	depends on CRYPTO_LIB_POLYVAL && !UML
 	default y if ARM64 && KERNEL_MODE_NEON
+	default y if X86_64
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 2efa96afcb4b..6580991f8e12 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -201,10 +201,11 @@ clean-files += arm/poly1305-core.S \
 obj-$(CONFIG_CRYPTO_LIB_POLYVAL) += libpolyval.o
 libpolyval-y := polyval.o
 ifeq ($(CONFIG_CRYPTO_LIB_POLYVAL_ARCH),y)
 CFLAGS_polyval.o += -I$(src)/$(SRCARCH)
 libpolyval-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
+libpolyval-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
 endif
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_SHA1) += libsha1.o
diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/lib/crypto/x86/polyval-pclmul-avx.S
similarity index 91%
rename from arch/x86/crypto/polyval-clmulni_asm.S
rename to lib/crypto/x86/polyval-pclmul-avx.S
index a6ebe4e7dd2b..7f739465ad35 100644
--- a/arch/x86/crypto/polyval-clmulni_asm.S
+++ b/lib/crypto/x86/polyval-pclmul-avx.S
@@ -34,14 +34,14 @@
 #define LO %xmm12
 #define HI %xmm13
 #define MI %xmm14
 #define SUM %xmm15
 
-#define KEY_POWERS %rdi
-#define MSG %rsi
-#define BLOCKS_LEFT %rdx
-#define ACCUMULATOR %rcx
+#define ACCUMULATOR %rdi
+#define KEY_POWERS %rsi
+#define MSG %rdx
+#define BLOCKS_LEFT %rcx
 #define TMP %rax
 
 .section    .rodata.cst16.gstar, "aM", @progbits, 16
 .align 16
 
@@ -232,11 +232,11 @@
 	addq $(16*STRIDE_BLOCKS), KEY_POWERS
 	subq TMP, KEY_POWERS
 
 	movups (MSG), %xmm0
 	pxor SUM, %xmm0
-	movaps (KEY_POWERS), %xmm1
+	movups (KEY_POWERS), %xmm1
 	schoolbook1_noload
 	dec BLOCKS_LEFT
 	addq $16, MSG
 	addq $16, KEY_POWERS
 
@@ -259,45 +259,43 @@
 	schoolbook2
 	montgomery_reduction SUM
 .endm
 
 /*
- * Perform montgomery multiplication in GF(2^128) and store result in op1.
+ * Computes a = a * b * x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1.
  *
- * Computes op1*op2*x^{-128} mod x^128 + x^127 + x^126 + x^121 + 1
- * If op1, op2 are in montgomery form, this computes the montgomery
- * form of op1*op2.
- *
- * void clmul_polyval_mul(u8 *op1, const u8 *op2);
+ * void polyval_mul_pclmul_avx(struct polyval_elem *a,
+ *			       const struct polyval_elem *b);
  */
-SYM_FUNC_START(clmul_polyval_mul)
+SYM_FUNC_START(polyval_mul_pclmul_avx)
 	FRAME_BEGIN
 	vmovdqa .Lgstar(%rip), GSTAR
 	movups (%rdi), %xmm0
 	movups (%rsi), %xmm1
 	schoolbook1_noload
 	schoolbook2
 	montgomery_reduction SUM
 	movups SUM, (%rdi)
 	FRAME_END
 	RET
-SYM_FUNC_END(clmul_polyval_mul)
+SYM_FUNC_END(polyval_mul_pclmul_avx)
 
 /*
  * Perform polynomial evaluation as specified by POLYVAL.  This computes:
  *	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
  * where n=nblocks, h is the hash key, and m_i are the message blocks.
  *
- * rdi - pointer to precomputed key powers h^8 ... h^1
- * rsi - pointer to message blocks
- * rdx - number of blocks to hash
- * rcx - pointer to the accumulator
+ * rdi - pointer to the accumulator
+ * rsi - pointer to precomputed key powers h^8 ... h^1
+ * rdx - pointer to message blocks
+ * rcx - number of blocks to hash
  *
- * void clmul_polyval_update(const struct polyval_tfm_ctx *keys,
- *	const u8 *in, size_t nblocks, u8 *accumulator);
+ * void polyval_blocks_pclmul_avx(struct polyval_elem *acc,
+ *				  const struct polyval_key *key,
+ *				  const u8 *data, size_t nblocks);
  */
-SYM_FUNC_START(clmul_polyval_update)
+SYM_FUNC_START(polyval_blocks_pclmul_avx)
 	FRAME_BEGIN
 	vmovdqa .Lgstar(%rip), GSTAR
 	movups (ACCUMULATOR), SUM
 	subq $STRIDE_BLOCKS, BLOCKS_LEFT
 	js .LstrideLoopExit
@@ -316,6 +314,6 @@ SYM_FUNC_START(clmul_polyval_update)
 	partial_stride
 .LskipPartial:
 	movups SUM, (ACCUMULATOR)
 	FRAME_END
 	RET
-SYM_FUNC_END(clmul_polyval_update)
+SYM_FUNC_END(polyval_blocks_pclmul_avx)
diff --git a/lib/crypto/x86/polyval.h b/lib/crypto/x86/polyval.h
new file mode 100644
index 000000000000..ef8797521420
--- /dev/null
+++ b/lib/crypto/x86/polyval.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * POLYVAL library functions, x86_64 optimized
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <asm/fpu/api.h>
+#include <linux/cpufeature.h>
+
+#define NUM_H_POWERS 8
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pclmul_avx);
+
+asmlinkage void polyval_mul_pclmul_avx(struct polyval_elem *a,
+				       const struct polyval_elem *b);
+asmlinkage void polyval_blocks_pclmul_avx(struct polyval_elem *acc,
+					  const struct polyval_key *key,
+					  const u8 *data, size_t nblocks);
+
+static void polyval_preparekey_arch(struct polyval_key *key,
+				    const u8 raw_key[POLYVAL_BLOCK_SIZE])
+{
+	static_assert(ARRAY_SIZE(key->h_powers) == NUM_H_POWERS);
+	memcpy(&key->h_powers[NUM_H_POWERS - 1], raw_key, POLYVAL_BLOCK_SIZE);
+	if (static_branch_likely(&have_pclmul_avx) && irq_fpu_usable()) {
+		kernel_fpu_begin();
+		for (int i = NUM_H_POWERS - 2; i >= 0; i--) {
+			key->h_powers[i] = key->h_powers[i + 1];
+			polyval_mul_pclmul_avx(
+				&key->h_powers[i],
+				&key->h_powers[NUM_H_POWERS - 1]);
+		}
+		kernel_fpu_end();
+	} else {
+		for (int i = NUM_H_POWERS - 2; i >= 0; i--) {
+			key->h_powers[i] = key->h_powers[i + 1];
+			polyval_mul_generic(&key->h_powers[i],
+					    &key->h_powers[NUM_H_POWERS - 1]);
+		}
+	}
+}
+
+static void polyval_mul_arch(struct polyval_elem *acc,
+			     const struct polyval_key *key)
+{
+	if (static_branch_likely(&have_pclmul_avx) && irq_fpu_usable()) {
+		kernel_fpu_begin();
+		polyval_mul_pclmul_avx(acc, &key->h_powers[NUM_H_POWERS - 1]);
+		kernel_fpu_end();
+	} else {
+		polyval_mul_generic(acc, &key->h_powers[NUM_H_POWERS - 1]);
+	}
+}
+
+static void polyval_blocks_arch(struct polyval_elem *acc,
+				const struct polyval_key *key,
+				const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_pclmul_avx) && irq_fpu_usable()) {
+		do {
+			/* Allow rescheduling every 4 KiB. */
+			size_t n = min_t(size_t, nblocks,
+					 4096 / POLYVAL_BLOCK_SIZE);
+
+			kernel_fpu_begin();
+			polyval_blocks_pclmul_avx(acc, key, data, n);
+			kernel_fpu_end();
+			data += n * POLYVAL_BLOCK_SIZE;
+			nblocks -= n;
+		} while (nblocks);
+	} else {
+		polyval_blocks_generic(acc, &key->h_powers[NUM_H_POWERS - 1],
+				       data, nblocks);
+	}
+}
+
+#define polyval_mod_init_arch polyval_mod_init_arch
+static void polyval_mod_init_arch(void)
+{
+	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ) &&
+	    boot_cpu_has(X86_FEATURE_AVX))
+		static_branch_enable(&have_pclmul_avx);
+}
-- 
2.51.2

