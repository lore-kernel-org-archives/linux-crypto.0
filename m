Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1F635AC22;
	Thu, 19 Mar 2026 06:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901160; cv=none; b=NGo1flKntbYo3DQPT2DNf0PM1H6QUCY9+z+sgC9FEVgIspRvYwc1rFSYM6JOM7wHz+qLv3Lk5tfelFdcEUKXedvAKJZWZPSofKEZH/GTPlMzaU1WsqNMQRQVbFATcSYzQthuGAtRfszuHXvJimXKQePg3QBevzogPPLZItrCxo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901160; c=relaxed/simple;
	bh=+ZmjSDH5DIbHkhs8sGfuQZibCGDn1Tzw/dqhYSngFD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3vr7r5Udqw6UFMJerradT65zKdWsQ1sK52AEV1z/ekqsfb5gdE1OC8sICJvrgij1Eladznp93Xt2j5FkjNYD/xz06ZetIqawpVvLs+DASapJ6mpxsuYmhNLJFDKfU0Hhx7YjOqTg0l2kyAv0UGNj7UXygusWfrhAwqYx0/p4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnean7F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnean7F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9139C2BCB1;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901160;
	bh=+ZmjSDH5DIbHkhs8sGfuQZibCGDn1Tzw/dqhYSngFD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnean7F5sIW0j/PDDxjaqGyGILEQL5LWC1ZOa2gtGq3EkrwAV03/l3rgTmOOHTpHf
	 zuWiucXxFt0bIE/omsLvX3AYzKLw35DJ0KiTAXUiu9rnnVV3Go7xE7twTP3m4a9u4k
	 kuPIiu4CjMhPqmQlqBhSgq836J+HHGm9m7WGDcJHOWIDXrjaGPWWdc9IThZSx53uz8
	 H4ZXX1uojF+l9CmYgAMCgkuREmq7GPg5yOYWBKCe7vY+YlOQDe0U1ZT7l6KuRL/+a1
	 Cto/yQ8kWtV3VUj+9ES3MrtArOdzHHnqThiXY2S9ptS6HVrdHf4U3bv7k3V7NpVhmB
	 i8tqNk8NcHEbw==
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
Subject: [PATCH 12/19] lib/crypto: riscv/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:13 -0700
Message-ID: <20260319061723.1140720-13-ebiggers@kernel.org>
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

Remove the "ghash-riscv64-zvkg" crypto_shash algorithm.  Move the
corresponding assembly code into lib/crypto/, modify it to take the
length in blocks instead of bytes, and wire it up to the GHASH library.

This makes the GHASH library be optimized with the RISC-V Vector
Cryptography Extension.  It also greatly reduces the amount of
riscv-specific glue code that is needed, and it fixes the issue where
this optimized GHASH code was disabled by default.

Note that this RISC-V code has multiple opportunities for improvement,
such as adding more parallelism, providing an optimized multiplication
function, and directly supporting POLYVAL.  But for now, this commit
simply tweaks ghash_zvkg() slightly to make it compatible with the
library, then wires it up to ghash_blocks_arch().

ghash_preparekey_arch() is also implemented to store the copy of the raw
key needed by the vghsh.vv instruction.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig                     |  11 --
 arch/riscv/crypto/Makefile                    |   3 -
 arch/riscv/crypto/ghash-riscv64-glue.c        | 146 ------------------
 include/crypto/gf128hash.h                    |   3 +
 lib/crypto/Kconfig                            |   2 +
 lib/crypto/Makefile                           |   1 +
 lib/crypto/riscv/gf128hash.h                  |  57 +++++++
 .../crypto/riscv}/ghash-riscv64-zvkg.S        |  13 +-
 8 files changed, 69 insertions(+), 167 deletions(-)
 delete mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 create mode 100644 lib/crypto/riscv/gf128hash.h
 rename {arch/riscv/crypto => lib/crypto/riscv}/ghash-riscv64-zvkg.S (91%)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 22d4eaab15f3..c208f54afbcd 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -15,21 +15,10 @@ config CRYPTO_AES_RISCV64
 	  - Zvkned vector crypto extension
 	  - Zvbb vector extension (XTS)
 	  - Zvkb vector crypto extension (CTR)
 	  - Zvkg vector crypto extension (XTS)
 
-config CRYPTO_GHASH_RISCV64
-	tristate "Hash functions: GHASH"
-	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
-		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
-	select CRYPTO_GCM
-	help
-	  GCM GHASH function (NIST SP 800-38D)
-
-	  Architecture: riscv64 using:
-	  - Zvkg vector crypto extension
-
 config CRYPTO_SM3_RISCV64
 	tristate "Hash functions: SM3 (ShangMi 3)"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_HASH
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 183495a95cc0..5c9ee1b876fa 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -2,13 +2,10 @@
 
 obj-$(CONFIG_CRYPTO_AES_RISCV64) += aes-riscv64.o
 aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o \
 		 aes-riscv64-zvkned-zvbb-zvkg.o aes-riscv64-zvkned-zvkb.o
 
-obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
-ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
-
 obj-$(CONFIG_CRYPTO_SM3_RISCV64) += sm3-riscv64.o
 sm3-riscv64-y := sm3-riscv64-glue.o sm3-riscv64-zvksh-zvkb.o
 
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
diff --git a/arch/riscv/crypto/ghash-riscv64-glue.c b/arch/riscv/crypto/ghash-riscv64-glue.c
deleted file mode 100644
index d86073d25387..000000000000
--- a/arch/riscv/crypto/ghash-riscv64-glue.c
+++ /dev/null
@@ -1,146 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * GHASH using the RISC-V vector crypto extensions
- *
- * Copyright (C) 2023 VRULL GmbH
- * Author: Heiko Stuebner <heiko.stuebner@vrull.eu>
- *
- * Copyright (C) 2023 SiFive, Inc.
- * Author: Jerry Shih <jerry.shih@sifive.com>
- */
-
-#include <asm/simd.h>
-#include <asm/vector.h>
-#include <crypto/b128ops.h>
-#include <crypto/gf128mul.h>
-#include <crypto/ghash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <crypto/utils.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-asmlinkage void ghash_zvkg(be128 *accumulator, const be128 *key, const u8 *data,
-			   size_t len);
-
-struct riscv64_ghash_tfm_ctx {
-	be128 key;
-};
-
-struct riscv64_ghash_desc_ctx {
-	be128 accumulator;
-};
-
-static int riscv64_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
-				unsigned int keylen)
-{
-	struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(tfm);
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	memcpy(&tctx->key, key, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static int riscv64_ghash_init(struct shash_desc *desc)
-{
-	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	*dctx = (struct riscv64_ghash_desc_ctx){};
-
-	return 0;
-}
-
-static inline void
-riscv64_ghash_blocks(const struct riscv64_ghash_tfm_ctx *tctx,
-		     struct riscv64_ghash_desc_ctx *dctx,
-		     const u8 *src, size_t srclen)
-{
-	/* The srclen is nonzero and a multiple of 16. */
-	if (crypto_simd_usable()) {
-		kernel_vector_begin();
-		ghash_zvkg(&dctx->accumulator, &tctx->key, src, srclen);
-		kernel_vector_end();
-	} else {
-		do {
-			crypto_xor((u8 *)&dctx->accumulator, src,
-				   GHASH_BLOCK_SIZE);
-			gf128mul_lle(&dctx->accumulator, &tctx->key);
-			src += GHASH_BLOCK_SIZE;
-			srclen -= GHASH_BLOCK_SIZE;
-		} while (srclen);
-	}
-}
-
-static int riscv64_ghash_update(struct shash_desc *desc, const u8 *src,
-				unsigned int srclen)
-{
-	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	riscv64_ghash_blocks(tctx, dctx, src,
-			     round_down(srclen, GHASH_BLOCK_SIZE));
-	return srclen - round_down(srclen, GHASH_BLOCK_SIZE);
-}
-
-static int riscv64_ghash_finup(struct shash_desc *desc, const u8 *src,
-			       unsigned int len, u8 *out)
-{
-	const struct riscv64_ghash_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
-	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	if (len) {
-		u8 buf[GHASH_BLOCK_SIZE] = {};
-
-		memcpy(buf, src, len);
-		riscv64_ghash_blocks(tctx, dctx, buf, GHASH_BLOCK_SIZE);
-		memzero_explicit(buf, sizeof(buf));
-	}
-
-	memcpy(out, &dctx->accumulator, GHASH_DIGEST_SIZE);
-	return 0;
-}
-
-static struct shash_alg riscv64_ghash_alg = {
-	.init = riscv64_ghash_init,
-	.update = riscv64_ghash_update,
-	.finup = riscv64_ghash_finup,
-	.setkey = riscv64_ghash_setkey,
-	.descsize = sizeof(struct riscv64_ghash_desc_ctx),
-	.digestsize = GHASH_DIGEST_SIZE,
-	.base = {
-		.cra_blocksize = GHASH_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct riscv64_ghash_tfm_ctx),
-		.cra_priority = 300,
-		.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_name = "ghash",
-		.cra_driver_name = "ghash-riscv64-zvkg",
-		.cra_module = THIS_MODULE,
-	},
-};
-
-static int __init riscv64_ghash_mod_init(void)
-{
-	if (riscv_isa_extension_available(NULL, ZVKG) &&
-	    riscv_vector_vlen() >= 128)
-		return crypto_register_shash(&riscv64_ghash_alg);
-
-	return -ENODEV;
-}
-
-static void __exit riscv64_ghash_mod_exit(void)
-{
-	crypto_unregister_shash(&riscv64_ghash_alg);
-}
-
-module_init(riscv64_ghash_mod_init);
-module_exit(riscv64_ghash_mod_exit);
-
-MODULE_DESCRIPTION("GHASH (RISC-V accelerated)");
-MODULE_AUTHOR("Heiko Stuebner <heiko.stuebner@vrull.eu>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("ghash");
diff --git a/include/crypto/gf128hash.h b/include/crypto/gf128hash.h
index 650652dd6003..b798438cce23 100644
--- a/include/crypto/gf128hash.h
+++ b/include/crypto/gf128hash.h
@@ -42,10 +42,13 @@ struct polyval_elem {
  */
 struct ghash_key {
 #if defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_PPC64)
 	/** @htable: GHASH key format used by the POWER8 assembly code */
 	u64 htable[4][2];
+#elif defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_RISCV)
+	/** @h_raw: The hash key H, in GHASH format */
+	u8 h_raw[GHASH_BLOCK_SIZE];
 #endif
 	/** @h: The hash key H, in POLYVAL format */
 	struct polyval_elem h;
 };
 
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index f54add7d9070..027802e0de33 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -120,10 +120,12 @@ config CRYPTO_LIB_GF128HASH_ARCH
 	bool
 	depends on CRYPTO_LIB_GF128HASH && !UML
 	default y if ARM && KERNEL_MODE_NEON
 	default y if ARM64
 	default y if PPC64 && VSX
+	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if X86_64
 
 config CRYPTO_LIB_MD5
 	tristate
 	help
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 8a9084188778..8950509833af 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -171,10 +171,11 @@ $(obj)/powerpc/ghashp8-ppc.S: $(src)/powerpc/ghashp8-ppc.pl FORCE
 	$(call if_changed,perlasm_ghash)
 targets += powerpc/ghashp8-ppc.S
 OBJECT_FILES_NON_STANDARD_powerpc/ghashp8-ppc.o := y
 endif
 
+libgf128hash-$(CONFIG_RISCV) += riscv/ghash-riscv64-zvkg.o
 libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
 endif # CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 
 # clean-files must be defined unconditionally
 clean-files += powerpc/ghashp8-ppc.S
diff --git a/lib/crypto/riscv/gf128hash.h b/lib/crypto/riscv/gf128hash.h
new file mode 100644
index 000000000000..4301a0384f60
--- /dev/null
+++ b/lib/crypto/riscv/gf128hash.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * GHASH, RISC-V optimized
+ *
+ * Copyright (C) 2023 VRULL GmbH
+ * Copyright (C) 2023 SiFive, Inc.
+ * Copyright 2026 Google LLC
+ */
+
+#include <asm/simd.h>
+#include <asm/vector.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkg);
+
+asmlinkage void ghash_zvkg(u8 accumulator[GHASH_BLOCK_SIZE],
+			   const u8 key[GHASH_BLOCK_SIZE],
+			   const u8 *data, size_t nblocks);
+
+#define ghash_preparekey_arch ghash_preparekey_arch
+static void ghash_preparekey_arch(struct ghash_key *key,
+				  const u8 raw_key[GHASH_BLOCK_SIZE])
+{
+	/* Save key in POLYVAL format for fallback */
+	ghash_key_to_polyval(raw_key, &key->h);
+
+	/* Save key in GHASH format for zvkg */
+	memcpy(key->h_raw, raw_key, GHASH_BLOCK_SIZE);
+}
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_zvkg) && likely(may_use_simd())) {
+		u8 ghash_acc[GHASH_BLOCK_SIZE];
+
+		polyval_acc_to_ghash(acc, ghash_acc);
+
+		kernel_vector_begin();
+		ghash_zvkg(ghash_acc, key->h_raw, data, nblocks);
+		kernel_vector_end();
+
+		ghash_acc_to_polyval(ghash_acc, acc);
+		memzero_explicit(ghash_acc, sizeof(ghash_acc));
+	} else {
+		ghash_blocks_generic(acc, &key->h, data, nblocks);
+	}
+}
+
+#define gf128hash_mod_init_arch gf128hash_mod_init_arch
+static void gf128hash_mod_init_arch(void)
+{
+	if (riscv_isa_extension_available(NULL, ZVKG) &&
+	    riscv_vector_vlen() >= 128)
+		static_branch_enable(&have_zvkg);
+}
diff --git a/arch/riscv/crypto/ghash-riscv64-zvkg.S b/lib/crypto/riscv/ghash-riscv64-zvkg.S
similarity index 91%
rename from arch/riscv/crypto/ghash-riscv64-zvkg.S
rename to lib/crypto/riscv/ghash-riscv64-zvkg.S
index f2b43fb4d434..2839ff1a990c 100644
--- a/arch/riscv/crypto/ghash-riscv64-zvkg.S
+++ b/lib/crypto/riscv/ghash-riscv64-zvkg.S
@@ -48,25 +48,24 @@
 .option arch, +zvkg
 
 #define ACCUMULATOR	a0
 #define KEY		a1
 #define DATA		a2
-#define LEN		a3
+#define NBLOCKS		a3
 
-// void ghash_zvkg(be128 *accumulator, const be128 *key, const u8 *data,
-//		   size_t len);
-//
-// |len| must be nonzero and a multiple of 16 (GHASH_BLOCK_SIZE).
+// void ghash_zvkg(u8 accumulator[GHASH_BLOCK_SIZE],
+//		   const u8 key[GHASH_BLOCK_SIZE],
+//		   const u8 *data, size_t nblocks);
 SYM_FUNC_START(ghash_zvkg)
 	vsetivli	zero, 4, e32, m1, ta, ma
 	vle32.v		v1, (ACCUMULATOR)
 	vle32.v		v2, (KEY)
 .Lnext_block:
 	vle32.v		v3, (DATA)
 	vghsh.vv	v1, v2, v3
 	addi		DATA, DATA, 16
-	addi		LEN, LEN, -16
-	bnez		LEN, .Lnext_block
+	addi		NBLOCKS, NBLOCKS, -1
+	bnez		NBLOCKS, .Lnext_block
 
 	vse32.v		v1, (ACCUMULATOR)
 	ret
 SYM_FUNC_END(ghash_zvkg)
-- 
2.53.0

