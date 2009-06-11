From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 4/7] crypto: use crypto_shash instead of crypto_hash in
 cryptd hash
Date: Thu, 11 Jun 2009 15:10:32 +0800
Message-ID: <1244704232.5320.127.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247AbZFKHKk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_hash interface has some issue and will be replaced by
crypto_shash. This patch replace crypto_hash in cryptd hash with
crypto_shash.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/cryptd.c |  118 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 73 insertions(+), 45 deletions(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -14,12 +14,12 @@
 #include <crypto/internal/hash.h>
 #include <crypto/cryptd.h>
 #include <crypto/crypto_wq.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -48,11 +48,12 @@ struct cryptd_blkcipher_request_ctx {
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
@@ -334,15 +335,15 @@ static int cryptd_hash_init_tfm(struct c
 	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct crypto_spawn *spawn = &ictx->spawn;
 	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_hash *cipher;
+	struct crypto_shash *cipher;
 
-	cipher = crypto_spawn_hash(spawn);
+	cipher = crypto_spawn_shash(spawn);
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
-	tfm->crt_ahash.reqsize =
-		sizeof(struct cryptd_hash_request_ctx);
+	tfm->crt_ahash.reqsize = sizeof(struct cryptd_hash_request_ctx) +
+		crypto_shash_descsize(cipher);
 	return 0;
 }
 
@@ -350,22 +351,22 @@ static void cryptd_hash_exit_tfm(struct 
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
+	struct crypto_shash    *child = ctx->child;
 	int err;
 
-	crypto_hash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_hash_set_flags(child, crypto_ahash_get_flags(parent) &
-					  CRYPTO_TFM_REQ_MASK);
-	err = crypto_hash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(parent, crypto_hash_get_flags(child) &
-					    CRYPTO_TFM_RES_MASK);
+	crypto_shash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_shash_set_flags(child, crypto_ahash_get_flags(parent) &
+			       CRYPTO_TFM_REQ_MASK);
+	err = crypto_shash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_shash_get_flags(child) &
+			       CRYPTO_TFM_RES_MASK);
 	return err;
 }
 
@@ -386,20 +387,21 @@ static int cryptd_hash_enqueue(struct ah
 static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
 {
 	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
+	struct crypto_shash    *child = ctx->child;
 	struct ahash_request    *req = ahash_request_cast(req_async);
 	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
+	struct shash_desc *desc;
 
 	rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc = &rctx->desc;
+	desc->tfm = child;
+	desc->flags = req->base.flags | CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = crypto_hash_crt(child)->init(&desc);
+	err = crypto_shash_init(desc);
 
 	req->base.complete = rctx->complete;
 
@@ -416,23 +418,23 @@ static int cryptd_hash_init_enqueue(stru
 
 static void cryptd_hash_update(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
 	struct ahash_request    *req = ahash_request_cast(req_async);
 	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
+	struct shash_desc *desc;
+	struct crypto_hash_walk walk;
+	int nbytes;
 
 	rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc = &rctx->desc;
 
-	err = crypto_hash_crt(child)->update(&desc,
-						req->src,
-						req->nbytes);
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+	err = nbytes;
 
 	req->base.complete = rctx->complete;
 
@@ -449,21 +451,18 @@ static int cryptd_hash_update_enqueue(st
 
 static void cryptd_hash_final(struct crypto_async_request *req_async, int err)
 {
-	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
 	struct ahash_request    *req = ahash_request_cast(req_async);
 	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
+	struct shash_desc *desc;
 
 	rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc = &rctx->desc;
 
-	err = crypto_hash_crt(child)->final(&desc, req->result);
+	err = crypto_shash_final(desc, req->result);
 
 	req->base.complete = rctx->complete;
 
@@ -481,23 +480,49 @@ static int cryptd_hash_final_enqueue(str
 static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
 {
 	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_hash     *child = ctx->child;
-	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct crypto_shash    *child = ctx->child;
+	struct ahash_request   *req = ahash_request_cast(req_async);
 	struct cryptd_hash_request_ctx *rctx;
-	struct hash_desc desc;
+	struct shash_desc *desc;
+	struct crypto_hash_walk walk;
+	int nbytes;
+	unsigned int n = req->nbytes;
+	struct scatterlist *sg = req->src;
+	unsigned int offset = sg->offset;
 
 	rctx = ahash_request_ctx(req);
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc.tfm = child;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc = &rctx->desc;
+	desc->tfm = child;
+	desc->flags = req->base.flags | CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	if (n < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
+		void *data;
+
+		data = crypto_kmap(sg_page(sg), 0);
+		err = crypto_shash_digest(desc, data + offset, n,
+					  req->result);
+		crypto_kunmap(data, 0);
+		crypto_yield(desc->flags);
+		goto out;
+	}
 
-	err = crypto_hash_crt(child)->digest(&desc,
-						req->src,
-						req->nbytes,
-						req->result);
+	err = crypto_shash_init(desc);
+	if (err)
+		goto out;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+	if (nbytes) {
+		err = nbytes;
+		goto out;
+	}
+
+	err = crypto_shash_final(desc, req->result);
 
 	req->base.complete = rctx->complete;
 
@@ -517,12 +542,15 @@ static struct crypto_instance *cryptd_al
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	struct shash_alg *salg;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
-				  CRYPTO_ALG_TYPE_HASH_MASK);
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_SHASH,
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
+	salg = __crypto_shash_alg(alg);
+
 	inst = cryptd_alloc_instance(alg, queue);
 	if (IS_ERR(inst))
 		goto out_put_alg;
@@ -530,7 +558,7 @@ static struct crypto_instance *cryptd_al
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_type = &crypto_ahash_type;
 
-	inst->alg.cra_ahash.digestsize = alg->cra_hash.digestsize;
+	inst->alg.cra_ahash.digestsize = salg->digestsize;
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
 	inst->alg.cra_init = cryptd_hash_init_tfm;


