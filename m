Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbeLEGVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:21:35 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] crypto: x86/chacha20 - add XChaCha20 support
Date: Tue,  4 Dec 2018 22:20:02 -0800
Message-Id: <20181205062005.27727-4-ebiggers@kernel.org>
In-Reply-To: <20181205062005.27727-1-ebiggers@kernel.org>
References: <20181205062005.27727-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Add an XChaCha20 implementation that is hooked up to the x86_64 SIMD
implementations of ChaCha20.  This can be used by Adiantum.

An SSSE3 implementation of single-block HChaCha20 is also added so that
XChaCha20 can use it rather than the generic implementation.  This
required refactoring the ChaCha permutation into its own function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/chacha20-ssse3-x86_64.S |  81 ++++++++++++------
 arch/x86/crypto/chacha20_glue.c         | 108 ++++++++++++++++++------
 crypto/Kconfig                          |  12 +--
 3 files changed, 141 insertions(+), 60 deletions(-)

diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha20-ssse3-x86_64.S
index d8ac75bb448f..f6792789f875 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha20-ssse3-x86_64.S
@@ -10,6 +10,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/frame.h>
 
 .section	.rodata.cst16.ROT8, "aM", @progbits, 16
 .align 16
@@ -23,37 +24,24 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 
 .text
 
-ENTRY(chacha20_block_xor_ssse3)
-	# %rdi: Input state matrix, s
-	# %rsi: up to 1 data block output, o
-	# %rdx: up to 1 data block input, i
-	# %rcx: input/output length in bytes
-
-	# This function encrypts one ChaCha20 block by loading the state matrix
-	# in four SSE registers. It performs matrix operation on four words in
-	# parallel, but requires shuffling to rearrange the words after each
-	# round. 8/16-bit word rotation is done with the slightly better
-	# performing SSSE3 byte shuffling, 7/12-bit word rotation uses
-	# traditional shift+OR.
-
-	# x0..3 = s0..3
-	movdqa		0x00(%rdi),%xmm0
-	movdqa		0x10(%rdi),%xmm1
-	movdqa		0x20(%rdi),%xmm2
-	movdqa		0x30(%rdi),%xmm3
-	movdqa		%xmm0,%xmm8
-	movdqa		%xmm1,%xmm9
-	movdqa		%xmm2,%xmm10
-	movdqa		%xmm3,%xmm11
+/*
+ * chacha20_permute - permute one block
+ *
+ * Permute one 64-byte block where the state matrix is in %xmm0-%xmm3.  This
+ * function performs matrix operations on four words in parallel, but requires
+ * shuffling to rearrange the words after each round.  8/16-bit word rotation is
+ * done with the slightly better performing SSSE3 byte shuffling, 7/12-bit word
+ * rotation uses traditional shift+OR.
+ *
+ * Clobbers: %ecx, %xmm4-%xmm7
+ */
+chacha20_permute:
 
 	movdqa		ROT8(%rip),%xmm4
 	movdqa		ROT16(%rip),%xmm5
-
-	mov		%rcx,%rax
 	mov		$10,%ecx
 
 .Ldoubleround:
-
 	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
 	paddd		%xmm1,%xmm0
 	pxor		%xmm0,%xmm3
@@ -123,6 +111,29 @@ ENTRY(chacha20_block_xor_ssse3)
 	dec		%ecx
 	jnz		.Ldoubleround
 
+	ret
+ENDPROC(chacha20_permute)
+
+ENTRY(chacha20_block_xor_ssse3)
+	# %rdi: Input state matrix, s
+	# %rsi: up to 1 data block output, o
+	# %rdx: up to 1 data block input, i
+	# %rcx: input/output length in bytes
+	FRAME_BEGIN
+
+	# x0..3 = s0..3
+	movdqa		0x00(%rdi),%xmm0
+	movdqa		0x10(%rdi),%xmm1
+	movdqa		0x20(%rdi),%xmm2
+	movdqa		0x30(%rdi),%xmm3
+	movdqa		%xmm0,%xmm8
+	movdqa		%xmm1,%xmm9
+	movdqa		%xmm2,%xmm10
+	movdqa		%xmm3,%xmm11
+
+	mov		%rcx,%rax
+	call		chacha20_permute
+
 	# o0 = i0 ^ (x0 + s0)
 	paddd		%xmm8,%xmm0
 	cmp		$0x10,%rax
@@ -156,6 +167,7 @@ ENTRY(chacha20_block_xor_ssse3)
 	movdqu		%xmm0,0x30(%rsi)
 
 .Ldone:
+	FRAME_END
 	ret
 
 .Lxorpart:
@@ -189,6 +201,25 @@ ENTRY(chacha20_block_xor_ssse3)
 
 ENDPROC(chacha20_block_xor_ssse3)
 
+ENTRY(hchacha20_block_ssse3)
+	# %rdi: Input state matrix, s
+	# %rsi: output (8 32-bit words)
+	FRAME_BEGIN
+
+	movdqa		0x00(%rdi),%xmm0
+	movdqa		0x10(%rdi),%xmm1
+	movdqa		0x20(%rdi),%xmm2
+	movdqa		0x30(%rdi),%xmm3
+
+	call		chacha20_permute
+
+	movdqu		%xmm0,0x00(%rsi)
+	movdqu		%xmm3,0x10(%rsi)
+
+	FRAME_END
+	ret
+ENDPROC(hchacha20_block_ssse3)
+
 ENTRY(chacha20_4block_xor_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 4 data blocks output, o
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
index 773d075a1483..70d388e4a3a2 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha20_glue.c
@@ -23,6 +23,7 @@ asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
 asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 					  unsigned int len);
+asmlinkage void hchacha20_block_ssse3(const u32 *state, u32 *out);
 #ifdef CONFIG_AS_AVX2
 asmlinkage void chacha20_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
 					 unsigned int len);
@@ -121,10 +122,9 @@ static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
 	}
 }
 
-static int chacha20_simd(struct skcipher_request *req)
+static int chacha20_simd_stream_xor(struct skcipher_request *req,
+				    struct chacha_ctx *ctx, u8 *iv)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 *state, state_buf[16 + 2] __aligned(8);
 	struct skcipher_walk walk;
 	int err;
@@ -132,14 +132,9 @@ static int chacha20_simd(struct skcipher_request *req)
 	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
 	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
 
-	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
-		return crypto_chacha_crypt(req);
-
 	err = skcipher_walk_virt(&walk, req, true);
 
-	crypto_chacha_init(state, ctx, walk.iv);
-
-	kernel_fpu_begin();
+	crypto_chacha_init(state, ctx, iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -153,26 +148,85 @@ static int chacha20_simd(struct skcipher_request *req)
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
+	return err;
+}
+
+static int chacha20_simd(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err;
+
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !irq_fpu_usable())
+		return crypto_chacha_crypt(req);
+
+	kernel_fpu_begin();
+	err = chacha20_simd_stream_xor(req, ctx, req->iv);
+	kernel_fpu_end();
+	return err;
+}
+
+static int xchacha20_simd(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct chacha_ctx subctx;
+	u32 *state, state_buf[16 + 2] __aligned(8);
+	u8 real_iv[16];
+	int err;
+
+	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !irq_fpu_usable())
+		return crypto_xchacha_crypt(req);
+
+	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
+	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
+	crypto_chacha_init(state, ctx, req->iv);
+
+	kernel_fpu_begin();
+
+	hchacha20_block_ssse3(state, subctx.key);
+
+	memcpy(&real_iv[0], req->iv + 24, 8);
+	memcpy(&real_iv[8], req->iv + 16, 8);
+	err = chacha20_simd_stream_xor(req, &subctx, real_iv);
+
 	kernel_fpu_end();
 
 	return err;
 }
 
-static struct skcipher_alg alg = {
-	.base.cra_name		= "chacha20",
-	.base.cra_driver_name	= "chacha20-simd",
-	.base.cra_priority	= 300,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct chacha_ctx),
-	.base.cra_module	= THIS_MODULE,
-
-	.min_keysize		= CHACHA_KEY_SIZE,
-	.max_keysize		= CHACHA_KEY_SIZE,
-	.ivsize			= CHACHA_IV_SIZE,
-	.chunksize		= CHACHA_BLOCK_SIZE,
-	.setkey			= crypto_chacha20_setkey,
-	.encrypt		= chacha20_simd,
-	.decrypt		= chacha20_simd,
+static struct skcipher_alg algs[] = {
+	{
+		.base.cra_name		= "chacha20",
+		.base.cra_driver_name	= "chacha20-simd",
+		.base.cra_priority	= 300,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= CHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.setkey			= crypto_chacha20_setkey,
+		.encrypt		= chacha20_simd,
+		.decrypt		= chacha20_simd,
+	}, {
+		.base.cra_name		= "xchacha20",
+		.base.cra_driver_name	= "xchacha20-simd",
+		.base.cra_priority	= 300,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct chacha_ctx),
+		.base.cra_module	= THIS_MODULE,
+
+		.min_keysize		= CHACHA_KEY_SIZE,
+		.max_keysize		= CHACHA_KEY_SIZE,
+		.ivsize			= XCHACHA_IV_SIZE,
+		.chunksize		= CHACHA_BLOCK_SIZE,
+		.setkey			= crypto_chacha20_setkey,
+		.encrypt		= xchacha20_simd,
+		.decrypt		= xchacha20_simd,
+	},
 };
 
 static int __init chacha20_simd_mod_init(void)
@@ -190,12 +244,12 @@ static int __init chacha20_simd_mod_init(void)
 				boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
 #endif
 #endif
-	return crypto_register_skcipher(&alg);
+	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit chacha20_simd_mod_fini(void)
 {
-	crypto_unregister_skcipher(&alg);
+	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 module_init(chacha20_simd_mod_init);
@@ -206,3 +260,5 @@ MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("chacha20 cipher algorithm, SIMD accelerated");
 MODULE_ALIAS_CRYPTO("chacha20");
 MODULE_ALIAS_CRYPTO("chacha20-simd");
+MODULE_ALIAS_CRYPTO("xchacha20");
+MODULE_ALIAS_CRYPTO("xchacha20-simd");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e084e2fb6743..df466771e9bf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1468,19 +1468,13 @@ config CRYPTO_CHACHA20
 	  in some performance-sensitive scenarios.
 
 config CRYPTO_CHACHA20_X86_64
-	tristate "ChaCha20 cipher algorithm (x86_64/SSSE3/AVX2)"
+	tristate "ChaCha stream cipher algorithms (x86_64/SSSE3/AVX2/AVX-512VL)"
 	depends on X86 && 64BIT
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_CHACHA20
 	help
-	  ChaCha20 cipher algorithm, RFC7539.
-
-	  ChaCha20 is a 256-bit high-speed stream cipher designed by Daniel J.
-	  Bernstein and further specified in RFC7539 for use in IETF protocols.
-	  This is the x86_64 assembler implementation using SIMD instructions.
-
-	  See also:
-	  <http://cr.yp.to/chacha/chacha-20080128.pdf>
+	  SSSE3, AVX2, and AVX-512VL optimized implementations of the ChaCha20
+	  and XChaCha20 stream ciphers.
 
 config CRYPTO_SEED
 	tristate "SEED cipher algorithm"
-- 
2.19.2
