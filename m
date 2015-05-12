From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/8] dmaengine: mv_xor: improve descriptors list handling and reduce locking
Date: Tue, 12 May 2015 17:37:39 +0200
Message-ID: <1431445063-20226-5-git-send-email-maxime.ripard@free-electrons.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Lior Amsalem <alior@marvell.com>

This patch change the way free descriptors are marked.

Instead of having a field for descriptor in use, all the descriptors in the
all_slots list are free for use.

This simplify the allocation method and reduce the locking needed.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mv_xor.c | 131 +++++++++++++++++----------------------------------
 drivers/dma/mv_xor.h |  17 +++----
 2 files changed, 48 insertions(+), 100 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index bcc9aec0ce02..d1110442f0d2 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -88,12 +88,6 @@ static void mv_desc_set_next_desc(struct mv_xor_desc_slot *desc,
 	hw_desc->phy_next_desc = next_desc_addr;
 }
 
-static void mv_desc_clear_next_desc(struct mv_xor_desc_slot *desc)
-{
-	struct mv_xor_desc *hw_desc = desc->hw_desc;
-	hw_desc->phy_next_desc = 0;
-}
-
 static void mv_desc_set_src_addr(struct mv_xor_desc_slot *desc,
 				 int index, dma_addr_t addr)
 {
@@ -214,21 +208,6 @@ static char mv_chan_is_busy(struct mv_xor_chan *chan)
 	return (state == 1) ? 1 : 0;
 }
 
-/**
- * mv_chan_free_slots - flags descriptor slots for reuse
- * @slot: Slot to free
- * Caller must hold &mv_chan->lock while calling this function
- */
-static void mv_chan_free_slots(struct mv_xor_chan *mv_chan,
-			       struct mv_xor_desc_slot *slot)
-{
-	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d slot %p\n",
-		__func__, __LINE__, slot);
-
-	slot->slot_used = 0;
-
-}
-
 /*
  * mv_chan_start_new_chain - program the engine to operate on new
  * chain headed by sw_desc
@@ -280,12 +259,10 @@ mv_chan_clean_completed_slots(struct mv_xor_chan *mv_chan)
 
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d\n", __func__, __LINE__);
 	list_for_each_entry_safe(iter, _iter, &mv_chan->completed_slots,
-				 completed_node) {
+				 node) {
 
-		if (async_tx_test_ack(&iter->async_tx)) {
-			list_del(&iter->completed_node);
-			mv_chan_free_slots(mv_chan, iter);
-		}
+		if (async_tx_test_ack(&iter->async_tx))
+			list_move_tail(&iter->node, &mv_chan->free_slots);
 	}
 	return 0;
 }
@@ -296,17 +273,16 @@ mv_desc_clean_slot(struct mv_xor_desc_slot *desc,
 {
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d: desc %p flags %d\n",
 		__func__, __LINE__, desc, desc->async_tx.flags);
-	list_del(&desc->chain_node);
+
 	/* the client is allowed to attach dependent operations
 	 * until 'ack' is set
 	 */
-	if (!async_tx_test_ack(&desc->async_tx)) {
+	if (!async_tx_test_ack(&desc->async_tx))
 		/* move this slot to the completed_slots */
-		list_add_tail(&desc->completed_node, &mv_chan->completed_slots);
-		return 0;
-	}
+		list_move_tail(&desc->node, &mv_chan->completed_slots);
+	else
+		list_move_tail(&desc->node, &mv_chan->free_slots);
 
-	mv_chan_free_slots(mv_chan, desc);
 	return 0;
 }
 
@@ -328,7 +304,7 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 	 */
 
 	list_for_each_entry_safe(iter, _iter, &mv_chan->chain,
-					chain_node) {
+					node) {
 		prefetch(_iter);
 		prefetch(&_iter->async_tx);
 
@@ -358,7 +334,7 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 		struct mv_xor_desc_slot *chain_head;
 		chain_head = list_entry(mv_chan->chain.next,
 					struct mv_xor_desc_slot,
-					chain_node);
+					node);
 
 		mv_chan_start_new_chain(mv_chan, chain_head);
 	}
@@ -379,49 +355,28 @@ static void mv_xor_tasklet(unsigned long data)
 static struct mv_xor_desc_slot *
 mv_chan_alloc_slot(struct mv_xor_chan *mv_chan)
 {
-	struct mv_xor_desc_slot *iter, *_iter;
-	int retry = 0;
+	struct mv_xor_desc_slot *iter;
 
-	/* start search from the last allocated descrtiptor
-	 * if a contiguous allocation can not be found start searching
-	 * from the beginning of the list
-	 */
-retry:
-	if (retry == 0)
-		iter = mv_chan->last_used;
-	else
-		iter = list_entry(&mv_chan->all_slots,
-			struct mv_xor_desc_slot,
-			slot_node);
+	spin_lock_bh(&mv_chan->lock);
 
-	list_for_each_entry_safe_continue(
-		iter, _iter, &mv_chan->all_slots, slot_node) {
+	if (!list_empty(&mv_chan->free_slots)) {
+		iter = list_first_entry(&mv_chan->free_slots,
+					struct mv_xor_desc_slot,
+					node);
 
-		prefetch(_iter);
-		prefetch(&_iter->async_tx);
-		if (iter->slot_used) {
-			/* give up after finding the first busy slot
-			 * on the second pass through the list
-			 */
-			if (retry)
-				break;
-			continue;
-		}
+		list_move_tail(&iter->node, &mv_chan->allocated_slots);
+
+		spin_unlock_bh(&mv_chan->lock);
 
 		/* pre-ack descriptor */
 		async_tx_ack(&iter->async_tx);
-
-		iter->slot_used = 1;
-		INIT_LIST_HEAD(&iter->chain_node);
 		iter->async_tx.cookie = -EBUSY;
-		mv_chan->last_used = iter;
-		mv_desc_clear_next_desc(iter);
 
 		return iter;
 
 	}
-	if (!retry++)
-		goto retry;
+
+	spin_unlock_bh(&mv_chan->lock);
 
 	/* try to free some slots if the allocation fails */
 	tasklet_schedule(&mv_chan->irq_tasklet);
@@ -447,14 +402,14 @@ mv_xor_tx_submit(struct dma_async_tx_descriptor *tx)
 	cookie = dma_cookie_assign(tx);
 
 	if (list_empty(&mv_chan->chain))
-		list_add_tail(&sw_desc->chain_node, &mv_chan->chain);
+		list_move_tail(&sw_desc->node, &mv_chan->chain);
 	else {
 		new_hw_chain = 0;
 
 		old_chain_tail = list_entry(mv_chan->chain.prev,
 					    struct mv_xor_desc_slot,
-					    chain_node);
-		list_add_tail(&sw_desc->chain_node, &mv_chan->chain);
+					    node);
+		list_move_tail(&sw_desc->node, &mv_chan->chain);
 
 		dev_dbg(mv_chan_to_devp(mv_chan), "Append to last desc %pa\n",
 			&old_chain_tail->async_tx.phys);
@@ -507,26 +462,20 @@ static int mv_xor_alloc_chan_resources(struct dma_chan *chan)
 
 		dma_async_tx_descriptor_init(&slot->async_tx, chan);
 		slot->async_tx.tx_submit = mv_xor_tx_submit;
-		INIT_LIST_HEAD(&slot->chain_node);
-		INIT_LIST_HEAD(&slot->slot_node);
+		INIT_LIST_HEAD(&slot->node);
 		dma_desc = mv_chan->dma_desc_pool;
 		slot->async_tx.phys = dma_desc + idx * MV_XOR_SLOT_SIZE;
 		slot->idx = idx++;
 
 		spin_lock_bh(&mv_chan->lock);
 		mv_chan->slots_allocated = idx;
-		list_add_tail(&slot->slot_node, &mv_chan->all_slots);
+		list_add_tail(&slot->node, &mv_chan->free_slots);
 		spin_unlock_bh(&mv_chan->lock);
 	}
 
-	if (mv_chan->slots_allocated && !mv_chan->last_used)
-		mv_chan->last_used = list_entry(mv_chan->all_slots.next,
-					struct mv_xor_desc_slot,
-					slot_node);
-
 	dev_dbg(mv_chan_to_devp(mv_chan),
-		"allocated %d descriptor slots last_used: %p\n",
-		mv_chan->slots_allocated, mv_chan->last_used);
+		"allocated %d descriptor slots\n",
+		mv_chan->slots_allocated);
 
 	return mv_chan->slots_allocated ? : -ENOMEM;
 }
@@ -547,7 +496,6 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		"%s src_cnt: %d len: %u dest %pad flags: %ld\n",
 		__func__, src_cnt, len, &dest, flags);
 
-	spin_lock_bh(&mv_chan->lock);
 	sw_desc = mv_chan_alloc_slot(mv_chan);
 	if (sw_desc) {
 		sw_desc->type = DMA_XOR;
@@ -558,7 +506,7 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		while (src_cnt--)
 			mv_desc_set_src_addr(sw_desc, src_cnt, src[src_cnt]);
 	}
-	spin_unlock_bh(&mv_chan->lock);
+
 	dev_dbg(mv_chan_to_devp(mv_chan),
 		"%s sw_desc %p async_tx %p \n",
 		__func__, sw_desc, &sw_desc->async_tx);
@@ -605,22 +553,26 @@ static void mv_xor_free_chan_resources(struct dma_chan *chan)
 	mv_chan_slot_cleanup(mv_chan);
 
 	list_for_each_entry_safe(iter, _iter, &mv_chan->chain,
-					chain_node) {
+					node) {
 		in_use_descs++;
-		list_del(&iter->chain_node);
+		list_move_tail(&iter->node, &mv_chan->free_slots);
 	}
 	list_for_each_entry_safe(iter, _iter, &mv_chan->completed_slots,
-				 completed_node) {
+				 node) {
+		in_use_descs++;
+		list_move_tail(&iter->node, &mv_chan->free_slots);
+	}
+	list_for_each_entry_safe(iter, _iter, &mv_chan->allocated_slots,
+				 node) {
 		in_use_descs++;
-		list_del(&iter->completed_node);
+		list_move_tail(&iter->node, &mv_chan->free_slots);
 	}
 	list_for_each_entry_safe_reverse(
-		iter, _iter, &mv_chan->all_slots, slot_node) {
-		list_del(&iter->slot_node);
+		iter, _iter, &mv_chan->free_slots, node) {
+		list_del(&iter->node);
 		kfree(iter);
 		mv_chan->slots_allocated--;
 	}
-	mv_chan->last_used = NULL;
 
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s slots_allocated %d\n",
 		__func__, mv_chan->slots_allocated);
@@ -1078,7 +1030,8 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 	spin_lock_init(&mv_chan->lock);
 	INIT_LIST_HEAD(&mv_chan->chain);
 	INIT_LIST_HEAD(&mv_chan->completed_slots);
-	INIT_LIST_HEAD(&mv_chan->all_slots);
+	INIT_LIST_HEAD(&mv_chan->free_slots);
+	INIT_LIST_HEAD(&mv_chan->allocated_slots);
 	mv_chan->dmachan.device = dma_dev;
 	dma_cookie_init(&mv_chan->dmachan);
 
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 145ba2f895f7..71684de37ddb 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -93,11 +93,11 @@ struct mv_xor_device {
  * @mmr_base: memory mapped register base
  * @idx: the index of the xor channel
  * @chain: device chain view of the descriptors
+ * @free_slots: free slots usable by the channel
+ * @allocated_slots: slots allocated by the driver
  * @completed_slots: slots completed by HW but still need to be acked
  * @device: parent device
  * @common: common dmaengine channel object members
- * @last_used: place holder for allocation to continue from where it left off
- * @all_slots: complete domain of slots usable by the channel
  * @slots_allocated: records the actual size of the descriptor slot pool
  * @irq_tasklet: bottom half where mv_xor_slot_cleanup runs
  * @op_in_desc: new mode of driver, each op is writen to descriptor.
@@ -111,14 +111,14 @@ struct mv_xor_chan {
 	int                     irq;
 	enum dma_transaction_type	current_type;
 	struct list_head	chain;
+	struct list_head	free_slots;
+	struct list_head	allocated_slots;
 	struct list_head	completed_slots;
 	dma_addr_t		dma_desc_pool;
 	void			*dma_desc_pool_virt;
 	size_t                  pool_size;
 	struct dma_device	dmadev;
 	struct dma_chan		dmachan;
-	struct mv_xor_desc_slot	*last_used;
-	struct list_head	all_slots;
 	int			slots_allocated;
 	struct tasklet_struct	irq_tasklet;
 	int                     op_in_desc;
@@ -129,9 +129,7 @@ struct mv_xor_chan {
 
 /**
  * struct mv_xor_desc_slot - software descriptor
- * @slot_node: node on the mv_xor_chan.all_slots list
- * @chain_node: node on the mv_xor_chan.chain list
- * @completed_node: node on the mv_xor_chan.completed_slots list
+ * @node: node on the mv_xor_chan lists
  * @hw_desc: virtual address of the hardware descriptor chain
  * @phys: hardware address of the hardware descriptor chain
  * @slot_used: slot in use or not
@@ -140,12 +138,9 @@ struct mv_xor_chan {
  * @async_tx: support for the async_tx api
  */
 struct mv_xor_desc_slot {
-	struct list_head	slot_node;
-	struct list_head	chain_node;
-	struct list_head	completed_node;
+	struct list_head	node;
 	enum dma_transaction_type	type;
 	void			*hw_desc;
-	u16			slot_used;
 	u16			idx;
 	struct dma_async_tx_descriptor	async_tx;
 };
-- 
2.4.0
