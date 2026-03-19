Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7DB359703;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901159; cv=none; b=sTlDMvzWL+IzwmCoJZtnueTo4kWg1L4mDAFNHK868dZSltiaXlxliNe/LWO+SkcWh1wc2JnUC+uW/oBoV8yfXsOtjRsG/oA8eJP8aqgsxD/Vt695pBrvb9ufjtazy04Oo1UIcOuyMga5HctZmYA5c6Xg9fGRXDiKJRlfqVEh5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901159; c=relaxed/simple;
	bh=yr8pKBP08w4IQOykt2Y32o124L8GWjwohcioSRWmwdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulbkcSUmy0UaBJjqZlrx5ON1rBN1vVR+ANuo45a4+0Wn89cSqZu9QCmiHi77AAnBiuPp7FBUX5J5KiWhYr1IYieY2wprqS3qcLvmhGNWiM7ZcFOy6GjVs0bOhAizGHlc/HffQDHeyNMDYvAxEzJip+o26hxqvjBypUPjYo2OGrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srZICETK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srZICETK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9F7C19425;
	Thu, 19 Mar 2026 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901158;
	bh=yr8pKBP08w4IQOykt2Y32o124L8GWjwohcioSRWmwdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srZICETKoqua/JoZbO/T3R+C7Ijrlp6jUWjb/0ULuTwyL7bg8SKcyKQjSg13NqVkI
	 rYncMULyh6z0UsA0CNoYrrJQk0adbGrcOdqWw1WKcIR3d0fBG8XDDyS+MsQsIi0tUF
	 vPS5fHQaV2NjqJ+v7ZwNRVTVcsUKy4n/f2dtZ4elTMUrTPPykUOEJDOtaV54jvgsUn
	 iAGKNzdr51p1nQ3wZTo5vssSgzic0sPUBQ9QFFQZ9Nm99iVE2e6UbJV++nWN8cmTsU
	 WWRP/lezIN8tazlI2KPjsV2jN9OP06PI2ojgLZ4KQ4OwSg1xm87vxPZ37+IwZhj9hT
	 njCZCgVt2oqDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/19] lib/crypto: arm64/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:10 -0700
Message-ID: <20260319061723.1140720-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the "ghash-neon" crypto_shash algorithm.  Move the corresponding
assembly code into lib/crypto/, and wire it up to the GHASH library.

This makes the GHASH library be optimized on arm64 (though only with
NEON, not PMULL; for now the goal is just parity with crypto_shash).  It
greatly reduces the amount of arm64-specific glue code that is needed,
and it fixes the issue where this optimization was disabled by default.

To integrate the assembly code correctly with the library, make the
following tweaks:

- Change the type of 'blocks' from int to size_t
- Change the types of 'dg' and 'k' to polyval_elem.  Note that this
  simply reflects the format that the code was already using.
- Remove the 'head' argument, which is no longer needed.
- Remove the CFI stubs, as indirect calls are no longer used.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/Kconfig                     |   5 +-
 arch/arm64/crypto/Makefile                    |   2 +-
 arch/arm64/crypto/ghash-ce-core.S             |   3 +-
 arch/arm64/crypto/ghash-ce-glue.c             | 146 ++----------------
 lib/crypto/Makefile                           |   3 +-
 lib/crypto/arm64/gf128hash.h                  |  68 +++++++-
 .../crypto/arm64}/ghash-neon-core.S           |  20 +--
 7 files changed, 86 insertions(+), 161 deletions(-)
 rename {arch/arm64/crypto => lib/crypto/arm64}/ghash-neon-core.S (93%)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 82794afaffc9..1a0c553fbfd7 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -1,18 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
 menu "Accelerated Cryptographic Algorithms for CPU (arm64)"
 
 config CRYPTO_GHASH_ARM64_CE
-	tristate "Hash functions: GHASH (ARMv8 Crypto Extensions)"
+	tristate "AEAD cipher: AES in GCM mode (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
-	select CRYPTO_HASH
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_AEAD
 	help
-	  GCM GHASH function (NIST SP800-38D)
+	  AEAD cipher: AES-GCM
 
 	  Architecture: arm64 using:
 	  - ARMv8 Crypto Extensions
 
 config CRYPTO_SM3_NEON
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index b7ba43ce8584..8a8e3e551ed3 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -25,11 +25,11 @@ sm4-ce-gcm-y := sm4-ce-gcm-glue.o sm4-ce-gcm-core.o
 
 obj-$(CONFIG_CRYPTO_SM4_ARM64_NEON_BLK) += sm4-neon.o
 sm4-neon-y := sm4-neon-glue.o sm4-neon-core.o
 
 obj-$(CONFIG_CRYPTO_GHASH_ARM64_CE) += ghash-ce.o
-ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o ghash-neon-core.o
+ghash-ce-y := ghash-ce-glue.o ghash-ce-core.o
 
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE_CCM) += aes-ce-ccm.o
 aes-ce-ccm-y := aes-ce-ccm-glue.o aes-ce-ccm-core.o
 
 obj-$(CONFIG_CRYPTO_AES_ARM64_CE_BLK) += aes-ce-blk.o
diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 4344fe213d14..a01f136f4fb2 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -4,11 +4,10 @@
  *
  * Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 	SHASH		.req	v0
 	SHASH2		.req	v1
 	T1		.req	v2
@@ -65,11 +64,11 @@
 
 	/*
 	 * void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
 	 *			       u64 const h[][2], const char *head)
 	 */
-SYM_TYPED_FUNC_START(pmull_ghash_update_p64)
+SYM_FUNC_START(pmull_ghash_update_p64)
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
 
 	__pmull_pre_p64
 
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 63bb9e062251..42fb46bdc124 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -1,19 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Accelerated GHASH implementation with ARMv8 PMULL instructions.
+ * AES-GCM using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <crypto/aes.h>
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
 #include <crypto/ghash.h>
 #include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -21,14 +20,15 @@
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
 #include <asm/simd.h>
 
-MODULE_DESCRIPTION("GHASH and AES-GCM using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("ghash");
+MODULE_ALIAS_CRYPTO("gcm(aes)");
+MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 
 #define RFC4106_NONCE_SIZE	4
 
 struct ghash_key {
 	be128			k;
@@ -46,100 +46,23 @@ struct gcm_aes_ctx {
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
 				       u64 const h[][2], const char *head);
 
-asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-				      u64 const h[][2], const char *head);
-
 asmlinkage void pmull_gcm_encrypt(int bytes, u8 dst[], const u8 src[],
 				  u64 const h[][2], u64 dg[], u8 ctr[],
 				  u32 const rk[], int rounds, u8 tag[]);
 asmlinkage int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
 				 u64 const h[][2], u64 dg[], u8 ctr[],
 				 u32 const rk[], int rounds, const u8 l[],
 				 const u8 tag[], u64 authsize);
 
-static int ghash_init(struct shash_desc *desc)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*ctx = (struct arm_ghash_desc_ctx){};
-	return 0;
-}
-
-static __always_inline
-void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
-			  struct ghash_key *key, const char *head,
-			  void (*simd_update)(int blocks, u64 dg[],
-					      const char *src,
-					      u64 const h[][2],
-					      const char *head))
+static void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
+				 struct ghash_key *key, const char *head)
 {
 	scoped_ksimd()
-		simd_update(blocks, dg, src, key->h, head);
-}
-
-/* avoid hogging the CPU for too long */
-#define MAX_BLOCKS	(SZ_64K / GHASH_BLOCK_SIZE)
-
-static int ghash_update(struct shash_desc *desc, const u8 *src,
-			unsigned int len)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-	int blocks;
-
-	blocks = len / GHASH_BLOCK_SIZE;
-	len -= blocks * GHASH_BLOCK_SIZE;
-
-	do {
-		int chunk = min(blocks, MAX_BLOCKS);
-
-		ghash_do_simd_update(chunk, ctx->digest, src, key, NULL,
-				     pmull_ghash_update_p8);
-		blocks -= chunk;
-		src += chunk * GHASH_BLOCK_SIZE;
-	} while (unlikely(blocks > 0));
-	return len;
-}
-
-static int ghash_export(struct shash_desc *desc, void *out)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	u8 *dst = out;
-
-	put_unaligned_be64(ctx->digest[1], dst);
-	put_unaligned_be64(ctx->digest[0], dst + 8);
-	return 0;
-}
-
-static int ghash_import(struct shash_desc *desc, const void *in)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	const u8 *src = in;
-
-	ctx->digest[1] = get_unaligned_be64(src);
-	ctx->digest[0] = get_unaligned_be64(src + 8);
-	return 0;
-}
-
-static int ghash_finup(struct shash_desc *desc, const u8 *src,
-		       unsigned int len, u8 *dst)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-
-	if (len) {
-		u8 buf[GHASH_BLOCK_SIZE] = {};
-
-		memcpy(buf, src, len);
-		ghash_do_simd_update(1, ctx->digest, buf, key, NULL,
-				     pmull_ghash_update_p8);
-		memzero_explicit(buf, sizeof(buf));
-	}
-	return ghash_export(desc, dst);
+		pmull_ghash_update_p64(blocks, dg, src, key->h, head);
 }
 
 static void ghash_reflect(u64 h[], const be128 *k)
 {
 	u64 carry = be64_to_cpu(k->a) & BIT(63) ? 1 : 0;
@@ -149,45 +72,10 @@ static void ghash_reflect(u64 h[], const be128 *k)
 
 	if (carry)
 		h[1] ^= 0xc200000000000000UL;
 }
 
-static int ghash_setkey(struct crypto_shash *tfm,
-			const u8 *inkey, unsigned int keylen)
-{
-	struct ghash_key *key = crypto_shash_ctx(tfm);
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	/* needed for the fallback */
-	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
-
-	ghash_reflect(key->h[0], &key->k);
-	return 0;
-}
-
-static struct shash_alg ghash_alg = {
-	.base.cra_name		= "ghash",
-	.base.cra_driver_name	= "ghash-neon",
-	.base.cra_priority	= 150,
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= GHASH_DIGEST_SIZE,
-	.init			= ghash_init,
-	.update			= ghash_update,
-	.finup			= ghash_finup,
-	.setkey			= ghash_setkey,
-	.export			= ghash_export,
-	.import			= ghash_import,
-	.descsize		= sizeof(struct arm_ghash_desc_ctx),
-	.statesize		= sizeof(struct ghash_desc_ctx),
-};
-
 static int gcm_aes_setkey(struct crypto_aead *tfm, const u8 *inkey,
 			  unsigned int keylen)
 {
 	struct gcm_aes_ctx *ctx = crypto_aead_ctx(tfm);
 	u8 key[GHASH_BLOCK_SIZE];
@@ -238,13 +126,11 @@ static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
 
 	if (count >= GHASH_BLOCK_SIZE || *buf_count == GHASH_BLOCK_SIZE) {
 		int blocks = count / GHASH_BLOCK_SIZE;
 
 		ghash_do_simd_update(blocks, dg, src, &ctx->ghash_key,
-				     *buf_count ? buf : NULL,
-				     pmull_ghash_update_p64);
-
+				     *buf_count ? buf : NULL);
 		src += blocks * GHASH_BLOCK_SIZE;
 		count %= GHASH_BLOCK_SIZE;
 		*buf_count = 0;
 	}
 
@@ -273,12 +159,11 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[], u32 len)
 		len -= n;
 	} while (len);
 
 	if (buf_count) {
 		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
-		ghash_do_simd_update(1, dg, buf, &ctx->ghash_key, NULL,
-				     pmull_ghash_update_p64);
+		ghash_do_simd_update(1, dg, buf, &ctx->ghash_key, NULL);
 	}
 }
 
 static int gcm_encrypt(struct aead_request *req, char *iv, int assoclen)
 {
@@ -503,26 +388,19 @@ static struct aead_alg gcm_aes_algs[] = {{
 	.base.cra_module	= THIS_MODULE,
 }};
 
 static int __init ghash_ce_mod_init(void)
 {
-	if (!cpu_have_named_feature(ASIMD))
+	if (!cpu_have_named_feature(ASIMD) || !cpu_have_named_feature(PMULL))
 		return -ENODEV;
 
-	if (cpu_have_named_feature(PMULL))
-		return crypto_register_aeads(gcm_aes_algs,
-					     ARRAY_SIZE(gcm_aes_algs));
-
-	return crypto_register_shash(&ghash_alg);
+	return crypto_register_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
 static void __exit ghash_ce_mod_exit(void)
 {
-	if (cpu_have_named_feature(PMULL))
-		crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
-	else
-		crypto_unregister_shash(&ghash_alg);
+	crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
 static const struct cpu_feature __maybe_unused ghash_cpu_feature[] = {
 	{ cpu_feature(PMULL) }, { }
 };
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 8a06dd6a43ea..4ce0bac8fd93 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -157,11 +157,12 @@ libdes-y					:= des.o
 obj-$(CONFIG_CRYPTO_LIB_GF128HASH) += libgf128hash.o
 libgf128hash-y := gf128hash.o
 ifeq ($(CONFIG_CRYPTO_LIB_GF128HASH_ARCH),y)
 CFLAGS_gf128hash.o += -I$(src)/$(SRCARCH)
 libgf128hash-$(CONFIG_ARM) += arm/ghash-neon-core.o
-libgf128hash-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
+libgf128hash-$(CONFIG_ARM64) += arm64/ghash-neon-core.o \
+				arm64/polyval-ce-core.o
 libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
 endif
 
 ################################################################################
 
diff --git a/lib/crypto/arm64/gf128hash.h b/lib/crypto/arm64/gf128hash.h
index 796c36804dda..d5ef1b1b77e1 100644
--- a/lib/crypto/arm64/gf128hash.h
+++ b/lib/crypto/arm64/gf128hash.h
@@ -1,23 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * POLYVAL library functions, arm64 optimized
+ * GHASH and POLYVAL, arm64 optimized
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/simd.h>
 #include <linux/cpufeature.h>
 
 #define NUM_H_POWERS 8
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_asimd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pmull);
 
 asmlinkage void polyval_mul_pmull(struct polyval_elem *a,
 				  const struct polyval_elem *b);
 asmlinkage void polyval_blocks_pmull(struct polyval_elem *acc,
 				     const struct polyval_key *key,
 				     const u8 *data, size_t nblocks);
+asmlinkage void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
+				      const u8 *src,
+				      const struct polyval_elem *k);
 
 #define polyval_preparekey_arch polyval_preparekey_arch
 static void polyval_preparekey_arch(struct polyval_key *key,
 				    const u8 raw_key[POLYVAL_BLOCK_SIZE])
 {
@@ -39,19 +43,66 @@ static void polyval_preparekey_arch(struct polyval_key *key,
 					    &key->h_powers[NUM_H_POWERS - 1]);
 		}
 	}
 }
 
+static void polyval_mul_arm64(struct polyval_elem *a,
+			      const struct polyval_elem *b)
+{
+	if (static_branch_likely(&have_asimd) && may_use_simd()) {
+		static const u8 zeroes[GHASH_BLOCK_SIZE];
+
+		scoped_ksimd() {
+			if (static_branch_likely(&have_pmull)) {
+				polyval_mul_pmull(a, b);
+			} else {
+				/*
+				 * Note that this is indeed equivalent to a
+				 * POLYVAL multiplication, since it takes the
+				 * accumulator and key in POLYVAL format, and
+				 * byte-swapping a block of zeroes is a no-op.
+				 */
+				pmull_ghash_update_p8(1, a, zeroes, b);
+			}
+		}
+	} else {
+		polyval_mul_generic(a, b);
+	}
+}
+
+#define ghash_mul_arch ghash_mul_arch
+static void ghash_mul_arch(struct polyval_elem *acc,
+			   const struct ghash_key *key)
+{
+	polyval_mul_arm64(acc, &key->h);
+}
+
 #define polyval_mul_arch polyval_mul_arch
 static void polyval_mul_arch(struct polyval_elem *acc,
 			     const struct polyval_key *key)
 {
-	if (static_branch_likely(&have_pmull) && may_use_simd()) {
-		scoped_ksimd()
-			polyval_mul_pmull(acc, &key->h_powers[NUM_H_POWERS - 1]);
+	polyval_mul_arm64(acc, &key->h_powers[NUM_H_POWERS - 1]);
+}
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_asimd) && may_use_simd()) {
+		do {
+			/* Allow rescheduling every 4 KiB. */
+			size_t n =
+				min_t(size_t, nblocks, 4096 / GHASH_BLOCK_SIZE);
+
+			scoped_ksimd()
+				pmull_ghash_update_p8(n, acc, data, &key->h);
+			data += n * GHASH_BLOCK_SIZE;
+			nblocks -= n;
+		} while (nblocks);
 	} else {
-		polyval_mul_generic(acc, &key->h_powers[NUM_H_POWERS - 1]);
+		ghash_blocks_generic(acc, &key->h, data, nblocks);
 	}
 }
 
 #define polyval_blocks_arch polyval_blocks_arch
 static void polyval_blocks_arch(struct polyval_elem *acc,
@@ -76,8 +127,11 @@ static void polyval_blocks_arch(struct polyval_elem *acc,
 }
 
 #define gf128hash_mod_init_arch gf128hash_mod_init_arch
 static void gf128hash_mod_init_arch(void)
 {
-	if (cpu_have_named_feature(PMULL))
-		static_branch_enable(&have_pmull);
+	if (cpu_have_named_feature(ASIMD)) {
+		static_branch_enable(&have_asimd);
+		if (cpu_have_named_feature(PMULL))
+			static_branch_enable(&have_pmull);
+	}
 }
diff --git a/arch/arm64/crypto/ghash-neon-core.S b/lib/crypto/arm64/ghash-neon-core.S
similarity index 93%
rename from arch/arm64/crypto/ghash-neon-core.S
rename to lib/crypto/arm64/ghash-neon-core.S
index 6157135ad566..eadd6da47247 100644
--- a/arch/arm64/crypto/ghash-neon-core.S
+++ b/lib/crypto/arm64/ghash-neon-core.S
@@ -4,11 +4,10 @@
  *
  * Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 	SHASH		.req	v0
 	SHASH2		.req	v1
 	T1		.req	v2
@@ -177,29 +176,24 @@
 	ushr		T2.2d, T2.2d, #6
 	ushr		XL.2d, XL.2d, #1
 	.endm
 
 	/*
-	 * void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-	 *			      u64 const h[][2], const char *head)
+	 * void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
+	 *			      const u8 *src,
+	 *			      const struct polyval_elem *k)
 	 */
-SYM_TYPED_FUNC_START(pmull_ghash_update_p8)
+SYM_FUNC_START(pmull_ghash_update_p8)
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
 
 	__pmull_pre_p8
 
-	/* do the head block first, if supplied */
-	cbz		x4, 0f
-	ld1		{T1.2d}, [x4]
-	mov		x4, xzr
-	b		3f
-
 0:	ld1		{T1.2d}, [x2], #16
-	sub		w0, w0, #1
+	sub		x0, x0, #1
 
-3:	/* multiply XL by SHASH in GF(2^128) */
+	/* multiply XL by SHASH in GF(2^128) */
 CPU_LE(	rev64		T1.16b, T1.16b	)
 
 	ext		T2.16b, XL.16b, XL.16b, #8
 	ext		IN1.16b, T1.16b, T1.16b, #8
 	eor		T1.16b, T1.16b, T2.16b
@@ -217,10 +211,10 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 	__pmull_reduce_p8
 
 	eor		T2.16b, T2.16b, XH.16b
 	eor		XL.16b, XL.16b, T2.16b
 
-	cbnz		w0, 0b
+	cbnz		x0, 0b
 
 	st1		{XL.2d}, [x1]
 	ret
 SYM_FUNC_END(pmull_ghash_update_p8)
-- 
2.53.0

