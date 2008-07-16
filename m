From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/6] crypto: talitos - preempt overflow interrupts
Date: Wed, 16 Jul 2008 18:21:58 -0500
Message-ID: <20080716182158.cc9ee10b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:64463 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944AbYGPXWl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:22:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

add requests pending/submit count to prevent request queue full
condition by preempting h/w overflow interrupts in software.
We do this due to the delay in the delivery and handling of the
channel overflow error interrupt.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Lee Nipper <lee.nipper@freescale.com>
---
 drivers/crypto/talitos.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f644fba..fdb0680 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -99,6 +99,9 @@ struct talitos_private {
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan;
 
+	/* per-channel number of requests pending in channel h/w fifo */
+	atomic_t *submit_count;
+
 	/* per-channel request fifo */
 	struct talitos_request **fifo;
 
@@ -263,15 +266,15 @@ static int talitos_submit(struct device *dev, struct talitos_desc *desc,
 
 	spin_lock_irqsave(&priv->head_lock[ch], flags);
 
-	head = priv->head[ch];
-	request = &priv->fifo[ch][head];
-
-	if (request->desc) {
-		/* request queue is full */
+	if (!atomic_inc_not_zero(&priv->submit_count[ch])) {
+		/* h/w fifo is full */
 		spin_unlock_irqrestore(&priv->head_lock[ch], flags);
 		return -EAGAIN;
 	}
 
+	head = priv->head[ch];
+	request = &priv->fifo[ch][head];
+
 	/* map descriptor and save caller data */
 	request->dma_desc = dma_map_single(dev, desc, sizeof(*desc),
 					   DMA_BIDIRECTIONAL);
@@ -335,6 +338,9 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 		priv->tail[ch] = (tail + 1) & (priv->fifo_len - 1);
 
 		spin_unlock_irqrestore(&priv->tail_lock[ch], flags);
+
+		atomic_dec(&priv->submit_count[ch]);
+
 		saved_req.callback(dev, saved_req.desc, saved_req.context,
 				   status);
 		/* channel may resume processing in single desc error case */
@@ -1337,6 +1343,7 @@ static int __devexit talitos_remove(struct of_device *ofdev)
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
+	kfree(priv->submit_count);
 	kfree(priv->tail);
 	kfree(priv->head);
 
@@ -1501,6 +1508,16 @@ static int talitos_probe(struct of_device *ofdev,
 		}
 	}
 
+	priv->submit_count = kmalloc(sizeof(int) * priv->num_channels,
+				     GFP_KERNEL);
+	if (!priv->submit_count) {
+		dev_err(dev, "failed to allocate fifo submit count space\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+	for (i = 0; i < priv->num_channels; i++)
+		atomic_set(&priv->submit_count[i], -priv->chfifo_len);
+
 	priv->head = kzalloc(sizeof(int) * priv->num_channels, GFP_KERNEL);
 	priv->tail = kzalloc(sizeof(int) * priv->num_channels, GFP_KERNEL);
 	if (!priv->head || !priv->tail) {
-- 
1.5.6

