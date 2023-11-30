Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C51B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:46 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g8r-005IId-Uu; Thu, 30 Nov 2023 20:27:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:27:51 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:27:51 +0800
Subject: [PATCH 1/19] crypto: arm64/sm4 - Remove cfb(sm4)
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g8r-005IId-Uu@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/arm64/crypto/Kconfig         |    6 -
 arch/arm64/crypto/sm4-ce-core.S   |  158 --------------------------------------
 arch/arm64/crypto/sm4-ce-glue.c   |  108 -------------------------
 arch/arm64/crypto/sm4-ce.h        |    3 
 arch/arm64/crypto/sm4-neon-core.S |  113 ---------------------------
 arch/arm64/crypto/sm4-neon-glue.c |  105 -------------------------
 6 files changed, 4 insertions(+), 489 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 6d06b448a66e..eb7b423ba463 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -231,7 +231,7 @@ config CRYPTO_SM4_ARM64_CE
 	  - NEON (Advanced SIMD) extensions
 
 config CRYPTO_SM4_ARM64_CE_BLK
-	tristate "Ciphers: SM4, modes: ECB/CBC/CFB/CTR/XTS (ARMv8 Crypto Extensions)"
+	tristate "Ciphers: SM4, modes: ECB/CBC/CTR/XTS (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SM4
@@ -240,7 +240,6 @@ config CRYPTO_SM4_ARM64_CE_BLK
 	  with block cipher modes:
 	  - ECB (Electronic Codebook) mode (NIST SP800-38A)
 	  - CBC (Cipher Block Chaining) mode (NIST SP800-38A)
-	  - CFB (Cipher Feedback) mode (NIST SP800-38A)
 	  - CTR (Counter) mode (NIST SP800-38A)
 	  - XTS (XOR Encrypt XOR with ciphertext stealing) mode (NIST SP800-38E
 	    and IEEE 1619)
@@ -250,7 +249,7 @@ config CRYPTO_SM4_ARM64_CE_BLK
 	  - NEON (Advanced SIMD) extensions
 
 config CRYPTO_SM4_ARM64_NEON_BLK
-	tristate "Ciphers: SM4, modes: ECB/CBC/CFB/CTR (NEON)"
+	tristate "Ciphers: SM4, modes: ECB/CBC/CTR (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_SM4
@@ -259,7 +258,6 @@ config CRYPTO_SM4_ARM64_NEON_BLK
 	  with block cipher modes:
 	  - ECB (Electronic Codebook) mode (NIST SP800-38A)
 	  - CBC (Cipher Block Chaining) mode (NIST SP800-38A)
-	  - CFB (Cipher Feedback) mode (NIST SP800-38A)
 	  - CTR (Counter) mode (NIST SP800-38A)
 
 	  Architecture: arm64 using:
diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-core.S
index 877b80c54a0d..1f3625c2c67e 100644
--- a/arch/arm64/crypto/sm4-ce-core.S
+++ b/arch/arm64/crypto/sm4-ce-core.S
@@ -402,164 +402,6 @@ SYM_FUNC_START(sm4_ce_cbc_cts_dec)
 	ret
 SYM_FUNC_END(sm4_ce_cbc_cts_dec)
 
-.align 3
-SYM_FUNC_START(sm4_ce_cfb_enc)
-	/* input:
-	 *   x0: round key array, CTX
-	 *   x1: dst
-	 *   x2: src
-	 *   x3: iv (big endian, 128 bit)
-	 *   w4: nblocks
-	 */
-	SM4_PREPARE(x0)
-
-	ld1		{RIV.16b}, [x3]
-
-.Lcfb_enc_loop_4x:
-	cmp		w4, #4
-	blt		.Lcfb_enc_loop_1x
-
-	sub		w4, w4, #4
-
-	ld1		{v0.16b-v3.16b}, [x2], #64
-
-	rev32		v8.16b, RIV.16b
-	SM4_CRYPT_BLK_BE(v8)
-	eor		v0.16b, v0.16b, v8.16b
-
-	rev32		v8.16b, v0.16b
-	SM4_CRYPT_BLK_BE(v8)
-	eor		v1.16b, v1.16b, v8.16b
-
-	rev32		v8.16b, v1.16b
-	SM4_CRYPT_BLK_BE(v8)
-	eor		v2.16b, v2.16b, v8.16b
-
-	rev32		v8.16b, v2.16b
-	SM4_CRYPT_BLK_BE(v8)
-	eor		v3.16b, v3.16b, v8.16b
-
-	st1		{v0.16b-v3.16b}, [x1], #64
-	mov		RIV.16b, v3.16b
-
-	cbz		w4, .Lcfb_enc_end
-	b		.Lcfb_enc_loop_4x
-
-.Lcfb_enc_loop_1x:
-	sub		w4, w4, #1
-
-	ld1		{v0.16b}, [x2], #16
-
-	SM4_CRYPT_BLK(RIV)
-	eor		RIV.16b, RIV.16b, v0.16b
-
-	st1		{RIV.16b}, [x1], #16
-
-	cbnz		w4, .Lcfb_enc_loop_1x
-
-.Lcfb_enc_end:
-	/* store new IV */
-	st1		{RIV.16b}, [x3]
-
-	ret
-SYM_FUNC_END(sm4_ce_cfb_enc)
-
-.align 3
-SYM_FUNC_START(sm4_ce_cfb_dec)
-	/* input:
-	 *   x0: round key array, CTX
-	 *   x1: dst
-	 *   x2: src
-	 *   x3: iv (big endian, 128 bit)
-	 *   w4: nblocks
-	 */
-	SM4_PREPARE(x0)
-
-	ld1		{RIV.16b}, [x3]
-
-.Lcfb_dec_loop_8x:
-	sub		w4, w4, #8
-	tbnz		w4, #31, .Lcfb_dec_4x
-
-	ld1		{v0.16b-v3.16b}, [x2], #64
-	ld1		{v4.16b-v7.16b}, [x2], #64
-
-	rev32		v8.16b, RIV.16b
-	rev32		v9.16b, v0.16b
-	rev32		v10.16b, v1.16b
-	rev32		v11.16b, v2.16b
-	rev32		v12.16b, v3.16b
-	rev32		v13.16b, v4.16b
-	rev32		v14.16b, v5.16b
-	rev32		v15.16b, v6.16b
-
-	SM4_CRYPT_BLK8_BE(v8, v9, v10, v11, v12, v13, v14, v15)
-
-	mov		RIV.16b, v7.16b
-
-	eor		v0.16b, v0.16b, v8.16b
-	eor		v1.16b, v1.16b, v9.16b
-	eor		v2.16b, v2.16b, v10.16b
-	eor		v3.16b, v3.16b, v11.16b
-	eor		v4.16b, v4.16b, v12.16b
-	eor		v5.16b, v5.16b, v13.16b
-	eor		v6.16b, v6.16b, v14.16b
-	eor		v7.16b, v7.16b, v15.16b
-
-	st1		{v0.16b-v3.16b}, [x1], #64
-	st1		{v4.16b-v7.16b}, [x1], #64
-
-	cbz		w4, .Lcfb_dec_end
-	b		.Lcfb_dec_loop_8x
-
-.Lcfb_dec_4x:
-	add		w4, w4, #8
-	cmp		w4, #4
-	blt		.Lcfb_dec_loop_1x
-
-	sub		w4, w4, #4
-
-	ld1		{v0.16b-v3.16b}, [x2], #64
-
-	rev32		v8.16b, RIV.16b
-	rev32		v9.16b, v0.16b
-	rev32		v10.16b, v1.16b
-	rev32		v11.16b, v2.16b
-
-	SM4_CRYPT_BLK4_BE(v8, v9, v10, v11)
-
-	mov		RIV.16b, v3.16b
-
-	eor		v0.16b, v0.16b, v8.16b
-	eor		v1.16b, v1.16b, v9.16b
-	eor		v2.16b, v2.16b, v10.16b
-	eor		v3.16b, v3.16b, v11.16b
-
-	st1		{v0.16b-v3.16b}, [x1], #64
-
-	cbz		w4, .Lcfb_dec_end
-
-.Lcfb_dec_loop_1x:
-	sub		w4, w4, #1
-
-	ld1		{v0.16b}, [x2], #16
-
-	SM4_CRYPT_BLK(RIV)
-
-	eor		RIV.16b, RIV.16b, v0.16b
-	st1		{RIV.16b}, [x1], #16
-
-	mov		RIV.16b, v0.16b
-
-	cbnz		w4, .Lcfb_dec_loop_1x
-
-.Lcfb_dec_end:
-	/* store new IV */
-	st1		{RIV.16b}, [x3]
-
-	ret
-SYM_FUNC_END(sm4_ce_cfb_dec)
-
 .align 3
 SYM_FUNC_START(sm4_ce_ctr_enc)
 	/* input:
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 0a2d32ed3bde..43741bed874e 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -37,10 +37,6 @@ asmlinkage void sm4_ce_cbc_cts_enc(const u32 *rkey, u8 *dst, const u8 *src,
 				   u8 *iv, unsigned int nbytes);
 asmlinkage void sm4_ce_cbc_cts_dec(const u32 *rkey, u8 *dst, const u8 *src,
 				   u8 *iv, unsigned int nbytes);
-asmlinkage void sm4_ce_cfb_enc(const u32 *rkey, u8 *dst, const u8 *src,
-			       u8 *iv, unsigned int nblks);
-asmlinkage void sm4_ce_cfb_dec(const u32 *rkey, u8 *dst, const u8 *src,
-			       u8 *iv, unsigned int nblks);
 asmlinkage void sm4_ce_ctr_enc(const u32 *rkey, u8 *dst, const u8 *src,
 			       u8 *iv, unsigned int nblks);
 asmlinkage void sm4_ce_xts_enc(const u32 *rkey1, u8 *dst, const u8 *src,
@@ -56,7 +52,6 @@ asmlinkage void sm4_ce_mac_update(const u32 *rkey_enc, u8 *digest,
 EXPORT_SYMBOL(sm4_ce_expand_key);
 EXPORT_SYMBOL(sm4_ce_crypt_block);
 EXPORT_SYMBOL(sm4_ce_cbc_enc);
-EXPORT_SYMBOL(sm4_ce_cfb_enc);
 
 struct sm4_xts_ctx {
 	struct sm4_ctx key1;
@@ -280,90 +275,6 @@ static int sm4_cbc_cts_decrypt(struct skcipher_request *req)
 	return sm4_cbc_cts_crypt(req, false);
 }
 
-static int sm4_cfb_encrypt(struct skcipher_request *req)
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
-		unsigned int nblks;
-
-		kernel_neon_begin();
-
-		nblks = BYTES2BLKS(nbytes);
-		if (nblks) {
-			sm4_ce_cfb_enc(ctx->rkey_enc, dst, src, walk.iv, nblks);
-			dst += nblks * SM4_BLOCK_SIZE;
-			src += nblks * SM4_BLOCK_SIZE;
-			nbytes -= nblks * SM4_BLOCK_SIZE;
-		}
-
-		/* tail */
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[SM4_BLOCK_SIZE];
-
-			sm4_ce_crypt_block(ctx->rkey_enc, keystream, walk.iv);
-			crypto_xor_cpy(dst, src, keystream, nbytes);
-			nbytes = 0;
-		}
-
-		kernel_neon_end();
-
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
-static int sm4_cfb_decrypt(struct skcipher_request *req)
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
-		unsigned int nblks;
-
-		kernel_neon_begin();
-
-		nblks = BYTES2BLKS(nbytes);
-		if (nblks) {
-			sm4_ce_cfb_dec(ctx->rkey_enc, dst, src, walk.iv, nblks);
-			dst += nblks * SM4_BLOCK_SIZE;
-			src += nblks * SM4_BLOCK_SIZE;
-			nbytes -= nblks * SM4_BLOCK_SIZE;
-		}
-
-		/* tail */
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[SM4_BLOCK_SIZE];
-
-			sm4_ce_crypt_block(ctx->rkey_enc, keystream, walk.iv);
-			crypto_xor_cpy(dst, src, keystream, nbytes);
-			nbytes = 0;
-		}
-
-		kernel_neon_end();
-
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	return err;
-}
-
 static int sm4_ctr_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -542,22 +453,6 @@ static struct skcipher_alg sm4_algs[] = {
 		.setkey		= sm4_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= sm4_cbc_decrypt,
-	}, {
-		.base = {
-			.cra_name		= "cfb(sm4)",
-			.cra_driver_name	= "cfb-sm4-ce",
-			.cra_priority		= 400,
-			.cra_blocksize		= 1,
-			.cra_ctxsize		= sizeof(struct sm4_ctx),
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= SM4_KEY_SIZE,
-		.max_keysize	= SM4_KEY_SIZE,
-		.ivsize		= SM4_BLOCK_SIZE,
-		.chunksize	= SM4_BLOCK_SIZE,
-		.setkey		= sm4_setkey,
-		.encrypt	= sm4_cfb_encrypt,
-		.decrypt	= sm4_cfb_decrypt,
 	}, {
 		.base = {
 			.cra_name		= "ctr(sm4)",
@@ -869,12 +764,11 @@ static void __exit sm4_exit(void)
 module_cpu_feature_match(SM4, sm4_init);
 module_exit(sm4_exit);
 
-MODULE_DESCRIPTION("SM4 ECB/CBC/CFB/CTR/XTS using ARMv8 Crypto Extensions");
+MODULE_DESCRIPTION("SM4 ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 MODULE_ALIAS_CRYPTO("sm4-ce");
 MODULE_ALIAS_CRYPTO("sm4");
 MODULE_ALIAS_CRYPTO("ecb(sm4)");
 MODULE_ALIAS_CRYPTO("cbc(sm4)");
-MODULE_ALIAS_CRYPTO("cfb(sm4)");
 MODULE_ALIAS_CRYPTO("ctr(sm4)");
 MODULE_ALIAS_CRYPTO("cts(cbc(sm4))");
 MODULE_ALIAS_CRYPTO("xts(sm4)");
diff --git a/arch/arm64/crypto/sm4-ce.h b/arch/arm64/crypto/sm4-ce.h
index 109c21b37590..1e235c4371eb 100644
--- a/arch/arm64/crypto/sm4-ce.h
+++ b/arch/arm64/crypto/sm4-ce.h
@@ -11,6 +11,3 @@ void sm4_ce_crypt_block(const u32 *rkey, u8 *dst, const u8 *src);
 
 void sm4_ce_cbc_enc(const u32 *rkey_enc, u8 *dst, const u8 *src,
 		    u8 *iv, unsigned int nblocks);
-
-void sm4_ce_cfb_enc(const u32 *rkey_enc, u8 *dst, const u8 *src,
-		    u8 *iv, unsigned int nblocks);
diff --git a/arch/arm64/crypto/sm4-neon-core.S b/arch/arm64/crypto/sm4-neon-core.S
index f295b4b7d70a..734dc7193610 100644
--- a/arch/arm64/crypto/sm4-neon-core.S
+++ b/arch/arm64/crypto/sm4-neon-core.S
@@ -437,119 +437,6 @@ SYM_FUNC_START(sm4_neon_cbc_dec)
 	ret
 SYM_FUNC_END(sm4_neon_cbc_dec)
 
-.align 3
-SYM_FUNC_START(sm4_neon_cfb_dec)
-	/* input:
-	 *   x0: round key array, CTX
-	 *   x1: dst
-	 *   x2: src
-	 *   x3: iv (big endian, 128 bit)
-	 *   w4: nblocks
-	 */
-	SM4_PREPARE()
-
-	ld1		{v0.16b}, [x3]
-
-.Lcfb_dec_loop_8x:
-	sub		w4, w4, #8
-	tbnz		w4, #31, .Lcfb_dec_4x
-
-	ld1		{v1.16b-v3.16b}, [x2], #48
-	ld4		{v4.4s-v7.4s}, [x2]
-
-	transpose_4x4(v0, v1, v2, v3)
-
-	SM4_CRYPT_BLK8(v0, v1, v2, v3, v4, v5, v6, v7)
-
-	sub		x2, x2, #48
-	ld1		{RTMP0.16b-RTMP3.16b}, [x2], #64
-	ld1		{RTMP4.16b-RTMP7.16b}, [x2], #64
-
-	eor		v0.16b, v0.16b, RTMP0.16b
-	eor		v1.16b, v1.16b, RTMP1.16b
-	eor		v2.16b, v2.16b, RTMP2.16b
-	eor		v3.16b, v3.16b, RTMP3.16b
-	eor		v4.16b, v4.16b, RTMP4.16b
-	eor		v5.16b, v5.16b, RTMP5.16b
-	eor		v6.16b, v6.16b, RTMP6.16b
-	eor		v7.16b, v7.16b, RTMP7.16b
-
-	st1		{v0.16b-v3.16b}, [x1], #64
-	st1		{v4.16b-v7.16b}, [x1], #64
-
-	mov		v0.16b, RTMP7.16b
-
-	cbz		w4, .Lcfb_dec_end
-	b		.Lcfb_dec_loop_8x
-
-.Lcfb_dec_4x:
-	add		w4, w4, #8
-	cmp		w4, #4
-	blt		.Lcfb_dec_tail
-
-	sub		w4, w4, #4
-
-	ld1		{v4.16b-v7.16b}, [x2], #64
-
-	rev32		v0.16b, v0.16b		/* v0 is IV register */
-	rev32		v1.16b, v4.16b
-	rev32		v2.16b, v5.16b
-	rev32		v3.16b, v6.16b
-
-	transpose_4x4(v0, v1, v2, v3)
-
-	SM4_CRYPT_BLK4_BE(v0, v1, v2, v3)
-
-	eor		v0.16b, v0.16b, v4.16b
-	eor		v1.16b, v1.16b, v5.16b
-	eor		v2.16b, v2.16b, v6.16b
-	eor		v3.16b, v3.16b, v7.16b
-
-	st1		{v0.16b-v3.16b}, [x1], #64
-
-	mov		v0.16b, v7.16b
-
-	cbz		w4, .Lcfb_dec_end
-
-.Lcfb_dec_tail:
-	cmp		w4, #2
-	ld1		{v4.16b}, [x2], #16
-	blt		.Lcfb_dec_tail_load_done
-	ld1		{v5.16b}, [x2], #16
-	beq		.Lcfb_dec_tail_load_done
-	ld1		{v6.16b}, [x2], #16
-
-.Lcfb_dec_tail_load_done:
-	rev32		v0.16b, v0.16b		/* v0 is IV register */
-	rev32		v1.16b, v4.16b
-	rev32		v2.16b, v5.16b
-
-	transpose_4x4(v0, v1, v2, v3)
-
-	SM4_CRYPT_BLK4_BE(v0, v1, v2, v3)
-
-	cmp		w4, #2
-	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x1], #16
-	mov		v0.16b, v4.16b
-	blt		.Lcfb_dec_end
-
-	eor		v1.16b, v1.16b, v5.16b
-	st1		{v1.16b}, [x1], #16
-	mov		v0.16b, v5.16b
-	beq		.Lcfb_dec_end
-
-	eor		v2.16b, v2.16b, v6.16b
-	st1		{v2.16b}, [x1], #16
-	mov		v0.16b, v6.16b
-
-.Lcfb_dec_end:
-	/* store new IV */
-	st1		{v0.16b}, [x3]
-
-	ret
-SYM_FUNC_END(sm4_neon_cfb_dec)
-
 .align 3
 SYM_FUNC_START(sm4_neon_ctr_crypt)
 	/* input:
diff --git a/arch/arm64/crypto/sm4-neon-glue.c b/arch/arm64/crypto/sm4-neon-glue.c
index 7b19accf5c03..e3500aca2d18 100644
--- a/arch/arm64/crypto/sm4-neon-glue.c
+++ b/arch/arm64/crypto/sm4-neon-glue.c
@@ -22,8 +22,6 @@ asmlinkage void sm4_neon_crypt(const u32 *rkey, u8 *dst, const u8 *src,
 			       unsigned int nblocks);
 asmlinkage void sm4_neon_cbc_dec(const u32 *rkey_dec, u8 *dst, const u8 *src,
 				 u8 *iv, unsigned int nblocks);
-asmlinkage void sm4_neon_cfb_dec(const u32 *rkey_enc, u8 *dst, const u8 *src,
-				 u8 *iv, unsigned int nblocks);
 asmlinkage void sm4_neon_ctr_crypt(const u32 *rkey_enc, u8 *dst, const u8 *src,
 				   u8 *iv, unsigned int nblocks);
 
@@ -142,90 +140,6 @@ static int sm4_cbc_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int sm4_cfb_encrypt(struct skcipher_request *req)
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
-
-static int sm4_cfb_decrypt(struct skcipher_request *req)
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
-		unsigned int nblocks;
-
-		nblocks = nbytes / SM4_BLOCK_SIZE;
-		if (nblocks) {
-			kernel_neon_begin();
-
-			sm4_neon_cfb_dec(ctx->rkey_enc, dst, src,
-					 walk.iv, nblocks);
-
-			kernel_neon_end();
-
-			dst += nblocks * SM4_BLOCK_SIZE;
-			src += nblocks * SM4_BLOCK_SIZE;
-			nbytes -= nblocks * SM4_BLOCK_SIZE;
-		}
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
-
 static int sm4_ctr_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -301,22 +215,6 @@ static struct skcipher_alg sm4_algs[] = {
 		.setkey		= sm4_setkey,
 		.encrypt	= sm4_cbc_encrypt,
 		.decrypt	= sm4_cbc_decrypt,
-	}, {
-		.base = {
-			.cra_name		= "cfb(sm4)",
-			.cra_driver_name	= "cfb-sm4-neon",
-			.cra_priority		= 200,
-			.cra_blocksize		= 1,
-			.cra_ctxsize		= sizeof(struct sm4_ctx),
-			.cra_module		= THIS_MODULE,
-		},
-		.min_keysize	= SM4_KEY_SIZE,
-		.max_keysize	= SM4_KEY_SIZE,
-		.ivsize		= SM4_BLOCK_SIZE,
-		.chunksize	= SM4_BLOCK_SIZE,
-		.setkey		= sm4_setkey,
-		.encrypt	= sm4_cfb_encrypt,
-		.decrypt	= sm4_cfb_decrypt,
 	}, {
 		.base = {
 			.cra_name		= "ctr(sm4)",
@@ -349,12 +247,11 @@ static void __exit sm4_exit(void)
 module_init(sm4_init);
 module_exit(sm4_exit);
 
-MODULE_DESCRIPTION("SM4 ECB/CBC/CFB/CTR using ARMv8 NEON");
+MODULE_DESCRIPTION("SM4 ECB/CBC/CTR using ARMv8 NEON");
 MODULE_ALIAS_CRYPTO("sm4-neon");
 MODULE_ALIAS_CRYPTO("sm4");
 MODULE_ALIAS_CRYPTO("ecb(sm4)");
 MODULE_ALIAS_CRYPTO("cbc(sm4)");
-MODULE_ALIAS_CRYPTO("cfb(sm4)");
 MODULE_ALIAS_CRYPTO("ctr(sm4)");
 MODULE_AUTHOR("Tianjia Zhang <tianjia.zhang@linux.alibaba.com>");
 MODULE_LICENSE("GPL v2");
