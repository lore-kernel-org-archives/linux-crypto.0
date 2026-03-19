Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D74634F487;
	Thu, 19 Mar 2026 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901158; cv=none; b=L41DYXdnjnG5A3EA8dCTf0G3Gx0tInu6Uh3X2RXfvlv/8HMjmfFEw92Dfspt3WAcSyPU0CitiY15on6fILom8Tb/1vBQf7JITo+67031KXNqIc89T7J8EdNKUFE5CaFQChZIAQl+IvfjR+ypD4s1KtnRG7gm+gDedFA0YRIkmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901158; c=relaxed/simple;
	bh=SUlBh6ude964ptwoct2eRUqHN2yhqaxUURXeunMfh1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3pa7vLwNkbsMKy8RZNn8A8H5SeWcAOeLx3x6TLUxtyuydkruSU+15ObincppYDfXB7M3ZwzdSkr8SGpXbSjPjLzo8vv304v3JQr6GYV9+jTl8TkydX16cNlmUeBoJy+mBrhTAervux/FDaAgDqmfl00LaVDLyau/zGHBTITTIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9oN+4HY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9oN+4HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9917BC2BCAF;
	Thu, 19 Mar 2026 06:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901157;
	bh=SUlBh6ude964ptwoct2eRUqHN2yhqaxUURXeunMfh1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9oN+4HYz50QQhyhsYQS0uoK8sVJjrgvy/HMW9/IDw+Bksg5NpyRYOFIftimZWHqV
	 vxwhE6XtM6scxfGLKGA9D2lrnYfiQygnqngC2RzY6Xj4fkebDCXyHXWDqIyT7kmiM6
	 JjkehxjMri8fQq2rI1BC9+5GopxUSlVkC+EvJL9qXN5uInDMgpIMRCQPLeBjyAqpXy
	 q6XXI78pR9PfCWrCIs8kPi6Vf81yTVijCWZ+AR2jpcCUNf1lVfsR0BpbRf7ncVccYQ
	 C/biGma0wwnRC21kXe9SOZ14mh9r+L7TqUF3W+0wDW3SbhgrR7+vAA45u1hBl3+DJy
	 bwj2qMifmZ/Wg==
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
Subject: [PATCH 07/19] lib/crypto: arm/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:08 -0700
Message-ID: <20260319061723.1140720-8-ebiggers@kernel.org>
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

This makes the GHASH library be optimized on arm (though only with NEON,
not PMULL; for now the goal is just parity with crypto_shash).  It
greatly reduces the amount of arm-specific glue code that is needed, and
it fixes the issue where this optimization was disabled by default.

To integrate the assembly code correctly with the library, make the
following tweaks:

- Change the type of 'blocks' from int to size_t.
- Change the types of 'dg' and 'k' to polyval_elem.  Note that this
  simply reflects the format that the code was already using, at least
  on little endian CPUs.  For big endian CPUs, add byte-swaps.
- Remove the 'head' argument, which is no longer needed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/Kconfig                       |  13 +-
 arch/arm/crypto/Makefile                      |   2 +-
 arch/arm/crypto/ghash-ce-glue.c               | 144 +-----------------
 lib/crypto/Kconfig                            |   1 +
 lib/crypto/Makefile                           |   1 +
 lib/crypto/arm/gf128hash.h                    |  43 ++++++
 .../crypto/arm}/ghash-neon-core.S             |  24 +--
 7 files changed, 66 insertions(+), 162 deletions(-)
 create mode 100644 lib/crypto/arm/gf128hash.h
 rename {arch/arm/crypto => lib/crypto/arm}/ghash-neon-core.S (92%)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b9c28c818b7c..f884b8b2fd93 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -1,30 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0
 
 menu "Accelerated Cryptographic Algorithms for CPU (arm)"
 
 config CRYPTO_GHASH_ARM_CE
-	tristate "Hash functions: GHASH (PMULL/NEON/ARMv8 Crypto Extensions)"
+	tristate "AEAD cipher: AES in GCM mode (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_AEAD
-	select CRYPTO_HASH
-	select CRYPTO_CRYPTD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	help
-	  GCM GHASH function (NIST SP800-38D)
+	  AEAD cipher: AES-GCM
 
 	  Architecture: arm using
-	  - PMULL (Polynomial Multiply Long) instructions
-	  - NEON (Advanced SIMD) extensions
 	  - ARMv8 Crypto Extensions
 
-	  Use an implementation of GHASH (used by the GCM AEAD chaining mode)
-	  that uses the 64x64 to 128 bit polynomial multiplication (vmull.p64)
-	  that is part of the ARMv8 Crypto Extensions, or a slower variant that
-	  uses the vmull.p8 instruction that is part of the basic NEON ISA.
-
 config CRYPTO_AES_ARM_BS
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (bit-sliced NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index cedce94d5ee5..e73099e120b3 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -8,6 +8,6 @@ obj-$(CONFIG_CRYPTO_AES_ARM_BS) += aes-arm-bs.o
 obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
 
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
 aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
-ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o ghash-neon-core.o
+ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index d7d787de7dd3..9aa0ada5b627 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Accelerated GHASH implementation with ARMv8 vmull.p64 instructions.
+ * AES-GCM using ARMv8 Crypto Extensions
  *
  * Copyright (C) 2015 - 2018 Linaro Ltd.
  * Copyright (C) 2023 Google LLC.
  */
 
@@ -12,116 +12,38 @@
 #include <crypto/b128ops.h>
 #include <crypto/gcm.h>
 #include <crypto/gf128mul.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/errno.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
-MODULE_DESCRIPTION("GHASH hash function using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("AES-GCM using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("ghash");
 MODULE_ALIAS_CRYPTO("gcm(aes)");
 MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 
 #define RFC4106_NONCE_SIZE	4
 
-struct ghash_key {
-	be128	k;
-	u64	h[1][2];
-};
-
 struct gcm_key {
 	u64	h[4][2];
 	u32	rk[AES_MAX_KEYLENGTH_U32];
 	int	rounds;
 	u8	nonce[];	// for RFC4106 nonce
 };
 
-struct arm_ghash_desc_ctx {
-	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
-};
-
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
 				       u64 const h[4][2], const char *head);
 
-asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-				      u64 const h[1][2], const char *head);
-
-static int ghash_init(struct shash_desc *desc)
-{
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*ctx = (struct arm_ghash_desc_ctx){};
-	return 0;
-}
-
-static void ghash_do_update(int blocks, u64 dg[], const char *src,
-			    struct ghash_key *key, const char *head)
-{
-	kernel_neon_begin();
-	pmull_ghash_update_p8(blocks, dg, src, key->h, head);
-	kernel_neon_end();
-}
-
-static int ghash_update(struct shash_desc *desc, const u8 *src,
-			unsigned int len)
-{
-	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	int blocks;
-
-	blocks = len / GHASH_BLOCK_SIZE;
-	ghash_do_update(blocks, ctx->digest, src, key, NULL);
-	return len - blocks * GHASH_BLOCK_SIZE;
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
-	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	if (len) {
-		u8 buf[GHASH_BLOCK_SIZE] = {};
-
-		memcpy(buf, src, len);
-		ghash_do_update(1, ctx->digest, buf, key, NULL);
-		memzero_explicit(buf, sizeof(buf));
-	}
-	return ghash_export(desc, dst);
-}
-
 static void ghash_reflect(u64 h[], const be128 *k)
 {
 	u64 carry = be64_to_cpu(k->a) >> 63;
 
 	h[0] = (be64_to_cpu(k->b) << 1) | carry;
@@ -129,44 +51,10 @@ static void ghash_reflect(u64 h[], const be128 *k)
 
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
-	ghash_reflect(key->h[0], &key->k);
-	return 0;
-}
-
-static struct shash_alg ghash_alg = {
-	.digestsize		= GHASH_DIGEST_SIZE,
-	.init			= ghash_init,
-	.update			= ghash_update,
-	.finup			= ghash_finup,
-	.setkey			= ghash_setkey,
-	.export			= ghash_export,
-	.import			= ghash_import,
-	.descsize		= sizeof(struct arm_ghash_desc_ctx),
-	.statesize		= sizeof(struct ghash_desc_ctx),
-
-	.base.cra_name		= "ghash",
-	.base.cra_driver_name	= "ghash-neon",
-	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key),
-	.base.cra_module	= THIS_MODULE,
-};
-
 void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
 		       struct gcm_key const *k, char *dst,
 		       const char *iv, int rounds, u32 counter);
 
 void pmull_gcm_enc_final(int blocks, u64 dg[], char *tag,
@@ -541,40 +429,18 @@ static struct aead_alg gcm_aes_algs[] = {{
 	.base.cra_module	= THIS_MODULE,
 }};
 
 static int __init ghash_ce_mod_init(void)
 {
-	int err;
-
-	if (!(elf_hwcap & HWCAP_NEON))
+	if (!(elf_hwcap & HWCAP_NEON) || !(elf_hwcap2 & HWCAP2_PMULL))
 		return -ENODEV;
 
-	if (elf_hwcap2 & HWCAP2_PMULL) {
-		err = crypto_register_aeads(gcm_aes_algs,
-					    ARRAY_SIZE(gcm_aes_algs));
-		if (err)
-			return err;
-	}
-
-	err = crypto_register_shash(&ghash_alg);
-	if (err)
-		goto err_aead;
-
-	return 0;
-
-err_aead:
-	if (elf_hwcap2 & HWCAP2_PMULL)
-		crypto_unregister_aeads(gcm_aes_algs,
-					ARRAY_SIZE(gcm_aes_algs));
-	return err;
+	return crypto_register_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
 static void __exit ghash_ce_mod_exit(void)
 {
-	crypto_unregister_shash(&ghash_alg);
-	if (elf_hwcap2 & HWCAP2_PMULL)
-		crypto_unregister_aeads(gcm_aes_algs,
-					ARRAY_SIZE(gcm_aes_algs));
+	crypto_unregister_aeads(gcm_aes_algs, ARRAY_SIZE(gcm_aes_algs));
 }
 
 module_init(ghash_ce_mod_init);
 module_exit(ghash_ce_mod_exit);
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 98cedd95c2a5..4f1a79883a56 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -117,10 +117,11 @@ config CRYPTO_LIB_GF128HASH
 	  uses any of the functions from <crypto/gf128hash.h>.
 
 config CRYPTO_LIB_GF128HASH_ARCH
 	bool
 	depends on CRYPTO_LIB_GF128HASH && !UML
+	default y if ARM && KERNEL_MODE_NEON
 	default y if ARM64
 	default y if X86_64
 
 config CRYPTO_LIB_MD5
 	tristate
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index fc30622123d2..8a06dd6a43ea 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -156,10 +156,11 @@ libdes-y					:= des.o
 
 obj-$(CONFIG_CRYPTO_LIB_GF128HASH) += libgf128hash.o
 libgf128hash-y := gf128hash.o
 ifeq ($(CONFIG_CRYPTO_LIB_GF128HASH_ARCH),y)
 CFLAGS_gf128hash.o += -I$(src)/$(SRCARCH)
+libgf128hash-$(CONFIG_ARM) += arm/ghash-neon-core.o
 libgf128hash-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
 libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
 endif
 
 ################################################################################
diff --git a/lib/crypto/arm/gf128hash.h b/lib/crypto/arm/gf128hash.h
new file mode 100644
index 000000000000..cb929bed29d5
--- /dev/null
+++ b/lib/crypto/arm/gf128hash.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * GHASH, arm optimized
+ *
+ * Copyright 2026 Google LLC
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
+void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
+			   const u8 *src, const struct polyval_elem *k);
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_neon) && may_use_simd()) {
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
+	} else {
+		ghash_blocks_generic(acc, &key->h, data, nblocks);
+	}
+}
+
+#define gf128hash_mod_init_arch gf128hash_mod_init_arch
+static void gf128hash_mod_init_arch(void)
+{
+	if (elf_hwcap & HWCAP_NEON)
+		static_branch_enable(&have_neon);
+}
diff --git a/arch/arm/crypto/ghash-neon-core.S b/lib/crypto/arm/ghash-neon-core.S
similarity index 92%
rename from arch/arm/crypto/ghash-neon-core.S
rename to lib/crypto/arm/ghash-neon-core.S
index bdf6fb6d063c..bf423fb06a75 100644
--- a/arch/arm/crypto/ghash-neon-core.S
+++ b/lib/crypto/arm/ghash-neon-core.S
@@ -139,26 +139,25 @@
 	veor		XL, XL, T1
 	vshr.u64	T1, T1, #6
 	vshr.u64	XL, XL, #1
 	.endm
 
+	.macro		vrev64_if_be	a
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	vrev64.8	\a, \a
+#endif
+	.endm
+
 	.macro		ghash_update
 	vld1.64		{XL}, [r1]
-
-	/* do the head block first, if supplied */
-	ldr		ip, [sp]
-	teq		ip, #0
-	beq		0f
-	vld1.64		{T1}, [ip]
-	teq		r0, #0
-	b		3f
+	vrev64_if_be	XL
 
 0:
 	vld1.8		{T1}, [r2]!
 	subs		r0, r0, #1
 
-3:	/* multiply XL by SHASH in GF(2^128) */
+	/* multiply XL by SHASH in GF(2^128) */
 	vrev64.8	T1, T1
 
 	vext.8		IN1, T1, T1, #8
 	veor		T1_L, T1_L, XL_H
 	veor		XL, XL, IN1
@@ -178,15 +177,17 @@
 
 	bne		0b
 	.endm
 
 	/*
-	 * void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-	 *			      u64 const h[1][2], const char *head)
+	 * void pmull_ghash_update_p8(size_t blocks, struct polyval_elem *dg,
+	 *			      const u8 *src,
+	 *			      const struct polyval_elem *k)
 	 */
 ENTRY(pmull_ghash_update_p8)
 	vld1.64		{SHASH}, [r3]
+	vrev64_if_be	SHASH
 	veor		SHASH2_p8, SHASH_L, SHASH_H
 
 	vext.8		s1l, SHASH_L, SHASH_L, #1
 	vext.8		s2l, SHASH_L, SHASH_L, #2
 	vext.8		s3l, SHASH_L, SHASH_L, #3
@@ -199,9 +200,10 @@ ENTRY(pmull_ghash_update_p8)
 	vmov.i64	k16, #0xffff
 	vmov.i64	k32, #0xffffffff
 	vmov.i64	k48, #0xffffffffffff
 
 	ghash_update
+	vrev64_if_be	XL
 	vst1.64		{XL}, [r1]
 
 	bx		lr
 ENDPROC(pmull_ghash_update_p8)
-- 
2.53.0

