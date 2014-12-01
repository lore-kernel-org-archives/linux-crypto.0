From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH v4 3/4] crypto: sahara - replace tasklets with kthread
Date: Mon,  1 Dec 2014 13:26:33 +0100
Message-ID: <1417436794-7804-4-git-send-email-s.trumtrar@pengutronix.de>
References: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbaLAM1K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 07:27:10 -0500
In-Reply-To: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation for SHA support, replace the tasklets with a kthread that
manages one crypto_queue for the core.

As the Sahara can only process one AES or SHA request at a time, we make
sure that the queue serializes all requests from userspace. Instead of a
watchdog timer we now use a completion mechanism in the queue manager
thread.
This makes the control flow more obvious and guarantees, that only one
request is dequeued until the completion is completed.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 drivers/crypto/sahara.c | 152 +++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 55c0d2bea426..04d3b4309e4c 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -22,7 +22,9 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -38,7 +40,6 @@
 #define FLAGS_ENCRYPT		BIT(0)
 #define FLAGS_CBC		BIT(1)
 #define FLAGS_NEW_KEY		BIT(3)
-#define FLAGS_BUSY		4
 
 #define SAHARA_HDR_BASE			0x00800000
 #define SAHARA_HDR_SKHA_ALG_AES	0
@@ -119,7 +120,6 @@ struct sahara_hw_link {
 };
 
 struct sahara_ctx {
-	struct sahara_dev *dev;
 	unsigned long flags;
 	int keylen;
 	u8 key[AES_KEYSIZE_128];
@@ -136,15 +136,15 @@ struct sahara_dev {
 	void __iomem		*regs_base;
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
+	struct mutex		queue_mutex;
+	struct task_struct	*kthread;
+	struct completion	dma_completion;
 
 	struct sahara_ctx	*ctx;
 	spinlock_t		lock;
 	struct crypto_queue	queue;
 	unsigned long		flags;
 
-	struct tasklet_struct	done_task;
-	struct tasklet_struct	queue_task;
-
 	struct sahara_hw_desc	*hw_desc[SAHARA_MAX_HW_DESC];
 	dma_addr_t		hw_phys_desc[SAHARA_MAX_HW_DESC];
 
@@ -157,7 +157,6 @@ struct sahara_dev {
 	struct sahara_hw_link	*hw_link[SAHARA_MAX_HW_LINK];
 	dma_addr_t		hw_phys_link[SAHARA_MAX_HW_LINK];
 
-	struct ablkcipher_request *req;
 	size_t			total;
 	struct scatterlist	*in_sg;
 	unsigned int		nb_in_sg;
@@ -165,7 +164,6 @@ struct sahara_dev {
 	unsigned int		nb_out_sg;
 
 	u32			error;
-	struct timer_list	watchdog;
 };
 
 static struct sahara_dev *dev_ptr;
@@ -404,34 +402,6 @@ static void sahara_dump_links(struct sahara_dev *dev)
 	dev_dbg(dev->device, "\n");
 }
 
-static void sahara_aes_done_task(unsigned long data)
-{
-	struct sahara_dev *dev = (struct sahara_dev *)data;
-
-	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_TO_DEVICE);
-	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
-		DMA_FROM_DEVICE);
-
-	spin_lock(&dev->lock);
-	clear_bit(FLAGS_BUSY, &dev->flags);
-	spin_unlock(&dev->lock);
-
-	dev->req->base.complete(&dev->req->base, dev->error);
-}
-
-static void sahara_watchdog(unsigned long data)
-{
-	struct sahara_dev *dev = (struct sahara_dev *)data;
-	unsigned int err = sahara_read(dev, SAHARA_REG_ERRSTATUS);
-	unsigned int stat = sahara_read(dev, SAHARA_REG_STATUS);
-
-	sahara_decode_status(dev, stat);
-	sahara_decode_error(dev, err);
-	dev->error = -ETIMEDOUT;
-	sahara_aes_done_task(data);
-}
-
 static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 {
 	struct sahara_ctx *ctx = dev->ctx;
@@ -515,9 +485,6 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	sahara_dump_descriptors(dev);
 	sahara_dump_links(dev);
 
-	/* Start processing descriptor chain. */
-	mod_timer(&dev->watchdog,
-		  jiffies + msecs_to_jiffies(SAHARA_TIMEOUT_MS));
 	sahara_write(dev, dev->hw_phys_desc[0], SAHARA_REG_DAR);
 
 	return 0;
@@ -532,37 +499,19 @@ unmap_in:
 	return -EINVAL;
 }
 
-static void sahara_aes_queue_task(unsigned long data)
+static int sahara_aes_process(struct ablkcipher_request *req)
 {
-	struct sahara_dev *dev = (struct sahara_dev *)data;
-	struct crypto_async_request *async_req, *backlog;
+	struct sahara_dev *dev = dev_ptr;
 	struct sahara_ctx *ctx;
 	struct sahara_aes_reqctx *rctx;
-	struct ablkcipher_request *req;
 	int ret;
 
-	spin_lock(&dev->lock);
-	backlog = crypto_get_backlog(&dev->queue);
-	async_req = crypto_dequeue_request(&dev->queue);
-	if (!async_req)
-		clear_bit(FLAGS_BUSY, &dev->flags);
-	spin_unlock(&dev->lock);
-
-	if (!async_req)
-		return;
-
-	if (backlog)
-		backlog->complete(backlog, -EINPROGRESS);
-
-	req = ablkcipher_request_cast(async_req);
-
 	/* Request is ready to be dispatched by the device */
 	dev_dbg(dev->device,
 		"dispatch request (nbytes=%d, src=%p, dst=%p)\n",
 		req->nbytes, req->src, req->dst);
 
 	/* assign new request to device */
-	dev->req = req;
 	dev->total = req->nbytes;
 	dev->in_sg = req->src;
 	dev->out_sg = req->dst;
@@ -576,16 +525,25 @@ static void sahara_aes_queue_task(unsigned long data)
 		memcpy(dev->iv_base, req->info, AES_KEYSIZE_128);
 
 	/* assign new context to device */
-	ctx->dev = dev;
 	dev->ctx = ctx;
 
+	reinit_completion(&dev->dma_completion);
+
 	ret = sahara_hw_descriptor_create(dev);
-	if (ret < 0) {
-		spin_lock(&dev->lock);
-		clear_bit(FLAGS_BUSY, &dev->flags);
-		spin_unlock(&dev->lock);
-		dev->req->base.complete(&dev->req->base, ret);
+
+	ret = wait_for_completion_timeout(&dev->dma_completion,
+				msecs_to_jiffies(SAHARA_TIMEOUT_MS));
+	if (!ret) {
+		dev_err(dev->device, "AES timeout\n");
+		return -ETIMEDOUT;
 	}
+
+	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
+		DMA_TO_DEVICE);
+	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+		DMA_FROM_DEVICE);
+
+	return 0;
 }
 
 static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -627,12 +585,9 @@ static int sahara_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
-	struct sahara_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
 	struct sahara_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
-	int busy;
 
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
 		req->nbytes, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
@@ -643,16 +598,13 @@ static int sahara_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		return -EINVAL;
 	}
 
-	ctx->dev = dev;
-
 	rctx->mode = mode;
-	spin_lock_bh(&dev->lock);
+
+	mutex_lock(&dev->queue_mutex);
 	err = ablkcipher_enqueue_request(&dev->queue, req);
-	busy = test_and_set_bit(FLAGS_BUSY, &dev->flags);
-	spin_unlock_bh(&dev->lock);
+	mutex_unlock(&dev->queue_mutex);
 
-	if (!busy)
-		tasklet_schedule(&dev->queue_task);
+	wake_up_process(dev->kthread);
 
 	return err;
 }
@@ -755,6 +707,36 @@ static void sahara_aes_cra_exit(struct crypto_tfm *tfm)
 	ctx->fallback = NULL;
 }
 
+static int sahara_queue_manage(void *data)
+{
+	struct sahara_dev *dev = (struct sahara_dev *)data;
+	struct crypto_async_request *async_req;
+	int ret = 0;
+
+	do {
+		__set_current_state(TASK_INTERRUPTIBLE);
+
+		mutex_lock(&dev->queue_mutex);
+		async_req = crypto_dequeue_request(&dev->queue);
+		mutex_unlock(&dev->queue_mutex);
+
+		if (async_req) {
+			struct ablkcipher_request *req =
+				ablkcipher_request_cast(async_req);
+
+			ret = sahara_aes_process(req);
+
+			async_req->complete(async_req, ret);
+
+			continue;
+		}
+
+		schedule();
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
 static struct crypto_alg aes_algs[] = {
 {
 	.cra_name		= "ecb(aes)",
@@ -806,8 +788,6 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 	unsigned int stat = sahara_read(dev, SAHARA_REG_STATUS);
 	unsigned int err = sahara_read(dev, SAHARA_REG_ERRSTATUS);
 
-	del_timer(&dev->watchdog);
-
 	sahara_write(dev, SAHARA_CMD_CLEAR_INT | SAHARA_CMD_CLEAR_ERR,
 		     SAHARA_REG_CMD);
 
@@ -822,7 +802,7 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 		dev->error = -EINVAL;
 	}
 
-	tasklet_schedule(&dev->done_task);
+	complete(&dev->dma_completion);
 
 	return IRQ_HANDLED;
 }
@@ -961,17 +941,17 @@ static int sahara_probe(struct platform_device *pdev)
 	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
 
 	spin_lock_init(&dev->lock);
+	mutex_init(&dev->queue_mutex);
 
 	dev_ptr = dev;
 
-	tasklet_init(&dev->queue_task, sahara_aes_queue_task,
-		     (unsigned long)dev);
-	tasklet_init(&dev->done_task, sahara_aes_done_task,
-		     (unsigned long)dev);
+	dev->kthread = kthread_run(sahara_queue_manage, dev, "sahara_crypto");
+	if (IS_ERR(dev->kthread)) {
+		err = PTR_ERR(dev->kthread);
+		goto err_link;
+	}
 
-	init_timer(&dev->watchdog);
-	dev->watchdog.function = &sahara_watchdog;
-	dev->watchdog.data = (unsigned long)dev;
+	init_completion(&dev->dma_completion);
 
 	clk_prepare_enable(dev->clk_ipg);
 	clk_prepare_enable(dev->clk_ahb);
@@ -1016,6 +996,7 @@ err_algs:
 			  dev->hw_link[0], dev->hw_phys_link[0]);
 	clk_disable_unprepare(dev->clk_ipg);
 	clk_disable_unprepare(dev->clk_ahb);
+	kthread_stop(dev->kthread);
 	dev_ptr = NULL;
 err_link:
 	dma_free_coherent(&pdev->dev,
@@ -1043,8 +1024,7 @@ static int sahara_remove(struct platform_device *pdev)
 			  SAHARA_MAX_HW_DESC * sizeof(struct sahara_hw_desc),
 			  dev->hw_desc[0], dev->hw_phys_desc[0]);
 
-	tasklet_kill(&dev->done_task);
-	tasklet_kill(&dev->queue_task);
+	kthread_stop(dev->kthread);
 
 	sahara_unregister_algs(dev);
 
-- 
2.1.3
