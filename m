From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 6/7] crypto: marvell: Adding load balancing between engines
Date: Wed, 15 Jun 2016 21:15:33 +0200
Message-ID: <1466018134-10779-7-git-send-email-romain.perier@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52789 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932759AbcFOTQq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:16:46 -0400
In-Reply-To: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This commits adds support for fine grained load balancing on
multi-engine IPs. The engine is pre-selected based on its current load
and on the weight of the crypto request that is about to be processed.
The global crypto queue is also moved to each engine. These changes are
useful for preparing the code to support TDMA chaining between crypto
requests, because each tdma chain will be handled per engine. By using
a crypto queue per engine, we make sure that we keep the state of the
tdma chain synchronized with the crypto queue. We also reduce contention
on 'cesa_dev->lock' and improve parallelism.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c   | 30 +++++++++----------
 drivers/crypto/marvell/cesa.h   | 26 +++++++++++++++--
 drivers/crypto/marvell/cipher.c | 59 ++++++++++++++++++-------------------
 drivers/crypto/marvell/hash.c   | 65 +++++++++++++++++++----------------------
 4 files changed, 97 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index af96426..f9e6688 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -45,11 +45,9 @@ static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
 	struct crypto_async_request *req, *backlog;
 	struct mv_cesa_ctx *ctx;
 
-	spin_lock_bh(&cesa_dev->lock);
-	backlog = crypto_get_backlog(&cesa_dev->queue);
-	req = crypto_dequeue_request(&cesa_dev->queue);
+	backlog = crypto_get_backlog(&engine->queue);
+	req = crypto_dequeue_request(&engine->queue);
 	engine->req = req;
-	spin_unlock_bh(&cesa_dev->lock);
 
 	if (!req)
 		return;
@@ -58,7 +56,6 @@ static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
 		backlog->complete(backlog, -EINPROGRESS);
 
 	ctx = crypto_tfm_ctx(req->tfm);
-	ctx->ops->prepare(req, engine);
 	ctx->ops->step(req);
 }
 
@@ -116,21 +113,19 @@ int mv_cesa_queue_req(struct crypto_async_request *req,
 		      struct mv_cesa_req *creq)
 {
 	int ret;
-	int i;
+	struct mv_cesa_engine *engine = creq->engine;
 
-	spin_lock_bh(&cesa_dev->lock);
-	ret = crypto_enqueue_request(&cesa_dev->queue, req);
-	spin_unlock_bh(&cesa_dev->lock);
+	spin_lock_bh(&engine->lock);
+	ret = crypto_enqueue_request(&engine->queue, req);
+	spin_unlock_bh(&engine->lock);
 
 	if (ret != -EINPROGRESS)
 		return ret;
 
-	for (i = 0; i < cesa_dev->caps->nengines; i++) {
-		spin_lock_bh(&cesa_dev->engines[i].lock);
-		if (!cesa_dev->engines[i].req)
-			mv_cesa_dequeue_req_unlocked(&cesa_dev->engines[i]);
-		spin_unlock_bh(&cesa_dev->engines[i].lock);
-	}
+	spin_lock_bh(&engine->lock);
+	if (!engine->req)
+		mv_cesa_dequeue_req_unlocked(engine);
+	spin_unlock_bh(&engine->lock);
 
 	return -EINPROGRESS;
 }
@@ -425,7 +420,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&cesa->lock);
-	crypto_init_queue(&cesa->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	cesa->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(cesa->regs))
@@ -498,6 +493,9 @@ static int mv_cesa_probe(struct platform_device *pdev)
 						engine);
 		if (ret)
 			goto err_cleanup;
+
+		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
+		atomic_set(&engine->load, 0);
 	}
 
 	cesa_dev = cesa;
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 32de08b..5626aa7 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -400,7 +400,6 @@ struct mv_cesa_dev_dma {
  * @regs:	device registers
  * @sram_size:	usable SRAM size
  * @lock:	device lock
- * @queue:	crypto request queue
  * @engines:	array of engines
  * @dma:	dma pools
  *
@@ -412,7 +411,6 @@ struct mv_cesa_dev {
 	struct device *dev;
 	unsigned int sram_size;
 	spinlock_t lock;
-	struct crypto_queue queue;
 	struct mv_cesa_engine *engines;
 	struct mv_cesa_dev_dma *dma;
 };
@@ -431,6 +429,8 @@ struct mv_cesa_dev {
  * @int_mask:		interrupt mask cache
  * @pool:		memory pool pointing to the memory region reserved in
  *			SRAM
+ * @queue:		fifo of the pending crypto requests
+ * @load:		engine load counter, useful for load balancing
  *
  * Structure storing CESA engine information.
  */
@@ -446,6 +446,8 @@ struct mv_cesa_engine {
 	size_t max_req_len;
 	u32 int_mask;
 	struct gen_pool *pool;
+	struct crypto_queue queue;
+	atomic_t load;
 };
 
 /**
@@ -697,6 +699,26 @@ static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
 int mv_cesa_queue_req(struct crypto_async_request *req,
 		      struct mv_cesa_req *creq);
 
+static inline struct mv_cesa_engine *mv_cesa_select_engine(int weight)
+{
+	int i;
+	u32 min_load = U32_MAX;
+	struct mv_cesa_engine *selected = NULL;
+
+	for (i = 0; i < cesa_dev->caps->nengines; i++) {
+		struct mv_cesa_engine *engine = cesa_dev->engines + i;
+		u32 load = atomic_read(&engine->load);
+		if (load < min_load) {
+			min_load = load;
+			selected = engine;
+		}
+	}
+
+	atomic_add(weight, &selected->load);
+
+	return selected;
+}
+
 /*
  * Helper function that indicates whether a crypto request needs to be
  * cleaned up or not after being enqueued using mv_cesa_queue_req().
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index fbaae2f..02aa38f 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -89,6 +89,9 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
 	size_t  len = min_t(size_t, req->nbytes - sreq->offset,
 			    CESA_SA_SRAM_PAYLOAD_SIZE);
 
+	mv_cesa_adjust_op(engine, &sreq->op);
+	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
+
 	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
 				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
 				 len, sreq->offset);
@@ -167,12 +170,9 @@ mv_cesa_ablkcipher_std_prepare(struct ablkcipher_request *req)
 {
 	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_ablkcipher_std_req *sreq = &creq->req.std;
-	struct mv_cesa_engine *engine = sreq->base.engine;
 
 	sreq->size = 0;
 	sreq->offset = 0;
-	mv_cesa_adjust_op(engine, &sreq->op);
-	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
 }
 
 static inline void mv_cesa_ablkcipher_prepare(struct crypto_async_request *req,
@@ -205,6 +205,7 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 	struct mv_cesa_engine *engine = creq->req.base.engine;
 	unsigned int ivsize;
 
+	atomic_sub(ablkreq->nbytes, &engine->load);
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
 
 	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ) {
@@ -449,29 +450,43 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
 	return ret;
 }
 
-static int mv_cesa_des_op(struct ablkcipher_request *req,
-			  struct mv_cesa_op_ctx *tmpl)
+static int mv_cesa_ablkcipher_queue_req(struct ablkcipher_request *req,
+					struct mv_cesa_op_ctx *tmpl)
 {
-	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
-	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	int ret;
-
-	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
-			      CESA_SA_DESC_CFG_CRYPTM_MSK);
-
-	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_engine *engine;
 
 	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
 
+	engine = mv_cesa_select_engine(req->nbytes);
+	mv_cesa_ablkcipher_prepare(&req->base, engine);
+
 	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
+
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ablkcipher_cleanup(req);
 
 	return ret;
 }
 
+static int mv_cesa_des_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	int ret;
+
+	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
+			      CESA_SA_DESC_CFG_CRYPTM_MSK);
+
+	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
+
+	return mv_cesa_ablkcipher_queue_req(req, tmpl);
+}
+
 static int mv_cesa_ecb_des_encrypt(struct ablkcipher_request *req)
 {
 	struct mv_cesa_op_ctx tmpl;
@@ -582,15 +597,7 @@ static int mv_cesa_des3_op(struct ablkcipher_request *req,
 
 	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
 
-	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
-	if (ret)
-		return ret;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ablkcipher_cleanup(req);
-
-	return ret;
+	return mv_cesa_ablkcipher_queue_req(req, tmpl);
 }
 
 static int mv_cesa_ecb_des3_ede_encrypt(struct ablkcipher_request *req)
@@ -725,15 +732,7 @@ static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			      CESA_SA_DESC_CFG_CRYPTM_MSK |
 			      CESA_SA_DESC_CFG_AES_LEN_MSK);
 
-	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
-	if (ret)
-		return ret;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ablkcipher_cleanup(req);
-
-	return ret;
+	return mv_cesa_ablkcipher_queue_req(req, tmpl);
 }
 
 static int mv_cesa_ecb_aes_encrypt(struct ablkcipher_request *req)
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index f7f84cc..5946a69 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -162,6 +162,15 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	unsigned int new_cache_ptr = 0;
 	u32 frag_mode;
 	size_t  len;
+	unsigned int digsize;
+	int i;
+
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+
+	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+	for (i = 0; i < digsize / 4; i++)
+		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 
 	if (creq->cache_ptr)
 		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
@@ -265,11 +274,8 @@ static void mv_cesa_ahash_std_prepare(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_ahash_std_req *sreq = &creq->req.std;
-	struct mv_cesa_engine *engine = sreq->base.engine;
 
 	sreq->offset = 0;
-	mv_cesa_adjust_op(engine, &creq->op_tmpl);
-	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
 }
 
 static void mv_cesa_ahash_step(struct crypto_async_request *req)
@@ -329,6 +335,8 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 				result[i] = cpu_to_be32(creq->state[i]);
 		}
 	}
+
+	atomic_sub(ahashreq->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -336,8 +344,6 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
-	unsigned int digsize;
-	int i;
 
 	creq->req.base.engine = engine;
 
@@ -345,10 +351,6 @@ static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
 		mv_cesa_ahash_dma_prepare(ahashreq);
 	else
 		mv_cesa_ahash_std_prepare(ahashreq);
-
-	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(ahashreq));
-	for (i = 0; i < digsize / 4; i++)
-		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 }
 
 static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
@@ -682,13 +684,13 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
 	return ret;
 }
 
-static int mv_cesa_ahash_update(struct ahash_request *req)
+static int mv_cesa_ahash_queue_req(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	struct mv_cesa_engine *engine;
 	bool cached = false;
 	int ret;
 
-	creq->len += req->nbytes;
 	ret = mv_cesa_ahash_req_init(req, &cached);
 	if (ret)
 		return ret;
@@ -696,13 +698,28 @@ static int mv_cesa_ahash_update(struct ahash_request *req)
 	if (cached)
 		return 0;
 
+	engine = mv_cesa_select_engine(req->nbytes);
+	mv_cesa_ahash_prepare(&req->base, engine);
+
 	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
+
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ahash_cleanup(req);
 
 	return ret;
 }
 
+static int mv_cesa_ahash_update(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	bool cached = false;
+	int ret;
+
+	creq->len += req->nbytes;
+
+	return mv_cesa_ahash_queue_req(req);
+}
+
 static int mv_cesa_ahash_final(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
@@ -714,18 +731,7 @@ static int mv_cesa_ahash_final(struct ahash_request *req)
 	creq->last_req = true;
 	req->nbytes = 0;
 
-	ret = mv_cesa_ahash_req_init(req, &cached);
-	if (ret)
-		return ret;
-
-	if (cached)
-		return 0;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ahash_cleanup(req);
-
-	return ret;
+	return mv_cesa_ahash_queue_req(req);
 }
 
 static int mv_cesa_ahash_finup(struct ahash_request *req)
@@ -739,18 +745,7 @@ static int mv_cesa_ahash_finup(struct ahash_request *req)
 	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
 	creq->last_req = true;
 
-	ret = mv_cesa_ahash_req_init(req, &cached);
-	if (ret)
-		return ret;
-
-	if (cached)
-		return 0;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->req.base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ahash_cleanup(req);
-
-	return ret;
+	return mv_cesa_ahash_queue_req(req);
 }
 
 static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
-- 
2.7.4
