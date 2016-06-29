From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/28] crypto: gcm - Use skcipher
Date: Wed, 29 Jun 2016 18:03:56 +0800
Message-ID: <E1bICLc-0006tP-2m@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39660 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbcF2KEA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLc-0005HM-6o
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:56 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts gcm to use the new skcipher interface as opposed
to ablkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |  108 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 55 insertions(+), 53 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index d9ea5f9..909eb35 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -29,7 +29,7 @@ struct gcm_instance_ctx {
 };
 
 struct crypto_gcm_ctx {
-	struct crypto_ablkcipher *ctr;
+	struct crypto_skcipher *ctr;
 	struct crypto_ahash *ghash;
 };
 
@@ -50,7 +50,7 @@ struct crypto_rfc4543_instance_ctx {
 
 struct crypto_rfc4543_ctx {
 	struct crypto_aead *child;
-	struct crypto_blkcipher *null;
+	struct crypto_skcipher *null;
 	u8 nonce[4];
 };
 
@@ -74,7 +74,7 @@ struct crypto_gcm_req_priv_ctx {
 	struct crypto_gcm_ghash_ctx ghash_ctx;
 	union {
 		struct ahash_request ahreq;
-		struct ablkcipher_request abreq;
+		struct skcipher_request skreq;
 	} u;
 };
 
@@ -114,7 +114,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 {
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_ahash *ghash = ctx->ghash;
-	struct crypto_ablkcipher *ctr = ctx->ctr;
+	struct crypto_skcipher *ctr = ctx->ctr;
 	struct {
 		be128 hash;
 		u8 iv[8];
@@ -122,35 +122,35 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 		struct crypto_gcm_setkey_result result;
 
 		struct scatterlist sg[1];
-		struct ablkcipher_request req;
+		struct skcipher_request req;
 	} *data;
 	int err;
 
-	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
-					 CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(ctr, key, keylen);
-	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
+	crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
+				       CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(ctr, key, keylen);
+	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
 				    CRYPTO_TFM_RES_MASK);
 	if (err)
 		return err;
 
-	data = kzalloc(sizeof(*data) + crypto_ablkcipher_reqsize(ctr),
+	data = kzalloc(sizeof(*data) + crypto_skcipher_reqsize(ctr),
 		       GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
 	init_completion(&data->result.completion);
 	sg_init_one(data->sg, &data->hash, sizeof(data->hash));
-	ablkcipher_request_set_tfm(&data->req, ctr);
-	ablkcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
-						    CRYPTO_TFM_REQ_MAY_BACKLOG,
-					crypto_gcm_setkey_done,
-					&data->result);
-	ablkcipher_request_set_crypt(&data->req, data->sg, data->sg,
-				     sizeof(data->hash), data->iv);
-
-	err = crypto_ablkcipher_encrypt(&data->req);
+	skcipher_request_set_tfm(&data->req, ctr);
+	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
+						  CRYPTO_TFM_REQ_MAY_BACKLOG,
+				      crypto_gcm_setkey_done,
+				      &data->result);
+	skcipher_request_set_crypt(&data->req, data->sg, data->sg,
+				   sizeof(data->hash), data->iv);
+
+	err = crypto_skcipher_encrypt(&data->req);
 	if (err == -EINPROGRESS || err == -EBUSY) {
 		err = wait_for_completion_interruptible(
 			&data->result.completion);
@@ -223,13 +223,13 @@ static void crypto_gcm_init_crypt(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *ablk_req = &pctx->u.abreq;
+	struct skcipher_request *skreq = &pctx->u.skreq;
 	struct scatterlist *dst;
 
 	dst = req->src == req->dst ? pctx->src : pctx->dst;
 
-	ablkcipher_request_set_tfm(ablk_req, ctx->ctr);
-	ablkcipher_request_set_crypt(ablk_req, pctx->src, dst,
+	skcipher_request_set_tfm(skreq, ctx->ctr);
+	skcipher_request_set_crypt(skreq, pctx->src, dst,
 				     cryptlen + sizeof(pctx->auth_tag),
 				     pctx->iv);
 }
@@ -494,14 +494,14 @@ out:
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->u.abreq;
+	struct skcipher_request *skreq = &pctx->u.skreq;
 	u32 flags = aead_request_flags(req);
 
 	crypto_gcm_init_common(req);
 	crypto_gcm_init_crypt(req, req->cryptlen);
-	ablkcipher_request_set_callback(abreq, flags, gcm_encrypt_done, req);
+	skcipher_request_set_callback(skreq, flags, gcm_encrypt_done, req);
 
-	return crypto_ablkcipher_encrypt(abreq) ?:
+	return crypto_skcipher_encrypt(skreq) ?:
 	       gcm_encrypt_continue(req, flags);
 }
 
@@ -533,12 +533,12 @@ static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
 static int gcm_dec_hash_continue(struct aead_request *req, u32 flags)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->u.abreq;
+	struct skcipher_request *skreq = &pctx->u.skreq;
 	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
 	crypto_gcm_init_crypt(req, gctx->cryptlen);
-	ablkcipher_request_set_callback(abreq, flags, gcm_decrypt_done, req);
-	return crypto_ablkcipher_decrypt(abreq) ?: crypto_gcm_verify(req);
+	skcipher_request_set_callback(skreq, flags, gcm_decrypt_done, req);
+	return crypto_skcipher_decrypt(skreq) ?: crypto_gcm_verify(req);
 }
 
 static int crypto_gcm_decrypt(struct aead_request *req)
@@ -566,7 +566,7 @@ static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct gcm_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct crypto_ablkcipher *ctr;
+	struct crypto_skcipher *ctr;
 	struct crypto_ahash *ghash;
 	unsigned long align;
 	int err;
@@ -575,7 +575,7 @@ static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(ghash))
 		return PTR_ERR(ghash);
 
-	ctr = crypto_spawn_skcipher(&ictx->ctr);
+	ctr = crypto_spawn_skcipher2(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
 		goto err_free_hash;
@@ -587,8 +587,8 @@ static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	crypto_aead_set_reqsize(tfm,
 		align + offsetof(struct crypto_gcm_req_priv_ctx, u) +
-		max(sizeof(struct ablkcipher_request) +
-		    crypto_ablkcipher_reqsize(ctr),
+		max(sizeof(struct skcipher_request) +
+		    crypto_skcipher_reqsize(ctr),
 		    sizeof(struct ahash_request) +
 		    crypto_ahash_reqsize(ghash)));
 
@@ -604,7 +604,7 @@ static void crypto_gcm_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_ahash(ctx->ghash);
-	crypto_free_ablkcipher(ctx->ctr);
+	crypto_free_skcipher(ctx->ctr);
 }
 
 static void crypto_gcm_free(struct aead_instance *inst)
@@ -624,7 +624,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 {
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
-	struct crypto_alg *ctr;
+	struct skcipher_alg *ctr;
 	struct crypto_alg *ghash_alg;
 	struct hash_alg_common *ghash;
 	struct gcm_instance_ctx *ctx;
@@ -663,39 +663,39 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher2(&ctx->ctr, ctr_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
 		goto err_drop_ghash;
 
-	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
+	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
 	/* We only support 16-byte blocks. */
-	if (ctr->cra_ablkcipher.ivsize != 16)
+	if (crypto_skcipher_alg_ivsize(ctr) != 16)
 		goto out_put_ctr;
 
 	/* Not a stream cipher? */
 	err = -EINVAL;
-	if (ctr->cra_blocksize != 1)
+	if (ctr->base.cra_blocksize != 1)
 		goto out_put_ctr;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm_base(%s,%s)", ctr->cra_driver_name,
+		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
 		     ghash_alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
 	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
 
-	inst->alg.base.cra_flags = (ghash->base.cra_flags | ctr->cra_flags) &
-				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = (ghash->base.cra_flags |
+				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
-				       ctr->cra_priority) / 2;
+				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = ghash->base.cra_alignmask |
-				       ctr->cra_alignmask;
+				       ctr->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.ivsize = 12;
 	inst->alg.maxauthsize = 16;
@@ -1086,11 +1086,13 @@ static int crypto_rfc4543_copy_src_to_dst(struct aead_request *req, bool enc)
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int nbytes = req->assoclen + req->cryptlen -
 			      (enc ? 0 : authsize);
-	struct blkcipher_desc desc = {
-		.tfm = ctx->null,
-	};
+	SKCIPHER_REQUEST_ON_STACK(nreq, ctx->null);
+
+	skcipher_request_set_tfm(nreq, ctx->null);
+	skcipher_request_set_callback(nreq, req->base.flags, NULL, NULL);
+	skcipher_request_set_crypt(nreq, req->src, req->dst, nbytes, NULL);
 
-	return crypto_blkcipher_encrypt(&desc, req->dst, req->src, nbytes);
+	return crypto_skcipher_encrypt(nreq);
 }
 
 static int crypto_rfc4543_encrypt(struct aead_request *req)
@@ -1110,7 +1112,7 @@ static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 	struct crypto_aead_spawn *spawn = &ictx->aead;
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_aead *aead;
-	struct crypto_blkcipher *null;
+	struct crypto_skcipher *null;
 	unsigned long align;
 	int err = 0;
 
@@ -1118,7 +1120,7 @@ static int crypto_rfc4543_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(aead))
 		return PTR_ERR(aead);
 
-	null = crypto_get_default_null_skcipher();
+	null = crypto_get_default_null_skcipher2();
 	err = PTR_ERR(null);
 	if (IS_ERR(null))
 		goto err_free_aead;
@@ -1146,7 +1148,7 @@ static void crypto_rfc4543_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_rfc4543_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher();
+	crypto_put_default_null_skcipher2();
 }
 
 static void crypto_rfc4543_free(struct aead_instance *inst)
