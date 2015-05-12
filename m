From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 7/8] dmaengine: mv_xor: add support for a38x RAID6 support
Date: Tue, 12 May 2015 17:37:42 +0200
Message-ID: <1431445063-20226-8-git-send-email-maxime.ripard@free-electrons.com>
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

The offload engine in A38x introduce RAID6 capability, this patch adds
RAID6 offload support for mv_xor driver.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Tested-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mv_xor.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/dma/mv_xor.h |   5 ++-
 2 files changed, 111 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 28980483eafb..9b5753dcbf76 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -36,6 +36,11 @@ enum mv_xor_mode {
 	XOR_MODE_IN_DESC,
 };
 
+/* engine coefficients  */
+static u8 mv_xor_raid6_coefs[8] = {
+	0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
+};
+
 static void mv_xor_issue_pending(struct dma_chan *chan);
 
 #define to_mv_xor_chan(chan)		\
@@ -48,8 +53,7 @@ static void mv_xor_issue_pending(struct dma_chan *chan);
 	((chan)->dmadev.dev)
 
 static void mv_desc_init(struct mv_xor_desc_slot *desc,
-			 dma_addr_t addr, u32 byte_count,
-			 enum dma_ctrl_flags flags)
+			  u32 byte_count, enum dma_ctrl_flags flags)
 {
 	struct mv_xor_desc *hw_desc = desc->hw_desc;
 
@@ -58,7 +62,6 @@ static void mv_desc_init(struct mv_xor_desc_slot *desc,
 	/* Enable end-of-descriptor interrupts only for DMA_PREP_INTERRUPT */
 	hw_desc->desc_command = (flags & DMA_PREP_INTERRUPT) ?
 				XOR_DESC_EOD_INT_EN : 0;
-	hw_desc->phy_dest_addr = addr;
 	hw_desc->byte_count = byte_count;
 }
 
@@ -74,6 +77,9 @@ static void mv_desc_set_mode(struct mv_xor_desc_slot *desc)
 	case DMA_MEMCPY:
 		hw_desc->desc_command |= XOR_DESC_OPERATION_MEMCPY;
 		break;
+	case DMA_PQ:
+		hw_desc->desc_command |= XOR_DESC_OPERATION_PQ;
+		break;
 	default:
 		BUG();
 		return;
@@ -84,16 +90,38 @@ static void mv_desc_set_next_desc(struct mv_xor_desc_slot *desc,
 				  u32 next_desc_addr)
 {
 	struct mv_xor_desc *hw_desc = desc->hw_desc;
+
 	BUG_ON(hw_desc->phy_next_desc);
 	hw_desc->phy_next_desc = next_desc_addr;
 }
 
+static void mv_desc_set_dest_addr(struct mv_xor_desc_slot *desc,
+				  dma_addr_t addr)
+{
+	struct mv_xor_desc *hw_desc = desc->hw_desc;
+
+	hw_desc->phy_dest_addr = addr;
+	if (desc->type == DMA_PQ)
+		hw_desc->desc_command |= (1 << 8);
+}
+
+static void mv_desc_set_q_dest_addr(struct mv_xor_desc_slot *desc,
+				    dma_addr_t addr)
+{
+	struct mv_xor_desc *hw_desc = desc->hw_desc;
+
+	hw_desc->phy_q_dest_addr = addr;
+	if (desc->type == DMA_PQ)
+		hw_desc->desc_command |= (1 << 9);
+}
+
 static void mv_desc_set_src_addr(struct mv_xor_desc_slot *desc,
 				 int index, dma_addr_t addr)
 {
 	struct mv_xor_desc *hw_desc = desc->hw_desc;
+
 	hw_desc->phy_src_addr[mv_phy_src_idx(index)] = addr;
-	if (desc->type == DMA_XOR)
+	if ((desc->type == DMA_XOR) || (desc->type == DMA_PQ))
 		hw_desc->desc_command |= (1 << index);
 }
 
@@ -520,7 +548,8 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 	if (sw_desc) {
 		sw_desc->type = DMA_XOR;
 		sw_desc->async_tx.flags = flags;
-		mv_desc_init(sw_desc, dest, len, flags);
+		mv_desc_init(sw_desc, len, flags);
+		mv_desc_set_dest_addr(sw_desc, dest);
 		if (mv_chan->op_in_desc == XOR_MODE_IN_DESC)
 			mv_desc_set_mode(sw_desc);
 		while (src_cnt--)
@@ -562,6 +591,69 @@ mv_xor_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
 	return mv_xor_prep_dma_xor(chan, dest, &src, 1, len, flags);
 }
 
+static struct dma_async_tx_descriptor *
+mv_xor_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
+		   unsigned int src_cnt, const unsigned char *scf,
+		   size_t len, unsigned long flags)
+{
+	struct mv_xor_chan *mv_chan = to_mv_xor_chan(chan);
+	struct mv_xor_desc_slot *sw_desc;
+	int src_i = 0;
+	int i = 0;
+
+	if (unlikely(len < MV_XOR_MIN_BYTE_COUNT))
+		return NULL;
+
+	BUG_ON(len > MV_XOR_MAX_BYTE_COUNT);
+
+	dev_dbg(mv_chan_to_devp(mv_chan),
+		"%s src_cnt: %d len: %u flags: %ld\n",
+		__func__, src_cnt, len, flags);
+
+	/*
+	 * since the coefs on Marvell engine are hardcoded, do not
+	 * support mult and sum product requests
+	 */
+	if ((flags & DMA_PREP_PQ_MULT) || (flags & DMA_PREP_PQ_SUM_PRODUCT))
+		return NULL;
+
+	sw_desc = mv_chan_alloc_slot(mv_chan);
+	if (sw_desc) {
+		sw_desc->type = DMA_PQ;
+		sw_desc->async_tx.flags = flags;
+		mv_desc_init(sw_desc, len, flags);
+		if (mv_chan->op_in_desc == XOR_MODE_IN_DESC)
+			mv_desc_set_mode(sw_desc);
+		if (!(flags & DMA_PREP_PQ_DISABLE_P))
+			mv_desc_set_dest_addr(sw_desc, dst[0]);
+		if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+			mv_desc_set_q_dest_addr(sw_desc, dst[1]);
+		while (src_cnt) {
+			/*
+			 * probably we can do better coding below,
+			 * hash table maybe?
+			 */
+			if (scf[src_i] == mv_xor_raid6_coefs[i]) {
+				/*
+				 * coefs are hardcoded, assign the src
+				 * to the right place
+				 */
+				mv_desc_set_src_addr(sw_desc, i, src[src_i]);
+				src_i++;
+				i++;
+				src_cnt--;
+			} else {
+				i++;
+			}
+		}
+	}
+
+	dev_dbg(mv_chan_to_devp(mv_chan),
+		"%s sw_desc %p async_tx %p\n",
+		__func__, sw_desc, &sw_desc->async_tx);
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
 static void mv_xor_free_chan_resources(struct dma_chan *chan)
 {
 	struct mv_xor_chan *mv_chan = to_mv_xor_chan(chan);
@@ -1026,6 +1118,10 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 		dma_dev->max_xor = 8;
 		dma_dev->device_prep_dma_xor = mv_xor_prep_dma_xor;
 	}
+	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
+		dma_set_maxpq(dma_dev, 8, 0);
+		dma_dev->device_prep_dma_pq = mv_xor_prep_dma_pq;
+	}
 
 	mv_chan->mmr_base = xordev->xor_base;
 	mv_chan->mmr_high_base = xordev->xor_high_base;
@@ -1071,11 +1167,13 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 			goto err_free_irq;
 	}
 
-	dev_info(&pdev->dev, "Marvell XOR (%s): ( %s%s%s)\n",
+	dev_info(&pdev->dev, "Marvell XOR (%s): ( %s%s%s%s)\n",
 		 mv_chan->op_in_desc ? "Descriptor Mode" : "Registers Mode",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
-		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
+		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "",
+		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "pq " : "");
+
 
 	dma_async_device_register(dma_dev);
 	return mv_chan;
@@ -1199,6 +1297,8 @@ static int mv_xor_probe(struct platform_device *pdev)
 				dma_cap_set(DMA_XOR, cap_mask);
 			if (of_property_read_bool(np, "dmacap,interrupt"))
 				dma_cap_set(DMA_INTERRUPT, cap_mask);
+			if (of_property_read_bool(np, "dmacap,pq"))
+				dma_cap_set(DMA_PQ, cap_mask);
 
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
@@ -1310,6 +1410,6 @@ static void __exit mv_xor_exit(void)
 module_exit(mv_xor_exit);
 #endif
 
-MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>");
+MODULE_AUTHOR("Lior Amsalem <alior@marvell.com>, Saeed Bishara <saeed@marvell.com>");
 MODULE_DESCRIPTION("DMA engine driver for Marvell's XOR engine");
 MODULE_LICENSE("GPL");
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index b7455b42137b..b72e7357c5c8 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -37,6 +37,7 @@
 #define XOR_DESC_OPERATION_XOR          (0 << 24)
 #define XOR_DESC_OPERATION_CRC32C       (1 << 24)
 #define XOR_DESC_OPERATION_MEMCPY       (2 << 24)
+#define XOR_DESC_OPERATION_PQ           (5 << 24)
 
 #define XOR_DESC_DMA_OWNED		BIT(31)
 #define XOR_DESC_EOD_INT_EN		BIT(31)
@@ -164,7 +165,7 @@ struct mv_xor_desc {
 	u32 byte_count;		/* size of src/dst blocks in bytes */
 	u32 phy_dest_addr;	/* destination block address */
 	u32 phy_src_addr[8];	/* source block addresses */
-	u32 reserved0;
+	u32 phy_q_dest_addr;
 	u32 reserved1;
 };
 #define mv_phy_src_idx(src_idx) (src_idx)
@@ -178,7 +179,7 @@ struct mv_xor_desc {
 	u32 byte_count;		/* size of src/dst blocks in bytes */
 	u32 phy_src_addr[8];	/* source block addresses */
 	u32 reserved1;
-	u32 reserved0;
+	u32 phy_q_dest_addr;
 };
 #define mv_phy_src_idx(src_idx) (src_idx ^ 1)
 #endif
-- 
2.4.0
