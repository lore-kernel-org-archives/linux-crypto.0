From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/35] crypto: cryptd - Use shash algorithms
Date: Wed, 15 Jul 2009 15:16:11 +0800
Message-ID: <E1MQyip-00050F-TR@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53636 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbZGOHQO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiq-0004s7-8j
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:12 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: cryptd - Use shash algorithms

This patch changes cryptd to use shash algorithms instead of the
legacy hash interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |  164 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 84 insertions(+), 80 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index ae5fa99..ef5720c 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -39,6 +39,11 @@ struct cryptd_instance_ctx {
 	struct cryptd_queue *queue;
 };
 
+struct hashd_instance_ctx {
+	struct crypto_shash_spawn spawn;
+	struct cryptd_queue *queue;
+};
+
 struct cryptd_blkcipher_ctx {
 	struct crypto_blkcipher *child;
 };
@@ -48,11 +53,12 @@ struct cryptd_blkcipher_request_ctx {
 };
 
 struct cryptd_hash_ctx {
-	struct crypto_hash *child;
+	struct crypto_shash *child;
 };
 
 struct cryptd_hash_request_ctx {
 	crypto_completion_t complete;
+	struct shash_desc desc;
 };
 
 static void cryptd_queue_worker(struct work_struct *work);
@@ -250,13 +256,12 @@ static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 }
 
 static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *alg,
-						     struct cryptd_queue *queue)
+						     unsigned int tail)
 {
 	struct crypto_instance *inst;
-	struct cryptd_instance_ctx *ctx;
 	int err;
 
-	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	inst = kzalloc(sizeof(*inst) + tail, GFP_KERNEL);
 	if (!inst) {
 		inst = ERR_PTR(-ENOMEM);
 		goto out;
@@ -267,14 +272,6 @@ static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *alg,
 		     "cryptd(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto out_free_inst;
 
-	ctx = crypto_instance_ctx(inst);
-	err = crypto_init_spawn(&ctx->spawn, alg, inst,
-				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
-	if (err)
-		goto out_free_inst;
-
-	ctx->queue = queue;
-
 	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
 
 	inst->alg.cra_priority = alg->cra_priority + 50;
@@ -293,18 +290,28 @@ out_free_inst:
 static struct crypto_instance *cryptd_alloc_blkcipher(
 	struct rtattr **tb, struct cryptd_queue *queue)
 {
+	struct cryptd_instance_ctx *ctx;
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	int err;
 
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
-	inst = cryptd_alloc_instance(alg, queue);
+	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
+	ctx = crypto_instance_ctx(inst);
+	ctx->queue = queue;
+
+	err = crypto_init_spawn(&ctx->spawn, alg, inst,
+				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	if (err)
+		goto out_free_inst;
+
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_type = &crypto_ablkcipher_type;
 
@@ -326,23 +333,28 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 out_put_alg:
 	crypto_mod_put(alg);
 	return inst;
+
+out_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out_put_alg;
 }
 
 static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_spawn *spawn = &ictx->spawn;
+	struct hashd_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_shash_spawn *spawn = &ictx->spawn;
 	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_hash *cipher;
+	struct crypto_shash *hash;
 
-	cipher = crypto_spawn_hash(spawn);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
+	hash = crypto_spawn_shash(spawn);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
 
-	ctx->child = cipher;
-	tfm->crt_ahash.reqsize =
-		sizeof(struct cryptd_hash_request_ctx);
+	ctx->child = hash;
+	tfm->crt_ahash.reqsize = sizeof(struct cryptd_hash_request_ctx) +
+				 crypto_shash_descsize(hash);
 	return 0;
 }
 
@@ -350,22 +362,22 @@ static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_hash(ctx->child);
+	crypto_free_shash(ctx->child);
 }
 
 static int cryptd_hash_setkey(struct crypto_ahash *parent,
 				   const u8 *key, unsigned int keylen)
 {
 	struct cryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
-	struct crypto_hash     *child = ctx->child;
+	struct crypto_shash *child = ctx->child;
 	int err;
 
-	crypto_hash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_hash_set_flags(child, crypto_ahash_get_flags(parent) &
-					  CRYPTO_TFM_REQ_MASK);
-	err = crypto_hash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(parent, crypto_hash_get_flags(child) &
-					    CRYPTO_TFM_RES_MASK);
+	crypto_shash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_shash_set_flags(child, crypto_ahash_get_flags(parent) &
+				      CRYPTO_TFM_REQ_MASK);
+	err = crypto_shash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_shash_get_flags(child) &
+				       CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
@@ -385,21 +397,19 @@ static int cryptd_hash_enqueue(struct ahash_request *req,
 
 static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
-	struct ahash_request    *req = ahash_request_cast(req_async);
-	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
-
-	rctx = ahash_request_ctx(req);
+	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_shash *child = ctx->child;
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct shash_desc *desc = &rctx->desc;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->tfm = child;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = crypto_hash_crt(child)->init(&desc);
+	err = crypto_shash_init(desc);
 
 	req->base.complete = rctx->complete;
 
@@ -416,23 +426,15 @@ static int cryptd_hash_init_enqueue(struct ahash_request *req)
 
 static void cryptd_hash_update(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
-	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct ahash_request *req = ahash_request_cast(req_async);
 	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
 
 	rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = crypto_hash_crt(child)->update(&desc,
-						req->src,
-						req->nbytes);
+	err = shash_ahash_update(req, &rctx->desc);
 
 	req->base.complete = rctx->complete;
 
@@ -449,21 +451,13 @@ static int cryptd_hash_update_enqueue(struct ahash_request *req)
 
 static void cryptd_hash_final(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
-	struct ahash_request    *req = ahash_request_cast(req_async);
-	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
-
-	rctx = ahash_request_ctx(req);
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = crypto_hash_crt(child)->final(&desc, req->result);
+	err = crypto_shash_final(&rctx->desc, req->result);
 
 	req->base.complete = rctx->complete;
 
@@ -480,24 +474,19 @@ static int cryptd_hash_final_enqueue(struct ahash_request *req)
 
 static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
-	struct ahash_request    *req = ahash_request_cast(req_async);
-	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
-
-	rctx = ahash_request_ctx(req);
+	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_shash *child = ctx->child;
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct shash_desc *desc = &rctx->desc;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc->tfm = child;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = crypto_hash_crt(child)->digest(&desc,
-						req->src,
-						req->nbytes,
-						req->result);
+	err = shash_ahash_digest(req, desc);
 
 	req->base.complete = rctx->complete;
 
@@ -515,22 +504,32 @@ static int cryptd_hash_digest_enqueue(struct ahash_request *req)
 static struct crypto_instance *cryptd_alloc_hash(
 	struct rtattr **tb, struct cryptd_queue *queue)
 {
+	struct hashd_instance_ctx *ctx;
 	struct crypto_instance *inst;
+	struct shash_alg *salg;
 	struct crypto_alg *alg;
+	int err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_HASH_MASK);
-	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+	salg = shash_attr_alg(tb[1], 0, 0);
+	if (IS_ERR(salg))
+		return ERR_CAST(salg);
 
-	inst = cryptd_alloc_instance(alg, queue);
+	alg = &salg->base;
+	inst = cryptd_alloc_instance(alg, sizeof(*ctx));
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
+	ctx = crypto_instance_ctx(inst);
+	ctx->queue = queue;
+
+	err = crypto_init_shash_spawn(&ctx->spawn, salg, inst);
+	if (err)
+		goto out_free_inst;
+
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_type = &crypto_ahash_type;
 
-	inst->alg.cra_ahash.digestsize = alg->cra_hash.digestsize;
+	inst->alg.cra_ahash.digestsize = salg->digestsize;
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
 	inst->alg.cra_init = cryptd_hash_init_tfm;
@@ -545,6 +544,11 @@ static struct crypto_instance *cryptd_alloc_hash(
 out_put_alg:
 	crypto_mod_put(alg);
 	return inst;
+
+out_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out_put_alg;
 }
 
 static struct cryptd_queue queue;
