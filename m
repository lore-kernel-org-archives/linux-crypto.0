From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/3] crypto: talitos - align locks on cache lines
Date: Fri, 7 Aug 2009 18:40:19 -0500
Message-ID: <20090807184019.c831f814.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:55410 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZHGXkm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 19:40:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

align channel access locks onto separate cache lines (for performance
reasons).  This is done by placing per-channel variables into their own
private struct, and using the cacheline_aligned attribute within that
struct.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |  141 +++++++++++++++++++---------------------------
 1 files changed, 58 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b1a651c..5013a2d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -86,6 +86,25 @@ struct talitos_request {
 	void *context;
 };
 
+/* per-channel fifo management */
+struct talitos_channel {
+	/* request fifo */
+	struct talitos_request *fifo;
+
+	/* number of requests pending in channel h/w fifo */
+	atomic_t submit_count ____cacheline_aligned;
+
+	/* request submission (head) lock */
+	spinlock_t head_lock ____cacheline_aligned;
+	/* index to next free descriptor request */
+	int head;
+
+	/* request release (tail) lock */
+	spinlock_t tail_lock ____cacheline_aligned;
+	/* index to next in-progress/done descriptor request */
+	int tail;
+};
+
 struct talitos_private {
 	struct device *dev;
 	struct of_device *ofdev;
@@ -101,15 +120,6 @@ struct talitos_private {
 	/* SEC Compatibility info */
 	unsigned long features;
 
-	/* next channel to be assigned next incoming descriptor */
-	atomic_t last_chan;
-
-	/* per-channel number of requests pending in channel h/w fifo */
-	atomic_t *submit_count;
-
-	/* per-channel request fifo */
-	struct talitos_request **fifo;
-
 	/*
 	 * length of the request fifo
 	 * fifo_len is chfifo_len rounded up to next power of 2
@@ -117,15 +127,10 @@ struct talitos_private {
 	 */
 	unsigned int fifo_len;
 
-	/* per-channel index to next free descriptor request */
-	int *head;
-
-	/* per-channel index to next in-progress/done descriptor request */
-	int *tail;
+	struct talitos_channel *chan;
 
-	/* per-channel request submission (head) and release (tail) locks */
-	spinlock_t *head_lock;
-	spinlock_t *tail_lock;
+	/* next channel to be assigned next incoming descriptor */
+	atomic_t last_chan ____cacheline_aligned;
 
 	/* request callback tasklet */
 	struct tasklet_struct done_task;
@@ -282,16 +287,16 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 	/* emulate SEC's round-robin channel fifo polling scheme */
 	ch = atomic_inc_return(&priv->last_chan) & (priv->num_channels - 1);
 
-	spin_lock_irqsave(&priv->head_lock[ch], flags);
+	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
-	if (!atomic_inc_not_zero(&priv->submit_count[ch])) {
+	if (!atomic_inc_not_zero(&priv->chan[ch].submit_count)) {
 		/* h/w fifo is full */
-		spin_unlock_irqrestore(&priv->head_lock[ch], flags);
+		spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 		return -EAGAIN;
 	}
 
-	head = priv->head[ch];
-	request = &priv->fifo[ch][head];
+	head = priv->chan[ch].head;
+	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
 	request->dma_desc = dma_map_single(dev, desc, sizeof(*desc),
@@ -300,7 +305,7 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 	request->context = context;
 
 	/* increment fifo head */
-	priv->head[ch] = (priv->head[ch] + 1) & (priv->fifo_len - 1);
+	priv->chan[ch].head = (priv->chan[ch].head + 1) & (priv->fifo_len - 1);
 
 	smp_wmb();
 	request->desc = desc;
@@ -309,7 +314,7 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 	wmb();
 	out_be32(priv->reg + TALITOS_FF_LO(ch), request->dma_desc);
 
-	spin_unlock_irqrestore(&priv->head_lock[ch], flags);
+	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
 	return -EINPROGRESS;
 }
@@ -324,11 +329,11 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	unsigned long flags;
 	int tail, status;
 
-	spin_lock_irqsave(&priv->tail_lock[ch], flags);
+	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
-	tail = priv->tail[ch];
-	while (priv->fifo[ch][tail].desc) {
-		request = &priv->fifo[ch][tail];
+	tail = priv->chan[ch].tail;
+	while (priv->chan[ch].fifo[tail].desc) {
+		request = &priv->chan[ch].fifo[tail];
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
@@ -354,22 +359,22 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 		request->desc = NULL;
 
 		/* increment fifo tail */
-		priv->tail[ch] = (tail + 1) & (priv->fifo_len - 1);
+		priv->chan[ch].tail = (tail + 1) & (priv->fifo_len - 1);
 
-		spin_unlock_irqrestore(&priv->tail_lock[ch], flags);
+		spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
 
-		atomic_dec(&priv->submit_count[ch]);
+		atomic_dec(&priv->chan[ch].submit_count);
 
 		saved_req.callback(dev, saved_req.desc, saved_req.context,
 				   status);
 		/* channel may resume processing in single desc error case */
 		if (error && !reset_ch && status == error)
 			return;
-		spin_lock_irqsave(&priv->tail_lock[ch], flags);
-		tail = priv->tail[ch];
+		spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
+		tail = priv->chan[ch].tail;
 	}
 
-	spin_unlock_irqrestore(&priv->tail_lock[ch], flags);
+	spin_unlock_irqrestore(&priv->chan[ch].tail_lock, flags);
 }
 
 /*
@@ -397,20 +402,20 @@ static void talitos_done(unsigned long data)
 static struct talitos_desc *current_desc(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	int tail = priv->tail[ch];
+	int tail = priv->chan[ch].tail;
 	dma_addr_t cur_desc;
 
 	cur_desc = in_be32(priv->reg + TALITOS_CDPR_LO(ch));
 
-	while (priv->fifo[ch][tail].dma_desc != cur_desc) {
+	while (priv->chan[ch].fifo[tail].dma_desc != cur_desc) {
 		tail = (tail + 1) & (priv->fifo_len - 1);
-		if (tail == priv->tail[ch]) {
+		if (tail == priv->chan[ch].tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
 			return NULL;
 		}
 	}
 
-	return priv->fifo[ch][tail].desc;
+	return priv->chan[ch].fifo[tail].desc;
 }
 
 /*
@@ -1740,17 +1745,11 @@ static int talitos_remove(struct of_device *ofdev)
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
-	kfree(priv->submit_count);
-	kfree(priv->tail);
-	kfree(priv->head);
-
-	if (priv->fifo)
-		for (i = 0; i < priv->num_channels; i++)
-			kfree(priv->fifo[i]);
+	for (i = 0; i < priv->num_channels; i++)
+		if (priv->chan[i].fifo)
+			kfree(priv->chan[i].fifo);
 
-	kfree(priv->fifo);
-	kfree(priv->head_lock);
-	kfree(priv->tail_lock);
+	kfree(priv->chan);
 
 	if (priv->irq != NO_IRQ) {
 		free_irq(priv->irq, dev);
@@ -1870,58 +1869,34 @@ static int talitos_probe(struct of_device *ofdev,
 	if (of_device_is_compatible(np, "fsl,sec2.1"))
 		priv->features |= TALITOS_FTR_HW_AUTH_CHECK;
 
-	priv->head_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
-				  GFP_KERNEL);
-	priv->tail_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
-				  GFP_KERNEL);
-	if (!priv->head_lock || !priv->tail_lock) {
-		dev_err(dev, "failed to allocate fifo locks\n");
+	priv->chan = kzalloc(sizeof(struct talitos_channel) *
+			     priv->num_channels, GFP_KERNEL);
+	if (!priv->chan) {
+		dev_err(dev, "failed to allocate channel management space\n");
 		err = -ENOMEM;
 		goto err_out;
 	}
 
 	for (i = 0; i < priv->num_channels; i++) {
-		spin_lock_init(&priv->head_lock[i]);
-		spin_lock_init(&priv->tail_lock[i]);
-	}
-
-	priv->fifo = kmalloc(sizeof(struct talitos_request *) *
-			     priv->num_channels, GFP_KERNEL);
-	if (!priv->fifo) {
-		dev_err(dev, "failed to allocate request fifo\n");
-		err = -ENOMEM;
-		goto err_out;
+		spin_lock_init(&priv->chan[i].head_lock);
+		spin_lock_init(&priv->chan[i].tail_lock);
 	}
 
 	priv->fifo_len = roundup_pow_of_two(priv->chfifo_len);
 
 	for (i = 0; i < priv->num_channels; i++) {
-		priv->fifo[i] = kzalloc(sizeof(struct talitos_request) *
-					priv->fifo_len, GFP_KERNEL);
-		if (!priv->fifo[i]) {
+		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request) *
+					     priv->fifo_len, GFP_KERNEL);
+		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
 			goto err_out;
 		}
 	}
 
-	priv->submit_count = kmalloc(sizeof(atomic_t) * priv->num_channels,
-				     GFP_KERNEL);
-	if (!priv->submit_count) {
-		dev_err(dev, "failed to allocate fifo submit count space\n");
-		err = -ENOMEM;
-		goto err_out;
-	}
 	for (i = 0; i < priv->num_channels; i++)
-		atomic_set(&priv->submit_count[i], -(priv->chfifo_len - 1));
