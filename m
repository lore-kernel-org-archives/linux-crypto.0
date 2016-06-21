From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 08/10] crypto: marvell: Add load balancing between engines
Date: Tue, 21 Jun 2016 10:08:38 +0200
Message-ID: <1466496520-28806-9-git-send-email-romain.perier@free-electrons.com>
References: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Russell King <linux@arm.linux.org.uk>, linux-crypto@vger.kernel.org,
 Gregory Clement <gregory.clement@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
 Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This commits adds support for fine grained load balancing on
multi-engine IPs. The engine is pre-selected based on its current load
and on the weight of the crypto request that is about to be processed.
The global crypto queue is also moved to each engine. These changes are
required to allow chaining crypto requests at the DMA level. By using
a crypto queue per engine, we make sure that we keep the state of the
tdma chain synchronized with the crypto queue. We also reduce contention
on 'cesa_dev->lock' and improve parallelism.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---

Changes in v3:

  - Renamed mv_cesa_dequeue_req_unlocked => mv_cesa_dequeue_req_locked

Changes in v2:

  - Reworded the commit message
  - Moved the code about SRAM I/O operations from this commit to
    a separated commit (see PATCH 07/10).

 drivers/crypto/marvell/cesa.c   | 34 ++++++++++++------------
 drivers/crypto/marvell/cesa.h   | 29 +++++++++++++++++----
 drivers/crypto/marvell/cipher.c | 57 ++++++++++++++++++-----------------------
 drivers/crypto/marvell/hash.c   | 50 ++++++++++++++----------------------
 4 files changed, 84 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index af96426..c0497ac 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -40,16 +40,14 @@ MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if over
 
 struct mv_cesa_dev *cesa_dev;
 
-static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
+static void mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine)
 {
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
 
@@ -96,7 +93,7 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 			if (res != -EINPROGRESS) {
 				spin_lock_bh(&engine->lock);
 				engine->req = NULL;
-				mv_cesa_dequeue_req_unlocked(engine);
+				mv_cesa_dequeue_req_locked(engine);
 				spin_unlock_bh(&engine->lock);
 				ctx->ops->complete(req);
 				ctx->ops->cleanup(req);
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
+		mv_cesa_dequeue_req_locked(engine);
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
index c463528..644be35 100644
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
@@ -446,11 +446,12 @@ struct mv_cesa_engine {
 	size_t max_req_len;
 	u32 int_mask;
 	struct gen_pool *pool;
+	struct crypto_queue queue;
+	atomic_t load;
 };
 
 /**
  * struct mv_cesa_req_ops - CESA request operations
- * @prepare:	prepare a request to be executed on the specified engine
  * @process:	process a request chunk result (should return 0 if the
  *		operation, -EINPROGRESS if it needs more steps or an error
  *		code)
@@ -460,8 +461,6 @@ struct mv_cesa_engine {
  * 		when it is needed.
  */
 struct mv_cesa_req_ops {
-	void (*prepare)(struct crypto_async_request *req,
-			struct mv_cesa_engine *engine);
 	int (*process)(struct crypto_async_request *req, u32 status);
 	void (*step)(struct crypto_async_request *req);
 	void (*cleanup)(struct crypto_async_request *req);
@@ -690,6 +689,26 @@ static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
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
index 79d4175..28894be 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -214,6 +214,7 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 	struct mv_cesa_engine *engine = creq->base.engine;
 	unsigned int ivsize;
 
+	atomic_sub(ablkreq->nbytes, &engine->load);
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(ablkreq));
 
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ) {
@@ -231,7 +232,6 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops = {
 	.step = mv_cesa_ablkcipher_step,
 	.process = mv_cesa_ablkcipher_process,
-	.prepare = mv_cesa_ablkcipher_prepare,
 	.cleanup = mv_cesa_ablkcipher_req_cleanup,
 	.complete = mv_cesa_ablkcipher_complete,
 };
@@ -456,29 +456,41 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
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
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
+
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ablkcipher_cleanup(req);
 
 	return ret;
 }
 
+static int mv_cesa_des_op(struct ablkcipher_request *req,
+			  struct mv_cesa_op_ctx *tmpl)
+{
+	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
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
@@ -580,24 +592,14 @@ struct crypto_alg mv_cesa_cbc_des_alg = {
 static int mv_cesa_des3_op(struct ablkcipher_request *req,
 			   struct mv_cesa_op_ctx *tmpl)
 {
-	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_des3_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	int ret;
 
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
 			      CESA_SA_DESC_CFG_CRYPTM_MSK);
 
 	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
 
-	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
-	if (ret)
-		return ret;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ablkcipher_cleanup(req);
-
-	return ret;
+	return mv_cesa_ablkcipher_queue_req(req, tmpl);
 }
 
 static int mv_cesa_ecb_des3_ede_encrypt(struct ablkcipher_request *req)
@@ -707,9 +709,8 @@ struct crypto_alg mv_cesa_cbc_des3_ede_alg = {
 static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			  struct mv_cesa_op_ctx *tmpl)
 {
-	struct mv_cesa_ablkcipher_req *creq = ablkcipher_request_ctx(req);
 	struct mv_cesa_aes_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	int ret, i;
+	int i;
 	u32 *key;
 	u32 cfg;
 
@@ -732,15 +733,7 @@ static int mv_cesa_aes_op(struct ablkcipher_request *req,
 			      CESA_SA_DESC_CFG_CRYPTM_MSK |
 			      CESA_SA_DESC_CFG_AES_LEN_MSK);
 
-	ret = mv_cesa_ablkcipher_req_init(req, tmpl);
-	if (ret)
-		return ret;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ablkcipher_cleanup(req);
-
-	return ret;
+	return mv_cesa_ablkcipher_queue_req(req, tmpl);
 }
 
 static int mv_cesa_ecb_aes_encrypt(struct ablkcipher_request *req)
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index e1f8acd..b7cfc42 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -335,6 +335,8 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 				result[i] = cpu_to_be32(creq->state[i]);
 		}
 	}
+
+	atomic_sub(ahashreq->nbytes, &engine->load);
 }
 
 static void mv_cesa_ahash_prepare(struct crypto_async_request *req,
@@ -365,7 +367,6 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
 	.step = mv_cesa_ahash_step,
 	.process = mv_cesa_ahash_process,
-	.prepare = mv_cesa_ahash_prepare,
 	.cleanup = mv_cesa_ahash_req_cleanup,
 	.complete = mv_cesa_ahash_complete,
 };
@@ -682,13 +683,13 @@ static int mv_cesa_ahash_req_init(struct ahash_request *req, bool *cached)
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
@@ -696,61 +697,48 @@ static int mv_cesa_ahash_update(struct ahash_request *req)
 	if (cached)
 		return 0;
 
+	engine = mv_cesa_select_engine(req->nbytes);
+	mv_cesa_ahash_prepare(&req->base, engine);
+
 	ret = mv_cesa_queue_req(&req->base, &creq->base);
+
 	if (mv_cesa_req_needs_cleanup(&req->base, ret))
 		mv_cesa_ahash_cleanup(req);
 
 	return ret;
 }
 
+static int mv_cesa_ahash_update(struct ahash_request *req)
+{
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+
+	creq->len += req->nbytes;
+
+	return mv_cesa_ahash_queue_req(req);
+}
+
 static int mv_cesa_ahash_final(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
-	bool cached = false;
-	int ret;
 
 	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
 	creq->last_req = true;
 	req->nbytes = 0;
 
-	ret = mv_cesa_ahash_req_init(req, &cached);
-	if (ret)
-		return ret;
-
-	if (cached)
-		return 0;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ahash_cleanup(req);
-
-	return ret;
+	return mv_cesa_ahash_queue_req(req);
 }
 
 static int mv_cesa_ahash_finup(struct ahash_request *req)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_op_ctx *tmpl = &creq->op_tmpl;
-	bool cached = false;
-	int ret;
 
 	creq->len += req->nbytes;
 	mv_cesa_set_mac_op_total_len(tmpl, creq->len);
 	creq->last_req = true;
 
-	ret = mv_cesa_ahash_req_init(req, &cached);
-	if (ret)
-		return ret;
-
-	if (cached)
-		return 0;
-
-	ret = mv_cesa_queue_req(&req->base, &creq->base);
-	if (mv_cesa_req_needs_cleanup(&req->base, ret))
-		mv_cesa_ahash_cleanup(req);
-
-	return ret;
+	return mv_cesa_ahash_queue_req(req);
 }
 
 static int mv_cesa_ahash_export(struct ahash_request *req, void *hash,
-- 
2.7.4
