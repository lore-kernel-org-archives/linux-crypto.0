From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v3 4/4] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
Date: Mon, 16 Jul 2012 12:09:40 +0800
Message-ID: <1342411780-29930-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:54484
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab2GPEbP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 00:31:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use spin_lock_bh to instead of spin_lock_irqsave for improving performance.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4ee1b8f..e975719 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -616,10 +616,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie;

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/*
 	 * assign cookies to all of the software descriptors
@@ -632,7 +631,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);

-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return cookie;
 }
@@ -741,15 +740,14 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	unsigned long flags;

 	chan_dbg(chan, "free all channel resources\n");
-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_cleanup_descriptor(chan);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
 	fsldma_free_desc_list(chan, &chan->ld_completed);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	dma_pool_destroy(chan->desc_pool);
 	chan->desc_pool = NULL;
@@ -968,7 +966,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 {
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
-	unsigned long flags;
 	int size;

 	if (!dchan)
@@ -978,7 +975,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,

 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_bh(&chan->desc_lock);

 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -988,7 +985,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;

-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_bh(&chan->desc_lock);
 		return 0;

 	case DMA_SLAVE_CONFIG:
@@ -1030,11 +1027,10 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
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
@@ -1047,7 +1043,6 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	enum dma_status ret;
-	unsigned long flags;

 	ret = dma_cookie_status(dchan, cookie, txstate);
 	if (ret == DMA_SUCCESS) {
@@ -1055,9 +1050,9 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 		return ret;
 	}

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
 	fsldma_cleanup_descriptor(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return dma_cookie_status(dchan, cookie, txstate);
 }
@@ -1140,7 +1135,7 @@ static void dma_do_tasklet(unsigned long data)

 	chan_dbg(chan, "tasklet entry\n");

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);

 	/* Run all cleanup for this descriptor */
 	fsldma_cleanup_descriptor(chan);
@@ -1149,7 +1144,7 @@ static void dma_do_tasklet(unsigned long data)
 	chan->idle = true;

 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	chan_dbg(chan, "tasklet exit\n");
 }
--
1.7.5.1
