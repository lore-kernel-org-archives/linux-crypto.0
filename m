Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C96DD46
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:59 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g94-005IJd-JO; Thu, 30 Nov 2023 20:27:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:03 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:03 +0800
Subject: [PATCH 7/19] crypto: nitrox - Remove cfb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g94-005IJd-JO@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/cavium/nitrox/nitrox_skcipher.c |   19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
index 138261dcd032..6e5e667bab75 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -419,25 +419,6 @@ static struct skcipher_alg nitrox_skciphers[] = { {
 	.decrypt = nitrox_aes_decrypt,
 	.init = nitrox_skcipher_init,
 	.exit = nitrox_skcipher_exit,
-}, {
-	.base = {
-		.cra_name = "cfb(aes)",
-		.cra_driver_name = "n5_cfb(aes)",
-		.cra_priority = PRIO,
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct nitrox_crypto_ctx),
-		.cra_alignmask = 0,
-		.cra_module = THIS_MODULE,
-	},
-	.min_keysize = AES_MIN_KEY_SIZE,
-	.max_keysize = AES_MAX_KEY_SIZE,
-	.ivsize = AES_BLOCK_SIZE,
-	.setkey = nitrox_aes_setkey,
-	.encrypt = nitrox_aes_encrypt,
-	.decrypt = nitrox_aes_decrypt,
-	.init = nitrox_skcipher_init,
-	.exit = nitrox_skcipher_exit,
 }, {
 	.base = {
 		.cra_name = "xts(aes)",
