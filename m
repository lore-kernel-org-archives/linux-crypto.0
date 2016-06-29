From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/28] crypto: ctr - Use skcipher in rfc3686
Date: Wed, 29 Jun 2016 18:03:53 +0800
Message-ID: <E1bICLZ-0006sr-Tk@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48710 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbcF2KD5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:03:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLa-0005Gc-1C
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc3686 to use the new skcipher interface as
opposed to ablkcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ctr.c |  182 ++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 93 insertions(+), 89 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index 2386f73..4b4b7ed 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -26,13 +26,13 @@ struct crypto_ctr_ctx {
 };
 
 struct crypto_rfc3686_ctx {
-	struct crypto_ablkcipher *child;
+	struct crypto_skcipher *child;
 	u8 nonce[CTR_RFC3686_NONCE_SIZE];
 };
 
 struct crypto_rfc3686_req_ctx {
 	u8 iv[CTR_RFC3686_BLOCK_SIZE];
-	struct ablkcipher_request subreq CRYPTO_MINALIGN_ATTR;
+	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
 };
 
 static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
@@ -249,11 +249,11 @@ static struct crypto_template crypto_ctr_tmpl = {
 	.module = THIS_MODULE,
 };
 
-static int crypto_rfc3686_setkey(struct crypto_ablkcipher *parent,
+static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
 				 const u8 *key, unsigned int keylen)
 {
-	struct crypto_rfc3686_ctx *ctx = crypto_ablkcipher_ctx(parent);
-	struct crypto_ablkcipher *child = ctx->child;
+	struct crypto_rfc3686_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
 	int err;
 
 	/* the nonce is stored in bytes at end of key */
@@ -265,173 +265,177 @@ static int crypto_rfc3686_setkey(struct crypto_ablkcipher *parent,
 
 	keylen -= CTR_RFC3686_NONCE_SIZE;
 
-	crypto_ablkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_ablkcipher_set_flags(child, crypto_ablkcipher_get_flags(parent) &
-				    CRYPTO_TFM_REQ_MASK);
-	err = crypto_ablkcipher_setkey(child, key, keylen);
-	crypto_ablkcipher_set_flags(parent, crypto_ablkcipher_get_flags(child) &
-				    CRYPTO_TFM_RES_MASK);
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
 
 	return err;
 }
 
-static int crypto_rfc3686_crypt(struct ablkcipher_request *req)
+static int crypto_rfc3686_crypt(struct skcipher_request *req)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct crypto_rfc3686_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_ablkcipher *child = ctx->child;
-	unsigned long align = crypto_ablkcipher_alignmask(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_rfc3686_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	unsigned long align = crypto_skcipher_alignmask(tfm);
 	struct crypto_rfc3686_req_ctx *rctx =
-		(void *)PTR_ALIGN((u8 *)ablkcipher_request_ctx(req), align + 1);
-	struct ablkcipher_request *subreq = &rctx->subreq;
+		(void *)PTR_ALIGN((u8 *)skcipher_request_ctx(req), align + 1);
+	struct skcipher_request *subreq = &rctx->subreq;
 	u8 *iv = rctx->iv;
 
 	/* set up counter block */
 	memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
-	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->info, CTR_RFC3686_IV_SIZE);
+	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
 
 	/* initialize counter portion of counter block */
 	*(__be32 *)(iv + CTR_RFC3686_NONCE_SIZE + CTR_RFC3686_IV_SIZE) =
 		cpu_to_be32(1);
 
-	ablkcipher_request_set_tfm(subreq, child);
-	ablkcipher_request_set_callback(subreq, req->base.flags,
-					req->base.complete, req->base.data);
-	ablkcipher_request_set_crypt(subreq, req->src, req->dst, req->nbytes,
-				     iv);
+	skcipher_request_set_tfm(subreq, child);
+	skcipher_request_set_callback(subreq, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->cryptlen, iv);
 
-	return crypto_ablkcipher_encrypt(subreq);
+	return crypto_skcipher_encrypt(subreq);
 }
 
-static int crypto_rfc3686_init_tfm(struct crypto_tfm *tfm)
+static int crypto_rfc3686_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_skcipher_spawn *spawn = crypto_instance_ctx(inst);
-	struct crypto_rfc3686_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_ablkcipher *cipher;
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_rfc3686_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
 	unsigned long align;
+	unsigned int reqsize;
 
-	cipher = crypto_spawn_skcipher(spawn);
+	cipher = crypto_spawn_skcipher2(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
 
-	align = crypto_tfm_alg_alignmask(tfm);
+	align = crypto_skcipher_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
-	tfm->crt_ablkcipher.reqsize = align +
-		sizeof(struct crypto_rfc3686_req_ctx) +
-		crypto_ablkcipher_reqsize(cipher);
+	reqsize = align + sizeof(struct crypto_rfc3686_req_ctx) +
+		  crypto_skcipher_reqsize(cipher);
+	crypto_skcipher_set_reqsize(tfm, reqsize);
 
 	return 0;
 }
 
-static void crypto_rfc3686_exit_tfm(struct crypto_tfm *tfm)
+static void crypto_rfc3686_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct crypto_rfc3686_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_rfc3686_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
+}
 
-	crypto_free_ablkcipher(ctx->child);
+static void crypto_rfc3686_free(struct skcipher_instance *inst)
+{
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(spawn);
+	kfree(inst);
 }
 
-static struct crypto_instance *crypto_rfc3686_alloc(struct rtattr **tb)
+static int crypto_rfc3686_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
+	struct skcipher_instance *inst;
+	struct skcipher_alg *alg;
 	struct crypto_skcipher_spawn *spawn;
 	const char *cipher_name;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_CAST(algt);
+		return PTR_ERR(algt);
 
-	if ((algt->type ^ CRYPTO_ALG_TYPE_BLKCIPHER) & algt->mask)
-		return ERR_PTR(-EINVAL);
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
+		return -EINVAL;
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
-		return ERR_CAST(cipher_name);
+		return PTR_ERR(cipher_name);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
-	spawn = crypto_instance_ctx(inst);
+	spawn = skcipher_instance_ctx(inst);
 
-	crypto_set_skcipher_spawn(spawn, inst);
-	err = crypto_grab_skcipher(spawn, cipher_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher2(spawn, cipher_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
 	if (err)
 		goto err_free_inst;
 
-	alg = crypto_skcipher_spawn_alg(spawn);
+	alg = crypto_spawn_skcipher_alg(spawn);
 
 	/* We only support 16-byte blocks. */
 	err = -EINVAL;
-	if (alg->cra_ablkcipher.ivsize != CTR_RFC3686_BLOCK_SIZE)
+	if (crypto_skcipher_alg_ivsize(alg) != CTR_RFC3686_BLOCK_SIZE)
 		goto err_drop_spawn;
 
 	/* Not a stream cipher? */
-	if (alg->cra_blocksize != 1)
+	if (alg->base.cra_blocksize != 1)
 		goto err_drop_spawn;
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME, "rfc3686(%s)",
-		     alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc3686(%s)", alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_spawn;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "rfc3686(%s)", alg->cra_driver_name) >=
-			CRYPTO_MAX_ALG_NAME)
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "rfc3686(%s)", alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
 		goto err_drop_spawn;
 
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = 1;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-			      (alg->cra_flags & CRYPTO_ALG_ASYNC);
-	inst->alg.cra_type = &crypto_ablkcipher_type;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 
-	inst->alg.cra_ablkcipher.ivsize = CTR_RFC3686_IV_SIZE;
-	inst->alg.cra_ablkcipher.min_keysize =
-		alg->cra_ablkcipher.min_keysize + CTR_RFC3686_NONCE_SIZE;
-	inst->alg.cra_ablkcipher.max_keysize =
-		alg->cra_ablkcipher.max_keysize + CTR_RFC3686_NONCE_SIZE;
+	inst->alg.ivsize = CTR_RFC3686_IV_SIZE;
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
+				CTR_RFC3686_NONCE_SIZE;
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
+				CTR_RFC3686_NONCE_SIZE;
 
-	inst->alg.cra_ablkcipher.geniv = "seqiv";
+	inst->alg.setkey = crypto_rfc3686_setkey;
+	inst->alg.encrypt = crypto_rfc3686_crypt;
+	inst->alg.decrypt = crypto_rfc3686_crypt;
 
-	inst->alg.cra_ablkcipher.setkey = crypto_rfc3686_setkey;
-	inst->alg.cra_ablkcipher.encrypt = crypto_rfc3686_crypt;
-	inst->alg.cra_ablkcipher.decrypt = crypto_rfc3686_crypt;
+	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc3686_ctx);
 
-	inst->alg.cra_ctxsize = sizeof(struct crypto_rfc3686_ctx);
+	inst->alg.init = crypto_rfc3686_init_tfm;
+	inst->alg.exit = crypto_rfc3686_exit_tfm;
 
-	inst->alg.cra_init = crypto_rfc3686_init_tfm;
-	inst->alg.cra_exit = crypto_rfc3686_exit_tfm;
+	inst->free = crypto_rfc3686_free;
 
-	return inst;
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_spawn;
+
+out:
+	return err;
 
 err_drop_spawn:
 	crypto_drop_skcipher(spawn);
 err_free_inst:
 	kfree(inst);
-	return ERR_PTR(err);
-}
-
-static void crypto_rfc3686_free(struct crypto_instance *inst)
-{
-	struct crypto_skcipher_spawn *spawn = crypto_instance_ctx(inst);
-
-	crypto_drop_skcipher(spawn);
-	kfree(inst);
+	goto out;
 }
 
 static struct crypto_template crypto_rfc3686_tmpl = {
 	.name = "rfc3686",
-	.alloc = crypto_rfc3686_alloc,
-	.free = crypto_rfc3686_free,
+	.create = crypto_rfc3686_create,
 	.module = THIS_MODULE,
 };
 
