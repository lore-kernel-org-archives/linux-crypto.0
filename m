From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 04/11] omap-sham: replace flags operation with atomic bit operations
Date: Thu,  2 Jun 2011 21:10:06 +0300
Message-ID: <daaea9c543bf7a882b93850b374a2ebfb6ab850b.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58398 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1FBSKf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2011 14:10:35 -0400
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Some flags are changed in interrupt handlers and verified in the tasklet.
There might be a race condition when tasklet is interrupted or another
cpu/core will run IRQ handler and tasklet in parallel.
Atomic bitops functions are now used instead of bitmask operations.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 64698ad..208404e 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -240,7 +240,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
 	clk_enable(dd->iclk);
 
-	if (!(dd->flags & BIT(FLAGS_INIT))) {
+	if (!test_bit(FLAGS_INIT, &dd->flags)) {
 		omap_sham_write_mask(dd, SHA_REG_MASK,
 			SHA_REG_MASK_SOFTRESET, SHA_REG_MASK_SOFTRESET);
 
@@ -248,7 +248,7 @@ static int omap_sham_hw_init(struct omap_sham_dev *dd)
 					SHA_REG_SYSSTATUS_RESETDONE))
 			return -ETIMEDOUT;
 
-		dd->flags |= BIT(FLAGS_INIT);
+		set_bit(FLAGS_INIT, &dd->flags);
 		dd->err = 0;
 	}
 
@@ -303,7 +303,7 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 		return -ETIMEDOUT;
 
 	if (final)
-		ctx->flags |= BIT(FLAGS_FINAL); /* catch last interrupt */
+		set_bit(FLAGS_FINAL, &ctx->flags); /* catch last interrupt */
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
@@ -336,9 +336,9 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	ctx->digcnt += length;
 
 	if (final)
-		ctx->flags |= BIT(FLAGS_FINAL); /* catch last interrupt */
+		set_bit(FLAGS_FINAL, &ctx->flags); /* catch last interrupt */
 
-	dd->flags |= BIT(FLAGS_DMA_ACTIVE);
+	set_bit(FLAGS_DMA_ACTIVE, &dd->flags);
 
 	omap_start_dma(dd->dma_lch);
 
@@ -642,7 +642,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 
 	if (!err) {
 		omap_sham_copy_hash(req, 1);
-		if (ctx->flags & BIT(FLAGS_FINAL))
+		if (test_bit(FLAGS_FINAL, &ctx->flags))
 			err = omap_sham_finish(req);
 	} else {
 		ctx->flags |= BIT(FLAGS_ERROR);
@@ -666,14 +666,14 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
 		ret = ahash_enqueue_request(&dd->queue, req);
-	if (dd->flags & BIT(FLAGS_BUSY)) {
+	if (test_bit(FLAGS_BUSY, &dd->flags)) {
 		spin_unlock_irqrestore(&dd->lock, flags);
 		return ret;
 	}
 	backlog = crypto_get_backlog(&dd->queue);
 	async_req = crypto_dequeue_request(&dd->queue);
 	if (async_req)
-		dd->flags |= BIT(FLAGS_BUSY);
+		set_bit(FLAGS_BUSY, &dd->flags);
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
@@ -1037,13 +1037,10 @@ static void omap_sham_done_task(unsigned long data)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	int ready = 0, err = 0;
 
-	if (ctx->flags & BIT(FLAGS_OUTPUT_READY)) {
-		ctx->flags &= ~BIT(FLAGS_OUTPUT_READY);
+	if (test_and_clear_bit(FLAGS_OUTPUT_READY, &ctx->flags))
 		ready = 1;
-	}
 
-	if (dd->flags & BIT(FLAGS_DMA_ACTIVE)) {
-		dd->flags &= ~BIT(FLAGS_DMA_ACTIVE);
+	if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
 		omap_sham_update_dma_stop(dd);
 		if (!dd->err)
 			err = omap_sham_update_dma_start(dd);
@@ -1077,7 +1074,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	if (unlikely(ctx->flags & BIT(FLAGS_FINAL)))
+	if (unlikely(test_bit(FLAGS_FINAL, &ctx->flags)))
 		/* final -> allow device to go to power-saving mode */
 		omap_sham_write_mask(dd, SHA_REG_CTRL, 0, SHA_REG_CTRL_LENGTH);
 
@@ -1085,7 +1082,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 				 SHA_REG_CTRL_OUTPUT_READY);
 	omap_sham_read(dd, SHA_REG_CTRL);
 
-	ctx->flags |= BIT(FLAGS_OUTPUT_READY);
+	set_bit(FLAGS_OUTPUT_READY, &ctx->flags);
 	dd->err = 0;
 	tasklet_schedule(&dd->done_task);
 
@@ -1099,7 +1096,7 @@ static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
 	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
 		pr_err("omap-sham DMA error status: 0x%hx\n", ch_status);
 		dd->err = -EIO;
-		dd->flags &= ~BIT(FLAGS_INIT); /* request to re-initialize */
+		clear_bit(FLAGS_INIT, &dd->flags);/* request to re-initialize */
 	}
 
 	tasklet_schedule(&dd->done_task);
-- 
1.7.4.1
