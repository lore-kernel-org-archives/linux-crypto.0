Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BAB1B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:13 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9J-005INy-8H; Thu, 30 Nov 2023 20:28:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:18 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:18 +0800
Subject: [PATCH 14/19] crypto: starfive - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9J-005INy-8H@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/starfive/jh7110-aes.c |   62 -----------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 9378e6682f0e..d1da9b366bbc 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -783,26 +783,6 @@ static int starfive_aes_cbc_decrypt(struct skcipher_request *req)
 	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CBC);
 }
 
-static int starfive_aes_cfb_encrypt(struct skcipher_request *req)
-{
-	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CFB | FLG_ENCRYPT);
-}
-
-static int starfive_aes_cfb_decrypt(struct skcipher_request *req)
-{
-	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CFB);
-}
-
-static int starfive_aes_ofb_encrypt(struct skcipher_request *req)
-{
-	return starfive_aes_crypt(req, STARFIVE_AES_MODE_OFB | FLG_ENCRYPT);
-}
-
-static int starfive_aes_ofb_decrypt(struct skcipher_request *req)
-{
-	return starfive_aes_crypt(req, STARFIVE_AES_MODE_OFB);
-}
-
 static int starfive_aes_ctr_encrypt(struct skcipher_request *req)
 {
 	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CTR | FLG_ENCRYPT);
@@ -908,48 +888,6 @@ static struct skcipher_engine_alg skcipher_algs[] = {
 	.op = {
 		.do_one_request = starfive_aes_do_one_req,
 	},
-}, {
-	.base.init			= starfive_aes_init_tfm,
-	.base.setkey			= starfive_aes_setkey,
-	.base.encrypt			= starfive_aes_cfb_encrypt,
-	.base.decrypt			= starfive_aes_cfb_decrypt,
-	.base.min_keysize		= AES_MIN_KEY_SIZE,
-	.base.max_keysize		= AES_MAX_KEY_SIZE,
-	.base.ivsize			= AES_BLOCK_SIZE,
-	.base.base = {
-		.cra_name		= "cfb(aes)",
-		.cra_driver_name	= "starfive-cfb-aes",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-		.cra_alignmask		= 0xf,
-		.cra_module		= THIS_MODULE,
-	},
-	.op = {
-		.do_one_request = starfive_aes_do_one_req,
-	},
-}, {
-	.base.init			= starfive_aes_init_tfm,
-	.base.setkey			= starfive_aes_setkey,
-	.base.encrypt			= starfive_aes_ofb_encrypt,
-	.base.decrypt			= starfive_aes_ofb_decrypt,
-	.base.min_keysize		= AES_MIN_KEY_SIZE,
-	.base.max_keysize		= AES_MAX_KEY_SIZE,
-	.base.ivsize			= AES_BLOCK_SIZE,
-	.base.base = {
-		.cra_name		= "ofb(aes)",
-		.cra_driver_name	= "starfive-ofb-aes",
-		.cra_priority		= 200,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
-		.cra_alignmask		= 0xf,
-		.cra_module		= THIS_MODULE,
-	},
-	.op = {
-		.do_one_request = starfive_aes_do_one_req,
-	},
 },
 };
 
