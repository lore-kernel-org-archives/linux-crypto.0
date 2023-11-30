Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438831B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g9A-005ILj-Sb; Thu, 30 Nov 2023 20:28:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:10 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:10 +0800
Subject: [PATCH 10/19] crypto: hisilicon/sec2 - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g9A-005ILj-Sb@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/hisilicon/sec2/sec_crypto.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 6fcabbc87860..a1b65391f792 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -879,15 +879,11 @@ static int sec_setkey_##name(struct crypto_skcipher *tfm, const u8 *key,\
 GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
-GEN_SEC_SETKEY_FUNC(aes_ofb, SEC_CALG_AES, SEC_CMODE_OFB)
-GEN_SEC_SETKEY_FUNC(aes_cfb, SEC_CALG_AES, SEC_CMODE_CFB)
 GEN_SEC_SETKEY_FUNC(aes_ctr, SEC_CALG_AES, SEC_CMODE_CTR)
 GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
 GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
 GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
 GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
-GEN_SEC_SETKEY_FUNC(sm4_ofb, SEC_CALG_SM4, SEC_CMODE_OFB)
-GEN_SEC_SETKEY_FUNC(sm4_cfb, SEC_CALG_SM4, SEC_CMODE_CFB)
 GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 
 static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
@@ -2197,16 +2193,6 @@ static struct sec_skcipher sec_skciphers[] = {
 		.alg = SEC_SKCIPHER_ALG("xts(aes)", sec_setkey_aes_xts,	SEC_XTS_MIN_KEY_SIZE,
 					SEC_XTS_MAX_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 	},
-	{
-		.alg_msk = BIT(4),
-		.alg = SEC_SKCIPHER_ALG("ofb(aes)", sec_setkey_aes_ofb,	AES_MIN_KEY_SIZE,
-					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
-	},
-	{
-		.alg_msk = BIT(5),
-		.alg = SEC_SKCIPHER_ALG("cfb(aes)", sec_setkey_aes_cfb,	AES_MIN_KEY_SIZE,
-					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
-	},
 	{
 		.alg_msk = BIT(12),
 		.alg = SEC_SKCIPHER_ALG("cbc(sm4)", sec_setkey_sm4_cbc,	AES_MIN_KEY_SIZE,
@@ -2222,16 +2208,6 @@ static struct sec_skcipher sec_skciphers[] = {
 		.alg = SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,	SEC_XTS_MIN_KEY_SIZE,
 					SEC_XTS_MIN_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
 	},
-	{
-		.alg_msk = BIT(15),
-		.alg = SEC_SKCIPHER_ALG("ofb(sm4)", sec_setkey_sm4_ofb,	AES_MIN_KEY_SIZE,
-					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
-	},
-	{
-		.alg_msk = BIT(16),
-		.alg = SEC_SKCIPHER_ALG("cfb(sm4)", sec_setkey_sm4_cfb,	AES_MIN_KEY_SIZE,
-					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
-	},
 	{
 		.alg_msk = BIT(23),
 		.alg = SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb, SEC_DES3_3KEY_SIZE,
