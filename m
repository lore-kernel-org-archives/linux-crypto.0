From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 05/11] omap-sham: move some flags to device context
Date: Thu,  2 Jun 2011 21:10:07 +0300
Message-ID: <45316cd4c56a940bb29b23bda5c6c196c29c78ea.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Couple of context flags have been moved to device flags.
IRQ and tasklet handlers does not need to access request
context anymore.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 208404e..b959dc6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -303,7 +303,7 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 		return -ETIMEDOUT;
 
 	if (final)
-		set_bit(FLAGS_FINAL, &ctx->flags); /* catch last interrupt */
+		set_bit(FLAGS_FINAL, &dd->flags); /* catch last interrupt */
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
@@ -336,7 +336,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	ctx->digcnt += length;
 
 	if (final)
-		set_bit(FLAGS_FINAL, &ctx->flags); /* catch last interrupt */
+		set_bit(FLAGS_FINAL, &dd->flags); /* catch last interrupt */
 
 	set_bit(FLAGS_DMA_ACTIVE, &dd->flags);
 
@@ -642,7 +642,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 
 	if (!err) {
 		omap_sham_copy_hash(req, 1);
-		if (test_bit(FLAGS_FINAL, &ctx->flags))
+		if (test_bit(FLAGS_FINAL, &dd->flags))
 			err = omap_sham_finish(req);
 	} else {
 		ctx->flags |= BIT(FLAGS_ERROR);
@@ -1034,10 +1034,9 @@ static void omap_sham_done_task(unsigned long data)
 {
 	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
 	struct ahash_request *req = dd->req;
-	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	int ready = 0, err = 0;
 
-	if (test_and_clear_bit(FLAGS_OUTPUT_READY, &ctx->flags))
+	if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
 		ready = 1;
 
 	if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
@@ -1067,14 +1066,8 @@ static void omap_sham_queue_task(unsigned long data)
 static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 {
 	struct omap_sham_dev *dd = dev_id;
-	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-
-	if (!ctx) {
-		dev_err(dd->dev, "unknown interrupt.\n");
-		return IRQ_HANDLED;
-	}
 
-	if (unlikely(test_bit(FLAGS_FINAL, &ctx->flags)))
+	if (unlikely(test_bit(FLAGS_FINAL, &dd->flags)))
 		/* final -> allow device to go to power-saving mode */
 		omap_sham_write_mask(dd, SHA_REG_CTRL, 0, SHA_REG_CTRL_LENGTH);
 
@@ -1082,7 +1075,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 				 SHA_REG_CTRL_OUTPUT_READY);
 	omap_sham_read(dd, SHA_REG_CTRL);
 
-	set_bit(FLAGS_OUTPUT_READY, &ctx->flags);
+	set_bit(FLAGS_OUTPUT_READY, &dd->flags);
 	dd->err = 0;
 	tasklet_schedule(&dd->done_task);
 
-- 
1.7.4.1

