From: Martin Hicks <mort@bork.org>
Subject: [PATCH v2 5/5] crypto: talitos: Add software backlog queue handling
Date: Tue,  3 Mar 2015 08:21:37 -0500
Message-ID: <1425388897-5434-6-git-send-email-mort@bork.org>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>
To: Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:45710 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbbCCNVz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 08:21:55 -0500
Received: by igjz20 with SMTP id z20so27214778igj.4
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 05:21:54 -0800 (PST)
In-Reply-To: <1425388897-5434-1-git-send-email-mort@bork.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I was running into situations where the hardware FIFO was filling up, and
the code was returning EAGAIN to dm-crypt and just dropping the submitted
crypto request.

This adds support in talitos for a software backlog queue.  When requests
can't be queued to the hardware immediately EBUSY is returned.  The queued
requests are dispatched to the hardware in received order as hardware FIFO
slots become available.

Signed-off-by: Martin Hicks <mort@bork.org>
---
 drivers/crypto/talitos.c |  135 ++++++++++++++++++++++++++++++++++++----------
 drivers/crypto/talitos.h |    3 ++
 2 files changed, 110 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b0c85ce..bb7fba0 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -182,55 +182,118 @@ static int init_device(struct device *dev)
 	return 0;
 }
 
-/**
- * talitos_submit - submits a descriptor to the device for processing
- * @dev:	the SEC device to be used
- * @ch:		the SEC device channel to be used
- * @edesc:	the descriptor to be processed by the device
- *
- * desc must contain valid dma-mapped (bus physical) address pointers.
- * callback must check err and feedback in descriptor header
- * for device processing status.
- */
-int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc)
+/* Dispatch 'request' if provided, otherwise a backlogged request */
+static int __talitos_handle_queue(struct device *dev, int ch,
+				  struct talitos_edesc *edesc,
+				  unsigned long *irq_flags)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	struct talitos_request *request = &edesc->req;
-	unsigned long flags;
+	struct talitos_request *request;
+	struct crypto_async_request *areq;
 	int head;
+	int ret = -EINPROGRESS;
 
-	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
-
-	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
+	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count))
 		/* h/w fifo is full */
-		spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
-		return -EAGAIN;
+		return -EBUSY;
+
+	if (!edesc) {
+		/* Dequeue the oldest request */
+		areq = crypto_dequeue_request(&priv->chan[ch].queue);
+		request = container_of(areq, struct talitos_request, base);
+	} else {
+		request = &edesc->req;
 	}
 
-	head = priv->chan[ch].head;
 	request->dma_desc = dma_map_single(dev, request->desc,
 					   sizeof(*request->desc),
 					   DMA_BIDIRECTIONAL);
 
 	/* increment fifo head */
+	head = priv->chan[ch].head;
 	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
 
-	smp_wmb();
-	priv->chan[ch].fifo[head] = request;
+	spin_unlock_irqrestore(&priv->chan[ch].head_lock, *irq_flags);
+
+	/*
+	 * Mark a backlogged request as in-progress.
+	 */
+	if (!edesc) {
+		areq = request->context;
+		areq->complete(areq, -EINPROGRESS);
+	}
+
+	spin_lock_irqsave(&priv->chan[ch].head_lock, *irq_flags);
 
 	/* GO! */
+	priv->chan[ch].fifo[head] = request;
 	wmb();
 	out_be32(priv->chan[ch].reg + TALITOS_FF,
 		 upper_32_bits(request->dma_desc));
 	out_be32(priv->chan[ch].reg + TALITOS_FF_LO,
 		 lower_32_bits(request->dma_desc));
 
+	return ret;
+}
+
+/**
+ * talitos_submit - performs submissions of a new descriptors
+ *
+ * @dev:	the SEC device to be used
+ * @ch:		the SEC device channel to be used
+ * @edesc:	the request to be processed by the device
+ *
+ * edesc->req must contain valid dma-mapped (bus physical) address pointers.
+ * callback must check err and feedback in descriptor header
+ * for device processing status upon completion.
+ */
+int talitos_submit(struct device *dev, int ch, struct talitos_edesc *edesc)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct talitos_request *request = &edesc->req;
+	unsigned long flags;
+	int ret = -EINPROGRESS;
+
+	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
+
+	if (priv->chan[ch].queue.qlen) {
+		/*
+		 * There are backlogged requests.  Just queue this new request
+		 * and dispatch the oldest backlogged request to the hardware.
+		 */
+		crypto_enqueue_request(&priv->chan[ch].queue,
+				       &request->base);
+		__talitos_handle_queue(dev, ch, NULL, &flags);
+		ret = -EBUSY;
+	} else {
+		ret = __talitos_handle_queue(dev, ch, edesc, &flags);
+		if (ret == -EBUSY)
+			/* Hardware FIFO is full */
+			crypto_enqueue_request(&priv->chan[ch].queue,
+					       &request->base);
+	}
+
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
-	return -EINPROGRESS;
+	return ret;
 }
 EXPORT_SYMBOL(talitos_submit);
 
+static int talitos_handle_queue(struct device *dev, int ch)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned long flags;
+	int ret = -EINPROGRESS;
+
+	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
+	/* Queue backlogged requests as long as the hardware has room */
+	while (priv->chan[ch].queue.qlen && ret == -EINPROGRESS)
+		ret = __talitos_handle_queue(dev, ch, NULL, &flags);
+	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
+
+	return 0;
+}
+
 /*
  * process what was done, notify callback of error if not
  */
@@ -283,6 +346,8 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	}
 
 	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
+
+	talitos_handle_queue(dev, ch);
 }
 
 /*
@@ -1039,7 +1104,8 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	edesc->req.context = areq;
 
 	ret = talitos_submit(dev, ctx->ch, edesc);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		ipsec_esp_unmap(dev, edesc, areq);
 		kfree(edesc);
 	}
@@ -1080,6 +1146,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 unsigned int ivsize,
 						 int icv_stashing,
 						 u32 cryptoflags,
+						 struct crypto_async_request *areq,
 						 bool encrypt)
 {
 	struct talitos_edesc *edesc;
@@ -1170,6 +1237,8 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						     edesc->dma_len,
 						     DMA_BIDIRECTIONAL);
 	edesc->req.desc = &edesc->desc;
+	/* A copy of the crypto_async_request to use the crypto_queue backlog */
+	memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_request));
 
 	return edesc;
 }
@@ -1184,7 +1253,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
 	return talitos_edesc_alloc(ctx->dev, areq->assoc, areq->src, areq->dst,
 				   iv, areq->assoclen, areq->cryptlen,
 				   ctx->authsize, ivsize, icv_stashing,
-				   areq->base.flags, encrypt);
+				   areq->base.flags, &areq->base, encrypt);
 }
 
 static int aead_encrypt(struct aead_request *req)
@@ -1414,7 +1483,8 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	edesc->req.context = areq;
 
 	ret = talitos_submit(dev, ctx->ch, edesc);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		common_nonsnoop_unmap(dev, edesc, areq);
 		kfree(edesc);
 	}
@@ -1430,7 +1500,7 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 
 	return talitos_edesc_alloc(ctx->dev, NULL, areq->src, areq->dst,
 				   areq->info, 0, areq->nbytes, 0, ivsize, 0,
-				   areq->base.flags, encrypt);
+				   areq->base.flags, &areq->base, encrypt);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1597,7 +1667,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	edesc->req.context = areq;
 
 	ret = talitos_submit(dev, ctx->ch, edesc);
-	if (ret != -EINPROGRESS) {
+	if (ret != -EINPROGRESS &&
+	    !(ret == -EBUSY && areq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
 		common_nonsnoop_hash_unmap(dev, edesc, areq);
 		kfree(edesc);
 	}
@@ -1612,7 +1683,8 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
 	return talitos_edesc_alloc(ctx->dev, NULL, req_ctx->psrc, NULL, NULL, 0,
-				   nbytes, 0, 0, 0, areq->base.flags, false);
+				   nbytes, 0, 0, 0, areq->base.flags,
+				   &areq->base, false);
 }
 
 static int ahash_init(struct ahash_request *areq)
@@ -2690,6 +2762,13 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 
 		atomic_set(&priv->chan[i].submit_count, -priv->chfifo_len);
+
+		/*
+		 * The crypto_queue is used to manage the backlog only.  While
+		 * the hardware FIFO has space requests are dispatched
+		 * immediately.
+		 */
+		crypto_init_queue(&priv->chan[i].queue, 0);
 	}
 
 	dma_set_mask(dev, DMA_BIT_MASK(36));
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 914eb15..2762e47 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -65,6 +65,7 @@ struct talitos_desc {
  * @context: caller context (optional)
  */
 struct talitos_request {
+	struct crypto_async_request base;
 	struct talitos_desc *desc;
 	dma_addr_t dma_desc;
 	void (*callback) (struct device *dev, struct talitos_desc *desc,
@@ -91,6 +92,8 @@ struct talitos_channel {
 	spinlock_t tail_lock ____cacheline_aligned;
 	/* index to next in-progress/done descriptor request */
 	int tail;
+
+	struct crypto_queue queue;
 };
 
 struct talitos_private {
-- 
1.7.10.4
