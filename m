From: "Sebastian A. Siewior" <arm-kernel@ml.breakpoint.cc>
Subject: [RFC 2/2] crypto/mv-cesa: use threaded interrupts
Date: Fri, 14 Aug 2009 21:09:50 +0200
Message-ID: <1250276990-28006-3-git-send-email-arm-kernel@ml.breakpoint.cc>
References: <1250276990-28006-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57745 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915AbZHNTKM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 15:10:12 -0400
In-Reply-To: <1250276990-28006-1-git-send-email-arm-kernel@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

this patch converts the cesa-thread into a threaded-interrupt.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/mv_cesa.c |   79 ++++++++++++++++-----------------------------
 1 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index ef3404b..6943597 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -60,7 +60,6 @@ struct crypto_priv {
 	void __iomem *sram;
 	u32 sram_phys;
 	int irq;
-	struct task_struct *queue_th;
 
 	/* the lock protects queue and eng_st */
 	spinlock_t lock;
@@ -317,52 +316,41 @@ static void mv_enqueue_new_req(struct ablkcipher_request *req)
 	mv_process_current_q(1);
 }
 
-static int queue_manag(void *data)
+static irqreturn_t queue_manag(int irq, void *data)
 {
-	cpg->eng_st = ENGINE_IDLE;
-	do {
-		struct ablkcipher_request *req;
-		struct crypto_async_request *async_req = NULL;
-		struct crypto_async_request *backlog;
-
-		__set_current_state(TASK_INTERRUPTIBLE);
-
-		if (cpg->eng_st == ENGINE_W_DEQUEUE)
-			dequeue_complete_req();
-
-		spin_lock_irq(&cpg->lock);
-		if (cpg->eng_st == ENGINE_IDLE) {
-			backlog = crypto_get_backlog(&cpg->queue);
-			async_req = crypto_dequeue_request(&cpg->queue);
-			if (async_req) {
-				BUG_ON(cpg->eng_st != ENGINE_IDLE);
-				cpg->eng_st = ENGINE_BUSY;
-			}
-		}
-		spin_unlock_irq(&cpg->lock);
+	struct ablkcipher_request *req;
+	struct crypto_async_request *async_req = NULL;
+	struct crypto_async_request *backlog = NULL;
 
-		if (backlog) {
-			backlog->complete(backlog, -EINPROGRESS);
-			backlog = NULL;
-		}
+	if (cpg->eng_st == ENGINE_W_DEQUEUE)
+		dequeue_complete_req();
 
+	spin_lock_bh(&cpg->lock);
+	if (cpg->eng_st == ENGINE_IDLE) {
+		backlog = crypto_get_backlog(&cpg->queue);
+		async_req = crypto_dequeue_request(&cpg->queue);
 		if (async_req) {
-			req = container_of(async_req,
-					struct ablkcipher_request, base);
-			mv_enqueue_new_req(req);
-			async_req = NULL;
+			BUG_ON(cpg->eng_st != ENGINE_IDLE);
+			cpg->eng_st = ENGINE_BUSY;
 		}
+	}
+	spin_unlock_bh(&cpg->lock);
 
-		schedule();
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
 
-	} while (!kthread_should_stop());
-	return 0;
+	if (async_req) {
+		req = container_of(async_req,
+				struct ablkcipher_request, base);
+		mv_enqueue_new_req(req);
+	}
+
+	return IRQ_HANDLED;
 }
 
 static int mv_handle_req(struct ablkcipher_request *req)
 {
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
-	unsigned long flags;
 	unsigned int n_sgs;
 	int ret;
 	int enqueue_plz = 0;
@@ -408,7 +396,7 @@ static int mv_handle_req(struct ablkcipher_request *req)
 		req_ctx->sg_dst_left = sg_dma_len(req->dst);
 	}
 
-	spin_lock_irqsave(&cpg->lock, flags);
+	spin_lock_bh(&cpg->lock);
 	/* If the engine is idle, we enqueue it on HW start processing. In the
 	 * other case we put in in the queue and enqueue it once we dequeue the
 	 * earlier request.
@@ -420,7 +408,7 @@ static int mv_handle_req(struct ablkcipher_request *req)
 	} else {
 		ret = ablkcipher_enqueue_request(&cpg->queue, req);
 	}
-	spin_unlock_irqrestore(&cpg->lock, flags);
+	spin_unlock_bh(&cpg->lock);
 
 	if (enqueue_plz)
 		mv_enqueue_new_req(req);
@@ -491,8 +479,7 @@ irqreturn_t crypto_int(int irq, void *priv)
 	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
 	BUG_ON(cpg->eng_st != ENGINE_BUSY);
 	cpg->eng_st = ENGINE_W_DEQUEUE;
-	wake_up_process(cpg->queue_th);
-	return IRQ_HANDLED;
+	return IRQ_WAKE_THREAD;
 }
 
 struct crypto_alg mv_aes_alg_ecb = {
@@ -591,15 +578,8 @@ static int mv_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, cp);
 	cpg = cp;
-
-	cp->queue_th = kthread_run(queue_manag, cp, "mv_crypto");
-	if (IS_ERR(cp->queue_th)) {
-		ret = PTR_ERR(cp->queue_th);
-		goto err_thread;
-	}
-
-	ret = request_irq(irq, crypto_int, IRQF_DISABLED, dev_name(&pdev->dev),
-			cp);
+	ret = request_threaded_irq(irq, crypto_int, queue_manag, 0,
+			dev_name(&pdev->dev), cp);
 	if (ret)
 		goto err_unmap_sram;
 
@@ -616,10 +596,8 @@ static int mv_probe(struct platform_device *pdev)
 	return 0;
 err_unreg_ecb:
 	crypto_unregister_alg(&mv_aes_alg_ecb);
-err_thread:
 	free_irq(irq, cp);
 err_reg:
-	kthread_stop(cp->queue_th);
 err_unmap_sram:
 	iounmap(cp->sram);
 err_unmap_reg:
@@ -637,7 +615,6 @@ static int mv_remove(struct platform_device *pdev)
 
 	crypto_unregister_alg(&mv_aes_alg_ecb);
 	crypto_unregister_alg(&mv_aes_alg_cbc);
-	kthread_stop(cp->queue_th);
 	free_irq(cp->irq, cp);
 	memset(cp->sram, 0, cp->sram_size);
 	iounmap(cp->sram);
-- 
1.6.2.5

