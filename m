Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A1ED4A
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:03 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g98-005IKY-Pz; Thu, 30 Nov 2023 20:27:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:07 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:07 +0800
Subject: [PATCH 9/19] crypto: hifn_795x - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g98-005IKY-Pz@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/hifn_795x.c |  126 +--------------------------------------------
 1 file changed, 3 insertions(+), 123 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7bddc3c786c1..b4a4ec35bce0 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2096,16 +2096,6 @@ static inline int hifn_encrypt_aes_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
 			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_encrypt_aes_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_encrypt_aes_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_OFB);
-}
 
 /*
  * AES decryption functions.
@@ -2120,16 +2110,6 @@ static inline int hifn_decrypt_aes_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
 			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_decrypt_aes_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_decrypt_aes_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_AES_128, ACRYPTO_MODE_OFB);
-}
 
 /*
  * DES ecryption functions.
@@ -2144,16 +2124,6 @@ static inline int hifn_encrypt_des_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
 			ACRYPTO_TYPE_DES, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_encrypt_des_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_DES, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_encrypt_des_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_DES, ACRYPTO_MODE_OFB);
-}
 
 /*
  * DES decryption functions.
@@ -2168,16 +2138,6 @@ static inline int hifn_decrypt_des_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
 			ACRYPTO_TYPE_DES, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_decrypt_des_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_DES, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_decrypt_des_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_DES, ACRYPTO_MODE_OFB);
-}
 
 /*
  * 3DES ecryption functions.
@@ -2192,16 +2152,6 @@ static inline int hifn_encrypt_3des_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
 			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_encrypt_3des_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_encrypt_3des_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_ENCRYPT,
-			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
-}
 
 /* 3DES decryption functions. */
 static inline int hifn_decrypt_3des_ecb(struct skcipher_request *req)
@@ -2214,16 +2164,6 @@ static inline int hifn_decrypt_3des_cbc(struct skcipher_request *req)
 	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
 			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CBC);
 }
-static inline int hifn_decrypt_3des_cfb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_CFB);
-}
-static inline int hifn_decrypt_3des_ofb(struct skcipher_request *req)
-{
-	return hifn_setup_crypto(req, ACRYPTO_OP_DECRYPT,
-			ACRYPTO_TYPE_3DES, ACRYPTO_MODE_OFB);
-}
 
 struct hifn_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
@@ -2234,28 +2174,8 @@ struct hifn_alg_template {
 
 static const struct hifn_alg_template hifn_alg_templates[] = {
 	/*
-	 * 3DES ECB, CBC, CFB and OFB modes.
+	 * 3DES ECB and CBC modes.
 	 */
-	{
-		.name = "cfb(des3_ede)", .drv_name = "cfb-3des", .bsize = 8,
-		.skcipher = {
-			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_des3_setkey,
-			.encrypt	=	hifn_encrypt_3des_cfb,
-			.decrypt	=	hifn_decrypt_3des_cfb,
-		},
-	},
-	{
-		.name = "ofb(des3_ede)", .drv_name = "ofb-3des", .bsize = 8,
-		.skcipher = {
-			.min_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.max_keysize	=	HIFN_3DES_KEY_LENGTH,
-			.setkey		=	hifn_des3_setkey,
-			.encrypt	=	hifn_encrypt_3des_ofb,
-			.decrypt	=	hifn_decrypt_3des_ofb,
-		},
-	},
 	{
 		.name = "cbc(des3_ede)", .drv_name = "cbc-3des", .bsize = 8,
 		.skcipher = {
@@ -2279,28 +2199,8 @@ static const struct hifn_alg_template hifn_alg_templates[] = {
 	},
 
 	/*
-	 * DES ECB, CBC, CFB and OFB modes.
+	 * DES ECB and CBC modes.
 	 */
-	{
-		.name = "cfb(des)", .drv_name = "cfb-des", .bsize = 8,
-		.skcipher = {
-			.min_keysize	=	HIFN_DES_KEY_LENGTH,
-			.max_keysize	=	HIFN_DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
-			.encrypt	=	hifn_encrypt_des_cfb,
-			.decrypt	=	hifn_decrypt_des_cfb,
-		},
-	},
-	{
-		.name = "ofb(des)", .drv_name = "ofb-des", .bsize = 8,
-		.skcipher = {
-			.min_keysize	=	HIFN_DES_KEY_LENGTH,
-			.max_keysize	=	HIFN_DES_KEY_LENGTH,
-			.setkey		=	hifn_setkey,
-			.encrypt	=	hifn_encrypt_des_ofb,
-			.decrypt	=	hifn_decrypt_des_ofb,
-		},
-	},
 	{
 		.name = "cbc(des)", .drv_name = "cbc-des", .bsize = 8,
 		.skcipher = {
@@ -2324,7 +2224,7 @@ static const struct hifn_alg_template hifn_alg_templates[] = {
 	},
 
 	/*
-	 * AES ECB, CBC, CFB and OFB modes.
+	 * AES ECB and CBC modes.
 	 */
 	{
 		.name = "ecb(aes)", .drv_name = "ecb-aes", .bsize = 16,
@@ -2347,26 +2247,6 @@ static const struct hifn_alg_template hifn_alg_templates[] = {
 			.decrypt	=	hifn_decrypt_aes_cbc,
 		},
 	},
-	{
-		.name = "cfb(aes)", .drv_name = "cfb-aes", .bsize = 16,
-		.skcipher = {
-			.min_keysize	=	AES_MIN_KEY_SIZE,
-			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey		=	hifn_setkey,
-			.encrypt	=	hifn_encrypt_aes_cfb,
-			.decrypt	=	hifn_decrypt_aes_cfb,
-		},
-	},
-	{
-		.name = "ofb(aes)", .drv_name = "ofb-aes", .bsize = 16,
-		.skcipher = {
-			.min_keysize	=	AES_MIN_KEY_SIZE,
-			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey		=	hifn_setkey,
-			.encrypt	=	hifn_encrypt_aes_ofb,
-			.decrypt	=	hifn_decrypt_aes_ofb,
-		},
-	},
 };
 
 static int hifn_init_tfm(struct crypto_skcipher *tfm)
