From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 4/4] crypto: talitos - add software backlog queue handling
Date: Fri, 13 Mar 2015 19:38:40 +0200
Message-ID: <1426268320-23406-1-git-send-email-horia.geanta@freescale.com>
References: <1426268260-20824-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>,
	Horia Geanta <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:11540
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752842AbbCMRiv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2015 13:38:51 -0400
In-Reply-To: <1426268260-20824-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was running into situations where the hardware FIFO was filling up, and
the code was returning EAGAIN to dm-crypt and just dropping the submitted
crypto request.

This adds support in talitos for a software backlog queue. When requests
can't be queued to the hardware immediately EBUSY is returned. The queued
requests are dispatched to the hardware in received order as hardware FIFO
slots become available.

Signed-off-by: Martin Hicks <mort@bork.org>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c | 107 +++++++++++++++++++++++++++++++++++++++++------
 drivers/crypto/talitos.h |   2 +
 2 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c184987dfcc7..d4679030d23c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -197,23 +197,41 @@ static struct talitos_request *to_talitos_req(struct crypto_async_request *areq)
 	}
 }
 
-int talitos_submit(struct device *dev, int ch,
-		   struct crypto_async_request *areq)
+/*
+ * Enqueue to HW queue a request, coming either from upper layer or taken from
+ * SW queue. When drawing from SW queue, check if there are backlogged requests
+ * and notify their producers.
+ */
+int __talitos_handle_queue(struct device *dev, int ch,
+			   struct crypto_async_request *areq,
+			   unsigned long *irq_flags)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
-	unsigned long flags;
 	int head;
 
-	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
-
 	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
 		/* h/w fifo is full */
-		spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
-		return -EAGAIN;
+		if (!areq)
+			return -EBUSY;
+
+		/* Try to backlog request (if allowed) */
+		return crypto_enqueue_request(&priv->chan[ch].queue, areq);
 	}
 
-	head = priv->chan[ch].head;
+	if (!areq) {
+		struct crypto_async_request *backlog =
+			crypto_get_backlog(&priv->chan[ch].queue);
+
+		/* Dequeue the oldest request */
+		areq = crypto_dequeue_request(&priv->chan[ch].queue);
+		if (!areq)
+			return 0;
+
+		/* Mark a backlogged request as in-progress */
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+	}
 
 	request = to_talitos_req(areq);
 	if (IS_ERR(request))
@@ -224,6 +242,7 @@ int talitos_submit(struct device *dev, int ch,
 					   DMA_BIDIRECTIONAL);
 
 	/* increment fifo head */
+	head = priv->chan[ch].head;
 	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
 
 	smp_wmb();
@@ -236,14 +255,66 @@ int talitos_submit(struct device *dev, int ch,
 	out_be32(priv->chan[ch].reg + TALITOS_FF_LO,
 		 lower_32_bits(request->dma_desc));
 
+	return -EINPROGRESS;
+}
+
+int talitos_submit(struct device *dev, int ch,
+		   struct crypto_async_request *areq)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
+
+	/*
+	 * Hidden assumption: we maintain submission order separately for
+	 * requests that may be backlogged and those that may not. For e.g. even
+	 * if SW queue has some requests, we won't drop an incoming request that
+	 * may not be backlogged, but enqueue it in the HW queue (in front of
+	 * pending ones).
+	 */
+	if (areq->flags & CRYPTO_TFM_REQ_MAY_BACKLOG &&
+	    priv->chan[ch].queue.qlen) {
+		/*
+		 * There are pending requests in the SW queue. Since we want to
+		 * maintain the order of requests, we cannot enqueue in the HW
+		 * queue. Thus put this new request in SW queue and dispatch
+		 * the oldest backlogged request to the hardware.
+		 */
+		ret = crypto_enqueue_request(&priv->chan[ch].queue, areq);
+		__talitos_handle_queue(dev, ch, NULL, &flags);
+	} else {
+		ret = __talitos_handle_queue(dev, ch, areq, &flags);
+	}
+
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
-	return -EINPROGRESS;
+	return ret;
 }
 EXPORT_SYMBOL(talitos_submit);
 
+static void talitos_handle_queue(struct device *dev, int ch)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned long flags;
+	int ret = -EINPROGRESS;
+
+	if (!priv->chan[ch].queue.qlen)
+		return;
+
+	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
+
+	/* Queue backlogged requests as long as the hardware has room */
+	while (priv->chan[ch].queue.qlen && ret == -EINPROGRESS)
+		ret = __talitos_handle_queue(dev, ch, NULL, &flags);
+
+	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
+}
+
 /*
  * process what was done, notify callback of error if not
+ * when done with HW queue, check SW queue (backlogged requests)
  */
 static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
@@ -293,6 +364,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	}
 
 	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
+
+	talitos_handle_queue(dev, ch);
 }
 
 /*
@@ -1069,7 +1142,8 @@ static int ipsec_esp(struct aead_request *areq, u64 seq,
 	req_ctx->req.callback = callback;
 	req_ctx->req.context = areq;
 	ret = talitos_submit(dev, ctx->ch, &areq->base);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		ipsec_esp_unmap(dev, edesc, areq);
 		kfree(edesc->link_tbl);
 	}
@@ -1451,7 +1525,8 @@ static int common_nonsnoop(struct ablkcipher_request *areq,
 	req_ctx->req.callback = callback;
 	req_ctx->req.context = areq;
 	ret = talitos_submit(dev, ctx->ch, &areq->base);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		common_nonsnoop_unmap(dev, edesc, areq);
 		kfree(edesc->link_tbl);
 	}
@@ -1634,7 +1709,8 @@ static int common_nonsnoop_hash(struct ahash_request *areq, unsigned int length,
 	req_ctx->req.callback = callback;
 	req_ctx->req.context = areq;
 	ret = talitos_submit(dev, ctx->ch, &areq->base);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
 		kfree(edesc->link_tbl);
 	}
@@ -2753,6 +2829,13 @@ static int talitos_probe(struct platform_device *ofdev)
 
 		atomic_set(&priv->chan[i].submit_count,
 			   -(priv->chfifo_len - 1));
+
+		/*
+		 * The crypto_queue is used to manage the backlog only. While
+		 * the hardware FIFO has space requests are dispatched
+		 * immediately.
+		 */
+		crypto_init_queue(&priv->chan[i].queue, 0);
 	}
 
 	dma_set_mask(dev, DMA_BIT_MASK(36));
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index ebae5c3ef0fb..68ea26a4309d 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -118,6 +118,8 @@ struct talitos_channel {
 	/* index to next free descriptor request */
 	int head;
 
+	struct crypto_queue queue;
+
 	/* request release (tail) lock */
 	spinlock_t tail_lock ____cacheline_aligned;
 	/* index to next in-progress/done descriptor request */
-- 
1.8.3.1
