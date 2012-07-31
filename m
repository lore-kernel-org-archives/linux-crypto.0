From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 5/7] fsl-dma: fix support for async_tx API
Date: Tue, 31 Jul 2012 16:45:50 -0700
Message-ID: <1343778352-5549-6-git-send-email-iws@ovro.caltech.edu>
References: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, B32616@freescale.com,
	"Ira W. Snyder" <iws@ovro.caltech.edu>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>,
	Qiang Liu <qiang.liu@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:59629 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2GaXqA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 19:46:00 -0400
In-Reply-To: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The current fsldma driver does not support the async_tx API. This is due
to a bug: all descriptors are released when the hardware is finished
with them. The async_tx API requires that the ACK bit is set by software
before descriptors are freed.

This bug is easiest to reproduce by enabling both CONFIG_NET_DMA and
CONFIG_ASYNC_TX, and using the hardware offload support in MD RAID. The
network stack will force operations on shared DMA channels, and will
free descriptors which are being used by the MD RAID code.

The BUG_ON(async_tx_test_ack(depend_tx)) test in async_tx_submit() will
be hit, and panic the machine.

TASK = ee1a94a0[1390] 'md0_raid5' THREAD: ecf40000 CPU: 0
GPR00: 00000001 ecf41ca0 ee44/921a94a0 0000003f 00000001 c00593e4 00000000 00000001
GPR08: 00000000 a7a7a7a7 00000001 045/920000002 42028042 100a38d4 ed576d98 00000000
GPR16: ed5a11b0 00000000 2b162000 00000200 046/920000000 2d555000 ed3015e8 c15a7aa0
GPR24: 00000000 c155fc40 00000000 ecb63220 ecf41d28 e47/92f640bb0 ef640c30 ecf41ca0
NIP [c02b048c] async_tx_submit+0x6c/0x2b4
LR [c02b068c] async_tx_submit+0x26c/0x2b4
Call Trace:
[ecf41ca0] [c02b068c] async_tx_submit+0x26c/0x2b448/92 (unreliable)
[ecf41cd0] [c02b0a4c] async_memcpy+0x240/0x25c
[ecf41d20] [c0421064] async_copy_data+0xa0/0x17c
[ecf41d70] [c0421cf4] __raid_run_ops+0x874/0xe10
[ecf41df0] [c0426ee4] handle_stripe+0x820/0x25e8
[ecf41e90] [c0429080] raid5d+0x3d4/0x5b4
[ecf41f40] [c04329b8] md_thread+0x138/0x16c
[ecf41f90] [c008277c] kthread+0x8c/0x90
[ecf41ff0] [c0011630] kernel_thread+0x4c/0x68

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Qiang Liu <qiang.liu@freescale.com>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  156 +++++++++++++++++++++++++++++++-------------------
 drivers/dma/fsldma.h |    1 +
 2 files changed, 97 insertions(+), 60 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 80edc63..380c1b7 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -410,16 +410,15 @@ static void fsl_dma_free_descriptor(struct fsldma_chan *chan, struct fsl_desc_sw
 }
 
 /**
- * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
+ * fsldma_run_tx_complete_actions - run callback and unmap descriptor
  * @chan: Freescale DMA channel
  * @desc: descriptor to cleanup and free
  *
  * This function is used on a descriptor which has been executed by the DMA
- * controller. It will run any callbacks, submit any dependencies, and then
- * free the descriptor.
+ * controller. It will run the callback and unmap the descriptor, if requested.
  */
-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
-				      struct fsl_desc_sw *desc)
+static void fsldma_run_tx_complete_actions(struct fsldma_chan *chan,
+					   struct fsl_desc_sw *desc)
 {
 	struct dma_async_tx_descriptor *txd = &desc->async_tx;
 	struct device *dev = chan->common.device->dev;
@@ -427,6 +426,10 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	dma_addr_t dst = get_desc_dst(chan, desc);
 	u32 len = get_desc_cnt(chan, desc);
 
+	/* Cookies with value zero are already cleaned up */
+	if (txd->cookie == 0)
+		return;
+
 	/* Run the link descriptor callback function */
 	if (txd->callback) {
 #ifdef FSL_DMA_LD_DEBUG
@@ -435,9 +438,6 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 		txd->callback(txd->callback_param);
 	}
 
-	/* Run any dependencies */
-	dma_run_dependencies(txd);
-
 	/* Unmap the dst buffer, if requested */
 	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
@@ -454,7 +454,68 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
 	}
 
-	fsl_dma_free_descriptor(chan, desc);
+	/*
+	 * A zeroed cookie indicates that cleanup actions have been
+	 * run, but the descriptor has not yet been ACKed.
+	 */
+	txd->cookie = 0;
+}
+
+/**
+ * fsldma_cleanup_descriptors - cleanup and free link descriptors
+ * @chan: Freescale DMA channel
+ *
+ * This function is used to clean up all descriptors which have been executed
+ * by the DMA controller. It will run any callbacks, submit any dependencies,
+ * and free any descriptors which have been ACKed.
+ *
+ * LOCKING: must NOT hold chan->desc_lock
+ * CONTEXT: any
+ */
+static void fsldma_cleanup_descriptors(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc, *_desc;
+	dma_cookie_t cookie = 0;
+	LIST_HEAD(ld_cleanup);
+	unsigned long flags;
+
+	/*
+	 * Move all descriptors onto a temporary list so that hardware
+	 * interrupts can be enabled during cleanup
+	 */
+	spin_lock_irqsave(&chan->desc_lock, flags);
+	list_splice_tail_init(&chan->ld_completed, &ld_cleanup);
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
+	/* Run TX completion actions on completed descriptors */
+	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
+		struct dma_async_tx_descriptor *txd = &desc->async_tx;
+		cookie = txd->cookie;
+
+		/* Clean up this descriptor */
+		fsldma_run_tx_complete_actions(chan, desc);
+
+		/* Run any dependencies */
+		dma_run_dependencies(txd);
+
+		/* Test for ACK and free */
+		if (async_tx_test_ack(txd))
+			fsl_dma_free_descriptor(chan, desc);
+	}
+
+	spin_lock_irqsave(&chan->desc_lock, flags);
+
+	/*
+	 * Replace any non-ACKed descriptors on the front of the ld_completed
+	 * list so they will be freed in the order they were submitted
+	 */
+	list_splice(&ld_cleanup, &chan->ld_completed);
+
+	/* Update the cookie, if it changed */
+	if (cookie > 0)
+		chan->common.completed_cookie = cookie;
+
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
 }
 
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
@@ -578,9 +639,11 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 
 	chan_dbg(chan, "free all channel resources\n");
+	fsldma_cleanup_descriptors(chan);
 	spin_lock_irq(&chan->desc_lock);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
+	fsldma_free_desc_list(chan, &chan->ld_completed);
 	spin_unlock_irq(&chan->desc_lock);
 
 	dma_pool_destroy(chan->desc_pool);
@@ -945,11 +1008,13 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	enum dma_status ret;
 
-	spin_lock_irq(&chan->desc_lock);
 	ret = dma_cookie_status(dchan, cookie, txstate);
-	spin_unlock_irq(&chan->desc_lock);
+	if (ret == DMA_SUCCESS)
+		return ret;
 
-	return ret;
+	tasklet_schedule(&chan->tasklet);
+
+	return dma_cookie_status(dchan, cookie, txstate);
 }
 
 /*----------------------------------------------------------------------------*/
@@ -1013,10 +1078,24 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	if (stat)
 		chan_err(chan, "irq: unhandled sr 0x%08x\n", stat);
 
+	spin_lock(&chan->desc_lock);
+	chan->idle = true;
+
+	/* Move all running descriptors onto the completed list */
+	list_splice_tail_init(&chan->ld_running, &chan->ld_completed);
+
+	/*
+	 * Start any pending transactions automatically
+	 *
+	 * In the ideal case, we keep the DMA controller busy while we go
+	 * ahead and free the descriptors in the tasklet.
+	 */
+	fsl_chan_xfer_ld_queue(chan);
+	spin_unlock(&chan->desc_lock);
+
 	/*
-	 * Schedule the tasklet to handle all cleanup of the current
-	 * transaction. It will start a new transaction if there is
-	 * one pending.
+	 * Schedule the tasklet to handle all cleanup of the completed
+	 * descriptors.
 	 */
 	tasklet_schedule(&chan->tasklet);
 	chan_dbg(chan, "irq: Exit\n");
@@ -1026,53 +1105,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
-	struct fsl_desc_sw *desc, *_desc;
-	LIST_HEAD(ld_cleanup);
-	unsigned long flags;
 
 	chan_dbg(chan, "tasklet entry\n");
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
-
-	/* update the cookie if we have some descriptors to cleanup */
-	if (!list_empty(&chan->ld_running)) {
-		dma_cookie_t cookie;
-
-		desc = to_fsl_desc(chan->ld_running.prev);
-		cookie = desc->async_tx.cookie;
-		dma_cookie_complete(&desc->async_tx);
-
-		chan_dbg(chan, "completed_cookie=%d\n", cookie);
-	}
-
-	/*
-	 * move the descriptors to a temporary list so we can drop the lock
-	 * during the entire cleanup operation
-	 */
-	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
-
-	/* the hardware is now idle and ready for more */
-	chan->idle = true;
-
-	/*
-	 * Start any pending transactions automatically
-	 *
-	 * In the ideal case, we keep the DMA controller busy while we go
-	 * ahead and free the descriptors below.
-	 */
-	fsl_chan_xfer_ld_queue(chan);
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-
-	/* Run the callback for each descriptor, in order */
-	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
-
-		/* Remove from the list of transactions */
-		list_del(&desc->node);
-
-		/* Run all cleanup for this descriptor */
-		fsldma_cleanup_descriptor(chan, desc);
-	}
-
+	fsldma_cleanup_descriptors(chan);
 	chan_dbg(chan, "tasklet exit\n");
 }
 
@@ -1253,6 +1288,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 	spin_lock_init(&chan->desc_lock);
 	INIT_LIST_HEAD(&chan->ld_pending);
 	INIT_LIST_HEAD(&chan->ld_running);
+	INIT_LIST_HEAD(&chan->ld_completed);
 	chan->idle = true;
 
 	chan->common.device = &fdev->common;
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index f5c3879..7ede908 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -140,6 +140,7 @@ struct fsldma_chan {
 	spinlock_t desc_lock;		/* Descriptor operation lock */
 	struct list_head ld_pending;	/* Link descriptors queue */
 	struct list_head ld_running;	/* Link descriptors queue */
+	struct list_head ld_completed;	/* Link descriptors queue */
 	struct dma_chan common;		/* DMA common channel */
 	struct dma_pool *desc_pool;	/* Descriptors pool */
 	struct device *dev;		/* Channel device */
-- 
1.7.8.6
