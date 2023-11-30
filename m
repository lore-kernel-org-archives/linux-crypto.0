Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E391B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g8y-005IJ6-8o; Thu, 30 Nov 2023 20:27:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:27:57 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:27:57 +0800
Subject: [PATCH 4/19] crypto: aspeed - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g8y-005IJ6-8o@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/aspeed/Kconfig              |    4 
 drivers/crypto/aspeed/aspeed-hace-crypto.c |  230 -----------------------------
 2 files changed, 1 insertion(+), 233 deletions(-)

diff --git a/drivers/crypto/aspeed/Kconfig b/drivers/crypto/aspeed/Kconfig
index db6c5b4cdc40..e93f2f82b418 100644
--- a/drivers/crypto/aspeed/Kconfig
+++ b/drivers/crypto/aspeed/Kconfig
@@ -38,14 +38,12 @@ config CRYPTO_DEV_ASPEED_HACE_CRYPTO
 	select CRYPTO_DES
 	select CRYPTO_ECB
 	select CRYPTO_CBC
-	select CRYPTO_CFB
-	select CRYPTO_OFB
 	select CRYPTO_CTR
 	help
 	  Select here to enable Aspeed Hash & Crypto Engine (HACE)
 	  crypto driver.
 	  Supports AES/DES symmetric-key encryption and decryption
-	  with ECB/CBC/CFB/OFB/CTR options.
+	  with ECB/CBC/CTR options.
 
 config CRYPTO_DEV_ASPEED_ACRY
 	bool "Enable Aspeed ACRY RSA Engine"
diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index f0eddb7854e5..a72dfebc53ff 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -473,30 +473,6 @@ static int aspeed_tdes_ctr_encrypt(struct skcipher_request *req)
 				HACE_CMD_TRIPLE_DES);
 }
 
-static int aspeed_tdes_ofb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_OFB |
-				HACE_CMD_TRIPLE_DES);
-}
-
-static int aspeed_tdes_ofb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_OFB |
-				HACE_CMD_TRIPLE_DES);
-}
-
-static int aspeed_tdes_cfb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CFB |
-				HACE_CMD_TRIPLE_DES);
-}
-
-static int aspeed_tdes_cfb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_CFB |
-				HACE_CMD_TRIPLE_DES);
-}
-
 static int aspeed_tdes_cbc_decrypt(struct skcipher_request *req)
 {
 	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CBC |
@@ -533,30 +509,6 @@ static int aspeed_des_ctr_encrypt(struct skcipher_request *req)
 				HACE_CMD_SINGLE_DES);
 }
 
-static int aspeed_des_ofb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_OFB |
-				HACE_CMD_SINGLE_DES);
-}
-
-static int aspeed_des_ofb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_OFB |
-				HACE_CMD_SINGLE_DES);
-}
-
-static int aspeed_des_cfb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CFB |
-				HACE_CMD_SINGLE_DES);
-}
-
-static int aspeed_des_cfb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_des_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_CFB |
-				HACE_CMD_SINGLE_DES);
-}
-
 static int aspeed_des_cbc_decrypt(struct skcipher_request *req)
 {
 	return aspeed_des_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CBC |
@@ -659,26 +611,6 @@ static int aspeed_aes_ctr_encrypt(struct skcipher_request *req)
 	return aspeed_aes_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_CTR);
 }
 
-static int aspeed_aes_ofb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_aes_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_OFB);
-}
-
-static int aspeed_aes_ofb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_aes_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_OFB);
-}
-
-static int aspeed_aes_cfb_decrypt(struct skcipher_request *req)
-{
-	return aspeed_aes_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CFB);
-}
-
-static int aspeed_aes_cfb_encrypt(struct skcipher_request *req)
-{
-	return aspeed_aes_crypt(req, HACE_CMD_ENCRYPT | HACE_CMD_CFB);
-}
-
 static int aspeed_aes_cbc_decrypt(struct skcipher_request *req)
 {
 	return aspeed_aes_crypt(req, HACE_CMD_DECRYPT | HACE_CMD_CBC);
@@ -790,60 +722,6 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 			.do_one_request = aspeed_crypto_do_request,
 		},
 	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= AES_BLOCK_SIZE,
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aspeed_aes_setkey,
-			.encrypt	= aspeed_aes_cfb_encrypt,
-			.decrypt	= aspeed_aes_cfb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "cfb(aes)",
-				.cra_driver_name	= "aspeed-cfb-aes",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= 1,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= AES_BLOCK_SIZE,
-			.min_keysize	= AES_MIN_KEY_SIZE,
-			.max_keysize	= AES_MAX_KEY_SIZE,
-			.setkey		= aspeed_aes_setkey,
-			.encrypt	= aspeed_aes_ofb_encrypt,
-			.decrypt	= aspeed_aes_ofb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "ofb(aes)",
-				.cra_driver_name	= "aspeed-ofb-aes",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= 1,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
 	{
 		.alg.skcipher.base = {
 			.min_keysize	= DES_KEY_SIZE,
@@ -897,60 +775,6 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 			.do_one_request = aspeed_crypto_do_request,
 		},
 	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= DES_BLOCK_SIZE,
-			.min_keysize	= DES_KEY_SIZE,
-			.max_keysize	= DES_KEY_SIZE,
-			.setkey		= aspeed_des_setkey,
-			.encrypt	= aspeed_des_cfb_encrypt,
-			.decrypt	= aspeed_des_cfb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "cfb(des)",
-				.cra_driver_name	= "aspeed-cfb-des",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= DES_BLOCK_SIZE,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= DES_BLOCK_SIZE,
-			.min_keysize	= DES_KEY_SIZE,
-			.max_keysize	= DES_KEY_SIZE,
-			.setkey		= aspeed_des_setkey,
-			.encrypt	= aspeed_des_ofb_encrypt,
-			.decrypt	= aspeed_des_ofb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "ofb(des)",
-				.cra_driver_name	= "aspeed-ofb-des",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= DES_BLOCK_SIZE,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
 	{
 		.alg.skcipher.base = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
@@ -1004,60 +828,6 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 			.do_one_request = aspeed_crypto_do_request,
 		},
 	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= DES_BLOCK_SIZE,
-			.min_keysize	= DES3_EDE_KEY_SIZE,
-			.max_keysize	= DES3_EDE_KEY_SIZE,
-			.setkey		= aspeed_des_setkey,
-			.encrypt	= aspeed_tdes_cfb_encrypt,
-			.decrypt	= aspeed_tdes_cfb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "cfb(des3_ede)",
-				.cra_driver_name	= "aspeed-cfb-tdes",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= DES_BLOCK_SIZE,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
-	{
-		.alg.skcipher.base = {
-			.ivsize		= DES_BLOCK_SIZE,
-			.min_keysize	= DES3_EDE_KEY_SIZE,
-			.max_keysize	= DES3_EDE_KEY_SIZE,
-			.setkey		= aspeed_des_setkey,
-			.encrypt	= aspeed_tdes_ofb_encrypt,
-			.decrypt	= aspeed_tdes_ofb_decrypt,
-			.init		= aspeed_crypto_cra_init,
-			.exit		= aspeed_crypto_cra_exit,
-			.base = {
-				.cra_name		= "ofb(des3_ede)",
-				.cra_driver_name	= "aspeed-ofb-tdes",
-				.cra_priority		= 300,
-				.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
-							  CRYPTO_ALG_ASYNC |
-							  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize		= DES_BLOCK_SIZE,
-				.cra_ctxsize		= sizeof(struct aspeed_cipher_ctx),
-				.cra_alignmask		= 0x0f,
-				.cra_module		= THIS_MODULE,
-			}
-		},
-		.alg.skcipher.op = {
-			.do_one_request = aspeed_crypto_do_request,
-		},
-	},
 };
 
 static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
