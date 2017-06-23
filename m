From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH] crypto: chcr: Avoid algo allocation in softirq.
Date: Fri, 23 Jun 2017 19:45:11 +0530
Message-ID: <ec9da7c14a5a5a21da0eb1cef7882cff1ca0cf03.1498225095.git.harsh@chelsio.com>
References: <cover.1498225095.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:49844 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdFWOPj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 10:15:39 -0400
In-Reply-To: <cover.1498225095.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thsi patch fixes calling "crypto_alloc_cipher" call in bottom halves.
Pre allocate aes cipher required to update Tweak value for XTS.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 23 +++++++++++++++--------
 drivers/crypto/chelsio/chcr_crypto.h |  1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index aa4e5b8..508cbc7 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -899,26 +899,20 @@ static int chcr_update_tweak(struct ablkcipher_request *req, u8 *iv)
 	u8 *key;
 	unsigned int keylen;
 
-	cipher = crypto_alloc_cipher("aes-generic", 0, 0);
+	cipher = ablkctx->aes_generic;
 	memcpy(iv, req->info, AES_BLOCK_SIZE);
 
-	if (IS_ERR(cipher)) {
-		ret = -ENOMEM;
-		goto out;
-	}
 	keylen = ablkctx->enckey_len / 2;
 	key = ablkctx->key + keylen;
 	ret = crypto_cipher_setkey(cipher, key, keylen);
 	if (ret)
-		goto out1;
+		goto out;
 
 	crypto_cipher_encrypt_one(cipher, iv, iv);
 	for (i = 0; i < (reqctx->processed / AES_BLOCK_SIZE); i++)
 		gf128mul_x_ble((le128 *)iv, (le128 *)iv);
 
 	crypto_cipher_decrypt_one(cipher, iv, iv);
-out1:
-	crypto_free_cipher(cipher);
 out:
 	return ret;
 }
@@ -1262,6 +1256,17 @@ static int chcr_cra_init(struct crypto_tfm *tfm)
 		pr_err("failed to allocate fallback for %s\n", alg->cra_name);
 		return PTR_ERR(ablkctx->sw_cipher);
 	}
+
+	if (get_cryptoalg_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_XTS) {
+		/* To update tweak*/
+		ablkctx->aes_generic = crypto_alloc_cipher("aes-generic", 0, 0);
+		if (IS_ERR(ablkctx->aes_generic)) {
+			pr_err("failed to allocate aes cipher for tweak\n");
+			return PTR_ERR(ablkctx->aes_generic);
+		}
+	} else
+		ablkctx->aes_generic = NULL;
+
 	tfm->crt_ablkcipher.reqsize =  sizeof(struct chcr_blkcipher_req_ctx);
 	return chcr_device_init(crypto_tfm_ctx(tfm));
 }
@@ -1292,6 +1297,8 @@ static void chcr_cra_exit(struct crypto_tfm *tfm)
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 
 	crypto_free_skcipher(ablkctx->sw_cipher);
+	if (ablkctx->aes_generic)
+		crypto_free_cipher(ablkctx->aes_generic);
 }
 
 static int get_alg_config(struct algo_param *params,
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index a4f95b0..30af1ee 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -155,6 +155,7 @@
 
 struct ablk_ctx {
 	struct crypto_skcipher *sw_cipher;
+	struct crypto_cipher *aes_generic;
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
 	unsigned char ciph_mode;
-- 
2.1.4
