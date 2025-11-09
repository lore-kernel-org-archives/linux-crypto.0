Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BCF27586C;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732198; cv=none; b=DXz2gEh2oiu/53v1tz+z/TN2InISlH+L9ZlFT6qW/tJu5WKrQIvqY7/7rN0aRZ/ZEiky3SKWSMs7v2XkQxBWWR6zdz2Dqp/xWqJfeuecXVMVydaYZRlSNCsTR0Ro7wKET929LDDzpyzYtIQ/x5g21EKSAFpfPrfSEPQfi/R2McI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732198; c=relaxed/simple;
	bh=8e2kAyHo72Xgi4j2u5Y3CXtlQQMKjJmSz6jydmNZnxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lknWclMlcXwq192pLmGvJwzEkNJ3ukW9zUup//6J++wR+3MHFfcv0uQUBTQZVpjTHW2VxzDeKYftATbiXF0Xa30dwmE4aQ1Wz7PVNTwIPLBYueGyvlFQZZv/gMXrY8uv5teHPjACdZlkW8QM0zGS6R51pc9FEjAs5nH5qU7mHCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofoRsJIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofoRsJIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458C1C2BC86;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732198;
	bh=8e2kAyHo72Xgi4j2u5Y3CXtlQQMKjJmSz6jydmNZnxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofoRsJIK5A99kKzkhQCZYQBjBXFcHhBgj3INXraIhnakfH58TtBA+RHWMS8uHJkam
	 g+MQbJK1sIO1GQEyNkUwdYT8nv5VcKf2ncwR3DAdVOzCtDTuZUN4iZwhTjXKnexEGX
	 d6g9S1yVdZKTABsEgUjYpdC/DolxCElel55yHFYt1y5u0dpXqPDCLIGUgQhsnFnJZg
	 kb+ahNHmDWwvS/MPyRLW9+ktbnSMdgQ+E8Fit70rsKf2tE7zKq9Q2FhWhGQsXnXqiu
	 XswnLIbeL/5Hd4hS8l8g7mIFxb22TxaQ2a4mXg+crgo5vEr9fnKTG81bsebDDaAPjf
	 IrHz1f2SE6EnQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/9] lib/crypto: arm64/polyval: Migrate optimized code into library
Date: Sun,  9 Nov 2025 15:47:19 -0800
Message-ID: <20251109234726.638437-5-ebiggers@kernel.org>
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

Migrate the arm64 implementation of POLYVAL into lib/crypto/, wiring it
up to the POLYVAL library interface.  This makes the POLYVAL library be
properly optimized on arm64.

This drops the arm64 optimizations of polyval in the crypto_shash API.
That's fine, since polyval will be removed from crypto_shash entirely
since it is unneeded there.  But even if it comes back, the crypto_shash
API could just be implemented on top of the library API, as usual.

Adjust the names and prototypes of the assembly functions to align more
closely with the rest of the library code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/Kconfig                     |  10 --
 arch/arm64/crypto/Makefile                    |   3 -
 arch/arm64/crypto/polyval-ce-glue.c           | 158 ------------------
 include/crypto/polyval.h                      |   8 +
 lib/crypto/Kconfig                            |   1 +
 lib/crypto/Makefile                           |   1 +
 .../crypto/arm64}/polyval-ce-core.S           |  38 ++---
 lib/crypto/arm64/polyval.h                    |  82 +++++++++
 8 files changed, 110 insertions(+), 191 deletions(-)
 delete mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 rename {arch/arm64/crypto => lib/crypto/arm64}/polyval-ce-core.S (92%)
 create mode 100644 lib/crypto/arm64/polyval.h

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 376d6b50743f..bdd276a6e540 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -45,20 +45,10 @@ config CRYPTO_SM3_ARM64_CE
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
 
 	  Architecture: arm64 using:
 	  - ARMv8.2 Crypto Extensions
 
-config CRYPTO_POLYVAL_ARM64_CE
-	tristate "Hash functions: POLYVAL (ARMv8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
-	select CRYPTO_POLYVAL
-	help
-	  POLYVAL hash function for HCTR2
-
-	  Architecture: arm64 using:
-	  - ARMv8 Crypto Extensions
-
 config CRYPTO_AES_ARM64
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, CTS, XCTR, XTS"
 	select CRYPTO_AES
 	select CRYPTO_LIB_SHA256
 	help
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index fd3d590fa113..1e330aa08d3f 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -27,13 +27,10 @@ obj-$(CONFIG_CRYPTO_SM4_ARM64_NEON_BLK) += sm4-neon.o
 sm4-neon-y := sm4-neon-glue.o sm4-neon-core.o
 
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
 ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
-obj-$(CONFIG_CRYPTO_POLYVAL_ARM64_CE) += polyval-ce.o
-polyval-ce-y := polyval-ce-glue.o polyval-ce-core.o
-
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
 aes-ce-cipher-y := aes-ce-core.o aes-ce-glue.o
 
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE_CCM) += aes-ce-ccm.o
 aes-ce-ccm-y := aes-ce-ccm-glue.o aes-ce-ccm-core.o
diff --git a/arch/arm64/crypto/polyval-ce-glue.c b/arch/arm64/crypto/polyval-ce-glue.c
deleted file mode 100644
index c4e653688ea0..000000000000
--- a/arch/arm64/crypto/polyval-ce-glue.c
+++ /dev/null
@@ -1,158 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Glue code for POLYVAL using ARMv8 Crypto Extensions
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
- * This implementation of POLYVAL uses montgomery multiplication accelerated by
- * ARMv8 Crypto Extensions instructions to implement the finite field operations.
- */
-
-#include <asm/neon.h>
-#include <crypto/internal/hash.h>
-#include <crypto/polyval.h>
-#include <crypto/utils.h>
-#include <linux/cpufeature.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-#define NUM_KEY_POWERS	8
-
-struct polyval_tfm_ctx {
-	/*
-	 * These powers must be in the order h^8, ..., h^1.
-	 */
-	u8 key_powers[NUM_KEY_POWERS][POLYVAL_BLOCK_SIZE];
-};
-
-struct polyval_desc_ctx {
-	u8 buffer[POLYVAL_BLOCK_SIZE];
-};
-
-asmlinkage void pmull_polyval_update(const struct polyval_tfm_ctx *keys,
-	const u8 *in, size_t nblocks, u8 *accumulator);
-asmlinkage void pmull_polyval_mul(u8 *op1, const u8 *op2);
-
-static void internal_polyval_update(const struct polyval_tfm_ctx *keys,
-	const u8 *in, size_t nblocks, u8 *accumulator)
-{
-	kernel_neon_begin();
-	pmull_polyval_update(keys, in, nblocks, accumulator);
-	kernel_neon_end();
-}
-
-static void internal_polyval_mul(u8 *op1, const u8 *op2)
-{
-	kernel_neon_begin();
-	pmull_polyval_mul(op1, op2);
-	kernel_neon_end();
-}
-
-static int polyval_arm64_setkey(struct crypto_shash *tfm,
-			const u8 *key, unsigned int keylen)
-{
-	struct polyval_tfm_ctx *tctx = crypto_shash_ctx(tfm);
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
-static int polyval_arm64_init(struct shash_desc *desc)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx, 0, sizeof(*dctx));
-
-	return 0;
-}
-
-static int polyval_arm64_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	unsigned int nblocks;
-
-	do {
-		/* allow rescheduling every 4K bytes */
-		nblocks = min(srclen, 4096U) / POLYVAL_BLOCK_SIZE;
-		internal_polyval_update(tctx, src, nblocks, dctx->buffer);
-		srclen -= nblocks * POLYVAL_BLOCK_SIZE;
-		src += nblocks * POLYVAL_BLOCK_SIZE;
-	} while (srclen >= POLYVAL_BLOCK_SIZE);
-
-	return srclen;
-}
-
-static int polyval_arm64_finup(struct shash_desc *desc, const u8 *src,
-			       unsigned int len, u8 *dst)
-{
-	struct polyval_desc_ctx *dctx = shash_desc_ctx(desc);
-	const struct polyval_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
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
-	.init		= polyval_arm64_init,
-	.update		= polyval_arm64_update,
-	.finup		= polyval_arm64_finup,
-	.setkey		= polyval_arm64_setkey,
-	.descsize	= sizeof(struct polyval_desc_ctx),
-	.base		= {
-		.cra_name		= "polyval",
-		.cra_driver_name	= "polyval-ce",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize		= POLYVAL_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct polyval_tfm_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-static int __init polyval_ce_mod_init(void)
-{
-	return crypto_register_shash(&polyval_alg);
-}
-
-static void __exit polyval_ce_mod_exit(void)
-{
-	crypto_unregister_shash(&polyval_alg);
-}
-
-module_cpu_feature_match(PMULL, polyval_ce_mod_init)
-module_exit(polyval_ce_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("POLYVAL hash function accelerated by ARMv8 Crypto Extensions");
-MODULE_ALIAS_CRYPTO("polyval");
-MODULE_ALIAS_CRYPTO("polyval-ce");
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
index 5ba4c248cad1..f8aaf4275fbd 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/polyval.h
@@ -37,14 +37,22 @@ struct polyval_elem {
  * struct polyval_key - Prepared key for POLYVAL
  *
  * This may contain just the raw key H, or it may contain precomputed key
  * powers, depending on the platform's POLYVAL implementation.  Use
  * polyval_preparekey() to initialize this.
+ *
+ * By H^i we mean H^(i-1) * H * x^-128, with base case H^1 = H.  I.e. the
+ * exponentiation repeats the POLYVAL dot operation, with its "extra" x^-128.
  */
 struct polyval_key {
 #ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#ifdef CONFIG_ARM64
+	/** @h_powers: Powers of the hash key H^8 through H^1 */
+	struct polyval_elem h_powers[8];
+#else
 #error "Unhandled arch"
+#endif
 #else /* CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
 	/** @h: The hash key H */
 	struct polyval_elem h;
 #endif /* !CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
 };
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 6545f0e83b83..430723994142 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -142,10 +142,11 @@ config CRYPTO_LIB_POLYVAL
 	  the functions from <crypto/polyval.h>.
 
 config CRYPTO_LIB_POLYVAL_ARCH
 	bool
 	depends on CRYPTO_LIB_POLYVAL && !UML
+	default y if ARM64 && KERNEL_MODE_NEON
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 055e44008805..2efa96afcb4b 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -200,10 +200,11 @@ clean-files += arm/poly1305-core.S \
 
 obj-$(CONFIG_CRYPTO_LIB_POLYVAL) += libpolyval.o
 libpolyval-y := polyval.o
 ifeq ($(CONFIG_CRYPTO_LIB_POLYVAL_ARCH),y)
 CFLAGS_polyval.o += -I$(src)/$(SRCARCH)
+libpolyval-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
 endif
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_SHA1) += libsha1.o
diff --git a/arch/arm64/crypto/polyval-ce-core.S b/lib/crypto/arm64/polyval-ce-core.S
similarity index 92%
rename from arch/arm64/crypto/polyval-ce-core.S
rename to lib/crypto/arm64/polyval-ce-core.S
index b5326540d2e3..7c731a044d02 100644
--- a/arch/arm64/crypto/polyval-ce-core.S
+++ b/lib/crypto/arm64/polyval-ce-core.S
@@ -25,14 +25,14 @@
  */
 
 #include <linux/linkage.h>
 #define STRIDE_BLOCKS 8
 
-KEY_POWERS	.req	x0
-MSG		.req	x1
-BLOCKS_LEFT	.req	x2
-ACCUMULATOR	.req	x3
+ACCUMULATOR	.req	x0
+KEY_POWERS	.req	x1
+MSG		.req	x2
+BLOCKS_LEFT	.req	x3
 KEY_START	.req	x10
 EXTRA_BYTES	.req	x11
 TMP	.req	x13
 
 M0	.req	v0
@@ -298,44 +298,42 @@ GSTAR	.req	v24
 	karatsuba2
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
- * void pmull_polyval_mul(u8 *op1, const u8 *op2);
+ * void polyval_mul_pmull(struct polyval_elem *a,
+ *			  const struct polyval_elem *b);
  */
-SYM_FUNC_START(pmull_polyval_mul)
+SYM_FUNC_START(polyval_mul_pmull)
 	adr	TMP, .Lgstar
 	ld1	{GSTAR.2d}, [TMP]
 	ld1	{v0.16b}, [x0]
 	ld1	{v1.16b}, [x1]
 	karatsuba1_store v0 v1
 	karatsuba2
 	montgomery_reduction SUM
 	st1	{SUM.16b}, [x0]
 	ret
-SYM_FUNC_END(pmull_polyval_mul)
+SYM_FUNC_END(polyval_mul_pmull)
 
 /*
  * Perform polynomial evaluation as specified by POLYVAL.  This computes:
  *	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
  * where n=nblocks, h is the hash key, and m_i are the message blocks.
  *
- * x0 - pointer to precomputed key powers h^8 ... h^1
- * x1 - pointer to message blocks
- * x2 - number of blocks to hash
- * x3 - pointer to accumulator
+ * x0 - pointer to accumulator
+ * x1 - pointer to precomputed key powers h^8 ... h^1
+ * x2 - pointer to message blocks
+ * x3 - number of blocks to hash
  *
- * void pmull_polyval_update(const struct polyval_ctx *ctx, const u8 *in,
- *			     size_t nblocks, u8 *accumulator);
+ * void polyval_blocks_pmull(struct polyval_elem *acc,
+ *			     const struct polyval_key *key,
+ *			     const u8 *data, size_t nblocks);
  */
-SYM_FUNC_START(pmull_polyval_update)
+SYM_FUNC_START(polyval_blocks_pmull)
 	adr	TMP, .Lgstar
 	mov	KEY_START, KEY_POWERS
 	ld1	{GSTAR.2d}, [TMP]
 	ld1	{SUM.16b}, [ACCUMULATOR]
 	subs	BLOCKS_LEFT, BLOCKS_LEFT, #STRIDE_BLOCKS
@@ -356,6 +354,6 @@ SYM_FUNC_START(pmull_polyval_update)
 	beq	.LskipPartial
 	partial_stride
 .LskipPartial:
 	st1	{SUM.16b}, [ACCUMULATOR]
 	ret
-SYM_FUNC_END(pmull_polyval_update)
+SYM_FUNC_END(polyval_blocks_pmull)
diff --git a/lib/crypto/arm64/polyval.h b/lib/crypto/arm64/polyval.h
new file mode 100644
index 000000000000..2486e80750d0
--- /dev/null
+++ b/lib/crypto/arm64/polyval.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * POLYVAL library functions, arm64 optimized
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <linux/cpufeature.h>
+
+#define NUM_H_POWERS 8
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
+
+asmlinkage void polyval_mul_pmull(struct polyval_elem *a,
+				  const struct polyval_elem *b);
+asmlinkage void polyval_blocks_pmull(struct polyval_elem *acc,
+				     const struct polyval_key *key,
+				     const u8 *data, size_t nblocks);
+
+static void polyval_preparekey_arch(struct polyval_key *key,
+				    const u8 raw_key[POLYVAL_BLOCK_SIZE])
+{
+	static_assert(ARRAY_SIZE(key->h_powers) == NUM_H_POWERS);
+	memcpy(&key->h_powers[NUM_H_POWERS - 1], raw_key, POLYVAL_BLOCK_SIZE);
+	if (static_branch_likely(&have_pmull) && may_use_simd()) {
+		kernel_neon_begin();
+		for (int i = NUM_H_POWERS - 2; i >= 0; i--) {
+			key->h_powers[i] = key->h_powers[i + 1];
+			polyval_mul_pmull(&key->h_powers[i],
+					  &key->h_powers[NUM_H_POWERS - 1]);
+		}
+		kernel_neon_end();
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
+	if (static_branch_likely(&have_pmull) && may_use_simd()) {
+		kernel_neon_begin();
+		polyval_mul_pmull(acc, &key->h_powers[NUM_H_POWERS - 1]);
+		kernel_neon_end();
+	} else {
+		polyval_mul_generic(acc, &key->h_powers[NUM_H_POWERS - 1]);
+	}
+}
+
+static void polyval_blocks_arch(struct polyval_elem *acc,
+				const struct polyval_key *key,
+				const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_pmull) && may_use_simd()) {
+		do {
+			/* Allow rescheduling every 4 KiB. */
+			size_t n = min_t(size_t, nblocks,
+					 4096 / POLYVAL_BLOCK_SIZE);
+
+			kernel_neon_begin();
+			polyval_blocks_pmull(acc, key, data, n);
+			kernel_neon_end();
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
+	if (cpu_have_named_feature(PMULL))
+		static_branch_enable(&have_pmull);
+}
-- 
2.51.2

