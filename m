Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E975F35BDBA;
	Thu, 19 Mar 2026 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901161; cv=none; b=cyd9UTXPCQHSuK3x5PYrZ0DO31Bpuykf547otJjEg8n7vXyfujeT9m3Qk6YG0ZW4H5bEj2dfaJmcz4UW7sF42s1BOnwStBzEFhtoubMJFwJQvZx+ERhuJ8pb/qNVmC7Q8qwqmls+QIc3E183v1UG9vZ7M1wOy7uGvvLMRXLrNPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901161; c=relaxed/simple;
	bh=7F7ndcFH8rpPiACNbtYxCLPxNZA0C89ig93X3UFOhZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsZP8A/7nIu3bRkOjDN7V+n9AgGyVZL4K5gWeaYlL7ktQkoGm91xI2tBZLbcaLy80IdeNN45Ae8YVEE+P4qlavcZlWZiOytWLFY12LyrCOUoeyYSfs9UMNNWfylVUya3tOftEkk/kdmE/T0oTfvAnyoXxlwSBPWbm/PGAb7v4NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtLToKlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtLToKlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CFAC2BCC9;
	Thu, 19 Mar 2026 06:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901160;
	bh=7F7ndcFH8rpPiACNbtYxCLPxNZA0C89ig93X3UFOhZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtLToKlgA0+Pk4GjTlYNad6rvHvHbEP/2D3kndnAGFI1vz5KKAGFs1+R+SwEgJXO8
	 HQbMb6bXMWgJVHvmjee84xWTWOzkHZ5i2XUw5vG9WYRbpoThUyDHWaQlFZ9MaABGo2
	 IiiR8rZuYEQBM3NpxG1cPccwPVLZezGnovy4A/EK05lEICEgEH54q6KrgAYlcrcVvW
	 6hTnWXcqDfGFkeJe7m8YD9h/6qVmQqqDpydEODU3dhxIIqxXb2Lbwc3XJu9APpryvN
	 PhH/eiY+dyPlSjSeQemdVtcw6QvNayZP1xVoHu9PrhGn9/YsRBOEtSYwmfpda3vkVu
	 2c4i/tSpO0www==
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
Subject: [PATCH 13/19] lib/crypto: s390/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:14 -0700
Message-ID: <20260319061723.1140720-14-ebiggers@kernel.org>
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

Remove the "ghash-s390" crypto_shash algorithm, and replace it with an
implementation of ghash_blocks_arch() for the GHASH library.

This makes the GHASH library be optimized with CPACF.  It also greatly
reduces the amount of s390-specific glue code that is needed, and it
fixes the issue where this GHASH optimization was disabled by default.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/s390/configs/debug_defconfig |   1 -
 arch/s390/configs/defconfig       |   1 -
 arch/s390/crypto/Kconfig          |  10 ---
 arch/s390/crypto/Makefile         |   1 -
 arch/s390/crypto/ghash_s390.c     | 144 ------------------------------
 include/crypto/gf128hash.h        |   3 +-
 lib/crypto/Kconfig                |   1 +
 lib/crypto/s390/gf128hash.h       |  54 +++++++++++
 8 files changed, 57 insertions(+), 158 deletions(-)
 delete mode 100644 arch/s390/crypto/ghash_s390.c
 create mode 100644 lib/crypto/s390/gf128hash.h

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 98fd0a2f51c6..aa862d4fcc68 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -807,11 +807,10 @@ CONFIG_CRYPTO_LZ4HC=m
 CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
-CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
 CONFIG_PKEY=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 0f4cedcab3ce..74f943307c46 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -792,11 +792,10 @@ CONFIG_CRYPTO_ZSTD=m
 CONFIG_CRYPTO_JITTERENTROPY_OSR=1
 CONFIG_CRYPTO_USER_API_HASH=m
 CONFIG_CRYPTO_USER_API_SKCIPHER=m
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_USER_API_AEAD=m
-CONFIG_CRYPTO_GHASH_S390=m
 CONFIG_CRYPTO_AES_S390=m
 CONFIG_CRYPTO_DES_S390=m
 CONFIG_CRYPTO_HMAC_S390=m
 CONFIG_ZCRYPT=m
 CONFIG_PKEY=m
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 79a2d0034258..ee83052dbc15 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -1,19 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
 menu "Accelerated Cryptographic Algorithms for CPU (s390)"
 
-config CRYPTO_GHASH_S390
-	tristate "Hash functions: GHASH"
-	select CRYPTO_HASH
-	help
-	  GCM GHASH hash function (NIST SP800-38D)
-
-	  Architecture: s390
-
-	  It is available as of z196.
-
 config CRYPTO_AES_S390
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, XTS, GCM"
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index 387a229e1038..4449c1b19ef5 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -5,9 +5,8 @@
 
 obj-$(CONFIG_CRYPTO_DES_S390) += des_s390.o
 obj-$(CONFIG_CRYPTO_AES_S390) += aes_s390.o
 obj-$(CONFIG_CRYPTO_PAES_S390) += paes_s390.o
 obj-$(CONFIG_S390_PRNG) += prng.o
-obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
 obj-$(CONFIG_CRYPTO_HMAC_S390) += hmac_s390.o
 obj-$(CONFIG_CRYPTO_PHMAC_S390) += phmac_s390.o
 obj-y += arch_random.o
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
deleted file mode 100644
index dcbcee37cb63..000000000000
--- a/arch/s390/crypto/ghash_s390.c
+++ /dev/null
@@ -1,144 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Cryptographic API.
- *
- * s390 implementation of the GHASH algorithm for GCM (Galois/Counter Mode).
- *
- * Copyright IBM Corp. 2011
- * Author(s): Gerald Schaefer <gerald.schaefer@de.ibm.com>
- */
-
-#include <asm/cpacf.h>
-#include <crypto/ghash.h>
-#include <crypto/internal/hash.h>
-#include <linux/cpufeature.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-struct s390_ghash_ctx {
-	u8 key[GHASH_BLOCK_SIZE];
-};
-
-struct s390_ghash_desc_ctx {
-	u8 icv[GHASH_BLOCK_SIZE];
-	u8 key[GHASH_BLOCK_SIZE];
-};
-
-static int ghash_init(struct shash_desc *desc)
-{
-	struct s390_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx, 0, sizeof(*dctx));
-	memcpy(dctx->key, ctx->key, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static int ghash_setkey(struct crypto_shash *tfm,
-			const u8 *key, unsigned int keylen)
-{
-	struct s390_ghash_ctx *ctx = crypto_shash_ctx(tfm);
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	memcpy(ctx->key, key, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static int ghash_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
-{
-	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int n;
-
-	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
-	cpacf_kimd(CPACF_KIMD_GHASH, dctx, src, n);
-	return srclen - n;
-}
-
-static void ghash_flush(struct s390_ghash_desc_ctx *dctx, const u8 *src,
-			unsigned int len)
-{
-	if (len) {
-		u8 buf[GHASH_BLOCK_SIZE] = {};
-
-		memcpy(buf, src, len);
-		cpacf_kimd(CPACF_KIMD_GHASH, dctx, buf, GHASH_BLOCK_SIZE);
-		memzero_explicit(buf, sizeof(buf));
-	}
-}
-
-static int ghash_finup(struct shash_desc *desc, const u8 *src,
-		       unsigned int len, u8 *dst)
-{
-	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	ghash_flush(dctx, src, len);
-	memcpy(dst, dctx->icv, GHASH_BLOCK_SIZE);
-	return 0;
-}
-
-static int ghash_export(struct shash_desc *desc, void *out)
-{
-	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memcpy(out, dctx->icv, GHASH_DIGEST_SIZE);
-	return 0;
-}
-
-static int ghash_import(struct shash_desc *desc, const void *in)
-{
-	struct s390_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memcpy(dctx->icv, in, GHASH_DIGEST_SIZE);
-	memcpy(dctx->key, ctx->key, GHASH_BLOCK_SIZE);
-	return 0;
-}
-
-static struct shash_alg ghash_alg = {
-	.digestsize	= GHASH_DIGEST_SIZE,
-	.init		= ghash_init,
-	.update		= ghash_update,
-	.finup		= ghash_finup,
-	.setkey		= ghash_setkey,
-	.export		= ghash_export,
-	.import		= ghash_import,
-	.statesize	= sizeof(struct ghash_desc_ctx),
-	.descsize	= sizeof(struct s390_ghash_desc_ctx),
-	.base		= {
-		.cra_name		= "ghash",
-		.cra_driver_name	= "ghash-s390",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct s390_ghash_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-static int __init ghash_mod_init(void)
-{
-	if (!cpacf_query_func(CPACF_KIMD, CPACF_KIMD_GHASH))
-		return -ENODEV;
-
-	return crypto_register_shash(&ghash_alg);
-}
-
-static void __exit ghash_mod_exit(void)
-{
-	crypto_unregister_shash(&ghash_alg);
-}
-
-module_cpu_feature_match(S390_CPU_FEATURE_MSA, ghash_mod_init);
-module_exit(ghash_mod_exit);
-
-MODULE_ALIAS_CRYPTO("ghash");
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH hash function, s390 implementation");
diff --git a/include/crypto/gf128hash.h b/include/crypto/gf128hash.h
index b798438cce23..0bc649d01e12 100644
--- a/include/crypto/gf128hash.h
+++ b/include/crypto/gf128hash.h
@@ -42,11 +42,12 @@ struct polyval_elem {
  */
 struct ghash_key {
 #if defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_PPC64)
 	/** @htable: GHASH key format used by the POWER8 assembly code */
 	u64 htable[4][2];
-#elif defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_RISCV)
+#elif defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && \
+	(defined(CONFIG_RISCV) || defined(CONFIG_S390))
 	/** @h_raw: The hash key H, in GHASH format */
 	u8 h_raw[GHASH_BLOCK_SIZE];
 #endif
 	/** @h: The hash key H, in POLYVAL format */
 	struct polyval_elem h;
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 027802e0de33..a39e7707e9ee 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -122,10 +122,11 @@ config CRYPTO_LIB_GF128HASH_ARCH
 	default y if ARM && KERNEL_MODE_NEON
 	default y if ARM64
 	default y if PPC64 && VSX
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
+	default y if S390
 	default y if X86_64
 
 config CRYPTO_LIB_MD5
 	tristate
 	help
diff --git a/lib/crypto/s390/gf128hash.h b/lib/crypto/s390/gf128hash.h
new file mode 100644
index 000000000000..1e46ce4bca40
--- /dev/null
+++ b/lib/crypto/s390/gf128hash.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * GHASH optimized using the CP Assist for Cryptographic Functions (CPACF)
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <asm/cpacf.h>
+#include <linux/cpufeature.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_cpacf_ghash);
+
+#define ghash_preparekey_arch ghash_preparekey_arch
+static void ghash_preparekey_arch(struct ghash_key *key,
+				  const u8 raw_key[GHASH_BLOCK_SIZE])
+{
+	/* Save key in POLYVAL format for fallback */
+	ghash_key_to_polyval(raw_key, &key->h);
+
+	/* Save key in GHASH format for CPACF_KIMD_GHASH */
+	memcpy(key->h_raw, raw_key, GHASH_BLOCK_SIZE);
+}
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_cpacf_ghash)) {
+		/*
+		 * CPACF_KIMD_GHASH requires the accumulator and key in a single
+		 * buffer, each using the GHASH convention.
+		 */
+		u8 ctx[2][GHASH_BLOCK_SIZE] __aligned(8);
+
+		polyval_acc_to_ghash(acc, ctx[0]);
+		memcpy(ctx[1], key->h_raw, GHASH_BLOCK_SIZE);
+
+		cpacf_kimd(CPACF_KIMD_GHASH, ctx, data,
+			   nblocks * GHASH_BLOCK_SIZE);
+
+		ghash_acc_to_polyval(ctx[0], acc);
+		memzero_explicit(ctx, sizeof(ctx));
+	} else {
+		ghash_blocks_generic(acc, &key->h, data, nblocks);
+	}
+}
+
+#define gf128hash_mod_init_arch gf128hash_mod_init_arch
+static void gf128hash_mod_init_arch(void)
+{
+	if (cpu_have_feature(S390_CPU_FEATURE_MSA) &&
+	    cpacf_query_func(CPACF_KIMD, CPACF_KIMD_GHASH))
+		static_branch_enable(&have_cpacf_ghash);
+}
-- 
2.53.0

