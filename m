From: tmarri@apm.com
Subject: [PATCH v1 2/4] PPC4xx: New header with SoC specific dfinitions
Date: Thu, 23 Sep 2010 15:11:29 -0700
Message-ID: <1285279889-16740-1-git-send-email-tmarri@apm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com, yur@emcraft.com,
	herbert@gondor.hengli.com.au, tmarri@apm.com
To: linux-raid@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Tirumala Marri <tmarri@apm.com>

This patch adds new header file which contains common macro
definitions and inline functions.

Signed-off-by: Tirumala R Marri <tmarri@apm.com>
---
V1:
  * Remove all 440SPe specific references.
  * Move some of the code from header file to c file.
---
 drivers/dma/ppc4xx/ppc4xx-adma.h | 2424 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 2424 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/ppc4xx/ppc4xx-adma.h

diff --git a/drivers/dma/ppc4xx/ppc4xx-adma.h b/drivers/dma/ppc4xx/ppc4xx-adma.h
new file mode 100644
index 0000000..ae99350
--- /dev/null
+++ b/drivers/dma/ppc4xx/ppc4xx-adma.h
@@ -0,0 +1,2424 @@
+/*
+ * Copyright (C) 2006-2009 DENX Software Engineering.
+ *
+ * Author: Yuri Tikhonov <yur@emcraft.com>
+ *
+ * Further porting to arch/powerpc by
+ * 	Anatolij Gustschin <agust@denx.de>
+ * 	Tirumala R Marri <tmarri@apm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called COPYING.
+ */
+#ifndef __PPC4XX_ADMA_H
+#define __PPC4XX_ADMA_H
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <asm/dcr.h>
+#include <asm/dcr-regs.h>
+#include "adma.h"
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+#include "ppc440spe-dma.h"
+#endif
+
+#define PPC4XX_ADMA_DMA_MAX_BYTE_COUNT	0xFFFFFFUL
+/* this is the XOR_CBBCR width */
+#define PPC4XX_ADMA_XOR_MAX_BYTE_COUNT	(1 << 31)
+#define PPC4XX_ADMA_ZERO_SUM_MAX_BYTE_COUNT PPC4XX_ADMA_XOR_MAX_BYTE_COUNT
+#define PPC4XX_ADMA_ENGINES_NUM	(XOR_ENGINES_NUM + DMA_ENGINES_NUM)
+#define PPC4XX_ADMA_THRESHOLD	1
+#ifdef ADMA_LL_DEBUG
+#define ADMA_LL_DBG(x) ({ if (1) x; 0; })
+#else
+#define ADMA_LL_DBG(x) ({ if (0) x; 0; })
+#endif
+
+#define PPC4XX_DMA0_ID	0
+#define PPC4XX_DMA1_ID	1
+#define PPC4XX_XOR_ID	2
+/* Default polynomial (for 440SP is only available) */
+#define PPC4XX_DEFAULT_POLY	0x4d
+#define PPC4XX_ADMA_WATCHDOG_MSEC	3
+#define PPC4XX_RXOR_RUN	0
+#define MQ0_CF2H_RXOR_BS_MASK	0x1FF
+#define PPC4XX_DESC_INT	0	/* generate interrupt on complete */
+#define PPC4XX_ZERO_P	1	/* clear P destionaion */
+#define PPC4XX_ZERO_Q	2	/* clear Q destination */
+#define PPC4XX_COHERENT	3	/* src/dst are coherent */
+#define PPC4XX_DESC_WXOR	4	/* WXORs are in chain */
+#define PPC4XX_DESC_RXOR	5	/* RXOR is in chain */
+#define PPC4XX_DESC_RXOR123	8	/* CDB for RXOR123 operation */
+#define PPC4XX_DESC_RXOR124	9	/* CDB for RXOR124 operation */
+#define PPC4XX_DESC_RXOR125	10	/* CDB for RXOR125 operation */
+#define PPC4XX_DESC_RXOR12	11	/* CDB for RXOR12 operation */
+#define PPC4XX_DESC_RXOR_REV	12	/* CDB has srcs in reversed order */
+#define PPC4XX_DESC_PCHECK	13
+#define PPC4XX_DESC_QCHECK	14
+#define PPC4XX_DESC_RXOR_MSK	0x3
+
+enum ppc_adma_init_code {
+	PPC_ADMA_INIT_OK = 0,
+	PPC_ADMA_INIT_MEMRES,
+	PPC_ADMA_INIT_MEMREG,
+	PPC_ADMA_INIT_ALLOC,
+	PPC_ADMA_INIT_COHERENT,
+	PPC_ADMA_INIT_CHANNEL,
+	PPC_ADMA_INIT_IRQ1,
+	PPC_ADMA_INIT_IRQ2,
+	PPC_ADMA_INIT_REGISTER
+};
+
+/* This flag is set when want to refetch the xor chain in the interrupt
+ * handler
+ */
+static u32 do_xor_refetch;
+static struct ppc4xx_adma_chan *ppc4xx_r6_tchan;
+/* Since RXOR operations use the common register (MQ0_CF2H) for setting-up
+ * the block size in transactions, then we do not allow to activate more than
+ * only one RXOR transactions simultaneously. So use this var to store
+ * the information about is RXOR currently active (PPC4XX_RXOR_RUN bit is
+ * set) or not (PPC4XX_RXOR_RUN is clear).
+ */
+static unsigned long ppc4xx_rxor_state;
+
+/* Pointer to last linked and submitted xor CB */
+static struct ppc4xx_adma_desc_slot *xor_last_linked;
+static struct ppc4xx_adma_desc_slot *xor_last_submit;
+
+
+/* Pointers to last submitted to DMA0, DMA1 CDBs */
+static struct ppc4xx_adma_desc_slot *chan_last_sub[3];
+static struct ppc4xx_adma_desc_slot *chan_first_cdb[3];
+
+/* The list of channels exported by ppc4xx ADMA */
+static struct list_head ppc4xx_adma_chan_list =
+LIST_HEAD_INIT(ppc4xx_adma_chan_list);
+
+static int ppc4xx_adma_devices[PPC4XX_ADMA_ENGINES_NUM];
+static struct of_platform_driver ppc4xx_adma_driver;
+
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+static const struct of_device_id ppc4xx_adma_of_match[] __devinitconst = {
+	{.compatible = "ibm,dma-440spe",},
+	{.compatible = "amcc,xor-accelerator",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, ppc4xx_adma_of_match);
+#endif
+
+
+
+irqreturn_t ppc4xx_adma_eot_handler(int irq, void *data);
+irqreturn_t ppc4xx_adma_err_handler(int irq, void *data);
+
+void ppc4xx_adma_issue_pending(struct dma_chan *chan);
+struct ppc4xx_adma_desc_slot *ppc4xx_adma_alloc_slots(struct
+						      ppc4xx_adma_chan
+						      *chan,
+						      int num_slots,
+						      int slots_per_op);
+void ppc4xx_adma_free_slots(struct ppc4xx_adma_desc_slot *slot,
+			    struct ppc4xx_adma_chan *chan);
+dma_cookie_t ppc4xx_adma_tx_submit(struct dma_async_tx_descriptor *tx);
+void ppc4xx_chan_start_null_xor(struct ppc4xx_adma_chan *chan);
+void prep_dma_pqzero_sum_dbg(int id, dma_addr_t * src,
+			     unsigned int src_cnt, const unsigned char *scf);
+/*
+ * ppc4xx_get_group_entry - get group entry with index idx
+ * @tdesc: is the last allocated slot in the group.
+ */
+static struct ppc4xx_adma_desc_slot *ppc4xx_get_group_entry(struct
+							    ppc4xx_adma_desc_slot
+							    *tdesc,
+							    u32 entry_idx)
+{
+	struct ppc4xx_adma_desc_slot *iter = tdesc->group_head;
+	int i = 0;
+
+	if (entry_idx < 0 || entry_idx >= (tdesc->src_cnt + tdesc->dst_cnt)) {
+		printk("%s: entry_idx %d, src_cnt %d, dst_cnt %d\n",
+		       __func__, entry_idx, tdesc->src_cnt, tdesc->dst_cnt);
+		BUG();
+	}
+
+	list_for_each_entry(iter, &tdesc->group_list, chain_node) {
+		if (i++ == entry_idx)
+			break;
+	}
+	return iter;
+}
+
+static inline void print_cb(struct ppc4xx_adma_chan *chan, void *block)
+{
+	struct dma_cdb *cdb;
+	struct xor_cb *cb;
+	int i;
+
+	switch (chan->device->id) {
+	case 0:
+	case 1:
+		cdb = block;
+
+		pr_debug("CDB at %p [%d]:\n"
+			 "\t attr 0x%02x opc 0x%02x cnt 0x%08x\n"
+			 "\t sg1u 0x%08x sg1l 0x%08x\n"
+			 "\t sg2u 0x%08x sg2l 0x%08x\n"
+			 "\t sg3u 0x%08x sg3l 0x%08x\n",
+			 cdb, chan->device->id,
+			 cdb->attr, cdb->opc, le32_to_cpu(cdb->cnt),
+			 le32_to_cpu(cdb->sg1u), le32_to_cpu(cdb->sg1l),
+			 le32_to_cpu(cdb->sg2u), le32_to_cpu(cdb->sg2l),
+			 le32_to_cpu(cdb->sg3u), le32_to_cpu(cdb->sg3l)
+		    );
+		break;
+	case 2:
+		cb = block;
+
+		pr_debug("CB at %p [%d]:\n"
+			 "\t cbc 0x%08x cbbc 0x%08x cbs 0x%08x\n"
+			 "\t cbtah 0x%08x cbtal 0x%08x\n"
+			 "\t cblah 0x%08x cblal 0x%08x\n",
+			 cb, chan->device->id,
+			 cb->cbc, cb->cbbc, cb->cbs,
+			 cb->cbtah, cb->cbtal, cb->cblah, cb->cblal);
+		for (i = 0; i < 16; i++) {
+			if (i && !cb->ops[i].h && !cb->ops[i].l)
+				continue;
+			pr_debug("\t ops[%2d]: h 0x%08x l 0x%08x\n",
+				 i, cb->ops[i].h, cb->ops[i].l);
+		}
+		break;
+	}
+}
+
+/******************************************************************************
+ * Command (Descriptor) Blocks low-level routines
+ ******************************************************************************/
+/**
+ * ppc4xx_desc_init_interrupt - initialize the descriptor for INTERRUPT
+ * pseudo operation
+ */
+static inline void ppc4xx_desc_init_interrupt(struct ppc4xx_adma_desc_slot
+					      *desc,
+					      struct ppc4xx_adma_chan *chan)
+{
+	struct xor_cb *p;
+
+	switch (chan->device->id) {
+	case PPC4XX_XOR_ID:
+		p = desc->hw_desc;
+		memset(desc->hw_desc, 0, sizeof(struct xor_cb));
+		/* NOP with Command Block Complete Enable */
+		p->cbc = XOR_CBCR_CBCE_BIT;
+		break;
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+		/* NOP with interrupt */
+		set_bit(PPC4XX_DESC_INT, &desc->flags);
+		break;
+	default:
+		printk(KERN_ERR "Unsupported id %d in %s\n", chan->device->id,
+		       __func__);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_desc_init_null_xor - initialize the descriptor for NULL XOR
+ * pseudo operation
+ */
+static inline void ppc4xx_desc_init_null_xor(struct ppc4xx_adma_desc_slot *desc)
+{
+	memset(desc->hw_desc, 0, sizeof(struct xor_cb));
+	desc->hw_next = NULL;
+	desc->src_cnt = 0;
+	desc->dst_cnt = 1;
+}
+
+/**
+ * ppc4xx_desc_init_xor - initialize the descriptor for XOR operation
+ */
+static inline void ppc4xx_desc_init_xor(struct ppc4xx_adma_desc_slot *desc,
+					int src_cnt, unsigned long flags)
+{
+	struct xor_cb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct xor_cb));
+	desc->hw_next = NULL;
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = 1;
+
+	hw_desc->cbc = XOR_CBCR_TGT_BIT | src_cnt;
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Enable interrupt on completion */
+		hw_desc->cbc |= XOR_CBCR_CBCE_BIT;
+}
+
+/**
+ * ppc4xx_desc_init_dma2pq - initialize the descriptor for PQ
+ * operation in DMA2 controller
+ */
+static inline void ppc4xx_desc_init_dma2pq(struct ppc4xx_adma_desc_slot *desc,
+					   int dst_cnt, int src_cnt,
+					   unsigned long flags)
+{
+	struct xor_cb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct xor_cb));
+	desc->hw_next = NULL;
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = dst_cnt;
+	memset(desc->reverse_flags, 0, sizeof(desc->reverse_flags));
+	desc->descs_per_op = 0;
+
+	hw_desc->cbc = XOR_CBCR_TGT_BIT;
+	if (flags & DMA_PREP_INTERRUPT)
+		/* Enable interrupt on completion */
+		hw_desc->cbc |= XOR_CBCR_CBCE_BIT;
+}
+
+#define DMA_CTRL_FLAGS_LAST	DMA_PREP_FENCE
+#define DMA_PREP_ZERO_P		(DMA_CTRL_FLAGS_LAST << 1)
+#define DMA_PREP_ZERO_Q		(DMA_PREP_ZERO_P << 1)
+
+/**
+ * ppc4xx_desc_init_dma01pq - initialize the descriptors for PQ operation
+ * with DMA0/1
+ */
+static inline void ppc4xx_desc_init_dma01pq(struct ppc4xx_adma_desc_slot *desc,
+					    int dst_cnt, int src_cnt,
+					    unsigned long flags,
+					    unsigned long op)
+{
+	struct dma_cdb *hw_desc;
+	struct ppc4xx_adma_desc_slot *iter;
+	u8 dopc;
+
+	/* Common initialization of a PQ descriptors chain */
+	set_bits(op, &desc->flags);
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = dst_cnt;
+
+	/* WXOR MULTICAST if both P and Q are being computed
+	 * MV_SG1_SG2 if Q only
+	 */
+	dopc = (desc->dst_cnt == DMA_DEST_MAX_NUM) ?
+	    DMA_CDB_OPC_MULTICAST : DMA_CDB_OPC_MV_SG1_SG2;
+
+	list_for_each_entry(iter, &desc->group_list, chain_node) {
+		hw_desc = iter->hw_desc;
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+
+		if (likely(!list_is_last(&iter->chain_node, &desc->group_list))) {
+			/* set 'next' pointer */
+			iter->hw_next = list_entry(iter->chain_node.next,
+						   struct ppc4xx_adma_desc_slot,
+						   chain_node);
+			clear_bit(PPC4XX_DESC_INT, &iter->flags);
+		} else {
+			/* this is the last descriptor.
+			 * this slot will be pasted from ADMA level
+			 * each time it wants to configure parameters
+			 * of the transaction (src, dst, ...)
+			 */
+			iter->hw_next = NULL;
+			if (flags & DMA_PREP_INTERRUPT)
+				set_bit(PPC4XX_DESC_INT, &iter->flags);
+			else
+				clear_bit(PPC4XX_DESC_INT, &iter->flags);
+		}
+	}
+
+	/* Set OPS depending on WXOR/RXOR type of operation */
+	if (!test_bit(PPC4XX_DESC_RXOR, &desc->flags)) {
+		/* This is a WXOR only chain:
+		 * - first descriptors are for zeroing destinations
+		 *   if PPC4XX_ZERO_P/Q set;
+		 * - descriptors remained are for GF-XOR operations.
+		 */
+		iter = list_first_entry(&desc->group_list,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+
+		if (test_bit(PPC4XX_ZERO_P, &desc->flags)) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc4xx_adma_desc_slot,
+						chain_node);
+		}
+
+		if (test_bit(PPC4XX_ZERO_Q, &desc->flags)) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc4xx_adma_desc_slot,
+						chain_node);
+		}
+
+		list_for_each_entry_from(iter, &desc->group_list, chain_node) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = dopc;
+		}
+	} else {
+		/* This is either RXOR-only or mixed RXOR/WXOR */
+
+		/* The first 1 or 2 slots in chain are always RXOR,
+		 * if need to calculate P & Q, then there are two
+		 * RXOR slots; if only P or only Q, then there is one
+		 */
+		iter = list_first_entry(&desc->group_list,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+
+		if (desc->dst_cnt == DMA_DEST_MAX_NUM) {
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc4xx_adma_desc_slot,
+						chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		}
+
+		/* The remaining descs (if any) are WXORs */
+		if (test_bit(PPC4XX_DESC_WXOR, &desc->flags)) {
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc4xx_adma_desc_slot,
+						chain_node);
+			list_for_each_entry_from(iter, &desc->group_list,
+						 chain_node) {
+				hw_desc = iter->hw_desc;
+				hw_desc->opc = dopc;
+			}
+		}
+	}
+}
+
+/**
+ * ppc4xx_desc_init_dma01pqzero_sum - initialize the descriptor
+ * for PQ_ZERO_SUM operation
+ */
+static inline void ppc4xx_desc_init_dma01pqzero_sum(struct ppc4xx_adma_desc_slot
+						    *desc, int dst_cnt,
+						    int src_cnt)
+{
+	struct dma_cdb *hw_desc;
+	struct ppc4xx_adma_desc_slot *iter;
+	int i = 0;
+	u8 dopc = (dst_cnt == 2) ? DMA_CDB_OPC_MULTICAST :
+	    DMA_CDB_OPC_MV_SG1_SG2;
+	/*
+	 * Initialize starting from 2nd or 3rd descriptor dependent
+	 * on dst_cnt. First one or two slots are for cloning P
+	 * and/or Q to chan->pdest and/or chan->qdest as we have
+	 * to preserve original P/Q.
+	 */
+	iter = list_first_entry(&desc->group_list,
+				struct ppc4xx_adma_desc_slot, chain_node);
+	iter = list_entry(iter->chain_node.next,
+			  struct ppc4xx_adma_desc_slot, chain_node);
+
+	if (dst_cnt > 1) {
+		iter = list_entry(iter->chain_node.next,
+				  struct ppc4xx_adma_desc_slot, chain_node);
+	}
+	/* initialize each source descriptor in chain */
+	list_for_each_entry_from(iter, &desc->group_list, chain_node) {
+		hw_desc = iter->hw_desc;
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->src_cnt = 0;
+		iter->dst_cnt = 0;
+
+		/* This is a ZERO_SUM operation:
+		 * - <src_cnt> descriptors starting from 2nd or 3rd
+		 *   descriptor are for GF-XOR operations;
+		 * - remaining <dst_cnt> descriptors are for checking the result
+		 */
+		if (i++ < src_cnt)
+			/* MV_SG1_SG2 if only Q is being verified
+			 * MULTICAST if both P and Q are being verified
+			 */
+			hw_desc->opc = dopc;
+		else
+			/* DMA_CDB_OPC_DCHECK128 operation */
+			hw_desc->opc = DMA_CDB_OPC_DCHECK128;
+
+		if (likely(!list_is_last(&iter->chain_node, &desc->group_list))) {
+			/* set 'next' pointer */
+			iter->hw_next = list_entry(iter->chain_node.next,
+						   struct ppc4xx_adma_desc_slot,
+						   chain_node);
+		} else {
+			/* this is the last descriptor.
+			 * this slot will be pasted from ADMA level
+			 * each time it wants to configure parameters
+			 * of the transaction (src, dst, ...)
+			 */
+			iter->hw_next = NULL;
+			/* always enable interrupt generation since we get
+			 * the status of pqzero from the handler
+			 */
+			set_bit(PPC4XX_DESC_INT, &iter->flags);
+		}
+	}
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = dst_cnt;
+}
+
+/**
+ * ppc4xx_desc_init_memcpy - initialize the descriptor for MEMCPY operation
+ */
+static inline void ppc4xx_desc_init_memcpy(struct ppc4xx_adma_desc_slot *desc,
+					   unsigned long flags)
+{
+	struct dma_cdb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+	desc->hw_next = NULL;
+	desc->src_cnt = 1;
+	desc->dst_cnt = 1;
+
+	if (flags & DMA_PREP_INTERRUPT)
+		set_bit(PPC4XX_DESC_INT, &desc->flags);
+	else
+		clear_bit(PPC4XX_DESC_INT, &desc->flags);
+
+	hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+}
+
+/**
+ * ppc4xx_desc_init_memset - initialize the descriptor for MEMSET operation
+ */
+static inline void ppc4xx_desc_init_memset(struct ppc4xx_adma_desc_slot *desc,
+					   int value, unsigned long flags)
+{
+	struct dma_cdb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+	desc->hw_next = NULL;
+	desc->src_cnt = 1;
+	desc->dst_cnt = 1;
+
+	if (flags & DMA_PREP_INTERRUPT)
+		set_bit(PPC4XX_DESC_INT, &desc->flags);
+	else
+		clear_bit(PPC4XX_DESC_INT, &desc->flags);
+
+	hw_desc->sg1u = hw_desc->sg1l = cpu_to_le32((u32) value);
+	hw_desc->sg3u = hw_desc->sg3l = cpu_to_le32((u32) value);
+	hw_desc->opc = DMA_CDB_OPC_DFILL128;
+}
+
+/**
+ * ppc4xx_desc_set_byte_count - set number of data bytes involved
+ * into the operation
+ */
+static inline void ppc4xx_desc_set_byte_count(struct ppc4xx_adma_desc_slot
+					      *desc,
+					      struct ppc4xx_adma_chan *chan,
+					      u32 byte_count)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+		dma_hw_desc->cnt = cpu_to_le32(byte_count);
+		break;
+	case PPC4XX_XOR_ID:
+		xor_hw_desc = desc->hw_desc;
+		xor_hw_desc->cbbc = byte_count;
+		break;
+	}
+}
+
+/**
+ * ppc4xx_desc_set_dcheck - set CHECK pattern
+ */
+static inline void ppc4xx_desc_set_dcheck(struct ppc4xx_adma_desc_slot *desc,
+					  struct ppc4xx_adma_chan *chan,
+					  u8 * qword)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+		iowrite32(qword[0], &dma_hw_desc->sg3l);
+		iowrite32(qword[4], &dma_hw_desc->sg3u);
+		iowrite32(qword[8], &dma_hw_desc->sg2l);
+		iowrite32(qword[12], &dma_hw_desc->sg2u);
+		break;
+	default:
+		BUG();
+	}
+}
+
+/**
+ * ppc4xx_desc_get_src_addr - extract the source address from the descriptor
+ */
+static inline u32 ppc4xx_desc_get_src_addr(struct ppc4xx_adma_desc_slot *desc,
+					   struct ppc4xx_adma_chan *chan,
+					   int src_idx)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+		/* May have 0, 1, 2, or 3 sources */
+		switch (dma_hw_desc->opc) {
+		case DMA_CDB_OPC_NO_OP:
+		case DMA_CDB_OPC_DFILL128:
+			return 0;
+		case DMA_CDB_OPC_DCHECK128:
+			if (unlikely(src_idx)) {
+				printk(KERN_ERR "%s: try to get %d source for"
+				       " DCHECK128\n", __func__, src_idx);
+				BUG();
+			}
+			return le32_to_cpu(dma_hw_desc->sg1l);
+		case DMA_CDB_OPC_MULTICAST:
+		case DMA_CDB_OPC_MV_SG1_SG2:
+			if (unlikely(src_idx > 2)) {
+				printk(KERN_ERR "%s: try to get %d source from"
+				       " DMA descr\n", __func__, src_idx);
+				BUG();
+			}
+			if (src_idx) {
+				if (le32_to_cpu(dma_hw_desc->sg1u) &
+				    DMA_CUED_XOR_WIN_MSK) {
+					u8 region;
+
+					if (src_idx == 1)
+						return le32_to_cpu(dma_hw_desc->
+								   sg1l) +
+						    desc->unmap_len;
+
+					region =
+					    (le32_to_cpu(dma_hw_desc->sg1u)) >>
+					    DMA_CUED_REGION_OFF;
+
+					region &= DMA_CUED_REGION_MSK;
+					switch (region) {
+					case DMA_RXOR123:
+						return le32_to_cpu(dma_hw_desc->
+								   sg1l) +
+						    (desc->unmap_len << 1);
+					case DMA_RXOR124:
+						return le32_to_cpu(dma_hw_desc->
+								   sg1l) +
+						    (desc->unmap_len * 3);
+					case DMA_RXOR125:
+						return le32_to_cpu(dma_hw_desc->
+								   sg1l) +
+						    (desc->unmap_len << 2);
+					default:
+						printk(KERN_ERR
+						       "%s: try to"
+						       " get src3 for region %02x"
+						       "PPC4XX_DESC_RXOR12?\n",
+						       __func__, region);
+						BUG();
+					}
+				} else {
+					printk(KERN_ERR
+					       "%s: try to get %d"
+					       " source for non-cued descr\n",
+					       __func__, src_idx);
+					BUG();
+				}
+			}
+			return le32_to_cpu(dma_hw_desc->sg1l);
+		default:
+			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
+			       __func__, dma_hw_desc->opc);
+			BUG();
+		}
+		return le32_to_cpu(dma_hw_desc->sg1l);
+	case PPC4XX_XOR_ID:
+		/* May have up to 16 sources */
+		xor_hw_desc = desc->hw_desc;
+		return xor_hw_desc->ops[src_idx].l;
+	}
+	return 0;
+}
+
+/**
+ * ppc4xx_desc_get_dest_addr - extract the destination address from the
+ * descriptor
+ */
+static inline u32 ppc4xx_desc_get_dest_addr(struct ppc4xx_adma_desc_slot *desc,
+					    struct ppc4xx_adma_chan *chan,
+					    int idx)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+
+		if (likely(!idx))
+			return le32_to_cpu(dma_hw_desc->sg2l);
+		return le32_to_cpu(dma_hw_desc->sg3l);
+	case PPC4XX_XOR_ID:
+		xor_hw_desc = desc->hw_desc;
+		return xor_hw_desc->cbtal;
+	}
+	return 0;
+}
+
+/**
+ * ppc4xx_desc_get_src_num - extract the number of source addresses from
+ * the descriptor
+ */
+static inline u32 ppc4xx_desc_get_src_num(struct ppc4xx_adma_desc_slot *desc,
+					  struct ppc4xx_adma_chan *chan)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+
+		switch (dma_hw_desc->opc) {
+		case DMA_CDB_OPC_NO_OP:
+		case DMA_CDB_OPC_DFILL128:
+			return 0;
+		case DMA_CDB_OPC_DCHECK128:
+			return 1;
+		case DMA_CDB_OPC_MV_SG1_SG2:
+		case DMA_CDB_OPC_MULTICAST:
+			/*
+			 * Only for RXOR operations we have more than
+			 * one source
+			 */
+			if (le32_to_cpu(dma_hw_desc->sg1u) &
+			    DMA_CUED_XOR_WIN_MSK) {
+				/* RXOR op, there are 2 or 3 sources */
+				if (((le32_to_cpu(dma_hw_desc->sg1u) >>
+				      DMA_CUED_REGION_OFF) &
+				     DMA_CUED_REGION_MSK) == DMA_RXOR12) {
+					/* RXOR 1-2 */
+					return 2;
+				} else {
+					/* RXOR 1-2-3/1-2-4/1-2-5 */
+					return 3;
+				}
+			}
+			return 1;
+		default:
+			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
+			       __func__, dma_hw_desc->opc);
+			BUG();
+		}
+	case PPC4XX_XOR_ID:
+		/* up to 16 sources */
+		xor_hw_desc = desc->hw_desc;
+		return xor_hw_desc->cbc & XOR_CDCR_OAC_MSK;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+/**
+ * ppc4xx_desc_get_dst_num - get the number of destination addresses in
+ * this descriptor
+ */
+static inline u32 ppc4xx_desc_get_dst_num(struct ppc4xx_adma_desc_slot *desc,
+					  struct ppc4xx_adma_chan *chan)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* May be 1 or 2 destinations */
+		dma_hw_desc = desc->hw_desc;
+		switch (dma_hw_desc->opc) {
+		case DMA_CDB_OPC_NO_OP:
+		case DMA_CDB_OPC_DCHECK128:
+			return 0;
+		case DMA_CDB_OPC_MV_SG1_SG2:
+		case DMA_CDB_OPC_DFILL128:
+			return 1;
+		case DMA_CDB_OPC_MULTICAST:
+			if (desc->dst_cnt == 2)
+				return 2;
+			else
+				return 1;
+		default:
+			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
+			       __func__, dma_hw_desc->opc);
+			BUG();
+		}
+	case PPC4XX_XOR_ID:
+		/* Always only 1 destination */
+		return 1;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+/******************************************************************************
+ * ADMA channel low-level routines
+ ******************************************************************************/
+
+static inline u32 ppc4xx_chan_get_current_descriptor(struct ppc4xx_adma_chan
+						     *chan);
+static inline void ppc4xx_dma_put_desc(struct ppc4xx_adma_chan *chan,
+				       struct ppc4xx_adma_desc_slot *desc);
+static inline void ppc4xx_xor_set_link(struct ppc4xx_adma_desc_slot *prev_desc,
+				       struct ppc4xx_adma_desc_slot *next_desc);
+static inline void print_cb_list(struct ppc4xx_adma_chan *chan,
+				 struct ppc4xx_adma_desc_slot *iter);
+/**
+ * ppc4xx_chan_append - update the h/w chain in the channel
+ */
+static inline void ppc4xx_chan_append(struct ppc4xx_adma_chan *chan)
+{
+	struct xor_regs *xor_reg;
+	struct ppc4xx_adma_desc_slot *iter;
+	struct xor_cb *xcb;
+	u32 cur_desc;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		cur_desc = ppc4xx_chan_get_current_descriptor(chan);
+
+		if (likely(cur_desc)) {
+			iter = chan_last_sub[chan->device->id];
+			BUG_ON(!iter);
+		} else {
+			/* first peer */
+			iter = chan_first_cdb[chan->device->id];
+			BUG_ON(!iter);
+			ppc4xx_dma_put_desc(chan, iter);
+			chan->hw_chain_inited = 1;
+		}
+
+		/* is there something new to append */
+		if (!iter->hw_next)
+			break;
+
+		/* flush descriptors from the s/w queue to fifo */
+		list_for_each_entry_continue(iter, &chan->chain, chain_node) {
+			ppc4xx_dma_put_desc(chan, iter);
+			if (!iter->hw_next)
+				break;
+		}
+		break;
+	case PPC4XX_XOR_ID:
+		/* update h/w links and refetch */
+		if (!xor_last_submit->hw_next)
+			break;
+
+		xor_reg = chan->device->xor_reg;
+		/* the last linked CDB has to generate an interrupt
+		 * that we'd be able to append the next lists to h/w
+		 * regardless of the XOR engine state at the moment of
+		 * appending of these next lists
+		 */
+		xcb = xor_last_linked->hw_desc;
+		xcb->cbc |= XOR_CBCR_CBCE_BIT;
+
+		if (!(ioread32be(&xor_reg->sr) & XOR_SR_XCP_BIT)) {
+			/* XORcore is idle. Refetch now */
+			do_xor_refetch = 0;
+			ppc4xx_xor_set_link(xor_last_submit,
+					    xor_last_submit->hw_next);
+
+			ADMA_LL_DBG(print_cb_list(chan,
+						  xor_last_submit->hw_next));
+
+			xor_last_submit = xor_last_linked;
+			iowrite32be(ioread32be(&xor_reg->crsr) |
+				    XOR_CRSR_RCBE_BIT | XOR_CRSR_64BA_BIT,
+				    &xor_reg->crsr);
+		} else {
+			/* XORcore is running. Refetch later in the handler */
+			do_xor_refetch = 1;
+		}
+
+		break;
+	}
+
+	local_irq_restore(flags);
+}
+
+/**
+ * ppc4xx_adma_device_clear_eot_status - interrupt ack to XOR or DMA engine
+ */
+static inline void ppc4xx_adma_device_clear_eot_status(struct ppc4xx_adma_chan
+						       *chan)
+{
+	struct dma_regs *dma_reg;
+	struct xor_regs *xor_reg;
+	u8 *p = chan->device->dma_desc_pool_virt;
+	struct dma_cdb *cdb;
+	u32 rv, i;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* read FIFO to ack */
+		dma_reg = chan->device->dma_reg;
+		while ((rv = ioread32(&dma_reg->csfpl))) {
+			i = rv & DMA_CDB_ADDR_MSK;
+			cdb = (struct dma_cdb *)&p[i -
+						   (u32) chan->device->
+						   dma_desc_pool];
+
+			/* Clear opcode to ack. This is necessary for
+			 * ZeroSum operations only
+			 */
+			cdb->opc = 0;
+
+			if (test_bit(PPC4XX_RXOR_RUN, &ppc4xx_rxor_state)) {
+				/* probably this is a completed RXOR op,
+				 * get pointer to CDB using the fact that
+				 * physical and virtual addresses of CDB
+				 * in pools have the same offsets
+				 */
+				if (le32_to_cpu(cdb->sg1u) & DMA_CUED_XOR_BASE) {
+					/* this is a RXOR */
+					clear_bit(PPC4XX_RXOR_RUN,
+						  &ppc4xx_rxor_state);
+				}
+			}
+
+			if (rv & DMA_CDB_STATUS_MSK) {
+				/* ZeroSum check failed
+				 */
+				struct ppc4xx_adma_desc_slot *iter;
+				dma_addr_t phys = rv & ~DMA_CDB_MSK;
+
+				/*
+				 * Update the status of corresponding
+				 * descriptor.
+				 */
+				list_for_each_entry(iter, &chan->chain,
+						    chain_node) {
+					if (iter->phys == phys)
+						break;
+				}
+				/*
+				 * if cannot find the corresponding
+				 * slot it's a bug
+				 */
+				BUG_ON(&iter->chain_node == &chan->chain);
+
+				if (iter->xor_check_result) {
+					if (test_bit(PPC4XX_DESC_PCHECK,
+						     &iter->flags)) {
+						*iter->xor_check_result |=
+						    SUM_CHECK_P_RESULT;
+					} else
+					    if (test_bit(PPC4XX_DESC_QCHECK,
+							 &iter->flags)) {
+						*iter->xor_check_result |=
+						    SUM_CHECK_Q_RESULT;
+					} else
+						BUG();
+				}
+			}
+		}
+
+		rv = ioread32(&dma_reg->dsts);
+		if (rv) {
+			pr_err("DMA%d err status: 0x%x\n",
+			       chan->device->id, rv);
+			/* write back to clear */
+			iowrite32(rv, &dma_reg->dsts);
+		}
+		break;
+	case PPC4XX_XOR_ID:
+		/* reset status bits to ack */
+		xor_reg = chan->device->xor_reg;
+		rv = ioread32be(&xor_reg->sr);
+		iowrite32be(rv, &xor_reg->sr);
+
+		if (rv &
+		    (XOR_IE_ICBIE_BIT | XOR_IE_ICIE_BIT | XOR_IE_RPTIE_BIT)) {
+			if (rv & XOR_IE_RPTIE_BIT) {
+				/* Read PLB Timeout Error.
+				 * Try to resubmit the CB
+				 */
+				u32 val = ioread32be(&xor_reg->ccbalr);
+
+				iowrite32be(val, &xor_reg->cblalr);
+
+				val = ioread32be(&xor_reg->crsr);
+				iowrite32be(val | XOR_CRSR_XAE_BIT,
+					    &xor_reg->crsr);
+			} else
+				pr_err("XOR ERR 0x%x status\n", rv);
+			break;
+		}
+
+		/*  if the XORcore is idle, but there are unprocessed CBs
+		 * then refetch the s/w chain here
+		 */
+		if (!(ioread32be(&xor_reg->sr) & XOR_SR_XCP_BIT) &&
+		    do_xor_refetch)
+			ppc4xx_chan_append(chan);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_chan_is_busy - get the channel status
+ */
+static inline int ppc4xx_chan_is_busy(struct ppc4xx_adma_chan *chan)
+{
+	struct dma_regs *dma_reg;
+	struct xor_regs *xor_reg;
+	int busy = 0;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_reg = chan->device->dma_reg;
+		/*  if command FIFO's head and tail pointers are equal and
+		 * status tail is the same as command, then channel is free
+		 */
+		if (ioread16(&dma_reg->cpfhp) != ioread16(&dma_reg->cpftp) ||
+		    ioread16(&dma_reg->cpftp) != ioread16(&dma_reg->csftp))
+			busy = 1;
+		break;
+	case PPC4XX_XOR_ID:
+		/* use the special status bit for the XORcore
+		 */
+		xor_reg = chan->device->xor_reg;
+		busy = (ioread32be(&xor_reg->sr) & XOR_SR_XCP_BIT) ? 1 : 0;
+		break;
+	}
+
+	return busy;
+}
+
+/**
+ * ppc4xx_chan_set_first_xor_descriptor -  init XORcore chain
+ */
+static inline void ppc4xx_chan_set_first_xor_descriptor(struct ppc4xx_adma_chan
+							*chan,
+							struct
+							ppc4xx_adma_desc_slot
+							*next_desc)
+{
+	struct xor_regs *xor_reg = chan->device->xor_reg;
+
+	if (ioread32be(&xor_reg->sr) & XOR_SR_XCP_BIT)
+		printk(KERN_INFO "%s: Warn: XORcore is running "
+		       "when try to set the first CDB!\n", __func__);
+
+	xor_last_submit = xor_last_linked = next_desc;
+
+	iowrite32be(XOR_CRSR_64BA_BIT, &xor_reg->crsr);
+
+	iowrite32be(next_desc->phys, &xor_reg->cblalr);
+	iowrite32be(0, &xor_reg->cblahr);
+	iowrite32be(ioread32be(&xor_reg->cbcr) | XOR_CBCR_LNK_BIT,
+		    &xor_reg->cbcr);
+
+	chan->hw_chain_inited = 1;
+}
+
+/**
+ * ppc4xx_chan_run - enable the channel
+ */
+static inline void ppc4xx_chan_run(struct ppc4xx_adma_chan *chan)
+{
+	struct xor_regs *xor_reg;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* DMAs are always enabled, do nothing */
+		break;
+	case PPC4XX_XOR_ID:
+		/* drain write buffer */
+		xor_reg = chan->device->xor_reg;
+
+		/* fetch descriptor pointed to in <link> */
+		iowrite32be(XOR_CRSR_64BA_BIT | XOR_CRSR_XAE_BIT,
+			    &xor_reg->crsr);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_adma_device_estimate - estimate the efficiency of processing
+ *	the operation given on this channel. It's assumed that 'chan' is
+ *	capable to process 'cap' type of operation.
+ * @chan: channel to use
+ * @cap: type of transaction
+ * @dst_lst: array of destination pointers
+ * @dst_cnt: number of destination operands
+ * @src_lst: array of source pointers
+ * @src_cnt: number of source operands
+ * @src_sz: size of each source operand
+ */
+
+#define DMA_CTRL_FLAGS_LAST	DMA_PREP_FENCE
+#define DMA_PREP_ZERO_P		(DMA_CTRL_FLAGS_LAST << 1)
+#define DMA_PREP_ZERO_Q		(DMA_PREP_ZERO_P << 1)
+
+static inline void print_cb_list(struct ppc4xx_adma_chan *chan,
+				 struct ppc4xx_adma_desc_slot *iter)
+{
+	for (; iter; iter = iter->hw_next)
+		print_cb(chan, iter->hw_desc);
+}
+
+/**
+ * ppc4xx_dma_put_desc - put DMA0,1 descriptor to FIFO.
+ * called with irqs disabled
+ */
+static inline void ppc4xx_dma_put_desc(struct ppc4xx_adma_chan *chan,
+				       struct ppc4xx_adma_desc_slot *desc)
+{
+	u32 pcdb;
+	struct dma_regs *dma_reg = chan->device->dma_reg;
+
+	pcdb = desc->phys;
+	if (!test_bit(PPC4XX_DESC_INT, &desc->flags))
+		pcdb |= DMA_CDB_NO_INT;
+
+	chan_last_sub[chan->device->id] = desc;
+
+	ADMA_LL_DBG(print_cb(chan, desc->hw_desc));
+
+	iowrite32(pcdb, &dma_reg->cpfpl);
+}
+
+/**
+ * ppc4xx_xor_set_link - set link address in xor CB
+ */
+static inline void ppc4xx_xor_set_link(struct ppc4xx_adma_desc_slot *prev_desc,
+				       struct ppc4xx_adma_desc_slot *next_desc)
+{
+	struct xor_cb *xor_hw_desc = prev_desc->hw_desc;
+
+	if (unlikely(!next_desc || !(next_desc->phys))) {
+		printk(KERN_ERR "%s: next_desc=0x%p; next_desc->phys=0x%llx\n",
+		       __func__, next_desc, next_desc ? next_desc->phys : 0);
+		BUG();
+	}
+
+	xor_hw_desc->cbs = 0;
+	xor_hw_desc->cblal = next_desc->phys;
+	xor_hw_desc->cblah = 0;
+	xor_hw_desc->cbc |= XOR_CBCR_LNK_BIT;
+}
+
+/**
+ * ppc4xx_desc_set_link - set the address of descriptor following this
+ * descriptor in chain
+ */
+static inline void ppc4xx_desc_set_link(struct ppc4xx_adma_chan *chan,
+					struct ppc4xx_adma_desc_slot *prev_desc,
+					struct ppc4xx_adma_desc_slot *next_desc)
+{
+	unsigned long flags;
+	struct ppc4xx_adma_desc_slot *tail = next_desc;
+
+	if (unlikely(!prev_desc || !next_desc ||
+		     (prev_desc->hw_next && prev_desc->hw_next != next_desc))) {
+		/* If previous next is overwritten something is wrong.
+		 * though we may refetch from append to initiate list
+		 * processing; in this case - it's ok.
+		 */
+		printk(KERN_ERR "%s: prev_desc=0x%p; next_desc=0x%p; "
+		       "prev->hw_next=0x%p\n", __func__, prev_desc,
+		       next_desc, prev_desc ? prev_desc->hw_next : 0);
+		BUG();
+	}
+
+	local_irq_save(flags);
+
+	/* do s/w chaining both for DMA and XOR descriptors */
+	prev_desc->hw_next = next_desc;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		break;
+	case PPC4XX_XOR_ID:
+		/* bind descriptor to the chain */
+		while (tail->hw_next)
+			tail = tail->hw_next;
+		xor_last_linked = tail;
+
+		if (prev_desc == xor_last_submit)
+			/* do not link to the last submitted CB */
+			break;
+		ppc4xx_xor_set_link(prev_desc, next_desc);
+		break;
+	}
+
+	local_irq_restore(flags);
+}
+
+/******************************************************************************
+ * CDB field manipulation routines
+ ******************************************************************************/
+/**
+ * ppc4xx_desc_set_dest_addr - set destination address into the descriptor
+ */
+static inline void ppc4xx_desc_set_dest_addr(struct ppc4xx_adma_desc_slot *desc,
+					     struct ppc4xx_adma_chan *chan,
+					     dma_addr_t addrh, dma_addr_t addrl,
+					     u32 dst_idx)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+	phys_addr_t addr64, tmphi, tmplow;
+	u32 *psgu, *psgl;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		if (!addrh) {
+			addr64 = addrl;
+			tmphi = (addr64 >> 32);
+			tmplow = (addr64 & 0xFFFFFFFF);
+		} else {
+			tmphi = addrh;
+			tmplow = addrl;
+		}
+		dma_hw_desc = desc->hw_desc;
+
+		psgu = dst_idx ? &dma_hw_desc->sg3u : &dma_hw_desc->sg2u;
+		psgl = dst_idx ? &dma_hw_desc->sg3l : &dma_hw_desc->sg2l;
+
+		*psgl = cpu_to_le32((u32) tmplow);
+		*psgu |= cpu_to_le32((u32) tmphi);
+		break;
+	case PPC4XX_XOR_ID:
+		xor_hw_desc = desc->hw_desc;
+		xor_hw_desc->cbtal = addrl;
+		xor_hw_desc->cbtah |= addrh;
+		break;
+	}
+}
+
+/**
+ * ppc4xx_desc_set_src_addr - set source address into the descriptor
+ */
+static inline void ppc4xx_desc_set_src_addr(struct ppc4xx_adma_desc_slot *desc,
+					    struct ppc4xx_adma_chan *chan,
+					    int src_idx, dma_addr_t addrh,
+					    dma_addr_t addrl)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+	phys_addr_t addr64, tmplow, tmphi;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		if (!addrh) {
+			addr64 = addrl;
+			tmphi = (addr64 >> 32);
+			tmplow = (addr64 & 0xFFFFFFFF);
+		} else {
+			tmphi = addrh;
+			tmplow = addrl;
+		}
+		dma_hw_desc = desc->hw_desc;
+		dma_hw_desc->sg1l = cpu_to_le32((u32) tmplow);
+		dma_hw_desc->sg1u |= cpu_to_le32((u32) tmphi);
+		break;
+	case PPC4XX_XOR_ID:
+		xor_hw_desc = desc->hw_desc;
+		xor_hw_desc->ops[src_idx].l = addrl;
+		xor_hw_desc->ops[src_idx].h |= addrh;
+		break;
+	}
+}
+
+/**
+ * ppc4xx_desc_set_src_mult - set source address mult into the descriptor
+ */
+static inline void ppc4xx_desc_set_src_mult(struct ppc4xx_adma_desc_slot *desc,
+					    struct ppc4xx_adma_chan *chan,
+					    u32 mult_index, int sg_index,
+					    unsigned char mult_value)
+{
+	struct dma_cdb *dma_hw_desc;
+	struct xor_cb *xor_hw_desc;
+	u32 *psgu;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_hw_desc = desc->hw_desc;
+
+		switch (sg_index) {
+			/* for RXOR operations set multiplier
+			 * into source cued address
+			 */
+		case DMA_CDB_SG_SRC:
+			psgu = &dma_hw_desc->sg1u;
+			break;
+			/* for WXOR operations set multiplier
+			 * into destination cued address(es)
+			 */
+		case DMA_CDB_SG_DST1:
+			psgu = &dma_hw_desc->sg2u;
+			break;
+		case DMA_CDB_SG_DST2:
+			psgu = &dma_hw_desc->sg3u;
+			break;
+		default:
+			BUG();
+		}
+
+		*psgu |= cpu_to_le32(mult_value << mult_index);
+		break;
+	case PPC4XX_XOR_ID:
+		xor_hw_desc = desc->hw_desc;
+		break;
+	default:
+		BUG();
+	}
+}
+
+/******************************************************************************
+ * ADMA channel low-level routines
+ ******************************************************************************/
+
+static void ppc4xx_adma_device_clear_eot_status(struct ppc4xx_adma_chan *chan);
+static inline int ppc4xx_adma_dma2rxor_prep_src(struct ppc4xx_adma_desc_slot
+						*hdesc,
+						struct ppc4xx_rxor *cursor,
+						int index, int src_cnt,
+						u32 addr);
+
+static int ppc4xx_chan_is_busy(struct ppc4xx_adma_chan *chan);
+static void ppc4xx_chan_set_first_xor_descriptor(struct ppc4xx_adma_chan *chan, struct ppc4xx_adma_desc_slot
+						 *next_desc);
+/**
+ * ppc4xx_chan_get_current_descriptor - get the currently executed descriptor
+ */
+static inline u32 ppc4xx_chan_get_current_descriptor(struct ppc4xx_adma_chan
+						     *chan)
+{
+	struct dma_regs *dma_reg;
+	struct xor_regs *xor_reg;
+
+	if (unlikely(!chan->hw_chain_inited))
+		/* h/w descriptor chain is not initialized yet */
+		return 0;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_reg = chan->device->dma_reg;
+		return ioread32(&dma_reg->acpl) & (~DMA_CDB_MSK);
+	case PPC4XX_XOR_ID:
+		xor_reg = chan->device->xor_reg;
+		return ioread32be(&xor_reg->ccbalr);
+	}
+	return 0;
+}
+
+static void ppc4xx_chan_run(struct ppc4xx_adma_chan *chan);
+/**
+ * ppc4xx_adma_clean_slot - clean up CDB slot (if ack is set)
+ */
+static inline int ppc4xx_adma_clean_slot(struct ppc4xx_adma_desc_slot *desc,
+					 struct ppc4xx_adma_chan *chan)
+{
+	/* the client is allowed to attach dependent operations
+	 * until 'ack' is set
+	 */
+	if (!async_tx_test_ack(&desc->async_tx))
+		return 0;
+
+	/* leave the last descriptor in the chain
+	 * so we can append to it
+	 */
+	if (list_is_last(&desc->chain_node, &chan->chain) ||
+	    desc->phys == ppc4xx_chan_get_current_descriptor(chan))
+		return 1;
+
+	if (chan->device->id != PPC4XX_XOR_ID) {
+		/* our DMA interrupt handler clears opc field of
+		 * each processed descriptor. For all types of
+		 * operations except for ZeroSum we do not actually
+		 * need ack from the interrupt handler. ZeroSum is a
+		 * special case since the result of this operation
+		 * is available from the handler only, so if we see
+		 * such type of descriptor (which is unprocessed yet)
+		 * then leave it in chain.
+		 */
+		struct dma_cdb *cdb = desc->hw_desc;
+		if (cdb->opc == DMA_CDB_OPC_DCHECK128)
+			return 1;
+	}
+
+	dev_dbg(chan->device->common.dev, "\tfree slot %llx: %d stride: %d\n",
+		desc->phys, desc->idx, desc->slots_per_op);
+
+	list_del(&desc->chain_node);
+	ppc4xx_adma_free_slots(desc, chan);
+	return 0;
+}
+
+/**
+ * ppc4xx_rxor_set_region_data -
+ */
+static inline void ppc4xx_rxor_set_region(struct ppc4xx_adma_desc_slot *desc,
+					  u8 xor_arg_no, u32 mask)
+{
+	struct xor_cb *xcb = desc->hw_desc;
+
+	xcb->ops[xor_arg_no].h |= mask;
+}
+
+/**
+ * ppc4xx_rxor_set_src -
+ */
+static inline void ppc4xx_rxor_set_src(struct ppc4xx_adma_desc_slot *desc,
+				       u8 xor_arg_no, dma_addr_t addr)
+{
+	struct xor_cb *xcb = desc->hw_desc;
+
+	xcb->ops[xor_arg_no].h |= DMA_CUED_XOR_BASE;
+	xcb->ops[xor_arg_no].l = addr;
+}
+
+/**
+ * ppc4xx_rxor_set_mult -
+ */
+static inline void ppc4xx_rxor_set_mult(struct ppc4xx_adma_desc_slot *desc,
+					u8 xor_arg_no, u8 idx, u8 mult)
+{
+	struct xor_cb *xcb = desc->hw_desc;
+
+	xcb->ops[xor_arg_no].h |= mult << (DMA_CUED_MULT1_OFF + idx * 8);
+}
+
+/**
+ * ppc4xx_adma_dma2rxor_set_src - set RXOR source address; it's assumed that
+ *	ppc4xx_adma_dma2rxor_prep_src() has already done prior this call
+ */
+static inline void ppc4xx_adma_dma2rxor_set_src(struct ppc4xx_adma_desc_slot
+						*desc, int index,
+						dma_addr_t addr)
+{
+	struct xor_cb *xcb = desc->hw_desc;
+	int k = 0, op = 0, lop = 0;
+
+	/* get the RXOR operand which corresponds to index addr */
+	while (op <= index) {
+		lop = op;
+		if (k == XOR_MAX_OPS) {
+			k = 0;
+			desc = list_entry(desc->chain_node.next,
+					  struct ppc4xx_adma_desc_slot,
+					  chain_node);
+			xcb = desc->hw_desc;
+
+		}
+		if ((xcb->ops[k++].h & (DMA_RXOR12 << DMA_CUED_REGION_OFF)) ==
+		    (DMA_RXOR12 << DMA_CUED_REGION_OFF))
+			op += 2;
+		else
+			op += 3;
+	}
+
+	BUG_ON(k < 1);
+
+	if (test_bit(k - 1, desc->reverse_flags)) {
+		/* reverse operand order; put last op in RXOR group */
+		if (index == op - 1)
+			ppc4xx_rxor_set_src(desc, k - 1, addr);
+	} else {
+		/* direct operand order; put first op in RXOR group */
+		if (index == lop)
+			ppc4xx_rxor_set_src(desc, k - 1, addr);
+	}
+}
+
+/**
+ * ppc4xx_adma_pq_set_src - set source address into descriptor
+ */
+static inline void ppc4xx_adma_pq_set_src(struct ppc4xx_adma_desc_slot *sw_desc,
+					  dma_addr_t addr, int index)
+{
+	struct ppc4xx_adma_chan *chan;
+	dma_addr_t haddr = 0;
+	struct ppc4xx_adma_desc_slot *iter = NULL;
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* DMA0,1 may do: WXOR, RXOR, RXOR+WXORs chain
+		 */
+		if (test_bit(PPC4XX_DESC_RXOR, &sw_desc->flags)) {
+			/* RXOR-only or RXOR/WXOR operation */
+			int iskip = test_bit(PPC4XX_DESC_RXOR12,
+					     &sw_desc->flags) ? 2 : 3;
+
+			if (index == 0) {
+				/* 1st slot (RXOR) */
+				/* setup sources region (R1-2-3, R1-2-4,
+				 * or R1-2-5)
+				 */
+				if (test_bit(PPC4XX_DESC_RXOR12,
+					     &sw_desc->flags))
+					haddr = DMA_RXOR12 <<
+					    DMA_CUED_REGION_OFF;
+				else if (test_bit(PPC4XX_DESC_RXOR123,
+						  &sw_desc->flags))
+					haddr = DMA_RXOR123 <<
+					    DMA_CUED_REGION_OFF;
+				else if (test_bit(PPC4XX_DESC_RXOR124,
+						  &sw_desc->flags))
+					haddr = DMA_RXOR124 <<
+					    DMA_CUED_REGION_OFF;
+				else if (test_bit(PPC4XX_DESC_RXOR125,
+						  &sw_desc->flags))
+					haddr = DMA_RXOR125 <<
+					    DMA_CUED_REGION_OFF;
+				else
+					BUG();
+				haddr |= DMA_CUED_XOR_BASE;
+				iter = ppc4xx_get_group_entry(sw_desc, 0);
+			} else if (index < iskip) {
+				/* 1st slot (RXOR)
+				 * shall actually set source address only once
+				 * instead of first <iskip>
+				 */
+				iter = NULL;
+			} else {
+				/* 2nd/3d and next slots (WXOR);
+				 * skip first slot with RXOR
+				 */
+				haddr = DMA_CUED_XOR_HB;
+				iter = ppc4xx_get_group_entry(sw_desc,
+							      index - iskip +
+							      sw_desc->dst_cnt);
+			}
+		} else {
+			int znum = 0;
+
+			/* WXOR-only operation; skip first slots with
+			 * zeroing destinations
+			 */
+			if (test_bit(PPC4XX_ZERO_P, &sw_desc->flags))
+				znum++;
+			if (test_bit(PPC4XX_ZERO_Q, &sw_desc->flags))
+				znum++;
+
+			haddr = DMA_CUED_XOR_HB;
+			iter = ppc4xx_get_group_entry(sw_desc, index + znum);
+		}
+
+		if (likely(iter)) {
+			ppc4xx_desc_set_src_addr(iter, chan, 0, haddr, addr);
+
+			if (!index &&
+			    test_bit(PPC4XX_DESC_RXOR, &sw_desc->flags) &&
+			    sw_desc->dst_cnt == 2) {
+				/* if we have two destinations for RXOR, then
+				 * setup source in the second descr too
+				 */
+				iter = ppc4xx_get_group_entry(sw_desc, 1);
+				ppc4xx_desc_set_src_addr(iter, chan, 0,
+							 haddr, addr);
+			}
+		}
+		break;
+
+	case PPC4XX_XOR_ID:
+		/* DMA2 may do Biskup */
+		iter = sw_desc->group_head;
+		if (iter->dst_cnt == 2) {
+			/* both P & Q calculations required; set P src here */
+			ppc4xx_adma_dma2rxor_set_src(iter, index, addr);
+
+			/* this is for Q */
+			iter = ppc4xx_get_group_entry(sw_desc,
+						      sw_desc->descs_per_op);
+		}
+		ppc4xx_adma_dma2rxor_set_src(iter, index, addr);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_adma_dma2rxor_set_mult - set RXOR multipliers; it's assumed that
+ *	ppc4xx_adma_dma2rxor_prep_src() has already done prior this call
+ */
+static inline void ppc4xx_adma_dma2rxor_set_mult(struct ppc4xx_adma_desc_slot
+						 *desc, int index, u8 mult)
+{
+	struct xor_cb *xcb = desc->hw_desc;
+	int k = 0, op = 0, lop = 0;
+
+	/* get the RXOR operand which corresponds to index mult */
+	while (op <= index) {
+		lop = op;
+		if (k == XOR_MAX_OPS) {
+			k = 0;
+			desc = list_entry(desc->chain_node.next,
+					  struct ppc4xx_adma_desc_slot,
+					  chain_node);
+			xcb = desc->hw_desc;
+
+		}
+		if ((xcb->ops[k++].h & (DMA_RXOR12 << DMA_CUED_REGION_OFF)) ==
+		    (DMA_RXOR12 << DMA_CUED_REGION_OFF))
+			op += 2;
+		else
+			op += 3;
+	}
+
+	BUG_ON(k < 1);
+	if (test_bit(k - 1, desc->reverse_flags)) {
+		/* reverse order */
+		ppc4xx_rxor_set_mult(desc, k - 1, op - index - 1, mult);
+	} else {
+		/* direct order */
+		ppc4xx_rxor_set_mult(desc, k - 1, index - lop, mult);
+	}
+}
+
+/**
+ * ppc4xx_adma_pq_set_src_mult - set multiplication coefficient into
+ * descriptor for the PQXOR operation
+ */
+static inline void ppc4xx_adma_pq_set_src_mult(struct ppc4xx_adma_desc_slot
+					       *sw_desc, unsigned char mult,
+					       int index, int dst_pos)
+{
+	struct ppc4xx_adma_chan *chan;
+	u32 mult_idx, mult_dst;
+	struct ppc4xx_adma_desc_slot *iter = NULL, *iter1 = NULL;
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		if (test_bit(PPC4XX_DESC_RXOR, &sw_desc->flags)) {
+			int region = test_bit(PPC4XX_DESC_RXOR12,
+					      &sw_desc->flags) ? 2 : 3;
+
+			if (index < region) {
+				/* RXOR multipliers */
+				iter = ppc4xx_get_group_entry(sw_desc,
+							      sw_desc->
+							      dst_cnt - 1);
+				if (sw_desc->dst_cnt == 2)
+					iter1 =
+					    ppc4xx_get_group_entry(sw_desc, 0);
+
+				mult_idx = DMA_CUED_MULT1_OFF + (index << 3);
+				mult_dst = DMA_CDB_SG_SRC;
+			} else {
+				/* WXOR multiplier */
+				iter = ppc4xx_get_group_entry(sw_desc,
+							      index -
+							      region +
+							      sw_desc->dst_cnt);
+				mult_idx = DMA_CUED_MULT1_OFF;
+				mult_dst = dst_pos ? DMA_CDB_SG_DST2 :
+				    DMA_CDB_SG_DST1;
+			}
+		} else {
+			int znum = 0;
+
+			/* WXOR-only;
+			 * skip first slots with destinations (if ZERO_DST has
+			 * place)
+			 */
+			if (test_bit(PPC4XX_ZERO_P, &sw_desc->flags))
+				znum++;
+			if (test_bit(PPC4XX_ZERO_Q, &sw_desc->flags))
+				znum++;
+
+			iter = ppc4xx_get_group_entry(sw_desc, index + znum);
+			mult_idx = DMA_CUED_MULT1_OFF;
+			mult_dst = dst_pos ? DMA_CDB_SG_DST2 : DMA_CDB_SG_DST1;
+		}
+
+		if (likely(iter)) {
+			ppc4xx_desc_set_src_mult(iter, chan,
+						 mult_idx, mult_dst, mult);
+
+			if (unlikely(iter1)) {
+				/* if we have two destinations for RXOR, then
+				 * we've just set Q mult. Set-up P now.
+				 */
+				ppc4xx_desc_set_src_mult(iter1, chan,
+							 mult_idx, mult_dst, 1);
+			}
+
+		}
+		break;
+
+	case PPC4XX_XOR_ID:
+		iter = sw_desc->group_head;
+		if (sw_desc->dst_cnt == 2) {
+			/* both P & Q calculations required; set P mult here */
+			ppc4xx_adma_dma2rxor_set_mult(iter, index, 1);
+
+			/* and then set Q mult */
+			iter = ppc4xx_get_group_entry(sw_desc,
+						      sw_desc->descs_per_op);
+		}
+		ppc4xx_adma_dma2rxor_set_mult(iter, index, mult);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_adma_pq_zero_sum_set_dest - set destination address into descriptor
+ * for the PQ_ZERO_SUM operation
+ */
+static inline void ppc4xx_adma_pqzero_sum_set_dest(struct ppc4xx_adma_desc_slot
+						   *sw_desc, dma_addr_t paddr,
+						   dma_addr_t qaddr)
+{
+	struct ppc4xx_adma_desc_slot *iter, *end;
+	struct ppc4xx_adma_chan *chan;
+	dma_addr_t addr = 0;
+	int idx;
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+
+	/* walk through the WXOR source list and set P/Q-destinations
+	 * for each slot
+	 */
+	idx = (paddr && qaddr) ? 2 : 1;
+	/* set end */
+	list_for_each_entry_reverse(end, &sw_desc->group_list, chain_node) {
+		if (!(--idx))
+			break;
+	}
+	/* set start */
+	idx = (paddr && qaddr) ? 2 : 1;
+	iter = ppc4xx_get_group_entry(sw_desc, idx);
+
+	if (paddr && qaddr) {
+		/* two destinations */
+		list_for_each_entry_from(iter, &sw_desc->group_list, chain_node) {
+			if (unlikely(iter == end))
+				break;
+			ppc4xx_desc_set_dest_addr(iter, chan,
+						  DMA_CUED_XOR_BASE, paddr, 0);
+			ppc4xx_desc_set_dest_addr(iter, chan,
+						  DMA_CUED_XOR_BASE, qaddr, 1);
+		}
+	} else {
+		/* one destination */
+		addr = paddr ? paddr : qaddr;
+		list_for_each_entry_from(iter, &sw_desc->group_list, chain_node) {
+			if (unlikely(iter == end))
+				break;
+			ppc4xx_desc_set_dest_addr(iter, chan,
+						  DMA_CUED_XOR_BASE, addr, 0);
+		}
+	}
+
+	/*  The remaining descriptors are DATACHECK. These have no need in
+	 * destination. Actually, these destinations are used there
+	 * as sources for check operation. So, set addr as source.
+	 */
+	ppc4xx_desc_set_src_addr(end, chan, 0, 0, addr ? addr : paddr);
+
+	if (!addr) {
+		end = list_entry(end->chain_node.next,
+				 struct ppc4xx_adma_desc_slot, chain_node);
+		ppc4xx_desc_set_src_addr(end, chan, 0, 0, qaddr);
+	}
+}
+
+static inline void ppc4xx_adma_pq_zero_op(struct ppc4xx_adma_desc_slot *iter,
+					  struct ppc4xx_adma_chan *chan,
+					  dma_addr_t addr)
+{
+	/*  To clear destinations update the descriptor
+	 * (P or Q depending on index) as follows:
+	 * addr is destination (0 corresponds to SG2):
+	 */
+	ppc4xx_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE, addr, 0);
+
+	/* ... and the addr is source: */
+	ppc4xx_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB, addr);
+
+	/* addr is always SG2 then the mult is always DST1 */
+	ppc4xx_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+				 DMA_CDB_SG_DST1, 1);
+}
+
+/**
+ * ppc4xx_adma_pq_set_dest - set destination address into descriptor
+ * for the PQXOR operation
+ */
+static inline void ppc4xx_adma_pq_set_dest(struct ppc4xx_adma_desc_slot
+					   *sw_desc, dma_addr_t * addrs,
+					   unsigned long flags)
+{
+	struct ppc4xx_adma_desc_slot *iter;
+	struct ppc4xx_adma_chan *chan;
+	dma_addr_t paddr, qaddr;
+	dma_addr_t addr = 0, ppath, qpath;
+	int index = 0, i;
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		paddr = 0;
+	else
+		paddr = addrs[0];
+
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		qaddr = 0;
+	else
+		qaddr = addrs[1];
+
+	if (!paddr || !qaddr)
+		addr = paddr ? paddr : qaddr;
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* walk through the WXOR source list and set P/Q-destinations
+		 * for each slot:
+		 */
+		if (!test_bit(PPC4XX_DESC_RXOR, &sw_desc->flags)) {
+			/* This is WXOR-only chain; may have 1/2 zero descs */
+			if (test_bit(PPC4XX_ZERO_P, &sw_desc->flags))
+				index++;
+			if (test_bit(PPC4XX_ZERO_Q, &sw_desc->flags))
+				index++;
+
+			iter = ppc4xx_get_group_entry(sw_desc, index);
+			if (addr) {
+				/* one destination */
+				list_for_each_entry_from(iter,
+							 &sw_desc->group_list,
+							 chain_node)
+				    ppc4xx_desc_set_dest_addr(iter, chan,
+							      DMA_CUED_XOR_BASE,
+							      addr, 0);
+			} else {
+				/* two destinations */
+				list_for_each_entry_from(iter,
+							 &sw_desc->group_list,
+							 chain_node) {
+					ppc4xx_desc_set_dest_addr(iter, chan,
+								  DMA_CUED_XOR_BASE,
+								  paddr, 0);
+					ppc4xx_desc_set_dest_addr(iter, chan,
+								  DMA_CUED_XOR_BASE,
+								  qaddr, 1);
+				}
+			}
+
+			if (index) {
+				/*  To clear destinations update the descriptor
+				 * (1st,2nd, or both depending on flags)
+				 */
+				index = 0;
+				if (test_bit(PPC4XX_ZERO_P, &sw_desc->flags)) {
+					iter =
+					    ppc4xx_get_group_entry(sw_desc,
+								   index++);
+					ppc4xx_adma_pq_zero_op(iter, chan,
+							       paddr);
+				}
+
+				if (test_bit(PPC4XX_ZERO_Q, &sw_desc->flags)) {
+					iter =
+					    ppc4xx_get_group_entry(sw_desc,
+								   index++);
+					ppc4xx_adma_pq_zero_op(iter, chan,
+							       qaddr);
+				}
+
+				return;
+			}
+		} else {
+			/* This is RXOR-only or RXOR/WXOR mixed chain */
+
+			/* If we want to include destination into calculations,
+			 * then make dest addresses cued with mult=1 (XOR).
+			 */
+			ppath = test_bit(PPC4XX_ZERO_P, &sw_desc->flags) ?
+			    DMA_CUED_XOR_HB :
+			    DMA_CUED_XOR_BASE | (1 << DMA_CUED_MULT1_OFF);
+			qpath = test_bit(PPC4XX_ZERO_Q, &sw_desc->flags) ?
+			    DMA_CUED_XOR_HB :
+			    DMA_CUED_XOR_BASE | (1 << DMA_CUED_MULT1_OFF);
+
+			/* Setup destination(s) in RXOR slot(s) */
+			iter = ppc4xx_get_group_entry(sw_desc, index++);
+			ppc4xx_desc_set_dest_addr(iter, chan,
+						  paddr ? ppath : qpath,
+						  paddr ? paddr : qaddr, 0);
+			if (!addr) {
+				/* two destinations */
+				iter = ppc4xx_get_group_entry(sw_desc, index++);
+				ppc4xx_desc_set_dest_addr(iter, chan,
+							  qpath, qaddr, 0);
+			}
+
+			if (test_bit(PPC4XX_DESC_WXOR, &sw_desc->flags)) {
+				/* Setup destination(s) in remaining WXOR
+				 * slots
+				 */
+				iter = ppc4xx_get_group_entry(sw_desc, index);
+				if (addr) {
+					/* one destination */
+					list_for_each_entry_from(iter,
+								 &sw_desc->
+								 group_list,
+								 chain_node)
+					    ppc4xx_desc_set_dest_addr(iter,
+								      chan,
+								      DMA_CUED_XOR_BASE,
+								      addr, 0);
+
+				} else {
+					/* two destinations */
+					list_for_each_entry_from(iter,
+								 &sw_desc->
+								 group_list,
+								 chain_node) {
+						ppc4xx_desc_set_dest_addr
+						    (iter, chan,
+						     DMA_CUED_XOR_BASE, paddr,
+						     0);
+						ppc4xx_desc_set_dest_addr
+						    (iter, chan,
+						     DMA_CUED_XOR_BASE, qaddr,
+						     1);
+					}
+				}
+			}
+
+		}
+		break;
+
+	case PPC4XX_XOR_ID:
+		/* DMA2 descriptors have only 1 destination, so there are
+		 * two chains - one for each dest.
+		 * If we want to include destination into calculations,
+		 * then make dest addresses cued with mult=1 (XOR).
+		 */
+		ppath = test_bit(PPC4XX_ZERO_P, &sw_desc->flags) ?
+		    DMA_CUED_XOR_HB :
+		    DMA_CUED_XOR_BASE | (1 << DMA_CUED_MULT1_OFF);
+
+		qpath = test_bit(PPC4XX_ZERO_Q, &sw_desc->flags) ?
+		    DMA_CUED_XOR_HB :
+		    DMA_CUED_XOR_BASE | (1 << DMA_CUED_MULT1_OFF);
+
+		iter = ppc4xx_get_group_entry(sw_desc, 0);
+		for (i = 0; i < sw_desc->descs_per_op; i++) {
+			ppc4xx_desc_set_dest_addr(iter, chan,
+						  paddr ? ppath : qpath,
+						  paddr ? paddr : qaddr, 0);
+			iter = list_entry(iter->chain_node.next,
+					  struct ppc4xx_adma_desc_slot,
+					  chain_node);
+		}
+
+		if (!addr) {
+			/* Two destinations; setup Q here */
+			iter = ppc4xx_get_group_entry(sw_desc,
+						      sw_desc->descs_per_op);
+			for (i = 0; i < sw_desc->descs_per_op; i++) {
+				ppc4xx_desc_set_dest_addr(iter,
+							  chan, qpath, qaddr,
+							  0);
+				iter =
+				    list_entry(iter->chain_node.next,
+					       struct ppc4xx_adma_desc_slot,
+					       chain_node);
+			}
+		}
+
+		break;
+	}
+}
+
+/**
+ * ppc4xx_dma2_pq_slot_count - get the number of slots necessary for
+ * DMA2 PQ operation
+ */
+static inline int ppc4xx_dma2_pq_slot_count(dma_addr_t * srcs, int src_cnt,
+					    size_t len)
+{
+	signed long long order = 0;
+	int state = 0;
+	int addr_count = 0;
+	int i;
+	for (i = 1; i < src_cnt; i++) {
+		dma_addr_t cur_addr = srcs[i];
+		dma_addr_t old_addr = srcs[i - 1];
+		switch (state) {
+		case 0:
+			if (cur_addr == old_addr + len) {
+				/* direct RXOR */
+				order = 1;
+				state = 1;
+				if (i == src_cnt - 1)
+					addr_count++;
+			} else if (old_addr == cur_addr + len) {
+				/* reverse RXOR */
+				order = -1;
+				state = 1;
+				if (i == src_cnt - 1)
+					addr_count++;
+			} else {
+				state = 3;
+			}
+			break;
+		case 1:
+			if (i == src_cnt - 2 || (order == -1
+						 && cur_addr !=
+						 old_addr - len)) {
+				order = 0;
+				state = 0;
+				addr_count++;
+			} else if (cur_addr == old_addr + len * order) {
+				state = 2;
+				if (i == src_cnt - 1)
+					addr_count++;
+			} else if (cur_addr == old_addr + 2 * len) {
+				state = 2;
+				if (i == src_cnt - 1)
+					addr_count++;
+			} else if (cur_addr == old_addr + 3 * len) {
+				state = 2;
+				if (i == src_cnt - 1)
+					addr_count++;
+			} else {
+				order = 0;
+				state = 0;
+				addr_count++;
+			}
+			break;
+		case 2:
+			order = 0;
+			state = 0;
+			addr_count++;
+			break;
+		}
+		if (state == 3)
+			break;
+	}
+	if (src_cnt <= 1 || (state != 1 && state != 2)) {
+		pr_err("%s: src_cnt=%d, state=%d, addr_count=%d, order=%lld\n",
+		       __func__, src_cnt, state, addr_count, order);
+		for (i = 0; i < src_cnt; i++)
+			pr_err("\t[%d] 0x%llx \n", i, srcs[i]);
+		BUG();
+	}
+
+	return (addr_count + XOR_MAX_OPS - 1) / XOR_MAX_OPS;
+}
+
+/**
+ * ppc4xx_adma_set_dest - set destination address into descriptor
+ */
+static inline void ppc4xx_adma_set_dest(struct ppc4xx_adma_desc_slot *sw_desc,
+					dma_addr_t addr, int index)
+{
+	struct ppc4xx_adma_chan *chan;
+
+	BUG_ON(index >= sw_desc->dst_cnt);
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+
+	switch (chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		/* to do: support transfers lengths >
+		 * ppc4xx_adma_DMA/XOR_MAX_BYTE_COUNT
+		 */
+		ppc4xx_desc_set_dest_addr(sw_desc->group_head,
+					  chan, 0, addr, index);
+		break;
+	case PPC4XX_XOR_ID:
+		sw_desc = ppc4xx_get_group_entry(sw_desc, index);
+		ppc4xx_desc_set_dest_addr(sw_desc, chan, 0, addr, index);
+		break;
+	}
+}
+
+/**
+ * ppc4xx_desc_set_xor_src_cnt - set source count into descriptor
+ */
+static inline void ppc4xx_desc_set_xor_src_cnt(struct ppc4xx_adma_desc_slot
+					       *desc, int src_cnt)
+{
+	struct xor_cb *hw_desc = desc->hw_desc;
+
+	hw_desc->cbc &= ~XOR_CDCR_OAC_MSK;
+	hw_desc->cbc |= src_cnt;
+}
+
+/**
+ * ppc4xx_adma_memcpy_xor_set_src - set source address into descriptor
+ */
+static inline void ppc4xx_adma_memcpy_xor_set_src(struct ppc4xx_adma_desc_slot
+						  *sw_desc, dma_addr_t addr,
+						  int index)
+{
+	struct ppc4xx_adma_chan *chan;
+
+	chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+	sw_desc = sw_desc->group_head;
+
+	if (likely(sw_desc))
+		ppc4xx_desc_set_src_addr(sw_desc, chan, index, 0, addr);
+}
+
+/**
+ * ppc4xx_adma_dma2rxor_inc_addr  -
+ */
+static inline void ppc4xx_adma_dma2rxor_inc_addr(struct ppc4xx_adma_desc_slot
+						 *desc,
+						 struct ppc4xx_rxor *cursor,
+						 int index, int src_cnt)
+{
+	cursor->addr_count++;
+	if (index == src_cnt - 1) {
+		ppc4xx_desc_set_xor_src_cnt(desc, cursor->addr_count);
+	} else if (cursor->addr_count == XOR_MAX_OPS) {
+		ppc4xx_desc_set_xor_src_cnt(desc, cursor->addr_count);
+		cursor->addr_count = 0;
+		cursor->desc_count++;
+	}
+}
+
+/**
+ * ppc4xx_adma_dma2rxor_prep_src - setup RXOR types in DMA2 CDB
+ */
+static inline int ppc4xx_adma_dma2rxor_prep_src(struct ppc4xx_adma_desc_slot
+						*hdesc,
+						struct ppc4xx_rxor *cursor,
+						int index, int src_cnt,
+						u32 addr)
+{
+	int rval = 0;
+	u32 sign;
+	struct ppc4xx_adma_desc_slot *desc = hdesc;
+	int i;
+
+	for (i = 0; i < cursor->desc_count; i++) {
+		desc = list_entry(hdesc->chain_node.next,
+				  struct ppc4xx_adma_desc_slot, chain_node);
+	}
+
+	switch (cursor->state) {
+	case 0:
+		if (addr == cursor->addrl + cursor->len) {
+			/* direct RXOR */
+			cursor->state = 1;
+			cursor->xor_count++;
+			if (index == src_cnt - 1) {
+				ppc4xx_rxor_set_region(desc,
+						       cursor->addr_count,
+						       DMA_RXOR12 <<
+						       DMA_CUED_REGION_OFF);
+				ppc4xx_adma_dma2rxor_inc_addr(desc, cursor,
+							      index, src_cnt);
+			}
+		} else if (cursor->addrl == addr + cursor->len) {
+			/* reverse RXOR */
+			cursor->state = 1;
+			cursor->xor_count++;
+			set_bit(cursor->addr_count, &desc->reverse_flags[0]);
+			if (index == src_cnt - 1) {
+				ppc4xx_rxor_set_region(desc,
+						       cursor->addr_count,
+						       DMA_RXOR12 <<
+						       DMA_CUED_REGION_OFF);
+				ppc4xx_adma_dma2rxor_inc_addr(desc, cursor,
+							      index, src_cnt);
+			}
+		} else {
+			printk(KERN_ERR "Cannot build "
+			       "DMA2 RXOR command block.\n");
+			BUG();
+		}
+		break;
+	case 1:
+		sign = test_bit(cursor->addr_count, desc->reverse_flags)
+		    ? -1 : 1;
+		if (index == src_cnt - 2 || (sign == -1
+					     && addr !=
+					     cursor->addrl - 2 * cursor->len)) {
+			cursor->state = 0;
+			cursor->xor_count = 1;
+			cursor->addrl = addr;
+			ppc4xx_rxor_set_region(desc,
+					       cursor->addr_count,
+					       DMA_RXOR12 <<
+					       DMA_CUED_REGION_OFF);
+			ppc4xx_adma_dma2rxor_inc_addr(desc, cursor, index,
+						      src_cnt);
+		} else if (addr == cursor->addrl + 2 * sign * cursor->len) {
+			cursor->state = 2;
+			cursor->xor_count = 0;
+			ppc4xx_rxor_set_region(desc,
+					       cursor->addr_count,
+					       DMA_RXOR123 <<
+					       DMA_CUED_REGION_OFF);
+			if (index == src_cnt - 1) {
+				ppc4xx_adma_dma2rxor_inc_addr(desc, cursor,
+							      index, src_cnt);
+			}
+		} else if (addr == cursor->addrl + 3 * cursor->len) {
+			cursor->state = 2;
+			cursor->xor_count = 0;
+			ppc4xx_rxor_set_region(desc,
+					       cursor->addr_count,
+					       DMA_RXOR124 <<
+					       DMA_CUED_REGION_OFF);
+			if (index == src_cnt - 1) {
+				ppc4xx_adma_dma2rxor_inc_addr(desc, cursor,
+							      index, src_cnt);
+			}
+		} else if (addr == cursor->addrl + 4 * cursor->len) {
+			cursor->state = 2;
+			cursor->xor_count = 0;
+			ppc4xx_rxor_set_region(desc,
+					       cursor->addr_count,
+					       DMA_RXOR125 <<
+					       DMA_CUED_REGION_OFF);
+			if (index == src_cnt - 1) {
+				ppc4xx_adma_dma2rxor_inc_addr(desc, cursor,
+							      index, src_cnt);
+			}
+		} else {
+			cursor->state = 0;
+			cursor->xor_count = 1;
+			cursor->addrl = addr;
+			ppc4xx_rxor_set_region(desc,
+					       cursor->addr_count,
+					       DMA_RXOR12 <<
+					       DMA_CUED_REGION_OFF);
+			ppc4xx_adma_dma2rxor_inc_addr(desc, cursor, index,
+						      src_cnt);
+		}
+		break;
+	case 2:
+		cursor->state = 0;
+		cursor->addrl = addr;
+		cursor->xor_count++;
+		if (index) {
+			ppc4xx_adma_dma2rxor_inc_addr(desc, cursor, index,
+						      src_cnt);
+		}
+		break;
+	}
+
+	return rval;
+}
+
+static void ppc4xx_adma_set_dest(struct ppc4xx_adma_desc_slot *sw_desc,
+				 dma_addr_t addr, int index);
+static void ppc4xx_adma_memcpy_xor_set_src(struct ppc4xx_adma_desc_slot
+					   *sw_desc, dma_addr_t addr,
+					   int index);
+
+static inline void ppc4xx_free_ref(struct ppc4xx_adma_device *adev,
+				   struct platform_device *ofdev,
+				   struct ppc4xx_adma_chan *chan)
+{
+	if (adev->id != PPC4XX_XOR_ID) {
+		dma_unmap_page(&ofdev->dev, chan->pdest,
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_page(&ofdev->dev, chan->qdest,
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
+		__free_page(chan->pdest_page);
+		__free_page(chan->qdest_page);
+	}
+}
+static inline void ppc4xx_free_reg(struct ppc4xx_adma_device *adev)
+{
+	if (adev->id == PPC4XX_XOR_ID)
+		iounmap(adev->xor_reg);
+	else
+		iounmap(adev->dma_reg);
+}
+static inline int ppc4xx_get_cdb_size(struct ppc4xx_adma_chan *ppc4xx_chan)
+{
+	int db_sz;
+	if (ppc4xx_chan->device->id != PPC4XX_XOR_ID)
+		db_sz = sizeof(struct dma_cdb);
+	else
+		db_sz = sizeof(struct xor_cb);
+	return db_sz;
+}
+
+/*
+ * initialize the channel and the chain with a null operation
+ */
+static inline void ppc4xx_init_chan_null_op(struct ppc4xx_adma_chan
+					    *ppc4xx_chan)
+{
+	switch (ppc4xx_chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		ppc4xx_chan->hw_chain_inited = 0;
+		/* Use WXOR for self-testing */
+		if (!ppc4xx_r6_tchan)
+			ppc4xx_r6_tchan = ppc4xx_chan;
+		break;
+	case PPC4XX_XOR_ID:
+		ppc4xx_chan_start_null_xor(ppc4xx_chan);
+		break;
+	default:
+		BUG();
+	}
+}
+static inline int ppc4xx_adma_get_devid(struct platform_device *ofdev,
+					struct device_node *np)
+{
+	unsigned int id;
+	unsigned int len;
+	const unsigned int *idx;
+	if (of_device_is_compatible(np, "amcc,xor-accelerator")) {
+		id = PPC4XX_XOR_ID;
+	} else {
+		/* it is DMA0 or DMA1 */
+		idx = of_get_property(np, "cell-index", &len);
+		/* it is DMA0 or DMA1 */
+		if (!idx || (len != sizeof(u32))) {
+			dev_err(&ofdev->dev, "Device node %s has missing "
+				"or invalid cell-index property\n",
+				np->full_name);
+			return -EINVAL;
+		}
+		id = *idx;
+	}
+	return id;
+}
+static inline int ppc4xx_adma_get_pool_size(struct device_node *np, int id)
+{
+	unsigned int pool_size;
+	if (of_device_is_compatible(np, "amcc,xor-accelerator")) {
+		/* As far as the XOR engine is concerned, it does not
+		 * use FIFOs but uses linked list. So there is no dependency
+		 * between pool size to allocate and the engine configuration.
+		 */
+		pool_size = PAGE_SIZE << 1;
+	} else {
+		/* DMA0,1 engines use FIFO to maintain CDBs, so we
+		 * should allocate the pool accordingly to size of this
+		 * FIFO. Thus, the pool size depends on the FIFO depth:
+		 * how much CDBs pointers the FIFO may contain then so
+		 * much CDBs we should provide in the pool.
+		 * That is
+		 * CDB size = 32B;
+		 * CDBs number = (DMA0_FIFO_SIZE >> 3);
+		 * Pool size = CDBs number * CDB size =
+		 * = (DMA0_FIFO_SIZE >> 3) << 5 = DMA0_FIFO_SIZE << 2.
+		 */
+		pool_size = (id == PPC4XX_DMA0_ID) ?
+		    DMA0_FIFO_SIZE : DMA1_FIFO_SIZE;
+		pool_size <<= 2;
+	}
+	return pool_size;
+}
+static inline void ppc4xx_adma_init_hw(struct ppc4xx_adma_device *adev,
+				       void *regs)
+{
+	if (adev->id == PPC4XX_XOR_ID) {
+		adev->xor_reg = regs;
+		/* Reset XOR */
+		iowrite32be(XOR_CRSR_XASR_BIT, &adev->xor_reg->crsr);
+		iowrite32be(XOR_CRSR_64BA_BIT, &adev->xor_reg->crrr);
+	} else {
+		size_t fifo_size = (adev->id == PPC4XX_DMA0_ID) ?
+		    DMA0_FIFO_SIZE : DMA1_FIFO_SIZE;
+		adev->dma_reg = regs;
+		/* DMAx_FIFO_SIZE is defined in bytes,
+		 * <fsiz> - is defined in number of CDB pointers (8byte).
+		 * DMA FIFO Length = CSlength + CPlength, where
+		 * CSlength = CPlength = (fsiz + 1) * 8.
+		 */
+		iowrite32(DMA_FIFO_ENABLE | ((fifo_size >> 3) - 2),
+			  &adev->dma_reg->fsiz);
+		/* Configure DMA engine */
+		iowrite32(DMA_CFG_DXEPR_HP | DMA_CFG_DFMPP_HP | DMA_CFG_FALGN,
+			  &adev->dma_reg->cfg);
+		/* Clear Status */
+		iowrite32(~0, &adev->dma_reg->dsts);
+	}
+}
+static inline int ppc4xx_create_helper_pages(struct ppc4xx_adma_device *adev,
+					     struct platform_device *ofdev,
+					     struct ppc4xx_adma_chan *chan)
+{
+	int ret = 0;
+	/* allocate and map helper pages for async validation or
+	 * async_mult/async_sum_product operations on DMA0/1.
+	 */
+	if (adev->id != PPC4XX_XOR_ID) {
+		chan->pdest_page = alloc_page(GFP_KERNEL);
+		chan->qdest_page = alloc_page(GFP_KERNEL);
+		if (!chan->pdest_page || !chan->qdest_page) {
+			if (chan->pdest_page)
+				__free_page(chan->pdest_page);
+			if (chan->qdest_page)
+				__free_page(chan->qdest_page);
+			ret = -ENOMEM;
+			goto err_page_alloc;
+		}
+		chan->pdest = dma_map_page(&ofdev->dev, chan->pdest_page, 0,
+					   PAGE_SIZE, DMA_BIDIRECTIONAL);
+		chan->qdest = dma_map_page(&ofdev->dev, chan->qdest_page, 0,
+					   PAGE_SIZE, DMA_BIDIRECTIONAL);
+	}
+      err_page_alloc:
+	return ret;
+}
+
+#endif /*__PPC4XX_ADMA_H*/
-- 
1.6.1.rc3

