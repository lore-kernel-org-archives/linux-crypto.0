Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BCA1B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:09 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9F-005IMt-2i; Thu, 30 Nov 2023 20:28:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:14 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:14 +0800
Subject: [PATCH 12/19] crypto: octeontx - Remove cfb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9F-005IMt-2i@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 1c2c870e887a..3c5d577d8f0d 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -473,12 +473,6 @@ static int otx_cpt_skcipher_ecb_aes_setkey(struct crypto_skcipher *tfm,
 	return cpt_aes_setkey(tfm, key, keylen, OTX_CPT_AES_ECB);
 }
 
-static int otx_cpt_skcipher_cfb_aes_setkey(struct crypto_skcipher *tfm,
-					   const u8 *key, u32 keylen)
-{
-	return cpt_aes_setkey(tfm, key, keylen, OTX_CPT_AES_CFB);
-}
-
 static int otx_cpt_skcipher_cbc_des3_setkey(struct crypto_skcipher *tfm,
 					    const u8 *key, u32 keylen)
 {
@@ -1351,23 +1345,6 @@ static struct skcipher_alg otx_cpt_skciphers[] = { {
 	.setkey = otx_cpt_skcipher_ecb_aes_setkey,
 	.encrypt = otx_cpt_skcipher_encrypt,
 	.decrypt = otx_cpt_skcipher_decrypt,
-}, {
-	.base.cra_name = "cfb(aes)",
-	.base.cra_driver_name = "cpt_cfb_aes",
-	.base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
-	.base.cra_blocksize = AES_BLOCK_SIZE,
-	.base.cra_ctxsize = sizeof(struct otx_cpt_enc_ctx),
-	.base.cra_alignmask = 7,
-	.base.cra_priority = 4001,
-	.base.cra_module = THIS_MODULE,
-
-	.init = otx_cpt_enc_dec_init,
-	.ivsize = AES_BLOCK_SIZE,
-	.min_keysize = AES_MIN_KEY_SIZE,
-	.max_keysize = AES_MAX_KEY_SIZE,
-	.setkey = otx_cpt_skcipher_cfb_aes_setkey,
-	.encrypt = otx_cpt_skcipher_encrypt,
-	.decrypt = otx_cpt_skcipher_decrypt,
 }, {
 	.base.cra_name = "cbc(des3_ede)",
 	.base.cra_driver_name = "cpt_cbc_des3_ede",
