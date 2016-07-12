From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/30] crypto: ccm - Use skcipher
Date: Tue, 12 Jul 2016 13:17:38 +0800
Message-ID: <E1bMq4g-0007Ph-6T@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43615 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbcGLFRl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4g-0004Yk-Al
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:38 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts ccm to use the new skcipher interface as opposed
to ablkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ccm.c |   72 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index cc31ea4..006d857 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -28,7 +28,7 @@ struct ccm_instance_ctx {
 
 struct crypto_ccm_ctx {
 	struct crypto_cipher *cipher;
-	struct crypto_ablkcipher *ctr;
+	struct crypto_skcipher *ctr;
 };
 
 struct crypto_rfc4309_ctx {
@@ -50,7 +50,7 @@ struct crypto_ccm_req_priv_ctx {
 	u32 flags;
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
-	struct ablkcipher_request abreq;
+	struct skcipher_request skreq;
 };
 
 static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
@@ -83,15 +83,15 @@ static int crypto_ccm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_ablkcipher *ctr = ctx->ctr;
+	struct crypto_skcipher *ctr = ctx->ctr;
 	struct crypto_cipher *tfm = ctx->cipher;
 	int err = 0;
 
-	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
-				    CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(ctr, key, keylen);
-	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
+	crypto_skcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
+				       CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(ctr, key, keylen);
+	crypto_aead_set_flags(aead, crypto_skcipher_get_flags(ctr) &
 			      CRYPTO_TFM_RES_MASK);
 	if (err)
 		goto out;
@@ -347,7 +347,7 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
+	struct skcipher_request *skreq = &pctx->skreq;
 	struct scatterlist *dst;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *odata = pctx->odata;
@@ -366,11 +366,11 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
-	ablkcipher_request_set_tfm(abreq, ctx->ctr);
-	ablkcipher_request_set_callback(abreq, pctx->flags,
-					crypto_ccm_encrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, pctx->src, dst, cryptlen + 16, iv);
-	err = crypto_ablkcipher_encrypt(abreq);
+	skcipher_request_set_tfm(skreq, ctx->ctr);
+	skcipher_request_set_callback(skreq, pctx->flags,
+				      crypto_ccm_encrypt_done, req);
+	skcipher_request_set_crypt(skreq, pctx->src, dst, cryptlen + 16, iv);
+	err = crypto_skcipher_encrypt(skreq);
 	if (err)
 		return err;
 
@@ -407,7 +407,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
+	struct skcipher_request *skreq = &pctx->skreq;
 	struct scatterlist *dst;
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen;
@@ -429,11 +429,11 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
-	ablkcipher_request_set_tfm(abreq, ctx->ctr);
-	ablkcipher_request_set_callback(abreq, pctx->flags,
-					crypto_ccm_decrypt_done, req);
-	ablkcipher_request_set_crypt(abreq, pctx->src, dst, cryptlen + 16, iv);
-	err = crypto_ablkcipher_decrypt(abreq);
+	skcipher_request_set_tfm(skreq, ctx->ctr);
+	skcipher_request_set_callback(skreq, pctx->flags,
+				      crypto_ccm_decrypt_done, req);
+	skcipher_request_set_crypt(skreq, pctx->src, dst, cryptlen + 16, iv);
+	err = crypto_skcipher_decrypt(skreq);
 	if (err)
 		return err;
 
@@ -454,7 +454,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 	struct ccm_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_cipher *cipher;
-	struct crypto_ablkcipher *ctr;
+	struct crypto_skcipher *ctr;
 	unsigned long align;
 	int err;
 
@@ -462,7 +462,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctr = crypto_spawn_skcipher(&ictx->ctr);
+	ctr = crypto_spawn_skcipher2(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
 		goto err_free_cipher;
@@ -475,7 +475,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 	crypto_aead_set_reqsize(
 		tfm,
 		align + sizeof(struct crypto_ccm_req_priv_ctx) +
-		crypto_ablkcipher_reqsize(ctr));
+		crypto_skcipher_reqsize(ctr));
 
 	return 0;
 
@@ -489,7 +489,7 @@ static void crypto_ccm_exit_tfm(struct crypto_aead *tfm)
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_cipher(ctx->cipher);
-	crypto_free_ablkcipher(ctx->ctr);
+	crypto_free_skcipher(ctx->ctr);
 }
 
 static void crypto_ccm_free(struct aead_instance *inst)
@@ -509,7 +509,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 {
 	struct crypto_attr_type *algt;
 	struct aead_instance *inst;
-	struct crypto_alg *ctr;
+	struct skcipher_alg *ctr;
 	struct crypto_alg *cipher;
 	struct ccm_instance_ctx *ictx;
 	int err;
@@ -544,39 +544,40 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	crypto_set_skcipher_spawn(&ictx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ictx->ctr, ctr_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher2(&ictx->ctr, ctr_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
 		goto err_drop_cipher;
 
-	ctr = crypto_skcipher_spawn_alg(&ictx->ctr);
+	ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
 
 	/* Not a stream cipher? */
 	err = -EINVAL;
-	if (ctr->cra_blocksize != 1)
+	if (ctr->base.cra_blocksize != 1)
 		goto err_drop_ctr;
 
 	/* We want the real thing! */
-	if (ctr->cra_ablkcipher.ivsize != 16)
+	if (crypto_skcipher_alg_ivsize(ctr) != 16)
 		goto err_drop_ctr;
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "ccm_base(%s,%s)", ctr->cra_driver_name,
+		     "ccm_base(%s,%s)", ctr->base.cra_driver_name,
 		     cipher->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_ctr;
 
 	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
 
-	inst->alg.base.cra_flags = ctr->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (cipher->cra_priority +
-				       ctr->cra_priority) / 2;
+				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = cipher->cra_alignmask |
-				       ctr->cra_alignmask |
+				       ctr->base.cra_alignmask |
 				       (__alignof__(u32) - 1);
 	inst->alg.ivsize = 16;
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(ctr);
 	inst->alg.maxauthsize = 16;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_ccm_ctx);
 	inst->alg.init = crypto_ccm_init_tfm;
@@ -863,6 +864,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
 	inst->alg.ivsize = 8;
+	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
 	inst->alg.maxauthsize = 16;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
