From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 4/5] omap-aes: error handling implementation improved
Date: Wed, 10 Nov 2010 19:26:55 +0200
Message-ID: <ec8cdb4e9fc493f740deab8fb8807cc55b082ddf.1289409924.git.dmitry.kasatkin@nokia.com>
References: <y>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:20074 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab0KJR1a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 12:27:30 -0500
In-Reply-To: <y>
In-Reply-To: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
References: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Previous version had not error handling.
Request could remain uncompleted.

Also in the case of DMA error, FLAGS_INIT is unset
and accelerator will be initialized again.

Buffer size allignment is checked.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |  135 +++++++++++++++++++++++++++++++--------------
 1 files changed, 94 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index a4d0ef4..704c9d1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -104,14 +104,16 @@ struct omap_aes_dev {
 	struct omap_aes_ctx	*ctx;
 	struct device		*dev;
 	unsigned long		flags;
+	int			err;
 
 	u32			*iv;
 	u32			ctrl;
 
-	spinlock_t			lock;
-	struct crypto_queue		queue;
+	spinlock_t		lock;
+	struct crypto_queue	queue;
 
-	struct tasklet_struct		task;
+	struct tasklet_struct	done_task;
+	struct tasklet_struct	queue_task;
 
 	struct ablkcipher_request	*req;
 	size_t				total;
@@ -180,8 +182,6 @@ static int omap_aes_wait(struct omap_aes_dev *dd, u32 offset, u32 bit)
 
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
-	int err;
-
 	clk_enable(dd->iclk);
 
 	if (!(dd->flags & FLAGS_INIT)) {
@@ -200,25 +200,32 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 				AES_REG_SYSSTATUS_RESETDONE)) {
 			clk_disable(dd->iclk);
 			return -ETIMEDOUT;
+		}
 		dd->flags |= FLAGS_INIT;
+		dd->err = 0;
 	}
 
 	return 0;
 }
 
-static void omap_aes_write_ctrl(struct omap_aes_dev *dd)
+static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 {
 	unsigned int key32;
-	int i;
+	int i, err, init = dd->flags & FLAGS_INIT;
 	u32 val, mask;
 
+	err = omap_aes_hw_init(dd);
+	if (err)
+		return err;
+
 	val = FLD_VAL(((dd->ctx->keylen >> 3) - 1), 4, 3);
 	if (dd->flags & FLAGS_CBC)
 		val |= AES_REG_CTRL_CBC;
 	if (dd->flags & FLAGS_ENCRYPT)
 		val |= AES_REG_CTRL_DIRECTION;
 
-	if (dd->ctrl == val && !(dd->flags & FLAGS_NEW_IV) &&
+	/* check if hw state & mode have not changed */
+	if (init && dd->ctrl == val && !(dd->flags & FLAGS_NEW_IV) &&
 		   !(dd->ctx->flags & FLAGS_NEW_KEY))
 		goto out;
 
@@ -260,6 +267,8 @@ out:
 	/* start DMA or disable idle mode */
 	omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_START,
 			    AES_REG_MASK_START);
+
+	return 0;
 }
 
 static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
@@ -287,8 +296,16 @@ static void omap_aes_dma_callback(int lch, u16 ch_status, void *data)
 {
 	struct omap_aes_dev *dd = data;
 
-	if (lch == dd->dma_lch_out)
-		tasklet_schedule(&dd->task);
+	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
+		pr_err("omap-aes DMA error status: 0x%hx\n", ch_status);
+		dd->err = -EIO;
+		dd->flags &= ~FLAGS_INIT; /* request to re-initialize */
+	} else if (lch == dd->dma_lch_in) {
+		return;
+	}
+
+	/* dma_lch_out - completed */
+	tasklet_schedule(&dd->done_task);
 }
 
 static int omap_aes_dma_init(struct omap_aes_dev *dd)
@@ -393,6 +410,11 @@ static int sg_copy(struct scatterlist **sg, size_t *offset, void *buf,
 		if (!count)
 			return off;
 
+		/*
+		 * buflen and total are AES_BLOCK_SIZE size aligned,
+		 * so count should be also aligned
+		 */
+
 		sg_copy_buf(buf + off, *sg, *offset, count, out);
 
 		off += count;
@@ -418,6 +440,7 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct omap_aes_dev *dd = ctx->dd;
 	int len32;
+	int err;
 
 	pr_debug("len: %d\n", length);
 
@@ -457,11 +480,13 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	omap_set_dma_dest_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_addr_out, 0, 0);
 
+	err = omap_aes_write_ctrl(dd);
+	if (err)
+		return err;
+
 	omap_start_dma(dd->dma_lch_in);
 	omap_start_dma(dd->dma_lch_out);
 
-	omap_aes_write_ctrl(dd);
-
 	return 0;
 }
 
@@ -487,8 +512,10 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 		count = min(dd->total, sg_dma_len(dd->in_sg));
 		count = min(count, sg_dma_len(dd->out_sg));
 
-		if (count != dd->total)
+		if (count != dd->total) {
+			pr_err("request length != buffer length\n");
 			return -EINVAL;
+		}
 
 		pr_debug("fast\n");
 
@@ -524,25 +551,28 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 
 	dd->total -= count;
 
-	err = omap_aes_hw_init(dd);
-
 	err = omap_aes_crypt_dma(tfm, addr_in, addr_out, count);
+	if (err) {
+		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
+		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_TO_DEVICE);
+	}
 
 	return err;
 }
 
 static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 {
+	struct ablkcipher_request *req = dd->req;
 	struct omap_aes_ctx *ctx;
 
 	pr_debug("err: %d\n", err);
 
 	dd->flags &= ~FLAGS_BUSY;
 
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(dd->req));
+	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 
-	if (!dd->total)
-		dd->req->base.complete(&dd->req->base, err);
+	if (req->base.complete)
+		req->base.complete(&req->base, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -554,11 +584,11 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_MASK, 0, AES_REG_MASK_START);
 
-	clk_disable(dd->iclk);
-
 	omap_stop_dma(dd->dma_lch_in);
 	omap_stop_dma(dd->dma_lch_out);
 
+	clk_disable(dd->iclk);
+
 	if (dd->flags & FLAGS_FAST) {
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
@@ -575,27 +605,24 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 		}
 	}
 
-	if (err || !dd->total)
-		omap_aes_finish_req(dd, err);
-
 	return err;
 }
 
-static int omap_aes_handle_req(struct omap_aes_dev *dd,
+static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 			       struct ablkcipher_request *req)
 {
 	struct crypto_async_request *async_req, *backlog;
 	struct omap_aes_ctx *ctx;
 	struct omap_aes_reqctx *rctx;
 	unsigned long flags;
-	int err;
+	int err, ret = 0;
 
 	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
-		err = ablkcipher_enqueue_request(&dd->queue, req);
+		ret = ablkcipher_enqueue_request(&dd->queue, req);
 	if (dd->flags & FLAGS_BUSY) {
 		spin_unlock_irqrestore(&dd->lock, flags);
-		return err;
+		return ret;
 	}
 	async_req = crypto_dequeue_request(&dd->queue);
 	if (async_req) {
@@ -605,7 +632,7 @@ static int omap_aes_handle_req(struct omap_aes_dev *dd,
 	spin_unlock_irqrestore(&dd->lock, flags);
 
 	if (!async_req)
-		return 0;
+		return ret;
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -640,28 +667,46 @@ static int omap_aes_handle_req(struct omap_aes_dev *dd,
 		ctx->flags |= FLAGS_NEW_KEY;
 	}
 
-	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE))
-		pr_err("request size is not exact amount of AES blocks\n");
+	err = omap_aes_crypt_dma_start(dd);
+	if (err) {
+		/* aes_task will not finish it, so do it here */
+		omap_aes_finish_req(dd, err);
+		tasklet_schedule(&dd->queue_task);
+	}
 
-	return omap_aes_crypt_dma_start(dd);
+	return ret; /* return ret, which is enqueue return value */
 }
 
-static void omap_aes_task(unsigned long data)
+static void omap_aes_done_task(unsigned long data)
 {
 	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+	int err;
 
 	pr_debug("enter\n");
 
-	omap_aes_crypt_dma_stop(dd);
+	err = omap_aes_crypt_dma_stop(dd);
 
-	if (dd->total)
-		omap_aes_crypt_dma_start(dd);
-	else
-		omap_aes_handle_req(dd, NULL);
+	err = dd->err ? : err;
+
+	if (dd->total && !err) {
+		err = omap_aes_crypt_dma_start(dd);
+		if (!err)
+			return; /* DMA started. Not fininishing. */
+	}
+
+	omap_aes_finish_req(dd, err);
+	omap_aes_handle_queue(dd, NULL);
 
 	pr_debug("exit\n");
 }
 
+static void omap_aes_queue_task(unsigned long data)
+{
+	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+
+	omap_aes_handle_queue(dd, NULL);
+}
+
 static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
@@ -673,13 +718,18 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		  !!(mode & FLAGS_ENCRYPT),
 		  !!(mode & FLAGS_CBC));
 
+	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE)) {
+		pr_err("request size is not exact amount of AES blocks\n");
+		return -EINVAL;
+	}
+
 	dd = omap_aes_find_dev(ctx);
 	if (!dd)
 		return -ENODEV;
 
 	rctx->mode = mode;
 
-	return omap_aes_handle_req(dd, req);
+	return omap_aes_handle_queue(dd, req);
 }
 
 /* ********************** ALG API ************************************ */
@@ -845,7 +895,8 @@ static int omap_aes_probe(struct platform_device *pdev)
 		 (reg & AES_REG_REV_MAJOR) >> 4, reg & AES_REG_REV_MINOR);
 	clk_disable(dd->iclk);
 
-	tasklet_init(&dd->task, omap_aes_task, (unsigned long)dd);
+	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
+	tasklet_init(&dd->queue_task, omap_aes_queue_task, (unsigned long)dd);
 
 	err = omap_aes_dma_init(dd);
 	if (err)
@@ -872,7 +923,8 @@ err_algs:
 		crypto_unregister_alg(&algs[j]);
 	omap_aes_dma_cleanup(dd);
 err_dma:
-	tasklet_kill(&dd->task);
+	tasklet_kill(&dd->done_task);
+	tasklet_kill(&dd->queue_task);
 	iounmap(dd->io_base);
 err_io:
 	clk_put(dd->iclk);
@@ -899,7 +951,8 @@ static int omap_aes_remove(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(algs); i++)
 		crypto_unregister_alg(&algs[i]);
 
-	tasklet_kill(&dd->task);
+	tasklet_kill(&dd->done_task);
+	tasklet_kill(&dd->queue_task);
 	omap_aes_dma_cleanup(dd);
 	iounmap(dd->io_base);
 	clk_put(dd->iclk);
-- 
1.7.0.4
