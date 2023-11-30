Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8BDD46
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9C-005IMR-Vw; Thu, 30 Nov 2023 20:28:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:12 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:12 +0800
Subject: [PATCH 11/19] crypto: safexcel - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9C-005IMR-Vw@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/inside-secure/safexcel.c        |    4 
 drivers/crypto/inside-secure/safexcel.h        |    4 
 drivers/crypto/inside-secure/safexcel_cipher.c |  152 -------------------------
 3 files changed, 160 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 76da14af74b5..f5c1912aa564 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1191,8 +1191,6 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_cbc_des3_ede,
 	&safexcel_alg_ecb_aes,
 	&safexcel_alg_cbc_aes,
-	&safexcel_alg_cfb_aes,
-	&safexcel_alg_ofb_aes,
 	&safexcel_alg_ctr_aes,
 	&safexcel_alg_md5,
 	&safexcel_alg_sha1,
@@ -1231,8 +1229,6 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sm3,
 	&safexcel_alg_ecb_sm4,
 	&safexcel_alg_cbc_sm4,
-	&safexcel_alg_ofb_sm4,
-	&safexcel_alg_cfb_sm4,
 	&safexcel_alg_ctr_sm4,
 	&safexcel_alg_authenc_hmac_sha1_cbc_sm4,
 	&safexcel_alg_authenc_hmac_sm3_cbc_sm4,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 47ef6c7cd02c..d0059ce954dd 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -933,8 +933,6 @@ extern struct safexcel_alg_template safexcel_alg_ecb_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_ecb_aes;
 extern struct safexcel_alg_template safexcel_alg_cbc_aes;
-extern struct safexcel_alg_template safexcel_alg_cfb_aes;
-extern struct safexcel_alg_template safexcel_alg_ofb_aes;
 extern struct safexcel_alg_template safexcel_alg_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_md5;
 extern struct safexcel_alg_template safexcel_alg_sha1;
@@ -973,8 +971,6 @@ extern struct safexcel_alg_template safexcel_alg_sm3;
 extern struct safexcel_alg_template safexcel_alg_hmac_sm3;
 extern struct safexcel_alg_template safexcel_alg_ecb_sm4;
 extern struct safexcel_alg_template safexcel_alg_cbc_sm4;
-extern struct safexcel_alg_template safexcel_alg_ofb_sm4;
-extern struct safexcel_alg_template safexcel_alg_cfb_sm4;
 extern struct safexcel_alg_template safexcel_alg_ctr_sm4;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_sm4;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sm3_cbc_sm4;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 272c28b5a088..835477c97b2f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1349,82 +1349,6 @@ struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	},
 };
 
-static int safexcel_skcipher_aes_cfb_cra_init(struct crypto_tfm *tfm)
-{
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	safexcel_skcipher_cra_init(tfm);
-	ctx->alg  = SAFEXCEL_AES;
-	ctx->blocksz = AES_BLOCK_SIZE;
-	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
-	return 0;
-}
-
-struct safexcel_alg_template safexcel_alg_cfb_aes = {
-	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_AES_XFB,
-	.alg.skcipher = {
-		.setkey = safexcel_skcipher_aes_setkey,
-		.encrypt = safexcel_encrypt,
-		.decrypt = safexcel_decrypt,
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.base = {
-			.cra_name = "cfb(aes)",
-			.cra_driver_name = "safexcel-cfb-aes",
-			.cra_priority = SAFEXCEL_CRA_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_ALLOCATES_MEMORY |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
-			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_aes_cfb_cra_init,
-			.cra_exit = safexcel_skcipher_cra_exit,
-			.cra_module = THIS_MODULE,
-		},
-	},
-};
-
-static int safexcel_skcipher_aes_ofb_cra_init(struct crypto_tfm *tfm)
-{
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	safexcel_skcipher_cra_init(tfm);
-	ctx->alg  = SAFEXCEL_AES;
-	ctx->blocksz = AES_BLOCK_SIZE;
-	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
-	return 0;
-}
-
-struct safexcel_alg_template safexcel_alg_ofb_aes = {
-	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_AES_XFB,
-	.alg.skcipher = {
-		.setkey = safexcel_skcipher_aes_setkey,
-		.encrypt = safexcel_encrypt,
-		.decrypt = safexcel_decrypt,
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.base = {
-			.cra_name = "ofb(aes)",
-			.cra_driver_name = "safexcel-ofb-aes",
-			.cra_priority = SAFEXCEL_CRA_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_ALLOCATES_MEMORY |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
-			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_aes_ofb_cra_init,
-			.cra_exit = safexcel_skcipher_cra_exit,
-			.cra_module = THIS_MODULE,
-		},
-	},
-};
-
 static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 					   const u8 *key, unsigned int len)
 {
@@ -3183,82 +3107,6 @@ struct safexcel_alg_template safexcel_alg_cbc_sm4 = {
 	},
 };
 
-static int safexcel_skcipher_sm4_ofb_cra_init(struct crypto_tfm *tfm)
-{
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	safexcel_skcipher_cra_init(tfm);
-	ctx->alg  = SAFEXCEL_SM4;
-	ctx->blocksz = SM4_BLOCK_SIZE;
-	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_OFB;
-	return 0;
-}
-
-struct safexcel_alg_template safexcel_alg_ofb_sm4 = {
-	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_AES_XFB,
-	.alg.skcipher = {
-		.setkey = safexcel_skcipher_sm4_setkey,
-		.encrypt = safexcel_encrypt,
-		.decrypt = safexcel_decrypt,
-		.min_keysize = SM4_KEY_SIZE,
-		.max_keysize = SM4_KEY_SIZE,
-		.ivsize = SM4_BLOCK_SIZE,
-		.base = {
-			.cra_name = "ofb(sm4)",
-			.cra_driver_name = "safexcel-ofb-sm4",
-			.cra_priority = SAFEXCEL_CRA_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_ALLOCATES_MEMORY |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
-			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_sm4_ofb_cra_init,
-			.cra_exit = safexcel_skcipher_cra_exit,
-			.cra_module = THIS_MODULE,
-		},
-	},
-};
-
-static int safexcel_skcipher_sm4_cfb_cra_init(struct crypto_tfm *tfm)
-{
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	safexcel_skcipher_cra_init(tfm);
-	ctx->alg  = SAFEXCEL_SM4;
-	ctx->blocksz = SM4_BLOCK_SIZE;
-	ctx->mode = CONTEXT_CONTROL_CRYPTO_MODE_CFB;
-	return 0;
-}
-
-struct safexcel_alg_template safexcel_alg_cfb_sm4 = {
-	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.algo_mask = SAFEXCEL_ALG_SM4 | SAFEXCEL_ALG_AES_XFB,
-	.alg.skcipher = {
-		.setkey = safexcel_skcipher_sm4_setkey,
-		.encrypt = safexcel_encrypt,
-		.decrypt = safexcel_decrypt,
-		.min_keysize = SM4_KEY_SIZE,
-		.max_keysize = SM4_KEY_SIZE,
-		.ivsize = SM4_BLOCK_SIZE,
-		.base = {
-			.cra_name = "cfb(sm4)",
-			.cra_driver_name = "safexcel-cfb-sm4",
-			.cra_priority = SAFEXCEL_CRA_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_ALLOCATES_MEMORY |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
-			.cra_alignmask = 0,
-			.cra_init = safexcel_skcipher_sm4_cfb_cra_init,
-			.cra_exit = safexcel_skcipher_cra_exit,
-			.cra_module = THIS_MODULE,
-		},
-	},
-};
-
 static int safexcel_skcipher_sm4ctr_setkey(struct crypto_skcipher *ctfm,
 					   const u8 *key, unsigned int len)
 {
