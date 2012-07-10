From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH 3/4] fsl-dma: support attribute of DMA_MEMORY when async_tx enabled
Date: Tue, 10 Jul 2012 13:59:57 +0800
Message-ID: <1341899997-20879-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <leoli@freescale.com>, <kim.phillips@freescale.com>,
	Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:30177
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2GJGVA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 02:21:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- delete attribute of DMA_INTERRUPT because fsl-dma doesn't support
this function, exception will be thrown if talitos is used to compute xor
at the same time;
- change the release process of dma descriptor for avoiding exception when
enable config NET_DMA, release dma descriptor from 1st to last second, the
last descriptor which is reserved in current descriptor register may not be
completed, race condition will be raised if free current descriptor;
- use spin_lock_bh to instead of spin_lock_irqsave for improving performance;

A race condition which is raised when use both of talitos and dmaengine to
offload xor is because napi scheduler will sync all pending requests in dma
channels, it will affect the process of raid operations. The descriptor is
freed which is submitted just now, but async_tx must check whether this depend
tx descriptor is acked, there are poison contents in the invalid address,
then BUG_ON() is thrown, so this descriptor will be freed in the next time.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   78 ++++++++++++++++----------------------------------
 1 files changed, 25 insertions(+), 53 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index b98070c..44698c9 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -404,11 +404,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
 	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
 	struct fsl_desc_sw *child;
-	unsigned long flags;
 	dma_cookie_t cookie;

-	spin_lock_irqsave(&chan->desc_lock, flags);
-
+	spin_lock_bh(&chan->desc_lock);
 	/*
 	 * assign cookies to all of the software descriptors
 	 * that make up this transaction
@@ -427,7 +425,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	/* put this transaction onto the tail of the pending queue */
 	append_ld_queue(chan, desc);

-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	return cookie;
 }
@@ -536,48 +534,18 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
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
 }

 static struct dma_async_tx_descriptor *
-fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
-{
-	struct fsldma_chan *chan;
-	struct fsl_desc_sw *new;
-
-	if (!dchan)
-		return NULL;
-
-	chan = to_fsl_chan(dchan);
-
-	new = fsl_dma_alloc_descriptor(chan);
-	if (!new) {
-		chan_err(chan, "%s\n", msg_ld_oom);
-		return NULL;
-	}
-
-	new->async_tx.cookie = -EBUSY;
-	new->async_tx.flags = flags;
-
-	/* Insert the link descriptor to the LD ring */
-	list_add_tail(&new->node, &new->tx_list);
-
-	/* Set End-of-link to the last link descriptor of new list */
-	set_ld_eol(chan, new);
-
-	return &new->async_tx;
-}
-
-static struct dma_async_tx_descriptor *
 fsl_dma_prep_memcpy(struct dma_chan *dchan,
 	dma_addr_t dma_dst, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
@@ -788,7 +756,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 {
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
-	unsigned long flags;
 	int size;

 	if (!dchan)
@@ -798,7 +765,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,

 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&chan->desc_lock, flags);
+		spin_lock_bh(&chan->desc_lock);

 		/* Halt the DMA engine */
 		dma_halt(chan);
@@ -808,7 +775,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 		fsldma_free_desc_list(chan, &chan->ld_running);
 		chan->idle = true;

-		spin_unlock_irqrestore(&chan->desc_lock, flags);
+		spin_unlock_bh(&chan->desc_lock);
 		return 0;

 	case DMA_SLAVE_CONFIG:
@@ -968,11 +935,10 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
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
@@ -1073,13 +1039,20 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
-	struct fsl_desc_sw *desc, *_desc;
+	struct fsl_desc_sw *desc, *_desc, *prev = NULL;
 	LIST_HEAD(ld_cleanup);
-	unsigned long flags;
+	dma_addr_t curr_phys = get_cdar(chan);

 	chan_dbg(chan, "tasklet entry\n");

-	spin_lock_irqsave(&chan->desc_lock, flags);
+	spin_lock_bh(&chan->desc_lock);
+
+	/* find the descriptor which is already completed */
+	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
+		if (prev && desc->async_tx.phys == curr_phys)
+			break;
+		prev = desc;
+	}

 	/* update the cookie if we have some descriptors to cleanup */
 	if (!list_empty(&chan->ld_running)) {
@@ -1092,23 +1065,24 @@ static void dma_do_tasklet(unsigned long data)
 		chan_dbg(chan, "completed_cookie=%d\n", cookie);
 	}

+	/* the hardware is now idle and ready for more */
+	chan->idle = true;
+
 	/*
 	 * move the descriptors to a temporary list so we can drop the lock
 	 * during the entire cleanup operation
 	 */
-	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
-
-	/* the hardware is now idle and ready for more */
-	chan->idle = true;
+	list_cut_position(&ld_cleanup, &chan->ld_running, &prev->node);

 	/*
-	 * Start any pending transactions automatically
+	 * Start any pending transactions automatically if current descriptor
+	 * list is completed
 	 *
 	 * In the ideal case, we keep the DMA controller busy while we go
 	 * ahead and free the descriptors below.
 	 */
 	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	spin_unlock_bh(&chan->desc_lock);

 	/* Run the callback for each descriptor, in order */
 	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
@@ -1360,12 +1334,10 @@ static int __devinit fsldma_of_probe(struct platform_device *op)
 	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);

 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
-	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
 	dma_cap_set(DMA_SG, fdev->common.cap_mask);
 	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources = fsl_dma_alloc_chan_resources;
 	fdev->common.device_free_chan_resources = fsl_dma_free_chan_resources;
-	fdev->common.device_prep_dma_interrupt = fsl_dma_prep_interrupt;
 	fdev->common.device_prep_dma_memcpy = fsl_dma_prep_memcpy;
 	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
--
1.7.5.1
