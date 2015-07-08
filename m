From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/14] crypto: gcm - Use new IV convention
Date: Thu, 09 Jul 2015 07:17:30 +0800
Message-ID: <E1ZCyao-0007aL-4h@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56788 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbGHXRf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:35 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyaq-0005HI-0h
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:32 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc4106 to the new calling convention where
the IV is now part of the AD and needs to be skipped.  This patch
also makes use of the new type-safe way of freeing instances.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |  114 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 77 insertions(+), 37 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 7d32d47..0c9e33b 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -38,6 +38,12 @@ struct crypto_rfc4106_ctx {
 	u8 nonce[4];
 };
 
+struct crypto_rfc4106_req_ctx {
+	struct scatterlist src[3];
+	struct scatterlist dst[3];
+	struct aead_request subreq;
+};
+
 struct crypto_rfc4543_instance_ctx {
 	struct crypto_aead_spawn aead;
 };
@@ -601,6 +607,15 @@ static void crypto_gcm_exit_tfm(struct crypto_aead *tfm)
 	crypto_free_ablkcipher(ctx->ctr);
 }
 
+static void crypto_gcm_free(struct aead_instance *inst)
+{
+	struct gcm_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->ctr);
+	crypto_drop_ahash(&ctx->ghash);
+	kfree(inst);
+}
+
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
 				    const char *full_name,
@@ -619,7 +634,8 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
 		return -EINVAL;
 
 	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
@@ -674,6 +690,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	inst->alg.base.cra_flags = (ghash->base.cra_flags | ctr->cra_flags) &
 				   CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
 				       ctr->cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
@@ -689,6 +706,8 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	inst->alg.encrypt = crypto_gcm_encrypt;
 	inst->alg.decrypt = crypto_gcm_decrypt;
 
+	inst->free = crypto_gcm_free;
+
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto out_put_ctr;
@@ -728,19 +747,9 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 					ctr_name, "ghash");
 }
 
-static void crypto_gcm_free(struct crypto_instance *inst)
-{
-	struct gcm_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_skcipher(&ctx->ctr);
-	crypto_drop_ahash(&ctx->ghash);
-	kfree(aead_instance(inst));
-}
-
 static struct crypto_template crypto_gcm_tmpl = {
 	.name = "gcm",
 	.create = crypto_gcm_create,
-	.free = crypto_gcm_free,
 	.module = THIS_MODULE,
 };
 
@@ -770,7 +779,6 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 static struct crypto_template crypto_gcm_base_tmpl = {
 	.name = "gcm_base",
 	.create = crypto_gcm_base_create,
-	.free = crypto_gcm_free,
 	.module = THIS_MODULE,
 };
 
@@ -816,27 +824,50 @@ static int crypto_rfc4106_setauthsize(struct crypto_aead *parent,
 
 static struct aead_request *crypto_rfc4106_crypt(struct aead_request *req)
 {
-	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_rfc4106_req_ctx *rctx = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_rfc4106_ctx *ctx = crypto_aead_ctx(aead);
+	struct aead_request *subreq = &rctx->subreq;
 	struct crypto_aead *child = ctx->child;
+	struct scatterlist *sg;
 	u8 *iv = PTR_ALIGN((u8 *)(subreq + 1) + crypto_aead_reqsize(child),
 			   crypto_aead_alignmask(child) + 1);
 
+	scatterwalk_map_and_copy(iv + 12, req->src, 0, req->assoclen - 8, 0);
+
 	memcpy(iv, ctx->nonce, 4);
 	memcpy(iv + 4, req->iv, 8);
 
+	sg_init_table(rctx->src, 3);
+	sg_set_buf(rctx->src, iv + 12, req->assoclen - 8);
+	sg = scatterwalk_ffwd(rctx->src + 1, req->src, req->assoclen);
+	if (sg != rctx->src + 1)
+		sg_chain(rctx->src, 2, sg);
+
+	if (req->src != req->dst) {
+		sg_init_table(rctx->dst, 3);
+		sg_set_buf(rctx->dst, iv + 12, req->assoclen - 8);
+		sg = scatterwalk_ffwd(rctx->dst + 1, req->dst, req->assoclen);
+		if (sg != rctx->dst + 1)
+			sg_chain(rctx->dst, 2, sg);
+	}
+
 	aead_request_set_tfm(subreq, child);
 	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
 				  req->base.data);
-	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, iv);
-	aead_request_set_ad(subreq, req->assoclen);
+	aead_request_set_crypt(subreq, rctx->src,
+			       req->src == req->dst ? rctx->src : rctx->dst,
+			       req->cryptlen, iv);
+	aead_request_set_ad(subreq, req->assoclen - 8);
 
 	return subreq;
 }
 
 static int crypto_rfc4106_encrypt(struct aead_request *req)
 {
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
 	req = crypto_rfc4106_crypt(req);
 
 	return crypto_aead_encrypt(req);
@@ -844,6 +875,9 @@ static int crypto_rfc4106_encrypt(struct aead_request *req)
 
 static int crypto_rfc4106_decrypt(struct aead_request *req)
 {
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
 	req = crypto_rfc4106_crypt(req);
 
 	return crypto_aead_decrypt(req);
@@ -867,9 +901,9 @@ static int crypto_rfc4106_init_tfm(struct crypto_aead *tfm)
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	crypto_aead_set_reqsize(
 		tfm,
-		sizeof(struct aead_request) +
+		sizeof(struct crypto_rfc4106_req_ctx) +
 		ALIGN(crypto_aead_reqsize(aead), crypto_tfm_ctx_alignment()) +
-		align + 12);
+		align + 24);
 
 	return 0;
 }
@@ -881,6 +915,12 @@ static void crypto_rfc4106_exit_tfm(struct crypto_aead *tfm)
 	crypto_free_aead(ctx->child);
 }
 
+static void crypto_rfc4106_free(struct aead_instance *inst)
+{
+	crypto_drop_aead(aead_instance_ctx(inst));
+	kfree(inst);
+}
+
 static int crypto_rfc4106_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
@@ -895,7 +935,8 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
 		return -EINVAL;
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
@@ -934,7 +975,8 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
 
-	inst->alg.base.cra_flags |= alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -952,6 +994,8 @@ static int crypto_rfc4106_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = crypto_rfc4106_encrypt;
 	inst->alg.decrypt = crypto_rfc4106_decrypt;
 
+	inst->free = crypto_rfc4106_free;
+
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto out_drop_alg;
@@ -966,16 +1010,9 @@ out_free_inst:
 	goto out;
 }
 
-static void crypto_rfc4106_free(struct crypto_instance *inst)
-{
-	crypto_drop_aead(crypto_instance_ctx(inst));
-	kfree(aead_instance(inst));
-}
-
 static struct crypto_template crypto_rfc4106_tmpl = {
 	.name = "rfc4106",
 	.create = crypto_rfc4106_create,
-	.free = crypto_rfc4106_free,
 	.module = THIS_MODULE,
 };
 
@@ -1114,6 +1151,15 @@ static void crypto_rfc4543_exit_tfm(struct crypto_aead *tfm)
 	crypto_put_default_null_skcipher();
 }
 
+static void crypto_rfc4543_free(struct aead_instance *inst)
+{
+	struct crypto_rfc4543_instance_ctx *ctx = aead_instance_ctx(inst);
+
+	crypto_drop_aead(&ctx->aead);
+
+	kfree(inst);
+}
+
 static int crypto_rfc4543_create(struct crypto_template *tmpl,
 				struct rtattr **tb)
 {
@@ -1129,7 +1175,8 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_AEAD_NEW)) &
+	    algt->mask)
 		return -EINVAL;
 
 	ccm_name = crypto_attr_alg_name(tb[1]);
@@ -1170,6 +1217,7 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 		goto out_drop_alg;
 
 	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags |= CRYPTO_ALG_AEAD_NEW;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
@@ -1187,6 +1235,8 @@ static int crypto_rfc4543_create(struct crypto_template *tmpl,
 	inst->alg.encrypt = crypto_rfc4543_encrypt;
 	inst->alg.decrypt = crypto_rfc4543_decrypt;
 
+	inst->free = crypto_rfc4543_free,
+
 	err = aead_register_instance(tmpl, inst);
 	if (err)
 		goto out_drop_alg;
@@ -1201,19 +1251,9 @@ out_free_inst:
 	goto out;
 }
 
-static void crypto_rfc4543_free(struct crypto_instance *inst)
-{
-	struct crypto_rfc4543_instance_ctx *ctx = crypto_instance_ctx(inst);
-
-	crypto_drop_aead(&ctx->aead);
-
-	kfree(aead_instance(inst));
-}
-
 static struct crypto_template crypto_rfc4543_tmpl = {
 	.name = "rfc4543",
 	.create = crypto_rfc4543_create,
-	.free = crypto_rfc4543_free,
 	.module = THIS_MODULE,
 };
 
