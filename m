Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727568AbeK2Rjf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 12:39:35 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: arm64/chacha20 - refactor to allow varying number of rounds
Date: Wed, 28 Nov 2018 22:34:21 -0800
Message-Id: <20181129063422.24307-4-ebiggers@kernel.org>
In-Reply-To: <20181129063422.24307-1-ebiggers@kernel.org>
References: <20181129063422.24307-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In preparation for adding XChaCha12 support, rename/refactor the ARM64
NEON implementation of ChaCha20 to support different numbers of rounds.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/Makefile                    |  4 +-
 ...hacha20-neon-core.S => chacha-neon-core.S} | 45 ++++++++-------
 ...hacha20-neon-glue.c => chacha-neon-glue.c} | 57 ++++++++++---------
 3 files changed, 57 insertions(+), 49 deletions(-)
 rename arch/arm64/crypto/{chacha20-neon-core.S => chacha-neon-core.S} (94%)
 rename arch/arm64/crypto/{chacha20-neon-glue.c => chacha-neon-glue.c} (71%)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 125dbb10a93ed..a4ffd9fe32650 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -50,8 +50,8 @@ sha256-arm64-y := sha256-glue.o sha256-core.o
 obj-$(CONFIG_CRYPTO_SHA512_ARM64) += sha512-arm64.o
 sha512-arm64-y := sha512-glue.o sha512-core.o
 
-obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
-chacha20-neon-y := chacha20-neon-core.o chacha20-neon-glue.o
+obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
+chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
 
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
 nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
diff --git a/arch/arm64/crypto/chacha20-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
similarity index 94%
rename from arch/arm64/crypto/chacha20-neon-core.S
rename to arch/arm64/crypto/chacha-neon-core.S
index 378850505c0ae..75b4e06cee79f 100644
--- a/arch/arm64/crypto/chacha20-neon-core.S
+++ b/arch/arm64/crypto/chacha-neon-core.S
@@ -1,5 +1,5 @@
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, arm64 NEON functions
+ * ChaCha/XChaCha NEON helper functions
  *
  * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
@@ -24,17 +24,18 @@
 	.align		6
 
 /*
- * chacha20_permute - permute one block
+ * chacha_permute - permute one block
  *
  * Permute one 64-byte block where the state matrix is stored in the four NEON
  * registers v0-v3.  It performs matrix operations on four words in parallel,
  * but requires shuffling to rearrange the words after each round.
  *
- * Clobbers: x3, x10, v4, v12
+ * The round count is given in w3.
+ *
+ * Clobbers: w3, x10, v4, v12
  */
-chacha20_permute:
+chacha_permute:
 
-	mov		x3, #10
 	adr		x10, ROT8
 	ld1		{v12.4s}, [x10]
 
@@ -97,16 +98,17 @@ chacha20_permute:
 	// x3 = shuffle32(x3, MASK(0, 3, 2, 1))
 	ext		v3.16b, v3.16b, v3.16b, #4
 
-	subs		x3, x3, #1
+	subs		w3, w3, #2
 	b.ne		.Ldoubleround
 
 	ret
-ENDPROC(chacha20_permute)
+ENDPROC(chacha_permute)
 
-ENTRY(chacha20_block_xor_neon)
+ENTRY(chacha_block_xor_neon)
 	// x0: Input state matrix, s
 	// x1: 1 data block output, o
 	// x2: 1 data block input, i
+	// w3: nrounds
 
 	mov		x9, lr
 
@@ -114,7 +116,7 @@ ENTRY(chacha20_block_xor_neon)
 	ld1		{v0.4s-v3.4s}, [x0]
 	ld1		{v8.4s-v11.4s}, [x0]
 
-	bl		chacha20_permute
+	bl		chacha_permute
 
 	ld1		{v4.16b-v7.16b}, [x2]
 
@@ -137,39 +139,42 @@ ENTRY(chacha20_block_xor_neon)
 	st1		{v0.16b-v3.16b}, [x1]
 
 	ret		x9
-ENDPROC(chacha20_block_xor_neon)
+ENDPROC(chacha_block_xor_neon)
 
-ENTRY(hchacha20_block_neon)
+ENTRY(hchacha_block_neon)
 	// x0: Input state matrix, s
 	// x1: output (8 32-bit words)
+	// w2: nrounds
 	mov		x9, lr
 
 	ld1		{v0.4s-v3.4s}, [x0]
 
-	bl		chacha20_permute
+	mov		w3, w2
+	bl		chacha_permute
 
 	st1		{v0.16b}, [x1], #16
 	st1		{v3.16b}, [x1]
 
 	ret		x9
-ENDPROC(hchacha20_block_neon)
+ENDPROC(hchacha_block_neon)
 
 	.align		6
-ENTRY(chacha20_4block_xor_neon)
+ENTRY(chacha_4block_xor_neon)
 	// x0: Input state matrix, s
 	// x1: 4 data blocks output, o
 	// x2: 4 data blocks input, i
+	// w3: nrounds
 
 	//
-	// This function encrypts four consecutive ChaCha20 blocks by loading
+	// This function encrypts four consecutive ChaCha blocks by loading
 	// the state matrix in NEON registers four times. The algorithm performs
 	// each operation on the corresponding word of each state matrix, hence
 	// requires no word shuffling. For final XORing step we transpose the
 	// matrix by interleaving 32- and then 64-bit words, which allows us to
 	// do XOR in NEON registers.
 	//
-	adr		x3, CTRINC		// ... and ROT8
-	ld1		{v30.4s-v31.4s}, [x3]
+	adr		x9, CTRINC		// ... and ROT8
+	ld1		{v30.4s-v31.4s}, [x9]
 
 	// x0..15[0-3] = s0..3[0..3]
 	mov		x4, x0
@@ -181,8 +186,6 @@ ENTRY(chacha20_4block_xor_neon)
 	// x12 += counter values 0-3
 	add		v12.4s, v12.4s, v30.4s
 
-	mov		x3, #10
-
 .Ldoubleround4:
 	// x0 += x4, x12 = rotl32(x12 ^ x0, 16)
 	// x1 += x5, x13 = rotl32(x13 ^ x1, 16)
@@ -356,7 +359,7 @@ ENTRY(chacha20_4block_xor_neon)
 	sri		v7.4s, v18.4s, #25
 	sri		v4.4s, v19.4s, #25
 
-	subs		x3, x3, #1
+	subs		w3, w3, #2
 	b.ne		.Ldoubleround4
 
 	ld4r		{v16.4s-v19.4s}, [x0], #16
@@ -470,7 +473,7 @@ ENTRY(chacha20_4block_xor_neon)
 	st1		{v28.16b-v31.16b}, [x1]
 
 	ret
-ENDPROC(chacha20_4block_xor_neon)
+ENDPROC(chacha_4block_xor_neon)
 
 CTRINC:	.word		0, 1, 2, 3
 ROT8:	.word		0x02010003, 0x06050407, 0x0a09080b, 0x0e0d0c0f
diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
similarity index 71%
rename from arch/arm64/crypto/chacha20-neon-glue.c
rename to arch/arm64/crypto/chacha-neon-glue.c
index a5b9cbc0c4de4..4d992029b9121 100644
--- a/arch/arm64/crypto/chacha20-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -1,5 +1,6 @@
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, arm64 NEON functions
+ * ARM NEON accelerated ChaCha and XChaCha stream ciphers,
+ * including ChaCha20 (RFC7539)
  *
  * Copyright (C) 2016 - 2017 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
@@ -28,18 +29,20 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 
-asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
-asmlinkage void hchacha20_block_neon(const u32 *state, u32 *out);
+asmlinkage void chacha_block_xor_neon(u32 *state, u8 *dst, const u8 *src,
+				      int nrounds);
+asmlinkage void chacha_4block_xor_neon(u32 *state, u8 *dst, const u8 *src,
+				       int nrounds);
+asmlinkage void hchacha_block_neon(const u32 *state, u32 *out, int nrounds);
 
-static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
-			    unsigned int bytes)
+static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
+			  unsigned int bytes, int nrounds)
 {
 	u8 buf[CHACHA_BLOCK_SIZE];
 
 	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
 		kernel_neon_begin();
-		chacha20_4block_xor_neon(state, dst, src);
+		chacha_4block_xor_neon(state, dst, src, nrounds);
 		kernel_neon_end();
 		bytes -= CHACHA_BLOCK_SIZE * 4;
 		src += CHACHA_BLOCK_SIZE * 4;
@@ -52,7 +55,7 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
 
 	kernel_neon_begin();
 	while (bytes >= CHACHA_BLOCK_SIZE) {
-		chacha20_block_xor_neon(state, dst, src);
+		chacha_block_xor_neon(state, dst, src, nrounds);
 		bytes -= CHACHA_BLOCK_SIZE;
 		src += CHACHA_BLOCK_SIZE;
 		dst += CHACHA_BLOCK_SIZE;
@@ -60,14 +63,14 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
 	}
 	if (bytes) {
 		memcpy(buf, src, bytes);
-		chacha20_block_xor_neon(state, buf, buf);
+		chacha_block_xor_neon(state, buf, buf, nrounds);
 		memcpy(dst, buf, bytes);
 	}
 	kernel_neon_end();
 }
 
-static int chacha20_neon_stream_xor(struct skcipher_request *req,
-				    struct chacha_ctx *ctx, u8 *iv)
+static int chacha_neon_stream_xor(struct skcipher_request *req,
+				  struct chacha_ctx *ctx, u8 *iv)
 {
 	struct skcipher_walk walk;
 	u32 state[16];
@@ -83,15 +86,15 @@ static int chacha20_neon_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		chacha20_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
-				nbytes);
+		chacha_doneon(state, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes, ctx->nrounds);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
 }
 
-static int chacha20_neon(struct skcipher_request *req)
+static int chacha_neon(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -99,10 +102,10 @@ static int chacha20_neon(struct skcipher_request *req)
 	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
 		return crypto_chacha_crypt(req);
 
-	return chacha20_neon_stream_xor(req, ctx, req->iv);
+	return chacha_neon_stream_xor(req, ctx, req->iv);
 }
 
-static int xchacha20_neon(struct skcipher_request *req)
+static int xchacha_neon(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -116,12 +119,13 @@ static int xchacha20_neon(struct skcipher_request *req)
 	crypto_chacha_init(state, ctx, req->iv);
 
 	kernel_neon_begin();
-	hchacha20_block_neon(state, subctx.key);
+	hchacha_block_neon(state, subctx.key, ctx->nrounds);
 	kernel_neon_end();
+	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha20_neon_stream_xor(req, &subctx, real_iv);
+	return chacha_neon_stream_xor(req, &subctx, real_iv);
 }
 
 static struct skcipher_alg algs[] = {
@@ -139,8 +143,8 @@ static struct skcipher_alg algs[] = {
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 4 * CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= chacha20_neon,
-		.decrypt		= chacha20_neon,
+		.encrypt		= chacha_neon,
+		.decrypt		= chacha_neon,
 	}, {
 		.base.cra_name		= "xchacha20",
 		.base.cra_driver_name	= "xchacha20-neon",
@@ -155,12 +159,12 @@ static struct skcipher_alg algs[] = {
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 4 * CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= xchacha20_neon,
-		.decrypt		= xchacha20_neon,
+		.encrypt		= xchacha_neon,
+		.decrypt		= xchacha_neon,
 	}
 };
 
-static int __init chacha20_simd_mod_init(void)
+static int __init chacha_simd_mod_init(void)
 {
 	if (!(elf_hwcap & HWCAP_ASIMD))
 		return -ENODEV;
@@ -168,14 +172,15 @@ static int __init chacha20_simd_mod_init(void)
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-static void __exit chacha20_simd_mod_fini(void)
+static void __exit chacha_simd_mod_fini(void)
 {
 	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-module_init(chacha20_simd_mod_init);
-module_exit(chacha20_simd_mod_fini);
+module_init(chacha_simd_mod_init);
+module_exit(chacha_simd_mod_fini);
 
+MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (NEON accelerated)");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("chacha20");
-- 
2.19.2
