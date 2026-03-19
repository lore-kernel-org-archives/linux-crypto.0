Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB5F2D595B;
	Thu, 19 Mar 2026 06:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901155; cv=none; b=FUVJFRFYQ/4FrsYjv0cYuvO2FkimstLOGdxrZTYh+bbtcdzfifOU+VFrUdAUyWmxjQw+bWS7lpHRpcAHqfSlZtMgCpj6X9h6KJRkP0pPPfcSoVC3xSMPwf0ZY4kOtI5UaTtdZSpjlVFGTvPfhhs0VP1Gqpk4Og9l219/9RM/JTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901155; c=relaxed/simple;
	bh=2RnBJCTFrD0ohcPH8mcR5XHGHKUTn3w5CDa+XMF3VZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoTFXfMtt8TYcY5sN94vEIv4v3Q1ygMBlA2rtlTxvEcoaqGVyffwZNxoJxu95FT6bVDRGd3qXHmpncMaIx1z7zWG3pVDc/x4L0OFZl0y2QL1cxaPwrIYVpBccVS5Oe9/gdEJ8FKYfEFGuj3d7jg5VMBcHlAkwaUVmYONVW+GhpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qme/wxlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qme/wxlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91D1C2BCB2;
	Thu, 19 Mar 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901155;
	bh=2RnBJCTFrD0ohcPH8mcR5XHGHKUTn3w5CDa+XMF3VZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qme/wxlpFt5vEOTbM9QLsloHawmga9oHXECrQF9aFqJ+c22qswdZvB1tt8zMSpFDD
	 gj3SR5bJOOOI/CwrWD6c/OJFWl6EoLqissuqhMXuLElf33A+M8eFK3/akwhQUYCPvv
	 fHA/MWnN0WFeo0BwGMowPsFpuS1BfPQExabl5O8liLGii9wcok730wyc+yhgqX4k1Y
	 dtF3PmCJMvNkwrSj+l+Q1BAbG0f3bn6mstN4ZrdizPGgfPaae6hGPJvH9JSvRQJSV7
	 a7U0XkjSLJgXrpcZOsY81qaijqTblYWUKaPClmI5/TznDuh/7d/w2RxYSaODwp1DcK
	 XlkYCLJv7+YuA==
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
Subject: [PATCH 01/19] lib/crypto: gf128hash: Rename polyval module to gf128hash
Date: Wed, 18 Mar 2026 23:17:02 -0700
Message-ID: <20260319061723.1140720-2-ebiggers@kernel.org>
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

Currently, the standalone GHASH code is coupled with crypto_shash.  This
has resulted in unnecessary complexity and overhead, as well as the code
being unavailable to library code such as the AES-GCM library.  Like was
done with POLYVAL, it needs to find a new home in lib/crypto/.

GHASH and POLYVAL are closely related and can each be implemented in
terms of each other.  Optimized code for one can be reused with the
other.  But also since GHASH tends to be difficult to implement directly
due to its unnatural bit order, most modern GHASH implementations
(including the existing arm, arm64, powerpc, and x86 optimized GHASH
code, and the new generic GHASH code I'll be adding) actually
reinterpret the GHASH computation as an equivalent POLYVAL computation,
pre and post-processing the inputs and outputs to map to/from POLYVAL.

Given this close relationship, it makes sense to group the GHASH and
POLYVAL code together in the same module.  This gives us a wide range of
options for implementing them, reusing code between the two and properly
utilizing whatever instructions each architecture provides.

Thus, GHASH support will be added to the library module that is
currently called "polyval".  Rename it to an appropriate name:
"gf128hash".  Rename files, options, functions, etc. where appropriate
to reflect the upcoming sharing with GHASH.  (Note: polyval_kunit is not
renamed, as ghash_kunit will be added alongside it instead.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                              |  2 +-
 crypto/hctr2.c                              |  2 +-
 include/crypto/{polyval.h => gf128hash.h}   | 16 ++++++-------
 lib/crypto/Kconfig                          | 24 +++++++++----------
 lib/crypto/Makefile                         | 20 ++++++++--------
 lib/crypto/arm64/{polyval.h => gf128hash.h} |  4 ++--
 lib/crypto/{polyval.c => gf128hash.c}       | 26 ++++++++++-----------
 lib/crypto/tests/Kconfig                    |  4 ++--
 lib/crypto/tests/polyval_kunit.c            |  2 +-
 lib/crypto/x86/{polyval.h => gf128hash.h}   |  4 ++--
 10 files changed, 52 insertions(+), 52 deletions(-)
 rename include/crypto/{polyval.h => gf128hash.h} (94%)
 rename lib/crypto/arm64/{polyval.h => gf128hash.h} (95%)
 rename lib/crypto/{polyval.c => gf128hash.c} (94%)
 rename lib/crypto/x86/{polyval.h => gf128hash.h} (95%)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b8608ef6823b..5627b3691561 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -684,11 +684,11 @@ config CRYPTO_ECB
 	  ECB (Electronic Codebook) mode (NIST SP800-38A)
 
 config CRYPTO_HCTR2
 	tristate "HCTR2"
 	select CRYPTO_XCTR
-	select CRYPTO_LIB_POLYVAL
+	select CRYPTO_LIB_GF128HASH
 	select CRYPTO_MANAGER
 	help
 	  HCTR2 length-preserving encryption mode
 
 	  A mode for storage encryption that is efficient on processors with
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index f4cd6c29b4d3..ad5edf9366ac 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -14,13 +14,13 @@
  *
  * For more details, see the paper: "Length-preserving encryption with HCTR2"
  * (https://eprint.iacr.org/2021/1441.pdf)
  */
 
+#include <crypto/gf128hash.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/polyval.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
 #define BLOCKCIPHER_BLOCK_SIZE		16
 
diff --git a/include/crypto/polyval.h b/include/crypto/gf128hash.h
similarity index 94%
rename from include/crypto/polyval.h
rename to include/crypto/gf128hash.h
index b28b8ef11353..5ffa86f5c13f 100644
--- a/include/crypto/polyval.h
+++ b/include/crypto/gf128hash.h
@@ -1,14 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * POLYVAL library API
+ * GF(2^128) polynomial hashing: GHASH and POLYVAL
  *
  * Copyright 2025 Google LLC
  */
 
-#ifndef _CRYPTO_POLYVAL_H
-#define _CRYPTO_POLYVAL_H
+#ifndef _CRYPTO_GF128HASH_H
+#define _CRYPTO_GF128HASH_H
 
 #include <linux/string.h>
 #include <linux/types.h>
 
 #define POLYVAL_BLOCK_SIZE	16
@@ -42,24 +42,24 @@ struct polyval_elem {
  *
  * By H^i we mean H^(i-1) * H * x^-128, with base case H^1 = H.  I.e. the
  * exponentiation repeats the POLYVAL dot operation, with its "extra" x^-128.
  */
 struct polyval_key {
-#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 #ifdef CONFIG_ARM64
 	/** @h_powers: Powers of the hash key H^8 through H^1 */
 	struct polyval_elem h_powers[8];
 #elif defined(CONFIG_X86)
 	/** @h_powers: Powers of the hash key H^8 through H^1 */
 	struct polyval_elem h_powers[8];
 #else
 #error "Unhandled arch"
 #endif
-#else /* CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
+#else /* CONFIG_CRYPTO_LIB_GF128HASH_ARCH */
 	/** @h: The hash key H */
 	struct polyval_elem h;
-#endif /* !CONFIG_CRYPTO_LIB_POLYVAL_ARCH */
+#endif /* !CONFIG_CRYPTO_LIB_GF128HASH_ARCH */
 };
 
 /**
  * struct polyval_ctx - Context for computing a POLYVAL value
  * @key: Pointer to the prepared POLYVAL key.  The user of the API is
@@ -82,11 +82,11 @@ struct polyval_ctx {
  * copy, or it may involve precomputing powers of the key, depending on the
  * platform's POLYVAL implementation.
  *
  * Context: Any context.
  */
-#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 void polyval_preparekey(struct polyval_key *key,
 			const u8 raw_key[POLYVAL_BLOCK_SIZE]);
 
 #else
 static inline void polyval_preparekey(struct polyval_key *key,
@@ -185,6 +185,6 @@ static inline void polyval(const struct polyval_key *key,
 	polyval_init(&ctx, key);
 	polyval_update(&ctx, data, len);
 	polyval_final(&ctx, out);
 }
 
-#endif /* _CRYPTO_POLYVAL_H */
+#endif /* _CRYPTO_GF128HASH_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4910fe20e42a..98cedd95c2a5 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -108,10 +108,22 @@ config CRYPTO_LIB_CURVE25519_GENERIC
 	default y if !CRYPTO_LIB_CURVE25519_ARCH || ARM || X86_64
 
 config CRYPTO_LIB_DES
 	tristate
 
+config CRYPTO_LIB_GF128HASH
+	tristate
+	help
+	  The GHASH and POLYVAL library functions.  Select this if your module
+	  uses any of the functions from <crypto/gf128hash.h>.
+
+config CRYPTO_LIB_GF128HASH_ARCH
+	bool
+	depends on CRYPTO_LIB_GF128HASH && !UML
+	default y if ARM64
+	default y if X86_64
+
 config CRYPTO_LIB_MD5
 	tristate
 	help
 	  The MD5 and HMAC-MD5 library functions.  Select this if your module
 	  uses any of the functions from <crypto/md5.h>.
@@ -176,22 +188,10 @@ config CRYPTO_LIB_POLY1305_RSIZE
 	default 2 if MIPS || RISCV
 	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 1
 
-config CRYPTO_LIB_POLYVAL
-	tristate
-	help
-	  The POLYVAL library functions.  Select this if your module uses any of
-	  the functions from <crypto/polyval.h>.
-
-config CRYPTO_LIB_POLYVAL_ARCH
-	bool
-	depends on CRYPTO_LIB_POLYVAL && !UML
-	default y if ARM64
-	default y if X86_64
-
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_UTILS
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index a961615c8c7f..fc30622123d2 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -152,10 +152,20 @@ endif
 obj-$(CONFIG_CRYPTO_LIB_DES)			+= libdes.o
 libdes-y					:= des.o
 
 ################################################################################
 
+obj-$(CONFIG_CRYPTO_LIB_GF128HASH) += libgf128hash.o
+libgf128hash-y := gf128hash.o
+ifeq ($(CONFIG_CRYPTO_LIB_GF128HASH_ARCH),y)
+CFLAGS_gf128hash.o += -I$(src)/$(SRCARCH)
+libgf128hash-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
+libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
+endif
+
+################################################################################
+
 obj-$(CONFIG_CRYPTO_LIB_MD5) += libmd5.o
 libmd5-y := md5.o
 ifeq ($(CONFIG_CRYPTO_LIB_MD5_ARCH),y)
 CFLAGS_md5.o += -I$(src)/$(SRCARCH)
 libmd5-$(CONFIG_PPC) += powerpc/md5-asm.o
@@ -249,20 +259,10 @@ clean-files += arm/poly1305-core.S \
 	       riscv/poly1305-core.S \
 	       x86/poly1305-x86_64-cryptogams.S
 
 ################################################################################
 
-obj-$(CONFIG_CRYPTO_LIB_POLYVAL) += libpolyval.o
-libpolyval-y := polyval.o
-ifeq ($(CONFIG_CRYPTO_LIB_POLYVAL_ARCH),y)
-CFLAGS_polyval.o += -I$(src)/$(SRCARCH)
-libpolyval-$(CONFIG_ARM64) += arm64/polyval-ce-core.o
-libpolyval-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
-endif
-
-################################################################################
-
 obj-$(CONFIG_CRYPTO_LIB_SHA1) += libsha1.o
 libsha1-y := sha1.o
 ifeq ($(CONFIG_CRYPTO_LIB_SHA1_ARCH),y)
 CFLAGS_sha1.o += -I$(src)/$(SRCARCH)
 ifeq ($(CONFIG_ARM),y)
diff --git a/lib/crypto/arm64/polyval.h b/lib/crypto/arm64/gf128hash.h
similarity index 95%
rename from lib/crypto/arm64/polyval.h
rename to lib/crypto/arm64/gf128hash.h
index a39763395e9b..c1012007adcf 100644
--- a/lib/crypto/arm64/polyval.h
+++ b/lib/crypto/arm64/gf128hash.h
@@ -70,11 +70,11 @@ static void polyval_blocks_arch(struct polyval_elem *acc,
 		polyval_blocks_generic(acc, &key->h_powers[NUM_H_POWERS - 1],
 				       data, nblocks);
 	}
 }
 
-#define polyval_mod_init_arch polyval_mod_init_arch
-static void polyval_mod_init_arch(void)
+#define gf128hash_mod_init_arch gf128hash_mod_init_arch
+static void gf128hash_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(PMULL))
 		static_branch_enable(&have_pmull);
 }
diff --git a/lib/crypto/polyval.c b/lib/crypto/gf128hash.c
similarity index 94%
rename from lib/crypto/polyval.c
rename to lib/crypto/gf128hash.c
index 5796275f574a..8bb848bf26b7 100644
--- a/lib/crypto/polyval.c
+++ b/lib/crypto/gf128hash.c
@@ -1,13 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * POLYVAL library functions
+ * GF(2^128) polynomial hashing: GHASH and POLYVAL
  *
  * Copyright 2025 Google LLC
  */
 
-#include <crypto/polyval.h>
+#include <crypto/gf128hash.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
@@ -216,12 +216,12 @@ polyval_blocks_generic(struct polyval_elem *acc, const struct polyval_elem *key,
 		data += POLYVAL_BLOCK_SIZE;
 	} while (--nblocks);
 }
 
 /* Include the arch-optimized implementation of POLYVAL, if one is available. */
-#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
-#include "polyval.h" /* $(SRCARCH)/polyval.h */
+#ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
+#include "gf128hash.h" /* $(SRCARCH)/gf128hash.h */
 void polyval_preparekey(struct polyval_key *key,
 			const u8 raw_key[POLYVAL_BLOCK_SIZE])
 {
 	polyval_preparekey_arch(key, raw_key);
 }
@@ -236,21 +236,21 @@ EXPORT_SYMBOL_GPL(polyval_preparekey);
  * code is needed to pass the appropriate key argument.
  */
 
 static void polyval_mul(struct polyval_ctx *ctx)
 {
-#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 	polyval_mul_arch(&ctx->acc, ctx->key);
 #else
 	polyval_mul_generic(&ctx->acc, &ctx->key->h);
 #endif
 }
 
 static void polyval_blocks(struct polyval_ctx *ctx,
 			   const u8 *data, size_t nblocks)
 {
-#ifdef CONFIG_CRYPTO_LIB_POLYVAL_ARCH
+#ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 	polyval_blocks_arch(&ctx->acc, ctx->key, data, nblocks);
 #else
 	polyval_blocks_generic(&ctx->acc, &ctx->key->h, data, nblocks);
 #endif
 }
@@ -287,21 +287,21 @@ void polyval_final(struct polyval_ctx *ctx, u8 out[POLYVAL_BLOCK_SIZE])
 	memcpy(out, &ctx->acc, POLYVAL_BLOCK_SIZE);
 	memzero_explicit(ctx, sizeof(*ctx));
 }
 EXPORT_SYMBOL_GPL(polyval_final);
 
-#ifdef polyval_mod_init_arch
-static int __init polyval_mod_init(void)
+#ifdef gf128hash_mod_init_arch
+static int __init gf128hash_mod_init(void)
 {
-	polyval_mod_init_arch();
+	gf128hash_mod_init_arch();
 	return 0;
 }
-subsys_initcall(polyval_mod_init);
+subsys_initcall(gf128hash_mod_init);
 
-static void __exit polyval_mod_exit(void)
+static void __exit gf128hash_mod_exit(void)
 {
 }
-module_exit(polyval_mod_exit);
+module_exit(gf128hash_mod_exit);
 #endif
 
-MODULE_DESCRIPTION("POLYVAL almost-XOR-universal hash function");
+MODULE_DESCRIPTION("GF(2^128) polynomial hashing: GHASH and POLYVAL");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 42e1770e1883..aa627b6b9855 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -67,11 +67,11 @@ config CRYPTO_LIB_POLY1305_KUNIT_TEST
 	help
 	  KUnit tests for the Poly1305 library functions.
 
 config CRYPTO_LIB_POLYVAL_KUNIT_TEST
 	tristate "KUnit tests for POLYVAL" if !KUNIT_ALL_TESTS
-	depends on KUNIT && CRYPTO_LIB_POLYVAL
+	depends on KUNIT && CRYPTO_LIB_GF128HASH
 	default KUNIT_ALL_TESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the POLYVAL library functions.
 
@@ -120,15 +120,15 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	tristate "Enable all crypto library code for KUnit tests"
 	depends on KUNIT
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_BLAKE2B
 	select CRYPTO_LIB_CURVE25519
+	select CRYPTO_LIB_GF128HASH
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_MLDSA
 	select CRYPTO_LIB_NH
 	select CRYPTO_LIB_POLY1305
-	select CRYPTO_LIB_POLYVAL
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select CRYPTO_LIB_SHA3
 	help
diff --git a/lib/crypto/tests/polyval_kunit.c b/lib/crypto/tests/polyval_kunit.c
index f47f41a39a41..d1f53a690ab8 100644
--- a/lib/crypto/tests/polyval_kunit.c
+++ b/lib/crypto/tests/polyval_kunit.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright 2025 Google LLC
  */
-#include <crypto/polyval.h>
+#include <crypto/gf128hash.h>
 #include "polyval-testvecs.h"
 
 /*
  * A fixed key used when presenting POLYVAL as an unkeyed hash function in order
  * to reuse hash-test-template.h.  At the beginning of the test suite, this is
diff --git a/lib/crypto/x86/polyval.h b/lib/crypto/x86/gf128hash.h
similarity index 95%
rename from lib/crypto/x86/polyval.h
rename to lib/crypto/x86/gf128hash.h
index ef8797521420..fe506cf6431b 100644
--- a/lib/crypto/x86/polyval.h
+++ b/lib/crypto/x86/gf128hash.h
@@ -72,12 +72,12 @@ static void polyval_blocks_arch(struct polyval_elem *acc,
 		polyval_blocks_generic(acc, &key->h_powers[NUM_H_POWERS - 1],
 				       data, nblocks);
 	}
 }
 
-#define polyval_mod_init_arch polyval_mod_init_arch
-static void polyval_mod_init_arch(void)
+#define gf128hash_mod_init_arch gf128hash_mod_init_arch
+static void gf128hash_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ) &&
 	    boot_cpu_has(X86_FEATURE_AVX))
 		static_branch_enable(&have_pclmul_avx);
 }
-- 
2.53.0

