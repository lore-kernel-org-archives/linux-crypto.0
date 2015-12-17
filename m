From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 08/24] crypto: atmel-aes: make crypto request queue management more generic
Date: Thu, 17 Dec 2015 17:48:39 +0100
Message-ID: <04fe5ec37b0e27d8a937b04ec9742fb26e88ae8f.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56661 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbbLQQvA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 11:51:00 -0500
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes atmel_aes_handle_queue() to make it more generic.
The function argument is now a pointer to struct crypto_async_request,
which is the common base of struct ablkcipher_request and
struct aead_request.

Also this patch introduces struct atmel_aes_base_ctx which will be the
common base of all the transformation contexts.

Hence the very same queue will be used to manage both block cipher and
AEAD requests (such as gcm and authenc implemented in further patches).

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 75 ++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index ccb8a8322bf7..48407a7f6f61 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -78,8 +78,13 @@ struct atmel_aes_caps {
 
 struct atmel_aes_dev;
 
-struct atmel_aes_ctx {
+
+typedef int (*atmel_aes_fn_t)(struct atmel_aes_dev *);
+
+
+struct atmel_aes_base_ctx {
 	struct atmel_aes_dev *dd;
+	atmel_aes_fn_t	start;
 
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
@@ -87,6 +92,10 @@ struct atmel_aes_ctx {
 	u16		block_size;
 };
 
+struct atmel_aes_ctx {
+	struct atmel_aes_base_ctx	base;
+};
+
 struct atmel_aes_reqctx {
 	unsigned long mode;
 };
@@ -101,7 +110,9 @@ struct atmel_aes_dev {
 	unsigned long		phys_base;
 	void __iomem		*io_base;
 
-	struct atmel_aes_ctx	*ctx;
+	struct crypto_async_request	*areq;
+	struct atmel_aes_base_ctx	*ctx;
+
 	struct device		*dev;
 	struct clk		*iclk;
 	int	irq;
@@ -115,7 +126,6 @@ struct atmel_aes_dev {
 	struct tasklet_struct	done_task;
 	struct tasklet_struct	queue_task;
 
-	struct ablkcipher_request	*req;
 	size_t	total;
 
 	struct scatterlist	*in_sg;
@@ -236,7 +246,7 @@ static void atmel_aes_write_n(struct atmel_aes_dev *dd, u32 offset,
 		atmel_aes_write(dd, offset, *value);
 }
 
-static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_ctx *ctx)
+static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_base_ctx *ctx)
 {
 	struct atmel_aes_dev *aes_dd = NULL;
 	struct atmel_aes_dev *tmp;
@@ -298,7 +308,7 @@ static int atmel_aes_hw_version_init(struct atmel_aes_dev *dd)
 
 static void atmel_aes_finish_req(struct atmel_aes_dev *dd, int err)
 {
-	struct ablkcipher_request *req = dd->req;
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
 
 	clk_disable_unprepare(dd->iclk);
 	dd->flags &= ~AES_FLAGS_BUSY;
@@ -396,6 +406,8 @@ static int atmel_aes_crypt_dma(struct atmel_aes_dev *dd,
 
 static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+
 	dd->flags &= ~AES_FLAGS_DMA;
 
 	dma_sync_single_for_cpu(dd->dev, dd->dma_addr_in,
@@ -404,11 +416,11 @@ static int atmel_aes_crypt_cpu_start(struct atmel_aes_dev *dd)
 				dd->dma_size, DMA_FROM_DEVICE);
 
 	/* use cache buffers */
-	dd->nb_in_sg = atmel_aes_sg_length(dd->req, dd->in_sg);
+	dd->nb_in_sg = atmel_aes_sg_length(req, dd->in_sg);
 	if (!dd->nb_in_sg)
 		return -EINVAL;
 
-	dd->nb_out_sg = atmel_aes_sg_length(dd->req, dd->out_sg);
+	dd->nb_out_sg = atmel_aes_sg_length(req, dd->out_sg);
 	if (!dd->nb_out_sg)
 		return -EINVAL;
 
@@ -556,38 +568,49 @@ static void atmel_aes_write_ctrl(struct atmel_aes_dev *dd, bool use_dma,
 }
 
 static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
-			       struct ablkcipher_request *req)
+				  struct crypto_async_request *new_areq)
 {
-	struct crypto_async_request *async_req, *backlog;
-	struct atmel_aes_ctx *ctx;
-	struct atmel_aes_reqctx *rctx;
+	struct crypto_async_request *areq, *backlog;
+	struct atmel_aes_base_ctx *ctx;
 	unsigned long flags;
 	int err, ret = 0;
-	bool use_dma;
 
 	spin_lock_irqsave(&dd->lock, flags);
-	if (req)
-		ret = ablkcipher_enqueue_request(&dd->queue, req);
+	if (new_areq)
+		ret = crypto_enqueue_request(&dd->queue, new_areq);
 	if (dd->flags & AES_FLAGS_BUSY) {
 		spin_unlock_irqrestore(&dd->lock, flags);
 		return ret;
 	}
 	backlog = crypto_get_backlog(&dd->queue);
-	async_req = crypto_dequeue_request(&dd->queue);
-	if (async_req)
+	areq = crypto_dequeue_request(&dd->queue);
+	if (areq)
 		dd->flags |= AES_FLAGS_BUSY;
 	spin_unlock_irqrestore(&dd->lock, flags);
 
-	if (!async_req)
+	if (!areq)
 		return ret;
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
-	req = ablkcipher_request_cast(async_req);
+	ctx = crypto_tfm_ctx(areq->tfm);
+
+	dd->areq = areq;
+	dd->ctx = ctx;
+
+	err = ctx->start(dd);
+	return (areq != new_areq) ? ret : err;
+}
+
+static int atmel_aes_start(struct atmel_aes_dev *dd)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+	struct atmel_aes_reqctx *rctx;
+	bool use_dma;
+	int err;
 
 	/* assign new request to device */
-	dd->req = req;
 	dd->total = req->nbytes;
 	dd->in_offset = 0;
 	dd->in_sg = req->src;
@@ -595,11 +618,8 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	dd->out_sg = req->dst;
 
 	rctx = ablkcipher_request_ctx(req);
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= AES_FLAGS_MODE_MASK;
 	dd->flags = (dd->flags & ~AES_FLAGS_MODE_MASK) | rctx->mode;
-	dd->ctx = ctx;
-	ctx->dd = dd;
 
 	err = atmel_aes_hw_init(dd);
 	if (!err) {
@@ -616,7 +636,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 		tasklet_schedule(&dd->queue_task);
 	}
 
-	return ret;
+	return -EINPROGRESS;
 }
 
 static int atmel_aes_crypt_dma_stop(struct atmel_aes_dev *dd)
@@ -704,7 +724,7 @@ static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 
 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
-	struct atmel_aes_ctx *ctx = crypto_ablkcipher_ctx(
+	struct atmel_aes_base_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct atmel_aes_dev *dd;
@@ -747,7 +767,7 @@ static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	return atmel_aes_handle_queue(dd, req);
+	return atmel_aes_handle_queue(dd, &req->base);
 }
 
 static bool atmel_aes_filter(struct dma_chan *chan, void *slave)
@@ -822,7 +842,7 @@ static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
 static int atmel_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	struct atmel_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct atmel_aes_base_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
 		   keylen != AES_KEYSIZE_256) {
@@ -946,7 +966,10 @@ static int atmel_aes_ctr_decrypt(struct ablkcipher_request *req)
 
 static int atmel_aes_cra_init(struct crypto_tfm *tfm)
 {
+	struct atmel_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
 	tfm->crt_ablkcipher.reqsize = sizeof(struct atmel_aes_reqctx);
+	ctx->base.start = atmel_aes_start;
 
 	return 0;
 }
-- 
1.8.2.2
