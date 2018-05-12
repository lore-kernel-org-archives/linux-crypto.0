From: Megha Dey <megha.dey@linux.intel.com>
Subject: [RFC] crypto: Remove mcryptd
Date: Fri, 11 May 2018 18:44:13 -0700
Message-ID: <1526089453-6542-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch attempts to remove the mcryptd interface and expose the
sha1 multibuffer algorithm as a proper ahash to the inner algorithm.

1. Host the flusher helper in sha1_mb.c instead of mcryptd.c (need to
change the names of these functions)
2. Remove unnecessary mcryptd structure mcryptd_hash_ctx
(combine sha_mb_ctx and mcryptd_hash_ctx)
3. Introduce a new simd_ahash_create_compat() similar to the
simd_skcipher_create_compat() in simd.c. This registers the outer
algorithm. Remove existing outer algorithm.
4. In the outer layer(simd wrapper), pass the right pointers to the
inner algorithm.(will shift 3 and 4 to simd.c later)
5. Remove mcryptd.c
6. Update the name, driver name and priority of inner algorithm.

Herbert,
I would like to know if the above approach is what you are suggesting.
The problem with this approach is there is no async workqueue context
which issues completions. Instead everything runs in a single thread of
execution. You had suggested that the SIMD wrapper will defer the job to
the Kthread context, but I am not sure that will be done.

Please let me know what you think.

Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
---
 arch/x86/crypto/sha1-mb/sha1_mb.c | 312 +++++++++++------
 crypto/Makefile                   |   1 -
 crypto/mcryptd.c                  | 702 --------------------------------------
 include/crypto/mcryptd.h          |   5 -
 4 files changed, 200 insertions(+), 820 deletions(-)
 delete mode 100644 crypto/mcryptd.c

diff --git a/arch/x86/crypto/sha1-mb/sha1_mb.c b/arch/x86/crypto/sha1-mb/sha1_mb.c
index acf9fdf..b8c03ce 100644
--- a/arch/x86/crypto/sha1-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha1-mb/sha1_mb.c
@@ -71,10 +71,62 @@
 
 #define FLUSH_INTERVAL 1000 /* in usec */
 
+static struct crypto_ahash *tfm_compact;
+
+struct mcryptd_flush_list {
+	struct list_head list;
+	struct mutex lock;
+};
+
+static struct mcryptd_flush_list __percpu *mcryptd_flist;
+
+void mcryptd_arm_flusher(struct mcryptd_alg_cstate *cstate, unsigned long delay)
+{
+	struct mcryptd_flush_list *flist;
+
+	if (!cstate->flusher_engaged) {
+		/* put the flusher on the flush list */
+		flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
+		mutex_lock(&flist->lock);
+		list_add_tail(&cstate->flush_list, &flist->list);
+		cstate->flusher_engaged = true;
+		cstate->next_flush = jiffies + delay;
+		queue_delayed_work_on(smp_processor_id(), kcrypto_wq,
+					&cstate->flush, delay);
+		mutex_unlock(&flist->lock);
+	}
+}
+
+void mcryptd_flusher(struct work_struct *__work)
+{
+	struct  mcryptd_alg_cstate      *alg_cpu_state;
+	struct  mcryptd_alg_state       *alg_state;
+	struct  mcryptd_flush_list      *flist;
+	int     cpu;
+
+	cpu = smp_processor_id();
+	alg_cpu_state = container_of(to_delayed_work(__work),
+				struct mcryptd_alg_cstate, flush);
+	alg_state = alg_cpu_state->alg_state;
+	if (alg_cpu_state->cpu != cpu)
+		pr_debug("mcryptd error: work on cpu %d, should be cpu %d\n",
+				cpu, alg_cpu_state->cpu);
+
+	if (alg_cpu_state->flusher_engaged) {
+		flist = per_cpu_ptr(mcryptd_flist, cpu);
+		mutex_lock(&flist->lock);
+		list_del(&alg_cpu_state->flush_list);
+		alg_cpu_state->flusher_engaged = false;
+		mutex_unlock(&flist->lock);
+		alg_state->flusher(alg_cpu_state);
+	}
+}
+
 static struct mcryptd_alg_state sha1_mb_alg_state;
 
 struct sha1_mb_ctx {
-	struct mcryptd_ahash *mcryptd_tfm;
+	struct crypto_ahash *child;
+	struct mcryptd_alg_state *alg_state;
 };
 
 static inline struct mcryptd_hash_request_ctx
@@ -530,7 +582,6 @@ static int sha1_mb_update(struct ahash_request *areq)
 	struct sha1_hash_ctx *sha_ctx;
 	int ret = 0, nbytes;
 
-
 	/* sanity check */
 	if (rctx->tag.cpu != smp_processor_id()) {
 		pr_err("mcryptd error: cpu clash\n");
@@ -667,7 +718,6 @@ static int sha1_mb_final(struct ahash_request *areq)
 	sha_ctx = sha1_ctx_mgr_submit(cstate->mgr, sha_ctx, &data, 0,
 								HASH_LAST);
 	kernel_fpu_end();
-
 	/* check if anything is returned */
 	if (!sha_ctx)
 		return -EINPROGRESS;
@@ -707,21 +757,12 @@ static int sha1_mb_import(struct ahash_request *areq, const void *in)
 
 static int sha1_mb_async_init_tfm(struct crypto_tfm *tfm)
 {
-	struct mcryptd_ahash *mcryptd_tfm;
 	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct mcryptd_hash_ctx *mctx;
 
-	mcryptd_tfm = mcryptd_alloc_ahash("__intel_sha1-mb",
-						CRYPTO_ALG_INTERNAL,
-						CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(mcryptd_tfm))
-		return PTR_ERR(mcryptd_tfm);
-	mctx = crypto_ahash_ctx(&mcryptd_tfm->base);
-	mctx->alg_state = &sha1_mb_alg_state;
-	ctx->mcryptd_tfm = mcryptd_tfm;
+	ctx->child = tfm_compact;
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				sizeof(struct ahash_request) +
-				crypto_ahash_reqsize(&mcryptd_tfm->base));
+				crypto_ahash_reqsize(tfm_compact));
 
 	return 0;
 }
@@ -730,7 +771,7 @@ static void sha1_mb_async_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	mcryptd_free_ahash(ctx->mcryptd_tfm);
+	crypto_free_ahash(ctx->child);
 }
 
 static int sha1_mb_areq_init_tfm(struct crypto_tfm *tfm)
@@ -746,7 +787,7 @@ static void sha1_mb_areq_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	mcryptd_free_ahash(ctx->mcryptd_tfm);
+	crypto_free_ahash(ctx->child);
 }
 
 static struct ahash_alg sha1_mb_areq_alg = {
@@ -760,9 +801,9 @@ static void sha1_mb_areq_exit_tfm(struct crypto_tfm *tfm)
 		.digestsize	=	SHA1_DIGEST_SIZE,
 		.statesize	=	sizeof(struct sha1_hash_ctx),
 		.base		=	{
-			.cra_name	 = "__sha1-mb",
-			.cra_driver_name = "__intel_sha1-mb",
-			.cra_priority	 = 100,
+			.cra_name	 = "__sha1",
+			.cra_driver_name = "__sha1_mb",
+			.cra_priority	 = 200,
 			/*
 			 * use ASYNC flag as some buffers in multi-buffer
 			 * algo may not have completed before hashing thread
@@ -784,128 +825,158 @@ static void sha1_mb_areq_exit_tfm(struct crypto_tfm *tfm)
 
 static int sha1_mb_async_init(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
-
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_init(mcryptd_req);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *desc = &rctx->areq;
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_ahash *child = ctx->child;
+
+	rctx->out = req->result;
+	rctx->complete = req->base.complete;
+
+	ahash_request_set_tfm(desc, child);
+	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
+					rctx->complete, &req->base);
+
+	return crypto_ahash_init(desc);
 }
 
 static int sha1_mb_async_update(struct ahash_request *req)
 {
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
+	rctx->out = req->result;
+	rctx->complete = req->base.complete;
+	rctx->tag.cpu = smp_processor_id();
 
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_update(mcryptd_req);
+	return crypto_ahash_update(&rctx->areq);
 }
 
 static int sha1_mb_async_finup(struct ahash_request *req)
 {
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
+	rctx->out = req->result;
+	rctx->complete = req->base.complete;
+	rctx->tag.cpu = smp_processor_id();
 
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_finup(mcryptd_req);
+	return crypto_ahash_finup(&rctx->areq);
 }
 
 static int sha1_mb_async_final(struct ahash_request *req)
 {
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
 
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
+	rctx->out = req->result;
+	rctx->complete = req->base.complete;
+	rctx->tag.cpu = smp_processor_id();
 
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_final(mcryptd_req);
+	return crypto_ahash_final(&rctx->areq);
 }
 
 static int sha1_mb_async_digest(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
-
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_digest(mcryptd_req);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *desc = &rctx->areq;
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_ahash *child = ctx->child;
+
+	rctx->out = req->result;
+	rctx->complete = req->base.complete;
+	rctx->tag.cpu = smp_processor_id();
+
+	ahash_request_set_tfm(desc, child);
+	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
+					rctx->complete, &req->base);
+
+	return crypto_ahash_init(desc) ?: crypto_ahash_finup(desc);
 }
 
 static int sha1_mb_async_export(struct ahash_request *req, void *out)
 {
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
-
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	return crypto_ahash_export(mcryptd_req, out);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *desc = &rctx->areq;
+
+	return crypto_ahash_export(desc, out);
 }
 
 static int sha1_mb_async_import(struct ahash_request *req, const void *in)
 {
-	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
-	struct crypto_ahash *child = mcryptd_ahash_child(mcryptd_tfm);
-	struct mcryptd_hash_request_ctx *rctx;
-	struct ahash_request *areq;
-
-	memcpy(mcryptd_req, req, sizeof(*req));
-	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
-	rctx = ahash_request_ctx(mcryptd_req);
-	areq = &rctx->areq;
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct ahash_request *desc = &rctx->areq;
+	struct sha1_mb_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_ahash *child = ctx->child;
 
-	ahash_request_set_tfm(areq, child);
-	ahash_request_set_callback(areq, CRYPTO_TFM_REQ_MAY_SLEEP,
+	ahash_request_set_tfm(desc, child);
+	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
 					rctx->complete, req);
 
-	return crypto_ahash_import(mcryptd_req, in);
+	return crypto_ahash_import(desc, in);
 }
 
-static struct ahash_alg sha1_mb_async_alg = {
-	.init           = sha1_mb_async_init,
-	.update         = sha1_mb_async_update,
-	.final          = sha1_mb_async_final,
-	.finup          = sha1_mb_async_finup,
-	.digest         = sha1_mb_async_digest,
-	.export		= sha1_mb_async_export,
-	.import		= sha1_mb_async_import,
-	.halg = {
-		.digestsize     = SHA1_DIGEST_SIZE,
-		.statesize	= sizeof(struct sha1_hash_ctx),
-		.base = {
-			.cra_name               = "sha1",
-			.cra_driver_name        = "sha1_mb",
-			.cra_priority           = 200,
-			.cra_flags              = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
-			.cra_blocksize          = SHA1_BLOCK_SIZE,
-			.cra_type               = &crypto_ahash_type,
-			.cra_module             = THIS_MODULE,
-			.cra_list               = LIST_HEAD_INIT(sha1_mb_async_alg.halg.base.cra_list),
-			.cra_init               = sha1_mb_async_init_tfm,
-			.cra_exit               = sha1_mb_async_exit_tfm,
-			.cra_ctxsize		= sizeof(struct sha1_mb_ctx),
-			.cra_alignmask		= 0,
-		},
-	},
-};
+static struct ahash_alg *simd_ahash_create_compat(const char *algname,
+						       const char *drvname,
+						       const char *basename)
+{
+	struct ahash_alg *alg;
+	struct ahash_alg *ialg;
+	int err;
+
+	tfm_compact = crypto_alloc_ahash(basename,
+					CRYPTO_ALG_INTERNAL,
+					CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(tfm_compact))
+		return ERR_CAST(tfm_compact);
+
+	ialg = container_of(crypto_hash_alg_common(tfm_compact),
+						struct ahash_alg, halg);
+
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
+	if (!alg) {
+		alg = ERR_PTR(-ENOMEM);
+		goto out_put_tfm;
+	}
+
+	err = -ENAMETOOLONG;
+	if (snprintf(alg->halg.base.cra_name, CRYPTO_MAX_ALG_NAME, "%s",
+				algname) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_alg;
+
+	if (snprintf(alg->halg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		drvname) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_alg;
+
+	alg->halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->halg.base.cra_priority = ialg->halg.base.cra_priority + 50;
+	alg->halg.base.cra_blocksize = ialg->halg.base.cra_blocksize;
+	alg->halg.base.cra_alignmask = ialg->halg.base.cra_alignmask;
+	alg->halg.base.cra_module = ialg->halg.base.cra_module;
+	alg->halg.base.cra_ctxsize = sizeof(struct sha1_mb_ctx);
+	alg->halg.digestsize	= ialg->halg.digestsize;
+	alg->halg.statesize	= ialg->halg.statesize;
+	alg->halg.base.cra_init	= sha1_mb_async_init_tfm;
+	alg->halg.base.cra_exit = sha1_mb_async_exit_tfm;
+
+	alg->init   = sha1_mb_async_init;
+	alg->update = sha1_mb_async_update,
+	alg->final  = sha1_mb_async_final,
+	alg->finup  = sha1_mb_async_finup,
+	alg->digest = sha1_mb_async_digest,
+	alg->export = sha1_mb_async_export,
+	alg->import = sha1_mb_async_import,
+
+	err = crypto_register_ahash(alg);
+	if (err)
+		goto out_free_alg;
+
+out_put_tfm:
+	crypto_unregister_ahash(alg);
+	return alg;
+
+out_free_alg:
+	kfree(alg);
+	alg = ERR_PTR(err);
+	goto out_put_tfm;
+}
 
 static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 {
@@ -945,12 +1016,17 @@ static unsigned long sha1_mb_flusher(struct mcryptd_alg_cstate *cstate)
 	return next_flush;
 }
 
+struct ahash_alg *sha1_mb_async_alg;
 static int __init sha1_mb_mod_init(void)
 {
 
 	int cpu;
 	int err;
 	struct mcryptd_alg_cstate *cpu_state;
+	const char *basename;
+	const char *algname;
+	const char *drvname;
+	struct mcryptd_flush_list *flist;
 
 	/* check for dependent cpu features */
 	if (!boot_cpu_has(X86_FEATURE_AVX2) ||
@@ -982,21 +1058,32 @@ static int __init sha1_mb_mod_init(void)
 		sha1_ctx_mgr_init(cpu_state->mgr);
 		INIT_LIST_HEAD(&cpu_state->work_list);
 		spin_lock_init(&cpu_state->work_lock);
+		flist = per_cpu_ptr(mcryptd_flist, cpu);
+		INIT_LIST_HEAD(&flist->list);
+		mutex_init(&flist->lock);
 	}
 	sha1_mb_alg_state.flusher = &sha1_mb_flusher;
-
 	err = crypto_register_ahash(&sha1_mb_areq_alg);
 	if (err)
 		goto err2;
-	err = crypto_register_ahash(&sha1_mb_async_alg);
-	if (err)
-		goto err1;
 
+	algname = sha1_mb_areq_alg.halg.base.cra_name + 2;
+	drvname = sha1_mb_areq_alg.halg.base.cra_driver_name + 2;
+	basename = sha1_mb_areq_alg.halg.base.cra_driver_name;
+
+	sha1_mb_async_alg = simd_ahash_create_compat(algname,
+						drvname, basename);
+
+	err = PTR_ERR(sha1_mb_async_alg);
+	if (IS_ERR(sha1_mb_async_alg))
+		goto err1;
 
 	return 0;
 err1:
-	crypto_unregister_ahash(&sha1_mb_areq_alg);
+	crypto_unregister_ahash(sha1_mb_async_alg);
+	kfree(sha1_mb_async_alg);
 err2:
+	crypto_unregister_ahash(&sha1_mb_areq_alg);
 	for_each_possible_cpu(cpu) {
 		cpu_state = per_cpu_ptr(sha1_mb_alg_state.alg_cstate, cpu);
 		kfree(cpu_state->mgr);
@@ -1010,12 +1097,13 @@ static void __exit sha1_mb_mod_fini(void)
 	int cpu;
 	struct mcryptd_alg_cstate *cpu_state;
 
-	crypto_unregister_ahash(&sha1_mb_async_alg);
+	crypto_unregister_ahash(sha1_mb_async_alg);
 	crypto_unregister_ahash(&sha1_mb_areq_alg);
 	for_each_possible_cpu(cpu) {
 		cpu_state = per_cpu_ptr(sha1_mb_alg_state.alg_cstate, cpu);
 		kfree(cpu_state->mgr);
 	}
+	free_percpu(mcryptd_flist);
 	free_percpu(sha1_mb_alg_state.alg_cstate);
 }
 
diff --git a/crypto/Makefile b/crypto/Makefile
index d674884..e2a03e0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
-obj-$(CONFIG_CRYPTO_MCRYPTD) += mcryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
deleted file mode 100644
index eca04d3..0000000
--- a/crypto/mcryptd.c
+++ /dev/null
@@ -1,702 +0,0 @@
-/*
- * Software multibuffer async crypto daemon.
- *
- * Copyright (c) 2014 Tim Chen <tim.c.chen@linux.intel.com>
- *
- * Adapted from crypto daemon.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/aead.h>
-#include <crypto/mcryptd.h>
-#include <crypto/crypto_wq.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <linux/sched.h>
-#include <linux/sched/stat.h>
-#include <linux/slab.h>
-#include <linux/hardirq.h>
-
-#define MCRYPTD_MAX_CPU_QLEN 100
-#define MCRYPTD_BATCH 9
-
-static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
-				   unsigned int tail);
-
-struct mcryptd_flush_list {
-	struct list_head list;
-	struct mutex lock;
-};
-
-static struct mcryptd_flush_list __percpu *mcryptd_flist;
-
-struct hashd_instance_ctx {
-	struct crypto_ahash_spawn spawn;
-	struct mcryptd_queue *queue;
-};
-
-static void mcryptd_queue_worker(struct work_struct *work);
-
-void mcryptd_arm_flusher(struct mcryptd_alg_cstate *cstate, unsigned long delay)
-{
-	struct mcryptd_flush_list *flist;
-
-	if (!cstate->flusher_engaged) {
-		/* put the flusher on the flush list */
-		flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
-		mutex_lock(&flist->lock);
-		list_add_tail(&cstate->flush_list, &flist->list);
-		cstate->flusher_engaged = true;
-		cstate->next_flush = jiffies + delay;
-		queue_delayed_work_on(smp_processor_id(), kcrypto_wq,
-			&cstate->flush, delay);
-		mutex_unlock(&flist->lock);
-	}
-}
-EXPORT_SYMBOL(mcryptd_arm_flusher);
-
-static int mcryptd_init_queue(struct mcryptd_queue *queue,
-			     unsigned int max_cpu_qlen)
-{
-	int cpu;
-	struct mcryptd_cpu_queue *cpu_queue;
-
-	queue->cpu_queue = alloc_percpu(struct mcryptd_cpu_queue);
-	pr_debug("mqueue:%p mcryptd_cpu_queue %p\n", queue, queue->cpu_queue);
-	if (!queue->cpu_queue)
-		return -ENOMEM;
-	for_each_possible_cpu(cpu) {
-		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
-		pr_debug("cpu_queue #%d %p\n", cpu, queue->cpu_queue);
-		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
-		INIT_WORK(&cpu_queue->work, mcryptd_queue_worker);
-		spin_lock_init(&cpu_queue->q_lock);
-	}
-	return 0;
-}
-
-static void mcryptd_fini_queue(struct mcryptd_queue *queue)
-{
-	int cpu;
-	struct mcryptd_cpu_queue *cpu_queue;
-
-	for_each_possible_cpu(cpu) {
-		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
-		BUG_ON(cpu_queue->queue.qlen);
-	}
-	free_percpu(queue->cpu_queue);
-}
-
-static int mcryptd_enqueue_request(struct mcryptd_queue *queue,
-				  struct crypto_async_request *request,
-				  struct mcryptd_hash_request_ctx *rctx)
-{
-	int cpu, err;
-	struct mcryptd_cpu_queue *cpu_queue;
-
-	cpu_queue = raw_cpu_ptr(queue->cpu_queue);
-	spin_lock(&cpu_queue->q_lock);
-	cpu = smp_processor_id();
-	rctx->tag.cpu = smp_processor_id();
-
-	err = crypto_enqueue_request(&cpu_queue->queue, request);
-	pr_debug("enqueue request: cpu %d cpu_queue %p request %p\n",
-		 cpu, cpu_queue, request);
-	spin_unlock(&cpu_queue->q_lock);
-	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
-
-	return err;
-}
-
-/*
- * Try to opportunisticlly flush the partially completed jobs if
- * crypto daemon is the only task running.
- */
-static void mcryptd_opportunistic_flush(void)
-{
-	struct mcryptd_flush_list *flist;
-	struct mcryptd_alg_cstate *cstate;
-
-	flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
-	while (single_task_running()) {
-		mutex_lock(&flist->lock);
-		cstate = list_first_entry_or_null(&flist->list,
-				struct mcryptd_alg_cstate, flush_list);
-		if (!cstate || !cstate->flusher_engaged) {
-			mutex_unlock(&flist->lock);
-			return;
-		}
-		list_del(&cstate->flush_list);
-		cstate->flusher_engaged = false;
-		mutex_unlock(&flist->lock);
-		cstate->alg_state->flusher(cstate);
-	}
-}
-
-/*
- * Called in workqueue context, do one real cryption work (via
- * req->complete) and reschedule itself if there are more work to
- * do.
- */
-static void mcryptd_queue_worker(struct work_struct *work)
-{
-	struct mcryptd_cpu_queue *cpu_queue;
-	struct crypto_async_request *req, *backlog;
-	int i;
-
-	/*
-	 * Need to loop through more than once for multi-buffer to
-	 * be effective.
-	 */
-
-	cpu_queue = container_of(work, struct mcryptd_cpu_queue, work);
-	i = 0;
-	while (i < MCRYPTD_BATCH || single_task_running()) {
-
-		spin_lock_bh(&cpu_queue->q_lock);
-		backlog = crypto_get_backlog(&cpu_queue->queue);
-		req = crypto_dequeue_request(&cpu_queue->queue);
-		spin_unlock_bh(&cpu_queue->q_lock);
-
-		if (!req) {
-			mcryptd_opportunistic_flush();
-			return;
-		}
-
-		if (backlog)
-			backlog->complete(backlog, -EINPROGRESS);
-		req->complete(req, 0);
-		if (!cpu_queue->queue.qlen)
-			return;
-		++i;
-	}
-	if (cpu_queue->queue.qlen)
-		queue_work_on(smp_processor_id(), kcrypto_wq, &cpu_queue->work);
-}
-
-void mcryptd_flusher(struct work_struct *__work)
-{
-	struct	mcryptd_alg_cstate	*alg_cpu_state;
-	struct	mcryptd_alg_state	*alg_state;
-	struct	mcryptd_flush_list	*flist;
-	int	cpu;
-
-	cpu = smp_processor_id();
-	alg_cpu_state = container_of(to_delayed_work(__work),
-				     struct mcryptd_alg_cstate, flush);
-	alg_state = alg_cpu_state->alg_state;
-	if (alg_cpu_state->cpu != cpu)
-		pr_debug("mcryptd error: work on cpu %d, should be cpu %d\n",
-				cpu, alg_cpu_state->cpu);
-
-	if (alg_cpu_state->flusher_engaged) {
-		flist = per_cpu_ptr(mcryptd_flist, cpu);
-		mutex_lock(&flist->lock);
-		list_del(&alg_cpu_state->flush_list);
-		alg_cpu_state->flusher_engaged = false;
-		mutex_unlock(&flist->lock);
-		alg_state->flusher(alg_cpu_state);
-	}
-}
-EXPORT_SYMBOL_GPL(mcryptd_flusher);
-
-static inline struct mcryptd_queue *mcryptd_get_queue(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct mcryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
-
-	return ictx->queue;
-}
-
-static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
-				   unsigned int tail)
-{
-	char *p;
-	struct crypto_instance *inst;
-	int err;
-
-	p = kzalloc(head + sizeof(*inst) + tail, GFP_KERNEL);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	inst = (void *)(p + head);
-
-	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		    "mcryptd(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
-		goto out_free_inst;
-
-	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
-
-	inst->alg.cra_priority = alg->cra_priority + 50;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-
-out:
-	return p;
-
-out_free_inst:
-	kfree(p);
-	p = ERR_PTR(err);
-	goto out;
-}
-
-static inline bool mcryptd_check_internal(struct rtattr **tb, u32 *type,
-					  u32 *mask)
-{
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return false;
-
-	*type |= algt->type & CRYPTO_ALG_INTERNAL;
-	*mask |= algt->mask & CRYPTO_ALG_INTERNAL;
-
-	if (*type & *mask & CRYPTO_ALG_INTERNAL)
-		return true;
-	else
-		return false;
-}
-
-static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct hashd_instance_ctx *ictx = crypto_instance_ctx(inst);
-	struct crypto_ahash_spawn *spawn = &ictx->spawn;
-	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_ahash *hash;
-
-	hash = crypto_spawn_ahash(spawn);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
-
-	ctx->child = hash;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct mcryptd_hash_request_ctx) +
-				 crypto_ahash_reqsize(hash));
-	return 0;
-}
-
-static void mcryptd_hash_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	crypto_free_ahash(ctx->child);
-}
-
-static int mcryptd_hash_setkey(struct crypto_ahash *parent,
-				   const u8 *key, unsigned int keylen)
-{
-	struct mcryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
-	struct crypto_ahash *child = ctx->child;
-	int err;
-
-	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(child, crypto_ahash_get_flags(parent) &
-				      CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(child, key, keylen);
-	crypto_ahash_set_flags(parent, crypto_ahash_get_flags(child) &
-				       CRYPTO_TFM_RES_MASK);
-	return err;
-}
-
-static int mcryptd_hash_enqueue(struct ahash_request *req,
-				crypto_completion_t complete)
-{
-	int ret;
-
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct mcryptd_queue *queue =
-		mcryptd_get_queue(crypto_ahash_tfm(tfm));
-
-	rctx->complete = req->base.complete;
-	req->base.complete = complete;
-
-	ret = mcryptd_enqueue_request(queue, &req->base, rctx);
-
-	return ret;
-}
-
-static void mcryptd_hash_init(struct crypto_async_request *req_async, int err)
-{
-	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_ahash *child = ctx->child;
-	struct ahash_request *req = ahash_request_cast(req_async);
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct ahash_request *desc = &rctx->areq;
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-
-	ahash_request_set_tfm(desc, child);
-	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
-						rctx->complete, req_async);
-
-	rctx->out = req->result;
-	err = crypto_ahash_init(desc);
-
-out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-}
-
-static int mcryptd_hash_init_enqueue(struct ahash_request *req)
-{
-	return mcryptd_hash_enqueue(req, mcryptd_hash_init);
-}
-
-static void mcryptd_hash_update(struct crypto_async_request *req_async, int err)
-{
-	struct ahash_request *req = ahash_request_cast(req_async);
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-
-	rctx->out = req->result;
-	err = ahash_mcryptd_update(&rctx->areq);
-	if (err) {
-		req->base.complete = rctx->complete;
-		goto out;
-	}
-
-	return;
-out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-}
-
-static int mcryptd_hash_update_enqueue(struct ahash_request *req)
-{
-	return mcryptd_hash_enqueue(req, mcryptd_hash_update);
-}
-
-static void mcryptd_hash_final(struct crypto_async_request *req_async, int err)
-{
-	struct ahash_request *req = ahash_request_cast(req_async);
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-
-	rctx->out = req->result;
-	err = ahash_mcryptd_final(&rctx->areq);
-	if (err) {
-		req->base.complete = rctx->complete;
-		goto out;
-	}
-
-	return;
-out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-}
-
-static int mcryptd_hash_final_enqueue(struct ahash_request *req)
-{
-	return mcryptd_hash_enqueue(req, mcryptd_hash_final);
-}
-
-static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
-{
-	struct ahash_request *req = ahash_request_cast(req_async);
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-	rctx->out = req->result;
-	err = ahash_mcryptd_finup(&rctx->areq);
-
-	if (err) {
-		req->base.complete = rctx->complete;
-		goto out;
-	}
-
-	return;
-out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-}
-
-static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
-{
-	return mcryptd_hash_enqueue(req, mcryptd_hash_finup);
-}
-
-static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
-{
-	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
-	struct crypto_ahash *child = ctx->child;
-	struct ahash_request *req = ahash_request_cast(req_async);
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	struct ahash_request *desc = &rctx->areq;
-
-	if (unlikely(err == -EINPROGRESS))
-		goto out;
-
-	ahash_request_set_tfm(desc, child);
-	ahash_request_set_callback(desc, CRYPTO_TFM_REQ_MAY_SLEEP,
-						rctx->complete, req_async);
-
-	rctx->out = req->result;
-	err = ahash_mcryptd_digest(desc);
-
-out:
-	local_bh_disable();
-	rctx->complete(&req->base, err);
-	local_bh_enable();
-}
-
-static int mcryptd_hash_digest_enqueue(struct ahash_request *req)
-{
-	return mcryptd_hash_enqueue(req, mcryptd_hash_digest);
-}
-
-static int mcryptd_hash_export(struct ahash_request *req, void *out)
-{
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-
-	return crypto_ahash_export(&rctx->areq, out);
-}
-
-static int mcryptd_hash_import(struct ahash_request *req, const void *in)
-{
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-
-	return crypto_ahash_import(&rctx->areq, in);
-}
-
-static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
-			      struct mcryptd_queue *queue)
-{
-	struct hashd_instance_ctx *ctx;
-	struct ahash_instance *inst;
-	struct hash_alg_common *halg;
-	struct crypto_alg *alg;
-	u32 type = 0;
-	u32 mask = 0;
-	int err;
-
-	if (!mcryptd_check_internal(tb, &type, &mask))
-		return -EINVAL;
-
-	halg = ahash_attr_alg(tb[1], type, mask);
-	if (IS_ERR(halg))
-		return PTR_ERR(halg);
-
-	alg = &halg->base;
-	pr_debug("crypto: mcryptd hash alg: %s\n", alg->cra_name);
-	inst = mcryptd_alloc_instance(alg, ahash_instance_headroom(),
-					sizeof(*ctx));
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	ctx = ahash_instance_ctx(inst);
-	ctx->queue = queue;
-
-	err = crypto_init_ahash_spawn(&ctx->spawn, halg,
-				      ahash_crypto_instance(inst));
-	if (err)
-		goto out_free_inst;
-
-	type = CRYPTO_ALG_ASYNC;
-	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
-		type |= CRYPTO_ALG_INTERNAL;
-	inst->alg.halg.base.cra_flags = type;
-
-	inst->alg.halg.digestsize = halg->digestsize;
-	inst->alg.halg.statesize = halg->statesize;
-	inst->alg.halg.base.cra_ctxsize = sizeof(struct mcryptd_hash_ctx);
-
-	inst->alg.halg.base.cra_init = mcryptd_hash_init_tfm;
-	inst->alg.halg.base.cra_exit = mcryptd_hash_exit_tfm;
-
-	inst->alg.init   = mcryptd_hash_init_enqueue;
-	inst->alg.update = mcryptd_hash_update_enqueue;
-	inst->alg.final  = mcryptd_hash_final_enqueue;
-	inst->alg.finup  = mcryptd_hash_finup_enqueue;
-	inst->alg.export = mcryptd_hash_export;
-	inst->alg.import = mcryptd_hash_import;
-	inst->alg.setkey = mcryptd_hash_setkey;
-	inst->alg.digest = mcryptd_hash_digest_enqueue;
-
-	err = ahash_register_instance(tmpl, inst);
-	if (err) {
-		crypto_drop_ahash(&ctx->spawn);
-out_free_inst:
-		kfree(inst);
-	}
-
-out_put_alg:
-	crypto_mod_put(alg);
-	return err;
-}
-
-static struct mcryptd_queue mqueue;
-
-static int mcryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_DIGEST:
-		return mcryptd_create_hash(tmpl, tb, &mqueue);
-	break;
-	}
-
-	return -EINVAL;
-}
-
-static void mcryptd_free(struct crypto_instance *inst)
-{
-	struct mcryptd_instance_ctx *ctx = crypto_instance_ctx(inst);
-	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
-
-	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
-	case CRYPTO_ALG_TYPE_AHASH:
-		crypto_drop_ahash(&hctx->spawn);
-		kfree(ahash_instance(inst));
-		return;
-	default:
-		crypto_drop_spawn(&ctx->spawn);
-		kfree(inst);
-	}
-}
-
-static struct crypto_template mcryptd_tmpl = {
-	.name = "mcryptd",
-	.create = mcryptd_create,
-	.free = mcryptd_free,
-	.module = THIS_MODULE,
-};
-
-struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
-					u32 type, u32 mask)
-{
-	char mcryptd_alg_name[CRYPTO_MAX_ALG_NAME];
-	struct crypto_ahash *tfm;
-
-	if (snprintf(mcryptd_alg_name, CRYPTO_MAX_ALG_NAME,
-		     "mcryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
-		return ERR_PTR(-EINVAL);
-	tfm = crypto_alloc_ahash(mcryptd_alg_name, type, mask);
-	if (IS_ERR(tfm))
-		return ERR_CAST(tfm);
-	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
-		crypto_free_ahash(tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	return __mcryptd_ahash_cast(tfm);
-}
-EXPORT_SYMBOL_GPL(mcryptd_alloc_ahash);
-
-int ahash_mcryptd_digest(struct ahash_request *desc)
-{
-	return crypto_ahash_init(desc) ?: ahash_mcryptd_finup(desc);
-}
-
-int ahash_mcryptd_update(struct ahash_request *desc)
-{
-	/* alignment is to be done by multi-buffer crypto algorithm if needed */
-
-	return crypto_ahash_update(desc);
-}
-
-int ahash_mcryptd_finup(struct ahash_request *desc)
-{
-	/* alignment is to be done by multi-buffer crypto algorithm if needed */
-
-	return crypto_ahash_finup(desc);
-}
-
-int ahash_mcryptd_final(struct ahash_request *desc)
-{
-	/* alignment is to be done by multi-buffer crypto algorithm if needed */
-
-	return crypto_ahash_final(desc);
-}
-
-struct crypto_ahash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
-{
-	struct mcryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
-
-	return ctx->child;
-}
-EXPORT_SYMBOL_GPL(mcryptd_ahash_child);
-
-struct ahash_request *mcryptd_ahash_desc(struct ahash_request *req)
-{
-	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
-	return &rctx->areq;
-}
-EXPORT_SYMBOL_GPL(mcryptd_ahash_desc);
-
-void mcryptd_free_ahash(struct mcryptd_ahash *tfm)
-{
-	crypto_free_ahash(&tfm->base);
-}
-EXPORT_SYMBOL_GPL(mcryptd_free_ahash);
-
-static int __init mcryptd_init(void)
-{
-	int err, cpu;
-	struct mcryptd_flush_list *flist;
-
-	mcryptd_flist = alloc_percpu(struct mcryptd_flush_list);
-	for_each_possible_cpu(cpu) {
-		flist = per_cpu_ptr(mcryptd_flist, cpu);
-		INIT_LIST_HEAD(&flist->list);
-		mutex_init(&flist->lock);
-	}
-
-	err = mcryptd_init_queue(&mqueue, MCRYPTD_MAX_CPU_QLEN);
-	if (err) {
-		free_percpu(mcryptd_flist);
-		return err;
-	}
-
-	err = crypto_register_template(&mcryptd_tmpl);
-	if (err) {
-		mcryptd_fini_queue(&mqueue);
-		free_percpu(mcryptd_flist);
-	}
-
-	return err;
-}
-
-static void __exit mcryptd_exit(void)
-{
-	mcryptd_fini_queue(&mqueue);
-	crypto_unregister_template(&mcryptd_tmpl);
-	free_percpu(mcryptd_flist);
-}
-
-subsys_initcall(mcryptd_init);
-module_exit(mcryptd_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Software async multibuffer crypto daemon");
-MODULE_ALIAS_CRYPTO("mcryptd");
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
index b67404f..6e163de 100644
--- a/include/crypto/mcryptd.h
+++ b/include/crypto/mcryptd.h
@@ -40,11 +40,6 @@ struct mcryptd_instance_ctx {
 	struct mcryptd_queue *queue;
 };
 
-struct mcryptd_hash_ctx {
-	struct crypto_ahash *child;
-	struct mcryptd_alg_state *alg_state;
-};
-
 struct mcryptd_tag {
 	/* seq number of request */
 	unsigned seq_num;
-- 
1.9.1
