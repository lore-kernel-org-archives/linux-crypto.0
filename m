From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 3/3] crypto: omap-aes: Support crypto engine framework
Date: Tue, 26 Jan 2016 20:25:40 +0800
Message-ID: <dd706b9e54d6cbdc8eddc16f53699959f1a0726f.1453810717.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	baolin.wang@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33600 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509AbcAZM0k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 07:26:40 -0500
Received: by mail-pa0-f53.google.com with SMTP id cy9so97277425pac.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2016 04:26:40 -0800 (PST)
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Integrate with the newly added crypto engine to make the crypto hardware
engine underutilized as each block needs to be processed before the crypto
hardware can start working on the next block.

The requests from dm-crypt will be listed into engine queue and processed
by engine automatically, so remove the 'queue' and 'queue_task' things in
omap aes driver.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/crypto/Kconfig    |    1 +
 drivers/crypto/omap-aes.c |   97 ++++++++++++++++++++-------------------------
 2 files changed, 45 insertions(+), 53 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2569e04..4945311 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -293,6 +293,7 @@ config CRYPTO_DEV_OMAP_AES
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || ARCH_OMAP2PLUS
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_ENGINE
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index eba2314..4ee3acc 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -36,6 +36,7 @@
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
@@ -152,13 +153,10 @@ struct omap_aes_dev {
 	unsigned long		flags;
 	int			err;
 
-	spinlock_t		lock;
-	struct crypto_queue	queue;
-
 	struct tasklet_struct	done_task;
-	struct tasklet_struct	queue_task;
 
 	struct ablkcipher_request	*req;
+	struct crypto_engine		*engine;
 
 	/*
 	 * total is used by PIO mode for book keeping so introduce
@@ -532,9 +530,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	dd->flags &= ~FLAGS_BUSY;
-
-	req->base.complete(&req->base, err);
+	crypto_finalize_request(dd->engine, req, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -606,34 +602,25 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 }
 
 static int omap_aes_handle_queue(struct omap_aes_dev *dd,
-			       struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
-	struct crypto_async_request *async_req, *backlog;
-	struct omap_aes_ctx *ctx;
-	struct omap_aes_reqctx *rctx;
-	unsigned long flags;
-	int err, ret = 0, len;
-
-	spin_lock_irqsave(&dd->lock, flags);
 	if (req)
-		ret = ablkcipher_enqueue_request(&dd->queue, req);
-	if (dd->flags & FLAGS_BUSY) {
-		spin_unlock_irqrestore(&dd->lock, flags);
-		return ret;
-	}
-	backlog = crypto_get_backlog(&dd->queue);
-	async_req = crypto_dequeue_request(&dd->queue);
-	if (async_req)
-		dd->flags |= FLAGS_BUSY;
-	spin_unlock_irqrestore(&dd->lock, flags);
+		return crypto_transfer_request_to_engine(dd->engine, req);
 
-	if (!async_req)
-		return ret;
+	return 0;
+}
 
-	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
+static int omap_aes_prepare_req(struct crypto_engine *engine,
+				struct ablkcipher_request *req)
+{
+	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
+	struct omap_aes_reqctx *rctx;
+	int len;
 
-	req = ablkcipher_request_cast(async_req);
+	if (!dd)
+		return -ENODEV;
 
 	/* assign new request to device */
 	dd->req = req;
@@ -664,16 +651,20 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	dd->ctx = ctx;
 	ctx->dd = dd;
 
-	err = omap_aes_write_ctrl(dd);
-	if (!err)
-		err = omap_aes_crypt_dma_start(dd);
-	if (err) {
-		/* aes_task will not finish it, so do it here */
-		omap_aes_finish_req(dd, err);
-		tasklet_schedule(&dd->queue_task);
-	}
+	return omap_aes_write_ctrl(dd);
+}
 
-	return ret; /* return ret, which is enqueue return value */
+static int omap_aes_crypt_req(struct crypto_engine *engine,
+			      struct ablkcipher_request *req)
+{
+	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
+
+	if (!dd)
+		return -ENODEV;
+
+	return omap_aes_crypt_dma_start(dd);
 }
 
 static void omap_aes_done_task(unsigned long data)
@@ -706,18 +697,10 @@ static void omap_aes_done_task(unsigned long data)
 	}
 
 	omap_aes_finish_req(dd, 0);
-	omap_aes_handle_queue(dd, NULL);
 
 	pr_debug("exit\n");
 }
 
-static void omap_aes_queue_task(unsigned long data)
-{
-	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
-
-	omap_aes_handle_queue(dd, NULL);
-}
-
 static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
@@ -1177,9 +1160,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 	dd->dev = dev;
 	platform_set_drvdata(pdev, dd);
 
-	spin_lock_init(&dd->lock);
-	crypto_init_queue(&dd->queue, OMAP_AES_QUEUE_LENGTH);
-
 	err = (dev->of_node) ? omap_aes_get_res_of(dd, dev, &res) :
 			       omap_aes_get_res_pdev(dd, pdev, &res);
 	if (err)
@@ -1211,7 +1191,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
 	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
-	tasklet_init(&dd->queue_task, omap_aes_queue_task, (unsigned long)dd);
 
 	err = omap_aes_dma_init(dd);
 	if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
@@ -1252,7 +1231,20 @@ static int omap_aes_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Initialize crypto engine */
+	dd->engine = crypto_engine_alloc_init(dev, 1);
+	if (!dd->engine)
+		goto err_algs;
+
+	dd->engine->prepare_request = omap_aes_prepare_req;
+	dd->engine->crypt_one_request = omap_aes_crypt_req;
+	err = crypto_engine_start(dd->engine);
+	if (err)
+		goto err_engine;
+
 	return 0;
+err_engine:
+	crypto_engine_exit(dd->engine);
 err_algs:
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
@@ -1262,7 +1254,6 @@ err_algs:
 		omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
-	tasklet_kill(&dd->queue_task);
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
@@ -1288,8 +1279,8 @@ static int omap_aes_remove(struct platform_device *pdev)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
 
+	crypto_engine_exit(dd->engine);
 	tasklet_kill(&dd->done_task);
-	tasklet_kill(&dd->queue_task);
 	omap_aes_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
 	dd = NULL;
-- 
1.7.9.5
