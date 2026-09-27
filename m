Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D357B440630;
	Sun, 27 Sep 2026 22:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549087; cv=none; b=b5L1elfMGHuuRji3SBIVhF+cX7re3DkYJzxPxK3UkqMARUJYOzyB2v1EydeCRCRcUY+bTx2Jj2ldgGMFxCNwznMDjlJQ+T87J62Xlo6Fg6A2N+HRxKiq/90x3pG/DZhHNvpWyIGbF8xqL+wVMu4l4pXKs1t0UE8tuL1yRR16N4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549087; c=relaxed/simple;
	bh=wln5lodX7mtjIzBxps6k5KRREju+1KMwp+rpw7kAo3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxDStSimqBnNcieO8Rc3I1QLBmQ2FEvdFXq0xSWhqOzPecfZCsg1imOUrbz5vK/nQtMUyNhzHLvCKmNoQ45m+9k9KOFH54AEXpSWG43HGtGHfmR2svCkshporE2VXYQmx23y0KOJWh/DgGZF3FnMt28DxwXQIagBoRnWqaQzgyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeXRmIyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeXRmIyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EBB1F00893;
	Sun, 27 Sep 2026 22:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549083;
	bh=1X+eHmTYMVeZLH6/u55yojUTlUxT5xFfAqkUdE8PJTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeXRmIyqsOzF0QP2VPUq84x+VIp3/hDqgvocIKgJ6FktSdWRYNc/rNfsfHyc75l82
	 WKDLYpoqBnrWbW0l0EVsBbpGJ0cb9hqc2AT//xIvNFngKdTRxV/4HSY/4Hc2AtrVRk
	 EPqfo/fsc2mDu+wu0xaGfMjxH3eBwSohMalreS5VX3N60EYahDXXS9xRFR7lCz6Ks7
	 kaSJB34zxdbCCW3wEwmwq98zdjXfxke4/u1Oxav2sQf+f7twxt0T3NuSyoj7OcQeYL
	 f8mNS+prtRYDLRHftiiKiJIEaOd9fdNyF/zO3nk/BkbuR8/+bWFElETv3BgvF4IS6/
	 /MytnKw44zGwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 13/20] lib/crypto: x86/aes-ctr: Migrate AVX-optimized code into library
Date: Sun, 27 Sep 2026 15:43:04 -0700
Message-ID: <20260927224418.109759-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migrate aes-ctr-avx-x86_64.S into lib/crypto/, wiring it up to the CTR
and XCTR library functions instead of the crypto_skcipher API.  It still
remains available through crypto_skcipher via crypto/aes.c.

Some slight adjustments to the assembly code were needed:

- Take 'struct aes_enckey' instead of 'struct crypto_aes_ctx'.

- Upgrade the length argument from 32-bit to 64-bit so that it's
  compatible with the library's use of size_t (at least assuming no
  lengths over S64_MAX, which seems quite safe to assume...)

- Remove the CFI stubs, as the functions are now called directly.

- Adjust the argument order to match the caller.  Not strictly required,
  but it's easiest to handle this now when changing the function
  prototypes anyway and adding the new glue code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |   4 +-
 arch/x86/crypto/Makefile                      |   1 -
 arch/x86/crypto/aesni-intel_glue.c            | 153 ------------------
 crypto/aes.c                                  |   7 +-
 lib/crypto/Makefile                           |   4 +
 .../crypto/x86}/aes-ctr-avx-x86_64.S          | 103 ++++++------
 lib/crypto/x86/aes.h                          |  80 ++++++++-
 7 files changed, 140 insertions(+), 212 deletions(-)
 rename {arch/x86/crypto => lib/crypto/x86}/aes-ctr-avx-x86_64.S (88%)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 79e610b5e5bc..778ab164c571 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,7 +3,7 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: CTR, XCTR, XTS, GCM (AES-NI/VAES)"
+	tristate "Ciphers: AES, modes: XTS, GCM (AES-NI/VAES)"
 	depends on 64BIT
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
@@ -11,7 +11,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with CTR, XCTR, XTS
+	  Length-preserving ciphers: AES with XTS
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES new instructions)
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 1c3feb6d72b7..0c016ba87373 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -42,7 +42,6 @@ aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o \
 		 aesni-intel_glue.o \
-		 aes-ctr-avx-x86_64.o \
 		 aes-gcm-aesni-x86_64.o \
 		 aes-gcm-vaes-avx2.o \
 		 aes-gcm-vaes-avx512.o \
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 29f07470f442..5aae178bbae3 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -42,7 +42,6 @@
 #define AESNI_ALIGN	16
 #define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
 #define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
-#define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
 struct aesni_xts_ctx {
@@ -60,11 +59,6 @@ static inline void *aes_align_addr(void *addr)
 asmlinkage void aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			      unsigned int key_len);
 
-static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
-{
-	return aes_align_addr(raw_ctx);
-}
-
 static inline struct aesni_xts_ctx *aes_xts_ctx(struct crypto_skcipher *tfm)
 {
 	return aes_align_addr(crypto_skcipher_ctx(tfm));
@@ -88,12 +82,6 @@ static int aes_set_key_common(struct crypto_aes_ctx *ctx,
 	return 0;
 }
 
-static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			         unsigned int len)
-{
-	return aes_set_key_common(aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
-}
-
 static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -222,100 +210,6 @@ xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
 asmlinkage void aes_xts_encrypt_iv(const struct crypto_aes_ctx *tweak_key,
 				   u8 iv[AES_BLOCK_SIZE]);
 
-/* __always_inline to avoid indirect call */
-static __always_inline int
-ctr_crypt(struct skcipher_request *req,
-	  void (*ctr64_func)(const struct crypto_aes_ctx *key,
-			     const u8 *src, u8 *dst, int len,
-			     const u64 le_ctr[2]))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *key = aes_ctx(crypto_skcipher_ctx(tfm));
-	unsigned int nbytes, p1_nbytes, nblocks;
-	struct skcipher_walk walk;
-	u64 le_ctr[2];
-	u64 ctr64;
-	int err;
-
-	ctr64 = le_ctr[0] = get_unaligned_be64(&req->iv[8]);
-	le_ctr[1] = get_unaligned_be64(&req->iv[0]);
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) != 0) {
-		if (nbytes < walk.total) {
-			/* Not the end yet, so keep the length block-aligned. */
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-			nblocks = nbytes / AES_BLOCK_SIZE;
-		} else {
-			/* It's the end, so include any final partial block. */
-			nblocks = DIV_ROUND_UP(nbytes, AES_BLOCK_SIZE);
-		}
-		ctr64 += nblocks;
-
-		kernel_fpu_begin();
-		if (likely(ctr64 >= nblocks)) {
-			/* The low 64 bits of the counter won't overflow. */
-			(*ctr64_func)(key, walk.src.virt.addr,
-				      walk.dst.virt.addr, nbytes, le_ctr);
-		} else {
-			/*
-			 * The low 64 bits of the counter will overflow.  The
-			 * assembly doesn't handle this case, so split the
-			 * operation into two at the point where the overflow
-			 * will occur.  After the first part, add the carry bit.
-			 */
-			p1_nbytes = min(nbytes, (nblocks - ctr64) * AES_BLOCK_SIZE);
-			(*ctr64_func)(key, walk.src.virt.addr,
-				      walk.dst.virt.addr, p1_nbytes, le_ctr);
-			le_ctr[0] = 0;
-			le_ctr[1]++;
-			(*ctr64_func)(key, walk.src.virt.addr + p1_nbytes,
-				      walk.dst.virt.addr + p1_nbytes,
-				      nbytes - p1_nbytes, le_ctr);
-		}
-		kernel_fpu_end();
-		le_ctr[0] = ctr64;
-
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	put_unaligned_be64(ctr64, &req->iv[8]);
-	put_unaligned_be64(le_ctr[1], &req->iv[0]);
-
-	return err;
-}
-
-/* __always_inline to avoid indirect call */
-static __always_inline int
-xctr_crypt(struct skcipher_request *req,
-	   void (*xctr_func)(const struct crypto_aes_ctx *key,
-			     const u8 *src, u8 *dst, int len,
-			     const u8 iv[AES_BLOCK_SIZE], u64 ctr))
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *key = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	u64 ctr = 1;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-
-		kernel_fpu_begin();
-		(*xctr_func)(key, walk.src.virt.addr, walk.dst.virt.addr,
-			     nbytes, req->iv, ctr);
-		kernel_fpu_end();
-
-		ctr += DIV_ROUND_UP(nbytes, AES_BLOCK_SIZE);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-	return err;
-}
-
 #define DEFINE_AVX_SKCIPHER_ALGS(suffix, driver_name_suffix, priority)	       \
 									       \
 asmlinkage void								       \
@@ -335,25 +229,6 @@ static int xts_decrypt_##suffix(struct skcipher_request *req)		       \
 	return xts_crypt(req, aes_xts_encrypt_iv, aes_xts_decrypt_##suffix);   \
 }									       \
 									       \
-asmlinkage void								       \
-aes_ctr64_crypt_##suffix(const struct crypto_aes_ctx *key,		       \
-			 const u8 *src, u8 *dst, int len, const u64 le_ctr[2]);\
-									       \
-static int ctr_crypt_##suffix(struct skcipher_request *req)		       \
-{									       \
-	return ctr_crypt(req, aes_ctr64_crypt_##suffix);		       \
-}									       \
-									       \
-asmlinkage void								       \
-aes_xctr_crypt_##suffix(const struct crypto_aes_ctx *key,		       \
-			const u8 *src, u8 *dst, int len,		       \
-			const u8 iv[AES_BLOCK_SIZE], u64 ctr);		       \
-									       \
-static int xctr_crypt_##suffix(struct skcipher_request *req)		       \
-{									       \
-	return xctr_crypt(req, aes_xctr_crypt_##suffix);		       \
-}									       \
-									       \
 static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 	.base.cra_name		= "xts(aes)",				       \
 	.base.cra_driver_name	= "xts-aes-" driver_name_suffix,	       \
@@ -368,34 +243,6 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
 	.setkey			= xts_setkey_aesni,			       \
 	.encrypt		= xts_encrypt_##suffix,			       \
 	.decrypt		= xts_decrypt_##suffix,			       \
-}, {									       \
-	.base.cra_name		= "ctr(aes)",				       \
-	.base.cra_driver_name	= "ctr-aes-" driver_name_suffix,	       \
-	.base.cra_priority	= priority,				       \
-	.base.cra_blocksize	= 1,					       \
-	.base.cra_ctxsize	= CRYPTO_AES_CTX_SIZE,			       \
-	.base.cra_module	= THIS_MODULE,				       \
-	.min_keysize		= AES_MIN_KEY_SIZE,			       \
-	.max_keysize		= AES_MAX_KEY_SIZE,			       \
-	.ivsize			= AES_BLOCK_SIZE,			       \
-	.chunksize		= AES_BLOCK_SIZE,			       \
-	.setkey			= aesni_skcipher_setkey,		       \
-	.encrypt		= ctr_crypt_##suffix,			       \
-	.decrypt		= ctr_crypt_##suffix,			       \
-}, {									       \
-	.base.cra_name		= "xctr(aes)",				       \
-	.base.cra_driver_name	= "xctr-aes-" driver_name_suffix,	       \
-	.base.cra_priority	= priority,				       \
-	.base.cra_blocksize	= 1,					       \
-	.base.cra_ctxsize	= CRYPTO_AES_CTX_SIZE,			       \
-	.base.cra_module	= THIS_MODULE,				       \
-	.min_keysize		= AES_MIN_KEY_SIZE,			       \
-	.max_keysize		= AES_MAX_KEY_SIZE,			       \
-	.ivsize			= AES_BLOCK_SIZE,			       \
-	.chunksize		= AES_BLOCK_SIZE,			       \
-	.setkey			= aesni_skcipher_setkey,		       \
-	.encrypt		= xctr_crypt_##suffix,			       \
-	.decrypt		= xctr_crypt_##suffix,			       \
 }}
 
 DEFINE_AVX_SKCIPHER_ALGS(aesni_avx, "aesni-avx", 500);
diff --git a/crypto/aes.c b/crypto/aes.c
index bf8acc553188..568a900bfec8 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -667,7 +667,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "ctr(aes)",
 		.base.cra_driver_name = "ctr-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
 		.base.cra_module = THIS_MODULE,
@@ -684,7 +684,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "xctr(aes)",
 		.base.cra_driver_name = "xctr-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = 1,
 		.base.cra_ctxsize = sizeof(struct aes_enckey),
 		.base.cra_module = THIS_MODULE,
@@ -1044,8 +1044,7 @@ static struct aead_alg aead_algs[] = {
 	  IS_ENABLED(CONFIG_PPC) || \
 	  IS_ENABLED(CONFIG_RISCV) || \
 	  IS_ENABLED(CONFIG_S390) || \
-	  IS_ENABLED(CONFIG_SPARC) || \
-	  IS_ENABLED(CONFIG_X86))
+	  IS_ENABLED(CONFIG_SPARC))
 	{
 		.base.cra_name = "ccm(aes)",
 		.base.cra_driver_name = "ccm-aes-lib",
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index ca068df1f71f..5d5484fc78ea 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -52,7 +52,11 @@ endif # CONFIG_PPC
 
 libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned.o
 libaes-$(CONFIG_SPARC) += sparc/aes_asm.o
+
 libaes-$(CONFIG_X86) += x86/aes-aesni.o
+ifneq ($(CONFIG_CRYPTO_LIB_AES_CTR),)
+libaes-$(CONFIG_X86_64) += x86/aes-ctr-avx-x86_64.o
+endif
 endif # CONFIG_CRYPTO_LIB_AES_ARCH
 
 # clean-files must be defined unconditionally
diff --git a/arch/x86/crypto/aes-ctr-avx-x86_64.S b/lib/crypto/x86/aes-ctr-avx-x86_64.S
similarity index 88%
rename from arch/x86/crypto/aes-ctr-avx-x86_64.S
rename to lib/crypto/x86/aes-ctr-avx-x86_64.S
index 2745918f68ee..c232337899b6 100644
--- a/arch/x86/crypto/aes-ctr-avx-x86_64.S
+++ b/lib/crypto/x86/aes-ctr-avx-x86_64.S
@@ -53,7 +53,10 @@
 // See the function definitions at the bottom of the file for more information.
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
+
+// Offsets in struct aes_enckey
+#define OFFSETOF_KEYLEN		0
+#define OFFSETOF_RNDKEYS	16
 
 .section .rodata
 .p2align 4
@@ -278,24 +281,25 @@
 .endr
 
 	// Function arguments
-	.set	KEY,		%rdi	// Initially points to the start of the
-					// crypto_aes_ctx, then is advanced to
-					// point to the index 1 round key
-	.set	KEY32,		%edi	// Available as temp register after all
-					// keystream blocks have been generated
+	.set	DST,		%rdi	// Pointer to next destination data
 	.set	SRC,		%rsi	// Pointer to next source data
-	.set	DST,		%rdx	// Pointer to next destination data
-	.set	LEN,		%ecx	// Remaining length in bytes.
-					// Note: _load_partial_block relies on
-					// this being in %ecx.
-	.set	LEN64,		%rcx	// Zero-extend LEN before using!
-	.set	LEN8,		%cl
+	.set	LEN,		%rdx	// Remaining length in bytes
+	.set	LEN32,		%edx	// Used for improved code density
 .if \is_xctr
+	.set	XCTR_CTR,	%rcx	// u64 ctr;
 	.set	XCTR_IV_PTR,	%r8	// const u8 iv[AES_BLOCK_SIZE];
-	.set	XCTR_CTR,	%r9	// u64 ctr;
+	.set	KEY,		%r9	// Initially points to the start of the
+					// aes_enckey, then is advanced to
+					// point to the index 1 round key
+	.set	KEY32,		%r9d	// Available as temp register after all
+					// keystream blocks have been generated
 .else
-	.set	LE_CTR_PTR,	%r8	// const u64 le_ctr[2];
+	.set	LE_CTR_PTR,	%rcx	// const u64 le_ctr[2];
+	.set	KEY,		%r8
+	.set	KEY32,		%r8d
 .endif
+	// Note: the use of _load_partial_block and _store_partial_block at the
+	// end of the function assumes %rcx doesn't hold DST, SRC, LEN, or KEY.
 
 	// Additional local variables
 	.set	RNDKEYLAST_PTR,	%r10
@@ -355,17 +359,17 @@
 	vpsllq		$1, LE_CTR_INC1, LE_CTR_INC2
 
 	// Load the AES key length: 16 (AES-128), 24 (AES-192), or 32 (AES-256).
-	movl		480(KEY), %eax
+	movl		OFFSETOF_KEYLEN(KEY), %eax
 
 	// Compute the pointer to the last round key.
-	lea		6*16(KEY, %rax, 4), RNDKEYLAST_PTR
+	lea		OFFSETOF_RNDKEYS+6*16(KEY, %rax, 4), RNDKEYLAST_PTR
 
 	// Load the zero-th and last round keys.
-	_vbroadcast128	(KEY), RNDKEY0
+	_vbroadcast128	OFFSETOF_RNDKEYS(KEY), RNDKEY0
 	_vbroadcast128	(RNDKEYLAST_PTR), RNDKEYLAST
 
 	// Make KEY point to the first round key.
-	add		$16, KEY
+	add		$OFFSETOF_RNDKEYS+16, KEY
 
 	// This is the main loop, which encrypts 8 vectors of data at a time.
 	add		$-8*VL, LEN
@@ -382,7 +386,7 @@
 	add		$-8*VL, LEN
 	jge		.Lloop_8x\@
 .Lloop_8x_done\@:
-	sub		$-8*VL, LEN
+	sub		$-8*VL, LEN32
 	jz		.Ldone\@
 
 	// 1 <= LEN < 8*VL.  Generate 2, 4, or 8 more vectors of keystream
@@ -390,7 +394,7 @@
 
 	_prepare_2_ctr_vecs	\is_xctr, 0, 1
 	_prepare_2_ctr_vecs	\is_xctr, 2, 3
-	cmp		$4*VL, LEN
+	cmp		$4*VL, LEN32
 	jle		.Lenc_tail_atmost4vecs\@
 
 	// 4*VL < LEN < 8*VL.  Generate 8 vectors of keystream blocks.  Use the
@@ -405,23 +409,23 @@
 	vaesenclast	RNDKEYLAST, AESDATA7, AESDATA3
 	sub		$-4*VL, SRC
 	sub		$-4*VL, DST
-	add		$-4*VL, LEN
-	cmp		$1*VL-1, LEN
+	add		$-4*VL, LEN32
+	cmp		$1*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_0\@
 	_xor_data	0
-	cmp		$2*VL-1, LEN
+	cmp		$2*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_1\@
 	_xor_data	1
-	cmp		$3*VL-1, LEN
+	cmp		$3*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_2\@
 	_xor_data	2
-	cmp		$4*VL-1, LEN
+	cmp		$4*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_3\@
 	_xor_data	3
 	jmp		.Ldone\@
 
 .Lenc_tail_atmost4vecs\@:
-	cmp		$2*VL, LEN
+	cmp		$2*VL, LEN32
 	jle		.Lenc_tail_atmost2vecs\@
 
 	// 2*VL < LEN <= 4*VL.  Generate 4 vectors of keystream blocks.  Use the
@@ -432,7 +436,7 @@
 	vaesenclast	RNDKEYLAST, AESDATA3, AESDATA1
 	sub		$-2*VL, SRC
 	sub		$-2*VL, DST
-	add		$-2*VL, LEN
+	add		$-2*VL, LEN32
 	jmp		.Lxor_tail_upto2vecs\@
 
 .Lenc_tail_atmost2vecs\@:
@@ -443,16 +447,16 @@
 	vaesenclast	RNDKEYLAST, AESDATA1, AESDATA1
 
 .Lxor_tail_upto2vecs\@:
-	cmp		$1*VL-1, LEN
+	cmp		$1*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_0\@
 	_xor_data	0
-	cmp		$2*VL-1, LEN
+	cmp		$2*VL-1, LEN32
 	jle		.Lxor_tail_partial_vec_1\@
 	_xor_data	1
 	jmp		.Ldone\@
 
 .Lxor_tail_partial_vec_1\@:
-	add		$-1*VL, LEN
+	add		$-1*VL, LEN32
 	jz		.Ldone\@
 	sub		$-1*VL, SRC
 	sub		$-1*VL, DST
@@ -460,7 +464,7 @@
 	jmp		.Lxor_tail_partial_vec_0\@
 
 .Lxor_tail_partial_vec_2\@:
-	add		$-2*VL, LEN
+	add		$-2*VL, LEN32
 	jz		.Ldone\@
 	sub		$-2*VL, SRC
 	sub		$-2*VL, DST
@@ -468,7 +472,7 @@
 	jmp		.Lxor_tail_partial_vec_0\@
 
 .Lxor_tail_partial_vec_3\@:
-	add		$-3*VL, LEN
+	add		$-3*VL, LEN32
 	jz		.Ldone\@
 	sub		$-3*VL, SRC
 	sub		$-3*VL, DST
@@ -479,28 +483,29 @@
 	// loads/stores are available; otherwise it's a bit harder...
 .if USE_AVX512
 	mov		$-1, %rax
-	bzhi		LEN64, %rax, %rax
+	bzhi		LEN, %rax, %rax
 	kmovq		%rax, %k1
 	vmovdqu8	(SRC), AESDATA1{%k1}{z}
 	vpxord		AESDATA1, AESDATA0, AESDATA0
 	vmovdqu8	AESDATA0, (DST){%k1}
 .else
   .if VL == 32
-	cmp		$16, LEN
+	cmp		$16, LEN32
 	jl		1f
 	vpxor		(SRC), AESDATA0_XMM, AESDATA1_XMM
 	vmovdqu		AESDATA1_XMM, (DST)
 	add		$16, SRC
 	add		$16, DST
-	sub		$16, LEN
+	sub		$16, LEN32
 	jz		.Ldone\@
 	vextracti128	$1, AESDATA0, AESDATA0_XMM
 1:
   .endif
-	mov		LEN, %r10d
+	// Note: this assumes %rcx doesn't hold DST, SRC, LEN, or KEY.
+	mov		LEN32, %ecx
 	_load_partial_block	SRC, AESDATA1_XMM, KEY, KEY32
 	vpxor		AESDATA1_XMM, AESDATA0_XMM, AESDATA0_XMM
-	mov		%r10d, %ecx
+	mov		LEN32, %ecx
 	_store_partial_block	AESDATA0_XMM, DST, KEY, KEY32
 .endif
 
@@ -515,13 +520,13 @@
 // They have the following prototypes:
 //
 //
-// void aes_ctr64_crypt_##suffix(const struct crypto_aes_ctx *key,
-//				 const u8 *src, u8 *dst, int len,
-//				 const u64 le_ctr[2]);
+// void aes_ctr64_crypt_##suffix(u8 *dst, const u8 *src, s64 len,
+//				 const u64 le_ctr[2],
+//				 const struct aes_enckey *key);
 //
-// void aes_xctr_crypt_##suffix(const struct crypto_aes_ctx *key,
-//				const u8 *src, u8 *dst, int len,
-//				const u8 iv[AES_BLOCK_SIZE], u64 ctr);
+// void aes_xctr_crypt_##suffix(u8 *dst, const u8 *src, s64 len, u64 ctr,
+//				const u8 iv[AES_BLOCK_SIZE],
+//				const struct aes_enckey *key);
 //
 // Both functions generate |len| bytes of keystream, XOR it with the data from
 // |src|, and write the result to |dst|.  On non-final calls, |len| must be a
@@ -545,27 +550,27 @@
 
 .set	VL, 16
 .set	USE_AVX512, 0
-SYM_TYPED_FUNC_START(aes_ctr64_crypt_aesni_avx)
+SYM_FUNC_START(aes_ctr64_crypt_aesni_avx)
 	_aes_ctr_crypt	0
 SYM_FUNC_END(aes_ctr64_crypt_aesni_avx)
-SYM_TYPED_FUNC_START(aes_xctr_crypt_aesni_avx)
+SYM_FUNC_START(aes_xctr_crypt_aesni_avx)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_aesni_avx)
 
 .set	VL, 32
 .set	USE_AVX512, 0
-SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx2)
+SYM_FUNC_START(aes_ctr64_crypt_vaes_avx2)
 	_aes_ctr_crypt	0
 SYM_FUNC_END(aes_ctr64_crypt_vaes_avx2)
-SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx2)
+SYM_FUNC_START(aes_xctr_crypt_vaes_avx2)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_vaes_avx2)
 
 .set	VL, 64
 .set	USE_AVX512, 1
-SYM_TYPED_FUNC_START(aes_ctr64_crypt_vaes_avx512)
+SYM_FUNC_START(aes_ctr64_crypt_vaes_avx512)
 	_aes_ctr_crypt	0
 SYM_FUNC_END(aes_ctr64_crypt_vaes_avx512)
-SYM_TYPED_FUNC_START(aes_xctr_crypt_vaes_avx512)
+SYM_FUNC_START(aes_xctr_crypt_vaes_avx512)
 	_aes_ctr_crypt	1
 SYM_FUNC_END(aes_xctr_crypt_vaes_avx512)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 54b599bd2581..8ed247ddb8f2 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -8,8 +8,12 @@
 #include <asm/fpu/api.h>
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_aesni);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_aesni_avx);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_vaes_avx2);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_vaes_avx512);
 
 /* The assembly code assumes the following offsets. */
+static_assert(offsetof(struct aes_enckey, len) == 0);
 static_assert(offsetof(struct aes_enckey, nrounds) == 4);
 static_assert(offsetof(struct aes_enckey, k.rndkeys) == 16);
 static_assert(offsetof(struct aes_key, nrounds) == 4);
@@ -208,11 +212,36 @@ static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR) && IS_ENABLED(CONFIG_X86_64)
 void aes_ctr64_crypt_aesni(u8 *dst, const u8 *src, s64 len, const u64 le_ctr[2],
 			   const struct aes_enckey *key);
+void aes_ctr64_crypt_aesni_avx(u8 *dst, const u8 *src, s64 len,
+			       const u64 le_ctr[2],
+			       const struct aes_enckey *key);
+void aes_ctr64_crypt_vaes_avx2(u8 *dst, const u8 *src, s64 len,
+			       const u64 le_ctr[2],
+			       const struct aes_enckey *key);
+void aes_ctr64_crypt_vaes_avx512(u8 *dst, const u8 *src, s64 len,
+				 const u64 le_ctr[2],
+				 const struct aes_enckey *key);
+void aes_xctr_crypt_aesni_avx(u8 *dst, const u8 *src, s64 len, u64 ctr,
+			      const u8 iv[AES_BLOCK_SIZE],
+			      const struct aes_enckey *key);
+void aes_xctr_crypt_vaes_avx2(u8 *dst, const u8 *src, s64 len, u64 ctr,
+			      const u8 iv[AES_BLOCK_SIZE],
+			      const struct aes_enckey *key);
+void aes_xctr_crypt_vaes_avx512(u8 *dst, const u8 *src, s64 len, u64 ctr,
+				const u8 iv[AES_BLOCK_SIZE],
+				const struct aes_enckey *key);
 
 static void aes_ctr64_x86(u8 *dst, const u8 *src, size_t len,
 			  const u64 le_ctr[2], const struct aes_enckey *key)
 {
-	aes_ctr64_crypt_aesni(dst, src, len, le_ctr, key);
+	if (static_branch_likely(&have_vaes_avx512))
+		aes_ctr64_crypt_vaes_avx512(dst, src, len, le_ctr, key);
+	else if (static_branch_likely(&have_vaes_avx2))
+		aes_ctr64_crypt_vaes_avx2(dst, src, len, le_ctr, key);
+	else if (static_branch_likely(&have_aesni_avx))
+		aes_ctr64_crypt_aesni_avx(dst, src, len, le_ctr, key);
+	else
+		aes_ctr64_crypt_aesni(dst, src, len, le_ctr, key);
 }
 
 #define aes_ctr_arch aes_ctr_arch
@@ -257,6 +286,25 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 	put_unaligned_be64(le_ctr[1], &ctr[0]);
 	return true;
 }
+
+#define aes_xctr_arch aes_xctr_arch
+static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 ctr,
+			  const u8 iv[AES_BLOCK_SIZE],
+			  const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_aesni_avx) ||
+	    unlikely(!irq_fpu_usable()))
+		return false;
+	kernel_fpu_begin();
+	if (static_branch_likely(&have_vaes_avx512))
+		aes_xctr_crypt_vaes_avx512(dst, src, len, ctr, iv, key);
+	else if (static_branch_likely(&have_vaes_avx2))
+		aes_xctr_crypt_vaes_avx2(dst, src, len, ctr, iv, key);
+	else
+		aes_xctr_crypt_aesni_avx(dst, src, len, ctr, iv, key);
+	kernel_fpu_end();
+	return true;
+}
 #endif /* CONFIG_CRYPTO_LIB_AES_CTR && CONFIG_X86_64 */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
@@ -306,6 +354,32 @@ static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-	if (boot_cpu_has(X86_FEATURE_AES))
-		static_branch_enable(&have_aesni);
+	/* Everything below requires AES-NI. */
+	if (!boot_cpu_has(X86_FEATURE_AES))
+		return;
+	static_branch_enable(&have_aesni);
+
+	/* Everything below requires AVX and is also 64-bit only. */
+	if (!boot_cpu_has(X86_FEATURE_AVX) || !IS_ENABLED(CONFIG_X86_64))
+		return;
+	static_branch_enable(&have_aesni_avx);
+
+	/*
+	 * Everything below requires VAES, and also sometimes AVX2, VPCLMULQDQ,
+	 * and PCLMULQDQ.  Use a single static key for all of them, since in
+	 * practice every CPU with VAES also has the others.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_VAES) ||
+	    !boot_cpu_has(X86_FEATURE_AVX2) ||
+	    !boot_cpu_has(X86_FEATURE_VPCLMULQDQ) ||
+	    !boot_cpu_has(X86_FEATURE_PCLMULQDQ))
+		return;
+	static_branch_enable(&have_vaes_avx2);
+
+	if (!boot_cpu_has(X86_FEATURE_AVX512BW) ||
+	    !boot_cpu_has(X86_FEATURE_AVX512VL) ||
+	    !boot_cpu_has(X86_FEATURE_BMI2) ||
+	    boot_cpu_has(X86_FEATURE_PREFER_YMM))
+		return;
+	static_branch_enable(&have_vaes_avx512);
 }
-- 
2.55.0

