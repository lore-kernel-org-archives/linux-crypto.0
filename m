From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 02/12] crypto: atmel-sha: update request queue management to make it more generic
Date: Thu, 22 Dec 2016 17:15:07 +0100
Message-ID: <f5f854b5e64cb46c66369f1e6f2fec9b7c4da83e.1482422983.git.cyrille.pitchen@atmel.com>
References: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:30257 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941296AbcLVQPT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 11:15:19 -0500
In-Reply-To: <cover.1482422983.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch is a transitional patch. It splits the atmel_sha_handle_queue()
function. Now atmel_sha_handle_queue() only manages the request queue and
calls a new .start() hook from the atmel_sha_ctx structure.
This hook allows to implement different kind of requests still handled by
a single queue.

Also when the req parameter of atmel_sha_handle_queue() refers to the very
same request as the one returned by crypto_dequeue_request(), the queue
management now gives a chance to this crypto request to be handled
synchronously, hence reducing latencies. The .start() hook returns 0 if
the crypto request was handled synchronously and -EINPROGRESS if the
crypto request still need to be handled asynchronously.

Besides, the new .is_async member of the atmel_sha_dev structure helps
tagging this asynchronous state. Indeed, the req->base.complete() callback
should not be called if the crypto request is handled synchronously.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 74 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 33a36e667547..2dbed8bb8d26 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -105,8 +105,11 @@ struct atmel_sha_reqctx {
 	u8 buffer[SHA_BUFFER_LEN + SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
 };
 
+typedef int (*atmel_sha_fn_t)(struct atmel_sha_dev *);
+
 struct atmel_sha_ctx {
 	struct atmel_sha_dev	*dd;
+	atmel_sha_fn_t		start;
 
 	unsigned long		flags;
 };
@@ -134,6 +137,7 @@ struct atmel_sha_dev {
 	unsigned long		flags;
 	struct crypto_queue	queue;
 	struct ahash_request	*req;
+	bool			is_async;
 
 	struct atmel_sha_dma	dma_lch_in;
 
@@ -163,6 +167,24 @@ static inline void atmel_sha_write(struct atmel_sha_dev *dd,
 	writel_relaxed(value, dd->io_base + offset);
 }
 
+static inline int atmel_sha_complete(struct atmel_sha_dev *dd, int err)
+{
+	struct ahash_request *req = dd->req;
+
+	dd->flags &= ~(SHA_FLAGS_BUSY | SHA_FLAGS_FINAL | SHA_FLAGS_CPU |
+		       SHA_FLAGS_DMA_READY | SHA_FLAGS_OUTPUT_READY);
+
+	clk_disable(dd->iclk);
+
+	if (dd->is_async && req->base.complete)
+		req->base.complete(&req->base, err);
+
+	/* handle new request */
+	tasklet_schedule(&dd->queue_task);
+
+	return err;
+}
+
 static size_t atmel_sha_append_sg(struct atmel_sha_reqctx *ctx)
 {
 	size_t count;
@@ -474,6 +496,8 @@ static void atmel_sha_dma_callback(void *data)
 {
 	struct atmel_sha_dev *dd = data;
 
+	dd->is_async = true;
+
 	/* dma_lch_in - completed - wait DATRDY */
 	atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
 }
@@ -509,7 +533,7 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	}
 	if (!in_desc)
-		return -EINVAL;
+		atmel_sha_complete(dd, -EINVAL);
 
 	in_desc->callback = atmel_sha_dma_callback;
 	in_desc->callback_param = dd;
@@ -566,7 +590,7 @@ static int atmel_sha_xmit_dma_map(struct atmel_sha_dev *dd,
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen +
 				ctx->block_size);
-		return -EINVAL;
+		atmel_sha_complete(dd, -EINVAL);
 	}
 
 	ctx->flags &= ~SHA_FLAGS_SG;
@@ -657,7 +681,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 		if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
 			dev_err(dd->dev, "dma %u bytes error\n",
 				ctx->buflen + ctx->block_size);
-			return -EINVAL;
+			atmel_sha_complete(dd, -EINVAL);
 		}
 
 		if (length == 0) {
@@ -671,7 +695,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 			if (!dma_map_sg(dd->dev, ctx->sg, 1,
 				DMA_TO_DEVICE)) {
 					dev_err(dd->dev, "dma_map_sg  error\n");
-					return -EINVAL;
+					atmel_sha_complete(dd, -EINVAL);
 			}
 
 			ctx->flags |= SHA_FLAGS_SG;
@@ -685,7 +709,7 @@ static int atmel_sha_update_dma_start(struct atmel_sha_dev *dd)
 
 	if (!dma_map_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
 		dev_err(dd->dev, "dma_map_sg  error\n");
-		return -EINVAL;
+		atmel_sha_complete(dd, -EINVAL);
 	}
 
 	ctx->flags |= SHA_FLAGS_SG;
@@ -843,16 +867,7 @@ static void atmel_sha_finish_req(struct ahash_request *req, int err)
 	}
 
 	/* atomic operation is not needed here */
-	dd->flags &= ~(SHA_FLAGS_BUSY | SHA_FLAGS_FINAL | SHA_FLAGS_CPU |
-			SHA_FLAGS_DMA_READY | SHA_FLAGS_OUTPUT_READY);
-
-	clk_disable(dd->iclk);
-
-	if (req->base.complete)
-		req->base.complete(&req->base, err);
-
-	/* handle new request */
-	tasklet_schedule(&dd->queue_task);
+	(void)atmel_sha_complete(dd, err);
 }
 
 static int atmel_sha_hw_init(struct atmel_sha_dev *dd)
@@ -893,8 +908,9 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 				  struct ahash_request *req)
 {
 	struct crypto_async_request *async_req, *backlog;
-	struct atmel_sha_reqctx *ctx;
+	struct atmel_sha_ctx *ctx;
 	unsigned long flags;
+	bool start_async;
 	int err = 0, ret = 0;
 
 	spin_lock_irqsave(&dd->lock, flags);
@@ -919,9 +935,22 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
-	req = ahash_request_cast(async_req);
-	dd->req = req;
-	ctx = ahash_request_ctx(req);
+	ctx = crypto_tfm_ctx(async_req->tfm);
+
+	dd->req = ahash_request_cast(async_req);
+	start_async = (dd->req != req);
+	dd->is_async = start_async;
+
+	/* WARNING: ctx->start() MAY change dd->is_async. */
+	err = ctx->start(dd);
+	return (start_async) ? ret : err;
+}
+
+static int atmel_sha_start(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	int err;
 
 	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %d\n",
 						ctx->op, req->nbytes);
@@ -947,7 +976,7 @@ static int atmel_sha_handle_queue(struct atmel_sha_dev *dd,
 
 	dev_dbg(dd->dev, "exit, err: %d\n", err);
 
-	return ret;
+	return err;
 }
 
 static int atmel_sha_enqueue(struct ahash_request *req, unsigned int op)
@@ -1043,8 +1072,11 @@ static int atmel_sha_import(struct ahash_request *req, const void *in)
 
 static int atmel_sha_cra_init(struct crypto_tfm *tfm)
 {
+	struct atmel_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct atmel_sha_reqctx));
+	ctx->start = atmel_sha_start;
 
 	return 0;
 }
@@ -1188,6 +1220,8 @@ static void atmel_sha_done_task(unsigned long data)
 	struct atmel_sha_dev *dd = (struct atmel_sha_dev *)data;
 	int err = 0;
 
+	dd->is_async = true;
+
 	if (SHA_FLAGS_CPU & dd->flags) {
 		if (SHA_FLAGS_OUTPUT_READY & dd->flags) {
 			dd->flags &= ~SHA_FLAGS_OUTPUT_READY;
-- 
2.7.4
