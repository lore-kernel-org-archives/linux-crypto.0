From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 19/28] crypto: sahara - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:05 +0800
Message-ID: <E1bICLl-0006vs-T3@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34114 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcF2KEJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLm-0005LA-2t
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete ablkcipher with skcipher.

It also removes shash_fallback which is totally unused.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/sahara.c |  112 +++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c3f3d89..0c49956 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -14,10 +14,9 @@
  * Based on omap-aes.c and tegra-aes.c
  */
 
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha.h>
 
@@ -150,10 +149,7 @@ struct sahara_ctx {
 	/* AES-specific context */
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
-	struct crypto_ablkcipher *fallback;
-
-	/* SHA-specific context */
-	struct crypto_shash *shash_fallback;
+	struct crypto_skcipher *fallback;
 };
 
 struct sahara_aes_reqctx {
@@ -620,25 +616,21 @@ static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		return 0;
 	}
 
-	if (keylen != AES_KEYSIZE_128 &&
-	    keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+	if (keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
 	/*
 	 * The requested key size is not supported by HW, do a fallback.
 	 */
-	ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	ctx->fallback->base.crt_flags |=
-		(tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
+						 CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_ablkcipher_setkey(ctx->fallback, key, keylen);
-	if (ret) {
-		struct crypto_tfm *tfm_aux = crypto_ablkcipher_tfm(tfm);
+	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
 
-		tfm_aux->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm_aux->crt_flags |=
-			(ctx->fallback->base.crt_flags & CRYPTO_TFM_RES_MASK);
-	}
+	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
+	tfm->base.crt_flags |= crypto_skcipher_get_flags(ctx->fallback) &
+			       CRYPTO_TFM_RES_MASK;
 	return ret;
 }
 
@@ -670,16 +662,20 @@ static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		ablkcipher_request_set_tfm(req, ctx->fallback);
-		err = crypto_ablkcipher_encrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		err = crypto_skcipher_encrypt(subreq);
+		skcipher_request_zero(subreq);
 		return err;
 	}
 
@@ -688,16 +684,20 @@ static int sahara_aes_ecb_encrypt(struct ablkcipher_request *req)
 
 static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		ablkcipher_request_set_tfm(req, ctx->fallback);
-		err = crypto_ablkcipher_decrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		err = crypto_skcipher_decrypt(subreq);
+		skcipher_request_zero(subreq);
 		return err;
 	}
 
@@ -706,16 +706,20 @@ static int sahara_aes_ecb_decrypt(struct ablkcipher_request *req)
 
 static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		ablkcipher_request_set_tfm(req, ctx->fallback);
-		err = crypto_ablkcipher_encrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		err = crypto_skcipher_encrypt(subreq);
+		skcipher_request_zero(subreq);
 		return err;
 	}
 
@@ -724,16 +728,20 @@ static int sahara_aes_cbc_encrypt(struct ablkcipher_request *req)
 
 static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
 		crypto_ablkcipher_reqtfm(req));
 	int err;
 
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		ablkcipher_request_set_tfm(req, ctx->fallback);
-		err = crypto_ablkcipher_decrypt(req);
-		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags,
+					      NULL, NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+		err = crypto_skcipher_decrypt(subreq);
+		skcipher_request_zero(subreq);
 		return err;
 	}
 
@@ -745,8 +753,9 @@ static int sahara_aes_cra_init(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	ctx->fallback = crypto_alloc_ablkcipher(name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	ctx->fallback = crypto_alloc_skcipher(name, 0,
+					      CRYPTO_ALG_ASYNC |
+					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback)) {
 		pr_err("Error allocating fallback algo %s\n", name);
 		return PTR_ERR(ctx->fallback);
@@ -761,9 +770,7 @@ static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
 {
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (ctx->fallback)
-		crypto_free_ablkcipher(ctx->fallback);
-	ctx->fallback = NULL;
+	crypto_free_skcipher(ctx->fallback);
 }
 
 static u32 sahara_sha_init_hdr(struct sahara_dev *dev,
@@ -1180,15 +1187,6 @@ static int sahara_sha_import(struct ahash_request *req, const void *in)
 
 static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 {
-	const char *name = crypto_tfm_alg_name(tfm);
-	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->shash_fallback = crypto_alloc_shash(name, 0,
-					CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(ctx->shash_fallback)) {
-		pr_err("Error allocating fallback algo %s\n", name);
-		return PTR_ERR(ctx->shash_fallback);
-	}
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct sahara_sha_reqctx) +
 				 SHA_BUFFER_LEN + SHA256_BLOCK_SIZE);
@@ -1196,14 +1194,6 @@ static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static void sahara_sha_cra_exit(struct crypto_tfm *tfm)
-{
-	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_shash(ctx->shash_fallback);
-	ctx->shash_fallback = NULL;
-}
-
 static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ecb(aes)",
@@ -1272,7 +1262,6 @@ static struct ahash_alg sha_v3_algs[] = {
 		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= sahara_sha_cra_init,
-		.cra_exit		= sahara_sha_cra_exit,
 	}
 },
 };
@@ -1300,7 +1289,6 @@ static struct ahash_alg sha_v4_algs[] = {
 		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= sahara_sha_cra_init,
-		.cra_exit		= sahara_sha_cra_exit,
 	}
 },
 };
