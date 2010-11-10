From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 3/5] omap-aes: redundant locking is removed
Date: Wed, 10 Nov 2010 19:26:54 +0200
Message-ID: <bbebc4f4fa139dc19b6d3868c344d10cf204d2a5.1289409924.git.dmitry.kasatkin@nokia.com>
References: <y>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <y>
In-Reply-To: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
References: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Submitting request involved double locking for enqueuing and
dequeuing. Now it is done under the same lock.

FLAGS_BUSY is now handled under the same lock.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   68 ++++++++++++++++++++------------------------
 1 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 04cab70..a4d0ef4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -79,7 +79,7 @@
 #define FLAGS_NEW_IV		BIT(5)
 #define FLAGS_INIT		BIT(6)
 #define FLAGS_FAST		BIT(7)
-#define FLAGS_BUSY		8
+#define FLAGS_BUSY		BIT(8)
 
 struct omap_aes_ctx {
 	struct omap_aes_dev *dd;
@@ -180,9 +180,10 @@ static int omap_aes_wait(struct omap_aes_dev *dd, u32 offset, u32 bit)
 
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
-	int err = 0;
+	int err;
 
 	clk_enable(dd->iclk);
+
 	if (!(dd->flags & FLAGS_INIT)) {
 		/* is it necessary to reset before every operation? */
 		omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_SOFTRESET,
@@ -195,18 +196,14 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		if (cpu_is_omap3630())
 			udelay(1);
 
-		err = omap_aes_wait(dd, AES_REG_SYSSTATUS,
-				AES_REG_SYSSTATUS_RESETDONE);
-		if (!err)
-			dd->flags |= FLAGS_INIT;
+		if (omap_aes_wait(dd, AES_REG_SYSSTATUS,
+				AES_REG_SYSSTATUS_RESETDONE)) {
+			clk_disable(dd->iclk);
+			return -ETIMEDOUT;
+		dd->flags |= FLAGS_INIT;
 	}
 
-	return err;
-}
-
-static void omap_aes_hw_cleanup(struct omap_aes_dev *dd)
-{
-	clk_disable(dd->iclk);
+	return 0;
 }
 
 static void omap_aes_write_ctrl(struct omap_aes_dev *dd)
@@ -540,6 +537,8 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
+	dd->flags &= ~FLAGS_BUSY;
+
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(dd->req));
 
 	if (!dd->total)
@@ -555,7 +554,7 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_MASK, 0, AES_REG_MASK_START);
 
-	omap_aes_hw_cleanup(dd);
+	clk_disable(dd->iclk);
 
 	omap_stop_dma(dd->dma_lch_in);
 	omap_stop_dma(dd->dma_lch_out);
@@ -582,22 +581,27 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	return err;
 }
 
-static int omap_aes_handle_req(struct omap_aes_dev *dd)
+static int omap_aes_handle_req(struct omap_aes_dev *dd,
+			       struct ablkcipher_request *req)
 {
 	struct crypto_async_request *async_req, *backlog;
 	struct omap_aes_ctx *ctx;
 	struct omap_aes_reqctx *rctx;
-	struct ablkcipher_request *req;
 	unsigned long flags;
-
-	if (dd->total)
-		goto start;
+	int err;
 
 	spin_lock_irqsave(&dd->lock, flags);
-	backlog = crypto_get_backlog(&dd->queue);
+	if (req)
+		err = ablkcipher_enqueue_request(&dd->queue, req);
+	if (dd->flags & FLAGS_BUSY) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return err;
+	}
 	async_req = crypto_dequeue_request(&dd->queue);
-	if (!async_req)
-		clear_bit(FLAGS_BUSY, &dd->flags);
+	if (async_req) {
+		dd->flags |= FLAGS_BUSY;
+		backlog = crypto_get_backlog(&dd->queue);
+	}
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
@@ -639,20 +643,21 @@ static int omap_aes_handle_req(struct omap_aes_dev *dd)
 	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE))
 		pr_err("request size is not exact amount of AES blocks\n");
 
-start:
 	return omap_aes_crypt_dma_start(dd);
 }
 
 static void omap_aes_task(unsigned long data)
 {
 	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
-	int err;
 
 	pr_debug("enter\n");
 
-	err = omap_aes_crypt_dma_stop(dd);
+	omap_aes_crypt_dma_stop(dd);
 
-	err = omap_aes_handle_req(dd);
+	if (dd->total)
+		omap_aes_crypt_dma_start(dd);
+	else
+		omap_aes_handle_req(dd, NULL);
 
 	pr_debug("exit\n");
 }
@@ -663,8 +668,6 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd;
-	unsigned long flags;
-	int err;
 
 	pr_debug("nbytes: %d, enc: %d, cbc: %d\n", req->nbytes,
 		  !!(mode & FLAGS_ENCRYPT),
@@ -676,16 +679,7 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	spin_lock_irqsave(&dd->lock, flags);
-	err = ablkcipher_enqueue_request(&dd->queue, req);
-	spin_unlock_irqrestore(&dd->lock, flags);
-
-	if (!test_and_set_bit(FLAGS_BUSY, &dd->flags))
-		omap_aes_handle_req(dd);
-
-	pr_debug("exit\n");
-
-	return err;
+	return omap_aes_handle_req(dd, req);
 }
 
 /* ********************** ALG API ************************************ */
-- 
1.7.0.4

