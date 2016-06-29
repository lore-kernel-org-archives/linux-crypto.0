From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/28] crypto: authencesn - Use skcipher
Date: Wed, 29 Jun 2016 18:03:52 +0800
Message-ID: <E1bICLY-0006sa-O5@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33887 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcF2KD4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:03:56 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLY-0005G2-V0
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:53 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts authencesn to use the new skcipher interface as
opposed to ablkcipher.

It also fixes a little bug where if a sync version of authencesn
is requested we may still end up using an async ahash.  This should
have no effect as none of the authencesn users can request for a
sync authencesn.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authencesn.c |  103 ++++++++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 50 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 0662b18..528fdcb 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -35,8 +35,8 @@ struct authenc_esn_instance_ctx {
 struct crypto_authenc_esn_ctx {
 	unsigned int reqoff;
 	struct crypto_ahash *auth;
-	struct crypto_ablkcipher *enc;
-	struct crypto_blkcipher *null;
+	struct crypto_skcipher *enc;
+	struct crypto_skcipher *null;
 };
 
 struct authenc_esn_request_ctx {
@@ -65,7 +65,7 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 {
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
 	struct crypto_ahash *auth = ctx->auth;
-	struct crypto_ablkcipher *enc = ctx->enc;
+	struct crypto_skcipher *enc = ctx->enc;
 	struct crypto_authenc_keys keys;
 	int err = -EINVAL;
 
@@ -82,11 +82,11 @@ static int crypto_authenc_esn_setkey(struct crypto_aead *authenc_esn, const u8 *
 	if (err)
 		goto out;
 
-	crypto_ablkcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(enc, crypto_aead_get_flags(authenc_esn) &
+	crypto_skcipher_clear_flags(enc, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(enc, crypto_aead_get_flags(authenc_esn) &
 					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(enc, keys.enckey, keys.enckeylen);
-	crypto_aead_set_flags(authenc_esn, crypto_ablkcipher_get_flags(enc) &
+	err = crypto_skcipher_setkey(enc, keys.enckey, keys.enckeylen);
+	crypto_aead_set_flags(authenc_esn, crypto_skcipher_get_flags(enc) &
 					   CRYPTO_TFM_RES_MASK);
 
 out:
@@ -182,11 +182,14 @@ static int crypto_authenc_esn_copy(struct aead_request *req, unsigned int len)
 {
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct blkcipher_desc desc = {
-		.tfm = ctx->null,
-	};
+	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
 
-	return crypto_blkcipher_encrypt(&desc, req->dst, req->src, len);
+	skcipher_request_set_tfm(skreq, ctx->null);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      NULL, NULL);
+	skcipher_request_set_crypt(skreq, req->src, req->dst, len, NULL);
+
+	return crypto_skcipher_encrypt(skreq);
 }
 
 static int crypto_authenc_esn_encrypt(struct aead_request *req)
@@ -194,9 +197,9 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 	struct crypto_aead *authenc_esn = crypto_aead_reqtfm(req);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
-						    + ctx->reqoff);
-	struct crypto_ablkcipher *enc = ctx->enc;
+	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
+						  ctx->reqoff);
+	struct crypto_skcipher *enc = ctx->enc;
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	struct scatterlist *src, *dst;
@@ -215,12 +218,12 @@ static int crypto_authenc_esn_encrypt(struct aead_request *req)
 		dst = scatterwalk_ffwd(areq_ctx->dst, req->dst, assoclen);
 	}
 
-	ablkcipher_request_set_tfm(abreq, enc);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_authenc_esn_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, src, dst, cryptlen, req->iv);
+	skcipher_request_set_tfm(skreq, enc);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      crypto_authenc_esn_encrypt_done, req);
+	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
 
-	err = crypto_ablkcipher_encrypt(abreq);
+	err = crypto_skcipher_encrypt(skreq);
 	if (err)
 		return err;
 
@@ -234,8 +237,8 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	unsigned int authsize = crypto_aead_authsize(authenc_esn);
 	struct authenc_esn_request_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(authenc_esn);
-	struct ablkcipher_request *abreq = (void *)(areq_ctx->tail
-						    + ctx->reqoff);
+	struct skcipher_request *skreq = (void *)(areq_ctx->tail +
+						  ctx->reqoff);
 	struct crypto_ahash *auth = ctx->auth;
 	u8 *ohash = PTR_ALIGN((u8 *)areq_ctx->tail,
 			      crypto_ahash_alignmask(auth) + 1);
@@ -256,12 +259,12 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	sg_init_table(areq_ctx->dst, 2);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
-	ablkcipher_request_set_tfm(abreq, ctx->enc);
-	ablkcipher_request_set_callback(abreq, flags,
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(abreq, dst, dst, cryptlen, req->iv);
+	skcipher_request_set_tfm(skreq, ctx->enc);
+	skcipher_request_set_callback(skreq, flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(skreq, dst, dst, cryptlen, req->iv);
 
-	return crypto_ablkcipher_decrypt(abreq);
+	return crypto_skcipher_decrypt(skreq);
 }
 
 static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
@@ -331,20 +334,20 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 	struct authenc_esn_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
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
@@ -361,15 +364,15 @@ static int crypto_authenc_esn_init_tfm(struct crypto_aead *tfm)
 		sizeof(struct authenc_esn_request_ctx) +
 		ctx->reqoff +
 		max_t(unsigned int,
-			crypto_ahash_reqsize(auth) +
-			sizeof(struct ahash_request),
-			sizeof(struct skcipher_givcrypt_request) +
-			crypto_ablkcipher_reqsize(enc)));
+		      crypto_ahash_reqsize(auth) +
+		      sizeof(struct ahash_request),
+		      sizeof(struct skcipher_request) +
+		      crypto_skcipher_reqsize(enc)));
 
 	return 0;
 
 err_free_skcipher:
-	crypto_free_ablkcipher(enc);
+	crypto_free_skcipher(enc);
 err_free_ahash:
 	crypto_free_ahash(auth);
 	return err;
@@ -380,8 +383,8 @@ static void crypto_authenc_esn_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_authenc_esn_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->auth);
-	crypto_free_ablkcipher(ctx->enc);
-	crypto_put_default_null_skcipher();
+	crypto_free_skcipher(ctx->enc);
+	crypto_put_default_null_skcipher2();
 }
 
 static void crypto_authenc_esn_free(struct aead_instance *inst)
@@ -400,7 +403,7 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
-	struct crypto_alg *enc;
+	struct skcipher_alg *enc;
 	struct authenc_esn_instance_ctx *ctx;
 	const char *enc_name;
 	int err;
@@ -438,35 +441,35 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
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
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_name,
-		     enc->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		     enc->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "authencesn(%s,%s)", auth_base->cra_driver_name,
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
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_authenc_esn_ctx);
 
-	inst->alg.ivsize = enc->cra_ablkcipher.ivsize;
+	inst->alg.ivsize = crypto_skcipher_alg_ivsize(enc);
 	inst->alg.maxauthsize = auth->digestsize;
 
 	inst->alg.init = crypto_authenc_esn_init_tfm;
