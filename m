Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4D127E05F;
	Wed, 27 Aug 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307699; cv=none; b=flv5DQBBR9j1uwrLtWp1yzyMRS/GVubA1alWO0WmdjyidY/EjP78MJwH4EZ5T73CKSLvLBl1y+k05/d5MuYo0r159IdqbdzNUrbQbeKFKqn/+kT4WRLD2pEQIYkcf7GKaAMAch8LNYvDWXW4ocAnZBsOHTTHva91fkBPBIj2mj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307699; c=relaxed/simple;
	bh=4OQ6L8Z9fiYsl2GeZ8NUQoGRg1AzhJZSgptP9o0Boqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6S2cAn7nVjp3j1aD473SlVkEDvh74Y2hurNBfLpkgr5uWmkCFtBwX7HzaqwFOqaED83iXgWfkMhsUymw3mduhH8yvhhRh4ujV57AjGN70qpZFmUDAgFt8C2CTF/vF9erYopBPAI9rC2gZLsAobXdy+ZkH7N6Mv/movNPcbw17o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcB4W+rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcB4W+rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978BBC4CEF5;
	Wed, 27 Aug 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307698;
	bh=4OQ6L8Z9fiYsl2GeZ8NUQoGRg1AzhJZSgptP9o0Boqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcB4W+rkhc4Um4tzNPOtygXY8UKVEFYewhkSEiKsX/SHTF3y5PoBAA8INcAYePLqZ
	 wh4b0I5aUd+p9VZcw+pSp+74rkyCgQMKfVtYuIOK/yxJbeH97wm5rvRsjNmqbUz+we
	 lpel81AP9m6Wanh+IrdqUW8CmUadHN/T0AhxYmnsPczIE+Jp5Pk9skESIxGYZsigpY
	 UCsEqsnBG50bX7FJBqXqSM20GLShGys4BRL3sjvdTg7YXuH5Kmj2wgzhK+M3ifzmvb
	 HZ6ppx/L2+86fANsO0z4IbByglOTK6QkKKxIrizTbS+IVfo87QzwkSCVhLwPGiQhzH
	 tHY8GX9fkR3ug==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/12] lib/crypto: chacha: Consolidate into single module
Date: Wed, 27 Aug 2025 08:11:25 -0700
Message-ID: <20250827151131.27733-7-ebiggers@kernel.org>
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

Consolidate the ChaCha code into a single module (excluding
chacha-block-generic.c which remains always built-in for random.c),
similar to various other algorithms:

- Each arch now provides a header file lib/crypto/$(SRCARCH)/chacha.h,
  replacing lib/crypto/$(SRCARCH)/chacha*.c.  The header defines
  chacha_crypt_arch() and hchacha_block_arch().  It is included by
  lib/crypto/chacha.c, and thus the code gets built into the single
  libchacha module, with improved inlining in some cases.

- Whether arch-optimized ChaCha is buildable is now controlled centrally
  by lib/crypto/Kconfig instead of by lib/crypto/$(SRCARCH)/Kconfig.
  The conditions for enabling it remain the same as before, and it
  remains enabled by default.

- Any additional arch-specific translation units for the optimized
  ChaCha code, such as assembly files, are now compiled by
  lib/crypto/Makefile instead of lib/crypto/$(SRCARCH)/Makefile.

This removes the last use for the Makefile and Kconfig files in the
arm64, mips, powerpc, riscv, and s390 subdirectories of lib/crypto/.  So
also remove those files and the references to them.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/chacha.h                       | 28 ++---------
 lib/crypto/Kconfig                            | 47 +++++--------------
 lib/crypto/Makefile                           | 43 +++++++++++++----
 lib/crypto/arm/Kconfig                        |  5 --
 lib/crypto/arm/Makefile                       |  4 --
 lib/crypto/arm/{chacha-glue.c => chacha.h}    | 28 +++--------
 lib/crypto/arm64/Kconfig                      |  8 ----
 lib/crypto/arm64/Makefile                     |  4 --
 .../arm64/{chacha-neon-glue.c => chacha.h}    | 26 +++-------
 lib/crypto/chacha.c                           | 41 ++++++++++++++--
 lib/crypto/mips/Kconfig                       |  7 ---
 lib/crypto/mips/Makefile                      |  5 --
 lib/crypto/mips/{chacha-glue.c => chacha.h}   | 11 +----
 lib/crypto/powerpc/Kconfig                    |  8 ----
 lib/crypto/powerpc/Makefile                   |  4 --
 .../powerpc/{chacha-p10-glue.c => chacha.h}   | 30 +++---------
 lib/crypto/riscv/Kconfig                      |  8 ----
 lib/crypto/riscv/Makefile                     |  4 --
 .../riscv/{chacha-riscv64-glue.c => chacha.h} | 30 +++---------
 lib/crypto/s390/Kconfig                       |  7 ---
 lib/crypto/s390/Makefile                      |  4 --
 lib/crypto/s390/{chacha-glue.c => chacha.h}   | 23 ++-------
 lib/crypto/x86/Kconfig                        |  7 ---
 lib/crypto/x86/Makefile                       |  3 --
 lib/crypto/x86/{chacha_glue.c => chacha.h}    | 30 ++++--------
 25 files changed, 126 insertions(+), 289 deletions(-)
 rename lib/crypto/arm/{chacha-glue.c => chacha.h} (79%)
 delete mode 100644 lib/crypto/arm64/Kconfig
 delete mode 100644 lib/crypto/arm64/Makefile
 rename lib/crypto/arm64/{chacha-neon-glue.c => chacha.h} (78%)
 delete mode 100644 lib/crypto/mips/Kconfig
 delete mode 100644 lib/crypto/mips/Makefile
 rename lib/crypto/mips/{chacha-glue.c => chacha.h} (55%)
 delete mode 100644 lib/crypto/powerpc/Kconfig
 delete mode 100644 lib/crypto/powerpc/Makefile
 rename lib/crypto/powerpc/{chacha-p10-glue.c => chacha.h} (66%)
 delete mode 100644 lib/crypto/riscv/Kconfig
 delete mode 100644 lib/crypto/riscv/Makefile
 rename lib/crypto/riscv/{chacha-riscv64-glue.c => chacha.h} (61%)
 delete mode 100644 lib/crypto/s390/Kconfig
 delete mode 100644 lib/crypto/s390/Makefile
 rename lib/crypto/s390/{chacha-glue.c => chacha.h} (55%)
 rename lib/crypto/x86/{chacha_glue.c => chacha.h} (87%)

diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
index be25a0b65a05f..38e26dff27b00 100644
--- a/include/crypto/chacha.h
+++ b/include/crypto/chacha.h
@@ -43,23 +43,15 @@ static inline void chacha20_block(struct chacha_state *state,
 				  u8 out[CHACHA_BLOCK_SIZE])
 {
 	chacha_block_generic(state, out, 20);
 }
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds);
 void hchacha_block_generic(const struct chacha_state *state,
 			   u32 out[HCHACHA_OUT_WORDS], int nrounds);
 
-static inline void hchacha_block(const struct chacha_state *state,
-				 u32 out[HCHACHA_OUT_WORDS], int nrounds)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
-		hchacha_block_arch(state, out, nrounds);
-	else
-		hchacha_block_generic(state, out, nrounds);
-}
+void hchacha_block(const struct chacha_state *state,
+		   u32 out[HCHACHA_OUT_WORDS], int nrounds);
 
 enum chacha_constants { /* expand 32-byte k */
 	CHACHA_CONSTANT_EXPA = 0x61707865U,
 	CHACHA_CONSTANT_ND_3 = 0x3320646eU,
 	CHACHA_CONSTANT_2_BY = 0x79622d32U,
@@ -91,24 +83,12 @@ static inline void chacha_init(struct chacha_state *state,
 	state->x[13] = get_unaligned_le32(iv +  4);
 	state->x[14] = get_unaligned_le32(iv +  8);
 	state->x[15] = get_unaligned_le32(iv + 12);
 }
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds);
-void chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
-			  unsigned int bytes, int nrounds);
-
-static inline void chacha_crypt(struct chacha_state *state,
-				u8 *dst, const u8 *src,
-				unsigned int bytes, int nrounds)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
-		chacha_crypt_arch(state, dst, src, bytes, nrounds);
-	else
-		chacha_crypt_generic(state, dst, src, bytes, nrounds);
-}
+void chacha_crypt(struct chacha_state *state, u8 *dst, const u8 *src,
+		  unsigned int bytes, int nrounds);
 
 static inline void chacha20_crypt(struct chacha_state *state,
 				  u8 *dst, const u8 *src, unsigned int bytes)
 {
 	chacha_crypt(state, dst, src, bytes, 20);
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index cb4e056a98faf..c1db483bc2306 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -42,33 +42,27 @@ config CRYPTO_LIB_BLAKE2S_GENERIC
 	  Blake2s library interface that require the generic code as a
 	  fallback, e.g., for SIMD implementations. If no arch specific
 	  implementation is enabled, this implementation serves the users
 	  of CRYPTO_LIB_BLAKE2S.
 
-config CRYPTO_ARCH_HAVE_LIB_CHACHA
-	bool
-	help
-	  Declares whether the architecture provides an arch-specific
-	  accelerated implementation of the ChaCha library interface,
-	  either builtin or as a module.
-
-config CRYPTO_LIB_CHACHA_GENERIC
+config CRYPTO_LIB_CHACHA
 	tristate
-	default CRYPTO_LIB_CHACHA if !CRYPTO_ARCH_HAVE_LIB_CHACHA
 	select CRYPTO_LIB_UTILS
 	help
-	  This symbol can be selected by arch implementations of the ChaCha
-	  library interface that require the generic code as a fallback, e.g.,
-	  for SIMD implementations. If no arch specific implementation is
-	  enabled, this implementation serves the users of CRYPTO_LIB_CHACHA.
+	  Enable the ChaCha library interface.  Select this if your module uses
+	  chacha_crypt() or hchacha_block().
 
-config CRYPTO_LIB_CHACHA
-	tristate
-	help
-	  Enable the ChaCha library interface. This interface may be fulfilled
-	  by either the generic implementation or an arch-specific one, if one
-	  is available and enabled.
+config CRYPTO_LIB_CHACHA_ARCH
+	bool
+	depends on CRYPTO_LIB_CHACHA && !UML && !KMSAN
+	default y if ARM
+	default y if ARM64 && KERNEL_MODE_NEON
+	default y if MIPS && CPU_MIPS32_R2
+	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX
+	default y if RISCV && 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
+	default y if S390
+	default y if X86_64
 
 config CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	bool
 	help
 	  Declares whether the architecture provides an arch-specific
@@ -216,25 +210,10 @@ source "lib/crypto/tests/Kconfig"
 
 if !KMSAN # avoid false positives from assembly
 if ARM
 source "lib/crypto/arm/Kconfig"
 endif
-if ARM64
-source "lib/crypto/arm64/Kconfig"
-endif
-if MIPS
-source "lib/crypto/mips/Kconfig"
-endif
-if PPC
-source "lib/crypto/powerpc/Kconfig"
-endif
-if RISCV
-source "lib/crypto/riscv/Kconfig"
-endif
-if S390
-source "lib/crypto/s390/Kconfig"
-endif
 if X86
 source "lib/crypto/x86/Kconfig"
 endif
 endif
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 5749d176be1c1..33d7288265db2 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -13,15 +13,10 @@ obj-$(CONFIG_KUNIT)				+= tests/
 obj-$(CONFIG_CRYPTO_HASH_INFO)			+= hash_info.o
 
 obj-$(CONFIG_CRYPTO_LIB_UTILS)			+= libcryptoutils.o
 libcryptoutils-y				:= memneq.o utils.o
 
-# chacha20_block() is used by the /dev/random driver which is always builtin
-obj-y						+= chacha-block-generic.o
-obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
-libchacha-y := chacha.o
-
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
 obj-$(CONFIG_CRYPTO_LIB_AESCFB)			+= libaescfb.o
 libaescfb-y					:= aescfb.o
@@ -38,10 +33,43 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
 obj-y						+= libblake2s.o
 libblake2s-y					:= blake2s.o
 libblake2s-$(CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC)	+= blake2s-generic.o
 libblake2s-$(CONFIG_CRYPTO_SELFTESTS)		+= blake2s-selftest.o
 
+################################################################################
+
+# chacha20_block() is used by the /dev/random driver which is always builtin
+obj-y += chacha-block-generic.o
+
+obj-$(CONFIG_CRYPTO_LIB_CHACHA) += libchacha.o
+libchacha-y := chacha.o
+
+ifeq ($(CONFIG_CRYPTO_LIB_CHACHA_ARCH),y)
+CFLAGS_chacha.o += -I$(src)/$(SRCARCH)
+
+ifeq ($(CONFIG_ARM),y)
+libchacha-y += arm/chacha-scalar-core.o
+libchacha-$(CONFIG_KERNEL_MODE_NEON) += arm/chacha-neon-core.o
+endif
+
+libchacha-$(CONFIG_ARM64) += arm64/chacha-neon-core.o
+
+ifeq ($(CONFIG_MIPS),y)
+libchacha-y += mips/chacha-core.o
+AFLAGS_mips/chacha-core.o += -O2 # needed to fill branch delay slots
+endif
+
+libchacha-$(CONFIG_PPC) += powerpc/chacha-p10le-8x.o
+libchacha-$(CONFIG_RISCV) += riscv/chacha-riscv64-zvkb.o
+libchacha-$(CONFIG_S390) += s390/chacha-s390.o
+libchacha-$(CONFIG_X86) += x86/chacha-ssse3-x86_64.o \
+			   x86/chacha-avx2-x86_64.o \
+			   x86/chacha-avx512vl-x86_64.o
+endif # CONFIG_CRYPTO_LIB_CHACHA_ARCH
+
+################################################################################
+
 obj-$(CONFIG_CRYPTO_LIB_CHACHA20POLY1305)	+= libchacha20poly1305.o
 libchacha20poly1305-y				+= chacha20poly1305.o
 libchacha20poly1305-$(CONFIG_CRYPTO_SELFTESTS)	+= chacha20poly1305-selftest.o
 
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519-generic.o
@@ -227,15 +255,10 @@ obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+= simd.o
 
 obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
 libsm3-y					:= sm3.o
 
 obj-$(CONFIG_ARM) += arm/
-obj-$(CONFIG_ARM64) += arm64/
-obj-$(CONFIG_MIPS) += mips/
-obj-$(CONFIG_PPC) += powerpc/
-obj-$(CONFIG_RISCV) += riscv/
-obj-$(CONFIG_S390) += s390/
 obj-$(CONFIG_X86) += x86/
 
 # clean-files must be defined unconditionally
 clean-files += arm/sha256-core.S arm/sha512-core.S
 clean-files += arm64/sha256-core.S arm64/sha512-core.S
diff --git a/lib/crypto/arm/Kconfig b/lib/crypto/arm/Kconfig
index 0d821e282c645..740341aa35d21 100644
--- a/lib/crypto/arm/Kconfig
+++ b/lib/crypto/arm/Kconfig
@@ -10,10 +10,5 @@ config CRYPTO_BLAKE2S_ARM
 
 	  This is faster than the generic implementations of BLAKE2s and
 	  BLAKE2b, but slower than the NEON implementation of BLAKE2b.
 	  There is no NEON implementation of BLAKE2s, since NEON doesn't
 	  really help with it.
-
-config CRYPTO_CHACHA20_NEON
-	tristate
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/arm/Makefile b/lib/crypto/arm/Makefile
index 9f70e61d419e2..0574b0e9739e3 100644
--- a/lib/crypto/arm/Makefile
+++ b/lib/crypto/arm/Makefile
@@ -1,8 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_BLAKE2S_ARM) += libblake2s-arm.o
 libblake2s-arm-y := blake2s-core.o blake2s-glue.o
-
-obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
-chacha-neon-y := chacha-scalar-core.o chacha-glue.o
-chacha-neon-$(CONFIG_KERNEL_MODE_NEON) += chacha-neon-core.o
diff --git a/lib/crypto/arm/chacha-glue.c b/lib/crypto/arm/chacha.h
similarity index 79%
rename from lib/crypto/arm/chacha-glue.c
rename to lib/crypto/arm/chacha.h
index 67ba045cae359..0cae30f8ee5d1 100644
--- a/lib/crypto/arm/chacha-glue.c
+++ b/lib/crypto/arm/chacha.h
@@ -1,18 +1,16 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ChaCha and HChaCha functions (ARM optimized)
  *
  * Copyright (C) 2016-2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <crypto/chacha.h>
 #include <crypto/internal/simd.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 
 #include <asm/cputype.h>
 #include <asm/hwcap.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
@@ -62,25 +60,24 @@ static void chacha_doneon(struct chacha_state *state, u8 *dst, const u8 *src,
 			memcpy(dst, buf, bytes);
 		state->x[12]++;
 	}
 }
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
+static void hchacha_block_arch(const struct chacha_state *state,
+			       u32 out[HCHACHA_OUT_WORDS], int nrounds)
 {
 	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable()) {
 		hchacha_block_arm(state, out, nrounds);
 	} else {
 		kernel_neon_begin();
 		hchacha_block_neon(state, out, nrounds);
 		kernel_neon_end();
 	}
 }
-EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable() ||
 	    bytes <= CHACHA_BLOCK_SIZE) {
 		chacha_doarm(dst, src, bytes, state, nrounds);
 		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
@@ -97,13 +94,13 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		bytes -= todo;
 		src += todo;
 		dst += todo;
 	} while (bytes);
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int __init chacha_arm_mod_init(void)
+#define chacha_mod_init_arch chacha_mod_init_arch
+static void chacha_mod_init_arch(void)
 {
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && (elf_hwcap & HWCAP_NEON)) {
 		switch (read_cpuid_part()) {
 		case ARM_CPU_PART_CORTEX_A7:
 		case ARM_CPU_PART_CORTEX_A5:
@@ -115,17 +112,6 @@ static int __init chacha_arm_mod_init(void)
 			break;
 		default:
 			static_branch_enable(&use_neon);
 		}
 	}
-	return 0;
 }
-subsys_initcall(chacha_arm_mod_init);
-
-static void __exit chacha_arm_mod_exit(void)
-{
-}
-module_exit(chacha_arm_mod_exit);
-
-MODULE_DESCRIPTION("ChaCha and HChaCha functions (ARM optimized)");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/arm64/Kconfig b/lib/crypto/arm64/Kconfig
deleted file mode 100644
index 07c8a4f0ab03a..0000000000000
--- a/lib/crypto/arm64/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_CHACHA20_NEON
-	tristate
-	depends on KERNEL_MODE_NEON
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/arm64/Makefile b/lib/crypto/arm64/Makefile
deleted file mode 100644
index d49cceca3d1ca..0000000000000
--- a/lib/crypto/arm64/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
-chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
diff --git a/lib/crypto/arm64/chacha-neon-glue.c b/lib/crypto/arm64/chacha.h
similarity index 78%
rename from lib/crypto/arm64/chacha-neon-glue.c
rename to lib/crypto/arm64/chacha.h
index 48097aa34af7c..ba6c22d460863 100644
--- a/lib/crypto/arm64/chacha-neon-glue.c
+++ b/lib/crypto/arm64/chacha.h
@@ -16,15 +16,13 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
 
-#include <crypto/chacha.h>
 #include <crypto/internal/simd.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
 
@@ -59,25 +57,24 @@ static void chacha_doneon(struct chacha_state *state, u8 *dst, const u8 *src,
 		dst += l;
 		state->x[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
 	}
 }
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
+static void hchacha_block_arch(const struct chacha_state *state,
+			       u32 out[HCHACHA_OUT_WORDS], int nrounds)
 {
 	if (!static_branch_likely(&have_neon) || !crypto_simd_usable()) {
 		hchacha_block_generic(state, out, nrounds);
 	} else {
 		kernel_neon_begin();
 		hchacha_block_neon(state, out, nrounds);
 		kernel_neon_end();
 	}
 }
-EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
@@ -91,23 +88,12 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		bytes -= todo;
 		src += todo;
 		dst += todo;
 	} while (bytes);
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int __init chacha_simd_mod_init(void)
+#define chacha_mod_init_arch chacha_mod_init_arch
+static void chacha_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(ASIMD))
 		static_branch_enable(&have_neon);
-	return 0;
 }
-subsys_initcall(chacha_simd_mod_init);
-
-static void __exit chacha_simd_mod_exit(void)
-{
-}
-module_exit(chacha_simd_mod_exit);
-
-MODULE_DESCRIPTION("ChaCha and HChaCha functions (ARM64 optimized)");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index 26862ad90a964..e0c7cb4af3180 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -9,12 +9,13 @@
 #include <crypto/chacha.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-void chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
-			  unsigned int bytes, int nrounds)
+static void __maybe_unused
+chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
+		     unsigned int bytes, int nrounds)
 {
 	/* aligned to potentially speed up crypto_xor() */
 	u8 stream[CHACHA_BLOCK_SIZE] __aligned(sizeof(long));
 
 	while (bytes >= CHACHA_BLOCK_SIZE) {
@@ -27,9 +28,43 @@ void chacha_crypt_generic(struct chacha_state *state, u8 *dst, const u8 *src,
 	if (bytes) {
 		chacha_block_generic(state, stream, nrounds);
 		crypto_xor_cpy(dst, src, stream, bytes);
 	}
 }
-EXPORT_SYMBOL(chacha_crypt_generic);
+
+#ifdef CONFIG_CRYPTO_LIB_CHACHA_ARCH
+#include "chacha.h" /* $(SRCARCH)/chacha.h */
+#else
+#define chacha_crypt_arch chacha_crypt_generic
+#define hchacha_block_arch hchacha_block_generic
+#endif
+
+void chacha_crypt(struct chacha_state *state, u8 *dst, const u8 *src,
+		  unsigned int bytes, int nrounds)
+{
+	chacha_crypt_arch(state, dst, src, bytes, nrounds);
+}
+EXPORT_SYMBOL_GPL(chacha_crypt);
+
+void hchacha_block(const struct chacha_state *state,
+		   u32 out[HCHACHA_OUT_WORDS], int nrounds)
+{
+	hchacha_block_arch(state, out, nrounds);
+}
+EXPORT_SYMBOL_GPL(hchacha_block);
+
+#ifdef chacha_mod_init_arch
+static int __init chacha_mod_init(void)
+{
+	chacha_mod_init_arch();
+	return 0;
+}
+subsys_initcall(chacha_mod_init);
+
+static void __exit chacha_mod_exit(void)
+{
+}
+module_exit(chacha_mod_exit);
+#endif
 
 MODULE_DESCRIPTION("ChaCha stream cipher (RFC7539)");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/mips/Kconfig b/lib/crypto/mips/Kconfig
deleted file mode 100644
index 94c1a0892c203..0000000000000
--- a/lib/crypto/mips/Kconfig
+++ /dev/null
@@ -1,7 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_CHACHA_MIPS
-	tristate
-	depends on CPU_MIPS32_R2
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/mips/Makefile b/lib/crypto/mips/Makefile
deleted file mode 100644
index b5ea0e25c21ef..0000000000000
--- a/lib/crypto/mips/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_CHACHA_MIPS) += chacha-mips.o
-chacha-mips-y := chacha-core.o chacha-glue.o
-AFLAGS_chacha-core.o += -O2 # needed to fill branch delay slots
diff --git a/lib/crypto/mips/chacha-glue.c b/lib/crypto/mips/chacha.h
similarity index 55%
rename from lib/crypto/mips/chacha-glue.c
rename to lib/crypto/mips/chacha.h
index f8390af21dc92..0c18c0dc2a406 100644
--- a/lib/crypto/mips/chacha-glue.c
+++ b/lib/crypto/mips/chacha.h
@@ -1,23 +1,14 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ChaCha and HChaCha functions (MIPS optimized)
  *
  * Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <crypto/chacha.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 
 asmlinkage void chacha_crypt_arch(struct chacha_state *state,
 				  u8 *dst, const u8 *src,
 				  unsigned int bytes, int nrounds);
-EXPORT_SYMBOL(chacha_crypt_arch);
-
 asmlinkage void hchacha_block_arch(const struct chacha_state *state,
 				   u32 out[HCHACHA_OUT_WORDS], int nrounds);
-EXPORT_SYMBOL(hchacha_block_arch);
-
-MODULE_DESCRIPTION("ChaCha and HChaCha functions (MIPS optimized)");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/powerpc/Kconfig b/lib/crypto/powerpc/Kconfig
deleted file mode 100644
index e41012a61876e..0000000000000
--- a/lib/crypto/powerpc/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_CHACHA20_P10
-	tristate
-	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/powerpc/Makefile b/lib/crypto/powerpc/Makefile
deleted file mode 100644
index 778a04edd226c..0000000000000
--- a/lib/crypto/powerpc/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_CHACHA20_P10) += chacha-p10-crypto.o
-chacha-p10-crypto-y := chacha-p10-glue.o chacha-p10le-8x.o
diff --git a/lib/crypto/powerpc/chacha-p10-glue.c b/lib/crypto/powerpc/chacha.h
similarity index 66%
rename from lib/crypto/powerpc/chacha-p10-glue.c
rename to lib/crypto/powerpc/chacha.h
index 5d3d5506d7f94..1df6e1ce31c46 100644
--- a/lib/crypto/powerpc/chacha-p10-glue.c
+++ b/lib/crypto/powerpc/chacha.h
@@ -1,16 +1,14 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ChaCha stream cipher (P10 accelerated)
  *
  * Copyright 2023- IBM Corp. All rights reserved.
  */
 
-#include <crypto/chacha.h>
 #include <crypto/internal/simd.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/sizes.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 
@@ -46,19 +44,14 @@ static void chacha_p10_do_8x(struct chacha_state *state, u8 *dst, const u8 *src,
 
 	if (bytes > 0)
 		chacha_crypt_generic(state, dst, src, bytes, nrounds);
 }
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
-{
-	hchacha_block_generic(state, out, nrounds);
-}
-EXPORT_SYMBOL(hchacha_block_arch);
+#define hchacha_block_arch hchacha_block_generic /* not implemented yet */
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	if (!static_branch_likely(&have_p10) || bytes <= CHACHA_BLOCK_SIZE ||
 	    !crypto_simd_usable())
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
@@ -72,23 +65,12 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		bytes -= todo;
 		src += todo;
 		dst += todo;
 	} while (bytes);
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int __init chacha_p10_init(void)
+#define chacha_mod_init_arch chacha_mod_init_arch
+static void chacha_mod_init_arch(void)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		static_branch_enable(&have_p10);
-	return 0;
-}
-subsys_initcall(chacha_p10_init);
-
-static void __exit chacha_p10_exit(void)
-{
 }
-module_exit(chacha_p10_exit);
-
-MODULE_DESCRIPTION("ChaCha stream cipher (P10 accelerated)");
-MODULE_AUTHOR("Danny Tsen <dtsen@linux.ibm.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/riscv/Kconfig b/lib/crypto/riscv/Kconfig
deleted file mode 100644
index bc7a43f33eb3a..0000000000000
--- a/lib/crypto/riscv/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_CHACHA_RISCV64
-	tristate
-	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
diff --git a/lib/crypto/riscv/Makefile b/lib/crypto/riscv/Makefile
deleted file mode 100644
index e27b78f317fc8..0000000000000
--- a/lib/crypto/riscv/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_CHACHA_RISCV64) += chacha-riscv64.o
-chacha-riscv64-y := chacha-riscv64-glue.o chacha-riscv64-zvkb.o
diff --git a/lib/crypto/riscv/chacha-riscv64-glue.c b/lib/crypto/riscv/chacha.h
similarity index 61%
rename from lib/crypto/riscv/chacha-riscv64-glue.c
rename to lib/crypto/riscv/chacha.h
index a15f0aca3fc43..5c000c6aef4be 100644
--- a/lib/crypto/riscv/chacha-riscv64-glue.c
+++ b/lib/crypto/riscv/chacha.h
@@ -1,34 +1,27 @@
-// SPDX-License-Identifier: GPL-2.0-only
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ChaCha stream cipher (RISC-V optimized)
  *
  * Copyright (C) 2023 SiFive, Inc.
  * Author: Jerry Shih <jerry.shih@sifive.com>
  */
 
 #include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/chacha.h>
 #include <crypto/internal/simd.h>
 #include <linux/linkage.h>
-#include <linux/module.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_zvkb);
 
 asmlinkage void chacha_zvkb(struct chacha_state *state, const u8 *in, u8 *out,
 			    size_t nblocks, int nrounds);
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
-{
-	hchacha_block_generic(state, out, nrounds);
-}
-EXPORT_SYMBOL(hchacha_block_arch);
+#define hchacha_block_arch hchacha_block_generic /* not implemented yet */
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	u8 block_buffer[CHACHA_BLOCK_SIZE];
 	unsigned int full_blocks = bytes / CHACHA_BLOCK_SIZE;
 	unsigned int tail_bytes = bytes % CHACHA_BLOCK_SIZE;
 
@@ -46,24 +39,13 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		chacha_zvkb(state, block_buffer, block_buffer, 1, nrounds);
 		memcpy(dst, block_buffer, tail_bytes);
 	}
 	kernel_vector_end();
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int __init riscv64_chacha_mod_init(void)
+#define chacha_mod_init_arch chacha_mod_init_arch
+static void chacha_mod_init_arch(void)
 {
 	if (riscv_isa_extension_available(NULL, ZVKB) &&
 	    riscv_vector_vlen() >= 128)
 		static_branch_enable(&use_zvkb);
-	return 0;
-}
-subsys_initcall(riscv64_chacha_mod_init);
-
-static void __exit riscv64_chacha_mod_exit(void)
-{
 }
-module_exit(riscv64_chacha_mod_exit);
-
-MODULE_DESCRIPTION("ChaCha stream cipher (RISC-V optimized)");
-MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
-MODULE_LICENSE("GPL");
diff --git a/lib/crypto/s390/Kconfig b/lib/crypto/s390/Kconfig
deleted file mode 100644
index 069b355fe51aa..0000000000000
--- a/lib/crypto/s390/Kconfig
+++ /dev/null
@@ -1,7 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-config CRYPTO_CHACHA_S390
-	tristate
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/s390/Makefile b/lib/crypto/s390/Makefile
deleted file mode 100644
index 06c2cf77178ef..0000000000000
--- a/lib/crypto/s390/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-
-obj-$(CONFIG_CRYPTO_CHACHA_S390) += chacha_s390.o
-chacha_s390-y := chacha-glue.o chacha-s390.o
diff --git a/lib/crypto/s390/chacha-glue.c b/lib/crypto/s390/chacha.h
similarity index 55%
rename from lib/crypto/s390/chacha-glue.c
rename to lib/crypto/s390/chacha.h
index d8137387fe28f..fd9c4a4223656 100644
--- a/lib/crypto/s390/chacha-glue.c
+++ b/lib/crypto/s390/chacha.h
@@ -1,34 +1,23 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ChaCha stream cipher (s390 optimized)
  *
  * Copyright IBM Corp. 2021
  */
 
-#define KMSG_COMPONENT "chacha_s390"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
-
-#include <crypto/chacha.h>
 #include <linux/cpufeature.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/sizes.h>
 #include <asm/fpu.h>
 #include "chacha-s390.h"
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
-{
-	/* TODO: implement hchacha_block_arch() in assembly */
-	hchacha_block_generic(state, out, nrounds);
-}
-EXPORT_SYMBOL(hchacha_block_arch);
+#define hchacha_block_arch hchacha_block_generic /* not implemented yet */
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	/* s390 chacha20 implementation has 20 rounds hard-coded,
 	 * it cannot handle a block of data or less, but otherwise
 	 * it can handle data of arbitrary size
 	 */
@@ -43,9 +32,5 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 
 		state->x[12] += round_up(bytes, CHACHA_BLOCK_SIZE) /
 				CHACHA_BLOCK_SIZE;
 	}
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
-
-MODULE_DESCRIPTION("ChaCha stream cipher (s390 optimized)");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/x86/Kconfig b/lib/crypto/x86/Kconfig
index 24dc9a59b2728..eb47da71aa6b6 100644
--- a/lib/crypto/x86/Kconfig
+++ b/lib/crypto/x86/Kconfig
@@ -9,12 +9,5 @@ config CRYPTO_BLAKE2S_X86
 	  BLAKE2s cryptographic hash function (RFC 7693)
 
 	  Architecture: x86_64 using:
 	  - SSSE3 (Supplemental SSE3)
 	  - AVX-512 (Advanced Vector Extensions-512)
-
-config CRYPTO_CHACHA20_X86_64
-	tristate
-	depends on 64BIT
-	default CRYPTO_LIB_CHACHA
-	select CRYPTO_LIB_CHACHA_GENERIC
-	select CRYPTO_ARCH_HAVE_LIB_CHACHA
diff --git a/lib/crypto/x86/Makefile b/lib/crypto/x86/Makefile
index 16c9d76f99472..4454556b243e7 100644
--- a/lib/crypto/x86/Makefile
+++ b/lib/crypto/x86/Makefile
@@ -1,7 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_BLAKE2S_X86) += libblake2s-x86_64.o
 libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
-
-obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha-x86_64.o
-chacha-x86_64-y := chacha-avx2-x86_64.o chacha-ssse3-x86_64.o chacha-avx512vl-x86_64.o chacha_glue.o
diff --git a/lib/crypto/x86/chacha_glue.c b/lib/crypto/x86/chacha.h
similarity index 87%
rename from lib/crypto/x86/chacha_glue.c
rename to lib/crypto/x86/chacha.h
index de7da9d512af2..10cf8f1c569dc 100644
--- a/lib/crypto/x86/chacha_glue.c
+++ b/lib/crypto/x86/chacha.h
@@ -1,17 +1,15 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ChaCha and HChaCha functions (x86_64 optimized)
  *
  * Copyright (C) 2015 Martin Willi
  */
 
 #include <asm/simd.h>
-#include <crypto/chacha.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/sizes.h>
 
 asmlinkage void chacha_block_xor_ssse3(const struct chacha_state *state,
 				       u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
@@ -124,25 +122,24 @@ static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 		chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
 		state->x[12]++;
 	}
 }
 
-void hchacha_block_arch(const struct chacha_state *state,
-			u32 out[HCHACHA_OUT_WORDS], int nrounds)
+static void hchacha_block_arch(const struct chacha_state *state,
+			       u32 out[HCHACHA_OUT_WORDS], int nrounds)
 {
 	if (!static_branch_likely(&chacha_use_simd)) {
 		hchacha_block_generic(state, out, nrounds);
 	} else {
 		kernel_fpu_begin();
 		hchacha_block_ssse3(state, out, nrounds);
 		kernel_fpu_end();
 	}
 }
-EXPORT_SYMBOL(hchacha_block_arch);
 
-void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
-		       unsigned int bytes, int nrounds)
+static void chacha_crypt_arch(struct chacha_state *state, u8 *dst,
+			      const u8 *src, unsigned int bytes, int nrounds)
 {
 	if (!static_branch_likely(&chacha_use_simd) ||
 	    bytes <= CHACHA_BLOCK_SIZE)
 		return chacha_crypt_generic(state, dst, src, bytes, nrounds);
 
@@ -156,16 +153,16 @@ void chacha_crypt_arch(struct chacha_state *state, u8 *dst, const u8 *src,
 		bytes -= todo;
 		src += todo;
 		dst += todo;
 	} while (bytes);
 }
-EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int __init chacha_simd_mod_init(void)
+#define chacha_mod_init_arch chacha_mod_init_arch
+static void chacha_mod_init_arch(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
-		return 0;
+		return;
 
 	static_branch_enable(&chacha_use_simd);
 
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    boot_cpu_has(X86_FEATURE_AVX2) &&
@@ -174,17 +171,6 @@ static int __init chacha_simd_mod_init(void)
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
 		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
 			static_branch_enable(&chacha_use_avx512vl);
 	}
-	return 0;
 }
-subsys_initcall(chacha_simd_mod_init);
-
-static void __exit chacha_simd_mod_exit(void)
-{
-}
-module_exit(chacha_simd_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("ChaCha and HChaCha functions (x86_64 optimized)");
-- 
2.50.1

