Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AF41AD
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9H-005INo-4r; Thu, 30 Nov 2023 20:28:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:16 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:16 +0800
Subject: [PATCH 13/19] crypto: n2 - Remove cfb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9H-005INo-4r@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/n2_core.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 37d958cfa9bb..7a3083debc2b 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1121,19 +1121,6 @@ static const struct n2_skcipher_tmpl skcipher_tmpls[] = {
 			.decrypt	= n2_decrypt_chaining,
 		},
 	},
-	{	.name		= "cfb(des)",
-		.drv_name	= "cfb-des",
-		.block_size	= DES_BLOCK_SIZE,
-		.enc_type	= (ENC_TYPE_ALG_DES |
-				   ENC_TYPE_CHAINING_CFB),
-		.skcipher	= {
-			.min_keysize	= DES_KEY_SIZE,
-			.max_keysize	= DES_KEY_SIZE,
-			.setkey		= n2_des_setkey,
-			.encrypt	= n2_encrypt_chaining,
-			.decrypt	= n2_decrypt_chaining,
-		},
-	},
 
 	/* 3DES: ECB CBC and CFB are supported */
 	{	.name		= "ecb(des3_ede)",
@@ -1163,19 +1150,7 @@ static const struct n2_skcipher_tmpl skcipher_tmpls[] = {
 			.decrypt	= n2_decrypt_chaining,
 		},
 	},
-	{	.name		= "cfb(des3_ede)",
-		.drv_name	= "cfb-3des",
-		.block_size	= DES_BLOCK_SIZE,
-		.enc_type	= (ENC_TYPE_ALG_3DES |
-				   ENC_TYPE_CHAINING_CFB),
-		.skcipher	= {
-			.min_keysize	= 3 * DES_KEY_SIZE,
-			.max_keysize	= 3 * DES_KEY_SIZE,
-			.setkey		= n2_3des_setkey,
-			.encrypt	= n2_encrypt_chaining,
-			.decrypt	= n2_decrypt_chaining,
-		},
-	},
+
 	/* AES: ECB CBC and CTR are supported */
 	{	.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes",
