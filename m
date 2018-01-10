From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH V8 1/5] crypto: Multi-buffer encryption infrastructure support
Date: Tue,  9 Jan 2018 16:09:04 -0800
Message-ID: <1515542948-24041-2-git-send-email-megha.dey@linux.intel.com>
References: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
Cc: megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515542948-24041-1-git-send-email-megha.dey@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In this patch, the infrastructure needed to support multibuffer
encryption implementation is added:

a) Enhance mcryptd daemon to support skcipher requests.

b) Add multi-buffer mcryptd skcipher helper which presents the
   top-level algorithm as an skcipher.

b) Update configuration to include multi-buffer encryption build
support.

For an introduction to the multi-buffer implementation, please see
http://www.intel.com/content/www/us/en/communications/communications-ia-multi-buffer-paper.html

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Kconfig           |  15 ++
 crypto/mcryptd.c         | 475 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/mcryptd.h |  56 ++++++
 3 files changed, 546 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9327fbf..66bd682 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1021,6 +1021,21 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, PCBC, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config CRYPTO_AES_CBC_MB
+        tristate "AES CBC algorithm (x86_64 Multi-Buffer, Experimental)"
+        depends on X86 && 64BIT
+        select CRYPTO_SIMD
+        select CRYPTO_MCRYPTD
+        help
+          AES CBC encryption implemented using multi-buffer technique.
+          This algorithm computes on multiple data lanes concurrently with
+          SIMD instructions for better throughput. It should only be used
+          when we expect many concurrent crypto requests to keep all the
+          data lanes filled to realize the performance benefit. If the data
+          lanes are unfilled, a flush operation will be initiated after some
+          delay to process the exisiting crypto jobs, adding some extra
+          latency to low load case.
+
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 2908382..ce502e2 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -269,6 +269,443 @@ static inline bool mcryptd_check_internal(struct rtattr **tb, u32 *type,
 		return false;
 }
 
+static int mcryptd_enqueue_skcipher_request(struct mcryptd_queue *queue,
+				struct crypto_async_request *request,
+				struct mcryptd_skcipher_request_ctx *rctx)
+{
+	int cpu, err;
+	struct mcryptd_cpu_queue *cpu_queue;
+
+	cpu = get_cpu();
+	cpu_queue = this_cpu_ptr(queue->cpu_queue);
+	rctx->tag.cpu = cpu;
+
+	err = crypto_enqueue_request(&cpu_queue->queue, request);
+	pr_debug("enqueue request: cpu %d cpu_queue %p request %p\n",
+		cpu, cpu_queue, request);
+	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+	put_cpu();
+
+	return err;
+}
+
+static int mcryptd_skcipher_setkey(struct crypto_skcipher *parent,
+				const u8 *key, unsigned int keylen)
+{
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
+	int err;
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+						CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
+						CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static void mcryptd_skcipher_complete(struct skcipher_request *req, int err)
+{
+	struct mcryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static void mcryptd_skcipher_encrypt(struct crypto_async_request *base,
+								int err)
+{
+	struct skcipher_request *req = skcipher_request_cast(base);
+	struct mcryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	struct skcipher_request subreq;
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	/* set up the skcipher request to work on */
+	skcipher_request_set_tfm(&subreq, child);
+	skcipher_request_set_callback(&subreq,
+					CRYPTO_TFM_REQ_MAY_SLEEP, 0, 0);
+	skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					req->cryptlen, req->iv);
+
+	/*
+	 * pass addr of descriptor stored in the request context
+	 * so that the callee can get to the request context
+	 */
+	rctx->desc = subreq;
+	err = crypto_skcipher_encrypt(&rctx->desc);
+
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+	return;
+
+out:
+	mcryptd_skcipher_complete(req, err);
+}
+
+static void mcryptd_skcipher_decrypt(struct crypto_async_request *base,
+								int err)
+{
+	struct skcipher_request *req = skcipher_request_cast(base);
+	struct mcryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = ctx->child;
+	struct skcipher_request subreq;
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	/* set up the skcipher request to work on */
+	skcipher_request_set_tfm(&subreq, child);
+	skcipher_request_set_callback(&subreq,
+				CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	skcipher_request_set_crypt(&subreq, req->src, req->dst,
+						req->cryptlen, req->iv);
+
+	/*
+	 * pass addr of descriptor stored in the request context
+	 * so that the callee can get to the request context
+	 */
+	rctx->desc = subreq;
+	err = crypto_skcipher_decrypt(&rctx->desc);
+
+	if (err) {
+		req->base.complete = rctx->complete;
+	goto out;
+	}
+	return;
+
+out:
+	mcryptd_skcipher_complete(req, err);
+}
+
+static int mcryptd_skcipher_enqueue(struct skcipher_request *req,
+					crypto_completion_t complete)
+{
+	struct mcryptd_skcipher_request_ctx *rctx =
+					skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct mcryptd_queue *queue;
+
+	queue = mcryptd_get_queue(crypto_skcipher_tfm(tfm));
+	rctx->complete = req->base.complete;
+	req->base.complete = complete;
+
+	return mcryptd_enqueue_skcipher_request(queue, &req->base, rctx);
+}
+
+static int mcryptd_skcipher_encrypt_enqueue(struct skcipher_request *req)
+{
+	return mcryptd_skcipher_enqueue(req, mcryptd_skcipher_encrypt);
+}
+
+static int mcryptd_skcipher_decrypt_enqueue(struct skcipher_request *req)
+{
+	return mcryptd_skcipher_enqueue(req, mcryptd_skcipher_decrypt);
+}
+
+static int mcryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct mskcipherd_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct crypto_skcipher_spawn *spawn = &ictx->spawn;
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *cipher;
+
+	cipher = crypto_spawn_skcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	crypto_skcipher_set_reqsize(tfm,
+			sizeof(struct mcryptd_skcipher_request_ctx));
+	return 0;
+}
+
+static void mcryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
+}
+
+static void mcryptd_skcipher_free(struct skcipher_instance *inst)
+{
+	struct mskcipherd_instance_ctx *ctx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ctx->spawn);
+}
+
+static int mcryptd_init_instance(struct crypto_instance *inst,
+					struct crypto_alg *alg)
+{
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		"mcryptd(%s)",
+			alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+	inst->alg.cra_priority = alg->cra_priority + 50;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+
+	return 0;
+}
+
+static int mcryptd_create_skcipher(struct crypto_template *tmpl,
+				   struct rtattr **tb,
+				   struct mcryptd_queue *queue)
+{
+	struct mskcipherd_instance_ctx *ctx;
+	struct skcipher_instance *inst;
+	struct skcipher_alg *alg;
+	const char *name;
+	u32 type;
+	u32 mask;
+	int err;
+
+	type = CRYPTO_ALG_ASYNC;
+	mask = CRYPTO_ALG_ASYNC;
+
+	mcryptd_check_internal(tb, &type, &mask);
+
+	name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ctx = skcipher_instance_ctx(inst);
+	ctx->queue = queue;
+
+	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher(&ctx->spawn, name, type, mask);
+
+	if (err)
+		goto out_free_inst;
+
+	alg = crypto_spawn_skcipher_alg(&ctx->spawn);
+	err = mcryptd_init_instance(skcipher_crypto_instance(inst), &alg->base);
+	if (err)
+		goto out_drop_skcipher;
+
+	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
+				(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+
+	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+
+	inst->alg.base.cra_ctxsize = sizeof(struct mcryptd_skcipher_ctx);
+
+	inst->alg.init = mcryptd_skcipher_init_tfm;
+	inst->alg.exit = mcryptd_skcipher_exit_tfm;
+
+	inst->alg.setkey = mcryptd_skcipher_setkey;
+	inst->alg.encrypt = mcryptd_skcipher_encrypt_enqueue;
+	inst->alg.decrypt = mcryptd_skcipher_decrypt_enqueue;
+
+	inst->free = mcryptd_skcipher_free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err) {
+out_drop_skcipher:
+		crypto_drop_skcipher(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+	return err;
+}
+
+static int mcryptd_skcipher_setkey_mb(struct crypto_skcipher *tfm,
+				      const u8 *key,
+				      unsigned int key_len)
+{
+	struct mcryptd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child = &ctx->mcryptd_tfm->base;
+	int err;
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(tfm) &
+					CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(child, key, key_len);
+	crypto_skcipher_set_flags(tfm, crypto_skcipher_get_flags(child) &
+					CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int mcryptd_skcipher_decrypt_mb(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct mcryptd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_request_ctx(req);
+	*subreq = *req;
+
+	child = &ctx->mcryptd_tfm->base;
+
+	skcipher_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_decrypt(subreq);
+}
+
+static int mcryptd_skcipher_encrypt_mb(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct mcryptd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_request *subreq;
+	struct crypto_skcipher *child;
+
+	subreq = skcipher_request_ctx(req);
+	*subreq = *req;
+
+	child = &ctx->mcryptd_tfm->base;
+
+	skcipher_request_set_tfm(subreq, child);
+
+	return crypto_skcipher_encrypt(subreq);
+}
+
+static void mcryptd_skcipher_exit_mb(struct crypto_skcipher *tfm)
+{
+	struct mcryptd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
+
+	mcryptd_free_skcipher(ctx->mcryptd_tfm);
+}
+
+static int mcryptd_skcipher_init_mb(struct crypto_skcipher *tfm)
+{
+	struct mcryptd_skcipher_ctx_mb *ctx = crypto_skcipher_ctx(tfm);
+	struct mcryptd_skcipher *mcryptd_tfm;
+	struct mcryptd_skcipher_alg_mb *salg;
+	struct skcipher_alg *alg;
+	unsigned int reqsize;
+	struct mcryptd_skcipher_ctx *mctx;
+
+	alg = crypto_skcipher_alg(tfm);
+	salg = container_of(alg, struct mcryptd_skcipher_alg_mb, alg);
+
+	mcryptd_tfm = mcryptd_alloc_skcipher(salg->ialg_name,
+						CRYPTO_ALG_INTERNAL,
+						CRYPTO_ALG_INTERNAL);
+	if (IS_ERR(mcryptd_tfm))
+		return PTR_ERR(mcryptd_tfm);
+
+	mctx = crypto_skcipher_ctx(&mcryptd_tfm->base);
+
+	mctx->alg_state = &cbc_mb_alg_state;
+	ctx->mcryptd_tfm = mcryptd_tfm;
+
+	reqsize = sizeof(struct skcipher_request);
+	reqsize += crypto_skcipher_reqsize(&mcryptd_tfm->base);
+
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
+	return 0;
+}
+struct mcryptd_skcipher_alg_mb *mcryptd_skcipher_create_compat_mb(
+							const char *algname,
+							const char *drvname,
+							const char *basename)
+{
+	struct mcryptd_skcipher_alg_mb *salg;
+	struct crypto_skcipher *tfm;
+	struct skcipher_alg *ialg;
+	struct skcipher_alg *alg;
+	int err;
+
+	tfm = crypto_alloc_skcipher(basename,
+				CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC,
+				CRYPTO_ALG_INTERNAL | CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+
+	ialg = crypto_skcipher_alg(tfm);
+
+	salg = kzalloc(sizeof(*salg), GFP_KERNEL);
+	if (!salg) {
+		salg = ERR_PTR(-ENOMEM);
+		goto out_put_tfm;
+	}
+
+	salg->ialg_name = basename;
+	alg = &salg->alg;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", algname) >=
+							CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+
+	if (snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+						drvname) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_salg;
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC;
+	alg->base.cra_priority = ialg->base.cra_priority;
+	alg->base.cra_blocksize = ialg->base.cra_blocksize;
+	alg->base.cra_alignmask = ialg->base.cra_alignmask;
+	alg->base.cra_module = ialg->base.cra_module;
+	alg->base.cra_ctxsize = sizeof(struct mcryptd_skcipher_ctx_mb);
+
+	alg->ivsize = ialg->ivsize;
+	alg->chunksize = ialg->chunksize;
+	alg->min_keysize = ialg->min_keysize;
+	alg->max_keysize = ialg->max_keysize;
+
+	alg->init = mcryptd_skcipher_init_mb;
+	alg->exit = mcryptd_skcipher_exit_mb;
+
+	alg->setkey = mcryptd_skcipher_setkey_mb;
+	alg->encrypt = mcryptd_skcipher_encrypt_mb;
+	alg->decrypt = mcryptd_skcipher_decrypt_mb;
+	err = crypto_register_skcipher(alg);
+	if (err)
+		goto out_free_salg;
+
+out_put_tfm:
+	crypto_free_skcipher(tfm);
+	return salg;
+
+out_free_salg:
+	kfree(salg);
+	salg = ERR_PTR(err);
+	goto out_put_tfm;
+}
+EXPORT_SYMBOL_GPL(mcryptd_skcipher_create_compat_mb);
+
+struct mcryptd_skcipher_alg_mb *mcryptd_skcipher_create_mb(const char *algname,
+							const char *basename)
+{
+	char drvname[CRYPTO_MAX_ALG_NAME];
+
+	if (snprintf(drvname, CRYPTO_MAX_ALG_NAME, "mcryptd-%s", basename) >=
+							CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	return mcryptd_skcipher_create_compat_mb(algname, drvname, basename);
+}
+EXPORT_SYMBOL_GPL(mcryptd_skcipher_create_mb);
+
+void mcryptd_skcipher_free_mb(struct mcryptd_skcipher_alg_mb *salg)
+{
+	crypto_unregister_skcipher(&salg->alg);
+	kfree(salg);
+}
+EXPORT_SYMBOL_GPL(mcryptd_skcipher_free_mb);
+
 static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
@@ -560,6 +997,8 @@ static int mcryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_BLKCIPHER:
+		return mcryptd_create_skcipher(tmpl, tb, &mqueue);
 	case CRYPTO_ALG_TYPE_DIGEST:
 		return mcryptd_create_hash(tmpl, tb, &mqueue);
 	break;
@@ -591,6 +1030,42 @@ static void mcryptd_free(struct crypto_instance *inst)
 	.module = THIS_MODULE,
 };
 
+struct mcryptd_skcipher *mcryptd_alloc_skcipher(const char *alg_name,
+							u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_skcipher *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		"mcryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm = crypto_alloc_skcipher(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_skcipher(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return container_of(tfm, struct mcryptd_skcipher, base);
+}
+EXPORT_SYMBOL_GPL(mcryptd_alloc_skcipher);
+
+struct crypto_skcipher *mcryptd_skcipher_child(
+			struct mcryptd_skcipher *tfm)
+{
+	struct mcryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
+
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(mcryptd_skcipher_child);
+
+void mcryptd_free_skcipher(struct mcryptd_skcipher *tfm)
+{
+	crypto_free_skcipher(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(mcryptd_free_skcipher);
+
 struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask)
 {
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
index b67404f..ff0f968 100644
--- a/include/crypto/mcryptd.h
+++ b/include/crypto/mcryptd.h
@@ -14,6 +14,49 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <crypto/hash.h>
+#include <crypto/b128ops.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/hash.h>
+
+static struct mcryptd_alg_state cbc_mb_alg_state;
+
+struct mcryptd_skcipher_ctx_mb {
+	struct mcryptd_skcipher *mcryptd_tfm;
+};
+
+struct mcryptd_skcipher_alg_mb {
+	const char *ialg_name;
+	struct skcipher_alg alg;
+};
+
+struct mskcipherd_instance_ctx {
+	struct crypto_skcipher_spawn spawn;
+	struct mcryptd_queue *queue;
+};
+
+struct mcryptd_skcipher_alg_mb *mcryptd_skcipher_create_mb(const char *algname,
+							const char *basename);
+
+void mcryptd_skcipher_free_mb(struct mcryptd_skcipher_alg_mb *alg);
+
+struct mcryptd_skcipher_alg_mb *mcryptd_skcipher_create_compat_mb(
+							const char *algname,
+							const char *drvname,
+							const char *basename);
+
+struct mcryptd_skcipher_ctx {
+	struct crypto_skcipher *child;
+	struct mcryptd_alg_state *alg_state;
+};
+
+struct mcryptd_skcipher {
+	struct crypto_skcipher base;
+};
+
+struct mcryptd_skcipher *mcryptd_alloc_skcipher(const char *alg_name,
+					      u32 type, u32 mask);
+struct crypto_skcipher *mcryptd_skcipher_child(struct mcryptd_skcipher *tfm);
+void mcryptd_free_skcipher(struct mcryptd_skcipher *tfm);
 
 struct mcryptd_ahash {
 	struct crypto_ahash base;
@@ -64,6 +107,19 @@ struct mcryptd_hash_request_ctx {
 	struct ahash_request areq;
 };
 
+struct mcryptd_skcipher_request_ctx {
+	struct list_head waiter;
+	crypto_completion_t complete;
+	struct mcryptd_tag tag;
+	struct skcipher_walk walk;
+	u8 flag;
+	int nbytes;
+	int error;
+	struct skcipher_request desc;
+	void *job;
+	u128 seq_iv;
+};
+
 struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask);
 struct crypto_ahash *mcryptd_ahash_child(struct mcryptd_ahash *tfm);
-- 
1.9.1
