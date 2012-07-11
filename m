From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v2 4/4] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Wed, 11 Jul 2012 17:02:06 +0800
Message-ID: <1341997326-18495-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57935
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918Ab2GKJXV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 05:23:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use spin_lock_bh to instead of spin_lock_irqsave for improving performance.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 0ba3e40..f2822a8 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -405,10 +405,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/*
 	 * assign cookies to all of the software descriptors
@@ -421,7 +420,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);

-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return cookie;
 }
@@ -530,13 +529,12 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;

 	chan_dbg(chan, "free all channel resources\n");
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

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
+		spin_lock_bh(&chan->desc_lock);

 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -775,7 +772,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;

-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_bh(&chan->desc_lock);
 		return 0;

 	case DMA_SLAVE_CONFIG:
@@ -935,11 +932,10 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);
 }

 /**
@@ -952,11 +948,10 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	enum dma_status ret;
-	unsigned long flags;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	ret = dma_cookie_status(dchan, cookie, txstate);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return ret;
 }
@@ -1037,12 +1032,11 @@ static void dma_do_tasklet(unsigned long data)
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
 	struct fsl_desc_sw *desc, *_desc, *prev = NULL;
 	LIST_HEAD(ld_cleanup);
-	unsigned long flags;
 	dma_addr_t curr_phys = get_cdar(chan);

 	chan_dbg(chan, "tasklet entry\n");

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/* find the descriptor which is already completed */
 	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
@@ -1079,7 +1073,7 @@ static void dma_do_tasklet(unsigned long data)
 	 * ahead and free the descriptors below.
 	 */
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	/* Run the callback for each descriptor, in order */
 	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
--
1.7.5.1
