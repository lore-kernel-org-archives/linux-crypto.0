Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C98634A3DB;
	Sat, 21 Mar 2026 04:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774066322; cv=none; b=B/qaOzQJSo5waR1fOIzRPgsDJ2Jzso9hqxPwJiacqDeNz3MimqfqSrR0ejvuLE2GoAVHZBUMeVXUAIwXorEJwXbg3fY4vRQeIrGwXYJwNyvNRyGbO1BsQuxR6ulQ7c89LqLDc1XLPsRd4ss4hkgHAosbsKYXFId0zsl8Bu2O3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774066322; c=relaxed/simple;
	bh=Z7X3CEAgl3dXN2F8cAlFv5bwr0TXDZ0BzcoXhcL/Vrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4BxhOwcXwyY4uKX5l2tPowAgRKmdkOYp4vLfBvyE+Xa6kQH6GDeZ0SO5gIhdSVP3VoBCY4iDTOKpXtKu8ej5GZV5gednJoKezqAbuRkExBI93Vs/62/x53Tj94FaP+zFeWjsgMpN2Ykg6BaVo/kvI5XMK2VqsZUbH2hSLOcHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLg2c8Eb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLg2c8Eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34E8C2BCB3;
	Sat, 21 Mar 2026 04:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774066322;
	bh=Z7X3CEAgl3dXN2F8cAlFv5bwr0TXDZ0BzcoXhcL/Vrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLg2c8EbUZGZV7Eej4tzRai+I4sdo2DDkwL00k5pj7z+Jl6xHe281kSPAtTsbhN2X
	 AW8LVDq/ARj0QCu4t4SjYw3K7LI0tHiXbUtem7U6LcQnEQ7imxZXpEyrPHkKaGhZzS
	 u66jNXD30u1xUjboE1bjXDAj+HzhAolFEcjhj8xGXGwm0yanFN3xibRDb4fnoQsBL+
	 vnXWpN6aPHEn/48hjaokhu481ab3KrKEpynO6fdKjZef5gi0dsszYcZVOKpCxt3mi/
	 /z27r9OTCPVgyg7pw7x0uBMA//YZl9ro9uDNkxqzKxEcZIUEJ5nVsjGyKB5jYwyTrH
	 wLx0SjaNAhMkg==
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
Subject: [PATCH 09/12] lib/crypto: x86/sm3: Migrate optimized code into library
Date: Fri, 20 Mar 2026 21:09:32 -0700
Message-ID: <20260321040935.410034-10-ebiggers@kernel.org>
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

Instead of exposing the x86-optimized SM3 code via an x86-specific
crypto_shash algorithm, instead just implement the sm3_blocks() library
function.  This is much simpler, it makes the SM3 library functions be
x86-optimized, and it fixes the longstanding issue where the
x86-optimized SM3 code was disabled by default.  SM3 still remains
available through crypto_shash, but individual architectures no longer
need to handle it.

Tweak the prototype of sm3_transform_avx() to match what the library
expects, including changing the block count to size_t.  Note that the
assembly code actually already treated this argument as size_t.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |  13 ---
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/sm3_avx_glue.c                | 100 ------------------
 lib/crypto/Kconfig                            |   1 +
 lib/crypto/Makefile                           |   1 +
 .../crypto/x86}/sm3-avx-asm_64.S              |  13 ++-
 lib/crypto/x86/sm3.h                          |  39 +++++++
 7 files changed, 47 insertions(+), 123 deletions(-)
 delete mode 100644 arch/x86/crypto/sm3_avx_glue.c
 rename {arch/x86/crypto => lib/crypto/x86}/sm3-avx-asm_64.S (98%)
 create mode 100644 lib/crypto/x86/sm3.h

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 7fb2319a0916..617494bd019f 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -329,23 +329,10 @@ config CRYPTO_AEGIS128_AESNI_SSE2
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
 	  - SSE4.1 (Streaming SIMD Extensions 4.1)
 
-config CRYPTO_SM3_AVX_X86_64
-	tristate "Hash functions: SM3 (AVX)"
-	depends on 64BIT
-	select CRYPTO_HASH
-	select CRYPTO_LIB_SM3
-	help
-	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3
-
-	  Architecture: x86_64 using:
-	  - AVX (Advanced Vector Extensions)
-
-	  If unsure, say N.
-
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "Hash functions: GHASH (CLMUL-NI)"
 	depends on 64BIT
 	select CRYPTO_CRYPTD
 	help
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b21ad0978c52..9420b9ff51da 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -51,13 +51,10 @@ aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-xts-avx-x86_64.o
 
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 
-obj-$(CONFIG_CRYPTO_SM3_AVX_X86_64) += sm3-avx-x86_64.o
-sm3-avx-x86_64-y := sm3-avx-asm_64.o sm3_avx_glue.o
-
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
 sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64) += sm4-aesni-avx2-x86_64.o
 sm4-aesni-avx2-x86_64-y := sm4-aesni-avx2-asm_64.o sm4_aesni_avx2_glue.o
diff --git a/arch/x86/crypto/sm3_avx_glue.c b/arch/x86/crypto/sm3_avx_glue.c
deleted file mode 100644
index 6e8c42b9dc8e..000000000000
--- a/arch/x86/crypto/sm3_avx_glue.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * SM3 Secure Hash Algorithm, AVX assembler accelerated.
- * specified in: https://datatracker.ietf.org/doc/html/draft-sca-cfrg-sm3-02
- *
- * Copyright (C) 2021 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
- */
-
-#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
-
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <crypto/sm3.h>
-#include <crypto/sm3_base.h>
-#include <linux/cpufeature.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-asmlinkage void sm3_transform_avx(struct sm3_state *state,
-			const u8 *data, int nblocks);
-
-static int sm3_avx_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int len)
-{
-	int remain;
-
-	/*
-	 * Make sure struct sm3_state begins directly with the SM3
-	 * 256-bit internal state, as this is what the asm functions expect.
-	 */
-	BUILD_BUG_ON(offsetof(struct sm3_state, state) != 0);
-
-	kernel_fpu_begin();
-	remain = sm3_base_do_update_blocks(desc, data, len, sm3_transform_avx);
-	kernel_fpu_end();
-	return remain;
-}
-
-static int sm3_avx_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out)
-{
-	kernel_fpu_begin();
-	sm3_base_do_finup(desc, data, len, sm3_transform_avx);
-	kernel_fpu_end();
-	return sm3_base_finish(desc, out);
-}
-
-static struct shash_alg sm3_avx_alg = {
-	.digestsize	=	SM3_DIGEST_SIZE,
-	.init		=	sm3_base_init,
-	.update		=	sm3_avx_update,
-	.finup		=	sm3_avx_finup,
-	.descsize	=	SM3_STATE_SIZE,
-	.base		=	{
-		.cra_name	=	"sm3",
-		.cra_driver_name =	"sm3-avx",
-		.cra_priority	=	300,
-		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY |
-					CRYPTO_AHASH_ALG_FINUP_MAX,
-		.cra_blocksize	=	SM3_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-};
-
-static int __init sm3_avx_mod_init(void)
-{
-	const char *feature_name;
-
-	if (!boot_cpu_has(X86_FEATURE_AVX)) {
-		pr_info("AVX instruction are not detected.\n");
-		return -ENODEV;
-	}
-
-	if (!boot_cpu_has(X86_FEATURE_BMI2)) {
-		pr_info("BMI2 instruction are not detected.\n");
-		return -ENODEV;
-	}
-
-	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
-				&feature_name)) {
-		pr_info("CPU feature '%s' is not supported.\n", feature_name);
-		return -ENODEV;
-	}
-
-	return crypto_register_shash(&sm3_avx_alg);
-}
-
-static void __exit sm3_avx_mod_exit(void)
-{
-	crypto_unregister_shash(&sm3_avx_alg);
-}
-
-module_init(sm3_avx_mod_init);
-module_exit(sm3_avx_mod_exit);
-
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Tianjia Zhang <tianjia.zhang@linux.alibaba.com>");
-MODULE_DESCRIPTION("SM3 Secure Hash Algorithm, AVX assembler accelerated");
-MODULE_ALIAS_CRYPTO("sm3");
-MODULE_ALIAS_CRYPTO("sm3-avx");
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index b714f9cbd368..2824bfb0e30d 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -275,9 +275,10 @@ config CRYPTO_LIB_SM3_ARCH
 	bool
 	depends on CRYPTO_LIB_SM3 && !UML
 	default y if ARM64
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
+	default y if X86_64
 
 source "lib/crypto/tests/Kconfig"
 
 endmenu
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 3019e6cbb10d..308ec3e93b54 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -354,10 +354,11 @@ libsm3-y := sm3.o
 ifeq ($(CONFIG_CRYPTO_LIB_SM3_ARCH),y)
 CFLAGS_sm3.o += -I$(src)/$(SRCARCH)
 libsm3-$(CONFIG_ARM64) += arm64/sm3-ce-core.o \
 			  arm64/sm3-neon-core.o
 libsm3-$(CONFIG_RISCV) += riscv/sm3-riscv64-zvksh-zvkb.o
+libsm3-$(CONFIG_X86) += x86/sm3-avx-asm_64.o
 endif # CONFIG_CRYPTO_LIB_SM3_ARCH
 
 ################################################################################
 
 obj-$(CONFIG_MPILIB) += mpi/
diff --git a/arch/x86/crypto/sm3-avx-asm_64.S b/lib/crypto/x86/sm3-avx-asm_64.S
similarity index 98%
rename from arch/x86/crypto/sm3-avx-asm_64.S
rename to lib/crypto/x86/sm3-avx-asm_64.S
index 503bab450a91..a1925b136010 100644
--- a/arch/x86/crypto/sm3-avx-asm_64.S
+++ b/lib/crypto/x86/sm3-avx-asm_64.S
@@ -10,14 +10,13 @@
 /* Based on SM3 AES/BMI2 accelerated work by libgcrypt at:
  *  https://gnupg.org/software/libgcrypt/index.html
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
-/* Context structure */
+/* State structure */
 
 #define state_h0 0
 #define state_h1 4
 #define state_h2 8
 #define state_h3 12
@@ -323,17 +322,17 @@
 .text
 
 /*
  * Transform nblocks*64 bytes (nblocks*16 32-bit words) at DATA.
  *
- * void sm3_transform_avx(struct sm3_state *state,
- *                        const u8 *data, int nblocks);
+ * void sm3_transform_avx(struct sm3_block_state *state,
+ *                        const u8 *data, size_t nblocks);
  */
-SYM_TYPED_FUNC_START(sm3_transform_avx)
+SYM_FUNC_START(sm3_transform_avx)
 	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: data (64*nblks bytes)
+	 *	%rdi: state
+	 *	%rsi: data
 	 *	%rdx: nblocks
 	 */
 	vzeroupper;
 
 	pushq %rbp;
diff --git a/lib/crypto/x86/sm3.h b/lib/crypto/x86/sm3.h
new file mode 100644
index 000000000000..3834780f2f6a
--- /dev/null
+++ b/lib/crypto/x86/sm3.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * SM3 optimized for x86_64
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <asm/fpu/api.h>
+#include <linux/static_call.h>
+
+asmlinkage void sm3_transform_avx(struct sm3_block_state *state,
+				  const u8 *data, size_t nblocks);
+
+static void sm3_blocks_avx(struct sm3_block_state *state,
+			   const u8 *data, size_t nblocks)
+{
+	if (likely(irq_fpu_usable())) {
+		kernel_fpu_begin();
+		sm3_transform_avx(state, data, nblocks);
+		kernel_fpu_end();
+	} else {
+		sm3_blocks_generic(state, data, nblocks);
+	}
+}
+
+DEFINE_STATIC_CALL(sm3_blocks_x86, sm3_blocks_generic);
+
+static void sm3_blocks(struct sm3_block_state *state,
+		       const u8 *data, size_t nblocks)
+{
+	static_call(sm3_blocks_x86)(state, data, nblocks);
+}
+
+#define sm3_mod_init_arch sm3_mod_init_arch
+static void sm3_mod_init_arch(void)
+{
+	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_BMI2) &&
+	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
+		static_call_update(sm3_blocks_x86, sm3_blocks_avx);
+}
-- 
2.53.0

