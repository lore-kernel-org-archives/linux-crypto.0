Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4F523371B;
	Mon, 20 Oct 2025 00:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921618; cv=none; b=L0JyZ4f1E6vp8O/Hsi6FnOWOys+2BZQvFvw+Q7s3H3o/2flllp24joBFXPFB/4wTOThNOsNu4Mkay5EI5D5UX2ZUaISpvNo0ei3D/HVmHECMq9ILBiGXjbCp7kbw8LOJBL3MCbDlR9uFjrVjO1LNeFKK66voIxFXQWFPqh+KZyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921618; c=relaxed/simple;
	bh=B9VMbVog0Y1HY4eF9BgSn2ZAQ7f9RGz3bUChSX1584o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTFgtVDB0PM+go6PC/vZ59/pX/vS+aprN2og7Gcr4hlGombbbNosjZQlxIOEwUOlJD6ciAaf6OY0hmTRhuZBlc/js4W3LTROmUAZis7Fz26qUBdBCYnYFi7/7+96idVaU1WzCmKkx429vntJxgffesvv++SiuzFeKGo9ByeIDLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWUMBtOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWUMBtOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F2BC113D0;
	Mon, 20 Oct 2025 00:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921617;
	bh=B9VMbVog0Y1HY4eF9BgSn2ZAQ7f9RGz3bUChSX1584o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWUMBtOc/yw/GtX+q8dnaAPv4VvD/vcKV7vDgV2eFrncL8o4IXFGmxsKx+OzMO2Qd
	 7MwyjXZYkTw7wwWi5iIMhAqkqhJwIvncAoULe2andUCjvPie2mAlG/Fyryuy+RJe2b
	 UD/hUaUdHYPGMF9tCDDAZevtcBscawlHsPYXg6QBzI1kAn6nGBDhrTyQof6qmpDgvB
	 1B6nY642N604Zb51R0B1iUf+Z0tTMOhvERW7ukSnF+OrunZa/GkRu1y9WfIQYNWKxq
	 vJsvwpAK+1p2SiU2neXOThDNWY+PoyaFaOgBzp7ICwpo+4vadG9e5ab2hCQ25kQLbb
	 zVHTlHYDACqFg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 14/17] lib/crypto: arm64/sha3: Migrate optimized code into library
Date: Sun, 19 Oct 2025 17:50:35 -0700
Message-ID: <20251020005038.661542-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of exposing the arm64-optimized SHA-3 code via arm64-specific
crypto_shash algorithms, instead just implement the sha3_absorb_blocks()
and sha3_keccakf() library functions.  This is much simpler, it makes
the SHA-3 library functions be arm64-optimized, and it fixes the
longstanding issue where the arm64-optimized SHA-3 code was disabled by
default.  SHA-3 still remains available through crypto_shash, but
individual architectures no longer need to handle it.

Note: to see the diff from arch/arm64/crypto/sha3-ce-glue.c to
lib/crypto/arm64/sha3.h, view this commit with 'git show -M10'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/configs/defconfig                  |   2 +-
 arch/arm64/crypto/Kconfig                     |  11 --
 arch/arm64/crypto/Makefile                    |   3 -
 arch/arm64/crypto/sha3-ce-glue.c              | 150 ------------------
 lib/crypto/Kconfig                            |   5 +
 lib/crypto/Makefile                           |   5 +
 .../crypto/arm64}/sha3-ce-core.S              |   0
 lib/crypto/arm64/sha3.h                       |  64 ++++++++
 8 files changed, 75 insertions(+), 165 deletions(-)
 delete mode 100644 arch/arm64/crypto/sha3-ce-glue.c
 rename {arch/arm64/crypto => lib/crypto/arm64}/sha3-ce-core.S (100%)
 create mode 100644 lib/crypto/arm64/sha3.h

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index e3a2d37bd1042..20dd3a39faead 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1781,14 +1781,14 @@ CONFIG_SECURITY=y
 CONFIG_CRYPTO_USER=y
 CONFIG_CRYPTO_CHACHA20=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_ECHAINIV=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
+CONFIG_CRYPTO_SHA3=m
 CONFIG_CRYPTO_ANSI_CPRNG=y
 CONFIG_CRYPTO_USER_API_RNG=m
 CONFIG_CRYPTO_GHASH_ARM64_CE=y
-CONFIG_CRYPTO_SHA3_ARM64=m
 CONFIG_CRYPTO_SM3_ARM64_CE=m
 CONFIG_CRYPTO_AES_ARM64_CE_BLK=y
 CONFIG_CRYPTO_AES_ARM64_BS=m
 CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 91f3093eee6ab..376d6b50743ff 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -23,21 +23,10 @@ config CRYPTO_NHPOLY1305_NEON
 	  NHPoly1305 hash function (Adiantum)
 
 	  Architecture: arm64 using:
 	  - NEON (Advanced SIMD) extensions
 
-config CRYPTO_SHA3_ARM64
-	tristate "Hash functions: SHA-3 (ARMv8.2 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
-	select CRYPTO_HASH
-	select CRYPTO_SHA3
-	help
-	  SHA-3 secure hash algorithms (FIPS 202)
-
-	  Architecture: arm64 using:
-	  - ARMv8.2 Crypto Extensions
-
 config CRYPTO_SM3_NEON
 	tristate "Hash functions: SM3 (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SM3
diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index a8b2cdbe202c1..fd3d590fa1137 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -3,13 +3,10 @@
 # linux/arch/arm64/crypto/Makefile
 #
 # Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
 #
 
-obj-$(CONFIG_CRYPTO_SHA3_ARM64) += sha3-ce.o
-sha3-ce-y := sha3-ce-glue.o sha3-ce-core.o
-
 obj-$(CONFIG_CRYPTO_SM3_NEON) += sm3-neon.o
 sm3-neon-y := sm3-neon-glue.o sm3-neon-core.o
 
 obj-$(CONFIG_CRYPTO_SM3_ARM64_CE) += sm3-ce.o
 sm3-ce-y := sm3-ce-glue.o sm3-ce-core.o
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
deleted file mode 100644
index f4eae798371ef..0000000000000
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ /dev/null
@@ -1,150 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * sha3-ce-glue.c - core SHA-3 transform using v8.2 Crypto Extensions
- *
- * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-#include <crypto/internal/hash.h>
-#include <crypto/sha3.h>
-#include <linux/cpufeature.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/unaligned.h>
-
-MODULE_DESCRIPTION("SHA3 secure hash using ARMv8 Crypto Extensions");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("sha3-224");
-MODULE_ALIAS_CRYPTO("sha3-256");
-MODULE_ALIAS_CRYPTO("sha3-384");
-MODULE_ALIAS_CRYPTO("sha3-512");
-
-asmlinkage size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
-				    size_t nblocks, size_t block_size);
-
-static int arm64_sha3_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	unsigned int bs;
-	int blocks;
-
-	bs = crypto_shash_blocksize(tfm);
-	blocks = len / bs;
-	len -= blocks * bs;
-	do {
-		int rem;
-
-		kernel_neon_begin();
-		rem = sha3_ce_transform(sctx, data, blocks, bs);
-		kernel_neon_end();
-		data += (blocks - rem) * bs;
-		blocks = rem;
-	} while (blocks);
-	return len;
-}
-
-static int arm64_sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
-			    u8 *out)
-{
-	struct sha3_state *sctx = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	__le64 *digest = (__le64 *)out;
-	u8 block[SHA3_224_BLOCK_SIZE];
-	unsigned int bs, ds;
-	int i;
-
-	ds = crypto_shash_digestsize(tfm);
-	bs = crypto_shash_blocksize(tfm);
-	memcpy(block, src, len);
-
-	block[len++] = 0x06;
-	memset(block + len, 0, bs - len);
-	block[bs - 1] |= 0x80;
-
-	kernel_neon_begin();
-	sha3_ce_transform(sctx, block, 1, bs);
-	kernel_neon_end();
-	memzero_explicit(block , sizeof(block));
-
-	for (i = 0; i < ds / 8; i++)
-		put_unaligned_le64(sctx->st[i], digest++);
-
-	if (ds & 4)
-		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
-
-	return 0;
-}
-
-static struct shash_alg algs[] = { {
-	.digestsize		= SHA3_224_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= arm64_sha3_update,
-	.finup			= arm64_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-224",
-	.base.cra_driver_name	= "sha3-224-ce",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_priority	= 200,
-}, {
-	.digestsize		= SHA3_256_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= arm64_sha3_update,
-	.finup			= arm64_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-256",
-	.base.cra_driver_name	= "sha3-256-ce",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_priority	= 200,
-}, {
-	.digestsize		= SHA3_384_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= arm64_sha3_update,
-	.finup			= arm64_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-384",
-	.base.cra_driver_name	= "sha3-384-ce",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_priority	= 200,
-}, {
-	.digestsize		= SHA3_512_DIGEST_SIZE,
-	.init			= crypto_sha3_init,
-	.update			= arm64_sha3_update,
-	.finup			= arm64_sha3_finup,
-	.descsize		= SHA3_STATE_SIZE,
-	.base.cra_name		= "sha3-512",
-	.base.cra_driver_name	= "sha3-512-ce",
-	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_priority	= 200,
-} };
-
-static int __init sha3_neon_mod_init(void)
-{
-	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
-}
-
-static void __exit sha3_neon_mod_fini(void)
-{
-	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
-}
-
-module_cpu_feature_match(SHA3, sha3_neon_mod_init);
-module_exit(sha3_neon_mod_fini);
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 1caf3fbe24bff..544eb67fe70f4 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -189,10 +189,15 @@ config CRYPTO_LIB_SHA3
 	help
 	  The SHA3 library functions.
 	  Select this if your module uses any of these functions from
 	  <crypto/sha3.h>.
 
+config CRYPTO_LIB_SHA3_ARCH
+	bool
+	depends on CRYPTO_LIB_SHA3 && !UML
+	default y if ARM64 && KERNEL_MODE_NEON
+
 config CRYPTO_LIB_SM3
 	tristate
 
 source "lib/crypto/tests/Kconfig"
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 2f15cef850507..f638bff0fb081 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -269,10 +269,15 @@ endif # CONFIG_CRYPTO_LIB_SHA512_ARCH
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_SHA3) += libsha3.o
 libsha3-y := sha3.o
 
+ifeq ($(CONFIG_CRYPTO_LIB_SHA3_ARCH),y)
+CFLAGS_sha3.o += -I$(src)/$(SRCARCH)
+libsha3-$(CONFIG_ARM64) += arm64/sha3-ce-core.o
+endif # CONFIG_CRYPTO_LIB_SHA3_ARCH
+
 ################################################################################
 
 obj-$(CONFIG_MPILIB) += mpi/
 
 obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
diff --git a/arch/arm64/crypto/sha3-ce-core.S b/lib/crypto/arm64/sha3-ce-core.S
similarity index 100%
rename from arch/arm64/crypto/sha3-ce-core.S
rename to lib/crypto/arm64/sha3-ce-core.S
diff --git a/lib/crypto/arm64/sha3.h b/lib/crypto/arm64/sha3.h
new file mode 100644
index 0000000000000..286c519eecd5a
--- /dev/null
+++ b/lib/crypto/arm64/sha3.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <linux/cpufeature.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_sha3);
+
+asmlinkage size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
+				    size_t nblocks, size_t block_size);
+
+static void sha3_absorb_blocks(struct __sha3_ctx *ctx,
+			       const u8 *data, size_t nblocks)
+{
+	size_t block_size = ctx->block_size;
+
+	if (static_branch_likely(&have_sha3) && likely(may_use_simd())) {
+		do {
+			size_t rem;
+
+			kernel_neon_begin();
+			rem = sha3_ce_transform(&ctx->state, data, nblocks,
+						block_size);
+			kernel_neon_end();
+			data += (nblocks - rem) * block_size;
+			nblocks = rem;
+		} while (nblocks);
+	} else {
+		sha3_absorb_blocks_generic(ctx, data, nblocks);
+	}
+}
+
+static void sha3_keccakf(struct sha3_state *state)
+{
+	if (static_branch_likely(&have_sha3) && likely(may_use_simd())) {
+		/*
+		 * Passing zeroes into sha3_ce_transform() gives the plain
+		 * Keccak-f permutation, which is what we want here.  Any
+		 * supported block size may be used.  Use SHA3_512_BLOCK_SIZE
+		 * since it's the shortest.
+		 */
+		static const u8 zeroes[SHA3_512_BLOCK_SIZE];
+
+		kernel_neon_begin();
+		sha3_ce_transform(state, zeroes, 1, sizeof(zeroes));
+		kernel_neon_end();
+	} else {
+		sha3_keccakf_generic(state);
+	}
+}
+
+#define sha3_mod_init_arch sha3_mod_init_arch
+static void sha3_mod_init_arch(void)
+{
+	if (cpu_have_named_feature(SHA3))
+		static_branch_enable(&have_sha3);
+}
-- 
2.51.1.dirty

