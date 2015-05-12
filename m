From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in descriptor mode
Date: Tue, 12 May 2015 17:37:37 +0200
Message-ID: <1431445063-20226-3-git-send-email-maxime.ripard@free-electrons.com>
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

The Marvell Armada 38x SoC introduce new features to the XOR engine,
especially the fact that the engine mode (MEMCPY/XOR/PQ/etc) can be part of
the descriptor and not set through the controller registers.

This new feature allows mixing of different commands (even PQ) on the same
channel/chain without the need to stop the engine to reconfigure the engine
mode.

Refactor the driver to be able to use that new feature on the Armada 38x,
while keeping the old behaviour on the older SoCs.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/dma/mv-xor.txt |  2 +-
 drivers/dma/mv_xor.c                             | 83 ++++++++++++++++++++----
 drivers/dma/mv_xor.h                             |  7 ++
 3 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/mv-xor.txt b/Documentation/devicetree/bindings/dma/mv-xor.txt
index 7c6cb7fcecd2..5b10f9ee0937 100644
--- a/Documentation/devicetree/bindings/dma/mv-xor.txt
+++ b/Documentation/devicetree/bindings/dma/mv-xor.txt
@@ -1,7 +1,7 @@
 * Marvell XOR engines
 
 Required properties:
-- compatible: Should be "marvell,orion-xor"
+- compatible: Should be "marvell,orion-xor" or "marvell,a38x-xor"
 - reg: Should contain registers location and length (two sets)
     the first set is the low registers, the second set the high
     registers for the XOR engine.
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 1affafa888c5..bcc9aec0ce02 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/memory.h>
 #include <linux/clk.h>
@@ -30,6 +31,11 @@
 #include "dmaengine.h"
 #include "mv_xor.h"
 
+enum mv_xor_mode {
+	XOR_MODE_IN_REG,
+	XOR_MODE_IN_DESC,
+};
+
 static void mv_xor_issue_pending(struct dma_chan *chan);
 
 #define to_mv_xor_chan(chan)		\
@@ -56,6 +62,24 @@ static void mv_desc_init(struct mv_xor_desc_slot *desc,
 	hw_desc->byte_count = byte_count;
 }
 
+static void mv_desc_set_mode(struct mv_xor_desc_slot *desc)
+{
+	struct mv_xor_desc *hw_desc = desc->hw_desc;
+
+	switch (desc->type) {
+	case DMA_XOR:
+	case DMA_INTERRUPT:
+		hw_desc->desc_command |= XOR_DESC_OPERATION_XOR;
+		break;
+	case DMA_MEMCPY:
+		hw_desc->desc_command |= XOR_DESC_OPERATION_MEMCPY;
+		break;
+	default:
+		BUG();
+		return;
+	}
+}
+
 static void mv_desc_set_next_desc(struct mv_xor_desc_slot *desc,
 				  u32 next_desc_addr)
 {
@@ -154,6 +178,25 @@ static void mv_chan_set_mode(struct mv_xor_chan *chan,
 	chan->current_type = type;
 }
 
+static void mv_chan_set_mode_to_desc(struct mv_xor_chan *chan)
+{
+	u32 op_mode;
+	u32 config = readl_relaxed(XOR_CONFIG(chan));
+
+	op_mode = XOR_OPERATION_MODE_IN_DESC;
+
+	config &= ~0x7;
+	config |= op_mode;
+
+#if defined(__BIG_ENDIAN)
+	config |= XOR_DESCRIPTOR_SWAP;
+#else
+	config &= ~XOR_DESCRIPTOR_SWAP;
+#endif
+
+	writel_relaxed(config, XOR_CONFIG(chan));
+}
+
 static void mv_chan_activate(struct mv_xor_chan *chan)
 {
 	dev_dbg(mv_chan_to_devp(chan), " activate chan.\n");
@@ -510,6 +553,8 @@ mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		sw_desc->type = DMA_XOR;
 		sw_desc->async_tx.flags = flags;
 		mv_desc_init(sw_desc, dest, len, flags);
+		if (mv_chan->op_in_desc == XOR_MODE_IN_DESC)
+			mv_desc_set_mode(sw_desc);
 		while (src_cnt--)
 			mv_desc_set_src_addr(sw_desc, src_cnt, src[src_cnt]);
 	}
@@ -952,7 +997,7 @@ static int mv_xor_channel_remove(struct mv_xor_chan *mv_chan)
 static struct mv_xor_chan *
 mv_xor_channel_add(struct mv_xor_device *xordev,
 		   struct platform_device *pdev,
-		   int idx, dma_cap_mask_t cap_mask, int irq)
+		   int idx, dma_cap_mask_t cap_mask, int irq, int op_in_desc)
 {
 	int ret = 0;
 	struct mv_xor_chan *mv_chan;
@@ -964,6 +1009,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 	mv_chan->idx = idx;
 	mv_chan->irq = irq;
+	mv_chan->op_in_desc = op_in_desc;
 
 	dma_dev = &mv_chan->dmadev;
 
@@ -1024,7 +1070,10 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 	mv_chan_unmask_interrupts(mv_chan);
 
-	mv_chan_set_mode(mv_chan, DMA_XOR);
+	if (mv_chan->op_in_desc == XOR_MODE_IN_DESC)
+		mv_chan_set_mode_to_desc(mv_chan);
+	else
+		mv_chan_set_mode(mv_chan, DMA_XOR);
 
 	spin_lock_init(&mv_chan->lock);
 	INIT_LIST_HEAD(&mv_chan->chain);
@@ -1049,7 +1098,8 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 			goto err_free_irq;
 	}
 
-	dev_info(&pdev->dev, "Marvell XOR: ( %s%s%s)\n",
+	dev_info(&pdev->dev, "Marvell XOR (%s): ( %s%s%s)\n",
+		 mv_chan->op_in_desc ? "Descriptor Mode" : "Registers Mode",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 		 dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 		 dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
@@ -1098,6 +1148,15 @@ mv_xor_conf_mbus_windows(struct mv_xor_device *xordev,
 	writel(0, base + WINDOW_OVERRIDE_CTRL(1));
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id mv_xor_dt_ids[] = {
+	{ .compatible = "marvell,orion-xor", .data = (void *)XOR_MODE_IN_REG },
+	{ .compatible = "marvell,a38x-xor", .data = (void *)XOR_MODE_IN_DESC },
+	{},
+};
+MODULE_DEVICE_TABLE(of, mv_xor_dt_ids);
+#endif
+
 static int mv_xor_probe(struct platform_device *pdev)
 {
 	const struct mbus_dram_target_info *dram;
@@ -1105,6 +1164,7 @@ static int mv_xor_probe(struct platform_device *pdev)
 	struct mv_xor_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource *res;
 	int i, ret;
+	int op_in_desc;
 
 	dev_notice(&pdev->dev, "Marvell shared XOR driver\n");
 
@@ -1149,11 +1209,15 @@ static int mv_xor_probe(struct platform_device *pdev)
 	if (pdev->dev.of_node) {
 		struct device_node *np;
 		int i = 0;
+		const struct of_device_id *of_id =
+			of_match_device(of_match_ptr(mv_xor_dt_ids),
+					&pdev->dev);
 
 		for_each_child_of_node(pdev->dev.of_node, np) {
 			struct mv_xor_chan *chan;
 			dma_cap_mask_t cap_mask;
 			int irq;
+			op_in_desc = (int)of_id->data;
 
 			dma_cap_zero(cap_mask);
 			if (of_property_read_bool(np, "dmacap,memcpy"))
@@ -1170,7 +1234,7 @@ static int mv_xor_probe(struct platform_device *pdev)
 			}
 
 			chan = mv_xor_channel_add(xordev, pdev, i,
-						  cap_mask, irq);
+						  cap_mask, irq, op_in_desc);
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
@@ -1199,7 +1263,8 @@ static int mv_xor_probe(struct platform_device *pdev)
 			}
 
 			chan = mv_xor_channel_add(xordev, pdev, i,
-						  cd->cap_mask, irq);
+						  cd->cap_mask, irq,
+						  XOR_MODE_IN_REG);
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				goto err_channel_add;
@@ -1245,14 +1310,6 @@ static int mv_xor_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id mv_xor_dt_ids[] = {
-       { .compatible = "marvell,orion-xor", },
-       {},
-};
-MODULE_DEVICE_TABLE(of, mv_xor_dt_ids);
-#endif
-
 static struct platform_driver mv_xor_driver = {
 	.probe		= mv_xor_probe,
 	.remove		= mv_xor_remove,
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 91958dba39a2..89a8c85539a1 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -30,8 +30,13 @@
 /* Values for the XOR_CONFIG register */
 #define XOR_OPERATION_MODE_XOR		0
 #define XOR_OPERATION_MODE_MEMCPY	2
+#define XOR_OPERATION_MODE_IN_DESC      7
 #define XOR_DESCRIPTOR_SWAP		BIT(14)
 
+#define XOR_DESC_OPERATION_XOR          (0 << 24)
+#define XOR_DESC_OPERATION_CRC32C       (1 << 24)
+#define XOR_DESC_OPERATION_MEMCPY       (2 << 24)
+
 #define XOR_DESC_DMA_OWNED		BIT(31)
 #define XOR_DESC_EOD_INT_EN		BIT(31)
 
@@ -95,6 +100,7 @@ struct mv_xor_device {
  * @all_slots: complete domain of slots usable by the channel
  * @slots_allocated: records the actual size of the descriptor slot pool
  * @irq_tasklet: bottom half where mv_xor_slot_cleanup runs
+ * @op_in_desc: new mode of driver, each op is writen to descriptor.
  */
 struct mv_xor_chan {
 	int			pending;
@@ -115,6 +121,7 @@ struct mv_xor_chan {
 	struct list_head	all_slots;
 	int			slots_allocated;
 	struct tasklet_struct	irq_tasklet;
+	int                     op_in_desc;
 	char			dummy_src[MV_XOR_MIN_BYTE_COUNT];
 	char			dummy_dst[MV_XOR_MIN_BYTE_COUNT];
 	dma_addr_t		dummy_src_addr, dummy_dst_addr;
-- 
2.4.0
