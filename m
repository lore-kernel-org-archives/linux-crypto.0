From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 2/7] fsl-dma: minimize locking overhead
Date: Tue, 31 Jul 2012 16:45:47 -0700
Message-ID: <1343778352-5549-3-git-send-email-iws@ovro.caltech.edu>
References: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, B32616@freescale.com,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:59616 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab2GaXp5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 19:45:57 -0400
In-Reply-To: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The use of spin_lock_irqsave() was a stronger locking mechanism than was
actually needed in many cases.

As the current code is written, spin_lock_bh() everywhere is sufficient.

The next patch in this series will add some code to hardware interrupt
context. This patch is intended to minimize the differences in the next
patch and make review easier.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4f2f212..8f0505d 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -405,10 +405,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie;
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_irq(&chan->desc_lock);
 
 	/*
 	 * assign cookies to all of the software descriptors
@@ -421,7 +420,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);
 
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_irq(&chan->desc_lock);
 
 	return cookie;
 }
@@ -530,13 +529,12 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;
 
 	chan_dbg(chan, "free all channel resources\n");
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_irq(&chan->desc_lock);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_irq(&chan->desc_lock);
 
 	dma_pool_destroy(chan->desc_pool);
 	chan->desc_pool = NULL;
@@ -755,7 +753,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 {
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
-	unsigned long flags;
 	int size;
 
 	if (!dchan)
@@ -765,7 +762,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_irq(&chan->desc_lock);
 
 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -775,7 +772,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;
 
-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_irq(&chan->desc_lock);
 		return 0;
 
 	case DMA_SLAVE_CONFIG:
@@ -935,11 +932,10 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_irq(&chan->desc_lock);
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_irq(&chan->desc_lock);
 }
 
 /**
@@ -952,11 +948,10 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	enum dma_status ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_irq(&chan->desc_lock);
 	ret = dma_cookie_status(dchan, cookie, txstate);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_irq(&chan->desc_lock);
 
 	return ret;
 }
-- 
1.7.8.6
