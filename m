From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/30] crypto: authenc - Use skcipher
Date: Tue, 12 Jul 2016 13:17:34 +0800
Message-ID: <E1bMq4c-0007Os-Ql@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57753 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbcGLFRh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:37 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4c-0004YL-VZ
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:35 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts authenc to use the new skcipher interface as
opposed to ablkcipher.

It also fixes a little bug where if a sync version of authenc
is requested we may still end up using an async ahash.  This should
have no effect as none of the authenc users can request for a
sync authenc.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |  107 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 56 insertions(+), 51 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 309fbc1..a7e1ac7 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -32,8 +32,8 @@ struct authenc_instance_ctx {
 
 struct crypto_authenc_ctx {
 	struct crypto_ahash *auth;
-	struct crypto_ablkcipher *enc;
-	struct crypto_blkcipher *null;
+	struct crypto_skcipher *enc;
+	struct crypto_skcipher *null;
 };
 
 struct authenc_request_ctx {
@@ -83,7 +83,7 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 {
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct crypto_ahash *auth = ctx->auth;
-	struct crypto_ablkcipher *enc = ctx->enc;
+	struct crypto_skcipher *enc = ctx->enc;
 	struct crypto_authenc_keys keys;
 	int err = -EINVAL;
 
@@ -100,11 +100,11 @@ static int crypto_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	if (err)
 		goto out;
 
-	crypto_ablkcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(enc, crypto_aead_get_flags(authenc) &
-					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(enc, keys.enckey, keys.enckeylen);
-	crypto_aead_set_flags(authenc, crypto_ablkcipher_get_flags(enc) &
+	crypto_skcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(enc, crypto_aead_get_flags(authenc) &
+				       CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(enc, keys.enckey, keys.enckeylen);
+	crypto_aead_set_flags(authenc, crypto_skcipher_get_flags(enc) &
 				       CRYPTO_TFM_RES_MASK);
 
 out:
@@ -184,12 +184,15 @@ static int crypto_authenc_copy_assoc(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
-	struct blkcipher_desc desc = {
-		.tfm = ctx->null,
-	};
+	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
 
-	return crypto_blkcipher_encrypt(&desc, req->dst, req->src,
-					req->assoclen);
+	skcipher_request_set_tfm(skreq, ctx->null);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      NULL, NULL);
+	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
+				   NULL);
+
+	return crypto_skcipher_encrypt(skreq);
 }
 
 static int crypto_authenc_encrypt(struct aead_request *req)
@@ -199,10 +202,10 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
-	struct crypto_ablkcipher *enc = ctx->enc;
+	struct crypto_skcipher *enc = ctx->enc;
 	unsigned int cryptlen = req->cryptlen;
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
-						    ictx->reqoff);
+	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
+						  ictx->reqoff);
 	struct scatterlist *src, *dst;
 	int err;
 
@@ -217,12 +220,12 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 	}
 
-	ablkcipher_request_set_tfm(abreq, enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_authenc_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, src, dst, cryptlen, req->iv);
+	skcipher_request_set_tfm(skreq, enc);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      crypto_authenc_encrypt_done, req);
+	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
 
-	err = crypto_ablkcipher_encrypt(abreq);
+	err = crypto_skcipher_encrypt(skreq);
 	if (err)
 		return err;
 
@@ -238,8 +241,8 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct authenc_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct ahash_request *ahreq = (void *)(areq_ctx->tail + ictx->reqoff);
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail +
-						    ictx->reqoff);
+	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
+						  ictx->reqoff);
 	unsigned int authsize = crypto_aead_authsize(authenc);
 	u8 *ihash = ahreq->result + authsize;
 	struct scatterlist *src, *dst;
@@ -255,13 +258,13 @@ static int crypto_authenc_decrypt_tail(struct aead_request *req,
 	if (req->src != req->dst)
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, req->assoclen);
 
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, src, dst,
-				     req->cryptlen - authsize, req->iv);
+	skcipher_request_set_tfm(skreq, ctx->enc);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(skreq, src, dst,
+				   req->cryptlen - authsize, req->iv);
 
-	return crypto_ablkcipher_decrypt(abreq);
+	return crypto_skcipher_decrypt(skreq);
 }
 
 static void authenc_verify_ahash_done(struct crypto_async_request *areq,
@@ -313,20 +316,20 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 	struct authenc_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_ahash *auth;
-	struct crypto_ablkcipher *enc;
-	struct crypto_blkcipher *null;
+	struct crypto_skcipher *enc;
+	struct crypto_skcipher *null;
 	int err;
 
 	auth = crypto_spawn_ahash(&ictx->auth);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
-	enc = crypto_spawn_skcipher(&ictx->enc);
+	enc = crypto_spawn_skcipher2(&ictx->enc);
 	err = PTR_ERR(enc);
 	if (IS_ERR(enc))
 		goto err_free_ahash;
 
-	null = crypto_get_default_null_skcipher();
+	null = crypto_get_default_null_skcipher2();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_skcipher;
@@ -342,13 +345,13 @@ static int crypto_authenc_init_tfm(struct crypto_aead *tfm)
 		max_t(unsigned int,
 		      crypto_ahash_reqsize(auth) +
 		      sizeof(struct ahash_request),
-		      sizeof(struct ablkcipher_request) +
-		      crypto_ablkcipher_reqsize(enc)));
+		      sizeof(struct skcipher_request) +
+		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
 err_free_skcipher:
-	crypto_free_ablkcipher(enc);
+	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
@@ -359,8 +362,8 @@ static void crypto_authenc_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
-	crypto_free_ablkcipher(ctx->enc);
-	crypto_put_default_null_skcipher();
+	crypto_free_skcipher(ctx->enc);
+	crypto_put_default_null_skcipher2();
 }
 
 static void crypto_authenc_free(struct aead_instance *inst)
@@ -379,7 +382,7 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
-	struct crypto_alg *enc;
+	struct skcipher_alg *enc;
 	struct authenc_instance_ctx *ctx;
 	const char *enc_name;
 	int err;
@@ -417,38 +420,40 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher2(&ctx->enc, enc_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
 		goto err_drop_auth;
 
-	enc = crypto_skcipher_spawn_alg(&ctx->enc);
+	enc = crypto_spawn_skcipher_alg(&ctx->enc);
 
 	ctx->reqoff = ALIGN(2 * auth->digestsize + auth_base->cra_alignmask,
 			    auth_base->cra_alignmask + 1);
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "authenc(%s,%s)", auth_base->cra_name, enc->cra_name) >=
+		     "authenc(%s,%s)", auth_base->cra_name,
+		     enc->base.cra_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authenc(%s,%s)", auth_base->cra_driver_name,
-		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     enc->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	inst->alg.base.cra_flags = (auth_base->cra_flags | enc->cra_flags) &
-				   CRYPTO_ALG_ASYNC;
-	inst->alg.base.cra_priority = enc->cra_priority * 10 +
+	inst->alg.base.cra_flags = (auth_base->cra_flags |
+				    enc->base.cra_flags) & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_priority = enc->base.cra_priority * 10 +
 				      auth_base->cra_priority;
-	inst->alg.base.cra_blocksize = enc->cra_blocksize;
+	inst->alg.base.cra_blocksize = enc->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = auth_base->cra_alignmask |
-				       enc->cra_alignmask;
+				       enc->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
 
-	inst->alg.ivsize = enc->cra_ablkcipher.ivsize;
+	inst->alg.ivsize = crypto_skcipher_alg_ivsize(enc);
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(enc);
 	inst->alg.maxauthsize = auth->digestsize;
 
 	inst->alg.init = crypto_authenc_init_tfm;
