Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE8DD4A
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:50 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g8w-005IIw-5u; Thu, 30 Nov 2023 20:27:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:27:55 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:27:55 +0800
Subject: [PATCH 3/19] crypto: crypto4xx - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g8w-005IIw-5u@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amcc/crypto4xx_alg.c  |   14 ------------
 drivers/crypto/amcc/crypto4xx_core.c |   40 -----------------------------------
 drivers/crypto/amcc/crypto4xx_core.h |    4 ---
 3 files changed, 58 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index ded732242732..e0af611a95d8 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -181,13 +181,6 @@ int crypto4xx_setkey_aes_cbc(struct crypto_skcipher *cipher,
 				    CRYPTO_FEEDBACK_MODE_NO_FB);
 }
 
-int crypto4xx_setkey_aes_cfb(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen)
-{
-	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_CFB,
-				    CRYPTO_FEEDBACK_MODE_128BIT_CFB);
-}
-
 int crypto4xx_setkey_aes_ecb(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
@@ -195,13 +188,6 @@ int crypto4xx_setkey_aes_ecb(struct crypto_skcipher *cipher,
 				    CRYPTO_FEEDBACK_MODE_NO_FB);
 }
 
-int crypto4xx_setkey_aes_ofb(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen)
-{
-	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_OFB,
-				    CRYPTO_FEEDBACK_MODE_64BIT_OFB);
-}
-
 int crypto4xx_setkey_rfc3686(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8d53372245ad..6006703fb6d7 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1209,26 +1209,6 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
-	{ .type = CRYPTO_ALG_TYPE_SKCIPHER, .u.cipher = {
-		.base = {
-			.cra_name = "cfb(aes)",
-			.cra_driver_name = "cfb-aes-ppc4xx",
-			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
-			.cra_module = THIS_MODULE,
-		},
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize	= AES_IV_SIZE,
-		.setkey	= crypto4xx_setkey_aes_cfb,
-		.encrypt = crypto4xx_encrypt_iv_stream,
-		.decrypt = crypto4xx_decrypt_iv_stream,
-		.init = crypto4xx_sk_init,
-		.exit = crypto4xx_sk_exit,
-	} },
 	{ .type = CRYPTO_ALG_TYPE_SKCIPHER, .u.cipher = {
 		.base = {
 			.cra_name = "ctr(aes)",
@@ -1289,26 +1269,6 @@ static struct crypto4xx_alg_common crypto4xx_alg[] = {
 		.init = crypto4xx_sk_init,
 		.exit = crypto4xx_sk_exit,
 	} },
-	{ .type = CRYPTO_ALG_TYPE_SKCIPHER, .u.cipher = {
-		.base = {
-			.cra_name = "ofb(aes)",
-			.cra_driver_name = "ofb-aes-ppc4xx",
-			.cra_priority = CRYPTO4XX_CRYPTO_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-				CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 1,
-			.cra_ctxsize = sizeof(struct crypto4xx_ctx),
-			.cra_module = THIS_MODULE,
-		},
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize	= AES_IV_SIZE,
-		.setkey	= crypto4xx_setkey_aes_ofb,
-		.encrypt = crypto4xx_encrypt_iv_stream,
-		.decrypt = crypto4xx_decrypt_iv_stream,
-		.init = crypto4xx_sk_init,
-		.exit = crypto4xx_sk_exit,
-	} },
 
 	/* AEAD */
 	{ .type = CRYPTO_ALG_TYPE_AEAD, .u.aead = {
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 56c10668c0ab..96355d463b04 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -162,14 +162,10 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct scatterlist *dst_tmp);
 int crypto4xx_setkey_aes_cbc(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
-int crypto4xx_setkey_aes_cfb(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen);
 int crypto4xx_setkey_aes_ctr(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_setkey_aes_ecb(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
-int crypto4xx_setkey_aes_ofb(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen);
 int crypto4xx_setkey_rfc3686(struct crypto_skcipher *cipher,
 			     const u8 *key, unsigned int keylen);
 int crypto4xx_encrypt_ctr(struct skcipher_request *req);
