From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 7/7] crypto: marvell: Add support for chaining crypto requests in TDMA mode
Date: Wed, 15 Jun 2016 21:15:34 +0200
Message-ID: <1466018134-10779-8-git-send-email-romain.perier@free-electrons.com>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52779 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932655AbcFOTQr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:16:47 -0400
In-Reply-To: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Cryptographic Engines and Security Accelerators (CESA) supports the
Multi-Packet Chain Mode. With this mode enabled, multiple tdma requests
can be chained and processed by the hardware without software
interferences. This mode was already activated, however the crypto
requests were not chained together. By doing so, we reduce significantly
the number of IRQs. Instead of being interrupted at the end of each
crypto request, we are interrupted at the end of the last cryptographic
request processed by the engine.

This commits re-factorizes the code, changes the code architecture and
adds the required data structures to chain cryptographic requests
together before sending them to an engine.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c   | 117 +++++++++++++++++++++++++++++++---------
 drivers/crypto/marvell/cesa.h   |  38 ++++++++++++-
 drivers/crypto/marvell/cipher.c |   3 +-
 drivers/crypto/marvell/hash.c   |   9 +++-
 drivers/crypto/marvell/tdma.c   |  81 ++++++++++++++++++++++++++++
 5 files changed, 218 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index f9e6688..33411f6 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -32,7 +32,7 @@
 #include "cesa.h"
 
 /* Limit of the crypto queue before reaching the backlog */
-#define CESA_CRYPTO_DEFAULT_MAX_QLEN 50
+#define CESA_CRYPTO_DEFAULT_MAX_QLEN 128
 
 static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
 module_param_named(allhwsupport, allhwsupport, int, 0444);
@@ -40,23 +40,83 @@ MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if over
 
 struct mv_cesa_dev *cesa_dev;
 
-static void mv_cesa_dequeue_req_unlocked(struct mv_cesa_engine *engine)
+struct crypto_async_request *mv_cesa_dequeue_req_locked(
+	struct mv_cesa_engine *engine, struct crypto_async_request **backlog)
+{
+	struct crypto_async_request *req;
+
+	*backlog = crypto_get_backlog(&engine->queue);
+	req = crypto_dequeue_request(&engine->queue);
+
+	if (!req)
+		return NULL;
+
+	return req;
+}
+
+static void mv_cesa_rearm_engine(struct mv_cesa_engine *engine)
 {
 	struct crypto_async_request *req, *backlog;
 	struct mv_cesa_ctx *ctx;
 
-	backlog = crypto_get_backlog(&engine->queue);
-	req = crypto_dequeue_request(&engine->queue);
-	engine->req = req;
 
+	spin_lock_bh(&engine->lock);
+	if (engine->req)
+		goto out_unlock;
+
+	req = mv_cesa_dequeue_req_locked(engine, &backlog);
 	if (!req)
-		return;
+		goto out_unlock;
+
+	engine->req = req;
+	spin_unlock_bh(&engine->lock);
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
 	ctx = crypto_tfm_ctx(req->tfm);
 	ctx->ops->step(req);
+	return;
+out_unlock:
+	spin_unlock_bh(&engine->lock);
+}
+
+static int mv_cesa_std_process(struct mv_cesa_engine *engine, u32 status)
+{
+	struct crypto_async_request *req;
+	struct mv_cesa_ctx *ctx;
+	int res;
+
+	req = engine->req;
+	ctx = crypto_tfm_ctx(req->tfm);
+	res = ctx->ops->process(req, status);
+
+	if (res == 0) {
+		ctx->ops->complete(req);
+		mv_cesa_engine_enqueue_complete_request(engine, req);
+	} else if (res == -EINPROGRESS) {
+		ctx->ops->step(req);
+	} else {
+		ctx->ops->complete(req);
+	}
+
+	return res;
+}
+
+static int mv_cesa_int_process(struct mv_cesa_engine *engine, u32 status)
+{
+	if (engine->chain.first && engine->chain.last)
+		return mv_cesa_tdma_process(engine, status);
+	return mv_cesa_std_process(engine, status);
+}
+
+static inline void mv_cesa_complete_req(struct mv_cesa_ctx *ctx,
+	struct crypto_async_request *req, int res)
+{
+	ctx->ops->cleanup(req);
+	local_bh_disable();
+	req->complete(req, res);
+	local_bh_enable();
 }
 
 static irqreturn_t mv_cesa_int(int irq, void *priv)
@@ -83,26 +143,31 @@ static irqreturn_t mv_cesa_int(int irq, void *priv)
 		writel(~status, engine->regs + CESA_SA_FPGA_INT_STATUS);
 		writel(~status, engine->regs + CESA_SA_INT_STATUS);
 
+		/* Process fetched requests */
+		res = mv_cesa_int_process(engine, status & mask);
 		ret = IRQ_HANDLED;
+
 		spin_lock_bh(&engine->lock);
 		req = engine->req;
+		if (res != -EINPROGRESS)
+			engine->req = NULL;
 		spin_unlock_bh(&engine->lock);
-		if (req) {
-			ctx = crypto_tfm_ctx(req->tfm);
-			res = ctx->ops->process(req, status & mask);
-			if (res != -EINPROGRESS) {
-				spin_lock_bh(&engine->lock);
-				engine->req = NULL;
-				mv_cesa_dequeue_req_unlocked(engine);
-				spin_unlock_bh(&engine->lock);
-				ctx->ops->complete(req);
-				ctx->ops->cleanup(req);
-				local_bh_disable();
-				req->complete(req, res);
-				local_bh_enable();
-			} else {
-				ctx->ops->step(req);
-			}
+
+		ctx = crypto_tfm_ctx(req->tfm);
+
+		if (res && res != -EINPROGRESS)
+			mv_cesa_complete_req(ctx, req, res);
+
+		/* Launch the next pending request */
+		mv_cesa_rearm_engine(engine);
+
+		/* Iterate over the complete queue */
+		while (true) {
+			req = mv_cesa_engine_dequeue_complete_request(engine);
+			if (!req)
+				break;
+
+			mv_cesa_complete_req(ctx, req, 0);
 		}
 	}
 
@@ -116,16 +181,15 @@ int mv_cesa_queue_req(struct crypto_async_request *req,
 	struct mv_cesa_engine *engine = creq->engine;
 
 	spin_lock_bh(&engine->lock);
+	if (mv_cesa_req_get_type(creq) == CESA_DMA_REQ)
+		mv_cesa_tdma_chain(engine, creq);
 	ret = crypto_enqueue_request(&engine->queue, req);
 	spin_unlock_bh(&engine->lock);
 
 	if (ret != -EINPROGRESS)
 		return ret;
 
-	spin_lock_bh(&engine->lock);
-	if (!engine->req)
-		mv_cesa_dequeue_req_unlocked(engine);
-	spin_unlock_bh(&engine->lock);
+	mv_cesa_rearm_engine(engine);
 
 	return -EINPROGRESS;
 }
@@ -496,6 +560,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 
 		crypto_init_queue(&engine->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 		atomic_set(&engine->load, 0);
+		INIT_LIST_HEAD(&engine->complete_queue);
 	}
 
 	cesa_dev = cesa;
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 5626aa7..e0fee1f 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -271,7 +271,9 @@ struct mv_cesa_op_ctx {
 /* TDMA descriptor flags */
 #define CESA_TDMA_DST_IN_SRAM			BIT(31)
 #define CESA_TDMA_SRC_IN_SRAM			BIT(30)
-#define CESA_TDMA_TYPE_MSK			GENMASK(29, 0)
+#define CESA_TDMA_END_OF_REQ			BIT(29)
+#define CESA_TDMA_NOT_CHAIN			BIT(28)
+#define CESA_TDMA_TYPE_MSK			GENMASK(27, 0)
 #define CESA_TDMA_DUMMY				0
 #define CESA_TDMA_DATA				1
 #define CESA_TDMA_OP				2
@@ -431,6 +433,9 @@ struct mv_cesa_dev {
  *			SRAM
  * @queue:		fifo of the pending crypto requests
  * @load:		engine load counter, useful for load balancing
+ * @chain:		list of the current tdma descriptors being processed
+ * 			by this engine.
+ * @complete_queue:	fifo of the processed requests by the engine
  *
  * Structure storing CESA engine information.
  */
@@ -448,6 +453,8 @@ struct mv_cesa_engine {
 	struct gen_pool *pool;
 	struct crypto_queue queue;
 	atomic_t load;
+	struct mv_cesa_tdma_chain chain;
+	struct list_head complete_queue;
 };
 
 /**
@@ -618,6 +625,28 @@ struct mv_cesa_ahash_req {
 
 extern struct mv_cesa_dev *cesa_dev;
 
+
+static inline void mv_cesa_engine_enqueue_complete_request(
+	struct mv_cesa_engine *engine, struct crypto_async_request *req)
+{
+	list_add_tail(&req->list, &engine->complete_queue);
+}
+
+static inline struct crypto_async_request *
+mv_cesa_engine_dequeue_complete_request(struct mv_cesa_engine *engine)
+{
+	struct crypto_async_request *req;
+
+	req = list_first_entry_or_null(&engine->complete_queue,
+				       struct crypto_async_request,
+				       list);
+	if (req)
+		list_del(&req->list);
+
+	return req;
+}
+
+
 static inline enum mv_cesa_req_type
 mv_cesa_req_get_type(struct mv_cesa_req *req)
 {
@@ -699,6 +728,10 @@ static inline bool mv_cesa_mac_op_is_first_frag(const struct mv_cesa_op_ctx *op)
 int mv_cesa_queue_req(struct crypto_async_request *req,
 		      struct mv_cesa_req *creq);
 
+struct crypto_async_request *mv_cesa_dequeue_req_locked(
+		      struct mv_cesa_engine *engine,
+		      struct crypto_async_request **backlog);
+
 static inline struct mv_cesa_engine *mv_cesa_select_engine(int weight)
 {
 	int i;
@@ -804,6 +837,9 @@ static inline int mv_cesa_dma_process(struct mv_cesa_req *dreq,
 void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 			 struct mv_cesa_engine *engine);
 void mv_cesa_dma_cleanup(struct mv_cesa_req *dreq);
+void mv_cesa_tdma_chain(struct mv_cesa_engine *engine,
+			struct mv_cesa_req *dreq);
+int mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status);
 
 
 static inline void
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 02aa38f..9033191 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -225,7 +225,6 @@ mv_cesa_ablkcipher_complete(struct crypto_async_request *req)
 static const struct mv_cesa_req_ops mv_cesa_ablkcipher_req_ops = {
 	.step = mv_cesa_ablkcipher_step,
 	.process = mv_cesa_ablkcipher_process,
-	.prepare = mv_cesa_ablkcipher_prepare,
 	.cleanup = mv_cesa_ablkcipher_req_cleanup,
 	.complete = mv_cesa_ablkcipher_complete,
 };
@@ -384,6 +383,7 @@ static int mv_cesa_ablkcipher_dma_req_init(struct ablkcipher_request *req,
 		goto err_free_tdma;
 
 	dreq->chain = chain;
+	dreq->chain.last->flags |= CESA_TDMA_END_OF_REQ;
 
 	return 0;
 
@@ -441,7 +441,6 @@ static int mv_cesa_ablkcipher_req_init(struct ablkcipher_request *req,
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_OP_CRYPT_ONLY,
 			      CESA_SA_DESC_CFG_OP_MSK);
 
-	/* TODO: add a threshold for DMA usage */
 	if (cesa_dev->caps->has_tdma)
 		ret = mv_cesa_ablkcipher_dma_req_init(req, tmpl);
 	else
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 5946a69..c2ff353 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -172,6 +172,9 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	for (i = 0; i < digsize / 4; i++)
 		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 
+	mv_cesa_adjust_op(engine, &creq->op_tmpl);
+	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
+
 	if (creq->cache_ptr)
 		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
 			    creq->cache, creq->cache_ptr);
@@ -282,6 +285,9 @@ static void mv_cesa_ahash_step(struct crypto_async_request *req)
 {
 	struct ahash_request *ahashreq = ahash_request_cast(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(ahashreq);
+	struct mv_cesa_engine *engine = creq->req.base.engine;
+	unsigned int digsize;
+	int i;
 
 	if (mv_cesa_req_get_type(&creq->req.base) == CESA_DMA_REQ)
 		mv_cesa_dma_step(&creq->req.base);
@@ -367,7 +373,6 @@ static void mv_cesa_ahash_req_cleanup(struct crypto_async_request *req)
 static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
 	.step = mv_cesa_ahash_step,
 	.process = mv_cesa_ahash_process,
-	.prepare = mv_cesa_ahash_prepare,
 	.cleanup = mv_cesa_ahash_req_cleanup,
 	.complete = mv_cesa_ahash_complete,
 };
@@ -648,6 +653,8 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	else
 		creq->cache_ptr = 0;
 
+	dreq->chain.last->flags |= (CESA_TDMA_END_OF_REQ | CESA_TDMA_NOT_CHAIN);
+
 	return 0;
 
 err_free_tdma:
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 9a424f9..ae50545 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -98,6 +98,87 @@ void mv_cesa_dma_prepare(struct mv_cesa_req *dreq,
 	}
 }
 
+void
+mv_cesa_tdma_chain(struct mv_cesa_engine *engine, struct mv_cesa_req *dreq)
+{
+	if (engine->chain.first == NULL && engine->chain.last == NULL) {
+		engine->chain.first = dreq->chain.first;
+		engine->chain.last  = dreq->chain.last;
+	} else {
+		struct mv_cesa_tdma_desc *last;
+
+		last = engine->chain.last;
+		last->next = dreq->chain.first;
+		engine->chain.last = dreq->chain.last;
+		if (!(last->flags & CESA_TDMA_NOT_CHAIN))
+			last->next_dma = dreq->chain.first->cur_dma;
+	}
+}
+
+int
+mv_cesa_tdma_process(struct mv_cesa_engine *engine, u32 status)
+{
+	struct crypto_async_request *req = NULL;
+	struct mv_cesa_tdma_desc *tdma = NULL, *next = NULL;
+	dma_addr_t tdma_cur;
+	int res = 0;
+
+	tdma_cur = readl(engine->regs + CESA_TDMA_CUR);
+
+	for (tdma = engine->chain.first; tdma; tdma = next) {
+		spin_lock_bh(&engine->lock);
+		next = tdma->next;
+		spin_unlock_bh(&engine->lock);
+
+		if (tdma->flags & CESA_TDMA_END_OF_REQ) {
+			struct crypto_async_request *backlog = NULL;
+			struct mv_cesa_ctx *ctx;
+
+			spin_lock_bh(&engine->lock);
+			/*
+			 * if req is NULL, this means we're processing the
+			 * request in engine->req.
+			 */
+			if (!req)
+				req = engine->req;
+			else
+				req = mv_cesa_dequeue_req_locked(engine,
+								 &backlog);
+
+			/* Re-chaining to the next request */
+			engine->chain.first = tdma->next;
+			tdma->next = NULL;
+
+			/* If this is the last request, clear the chain */
+			if (engine->chain.first == NULL)
+				engine->chain.last  = NULL;
+			spin_unlock_bh(&engine->lock);
+
+			ctx = crypto_tfm_ctx(req->tfm);
+			res = ctx->ops->process(req, status);
+			ctx->ops->complete(req);
+
+			if (res == 0)
+				mv_cesa_engine_enqueue_complete_request(engine,
+									req);
+
+			if (backlog)
+				backlog->complete(backlog, -EINPROGRESS);
+		}
+		if (res || tdma->cur_dma == tdma_cur)
+			break;
+	}
+
+	if (res) {
+		spin_lock_bh(&engine->lock);
+		engine->req = req;
+		spin_unlock_bh(&engine->lock);
+	}
+
+	return res;
+}
+
+
 static struct mv_cesa_tdma_desc *
 mv_cesa_dma_add_desc(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 {
-- 
2.7.4
