From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 03/11] omap-sham: replace flags bit mask with bit number
Date: Thu,  2 Jun 2011 21:10:05 +0300
Message-ID: <d1311b629434eaba03f046a2d3c71d5e556b1564.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59166 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1FBSKe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2011 14:10:34 -0400
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Flags mask cannot be used with atomic bit operations.
This patch changes masks to bit numbers.
Atomic bit operations will be used by following patches.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |  102 ++++++++++++++++++++++---------------------
 1 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ac12a60..64698ad 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -72,17 +72,19 @@
 
 #define DEFAULT_TIMEOUT_INTERVAL	HZ
 
-#define FLAGS_FINUP		0x0002
-#define FLAGS_FINAL		0x0004
-#define FLAGS_SG		0x0008
-#define FLAGS_SHA1		0x0010
-#define FLAGS_DMA_ACTIVE	0x0020
-#define FLAGS_OUTPUT_READY	0x0040
-#define FLAGS_INIT		0x0100
-#define FLAGS_CPU		0x0200
-#define FLAGS_HMAC		0x0400
-#define FLAGS_ERROR		0x0800
-#define FLAGS_BUSY		0x1000
+/* mostly device flags */
+#define FLAGS_BUSY		0
+#define FLAGS_FINAL		1
+#define FLAGS_DMA_ACTIVE	2
+#define FLAGS_OUTPUT_READY	3
+#define FLAGS_INIT		4
+#define FLAGS_CPU		5
+/* context flags */
+#define FLAGS_FINUP		16
+#define FLAGS_SG		17
+#define FLAGS_SHA1		18
+#define FLAGS_HMAC		19
+#define FLAGS_ERROR		20
 
 #define OP_UPDATE	1
 #define OP_FINAL	2
@@ -223,7 +225,7 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
 	if (!hash)
 		return;
 
-	if (likely(ctx->flags & FLAGS_SHA1)) {
+	if (likely(ctx->flags & BIT(FLAGS_SHA1))) {
 		/* SHA1 results are in big endian */
 		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++)
 			hash[i] = be32_to_cpu(in[i]);
@@ -238,7 +240,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
 	clk_enable(dd->iclk);
 
-	if (!(dd->flags & FLAGS_INIT)) {
+	if (!(dd->flags & BIT(FLAGS_INIT))) {
 		omap_sham_write_mask(dd, SHA_REG_MASK,
 			SHA_REG_MASK_SOFTRESET, SHA_REG_MASK_SOFTRESET);
 
@@ -246,7 +248,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 					SHA_REG_SYSSTATUS_RESETDONE))
 			return -ETIMEDOUT;
 
-		dd->flags |= FLAGS_INIT;
+		dd->flags |= BIT(FLAGS_INIT);
 		dd->err = 0;
 	}
 
@@ -269,7 +271,7 @@ static void omap_sham_write_ctrl(struct omap_sham_dev *dd, size_t length,
 	 * Setting ALGO_CONST only for the first iteration
 	 * and CLOSE_HASH only for the last one.
 	 */
-	if (ctx->flags & FLAGS_SHA1)
+	if (ctx->flags & BIT(FLAGS_SHA1))
 		val |= SHA_REG_CTRL_ALGO;
 	if (!ctx->digcnt)
 		val |= SHA_REG_CTRL_ALGO_CONST;
@@ -301,7 +303,7 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 		return -ETIMEDOUT;
 
 	if (final)
-		ctx->flags |= FLAGS_FINAL; /* catch last interrupt */
+		ctx->flags |= BIT(FLAGS_FINAL); /* catch last interrupt */
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
@@ -334,9 +336,9 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	ctx->digcnt += length;
 
 	if (final)
-		ctx->flags |= FLAGS_FINAL; /* catch last interrupt */
+		ctx->flags |= BIT(FLAGS_FINAL); /* catch last interrupt */
 
-	dd->flags |= FLAGS_DMA_ACTIVE;
+	dd->flags |= BIT(FLAGS_DMA_ACTIVE);
 
 	omap_start_dma(dd->dma_lch);
 
@@ -392,7 +394,7 @@ static int omap_sham_xmit_dma_map(struct omap_sham_dev *dd,
 		return -EINVAL;
 	}
 
-	ctx->flags &= ~FLAGS_SG;
+	ctx->flags &= ~BIT(FLAGS_SG);
 
 	/* next call does not fail... so no unmap in the case of error */
 	return omap_sham_xmit_dma(dd, ctx->dma_addr, length, final);
@@ -406,7 +408,7 @@ static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
 
 	omap_sham_append_sg(ctx);
 
-	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
+	final = (ctx->flags & BIT(FLAGS_FINUP)) && !ctx->total;
 
 	dev_dbg(dd->dev, "slow: bufcnt: %u, digcnt: %d, final: %d\n",
 					 ctx->bufcnt, ctx->digcnt, final);
@@ -452,7 +454,7 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	length = min(ctx->total, sg->length);
 
 	if (sg_is_last(sg)) {
-		if (!(ctx->flags & FLAGS_FINUP)) {
+		if (!(ctx->flags & BIT(FLAGS_FINUP))) {
 			/* not last sg must be SHA1_MD5_BLOCK_SIZE aligned */
 			tail = length & (SHA1_MD5_BLOCK_SIZE - 1);
 			/* without finup() we need one block to close hash */
@@ -467,12 +469,12 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 		return -EINVAL;
 	}
 
-	ctx->flags |= FLAGS_SG;
+	ctx->flags |= BIT(FLAGS_SG);
 
 	ctx->total -= length;
 	ctx->offset = length; /* offset where to start slow */
 
-	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
+	final = (ctx->flags & BIT(FLAGS_FINUP)) && !ctx->total;
 
 	/* next call does not fail... so no unmap in the case of error */
 	return omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, final);
@@ -495,7 +497,7 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 
 	omap_stop_dma(dd->dma_lch);
-	if (ctx->flags & FLAGS_SG) {
+	if (ctx->flags & BIT(FLAGS_SG)) {
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
 		if (ctx->sg->length == ctx->offset) {
 			ctx->sg = sg_next(ctx->sg);
@@ -537,18 +539,18 @@ static int omap_sham_init(struct ahash_request *req)
 		crypto_ahash_digestsize(tfm));
 
 	if (crypto_ahash_digestsize(tfm) == SHA1_DIGEST_SIZE)
-		ctx->flags |= FLAGS_SHA1;
+		ctx->flags |= BIT(FLAGS_SHA1);
 
 	ctx->bufcnt = 0;
 	ctx->digcnt = 0;
 	ctx->buflen = BUFLEN;
 
-	if (tctx->flags & FLAGS_HMAC) {
+	if (tctx->flags & BIT(FLAGS_HMAC)) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
 
 		memcpy(ctx->buffer, bctx->ipad, SHA1_MD5_BLOCK_SIZE);
 		ctx->bufcnt = SHA1_MD5_BLOCK_SIZE;
-		ctx->flags |= FLAGS_HMAC;
+		ctx->flags |= BIT(FLAGS_HMAC);
 	}
 
 	return 0;
@@ -562,9 +564,9 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
 	int err;
 
 	dev_dbg(dd->dev, "update_req: total: %u, digcnt: %d, finup: %d\n",
-		 ctx->total, ctx->digcnt, (ctx->flags & FLAGS_FINUP) != 0);
+		 ctx->total, ctx->digcnt, (ctx->flags & BIT(FLAGS_FINUP)) != 0);
 
-	if (ctx->flags & FLAGS_CPU)
+	if (ctx->flags & BIT(FLAGS_CPU))
 		err = omap_sham_update_cpu(dd);
 	else
 		err = omap_sham_update_dma_start(dd);
@@ -624,7 +626,7 @@ static int omap_sham_finish(struct ahash_request *req)
 
 	if (ctx->digcnt) {
 		omap_sham_copy_ready_hash(req);
-		if (ctx->flags & FLAGS_HMAC)
+		if (ctx->flags & BIT(FLAGS_HMAC))
 			err = omap_sham_finish_hmac(req);
 	}
 
@@ -640,14 +642,14 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 
 	if (!err) {
 		omap_sham_copy_hash(req, 1);
-		if (ctx->flags & FLAGS_FINAL)
+		if (ctx->flags & BIT(FLAGS_FINAL))
 			err = omap_sham_finish(req);
 	} else {
-		ctx->flags |= FLAGS_ERROR;
+		ctx->flags |= BIT(FLAGS_ERROR);
 	}
 
 	clk_disable(dd->iclk);
-	dd->flags &= ~FLAGS_BUSY;
+	dd->flags &= ~BIT(FLAGS_BUSY);
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
@@ -664,14 +666,14 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
 		ret = ahash_enqueue_request(&dd->queue, req);
-	if (dd->flags & FLAGS_BUSY) {
+	if (dd->flags & BIT(FLAGS_BUSY)) {
 		spin_unlock_irqrestore(&dd->lock, flags);
 		return ret;
 	}
 	backlog = crypto_get_backlog(&dd->queue);
 	async_req = crypto_dequeue_request(&dd->queue);
 	if (async_req)
-		dd->flags |= FLAGS_BUSY;
+		dd->flags |= BIT(FLAGS_BUSY);
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
@@ -707,7 +709,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 
 	if (ctx->op == OP_UPDATE) {
 		err = omap_sham_update_req(dd);
-		if (err != -EINPROGRESS && (ctx->flags & FLAGS_FINUP))
+		if (err != -EINPROGRESS && (ctx->flags & BIT(FLAGS_FINUP)))
 			/* no final() after finup() */
 			err = omap_sham_final_req(dd);
 	} else if (ctx->op == OP_FINAL) {
@@ -747,7 +749,7 @@ static int omap_sham_update(struct ahash_request *req)
 	ctx->sg = req->src;
 	ctx->offset = 0;
 
-	if (ctx->flags & FLAGS_FINUP) {
+	if (ctx->flags & BIT(FLAGS_FINUP)) {
 		if ((ctx->digcnt + ctx->bufcnt + ctx->total) < 9) {
 			/*
 			* OMAP HW accel works only with buffers >= 9
@@ -760,7 +762,7 @@ static int omap_sham_update(struct ahash_request *req)
 			/*
 			* faster to use CPU for short transfers
 			*/
-			ctx->flags |= FLAGS_CPU;
+			ctx->flags |= BIT(FLAGS_CPU);
 		}
 	} else if (ctx->bufcnt + ctx->total < ctx->buflen) {
 		omap_sham_append_sg(ctx);
@@ -797,9 +799,9 @@ static int omap_sham_final(struct ahash_request *req)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 
-	ctx->flags |= FLAGS_FINUP;
+	ctx->flags |= BIT(FLAGS_FINUP);
 
-	if (ctx->flags & FLAGS_ERROR)
+	if (ctx->flags & BIT(FLAGS_ERROR))
 		return 0; /* uncompleted hash is not needed */
 
 	/* OMAP HW accel works only with buffers >= 9 */
@@ -818,7 +820,7 @@ static int omap_sham_finup(struct ahash_request *req)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	int err1, err2;
 
-	ctx->flags |= FLAGS_FINUP;
+	ctx->flags |= BIT(FLAGS_FINUP);
 
 	err1 = omap_sham_update(req);
 	if (err1 == -EINPROGRESS || err1 == -EBUSY)
@@ -890,7 +892,7 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 
 	if (alg_base) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
-		tctx->flags |= FLAGS_HMAC;
+		tctx->flags |= BIT(FLAGS_HMAC);
 		bctx->shash = crypto_alloc_shash(alg_base, 0,
 						CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(bctx->shash)) {
@@ -927,7 +929,7 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
 	crypto_free_shash(tctx->fallback);
 	tctx->fallback = NULL;
 
-	if (tctx->flags & FLAGS_HMAC) {
+	if (tctx->flags & BIT(FLAGS_HMAC)) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
 		crypto_free_shash(bctx->shash);
 	}
@@ -1035,13 +1037,13 @@ static void omap_sham_done_task(unsigned long data)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	int ready = 0, err = 0;
 
-	if (ctx->flags & FLAGS_OUTPUT_READY) {
-		ctx->flags &= ~FLAGS_OUTPUT_READY;
+	if (ctx->flags & BIT(FLAGS_OUTPUT_READY)) {
+		ctx->flags &= ~BIT(FLAGS_OUTPUT_READY);
 		ready = 1;
 	}
 
-	if (dd->flags & FLAGS_DMA_ACTIVE) {
-		dd->flags &= ~FLAGS_DMA_ACTIVE;
+	if (dd->flags & BIT(FLAGS_DMA_ACTIVE)) {
+		dd->flags &= ~BIT(FLAGS_DMA_ACTIVE);
 		omap_sham_update_dma_stop(dd);
 		if (!dd->err)
 			err = omap_sham_update_dma_start(dd);
@@ -1075,7 +1077,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	if (unlikely(ctx->flags & FLAGS_FINAL))
+	if (unlikely(ctx->flags & BIT(FLAGS_FINAL)))
 		/* final -> allow device to go to power-saving mode */
 		omap_sham_write_mask(dd, SHA_REG_CTRL, 0, SHA_REG_CTRL_LENGTH);
 
@@ -1083,7 +1085,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 				 SHA_REG_CTRL_OUTPUT_READY);
 	omap_sham_read(dd, SHA_REG_CTRL);
 
-	ctx->flags |= FLAGS_OUTPUT_READY;
+	ctx->flags |= BIT(FLAGS_OUTPUT_READY);
 	dd->err = 0;
 	tasklet_schedule(&dd->done_task);
 
@@ -1097,7 +1099,7 @@ static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
 	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
 		pr_err("omap-sham DMA error status: 0x%hx\n", ch_status);
 		dd->err = -EIO;
-		dd->flags &= ~FLAGS_INIT; /* request to re-initialize */
+		dd->flags &= ~BIT(FLAGS_INIT); /* request to re-initialize */
 	}
 
 	tasklet_schedule(&dd->done_task);
-- 
1.7.4.1
