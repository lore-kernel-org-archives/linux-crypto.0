From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v4 1/5] crypto: Multi-buffer encryption infrastructure
 support
Date: Wed, 02 Dec 2015 12:02:03 -0800
Message-ID: <1449086523.22260.11.camel@schen9-desk2.jf.intel.com>
References: <cover.1449091633.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbbLBUCF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Dec 2015 15:02:05 -0500
In-Reply-To: <cover.1449091633.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


In this patch, the infrastructure needed to support multibuffer
encryption implementation is added:

a) Enhace mcryptd daemon to support blkcipher requests.

b) Update configuration to include multi-buffer encryption build support.

For an introduction to the multi-buffer implementation, please see
http://www.intel.com/content/www/us/en/communications/communications-ia-multi-buffer-paper.html

Originally-by: Chandramouli Narayanan <mouli_7982@yahoo.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Kconfig           |  16 +++
 crypto/mcryptd.c         | 256 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/algapi.h  |   1 +
 include/crypto/mcryptd.h |  36 +++++++
 4 files changed, 308 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7240821..6b51084 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -888,6 +888,22 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, PCBC, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config CRYPTO_AES_CBC_MB
+	tristate "AES CBC algorithm (x86_64 Multi-Buffer, Experimental)"
+	depends on X86 && 64BIT
+	select CRYPTO_ABLK_HELPER
+	select CRYPTO_MCRYPTD
+	help
+	  AES CBC encryption implemented using multi-buffer technique.
+	  This algorithm computes on multiple data lanes concurrently with
+	  SIMD instructions for better throughput.  It should only be
+	  used when there is significant work to generate many separate
+	  crypto requests that keep all the data lanes filled to get
+	  the performance benefit.  If the data lanes are unfilled, a
+	  flush operation will be initiated after some delay to process
+	  the exisiting crypto jobs, adding some extra latency at low
+	  load case.
+
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index fe5b495a..01f747c 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -116,8 +116,28 @@ static int mcryptd_enqueue_request(struct mcryptd_queue *queue,
 	return err;
 }
 
+static int mcryptd_enqueue_blkcipher_request(struct mcryptd_queue *queue,
+				  struct crypto_async_request *request,
+				  struct mcryptd_blkcipher_request_ctx *rctx)
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
+		 cpu, cpu_queue, request);
+	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+	put_cpu();
+
+	return err;
+}
+
 /*
- * Try to opportunisticlly flush the partially completed jobs if
+ * Try to opportunistically flush the partially completed jobs if
  * crypto daemon is the only task running.
  */
 static void mcryptd_opportunistic_flush(void)
@@ -225,6 +245,130 @@ static inline struct mcryptd_queue *mcryptd_get_queue(struct crypto_tfm *tfm)
 	return ictx->queue;
 }
 
+static int mcryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
+				   const u8 *key, unsigned int keylen)
+{
+	struct mcryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(parent);
+	struct crypto_blkcipher *child = ctx->child;
+	int err;
+
+	crypto_blkcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_blkcipher_set_flags(child, crypto_ablkcipher_get_flags(parent) &
+					  CRYPTO_TFM_REQ_MASK);
+	err = crypto_blkcipher_setkey(child, key, keylen);
+	crypto_ablkcipher_set_flags(parent, crypto_blkcipher_get_flags(child) &
+					    CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static void mcryptd_blkcipher_crypt(struct ablkcipher_request *req,
+				   struct crypto_blkcipher *child,
+				   int err,
+				   int (*crypt)(struct blkcipher_desc *desc,
+						struct scatterlist *dst,
+						struct scatterlist *src,
+						unsigned int len))
+{
+	struct mcryptd_blkcipher_request_ctx *rctx;
+	struct blkcipher_desc desc;
+
+	rctx = ablkcipher_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	/* set up the blkcipher request to work on */
+	desc.tfm = child;
+	desc.info = req->info;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	rctx->desc = desc;
+
+	/*
+	 * pass addr of descriptor stored in the request context
+	 * so that the callee can get to the request context
+	 */
+	err = crypt(&rctx->desc, req->dst, req->src, req->nbytes);
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+	return;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+
+}
+
+static void mcryptd_blkcipher_encrypt(struct crypto_async_request *req, int err)
+{
+	struct mcryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(req->tfm);
+	struct crypto_blkcipher *child = ctx->child;
+
+	mcryptd_blkcipher_crypt(ablkcipher_request_cast(req), child, err,
+			       crypto_blkcipher_crt(child)->encrypt);
+}
+
+static void mcryptd_blkcipher_decrypt(struct crypto_async_request *req, int err)
+{
+	struct mcryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(req->tfm);
+	struct crypto_blkcipher *child = ctx->child;
+
+	mcryptd_blkcipher_crypt(ablkcipher_request_cast(req), child, err,
+			       crypto_blkcipher_crt(child)->decrypt);
+}
+
+static int mcryptd_blkcipher_enqueue(struct ablkcipher_request *req,
+				    crypto_completion_t complete)
+{
+	struct mcryptd_blkcipher_request_ctx *rctx =
+			ablkcipher_request_ctx(req);
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct mcryptd_queue *queue;
+
+	queue = mcryptd_get_queue(crypto_ablkcipher_tfm(tfm));
+	rctx->complete = req->base.complete;
+	req->base.complete = complete;
+
+	return mcryptd_enqueue_blkcipher_request(queue, &req->base, rctx);
+}
+
+static int mcryptd_blkcipher_encrypt_enqueue(struct ablkcipher_request *req)
+{
+	return mcryptd_blkcipher_enqueue(req, mcryptd_blkcipher_encrypt);
+}
+
+static int mcryptd_blkcipher_decrypt_enqueue(struct ablkcipher_request *req)
+{
+	return mcryptd_blkcipher_enqueue(req, mcryptd_blkcipher_decrypt);
+}
+
+static int mcryptd_blkcipher_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct mcryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_spawn *spawn = &ictx->spawn;
+	struct mcryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_blkcipher *cipher;
+
+	cipher = crypto_spawn_blkcipher(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	tfm->crt_ablkcipher.reqsize =
+		sizeof(struct mcryptd_blkcipher_request_ctx);
+	return 0;
+}
+
+static void mcryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct mcryptd_blkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_blkcipher(ctx->child);
+}
+
 static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
 				   unsigned int tail)
 {
@@ -272,6 +416,70 @@ static inline void mcryptd_check_internal(struct rtattr **tb, u32 *type,
 		*mask |= CRYPTO_ALG_INTERNAL;
 }
 
+static int mcryptd_create_blkcipher(struct crypto_template *tmpl,
+				   struct rtattr **tb,
+				   struct mcryptd_queue *queue)
+{
+	struct mcryptd_instance_ctx *ctx;
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
+	int err;
+
+	mcryptd_check_internal(tb, &type, &mask);
+
+	alg = crypto_get_attr_alg(tb, type, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	pr_debug("crypto: mcryptd crypto alg: %s\n", alg->cra_name);
+	inst = mcryptd_alloc_instance(alg, 0, sizeof(*ctx));
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	ctx = crypto_instance_ctx(inst);
+	ctx->queue = queue;
+
+	err = crypto_init_spawn(&ctx->spawn, alg, inst,
+				CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	if (err)
+		goto out_free_inst;
+
+	type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
+		type |= CRYPTO_ALG_INTERNAL;
+	inst->alg.cra_flags = type;
+	inst->alg.cra_type = &crypto_ablkcipher_type;
+
+	inst->alg.cra_ablkcipher.ivsize = alg->cra_blkcipher.ivsize;
+	inst->alg.cra_ablkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
+	inst->alg.cra_ablkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
+
+	inst->alg.cra_ablkcipher.geniv = alg->cra_blkcipher.geniv;
+
+	inst->alg.cra_ctxsize = sizeof(struct mcryptd_blkcipher_ctx);
+
+	inst->alg.cra_init = mcryptd_blkcipher_init_tfm;
+	inst->alg.cra_exit = mcryptd_blkcipher_exit_tfm;
+
+	inst->alg.cra_ablkcipher.setkey = mcryptd_blkcipher_setkey;
+	inst->alg.cra_ablkcipher.encrypt = mcryptd_blkcipher_encrypt_enqueue;
+	inst->alg.cra_ablkcipher.decrypt = mcryptd_blkcipher_decrypt_enqueue;
+
+	err = crypto_register_instance(tmpl, inst);
+	if (err) {
+		crypto_drop_spawn(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
 static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
@@ -563,6 +771,8 @@ static int mcryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_BLKCIPHER:
+		return mcryptd_create_blkcipher(tmpl, tb, &mqueue);
 	case CRYPTO_ALG_TYPE_DIGEST:
 		return mcryptd_create_hash(tmpl, tb, &mqueue);
 	break;
@@ -577,6 +787,10 @@ static void mcryptd_free(struct crypto_instance *inst)
 	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
 
 	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_BLKCIPHER:
+		crypto_drop_spawn(&ctx->spawn);
+		kfree(inst);
+		return;
 	case CRYPTO_ALG_TYPE_AHASH:
 		crypto_drop_shash(&hctx->spawn);
 		kfree(ahash_instance(inst));
@@ -594,6 +808,46 @@ static struct crypto_template mcryptd_tmpl = {
 	.module = THIS_MODULE,
 };
 
+struct mcryptd_ablkcipher *mcryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask)
+{
+	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_tfm *tfm;
+
+	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "mcryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
+	mask |= (CRYPTO_ALG_GENIV | CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
+	tfm = crypto_alloc_base(cryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (tfm->__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_tfm(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return __mcryptd_ablkcipher_cast(__crypto_ablkcipher_cast(tfm));
+}
+EXPORT_SYMBOL_GPL(mcryptd_alloc_ablkcipher);
+
+struct crypto_blkcipher *mcryptd_ablkcipher_child(
+		struct mcryptd_ablkcipher *tfm)
+{
+	struct mcryptd_blkcipher_ctx *ctx = crypto_ablkcipher_ctx(&tfm->base);
+
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(mcryptd_ablkcipher_child);
+
+void mcryptd_free_ablkcipher(struct mcryptd_ablkcipher *tfm)
+{
+	crypto_free_ablkcipher(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(mcryptd_free_ablkcipher);
+
 struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
 					u32 type, u32 mask)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9fe145..4c5633f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -301,6 +301,7 @@ static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
 	walk->in.sg = src;
 	walk->out.sg = dst;
 	walk->total = nbytes;
+	walk->flags = 0;
 }
 
 static inline void ablkcipher_walk_init(struct ablkcipher_walk *walk,
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
index c23ee1f..3fbe4fa 100644
--- a/include/crypto/mcryptd.h
+++ b/include/crypto/mcryptd.h
@@ -13,6 +13,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <crypto/hash.h>
+#include <crypto/b128ops.h>
 
 struct mcryptd_ahash {
 	struct crypto_ahash base;
@@ -95,6 +96,41 @@ struct mcryptd_alg_state {
 	unsigned long (*flusher)(struct mcryptd_alg_cstate *cstate);
 };
 
+struct mcryptd_ablkcipher {
+	struct crypto_ablkcipher base;
+};
+
+static inline struct mcryptd_ablkcipher *__mcryptd_ablkcipher_cast(
+	struct crypto_ablkcipher *tfm)
+{
+	return (struct mcryptd_ablkcipher *)tfm;
+}
+
+/* alg_name should be algorithm to be cryptd-ed */
+struct mcryptd_ablkcipher *mcryptd_alloc_ablkcipher(const char *alg_name,
+						  u32 type, u32 mask);
+struct crypto_blkcipher *mcryptd_ablkcipher_child(
+	struct mcryptd_ablkcipher *tfm);
+void mcryptd_free_ablkcipher(struct mcryptd_ablkcipher *tfm);
+
+struct mcryptd_blkcipher_ctx {
+	struct crypto_blkcipher *child;
+	struct mcryptd_alg_state *alg_state;
+};
+
+struct mcryptd_blkcipher_request_ctx {
+	struct list_head waiter;
+	crypto_completion_t complete;
+	struct mcryptd_tag tag;
+	struct ablkcipher_walk walk;
+	u8 flag;
+	int nbytes;
+	int error;
+	struct blkcipher_desc desc;
+	void *job;
+	u128 seq_iv;	/* running iv of a sequence */
+};
+
 /* return delay in jiffies from current time */
 static inline unsigned long get_delay(unsigned long t)
 {
-- 
1.7.11.7
