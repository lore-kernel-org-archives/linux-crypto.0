Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38F1B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:17 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9N-005IOt-Ff; Thu, 30 Nov 2023 20:28:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:22 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:22 +0800
Subject: [PATCH 16/19] crypto: ccree - Remove ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9N-005IOt-Ff@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccree/cc_cipher.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d229e54fa935..cd66a580e8b6 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1079,24 +1079,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
-	{
-		.name = "ofb(paes)",
-		.driver_name = "ofb-paes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
-		.template_skcipher = {
-			.setkey = cc_cipher_sethkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = CC_HW_KEY_SIZE,
-			.max_keysize = CC_HW_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_OFB,
-		.flow_mode = S_DIN_to_AES,
-		.min_hw_rev = CC_HW_REV_712,
-		.std_body = CC_STD_NIST,
-		.sec_func = true,
-	},
 	{
 		.name = "cts(cbc(paes))",
 		.driver_name = "cts-cbc-paes-ccree",
@@ -1205,23 +1187,6 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_630,
 		.std_body = CC_STD_NIST,
 	},
-	{
-		.name = "ofb(aes)",
-		.driver_name = "ofb-aes-ccree",
-		.blocksize = 1,
-		.template_skcipher = {
-			.setkey = cc_cipher_setkey,
-			.encrypt = cc_cipher_encrypt,
-			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.cipher_mode = DRV_CIPHER_OFB,
-		.flow_mode = S_DIN_to_AES,
-		.min_hw_rev = CC_HW_REV_630,
-		.std_body = CC_STD_NIST,
-	},
 	{
 		.name = "cts(cbc(aes))",
 		.driver_name = "cts-cbc-aes-ccree",
