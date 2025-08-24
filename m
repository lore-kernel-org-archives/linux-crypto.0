Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89791F91D6;
	Sun, 24 Aug 2025 02:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756004352; cv=none; b=s5mhNdd6ccMlFWWuSbkaPZDul4PKSE5Pv/nwrUz3ApL9U9HFAFo7MGUreNIr0NcB8HZ/cpU1KNUXbhzCxFnahdhobtmzEioiM+kcH6XV554qlNs6+MH9JR5MPan6GThweJfi5Nz9oCv+gWH4Yyl57WrMg2pIoWZVjwU9+mPTKmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756004352; c=relaxed/simple;
	bh=aVpeB2ogsdEwfvCGKVHNKlnuOKrOIqqJMx9fW9tTFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8eTnS9dXmefYBeV1BVTEx19YW+Cf/b+0BA9tP+Oa/WkMk8eIJQ23UWCjnblfEfIPFRS/El30RcUQqsevnLch/zhEs0oiR0BJLbstBq4/Iku3UCVQgCcidihfeFQYUh0ScMTphjRcqWJNXVVeAvFhp4gAS0F7EYMxmhaXABhjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRAEriPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRAEriPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AFFC2BC9E;
	Sun, 24 Aug 2025 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756004351;
	bh=aVpeB2ogsdEwfvCGKVHNKlnuOKrOIqqJMx9fW9tTFB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRAEriPFskSv4zTR7qKv1dJPIOqwKqPuvXatC1MpYGidXpP9ob8auZ7K+H94lunaO
	 DgAx+GFEgC8C8yNV17bSQ3uPz+/3JWdViw6mwFIvETiJSPHC//Ktjx/0oCPjIvivQE
	 9CKmSYRdy3yLQ4c0wuzDnIzk8G8F+feeMe8twoZUVOS7i5/IabDqVQeM/mlNWPaqZj
	 EvLn8gfz510ZU8FCfM5auphkHrEUSY6bLM4kWMcYtThnu8//GmT2X9wXsoCJoDCOsf
	 WRod/ZUqgMZe988VleUNaM+USKV+lLUpJGciky05U7FKwDbmq5ZopCQ2p9R/+EfR7j
	 XJgyyDGmuX8+w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Andy Polyakov <appro@cryptogams.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/3] lib/crypto: poly1305: Consolidate into single module
Date: Sat, 23 Aug 2025 22:57:35 -0400
Message-ID: <20250824025736.148576-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250824025736.148576-1-ebiggers@kernel.org>
References: <20250824025736.148576-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Consolidate the Poly1305 code into a single module, similar to various
other algorithms (SHA-1, SHA-256, SHA-512, etc.):

- Each arch now provides a header file lib/crypto/$(SRCARCH)/poly1305.h,
  replacing lib/crypto/$(SRCARCH)/poly1305*.c.  The header defines
  poly1305_block_init(), poly1305_blocks(), poly1305_emit(), and
  optionally poly1305_mod_init_arch().  It is included by
  lib/crypto/poly1305.c, and thus the code gets built into the single
  libpoly1305 module, with improved inlining in some cases.

- Whether arch-optimized Poly1305 is buildable is now controlled
  centrally by lib/crypto/Kconfig instead of by
  lib/crypto/$(SRCARCH)/Kconfig.  The conditions for enabling it remain
  the same as before, and it remains enabled by default.  (The PPC64 one
  remains unconditionally disabled due to 'depends on BROKEN'.)

- Any additional arch-specific translation units for the optimized
  Poly1305 code, such as assembly files, are now compiled by
  lib/crypto/Makefile instead of lib/crypto/$(SRCARCH)/Makefile.

A special consideration is needed because the Adiantum code uses the
poly1305_core_*() functions directly.  For now, just carry forward that
approach.  This means retaining the CRYPTO_LIB_POLY1305_GENERIC kconfig
symbol, and keeping the poly1305_core_*() functions in separate
translation units.  So it's not quite as streamlined I've done with the
other hash functions, but we still get a single libpoly1305 module.

Note: to see the diff from the arm, arm64, and x86 .c files to the new
.h files, view this commit with 'git show -M10'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                                |  2 +
 include/crypto/internal/poly1305.h            | 16 ++--
 lib/crypto/Kconfig                            | 50 ++++++------
 lib/crypto/Makefile                           | 58 +++++++++++--
 lib/crypto/arm/Kconfig                        |  5 --
 lib/crypto/arm/Makefile                       | 18 -----
 lib/crypto/arm/poly1305-armv4.pl              |  3 +-
 lib/crypto/arm/poly1305-glue.c                | 69 ----------------
 lib/crypto/arm/poly1305.h                     | 53 ++++++++++++
 lib/crypto/arm64/Kconfig                      |  6 --
 lib/crypto/arm64/Makefile                     | 13 ---
 lib/crypto/arm64/poly1305-armv8.pl            |  3 +
 lib/crypto/arm64/poly1305-glue.c              | 67 ---------------
 lib/crypto/arm64/poly1305.h                   | 50 ++++++++++++
 lib/crypto/mips/Kconfig                       |  5 --
 lib/crypto/mips/Makefile                      | 14 ----
 lib/crypto/mips/poly1305-glue.c               | 27 -------
 lib/crypto/mips/poly1305-mips.pl              |  8 +-
 lib/crypto/mips/poly1305.h                    | 14 ++++
 lib/crypto/poly1305-generic.c                 | 25 ------
 lib/crypto/poly1305.c                         | 81 ++++++++++++-------
 lib/crypto/powerpc/Kconfig                    |  8 --
 lib/crypto/powerpc/Makefile                   |  3 -
 .../{poly1305-p10-glue.c => poly1305.h}       | 34 +++-----
 lib/crypto/x86/Kconfig                        |  6 --
 lib/crypto/x86/Makefile                       | 10 ---
 lib/crypto/x86/poly1305-x86_64-cryptogams.pl  | 33 +++-----
 .../x86/{poly1305_glue.c => poly1305.h}       | 41 ++++------
 28 files changed, 298 insertions(+), 424 deletions(-)
 delete mode 100644 lib/crypto/arm/poly1305-glue.c
 create mode 100644 lib/crypto/arm/poly1305.h
 delete mode 100644 lib/crypto/arm64/poly1305-glue.c
 create mode 100644 lib/crypto/arm64/poly1305.h
 delete mode 100644 lib/crypto/mips/poly1305-glue.c
 create mode 100644 lib/crypto/mips/poly1305.h
 delete mode 100644 lib/crypto/poly1305-generic.c
 rename lib/crypto/powerpc/{poly1305-p10-glue.c => poly1305.h} (66%)
 rename lib/crypto/x86/{poly1305_glue.c => poly1305.h} (85%)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1575dbec084d6..e8ccf5f51b855 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -607,10 +607,11 @@ endmenu
 menu "Length-preserving ciphers and modes"
 
 config CRYPTO_ADIANTUM
 	tristate "Adiantum"
 	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC
 	select CRYPTO_NHPOLY1305
 	select CRYPTO_MANAGER
 	help
 	  Adiantum tweakable, length-preserving encryption mode
@@ -768,10 +769,11 @@ config CRYPTO_XTS
 	  multiple of 16 bytes.
 
 config CRYPTO_NHPOLY1305
 	tristate
 	select CRYPTO_HASH
+	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC
 
 endmenu
 
 menu "AEAD (authenticated encryption with associated data) ciphers"
diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index c60315f475623..a72fff409ab85 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -28,28 +28,26 @@ void poly1305_core_blocks(struct poly1305_state *state,
 			  const struct poly1305_core_key *key, const void *src,
 			  unsigned int nblocks, u32 hibit);
 void poly1305_core_emit(const struct poly1305_state *state, const u32 nonce[4],
 			void *dst);
 
-void poly1305_block_init_arch(struct poly1305_block_state *state,
-			      const u8 raw_key[POLY1305_BLOCK_SIZE]);
-void poly1305_block_init_generic(struct poly1305_block_state *state,
-				 const u8 raw_key[POLY1305_BLOCK_SIZE]);
-void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
-			  unsigned int len, u32 padbit);
+static inline void
+poly1305_block_init_generic(struct poly1305_block_state *desc,
+			    const u8 raw_key[POLY1305_BLOCK_SIZE])
+{
+	poly1305_core_init(&desc->h);
+	poly1305_core_setkey(&desc->core_r, raw_key);
+}
 
 static inline void poly1305_blocks_generic(struct poly1305_block_state *state,
 					   const u8 *src, unsigned int len,
 					   u32 padbit)
 {
 	poly1305_core_blocks(&state->h, &state->core_r, src,
 			     len / POLY1305_BLOCK_SIZE, padbit);
 }
 
-void poly1305_emit_arch(const struct poly1305_state *state,
-			u8 digest[POLY1305_DIGEST_SIZE], const u32 nonce[4]);
-
 static inline void poly1305_emit_generic(const struct poly1305_state *state,
 					 u8 digest[POLY1305_DIGEST_SIZE],
 					 const u32 nonce[4])
 {
 	poly1305_core_emit(state, nonce, digest);
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 79b848448e07f..9991118c41a9d 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -112,40 +112,44 @@ config CRYPTO_LIB_MD5_ARCH
 	depends on CRYPTO_LIB_MD5 && !UML
 	default y if MIPS && CPU_CAVIUM_OCTEON
 	default y if PPC
 	default y if SPARC64
 
+config CRYPTO_LIB_POLY1305
+	tristate
+	help
+	  The Poly1305 library functions.  Select this if your module uses any
+	  of the functions from <crypto/poly1305.h>.
+
+config CRYPTO_LIB_POLY1305_ARCH
+	bool
+	depends on CRYPTO_LIB_POLY1305 && !UML
+	default y if ARM
+	default y if ARM64 && KERNEL_MODE_NEON
+	default y if MIPS
+	# The PPC64 code needs to be fixed to work in softirq context.
+	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX && BROKEN
+	default y if X86_64
+
+# This symbol controls the inclusion of the Poly1305 generic code.  This differs
+# from most of the other algorithms, which handle the generic code
+# "automatically" via __maybe_unused.  This is needed so that the Adiantum code,
+# which calls the poly1305_core_*() functions directly, can enable them.
+config CRYPTO_LIB_POLY1305_GENERIC
+	bool
+	depends on CRYPTO_LIB_POLY1305
+	# Enable if there's no arch impl or the arch impl requires the generic
+	# impl as a fallback.  (Or if selected explicitly.)
+	default y if !CRYPTO_LIB_POLY1305_ARCH || PPC64
+
 config CRYPTO_LIB_POLY1305_RSIZE
 	int
 	default 2 if MIPS
 	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 1
 
-config CRYPTO_ARCH_HAVE_LIB_POLY1305
-	bool
-	help
-	  Declares whether the architecture provides an arch-specific
-	  accelerated implementation of the Poly1305 library interface,
-	  either builtin or as a module.
-
-config CRYPTO_LIB_POLY1305_GENERIC
-	tristate
-	default CRYPTO_LIB_POLY1305 if !CRYPTO_ARCH_HAVE_LIB_POLY1305
-	help
-	  This symbol can be selected by arch implementations of the Poly1305
-	  library interface that require the generic code as a fallback, e.g.,
-	  for SIMD implementations. If no arch specific implementation is
-	  enabled, this implementation serves the users of CRYPTO_LIB_POLY1305.
-
-config CRYPTO_LIB_POLY1305
-	tristate
-	help
-	  Enable the Poly1305 library interface. This interface may be fulfilled
-	  by either the generic implementation or an arch-specific one, if one
-	  is available and enabled.
-
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_UTILS
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index d362636a22d38..5b3e181a83b62 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -69,17 +69,63 @@ libmd5-$(CONFIG_PPC) += powerpc/md5-asm.o
 libmd5-$(CONFIG_SPARC) += sparc/md5_asm.o
 endif # CONFIG_CRYPTO_LIB_MD5_ARCH
 
 ################################################################################
 
-obj-$(CONFIG_CRYPTO_LIB_POLY1305)		+= libpoly1305.o
-libpoly1305-y					+= poly1305.o
+obj-$(CONFIG_CRYPTO_LIB_POLY1305) += libpoly1305.o
+libpoly1305-y := poly1305.o
+ifeq ($(CONFIG_ARCH_SUPPORTS_INT128),y)
+libpoly1305-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC) += poly1305-donna64.o
+else
+libpoly1305-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC) += poly1305-donna32.o
+endif
+
+ifeq ($(CONFIG_CRYPTO_LIB_POLY1305_ARCH),y)
+CFLAGS_poly1305.o += -I$(src)/$(SRCARCH)
+
+ifeq ($(CONFIG_ARM),y)
+libpoly1305-y += arm/poly1305-core.o
+$(obj)/arm/poly1305-core.S: $(src)/arm/poly1305-armv4.pl
+	$(call cmd,perlasm)
+# massage the perlasm code a bit so we only get the NEON routine if we need it
+poly1305-aflags-$(CONFIG_CPU_V7) := -U__LINUX_ARM_ARCH__ -D__LINUX_ARM_ARCH__=5
+poly1305-aflags-$(CONFIG_KERNEL_MODE_NEON) := -U__LINUX_ARM_ARCH__ -D__LINUX_ARM_ARCH__=7
+AFLAGS_arm/poly1305-core.o += $(poly1305-aflags-y) $(aflags-thumb2-y)
+endif
+
+ifeq ($(CONFIG_ARM64),y)
+libpoly1305-y += arm64/poly1305-core.o
+$(obj)/arm64/poly1305-core.S: $(src)/arm64/poly1305-armv8.pl
+	$(call cmd,perlasm_with_args)
+endif
+
+ifeq ($(CONFIG_MIPS),y)
+libpoly1305-y += mips/poly1305-core.o
+poly1305-perlasm-flavour-$(CONFIG_32BIT) := o32
+poly1305-perlasm-flavour-$(CONFIG_64BIT) := 64
+quiet_cmd_perlasm_poly1305 = PERLASM $@
+      cmd_perlasm_poly1305 = $(PERL) $< $(poly1305-perlasm-flavour-y) $@
+# Use if_changed instead of cmd, in case the flavour changed.
+$(obj)/mips/poly1305-core.S: $(src)/mips/poly1305-mips.pl FORCE
+	$(call if_changed,perlasm_poly1305)
+endif
 
-obj-$(CONFIG_CRYPTO_LIB_POLY1305_GENERIC)	+= libpoly1305-generic.o
-libpoly1305-generic-y				:= poly1305-donna32.o
-libpoly1305-generic-$(CONFIG_ARCH_SUPPORTS_INT128) := poly1305-donna64.o
-libpoly1305-generic-y				+= poly1305-generic.o
+libpoly1305-$(CONFIG_PPC) += powerpc/poly1305-p10le_64.o
+
+ifeq ($(CONFIG_X86),y)
+libpoly1305-y += x86/poly1305-x86_64-cryptogams.o
+$(obj)/x86/poly1305-x86_64-cryptogams.S: $(src)/x86/poly1305-x86_64-cryptogams.pl
+	$(call cmd,perlasm)
+endif
+
+endif # CONFIG_CRYPTO_LIB_POLY1305_ARCH
+
+# clean-files must be defined unconditionally
+clean-files += arm/poly1305-core.S \
+	       arm64/poly1305-core.S \
+	       mips/poly1305-core.S \
+	       x86/poly1305-x86_64-cryptogams.S
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_SHA1) += libsha1.o
 libsha1-y := sha1.o
diff --git a/lib/crypto/arm/Kconfig b/lib/crypto/arm/Kconfig
index e8444fd0aae30..0d821e282c645 100644
--- a/lib/crypto/arm/Kconfig
+++ b/lib/crypto/arm/Kconfig
@@ -15,10 +15,5 @@ config CRYPTO_BLAKE2S_ARM
 
 config CRYPTO_CHACHA20_NEON
 	tristate
 	default CRYPTO_LIB_CHACHA
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-
-config CRYPTO_POLY1305_ARM
-	tristate
-	default CRYPTO_LIB_POLY1305
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
diff --git a/lib/crypto/arm/Makefile b/lib/crypto/arm/Makefile
index 4c042a4c77ed6..9f70e61d419e2 100644
--- a/lib/crypto/arm/Makefile
+++ b/lib/crypto/arm/Makefile
@@ -4,23 +4,5 @@ obj-$(CONFIG_CRYPTO_BLAKE2S_ARM) += libblake2s-arm.o
 libblake2s-arm-y := blake2s-core.o blake2s-glue.o
 
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 chacha-neon-y := chacha-scalar-core.o chacha-glue.o
 chacha-neon-$(CONFIG_KERNEL_MODE_NEON) += chacha-neon-core.o
-
-obj-$(CONFIG_CRYPTO_POLY1305_ARM) += poly1305-arm.o
-poly1305-arm-y := poly1305-core.o poly1305-glue.o
-
-quiet_cmd_perl = PERL    $@
-      cmd_perl = $(PERL) $(<) > $(@)
-
-$(obj)/%-core.S: $(src)/%-armv4.pl
-	$(call cmd,perl)
-
-clean-files += poly1305-core.S
-
-aflags-thumb2-$(CONFIG_THUMB2_KERNEL)  := -U__thumb2__ -D__thumb2__=1
-
-# massage the perlasm code a bit so we only get the NEON routine if we need it
-poly1305-aflags-$(CONFIG_CPU_V7) := -U__LINUX_ARM_ARCH__ -D__LINUX_ARM_ARCH__=5
-poly1305-aflags-$(CONFIG_KERNEL_MODE_NEON) := -U__LINUX_ARM_ARCH__ -D__LINUX_ARM_ARCH__=7
-AFLAGS_poly1305-core.o += $(poly1305-aflags-y) $(aflags-thumb2-y)
diff --git a/lib/crypto/arm/poly1305-armv4.pl b/lib/crypto/arm/poly1305-armv4.pl
index dd7a996361a71..34c11b7b44bd7 100644
--- a/lib/crypto/arm/poly1305-armv4.pl
+++ b/lib/crypto/arm/poly1305-armv4.pl
@@ -41,13 +41,12 @@ $code.=<<___;
 #ifndef	__KERNEL__
 # include "arm_arch.h"
 #else
 # define __ARM_ARCH__ __LINUX_ARM_ARCH__
 # define __ARM_MAX_ARCH__ __LINUX_ARM_ARCH__
-# define poly1305_init   poly1305_block_init_arch
+# define poly1305_init   poly1305_block_init
 # define poly1305_blocks poly1305_blocks_arm
-# define poly1305_emit   poly1305_emit_arch
 #endif
 
 #if defined(__thumb2__)
 .syntax	unified
 .thumb
diff --git a/lib/crypto/arm/poly1305-glue.c b/lib/crypto/arm/poly1305-glue.c
deleted file mode 100644
index 9e513e319e37c..0000000000000
--- a/lib/crypto/arm/poly1305-glue.c
+++ /dev/null
@@ -1,69 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * OpenSSL/Cryptogams accelerated Poly1305 transform for ARM
- *
- * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
- */
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-#include <crypto/internal/poly1305.h>
-#include <linux/cpufeature.h>
-#include <linux/jump_label.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/unaligned.h>
-
-asmlinkage void poly1305_block_init_arch(
-	struct poly1305_block_state *state,
-	const u8 raw_key[POLY1305_BLOCK_SIZE]);
-EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
-asmlinkage void poly1305_blocks_arm(struct poly1305_block_state *state,
-				    const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
-				     const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
-				   u8 digest[POLY1305_DIGEST_SIZE],
-				   const u32 nonce[4]);
-EXPORT_SYMBOL_GPL(poly1305_emit_arch);
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
-
-void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
-			  unsigned int len, u32 padbit)
-{
-	len = round_down(len, POLY1305_BLOCK_SIZE);
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		do {
-			unsigned int todo = min_t(unsigned int, len, SZ_4K);
-
-			kernel_neon_begin();
-			poly1305_blocks_neon(state, src, todo, padbit);
-			kernel_neon_end();
-
-			len -= todo;
-			src += todo;
-		} while (len);
-	} else
-		poly1305_blocks_arm(state, src, len, padbit);
-}
-EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
-
-static int __init arm_poly1305_mod_init(void)
-{
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    (elf_hwcap & HWCAP_NEON))
-		static_branch_enable(&have_neon);
-	return 0;
-}
-subsys_initcall(arm_poly1305_mod_init);
-
-static void __exit arm_poly1305_mod_exit(void)
-{
-}
-module_exit(arm_poly1305_mod_exit);
-
-MODULE_DESCRIPTION("Accelerated Poly1305 transform for ARM");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/arm/poly1305.h b/lib/crypto/arm/poly1305.h
new file mode 100644
index 0000000000000..0021cf368307c
--- /dev/null
+++ b/lib/crypto/arm/poly1305.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * OpenSSL/Cryptogams accelerated Poly1305 transform for ARM
+ *
+ * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <linux/cpufeature.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+
+asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
+				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
+asmlinkage void poly1305_blocks_arm(struct poly1305_block_state *state,
+				    const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
+				     const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit(const struct poly1305_state *state,
+			      u8 digest[POLY1305_DIGEST_SIZE],
+			      const u32 nonce[4]);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
+static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
+			    unsigned int len, u32 padbit)
+{
+	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
+	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
+		do {
+			unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+			kernel_neon_begin();
+			poly1305_blocks_neon(state, src, todo, padbit);
+			kernel_neon_end();
+
+			len -= todo;
+			src += todo;
+		} while (len);
+	} else
+		poly1305_blocks_arm(state, src, len, padbit);
+}
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+#define poly1305_mod_init_arch poly1305_mod_init_arch
+static void poly1305_mod_init_arch(void)
+{
+	if (elf_hwcap & HWCAP_NEON)
+		static_branch_enable(&have_neon);
+}
+#endif /* CONFIG_KERNEL_MODE_NEON */
diff --git a/lib/crypto/arm64/Kconfig b/lib/crypto/arm64/Kconfig
index 0b903ef524d85..07c8a4f0ab03a 100644
--- a/lib/crypto/arm64/Kconfig
+++ b/lib/crypto/arm64/Kconfig
@@ -4,11 +4,5 @@ config CRYPTO_CHACHA20_NEON
 	tristate
 	depends on KERNEL_MODE_NEON
 	default CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-
-config CRYPTO_POLY1305_NEON
-	tristate
-	depends on KERNEL_MODE_NEON
-	default CRYPTO_LIB_POLY1305
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
diff --git a/lib/crypto/arm64/Makefile b/lib/crypto/arm64/Makefile
index 6207088397a73..d49cceca3d1ca 100644
--- a/lib/crypto/arm64/Makefile
+++ b/lib/crypto/arm64/Makefile
@@ -1,17 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
-
-obj-$(CONFIG_CRYPTO_POLY1305_NEON) += poly1305-neon.o
-poly1305-neon-y := poly1305-core.o poly1305-glue.o
-AFLAGS_poly1305-core.o += -Dpoly1305_init=poly1305_block_init_arch
-AFLAGS_poly1305-core.o += -Dpoly1305_emit=poly1305_emit_arch
-
-quiet_cmd_perlasm = PERLASM $@
-      cmd_perlasm = $(PERL) $(<) void $(@)
-
-$(obj)/%-core.S: $(src)/%-armv8.pl
-	$(call cmd,perlasm)
-
-clean-files += poly1305-core.S
diff --git a/lib/crypto/arm64/poly1305-armv8.pl b/lib/crypto/arm64/poly1305-armv8.pl
index 22c9069c06505..f1930c6b55cee 100644
--- a/lib/crypto/arm64/poly1305-armv8.pl
+++ b/lib/crypto/arm64/poly1305-armv8.pl
@@ -48,10 +48,13 @@ my ($h0,$h1,$h2,$r0,$r1,$s1,$t0,$t1,$d0,$d1,$d2) = map("x$_",(4..14));
 
 $code.=<<___;
 #ifndef __KERNEL__
 # include "arm_arch.h"
 .extern	OPENSSL_armcap_P
+#else
+# define poly1305_init   poly1305_block_init
+# define poly1305_blocks poly1305_blocks_arm64
 #endif
 
 .text
 
 // forward "declarations" are required for Apple
diff --git a/lib/crypto/arm64/poly1305-glue.c b/lib/crypto/arm64/poly1305-glue.c
deleted file mode 100644
index d4a522e7d25a9..0000000000000
--- a/lib/crypto/arm64/poly1305-glue.c
+++ /dev/null
@@ -1,67 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * OpenSSL/Cryptogams accelerated Poly1305 transform for arm64
- *
- * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
- */
-
-#include <asm/hwcap.h>
-#include <asm/neon.h>
-#include <asm/simd.h>
-#include <crypto/internal/poly1305.h>
-#include <linux/cpufeature.h>
-#include <linux/jump_label.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/unaligned.h>
-
-asmlinkage void poly1305_block_init_arch(
-	struct poly1305_block_state *state,
-	const u8 raw_key[POLY1305_BLOCK_SIZE]);
-EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
-asmlinkage void poly1305_blocks(struct poly1305_block_state *state,
-				const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
-				     const u8 *src, u32 len, u32 hibit);
-asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
-				   u8 digest[POLY1305_DIGEST_SIZE],
-				   const u32 nonce[4]);
-EXPORT_SYMBOL_GPL(poly1305_emit_arch);
-
-static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
-
-void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
-			  unsigned int len, u32 padbit)
-{
-	len = round_down(len, POLY1305_BLOCK_SIZE);
-	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
-		do {
-			unsigned int todo = min_t(unsigned int, len, SZ_4K);
-
-			kernel_neon_begin();
-			poly1305_blocks_neon(state, src, todo, padbit);
-			kernel_neon_end();
-
-			len -= todo;
-			src += todo;
-		} while (len);
-	} else
-		poly1305_blocks(state, src, len, padbit);
-}
-EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
-
-static int __init neon_poly1305_mod_init(void)
-{
-	if (cpu_have_named_feature(ASIMD))
-		static_branch_enable(&have_neon);
-	return 0;
-}
-subsys_initcall(neon_poly1305_mod_init);
-
-static void __exit neon_poly1305_mod_exit(void)
-{
-}
-module_exit(neon_poly1305_mod_exit);
-
-MODULE_DESCRIPTION("Poly1305 authenticator (ARM64 optimized)");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/arm64/poly1305.h b/lib/crypto/arm64/poly1305.h
new file mode 100644
index 0000000000000..aed5921ccd9a1
--- /dev/null
+++ b/lib/crypto/arm64/poly1305.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * OpenSSL/Cryptogams accelerated Poly1305 transform for arm64
+ *
+ * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/hwcap.h>
+#include <asm/neon.h>
+#include <asm/simd.h>
+#include <linux/cpufeature.h>
+#include <linux/jump_label.h>
+#include <linux/kernel.h>
+
+asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
+				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
+asmlinkage void poly1305_blocks_arm64(struct poly1305_block_state *state,
+				      const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
+				     const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit(const struct poly1305_state *state,
+			      u8 digest[POLY1305_DIGEST_SIZE],
+			      const u32 nonce[4]);
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
+
+static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
+			    unsigned int len, u32 padbit)
+{
+	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
+		do {
+			unsigned int todo = min_t(unsigned int, len, SZ_4K);
+
+			kernel_neon_begin();
+			poly1305_blocks_neon(state, src, todo, padbit);
+			kernel_neon_end();
+
+			len -= todo;
+			src += todo;
+		} while (len);
+	} else
+		poly1305_blocks_arm64(state, src, len, padbit);
+}
+
+#define poly1305_mod_init_arch poly1305_mod_init_arch
+static void poly1305_mod_init_arch(void)
+{
+	if (cpu_have_named_feature(ASIMD))
+		static_branch_enable(&have_neon);
+}
diff --git a/lib/crypto/mips/Kconfig b/lib/crypto/mips/Kconfig
index 0670a170c1be0..94c1a0892c203 100644
--- a/lib/crypto/mips/Kconfig
+++ b/lib/crypto/mips/Kconfig
@@ -3,10 +3,5 @@
 config CRYPTO_CHACHA_MIPS
 	tristate
 	depends on CPU_MIPS32_R2
 	default CRYPTO_LIB_CHACHA
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-
-config CRYPTO_POLY1305_MIPS
-	tristate
-	default CRYPTO_LIB_POLY1305
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
diff --git a/lib/crypto/mips/Makefile b/lib/crypto/mips/Makefile
index 804488c7adedc..b5ea0e25c21ef 100644
--- a/lib/crypto/mips/Makefile
+++ b/lib/crypto/mips/Makefile
@@ -1,19 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_CHACHA_MIPS) += chacha-mips.o
 chacha-mips-y := chacha-core.o chacha-glue.o
 AFLAGS_chacha-core.o += -O2 # needed to fill branch delay slots
-
-obj-$(CONFIG_CRYPTO_POLY1305_MIPS) += poly1305-mips.o
-poly1305-mips-y := poly1305-core.o poly1305-glue.o
-
-perlasm-flavour-$(CONFIG_32BIT) := o32
-perlasm-flavour-$(CONFIG_64BIT) := 64
-
-quiet_cmd_perlasm = PERLASM $@
-      cmd_perlasm = $(PERL) $(<) $(perlasm-flavour-y) $(@)
-
-$(obj)/poly1305-core.S: $(src)/poly1305-mips.pl FORCE
-	$(call if_changed,perlasm)
-
-targets += poly1305-core.S
diff --git a/lib/crypto/mips/poly1305-glue.c b/lib/crypto/mips/poly1305-glue.c
deleted file mode 100644
index 002f50f710aba..0000000000000
--- a/lib/crypto/mips/poly1305-glue.c
+++ /dev/null
@@ -1,27 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * OpenSSL/Cryptogams accelerated Poly1305 transform for MIPS
- *
- * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
- */
-
-#include <crypto/internal/poly1305.h>
-#include <linux/cpufeature.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/unaligned.h>
-
-asmlinkage void poly1305_block_init_arch(
-	struct poly1305_block_state *state,
-	const u8 raw_key[POLY1305_BLOCK_SIZE]);
-EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
-asmlinkage void poly1305_blocks_arch(struct poly1305_block_state *state,
-				     const u8 *src, u32 len, u32 hibit);
-EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
-asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
-				   u8 digest[POLY1305_DIGEST_SIZE],
-				   const u32 nonce[4]);
-EXPORT_SYMBOL_GPL(poly1305_emit_arch);
-
-MODULE_DESCRIPTION("Poly1305 transform (MIPS accelerated");
-MODULE_LICENSE("GPL v2");
diff --git a/lib/crypto/mips/poly1305-mips.pl b/lib/crypto/mips/poly1305-mips.pl
index 399f10c3e3850..71347f34f4f9f 100644
--- a/lib/crypto/mips/poly1305-mips.pl
+++ b/lib/crypto/mips/poly1305-mips.pl
@@ -91,13 +91,11 @@ $code.=<<___;
 # define mflo(rd,rs,rt)	mflo	rd
 # define mfhi(rd,rs,rt)	mfhi	rd
 #endif
 
 #ifdef	__KERNEL__
-# define poly1305_init   poly1305_block_init_arch
-# define poly1305_blocks poly1305_blocks_arch
-# define poly1305_emit   poly1305_emit_arch
+# define poly1305_init   poly1305_block_init
 #endif
 
 #if defined(__MIPSEB__) && !defined(MIPSEB)
 # define MIPSEB
 #endif
@@ -563,13 +561,11 @@ $code.=<<___;
 # define mflo(rd,rs,rt)	mflo	rd
 # define mfhi(rd,rs,rt)	mfhi	rd
 #endif
 
 #ifdef	__KERNEL__
-# define poly1305_init   poly1305_block_init_arch
-# define poly1305_blocks poly1305_blocks_arch
-# define poly1305_emit   poly1305_emit_arch
+# define poly1305_init   poly1305_block_init
 #endif
 
 #if defined(__MIPSEB__) && !defined(MIPSEB)
 # define MIPSEB
 #endif
diff --git a/lib/crypto/mips/poly1305.h b/lib/crypto/mips/poly1305.h
new file mode 100644
index 0000000000000..85de450f1a93d
--- /dev/null
+++ b/lib/crypto/mips/poly1305.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * OpenSSL/Cryptogams accelerated Poly1305 transform for MIPS
+ *
+ * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
+				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
+asmlinkage void poly1305_blocks(struct poly1305_block_state *state,
+				const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit(const struct poly1305_state *state,
+			      u8 digest[POLY1305_DIGEST_SIZE],
+			      const u32 nonce[4]);
diff --git a/lib/crypto/poly1305-generic.c b/lib/crypto/poly1305-generic.c
deleted file mode 100644
index 71a16c5c538b4..0000000000000
--- a/lib/crypto/poly1305-generic.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Poly1305 authenticator algorithm, RFC7539
- *
- * Copyright (C) 2015 Martin Willi
- *
- * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
- */
-
-#include <crypto/internal/poly1305.h>
-#include <linux/export.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-void poly1305_block_init_generic(struct poly1305_block_state *desc,
-				 const u8 raw_key[POLY1305_BLOCK_SIZE])
-{
-	poly1305_core_init(&desc->h);
-	poly1305_core_setkey(&desc->core_r, raw_key);
-}
-EXPORT_SYMBOL_GPL(poly1305_block_init_generic);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("Poly1305 algorithm (generic implementation)");
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index a6dc182b6c22d..f313ccc4b4dd2 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -5,71 +5,96 @@
  * Copyright (C) 2015 Martin Willi
  *
  * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
  */
 
-#include <crypto/internal/blockhash.h>
 #include <crypto/internal/poly1305.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
+#ifdef CONFIG_CRYPTO_LIB_POLY1305_ARCH
+#include "poly1305.h" /* $(SRCARCH)/poly1305.h */
+#else
+#define poly1305_block_init	poly1305_block_init_generic
+#define poly1305_blocks		poly1305_blocks_generic
+#define poly1305_emit		poly1305_emit_generic
+#endif
+
 void poly1305_init(struct poly1305_desc_ctx *desc,
 		   const u8 key[POLY1305_KEY_SIZE])
 {
 	desc->s[0] = get_unaligned_le32(key + 16);
 	desc->s[1] = get_unaligned_le32(key + 20);
 	desc->s[2] = get_unaligned_le32(key + 24);
 	desc->s[3] = get_unaligned_le32(key + 28);
 	desc->buflen = 0;
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_block_init_arch(&desc->state, key);
-	else
-		poly1305_block_init_generic(&desc->state, key);
+	poly1305_block_init(&desc->state, key);
 }
 EXPORT_SYMBOL(poly1305_init);
 
-static inline void poly1305_blocks(struct poly1305_block_state *state,
-				   const u8 *src, unsigned int len)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_blocks_arch(state, src, len, 1);
-	else
-		poly1305_blocks_generic(state, src, len, 1);
-}
-
 void poly1305_update(struct poly1305_desc_ctx *desc,
 		     const u8 *src, unsigned int nbytes)
 {
-	desc->buflen = BLOCK_HASH_UPDATE(poly1305_blocks, &desc->state,
-					 src, nbytes, POLY1305_BLOCK_SIZE,
-					 desc->buf, desc->buflen);
+	if (desc->buflen + nbytes >= POLY1305_BLOCK_SIZE) {
+		unsigned int bulk_len;
+
+		if (desc->buflen) {
+			unsigned int l = POLY1305_BLOCK_SIZE - desc->buflen;
+
+			memcpy(&desc->buf[desc->buflen], src, l);
+			src += l;
+			nbytes -= l;
+
+			poly1305_blocks(&desc->state, desc->buf,
+					POLY1305_BLOCK_SIZE, 1);
+			desc->buflen = 0;
+		}
+
+		bulk_len = round_down(nbytes, POLY1305_BLOCK_SIZE);
+		nbytes %= POLY1305_BLOCK_SIZE;
+
+		if (bulk_len) {
+			poly1305_blocks(&desc->state, src, bulk_len, 1);
+			src += bulk_len;
+		}
+	}
+	if (nbytes) {
+		memcpy(&desc->buf[desc->buflen], src, nbytes);
+		desc->buflen += nbytes;
+	}
 }
 EXPORT_SYMBOL(poly1305_update);
 
 void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
 {
 	if (unlikely(desc->buflen)) {
 		desc->buf[desc->buflen++] = 1;
 		memset(desc->buf + desc->buflen, 0,
 		       POLY1305_BLOCK_SIZE - desc->buflen);
-		if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-			poly1305_blocks_arch(&desc->state, desc->buf,
-					     POLY1305_BLOCK_SIZE, 0);
-		else
-			poly1305_blocks_generic(&desc->state, desc->buf,
-						POLY1305_BLOCK_SIZE, 0);
+		poly1305_blocks(&desc->state, desc->buf, POLY1305_BLOCK_SIZE,
+				0);
 	}
 
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305))
-		poly1305_emit_arch(&desc->state.h, dst, desc->s);
-	else
-		poly1305_emit_generic(&desc->state.h, dst, desc->s);
+	poly1305_emit(&desc->state.h, dst, desc->s);
 	*desc = (struct poly1305_desc_ctx){};
 }
 EXPORT_SYMBOL(poly1305_final);
 
+#ifdef poly1305_mod_init_arch
+static int __init poly1305_mod_init(void)
+{
+	poly1305_mod_init_arch();
+	return 0;
+}
+subsys_initcall(poly1305_mod_init);
+
+static void __exit poly1305_mod_exit(void)
+{
+}
+module_exit(poly1305_mod_exit);
+#endif
+
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("Poly1305 authenticator algorithm, RFC7539");
diff --git a/lib/crypto/powerpc/Kconfig b/lib/crypto/powerpc/Kconfig
index 2eaeb7665a6a0..e41012a61876e 100644
--- a/lib/crypto/powerpc/Kconfig
+++ b/lib/crypto/powerpc/Kconfig
@@ -4,13 +4,5 @@ config CRYPTO_CHACHA20_P10
 	tristate
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
 	default CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-
-config CRYPTO_POLY1305_P10
-	tristate
-	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
-	depends on BROKEN # Needs to be fixed to work in softirq context
-	default CRYPTO_LIB_POLY1305
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
-	select CRYPTO_LIB_POLY1305_GENERIC
diff --git a/lib/crypto/powerpc/Makefile b/lib/crypto/powerpc/Makefile
index 5709ae14258a0..778a04edd226c 100644
--- a/lib/crypto/powerpc/Makefile
+++ b/lib/crypto/powerpc/Makefile
@@ -1,7 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_CHACHA20_P10) += chacha-p10-crypto.o
 chacha-p10-crypto-y := chacha-p10-glue.o chacha-p10le-8x.o
-
-obj-$(CONFIG_CRYPTO_POLY1305_P10) += poly1305-p10-crypto.o
-poly1305-p10-crypto-y := poly1305-p10-glue.o poly1305-p10le_64.o
diff --git a/lib/crypto/powerpc/poly1305-p10-glue.c b/lib/crypto/powerpc/poly1305.h
similarity index 66%
rename from lib/crypto/powerpc/poly1305-p10-glue.c
rename to lib/crypto/powerpc/poly1305.h
index 184a71f9c1dee..b8ed098a0e95f 100644
--- a/lib/crypto/powerpc/poly1305-p10-glue.c
+++ b/lib/crypto/powerpc/poly1305.h
@@ -1,17 +1,15 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Poly1305 authenticator algorithm, RFC7539.
  *
  * Copyright 2023- IBM Corp. All rights reserved.
  */
 #include <asm/switch_to.h>
-#include <crypto/internal/poly1305.h>
 #include <linux/cpufeature.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/unaligned.h>
 
 asmlinkage void poly1305_p10le_4blocks(struct poly1305_block_state *state, const u8 *m, u32 mlen);
 asmlinkage void poly1305_64s(struct poly1305_block_state *state, const u8 *m, u32 mlen, int highbit);
 asmlinkage void poly1305_emit_64(const struct poly1305_state *state, const u32 nonce[4], u8 digest[POLY1305_DIGEST_SIZE]);
@@ -28,24 +26,23 @@ static void vsx_end(void)
 {
 	disable_kernel_vsx();
 	preempt_enable();
 }
 
-void poly1305_block_init_arch(struct poly1305_block_state *dctx,
-			      const u8 raw_key[POLY1305_BLOCK_SIZE])
+static void poly1305_block_init(struct poly1305_block_state *dctx,
+				const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
 	if (!static_key_enabled(&have_p10))
 		return poly1305_block_init_generic(dctx, raw_key);
 
 	dctx->h = (struct poly1305_state){};
 	dctx->core_r.key.r64[0] = get_unaligned_le64(raw_key + 0);
 	dctx->core_r.key.r64[1] = get_unaligned_le64(raw_key + 8);
 }
-EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
 
-void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
-			  unsigned int len, u32 padbit)
+static void poly1305_blocks(struct poly1305_block_state *state, const u8 *src,
+			    unsigned int len, u32 padbit)
 {
 	if (!static_key_enabled(&have_p10))
 		return poly1305_blocks_generic(state, src, len, padbit);
 	vsx_begin();
 	if (len >= POLY1305_BLOCK_SIZE * 4) {
@@ -58,33 +55,20 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 		len -= POLY1305_BLOCK_SIZE;
 		src += POLY1305_BLOCK_SIZE;
 	}
 	vsx_end();
 }
-EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-void poly1305_emit_arch(const struct poly1305_state *state,
-			u8 digest[POLY1305_DIGEST_SIZE],
-			const u32 nonce[4])
+static void poly1305_emit(const struct poly1305_state *state,
+			  u8 digest[POLY1305_DIGEST_SIZE], const u32 nonce[4])
 {
 	if (!static_key_enabled(&have_p10))
 		return poly1305_emit_generic(state, digest, nonce);
 	poly1305_emit_64(state, nonce, digest);
 }
-EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-static int __init poly1305_p10_init(void)
+#define poly1305_mod_init_arch poly1305_mod_init_arch
+static void poly1305_mod_init_arch(void)
 {
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		static_branch_enable(&have_p10);
-	return 0;
 }
-subsys_initcall(poly1305_p10_init);
-
-static void __exit poly1305_p10_exit(void)
-{
-}
-module_exit(poly1305_p10_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Danny Tsen <dtsen@linux.ibm.com>");
-MODULE_DESCRIPTION("Optimized Poly1305 for P10");
diff --git a/lib/crypto/x86/Kconfig b/lib/crypto/x86/Kconfig
index 546fe2afe0b51..24dc9a59b2728 100644
--- a/lib/crypto/x86/Kconfig
+++ b/lib/crypto/x86/Kconfig
@@ -16,11 +16,5 @@ config CRYPTO_CHACHA20_X86_64
 	tristate
 	depends on 64BIT
 	default CRYPTO_LIB_CHACHA
 	select CRYPTO_LIB_CHACHA_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CHACHA
-
-config CRYPTO_POLY1305_X86_64
-	tristate
-	depends on 64BIT
-	default CRYPTO_LIB_POLY1305
-	select CRYPTO_ARCH_HAVE_LIB_POLY1305
diff --git a/lib/crypto/x86/Makefile b/lib/crypto/x86/Makefile
index c2ff8c5f1046e..16c9d76f99472 100644
--- a/lib/crypto/x86/Makefile
+++ b/lib/crypto/x86/Makefile
@@ -3,15 +3,5 @@
 obj-$(CONFIG_CRYPTO_BLAKE2S_X86) += libblake2s-x86_64.o
 libblake2s-x86_64-y := blake2s-core.o blake2s-glue.o
 
 obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha-x86_64.o
 chacha-x86_64-y := chacha-avx2-x86_64.o chacha-ssse3-x86_64.o chacha-avx512vl-x86_64.o chacha_glue.o
-
-obj-$(CONFIG_CRYPTO_POLY1305_X86_64) += poly1305-x86_64.o
-poly1305-x86_64-y := poly1305-x86_64-cryptogams.o poly1305_glue.o
-targets += poly1305-x86_64-cryptogams.S
-
-quiet_cmd_perlasm = PERLASM $@
-      cmd_perlasm = $(PERL) $< > $@
-
-$(obj)/%.S: $(src)/%.pl FORCE
-	$(call if_changed,perlasm)
diff --git a/lib/crypto/x86/poly1305-x86_64-cryptogams.pl b/lib/crypto/x86/poly1305-x86_64-cryptogams.pl
index 501827254fed7..409ec6955733a 100644
--- a/lib/crypto/x86/poly1305-x86_64-cryptogams.pl
+++ b/lib/crypto/x86/poly1305-x86_64-cryptogams.pl
@@ -116,34 +116,21 @@ sub declare_function() {
 		$code .= ".align	$align\n";
 		$code .= "$name:\n";
 	}
 }
 
-sub declare_typed_function() {
-	my ($name, $align, $nargs) = @_;
-	if($kernel) {
-		$code .= "SYM_TYPED_FUNC_START($name)\n";
-		$code .= ".L$name:\n";
-	} else {
-		$code .= ".globl	$name\n";
-		$code .= ".type	$name,\@function,$nargs\n";
-		$code .= ".align	$align\n";
-		$code .= "$name:\n";
-	}
-}
-
 sub end_function() {
 	my ($name) = @_;
 	if($kernel) {
 		$code .= "SYM_FUNC_END($name)\n";
 	} else {
 		$code .= ".size   $name,.-$name\n";
 	}
 }
 
 $code.=<<___ if $kernel;
-#include <linux/cfi_types.h>
+#include <linux/linkage.h>
 ___
 
 if ($avx) {
 $code.=<<___ if $kernel;
 .section .rodata
@@ -247,18 +234,18 @@ $code.=<<___;
 .text
 ___
 $code.=<<___ if (!$kernel);
 .extern	OPENSSL_ia32cap_P
 
-.globl	poly1305_block_init_arch
-.hidden	poly1305_block_init_arch
+.globl	poly1305_init_x86_64
+.hidden	poly1305_init_x86_64
 .globl	poly1305_blocks_x86_64
 .hidden	poly1305_blocks_x86_64
 .globl	poly1305_emit_x86_64
 .hidden	poly1305_emit_x86_64
 ___
-&declare_typed_function("poly1305_block_init_arch", 32, 3);
+&declare_function("poly1305_init_x86_64", 32, 3);
 $code.=<<___;
 	xor	%eax,%eax
 	mov	%rax,0($ctx)		# initialize hash value
 	mov	%rax,8($ctx)
 	mov	%rax,16($ctx)
@@ -309,11 +296,11 @@ ___
 $code.=<<___;
 	mov	\$1,%eax
 .Lno_key:
 	RET
 ___
-&end_function("poly1305_block_init_arch");
+&end_function("poly1305_init_x86_64");
 
 &declare_function("poly1305_blocks_x86_64", 32, 4);
 $code.=<<___;
 .cfi_startproc
 .Lblocks:
@@ -4116,13 +4103,13 @@ avx_handler:
 	RET
 .size	avx_handler,.-avx_handler
 
 .section	.pdata
 .align	4
-	.rva	.LSEH_begin_poly1305_block_init_arch
-	.rva	.LSEH_end_poly1305_block_init_arch
-	.rva	.LSEH_info_poly1305_block_init_arch
+	.rva	.LSEH_begin_poly1305_init_x86_64
+	.rva	.LSEH_end_poly1305_init_x86_64
+	.rva	.LSEH_info_poly1305_init_x86_64
 
 	.rva	.LSEH_begin_poly1305_blocks_x86_64
 	.rva	.LSEH_end_poly1305_blocks_x86_64
 	.rva	.LSEH_info_poly1305_blocks_x86_64
 
@@ -4166,14 +4153,14 @@ $code.=<<___ if ($avx>2);
 	.rva	.LSEH_info_poly1305_blocks_avx512
 ___
 $code.=<<___;
 .section	.xdata
 .align	8
-.LSEH_info_poly1305_block_init_arch:
+.LSEH_info_poly1305_init_x86_64:
 	.byte	9,0,0,0
 	.rva	se_handler
-	.rva	.LSEH_begin_poly1305_block_init_arch,.LSEH_begin_poly1305_block_init_arch
+	.rva	.LSEH_begin_poly1305_init_x86_64,.LSEH_begin_poly1305_init_x86_64
 
 .LSEH_info_poly1305_blocks_x86_64:
 	.byte	9,0,0,0
 	.rva	se_handler
 	.rva	.Lblocks_body,.Lblocks_epilogue
diff --git a/lib/crypto/x86/poly1305_glue.c b/lib/crypto/x86/poly1305.h
similarity index 85%
rename from lib/crypto/x86/poly1305_glue.c
rename to lib/crypto/x86/poly1305.h
index deb5841cb0ada..ee92e3740a787 100644
--- a/lib/crypto/x86/poly1305_glue.c
+++ b/lib/crypto/x86/poly1305.h
@@ -1,18 +1,15 @@
-// SPDX-License-Identifier: GPL-2.0 OR MIT
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
 /*
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #include <asm/cpu_device_id.h>
 #include <asm/fpu/api.h>
-#include <crypto/internal/poly1305.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/sizes.h>
-#include <linux/unaligned.h>
 
 struct poly1305_arch_internal {
 	union {
 		struct {
 			u32 h[5];
@@ -59,14 +56,12 @@ static void convert_to_base2_64(void *ctx)
 	state->hs[2] += ULT(state->hs[1], cy);
 #undef ULT
 	state->is_base2_26 = 0;
 }
 
-asmlinkage void poly1305_block_init_arch(
-	struct poly1305_block_state *state,
-	const u8 raw_key[POLY1305_BLOCK_SIZE]);
-EXPORT_SYMBOL_GPL(poly1305_block_init_arch);
+asmlinkage void poly1305_init_x86_64(struct poly1305_block_state *state,
+				     const u8 raw_key[POLY1305_BLOCK_SIZE]);
 asmlinkage void poly1305_blocks_x86_64(struct poly1305_arch_internal *ctx,
 				       const u8 *inp,
 				       const size_t len, const u32 padbit);
 asmlinkage void poly1305_emit_x86_64(const struct poly1305_state *ctx,
 				     u8 mac[POLY1305_DIGEST_SIZE],
@@ -86,12 +81,18 @@ asmlinkage void poly1305_blocks_avx512(struct poly1305_arch_internal *ctx,
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
 
-void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *inp,
-			  unsigned int len, u32 padbit)
+static void poly1305_block_init(struct poly1305_block_state *state,
+				const u8 raw_key[POLY1305_BLOCK_SIZE])
+{
+	poly1305_init_x86_64(state, raw_key);
+}
+
+static void poly1305_blocks(struct poly1305_block_state *state, const u8 *inp,
+			    unsigned int len, u32 padbit)
 {
 	struct poly1305_arch_internal *ctx =
 		container_of(&state->h.h, struct poly1305_arch_internal, h);
 
 	/* SIMD disables preemption, so relax after processing each page. */
@@ -127,23 +128,22 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *inp,
 
 		len -= bytes;
 		inp += bytes;
 	} while (len);
 }
-EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
 
-void poly1305_emit_arch(const struct poly1305_state *ctx,
-			u8 mac[POLY1305_DIGEST_SIZE], const u32 nonce[4])
+static void poly1305_emit(const struct poly1305_state *ctx,
+			  u8 mac[POLY1305_DIGEST_SIZE], const u32 nonce[4])
 {
 	if (!static_branch_likely(&poly1305_use_avx))
 		poly1305_emit_x86_64(ctx, mac, nonce);
 	else
 		poly1305_emit_avx(ctx, mac, nonce);
 }
-EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-static int __init poly1305_simd_mod_init(void)
+#define poly1305_mod_init_arch poly1305_mod_init_arch
+static void poly1305_mod_init_arch(void)
 {
 	if (boot_cpu_has(X86_FEATURE_AVX) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		static_branch_enable(&poly1305_use_avx);
 	if (boot_cpu_has(X86_FEATURE_AVX) && boot_cpu_has(X86_FEATURE_AVX2) &&
@@ -153,17 +153,6 @@ static int __init poly1305_simd_mod_init(void)
 	    boot_cpu_has(X86_FEATURE_AVX512F) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL) &&
 	    /* Skylake downclocks unacceptably much when using zmm, but later generations are fast. */
 	    boot_cpu_data.x86_vfm != INTEL_SKYLAKE_X)
 		static_branch_enable(&poly1305_use_avx512);
-	return 0;
 }
-subsys_initcall(poly1305_simd_mod_init);
-
-static void __exit poly1305_simd_mod_exit(void)
-{
-}
-module_exit(poly1305_simd_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-MODULE_DESCRIPTION("Poly1305 authenticator");
-- 
2.50.1

