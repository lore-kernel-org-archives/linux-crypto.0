Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85862C2366;
	Wed, 27 Aug 2025 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307701; cv=none; b=hk8gGx4ZeaR14Sx7iN1q8uDgEePVrewe/V2Uzhjc1Gg72jHLBk93tTAWKAVn6oJBjeA+YVmzimhd1yLr/f3eldOBNGVni33sxmkvzNRGPG40kS0zb2cJvig93Q+8QZ0ZETiyNJd+0xpQChc4W9YoGBNalYbAVVk+dqIzmW4PFfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307701; c=relaxed/simple;
	bh=U49ipLriqZbrr3XNuno8hDtfowuvOtRhW3j9fDfIUdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2ZMoR5zitTwTjc5AkvdMhgdVtpTPlx8qHZf4kVZOdi3dG667GUQ/Lrv9e1XA8vsH5XBCxutFw2OHrQljgV3cuGC+AUWWjZXmpQ6cvLVBjYjnOqgOGXnU02U5VQG7R6+5Gro4mSEIQMdva9EM8PgIKwAd0gRh5HTD3CIgwqaTdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hevibz4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hevibz4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EB5C4CEF7;
	Wed, 27 Aug 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307701;
	bh=U49ipLriqZbrr3XNuno8hDtfowuvOtRhW3j9fDfIUdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hevibz4Qr5uFxG1U9N17GWmUhPxkuwGxJD3bhrrdTyLyGpwBOhl1vPlU1o+jjJLwY
	 i6S+8d5h28tF+FAEWjM/bsm2qhIC0OdgSbnVuZcnNUaM6vjCVzMVZH/Fm8ycSSmCCy
	 qVZdvO+CCEjukiowRP/IO236eK+C2wNWac/vpZxuwp0tFBABbI2AjPmWJG9GOgQhOv
	 +gStoxC+ULUH3J0WHCXHREFf6Pld8tGjJKgpFU+tPlU7sazQqjSYspT4HcdQOgCTtp
	 hEg2xW41XvW9pVKJqPJgetBYR4VeTyPU55JJojjmimmbcJkr8hhcNdljsieMWHcaEA
	 Wf2cmTg/CuxfA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/12] lib/crypto: blake2s: Consolidate into single C translation unit
Date: Wed, 27 Aug 2025 08:11:30 -0700
Message-ID: <20250827151131.27733-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As was done with the other algorithms, reorganize the BLAKE2s code so
that the generic implementation and the arch-specific "glue" code is
consolidated into a single translation unit, so that the compiler will
inline the functions and automatically decide whether to include the
generic code in the resulting binary or not.

Similarly, also consolidate the build rules into
lib/crypto/{Makefile,Kconfig}.  This removes the last uses of
lib/crypto/{arm,x86}/{Makefile,Kconfig}, so remove those too.

Don't keep the !KMSAN dependency.  It was needed only for other
algorithms such as ChaCha that initialize memory from assembly code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/internal/blake2s.h            | 19 -------------
 lib/crypto/Kconfig                           | 29 ++++----------------
 lib/crypto/Makefile                          | 13 +++++----
 lib/crypto/arm/Kconfig                       | 14 ----------
 lib/crypto/arm/Makefile                      |  4 ---
 lib/crypto/arm/blake2s-core.S                |  5 +++-
 lib/crypto/arm/blake2s-glue.c                |  7 -----
 lib/crypto/arm/blake2s.h                     |  5 ++++
 lib/crypto/blake2s.c                         | 29 +++++++++++++-------
 lib/crypto/x86/Kconfig                       | 13 ---------
 lib/crypto/x86/Makefile                      |  4 ---
 lib/crypto/x86/{blake2s-glue.c => blake2s.h} | 16 ++++-------
 12 files changed, 47 insertions(+), 111 deletions(-)
 delete mode 100644 include/crypto/internal/blake2s.h
 delete mode 100644 lib/crypto/arm/Kconfig
 delete mode 100644 lib/crypto/arm/Makefile
 delete mode 100644 lib/crypto/arm/blake2s-glue.c
 create mode 100644 lib/crypto/arm/blake2s.h
 delete mode 100644 lib/crypto/x86/Kconfig
 delete mode 100644 lib/crypto/x86/Makefile
 rename lib/crypto/x86/{blake2s-glue.c => blake2s.h} (83%)

diff --git a/include/crypto/internal/blake2s.h b/include/crypto/internal/blake2s.h
deleted file mode 100644
index 3b82572c94337..0000000000000
--- a/include/crypto/internal/blake2s.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR MIT */
-/*
- * Helper functions for BLAKE2s implementations.
- * Keep this in sync with the corresponding BLAKE2b header.
- */
-
-#ifndef _CRYPTO_INTERNAL_BLAKE2S_H
-#define _CRYPTO_INTERNAL_BLAKE2S_H
-
-#include <crypto/blake2s.h>
-#include <linux/string.h>
-
-void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
-			      size_t nblocks, const u32 inc);
-
-void blake2s_compress(struct blake2s_state *state, const u8 *block,
-		      size_t nblocks, const u32 inc);
-
-#endif /* _CRYPTO_INTERNAL_BLAKE2S_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index c1db483bc2306..37d85e0c9b979 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -26,25 +26,17 @@ config CRYPTO_LIB_ARC4
 	tristate
 
 config CRYPTO_LIB_GF128MUL
 	tristate
 
-config CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	bool
-	help
-	  Declares whether the architecture provides an arch-specific
-	  accelerated implementation of the Blake2s library interface,
-	  either builtin or as a module.
+# BLAKE2s support is always built-in, so there's no CRYPTO_LIB_BLAKE2S option.
 
-config CRYPTO_LIB_BLAKE2S_GENERIC
-	def_bool !CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	help
-	  This symbol can be depended upon by arch implementations of the
-	  Blake2s library interface that require the generic code as a
-	  fallback, e.g., for SIMD implementations. If no arch specific
-	  implementation is enabled, this implementation serves the users
-	  of CRYPTO_LIB_BLAKE2S.
+config CRYPTO_LIB_BLAKE2S_ARCH
+	bool
+	depends on !UML
+	default y if ARM
+	default y if X86_64
 
 config CRYPTO_LIB_CHACHA
 	tristate
 	select CRYPTO_LIB_UTILS
 	help
@@ -206,15 +198,6 @@ config CRYPTO_LIB_SHA512_ARCH
 config CRYPTO_LIB_SM3
 	tristate
 
 source "lib/crypto/tests/Kconfig"
 
-if !KMSAN # avoid false positives from assembly
-if ARM
-source "lib/crypto/arm/Kconfig"
-endif
-if X86
-source "lib/crypto/x86/Kconfig"
-endif
-endif
-
 endmenu
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index be45dcfb8969b..2551843694b7e 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -27,13 +27,19 @@ libaesgcm-y					:= aesgcm.o
 obj-$(CONFIG_CRYPTO_LIB_ARC4)			+= libarc4.o
 libarc4-y					:= arc4.o
 
 obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 
+################################################################################
+
 # blake2s is used by the /dev/random driver which is always builtin
-obj-y						+= libblake2s.o
-libblake2s-y					:= blake2s.o
+obj-y += blake2s.o
+ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2S_ARCH),y)
+CFLAGS_blake2s.o += -I$(src)/$(SRCARCH)
+obj-$(CONFIG_ARM) += arm/blake2s-core.o
+obj-$(CONFIG_X86) += x86/blake2s-core.o
+endif
 
 ################################################################################
 
 # chacha20_block() is used by the /dev/random driver which is always builtin
 obj-y += chacha-block-generic.o
@@ -252,11 +258,8 @@ obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
 libsm3-y					:= sm3.o
 
-obj-$(CONFIG_ARM) += arm/
-obj-$(CONFIG_X86) += x86/
-
 # clean-files must be defined unconditionally
 clean-files += arm/sha256-core.S arm/sha512-core.S
 clean-files += arm64/sha256-core.S arm64/sha512-core.S
diff --git a/lib/crypto/arm/Kconfig b/lib/crypto/arm/Kconfig
deleted file mode 100644
index a5607ad079c4f..0000000000000
--- a/lib/crypto/arm/Kconfig
+++ /dev/null
@@ -1,14 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_BLAKE2S_ARM
-	def_bool y
-	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	help
-	  BLAKE2s cryptographic hash function (RFC 7693)
-
-	  Architecture: arm
-
-	  This is faster than the generic implementations of BLAKE2s and
-	  BLAKE2b, but slower than the NEON implementation of BLAKE2b.
-	  There is no NEON implementation of BLAKE2s, since NEON doesn't
-	  really help with it.
diff --git a/lib/crypto/arm/Makefile b/lib/crypto/arm/Makefile
deleted file mode 100644
index 0574b0e9739e3..0000000000000
--- a/lib/crypto/arm/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_BLAKE2S_ARM) += libblake2s-arm.o
-libblake2s-arm-y := blake2s-core.o blake2s-glue.o
diff --git a/lib/crypto/arm/blake2s-core.S b/lib/crypto/arm/blake2s-core.S
index df40e46601f10..293f44fa8f316 100644
--- a/lib/crypto/arm/blake2s-core.S
+++ b/lib/crypto/arm/blake2s-core.S
@@ -1,8 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * BLAKE2s digest algorithm, ARM scalar implementation
+ * BLAKE2s digest algorithm, ARM scalar implementation.  This is faster
+ * than the generic implementations of BLAKE2s and BLAKE2b, but slower
+ * than the NEON implementation of BLAKE2b.  There is no NEON
+ * implementation of BLAKE2s, since NEON doesn't really help with it.
  *
  * Copyright 2020 Google LLC
  *
  * Author: Eric Biggers <ebiggers@google.com>
  */
diff --git a/lib/crypto/arm/blake2s-glue.c b/lib/crypto/arm/blake2s-glue.c
deleted file mode 100644
index 0238a70d9581e..0000000000000
--- a/lib/crypto/arm/blake2s-glue.c
+++ /dev/null
@@ -1,7 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-
-#include <crypto/internal/blake2s.h>
-#include <linux/module.h>
-
-/* defined in blake2s-core.S */
-EXPORT_SYMBOL(blake2s_compress);
diff --git a/lib/crypto/arm/blake2s.h b/lib/crypto/arm/blake2s.h
new file mode 100644
index 0000000000000..aa7a97139ea74
--- /dev/null
+++ b/lib/crypto/arm/blake2s.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* defined in blake2s-core.S */
+void blake2s_compress(struct blake2s_state *state, const u8 *block,
+		      size_t nblocks, u32 inc);
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index b5b75ade46588..5638ed9d882d8 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -6,19 +6,18 @@
  *
  * Information: https://blake2.net/
  *
  */
 
-#include <crypto/internal/blake2s.h>
+#include <crypto/blake2s.h>
 #include <linux/bug.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/types.h>
 
-#ifdef CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC
 static const u8 blake2s_sigma[10][16] = {
 	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
 	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
 	{ 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 },
 	{ 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 },
@@ -35,16 +34,13 @@ static inline void blake2s_increment_counter(struct blake2s_state *state,
 {
 	state->t[0] += inc;
 	state->t[1] += (state->t[0] < inc);
 }
 
-void blake2s_compress(struct blake2s_state *state, const u8 *block,
-		      size_t nblocks, const u32 inc)
-		      __weak __alias(blake2s_compress_generic);
-
-void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
-			      size_t nblocks, const u32 inc)
+static void __maybe_unused
+blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
+			 size_t nblocks, const u32 inc)
 {
 	u32 m[16];
 	u32 v[16];
 	int i;
 
@@ -105,12 +101,16 @@ void blake2s_compress_generic(struct blake2s_state *state, const u8 *block,
 
 		block += BLAKE2S_BLOCK_SIZE;
 		--nblocks;
 	}
 }
-EXPORT_SYMBOL(blake2s_compress_generic);
-#endif /* CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC */
+
+#ifdef CONFIG_CRYPTO_LIB_BLAKE2S_ARCH
+#include "blake2s.h" /* $(SRCARCH)/blake2s.h */
+#else
+#define blake2s_compress blake2s_compress_generic
+#endif
 
 static inline void blake2s_set_lastblock(struct blake2s_state *state)
 {
 	state->f[0] = -1;
 }
@@ -150,7 +150,16 @@ void blake2s_final(struct blake2s_state *state, u8 *out)
 	memcpy(out, state->h, state->outlen);
 	memzero_explicit(state, sizeof(*state));
 }
 EXPORT_SYMBOL(blake2s_final);
 
+#ifdef blake2s_mod_init_arch
+static int __init blake2s_mod_init(void)
+{
+	blake2s_mod_init_arch();
+	return 0;
+}
+subsys_initcall(blake2s_mod_init);
+#endif
+
 MODULE_DESCRIPTION("BLAKE2s hash function");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
diff --git a/lib/crypto/x86/Kconfig b/lib/crypto/x86/Kconfig
deleted file mode 100644
index ffa718321369f..0000000000000
--- a/lib/crypto/x86/Kconfig
+++ /dev/null
@@ -1,13 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_BLAKE2S_X86
-	def_bool y
-	depends on 64BIT
-	select CRYPTO_LIB_BLAKE2S_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
-	help
-	  BLAKE2s cryptographic hash function (RFC 7693)
-
-	  Architecture: x86_64 using:
-	  - SSSE3 (Supplemental SSE3)
-	  - AVX-512 (Advanced Vector Extensions-512)
diff --git a/lib/crypto/x86/Makefile b/lib/crypto/x86/Makefile
deleted file mode 100644
index 4454556b243e7..0000000000000
--- a/lib/crypto/x86/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_BLAKE2S_X86) += libblake2s-x86_64.o
-libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
diff --git a/lib/crypto/x86/blake2s-glue.c b/lib/crypto/x86/blake2s.h
similarity index 83%
rename from lib/crypto/x86/blake2s-glue.c
rename to lib/crypto/x86/blake2s.h
index adc296cd17c93..b6d30d2fa045e 100644
--- a/lib/crypto/x86/blake2s-glue.c
+++ b/lib/crypto/x86/blake2s.h
@@ -1,16 +1,14 @@
-// SPDX-License-Identifier: GPL-2.0 OR MIT
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
 /*
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
 #include <asm/processor.h>
 #include <asm/simd.h>
-#include <crypto/internal/blake2s.h>
-#include <linux/init.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 
 asmlinkage void blake2s_compress_ssse3(struct blake2s_state *state,
@@ -21,12 +19,12 @@ asmlinkage void blake2s_compress_avx512(struct blake2s_state *state,
 					const u32 inc);
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_ssse3);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(blake2s_use_avx512);
 
-void blake2s_compress(struct blake2s_state *state, const u8 *block,
-		      size_t nblocks, const u32 inc)
+static void blake2s_compress(struct blake2s_state *state, const u8 *block,
+			     size_t nblocks, const u32 inc)
 {
 	/* SIMD disables preemption, so relax after processing each page. */
 	BUILD_BUG_ON(SZ_4K / BLAKE2S_BLOCK_SIZE < 8);
 
 	if (!static_branch_likely(&blake2s_use_ssse3) || !may_use_simd()) {
@@ -47,13 +45,13 @@ void blake2s_compress(struct blake2s_state *state, const u8 *block,
 
 		nblocks -= blocks;
 		block += blocks * BLAKE2S_BLOCK_SIZE;
 	} while (nblocks);
 }
-EXPORT_SYMBOL(blake2s_compress);
 
-static int __init blake2s_mod_init(void)
+#define blake2s_mod_init_arch blake2s_mod_init_arch
+static void blake2s_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_SSSE3))
 		static_branch_enable(&blake2s_use_ssse3);
 
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
@@ -61,10 +59,6 @@ static int __init blake2s_mod_init(void)
 	    boot_cpu_has(X86_FEATURE_AVX512F) &&
 	    boot_cpu_has(X86_FEATURE_AVX512VL) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM |
 			      XFEATURE_MASK_AVX512, NULL))
 		static_branch_enable(&blake2s_use_avx512);
-
-	return 0;
 }
-
-subsys_initcall(blake2s_mod_init);
-- 
2.50.1

