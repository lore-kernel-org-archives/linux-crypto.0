From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 17/28] crypto: picoxcell - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:03 +0800
Message-ID: <E1bICLj-0006vK-Nd@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53357 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcF2KEG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:06 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLj-0005KX-Sq
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:03 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete ablkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |   60 +++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3b1c7ec..4757609 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -171,7 +171,7 @@ struct spacc_ablk_ctx {
 	 * The fallback cipher. If the operation can't be done in hardware,
 	 * fallback to a software version.
 	 */
-	struct crypto_ablkcipher	*sw_cipher;
+	struct crypto_skcipher		*sw_cipher;
 };
 
 /* AEAD cipher context. */
@@ -789,33 +789,35 @@ static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	 * request for any other size (192 bits) then we need to do a software
 	 * fallback.
 	 */
-	if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256 &&
-	    ctx->sw_cipher) {
+	if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256) {
+		if (!ctx->sw_cipher)
+			return -EINVAL;
+
 		/*
 		 * Set the fallback transform to use the same request flags as
 		 * the hardware transform.
 		 */
-		ctx->sw_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-		ctx->sw_cipher->base.crt_flags |=
-			cipher->base.crt_flags & CRYPTO_TFM_REQ_MASK;
+		crypto_skcipher_clear_flags(ctx->sw_cipher,
+					    CRYPTO_TFM_REQ_MASK);
+		crypto_skcipher_set_flags(ctx->sw_cipher,
+					  cipher->base.crt_flags &
+					  CRYPTO_TFM_REQ_MASK);
+
+		err = crypto_skcipher_setkey(ctx->sw_cipher, key, len);
+
+		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm->crt_flags |=
+			crypto_skcipher_get_flags(ctx->sw_cipher) &
+			CRYPTO_TFM_RES_MASK;
 
-		err = crypto_ablkcipher_setkey(ctx->sw_cipher, key, len);
 		if (err)
 			goto sw_setkey_failed;
-	} else if (len != AES_KEYSIZE_128 && len != AES_KEYSIZE_256 &&
-		   !ctx->sw_cipher)
-		err = -EINVAL;
+	}
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
 
 sw_setkey_failed:
-	if (err && ctx->sw_cipher) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |=
-			ctx->sw_cipher->base.crt_flags & CRYPTO_TFM_RES_MASK;
-	}
-
 	return err;
 }
 
@@ -910,20 +912,21 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	struct crypto_tfm *old_tfm =
 	    crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(old_tfm);
+	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher);
 	int err;
 
-	if (!ctx->sw_cipher)
-		return -EINVAL;
-
 	/*
 	 * Change the request to use the software fallback transform, and once
 	 * the ciphering has completed, put the old transform back into the
 	 * request.
 	 */
-	ablkcipher_request_set_tfm(req, ctx->sw_cipher);
-	err = is_encrypt ? crypto_ablkcipher_encrypt(req) :
-		crypto_ablkcipher_decrypt(req);
-	ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(old_tfm));
+	skcipher_request_set_tfm(subreq, ctx->sw_cipher);
+	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->nbytes, req->info);
+	err = is_encrypt ? crypto_skcipher_encrypt(subreq) :
+			   crypto_skcipher_decrypt(subreq);
+	skcipher_request_zero(subreq);
 
 	return err;
 }
@@ -1015,12 +1018,13 @@ static int spacc_ablk_cra_init(struct crypto_tfm *tfm)
 	ctx->generic.flags = spacc_alg->type;
 	ctx->generic.engine = engine;
 	if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
-		ctx->sw_cipher = crypto_alloc_ablkcipher(alg->cra_name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+		ctx->sw_cipher = crypto_alloc_skcipher(
+			alg->cra_name, 0, CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(ctx->sw_cipher)) {
 			dev_warn(engine->dev, "failed to allocate fallback for %s\n",
 				 alg->cra_name);
-			ctx->sw_cipher = NULL;
+			return PTR_ERR(ctx->sw_cipher);
 		}
 	}
 	ctx->generic.key_offs = spacc_alg->key_offs;
@@ -1035,9 +1039,7 @@ static void spacc_ablk_cra_exit(struct crypto_tfm *tfm)
 {
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (ctx->sw_cipher)
-		crypto_free_ablkcipher(ctx->sw_cipher);
-	ctx->sw_cipher = NULL;
+	crypto_free_skcipher(ctx->sw_cipher);
 }
 
 static int spacc_ablk_encrypt(struct ablkcipher_request *req)
