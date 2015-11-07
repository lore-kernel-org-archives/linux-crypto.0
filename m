From: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v2 2/3] dmaengine: xgene-dma: Add support for CRC32C computations via DMA engine
Date: Sat,  7 Nov 2015 22:07:05 +0530
Message-ID: <1446914226-23402-3-git-send-email-rsahu@apm.com>
References: <1446914226-23402-1-git-send-email-rsahu@apm.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kgondkar-qTEPVZfXA3Y@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org,
	Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
To: vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446914226-23402-1-git-send-email-rsahu-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch implements CRC32C support to APM X-Gene SoC DMA engine driver.
Basically we have DMA engine in SoC capable of doing CRC32C computations.

Signed-off-by: Rameshwar Prasad Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/dma/xgene-dma.c |  314 ++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 299 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/xgene-dma.c b/drivers/dma/xgene-dma.c
index 9dfa2b0..d95dc72 100644
--- a/drivers/dma/xgene-dma.c
+++ b/drivers/dma/xgene-dma.c
@@ -22,6 +22,7 @@
  */

 #include <linux/acpi.h>
+#include <linux/bitrev.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -39,6 +40,7 @@
 #define XGENE_DMA_RING_ENABLE			BIT(31)
 #define XGENE_DMA_RING_ID			0x08
 #define XGENE_DMA_RING_ID_SETUP(v)		((v) | BIT(31))
+#define XGENE_DMA_RING_IS_BUFPOOL		BIT(20)
 #define XGENE_DMA_RING_ID_BUF			0x0C
 #define XGENE_DMA_RING_ID_BUF_SETUP(v)		(((v) << 9) | BIT(21))
 #define XGENE_DMA_RING_THRESLD0_SET1		0x30
@@ -69,6 +71,8 @@
 	(((u32 *)(m))[2] |= (((v) >> 8) << 5))
 #define XGENE_DMA_RING_ADDRH_SET(m, v)		\
 	(((u32 *)(m))[3] |= ((v) >> 35))
+#define XGENE_DMA_RING_BUFMODE_SET(m)		\
+	(((u32 *)(m))[3] |= ((0x3) << 20))
 #define XGENE_DMA_RING_ACCEPTLERR_SET(m)	\
 	(((u32 *)(m))[3] |= BIT(19))
 #define XGENE_DMA_RING_SIZE_SET(m, v)		\
@@ -106,6 +110,7 @@
 #define XGENE_DMA_RING_INT2_MASK		0x90B0
 #define XGENE_DMA_RING_INT3_MASK		0x90B8
 #define XGENE_DMA_RING_INT4_MASK		0x90C0
+#define XGENE_DMA_CFG_RING_FQ_ASSOC		0x90DC
 #define XGENE_DMA_CFG_RING_WQ_ASSOC		0x90E0
 #define XGENE_DMA_ASSOC_RING_MNGR1		0xFFFFFFFF
 #define XGENE_DMA_MEM_RAM_SHUTDOWN		0xD070
@@ -127,6 +132,10 @@
 #define XGENE_DMA_DESC_LERR_POS			60
 #define XGENE_DMA_DESC_BUFLEN_POS		48
 #define XGENE_DMA_DESC_HOENQ_NUM_POS		48
+#define XGENE_DMA_DESC_BD_BIT			BIT(0)
+#define XGENE_DMA_DESC_SD_BIT			BIT(1)
+#define XGENE_DMA_DESC_CRCSEED_POS		8
+#define XGENE_DMA_DESC_FPQ_NUM_POS		32
 #define XGENE_DMA_DESC_ELERR_RD(m)		\
 	(((m) >> XGENE_DMA_DESC_ELERR_POS) & 0x3)
 #define XGENE_DMA_DESC_LERR_RD(m)		\
@@ -140,20 +149,25 @@
 /* X-Gene DMA configurable parameters defines */
 #define XGENE_DMA_RING_NUM		512
 #define XGENE_DMA_BUFNUM		0x0
+#define XGENE_DMA_BUFPOOL_BUFNUM	0x20
 #define XGENE_DMA_CPU_BUFNUM		0x18
 #define XGENE_DMA_RING_OWNER_DMA	0x03
 #define XGENE_DMA_RING_OWNER_CPU	0x0F
 #define XGENE_DMA_RING_TYPE_REGULAR	0x01
+#define XGENE_DMA_RING_TYPE_BUFPOOL	0x02
 #define XGENE_DMA_RING_WQ_DESC_SIZE	32	/* 32 Bytes */
+#define XGENE_DMA_BUFPOOL_DESC_SIZE	16	/* 16 Bytes */
 #define XGENE_DMA_RING_NUM_CONFIG	5
 #define XGENE_DMA_MAX_CHANNEL		4
 #define XGENE_DMA_XOR_CHANNEL		0
 #define XGENE_DMA_PQ_CHANNEL		1
+#define XGENE_DMA_FLYBY_CHANNEL		2
 #define XGENE_DMA_MAX_BYTE_CNT		0x4000	/* 16 KB */
 #define XGENE_DMA_MAX_64B_DESC_BYTE_CNT	0x14000	/* 80 KB */
 #define XGENE_DMA_MAX_XOR_SRC		5
 #define XGENE_DMA_16K_BUFFER_LEN_CODE	0x0
 #define XGENE_DMA_INVALID_LEN_CODE	0x7800000000000000ULL
+#define XGENE_DMA_MAX_FLYBY_BYTE_CNT	0x7FFF	/* (32 KB - 1) */

 /* X-Gene DMA descriptor error codes */
 #define ERR_DESC_AXI			0x01
@@ -187,9 +201,14 @@
 #define FLYBY_3SRC_XOR			0x90
 #define FLYBY_4SRC_XOR			0xA0
 #define FLYBY_5SRC_XOR			0xB0
+#define FLYBY_CRC16			0x10
+#define FLYBY_CRC32C			0x20
+#define FLYBY_CRC32			0x30
+#define FLYBY_CHECKSUM			0x40

 /* X-Gene DMA SW descriptor flags */
 #define XGENE_DMA_FLAG_64B_DESC		BIT(0)
+#define XGENE_DMA_FLAG_FLYBY_ACTIVE	BIT(1)

 /* Define to dump X-Gene DMA descriptor */
 #define XGENE_DMA_DESC_DUMP(desc, m)	\
@@ -206,6 +225,11 @@
 #define chan_err(chan, fmt, arg...)	\
 	dev_err(chan->dev, "%s: " fmt, chan->name, ##arg)

+struct xgene_dma_desc16 {
+	__le64 m0;
+	__le64 m1;
+};
+
 struct xgene_dma_desc_hw {
 	__le64 m0;
 	__le64 m1;
@@ -232,6 +256,7 @@ struct xgene_dma_ring {
 	u16 slots;
 	u16 dst_ring_num;
 	u32 size;
+	bool is_bufpool;
 	void __iomem *cmd;
 	void __iomem *cmd_base;
 	dma_addr_t desc_paddr;
@@ -239,6 +264,7 @@ struct xgene_dma_ring {
 	enum xgene_dma_ring_cfgsize cfgsize;
 	union {
 		void *desc_vaddr;
+		struct xgene_dma_desc16 *desc16;
 		struct xgene_dma_desc_hw *desc_hw;
 	};
 };
@@ -247,6 +273,7 @@ struct xgene_dma_desc_sw {
 	struct xgene_dma_desc_hw desc1;
 	struct xgene_dma_desc_hw desc2;
 	u32 flags;
+	u8 *flyby_result;
 	struct list_head node;
 	struct list_head tx_list;
 	struct dma_async_tx_descriptor tx;
@@ -276,6 +303,8 @@ struct xgene_dma_desc_sw {
  *	descriptors for further executions
  * @rx_ring: receive ring descriptor that we use to get completed DMA
  *	descriptors during cleanup time
+ * @bufpool: Queue which maintains list of allocated memory for flyby operations
+ *	needed by DMA engine
  */
 struct xgene_dma_chan {
 	struct dma_chan dma_chan;
@@ -294,6 +323,7 @@ struct xgene_dma_chan {
 	struct tasklet_struct tasklet;
 	struct xgene_dma_ring tx_ring;
 	struct xgene_dma_ring rx_ring;
+	struct xgene_dma_ring bufpool;
 };

 /**
@@ -509,6 +539,102 @@ static void xgene_dma_prep_xor_desc(struct xgene_dma_chan *chan,
 	desc_sw->flags |= XGENE_DMA_FLAG_64B_DESC;
 }

+static u32 xgene_dma_set_flyby_src(__le64 *ext8, struct scatterlist *sg,
+				   dma_addr_t *paddr, u32 *nbytes, u32 offset)
+{
+	u32 len;
+
+	/* Fetch physical address from sg */
+	if (*paddr == 0)
+		*paddr = sg_dma_address(sg);
+
+	len = sg_dma_len(sg) - offset;
+
+	*ext8 |= cpu_to_le64(*paddr);
+	*ext8 |= cpu_to_le64(xgene_dma_encode_len(len));
+
+	if (len <= XGENE_DMA_MAX_BYTE_CNT) {
+		*nbytes -= len;
+		*paddr = 0;
+		return len;
+	}
+
+	*nbytes -= XGENE_DMA_MAX_BYTE_CNT;
+	*paddr += XGENE_DMA_MAX_BYTE_CNT;
+
+	return XGENE_DMA_MAX_BYTE_CNT;
+}
+
+static int xgene_dma_prep_flyby_desc(struct xgene_dma_chan *chan,
+				     struct xgene_dma_desc_sw *desc_sw,
+				     struct scatterlist *sg, u32 nbytes,
+				     u32 seed, u8 opcode)
+{
+	struct xgene_dma_desc_hw *desc1, *desc2;
+	dma_addr_t paddr = 0;
+	u32 len = nbytes;
+	u32 offset = 0;
+	int i;
+
+	/* Get 1st descriptor */
+	desc1 = &desc_sw->desc1;
+	xgene_dma_init_desc(desc1, chan->tx_ring.dst_ring_num);
+
+	/* Set 1st source address */
+	offset += xgene_dma_set_flyby_src(&desc1->m1, sg, &paddr,
+					  &nbytes, offset);
+
+	if (!nbytes) {
+		desc2 = NULL;
+		goto skip_additional_src;
+	}
+
+	/*
+	 * Still we have request length remaining,
+	 * So we need to use prepare 64B descriptor
+	 */
+	desc2 = &desc_sw->desc2;
+	desc1->m0 |= cpu_to_le64(XGENE_DMA_DESC_NV_BIT);
+
+	/* Set 2nd to 5th source address */
+	for (i = 0; i < 4 && nbytes; i++) {
+		/* Fetch next sg element */
+		if (!paddr) {
+			sg = sg_next(sg);
+			if (!sg)
+				break;
+			offset = 0;
+		}
+		offset += xgene_dma_set_flyby_src(
+				xgene_dma_lookup_ext8(desc2, i),
+				sg, &paddr, &nbytes, offset);
+	}
+
+	/* Invalidate unused source address field */
+	for (; i < 4; i++)
+		xgene_dma_invalidate_buffer(xgene_dma_lookup_ext8(desc2, i));
+
+	/* Check whether requested buffer processed */
+	if (nbytes) {
+		chan_err(chan, "Src count crossed maximum limit\n");
+		return -EINVAL;
+	}
+
+	/* Update flag that we have prepared 64B descriptor */
+	desc_sw->flags |= XGENE_DMA_FLAG_64B_DESC;
+
+skip_additional_src:
+	/* Set descriptor parameters for flyby operation */
+	desc1->m2 |= cpu_to_le64(XGENE_DMA_DESC_BD_BIT);
+	desc1->m2 |= cpu_to_le64(XGENE_DMA_DESC_SD_BIT);
+	desc1->m2 |= cpu_to_le64(opcode);
+	desc1->m2 |= cpu_to_le64((u64)bitrev32(seed) <<
+				 XGENE_DMA_DESC_CRCSEED_POS);
+	desc1->m3 |= cpu_to_le64(len);
+
+	return 0;
+}
+
 static dma_cookie_t xgene_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct xgene_dma_desc_sw *desc;
@@ -745,8 +871,9 @@ static void xgene_dma_cleanup_descriptors(struct xgene_dma_chan *chan)
 {
 	struct xgene_dma_ring *ring = &chan->rx_ring;
 	struct xgene_dma_desc_sw *desc_sw, *_desc_sw;
-	struct xgene_dma_desc_hw *desc_hw;
+	struct xgene_dma_desc_hw *desc_hw1, *desc_hw2;
 	struct list_head ld_completed;
+	u32 command;
 	u8 status;

 	INIT_LIST_HEAD(&ld_completed);
@@ -759,22 +886,35 @@ static void xgene_dma_cleanup_descriptors(struct xgene_dma_chan *chan)
 	/* Move all completed descriptors to ld completed queue, in order */
 	list_for_each_entry_safe(desc_sw, _desc_sw, &chan->ld_running, node) {
 		/* Get subsequent hw descriptor from DMA rx ring */
-		desc_hw = &ring->desc_hw[ring->head];
+		desc_hw1 = &ring->desc_hw[ring->head];

 		/* Check if this descriptor has been completed */
-		if (unlikely(le64_to_cpu(desc_hw->m0) ==
+		if (unlikely(le64_to_cpu(desc_hw1->m0) ==
 			     XGENE_DMA_DESC_EMPTY_SIGNATURE))
 			break;

 		if (++ring->head == ring->slots)
 			ring->head = 0;

+		if (le64_to_cpu(desc_hw1->m0) & XGENE_DMA_DESC_NV_BIT) {
+			/* 64B Rx descriptor */
+			desc_hw2 = &ring->desc_hw[ring->head];
+
+			if (++ring->head == ring->slots)
+				ring->head = 0;
+
+			command = 2;
+		} else {
+			desc_hw2 = NULL;
+			command = 1;
+		}
+
 		/* Check if we have any error with DMA transactions */
 		status = XGENE_DMA_DESC_STATUS(
 				XGENE_DMA_DESC_ELERR_RD(le64_to_cpu(
-							desc_hw->m0)),
+							desc_hw1->m0)),
 				XGENE_DMA_DESC_LERR_RD(le64_to_cpu(
-						       desc_hw->m0)));
+						       desc_hw1->m0)));
 		if (status) {
 			/* Print the DMA error type */
 			chan_err(chan, "%s\n", xgene_dma_desc_err[status]);
@@ -789,15 +929,23 @@ static void xgene_dma_cleanup_descriptors(struct xgene_dma_chan *chan)
 				XGENE_DMA_DESC_DUMP(&desc_sw->desc2,
 						    "X-Gene DMA TX DESC2: ");

-			XGENE_DMA_DESC_DUMP(desc_hw,
+			XGENE_DMA_DESC_DUMP(desc_hw1,
 					    "X-Gene DMA RX ERR DESC: ");
 		}

 		/* Notify the hw about this completed descriptor */
-		iowrite32(-1, ring->cmd);
+		iowrite32(-command, ring->cmd);

 		/* Mark this hw descriptor as processed */
-		desc_hw->m0 = cpu_to_le64(XGENE_DMA_DESC_EMPTY_SIGNATURE);
+		desc_hw1->m0 = cpu_to_le64(XGENE_DMA_DESC_EMPTY_SIGNATURE);
+		if (desc_hw2)
+			desc_hw2->m0 = cpu_to_le64(
+					XGENE_DMA_DESC_EMPTY_SIGNATURE);
+
+		if (desc_sw->flags & XGENE_DMA_FLAG_FLYBY_ACTIVE) {
+			iowrite32(command, chan->bufpool.cmd);
+			*(__le32 *)desc_sw->flyby_result = (__le32)desc_hw1->m3;
+		}

 		/*
 		 * Decrement the pending transaction count
@@ -1125,6 +1273,55 @@ fail:
 	return NULL;
 }

+struct dma_async_tx_descriptor *
+xgene_dma_prep_flyby(struct xgene_dma_chan *chan, struct scatterlist *src_sg,
+		     size_t len, u32 seed, u8 *result, unsigned long flags,
+		     u8 opcode)
+{
+	struct xgene_dma_desc_sw *desc;
+	int ret;
+
+	if (len > XGENE_DMA_MAX_FLYBY_BYTE_CNT) {
+		chan_err(chan, "Source length is too long 0x%zX\n", len);
+		return NULL;
+	}
+
+	/* Allocate the link descriptor from DMA pool */
+	desc = xgene_dma_alloc_descriptor(chan);
+	if (!desc)
+		return NULL;
+
+	/* Prepare DMA flyby descriptor */
+	ret = xgene_dma_prep_flyby_desc(chan, desc, src_sg, len, seed, opcode);
+	if (ret) {
+		xgene_dma_clean_descriptor(chan, desc);
+		return NULL;
+	}
+
+	desc->flags |= XGENE_DMA_FLAG_FLYBY_ACTIVE;
+	desc->tx.flags = flags;
+	desc->flyby_result = result;
+
+	list_add_tail(&desc->node, &desc->tx_list);
+
+	return &desc->tx;
+}
+
+struct dma_async_tx_descriptor *
+xgene_dma_prep_crc32c(struct dma_chan *dchan, struct scatterlist *src_sg,
+		      size_t len, u32 seed, u8 *result, unsigned long flags)
+{
+	struct xgene_dma_chan *chan;
+
+	if (unlikely(!dchan))
+		return NULL;
+
+	chan = to_dma_chan(dchan);
+
+	return xgene_dma_prep_flyby(chan, src_sg, len, seed,
+				    result, flags, FLYBY_CRC32C);
+}
+
 static void xgene_dma_issue_pending(struct dma_chan *dchan)
 {
 	struct xgene_dma_chan *chan = to_dma_chan(dchan);
@@ -1215,15 +1412,22 @@ static void xgene_dma_setup_ring(struct xgene_dma_ring *ring)
 {
 	void *ring_cfg = ring->state;
 	u64 addr = ring->desc_paddr;
-	u32 i, val;
+	u32 ring_id_buf, i, val;

-	ring->slots = ring->size / XGENE_DMA_RING_WQ_DESC_SIZE;
+	ring->slots = ring->size / (ring->is_bufpool ?
+			XGENE_DMA_BUFPOOL_DESC_SIZE :
+			XGENE_DMA_RING_WQ_DESC_SIZE);

 	/* Clear DMA ring state */
 	xgene_dma_clr_ring_state(ring);

 	/* Set DMA ring type */
-	XGENE_DMA_RING_TYPE_SET(ring_cfg, XGENE_DMA_RING_TYPE_REGULAR);
+	XGENE_DMA_RING_TYPE_SET(ring_cfg, ring->is_bufpool ?
+				XGENE_DMA_RING_TYPE_BUFPOOL :
+				XGENE_DMA_RING_TYPE_REGULAR);
+
+	if (ring->is_bufpool)
+		XGENE_DMA_RING_BUFMODE_SET(ring_cfg);

 	if (ring->owner == XGENE_DMA_RING_OWNER_DMA) {
 		/* Set recombination buffer and timeout */
@@ -1248,8 +1452,12 @@ static void xgene_dma_setup_ring(struct xgene_dma_ring *ring)
 		  ring->pdma->csr_ring + XGENE_DMA_RING_ID);

 	/* Set DMA ring buffer */
-	iowrite32(XGENE_DMA_RING_ID_BUF_SETUP(ring->num),
-		  ring->pdma->csr_ring + XGENE_DMA_RING_ID_BUF);
+	ring_id_buf = XGENE_DMA_RING_ID_BUF_SETUP(ring->num);
+
+	if (ring->is_bufpool)
+		ring_id_buf |= XGENE_DMA_RING_IS_BUFPOOL;
+
+	iowrite32(ring_id_buf, ring->pdma->csr_ring + XGENE_DMA_RING_ID_BUF);

 	if (ring->owner != XGENE_DMA_RING_OWNER_CPU)
 		return;
@@ -1344,6 +1552,9 @@ static void xgene_dma_delete_chan_rings(struct xgene_dma_chan *chan)
 {
 	xgene_dma_delete_ring_one(&chan->rx_ring);
 	xgene_dma_delete_ring_one(&chan->tx_ring);
+
+	if (chan->id == XGENE_DMA_FLYBY_CHANNEL)
+		xgene_dma_delete_ring_one(&chan->bufpool);
 }

 static int xgene_dma_create_ring_one(struct xgene_dma_chan *chan,
@@ -1378,6 +1589,60 @@ static int xgene_dma_create_ring_one(struct xgene_dma_chan *chan,
 	return 0;
 }

+static int xgene_dma_init_bufpool(struct xgene_dma_chan *chan)
+{
+	struct xgene_dma_ring *bufpool = &chan->bufpool;
+	struct xgene_dma_desc16 *desc16;
+	dma_addr_t buf_addr;
+	void *buf;
+	int ret, i;
+
+	/* Create DMA buffer pool */
+	bufpool->owner = XGENE_DMA_RING_OWNER_DMA;
+	bufpool->is_bufpool = true;
+	bufpool->buf_num = XGENE_DMA_BUFPOOL_BUFNUM;
+
+	ret = xgene_dma_create_ring_one(chan, bufpool,
+					XGENE_DMA_RING_CFG_SIZE_64KB);
+	if (ret)
+		return ret;
+
+	bufpool->dst_ring_num = XGENE_DMA_RING_DST_ID(bufpool->num);
+
+	dev_dbg(chan->dev,
+		"Bufpool ring id 0x%X num %d desc 0x%p\n",
+		bufpool->id, bufpool->num, bufpool->desc_vaddr);
+
+	for (i = 0; i < bufpool->slots; i++) {
+		desc16 = &bufpool->desc16[i];
+		memset(desc16, 0, sizeof(struct xgene_dma_desc16));
+		buf = devm_kzalloc(chan->dev,
+				   XGENE_DMA_MAX_BYTE_CNT, GFP_KERNEL);
+		if (!buf) {
+			xgene_dma_delete_ring_one(bufpool);
+			return -ENOMEM;
+		}
+
+		buf_addr = dma_map_single(chan->dev, buf,
+					  XGENE_DMA_MAX_BYTE_CNT,
+					  DMA_TO_DEVICE);
+
+		desc16->m0 |= cpu_to_le64((u64)bufpool->dst_ring_num <<
+					  XGENE_DMA_DESC_FPQ_NUM_POS);
+		desc16->m0 |= cpu_to_le64(XGENE_DMA_DESC_IN_BIT);
+		desc16->m0 |= cpu_to_le64((u64)XGENE_DMA_RING_OWNER_DMA <<
+					  XGENE_DMA_DESC_RTYPE_POS);
+		desc16->m1 |= cpu_to_le64(XGENE_DMA_DESC_C_BIT);
+		desc16->m1 |= cpu_to_le64(buf_addr);
+		desc16->m1 |= cpu_to_le64(xgene_dma_encode_len(
+					  XGENE_DMA_MAX_BYTE_CNT));
+	}
+
+	iowrite32(bufpool->slots, bufpool->cmd);
+
+	return 0;
+}
+
 static int xgene_dma_create_chan_rings(struct xgene_dma_chan *chan)
 {
 	struct xgene_dma_ring *rx_ring = &chan->rx_ring;
@@ -1386,6 +1651,7 @@ static int xgene_dma_create_chan_rings(struct xgene_dma_chan *chan)

 	/* Create DMA Rx ring descriptor */
 	rx_ring->owner = XGENE_DMA_RING_OWNER_CPU;
+	rx_ring->is_bufpool = false;
 	rx_ring->buf_num = XGENE_DMA_CPU_BUFNUM + chan->id;

 	ret = xgene_dma_create_ring_one(chan, rx_ring,
@@ -1398,6 +1664,7 @@ static int xgene_dma_create_chan_rings(struct xgene_dma_chan *chan)

 	/* Create DMA Tx ring descriptor */
 	tx_ring->owner = XGENE_DMA_RING_OWNER_DMA;
+	tx_ring->is_bufpool = false;
 	tx_ring->buf_num = XGENE_DMA_BUFNUM + chan->id;

 	ret = xgene_dma_create_ring_one(chan, tx_ring,
@@ -1416,6 +1683,14 @@ static int xgene_dma_create_chan_rings(struct xgene_dma_chan *chan)
 	/* Set the max outstanding request possible to this channel */
 	chan->max_outstanding = tx_ring->slots;

+	if (chan->id == XGENE_DMA_FLYBY_CHANNEL) {
+		ret = xgene_dma_init_bufpool(chan);
+		if (ret) {
+			xgene_dma_delete_ring_one(rx_ring);
+			xgene_dma_delete_ring_one(tx_ring);
+		}
+	}
+
 	return ret;
 }

@@ -1504,6 +1779,8 @@ static void xgene_dma_init_hw(struct xgene_dma *pdma)

 	/* Associate DMA ring to corresponding ring HW */
 	iowrite32(XGENE_DMA_ASSOC_RING_MNGR1,
+		  pdma->csr_dma + XGENE_DMA_CFG_RING_FQ_ASSOC);
+	iowrite32(XGENE_DMA_ASSOC_RING_MNGR1,
 		  pdma->csr_dma + XGENE_DMA_CFG_RING_WQ_ASSOC);

 	/* Configure RAID6 polynomial control setting */
@@ -1671,6 +1948,9 @@ static void xgene_dma_set_caps(struct xgene_dma_chan *chan,
 		dma_cap_set(DMA_XOR, dma_dev->cap_mask);
 	}

+	if (chan->id == XGENE_DMA_FLYBY_CHANNEL)
+		dma_cap_set(DMA_CRC32C, dma_dev->cap_mask);
+
 	/* Set base and prep routines */
 	dma_dev->dev = chan->dev;
 	dma_dev->device_alloc_chan_resources = xgene_dma_alloc_chan_resources;
@@ -1690,6 +1970,9 @@ static void xgene_dma_set_caps(struct xgene_dma_chan *chan,
 		dma_dev->max_pq = XGENE_DMA_MAX_XOR_SRC;
 		dma_dev->pq_align = DMAENGINE_ALIGN_64_BYTES;
 	}
+
+	if (dma_has_cap(DMA_CRC32C, dma_dev->cap_mask))
+		dma_dev->device_prep_dma_crc32c = xgene_dma_prep_crc32c;
 }

 static int xgene_dma_async_register(struct xgene_dma *pdma, int id)
@@ -1729,10 +2012,11 @@ static int xgene_dma_async_register(struct xgene_dma *pdma, int id)

 	/* DMA capability info */
 	dev_info(pdma->dev,
-		 "%s: CAPABILITY ( %s%s%s)\n", dma_chan_name(&chan->dma_chan),
+		 "%s: CAPABILITY ( %s%s%s%s)\n", dma_chan_name(&chan->dma_chan),
 		 dma_has_cap(DMA_SG, dma_dev->cap_mask) ? "SGCPY " : "",
 		 dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "XOR " : "",
-		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "PQ " : "");
+		 dma_has_cap(DMA_PQ, dma_dev->cap_mask) ? "PQ " : "",
+		 dma_has_cap(DMA_CRC32C, dma_dev->cap_mask) ? "CRC32C " : "");

 	return 0;
 }
--
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
