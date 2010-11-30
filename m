From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 2/6] omap-aes: redundant locking is removed
Date: Tue, 30 Nov 2010 10:13:28 +0200
Message-ID: <53efdd6bf0d375bc379437fba77cc461542e5bf4.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:51556 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0K3IM6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 03:12:58 -0500
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Submitting request involved double locking for enqueuing and
dequeuing. Now it is done under the same lock.

FLAGS_BUSY is now handled under the same lock.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   70 ++++++++++++++++++++------------------------
 1 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 41c91f3..2d8f72e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -78,7 +78,7 @@
 #define FLAGS_NEW_IV		BIT(5)
 #define FLAGS_INIT		BIT(6)
 #define FLAGS_FAST		BIT(7)
-#define FLAGS_BUSY		8
+#define FLAGS_BUSY		BIT(8)
 
 struct omap_aes_ctx {
 	struct omap_aes_dev *dd;
@@ -179,9 +179,8 @@ static int omap_aes_wait(struct omap_aes_dev *dd, u32 offset, u32 bit)
 
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
-	int err = 0;
-
 	clk_enable(dd->iclk);
+
 	if (!(dd->flags & FLAGS_INIT)) {
 		/* is it necessary to reset before every operation? */
 		omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_SOFTRESET,
@@ -193,18 +192,15 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		__asm__ __volatile__("nop");
 		__asm__ __volatile__("nop");
 
-		err = omap_aes_wait(dd, AES_REG_SYSSTATUS,
-				AES_REG_SYSSTATUS_RESETDONE);
-		if (!err)
-			dd->flags |= FLAGS_INIT;
+		if (omap_aes_wait(dd, AES_REG_SYSSTATUS,
+				AES_REG_SYSSTATUS_RESETDONE)) {
+			clk_disable(dd->iclk);
+			return -ETIMEDOUT;
+		}
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
@@ -538,6 +534,8 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
+	dd->flags &= ~FLAGS_BUSY;
+
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(dd->req));
 
 	if (!dd->total)
@@ -553,7 +551,7 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_MASK, 0, AES_REG_MASK_START);
 
-	omap_aes_hw_cleanup(dd);
+	clk_disable(dd->iclk);
 
 	omap_stop_dma(dd->dma_lch_in);
 	omap_stop_dma(dd->dma_lch_out);
@@ -580,22 +578,26 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
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
+	int err = 0;
 
 	spin_lock_irqsave(&dd->lock, flags);
+	if (req)
+		err = ablkcipher_enqueue_request(&dd->queue, req);
+	if (dd->flags & FLAGS_BUSY) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		return err;
+	}
 	backlog = crypto_get_backlog(&dd->queue);
 	async_req = crypto_dequeue_request(&dd->queue);
-	if (!async_req)
-		clear_bit(FLAGS_BUSY, &dd->flags);
+	if (async_req)
+		dd->flags |= FLAGS_BUSY;
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
@@ -637,20 +639,23 @@ static int omap_aes_handle_req(struct omap_aes_dev *dd)
 	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE))
 		pr_err("request size is not exact amount of AES blocks\n");
 
-start:
-	return omap_aes_crypt_dma_start(dd);
+	omap_aes_crypt_dma_start(dd);
+
+	return err;
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
@@ -661,8 +666,6 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd;
-	unsigned long flags;
-	int err;
 
 	pr_debug("nbytes: %d, enc: %d, cbc: %d\n", req->nbytes,
 		  !!(mode & FLAGS_ENCRYPT),
@@ -674,16 +677,7 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 
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
