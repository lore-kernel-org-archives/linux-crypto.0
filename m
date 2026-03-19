Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E435A3AB;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901160; cv=none; b=YURSsvGxL/J8NGkHHIPLryHAmpX03/YllGKrenKlmX6IkCUQHantmpak/nx4x8d3piKIQBZkCaS7d6tr/ajnvgDNZfgLv5qexpnK7DYnV8KTcMUDt6Xxzl0jd8s4M8L0+dbhR4T6IhoPDG3FGm2WjL1efIEYh8Q4Ox0yno6dkUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901160; c=relaxed/simple;
	bh=EHqY05M4yxDEHTjZmJV/a9yk3e/LPZ0/CaDs3VLZU30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnjRlUmnC0bi0l5shB5qD/cb/r1QH8955ccjj9+qql/db2d8ghS2q/doYdDq/BdzZHYotdfvYa1iukUIK24vz9+nUOm//FRD29VvFDvxG4TeJd1kWMCCzNOqXJWEjQ9tFyYOtyGv/iqPonS9cAZjvmoolqxBbvv7cpqg36AHWVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lTH7i7+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTH7i7+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8ADC2BCC9;
	Thu, 19 Mar 2026 06:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901159;
	bh=EHqY05M4yxDEHTjZmJV/a9yk3e/LPZ0/CaDs3VLZU30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTH7i7+AKBT1f9uNWK9OSxjGE6ei2uH1GkKTY8+xpc9FlDr0DMQuJePlqkkCjJ2Ke
	 4rTUYwQJXc03wMLPswL/AR9mPhfGP9L/OgsAQ5FvQi5fFWf5NZQLcNCPAFwe00vASm
	 OD4sOQkZmhds255aXuAxBqpIw9TJhTyObvxYrEVqhBVuXqzokmLzvzCFmzOtVGwY1y
	 e8G6vltDnKmM0HY6wmzwZNzVJwVdDPoWPsJEDmiWaQ2TaTNgGdUZe9c6FhltliBFwU
	 cB75GRdjB2+y2h3JCenbHseWg69IMMnG/OxeOzVDTFgLuPPlwbfFvi7i3EwtsbZkIC
	 /IXCz1t+GxFdQ==
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
Subject: [PATCH 11/19] lib/crypto: powerpc/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:12 -0700
Message-ID: <20260319061723.1140720-12-ebiggers@kernel.org>
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

Remove the "p8_ghash" crypto_shash algorithm.  Move the corresponding
assembly code into lib/crypto/, and wire it up to the GHASH library.

This makes the GHASH library be optimized for POWER8.  It also greatly
reduces the amount of powerpc-specific glue code that is needed, and it
fixes the issue where this optimized GHASH code was disabled by default.

Note that previously the C code defined the POWER8 GHASH key format as
"u128 htable[16]", despite the assembly code only using four entries.
Fix the C code to use the correct key format.  To fulfill the library
API contract, also make the key preparation work in all contexts.

Note that the POWER8 assembly code takes the accumulator in GHASH
format, but it actually byte-reflects it to get it into POLYVAL format.
The library already works with POLYVAL natively.  For now, just wire up
this existing code by converting it to/from GHASH format in C code.
This should be cleaned up to eliminate the unnecessary conversion later.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 MAINTAINERS                                   |   4 +-
 arch/powerpc/crypto/Kconfig                   |   5 +-
 arch/powerpc/crypto/Makefile                  |   8 +-
 arch/powerpc/crypto/aesp8-ppc.h               |   1 -
 arch/powerpc/crypto/ghash.c                   | 160 ------------------
 arch/powerpc/crypto/vmx.c                     |  10 +-
 include/crypto/gf128hash.h                    |   4 +
 lib/crypto/Kconfig                            |   1 +
 lib/crypto/Makefile                           |  25 ++-
 lib/crypto/powerpc/.gitignore                 |   1 +
 lib/crypto/powerpc/gf128hash.h                | 109 ++++++++++++
 .../crypto/powerpc}/ghashp8-ppc.pl            |   1 +
 12 files changed, 143 insertions(+), 186 deletions(-)
 delete mode 100644 arch/powerpc/crypto/ghash.c
 create mode 100644 lib/crypto/powerpc/gf128hash.h
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/ghashp8-ppc.pl (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77fdfcb55f06..f088f4085653 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12265,14 +12265,14 @@ F:	arch/powerpc/crypto/Makefile
 F:	arch/powerpc/crypto/aes.c
 F:	arch/powerpc/crypto/aes_cbc.c
 F:	arch/powerpc/crypto/aes_ctr.c
 F:	arch/powerpc/crypto/aes_xts.c
 F:	arch/powerpc/crypto/aesp8-ppc.*
-F:	arch/powerpc/crypto/ghash.c
-F:	arch/powerpc/crypto/ghashp8-ppc.pl
 F:	arch/powerpc/crypto/ppc-xlate.pl
 F:	arch/powerpc/crypto/vmx.c
+F:	lib/crypto/powerpc/gf128hash.h
+F:	lib/crypto/powerpc/ghashp8-ppc.pl
 
 IBM ServeRAID RAID DRIVER
 S:	Orphan
 F:	drivers/scsi/ips.*
 
diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 2d056f1fc90f..b247f7ed973e 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -52,14 +52,13 @@ config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
 	depends on CRYPTO_DEV_VMX
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_CTR
-	select CRYPTO_GHASH
 	select CRYPTO_XTS
 	default m
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
-	  This module supports acceleration for AES and GHASH in hardware. If you
-	  choose 'M' here, this module will be called vmx-crypto.
+	  This module supports acceleration for AES in hardware. If you choose
+	  'M' here, this module will be called vmx-crypto.
 
 endmenu
diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index 3ac0886282a2..a1fe102a90ae 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -9,11 +9,11 @@ obj-$(CONFIG_CRYPTO_AES_PPC_SPE) += aes-ppc-spe.o
 obj-$(CONFIG_CRYPTO_AES_GCM_P10) += aes-gcm-p10-crypto.o
 obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 
 aes-ppc-spe-y := aes-spe-glue.o
 aes-gcm-p10-crypto-y := aes-gcm-p10-glue.o aes-gcm-p10.o ghashp10-ppc.o aesp10-ppc.o
-vmx-crypto-objs := vmx.o ghashp8-ppc.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
+vmx-crypto-objs := vmx.o aes_cbc.o aes_ctr.o aes_xts.o
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
 override flavour := linux-ppc64le
 else
 ifdef CONFIG_PPC64_ELF_ABI_V2
@@ -24,16 +24,12 @@ endif
 endif
 
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $< $(flavour) > $@
 
-targets += aesp10-ppc.S ghashp10-ppc.S ghashp8-ppc.S
+targets += aesp10-ppc.S ghashp10-ppc.S
 
 $(obj)/aesp10-ppc.S $(obj)/ghashp10-ppc.S: $(obj)/%.S: $(src)/%.pl FORCE
 	$(call if_changed,perl)
 
-$(obj)/ghashp8-ppc.S: $(obj)/%.S: $(src)/%.pl FORCE
-	$(call if_changed,perl)
-
 OBJECT_FILES_NON_STANDARD_aesp10-ppc.o := y
 OBJECT_FILES_NON_STANDARD_ghashp10-ppc.o := y
-OBJECT_FILES_NON_STANDARD_ghashp8-ppc.o := y
diff --git a/arch/powerpc/crypto/aesp8-ppc.h b/arch/powerpc/crypto/aesp8-ppc.h
index 6862c605cc33..c68f5b6965fa 100644
--- a/arch/powerpc/crypto/aesp8-ppc.h
+++ b/arch/powerpc/crypto/aesp8-ppc.h
@@ -1,8 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/types.h>
 #include <crypto/aes.h>
 
-extern struct shash_alg p8_ghash_alg;
 extern struct skcipher_alg p8_aes_cbc_alg;
 extern struct skcipher_alg p8_aes_ctr_alg;
 extern struct skcipher_alg p8_aes_xts_alg;
diff --git a/arch/powerpc/crypto/ghash.c b/arch/powerpc/crypto/ghash.c
deleted file mode 100644
index 7308735bdb33..000000000000
--- a/arch/powerpc/crypto/ghash.c
+++ /dev/null
@@ -1,160 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * GHASH routines supporting VMX instructions on the Power 8
- *
- * Copyright (C) 2015, 2019 International Business Machines Inc.
- *
- * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
- *
- * Extended by Daniel Axtens <dja@axtens.net> to replace the fallback
- * mechanism. The new approach is based on arm64 code, which is:
- *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
- */
-
-#include "aesp8-ppc.h"
-#include <asm/switch_to.h>
-#include <crypto/aes.h>
-#include <crypto/gf128mul.h>
-#include <crypto/ghash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/uaccess.h>
-
-void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
-void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
-void gcm_ghash_p8(u64 Xi[2], const u128 htable[16],
-		  const u8 *in, size_t len);
-
-struct p8_ghash_ctx {
-	/* key used by vector asm */
-	u128 htable[16];
-	/* key used by software fallback */
-	be128 key;
-};
-
-struct p8_ghash_desc_ctx {
-	u64 shash[2];
-};
-
-static int p8_ghash_init(struct shash_desc *desc)
-{
-	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx->shash, 0, GHASH_DIGEST_SIZE);
-	return 0;
-}
-
-static int p8_ghash_setkey(struct crypto_shash *tfm, const u8 *key,
-			   unsigned int keylen)
-{
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(tfm));
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	preempt_disable();
-	pagefault_disable();
-	enable_kernel_vsx();
-	gcm_init_p8(ctx->htable, (const u64 *) key);
-	disable_kernel_vsx();
-	pagefault_enable();
-	preempt_enable();
-
-	memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static inline void __ghash_block(struct p8_ghash_ctx *ctx,
-				 struct p8_ghash_desc_ctx *dctx,
-				 const u8 *src)
-{
-	if (crypto_simd_usable()) {
-		preempt_disable();
-		pagefault_disable();
-		enable_kernel_vsx();
-		gcm_ghash_p8(dctx->shash, ctx->htable, src, GHASH_BLOCK_SIZE);
-		disable_kernel_vsx();
-		pagefault_enable();
-		preempt_enable();
-	} else {
-		crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
-		gf128mul_lle((be128 *)dctx->shash, &ctx->key);
-	}
-}
-
-static inline int __ghash_blocks(struct p8_ghash_ctx *ctx,
-				 struct p8_ghash_desc_ctx *dctx,
-				 const u8 *src, unsigned int srclen)
-{
-	int remain = srclen - round_down(srclen, GHASH_BLOCK_SIZE);
-
-	srclen -= remain;
-	if (crypto_simd_usable()) {
-		preempt_disable();
-		pagefault_disable();
-		enable_kernel_vsx();
-		gcm_ghash_p8(dctx->shash, ctx->htable,
-				src, srclen);
-		disable_kernel_vsx();
-		pagefault_enable();
-		preempt_enable();
-	} else {
-		do {
-			crypto_xor((u8 *)dctx->shash, src, GHASH_BLOCK_SIZE);
-			gf128mul_lle((be128 *)dctx->shash, &ctx->key);
-			srclen -= GHASH_BLOCK_SIZE;
-			src += GHASH_BLOCK_SIZE;
-		} while (srclen);
-	}
-
-	return remain;
-}
-
-static int p8_ghash_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen)
-{
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
-	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	return __ghash_blocks(ctx, dctx, src, srclen);
-}
-
-static int p8_ghash_finup(struct shash_desc *desc, const u8 *src,
-			  unsigned int len, u8 *out)
-{
-	struct p8_ghash_ctx *ctx = crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
-	struct p8_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	if (len) {
-		u8 buf[GHASH_BLOCK_SIZE] = {};
-
-		memcpy(buf, src, len);
-		__ghash_block(ctx, dctx, buf);
-		memzero_explicit(buf, sizeof(buf));
-	}
-	memcpy(out, dctx->shash, GHASH_DIGEST_SIZE);
-	return 0;
-}
-
-struct shash_alg p8_ghash_alg = {
-	.digestsize = GHASH_DIGEST_SIZE,
-	.init = p8_ghash_init,
-	.update = p8_ghash_update,
-	.finup = p8_ghash_finup,
-	.setkey = p8_ghash_setkey,
-	.descsize = sizeof(struct p8_ghash_desc_ctx),
-	.base = {
-		 .cra_name = "ghash",
-		 .cra_driver_name = "p8_ghash",
-		 .cra_priority = 1000,
-		 .cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		 .cra_blocksize = GHASH_BLOCK_SIZE,
-		 .cra_ctxsize = sizeof(struct p8_ghash_ctx),
-		 .cra_module = THIS_MODULE,
-	},
-};
diff --git a/arch/powerpc/crypto/vmx.c b/arch/powerpc/crypto/vmx.c
index 7d2beb774f99..08da5311dfdf 100644
--- a/arch/powerpc/crypto/vmx.c
+++ b/arch/powerpc/crypto/vmx.c
@@ -12,26 +12,21 @@
 #include <linux/types.h>
 #include <linux/err.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <asm/cputable.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
 #include "aesp8-ppc.h"
 
 static int __init p8_init(void)
 {
 	int ret;
 
-	ret = crypto_register_shash(&p8_ghash_alg);
-	if (ret)
-		goto err;
-
 	ret = crypto_register_skcipher(&p8_aes_cbc_alg);
 	if (ret)
-		goto err_unregister_ghash;
+		goto err;
 
 	ret = crypto_register_skcipher(&p8_aes_ctr_alg);
 	if (ret)
 		goto err_unregister_aes_cbc;
 
@@ -43,22 +38,19 @@ static int __init p8_init(void)
 
 err_unregister_aes_ctr:
 	crypto_unregister_skcipher(&p8_aes_ctr_alg);
 err_unregister_aes_cbc:
 	crypto_unregister_skcipher(&p8_aes_cbc_alg);
-err_unregister_ghash:
-	crypto_unregister_shash(&p8_ghash_alg);
 err:
 	return ret;
 }
 
 static void __exit p8_exit(void)
 {
 	crypto_unregister_skcipher(&p8_aes_xts_alg);
 	crypto_unregister_skcipher(&p8_aes_ctr_alg);
 	crypto_unregister_skcipher(&p8_aes_cbc_alg);
-	crypto_unregister_shash(&p8_ghash_alg);
 }
 
 module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, p8_init);
 module_exit(p8_exit);
 
diff --git a/include/crypto/gf128hash.h b/include/crypto/gf128hash.h
index 5090fbaa87f8..650652dd6003 100644
--- a/include/crypto/gf128hash.h
+++ b/include/crypto/gf128hash.h
@@ -39,10 +39,14 @@ struct polyval_elem {
  * struct ghash_key - Prepared key for GHASH
  *
  * Use ghash_preparekey() to initialize this.
  */
 struct ghash_key {
+#if defined(CONFIG_CRYPTO_LIB_GF128HASH_ARCH) && defined(CONFIG_PPC64)
+	/** @htable: GHASH key format used by the POWER8 assembly code */
+	u64 htable[4][2];
+#endif
 	/** @h: The hash key H, in POLYVAL format */
 	struct polyval_elem h;
 };
 
 /**
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4f1a79883a56..f54add7d9070 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -119,10 +119,11 @@ config CRYPTO_LIB_GF128HASH
 config CRYPTO_LIB_GF128HASH_ARCH
 	bool
 	depends on CRYPTO_LIB_GF128HASH && !UML
 	default y if ARM && KERNEL_MODE_NEON
 	default y if ARM64
+	default y if PPC64 && VSX
 	default y if X86_64
 
 config CRYPTO_LIB_MD5
 	tristate
 	help
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 4ce0bac8fd93..8a9084188778 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -6,10 +6,14 @@ quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) > $(@)
 
 quiet_cmd_perlasm_with_args = PERLASM $@
       cmd_perlasm_with_args = $(PERL) $(<) void $(@)
 
+ppc64-perlasm-flavour-y := linux-ppc64
+ppc64-perlasm-flavour-$(CONFIG_PPC64_ELF_ABI_V2) := linux-ppc64-elfv2
+ppc64-perlasm-flavour-$(CONFIG_CPU_LITTLE_ENDIAN) := linux-ppc64le
+
 obj-$(CONFIG_KUNIT)				+= tests/
 
 obj-$(CONFIG_CRYPTO_HASH_INFO)			+= hash_info.o
 
 obj-$(CONFIG_CRYPTO_LIB_UTILS)			+= libcryptoutils.o
@@ -34,15 +38,12 @@ libaes-y += powerpc/aes-spe-core.o \
 	    powerpc/aes-spe-keys.o \
 	    powerpc/aes-spe-modes.o \
 	    powerpc/aes-tab-4k.o
 else
 libaes-y += powerpc/aesp8-ppc.o
-aes-perlasm-flavour-y := linux-ppc64
-aes-perlasm-flavour-$(CONFIG_PPC64_ELF_ABI_V2) := linux-ppc64-elfv2
-aes-perlasm-flavour-$(CONFIG_CPU_LITTLE_ENDIAN) := linux-ppc64le
 quiet_cmd_perlasm_aes = PERLASM $@
-      cmd_perlasm_aes = $(PERL) $< $(aes-perlasm-flavour-y) $@
+      cmd_perlasm_aes = $(PERL) $< $(ppc64-perlasm-flavour-y) $@
 # Use if_changed instead of cmd, in case the flavour changed.
 $(obj)/powerpc/aesp8-ppc.S: $(src)/powerpc/aesp8-ppc.pl FORCE
 	$(call if_changed,perlasm_aes)
 targets += powerpc/aesp8-ppc.S
 OBJECT_FILES_NON_STANDARD_powerpc/aesp8-ppc.o := y
@@ -159,13 +160,27 @@ libgf128hash-y := gf128hash.o
 ifeq ($(CONFIG_CRYPTO_LIB_GF128HASH_ARCH),y)
 CFLAGS_gf128hash.o += -I$(src)/$(SRCARCH)
 libgf128hash-$(CONFIG_ARM) += arm/ghash-neon-core.o
 libgf128hash-$(CONFIG_ARM64) += arm64/ghash-neon-core.o \
 				arm64/polyval-ce-core.o
-libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
+
+ifeq ($(CONFIG_PPC),y)
+libgf128hash-y += powerpc/ghashp8-ppc.o
+quiet_cmd_perlasm_ghash = PERLASM $@
+      cmd_perlasm_ghash = $(PERL) $< $(ppc64-perlasm-flavour-y) $@
+$(obj)/powerpc/ghashp8-ppc.S: $(src)/powerpc/ghashp8-ppc.pl FORCE
+	$(call if_changed,perlasm_ghash)
+targets += powerpc/ghashp8-ppc.S
+OBJECT_FILES_NON_STANDARD_powerpc/ghashp8-ppc.o := y
 endif
 
+libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
+endif # CONFIG_CRYPTO_LIB_GF128HASH_ARCH
+
+# clean-files must be defined unconditionally
+clean-files += powerpc/ghashp8-ppc.S
+
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_MD5) += libmd5.o
 libmd5-y := md5.o
 ifeq ($(CONFIG_CRYPTO_LIB_MD5_ARCH),y)
diff --git a/lib/crypto/powerpc/.gitignore b/lib/crypto/powerpc/.gitignore
index 598ca7aff6b1..7aa71d83f739 100644
--- a/lib/crypto/powerpc/.gitignore
+++ b/lib/crypto/powerpc/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 aesp8-ppc.S
+ghashp8-ppc.S
diff --git a/lib/crypto/powerpc/gf128hash.h b/lib/crypto/powerpc/gf128hash.h
new file mode 100644
index 000000000000..629cd325d0c7
--- /dev/null
+++ b/lib/crypto/powerpc/gf128hash.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * GHASH routines supporting VMX instructions on the Power 8
+ *
+ * Copyright (C) 2015, 2019 International Business Machines Inc.
+ * Copyright (C) 2014 - 2018 Linaro Ltd.
+ * Copyright 2026 Google LLC
+ */
+
+#include <asm/simd.h>
+#include <asm/switch_to.h>
+#include <linux/cpufeature.h>
+#include <linux/jump_label.h>
+#include <linux/preempt.h>
+#include <linux/uaccess.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_vec_crypto);
+
+void gcm_init_p8(u64 htable[4][2], const u8 h[16]);
+void gcm_gmult_p8(u8 Xi[16], const u64 htable[4][2]);
+void gcm_ghash_p8(u8 Xi[16], const u64 htable[4][2], const u8 *in, size_t len);
+
+#define ghash_preparekey_arch ghash_preparekey_arch
+static void ghash_preparekey_arch(struct ghash_key *key,
+				  const u8 raw_key[GHASH_BLOCK_SIZE])
+{
+	ghash_key_to_polyval(raw_key, &key->h);
+
+	if (static_branch_likely(&have_vec_crypto) && likely(may_use_simd())) {
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_init_p8(key->htable, raw_key);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+	} else {
+		/* This reproduces gcm_init_p8() on both LE and BE systems. */
+		key->htable[0][0] = 0;
+		key->htable[0][1] = 0xc200000000000000;
+
+		key->htable[1][0] = 0;
+		key->htable[1][1] = le64_to_cpu(key->h.lo);
+
+		key->htable[2][0] = le64_to_cpu(key->h.lo);
+		key->htable[2][1] = le64_to_cpu(key->h.hi);
+
+		key->htable[3][0] = le64_to_cpu(key->h.hi);
+		key->htable[3][1] = 0;
+	}
+}
+
+#define ghash_mul_arch ghash_mul_arch
+static void ghash_mul_arch(struct polyval_elem *acc,
+			   const struct ghash_key *key)
+{
+	if (static_branch_likely(&have_vec_crypto) && likely(may_use_simd())) {
+		u8 ghash_acc[GHASH_BLOCK_SIZE];
+
+		polyval_acc_to_ghash(acc, ghash_acc);
+
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_gmult_p8(ghash_acc, key->htable);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
+
+		ghash_acc_to_polyval(ghash_acc, acc);
+		memzero_explicit(ghash_acc, sizeof(ghash_acc));
+	} else {
+		polyval_mul_generic(acc, &key->h);
+	}
+}
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_vec_crypto) && likely(may_use_simd())) {
+		u8 ghash_acc[GHASH_BLOCK_SIZE];
+
+		polyval_acc_to_ghash(acc, ghash_acc);
+
+		preempt_disable();
+		pagefault_disable();
+		enable_kernel_vsx();
+		gcm_ghash_p8(ghash_acc, key->htable, data,
+			     nblocks * GHASH_BLOCK_SIZE);
+		disable_kernel_vsx();
+		pagefault_enable();
+		preempt_enable();
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
+	if (cpu_has_feature(CPU_FTR_ARCH_207S) &&
+	    (cur_cpu_spec->cpu_user_features2 & PPC_FEATURE2_VEC_CRYPTO))
+		static_branch_enable(&have_vec_crypto);
+}
diff --git a/arch/powerpc/crypto/ghashp8-ppc.pl b/lib/crypto/powerpc/ghashp8-ppc.pl
similarity index 98%
rename from arch/powerpc/crypto/ghashp8-ppc.pl
rename to lib/crypto/powerpc/ghashp8-ppc.pl
index 041e633c214f..7c38eedc02cc 100644
--- a/arch/powerpc/crypto/ghashp8-ppc.pl
+++ b/lib/crypto/powerpc/ghashp8-ppc.pl
@@ -45,10 +45,11 @@ if ($flavour =~ /64/) {
 } else { die "nonsense $flavour"; }
 
 $0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
 ( $xlate="${dir}ppc-xlate.pl" and -f $xlate ) or
 ( $xlate="${dir}../../perlasm/ppc-xlate.pl" and -f $xlate) or
+( $xlate="${dir}../../../arch/powerpc/crypto/ppc-xlate.pl" and -f $xlate) or
 die "can't locate ppc-xlate.pl";
 
 open STDOUT,"| $^X $xlate $flavour $output" || die "can't call $xlate: $!";
 
 my ($Xip,$Htbl,$inp,$len)=map("r$_",(3..6));	# argument block
-- 
2.53.0

