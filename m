From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/28] crypto: qce - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:04 +0800
Message-ID: <E1bICLk-0006vb-QO@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36971 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcF2KEI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:08 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLk-0005Kt-UD
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete ablkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/qce/ablkcipher.c |   27 ++++++++++++++++-----------
 drivers/crypto/qce/cipher.h     |    2 +-
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index dbcbbe2..b04b42f 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -15,8 +15,8 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
 #include <crypto/des.h>
+#include <crypto/internal/skcipher.h>
 
 #include "cipher.h"
 
@@ -189,7 +189,7 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	memcpy(ctx->enc_key, key, keylen);
 	return 0;
 fallback:
-	ret = crypto_ablkcipher_setkey(ctx->fallback, key, keylen);
+	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 	if (!ret)
 		ctx->enc_keylen = keylen;
 	return ret;
@@ -212,10 +212,16 @@ static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 
 	if (IS_AES(rctx->flags) && ctx->enc_keylen != AES_KEYSIZE_128 &&
 	    ctx->enc_keylen != AES_KEYSIZE_256) {
-		ablkcipher_request_set_tfm(req, ctx->fallback);
-		ret = encrypt ? crypto_ablkcipher_encrypt(req) :
-				crypto_ablkcipher_decrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		ret = encrypt ? crypto_skcipher_encrypt(subreq) :
+				crypto_skcipher_decrypt(subreq);
+		skcipher_request_zero(subreq);
 		return ret;
 	}
 
@@ -239,10 +245,9 @@ static int qce_ablkcipher_init(struct crypto_tfm *tfm)
 	memset(ctx, 0, sizeof(*ctx));
 	tfm->crt_ablkcipher.reqsize = sizeof(struct qce_cipher_reqctx);
 
-	ctx->fallback = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm),
-						CRYPTO_ALG_TYPE_ABLKCIPHER,
-						CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK);
+	ctx->fallback = crypto_alloc_skcipher(crypto_tfm_alg_name(tfm), 0,
+					      CRYPTO_ALG_ASYNC |
+					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback))
 		return PTR_ERR(ctx->fallback);
 
@@ -253,7 +258,7 @@ static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
 {
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_ablkcipher(ctx->fallback);
+	crypto_free_skcipher(ctx->fallback);
 }
 
 struct qce_ablkcipher_def {
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 5c6a5f8..2b0278b 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -22,7 +22,7 @@
 struct qce_cipher_ctx {
 	u8 enc_key[QCE_MAX_KEY_SIZE];
 	unsigned int enc_keylen;
-	struct crypto_ablkcipher *fallback;
+	struct crypto_skcipher *fallback;
 };
 
 /**
