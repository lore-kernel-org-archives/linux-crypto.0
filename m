From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] [CRYPTO] chainiv: Avoid lock spinning where possible
Date: Fri, 14 Dec 2007 22:46:31 +0800
Message-ID: <E1J3Bo7-0004w7-00@gondolin.me.apana.org.au>
References: <20071214144317.GA18890@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4862 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbXLNOqg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 09:46:36 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J3Bo8-000581-35
	for <linux-crypto@vger.kernel.org>; Sat, 15 Dec 2007 01:46:32 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] chainiv: Avoid lock spinning where possible

This patch makes chainiv avoid spinning by postponing requests on lock
contention if the user allows the use of asynchronous algorithms.  If
a synchronous algorithm is requested then we behave as before.

This should improve IPsec performance on SMP when two CPUs attempt to
transmit over the same SA.  Currently one of them will spin doing nothing
waiting for the other CPU to finish its encryption.  This patch makes it
postpone the request and get on with other work.

If only one CPU is transmitting for a given SA, then we will process
the request synchronously as before.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/chainiv.c                   |  209 +++++++++++++++++++++++++++++++++++--
 include/crypto/internal/skcipher.h |   13 ++
 2 files changed, 214 insertions(+), 8 deletions(-)

diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 38868d1..0bdb212 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -16,16 +16,34 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
+
+enum {
+	CHAINIV_STATE_INUSE = 0,
+};
 
 struct chainiv_ctx {
 	spinlock_t lock;
 	char iv[];
 };
 
+struct async_chainiv_ctx {
+	unsigned long state;
+
+	spinlock_t lock;
+	int err;
+
+	struct crypto_queue queue;
+	struct work_struct postponed;
+
+	char iv[];
+};
+
 static int chainiv_givencrypt(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
@@ -80,26 +98,187 @@ unlock:
 	return chainiv_givencrypt(req);
 }
 
+static int chainiv_init_common(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
+
+	return skcipher_geniv_init(tfm);
+}
+
 static int chainiv_init(struct crypto_tfm *tfm)
 {
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	spin_lock_init(&ctx->lock);
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
+	return chainiv_init_common(tfm);
+}
 
-	return skcipher_geniv_init(tfm);
+static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
+{
+	int queued;
+
+	if (!ctx->queue.qlen) {
+		smp_mb__before_clear_bit();
+		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
+
+		if (!ctx->queue.qlen ||
+		    test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+			goto out;
+	}
+
+	queued = schedule_work(&ctx->postponed);
+	BUG_ON(!queued);
+
+out:
+	return ctx->err;
+}
+
+static int async_chainiv_postpone_request(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err;
+
+	spin_lock_bh(&ctx->lock);
+	err = skcipher_enqueue_givcrypt(&ctx->queue, req);
+	spin_unlock_bh(&ctx->lock);
+
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		return err;
+
+	ctx->err = err;
+	return async_chainiv_schedule_work(ctx);
+}
+
+static int async_chainiv_givencrypt_tail(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(geniv);
+
+	memcpy(req->giv, ctx->iv, ivsize);
+	memcpy(subreq->info, ctx->iv, ivsize);
+
+	ctx->err = crypto_ablkcipher_encrypt(subreq);
+	if (ctx->err)
+		goto out;
+
+	memcpy(ctx->iv, subreq->info, ivsize);
+
+out:
+	return async_chainiv_schedule_work(ctx);
+}
+
+static int async_chainiv_givencrypt(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
+
+	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
+	ablkcipher_request_set_callback(subreq, req->creq.base.flags,
+					req->creq.base.complete,
+					req->creq.base.data);
+	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
+				     req->creq.nbytes, req->creq.info);
+
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		goto postpone;
+
+	if (ctx->queue.qlen) {
+		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
+		goto postpone;
+	}
+
+	return async_chainiv_givencrypt_tail(req);
+
+postpone:
+	return async_chainiv_postpone_request(req);
+}
+
+static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
+{
+	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
+	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+
+	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
+		goto out;
+
+	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
+	    async_chainiv_givencrypt_first)
+		goto unlock;
+
+	crypto_ablkcipher_crt(geniv)->givencrypt = async_chainiv_givencrypt;
+	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+
+unlock:
+	clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
+
+out:
+	return async_chainiv_givencrypt(req);
+}
+
+static void async_chainiv_do_postponed(struct work_struct *work)
+{
+	struct async_chainiv_ctx *ctx = container_of(work,
+						     struct async_chainiv_ctx,
+						     postponed);
+	struct skcipher_givcrypt_request *req;
+	struct ablkcipher_request *subreq;
+
+	/* Only handle one request at a time to avoid hogging keventd. */
+	spin_lock_bh(&ctx->lock);
+	req = skcipher_dequeue_givcrypt(&ctx->queue);
+	spin_unlock_bh(&ctx->lock);
+
+	if (!req) {
+		async_chainiv_schedule_work(ctx);
+		return;
+	}
+
+	subreq = skcipher_givcrypt_reqctx(req);
+	subreq->base.flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	async_chainiv_givencrypt_tail(req);
+}
+
+static int async_chainiv_init(struct crypto_tfm *tfm)
+{
+	struct async_chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	spin_lock_init(&ctx->lock);
+
+	crypto_init_queue(&ctx->queue, 100);
+	INIT_WORK(&ctx->postponed, async_chainiv_do_postponed);
+
+	return chainiv_init_common(tfm);
+}
+
+static void async_chainiv_exit(struct crypto_tfm *tfm)
+{
+	struct async_chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	BUG_ON(test_bit(CHAINIV_STATE_INUSE, &ctx->state) || ctx->queue.qlen);
+
+	skcipher_geniv_exit(tfm);
 }
 
 static struct crypto_template chainiv_tmpl;
 
 static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 {
+	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
+	int err;
 
-	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0,
-				    CRYPTO_ALG_ASYNC);
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
 		goto out;
 
@@ -108,8 +287,22 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	inst->alg.cra_init = chainiv_init;
 	inst->alg.cra_exit = skcipher_geniv_exit;
 
-	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx) +
-				inst->alg.cra_ablkcipher.ivsize;
+	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx);
+
+	if (!((algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask &
+	      CRYPTO_ALG_ASYNC)) {
+		inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
+
+		inst->alg.cra_ablkcipher.givencrypt =
+			async_chainiv_givencrypt_first;
+
+		inst->alg.cra_init = async_chainiv_init;
+		inst->alg.cra_exit = async_chainiv_exit;
+
+		inst->alg.cra_ctxsize = sizeof(struct async_chainiv_ctx);
+	}
+
+	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
 
 out:
 	return inst;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 0053f34..2ba42cd 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -70,6 +70,19 @@ static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
 	return crypto_ablkcipher_crt(geniv)->base;
 }
 
+static inline int skcipher_enqueue_givcrypt(
+	struct crypto_queue *queue, struct skcipher_givcrypt_request *request)
+{
+	return ablkcipher_enqueue_request(queue, &request->creq);
+}
+
+static inline struct skcipher_givcrypt_request *skcipher_dequeue_givcrypt(
+	struct crypto_queue *queue)
+{
+	return container_of(ablkcipher_dequeue_request(queue),
+			    struct skcipher_givcrypt_request, creq);
+}
+
 static inline void *skcipher_givcrypt_reqctx(
 	struct skcipher_givcrypt_request *req)
 {
