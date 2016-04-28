From: Baolin <baolin.wang@linaro.org>
Subject: [PATCH] crypto: omap-des: Integrate with the crypto engine framework
Date: Thu, 28 Apr 2016 14:11:51 +0800
Message-ID: <a4d000f46bd5fa99b0ab832d85430e37a1c2d1bd.1461823641.git.baolin.wang@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	baolin.wang@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36490 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbcD1GMg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Apr 2016 02:12:36 -0400
Received: by mail-pf0-f178.google.com with SMTP id c189so29786086pfb.3
        for <linux-crypto@vger.kernel.org>; Wed, 27 Apr 2016 23:12:36 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the crypto engine framework had been merged, thus this patch integrates
with the newly added crypto engine framework to make the crypto hardware
engine under utilized as each block needs to be processed before the crypto
hardware can start working on the next block.

The crypto engine framework can manage and process the requests automatically,
so remove the 'queue' and 'queue_task' things in omap des driver.

Signed-off-by: Baolin <baolin.wang@linaro.org>
---
 drivers/crypto/Kconfig    |    1 +
 drivers/crypto/omap-des.c |   97 ++++++++++++++++++++-------------------------
 2 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 477fffd..f46a84d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -306,6 +306,7 @@ config CRYPTO_DEV_OMAP_DES
 	depends on ARCH_OMAP2PLUS
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_ENGINE
 	help
 	  OMAP processors have DES/3DES module accelerator. Select this if you
 	  want to use the OMAP module for DES and 3DES algorithms. Currently
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index dd7b93f..b9a465f 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -39,6 +39,7 @@
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/des.h>
+#include <crypto/algapi.h>
 
 #define DST_MAXBURST			2
 
@@ -132,14 +133,10 @@ struct omap_des_dev {
 	unsigned long		flags;
 	int			err;
 
-	/* spinlock used for queues */
-	spinlock_t		lock;
-	struct crypto_queue	queue;
-
 	struct tasklet_struct	done_task;
-	struct tasklet_struct	queue_task;
 
 	struct ablkcipher_request	*req;
+	struct crypto_engine		*engine;
 	/*
 	 * total is used by PIO mode for book keeping so introduce
 	 * variable total_save as need it to calc page_order
@@ -520,9 +517,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 	pr_debug("err: %d\n", err);
 
 	pm_runtime_put(dd->dev);
-	dd->flags &= ~FLAGS_BUSY;
-
-	req->base.complete(&req->base, err);
+	crypto_finalize_request(dd->engine, req, err);
 }
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
@@ -585,34 +580,24 @@ static int omap_des_copy_sgs(struct omap_des_dev *dd)
 }
 
 static int omap_des_handle_queue(struct omap_des_dev *dd,
-			       struct ablkcipher_request *req)
+				 struct ablkcipher_request *req)
 {
-	struct crypto_async_request *async_req, *backlog;
-	struct omap_des_ctx *ctx;
-	struct omap_des_reqctx *rctx;
-	unsigned long flags;
-	int err, ret = 0;
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
+static int omap_des_prepare_req(struct crypto_engine *engine,
+				struct ablkcipher_request *req)
+{
+	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct omap_des_dev *dd = omap_des_find_dev(ctx);
+	struct omap_des_reqctx *rctx;
 
-	req = ablkcipher_request_cast(async_req);
+	if (!dd)
+		return -ENODEV;
 
 	/* assign new request to device */
 	dd->req = req;
@@ -642,16 +627,20 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 	dd->ctx = ctx;
 	ctx->dd = dd;
 
-	err = omap_des_write_ctrl(dd);
-	if (!err)
-		err = omap_des_crypt_dma_start(dd);
-	if (err) {
-		/* des_task will not finish it, so do it here */
-		omap_des_finish_req(dd, err);
-		tasklet_schedule(&dd->queue_task);
-	}
+	return omap_des_write_ctrl(dd);
+}
 
-	return ret; /* return ret, which is enqueue return value */
+static int omap_des_crypt_req(struct crypto_engine *engine,
+			      struct ablkcipher_request *req)
+{
+	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
+			crypto_ablkcipher_reqtfm(req));
+	struct omap_des_dev *dd = omap_des_find_dev(ctx);
+
+	if (!dd)
+		return -ENODEV;
+
+	return omap_des_crypt_dma_start(dd);
 }
 
 static void omap_des_done_task(unsigned long data)
@@ -683,18 +672,10 @@ static void omap_des_done_task(unsigned long data)
 	}
 
 	omap_des_finish_req(dd, 0);
-	omap_des_handle_queue(dd, NULL);
 
 	pr_debug("exit\n");
 }
 
-static void omap_des_queue_task(unsigned long data)
-{
-	struct omap_des_dev *dd = (struct omap_des_dev *)data;
-
-	omap_des_handle_queue(dd, NULL);
-}
-
 static int omap_des_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
@@ -1062,9 +1043,6 @@ static int omap_des_probe(struct platform_device *pdev)
 	dd->dev = dev;
 	platform_set_drvdata(pdev, dd);
 
-	spin_lock_init(&dd->lock);
-	crypto_init_queue(&dd->queue, OMAP_DES_QUEUE_LENGTH);
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "no MEM resource info\n");
@@ -1103,7 +1081,6 @@ static int omap_des_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
 	tasklet_init(&dd->done_task, omap_des_done_task, (unsigned long)dd);
-	tasklet_init(&dd->queue_task, omap_des_queue_task, (unsigned long)dd);
 
 	err = omap_des_dma_init(dd);
 	if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
@@ -1144,7 +1121,21 @@ static int omap_des_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Initialize des crypto engine */
+	dd->engine = crypto_engine_alloc_init(dev, 1);
+	if (!dd->engine)
+		goto err_algs;
+
+	dd->engine->prepare_request = omap_des_prepare_req;
+	dd->engine->crypt_one_request = omap_des_crypt_req;
+	err = crypto_engine_start(dd->engine);
+	if (err)
+		goto err_engine;
+
 	return 0;
+
+err_engine:
+	crypto_engine_exit(dd->engine);
 err_algs:
 	for (i = dd->pdata->algs_info_size - 1; i >= 0; i--)
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
@@ -1154,7 +1145,6 @@ err_algs:
 		omap_des_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
-	tasklet_kill(&dd->queue_task);
 err_get:
 	pm_runtime_disable(dev);
 err_res:
@@ -1182,7 +1172,6 @@ static int omap_des_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 
 	tasklet_kill(&dd->done_task);
-	tasklet_kill(&dd->queue_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
 	dd = NULL;
-- 
1.7.9.5
