Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5E33689F;
	Sat, 14 Mar 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773510812; cv=none; b=u4bnssTZfsLWqaohErNh37yX+AN/Os+1A79D+K11vo//L/lxsDOS4JW/sO2ITC6ViVRvLJUEOD8t6nc7tO/KknysK0MVElDQ7YGb/fI5+ImfRShgC7n59JoqAfFIJy6tbpeEmhCveCNVnmiTmPfH/WbX9mI3CQfr2Hz0siiTxQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773510812; c=relaxed/simple;
	bh=LBY7bE6hfmib619Fj1qaFtC8jy1Ti7H1QZ+BHhYSvlA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M6szLUZo2MH/HJbYxNpVIqSQBSaW8VBRf6Pa8WWZEDOUqkF6/Qicll+pYdQW3UXlRVu4ft0OiGMrnw+nd6nyxviHG21nMJN/ec0WOsKQ9xRQ4dCDhDuM4dkCHOAkreXJPZ+ypnMh8EmhluUVnoFc8hPrlUElYyg2G3x4kj6Zepk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9J22XBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9J22XBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B7EC116C6;
	Sat, 14 Mar 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773510811;
	bh=LBY7bE6hfmib619Fj1qaFtC8jy1Ti7H1QZ+BHhYSvlA=;
	h=From:To:Cc:Subject:Date:From;
	b=Q9J22XBTyXjWUtB5PXv42Qsf2RPIbKz3MgKVsA7bma5vA9vxMTCoRVImeAobCRV7k
	 cehMTLZ39zg+aPiMltP/IwX0C/f/jz1QTm/Mim2VcnvHhI4MgROMSI0aUCzgTMIP0F
	 RD7AucXM7LMLmA9aGnP/2FBaC08bMlMu2boviI5anHE8BSedD3PUQYYiACkAVuWrl2
	 czq+EavFT/kj+k6BnsMkzUXaQ/kzhRet0Z9BjUnGkthERAmQ2sM5VQMVuwQwn/gl8I
	 Sx1r+4A2qqrkl3c6dUCrHpDT1aDcjhCMFlBrpHNCwZRk+4nIGf30vZ2qnHI+zBKLLP
	 mbRhlvDoCB2yg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm64: Drop checks for CONFIG_KERNEL_MODE_NEON
Date: Sat, 14 Mar 2026 10:50:49 -0700
Message-ID: <20260314175049.26931-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
been since its introduction in 2013.  Given that and the fact that the
usefulness of kernel-mode NEON has only been increasing over time,
checking for this option in arm64-specific code is unnecessary.  Remove
these checks from lib/crypto/ to simplify the code and prevent any
future bugs where e.g. code gets disabled due to a typo in this logic.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next)

 lib/crypto/Kconfig        | 12 ++++++------
 lib/crypto/Makefile       | 17 ++++++-----------
 lib/crypto/arm64/aes.h    | 16 ++++------------
 lib/crypto/arm64/sha256.h |  8 ++------
 lib/crypto/arm64/sha512.h |  5 +----
 5 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 42ec516459159..4910fe20e42ad 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -78,11 +78,11 @@ config CRYPTO_LIB_CHACHA
 
 config CRYPTO_LIB_CHACHA_ARCH
 	bool
 	depends on CRYPTO_LIB_CHACHA && !UML && !KMSAN
 	default y if ARM
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if MIPS && CPU_MIPS32_R2
 	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390
@@ -138,11 +138,11 @@ config CRYPTO_LIB_NH
 
 config CRYPTO_LIB_NH_ARCH
 	bool
 	depends on CRYPTO_LIB_NH && !UML && !KMSAN
 	default y if ARM && KERNEL_MODE_NEON
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if X86_64
 
 config CRYPTO_LIB_POLY1305
 	tristate
 	help
@@ -151,11 +151,11 @@ config CRYPTO_LIB_POLY1305
 
 config CRYPTO_LIB_POLY1305_ARCH
 	bool
 	depends on CRYPTO_LIB_POLY1305 && !UML && !KMSAN
 	default y if ARM
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if MIPS
 	# The PPC64 code needs to be fixed to work in softirq context.
 	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX && BROKEN
 	default y if RISCV
 	default y if X86_64
@@ -185,11 +185,11 @@ config CRYPTO_LIB_POLYVAL
 	  the functions from <crypto/polyval.h>.
 
 config CRYPTO_LIB_POLYVAL_ARCH
 	bool
 	depends on CRYPTO_LIB_POLYVAL && !UML
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if X86_64
 
 config CRYPTO_LIB_CHACHA20POLY1305
 	tristate
 	select CRYPTO_LIB_CHACHA
@@ -204,11 +204,11 @@ config CRYPTO_LIB_SHA1
 
 config CRYPTO_LIB_SHA1_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA1 && !UML
 	default y if ARM
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if MIPS && CPU_CAVIUM_OCTEON
 	default y if PPC
 	default y if S390
 	default y if SPARC64
 	default y if X86_64
@@ -260,11 +260,11 @@ config CRYPTO_LIB_SHA3
 	  the functions from <crypto/sha3.h>.
 
 config CRYPTO_LIB_SHA3_ARCH
 	bool
 	depends on CRYPTO_LIB_SHA3 && !UML
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if S390
 
 config CRYPTO_LIB_SM3
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index c05d4b4e8e826..a961615c8c7f2 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -21,17 +21,14 @@ obj-$(CONFIG_CRYPTO_LIB_AES) += libaes.o
 libaes-y := aes.o
 ifeq ($(CONFIG_CRYPTO_LIB_AES_ARCH),y)
 CFLAGS_aes.o += -I$(src)/$(SRCARCH)
 
 libaes-$(CONFIG_ARM) += arm/aes-cipher-core.o
-
-ifeq ($(CONFIG_ARM64),y)
-libaes-y += arm64/aes-cipher-core.o
-libaes-$(CONFIG_KERNEL_MODE_NEON) += arm64/aes-ce-core.o \
-				     arm64/aes-ce.o \
-				     arm64/aes-neon.o
-endif
+libaes-$(CONFIG_ARM64) += arm64/aes-cipher-core.o \
+			  arm64/aes-ce-core.o \
+			  arm64/aes-ce.o \
+			  arm64/aes-neon.o
 
 ifeq ($(CONFIG_PPC),y)
 ifeq ($(CONFIG_SPE),y)
 libaes-y += powerpc/aes-spe-core.o \
 	    powerpc/aes-spe-keys.o \
@@ -297,14 +294,13 @@ $(obj)/arm/sha256-core.S: $(src)/arm/sha256-armv4.pl
 	$(call cmd,perlasm)
 AFLAGS_arm/sha256-core.o += $(aflags-thumb2-y)
 endif
 
 ifeq ($(CONFIG_ARM64),y)
-libsha256-y += arm64/sha256-core.o
+libsha256-y += arm64/sha256-ce.o arm64/sha256-core.o
 $(obj)/arm64/sha256-core.S: $(src)/arm64/sha2-armv8.pl
 	$(call cmd,perlasm_with_args)
-libsha256-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha256-ce.o
 endif
 
 libsha256-$(CONFIG_PPC) += powerpc/sha256-spe-asm.o
 libsha256-$(CONFIG_RISCV) += riscv/sha256-riscv64-zvknha_or_zvknhb-zvkb.o
 libsha256-$(CONFIG_SPARC) += sparc/sha256_asm.o
@@ -327,14 +323,13 @@ $(obj)/arm/sha512-core.S: $(src)/arm/sha512-armv4.pl
 	$(call cmd,perlasm)
 AFLAGS_arm/sha512-core.o += $(aflags-thumb2-y)
 endif
 
 ifeq ($(CONFIG_ARM64),y)
-libsha512-y += arm64/sha512-core.o
+libsha512-y += arm64/sha512-ce-core.o arm64/sha512-core.o
 $(obj)/arm64/sha512-core.S: $(src)/arm64/sha2-armv8.pl
 	$(call cmd,perlasm_with_args)
-libsha512-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha512-ce-core.o
 endif
 
 libsha512-$(CONFIG_RISCV) += riscv/sha512-riscv64-zvknhb-zvkb.o
 libsha512-$(CONFIG_SPARC) += sparc/sha512_asm.o
 libsha512-$(CONFIG_X86) += x86/sha512-ssse3-asm.o \
diff --git a/lib/crypto/arm64/aes.h b/lib/crypto/arm64/aes.h
index 78e7b4e5f1206..135d3324a30a6 100644
--- a/lib/crypto/arm64/aes.h
+++ b/lib/crypto/arm64/aes.h
@@ -50,12 +50,11 @@ static void aes_expandkey_arm64(u32 rndkeys[], u32 *inv_rndkeys,
 
 	u32 kwords = key_len / sizeof(u32);
 	struct aes_block *key_enc, *key_dec;
 	int i, j;
 
-	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) ||
-	    !static_branch_likely(&have_aes) || unlikely(!may_use_simd())) {
+	if (!static_branch_likely(&have_aes) || unlikely(!may_use_simd())) {
 		aes_expandkey_generic(rndkeys, inv_rndkeys, in_key, key_len);
 		return;
 	}
 
 	for (i = 0; i < kwords; i++)
@@ -128,11 +127,10 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			    6 + key_len / 4);
 	return 0;
 }
 EXPORT_SYMBOL(ce_aes_expandkey);
 
-#if IS_ENABLED(CONFIG_KERNEL_MODE_NEON)
 EXPORT_SYMBOL_NS_GPL(neon_aes_ecb_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(neon_aes_ecb_decrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(neon_aes_cbc_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(neon_aes_cbc_decrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(neon_aes_cbc_cts_encrypt, "CRYPTO_INTERNAL");
@@ -154,21 +152,19 @@ EXPORT_SYMBOL_NS_GPL(ce_aes_ctr_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(ce_aes_xctr_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(ce_aes_xts_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(ce_aes_xts_decrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(ce_aes_essiv_cbc_encrypt, "CRYPTO_INTERNAL");
 EXPORT_SYMBOL_NS_GPL(ce_aes_essiv_cbc_decrypt, "CRYPTO_INTERNAL");
-#endif
 #if IS_MODULE(CONFIG_CRYPTO_AES_ARM64_CE_CCM)
 EXPORT_SYMBOL_NS_GPL(ce_aes_mac_update, "CRYPTO_INTERNAL");
 #endif
 
 static void aes_encrypt_arch(const struct aes_enckey *key,
 			     u8 out[AES_BLOCK_SIZE],
 			     const u8 in[AES_BLOCK_SIZE])
 {
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_aes) && likely(may_use_simd())) {
+	if (static_branch_likely(&have_aes) && likely(may_use_simd())) {
 		scoped_ksimd()
 			__aes_ce_encrypt(key->k.rndkeys, out, in, key->nrounds);
 	} else {
 		__aes_arm64_encrypt(key->k.rndkeys, out, in, key->nrounds);
 	}
@@ -176,12 +172,11 @@ static void aes_encrypt_arch(const struct aes_enckey *key,
 
 static void aes_decrypt_arch(const struct aes_key *key,
 			     u8 out[AES_BLOCK_SIZE],
 			     const u8 in[AES_BLOCK_SIZE])
 {
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_aes) && likely(may_use_simd())) {
+	if (static_branch_likely(&have_aes) && likely(may_use_simd())) {
 		scoped_ksimd()
 			__aes_ce_decrypt(key->inv_k.inv_rndkeys, out, in,
 					 key->nrounds);
 	} else {
 		__aes_arm64_decrypt(key->inv_k.inv_rndkeys, out, in,
@@ -194,12 +189,11 @@ static void aes_decrypt_arch(const struct aes_key *key,
 static bool aes_cbcmac_blocks_arch(u8 h[AES_BLOCK_SIZE],
 				   const struct aes_enckey *key, const u8 *data,
 				   size_t nblocks, bool enc_before,
 				   bool enc_after)
 {
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
+	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		do {
 			size_t rem;
 
 			scoped_ksimd() {
 				if (static_branch_likely(&have_aes))
@@ -221,16 +215,14 @@ static bool aes_cbcmac_blocks_arch(u8 h[AES_BLOCK_SIZE],
 	}
 	return false;
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC_MACS */
 
-#ifdef CONFIG_KERNEL_MODE_NEON
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(ASIMD)) {
 		static_branch_enable(&have_neon);
 		if (cpu_have_named_feature(AES))
 			static_branch_enable(&have_aes);
 	}
 }
-#endif /* CONFIG_KERNEL_MODE_NEON */
diff --git a/lib/crypto/arm64/sha256.h b/lib/crypto/arm64/sha256.h
index 568dff0f276af..1fad3d7baa9a2 100644
--- a/lib/crypto/arm64/sha256.h
+++ b/lib/crypto/arm64/sha256.h
@@ -18,12 +18,11 @@ asmlinkage size_t __sha256_ce_transform(struct sha256_block_state *state,
 					const u8 *data, size_t nblocks);
 
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_neon) && likely(may_use_simd())) {
+	if (static_branch_likely(&have_neon) && likely(may_use_simd())) {
 		if (static_branch_likely(&have_ce)) {
 			do {
 				size_t rem;
 
 				scoped_ksimd()
@@ -59,12 +58,11 @@ static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
 	/*
 	 * The assembly requires len >= SHA256_BLOCK_SIZE && len <= INT_MAX.
 	 * Further limit len to 65536 to avoid spending too long with preemption
 	 * disabled.  (Of course, in practice len is nearly always 4096 anyway.)
 	 */
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_ce) && len >= SHA256_BLOCK_SIZE &&
+	if (static_branch_likely(&have_ce) && len >= SHA256_BLOCK_SIZE &&
 	    len <= 65536 && likely(may_use_simd())) {
 		scoped_ksimd()
 			sha256_ce_finup2x(ctx, data1, data2, len, out1, out2);
 		kmsan_unpoison_memory(out1, SHA256_DIGEST_SIZE);
 		kmsan_unpoison_memory(out2, SHA256_DIGEST_SIZE);
@@ -76,16 +74,14 @@ static bool sha256_finup_2x_arch(const struct __sha256_ctx *ctx,
 static bool sha256_finup_2x_is_optimized_arch(void)
 {
 	return static_key_enabled(&have_ce);
 }
 
-#ifdef CONFIG_KERNEL_MODE_NEON
 #define sha256_mod_init_arch sha256_mod_init_arch
 static void sha256_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(ASIMD)) {
 		static_branch_enable(&have_neon);
 		if (cpu_have_named_feature(SHA2))
 			static_branch_enable(&have_ce);
 	}
 }
-#endif /* CONFIG_KERNEL_MODE_NEON */
diff --git a/lib/crypto/arm64/sha512.h b/lib/crypto/arm64/sha512.h
index 7eb7ef04d2687..d978c4d07e905 100644
--- a/lib/crypto/arm64/sha512.h
+++ b/lib/crypto/arm64/sha512.h
@@ -16,12 +16,11 @@ asmlinkage size_t __sha512_ce_transform(struct sha512_block_state *state,
 					const u8 *data, size_t nblocks);
 
 static void sha512_blocks(struct sha512_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
-	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
-	    static_branch_likely(&have_sha512_insns) &&
+	if (static_branch_likely(&have_sha512_insns) &&
 	    likely(may_use_simd())) {
 		do {
 			size_t rem;
 
 			scoped_ksimd()
@@ -33,13 +32,11 @@ static void sha512_blocks(struct sha512_block_state *state,
 	} else {
 		sha512_block_data_order(state, data, nblocks);
 	}
 }
 
-#ifdef CONFIG_KERNEL_MODE_NEON
 #define sha512_mod_init_arch sha512_mod_init_arch
 static void sha512_mod_init_arch(void)
 {
 	if (cpu_have_named_feature(SHA512))
 		static_branch_enable(&have_sha512_insns);
 }
-#endif /* CONFIG_KERNEL_MODE_NEON */

base-commit: ce260754bb435aea18e6a1a1ce3759249013f5a4
-- 
2.53.0

