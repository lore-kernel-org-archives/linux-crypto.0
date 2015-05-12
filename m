From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/8] dmaengine: mv_xor: Rename function for consistent naming
Date: Tue, 12 May 2015 17:37:36 +0200
Message-ID: <1431445063-20226-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57252 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751757AbbELPkE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 11:40:04 -0400
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current function names isn't very consistent, and functions with the
same prefix might operate on either a channel or a descriptor, which is
kind of confusing.

Rename these functions to have a consistent and clearer naming scheme.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mv_xor.c | 83 ++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 1c56001df676..1affafa888c5 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -104,7 +104,7 @@ static u32 mv_chan_get_intr_cause(struct mv_xor_chan *chan)
 	return intr_cause;
 }
 
-static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
+static void mv_chan_clear_eoc_cause(struct mv_xor_chan *chan)
 {
 	u32 val;
 
@@ -114,14 +114,14 @@ static void mv_xor_device_clear_eoc_cause(struct mv_xor_chan *chan)
 	writel_relaxed(val, XOR_INTR_CAUSE(chan));
 }
 
-static void mv_xor_device_clear_err_status(struct mv_xor_chan *chan)
+static void mv_chan_clear_err_status(struct mv_xor_chan *chan)
 {
 	u32 val = 0xFFFF0000 >> (chan->idx * 16);
 	writel_relaxed(val, XOR_INTR_CAUSE(chan));
 }
 
-static void mv_set_mode(struct mv_xor_chan *chan,
-			       enum dma_transaction_type type)
+static void mv_chan_set_mode(struct mv_xor_chan *chan,
+			     enum dma_transaction_type type)
 {
 	u32 op_mode;
 	u32 config = readl_relaxed(XOR_CONFIG(chan));
@@ -172,12 +172,12 @@ static char mv_chan_is_busy(struct mv_xor_chan *chan)
 }
 
 /**
- * mv_xor_free_slots - flags descriptor slots for reuse
+ * mv_chan_free_slots - flags descriptor slots for reuse
  * @slot: Slot to free
  * Caller must hold &mv_chan->lock while calling this function
  */
-static void mv_xor_free_slots(struct mv_xor_chan *mv_chan,
-			      struct mv_xor_desc_slot *slot)
+static void mv_chan_free_slots(struct mv_xor_chan *mv_chan,
+			       struct mv_xor_desc_slot *slot)
 {
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d slot %p\n",
 		__func__, __LINE__, slot);
@@ -187,12 +187,12 @@ static void mv_xor_free_slots(struct mv_xor_chan *mv_chan,
 }
 
 /*
- * mv_xor_start_new_chain - program the engine to operate on new chain headed by
- * sw_desc
+ * mv_chan_start_new_chain - program the engine to operate on new
+ * chain headed by sw_desc
  * Caller must hold &mv_chan->lock while calling this function
  */
-static void mv_xor_start_new_chain(struct mv_xor_chan *mv_chan,
-				   struct mv_xor_desc_slot *sw_desc)
+static void mv_chan_start_new_chain(struct mv_xor_chan *mv_chan,
+				    struct mv_xor_desc_slot *sw_desc)
 {
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d: sw_desc %p\n",
 		__func__, __LINE__, sw_desc);
@@ -205,8 +205,9 @@ static void mv_xor_start_new_chain(struct mv_xor_chan *mv_chan,
 }
 
 static dma_cookie_t
-mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
-	struct mv_xor_chan *mv_chan, dma_cookie_t cookie)
+mv_desc_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
+				struct mv_xor_chan *mv_chan,
+				dma_cookie_t cookie)
 {
 	BUG_ON(desc->async_tx.cookie < 0);
 
@@ -230,7 +231,7 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 }
 
 static int
-mv_xor_clean_completed_slots(struct mv_xor_chan *mv_chan)
+mv_chan_clean_completed_slots(struct mv_xor_chan *mv_chan)
 {
 	struct mv_xor_desc_slot *iter, *_iter;
 
@@ -240,15 +241,15 @@ mv_xor_clean_completed_slots(struct mv_xor_chan *mv_chan)
 
 		if (async_tx_test_ack(&iter->async_tx)) {
 			list_del(&iter->completed_node);
-			mv_xor_free_slots(mv_chan, iter);
+			mv_chan_free_slots(mv_chan, iter);
 		}
 	}
 	return 0;
 }
 
 static int
-mv_xor_clean_slot(struct mv_xor_desc_slot *desc,
-	struct mv_xor_chan *mv_chan)
+mv_desc_clean_slot(struct mv_xor_desc_slot *desc,
+		   struct mv_xor_chan *mv_chan)
 {
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d: desc %p flags %d\n",
 		__func__, __LINE__, desc, desc->async_tx.flags);
@@ -262,12 +263,12 @@ mv_xor_clean_slot(struct mv_xor_desc_slot *desc,
 		return 0;
 	}
 
-	mv_xor_free_slots(mv_chan, desc);
+	mv_chan_free_slots(mv_chan, desc);
 	return 0;
 }
 
 /* This function must be called with the mv_xor_chan spinlock held */
-static void mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
+static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 {
 	struct mv_xor_desc_slot *iter, *_iter;
 	dma_cookie_t cookie = 0;
@@ -277,7 +278,7 @@ static void mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d\n", __func__, __LINE__);
 	dev_dbg(mv_chan_to_devp(mv_chan), "current_desc %x\n", current_desc);
-	mv_xor_clean_completed_slots(mv_chan);
+	mv_chan_clean_completed_slots(mv_chan);
 
 	/* free completed slots from the chain starting with
 	 * the oldest descriptor
@@ -304,9 +305,9 @@ static void mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 				break;
 		}
 
-		cookie = mv_xor_run_tx_complete_actions(iter, mv_chan, cookie);
+		cookie = mv_desc_run_tx_complete_actions(iter, mv_chan, cookie);
 
-		if (mv_xor_clean_slot(iter, mv_chan))
+		if (mv_desc_clean_slot(iter, mv_chan))
 			break;
 	}
 
@@ -316,7 +317,7 @@ static void mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
 					struct mv_xor_desc_slot,
 					chain_node);
 
-		mv_xor_start_new_chain(mv_chan, chain_head);
+		mv_chan_start_new_chain(mv_chan, chain_head);
 	}
 
 	if (cookie > 0)
@@ -328,12 +329,12 @@ static void mv_xor_tasklet(unsigned long data)
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
 
 	spin_lock_bh(&chan->lock);
-	mv_xor_slot_cleanup(chan);
+	mv_chan_slot_cleanup(chan);
 	spin_unlock_bh(&chan->lock);
 }
 
 static struct mv_xor_desc_slot *
-mv_xor_alloc_slot(struct mv_xor_chan *mv_chan)
+mv_chan_alloc_slot(struct mv_xor_chan *mv_chan)
 {
 	struct mv_xor_desc_slot *iter, *_iter;
 	int retry = 0;
@@ -431,7 +432,7 @@ mv_xor_tx_submit(struct dma_async_tx_descriptor *tx)
 	}
 
 	if (new_hw_chain)
-		mv_xor_start_new_chain(mv_chan, sw_desc);
+		mv_chan_start_new_chain(mv_chan, sw_desc);
 
 	spin_unlock_bh(&mv_chan->lock);
 
@@ -504,7 +505,7 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		__func__, src_cnt, len, &dest, flags);
 
 	spin_lock_bh(&mv_chan->lock);
-	sw_desc = mv_xor_alloc_slot(mv_chan);
+	sw_desc = mv_chan_alloc_slot(mv_chan);
 	if (sw_desc) {
 		sw_desc->type = DMA_XOR;
 		sw_desc->async_tx.flags = flags;
@@ -556,7 +557,7 @@ static void mv_xor_free_chan_resources(struct dma_chan *chan)
 
 	spin_lock_bh(&mv_chan->lock);
 
-	mv_xor_slot_cleanup(mv_chan);
+	mv_chan_slot_cleanup(mv_chan);
 
 	list_for_each_entry_safe(iter, _iter, &mv_chan->chain,
 					chain_node) {
@@ -603,13 +604,13 @@ static enum dma_status mv_xor_status(struct dma_chan *chan,
 		return ret;
 
 	spin_lock_bh(&mv_chan->lock);
-	mv_xor_slot_cleanup(mv_chan);
+	mv_chan_slot_cleanup(mv_chan);
 	spin_unlock_bh(&mv_chan->lock);
 
 	return dma_cookie_status(chan, cookie, txstate);
 }
 
-static void mv_dump_xor_regs(struct mv_xor_chan *chan)
+static void mv_chan_dump_regs(struct mv_xor_chan *chan)
 {
 	u32 val;
 
@@ -632,8 +633,8 @@ static void mv_dump_xor_regs(struct mv_xor_chan *chan)
 	dev_err(mv_chan_to_devp(chan), "error addr   0x%08x\n", val);
 }
 
-static void mv_xor_err_interrupt_handler(struct mv_xor_chan *chan,
-					 u32 intr_cause)
+static void mv_chan_err_interrupt_handler(struct mv_xor_chan *chan,
+					  u32 intr_cause)
 {
 	if (intr_cause & XOR_INT_ERR_DECODE) {
 		dev_dbg(mv_chan_to_devp(chan), "ignoring address decode error\n");
@@ -643,7 +644,7 @@ static void mv_xor_err_interrupt_handler(struct mv_xor_chan *chan,
 	dev_err(mv_chan_to_devp(chan), "error on chan %d. intr cause 0x%08x\n",
 		chan->idx, intr_cause);
 
-	mv_dump_xor_regs(chan);
+	mv_chan_dump_regs(chan);
 	WARN_ON(1);
 }
 
@@ -655,11 +656,11 @@ static irqreturn_t mv_xor_interrupt_handler(int irq, void *data)
 	dev_dbg(mv_chan_to_devp(chan), "intr cause %x\n", intr_cause);
 
 	if (intr_cause & XOR_INTR_ERRORS)
-		mv_xor_err_interrupt_handler(chan, intr_cause);
+		mv_chan_err_interrupt_handler(chan, intr_cause);
 
 	tasklet_schedule(&chan->irq_tasklet);
 
-	mv_xor_device_clear_eoc_cause(chan);
+	mv_chan_clear_eoc_cause(chan);
 
 	return IRQ_HANDLED;
 }
@@ -678,7 +679,7 @@ static void mv_xor_issue_pending(struct dma_chan *chan)
  * Perform a transaction to verify the HW works.
  */
 
-static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
+static int mv_chan_memcpy_self_test(struct mv_xor_chan *mv_chan)
 {
 	int i, ret;
 	void *src, *dest;
@@ -787,7 +788,7 @@ out:
 
 #define MV_XOR_NUM_SRC_TEST 4 /* must be <= 15 */
 static int
-mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
+mv_chan_xor_self_test(struct mv_xor_chan *mv_chan)
 {
 	int i, src_idx, ret;
 	struct page *dest;
@@ -1014,7 +1015,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		     mv_chan);
 
 	/* clear errors before enabling interrupts */
-	mv_xor_device_clear_err_status(mv_chan);
+	mv_chan_clear_err_status(mv_chan);
 
 	ret = request_irq(mv_chan->irq, mv_xor_interrupt_handler,
 			  0, dev_name(&pdev->dev), mv_chan);
@@ -1023,7 +1024,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 	mv_chan_unmask_interrupts(mv_chan);
 
-	mv_set_mode(mv_chan, DMA_XOR);
+	mv_chan_set_mode(mv_chan, DMA_XOR);
 
 	spin_lock_init(&mv_chan->lock);
 	INIT_LIST_HEAD(&mv_chan->chain);
@@ -1035,14 +1036,14 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	list_add_tail(&mv_chan->dmachan.device_node, &dma_dev->channels);
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
-		ret = mv_xor_memcpy_self_test(mv_chan);
+		ret = mv_chan_memcpy_self_test(mv_chan);
 		dev_dbg(&pdev->dev, "memcpy self test returned %d\n", ret);
 		if (ret)
 			goto err_free_irq;
 	}
 
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
-		ret = mv_xor_xor_self_test(mv_chan);
+		ret = mv_chan_xor_self_test(mv_chan);
 		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
 		if (ret)
 			goto err_free_irq;
-- 
2.4.0
