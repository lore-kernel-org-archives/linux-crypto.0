From: Megha Dey <megha.dey@intel.com>
Subject: [PATCH] crypto : async implementation for sha1-mb
Date: Tue, 21 Jun 2016 18:21:46 -0700
Message-ID: <1466558506-3189-1-git-send-email-megha.dey@intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	megha.dey@intel.com, fenghua.yu@intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34346 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbcFVBRy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 21:17:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Megha Dey <megha.dey@linux.intel.com>

Herbert wants the sha1-mb algorithm to have an async implementation:
https://lkml.org/lkml/2016/4/5/286.
Currently, sha1-mb uses an async interface for the outer algorithm
and a sync interface for the inner algorithm. This patch introduces
a async interface for even the inner algorithm.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 182 ++++++++++++++++++++++-----------------
 crypto/mcryptd.c                 | 132 ++++++++++++----------------
 include/crypto/internal/hash.h   |  12 +--
 include/crypto/mcryptd.h         |   8 +-
 4 files changed, 165 insertions(+), 169 deletions(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index 0a46491..669cc37 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -80,10 +80,10 @@ struct sha1_mb_ctx {
 static inline struct mcryptd_hash_request_ctx
 		*cast_hash_to_mcryptd_ctx(struct sha1_hash_ctx *hash_ctx)
 {
-	struct shash_desc *desc;
+	struct ahash_request *areq;
 
-	desc = container_of((void *) hash_ctx, struct shash_desc, __ctx);
-	return container_of(desc, struct mcryptd_hash_request_ctx, desc);
+	areq = container_of((void *) hash_ctx, struct ahash_request, __ctx);
+	return container_of(areq, struct mcryptd_hash_request_ctx, areq);
 }
 
 static inline struct ahash_request
@@ -93,7 +93,7 @@ static inline struct ahash_request
 }
 
 static void req_ctx_init(struct mcryptd_hash_request_ctx *rctx,
-				struct shash_desc *desc)
+				struct ahash_request *areq)
 {
 	rctx->flag = HASH_UPDATE;
 }
@@ -375,9 +375,9 @@ static struct sha1_hash_ctx *sha1_ctx_mgr_flush(struct sha1_ctx_mgr *mgr)
 	}
 }
 
-static int sha1_mb_init(struct shash_desc *desc)
+static int sha1_mb_init(struct ahash_request *areq)
 {
-	struct sha1_hash_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_hash_ctx *sctx = ahash_request_ctx(areq);
 
 	hash_ctx_init(sctx);
 	sctx->job.result_digest[0] = SHA1_H0;
@@ -395,7 +395,7 @@ static int sha1_mb_init(struct shash_desc *desc)
 static int sha1_mb_set_results(struct mcryptd_hash_request_ctx *rctx)
 {
 	int	i;
-	struct	sha1_hash_ctx *sctx = shash_desc_ctx(&rctx->desc);
+	struct	sha1_hash_ctx *sctx = ahash_request_ctx(&rctx->areq);
 	__be32	*dst = (__be32 *) rctx->out;
 
 	for (i = 0; i < 5; ++i)
@@ -427,7 +427,7 @@ static int sha_finish_walk(struct mcryptd_hash_request_ctx **ret_rctx,
 
 		}
 		sha_ctx = (struct sha1_hash_ctx *)
-						shash_desc_ctx(&rctx->desc);
+						ahash_request_ctx(&rctx->areq);
 		kernel_fpu_begin();
 		sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx,
 						rctx->walk.data, nbytes, flag);
@@ -519,11 +519,10 @@ static void sha1_mb_add_list(struct mcryptd_hash_request_ctx *rctx,
 	mcryptd_arm_flusher(cstate, delay);
 }
 
-static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
-			  unsigned int len)
+static int sha1_mb_update(struct ahash_request *areq)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-		container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(areq, struct mcryptd_hash_request_ctx, areq);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -539,7 +538,7 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 	}
 
 	/* need to init context */
-	req_ctx_init(rctx, desc);
+	req_ctx_init(rctx, areq);
 
 	nbytes = crypto_ahash_walk_first(req, &rctx->walk);
 
@@ -552,7 +551,7 @@ static int sha1_mb_update(struct shash_desc *desc, const u8 *data,
 		rctx->flag |= HASH_DONE;
 
 	/* submit */
-	sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(desc);
+	sha_ctx = (struct sha1_hash_ctx *) ahash_request_ctx(areq);
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
 	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, rctx->walk.data,
@@ -579,11 +578,10 @@ done:
 	return ret;
 }
 
-static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, u8 *out)
+static int sha1_mb_finup(struct ahash_request *areq)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-		container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(areq, struct mcryptd_hash_request_ctx, areq);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -598,7 +596,7 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 	}
 
 	/* need to init context */
-	req_ctx_init(rctx, desc);
+	req_ctx_init(rctx, areq);
 
 	nbytes = crypto_ahash_walk_first(req, &rctx->walk);
 
@@ -611,11 +609,10 @@ static int sha1_mb_finup(struct shash_desc *desc, const u8 *data,
 		rctx->flag |= HASH_DONE;
 		flag = HASH_LAST;
 	}
-	rctx->out = out;
 
 	/* submit */
 	rctx->flag |= HASH_FINAL;
-	sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(desc);
+	sha_ctx = (struct sha1_hash_ctx *) ahash_request_ctx(areq);
 	sha1_mb_add_list(rctx, cstate);
 
 	kernel_fpu_begin();
@@ -641,10 +638,10 @@ done:
 	return ret;
 }
 
-static int sha1_mb_final(struct shash_desc *desc, u8 *out)
+static int sha1_mb_final(struct ahash_request *areq)
 {
 	struct mcryptd_hash_request_ctx *rctx =
-		container_of(desc, struct mcryptd_hash_request_ctx, desc);
+		container_of(areq, struct mcryptd_hash_request_ctx, areq);
 	struct mcryptd_alg_cstate *cstate =
 				this_cpu_ptr(sha1_mb_alg_state.alg_cstate);
 
@@ -659,12 +656,11 @@ static int sha1_mb_final(struct shash_desc *desc, u8 *out)
 	}
 
 	/* need to init context */
-	req_ctx_init(rctx, desc);
+	req_ctx_init(rctx, areq);
 
-	rctx->out = out;
 	rctx->flag |= HASH_DONE | HASH_FINAL;
 
-	sha_ctx = (struct sha1_hash_ctx *) shash_desc_ctx(desc);
+	sha_ctx = (struct sha1_hash_ctx *) ahash_request_ctx(areq);
 	/* flag HASH_FINAL and 0 data size */
 	sha1_mb_add_list(rctx, cstate);
 	kernel_fpu_begin();
@@ -691,48 +687,98 @@ done:
 	return ret;
 }
 
-static int sha1_mb_export(struct shash_desc *desc, void *out)
+static int sha1_mb_export(struct ahash_request *areq, void *out)
 {
-	struct sha1_hash_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_hash_ctx *sctx = ahash_request_ctx(areq);
 
 	memcpy(out, sctx, sizeof(*sctx));
 
 	return 0;
 }
 
-static int sha1_mb_import(struct shash_desc *desc, const void *in)
+static int sha1_mb_import(struct ahash_request *areq, const void *in)
 {
-	struct sha1_hash_ctx *sctx = shash_desc_ctx(desc);
+	struct sha1_hash_ctx *sctx = ahash_request_ctx(areq);
 
 	memcpy(sctx, in, sizeof(*sctx));
 
 	return 0;
 }
 
+static int sha1_mb_async_init_tfm(struct crypto_tfm *tfm)
+{
+	struct mcryptd_ahash *mcryptd_tfm;
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct mcryptd_hash_ctx *mctx;
 
-static struct shash_alg sha1_mb_shash_alg = {
-	.digestsize	=	SHA1_DIGEST_SIZE,
+	mcryptd_tfm = mcryptd_alloc_ahash("__intel_sha1-mb",
+						CRYPTO_ALG_INTERNAL,
+						CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(mcryptd_tfm))
+		return PTR_ERR(mcryptd_tfm);
+	mctx = crypto_ahash_ctx(&mcryptd_tfm->base);
+	mctx->alg_state = &sha1_mb_alg_state;
+	ctx->mcryptd_tfm = mcryptd_tfm;
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				sizeof(struct ahash_request) +
+				crypto_ahash_reqsize(&mcryptd_tfm->base));
+
+	return 0;
+}
+
+static void sha1_mb_async_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	mcryptd_free_ahash(ctx->mcryptd_tfm);
+}
+
+static int sha1_mb_areq_init_tfm(struct crypto_tfm *tfm)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				sizeof(struct ahash_request) +
+				sizeof(struct sha1_hash_ctx));
+
+	return 0;
+}
+
+static void sha1_mb_areq_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	mcryptd_free_ahash(ctx->mcryptd_tfm);
+}
+
+static struct ahash_alg sha1_mb_areq_alg = {
 	.init		=	sha1_mb_init,
 	.update		=	sha1_mb_update,
 	.final		=	sha1_mb_final,
 	.finup		=	sha1_mb_finup,
 	.export		=	sha1_mb_export,
 	.import		=	sha1_mb_import,
-	.descsize	=	sizeof(struct sha1_hash_ctx),
-	.statesize	=	sizeof(struct sha1_hash_ctx),
-	.base		=	{
-		.cra_name	 = "__sha1-mb",
-		.cra_driver_name = "__intel_sha1-mb",
-		.cra_priority	 = 100,
-		/*
-		 * use ASYNC flag as some buffers in multi-buffer
-		 * algo may not have completed before hashing thread sleep
-		 */
-		.cra_flags	 = CRYPTO_ALG_TYPE_SHASH | CRYPTO_ALG_ASYNC |
-				   CRYPTO_ALG_INTERNAL,
-		.cra_blocksize	 = SHA1_BLOCK_SIZE,
-		.cra_module	 = THIS_MODULE,
-		.cra_list	 = LIST_HEAD_INIT(sha1_mb_shash_alg.base.cra_list),
+	.halg		=	{
+		.digestsize	=	SHA1_DIGEST_SIZE,
+		.statesize	=	sizeof(struct sha1_hash_ctx),
+		.base		=	{
+			.cra_name	 = "__sha1-mb",
+			.cra_driver_name = "__intel_sha1-mb",
+			.cra_priority	 = 100,
+			/*
+			 * use ASYNC flag as some buffers in multi-buffer
+			 * algo may not have completed before hashing thread
+			 * sleep
+			 */
+			.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_INTERNAL,
+			.cra_blocksize	= SHA1_BLOCK_SIZE,
+			.cra_module	= THIS_MODULE,
+			.cra_list	= LIST_HEAD_INIT
+					(sha1_mb_areq_alg.halg.base.cra_list),
+			.cra_init	= sha1_mb_areq_init_tfm,
+			.cra_exit	= sha1_mb_areq_exit_tfm,
+			.cra_ctxsize	= sizeof(struct sha1_hash_ctx),
+		}
 	}
 };
 
@@ -817,46 +863,20 @@ static int sha1_mb_async_import(struct ahash_request *req, const void *in)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
-	struct crypto_shash *child = mcryptd_ahash_child(mcryptd_tfm);
+	struct crypto_ahash *child = mcryptd_ahash_child(mcryptd_tfm);
 	struct mcryptd_hash_request_ctx *rctx;
-	struct shash_desc *desc;
+	struct ahash_request *areq;
 
 	memcpy(mcryptd_req, req, sizeof(*req));
 	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
 	rctx = ahash_request_ctx(mcryptd_req);
-	desc = &rctx->desc;
-	desc->tfm = child;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	return crypto_ahash_import(mcryptd_req, in);
-}
-
-static int sha1_mb_async_init_tfm(struct crypto_tfm *tfm)
-{
-	struct mcryptd_ahash *mcryptd_tfm;
-	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct mcryptd_hash_ctx *mctx;
+	areq = &rctx->areq;
 
-	mcryptd_tfm = mcryptd_alloc_ahash("__intel_sha1-mb",
-					  CRYPTO_ALG_INTERNAL,
-					  CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(mcryptd_tfm))
-		return PTR_ERR(mcryptd_tfm);
-	mctx = crypto_ahash_ctx(&mcryptd_tfm->base);
-	mctx->alg_state = &sha1_mb_alg_state;
-	ctx->mcryptd_tfm = mcryptd_tfm;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct ahash_request) +
-				 crypto_ahash_reqsize(&mcryptd_tfm->base));
-
-	return 0;
-}
-
-static void sha1_mb_async_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
+	ahash_request_set_tfm(areq, child);
+	ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_SLEEP,
+					rctx->complete, req);
 
-	mcryptd_free_ahash(ctx->mcryptd_tfm);
+	return crypto_ahash_import(mcryptd_req, in);
 }
 
 static struct ahash_alg sha1_mb_async_alg = {
@@ -965,7 +985,7 @@ static int __init sha1_mb_mod_init(void)
 	}
 	sha1_mb_alg_state.flusher = &sha1_mb_flusher;
 
-	err = crypto_register_shash(&sha1_mb_shash_alg);
+	err = crypto_register_ahash(&sha1_mb_areq_alg);
 	if (err)
 		goto err2;
 	err = crypto_register_ahash(&sha1_mb_async_alg);
@@ -975,7 +995,7 @@ static int __init sha1_mb_mod_init(void)
 
 	return 0;
 err1:
-	crypto_unregister_shash(&sha1_mb_shash_alg);
+	crypto_unregister_ahash(&sha1_mb_areq_alg);
 err2:
 	for_each_possible_cpu(cpu) {
 		cpu_state = per_cpu_ptr(sha1_mb_alg_state.alg_cstate, cpu);
@@ -991,7 +1011,7 @@ static void __exit sha1_mb_mod_fini(void)
 	struct mcryptd_alg_cstate *cpu_state;
 
 	crypto_unregister_ahash(&sha1_mb_async_alg);
-	crypto_unregister_shash(&sha1_mb_shash_alg);
+	crypto_unregister_ahash(&sha1_mb_areq_alg);
 	for_each_possible_cpu(cpu) {
 		cpu_state = per_cpu_ptr(sha1_mb_alg_state.alg_cstate, cpu);
 		kfree(cpu_state->mgr);
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index c4eb9da..86fb59b 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -41,7 +41,7 @@ struct mcryptd_flush_list {
 static struct mcryptd_flush_list __percpu *mcryptd_flist;
 
 struct hashd_instance_ctx {
-	struct crypto_shash_spawn spawn;
+	struct crypto_ahash_spawn spawn;
 	struct mcryptd_queue *queue;
 };
 
@@ -272,18 +272,18 @@ static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
 	struct hashd_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_shash_spawn *spawn = &ictx->spawn;
+	struct crypto_ahash_spawn *spawn = &ictx->spawn;
 	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_shash *hash;
+	struct crypto_ahash *hash;
 
-	hash = crypto_spawn_shash(spawn);
+	hash = crypto_spawn_ahash(spawn);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
 	ctx->child = hash;
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct mcryptd_hash_request_ctx) +
-				 crypto_shash_descsize(hash));
+				 crypto_ahash_reqsize(hash));
 	return 0;
 }
 
@@ -291,21 +291,21 @@ static void mcryptd_hash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_shash(ctx->child);
+	crypto_free_ahash(ctx->child);
 }
 
 static int mcryptd_hash_setkey(struct crypto_ahash *parent,
 				   const u8 *key, unsigned int keylen)
 {
 	struct mcryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
-	struct crypto_shash *child = ctx->child;
+	struct crypto_ahash *child = ctx->child;
 	int err;
 
-	crypto_shash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_shash_set_flags(child, crypto_ahash_get_flags(parent) &
+	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(child, crypto_ahash_get_flags(parent) &
 				      CRYPTO_TFM_REQ_MASK);
-	err = crypto_shash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(parent, crypto_shash_get_flags(child) &
+	err = crypto_ahash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_ahash_get_flags(child) &
 				       CRYPTO_TFM_RES_MASK);
 	return err;
 }
@@ -331,20 +331,20 @@ static int mcryptd_hash_enqueue(struct ahash_request *req,
 static void mcryptd_hash_init(struct crypto_async_request *req_async, int err)
 {
 	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_shash *child = ctx->child;
+	struct crypto_ahash *child = ctx->child;
 	struct ahash_request *req = ahash_request_cast(req_async);
 	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct shash_desc *desc = &rctx->desc;
+	struct ahash_request *desc = &rctx->areq;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc->tfm = child;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_tfm(desc, child);
+	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
+						rctx->complete, req_async);
 
-	err = crypto_shash_init(desc);
-
-	req->base.complete = rctx->complete;
+	rctx->out = req->result;
+	err = crypto_ahash_init(desc);
 
 out:
 	local_bh_disable();
@@ -365,7 +365,8 @@ static void mcryptd_hash_update(struct crypto_async_request *req_async, int err)
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	err = shash_ahash_mcryptd_update(req, &rctx->desc);
+	rctx->out = req->result;
+	err = ahash_mcryptd_update(&rctx->areq);
 	if (err) {
 		req->base.complete = rctx->complete;
 		goto out;
@@ -391,7 +392,8 @@ static void mcryptd_hash_final(struct crypto_async_request *req_async, int err)
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	err = shash_ahash_mcryptd_final(req, &rctx->desc);
+	rctx->out = req->result;
+	err = ahash_mcryptd_final(&rctx->areq);
 	if (err) {
 		req->base.complete = rctx->complete;
 		goto out;
@@ -416,8 +418,8 @@ static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
-
-	err = shash_ahash_mcryptd_finup(req, &rctx->desc);
+	rctx->out = req->result;
+	err = ahash_mcryptd_finup(&rctx->areq);
 
 	if (err) {
 		req->base.complete = rctx->complete;
@@ -439,25 +441,21 @@ static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
 static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
 {
 	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_shash *child = ctx->child;
+	struct crypto_ahash *child = ctx->child;
 	struct ahash_request *req = ahash_request_cast(req_async);
 	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct shash_desc *desc = &rctx->desc;
+	struct ahash_request *desc = &rctx->areq;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	desc->tfm = child;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */
-
-	err = shash_ahash_mcryptd_digest(req, desc);
+	ahash_request_set_tfm(desc, child);
+	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
+						rctx->complete, req_async);
 
-	if (err) {
-		req->base.complete = rctx->complete;
-		goto out;
-	}
+	rctx->out = req->result;
+	err = ahash_mcryptd_digest(desc);
 
-	return;
 out:
 	local_bh_disable();
 	rctx->complete(&req->base, err);
@@ -473,14 +471,14 @@ static int mcryptd_hash_export(struct ahash_request *req, void *out)
 {
 	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	return crypto_shash_export(&rctx->desc, out);
+	return crypto_ahash_export(&rctx->areq, out);
 }
 
 static int mcryptd_hash_import(struct ahash_request *req, const void *in)
 {
 	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	return crypto_shash_import(&rctx->desc, in);
+	return crypto_ahash_import(&rctx->areq, in);
 }
 
 static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
@@ -488,7 +486,7 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 {
 	struct hashd_instance_ctx *ctx;
 	struct ahash_instance *inst;
-	struct shash_alg *salg;
+	struct hash_alg_common *halg;
 	struct crypto_alg *alg;
 	u32 type = 0;
 	u32 mask = 0;
@@ -496,11 +494,11 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 
 	mcryptd_check_internal(tb, &type, &mask);
 
-	salg = shash_attr_alg(tb[1], type, mask);
-	if (IS_ERR(salg))
-		return PTR_ERR(salg);
+	halg = ahash_attr_alg(tb[1], type, mask);
+	if (IS_ERR(halg))
+		return PTR_ERR(halg);
 
-	alg = &salg->base;
+	alg = &halg->base;
 	pr_debug("crypto: mcryptd hash alg: %s\n", alg->cra_name);
 	inst = mcryptd_alloc_instance(alg, ahash_instance_headroom(),
 					sizeof(*ctx));
@@ -511,7 +509,7 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	ctx = ahash_instance_ctx(inst);
 	ctx->queue = queue;
 
-	err = crypto_init_shash_spawn(&ctx->spawn, salg,
+	err = crypto_init_ahash_spawn(&ctx->spawn, halg,
 				      ahash_crypto_instance(inst));
 	if (err)
 		goto out_free_inst;
@@ -521,8 +519,8 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 		type |= CRYPTO_ALG_INTERNAL;
 	inst->alg.halg.base.cra_flags = type;
 
-	inst->alg.halg.digestsize = salg->digestsize;
-	inst->alg.halg.statesize = salg->statesize;
+	inst->alg.halg.digestsize = halg->digestsize;
+	inst->alg.halg.statesize = halg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct mcryptd_hash_ctx);
 
 	inst->alg.halg.base.cra_init = mcryptd_hash_init_tfm;
@@ -539,7 +537,7 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 
 	err = ahash_register_instance(tmpl, inst);
 	if (err) {
-		crypto_drop_shash(&ctx->spawn);
+		crypto_drop_ahash(&ctx->spawn);
 out_free_inst:
 		kfree(inst);
 	}
@@ -575,7 +573,7 @@ static void mcryptd_free(struct crypto_instance *inst)
 
 	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AHASH:
-		crypto_drop_shash(&hctx->spawn);
+		crypto_drop_ahash(&hctx->spawn);
 		kfree(ahash_instance(inst));
 		return;
 	default:
@@ -612,55 +610,38 @@ struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
 }
 EXPORT_SYMBOL_GPL(mcryptd_alloc_ahash);
 
-int shash_ahash_mcryptd_digest(struct ahash_request *req,
-			       struct shash_desc *desc)
+int ahash_mcryptd_digest(struct ahash_request *desc)
 {
 	int err;
 
-	err = crypto_shash_init(desc) ?:
-	      shash_ahash_mcryptd_finup(req, desc);
+	err = crypto_ahash_init(desc) ?:
+	      ahash_mcryptd_finup(desc);
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_digest);
 
-int shash_ahash_mcryptd_update(struct ahash_request *req,
-			       struct shash_desc *desc)
+int ahash_mcryptd_update(struct ahash_request *desc)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-
 	/* alignment is to be done by multi-buffer crypto algorithm if needed */
 
-	return shash->update(desc, NULL, 0);
+	return crypto_ahash_update(desc);
 }
-EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_update);
 
-int shash_ahash_mcryptd_finup(struct ahash_request *req,
-			      struct shash_desc *desc)
+int ahash_mcryptd_finup(struct ahash_request *desc)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-
 	/* alignment is to be done by multi-buffer crypto algorithm if needed */
 
-	return shash->finup(desc, NULL, 0, req->result);
+	return crypto_ahash_finup(desc);
 }
-EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_finup);
 
-int shash_ahash_mcryptd_final(struct ahash_request *req,
-			      struct shash_desc *desc)
+int ahash_mcryptd_final(struct ahash_request *desc)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-
 	/* alignment is to be done by multi-buffer crypto algorithm if needed */
 
-	return shash->final(desc, req->result);
+	return crypto_ahash_final(desc);
 }
-EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_final);
 
-struct crypto_shash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
+struct crypto_ahash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
 {
 	struct mcryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
 
@@ -668,12 +649,12 @@ struct crypto_shash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
 }
 EXPORT_SYMBOL_GPL(mcryptd_ahash_child);
 
-struct shash_desc *mcryptd_shash_desc(struct ahash_request *req)
+struct ahash_request *mcryptd_ahash_desc(struct ahash_request *req)
 {
 	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	return &rctx->desc;
+	return &rctx->areq;
 }
-EXPORT_SYMBOL_GPL(mcryptd_shash_desc);
+EXPORT_SYMBOL_GPL(mcryptd_ahash_desc);
 
 void mcryptd_free_ahash(struct mcryptd_ahash *tfm)
 {
@@ -681,7 +662,6 @@ void mcryptd_free_ahash(struct mcryptd_ahash *tfm)
 }
 EXPORT_SYMBOL_GPL(mcryptd_free_ahash);
 
-
 static int __init mcryptd_init(void)
 {
 	int err, cpu;
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 49dae16..1d4f365 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -114,14 +114,10 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
 
-int shash_ahash_mcryptd_update(struct ahash_request *req,
-			       struct shash_desc *desc);
-int shash_ahash_mcryptd_final(struct ahash_request *req,
-			      struct shash_desc *desc);
-int shash_ahash_mcryptd_finup(struct ahash_request *req,
-			      struct shash_desc *desc);
-int shash_ahash_mcryptd_digest(struct ahash_request *req,
-			       struct shash_desc *desc);
+int ahash_mcryptd_update(struct ahash_request *desc);
+int ahash_mcryptd_final(struct ahash_request *desc);
+int ahash_mcryptd_finup(struct ahash_request *desc);
+int ahash_mcryptd_digest(struct ahash_request *desc);
 
 int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
 
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
index c23ee1f..4a53c0d 100644
--- a/include/crypto/mcryptd.h
+++ b/include/crypto/mcryptd.h
@@ -39,7 +39,7 @@ struct mcryptd_instance_ctx {
 };
 
 struct mcryptd_hash_ctx {
-	struct crypto_shash *child;
+	struct crypto_ahash *child;
 	struct mcryptd_alg_state *alg_state;
 };
 
@@ -59,13 +59,13 @@ struct mcryptd_hash_request_ctx {
 	struct crypto_hash_walk walk;
 	u8 *out;
 	int flag;
-	struct shash_desc desc;
+	struct ahash_request areq;
 };
 
 struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask);
-struct crypto_shash *mcryptd_ahash_child(struct mcryptd_ahash *tfm);
-struct shash_desc *mcryptd_shash_desc(struct ahash_request *req);
+struct crypto_ahash *mcryptd_ahash_child(struct mcryptd_ahash *tfm);
+struct ahash_request *mcryptd_ahash_desc(struct ahash_request *req);
 void mcryptd_free_ahash(struct mcryptd_ahash *tfm);
 void mcryptd_flusher(struct work_struct *work);
 
-- 
1.9.1
