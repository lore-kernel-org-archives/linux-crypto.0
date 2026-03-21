Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06D34846D;
	Sat, 21 Mar 2026 04:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066321; cv=none; b=Fo4SLPPqkrLrjuEueBJR9RJIddIIe1EZXKtH/FrVFm9h12/ipzJlithAhnqJq2Tg248PfQvP1MosYwTuEs+z3Gk5toNE453L5FB4Fawm8wp4Y0cxl0ChQp0eO6CW/a6+/dj/U7GcSto6jGzFtHPxtGwZRkjpjtVpnyU4s9bPL+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066321; c=relaxed/simple;
	bh=OcsB7+OXdnUMRUsfOxDS7YNvzWDFzg54YZYjCij/IAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0fTRGBvxq6PEmzM9i4IeIZvfvMCbyeeRXZlcGwj6IHTzvXyPxW/5itj9CID8e8grlAeHqTxpy9Y0ToIS3xVyLjuKCsE0i4R1H3yATr+i8mc8bUM7DVomGDG4TV0Tu4K31tqbvFsmA1J48nApfhxfi+sp8S88od5Nl41IZOYmrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axRwogRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axRwogRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496A9C2BCB1;
	Sat, 21 Mar 2026 04:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066321;
	bh=OcsB7+OXdnUMRUsfOxDS7YNvzWDFzg54YZYjCij/IAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axRwogRu3SO1PqfifBK9d2drt62nE9Y0lp6zuHFGabkWYaMjVSqktfQAo1soA+3TD
	 8pbBH3ENza+wY4Be8WDNPTk1kSLGaNs2QYHcm4hx7tQ4boX0Qh5vThTkaUd75Mf4rr
	 TWdzhtZ4pI2ZYMyU50GVUXOX6xK2oYc6FiXIRxzy0CfN2YJG8iBL9H0nQ60DdEdovP
	 njXRbz/uo6C56iNHjJJFAbZgkX2HBpUKu3yiRg/Uv/Wq6SvlUy0rM077KKcf8T8Nte
	 6Pnshlg4hlwn+fhf1alu4IsC/714dfPmlYfyjCSovwjH4dc/KETJpbV/VjYq/LCrDx
	 HuuQqwmDCfDjw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/12] lib/crypto: riscv/sm3: Migrate optimized code into library
Date: Fri, 20 Mar 2026 21:09:31 -0700
Message-ID: <20260321040935.410034-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of exposing the riscv-optimized SM3 code via a riscv-specific
crypto_shash algorithm, instead just implement the sm3_blocks() library
function.  This is much simpler, it makes the SM3 library functions be
riscv-optimized, and it fixes the longstanding issue where the
riscv-optimized SM3 code was disabled by default.  SM3 still remains
available through crypto_shash, but individual architectures no longer
need to handle it.

Tweak the prototype of sm3_transform_zvksh_zvkb() to match what the
library expects, including changing the block count to size_t.
Note that the assembly code already treated it as size_t.

Note: to see the diff from arch/riscv/crypto/sm3-riscv64-glue.c to
lib/crypto/riscv/sm3.h, view this commit with 'git show -M10'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig                     | 13 ---
 arch/riscv/crypto/Makefile                    |  3 -
 lib/crypto/Kconfig                            |  2 +
 lib/crypto/Makefile                           |  1 +
 .../crypto/riscv}/sm3-riscv64-zvksh-zvkb.S    |  3 +-
 .../crypto/riscv/sm3.h                        | 84 +++----------------
 6 files changed, 18 insertions(+), 88 deletions(-)
 rename {arch/riscv/crypto => lib/crypto/riscv}/sm3-riscv64-zvksh-zvkb.S (97%)
 rename arch/riscv/crypto/sm3-riscv64-glue.c => lib/crypto/riscv/sm3.h (18%)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 22d4eaab15f3..eefba937b015 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -26,23 +26,10 @@ config CRYPTO_GHASH_RISCV64
 	  GCM GHASH function (NIST SP 800-38D)
 
 	  Architecture: riscv64 using:
 	  - Zvkg vector crypto extension
 
-config CRYPTO_SM3_RISCV64
-	tristate "Hash functions: SM3 (ShangMi 3)"
-	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
-		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
-	select CRYPTO_HASH
-	select CRYPTO_LIB_SM3
-	help
-	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
-
-	  Architecture: riscv64 using:
-	  - Zvksh vector crypto extension
-	  - Zvkb vector crypto extension
-
 config CRYPTO_SM4_RISCV64
 	tristate "Ciphers: SM4 (ShangMi 4)"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_ALGAPI
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 183495a95cc0..ca9a6c33ad53 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -5,10 +5,7 @@ aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o \
 		 aes-riscv64-zvkned-zvbb-zvkg.o aes-riscv64-zvkned-zvkb.o
 
 obj-$(CONFIG_CRYPTO_GHASH_RISCV64) += ghash-riscv64.o
 ghash-riscv64-y := ghash-riscv64-glue.o ghash-riscv64-zvkg.o
 
-obj-$(CONFIG_CRYPTO_SM3_RISCV64) += sm3-riscv64.o
-sm3-riscv64-y := sm3-riscv64-glue.o sm3-riscv64-zvksh-zvkb.o
-
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index a4e55b6a03af..b714f9cbd368 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -273,9 +273,11 @@ config CRYPTO_LIB_SM3
 
 config CRYPTO_LIB_SM3_ARCH
 	bool
 	depends on CRYPTO_LIB_SM3 && !UML
 	default y if ARM64
+	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
+		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 
 source "lib/crypto/tests/Kconfig"
 
 endmenu
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 48ed6ee5e3c9..3019e6cbb10d 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -353,10 +353,11 @@ obj-$(CONFIG_CRYPTO_LIB_SM3) += libsm3.o
 libsm3-y := sm3.o
 ifeq ($(CONFIG_CRYPTO_LIB_SM3_ARCH),y)
 CFLAGS_sm3.o += -I$(src)/$(SRCARCH)
 libsm3-$(CONFIG_ARM64) += arm64/sm3-ce-core.o \
 			  arm64/sm3-neon-core.o
+libsm3-$(CONFIG_RISCV) += riscv/sm3-riscv64-zvksh-zvkb.o
 endif # CONFIG_CRYPTO_LIB_SM3_ARCH
 
 ################################################################################
 
 obj-$(CONFIG_MPILIB) += mpi/
diff --git a/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S b/lib/crypto/riscv/sm3-riscv64-zvksh-zvkb.S
similarity index 97%
rename from arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S
rename to lib/crypto/riscv/sm3-riscv64-zvksh-zvkb.S
index 4fe754846f65..a1d4468b0485 100644
--- a/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S
+++ b/lib/crypto/riscv/sm3-riscv64-zvksh-zvkb.S
@@ -78,11 +78,12 @@
 	vsm3me.vv	\w0, \w1, \w0
 .endif
 	// For the next 8 rounds, w0 and w1 are swapped.
 .endm
 
-// void sm3_transform_zvksh_zvkb(u32 state[8], const u8 *data, int num_blocks);
+// void sm3_transform_zvksh_zvkb(struct sm3_block_state *state,
+//				 const u8 *data, size_t nblocks);
 SYM_FUNC_START(sm3_transform_zvksh_zvkb)
 
 	// Load the state and endian-swap each 32-bit word.
 	vsetivli	zero, 8, e32, m2, ta, ma
 	vle32.v		STATE, (STATEP)
diff --git a/arch/riscv/crypto/sm3-riscv64-glue.c b/lib/crypto/riscv/sm3.h
similarity index 18%
rename from arch/riscv/crypto/sm3-riscv64-glue.c
rename to lib/crypto/riscv/sm3.h
index abdfe4a63a27..c1fbee7094e6 100644
--- a/arch/riscv/crypto/sm3-riscv64-glue.c
+++ b/lib/crypto/riscv/sm3.h
@@ -1,6 +1,6 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * SM3 using the RISC-V vector crypto extensions
  *
  * Copyright (C) 2023 VRULL GmbH
  * Author: Heiko Stuebner <heiko.stuebner@vrull.eu>
@@ -9,89 +9,31 @@
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
 #include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <crypto/sm3.h>
-#include <crypto/sm3_base.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 
-/*
- * Note: the asm function only uses the 'state' field of struct sm3_state.
- * It is assumed to be the first field.
- */
-asmlinkage void sm3_transform_zvksh_zvkb(
-	struct sm3_state *state, const u8 *data, int num_blocks);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_extensions);
 
-static void sm3_block(struct sm3_state *state, const u8 *data,
-		      int num_blocks)
-{
-	/*
-	 * Ensure struct sm3_state begins directly with the SM3
-	 * 256-bit internal state, as this is what the asm function expects.
-	 */
-	BUILD_BUG_ON(offsetof(struct sm3_state, state) != 0);
+asmlinkage void sm3_transform_zvksh_zvkb(struct sm3_block_state *state,
+					 const u8 *data, size_t nblocks);
 
-	if (crypto_simd_usable()) {
+static void sm3_blocks(struct sm3_block_state *state,
+		       const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_extensions) && likely(may_use_simd())) {
 		kernel_vector_begin();
-		sm3_transform_zvksh_zvkb(state, data, num_blocks);
+		sm3_transform_zvksh_zvkb(state, data, nblocks);
 		kernel_vector_end();
 	} else {
-		sm3_block_generic(state, data, num_blocks);
+		sm3_blocks_generic(state, data, nblocks);
 	}
 }
 
-static int riscv64_sm3_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len)
-{
-	return sm3_base_do_update_blocks(desc, data, len, sm3_block);
-}
-
-static int riscv64_sm3_finup(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *out)
-{
-	sm3_base_do_finup(desc, data, len, sm3_block);
-	return sm3_base_finish(desc, out);
-}
-
-static struct shash_alg riscv64_sm3_alg = {
-	.init = sm3_base_init,
-	.update = riscv64_sm3_update,
-	.finup = riscv64_sm3_finup,
-	.descsize = SM3_STATE_SIZE,
-	.digestsize = SM3_DIGEST_SIZE,
-	.base = {
-		.cra_blocksize = SM3_BLOCK_SIZE,
-		.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
-			     CRYPTO_AHASH_ALG_FINUP_MAX,
-		.cra_priority = 300,
-		.cra_name = "sm3",
-		.cra_driver_name = "sm3-riscv64-zvksh-zvkb",
-		.cra_module = THIS_MODULE,
-	},
-};
-
-static int __init riscv64_sm3_mod_init(void)
+#define sm3_mod_init_arch sm3_mod_init_arch
+static void sm3_mod_init_arch(void)
 {
 	if (riscv_isa_extension_available(NULL, ZVKSH) &&
 	    riscv_isa_extension_available(NULL, ZVKB) &&
 	    riscv_vector_vlen() >= 128)
-		return crypto_register_shash(&riscv64_sm3_alg);
-
-	return -ENODEV;
-}
-
-static void __exit riscv64_sm3_mod_exit(void)
-{
-	crypto_unregister_shash(&riscv64_sm3_alg);
+		static_branch_enable(&have_extensions);
 }
-
-module_init(riscv64_sm3_mod_init);
-module_exit(riscv64_sm3_mod_exit);
-
-MODULE_DESCRIPTION("SM3 (RISC-V accelerated)");
-MODULE_AUTHOR("Heiko Stuebner <heiko.stuebner@vrull.eu>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("sm3");
-- 
2.53.0

