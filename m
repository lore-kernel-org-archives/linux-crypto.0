Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0867F353A98;
	Mon, 21 Sep 2026 05:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967771; cv=none; b=vDIZi28rC39/nc/X8Jnj+LY88v1U2+/zsn1q5oZTihaKj69gll9Dlvb1Ib5eiZhu5wa+ln7FeKBupLb53Di5faZusG2gF0dTNKGymad5tp8pMwmD4ahEnMjCgiRtuu31ISpexpfBpzPZLBvZVHnaJHfVSSBzMHmI7l5m4lnjJvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967771; c=relaxed/simple;
	bh=tSS2mfvgCGt6ZXDQLKxMbb4zRQYLENPQH/XfVX4QetU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0m46tQUZyjgl8QkKyXvmfjZYxlrWuXbR8htUT/7Bhj7XPYDXTgVuqQTa7MsqQSLs8lGQ6LCL0tRbzcZSVm5V9qXnkmTaLAGlyKD0w+7hfc2CdDphZZYLwHtnvmMLLqvM6SSR8xS4YWpGSjoj3XBxF5DG13xwXJutPKe9kzCSMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWBmfkRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWBmfkRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E84C1F00898;
	Mon, 21 Sep 2026 05:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967767;
	bh=2aZNbWYnMAIewNbbTA4KNPAmAvZGl6Lz+s1HvM1Jdew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWBmfkRwWKzwWI9M2lA1FbOlUUwG9rxl0lHhiufFTv4MquQxlcFS+ppvCyBCdVr4g
	 CRpD/++FvU3myBNYA2TglTT52PeVUXGA+nWRoEuoAB65TI2vhn/Ag42HeXXunjMxxk
	 2yzpT4qklm3xFU5OIHuj82M0FzzVpSoaryJ2U9FezVuAoPZLhOvaqa4c9KB7n4QCGJ
	 ZkUdy4feQma0tpwNipqj01pC/bMj3ZARvRmkdwQWuVKtOa0+2/h7IV+zDa76VUBY8d
	 zF6c8juUNmivoiGgbNq18Kaqt0Xd0xR92oiIvp2MTLaNSUY5VzG8T/5VNaA8vpjYE4
	 tez7MFGk5ka4w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/20] lib/crypto: x86/aes-ctr: Migrate AVX-optimized code into library
Date: Sun, 20 Sep 2026 22:08:58 -0700
Message-ID: <20260921050910.296144-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
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

To reduce the diff, the argument order of the assembly functions is kept
as-is for now rather than changed to match their callers.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig                       |   4 +-
 arch/x86/crypto/Makefile                      |   3 +-
 arch/x86/crypto/aesni-intel_glue.c            | 154 ------------------
 crypto/aes.c                                  |   7 +-
 lib/crypto/Makefile                           |   4 +
 .../crypto/x86}/aes-ctr-avx-x86_64.S          |  75 +++++----
 lib/crypto/x86/aes.h                          |  77 ++++++++-
 7 files changed, 123 insertions(+), 201 deletions(-)
 rename {arch/x86/crypto => lib/crypto/x86}/aes-ctr-avx-x86_64.S (92%)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 6dbf5e083966..60d9a144d63a 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,14 +3,14 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_AES_NI_INTEL
-	tristate "Ciphers: AES, modes: CTR, XCTR, XTS, GCM (AES-NI/VAES)"
+	tristate "Ciphers: AES, modes: XTS, GCM (AES-NI/VAES)"
 	select CRYPTO_AEAD
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-	  Length-preserving ciphers: AES with CTR, XCTR, XTS
+	  Length-preserving ciphers: AES with XTS
 
 	  Architecture: x86 (32-bit and 64-bit) using:
 	  - AES-NI (AES new instructions)
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index e04ff8718d6b..370a9cc7eab2 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -41,8 +41,7 @@ aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
 
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
-aesni-intel-$(CONFIG_64BIT) += aes-ctr-avx-x86_64.o \
-			       aes-gcm-aesni-x86_64.o \
+aesni-intel-$(CONFIG_64BIT) += aes-gcm-aesni-x86_64.o \
 			       aes-gcm-vaes-avx2.o \
 			       aes-gcm-vaes-avx512.o \
 			       aes-xts-avx-x86_64.o
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 6acb1fa32c6e..0bda9abae368 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -41,9 +41,7 @@
 
 #define AESNI_ALIGN	16
 #define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
-#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE - 1))
 #define AESNI_ALIGN_EXTRA ((AESNI_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
-#define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
 #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
 
 struct aesni_xts_ctx {
@@ -61,11 +59,6 @@ static inline void *aes_align_addr(void *addr)
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
@@ -89,12 +82,6 @@ static int aes_set_key_common(struct crypto_aes_ctx *ctx,
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
@@ -225,100 +212,6 @@ xts_crypt(struct skcipher_request *req, xts_encrypt_iv_func encrypt_iv,
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
@@ -338,25 +231,6 @@ static int xts_decrypt_##suffix(struct skcipher_request *req)		       \
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
@@ -371,34 +245,6 @@ static struct skcipher_alg skcipher_algs_##suffix[] = {{		       \
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
index cc2cd6b08eee..ac484a28b30e 100644
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
 	  IS_ENABLED(CONFIG_POWERPC) || \
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
similarity index 92%
rename from arch/x86/crypto/aes-ctr-avx-x86_64.S
rename to lib/crypto/x86/aes-ctr-avx-x86_64.S
index 2745918f68ee..654a7cd88027 100644
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
@@ -279,16 +282,16 @@
 
 	// Function arguments
 	.set	KEY,		%rdi	// Initially points to the start of the
-					// crypto_aes_ctx, then is advanced to
+					// aes_enckey, then is advanced to
 					// point to the index 1 round key
 	.set	KEY32,		%edi	// Available as temp register after all
 					// keystream blocks have been generated
 	.set	SRC,		%rsi	// Pointer to next source data
 	.set	DST,		%rdx	// Pointer to next destination data
-	.set	LEN,		%ecx	// Remaining length in bytes.
+	.set	LEN,		%rcx	// Remaining length in bytes.
 					// Note: _load_partial_block relies on
-					// this being in %ecx.
-	.set	LEN64,		%rcx	// Zero-extend LEN before using!
+					// this being in %rcx.
+	.set	LEN32,		%ecx
 	.set	LEN8,		%cl
 .if \is_xctr
 	.set	XCTR_IV_PTR,	%r8	// const u8 iv[AES_BLOCK_SIZE];
@@ -355,17 +358,17 @@
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
@@ -390,7 +393,7 @@
 
 	_prepare_2_ctr_vecs	\is_xctr, 0, 1
 	_prepare_2_ctr_vecs	\is_xctr, 2, 3
-	cmp		$4*VL, LEN
+	cmp		$4*VL, LEN32
 	jle		.Lenc_tail_atmost4vecs\@
 
 	// 4*VL < LEN < 8*VL.  Generate 8 vectors of keystream blocks.  Use the
@@ -405,23 +408,23 @@
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
@@ -432,7 +435,7 @@
 	vaesenclast	RNDKEYLAST, AESDATA3, AESDATA1
 	sub		$-2*VL, SRC
 	sub		$-2*VL, DST
-	add		$-2*VL, LEN
+	add		$-2*VL, LEN32
 	jmp		.Lxor_tail_upto2vecs\@
 
 .Lenc_tail_atmost2vecs\@:
@@ -443,16 +446,16 @@
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
@@ -460,7 +463,7 @@
 	jmp		.Lxor_tail_partial_vec_0\@
 
 .Lxor_tail_partial_vec_2\@:
-	add		$-2*VL, LEN
+	add		$-2*VL, LEN32
 	jz		.Ldone\@
 	sub		$-2*VL, SRC
 	sub		$-2*VL, DST
@@ -468,7 +471,7 @@
 	jmp		.Lxor_tail_partial_vec_0\@
 
 .Lxor_tail_partial_vec_3\@:
-	add		$-3*VL, LEN
+	add		$-3*VL, LEN32
 	jz		.Ldone\@
 	sub		$-3*VL, SRC
 	sub		$-3*VL, DST
@@ -479,25 +482,25 @@
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
+	mov		LEN32, %r10d
 	_load_partial_block	SRC, AESDATA1_XMM, KEY, KEY32
 	vpxor		AESDATA1_XMM, AESDATA0_XMM, AESDATA0_XMM
 	mov		%r10d, %ecx
@@ -515,12 +518,12 @@
 // They have the following prototypes:
 //
 //
-// void aes_ctr64_crypt_##suffix(const struct crypto_aes_ctx *key,
-//				 const u8 *src, u8 *dst, int len,
+// void aes_ctr64_crypt_##suffix(const struct aes_enckey *key,
+//				 const u8 *src, u8 *dst, s64 len,
 //				 const u64 le_ctr[2]);
 //
-// void aes_xctr_crypt_##suffix(const struct crypto_aes_ctx *key,
-//				const u8 *src, u8 *dst, int len,
+// void aes_xctr_crypt_##suffix(const struct aes_enckey *key,
+//				const u8 *src, u8 *dst, s64 len,
 //				const u8 iv[AES_BLOCK_SIZE], u64 ctr);
 //
 // Both functions generate |len| bytes of keystream, XOR it with the data from
@@ -545,27 +548,27 @@
 
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
index def9799302c1..5b4205870b9f 100644
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
 static_assert(offsetof(struct aes_key, inv_k.inv_rndkeys) == 256);
@@ -206,11 +210,33 @@ static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR) && IS_ENABLED(CONFIG_X86_64)
 void aes_ctr64_crypt_aesni(u8 *dst, const u8 *src, s64 len, const u64 le_ctr[2],
 			   const struct aes_enckey *key);
+void aes_ctr64_crypt_aesni_avx(const struct aes_enckey *key, const u8 *src,
+			       u8 *dst, s64 len, const u64 le_ctr[2]);
+void aes_ctr64_crypt_vaes_avx2(const struct aes_enckey *key, const u8 *src,
+			       u8 *dst, s64 len, const u64 le_ctr[2]);
+void aes_ctr64_crypt_vaes_avx512(const struct aes_enckey *key, const u8 *src,
+				 u8 *dst, s64 len, const u64 le_ctr[2]);
+void aes_xctr_crypt_aesni_avx(const struct aes_enckey *key, const u8 *src,
+			      u8 *dst, s64 len, const u8 iv[AES_BLOCK_SIZE],
+			      u64 ctr);
+void aes_xctr_crypt_vaes_avx2(const struct aes_enckey *key, const u8 *src,
+			      u8 *dst, s64 len, const u8 iv[AES_BLOCK_SIZE],
+			      u64 ctr);
+void aes_xctr_crypt_vaes_avx512(const struct aes_enckey *key, const u8 *src,
+				u8 *dst, s64 len, const u8 iv[AES_BLOCK_SIZE],
+				u64 ctr);
 
 static void aes_ctr64_x86(u8 *dst, const u8 *src, size_t len,
 			  const u64 le_ctr[2], const struct aes_enckey *key)
 {
-	aes_ctr64_crypt_aesni(dst, src, len, le_ctr, key);
+	if (static_branch_likely(&have_vaes_avx512))
+		aes_ctr64_crypt_vaes_avx512(key, src, dst, len, le_ctr);
+	else if (static_branch_likely(&have_vaes_avx2))
+		aes_ctr64_crypt_vaes_avx2(key, src, dst, len, le_ctr);
+	else if (static_branch_likely(&have_aesni_avx))
+		aes_ctr64_crypt_aesni_avx(key, src, dst, len, le_ctr);
+	else
+		aes_ctr64_crypt_aesni(dst, src, len, le_ctr, key);
 }
 
 #define aes_ctr_arch aes_ctr_arch
@@ -255,6 +281,25 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
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
+		aes_xctr_crypt_vaes_avx512(key, src, dst, len, iv, ctr);
+	else if (static_branch_likely(&have_vaes_avx2))
+		aes_xctr_crypt_vaes_avx2(key, src, dst, len, iv, ctr);
+	else
+		aes_xctr_crypt_aesni_avx(key, src, dst, len, iv, ctr);
+	kernel_fpu_end();
+	return true;
+}
 #endif /* CONFIG_CRYPTO_LIB_AES_CTR && CONFIG_X86_64 */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
@@ -304,6 +349,32 @@ static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
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
+	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
+	    !boot_cpu_has(X86_FEATURE_VAES) ||
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

