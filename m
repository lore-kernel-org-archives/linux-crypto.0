From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v3 3/4] fsl-dma: change release process of dma descriptor for supporting async_tx
Date: Mon, 16 Jul 2012 12:08:29 +0800
Message-ID: <1342411709-29895-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:24995
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab2GPEaK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 00:30:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the potential risk when enable config NET_DMA and ASYNC_TX.
Async_tx is lack of support in current release process of dma descriptor,
all descriptors will be released whatever is acked or no-acked by async_tx,
so there is a potential race condition when dma engine is uesd by others
clients (e.g. when enable NET_DMA to offload TCP).

In our case, a race condition which is raised when use both of talitos
and dmaengine to offload xor is because napi scheduler will sync all
pending requests in dma channels, it affects the process of raid operations
due to ack_tx is not checked in fsl dma. The no-acked descriptor is freed
which is submitted just now, as a dependent tx, this freed descriptor trigger
BUG_ON(async_tx_test_ack(depend_tx)) in async_tx_submit().

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |  378 +++++++++++++++++++++++++++++--------------------
 drivers/dma/fsldma.h |    1 +
 2 files changed, 225 insertions(+), 154 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4f2f212..4ee1b8f 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -400,6 +400,217 @@ out_splice:
 	list_splice_tail_init(&desc->tx_list, &chan->ld_pending);
 }

+/**
+ * fsl_chan_xfer_ld_queue - transfer any pending transactions
+ * @chan : Freescale DMA channel
+ *
+ * HARDWARE STATE: idle
+ * LOCKING: must hold chan->desc_lock
+ */
+static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc;
+
+	/*
+	 * If the list of pending descriptors is empty, then we
+	 * don't need to do any work at all
+	 */
+	if (list_empty(&chan->ld_pending)) {
+		chan_dbg(chan, "no pending LDs\n");
+		return;
+	}
+
+	/*
+	 * The DMA controller is not idle, which means that the interrupt
+	 * handler will start any queued transactions when it runs after
+	 * this transaction finishes
+	 */
+	if (!chan->idle) {
+		chan_dbg(chan, "DMA controller still busy\n");
+		return;
+	}
+
+	/*
+	 * If there are some link descriptors which have not been
+	 * transferred, we need to start the controller
+	 */
+
+	/*
+	 * Move all elements from the queue of pending transactions
+	 * onto the list of running transactions
+	 */
+	chan_dbg(chan, "idle, starting controller\n");
+	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
+	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
+
+	/*
+	 * The 85xx DMA controller doesn't clear the channel start bit
+	 * automatically at the end of a transfer. Therefore we must clear
+	 * it in software before starting the transfer.
+	 */
+	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
+		u32 mode;
+
+		mode = DMA_IN(chan, &chan->regs->mr, 32);
+		mode &= ~FSL_DMA_MR_CS;
+		DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	}
+
+	/*
+	 * Program the descriptor's address into the DMA controller,
+	 * then start the DMA transaction
+	 */
+	set_cdar(chan, desc->async_tx.phys);
+	get_cdar(chan);
+
+	dma_start(chan);
+	chan->idle = false;
+}
+
+static int
+fsldma_clean_completed_descriptor(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc, *_desc;
+
+	/* Run the callback for each descriptor, in order */
+	list_for_each_entry_safe(desc, _desc, &chan->ld_completed, node) {
+
+		if (async_tx_test_ack(&desc->async_tx)) {
+			/* Remove from the list of transactions */
+			list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+			chan_dbg(chan, "LD %p free\n", desc);
+#endif
+			dma_pool_free(chan->desc_pool, desc,
+					desc->async_tx.phys);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * fsldma_run_tx_complete_actions - cleanup and free a single link descriptor
+ * @chan: Freescale DMA channel
+ * @desc: descriptor to cleanup and free
+ * @cookie: Freescale DMA transaction identifier
+ *
+ * This function is used on a descriptor which has been executed by the DMA
+ * controller. It will run any callbacks, submit any dependencies, and then
+ * free the descriptor.
+ */
+static dma_cookie_t fsldma_run_tx_complete_actions(struct fsl_desc_sw *desc,
+		struct fsldma_chan *chan, dma_cookie_t cookie)
+{
+	struct dma_async_tx_descriptor *txd = &desc->async_tx;
+	struct device *dev = chan->common.device->dev;
+	dma_addr_t src = get_desc_src(chan, desc);
+	dma_addr_t dst = get_desc_dst(chan, desc);
+	u32 len = get_desc_cnt(chan, desc);
+
+	BUG_ON(txd->cookie < 0);
+
+	if (txd->cookie > 0) {
+		cookie = txd->cookie;
+
+		/* Run the link descriptor callback function */
+		if (txd->callback) {
+#ifdef FSL_DMA_LD_DEBUG
+			chan_dbg(chan, "LD %p callback\n", desc);
+#endif
+			txd->callback(txd->callback_param);
+		}
+
+		/* Unmap the dst buffer, if requested */
+		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+				dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);
+			else
+				dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);
+		}
+
+		/* Unmap the src buffer, if requested */
+		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+				dma_unmap_single(dev, src, len, DMA_TO_DEVICE);
+			else
+				dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
+		}
+	}
+
+	/* Run any dependencies */
+	dma_run_dependencies(txd);
+
+	return cookie;
+}
+
+static int
+fsldma_clean_running_descriptor(struct fsl_desc_sw *desc,
+			struct fsldma_chan *chan)
+{
+	/* Remove from the list of transactions */
+	list_del(&desc->node);
+	/* the client is allowed to attach dependent operations
+	 * until 'ack' is set
+	 */
+	if (!async_tx_test_ack(&desc->async_tx)) {
+		/* move this slot to the completed */
+		list_add_tail(&desc->node, &chan->ld_completed);
+		return 0;
+	}
+
+	dma_pool_free(chan->desc_pool, desc,
+			desc->async_tx.phys);
+	return 0;
+}
+
+static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc, *_desc;
+	dma_cookie_t cookie = 0;
+	dma_addr_t curr_phys = get_cdar(chan);
+	int idle = dma_is_idle(chan);
+	int seen_current = 0;
+
+	fsldma_clean_completed_descriptor(chan);
+
+	/* Run the callback for each descriptor, in order */
+	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
+		/* do not advance past the current descriptor loaded into the
+		 * hardware channel, subsequent descriptors are either in
+		 * process or have not been submitted
+		 */
+		if (seen_current)
+			break;
+
+		/* stop the search if we reach the current descriptor and the
+		 * channel is busy
+		 */
+		if (desc->async_tx.phys == curr_phys) {
+			seen_current = 1;
+			if (!idle)
+				break;
+		}
+
+		cookie = fsldma_run_tx_complete_actions(desc, chan, cookie);
+
+		if (fsldma_clean_running_descriptor(desc, chan))
+			break;
+
+	}
+
+	/*
+	 * Start any pending transactions automatically
+	 *
+	 * In the ideal case, we keep the DMA controller busy while we go
+	 * ahead and free the descriptors below.
+	 */
+	fsl_chan_xfer_ld_queue(chan);
+
+	if (cookie > 0)
+		chan->common.completed_cookie = cookie;
+}
+
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
@@ -534,8 +745,10 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)

 	chan_dbg(chan, "free all channel resources\n");
 	spin_lock_irqsave(&chan->desc_lock, flags);
+	fsldma_cleanup_descriptor(chan);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
+	fsldma_free_desc_list(chan, &chan->ld_completed);
 	spin_unlock_irqrestore(&chan->desc_lock, flags);

 	dma_pool_destroy(chan->desc_pool);
@@ -811,124 +1024,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 }

 /**
- * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
- * @chan: Freescale DMA channel
- * @desc: descriptor to cleanup and free
- *
- * This function is used on a descriptor which has been executed by the DMA
- * controller. It will run any callbacks, submit any dependencies, and then
- * free the descriptor.
- */
-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
-				      struct fsl_desc_sw *desc)
-{
-	struct dma_async_tx_descriptor *txd = &desc->async_tx;
-	struct device *dev = chan->common.device->dev;
-	dma_addr_t src = get_desc_src(chan, desc);
-	dma_addr_t dst = get_desc_dst(chan, desc);
-	u32 len = get_desc_cnt(chan, desc);
-
-	/* Run the link descriptor callback function */
-	if (txd->callback) {
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p callback\n", desc);
-#endif
-		txd->callback(txd->callback_param);
-	}
-
-	/* Run any dependencies */
-	dma_run_dependencies(txd);
-
-	/* Unmap the dst buffer, if requested */
-	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-			dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);
-		else
-			dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);
-	}
-
-	/* Unmap the src buffer, if requested */
-	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-			dma_unmap_single(dev, src, len, DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
-	}
-
-#ifdef FSL_DMA_LD_DEBUG
-	chan_dbg(chan, "LD %p free\n", desc);
-#endif
-	dma_pool_free(chan->desc_pool, desc, txd->phys);
-}
-
-/**
- * fsl_chan_xfer_ld_queue - transfer any pending transactions
- * @chan : Freescale DMA channel
- *
- * HARDWARE STATE: idle
- * LOCKING: must hold chan->desc_lock
- */
-static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc;
-
-	/*
-	 * If the list of pending descriptors is empty, then we
-	 * don't need to do any work at all
-	 */
-	if (list_empty(&chan->ld_pending)) {
-		chan_dbg(chan, "no pending LDs\n");
-		return;
-	}
-
-	/*
-	 * The DMA controller is not idle, which means that the interrupt
-	 * handler will start any queued transactions when it runs after
-	 * this transaction finishes
-	 */
-	if (!chan->idle) {
-		chan_dbg(chan, "DMA controller still busy\n");
-		return;
-	}
-
-	/*
-	 * If there are some link descriptors which have not been
-	 * transferred, we need to start the controller
-	 */
-
-	/*
-	 * Move all elements from the queue of pending transactions
-	 * onto the list of running transactions
-	 */
-	chan_dbg(chan, "idle, starting controller\n");
-	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
-	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
-
-	/*
-	 * The 85xx DMA controller doesn't clear the channel start bit
-	 * automatically at the end of a transfer. Therefore we must clear
-	 * it in software before starting the transfer.
-	 */
-	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
-		u32 mode;
-
-		mode = DMA_IN(chan, &chan->regs->mr, 32);
-		mode &= ~FSL_DMA_MR_CS;
-		DMA_OUT(chan, &chan->regs->mr, mode, 32);
-	}
-
-	/*
-	 * Program the descriptor's address into the DMA controller,
-	 * then start the DMA transaction
-	 */
-	set_cdar(chan, desc->async_tx.phys);
-	get_cdar(chan);
-
-	dma_start(chan);
-	chan->idle = false;
-}
-
-/**
  * fsl_dma_memcpy_issue_pending - Issue the DMA start command
  * @chan : Freescale DMA channel
  */
@@ -954,11 +1049,17 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 	enum dma_status ret;
 	unsigned long flags;

-	spin_lock_irqsave(&chan->desc_lock, flags);
 	ret = dma_cookie_status(dchan, cookie, txstate);
+	if (ret == DMA_SUCCESS) {
+		fsldma_clean_completed_descriptor(chan);
+		return ret;
+	}
+
+	spin_lock_irqsave(&chan->desc_lock, flags);
+	fsldma_cleanup_descriptor(chan);
 	spin_unlock_irqrestore(&chan->desc_lock, flags);

-	return ret;
+	return dma_cookie_status(dchan, cookie, txstate);
 }

 /*----------------------------------------------------------------------------*/
@@ -1035,53 +1136,21 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
-	struct fsl_desc_sw *desc, *_desc;
-	LIST_HEAD(ld_cleanup);
 	unsigned long flags;

 	chan_dbg(chan, "tasklet entry\n");

 	spin_lock_irqsave(&chan->desc_lock, flags);

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
+	/* Run all cleanup for this descriptor */
+	fsldma_cleanup_descriptor(chan);

 	/* the hardware is now idle and ready for more */
 	chan->idle = true;

-	/*
-	 * Start any pending transactions automatically
-	 *
-	 * In the ideal case, we keep the DMA controller busy while we go
-	 * ahead and free the descriptors below.
-	 */
 	fsl_chan_xfer_ld_queue(chan);
 	spin_unlock_irqrestore(&chan->desc_lock, flags);

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
 	chan_dbg(chan, "tasklet exit\n");
 }

@@ -1262,6 +1331,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
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
1.7.5.1
