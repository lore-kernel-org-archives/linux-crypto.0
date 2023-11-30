Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A04D46
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:48 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g8u-005IIl-2N; Thu, 30 Nov 2023 20:27:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:27:53 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:27:53 +0800
Subject: [PATCH 2/19] crypto: x86/sm4 - Remove cfb(sm4)
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g8u-005IIl-2N@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/Kconfig                 |    8 -
 arch/x86/crypto/sm4-aesni-avx-asm_64.S  |   52 ------------
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S |   55 -------------
 arch/x86/crypto/sm4-avx.h               |    4 
 arch/x86/crypto/sm4_aesni_avx2_glue.c   |   26 ------
 arch/x86/crypto/sm4_aesni_avx_glue.c    |  130 --------------------------------
 6 files changed, 4 insertions(+), 271 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 9bbfd01cfa2f..c9e59589a1ce 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -189,7 +189,7 @@ config CRYPTO_SERPENT_AVX2_X86_64
 	  Processes 16 blocks in parallel.
 
 config CRYPTO_SM4_AESNI_AVX_X86_64
-	tristate "Ciphers: SM4 with modes: ECB, CBC, CFB, CTR (AES-NI/AVX)"
+	tristate "Ciphers: SM4 with modes: ECB, CBC, CTR (AES-NI/AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
@@ -197,7 +197,7 @@ config CRYPTO_SM4_AESNI_AVX_X86_64
 	select CRYPTO_SM4
 	help
 	  Length-preserving ciphers: SM4 cipher algorithms
-	  (OSCCA GB/T 32907-2016) with ECB, CBC, CFB, and CTR modes
+	  (OSCCA GB/T 32907-2016) with ECB, CBC, and CTR modes
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
@@ -210,7 +210,7 @@ config CRYPTO_SM4_AESNI_AVX_X86_64
 	  If unsure, say N.
 
 config CRYPTO_SM4_AESNI_AVX2_X86_64
-	tristate "Ciphers: SM4 with modes: ECB, CBC, CFB, CTR (AES-NI/AVX2)"
+	tristate "Ciphers: SM4 with modes: ECB, CBC, CTR (AES-NI/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SIMD
@@ -219,7 +219,7 @@ config CRYPTO_SM4_AESNI_AVX2_X86_64
 	select CRYPTO_SM4_AESNI_AVX_X86_64
 	help
 	  Length-preserving ciphers: SM4 cipher algorithms
-	  (OSCCA GB/T 32907-2016) with ECB, CBC, CFB, and CTR modes
+	  (OSCCA GB/T 32907-2016) with ECB, CBC, and CTR modes
 
 	  Architecture: x86_64 using:
 	  - AES-NI (AES New Instructions)
diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index e2668d2fe6ce..2bf611eaa191 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -534,55 +534,3 @@ SYM_TYPED_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
 	FRAME_END
 	RET;
 SYM_FUNC_END(sm4_aesni_avx_cbc_dec_blk8)
-
-/*
- * void sm4_aesni_avx_cfb_dec_blk8(const u32 *rk, u8 *dst,
- *                                 const u8 *src, u8 *iv)
- */
-SYM_TYPED_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
-	/* input:
-	 *	%rdi: round key array, CTX
-	 *	%rsi: dst (8 blocks)
-	 *	%rdx: src (8 blocks)
-	 *	%rcx: iv
-	 */
-	FRAME_BEGIN
-
-	/* Load input */
-	vmovdqu (%rcx), RA0;
-	vmovdqu 0 * 16(%rdx), RA1;
-	vmovdqu 1 * 16(%rdx), RA2;
-	vmovdqu 2 * 16(%rdx), RA3;
-	vmovdqu 3 * 16(%rdx), RB0;
-	vmovdqu 4 * 16(%rdx), RB1;
-	vmovdqu 5 * 16(%rdx), RB2;
-	vmovdqu 6 * 16(%rdx), RB3;
-
-	/* Update IV */
-	vmovdqu 7 * 16(%rdx), RNOT;
-	vmovdqu RNOT, (%rcx);
-
-	call __sm4_crypt_blk8;
-
-	vpxor (0 * 16)(%rdx), RA0, RA0;
-	vpxor (1 * 16)(%rdx), RA1, RA1;
-	vpxor (2 * 16)(%rdx), RA2, RA2;
-	vpxor (3 * 16)(%rdx), RA3, RA3;
-	vpxor (4 * 16)(%rdx), RB0, RB0;
-	vpxor (5 * 16)(%rdx), RB1, RB1;
-	vpxor (6 * 16)(%rdx), RB2, RB2;
-	vpxor (7 * 16)(%rdx), RB3, RB3;
-
-	vmovdqu RA0, (0 * 16)(%rsi);
-	vmovdqu RA1, (1 * 16)(%rsi);
-	vmovdqu RA2, (2 * 16)(%rsi);
-	vmovdqu RA3, (3 * 16)(%rsi);
-	vmovdqu RB0, (4 * 16)(%rsi);
-	vmovdqu RB1, (5 * 16)(%rsi);
-	vmovdqu RB2, (6 * 16)(%rsi);
-	vmovdqu RB3, (7 * 16)(%rsi);
-
-	vzeroall;
-	FRAME_END
-	RET;
-SYM_FUNC_END(sm4_aesni_avx_cfb_dec_blk8)
diff --git a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
index 98ede9459287..9ff5ba075591 100644
--- a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
@@ -439,58 +439,3 @@ SYM_TYPED_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
 	FRAME_END
 	RET;
 SYM_FUNC_END(sm4_aesni_avx2_cbc_dec_blk16)
-
-/*
- * void sm4_aesni_avx2_cfb_dec_blk16(const u32 *rk, u8 *dst,
- *                                   const u8 *src, u8 *iv)
- */
-SYM_TYPED_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
-	/* input:
-	 *	%rdi: round key array, CTX
-	 *	%rsi: dst (16 blocks)
-	 *	%rdx: src (16 blocks)
-	 *	%rcx: iv
-	 */
-	FRAME_BEGIN
-
-	vzeroupper;
-
-	/* Load input */
-	vmovdqu (%rcx), RNOTx;
-	vinserti128 $1, (%rdx), RNOT, RA0;
-	vmovdqu (0 * 32 + 16)(%rdx), RA1;
-	vmovdqu (1 * 32 + 16)(%rdx), RA2;
-	vmovdqu (2 * 32 + 16)(%rdx), RA3;
-	vmovdqu (3 * 32 + 16)(%rdx), RB0;
-	vmovdqu (4 * 32 + 16)(%rdx), RB1;
-	vmovdqu (5 * 32 + 16)(%rdx), RB2;
-	vmovdqu (6 * 32 + 16)(%rdx), RB3;
-
-	/* Update IV */
-	vmovdqu (7 * 32 + 16)(%rdx), RNOTx;
-	vmovdqu RNOTx, (%rcx);
-
-	call __sm4_crypt_blk16;
-
-	vpxor (0 * 32)(%rdx), RA0, RA0;
-	vpxor (1 * 32)(%rdx), RA1, RA1;
-	vpxor (2 * 32)(%rdx), RA2, RA2;
-	vpxor (3 * 32)(%rdx), RA3, RA3;
-	vpxor (4 * 32)(%rdx), RB0, RB0;
-	vpxor (5 * 32)(%rdx), RB1, RB1;
-	vpxor (6 * 32)(%rdx), RB2, RB2;
-	vpxor (7 * 32)(%rdx), RB3, RB3;
-
-	vmovdqu RA0, (0 * 32)(%rsi);
-	vmovdqu RA1, (1 * 32)(%rsi);
-	vmovdqu RA2, (2 * 32)(%rsi);
-	vmovdqu RA3, (3 * 32)(%rsi);
-	vmovdqu RB0, (4 * 32)(%rsi);
-	vmovdqu RB1, (5 * 32)(%rsi);
-	vmovdqu RB2, (6 * 32)(%rsi);
-	vmovdqu RB3, (7 * 32)(%rsi);
-
-	vzeroall;
-	FRAME_END
-	RET;
-SYM_FUNC_END(sm4_aesni_avx2_cfb_dec_blk16)
diff --git a/arch/x86/crypto/sm4-avx.h b/arch/x86/crypto/sm4-avx.h
index 1bceab7516aa..b5b5e67e40ed 100644
--- a/arch/x86/crypto/sm4-avx.h
+++ b/arch/x86/crypto/sm4-avx.h
@@ -14,10 +14,6 @@ int sm4_cbc_encrypt(struct skcipher_request *req);
 int sm4_avx_cbc_decrypt(struct skcipher_request *req,
 			unsigned int bsize, sm4_crypt_func func);
 
-int sm4_cfb_encrypt(struct skcipher_request *req);
-int sm4_avx_cfb_decrypt(struct skcipher_request *req,
-			unsigned int bsize, sm4_crypt_func func);
-
 int sm4_avx_ctr_crypt(struct skcipher_request *req,
 			unsigned int bsize, sm4_crypt_func func);
 
diff --git a/arch/x86/crypto/sm4_aesni_avx2_glue.c b/arch/x86/crypto/sm4_aesni_avx2_glue.c
index 84bc718f49a3..1148fd4cd57f 100644
--- a/arch/x86/crypto/sm4_aesni_avx2_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx2_glue.c
@@ -23,8 +23,6 @@ asmlinkage void sm4_aesni_avx2_ctr_enc_blk16(const u32 *rk, u8 *dst,
 					const u8 *src, u8 *iv);
 asmlinkage void sm4_aesni_avx2_cbc_dec_blk16(const u32 *rk, u8 *dst,
 					const u8 *src, u8 *iv);
-asmlinkage void sm4_aesni_avx2_cfb_dec_blk16(const u32 *rk, u8 *dst,
-					const u8 *src, u8 *iv);
 
 static int sm4_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int key_len)
@@ -41,12 +39,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 }
 
 
-static int cfb_decrypt(struct skcipher_request *req)
-{
-	return sm4_avx_cfb_decrypt(req, SM4_CRYPT16_BLOCK_SIZE,
-				sm4_aesni_avx2_cfb_dec_blk16);
-}
-
 static int ctr_crypt(struct skcipher_request *req)
 {
 	return sm4_avx_ctr_crypt(req, SM4_CRYPT16_BLOCK_SIZE,
@@ -87,24 +79,6 @@ static struct skcipher_alg sm4_aesni_avx2_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= cbc_decrypt,
-	}, {
-		.base = {
-			.cra_name		= "__cfb(sm4)",
-			.cra_driver_name	= "__cfb-sm4-aesni-avx2",
-			.cra_priority		= 500,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
-			.cra_blocksize		= 1,
-			.cra_ctxsize		= sizeof(struct sm4_ctx),
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= SM4_KEY_SIZE,
-		.max_keysize	= SM4_KEY_SIZE,
-		.ivsize		= SM4_BLOCK_SIZE,
-		.chunksize	= SM4_BLOCK_SIZE,
-		.walksize	= 16 * SM4_BLOCK_SIZE,
-		.setkey		= sm4_skcipher_setkey,
-		.encrypt	= sm4_cfb_encrypt,
-		.decrypt	= cfb_decrypt,
 	}, {
 		.base = {
 			.cra_name		= "__ctr(sm4)",
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index 7800f77d68ad..85b4ca78b47b 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -27,8 +27,6 @@ asmlinkage void sm4_aesni_avx_ctr_enc_blk8(const u32 *rk, u8 *dst,
 				const u8 *src, u8 *iv);
 asmlinkage void sm4_aesni_avx_cbc_dec_blk8(const u32 *rk, u8 *dst,
 				const u8 *src, u8 *iv);
-asmlinkage void sm4_aesni_avx_cfb_dec_blk8(const u32 *rk, u8 *dst,
-				const u8 *src, u8 *iv);
 
 static int sm4_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int key_len)
@@ -188,116 +186,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 				sm4_aesni_avx_cbc_dec_blk8);
 }
 
-int sm4_cfb_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) > 0) {
-		u8 keystream[SM4_BLOCK_SIZE];
-		const u8 *iv = walk.iv;
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-
-		while (nbytes >= SM4_BLOCK_SIZE) {
-			sm4_crypt_block(ctx->rkey_enc, keystream, iv);
-			crypto_xor_cpy(dst, src, keystream, SM4_BLOCK_SIZE);
-			iv = dst;
-			src += SM4_BLOCK_SIZE;
-			dst += SM4_BLOCK_SIZE;
-			nbytes -= SM4_BLOCK_SIZE;
-		}
-		if (iv != walk.iv)
-			memcpy(walk.iv, iv, SM4_BLOCK_SIZE);
-
-		/* tail */
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			sm4_crypt_block(ctx->rkey_enc, keystream, walk.iv);
-			crypto_xor_cpy(dst, src, keystream, nbytes);
-			nbytes = 0;
-		}
-
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(sm4_cfb_encrypt);
-
-int sm4_avx_cfb_decrypt(struct skcipher_request *req,
-			unsigned int bsize, sm4_crypt_func func)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct sm4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) > 0) {
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-
-		kernel_fpu_begin();
-
-		while (nbytes >= bsize) {
-			func(ctx->rkey_enc, dst, src, walk.iv);
-			dst += bsize;
-			src += bsize;
-			nbytes -= bsize;
-		}
-
-		while (nbytes >= SM4_BLOCK_SIZE) {
-			u8 keystream[SM4_BLOCK_SIZE * 8];
-			unsigned int nblocks = min(nbytes >> 4, 8u);
-
-			memcpy(keystream, walk.iv, SM4_BLOCK_SIZE);
-			if (nblocks > 1)
-				memcpy(&keystream[SM4_BLOCK_SIZE], src,
-					(nblocks - 1) * SM4_BLOCK_SIZE);
-			memcpy(walk.iv, src + (nblocks - 1) * SM4_BLOCK_SIZE,
-				SM4_BLOCK_SIZE);
-
-			sm4_aesni_avx_crypt8(ctx->rkey_enc, keystream,
-						keystream, nblocks);
-
-			crypto_xor_cpy(dst, src, keystream,
-					nblocks * SM4_BLOCK_SIZE);
-			dst += nblocks * SM4_BLOCK_SIZE;
-			src += nblocks * SM4_BLOCK_SIZE;
-			nbytes -= nblocks * SM4_BLOCK_SIZE;
-		}
-
-		kernel_fpu_end();
-
-		/* tail */
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[SM4_BLOCK_SIZE];
-
-			sm4_crypt_block(ctx->rkey_enc, keystream, walk.iv);
-			crypto_xor_cpy(dst, src, keystream, nbytes);
-			nbytes = 0;
-		}
-
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(sm4_avx_cfb_decrypt);
-
-static int cfb_decrypt(struct skcipher_request *req)
-{
-	return sm4_avx_cfb_decrypt(req, SM4_CRYPT8_BLOCK_SIZE,
-				sm4_aesni_avx_cfb_dec_blk8);
-}
-
 int sm4_avx_ctr_crypt(struct skcipher_request *req,
 			unsigned int bsize, sm4_crypt_func func)
 {
@@ -406,24 +294,6 @@ static struct skcipher_alg sm4_aesni_avx_skciphers[] = {
 		.setkey		= sm4_skcipher_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= cbc_decrypt,
-	}, {
-		.base = {
-			.cra_name		= "__cfb(sm4)",
-			.cra_driver_name	= "__cfb-sm4-aesni-avx",
-			.cra_priority		= 400,
-			.cra_flags		= CRYPTO_ALG_INTERNAL,
-			.cra_blocksize		= 1,
-			.cra_ctxsize		= sizeof(struct sm4_ctx),
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= SM4_KEY_SIZE,
-		.max_keysize	= SM4_KEY_SIZE,
-		.ivsize		= SM4_BLOCK_SIZE,
-		.chunksize	= SM4_BLOCK_SIZE,
-		.walksize	= 8 * SM4_BLOCK_SIZE,
-		.setkey		= sm4_skcipher_setkey,
-		.encrypt	= sm4_cfb_encrypt,
-		.decrypt	= cfb_decrypt,
 	}, {
 		.base = {
 			.cra_name		= "__ctr(sm4)",
