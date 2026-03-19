Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA135CB98;
	Thu, 19 Mar 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901161; cv=none; b=USr+8FFNJXidhcMKOelNy0P04OOhaSzXisLACjfOsZ7YscOoRkKu3BjgOMNH4aqNMTe0f1n7apskILsSgAB/Jgv+XZlVex2GXf6G9sXSADNLNtApan29qmWjABf0X3VViVYEXHAhTc0C0OT016A0bDXbLEGD4lbALrrIMblX24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901161; c=relaxed/simple;
	bh=v23KyGPrHWAAC2T6J0ScHjRgqX7DUkokMnXW1NT3GDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZQJamOGsDIABGp0hPWK3f/SiMwS1GII3EDnBVJz/vmvEwaXP0vcRNNu7xloxirbqSH457NnS9Pj8km5ccWWs9nB5NTbJNjkc5suwH/GrOF51+NV7VnkYhE0m+W3xGR6GR2V7nzz/p2uzTxtzeIBmGl44phwHH68FG2+4UPrp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7hvvACg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7hvvACg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3186C2BCF5;
	Thu, 19 Mar 2026 06:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901161;
	bh=v23KyGPrHWAAC2T6J0ScHjRgqX7DUkokMnXW1NT3GDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7hvvACgXThVeEen2oB8v6/av/AmwXd++45upOpQyMaz+8DIdfwgfaEHjmMxHY95L
	 KgDxi1UEF65u8um9/80JUp1ERfI1lwB48xLsrNZalIFhHPKAcJW45DmTzH2Q1gcugu
	 QzkkUbuyb8Lf4vpYiyVNf9MKR5L+6kQSzmVeeZ4M1kBoBgBCjM7FrjyN7WDr+hjlz4
	 nj48OxB+Q1YTRVJe28oDZXuI2pmvrueIrl3YO8B99ipT7UI93XYMveTfuaS/W7NWjc
	 S860Q85nik5x7j1fDEP5CaEq7D1GEvarLqRTq/lxlioLeZlJeB3qp19mVvt6FHCjW9
	 w8pMMm1XNjL6w==
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
Subject: [PATCH 14/19] lib/crypto: x86/ghash: Migrate optimized code into library
Date: Wed, 18 Mar 2026 23:17:15 -0700
Message-ID: <20260319061723.1140720-15-ebiggers@kernel.org>
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

Remove the "ghash-pclmulqdqni" crypto_shash algorithm.  Move the
corresponding assembly code into lib/crypto/, and wire it up to the
GHASH library.

This makes the GHASH library be optimized with x86's carryless
multiplication instructions.  It also greatly reduces the amount of
x86-specific glue code that is needed, and it fixes the issue where this
GHASH optimization was disabled by default.

Rename and adjust the prototypes of the assembly functions to make them
fit better with the library.  Remove the byte-swaps (pshufb
instructions) that are no longer necessary because the library keeps the
accumulator in POLYVAL format rather than GHASH format.

Rename clmul_ghash_mul() to polyval_mul_pclmul() to reflect that it
really does a POLYVAL style multiplication.  Wire it up to both
ghash_mul_arch() and polyval_mul_arch().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |  10 --
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/ghash-clmulni-intel_glue.c    | 163 ------------------
 lib/crypto/Makefile                           |   3 +-
 lib/crypto/x86/gf128hash.h                    |  65 ++++++-
 .../crypto/x86/ghash-pclmul.S                 |  98 +++++------
 6 files changed, 104 insertions(+), 238 deletions(-)
 delete mode 100644 arch/x86/crypto/ghash-clmulni-intel_glue.c
 rename arch/x86/crypto/ghash-clmulni-intel_asm.S => lib/crypto/x86/ghash-pclmul.S (54%)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 7fb2319a0916..905e8a23cec3 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -342,16 +342,6 @@ config CRYPTO_SM3_AVX_X86_64
 	  Architecture: x86_64 using:
 	  - AVX (Advanced Vector Extensions)
 
 	  If unsure, say N.
 
-config CRYPTO_GHASH_CLMUL_NI_INTEL
-	tristate "Hash functions: GHASH (CLMUL-NI)"
-	depends on 64BIT
-	select CRYPTO_CRYPTD
-	help
-	  GCM GHASH hash function (NIST SP800-38D)
-
-	  Architecture: x86_64 using:
-	  - CLMUL-NI (carry-less multiplication new instructions)
-
 endmenu
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index b21ad0978c52..d562f4341da6 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -48,13 +48,10 @@ aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
 			       aes-gcm-aesni-x86_64.o \
 			       aes-gcm-vaes-avx2.o \
 			       aes-gcm-vaes-avx512.o \
 			       aes-xts-avx-x86_64.o
 
-obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
-ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
-
 obj-$(CONFIG_CRYPTO_SM3_AVX_X86_64) += sm3-avx-x86_64.o
 sm3-avx-x86_64-y := sm3-avx-asm_64.o sm3_avx_glue.o
 
 obj-$(CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64) += sm4-aesni-avx-x86_64.o
 sm4-aesni-avx-x86_64-y := sm4-aesni-avx-asm_64.o sm4_aesni_avx_glue.o
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
deleted file mode 100644
index aea5d4d06be7..000000000000
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ /dev/null
@@ -1,163 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Accelerated GHASH implementation with Intel PCLMULQDQ-NI
- * instructions. This file contains glue code.
- *
- * Copyright (c) 2009 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- */
-
-#include <asm/cpu_device_id.h>
-#include <asm/simd.h>
-#include <crypto/b128ops.h>
-#include <crypto/ghash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/utils.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/unaligned.h>
-
-asmlinkage void clmul_ghash_mul(char *dst, const le128 *shash);
-
-asmlinkage int clmul_ghash_update(char *dst, const char *src,
-				  unsigned int srclen, const le128 *shash);
-
-struct x86_ghash_ctx {
-	le128 shash;
-};
-
-static int ghash_init(struct shash_desc *desc)
-{
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx, 0, sizeof(*dctx));
-
-	return 0;
-}
-
-static int ghash_setkey(struct crypto_shash *tfm,
-			const u8 *key, unsigned int keylen)
-{
-	struct x86_ghash_ctx *ctx = crypto_shash_ctx(tfm);
-	u64 a, b;
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	/*
-	 * GHASH maps bits to polynomial coefficients backwards, which makes it
-	 * hard to implement.  But it can be shown that the GHASH multiplication
-	 *
-	 *	D * K (mod x^128 + x^7 + x^2 + x + 1)
-	 *
-	 * (where D is a data block and K is the key) is equivalent to:
-	 *
-	 *	bitreflect(D) * bitreflect(K) * x^(-127)
-	 *		(mod x^128 + x^127 + x^126 + x^121 + 1)
-	 *
-	 * So, the code below precomputes:
-	 *
-	 *	bitreflect(K) * x^(-127) (mod x^128 + x^127 + x^126 + x^121 + 1)
-	 *
-	 * ... but in Montgomery form (so that Montgomery multiplication can be
-	 * used), i.e. with an extra x^128 factor, which means actually:
-	 *
-	 *	bitreflect(K) * x (mod x^128 + x^127 + x^126 + x^121 + 1)
-	 *
-	 * The within-a-byte part of bitreflect() cancels out GHASH's built-in
-	 * reflection, and thus bitreflect() is actually a byteswap.
-	 */
-	a = get_unaligned_be64(key);
-	b = get_unaligned_be64(key + 8);
-	ctx->shash.a = cpu_to_le64((a << 1) | (b >> 63));
-	ctx->shash.b = cpu_to_le64((b << 1) | (a >> 63));
-	if (a >> 63)
-		ctx->shash.a ^= cpu_to_le64((u64)0xc2 << 56);
-	return 0;
-}
-
-static int ghash_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
-{
-	struct x86_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	u8 *dst = dctx->buffer;
-	int remain;
-
-	kernel_fpu_begin();
-	remain = clmul_ghash_update(dst, src, srclen, &ctx->shash);
-	kernel_fpu_end();
-	return remain;
-}
-
-static void ghash_flush(struct x86_ghash_ctx *ctx, struct ghash_desc_ctx *dctx,
-			const u8 *src, unsigned int len)
-{
-	u8 *dst = dctx->buffer;
-
-	kernel_fpu_begin();
-	if (len) {
-		crypto_xor(dst, src, len);
-		clmul_ghash_mul(dst, &ctx->shash);
-	}
-	kernel_fpu_end();
-}
-
-static int ghash_finup(struct shash_desc *desc, const u8 *src,
-		       unsigned int len, u8 *dst)
-{
-	struct x86_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	u8 *buf = dctx->buffer;
-
-	ghash_flush(ctx, dctx, src, len);
-	memcpy(dst, buf, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static struct shash_alg ghash_alg = {
-	.digestsize	= GHASH_DIGEST_SIZE,
-	.init		= ghash_init,
-	.update		= ghash_update,
-	.finup		= ghash_finup,
-	.setkey		= ghash_setkey,
-	.descsize	= sizeof(struct ghash_desc_ctx),
-	.base		= {
-		.cra_name		= "ghash",
-		.cra_driver_name	= "ghash-pclmulqdqni",
-		.cra_priority		= 400,
-		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct x86_ghash_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-static const struct x86_cpu_id pcmul_cpu_id[] = {
-	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL), /* Pickle-Mickle-Duck */
-	{}
-};
-MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
-
-static int __init ghash_pclmulqdqni_mod_init(void)
-{
-	if (!x86_match_cpu(pcmul_cpu_id))
-		return -ENODEV;
-
-	return crypto_register_shash(&ghash_alg);
-}
-
-static void __exit ghash_pclmulqdqni_mod_exit(void)
-{
-	crypto_unregister_shash(&ghash_alg);
-}
-
-module_init(ghash_pclmulqdqni_mod_init);
-module_exit(ghash_pclmulqdqni_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH hash function, accelerated by PCLMULQDQ-NI");
-MODULE_ALIAS_CRYPTO("ghash");
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 8950509833af..19c67f70fb38 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -172,11 +172,12 @@ $(obj)/powerpc/ghashp8-ppc.S: $(src)/powerpc/ghashp8-ppc.pl FORCE
 targets += powerpc/ghashp8-ppc.S
 OBJECT_FILES_NON_STANDARD_powerpc/ghashp8-ppc.o := y
 endif
 
 libgf128hash-$(CONFIG_RISCV) += riscv/ghash-riscv64-zvkg.o
-libgf128hash-$(CONFIG_X86) += x86/polyval-pclmul-avx.o
+libgf128hash-$(CONFIG_X86) += x86/ghash-pclmul.o \
+			      x86/polyval-pclmul-avx.o
 endif # CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 
 # clean-files must be defined unconditionally
 clean-files += powerpc/ghashp8-ppc.S
 
diff --git a/lib/crypto/x86/gf128hash.h b/lib/crypto/x86/gf128hash.h
index adf6147ea677..6b79b06caab0 100644
--- a/lib/crypto/x86/gf128hash.h
+++ b/lib/crypto/x86/gf128hash.h
@@ -1,20 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * POLYVAL library functions, x86_64 optimized
+ * GHASH and POLYVAL, x86_64 optimized
  *
  * Copyright 2025 Google LLC
  */
 #include <asm/fpu/api.h>
 #include <linux/cpufeature.h>
 
 #define NUM_H_POWERS 8
 
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pclmul);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_pclmul_avx);
 
+asmlinkage void polyval_mul_pclmul(struct polyval_elem *a,
+				   const struct polyval_elem *b);
 asmlinkage void polyval_mul_pclmul_avx(struct polyval_elem *a,
 				       const struct polyval_elem *b);
+
+asmlinkage void ghash_blocks_pclmul(struct polyval_elem *acc,
+				    const struct polyval_elem *key,
+				    const u8 *data, size_t nblocks);
 asmlinkage void polyval_blocks_pclmul_avx(struct polyval_elem *acc,
 					  const struct polyval_key *key,
 					  const u8 *data, size_t nblocks);
 
 #define polyval_preparekey_arch polyval_preparekey_arch
@@ -39,20 +46,58 @@ static void polyval_preparekey_arch(struct polyval_key *key,
 					    &key->h_powers[NUM_H_POWERS - 1]);
 		}
 	}
 }
 
+static void polyval_mul_x86(struct polyval_elem *a,
+			    const struct polyval_elem *b)
+{
+	if (static_branch_likely(&have_pclmul) && irq_fpu_usable()) {
+		kernel_fpu_begin();
+		if (static_branch_likely(&have_pclmul_avx))
+			polyval_mul_pclmul_avx(a, b);
+		else
+			polyval_mul_pclmul(a, b);
+		kernel_fpu_end();
+	} else {
+		polyval_mul_generic(a, b);
+	}
+}
+
+#define ghash_mul_arch ghash_mul_arch
+static void ghash_mul_arch(struct polyval_elem *acc,
+			   const struct ghash_key *key)
+{
+	polyval_mul_x86(acc, &key->h);
+}
+
 #define polyval_mul_arch polyval_mul_arch
 static void polyval_mul_arch(struct polyval_elem *acc,
 			     const struct polyval_key *key)
 {
-	if (static_branch_likely(&have_pclmul_avx) && irq_fpu_usable()) {
-		kernel_fpu_begin();
-		polyval_mul_pclmul_avx(acc, &key->h_powers[NUM_H_POWERS - 1]);
-		kernel_fpu_end();
+	polyval_mul_x86(acc, &key->h_powers[NUM_H_POWERS - 1]);
+}
+
+#define ghash_blocks_arch ghash_blocks_arch
+static void ghash_blocks_arch(struct polyval_elem *acc,
+			      const struct ghash_key *key,
+			      const u8 *data, size_t nblocks)
+{
+	if (static_branch_likely(&have_pclmul) && irq_fpu_usable()) {
+		do {
+			/* Allow rescheduling every 4 KiB. */
+			size_t n = min_t(size_t, nblocks,
+					 4096 / GHASH_BLOCK_SIZE);
+
+			kernel_fpu_begin();
+			ghash_blocks_pclmul(acc, &key->h, data, n);
+			kernel_fpu_end();
+			data += n * GHASH_BLOCK_SIZE;
+			nblocks -= n;
+		} while (nblocks);
 	} else {
-		polyval_mul_generic(acc, &key->h_powers[NUM_H_POWERS - 1]);
+		ghash_blocks_generic(acc, &key->h, data, nblocks);
 	}
 }
 
 #define polyval_blocks_arch polyval_blocks_arch
 static void polyval_blocks_arch(struct polyval_elem *acc,
@@ -78,9 +123,11 @@ static void polyval_blocks_arch(struct polyval_elem *acc,
 }
 
 #define gf128hash_mod_init_arch gf128hash_mod_init_arch
 static void gf128hash_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ) &&
-	    boot_cpu_has(X86_FEATURE_AVX))
-		static_branch_enable(&have_pclmul_avx);
+	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
+		static_branch_enable(&have_pclmul);
+		if (boot_cpu_has(X86_FEATURE_AVX))
+			static_branch_enable(&have_pclmul_avx);
+	}
 }
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/lib/crypto/x86/ghash-pclmul.S
similarity index 54%
rename from arch/x86/crypto/ghash-clmulni-intel_asm.S
rename to lib/crypto/x86/ghash-pclmul.S
index c4fbaa82ed7a..6ffb5aea6063 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/lib/crypto/x86/ghash-pclmul.S
@@ -19,12 +19,12 @@
 .section	.rodata.cst16.bswap_mask, "aM", @progbits, 16
 .align 16
 .Lbswap_mask:
 	.octa 0x000102030405060708090a0b0c0d0e0f
 
-#define DATA	%xmm0
-#define SHASH	%xmm1
+#define ACC	%xmm0
+#define KEY	%xmm1
 #define T1	%xmm2
 #define T2	%xmm3
 #define T3	%xmm4
 #define BSWAP	%xmm5
 #define IN1	%xmm6
@@ -32,102 +32,96 @@
 .text
 
 /*
  * __clmul_gf128mul_ble:	internal ABI
  * input:
- *	DATA:			operand1
- *	SHASH:			operand2, hash_key << 1 mod poly
+ *	ACC:			operand1
+ *	KEY:			operand2, hash_key << 1 mod poly
  * output:
- *	DATA:			operand1 * operand2 mod poly
+ *	ACC:			operand1 * operand2 mod poly
  * changed:
  *	T1
  *	T2
  *	T3
  */
 SYM_FUNC_START_LOCAL(__clmul_gf128mul_ble)
-	movaps DATA, T1
-	pshufd $0b01001110, DATA, T2
-	pshufd $0b01001110, SHASH, T3
-	pxor DATA, T2
-	pxor SHASH, T3
+	movaps ACC, T1
+	pshufd $0b01001110, ACC, T2
+	pshufd $0b01001110, KEY, T3
+	pxor ACC, T2
+	pxor KEY, T3
 
-	pclmulqdq $0x00, SHASH, DATA	# DATA = a0 * b0
-	pclmulqdq $0x11, SHASH, T1	# T1 = a1 * b1
+	pclmulqdq $0x00, KEY, ACC	# ACC = a0 * b0
+	pclmulqdq $0x11, KEY, T1	# T1 = a1 * b1
 	pclmulqdq $0x00, T3, T2		# T2 = (a1 + a0) * (b1 + b0)
-	pxor DATA, T2
+	pxor ACC, T2
 	pxor T1, T2			# T2 = a0 * b1 + a1 * b0
 
 	movaps T2, T3
 	pslldq $8, T3
 	psrldq $8, T2
-	pxor T3, DATA
-	pxor T2, T1			# <T1:DATA> is result of
+	pxor T3, ACC
+	pxor T2, T1			# <T1:ACC> is result of
 					# carry-less multiplication
 
 	# first phase of the reduction
-	movaps DATA, T3
+	movaps ACC, T3
 	psllq $1, T3
-	pxor DATA, T3
+	pxor ACC, T3
 	psllq $5, T3
-	pxor DATA, T3
+	pxor ACC, T3
 	psllq $57, T3
 	movaps T3, T2
 	pslldq $8, T2
 	psrldq $8, T3
-	pxor T2, DATA
+	pxor T2, ACC
 	pxor T3, T1
 
 	# second phase of the reduction
-	movaps DATA, T2
+	movaps ACC, T2
 	psrlq $5, T2
-	pxor DATA, T2
+	pxor ACC, T2
 	psrlq $1, T2
-	pxor DATA, T2
+	pxor ACC, T2
 	psrlq $1, T2
 	pxor T2, T1
-	pxor T1, DATA
+	pxor T1, ACC
 	RET
 SYM_FUNC_END(__clmul_gf128mul_ble)
 
-/* void clmul_ghash_mul(char *dst, const le128 *shash) */
-SYM_FUNC_START(clmul_ghash_mul)
+/*
+ * void polyval_mul_pclmul(struct polyval_elem *a,
+ *			   const struct polyval_elem *b)
+ */
+SYM_FUNC_START(polyval_mul_pclmul)
 	FRAME_BEGIN
-	movups (%rdi), DATA
-	movups (%rsi), SHASH
-	movaps .Lbswap_mask(%rip), BSWAP
-	pshufb BSWAP, DATA
+	movups (%rdi), ACC
+	movups (%rsi), KEY
 	call __clmul_gf128mul_ble
-	pshufb BSWAP, DATA
-	movups DATA, (%rdi)
+	movups ACC, (%rdi)
 	FRAME_END
 	RET
-SYM_FUNC_END(clmul_ghash_mul)
+SYM_FUNC_END(polyval_mul_pclmul)
 
 /*
- * int clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
- *			  const le128 *shash);
+ * void ghash_blocks_pclmul(struct polyval_elem *acc,
+ *			    const struct polyval_elem *key,
+ *			    const u8 *data, size_t nblocks)
  */
-SYM_FUNC_START(clmul_ghash_update)
+SYM_FUNC_START(ghash_blocks_pclmul)
 	FRAME_BEGIN
-	cmp $16, %rdx
-	jb .Lupdate_just_ret	# check length
 	movaps .Lbswap_mask(%rip), BSWAP
-	movups (%rdi), DATA
-	movups (%rcx), SHASH
-	pshufb BSWAP, DATA
+	movups (%rdi), ACC
+	movups (%rsi), KEY
 .align 4
-.Lupdate_loop:
-	movups (%rsi), IN1
+.Lnext_block:
+	movups (%rdx), IN1
 	pshufb BSWAP, IN1
-	pxor IN1, DATA
+	pxor IN1, ACC
 	call __clmul_gf128mul_ble
-	sub $16, %rdx
-	add $16, %rsi
-	cmp $16, %rdx
-	jge .Lupdate_loop
-	pshufb BSWAP, DATA
-	movups DATA, (%rdi)
-.Lupdate_just_ret:
-	mov %rdx, %rax
+	add $16, %rdx
+	dec %rcx
+	jnz .Lnext_block
+	movups ACC, (%rdi)
 	FRAME_END
 	RET
-SYM_FUNC_END(clmul_ghash_update)
+SYM_FUNC_END(ghash_blocks_pclmul)
-- 
2.53.0

