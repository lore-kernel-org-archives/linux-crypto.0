From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 5/9]crypto/chcr: Calculate Reverse round key in setkey callback.
Date: Mon, 21 Nov 2016 21:30:51 +0530
Message-ID: <d5b4d7c042f746874f5d609b465eaad2b8a9b44b.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:23925 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754479AbcKUQBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 11:01:39 -0500
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move reverse round key calculation logic in setkey operation.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 52 ++++++++++++++++--------------------
 drivers/crypto/chelsio/chcr_crypto.h |  2 +-
 2 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index c78d107..d5e0066 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -455,16 +455,13 @@ static int generate_copy_rrkey(struct ablk_ctx *ablkctx,
 			       struct _key_ctx *key_ctx)
 {
 	if (ablkctx->ciph_mode == CHCR_SCMD_CIPHER_MODE_AES_CBC) {
-		get_aes_decrypt_key(key_ctx->key, ablkctx->key,
-				    ablkctx->enckey_len << 3);
-		memset(key_ctx->key + ablkctx->enckey_len, 0,
-		       CHCR_AES_MAX_KEY_LEN - ablkctx->enckey_len);
+		memcpy(key_ctx->key, ablkctx->rrkey, ablkctx->enckey_len);
 	} else {
 		memcpy(key_ctx->key,
 		       ablkctx->key + (ablkctx->enckey_len >> 1),
 		       ablkctx->enckey_len >> 1);
-		get_aes_decrypt_key(key_ctx->key + (ablkctx->enckey_len >> 1),
-				    ablkctx->key, ablkctx->enckey_len << 2);
+		memcpy(key_ctx->key + (ablkctx->enckey_len >> 1),
+		       ablkctx->rrkey, ablkctx->enckey_len >> 1);
 	}
 	return 0;
 }
@@ -620,15 +617,9 @@ static int chcr_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
-	struct ablkcipher_alg *alg = crypto_ablkcipher_alg(tfm);
 	unsigned int ck_size, context_size;
 	u16 alignment = 0;
 
-	if ((keylen < alg->min_keysize) || (keylen > alg->max_keysize))
-		goto badkey_err;
-
-	memcpy(ablkctx->key, key, keylen);
-	ablkctx->enckey_len = keylen;
 	if (keylen == AES_KEYSIZE_128) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
 	} else if (keylen == AES_KEYSIZE_192) {
@@ -639,7 +630,9 @@ static int chcr_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	} else {
 		goto badkey_err;
 	}
-
+	memcpy(ablkctx->key, key, keylen);
+	ablkctx->enckey_len = keylen;
+	get_aes_decrypt_key(ablkctx->rrkey, ablkctx->key, keylen << 3);
 	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD +
 			keylen + alignment) >> 4;
 
@@ -1172,28 +1165,29 @@ static int chcr_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
-	int status = 0;
 	unsigned short context_size = 0;
 
-	if ((key_len == (AES_KEYSIZE_128 << 1)) ||
-	    (key_len == (AES_KEYSIZE_256 << 1))) {
-		memcpy(ablkctx->key, key, key_len);
-		ablkctx->enckey_len = key_len;
-		context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len) >> 4;
-		ablkctx->key_ctx_hdr =
-			FILL_KEY_CTX_HDR((key_len == AES_KEYSIZE_256) ?
-					 CHCR_KEYCTX_CIPHER_KEY_SIZE_128 :
-					 CHCR_KEYCTX_CIPHER_KEY_SIZE_256,
-					 CHCR_KEYCTX_NO_KEY, 1,
-					 0, context_size);
-		ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
-	} else {
+	if ((key_len != (AES_KEYSIZE_128 << 1)) &&
+	    (key_len != (AES_KEYSIZE_256 << 1))) {
 		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
 				     CRYPTO_TFM_RES_BAD_KEY_LEN);
 		ablkctx->enckey_len = 0;
-		status = -EINVAL;
+		return -EINVAL;
+
 	}
-	return status;
+
+	memcpy(ablkctx->key, key, key_len);
+	ablkctx->enckey_len = key_len;
+	get_aes_decrypt_key(ablkctx->rrkey, ablkctx->key, key_len << 2);
+	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len) >> 4;
+	ablkctx->key_ctx_hdr =
+		FILL_KEY_CTX_HDR((key_len == AES_KEYSIZE_256) ?
+				 CHCR_KEYCTX_CIPHER_KEY_SIZE_128 :
+				 CHCR_KEYCTX_CIPHER_KEY_SIZE_256,
+				 CHCR_KEYCTX_NO_KEY, 1,
+				 0, context_size);
+	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
+	return 0;
 }
 
 static int chcr_sha_init(struct ahash_request *areq)
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 8934ea2..7ed6d2b 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -125,8 +125,8 @@ struct ablk_ctx {
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
 	unsigned int dst_nents;
-	struct scatterlist iv_sg;
 	u8 key[CHCR_AES_MAX_KEY_LEN];
+	u8 rrkey[AES_MAX_KEY_SIZE];
 	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
 	unsigned char ciph_mode;
 };
-- 
1.8.2.3
