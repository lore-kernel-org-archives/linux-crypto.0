From: tmarri@apm.com
Subject: [PATCH v1 3/4] PPC4xx: New file with SoC specific functions
Date: Thu, 23 Sep 2010 15:11:46 -0700
Message-ID: <1285279906-16819-1-git-send-email-tmarri@apm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com, yur@emcraft.com,
	herbert@gondor.hengli.com.au, tmarri@apm.com
To: linux-raid@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:57539 "EHLO
	denmail01.apm.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754484Ab0IWWMJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 18:12:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tirumala Marri <tmarri@apm.com>

This patch creates new file with SoC dependent functions.

Signed-off-by: Tirumala R Marri <tmarri@apm.com>
---
V1:
  * Remove all 440SPe specific references.
  * Move some of the code from header file to c file.
---
 drivers/dma/ppc4xx/ppc4xx-adma.c | 1658 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 1658 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/ppc4xx/ppc4xx-adma.c

diff --git a/drivers/dma/ppc4xx/ppc4xx-adma.c b/drivers/dma/ppc4xx/ppc4xx-adma.c
new file mode 100644
index 0000000..5a5da23
--- /dev/null
+++ b/drivers/dma/ppc4xx/ppc4xx-adma.c
@@ -0,0 +1,1658 @@
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
+
+/*
+ * This driver supports the asynchrounous DMA copy and RAID engines available
+ * on the AMCC PPC440SPe Processors.
+ * Based on the Intel Xscale(R) family of I/O Processors (IOP 32x, 33x, 134x)
+ * ADMA driver written by D.Williams.
+ */
+
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <asm/dcr.h>
+#include <asm/dcr-regs.h>
+#include <linux/async_tx.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include "adma.h"
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+#include "ppc440spe-dma.h"
+#endif
+#include "ppc4xx-adma.h"
+
+/* This array is used in data-check operations for storing a pattern */
+static char ppc4xx_qword[16];
+static atomic_t ppc4xx_adma_err_irq_ref;
+static unsigned int ppc4xx_mq_dcr_len;
+
+/* These are used in enable & check routines
+ */
+static u32 ppc4xx_r6_enabled;
+static struct completion ppc4xx_r6_test_comp;
+
+static struct page *ppc4xx_rxor_srcs[32];
+
+static dcr_host_t ppc4xx_mq_dcr_host;
+/* Pointer to DMA0, DMA1 CP/CS FIFO */
+static void *ppc4xx_dma_fifo_buf;
+
+static char *ppc_adma_errors[] = {
+	[PPC_ADMA_INIT_OK] = "ok",
+	[PPC_ADMA_INIT_MEMRES] = "failed to get memory resource",
+	[PPC_ADMA_INIT_MEMREG] = "failed to request memory region",
+	[PPC_ADMA_INIT_ALLOC] = "failed to allocate memory for adev "
+	    "structure",
+	[PPC_ADMA_INIT_COHERENT] = "failed to allocate coherent memory for "
+	    "hardware descriptors",
+	[PPC_ADMA_INIT_CHANNEL] = "failed to allocate memory for channel",
+	[PPC_ADMA_INIT_IRQ1] = "failed to request first irq",
+	[PPC_ADMA_INIT_IRQ2] = "failed to request second irq",
+	[PPC_ADMA_INIT_REGISTER] = "failed to register dma async device",
+};
+
+static void ppc4xx_adma_dma2rxor_set_mult(struct ppc4xx_adma_desc_slot *desc,
+					  int index, u8 mult);
+static void print_cb_list(struct ppc4xx_adma_chan *chan,
+			  struct ppc4xx_adma_desc_slot *iter);
+/**
+ * ppc4xx_can_rxor - check if the operands may be processed with RXOR
+ */
+static int ppc4xx_can_rxor(struct page **srcs, int src_cnt, size_t len)
+{
+	int i, order = 0, state = 0;
+	int idx = 0;
+
+	if (unlikely(!(src_cnt > 1)))
+		return 0;
+
+	BUG_ON(src_cnt > ARRAY_SIZE(ppc4xx_rxor_srcs));
+
+	/* Skip holes in the source list before checking */
+	for (i = 0; i < src_cnt; i++) {
+		if (!srcs[i])
+			continue;
+		ppc4xx_rxor_srcs[idx++] = srcs[i];
+	}
+	src_cnt = idx;
+
+	for (i = 1; i < src_cnt; i++) {
+		char *cur_addr = page_address(ppc4xx_rxor_srcs[i]);
+		char *old_addr = page_address(ppc4xx_rxor_srcs[i - 1]);
+
+		switch (state) {
+		case 0:
+			if (cur_addr == old_addr + len) {
+				/* direct RXOR */
+				order = 1;
+				state = 1;
+			} else if (old_addr == cur_addr + len) {
+				/* reverse RXOR */
+				order = -1;
+				state = 1;
+			} else
+				goto out;
+			break;
+		case 1:
+			if ((i == src_cnt - 2) ||
+			    (order == -1 && cur_addr != old_addr - len)) {
+				order = 0;
+				state = 0;
+			} else if ((cur_addr == old_addr + len * order) ||
+				   (cur_addr == old_addr + 2 * len) ||
+				   (cur_addr == old_addr + 3 * len)) {
+				state = 2;
+			} else {
+				order = 0;
+				state = 0;
+			}
+			break;
+		case 2:
+			order = 0;
+			state = 0;
+			break;
+		}
+	}
+
+      out:
+	if (state == 1 || state == 2)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * ppc4xx_init_rxor_cursor -
+ */
+static void ppc4xx_init_rxor_cursor(struct ppc4xx_rxor *cursor)
+{
+	memset(cursor, 0, sizeof(struct ppc4xx_rxor));
+	cursor->state = 2;
+}
+
+/**
+ * ppc4xx_adma_init_dma2rxor_slot -
+ */
+static  void ppc4xx_adma_init_dma2rxor_slot(struct ppc4xx_adma_desc_slot
+						  *desc, dma_addr_t * src,
+						  int src_cnt)
+{
+	int i;
+
+	/* initialize CDB */
+	for (i = 0; i < src_cnt; i++) {
+		ppc4xx_adma_dma2rxor_prep_src(desc, &desc->rxor_cursor, i,
+					      desc->src_cnt, (u32) src[i]);
+	}
+}
+
+/******************************************************************************
+ * Command (Descriptor) Blocks low-level routines
+ ******************************************************************************/
+/**
+ * ppc4xx_desc_set_rxor_block_size - set RXOR block size
+ */
+static   void ppc4xx_desc_set_rxor_block_size(u32 byte_count)
+{
+	/* assume that byte_count is aligned on the 512-boundary;
+	 * thus write it directly to the register (bits 23:31 are
+	 * reserved there).
+	 */
+	dcr_write(ppc4xx_mq_dcr_host, DCRN_MQ0_CF2H, byte_count);
+}
+
+
+static int ppc4xx_adma_estimate(struct dma_chan *chan,
+				enum dma_transaction_type cap,
+				struct page **dst_lst, int dst_cnt,
+				struct page **src_lst, int src_cnt,
+				size_t src_sz)
+{
+	int ef = 1;
+
+	if (cap == DMA_PQ || cap == DMA_PQ_VAL) {
+		/* If RAID-6 capabilities were not activated don't try
+		 * to use them
+		 */
+		if (unlikely(!ppc4xx_r6_enabled))
+			return -1;
+	}
+	/*  In the current implementation of ppc4xx ADMA driver it
+	 * makes sense to pick out only pq case, because it may be
+	 * processed:
+	 * (1) either using Biskup method on DMA2;
+	 * (2) or on DMA0/1.
+	 *  Thus we give a favour to (1) if the sources are suitable;
+	 * else let it be processed on one of the DMA0/1 engines.
+	 *  In the sum_product case where destination is also the
+	 * source process it on DMA0/1 only.
+	 */
+	if (cap == DMA_PQ && chan->chan_id == PPC4XX_XOR_ID) {
+
+		if (dst_cnt == 1 && src_cnt == 2 && dst_lst[0] == src_lst[1])
+			ef = 0;	/* sum_product case, process on DMA0/1 */
+		else if (ppc4xx_can_rxor(src_lst, src_cnt, src_sz))
+			ef = 3;	/* override (DMA0/1 + idle) */
+		else
+			ef = 0;	/* can't process on DMA2 if !rxor */
+	}
+
+	/* channel idleness increases the priority */
+	if (likely(ef) && !ppc4xx_chan_is_busy(to_ppc4xx_adma_chan(chan)))
+		ef++;
+
+	return ef;
+}
+
+struct dma_chan *ppc4xx_async_tx_find_best_channel(enum dma_transaction_type cap,
+						      struct page **dst_lst,
+						      int dst_cnt,
+						      struct page **src_lst,
+						      int src_cnt,
+						      size_t src_sz)
+{
+	struct dma_chan *best_chan = NULL;
+	struct ppc_dma_chan_ref *ref;
+	int best_rank = -1;
+
+	if (unlikely(!src_sz))
+		return NULL;
+	if (src_sz > PAGE_SIZE) {
+		/*
+		 * should a user of the api ever pass > PAGE_SIZE requests
+		 * we sort out cases where temporary page-sized buffers
+		 * are used.
+		 */
+		switch (cap) {
+		case DMA_PQ:
+			if (src_cnt == 1 && dst_lst[1] == src_lst[0])
+				return NULL;
+			if (src_cnt == 2 && dst_lst[1] == src_lst[1])
+				return NULL;
+			break;
+		case DMA_PQ_VAL:
+		case DMA_XOR_VAL:
+			return NULL;
+		default:
+			break;
+		}
+	}
+
+	list_for_each_entry(ref, &ppc4xx_adma_chan_list, node) {
+		if (dma_has_cap(cap, ref->chan->device->cap_mask)) {
+			int rank;
+
+			rank = ppc4xx_adma_estimate(ref->chan, cap, dst_lst,
+						    dst_cnt, src_lst,
+						    src_cnt, src_sz);
+			if (rank > best_rank) {
+				best_rank = rank;
+				best_chan = ref->chan;
+			}
+		}
+	}
+
+	return best_chan;
+}
+
+EXPORT_SYMBOL_GPL(ppc4xx_async_tx_find_best_channel);
+
+/**
+ * ppc4xx_dma01_prep_sum_product -
+ * Dx = A*(P+Pxy) + B*(Q+Qxy) operation where destination is also
+ * the source.
+ */
+static  struct ppc4xx_adma_desc_slot
+*ppc4xx_dma01_prep_sum_product(struct ppc4xx_adma_chan*ppc4xx_chan,
+				dma_addr_t * dst,
+				dma_addr_t * src,
+				int src_cnt,
+				const unsigned char *scf,
+				size_t len,
+				unsigned long flags)
+{
+	struct ppc4xx_adma_desc_slot *sw_desc = NULL;
+	unsigned long op = 0;
+	int slot_cnt;
+
+	set_bit(PPC4XX_DESC_WXOR, &op);
+	slot_cnt = 3;
+
+	spin_lock_bh(&ppc4xx_chan->lock);
+
+	/* WXOR, each descriptor occupies one slot */
+	sw_desc = ppc4xx_adma_alloc_slots(ppc4xx_chan, slot_cnt, 1);
+	if (sw_desc) {
+		struct ppc4xx_adma_chan *chan;
+		struct ppc4xx_adma_desc_slot *iter;
+		struct dma_cdb *hw_desc;
+
+		chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+		set_bits(op, &sw_desc->flags);
+		sw_desc->src_cnt = src_cnt;
+		sw_desc->dst_cnt = 1;
+		/* 1st descriptor, src[1] data to q page and zero destination */
+		iter = list_first_entry(&sw_desc->group_list,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc4xx_adma_desc_slot,
+					   chain_node);
+		clear_bit(PPC4XX_DESC_INT, &iter->flags);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MULTICAST;
+
+		ppc4xx_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					  *dst, 0);
+		ppc4xx_desc_set_dest_addr(iter, chan, 0, ppc4xx_chan->qdest, 1);
+		ppc4xx_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					 src[1]);
+		ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+		iter->unmap_len = len;
+
+		/* 2nd descriptor, multiply src[1] data and store the
+		 * result in destination */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		/* set 'next' pointer */
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc4xx_adma_desc_slot,
+					   chain_node);
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC4XX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC4XX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc4xx_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					 ppc4xx_chan->qdest);
+		ppc4xx_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					  *dst, 0);
+		ppc4xx_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+					 DMA_CDB_SG_DST1, scf[1]);
+		ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+		iter->unmap_len = len;
+
+		/*
+		 * 3rd descriptor, multiply src[0] data and xor it
+		 * with destination
+		 */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = NULL;
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC4XX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC4XX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc4xx_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					 src[0]);
+		ppc4xx_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					  *dst, 0);
+		ppc4xx_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+					 DMA_CDB_SG_DST1, scf[0]);
+		ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+		iter->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+
+	spin_unlock_bh(&ppc4xx_chan->lock);
+
+	return sw_desc;
+}
+
+static
+struct ppc4xx_adma_desc_slot *ppc4xx_dma01_prep_pq(struct ppc4xx_adma_chan *ppc4xx_chan,
+							dma_addr_t *dst,
+							int dst_cnt,
+							dma_addr_t *src,
+							int src_cnt,
+							const unsigned char *scf,
+							size_t len,
+							unsigned long flags)
+{
+	int slot_cnt;
+	struct ppc4xx_adma_desc_slot *sw_desc = NULL, *iter;
+	unsigned long op = 0;
+	unsigned char mult = 1;
+
+	pr_debug("%s: dst_cnt %d, src_cnt %d, len %d\n",
+		 __func__, dst_cnt, src_cnt, len);
+	/*  select operations WXOR/RXOR depending on the
+	 * source addresses of operators and the number
+	 * of destinations (RXOR support only Q-parity calculations)
+	 */
+	set_bit(PPC4XX_DESC_WXOR, &op);
+	if (!test_and_set_bit(PPC4XX_RXOR_RUN, &ppc4xx_rxor_state)) {
+		/* no active RXOR;
+		 * do RXOR if:
+		 * - there are more than 1 source,
+		 * - len is aligned on 512-byte boundary,
+		 * - source addresses fit to one of 4 possible regions.
+		 */
+		if (src_cnt > 1 &&
+		    !(len & MQ0_CF2H_RXOR_BS_MASK) &&
+		    (src[0] + len) == src[1]) {
+			/* may do RXOR R1 R2 */
+			set_bit(PPC4XX_DESC_RXOR, &op);
+			if (src_cnt != 2) {
+				/* may try to enhance region of RXOR */
+				if ((src[1] + len) == src[2]) {
+					/* do RXOR R1 R2 R3 */
+					set_bit(PPC4XX_DESC_RXOR123, &op);
+				} else if ((src[1] + len * 2) == src[2]) {
+					/* do RXOR R1 R2 R4 */
+					set_bit(PPC4XX_DESC_RXOR124, &op);
+				} else if ((src[1] + len * 3) == src[2]) {
+					/* do RXOR R1 R2 R5 */
+					set_bit(PPC4XX_DESC_RXOR125, &op);
+				} else {
+					/* do RXOR R1 R2 */
+					set_bit(PPC4XX_DESC_RXOR12, &op);
+				}
+			} else {
+				/* do RXOR R1 R2 */
+				set_bit(PPC4XX_DESC_RXOR12, &op);
+			}
+		}
+
+		if (!test_bit(PPC4XX_DESC_RXOR, &op)) {
+			/* can not do this operation with RXOR */
+			clear_bit(PPC4XX_RXOR_RUN, &ppc4xx_rxor_state);
+		} else {
+			/* can do; set block size right now */
+			ppc4xx_desc_set_rxor_block_size(len);
+		}
+	}
+
+	/* Number of necessary slots depends on operation type selected */
+	if (!test_bit(PPC4XX_DESC_RXOR, &op)) {
+		/*  This is a WXOR only chain. Need descriptors for each
+		 * source to GF-XOR them with WXOR, and need descriptors
+		 * for each destination to zero them with WXOR
+		 */
+		slot_cnt = src_cnt;
+
+		if (flags & DMA_PREP_ZERO_P) {
+			slot_cnt++;
+			set_bit(PPC4XX_ZERO_P, &op);
+		}
+		if (flags & DMA_PREP_ZERO_Q) {
+			slot_cnt++;
+			set_bit(PPC4XX_ZERO_Q, &op);
+		}
+	} else {
+		/*  Need 1/2 descriptor for RXOR operation, and
+		 * need (src_cnt - (2 or 3)) for WXOR of sources
+		 * remained (if any)
+		 */
+		slot_cnt = dst_cnt;
+
+		if (flags & DMA_PREP_ZERO_P)
+			set_bit(PPC4XX_ZERO_P, &op);
+		if (flags & DMA_PREP_ZERO_Q)
+			set_bit(PPC4XX_ZERO_Q, &op);
+
+		if (test_bit(PPC4XX_DESC_RXOR12, &op))
+			slot_cnt += src_cnt - 2;
+		else
+			slot_cnt += src_cnt - 3;
+
+		/*  Thus we have either RXOR only chain or
+		 * mixed RXOR/WXOR
+		 */
+		if (slot_cnt == dst_cnt)
+			/* RXOR only chain */
+			clear_bit(PPC4XX_DESC_WXOR, &op);
+	}
+
+	spin_lock_bh(&ppc4xx_chan->lock);
+	/* for both RXOR/WXOR each descriptor occupies one slot */
+	sw_desc = ppc4xx_adma_alloc_slots(ppc4xx_chan, slot_cnt, 1);
+	if (sw_desc) {
+		ppc4xx_desc_init_dma01pq(sw_desc, dst_cnt, src_cnt, flags, op);
+
+		/* setup dst/src/mult */
+		pr_debug("%s: set dst descriptor 0, 1: 0x%016llx, 0x%016llx\n",
+			 __func__, dst[0], dst[1]);
+		ppc4xx_adma_pq_set_dest(sw_desc, dst, flags);
+		while (src_cnt--) {
+			ppc4xx_adma_pq_set_src(sw_desc, src[src_cnt], src_cnt);
+
+			/* NOTE: "Multi = 0 is equivalent to = 1" as it
+			 * stated in 440SPSPe_RAID6_Addendum_UM_1_17.pdf
+			 * doesn't work for RXOR with DMA0/1! Instead, multi=0
+			 * leads to zeroing source data after RXOR.
+			 * So, for P case set-up mult=1 explicitly.
+			 */
+			if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+				mult = scf[src_cnt];
+			ppc4xx_adma_pq_set_src_mult(sw_desc,
+						    mult, src_cnt, dst_cnt - 1);
+		}
+
+		/* Setup byte count foreach slot just allocated */
+		sw_desc->async_tx.flags = flags;
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+			iter->unmap_len = len;
+		}
+	}
+	spin_unlock_bh(&ppc4xx_chan->lock);
+
+	return sw_desc;
+}
+
+/**
+ * ppc4xx_adma_prep_dma_pqzero_sum - prepare CDB group for
+ * a PQ_ZERO_SUM operation
+ */
+struct dma_async_tx_descriptor
+*ppc4xx_adma_prep_dma_pqzero_sum(struct dma_chan *chan,
+					dma_addr_t * pq,
+					dma_addr_t * src,
+					unsigned int src_cnt,
+					const unsigned 	char *scf,
+					size_t len,
+					enum sum_check_flags *pqres,
+					unsigned long flags)
+{
+	struct ppc4xx_adma_chan *ppc4xx_chan;
+	struct ppc4xx_adma_desc_slot *sw_desc, *iter;
+	dma_addr_t pdest, qdest;
+	int slot_cnt, slots_per_op, idst, dst_cnt;
+
+	ppc4xx_chan = to_ppc4xx_adma_chan(chan);
+
+	if (flags & DMA_PREP_PQ_DISABLE_P)
+		pdest = 0;
+	else
+		pdest = pq[0];
+
+	if (flags & DMA_PREP_PQ_DISABLE_Q)
+		qdest = 0;
+	else
+		qdest = pq[1];
+
+	ADMA_LL_DBG(prep_dma_pqzero_sum_dbg(ppc4xx_chan->device->id,
+					    src, src_cnt, scf));
+
+	/* Always use WXOR for P/Q calculations (two destinations).
+	 * Need 1 or 2 extra slots to verify results are zero.
+	 */
+	idst = dst_cnt = (pdest && qdest) ? 2 : 1;
+
+	/* One additional slot per destination to clone P/Q
+	 * before calculation (we have to preserve destinations).
+	 */
+	slot_cnt = src_cnt + dst_cnt * 2;
+	slots_per_op = 1;
+
+	spin_lock_bh(&ppc4xx_chan->lock);
+	sw_desc = ppc4xx_adma_alloc_slots(ppc4xx_chan, slot_cnt, slots_per_op);
+	if (sw_desc) {
+		ppc4xx_desc_init_dma01pqzero_sum(sw_desc, dst_cnt, src_cnt);
+
+		/* Setup byte count for each slot just allocated */
+		sw_desc->async_tx.flags = flags;
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+			iter->unmap_len = len;
+		}
+
+		if (pdest) {
+			struct dma_cdb *hw_desc;
+			struct ppc4xx_adma_chan *chan;
+
+			iter = sw_desc->group_head;
+			chan = to_ppc4xx_adma_chan(iter->async_tx.chan);
+			memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+			iter->hw_next = list_entry(iter->chain_node.next,
+						   struct ppc4xx_adma_desc_slot,
+						   chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter->src_cnt = 0;
+			iter->dst_cnt = 0;
+			ppc4xx_desc_set_dest_addr(iter, chan, 0,
+						  ppc4xx_chan->pdest, 0);
+			ppc4xx_desc_set_src_addr(iter, chan, 0, 0, pdest);
+			ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+			iter->unmap_len = 0;
+			/* override pdest to preserve original P */
+			pdest = ppc4xx_chan->pdest;
+		}
+		if (qdest) {
+			struct dma_cdb *hw_desc;
+			struct ppc4xx_adma_chan *chan;
+
+			iter = list_first_entry(&sw_desc->group_list,
+						struct ppc4xx_adma_desc_slot,
+						chain_node);
+			chan = to_ppc4xx_adma_chan(iter->async_tx.chan);
+
+			if (pdest) {
+				iter = list_entry(iter->chain_node.next,
+						  struct ppc4xx_adma_desc_slot,
+						  chain_node);
+			}
+
+			memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+			iter->hw_next = list_entry(iter->chain_node.next,
+						   struct ppc4xx_adma_desc_slot,
+						   chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter->src_cnt = 0;
+			iter->dst_cnt = 0;
+			ppc4xx_desc_set_dest_addr(iter, chan, 0,
+						  ppc4xx_chan->qdest, 0);
+			ppc4xx_desc_set_src_addr(iter, chan, 0, 0, qdest);
+			ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+			iter->unmap_len = 0;
+			/* override qdest to preserve original Q */
+			qdest = ppc4xx_chan->qdest;
+		}
+
+		/* Setup destinations for P/Q ops */
+		ppc4xx_adma_pqzero_sum_set_dest(sw_desc, pdest, qdest);
+
+		/* Setup zero QWORDs into DCHECK CDBs */
+		idst = dst_cnt;
+		list_for_each_entry_reverse(iter, &sw_desc->group_list,
+					    chain_node) {
+			/*
+			 * The last CDB corresponds to Q-parity check,
+			 * the one before last CDB corresponds
+			 * P-parity check
+			 */
+			if (idst == DMA_DEST_MAX_NUM) {
+				if (idst == dst_cnt) {
+					set_bit(PPC4XX_DESC_QCHECK,
+						&iter->flags);
+				} else {
+					set_bit(PPC4XX_DESC_PCHECK,
+						&iter->flags);
+				}
+			} else {
+				if (qdest) {
+					set_bit(PPC4XX_DESC_QCHECK,
+						&iter->flags);
+				} else {
+					set_bit(PPC4XX_DESC_PCHECK,
+						&iter->flags);
+				}
+			}
+			iter->xor_check_result = pqres;
+
+			/*
+			 * set it to zero, if check fail then result will
+			 * be updated
+			 */
+			*iter->xor_check_result = 0;
+			ppc4xx_desc_set_dcheck(iter, ppc4xx_chan, ppc4xx_qword);
+
+			if (!(--dst_cnt))
+				break;
+		}
+
+		/* Setup sources and mults for P/Q ops */
+		list_for_each_entry_continue_reverse(iter, &sw_desc->group_list,
+						     chain_node) {
+			struct ppc4xx_adma_chan *chan;
+			u32 mult_dst;
+
+			chan = to_ppc4xx_adma_chan(iter->async_tx.chan);
+			ppc4xx_desc_set_src_addr(iter, chan, 0,
+						 DMA_CUED_XOR_HB,
+						 src[src_cnt - 1]);
+			if (qdest) {
+				mult_dst = (dst_cnt - 1) ? DMA_CDB_SG_DST2 :
+				    DMA_CDB_SG_DST1;
+				ppc4xx_desc_set_src_mult(iter, chan,
+							 DMA_CUED_MULT1_OFF,
+							 mult_dst,
+							 scf[src_cnt - 1]);
+			}
+			if (!(--src_cnt))
+				break;
+		}
+	}
+	spin_unlock_bh(&ppc4xx_chan->lock);
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+/**
+ * ppc4xx_adma_prep_dma_xor_zero_sum - prepare CDB group for
+ * XOR ZERO_SUM operation
+ */
+struct dma_async_tx_descriptor
+*ppc4xx_adma_prep_dma_xor_zero_sum(struct dma_chan *chan,
+					dma_addr_t * src,
+					unsigned int src_cnt,
+					size_t len,
+					enum sum_check_flags *result,
+					unsigned long flags)
+{
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t pq[2];
+
+	/* validate P, disable Q */
+	pq[0] = src[0];
+	pq[1] = 0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+
+	tx = ppc4xx_adma_prep_dma_pqzero_sum(chan, pq, &src[1],
+					     src_cnt - 1, 0, len,
+					     result, flags);
+	return tx;
+}
+
+void ppc4xx_adma_set_capabilities(struct ppc4xx_adma_device *adev)
+{
+	switch (adev->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		dma_cap_set(DMA_MEMCPY, adev->common.cap_mask);
+		dma_cap_set(DMA_INTERRUPT, adev->common.cap_mask);
+		dma_cap_set(DMA_MEMSET, adev->common.cap_mask);
+		dma_cap_set(DMA_PQ, adev->common.cap_mask);
+		dma_cap_set(DMA_PQ_VAL, adev->common.cap_mask);
+		dma_cap_set(DMA_XOR_VAL, adev->common.cap_mask);
+		break;
+	case PPC4XX_XOR_ID:
+		dma_cap_set(DMA_XOR, adev->common.cap_mask);
+		dma_cap_set(DMA_PQ, adev->common.cap_mask);
+		dma_cap_set(DMA_INTERRUPT, adev->common.cap_mask);
+		adev->common.cap_mask = adev->common.cap_mask;
+		break;
+	}
+
+	if (dma_has_cap(DMA_PQ, adev->common.cap_mask)) {
+		switch (adev->id) {
+		case PPC4XX_DMA0_ID:
+			dma_set_maxpq(&adev->common,
+				      DMA0_FIFO_SIZE / sizeof(struct dma_cdb),
+				      0);
+			break;
+		case PPC4XX_DMA1_ID:
+			dma_set_maxpq(&adev->common,
+				      DMA1_FIFO_SIZE / sizeof(struct dma_cdb),
+				      0);
+			break;
+		case PPC4XX_XOR_ID:
+			adev->common.max_pq = XOR_MAX_OPS * 3;
+			break;
+		}
+	}
+	if (dma_has_cap(DMA_PQ_VAL, adev->common.cap_mask)) {
+		switch (adev->id) {
+		case PPC4XX_DMA0_ID:
+			adev->common.max_pq = DMA0_FIFO_SIZE /
+			    sizeof(struct dma_cdb);
+			break;
+		case PPC4XX_DMA1_ID:
+			adev->common.max_pq = DMA1_FIFO_SIZE /
+			    sizeof(struct dma_cdb);
+			break;
+		}
+	}
+	if (dma_has_cap(DMA_XOR_VAL, adev->common.cap_mask)) {
+		switch (adev->id) {
+		case PPC4XX_DMA0_ID:
+			adev->common.max_xor = DMA0_FIFO_SIZE /
+			    sizeof(struct dma_cdb);
+			break;
+		case PPC4XX_DMA1_ID:
+			adev->common.max_xor = DMA1_FIFO_SIZE /
+			    sizeof(struct dma_cdb);
+			break;
+		}
+	}
+	pr_info("%s: AMCC(R) PPC440SP(E) ADMA Engine: "
+		"( %s%s%s%s%s%s%s)\n",
+		dev_name(adev->dev),
+		dma_has_cap(DMA_PQ, adev->common.cap_mask) ? "pq " : "",
+		dma_has_cap(DMA_PQ_VAL, adev->common.cap_mask) ? "pq_val " : "",
+		dma_has_cap(DMA_XOR, adev->common.cap_mask) ? "xor " : "",
+		dma_has_cap(DMA_XOR_VAL,
+			    adev->common.cap_mask) ? "xor_val " : "",
+		dma_has_cap(DMA_MEMCPY, adev->common.cap_mask) ? "memcpy " : "",
+		dma_has_cap(DMA_MEMSET, adev->common.cap_mask) ? "memset " : "",
+		dma_has_cap(DMA_INTERRUPT,
+			    adev->common.cap_mask) ? "intr " : "");
+}
+static  struct ppc4xx_adma_desc_slot
+*ppc4xx_dma2_prep_pq(struct ppc4xx_adma_chan *ppc4xx_chan,
+			dma_addr_t * dst,
+			int dst_cnt,
+			dma_addr_t * src,
+			int src_cnt,
+			const unsigned char *scf,
+			size_t len,
+			unsigned long flags)
+{
+	int slot_cnt, descs_per_op;
+	struct ppc4xx_adma_desc_slot *sw_desc = NULL, *iter;
+	unsigned long op = 0;
+	unsigned char mult = 1;
+
+	BUG_ON(!dst_cnt);
+	/*pr_debug("%s: dst_cnt %d, src_cnt %d, len %d\n",
+	   __func__, dst_cnt, src_cnt, len); */
+
+	spin_lock_bh(&ppc4xx_chan->lock);
+	descs_per_op = ppc4xx_dma2_pq_slot_count(src, src_cnt, len);
+	if (descs_per_op < 0) {
+		spin_unlock_bh(&ppc4xx_chan->lock);
+		return NULL;
+	}
+
+	/* depending on number of sources we have 1 or 2 RXOR chains */
+	slot_cnt = descs_per_op * dst_cnt;
+
+	sw_desc = ppc4xx_adma_alloc_slots(ppc4xx_chan, slot_cnt, 1);
+	if (sw_desc) {
+		op = slot_cnt;
+		sw_desc->async_tx.flags = flags;
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc4xx_desc_init_dma2pq(iter, dst_cnt, src_cnt,
+						--op ? 0 : flags);
+			ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+			iter->unmap_len = len;
+
+			ppc4xx_init_rxor_cursor(&(iter->rxor_cursor));
+			iter->rxor_cursor.len = len;
+			iter->descs_per_op = descs_per_op;
+		}
+		op = 0;
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			op++;
+			if (op % descs_per_op == 0)
+				ppc4xx_adma_init_dma2rxor_slot(iter, src,
+							       src_cnt);
+			if (likely(!list_is_last(&iter->chain_node,
+						 &sw_desc->group_list))) {
+				/* set 'next' pointer */
+				iter->hw_next =
+				    list_entry(iter->chain_node.next,
+					       struct ppc4xx_adma_desc_slot,
+					       chain_node);
+				ppc4xx_xor_set_link(iter, iter->hw_next);
+			} else {
+				/* this is the last descriptor. */
+				iter->hw_next = NULL;
+			}
+		}
+
+		/* fixup head descriptor */
+		sw_desc->dst_cnt = dst_cnt;
+		if (flags & DMA_PREP_ZERO_P)
+			set_bit(PPC4XX_ZERO_P, &sw_desc->flags);
+		if (flags & DMA_PREP_ZERO_Q)
+			set_bit(PPC4XX_ZERO_Q, &sw_desc->flags);
+
+		/* setup dst/src/mult */
+		ppc4xx_adma_pq_set_dest(sw_desc, dst, flags);
+
+		while (src_cnt--) {
+			/* handle descriptors (if dst_cnt == 2) inside
+			 * the ppc4xx_adma_pq_set_srcxxx() functions
+			 */
+			ppc4xx_adma_pq_set_src(sw_desc, src[src_cnt], src_cnt);
+			if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+				mult = scf[src_cnt];
+			ppc4xx_adma_pq_set_src_mult(sw_desc,
+						    mult, src_cnt, dst_cnt - 1);
+		}
+	}
+	spin_unlock_bh(&ppc4xx_chan->lock);
+	ppc4xx_desc_set_rxor_block_size(len);
+	return sw_desc;
+}
+
+/**
+ * ppc4xx_dma01_prep_mult -
+ * for Q operation where destination is also the source
+ */
+static  struct ppc4xx_adma_desc_slot
+*ppc4xx_dma01_prep_mult(struct ppc4xx_adma_chan *ppc4xx_chan,
+			dma_addr_t * dst,
+			int dst_cnt,
+			dma_addr_t * src,
+			int src_cnt,
+			const unsigned char *scf,
+			size_t len,
+			unsigned long flags)
+{
+	struct ppc4xx_adma_desc_slot *sw_desc = NULL;
+	unsigned long op = 0;
+	int slot_cnt;
+
+	set_bit(PPC4XX_DESC_WXOR, &op);
+	slot_cnt = 2;
+
+	spin_lock_bh(&ppc4xx_chan->lock);
+
+	/* use WXOR, each descriptor occupies one slot */
+	sw_desc = ppc4xx_adma_alloc_slots(ppc4xx_chan, slot_cnt, 1);
+	if (sw_desc) {
+		struct ppc4xx_adma_chan *chan;
+		struct ppc4xx_adma_desc_slot *iter;
+		struct dma_cdb *hw_desc;
+
+		chan = to_ppc4xx_adma_chan(sw_desc->async_tx.chan);
+		set_bits(op, &sw_desc->flags);
+		sw_desc->src_cnt = src_cnt;
+		sw_desc->dst_cnt = dst_cnt;
+		/* First descriptor, zero data in the destination and copy it
+		 * to q page using MULTICAST transfer.
+		 */
+		iter = list_first_entry(&sw_desc->group_list,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		/* set 'next' pointer */
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc4xx_adma_desc_slot,
+					   chain_node);
+		clear_bit(PPC4XX_DESC_INT, &iter->flags);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MULTICAST;
+
+		ppc4xx_desc_set_dest_addr(iter, chan,
+					  DMA_CUED_XOR_BASE, dst[0], 0);
+		ppc4xx_desc_set_dest_addr(iter, chan, 0, dst[1], 1);
+		ppc4xx_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					 src[0]);
+		ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+		iter->unmap_len = len;
+
+		/*
+		 * Second descriptor, multiply data from the q page
+		 * and store the result in real destination.
+		 */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc4xx_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = NULL;
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC4XX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC4XX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc4xx_desc_set_src_addr(iter, chan, 0,
+					 DMA_CUED_XOR_HB, dst[1]);
+		ppc4xx_desc_set_dest_addr(iter, chan,
+					  DMA_CUED_XOR_BASE, dst[0], 0);
+
+		ppc4xx_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+					 DMA_CDB_SG_DST1, scf[0]);
+		ppc4xx_desc_set_byte_count(iter, ppc4xx_chan, len);
+		iter->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+
+	spin_unlock_bh(&ppc4xx_chan->lock);
+
+	return sw_desc;
+}
+
+/**
+ * ppc4xx_adma_prep_dma_pq - prepare CDB (group) for a GF-XOR operation
+ */
+struct dma_async_tx_descriptor *ppc4xx_adma_prep_dma_pq(struct dma_chan
+							*chan,
+							dma_addr_t * dst,
+							dma_addr_t * src,
+							unsigned int
+							src_cnt, const unsigned
+							char *scf,
+							size_t len,
+							unsigned long flags)
+{
+	struct ppc4xx_adma_chan *ppc4xx_chan;
+	struct ppc4xx_adma_desc_slot *sw_desc = NULL;
+	int dst_cnt = 0;
+
+	ppc4xx_chan = to_ppc4xx_adma_chan(chan);
+
+	BUG_ON(!len);
+	BUG_ON(unlikely(len > PPC4XX_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(!src_cnt);
+
+	if (src_cnt == 1 && dst[1] == src[0]) {
+		dma_addr_t dest[2];
+
+		/* dst[1] is real destination (Q) */
+		dest[0] = dst[1];
+		/* this is the page to multicast source data to */
+		dest[1] = ppc4xx_chan->qdest;
+		sw_desc = ppc4xx_dma01_prep_mult(ppc4xx_chan,
+						 dest, 2, src, src_cnt, scf,
+						 len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
+
+	if (src_cnt == 2 && dst[1] == src[1]) {
+		sw_desc = ppc4xx_dma01_prep_sum_product(ppc4xx_chan,
+							&dst[1], src, 2, scf,
+							len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
+
+	if (!(flags & DMA_PREP_PQ_DISABLE_P)) {
+		BUG_ON(!dst[0]);
+		dst_cnt++;
+		flags |= DMA_PREP_ZERO_P;
+	}
+
+	if (!(flags & DMA_PREP_PQ_DISABLE_Q)) {
+		BUG_ON(!dst[1]);
+		dst_cnt++;
+		flags |= DMA_PREP_ZERO_Q;
+	}
+
+	BUG_ON(!dst_cnt);
+
+	dev_dbg(ppc4xx_chan->device->common.dev,
+		"ppc4xx adma%d: %s src_cnt: %d len: %u int_en: %d\n",
+		ppc4xx_chan->device->id, __func__, src_cnt, len,
+		flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+	switch (ppc4xx_chan->device->id) {
+	case PPC4XX_DMA0_ID:
+	case PPC4XX_DMA1_ID:
+		sw_desc = ppc4xx_dma01_prep_pq(ppc4xx_chan,
+						  dst, dst_cnt, src, src_cnt,
+						  scf, len, flags);
+		break;
+
+	case PPC4XX_XOR_ID:
+		sw_desc = ppc4xx_dma2_prep_pq(ppc4xx_chan,
+						 dst, dst_cnt, src, src_cnt,
+						 scf, len, flags);
+		break;
+	}
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+int ppc4xx_adma_setup_irqs(struct ppc4xx_adma_device *adev,
+			   struct ppc4xx_adma_chan *chan, int *initcode)
+{
+	struct platform_device *ofdev;
+	struct device_node *np;
+	int ret;
+
+	ofdev = container_of(adev->dev, struct platform_device, dev);
+	np = ofdev->dev.of_node;
+	if (adev->id != PPC4XX_XOR_ID) {
+		adev->err_irq = irq_of_parse_and_map(np, 1);
+		if (adev->err_irq == NO_IRQ) {
+			dev_warn(adev->dev, "no err irq resource?\n");
+			*initcode = PPC_ADMA_INIT_IRQ2;
+			adev->err_irq = -ENXIO;
+		} else
+			atomic_inc(&ppc4xx_adma_err_irq_ref);
+	} else {
+		adev->err_irq = -ENXIO;
+	}
+
+	adev->irq = irq_of_parse_and_map(np, 0);
+	if (adev->irq == NO_IRQ) {
+		dev_err(adev->dev, "no irq resource\n");
+		*initcode = PPC_ADMA_INIT_IRQ1;
+		ret = -ENXIO;
+		goto err_irq_map;
+	}
+	dev_dbg(adev->dev, "irq %d, err irq %d\n", adev->irq, adev->err_irq);
+
+	ret = request_irq(adev->irq, ppc4xx_adma_eot_handler,
+			  0, dev_driver_string(adev->dev), chan);
+	if (ret) {
+		dev_err(adev->dev, "can't request irq %d\n", adev->irq);
+		*initcode = PPC_ADMA_INIT_IRQ1;
+		ret = -EIO;
+		goto err_req1;
+	}
+
+	/* only DMA engines have a separate error IRQ
+	 * so it's Ok if err_irq < 0 in XOR engine case.
+	 */
+	if (adev->err_irq > 0) {
+		/* both DMA engines share common error IRQ */
+		ret = request_irq(adev->err_irq,
+				  ppc4xx_adma_err_handler,
+				  IRQF_SHARED,
+				  dev_driver_string(adev->dev), chan);
+		if (ret) {
+			dev_err(adev->dev, "can't request irq %d\n",
+				adev->err_irq);
+			*initcode = PPC_ADMA_INIT_IRQ2;
+			ret = -EIO;
+			goto err_req2;
+		}
+	}
+
+	if (adev->id == PPC4XX_XOR_ID) {
+		/* enable XOR engine interrupts */
+		iowrite32be(XOR_IE_CBCIE_BIT | XOR_IE_ICBIE_BIT |
+			    XOR_IE_ICIE_BIT | XOR_IE_RPTIE_BIT,
+			    &adev->xor_reg->ier);
+	} else {
+		u32 mask, enable;
+
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+		np = of_find_compatible_node(NULL, NULL, "ibm,i2o-440spe");
+#endif
+		if (!np) {
+			pr_err("%s: can't find I2O device tree node\n",
+			       __func__);
+			ret = -ENODEV;
+			goto err_req2;
+		}
+		adev->i2o_reg = of_iomap(np, 0);
+		if (!adev->i2o_reg) {
+			pr_err("%s: failed to map I2O registers\n", __func__);
+			of_node_put(np);
+			ret = -EINVAL;
+			goto err_req2;
+		}
+		of_node_put(np);
+		/* Unmask 'CS FIFO Attention' interrupts and
+		 * enable generating interrupts on errors
+		 */
+		enable = (adev->id == PPC4XX_DMA0_ID) ?
+		    ~(I2O_IOPIM_P0SNE | I2O_IOPIM_P0EM) :
+		    ~(I2O_IOPIM_P1SNE | I2O_IOPIM_P1EM);
+		mask = ioread32(&adev->i2o_reg->iopim) & enable;
+		iowrite32(mask, &adev->i2o_reg->iopim);
+	}
+	return 0;
+
+      err_req2:
+	free_irq(adev->irq, chan);
+      err_req1:
+	irq_dispose_mapping(adev->irq);
+      err_irq_map:
+	if (adev->err_irq > 0) {
+		if (atomic_dec_and_test(&ppc4xx_adma_err_irq_ref))
+			irq_dispose_mapping(adev->err_irq);
+	}
+	return ret;
+}
+
+void ppc4xx_adma_release_irqs(struct ppc4xx_adma_device *adev,
+			      struct ppc4xx_adma_chan *chan)
+{
+	u32 mask, disable;
+
+	if (adev->id == PPC4XX_XOR_ID) {
+		/* disable XOR engine interrupts */
+		mask = ioread32be(&adev->xor_reg->ier);
+		mask &= ~(XOR_IE_CBCIE_BIT | XOR_IE_ICBIE_BIT |
+			  XOR_IE_ICIE_BIT | XOR_IE_RPTIE_BIT);
+		iowrite32be(mask, &adev->xor_reg->ier);
+	} else {
+		/* disable DMAx engine interrupts */
+		disable = (adev->id == PPC4XX_DMA0_ID) ?
+		    (I2O_IOPIM_P0SNE | I2O_IOPIM_P0EM) :
+		    (I2O_IOPIM_P1SNE | I2O_IOPIM_P1EM);
+		mask = ioread32(&adev->i2o_reg->iopim) | disable;
+		iowrite32(mask, &adev->i2o_reg->iopim);
+	}
+	free_irq(adev->irq, chan);
+	irq_dispose_mapping(adev->irq);
+	if (adev->err_irq > 0) {
+		free_irq(adev->err_irq, chan);
+		if (atomic_dec_and_test(&ppc4xx_adma_err_irq_ref)) {
+			irq_dispose_mapping(adev->err_irq);
+			iounmap(adev->i2o_reg);
+		}
+	}
+}
+
+/*
+ * Common initialisation for RAID engines; allocate memory for
+ * DMAx FIFOs, perform configuration common for all DMA engines.
+ * Further DMA engine specific configuration is done at probe time.
+ */
+static int ppc4xx_configure_raid_devices(void)
+{
+	struct device_node *np;
+	struct resource i2o_res;
+	struct i2o_regs __iomem *i2o_reg;
+	dcr_host_t i2o_dcr_host;
+	unsigned int dcr_base, dcr_len;
+	int i, ret;
+
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+	np = of_find_compatible_node(NULL, NULL, "ibm,i2o-440spe");
+#endif
+	if (!np) {
+		pr_err("%s: can't find I2O device tree node\n", __func__);
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(np, 0, &i2o_res)) {
+		of_node_put(np);
+		return -EINVAL;
+	}
+
+	i2o_reg = of_iomap(np, 0);
+	if (!i2o_reg) {
+		pr_err("%s: failed to map I2O registers\n", __func__);
+		of_node_put(np);
+		return -EINVAL;
+	}
+
+	/* Get I2O DCRs base */
+	dcr_base = dcr_resource_start(np, 0);
+	dcr_len = dcr_resource_len(np, 0);
+	if (!dcr_base && !dcr_len) {
+		pr_err("%s: can't get DCR registers base/len!\n",
+		       np->full_name);
+		of_node_put(np);
+		iounmap(i2o_reg);
+		return -ENODEV;
+	}
+
+	i2o_dcr_host = dcr_map(np, dcr_base, dcr_len);
+	if (!DCR_MAP_OK(i2o_dcr_host)) {
+		pr_err("%s: failed to map DCRs!\n", np->full_name);
+		of_node_put(np);
+		iounmap(i2o_reg);
+		return -ENODEV;
+	}
+	of_node_put(np);
+
+	/* Provide memory regions for DMA's FIFOs: I2O, DMA0 and DMA1 share
+	 * the base address of FIFO memory space.
+	 * Actually we need twice more physical memory than programmed in the
+	 * <fsiz> register (because there are two FIFOs for each DMA: CP and CS)
+	 */
+	ppc4xx_dma_fifo_buf = kmalloc((DMA0_FIFO_SIZE + DMA1_FIFO_SIZE) << 1,
+				      GFP_KERNEL);
+	if (!ppc4xx_dma_fifo_buf) {
+		pr_err("%s: DMA FIFO buffer allocation failed.\n", __func__);
+		iounmap(i2o_reg);
+		dcr_unmap(i2o_dcr_host, dcr_len);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Configure h/w
+	 */
+	/* Reset I2O/DMA */
+	mtdcri(SDR0, DCRN_SDR0_SRST, DCRN_SDR0_SRST_I2ODMA);
+	mtdcri(SDR0, DCRN_SDR0_SRST, 0);
+
+	/* Setup the base address of mmaped registers */
+	dcr_write(i2o_dcr_host, DCRN_I2O0_IBAH, (u32) (i2o_res.start >> 32));
+	dcr_write(i2o_dcr_host, DCRN_I2O0_IBAL, (u32) (i2o_res.start) |
+		  I2O_REG_ENABLE);
+	dcr_unmap(i2o_dcr_host, dcr_len);
+
+	/* Setup FIFO memory space base address */
+	iowrite32(0, &i2o_reg->ifbah);
+	iowrite32(((u32) __pa(ppc4xx_dma_fifo_buf)), &i2o_reg->ifbal);
+
+	/* set zero FIFO size for I2O, so the whole
+	 * ppc4xx_dma_fifo_buf is used by DMAs.
+	 * DMAx_FIFOs will be configured while probe.
+	 */
+	iowrite32(0, &i2o_reg->ifsiz);
+	iounmap(i2o_reg);
+
+	/* To prepare WXOR/RXOR functionality we need access to
+	 * Memory Queue Module DCRs (finally it will be enabled
+	 * via /sys interface of the ppc4xx ADMA driver).
+	 */
+#if defined(CONFIG_440SPe) || defined(CONFIG_440SP)
+	np = of_find_compatible_node(NULL, NULL, "ibm,mq-440spe");
+#endif
+	if (!np) {
+		pr_err("%s: can't find MQ device tree node\n", __func__);
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	/* Get MQ DCRs base */
+	dcr_base = dcr_resource_start(np, 0);
+	dcr_len = dcr_resource_len(np, 0);
+	if (!dcr_base && !dcr_len) {
+		pr_err("%s: can't get DCR registers base/len!\n",
+		       np->full_name);
+		ret = -ENODEV;
+		goto out_mq;
+	}
+
+	ppc4xx_mq_dcr_host = dcr_map(np, dcr_base, dcr_len);
+	if (!DCR_MAP_OK(ppc4xx_mq_dcr_host)) {
+		pr_err("%s: failed to map DCRs!\n", np->full_name);
+		ret = -ENODEV;
+		goto out_mq;
+	}
+	of_node_put(np);
+	ppc4xx_mq_dcr_len = dcr_len;
+
+	/* Set HB alias */
+	dcr_write(ppc4xx_mq_dcr_host, DCRN_MQ0_BAUH, DMA_CUED_XOR_HB);
+
+	/* Set:
+	 * - LL transaction passing limit to 1;
+	 * - Memory controller cycle limit to 1;
+	 * - Galois Polynomial to 0x14d (default)
+	 */
+	dcr_write(ppc4xx_mq_dcr_host, DCRN_MQ0_CFBHL,
+		  (1 << MQ0_CFBHL_TPLM) | (1 << MQ0_CFBHL_HBCL) |
+		  (PPC4XX_DEFAULT_POLY << MQ0_CFBHL_POLY));
+
+	atomic_set(&ppc4xx_adma_err_irq_ref, 0);
+	for (i = 0; i < PPC4XX_ADMA_ENGINES_NUM; i++)
+		ppc4xx_adma_devices[i] = -1;
+
+	return 0;
+
+      out_mq:
+	of_node_put(np);
+      out_free:
+	kfree(ppc4xx_dma_fifo_buf);
+	return ret;
+}
+
+/**
+ * ppc4xx_test_callback - called when test operation has been done
+ */
+static void ppc4xx_test_callback(void *unused)
+{
+	complete(&ppc4xx_r6_test_comp);
+}
+
+/**
+ * ppc4xx_test_raid6 - test are RAID-6 capabilities enabled successfully.
+ *	For this we just perform one WXOR operation with the same source
+ *	and destination addresses, the GF-multiplier is 1; so if RAID-6
+ *	capabilities are enabled then we'll get src/dst filled with zero.
+ */
+static int ppc4xx_test_raid6(struct ppc4xx_adma_chan *chan)
+{
+	struct ppc4xx_adma_desc_slot *sw_desc, *iter;
+	struct page *pg;
+	char *a;
+	dma_addr_t dma_addr, addrs[2];
+	unsigned long op = 0;
+	int rval = 0;
+
+	set_bit(PPC4XX_DESC_WXOR, &op);
+
+	pg = alloc_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+
+	spin_lock_bh(&chan->lock);
+	sw_desc = ppc4xx_adma_alloc_slots(chan, 1, 1);
+	if (sw_desc) {
+		/* 1 src, 1 dsr, int_ena, WXOR */
+		ppc4xx_desc_init_dma01pq(sw_desc, 1, 1, 1, op);
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc4xx_desc_set_byte_count(iter, chan, PAGE_SIZE);
+			iter->unmap_len = PAGE_SIZE;
+		}
+	} else {
+		rval = -EFAULT;
+		spin_unlock_bh(&chan->lock);
+		goto exit;
+	}
+	spin_unlock_bh(&chan->lock);
+
+	/* Fill the test page with ones */
+	memset(page_address(pg), 0xFF, PAGE_SIZE);
+	dma_addr = dma_map_page(chan->device->dev, pg, 0,
+				PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+	/* Setup addresses */
+	ppc4xx_adma_pq_set_src(sw_desc, dma_addr, 0);
+	ppc4xx_adma_pq_set_src_mult(sw_desc, 1, 0, 0);
+	addrs[0] = dma_addr;
+	addrs[1] = 0;
+	ppc4xx_adma_pq_set_dest(sw_desc, addrs, DMA_PREP_PQ_DISABLE_Q);
+
+	async_tx_ack(&sw_desc->async_tx);
+	sw_desc->async_tx.callback = ppc4xx_test_callback;
+	sw_desc->async_tx.callback_param = NULL;
+
+	init_completion(&ppc4xx_r6_test_comp);
+
+	ppc4xx_adma_tx_submit(&sw_desc->async_tx);
+	ppc4xx_adma_issue_pending(&chan->common);
+
+	wait_for_completion(&ppc4xx_r6_test_comp);
+
+	/* Now check if the test page is zeroed */
+	a = page_address(pg);
+	if ((*(u32 *) a) == 0 && memcmp(a, a + 4, PAGE_SIZE - 4) == 0) {
+		/* page is zero - RAID-6 enabled */
+		rval = 0;
+	} else {
+		/* RAID-6 was not enabled */
+		rval = -EINVAL;
+	}
+      exit:
+	__free_page(pg);
+	return rval;
+}
+
+/**
+ * ppc4xx_adma_remove - remove the asynch device
+ */
+int __devexit ppc4xx_adma_remove(struct platform_device *ofdev)
+{
+	struct ppc4xx_adma_device *adev = dev_get_drvdata(&ofdev->dev);
+	struct device_node *np = ofdev->dev.of_node;
+	struct resource res;
+	struct dma_chan *chan, *_chan;
+	struct ppc_dma_chan_ref *ref, *_ref;
+	struct ppc4xx_adma_chan *ppc4xx_chan;
+
+	dev_set_drvdata(&ofdev->dev, NULL);
+	if (adev->id < PPC4XX_ADMA_ENGINES_NUM)
+		ppc4xx_adma_devices[adev->id] = -1;
+
+	dma_async_device_unregister(&adev->common);
+
+	list_for_each_entry_safe(chan, _chan, &adev->common.channels,
+				 device_node) {
+		ppc4xx_chan = to_ppc4xx_adma_chan(chan);
+		ppc4xx_adma_release_irqs(adev, ppc4xx_chan);
+		tasklet_kill(&ppc4xx_chan->irq_tasklet);
+		if (adev->id != PPC4XX_XOR_ID) {
+			dma_unmap_page(&ofdev->dev, ppc4xx_chan->pdest,
+				       PAGE_SIZE, DMA_BIDIRECTIONAL);
+			dma_unmap_page(&ofdev->dev, ppc4xx_chan->qdest,
+				       PAGE_SIZE, DMA_BIDIRECTIONAL);
+			__free_page(ppc4xx_chan->pdest_page);
+			__free_page(ppc4xx_chan->qdest_page);
+		}
+		list_for_each_entry_safe(ref, _ref, &ppc4xx_adma_chan_list,
+					 node) {
+			if (ppc4xx_chan == to_ppc4xx_adma_chan(ref->chan)) {
+				list_del(&ref->node);
+				kfree(ref);
+			}
+		}
+		list_del(&chan->device_node);
+		kfree(ppc4xx_chan);
+	}
+
+	dma_free_coherent(adev->dev, adev->pool_size,
+			  adev->dma_desc_pool_virt, adev->dma_desc_pool);
+	if (adev->id == PPC4XX_XOR_ID)
+		iounmap(adev->xor_reg);
+	else
+		iounmap(adev->dma_reg);
+	of_address_to_resource(np, 0, &res);
+	release_mem_region(res.start, resource_size(&res));
+	kfree(adev);
+	return 0;
+}
+
+/*
+ * /sys driver interface to enable h/w RAID-6 capabilities
+ * Files created in e.g. /sys/devices/plb.0/400100100.dma0/driver/
+ * directory are "devices", "enable" and "poly".
+ * "devices" shows available engines.
+ * "enable" is used to enable RAID-6 capabilities or to check
+ * whether these has been activated.
+ * "poly" allows setting/checking used polynomial (for PPC4xx only).
+ */
+
+static ssize_t show_ppc4xx_devices(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	int i;
+
+	for (i = 0; i < PPC4XX_ADMA_ENGINES_NUM; i++) {
+		if (ppc4xx_adma_devices[i] == -1)
+			continue;
+		size += snprintf(buf + size, PAGE_SIZE - size,
+				 "PPC4XX-ADMA.%d: %s\n", i,
+				 ppc_adma_errors[ppc4xx_adma_devices[i]]);
+	}
+	return size;
+}
+static ssize_t show_ppc4xx_r6enable(struct device_driver *dev, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE,
+			"PPC440SP(e) RAID-6 capabilities are %sABLED.\n",
+			ppc4xx_r6_enabled ? "EN" : "DIS");
+}
+
+static ssize_t store_ppc4xx_r6enable(struct device_driver *dev,
+					const char *buf, size_t count)
+{
+	unsigned long val;
+
+	if (!count || count > 11)
+		return -EINVAL;
+
+	if (!ppc4xx_r6_tchan)
+		return -EFAULT;
+
+	/* Write a key */
+	sscanf(buf, "%lx", &val);
+	dcr_write(ppc4xx_mq_dcr_host, DCRN_MQ0_XORBA, val);
+	isync();
+
+	/* Verify whether it really works now */
+	if (ppc4xx_test_raid6(ppc4xx_r6_tchan) == 0) {
+		pr_info("PPC440SP(e) RAID-6 has been activated "
+			"successfully\n");
+		ppc4xx_r6_enabled = 1;
+	} else {
+		pr_info("PPC440SP(e) RAID-6 hasn't been activated!"
+			" Error key ?\n");
+		ppc4xx_r6_enabled = 0;
+	}
+	return count;
+}
+
+static ssize_t show_ppc4xx_r6poly(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	u32 reg;
+
+#ifdef CONFIG_440SP
+	/* 440SP has fixed polynomial */
+	reg = 0x4d;
+#else
+	reg = dcr_read(ppc4xx_mq_dcr_host, DCRN_MQ0_CFBHL);
+	reg >>= MQ0_CFBHL_POLY;
+	reg &= 0xFF;
+#endif
+
+	size = snprintf(buf, PAGE_SIZE, "PPC440SP(e) RAID-6 driver "
+			"uses 0x1%02x polynomial.\n", reg);
+	return size;
+}
+
+static ssize_t store_ppc4xx_r6poly(struct device_driver *dev,
+				      const char *buf, size_t count)
+{
+	unsigned long reg, val;
+
+#ifdef CONFIG_440SP
+	/* 440SP uses default 0x14D polynomial only */
+	return -EINVAL;
+#endif
+
+	if (!count || count > 6)
+		return -EINVAL;
+
+	/* e.g., 0x14D or 0x11D */
+	sscanf(buf, "%lx", &val);
+
+	if (val & ~0x1FF)
+		return -EINVAL;
+
+	val &= 0xFF;
+	reg = dcr_read(ppc4xx_mq_dcr_host, DCRN_MQ0_CFBHL);
+	reg &= ~(0xFF << MQ0_CFBHL_POLY);
+	reg |= val << MQ0_CFBHL_POLY;
+	dcr_write(ppc4xx_mq_dcr_host, DCRN_MQ0_CFBHL, reg);
+
+	return count;
+}
+
+static DRIVER_ATTR(devices, S_IRUGO, show_ppc4xx_devices, NULL);
+static DRIVER_ATTR(enable, S_IRUGO | S_IWUSR, show_ppc4xx_r6enable,
+		   store_ppc4xx_r6enable);
+static DRIVER_ATTR(poly, S_IRUGO | S_IWUSR, show_ppc4xx_r6poly,
+		   store_ppc4xx_r6poly);
+int ppc4xx_adma_hw_init(void)
+{
+	int ret;
+
+	ret = ppc4xx_configure_raid_devices();
+	if (ret)
+		return ret;
+
+	ret = of_register_platform_driver(&ppc4xx_adma_driver);
+	if (ret) {
+		pr_err("%s: failed to register platform driver\n", __func__);
+		goto out_reg;
+	}
+
+	/* Initialization status */
+	ret = driver_create_file(&ppc4xx_adma_driver.driver,
+				 &driver_attr_devices);
+	if (ret)
+		goto out_dev;
+
+	/* RAID-6 h/w enable entry */
+	ret = driver_create_file(&ppc4xx_adma_driver.driver,
+				 &driver_attr_enable);
+	if (ret)
+		goto out_en;
+
+	/* GF polynomial to use */
+	ret = driver_create_file(&ppc4xx_adma_driver.driver, &driver_attr_poly);
+	if (!ret)
+		return ret;
+
+	driver_remove_file(&ppc4xx_adma_driver.driver, &driver_attr_enable);
+      out_en:
+	driver_remove_file(&ppc4xx_adma_driver.driver, &driver_attr_devices);
+      out_dev:
+	/* User will not be able to enable h/w RAID-6 */
+	pr_err("%s: failed to create RAID-6 driver interface\n", __func__);
+      out_reg:
+	dcr_unmap(ppc4xx_mq_dcr_host, ppc4xx_mq_dcr_len);
+	kfree(ppc4xx_dma_fifo_buf);
+	return ret;
+}
+
+static void __exit ppc4xx_adma_exit(void)
+{
+	driver_remove_file(&ppc4xx_adma_driver.driver, &driver_attr_poly);
+	driver_remove_file(&ppc4xx_adma_driver.driver, &driver_attr_enable);
+	driver_remove_file(&ppc4xx_adma_driver.driver, &driver_attr_devices);
+	of_unregister_platform_driver(&ppc4xx_adma_driver);
+	dcr_unmap(ppc4xx_mq_dcr_host, ppc4xx_mq_dcr_len);
+	kfree(ppc4xx_dma_fifo_buf);
+}
-- 
1.6.1.rc3
