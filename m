From: tmarri@amcc.com
Subject: [PATCH] Adding ADMA support for PPC460EX DMA engine.
Date: Thu, 22 Jul 2010 17:57:18 -0700
Message-ID: <1279846638-22323-1-git-send-email-tmarri@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-raid@vger.kernel.org, tmarri@amcc.com, dan.j.williams@intel.com,
	linuxppc-dev@lists.ozlabs.org
To: linux-crypto@vger.kernel.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
List-Id: linux-crypto.vger.kernel.org

From: Tirumala Marri <tmarri@amcc.com>

  This patch will add ADMA support for DMA engine and HW offload for
  XOR/ADG (RAID-5/6) functionalities.
  1. It supports memcpy, xor, GF(2) based RAID-6.
  2. It supports interrupt based DMA completions.
  3. Also supports memcpy in RAID-1 case.

  Kernel version: 2.6.35-rc5

  Testing:
    Created RAID-5/6 arrays usign mdadm.
    And ran raw IO and filesystem IO to the RAID array.
    Chunk size 4k,64k was tested.
    RAID rebuild , disk fail, resync tested.

  File names:
    This code is similar to ppc440spe . So I named the files as
    drivers/dma/ppc4xx/adma1.c and drivers/dma/ppc4xx/adma1.h

    Signed-off-by: Tirumala R Marri <tmarri@apm.com>
---
 arch/powerpc/boot/dts/canyonlands.dts |   23 +-
 drivers/dma/Kconfig                   |   10 +
 drivers/dma/Makefile                  |    1 +
 drivers/dma/ppc4xx/Makefile           |    1 +
 drivers/dma/ppc4xx/adma1.c            | 4119 +++++++++++++++++++++++++++++++++
 drivers/dma/ppc4xx/adma1.h            |  192 ++
 drivers/dma/ppc4xx/dma.h              |   20 +-
 7 files changed, 4362 insertions(+), 4 deletions(-)
 create mode 100644 drivers/dma/ppc4xx/adma1.c
 create mode 100644 drivers/dma/ppc4xx/adma1.h

diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
index cd56bb5..eb3ca8c 100644
--- a/arch/powerpc/boot/dts/canyonlands.dts
+++ b/arch/powerpc/boot/dts/canyonlands.dts
@@ -114,7 +114,10 @@
 		interrupt-parent = <&UIC1>;
 		interrupts = <11 1>;
 	};
-
+	MQ0: mq {
+		compatible = "ibm,mq-460ex";
+		dcr-reg = <0x040 0x020>;
+	};
 	plb {
 		compatible = "ibm,plb-460ex", "ibm,plb4";
 		#address-cells = <2>;
@@ -162,6 +165,24 @@
 			interrupt-parent = <&UIC2>;
 			interrupts = <0x1e 4>;
 		};
+		I2O: i2o@400100000 {
+			compatible = "ibm,i2o-460ex";
+			reg = <0x00000004 0x00100000 0x100>;
+			dcr-reg = <0x060 0x020>;
+		};
+                ADMA: adma {
+                        compatible = "amcc,dma-460ex";
+                        device_type = "dma";
+                        reg = <0x00000004 0x00100200 0x100>;
+                        interrupt-parent = <&ADMA>;
+                        interrupts =<0 1 2>;
+                        #interrupt-cells = <1>;
+                        #address-cells = <0>;
+                        #size-cells = <0>;
+                        interrupt-map = </*FIFO need service */ 0 &UIC0 0x16 4
+                                         /*FIFO FULL */         1 &UIC0 0x15 4
+                                         /*FIFO HSDMA err */    2 &UIC1 0x16 4>;
+                };
 
 		POB0: opb {
 			compatible = "ibm,opb-460ex", "ibm,opb";
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9e01e96..77f9ea0 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -163,6 +163,16 @@ config TIMB_DMA
 	help
 	  Enable support for the Timberdale FPGA DMA engine.
 
+config AMCC_PPC460EX_ADMA
+	tristate "AMCC PPC460Ex ADMA support"
+	depends on 460EX
+	select DMA_ENGINE
+	select ARCH_HAS_ASYNC_TX_FIND_CHANNEL
+	help
+	  Enable support for the AMCC PPC460Ex RAID engines.
+	  Also adds HW acceleration for memset and memcpy.
+	  Enabling RAID-5/6 would also need HW key.
+
 config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 	bool
 
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 0fe5ebb..1d0ccfc 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_TXX9_DMAC) += txx9dmac.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
 obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
+obj-$(CONFIG_AMCC_PPC460EX_ADMA) += ppc4xx/
 obj-$(CONFIG_TIMB_DMA) += timb_dma.o
 obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
 obj-$(CONFIG_PL330_DMA) += pl330.o
diff --git a/drivers/dma/ppc4xx/Makefile b/drivers/dma/ppc4xx/Makefile
index b3d259b..435a086 100644
--- a/drivers/dma/ppc4xx/Makefile
+++ b/drivers/dma/ppc4xx/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += adma.o
+obj-$(CONFIG_AMCC_PPC460EX_ADMA) += adma1.o
diff --git a/drivers/dma/ppc4xx/adma1.c b/drivers/dma/ppc4xx/adma1.c
new file mode 100644
index 0000000..30c2229
--- /dev/null
+++ b/drivers/dma/ppc4xx/adma1.c
@@ -0,0 +1,4119 @@
+/*
+ * Copyright(c) 2010 Applied Micro (APM). All rights reserved.
+ *
+ * Author: Tirumala Reddy Marri tmarri@apm.com
+ *
+ * This driver follows Dan Williams and Yuri Tikhonovs implementations.
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
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/async_tx.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/of_platform.h>
+#include <linux/proc_fs.h>
+#include <asm/dcr.h>
+#include <asm/dcr-regs.h>
+#include "dma.h"
+#include "adma1.h"
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
+static char *ppc_adma_errors[] = {
+	[PPC_ADMA_INIT_OK] = "ok",
+	[PPC_ADMA_INIT_MEMRES] = "failed to get memory resource",
+	[PPC_ADMA_INIT_MEMREG] = "failed to request memory region",
+	[PPC_ADMA_INIT_ALLOC] = "failed to allocate memory for adev "
+				"structure",
+	[PPC_ADMA_INIT_COHERENT] = "failed to allocate coherent memory for "
+				   "hardware descriptors",
+	[PPC_ADMA_INIT_CHANNEL] = "failed to allocate memory for channel",
+	[PPC_ADMA_INIT_IRQ1] = "failed to request first irq",
+	[PPC_ADMA_INIT_IRQ2] = "failed to request second irq",
+	[PPC_ADMA_INIT_REGISTER] = "failed to register dma async device",
+};
+
+static enum ppc_adma_init_code
+ppc460ex_adma_devices[PPC460EX_ADMA_ENGINES_NUM];
+
+struct ppc_dma_chan_ref {
+	struct dma_chan *chan;
+	struct list_head node;
+};
+
+/*
+ * The list of channels exported by ppc460ex ADMA
+ */
+struct list_head
+ppc460ex_adma_chan_list = LIST_HEAD_INIT(ppc460ex_adma_chan_list);
+
+/*
+ * Pointer to DMA0 CP/CS FIFO
+ */
+static void *ppc460ex_dma_fifo_buf;
+
+/*
+ * Pointers to last submitted to DMA0
+ */
+static struct ppc460ex_adma_desc_slot *chan_last_sub[1];
+static struct ppc460ex_adma_desc_slot *chan_first_cdb[1];
+
+/*
+ * Since RXOR operations use the common register (MQ0_CF2H) for setting-up
+ * the block size in transactions, then we do not allow to activate more than
+ * only one RXOR transactions simultaneously. So use this var to store
+ * the information about is RXOR currently active (PPC460EX_RXOR_RUN bit is
+ * set) or not (PPC460EX_RXOR_RUN is clear).
+ */
+static unsigned long ppc460ex_rxor_state;
+/*
+ * This array is used in data-check operations for storing a pattern
+ */
+static char ppc460ex_qword[16];
+
+
+/*
+ *  These are used in enable & check routines
+ */
+static u32 ppc460ex_r6_enabled;
+static u32 ppc460ex_r5_enabled;
+
+static struct pc460ex_adma_chan *ppc460ex_r6_tchan;
+static struct pc460ex_adma_chan *ppc460ex_r5_tchan;
+static struct completion ppc460ex_r6_test_comp;
+static struct completion ppc460ex_r5_test_comp;
+static atomic_t ppc460ex_adma_err_irq_ref;
+static dcr_host_t ppc460ex_mq_dcr_host;
+static unsigned int ppc460ex_mq_dcr_len;
+
+static int ppc460ex_adma_alloc_chan_resources(struct dma_chan *chan);
+static struct ppc460ex_adma_desc_slot *ppc460ex_adma_alloc_slots(
+		struct ppc460ex_adma_chan *chan, int num_slots,
+		int slots_per_op);
+
+/******************************************************************************
+ * Command (Descriptor) Blocks low-level routines
+ ******************************************************************************/
+/*
+ * ppc460ex_desc_init_interrupt - initialize the descriptor for INTERRUPT
+ * pseudo operation
+ */
+static inline void ppc460ex_desc_init_interrupt(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan)
+{
+	memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+	/*
+	 * NOP with interrupt
+	 */
+	set_bit(PPC460EX_DESC_INT, &desc->flags);
+}
+/*
+ * ppc460ex_desc_init_pqzero_sum - initialize the descriptor
+ * for PQ_ZERO_SUM operation
+ */
+static void ppc460ex_desc_init_pqzero_sum(
+				struct ppc460ex_adma_desc_slot *desc,
+				int dst_cnt, int src_cnt)
+{
+	struct dma_cdb *hw_desc;
+	struct ppc460ex_adma_desc_slot *iter;
+	int i = 0;
+	u8 dopc = (dst_cnt == 2) ? DMA_CDB_OPC_MULTICAST :
+				   DMA_CDB_OPC_MV_SG1_SG2;
+	/*
+	 * Initialize starting from 2nd or 3rd descriptor dependent
+	 * on dst_cnt. First one or two slots are for cloning P
+	 * and/or Q to chan->pdest and/or chan->qdest as we have
+	 * to preserve original P/Q.
+	 */
+	iter = list_first_entry(&desc->group_list,
+				struct ppc460ex_adma_desc_slot, chain_node);
+	iter = list_entry(iter->chain_node.next,
+			  struct ppc460ex_adma_desc_slot, chain_node);
+
+	if (dst_cnt > 1) {
+		iter = list_entry(iter->chain_node.next,
+				  struct ppc460ex_adma_desc_slot, chain_node);
+	}
+	/*
+	 * initialize each source descriptor in chain
+	 */
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
+			/*
+			 * DMA_CDB_OPC_DCHECK128 operation
+			 */
+			hw_desc->opc = DMA_CDB_OPC_DCHECK128;
+
+		if (likely(!list_is_last(&iter->chain_node,
+					 &desc->group_list))) {
+			/*
+			 * set 'next' pointer
+			 */
+			iter->hw_next = list_entry(iter->chain_node.next,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
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
+			set_bit(PPC460EX_DESC_INT, &iter->flags);
+		}
+	}
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = dst_cnt;
+}
+/*
+ * ppc460ex_desc_init_memcpy - initialize the descriptor for MEMCPY operation
+ */
+static inline void ppc460ex_desc_init_memcpy(
+		struct ppc460ex_adma_desc_slot *desc,
+		unsigned long flags)
+{
+	struct dma_cdb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+	desc->hw_next = NULL;
+	desc->src_cnt = 1;
+	desc->dst_cnt = 1;
+
+	if (flags & DMA_PREP_INTERRUPT)
+		set_bit(PPC460EX_DESC_INT, &desc->flags);
+	else
+		clear_bit(PPC460EX_DESC_INT, &desc->flags);
+
+	hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+}
+
+/*
+ * ppc460ex_desc_init_memset - initialize the descriptor for MEMSET operation
+ */
+static inline void ppc460ex_desc_init_memset(
+		struct ppc460ex_adma_desc_slot *desc, int value,
+		unsigned long flags)
+{
+	struct dma_cdb *hw_desc = desc->hw_desc;
+
+	memset(desc->hw_desc, 0, sizeof(struct dma_cdb));
+	desc->hw_next = NULL;
+	desc->src_cnt = 1;
+	desc->dst_cnt = 1;
+
+	if (flags & DMA_PREP_INTERRUPT)
+		set_bit(PPC460EX_DESC_INT, &desc->flags);
+	else
+		clear_bit(PPC460EX_DESC_INT, &desc->flags);
+
+	hw_desc->sg1u = hw_desc->sg1l = cpu_to_le32((u32)value);
+	hw_desc->sg3u = hw_desc->sg3l = cpu_to_le32((u32)value);
+	hw_desc->opc = DMA_CDB_OPC_DFILL128;
+}
+/*
+ * ppc460ex_desc_assign_cookie - assign a cookie
+ */
+static dma_cookie_t ppc460ex_desc_assign_cookie(struct ppc460ex_adma_chan *chan,
+		struct ppc460ex_adma_desc_slot *desc)
+{
+	dma_cookie_t cookie = chan->common.cookie;
+	cookie++;
+	if (cookie < 0)
+		cookie = 1;
+	chan->common.cookie = desc->async_tx.cookie = cookie;
+	return cookie;
+}
+/*
+ * ppc460ex_desc_set_src_addr - set source address into the descriptor
+ */
+static inline void ppc460ex_desc_set_src_addr(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, int src_idx,
+		dma_addr_t addrh, dma_addr_t addrl)
+{
+	struct dma_cdb *dma_hw_desc;
+	phys_addr_t addr64, tmplow, tmphi;
+
+	if (!addrh) {
+		addr64 = addrl;
+		tmphi = (addr64 >> 32);
+		tmplow = (addr64 & 0xFFFFFFFF);
+	} else {
+		tmphi = addrh;
+		tmplow = addrl;
+	}
+	dma_hw_desc = desc->hw_desc;
+	dma_hw_desc->sg1l = cpu_to_le32((u32)tmplow);
+	dma_hw_desc->sg1u = cpu_to_le32((u32)tmphi);
+}
+
+/*
+ * ppc460ex_desc_set_src_mult - set source address mult into the descriptor
+ */
+static inline void ppc460ex_desc_set_src_mult(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, u32 mult_index, int sg_index,
+		unsigned char mult_value)
+{
+	struct dma_cdb *dma_hw_desc;
+	u32 *psgu;
+
+	dma_hw_desc = desc->hw_desc;
+
+	switch (sg_index) {
+	/*
+	 * for RXOR operations set multiplier
+	 * into source cued address
+	 */
+	case DMA_CDB_SG_SRC:
+		psgu = &dma_hw_desc->sg1u;
+		break;
+	/*
+	 * for WXOR operations set multiplier
+	 * into destination cued address(es)
+	 */
+	case DMA_CDB_SG_DST1:
+		psgu = &dma_hw_desc->sg2u;
+		break;
+	case DMA_CDB_SG_DST2:
+		psgu = &dma_hw_desc->sg3u;
+		break;
+	default:
+		BUG();
+	}
+
+	*psgu |= cpu_to_le32(mult_value << mult_index);
+}
+
+/*
+ * ppc460ex_desc_set_dest_addr - set destination address into the descriptor
+ */
+static inline void ppc460ex_desc_set_dest_addr(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan,
+		dma_addr_t addrh, dma_addr_t addrl,
+		u32 dst_idx)
+{
+	struct dma_cdb *dma_hw_desc;
+	phys_addr_t addr64, tmphi, tmplow;
+	u32 *psgu, *psgl;
+
+	if (!addrh) {
+		addr64 = addrl;
+		tmphi = (addr64 >> 32);
+		tmplow = (addr64 & 0xFFFFFFFF);
+	} else {
+		tmphi = addrh;
+		tmplow = addrl;
+	}
+	dma_hw_desc = desc->hw_desc;
+
+	psgu = dst_idx ? &dma_hw_desc->sg3u : &dma_hw_desc->sg2u;
+	psgl = dst_idx ? &dma_hw_desc->sg3l : &dma_hw_desc->sg2l;
+
+	*psgl = cpu_to_le32((u32)tmplow);
+	*psgu |= cpu_to_le32((u32)tmphi);
+}
+
+/*
+ * ppc460ex_desc_set_byte_count - set number of data bytes involved
+ * into the operation
+ */
+static inline void ppc460ex_desc_set_byte_count(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, u32 byte_count)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	dma_hw_desc = desc->hw_desc;
+	dma_hw_desc->cnt = cpu_to_le32(byte_count);
+}
+/*
+ * ppc460ex_desc_set_rxor_block_size - set RXOR block size
+ */
+static inline void ppc460ex_desc_set_rxor_block_size(u32 byte_count)
+{
+	/*
+	 * assume that byte_count is aligned on the 512-boundary;
+	 * thus write it directly to the register (bits 23:31 are
+	 * reserved there).
+	 */
+	mtdcr(DCRN_MQ0_CF2H, byte_count);
+}
+/*
+ * ppc460ex_desc_set_dcheck - set CHECK pattern
+ */
+static inline void ppc460ex_desc_set_dcheck(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, u8 *qword)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	dma_hw_desc = desc->hw_desc;
+	out_le32(&dma_hw_desc->sg3l, qword[0]);
+	out_le32(&dma_hw_desc->sg3u, qword[4]);
+	out_le32(&dma_hw_desc->sg2l, qword[8]);
+	out_le32(&dma_hw_desc->sg2u, qword[12]);
+}
+/*
+ * ppc460ex_desc_get_src_num - extract the number of source addresses from
+ * the descriptor
+ */
+static inline u32 ppc460ex_desc_get_src_num(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	dma_hw_desc = desc->hw_desc;
+
+	switch (dma_hw_desc->opc) {
+	case DMA_CDB_OPC_NO_OP:
+	case DMA_CDB_OPC_DFILL128:
+		return 0;
+	case DMA_CDB_OPC_DCHECK128:
+		return 1;
+	case DMA_CDB_OPC_MV_SG1_SG2:
+	case DMA_CDB_OPC_MULTICAST:
+		/*
+		 * Only for RXOR operations we have more than
+		 * one source
+		 */
+		if (le32_to_cpu(dma_hw_desc->sg1u) &
+		    DMA_CUED_XOR_WIN_MSK) {
+			/* RXOR op, there are 2 or 3 sources */
+			if (((le32_to_cpu(dma_hw_desc->sg1u) >>
+			    DMA_CUED_REGION_OFF) &
+			      DMA_CUED_REGION_MSK) == DMA_RXOR12) {
+				/* RXOR 1-2 */
+				return 2;
+			} else {
+				/* RXOR 1-2-3/1-2-4/1-2-5 */
+				return 3;
+			}
+		}
+		return 1;
+	default:
+		dev_dbg(chan->device->common.dev, "%s: unknown OPC 0x%02x\n",
+			__func__, dma_hw_desc->opc);
+		BUG();
+	}
+
+	return 0;
+}
+
+/*
+ * ppc460ex_desc_get_dst_num - get the number of destination addresses in
+ * this descriptor
+ */
+static inline u32 ppc460ex_desc_get_dst_num(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	/*
+	 * May be 1 or 2 destinations
+	 */
+	dma_hw_desc = desc->hw_desc;
+	switch (dma_hw_desc->opc) {
+	case DMA_CDB_OPC_NO_OP:
+	case DMA_CDB_OPC_DCHECK128:
+		return 0;
+	case DMA_CDB_OPC_MV_SG1_SG2:
+	case DMA_CDB_OPC_DFILL128:
+		return 1;
+	case DMA_CDB_OPC_MULTICAST:
+		return 2;
+	default:
+		dev_dbg(chan->device->common.dev, "%s: unknown OPC 0x%02x\n",
+			__func__, dma_hw_desc->opc);
+		BUG();
+	}
+	return 0;
+}
+/*
+ * ppc460ex_desc_get_src_addr - extract the source address from the descriptor
+ */
+static inline u32 ppc460ex_desc_get_src_addr(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, int src_idx)
+{
+	struct dma_cdb *dma_hw_desc;
+	u32 sg11;
+
+	dma_hw_desc = desc->hw_desc;
+	/*
+	 * May have 0, 1, 2, or 3 sources
+	 */
+	switch (dma_hw_desc->opc) {
+	case DMA_CDB_OPC_NO_OP:
+	case DMA_CDB_OPC_DFILL128:
+		return 0;
+	case DMA_CDB_OPC_DCHECK128:
+		if (unlikely(src_idx)) {
+			dev_dbg(chan->device->common.dev,
+				"%s: try to get %d source for"
+				" DCHECK128\n", __func__, src_idx);
+			BUG();
+		}
+		return le32_to_cpu(dma_hw_desc->sg1l);
+	case DMA_CDB_OPC_MULTICAST:
+	case DMA_CDB_OPC_MV_SG1_SG2:
+		if (unlikely(src_idx > 2)) {
+			dev_dbg(chan->device->common.dev,
+				"%s: try to get %d source from"
+				" DMA descr\n", __func__, src_idx);
+			BUG();
+		}
+		if (src_idx) {
+			if (le32_to_cpu(dma_hw_desc->sg1u) &
+			    DMA_CUED_XOR_WIN_MSK) {
+				u8 region;
+
+				if (src_idx == 1)
+					return le32_to_cpu(
+					    dma_hw_desc->sg1l) +
+						desc->unmap_len;
+
+				region = (le32_to_cpu(
+				    dma_hw_desc->sg1u)) >>
+					DMA_CUED_REGION_OFF;
+
+				region &= DMA_CUED_REGION_MSK;
+				switch (region) {
+				case DMA_RXOR123:
+					return le32_to_cpu(
+					    dma_hw_desc->sg1l) +
+						(desc->unmap_len << 1);
+				case DMA_RXOR124:
+					return le32_to_cpu(
+					    dma_hw_desc->sg1l) +
+						(desc->unmap_len * 3);
+				case DMA_RXOR125:
+					return le32_to_cpu(
+					    dma_hw_desc->sg1l) +
+						(desc->unmap_len << 2);
+				default:
+					dev_dbg(chan->device->common.dev,
+					    "%s: try to"
+					    " get src3 for region %02x"
+					    "PPC460EX_DESC_RXOR12?\n",
+					    __func__, region);
+					BUG();
+				}
+			} else {
+				dev_dbg(chan->device->common.dev,
+					"%s: try to get %d"
+					" source for non-cued descr\n",
+					__func__, src_idx);
+				BUG();
+			}
+		}
+		return le32_to_cpu(dma_hw_desc->sg1l);
+	default:
+		dev_dbg(chan->device->common.dev, "%s: unknown OPC 0x%02x\n",
+			__func__, dma_hw_desc->opc);
+		BUG();
+	}
+	sg11 = le32_to_cpu(dma_hw_desc->sg1l);
+	return sg11;
+}
+
+/*
+ * ppc460ex_desc_get_dest_addr - extract the destination address from the
+ * descriptor
+ */
+static inline u32 ppc460ex_desc_get_dest_addr(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan, int idx)
+{
+	struct dma_cdb *dma_hw_desc;
+
+	dma_hw_desc = desc->hw_desc;
+
+	if (likely(!idx))
+		return le32_to_cpu(dma_hw_desc->sg2l);
+	return le32_to_cpu(dma_hw_desc->sg3l);
+}
+/*
+ * ppc460ex_desc_get_link - get the address of the descriptor that
+ * follows this one
+ */
+static inline u32 ppc460ex_desc_get_link(struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan)
+{
+	if (!desc->hw_next)
+		return 0;
+
+	return desc->hw_next->phys;
+}
+/******************************************************************************
+ * ADMA channel low-level routines
+ ******************************************************************************/
+static inline u32 ppc460ex_chan_get_current_descriptor(
+		struct ppc460ex_adma_chan *chan);
+static inline void ppc460ex_chan_append(struct ppc460ex_adma_chan *chan);
+static void ppc460ex_dma_put_desc(struct ppc460ex_adma_chan *chan,
+		struct ppc460ex_adma_desc_slot *desc);
+
+/*
+ * ppc460ex_adma_device_clear_eot_status - interrupt ack to XOR or DMA engine
+ */
+static inline void ppc460ex_adma_device_clear_eot_status(
+		struct ppc460ex_adma_chan *chan)
+{
+	struct dma_regs *dma_reg;
+	u8 *p = chan->device->dma_desc_pool_virt;
+	struct dma_cdb *cdb;
+	u32 rv, i;
+
+	/*
+	 * read FIFO to ack
+	 */
+	dma_reg = (struct dma_regs *)chan->device->dma_reg;
+	while ((rv = in_le32(&dma_reg->csfpl))) {
+		i = rv & DMA_CDB_ADDR_MSK;
+		cdb = (struct dma_cdb *)&p[i -
+		    (u32)chan->device->dma_desc_pool];
+
+		/* Clear opcode to ack. This is necessary for
+		 * ZeroSum operations only
+		 */
+		cdb->opc = 0;
+
+		if (test_bit(PPC460EX_RXOR_RUN,
+		    &ppc460ex_rxor_state)) {
+			/* probably this is a completed RXOR op,
+			 * get pointer to CDB using the fact that
+			 * physical and virtual addresses of CDB
+			 * in pools have the same offsets
+			 */
+			if (le32_to_cpu(cdb->sg1u) &
+			    DMA_CUED_XOR_BASE) {
+				/* this is a RXOR */
+				clear_bit(PPC460EX_RXOR_RUN,
+				    &ppc460ex_rxor_state);
+			}
+		}
+
+		if (rv & DMA_CDB_STATUS_MSK) {
+			/*
+			 * ZeroSum check failed
+			 */
+			struct ppc460ex_adma_desc_slot *iter;
+			dma_addr_t phys = rv & ~DMA_CDB_MSK;
+
+			/*
+			 * Update the status of corresponding
+			 * descriptor.
+			 */
+			list_for_each_entry(iter, &chan->chain,
+			    chain_node) {
+				if (iter->phys == phys)
+					break;
+			}
+			/*
+			 * if cannot find the corresponding
+			 * slot it's a bug
+			 */
+			BUG_ON(&iter->chain_node == &chan->chain);
+
+			if (iter->xor_check_result)
+				*iter->xor_check_result |=
+				    rv & DMA_CDB_STATUS_MSK;
+		}
+	}
+
+	rv = in_le32(&dma_reg->dsts);
+	if (rv) {
+		dev_dbg(chan->device->common.dev,
+				"DMA%d err status: 0x%x\n", chan->device->id,
+			rv);
+		/*
+		 * write back to clear
+		 */
+		out_le32(&dma_reg->dsts, rv);
+	}
+}
+/*
+ * ppc460ex_chan_is_busy - get the channel status
+ */
+static inline int ppc460ex_chan_is_busy(struct ppc460ex_adma_chan *chan)
+{
+	int busy = 0;
+	struct dma_regs *dma_reg;
+
+	dma_reg = (struct dma_regs *)chan->device->dma_reg;
+	/*
+	 * if command FIFO's head and tail pointers are equal and
+	 * status tail is the same as command, then channel is free
+	 */
+	if (dma_reg->cpfhp != dma_reg->cpftp ||
+	    dma_reg->cpftp != dma_reg->csftp)
+		busy = 1;
+
+	return busy;
+}
+/*
+ * ppc460ex_chan_append - update the h/w chain in the channel
+ */
+void ppc460ex_chan_append(struct ppc460ex_adma_chan *chan)
+{
+	struct dma_regs *dma_reg;
+	struct ppc460ex_adma_desc_slot *iter;
+	u32 cur_desc;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	dma_reg = (struct dma_regs *)chan->device->dma_reg;
+	cur_desc = ppc460ex_chan_get_current_descriptor(chan);
+
+	if (likely(cur_desc)) {
+		iter = chan_last_sub[chan->device->id];
+		BUG_ON(!iter);
+	} else {
+		/*
+		 * first peer
+		 */
+		iter = chan_first_cdb[chan->device->id];
+		BUG_ON(!iter);
+		ppc460ex_dma_put_desc(chan, iter);
+		chan->hw_chain_inited = 1;
+	}
+	/*
+	 * is there something new to append
+	 */
+	if (!iter->hw_next)
+		goto out;
+	/*
+	 * flush descriptors from the s/w queue to fifo
+	 */
+	list_for_each_entry_continue(iter, &chan->chain, chain_node) {
+		ppc460ex_dma_put_desc(chan, iter);
+		if (!iter->hw_next)
+			break;
+	}
+out:
+	local_irq_restore(flags);
+}
+
+/*
+ * ppc460ex_chan_get_current_descriptor - get the currently executed descriptor
+ */
+u32 ppc460ex_chan_get_current_descriptor(struct ppc460ex_adma_chan *chan)
+{
+	struct dma_regs *dma_reg;
+
+	if (unlikely(!chan->hw_chain_inited))
+		/*
+		 * h/w descriptor chain is not initialized yet
+		 */
+		return 0;
+
+		dma_reg = (struct dma_regs *)chan->device->dma_reg;
+		return (le32_to_cpu(dma_reg->acpl)) & (~DMA_CDB_MSK);
+}
+/*
+ * ppc460ex_dma_put_desc - put DMA0,1 descriptor to FIFO
+ */
+static void ppc460ex_dma_put_desc(struct ppc460ex_adma_chan *chan,
+		struct ppc460ex_adma_desc_slot *desc)
+{
+	u32 pcdb;
+	struct dma_regs *dma_reg =
+		dma_reg = (struct dma_regs *)chan->device->dma_reg;
+
+	pcdb = desc->phys;
+	if (!test_bit(PPC460EX_DESC_INT, &desc->flags))
+		pcdb |= DMA_CDB_NO_INT;
+
+	chan_last_sub[chan->device->id] = desc;
+
+	out_le32(&dma_reg->cpfpl, pcdb);
+
+}
+/******************************************************************************
+ *  ADMA device level
+ *****************************************************************************/
+
+static dma_cookie_t ppc460ex_adma_tx_submit(
+		struct dma_async_tx_descriptor *tx);
+static inline void ppc460ex_adma_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr, int index);
+
+static void ppc460ex_adma_pqzero_sum_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos);
+static void ppc460ex_adma_pq_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos);
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_mq_xor(
+		struct dma_chan *chan, dma_addr_t dst,
+		dma_addr_t *src, unsigned int src_cnt,
+		size_t len, unsigned long flags);
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_p(
+		struct dma_chan *chan, dma_addr_t *dst,	dma_addr_t *src,
+		unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags);
+static struct ppc460ex_adma_desc_slot *ppc460ex_dma01_prep_mult(
+		struct ppc460ex_adma_chan *ppc460ex_chan,
+		dma_addr_t *dst, int dst_cnt, dma_addr_t *src, int src_cnt,
+		const unsigned char *scf, size_t len, unsigned long flags);
+static struct ppc460ex_adma_desc_slot *ppc460ex_dma_prep_pq(
+		struct ppc460ex_adma_chan *ppc460ex_chan,
+		dma_addr_t *dst, unsigned int dst_cnt,
+		dma_addr_t *src, unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags);
+
+static void ppc460ex_adma_pqxor_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos);
+static void ppc460ex_adma_pqxor_set_src(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr, int index);
+
+static void ppc460ex_adma_pqxor_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t *addrs, unsigned long flags);
+static void ppc460ex_adma_pqzero_sum_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t paddr, dma_addr_t qaddr);
+static void ppc460ex_desc_init_pq(struct ppc460ex_adma_desc_slot *desc,
+		int dst_cnt, int src_cnt, unsigned long flags,
+		unsigned long op);
+static inline void ppc460ex_adma_memcpy_xor_set_src(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr, int index);
+#define DMA_CTRL_FLAGS_LAST	DMA_PREP_FENCE
+#define DMA_PREP_ZERO_P		(DMA_CTRL_FLAGS_LAST << 1)
+#define DMA_PREP_ZERO_Q		(DMA_PREP_ZERO_P << 1)
+/*
+ * ppc460ex_can_rxor - check if the operands may be processed with RXOR
+ */
+int ppc460ex_can_rxor(struct page **srcs, int src_cnt, size_t len)
+{
+	int i, order = 0, state = 0;
+
+	if (unlikely(!(src_cnt > 1)))
+		return 0;
+
+	for (i = 1; i < src_cnt; i++) {
+		char *cur_addr = page_address(srcs[i]);
+		char *old_addr = page_address(srcs[i-1]);
+		switch (state) {
+		case 0:
+			if (cur_addr == old_addr + len) {
+				/* direct RXOR */
+				order = 1;
+				state = 1;
+			} else
+			if (old_addr == cur_addr + len) {
+				/* reverse RXOR */
+				order = -1;
+				state = 1;
+			} else
+				goto out;
+			break;
+		case 1:
+			if ((i == src_cnt-2) ||
+			    (order == -1 && cur_addr != old_addr - len)) {
+				order = 0;
+				state = 0;
+			} else
+			if ((cur_addr == old_addr + len*order) ||
+			    (cur_addr == old_addr + 2*len) ||
+			    (cur_addr == old_addr + 3*len)) {
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
+out:
+	if (state == 1 || state == 2)
+		return 1;
+
+	return 0;
+}
+/*
+ * ppc460ex_adma_device_estimate - estimate the efficiency of processing
+ *	the operation given on this channel. It's assumed that 'chan' is
+ *	capable to process 'cap' type of operation.
+ * @chan: channel to use
+ * @cap: type of transaction
+ * @dst_lst: array of destination pointers
+ * @src_lst: array of source pointers
+ * @src_cnt: number of source operands
+ * @src_sz: size of each source operand
+ */
+int ppc460ex_adma_estimate(struct dma_chan *chan,
+	enum dma_transaction_type cap, struct page **dst_lst, int dst_cnt,
+	struct page **src_lst,	int src_cnt, size_t src_sz)
+{
+	int ef = 1;
+
+	if (cap == DMA_PQ || cap == DMA_PQ_VAL) {
+		/*
+		 * If RAID-6 capabilities were not activated don't try
+		 * to use them
+		 */
+		if (unlikely(!ppc460ex_r6_enabled))
+			return -1;
+	}
+	if (cap == DMA_XOR) {
+		if (unlikely(!ppc460ex_r5_enabled))
+			return -1;
+	}
+	/*  in the current implementation of ppc460ex ADMA driver it
+	 * makes sense to pick out only pqxor case, because it may be
+	 * processed:
+	 * (1) either using Biskup method on DMA2;
+	 * (2) or on DMA0/1.
+	 *  Thus we give a favour to (1) if the sources are suitable;
+	 * else let it be processed on one of the DMA0/1 engines.
+	 */
+	if (cap == DMA_PQ) {
+		if (ppc460ex_can_rxor(src_lst, src_cnt, src_sz))
+			ef = 3; /* override (dma0 + idle) */
+		else
+			ef = 0; /* can't process on DMA2 if !rxor */
+	}
+
+	/*
+	 * channel idleness increases the priority
+	 */
+	if (likely(ef) &&
+	    !ppc460ex_chan_is_busy(to_ppc460ex_adma_chan(chan)))
+		ef++;
+
+	return ef;
+}
+struct dma_chan *
+ppc460ex_async_tx_find_best_channel(enum dma_transaction_type cap,
+	struct page **dst_lst, int dst_cnt, struct page **src_lst,
+	int src_cnt, size_t src_sz)
+{
+	struct dma_chan *best_chan = NULL;
+	struct ppc_dma_chan_ref *ref;
+	int best_rank = -1;
+
+	if (unlikely(!src_sz))
+		return NULL;
+	if (src_sz > PAGE_SIZE) {
+		switch (cap) {
+		case DMA_PQ:
+			if (src_cnt == 1 && dst_lst[1] == src_lst[0])
+				return NULL;
+			if (src_cnt == 2 && dst_lst[1] == src_lst[1])
+				return NULL;
+			break;
+		default:
+			break;
+		}
+	}
+	list_for_each_entry(ref, &ppc460ex_adma_chan_list, node) {
+		if (dma_has_cap(cap, ref->chan->device->cap_mask)) {
+			int rank;
+
+			rank = ppc460ex_adma_estimate(ref->chan, cap, dst_lst,
+					dst_cnt, src_lst, src_cnt, src_sz);
+			if (rank > best_rank) {
+				best_rank = rank;
+				best_chan = ref->chan;
+			}
+		}
+	}
+	return best_chan;
+}
+/*
+ * ppc460ex_get_group_entry - get group entry with index idx
+ * @tdesc: is the last allocated slot in the group.
+ */
+struct ppc460ex_adma_desc_slot *
+ppc460ex_get_group_entry(struct ppc460ex_adma_desc_slot *tdesc,
+		u32 entry_idx)
+{
+	struct ppc460ex_adma_desc_slot *iter = tdesc->group_head;
+	int i = 0;
+
+	if (entry_idx < 0 || entry_idx >= (tdesc->src_cnt + tdesc->dst_cnt)) {
+		pr_debug("%s: entry_idx %d, src_cnt %d, dst_cnt %d\n",
+				__func__, entry_idx, tdesc->src_cnt,
+				tdesc->dst_cnt);
+		BUG();
+	}
+	list_for_each_entry(iter, &tdesc->group_list, chain_node) {
+		if (i++ == entry_idx)
+			break;
+	}
+	return iter;
+}
+/*
+ * ppc460ex_adma_free_slots - flags descriptor slots for reuse
+ * @slot: Slot to free
+ * Caller must hold &ppc460ex_chan->lock while calling this function
+ */
+void ppc460ex_adma_free_slots(struct ppc460ex_adma_desc_slot *slot,
+		struct ppc460ex_adma_chan *chan)
+{
+	int stride = slot->slots_per_op;
+
+	while (stride--) {
+		slot->slots_per_op = 0;
+		slot = list_entry(slot->slot_node.next,
+				struct ppc460ex_adma_desc_slot,
+				slot_node);
+	}
+}
+
+void ppc460ex_adma_unmap(struct ppc460ex_adma_chan *chan,
+		struct ppc460ex_adma_desc_slot *desc)
+{
+	u32 src_cnt, dst_cnt;
+	dma_addr_t addr;
+	/*
+	 * get the number of sources & destination
+	 * included in this descriptor and unmap
+	 * them all
+	 */
+	src_cnt = ppc460ex_desc_get_src_num(desc, chan);
+	dst_cnt = ppc460ex_desc_get_dst_num(desc, chan);
+
+	/*
+	 * unmap destinations
+	 */
+	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+		while (dst_cnt--) {
+			addr = ppc460ex_desc_get_dest_addr(
+				desc, chan, dst_cnt);
+			dma_unmap_page(chan->device->dev,
+					addr, desc->unmap_len,
+					DMA_FROM_DEVICE);
+		}
+	}
+
+	/*
+	 * unmap sources
+	 */
+	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+		while (src_cnt--) {
+			addr = ppc460ex_desc_get_src_addr(
+				desc, chan, src_cnt);
+			dma_unmap_page(chan->device->dev,
+					addr, desc->unmap_len,
+					DMA_TO_DEVICE);
+		}
+	}
+
+}
+/*
+ * ppc460ex_adma_run_tx_complete_actions - call functions to be called
+ * upon complete
+ */
+dma_cookie_t ppc460ex_adma_run_tx_complete_actions(
+		struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan,
+		dma_cookie_t cookie)
+{
+	int i;
+
+	BUG_ON(desc->async_tx.cookie < 0);
+	if (desc->async_tx.cookie > 0) {
+		cookie = desc->async_tx.cookie;
+		desc->async_tx.cookie = 0;
+
+		/*
+		 * call the callback (must not sleep or submit new
+		 * operations to this channel)
+		 */
+		if (desc->async_tx.callback)
+			desc->async_tx.callback(
+				desc->async_tx.callback_param);
+
+		/* unmap dma addresses
+		 * (unmap_single vs unmap_page?)
+		 *
+		 * actually, ppc's dma_unmap_page() functions are empty, so
+		 * the following code is just for the sake of completeness
+		 */
+		if (chan && chan->needs_unmap && desc->group_head &&
+		     desc->unmap_len) {
+			struct ppc460ex_adma_desc_slot *unmap =
+				desc->group_head;
+			/*
+			 * assume 1 slot per op always
+			 */
+			u32 slot_count = unmap->slot_cnt;
+
+			/*
+			 * Run through the group list and unmap addresses
+			 */
+			for (i = 0; i < slot_count; i++) {
+				BUG_ON(!unmap);
+				ppc460ex_adma_unmap(chan, unmap);
+				unmap = unmap->hw_next;
+			}
+		}
+	}
+
+	/*
+	 * run dependent operations
+	 */
+	dma_run_dependencies(&desc->async_tx);
+
+	return cookie;
+}
+/*
+ * ppc460ex_adma_clean_slot - clean up CDB slot (if ack is set)
+ */
+int ppc460ex_adma_clean_slot(struct ppc460ex_adma_desc_slot *desc,
+		struct ppc460ex_adma_chan *chan)
+{
+	struct dma_cdb *cdb ;
+	/*
+	 * the client is allowed to attach dependent operations
+	 * until 'ack' is set
+	 */
+	if (!async_tx_test_ack(&desc->async_tx))
+		return 0;
+
+	/*
+	 * leave the last descriptor in the chain
+	 * so we can append to it
+	 */
+	if (list_is_last(&desc->chain_node, &chan->chain) ||
+	    desc->phys == ppc460ex_chan_get_current_descriptor(chan))
+		return 1;
+
+	/* our DMA interrupt handler clears opc field of
+	 * each processed descriptor. For all types of
+	 * operations except for ZeroSum we do not actually
+	 * need ack from the interrupt handler. ZeroSum is a
+	 * gtcial case since the result of this operation
+	 * is available from the handler only, so if we see
+	 * such type of descriptor (which is unprocessed yet)
+	 * then leave it in chain.
+	 */
+	cdb = desc->hw_desc;
+	if (cdb->opc == DMA_CDB_OPC_DCHECK128)
+		return 1;
+
+	dev_dbg(chan->device->common.dev, "\tfree slot %lx: %d stride: %d\n",
+		(ulong)desc->phys, desc->idx, desc->slots_per_op);
+
+	list_del(&desc->chain_node);
+	ppc460ex_adma_free_slots(desc, chan);
+	return 0;
+}
+/*
+ *__ppc460ex_adma_slot_cleanup - this is the common clean-up routine
+ *which runs through the channel CDBs list until reach the descriptor
+ *currently processed. When routine determines that all CDBs of group
+ *are completed then corresponding callbacks (if any) are called and slots
+ *are freed.
+ */
+void __ppc460ex_adma_slot_cleanup(struct ppc460ex_adma_chan *chan)
+{
+	struct ppc460ex_adma_desc_slot *iter, *_iter, *group_start = NULL;
+	dma_cookie_t cookie = 0;
+	u32 current_desc = ppc460ex_chan_get_current_descriptor(chan);
+	int busy = ppc460ex_chan_is_busy(chan);
+	int seen_current = 0, slot_cnt = 0, slots_per_op = 0;
+
+	dev_dbg(chan->device->common.dev, "ppc460ex adma%d: %s\n",
+		chan->device->id, __func__);
+
+	if (!current_desc) {
+		/*
+		 *  There were no transactions yet, so
+		 * nothing to clean
+		 */
+		return;
+	}
+
+	/*
+	 * free completed slots from the chain starting with
+	 * the oldest descriptor
+	 */
+	list_for_each_entry_safe(iter, _iter, &chan->chain,
+					chain_node) {
+		dev_dbg(chan->device->common.dev, "\tcookie: %d slot: %d "
+		    "busy: %d this_desc: %#x next_desc: %#x cur: %#x ack: %d\n",
+			iter->async_tx.cookie, iter->idx, busy, (u32)iter->phys,
+		    ppc460ex_desc_get_link(iter, chan), current_desc,
+			async_tx_test_ack(&iter->async_tx));
+		prefetch(_iter);
+		prefetch(&_iter->async_tx);
+
+		/*
+		 * do not advance past the current descriptor loaded into the
+		 * hardware channel,subsequent descriptors are either in process
+		 * or have not been submitted
+		 */
+		if (seen_current)
+			break;
+
+		/*
+		 * stop the search if we reach the current descriptor and the
+		 * channel is busy, or if it appears that the current descriptor
+		 * needs to be re-read (i.e. has been appended to)
+		 */
+		if (iter->phys == current_desc) {
+			BUG_ON(seen_current++);
+			if (busy || ppc460ex_desc_get_link(iter, chan)) {
+				/* not all descriptors of the group have
+				 * been completed; exit.
+				 */
+				break;
+			}
+		}
+
+		/*
+		 * detect the start of a group transaction
+		 */
+		if (!slot_cnt && !slots_per_op) {
+			slot_cnt = iter->slot_cnt;
+			slots_per_op = iter->slots_per_op;
+			if (slot_cnt <= slots_per_op) {
+				slot_cnt = 0;
+				slots_per_op = 0;
+			}
+		}
+
+		if (slot_cnt) {
+			if (!group_start)
+				group_start = iter;
+			slot_cnt -= slots_per_op;
+		}
+
+		/*
+		 * all the members of a group are complete
+		 */
+		if (slots_per_op != 0 && slot_cnt == 0) {
+			struct ppc460ex_adma_desc_slot *grp_iter, *_grp_iter;
+			int end_of_chain = 0;
+
+			/*
+			 * clean up the group
+			 */
+			slot_cnt = group_start->slot_cnt;
+			grp_iter = group_start;
+			list_for_each_entry_safe_from(grp_iter, _grp_iter,
+				&chan->chain, chain_node) {
+
+				cookie = ppc460ex_adma_run_tx_complete_actions(
+					grp_iter, chan, cookie);
+
+				slot_cnt -= slots_per_op;
+				end_of_chain = ppc460ex_adma_clean_slot(
+				    grp_iter, chan);
+				if (end_of_chain && slot_cnt) {
+					/*
+					 * Should wait for ZeroSum complete
+					 */
+					if (cookie > 0)
+						chan->completed_cookie = cookie;
+					return;
+				}
+
+				if (slot_cnt == 0 || end_of_chain)
+					break;
+			}
+
+			/*
+			 * the group should be complete at this point
+			 */
+			BUG_ON(slot_cnt);
+
+			slots_per_op = 0;
+			group_start = NULL;
+			if (end_of_chain)
+				break;
+			else
+				continue;
+			/*
+			 * wait for group completion
+			 */
+		} else if (slots_per_op)
+			continue;
+
+		cookie = ppc460ex_adma_run_tx_complete_actions(iter, chan,
+		    cookie);
+
+		if (ppc460ex_adma_clean_slot(iter, chan))
+			break;
+	}
+
+	BUG_ON(!seen_current);
+}
+/*
+ * ppc460ex_adma_tasklet - clean up watch-dog initiator
+ */
+void ppc460ex_adma_tasklet(unsigned long data)
+{
+	struct ppc460ex_adma_chan *chan = (struct ppc460ex_adma_chan *) data;
+	spin_lock_nested(&chan->lock, SINGLE_DEPTH_NESTING);
+	__ppc460ex_adma_slot_cleanup(chan);
+	spin_unlock(&chan->lock);
+}
+
+/*
+ * ppc460ex_adma_slot_cleanup - clean up scheduled initiator
+ */
+void ppc460ex_adma_slot_cleanup(struct ppc460ex_adma_chan *chan)
+{
+	spin_lock_bh(&chan->lock);
+	__ppc460ex_adma_slot_cleanup(chan);
+	spin_unlock_bh(&chan->lock);
+}
+/*
+ * ppc460ex_adma_alloc_slots - allocate free slots (if any)
+ */
+struct ppc460ex_adma_desc_slot *ppc460ex_adma_alloc_slots(
+		struct ppc460ex_adma_chan *chan, int num_slots,
+		int slots_per_op)
+{
+	struct ppc460ex_adma_desc_slot *iter = NULL, *_iter;
+	struct ppc460ex_adma_desc_slot *alloc_start = NULL;
+	struct list_head chain = LIST_HEAD_INIT(chain);
+	int slots_found, retry = 0;
+
+	BUG_ON(!num_slots || !slots_per_op);
+	/* start search from the last allocated descrtiptor
+	 * if a contiguous allocation can not be found start searching
+	 * from the beginning of the list
+	 */
+retry:
+	slots_found = 0;
+	if (retry == 0)
+		iter = chan->last_used;
+	else
+		iter = list_entry(&chan->all_slots,
+				struct ppc460ex_adma_desc_slot,
+				slot_node);
+	list_for_each_entry_safe_continue(iter, _iter, &chan->all_slots,
+	    slot_node) {
+		prefetch(_iter);
+		prefetch(&_iter->async_tx);
+		if (iter->slots_per_op) {
+			slots_found = 0;
+			continue;
+		}
+
+		/*
+		 * start the allocation if the slot is correctly aligned
+		 */
+		if (!slots_found++)
+			alloc_start = iter;
+		if (slots_found == num_slots) {
+			struct ppc460ex_adma_desc_slot *alloc_tail = NULL;
+			struct ppc460ex_adma_desc_slot *last_used = NULL;
+
+			iter = alloc_start;
+			while (num_slots) {
+				int i;
+				/*
+				 * pre-ack all but the last descriptor
+				 */
+				if (num_slots != slots_per_op)
+					async_tx_ack(&iter->async_tx);
+
+				list_add_tail(&iter->chain_node, &chain);
+				alloc_tail = iter;
+				iter->async_tx.cookie = 0;
+				iter->hw_next = NULL;
+				iter->flags = 0;
+				iter->slot_cnt = num_slots;
+				iter->xor_check_result = NULL;
+				for (i = 0; i < slots_per_op; i++) {
+					iter->slots_per_op = slots_per_op - i;
+					last_used = iter;
+					iter = list_entry(iter->slot_node.next,
+						struct ppc460ex_adma_desc_slot,
+						slot_node);
+				}
+				num_slots -= slots_per_op;
+			}
+			alloc_tail->group_head = alloc_start;
+			alloc_tail->async_tx.cookie = -EBUSY;
+			list_splice(&chain, &alloc_tail->group_list);
+			chan->last_used = last_used;
+			return alloc_tail;
+		}
+	}
+	if (!retry++)
+		goto retry;
+
+	/*
+	 * try to free some slots if the allocation fails
+	 */
+	tasklet_schedule(&chan->irq_tasklet);
+	return NULL;
+}
+/*
+ * ppc460ex_adma_alloc_chan_resources -  allocate pools for CDB slots
+ */
+int ppc460ex_adma_alloc_chan_resources(struct dma_chan *chan)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan;
+	struct ppc460ex_adma_desc_slot *slot = NULL;
+	char *hw_desc;
+	int i, db_sz;
+	int init;
+
+	ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	init = ppc460ex_chan->slots_allocated ? 0 : 1;
+	chan->chan_id = ppc460ex_chan->device->id;
+
+	/*
+	 * Allocate descriptor slots
+	 */
+	i = ppc460ex_chan->slots_allocated;
+	db_sz = sizeof(struct dma_cdb);
+
+	for (; i < (ppc460ex_chan->device->pool_size / db_sz); i++) {
+		slot = kzalloc(sizeof(struct ppc460ex_adma_desc_slot),
+				GFP_KERNEL);
+		if (!slot) {
+			dev_dbg(ppc460ex_chan->device->common.dev,
+					"EX/GT ADMA Channel only initialized"
+					" %d descriptor slots", i--);
+			break;
+		}
+		hw_desc = (char *) ppc460ex_chan->device->dma_desc_pool_virt;
+		slot->hw_desc = (void *) &hw_desc[i * db_sz];
+		dma_async_tx_descriptor_init(&slot->async_tx, chan);
+		slot->async_tx.tx_submit = ppc460ex_adma_tx_submit;
+		INIT_LIST_HEAD(&slot->chain_node);
+		INIT_LIST_HEAD(&slot->slot_node);
+		INIT_LIST_HEAD(&slot->group_list);
+		slot->phys = ppc460ex_chan->device->dma_desc_pool + i * db_sz;
+		slot->idx = i;
+
+		spin_lock_bh(&ppc460ex_chan->lock);
+		ppc460ex_chan->slots_allocated++;
+		list_add_tail(&slot->slot_node, &ppc460ex_chan->all_slots);
+		spin_unlock_bh(&ppc460ex_chan->lock);
+	}
+	if (i && !ppc460ex_chan->last_used) {
+		ppc460ex_chan->last_used =
+			list_entry(ppc460ex_chan->all_slots.next,
+					struct ppc460ex_adma_desc_slot,
+					slot_node);
+	}
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+			"ppc460ex adma%d: allocated %d descriptor slots\n",
+			ppc460ex_chan->device->id, i);
+
+	/*
+	 * initialize the channel and the chain with a null operation
+	 */
+	if (init) {
+		ppc460ex_chan->hw_chain_inited = 0;
+		/*
+		 * Use WXOR for self-testing
+		 */
+		if (!ppc460ex_r6_tchan)
+			ppc460ex_r6_tchan = ppc460ex_chan;
+		ppc460ex_chan->needs_unmap = 1;
+	}
+	return (i > 0) ? i : -ENOMEM;
+}
+/*
+ * ppc460ex_desc_set_link - set the address of descriptor following this
+ * descriptor in chain
+ */
+static inline void ppc460ex_desc_set_link(struct ppc460ex_adma_chan *chan,
+		struct ppc460ex_adma_desc_slot *prev_desc,
+		struct ppc460ex_adma_desc_slot *next_desc)
+{
+	unsigned long flags;
+
+	if (unlikely(!prev_desc || !next_desc ||
+		(prev_desc->hw_next && prev_desc->hw_next != next_desc))) {
+		/* If previous next is overwritten something is wrong.
+		 * though we may refetch from append to initiate list
+		 * processing; in this case - it's ok.
+		 */
+		dev_dbg(chan->device->common.dev,
+				"%s: prev_desc=0x%p; next_desc=0x%p; "
+				"prev->hw_next=0x%p\n", __func__, prev_desc,
+			next_desc, prev_desc ? prev_desc->hw_next : 0);
+		BUG();
+	}
+
+	local_irq_save(flags);
+
+	/*
+	 * do s/w chaining both for DMA and XOR descriptors
+	 */
+	prev_desc->hw_next = next_desc;
+	local_irq_restore(flags);
+}
+/*
+ * ppc460ex_adma_check_threshold - append CDBs to h/w chain if threshold
+ *	has been achieved
+ */
+static void ppc460ex_adma_check_threshold(struct ppc460ex_adma_chan *chan)
+{
+	dev_dbg(chan->device->common.dev, "ppc460ex adma%d: pending: %d\n",
+		chan->device->id, chan->pending);
+
+	if (chan->pending >= PPC460EX_ADMA_THRESHOLD) {
+		chan->pending = 0;
+		ppc460ex_chan_append(chan);
+	}
+}
+/*
+ * ppc460ex_adma_tx_submit - submit new descriptor group to the channel
+ *	(it's not necessary that descriptors will be submitted to the h/w
+ *	chains too right now)
+ */
+static dma_cookie_t ppc460ex_adma_tx_submit(struct dma_async_tx_descriptor *tx)
+{
+	struct ppc460ex_adma_desc_slot *sw_desc = tx_to_ppc460ex_adma_slot(tx);
+	struct ppc460ex_adma_chan *chan = to_ppc460ex_adma_chan(tx->chan);
+	struct ppc460ex_adma_desc_slot *group_start, *old_chain_tail;
+	int slot_cnt;
+	int slots_per_op;
+	dma_cookie_t cookie;
+
+	group_start = sw_desc->group_head;
+	slot_cnt = group_start->slot_cnt;
+	slots_per_op = group_start->slots_per_op;
+
+	spin_lock_bh(&chan->lock);
+
+	cookie = ppc460ex_desc_assign_cookie(chan, sw_desc);
+
+	if (unlikely(list_empty(&chan->chain))) {
+		/*
+		 *first peer
+		 */
+		list_splice_init(&sw_desc->group_list, &chan->chain);
+		chan_first_cdb[chan->device->id] = group_start;
+	} else {
+		/*
+		 * isn't first peer, bind CDBs to chain
+		 */
+		old_chain_tail = list_entry(chan->chain.prev,
+			struct ppc460ex_adma_desc_slot, chain_node);
+		list_splice_init(&sw_desc->group_list,
+		    &old_chain_tail->chain_node);
+		/*
+		 * fix up the hardware chain
+		 */
+		ppc460ex_desc_set_link(chan, old_chain_tail, group_start);
+	}
+
+	/*
+	 * increment the pending count by the number of operations
+	 */
+	chan->pending += slot_cnt / slots_per_op;
+	ppc460ex_adma_check_threshold(chan);
+	spin_unlock_bh(&chan->lock);
+
+	dev_dbg(chan->device->common.dev,
+		"ppc460ex adma%d: %s cookie: %d slot: %d tx %p\n",
+		chan->device->id, __func__,
+		sw_desc->async_tx.cookie, sw_desc->idx, sw_desc);
+	return cookie;
+}
+/*
+ * ppc460ex_adma_prep_dma_interrupt - prepare CDB for a pseudo DMA operation
+ */
+struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_interrupt(
+		struct dma_chan *chan, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op;
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d: %s\n", ppc460ex_chan->device->id,
+		__func__);
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+	slot_cnt = slots_per_op = 1;
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt,
+			slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		ppc460ex_desc_init_interrupt(group_start, ppc460ex_chan);
+		group_start->unmap_len = 0;
+		sw_desc->async_tx.flags = flags;
+	}
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+/*
+ * ppc460ex_adma_prep_dma_pqzero_sum - prepare CDB group for
+ * a PQ_ZERO_SUM operation
+ */
+struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_pqzero_sum(
+		struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
+		unsigned int src_cnt, const unsigned char *scf, size_t len,
+		enum sum_check_flags *pqres, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan;
+	struct ppc460ex_adma_desc_slot *sw_desc, *iter;
+	dma_addr_t pdest, qdest;
+	int slot_cnt, slots_per_op, idst, dst_cnt;
+
+	ppc460ex_chan = to_ppc460ex_adma_chan(chan);
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
+	spin_lock_bh(&ppc460ex_chan->lock);
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt,
+					     slots_per_op);
+	if (sw_desc) {
+		ppc460ex_desc_init_pqzero_sum(sw_desc, dst_cnt, src_cnt);
+
+		/*
+		 * Setup byte count for each slot just allocated
+		 */
+		sw_desc->async_tx.flags = flags;
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc460ex_desc_set_byte_count(iter, ppc460ex_chan,
+						      len);
+			iter->unmap_len = len;
+		}
+
+		if (pdest) {
+			struct dma_cdb *hw_desc;
+			struct ppc460ex_adma_chan *chan;
+
+			iter = sw_desc->group_head;
+			chan = to_ppc460ex_adma_chan(iter->async_tx.chan);
+			memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+			iter->hw_next = list_entry(iter->chain_node.next,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter->src_cnt = 0;
+			iter->dst_cnt = 0;
+			ppc460ex_desc_set_dest_addr(iter, chan, 0,
+						     ppc460ex_chan->pdest, 0);
+			ppc460ex_desc_set_src_addr(iter, chan, 0, 0, pdest);
+			ppc460ex_desc_set_byte_count(iter, ppc460ex_chan,
+						      len);
+			iter->unmap_len = 0;
+			/*
+			 * override pdest to preserve original P
+			 */
+			pdest = ppc460ex_chan->pdest;
+		}
+		if (qdest) {
+			struct dma_cdb *hw_desc;
+			struct ppc460ex_adma_chan *chan;
+
+			iter = list_first_entry(&sw_desc->group_list,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			chan = to_ppc460ex_adma_chan(iter->async_tx.chan);
+
+			if (pdest) {
+				iter = list_entry(iter->chain_node.next,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			}
+
+			memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+			iter->hw_next = list_entry(iter->chain_node.next,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter->src_cnt = 0;
+			iter->dst_cnt = 0;
+			ppc460ex_desc_set_dest_addr(iter, chan, 0,
+						     ppc460ex_chan->qdest, 0);
+			ppc460ex_desc_set_src_addr(iter, chan, 0, 0, qdest);
+			ppc460ex_desc_set_byte_count(iter, ppc460ex_chan,
+						      len);
+			iter->unmap_len = 0;
+			/*
+			 * override qdest to preserve original Q
+			 */
+			qdest = ppc460ex_chan->qdest;
+		}
+
+		/*
+		 * Setup destinations for P/Q ops
+		 */
+		ppc460ex_adma_pqzero_sum_set_dest(sw_desc, pdest, qdest);
+
+		/*
+		 * Setup zero QWORDs into DCHECK CDBs
+		 */
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
+					set_bit(PPC460EX_DESC_QCHECK,
+						&iter->flags);
+				} else {
+					set_bit(PPC460EX_DESC_PCHECK,
+						&iter->flags);
+				}
+			} else {
+				if (qdest) {
+					set_bit(PPC460EX_DESC_QCHECK,
+						&iter->flags);
+				} else {
+					set_bit(PPC460EX_DESC_PCHECK,
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
+			ppc460ex_desc_set_dcheck(iter, ppc460ex_chan,
+				ppc460ex_qword);
+
+			if (!(--dst_cnt))
+				break;
+		}
+
+		/*
+		 * Setup sources and mults for P/Q ops
+		 */
+		list_for_each_entry_continue_reverse(iter, &sw_desc->group_list,
+						     chain_node) {
+			struct ppc460ex_adma_chan *chan;
+			u32 mult_dst;
+
+			chan = to_ppc460ex_adma_chan(iter->async_tx.chan);
+			ppc460ex_desc_set_src_addr(iter, chan, 0,
+						    DMA_CUED_XOR_HB,
+						    src[src_cnt - 1]);
+			if (qdest) {
+				mult_dst = (dst_cnt - 1) ? DMA_CDB_SG_DST2 :
+							   DMA_CDB_SG_DST1;
+				ppc460ex_desc_set_src_mult(iter, chan,
+							    DMA_CUED_MULT1_OFF,
+							    mult_dst,
+							    scf[src_cnt - 1]);
+			}
+			if (!(--src_cnt))
+				break;
+		}
+	}
+	spin_unlock_bh(&ppc460ex_chan->lock);
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+/*
+ * ppc460ex_adma_prep_dma_xor_zero_sum - prepare CDB group for
+ * XOR ZERO_SUM operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_xor_zero_sum(
+		struct dma_chan *chan, dma_addr_t *src, unsigned int src_cnt,
+		size_t len, enum sum_check_flags *result, unsigned long flags)
+{
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t pq[2];
+
+	/*
+	 * validate P, disable Q
+	 */
+	pq[0] = src[0];
+	pq[1] = 0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+
+	tx = ppc460ex_adma_prep_dma_pqzero_sum(chan, pq, &src[1],
+						src_cnt - 1, 0, len,
+						result, flags);
+	return tx;
+}
+/*
+ * ppc460ex_desc_init_pq - initialize the descriptor for PQ_XOR operation
+ */
+static inline void ppc460ex_desc_init_pq(struct ppc460ex_adma_desc_slot *desc,
+		int dst_cnt, int src_cnt, unsigned long flags,
+		unsigned long op)
+{
+	struct dma_cdb *hw_desc;
+	struct ppc460ex_adma_desc_slot *iter;
+	u8 dopc;
+
+
+	/*
+	 * Common initialization of a PQ descriptors chain
+	 */
+
+	set_bits(op, &desc->flags);
+	desc->src_cnt = src_cnt;
+	desc->dst_cnt = dst_cnt;
+
+	dopc = (desc->dst_cnt == DMA_DEST_MAX_NUM) ?
+		DMA_CDB_OPC_MULTICAST : DMA_CDB_OPC_MV_SG1_SG2;
+
+	list_for_each_entry(iter, &desc->group_list, chain_node) {
+		hw_desc = iter->hw_desc;
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+
+		if (likely(!list_is_last(&iter->chain_node,
+				&desc->group_list))) {
+			/*
+			 * set 'next' pointer
+			 */
+			iter->hw_next = list_entry(iter->chain_node.next,
+				struct ppc460ex_adma_desc_slot, chain_node);
+			clear_bit(PPC460EX_DESC_INT, &iter->flags);
+		} else {
+			/* this is the last descriptor.
+			 * this slot will be pasted from ADMA level
+			 * each time it wants to configure parameters
+			 * of the transaction (src, dst, ...)
+			 */
+			iter->hw_next = NULL;
+			if (flags & DMA_PREP_INTERRUPT)
+				set_bit(PPC460EX_DESC_INT, &iter->flags);
+			else
+				clear_bit(PPC460EX_DESC_INT, &iter->flags);
+		}
+	}
+
+	/* Set OPS depending on WXOR/RXOR type of operation */
+	if (!test_bit(PPC460EX_DESC_RXOR, &desc->flags)) {
+		/* This is a WXOR only chain:
+		 * - first descriptors are for zeroing destinations
+		 *   if PPC460EX_ZERO_P/Q set;
+		 * - descriptors remained are for GF-XOR operations.
+		 */
+		iter = list_first_entry(&desc->group_list,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+
+		if (test_bit(PPC460EX_ZERO_P, &desc->flags)) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter = list_first_entry(&iter->chain_node,
+				struct ppc460ex_adma_desc_slot,
+					chain_node);
+		}
+
+		if (test_bit(PPC460EX_ZERO_Q, &desc->flags)) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+			iter = list_first_entry(&iter->chain_node,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		}
+
+		list_for_each_entry_from(iter, &desc->group_list, chain_node) {
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = dopc;
+		}
+	} else {
+		/* This is either RXOR-only or mixed RXOR/WXOR
+		 * The first 1 or 2 slots in chain are always RXOR,
+		 * if need to calculate P & Q, then there are two
+		 * RXOR slots; if only P or only Q, then there is one
+		 */
+		iter = list_first_entry(&desc->group_list,
+				struct ppc460ex_adma_desc_slot, chain_node);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+
+		if (desc->dst_cnt == DMA_DEST_MAX_NUM) {
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			hw_desc = iter->hw_desc;
+			hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		}
+
+		/*
+		 * The remain descs (if any) are WXORs
+		 */
+		if (test_bit(PPC460EX_DESC_WXOR, &desc->flags)) {
+			iter = list_first_entry(&iter->chain_node,
+						struct ppc460ex_adma_desc_slot,
+						chain_node);
+			list_for_each_entry_from(iter, &desc->group_list,
+						chain_node) {
+				hw_desc = iter->hw_desc;
+				hw_desc->opc = dopc;
+			}
+		}
+	}
+}
+
+/*
+ * ppc460ex_adma_prep_dma_memcpy - prepare CDB for a MEMCPY operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_memcpy(
+		struct dma_chan *chan, dma_addr_t dma_dest,
+		dma_addr_t dma_src, size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op;
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > PPC460EX_ADMA_DMA_MAX_BYTE_COUNT));
+	spin_lock_bh(&ppc460ex_chan->lock);
+	dev_dbg(ppc460ex_chan->device->common.dev,
+			"ppc460ex adma%d: %s len: %u int_en %d\n",
+			ppc460ex_chan->device->id, __func__,
+			len, flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+	slot_cnt = slots_per_op = 1;
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt,
+		slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		ppc460ex_desc_init_memcpy(group_start, flags);
+		ppc460ex_adma_set_dest(group_start, dma_dest, 0);
+		ppc460ex_adma_memcpy_xor_set_src(group_start, dma_src, 0);
+		ppc460ex_desc_set_byte_count(group_start, ppc460ex_chan, len);
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+	spin_unlock_bh(&ppc460ex_chan->lock);
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+
+/*
+ * ppc460ex_adma_prep_dma_memset - prepare CDB for a MEMSET operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_memset(
+		struct dma_chan *chan, dma_addr_t dma_dest, int value,
+		size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *sw_desc, *group_start;
+	int slot_cnt, slots_per_op;
+	if (unlikely(!len))
+		return NULL;
+	BUG_ON(unlikely(len > PPC460EX_ADMA_DMA_MAX_BYTE_COUNT));
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d: %s cal: %u len: %u int_en %d\n",
+		ppc460ex_chan->device->id, __func__, value, len,
+		flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+	slot_cnt = slots_per_op = 1;
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt,
+		slots_per_op);
+	if (sw_desc) {
+		group_start = sw_desc->group_head;
+		ppc460ex_desc_init_memset(group_start, value, flags);
+		ppc460ex_adma_set_dest(group_start, dma_dest, 0);
+		ppc460ex_desc_set_byte_count(group_start, ppc460ex_chan, len);
+		sw_desc->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+static void ppc460ex_adma_pq_zero_op(struct ppc460ex_adma_desc_slot *iter,
+		struct ppc460ex_adma_chan *chan, dma_addr_t addr)
+{
+	/*
+	 * To clear destinations update the descriptor
+	 * (P or Q depending on index) as follows:
+	 * addr is destination (0 corresponds to SG2):
+	 */
+	ppc460ex_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE, addr, 0);
+
+	/* ... and the addr is source: */
+	ppc460ex_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB, addr);
+
+}
+/*
+ * ppc460ex_adma_set_dest - set destination address into descriptor
+ */
+static inline void ppc460ex_adma_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr, int index)
+{
+	struct ppc460ex_adma_chan *chan;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+	BUG_ON(index >= sw_desc->dst_cnt);
+
+	/*
+	 * to do: support transfers lengths
+	 * PPC460EX_ADMA_DMA/XOR_MAX_BYTE_COUNT
+	 */
+	ppc460ex_desc_set_dest_addr(sw_desc->group_head,
+		chan, 0, addr, index);
+}
+/*
+ * ppc460ex_adma_pq_xor_set_dest - set destination address into descriptor
+ * for the PQXOR operation
+ */
+static void ppc460ex_adma_pqxor_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t *addrs, unsigned long flags)
+{
+	struct ppc460ex_adma_desc_slot *iter;
+	struct ppc460ex_adma_chan *chan;
+	dma_addr_t paddr, qaddr;
+	dma_addr_t addr = 0, ppath, qpath;
+	int index = 0;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
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
+	/*
+	 * walk through the WXOR source list and set P/Q-destinations
+	 * for each slot:
+	 */
+	if (!test_bit(PPC460EX_DESC_RXOR, &sw_desc->flags)) {
+		/*
+		 * This is WXOR-only chain; may have 1/2 zero descs
+		 */
+		if (test_bit(PPC460EX_ZERO_P, &sw_desc->flags))
+			index++;
+		if (test_bit(PPC460EX_ZERO_Q, &sw_desc->flags))
+			index++;
+
+		iter = ppc460ex_get_group_entry(sw_desc, index);
+		if (addr) {
+			/*
+			 * one destination
+			 */
+			list_for_each_entry_from(iter,
+				&sw_desc->group_list, chain_node)
+				ppc460ex_desc_set_dest_addr(iter, chan,
+					DMA_CUED_XOR_BASE, addr, 0);
+		} else {
+			/*
+			 * two destinations
+			 */
+			list_for_each_entry_from(iter,
+				&sw_desc->group_list, chain_node) {
+				ppc460ex_desc_set_dest_addr(iter, chan,
+					DMA_CUED_XOR_BASE, paddr, 0);
+				ppc460ex_desc_set_dest_addr(iter, chan,
+					DMA_CUED_XOR_BASE, qaddr, 1);
+			}
+		}
+
+		if (index) {
+			/*  To clear destinations update the descriptor
+			 * (1st,2nd, or both depending on flags)
+			 */
+			index = 0;
+			if (test_bit(PPC460EX_ZERO_P,
+					&sw_desc->flags)) {
+				iter = ppc460ex_get_group_entry(
+						sw_desc, index++);
+				ppc460ex_adma_pq_zero_op(iter, chan,
+						paddr);
+			}
+
+			if (test_bit(PPC460EX_ZERO_Q,
+					&sw_desc->flags)) {
+				iter = ppc460ex_get_group_entry(
+						sw_desc, index++);
+				ppc460ex_adma_pq_zero_op(iter, chan,
+						qaddr);
+			}
+
+			return;
+		}
+	} else {
+		/*
+		 * This is RXOR-only or RXOR/WXOR mixed chain
+		 *
+		 * If we want to include destination into calculations,
+		 * then make dest addresses cued with mult=1 (XOR).
+		 */
+		ppath = test_bit(PPC460EX_ZERO_P, &sw_desc->flags) ?
+				DMA_CUED_XOR_HB :
+				DMA_CUED_XOR_BASE |
+					(1 << DMA_CUED_MULT1_OFF);
+		qpath = test_bit(PPC460EX_ZERO_Q, &sw_desc->flags) ?
+				DMA_CUED_XOR_HB :
+				DMA_CUED_XOR_BASE |
+					(1 << DMA_CUED_MULT1_OFF);
+
+		/*
+		 * Setup destination(s) in RXOR slot(s)
+		 */
+		iter = ppc460ex_get_group_entry(sw_desc, index++);
+		ppc460ex_desc_set_dest_addr(iter, chan,
+					paddr ? ppath : qpath,
+					paddr ? paddr : qaddr, 0);
+		if (!addr) {
+			/*
+			 * two destinations
+			 */
+			iter = ppc460ex_get_group_entry(sw_desc,
+							  index++);
+			ppc460ex_desc_set_dest_addr(iter, chan,
+					qpath, qaddr, 0);
+		}
+
+		if (test_bit(PPC460EX_DESC_WXOR, &sw_desc->flags)) {
+			/* Setup destination(s) in remaining WXOR
+			 * slots
+			 */
+			iter = ppc460ex_get_group_entry(sw_desc,
+							 index);
+			if (addr) {
+				/*
+				 * one destination
+				 */
+				list_for_each_entry_from(iter,
+				    &sw_desc->group_list,
+				    chain_node)
+					ppc460ex_desc_set_dest_addr(
+						iter, chan,
+						DMA_CUED_XOR_BASE,
+						addr, 0);
+
+			} else {
+				/*
+				 * two destinations
+				 */
+				list_for_each_entry_from(iter,
+				    &sw_desc->group_list,
+				    chain_node) {
+					ppc460ex_desc_set_dest_addr(
+						iter, chan,
+						DMA_CUED_XOR_BASE,
+						paddr, 0);
+					ppc460ex_desc_set_dest_addr(
+						iter, chan,
+						DMA_CUED_XOR_BASE,
+						qaddr, 1);
+				}
+			}
+		}
+
+	}
+}
+
+/*
+ * ppc460ex_adma_pqxor_set_src - set source address into descriptor
+ */
+static void ppc460ex_adma_pqxor_set_src(struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr, int index)
+{
+	struct ppc460ex_adma_chan *chan;
+	dma_addr_t haddr = 0;
+	struct ppc460ex_adma_desc_slot *iter = NULL;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+	/* DMA0,1 may do: WXOR, RXOR, RXOR+WXORs chain
+	 */
+	if (test_bit(PPC460EX_DESC_RXOR, &sw_desc->flags)) {
+		/*
+		 * RXOR-only or RXOR/WXOR operation
+		 */
+		int iskip = test_bit(PPC460EX_DESC_RXOR12,
+			&sw_desc->flags) ?  2 : 3;
+
+		if (index == 0) {
+			/* 1st slot (RXOR)
+			 * setup sources region (R1-2-3, R1-2-4,or R1-2-5)
+			 */
+			if (test_bit(PPC460EX_DESC_RXOR12,
+					&sw_desc->flags))
+				haddr = DMA_RXOR12 <<
+					DMA_CUED_REGION_OFF;
+		else if (test_bit(PPC460EX_DESC_RXOR123,
+		    &sw_desc->flags))
+				haddr = DMA_RXOR123 <<
+					DMA_CUED_REGION_OFF;
+		else if (test_bit(PPC460EX_DESC_RXOR124,
+		    &sw_desc->flags))
+				haddr = DMA_RXOR124 <<
+					DMA_CUED_REGION_OFF;
+		else if (test_bit(PPC460EX_DESC_RXOR125,
+		    &sw_desc->flags))
+				haddr = DMA_RXOR125 <<
+					DMA_CUED_REGION_OFF;
+			else
+				BUG();
+			haddr |= DMA_CUED_XOR_BASE;
+			sw_desc = sw_desc->group_head;
+		} else if (index < iskip) {
+			/* 1st slot (RXOR)
+			 * shall actually set source address only once
+			 * instead of first <iskip>
+			 */
+			iter = NULL;
+		} else {
+			/* second and next slots (WXOR);
+			 * skip first slot with RXOR
+			 */
+			haddr = DMA_CUED_XOR_HB;
+			sw_desc = ppc460ex_get_group_entry(sw_desc,
+			    index - iskip + 1);
+		}
+	} else {
+		int znum = 0;
+		/* WXOR-only operation;
+		 * skip first slots with destinations
+		 */
+		if (test_bit(PPC460EX_ZERO_P, &sw_desc->flags))
+			znum++;
+		if (test_bit(PPC460EX_ZERO_Q, &sw_desc->flags))
+			znum++;
+
+		haddr = DMA_CUED_XOR_HB;
+		iter = ppc460ex_get_group_entry(sw_desc,
+				index + znum);
+	}
+
+	if (likely(iter)) {
+		ppc460ex_desc_set_src_addr(iter, chan, 0, haddr, addr);
+		if (!index &&
+		    test_bit(PPC460EX_DESC_RXOR, &sw_desc->flags) &&
+		    sw_desc->dst_cnt == 2) {
+			/* if we have two destinations for RXOR, then
+			 * setup source in the second descr too
+			 */
+			iter = ppc460ex_get_group_entry(sw_desc, 1);
+			ppc460ex_desc_set_src_addr(iter, chan, 0,
+				haddr, addr);
+		}
+	}
+}
+/*
+ * ppc460ex_adma_pqxor_set_src_mult - set multiplication coefficient into
+ * descriptor for the PQXOR operation
+ */
+static void ppc460ex_adma_pqxor_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos)
+{
+	struct ppc460ex_adma_chan *chan;
+	u32 mult_idx, mult_dst;
+	struct ppc460ex_adma_desc_slot *iter = NULL, *iter1 = NULL;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+	if (test_bit(PPC460EX_DESC_RXOR, &sw_desc->flags)) {
+		int region = test_bit(PPC460EX_DESC_RXOR12,
+				&sw_desc->flags) ? 2 : 3;
+
+		if (index < region) {
+			/*
+			 * RXOR multipliers
+			 */
+
+			iter = ppc460ex_get_group_entry(sw_desc,
+					sw_desc->dst_cnt - 1);
+			if (sw_desc->dst_cnt == 2)
+				iter1 = ppc460ex_get_group_entry(sw_desc, 0);
+			mult_idx = DMA_CUED_MULT1_OFF + (index << 3);
+			mult_dst = DMA_CDB_SG_SRC;
+		} else {
+			/*
+			 * WXOR multiplier
+			 */
+			iter = ppc460ex_get_group_entry(sw_desc,
+					index - region +
+					sw_desc->dst_cnt);
+			mult_idx = DMA_CUED_MULT1_OFF;
+			mult_dst = dst_pos ? DMA_CDB_SG_DST2 :
+					     DMA_CDB_SG_DST1;
+		}
+	} else {
+		int znum = 0;
+
+		/* WXOR-only;
+		 * skip first slots with destinations (if ZERO_DST has
+		 * place)
+		 */
+		if (test_bit(PPC460EX_ZERO_P, &sw_desc->flags))
+			znum++;
+		if (test_bit(PPC460EX_ZERO_Q, &sw_desc->flags))
+			znum++;
+		iter = ppc460ex_get_group_entry(sw_desc, index + znum);
+		mult_idx = DMA_CUED_MULT1_OFF;
+		mult_dst = dst_pos ? DMA_CDB_SG_DST2 : DMA_CDB_SG_DST1;
+	}
+
+	if (likely(iter)) {
+		ppc460ex_desc_set_src_mult(iter, chan,
+			mult_idx, mult_dst, mult);
+
+		if (unlikely(iter1)) {
+			/* if we have two destinations for RXOR, then
+			 * we've just set Q mult. Set-up P now.
+			 */
+			ppc460ex_desc_set_src_mult(iter1, chan,
+				mult_idx, mult_dst, 1);
+		}
+
+	}
+}
+
+
+static inline struct ppc460ex_adma_desc_slot *ppc460ex_dma_prep_pq(
+		struct ppc460ex_adma_chan *ppc460ex_chan,
+		dma_addr_t *dst, unsigned int dst_cnt,
+		dma_addr_t *src, unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags)
+{
+	int slot_cnt;
+	struct ppc460ex_adma_desc_slot *sw_desc = NULL, *iter;
+	unsigned long op = 0;
+	unsigned char mult = 1;
+
+	/*  select operations WXOR/RXOR depending on the
+	 * source addresses of operators and the number
+	 * of destinations (RXOR support only Q-parity calculations)
+	 */
+	set_bit(PPC460EX_DESC_WXOR, &op);
+	if (!test_and_set_bit(PPC460EX_RXOR_RUN, &ppc460ex_rxor_state)) {
+		/* no active RXOR;
+		 * do RXOR if:
+		 * - destination os only one,
+		 * - there are more than 1 source,
+		 * - len is aligned on 512-byte boundary,
+		 * - source addresses fit to one of 4 possible regions.
+		 */
+		if (dst_cnt == 3 && src_cnt > 1 &&
+		    !(len & ~MQ0_CF2H_RXOR_BS_MASK) &&
+		    (src[0] + len) == src[1]) {
+			/* may do RXOR R1 R2 */
+			set_bit(PPC460EX_DESC_RXOR, &op);
+			if (src_cnt != 2) {
+				/* may try to enhance region of RXOR */
+				if ((src[1] + len) == src[2]) {
+					/* do RXOR R1 R2 R3 */
+					set_bit(PPC460EX_DESC_RXOR123,
+						&op);
+				} else if ((src[1] + len * 2) == src[2]) {
+					/* do RXOR R1 R2 R4 */
+					set_bit(PPC460EX_DESC_RXOR124, &op);
+				} else if ((src[1] + len * 3) == src[2]) {
+					/* do RXOR R1 R2 R5 */
+					set_bit(PPC460EX_DESC_RXOR125,
+						&op);
+				} else {
+					/* do RXOR R1 R2 */
+					set_bit(PPC460EX_DESC_RXOR12,
+						&op);
+				}
+			} else {
+				/* do RXOR R1 R2 */
+				set_bit(PPC460EX_DESC_RXOR12, &op);
+			}
+		}
+
+		if (!test_bit(PPC460EX_DESC_RXOR, &op)) {
+			/* can not do this operation with RXOR */
+			clear_bit(PPC460EX_RXOR_RUN,
+				&ppc460ex_rxor_state);
+		} else {
+			/* can do; set block size right now */
+			ppc460ex_desc_set_rxor_block_size(len);
+		}
+	}
+
+	/*
+	 * Number of necessary slots depends on operation type selected
+	 */
+	if (!test_bit(PPC460EX_DESC_RXOR, &op)) {
+		/*  This is a WXOR only chain. Need descriptors for each
+		 * source to GF-XOR them with WXOR, and need descriptors
+		 * for each destination to zero them with WXOR
+		 */
+		slot_cnt = src_cnt;
+
+		if (flags & DMA_PREP_ZERO_P) {
+			slot_cnt++;
+			set_bit(PPC460EX_ZERO_P, &op);
+		}
+		if (flags & DMA_PREP_ZERO_Q) {
+			slot_cnt++;
+			set_bit(PPC460EX_ZERO_Q, &op);
+		}
+	} else {
+		/*  Need 1/2 descriptor for RXOR operation, and
+		 * need (src_cnt - (2 or 3)) for WXOR of sources
+		 * remained (if any)
+		*/
+		slot_cnt = dst_cnt;
+
+		if (flags & DMA_PREP_ZERO_P)
+			set_bit(PPC460EX_ZERO_P, &op);
+		if (flags & DMA_PREP_ZERO_Q)
+			set_bit(PPC460EX_ZERO_Q, &op);
+
+		if (test_bit(PPC460EX_DESC_RXOR12, &op))
+			slot_cnt += src_cnt - 2;
+		else
+			slot_cnt += src_cnt - 3;
+
+		/*
+		 * Thus we have either RXOR only chain or
+		 * mixed RXOR/WXOR
+		 */
+		if (slot_cnt == dst_cnt) {
+			/* RXOR only chain */
+			clear_bit(PPC460EX_DESC_WXOR, &op);
+		}
+	}
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+	/*
+	 * for both RXOR/WXOR each descriptor occupies one slot
+	 */
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt, 1);
+	if (sw_desc) {
+		ppc460ex_desc_init_pq(sw_desc, dst_cnt, src_cnt,
+				flags, op);
+
+		/*
+		 * setup dst/src/mult
+		 */
+			ppc460ex_adma_pqxor_set_dest(sw_desc,
+				dst, flags);
+		while (src_cnt--) {
+			ppc460ex_adma_pqxor_set_src(sw_desc, src[src_cnt],
+					src_cnt);
+			if (!(flags & DMA_PREP_PQ_DISABLE_Q))
+				mult = scf[src_cnt];
+			ppc460ex_adma_pqxor_set_src_mult(sw_desc, mult,
+					src_cnt, dst_cnt - 1);
+		}
+
+		/*
+		 * Setup byte count foreach slot just allocated
+		 */
+		sw_desc->async_tx.flags = flags;
+		list_for_each_entry(iter, &sw_desc->group_list,
+				chain_node) {
+			ppc460ex_desc_set_byte_count(iter,
+				ppc460ex_chan, len);
+			iter->unmap_len = len;
+		}
+	}
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	return sw_desc;
+}
+/*
+ * ppc460ex_dma01_prep_mult -
+ * for Q operation where destination is also the source
+ */
+static struct ppc460ex_adma_desc_slot *ppc460ex_dma01_prep_mult(
+		struct ppc460ex_adma_chan *ppc460ex_chan,
+		dma_addr_t *dst, int dst_cnt, dma_addr_t *src, int src_cnt,
+		const unsigned char *scf, size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_desc_slot *sw_desc = NULL;
+	unsigned long op = 0;
+	int slot_cnt;
+
+	set_bit(PPC460EX_DESC_WXOR, &op);
+	slot_cnt = 2;
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+
+	/*
+	 * use WXOR, each descriptor occupies one slot
+	 */
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt, 1);
+	if (sw_desc) {
+		struct ppc460ex_adma_chan *chan;
+		struct ppc460ex_adma_desc_slot *iter;
+		struct dma_cdb *hw_desc;
+
+		chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+		set_bits(op, &sw_desc->flags);
+		sw_desc->src_cnt = src_cnt;
+		sw_desc->dst_cnt = dst_cnt;
+		/*
+		 * First descriptor, zero data in the destination and copy it
+		 * to q page using MULTICAST transfer.
+		 */
+		iter = list_first_entry(&sw_desc->group_list,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		/*
+		 * set 'next' pointer
+		 */
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc460ex_adma_desc_slot,
+					   chain_node);
+		clear_bit(PPC460EX_DESC_INT, &iter->flags);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MULTICAST;
+
+		ppc460ex_desc_set_dest_addr(iter, chan,
+					     DMA_CUED_XOR_BASE, dst[0], 0);
+		ppc460ex_desc_set_dest_addr(iter, chan, 0, dst[1], 1);
+		ppc460ex_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					    src[0]);
+		ppc460ex_desc_set_byte_count(iter, ppc460ex_chan, len);
+		iter->unmap_len = len;
+
+		/*
+		 * Second descriptor, multiply data from the q page
+		 * and store the result in real destination.
+		 */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = NULL;
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC460EX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC460EX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc460ex_desc_set_src_addr(iter, chan, 0,
+					    DMA_CUED_XOR_HB, dst[1]);
+		ppc460ex_desc_set_dest_addr(iter, chan,
+					     DMA_CUED_XOR_BASE, dst[0], 0);
+
+		ppc460ex_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+					    DMA_CDB_SG_DST1, scf[0]);
+		ppc460ex_desc_set_byte_count(iter, ppc460ex_chan, len);
+		iter->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	return sw_desc;
+}
+/*
+ * ppc460ex_dma01_prep_sum_product -
+ * Dx = A*(P+Pxy) + B*(Q+Qxy) operation where destination is also
+ * the source.
+ */
+static struct ppc460ex_adma_desc_slot *ppc460ex_dma01_prep_sum_product(
+		struct ppc460ex_adma_chan *ppc460ex_chan,
+		dma_addr_t *dst, dma_addr_t *src, int src_cnt,
+		const unsigned char *scf, size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_desc_slot *sw_desc = NULL;
+	unsigned long op = 0;
+	int slot_cnt;
+
+	set_bit(PPC460EX_DESC_WXOR, &op);
+	slot_cnt = 3;
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+
+	/*
+	 * WXOR, each descriptor occupies one slot
+	 */
+	sw_desc = ppc460ex_adma_alloc_slots(ppc460ex_chan, slot_cnt, 1);
+	if (sw_desc) {
+		struct ppc460ex_adma_chan *chan;
+		struct ppc460ex_adma_desc_slot *iter;
+		struct dma_cdb *hw_desc;
+
+		chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+		set_bits(op, &sw_desc->flags);
+		sw_desc->src_cnt = src_cnt;
+		sw_desc->dst_cnt = 1;
+		/*
+		 * 1st descriptor, src[1] data to q page and zero destination
+		 */
+		iter = list_first_entry(&sw_desc->group_list,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc460ex_adma_desc_slot,
+					   chain_node);
+		clear_bit(PPC460EX_DESC_INT, &iter->flags);
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MULTICAST;
+
+		ppc460ex_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					     *dst, 0);
+		ppc460ex_desc_set_dest_addr(iter, chan, 0,
+					     ppc460ex_chan->qdest, 1);
+		ppc460ex_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					    src[1]);
+		ppc460ex_desc_set_byte_count(iter, ppc460ex_chan, len);
+		iter->unmap_len = len;
+
+		/*
+		 * 2nd descriptor, multiply src[1] data and store the
+		 * result in destination */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		/* set 'next' pointer */
+		iter->hw_next = list_entry(iter->chain_node.next,
+					   struct ppc460ex_adma_desc_slot,
+					   chain_node);
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC460EX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC460EX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc460ex_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					    ppc460ex_chan->qdest);
+		ppc460ex_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					     *dst, 0);
+		ppc460ex_desc_set_src_mult(iter, chan,	DMA_CUED_MULT1_OFF,
+					    DMA_CDB_SG_DST1, scf[1]);
+		ppc460ex_desc_set_byte_count(iter, ppc460ex_chan, len);
+		iter->unmap_len = len;
+
+		/*
+		 * 3rd descriptor, multiply src[0] data and xor it
+		 * with destination
+		 */
+		iter = list_first_entry(&iter->chain_node,
+					struct ppc460ex_adma_desc_slot,
+					chain_node);
+		memset(iter->hw_desc, 0, sizeof(struct dma_cdb));
+		iter->hw_next = NULL;
+		if (flags & DMA_PREP_INTERRUPT)
+			set_bit(PPC460EX_DESC_INT, &iter->flags);
+		else
+			clear_bit(PPC460EX_DESC_INT, &iter->flags);
+
+		hw_desc = iter->hw_desc;
+		hw_desc->opc = DMA_CDB_OPC_MV_SG1_SG2;
+		ppc460ex_desc_set_src_addr(iter, chan, 0, DMA_CUED_XOR_HB,
+					    src[0]);
+		ppc460ex_desc_set_dest_addr(iter, chan, DMA_CUED_XOR_BASE,
+					     *dst, 0);
+		ppc460ex_desc_set_src_mult(iter, chan, DMA_CUED_MULT1_OFF,
+					    DMA_CDB_SG_DST1, scf[0]);
+		ppc460ex_desc_set_byte_count(iter, ppc460ex_chan, len);
+		iter->unmap_len = len;
+		sw_desc->async_tx.flags = flags;
+	}
+
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	return sw_desc;
+}
+/*
+ * ppc460ex_adma_prep_dma_pq- prepare CDB (group) for a GF-XOR operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_pq(
+		struct dma_chan *chan, dma_addr_t *dst,	dma_addr_t *src,
+		unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *sw_desc = NULL;
+	int dst_cnt = 0;
+
+	BUG_ON(!len);
+	BUG_ON(unlikely(len > PPC460EX_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(!src_cnt);
+
+	if (src_cnt == 1 && dst[1] == src[0]) {
+		dma_addr_t dest[2];
+
+		/* dst[1] is real destination (Q) */
+		dest[0] = dst[1];
+		/* this is the page to multicast source data to */
+		dest[1] = ppc460ex_chan->qdest;
+		sw_desc = ppc460ex_dma01_prep_mult(ppc460ex_chan,
+				dest, 2, src, src_cnt, scf, len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
+
+	if (src_cnt == 2 && dst[1] == src[1]) {
+		sw_desc = ppc460ex_dma01_prep_sum_product(ppc460ex_chan,
+					&dst[1], src, 2, scf, len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
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
+	BUG_ON(!dst_cnt);
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d: %s src_cnt: %d len: %u int_en: %d\n",
+		ppc460ex_chan->device->id, __func__, src_cnt, len,
+		flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+	sw_desc = ppc460ex_dma_prep_pq(ppc460ex_chan,
+			dst, dst_cnt, src, src_cnt, scf,
+			len, flags);
+
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+/*
+ * ppc460ex_adma_prep_dma_p- prepare CDB (group) for a GF-XOR operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_p(
+		struct dma_chan *chan, dma_addr_t *dst,	dma_addr_t *src,
+		unsigned int src_cnt, unsigned char *scf,
+		size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *sw_desc = NULL;
+	int dst_cnt = 0;
+
+	BUG_ON(!len);
+	BUG_ON(unlikely(len > PPC460EX_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(!src_cnt);
+
+	if (src_cnt == 1 && dst[1] == src[0]) {
+		dma_addr_t dest[2];
+
+		/* dst[1] is real destination (Q) */
+		dest[0] = dst[1];
+		/* this is the page to multicast source data to */
+		dest[1] = ppc460ex_chan->qdest;
+		sw_desc = ppc460ex_dma01_prep_mult(ppc460ex_chan,
+				dest, 2, src, src_cnt, scf, len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
+
+	if (src_cnt == 2 && dst[1] == src[1]) {
+		sw_desc = ppc460ex_dma01_prep_sum_product(ppc460ex_chan,
+					&dst[1], src, 2, scf, len, flags);
+		return sw_desc ? &sw_desc->async_tx : NULL;
+	}
+	if (!(flags & DMA_PREP_PQ_DISABLE_P)) {
+		BUG_ON(!dst[0]);
+		dst_cnt++;
+		if (flags & DMA_ZERO_P)
+			flags |= DMA_PREP_ZERO_P;
+	}
+
+	if (!(flags & DMA_PREP_PQ_DISABLE_Q)) {
+		BUG_ON(!dst[1]);
+		dst_cnt++;
+		flags |= DMA_PREP_ZERO_Q;
+	}
+	BUG_ON(!dst_cnt);
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d: %s src_cnt: %d len: %u int_en: %d\n",
+		ppc460ex_chan->device->id, __func__, src_cnt, len,
+		flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+	sw_desc = ppc460ex_dma_prep_pq(ppc460ex_chan,
+			dst, dst_cnt, src, src_cnt, scf,
+			len, flags);
+
+	return sw_desc ? &sw_desc->async_tx : NULL;
+}
+/*
+ * ppc460ex_adma_prep_dma_mq_xor - prepare CDB (group) for a GF-XOR operation
+ */
+static struct dma_async_tx_descriptor *ppc460ex_adma_prep_dma_mq_xor(
+		struct dma_chan *chan, dma_addr_t dst,
+		dma_addr_t *src, unsigned int src_cnt,
+		size_t len, unsigned long flags)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct dma_async_tx_descriptor *tx;
+	dma_addr_t pq[2];
+	unsigned char scf = 0;
+
+	/* validate P, disable Q */
+	pq[0] = dst;
+	pq[1] = 0;
+	flags |= DMA_PREP_PQ_DISABLE_Q;
+
+	BUG_ON(!len);
+	BUG_ON(unlikely(len > PPC460EX_ADMA_XOR_MAX_BYTE_COUNT));
+	BUG_ON(!src_cnt);
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d: %s src_cnt: %d len: %u int_en: %d\n",
+		ppc460ex_chan->device->id, __func__, src_cnt, len,
+		flags & DMA_PREP_INTERRUPT ? 1 : 0);
+
+		tx = ppc460ex_adma_prep_dma_p(chan, &pq[0], src,
+				src_cnt, &scf, len, flags);
+		return tx;
+
+}
+/*
+ * ppc460ex_adma_memcpy_xor_set_src - set source address into descriptor
+ */
+static inline void ppc460ex_adma_memcpy_xor_set_src(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t addr,
+		int index)
+{
+	struct ppc460ex_adma_chan *chan;
+
+	sw_desc = sw_desc->group_head;
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+
+	if (likely(sw_desc))
+		ppc460ex_desc_set_src_addr(sw_desc, chan, index, 0, addr);
+}
+/*
+ * ppc460ex_adma_pqzero_sum_set_src_mult - set multiplication coefficient
+ * into descriptor for the PQZERO_SUM operation
+ */
+static void ppc460ex_adma_pqzero_sum_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos)
+{
+	struct ppc460ex_adma_chan *chan;
+	u32 mult_idx, mult_dst;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+	/* set mult for sources only */
+	BUG_ON(index >= sw_desc->src_cnt);
+
+	/* get pointed slot */
+	sw_desc = ppc460ex_get_group_entry(sw_desc, index);
+
+	mult_idx = DMA_CUED_MULT1_OFF;
+	mult_dst = dst_pos ? DMA_CDB_SG_DST2 : DMA_CDB_SG_DST1;
+
+	if (likely(sw_desc))
+		ppc460ex_desc_set_src_mult(sw_desc, chan, mult_idx, mult_dst,
+		    mult);
+}
+/*
+ * ppc460ex_adma_pq_set_src_mult - set multiplication coefficient into
+ * descriptor for the PQXOR operation
+ */
+static void ppc460ex_adma_pq_set_src_mult(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		unsigned char mult, int index, int dst_pos)
+{
+	struct ppc460ex_adma_chan *chan;
+	u32 mult_idx, mult_dst;
+	struct ppc460ex_adma_desc_slot *iter = NULL, *iter1 = NULL;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+
+	if (test_bit(PPC460EX_DESC_RXOR, &sw_desc->flags)) {
+		int region = test_bit(PPC460EX_DESC_RXOR12,
+				&sw_desc->flags) ? 2 : 3;
+
+		if (index < region) {
+			/* RXOR multipliers */
+			iter = ppc460ex_get_group_entry(sw_desc,
+				sw_desc->dst_cnt - 1);
+			if (sw_desc->dst_cnt == 2)
+				iter1 = ppc460ex_get_group_entry(
+						sw_desc, 0);
+
+			mult_idx = DMA_CUED_MULT1_OFF + (index << 3);
+			mult_dst = DMA_CDB_SG_SRC;
+		} else {
+			/* WXOR multiplier */
+			iter = ppc460ex_get_group_entry(sw_desc,
+						index - region +
+						sw_desc->dst_cnt);
+			mult_idx = DMA_CUED_MULT1_OFF;
+			mult_dst = dst_pos ? DMA_CDB_SG_DST2 :
+					     DMA_CDB_SG_DST1;
+		}
+	} else {
+		int znum = 0;
+
+		/* WXOR-only;
+		 * skip first slots with destinations (if ZERO_DST has
+		 * place)
+		 */
+		if (test_bit(PPC460EX_ZERO_P, &sw_desc->flags))
+			znum++;
+		if (test_bit(PPC460EX_ZERO_Q, &sw_desc->flags))
+			znum++;
+
+		iter = ppc460ex_get_group_entry(sw_desc, index + znum);
+		mult_idx = DMA_CUED_MULT1_OFF;
+		mult_dst = dst_pos ? DMA_CDB_SG_DST2 : DMA_CDB_SG_DST1;
+	}
+
+	if (likely(iter)) {
+		ppc460ex_desc_set_src_mult(iter, chan,
+			mult_idx, mult_dst, mult);
+
+		if (unlikely(iter1)) {
+			/* if we have two destinations for RXOR, then
+			 * we've just set Q mult. Set-up P now.
+			 */
+			ppc460ex_desc_set_src_mult(iter1, chan,
+				mult_idx, mult_dst, 1);
+		}
+
+	}
+
+}
+/*
+ * ppc460ex_adma_pq_zero_sum_set_dest - set destination address into descriptor
+ * for the PQ_ZERO_SUM operation
+ */
+void ppc460ex_adma_pqzero_sum_set_dest(
+		struct ppc460ex_adma_desc_slot *sw_desc,
+		dma_addr_t paddr, dma_addr_t qaddr)
+{
+	struct ppc460ex_adma_desc_slot *iter, *end;
+	struct ppc460ex_adma_chan *chan;
+	dma_addr_t addr = 0;
+	int idx;
+
+	chan = to_ppc460ex_adma_chan(sw_desc->async_tx.chan);
+
+	/* walk through the WXOR source list and set P/Q-destinations
+	 * for each slot
+	 */
+	idx = (paddr && qaddr) ? 2 : 1;
+	/* set end */
+	list_for_each_entry_reverse(end, &sw_desc->group_list,
+				    chain_node) {
+		if (!(--idx))
+			break;
+	}
+	/* set start */
+	idx = (paddr && qaddr) ? 2 : 1;
+	iter = ppc460ex_get_group_entry(sw_desc, idx);
+
+	if (paddr && qaddr) {
+		/* two destinations */
+		list_for_each_entry_from(iter, &sw_desc->group_list,
+					 chain_node) {
+			if (unlikely(iter == end))
+				break;
+			ppc460ex_desc_set_dest_addr(iter, chan,
+						DMA_CUED_XOR_BASE, paddr, 0);
+			ppc460ex_desc_set_dest_addr(iter, chan,
+						DMA_CUED_XOR_BASE, qaddr, 1);
+		}
+	} else {
+		/* one destination */
+		addr = paddr ? paddr : qaddr;
+		list_for_each_entry_from(iter, &sw_desc->group_list,
+					 chain_node) {
+			if (unlikely(iter == end))
+				break;
+			ppc460ex_desc_set_dest_addr(iter, chan,
+						DMA_CUED_XOR_BASE, addr, 0);
+		}
+	}
+
+	/*  The remaining descriptors are DATACHECK. These have no need in
+	 * destination. Actually, these destinations are used there
+	 * as sources for check operation. So, set addr as source.
+	 */
+	ppc460ex_desc_set_src_addr(end, chan, 0, 0, addr ? addr : paddr);
+
+	if (!addr) {
+		end = list_entry(end->chain_node.next,
+				 struct ppc460ex_adma_desc_slot, chain_node);
+		ppc460ex_desc_set_src_addr(end, chan, 0, 0, qaddr);
+	}
+}
+/*
+ * ppc460ex_adma_free_chan_resources - free the resources allocated
+ */
+void ppc460ex_adma_free_chan_resources(struct dma_chan *chan)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	struct ppc460ex_adma_desc_slot *iter, *_iter;
+	int in_use_descs = 0;
+
+	ppc460ex_adma_slot_cleanup(ppc460ex_chan);
+
+	spin_lock_bh(&ppc460ex_chan->lock);
+	list_for_each_entry_safe(iter, _iter, &ppc460ex_chan->chain,
+					chain_node) {
+		in_use_descs++;
+		list_del(&iter->chain_node);
+	}
+	list_for_each_entry_safe_reverse(iter, _iter,
+			&ppc460ex_chan->all_slots, slot_node) {
+		list_del(&iter->slot_node);
+		kfree(iter);
+		ppc460ex_chan->slots_allocated--;
+	}
+	ppc460ex_chan->last_used = NULL;
+
+	dev_dbg(ppc460ex_chan->device->common.dev,
+		"ppc460ex adma%d %s slots_allocated %d\n",
+		ppc460ex_chan->device->id,
+		__func__, ppc460ex_chan->slots_allocated);
+	spin_unlock_bh(&ppc460ex_chan->lock);
+
+	/* one is ok since we left it on there on purpose */
+	if (in_use_descs > 1)
+		dev_dbg(ppc460ex_chan->device->common.dev,
+				"GT: Freeing %d in use descriptors!\n",
+				in_use_descs - 1);
+}
+
+/**
+ * ppc460ex_adma_tx_status - poll the status of an ADMA transaction
+ * @chan: ADMA channel handle
+ * @cookie: ADMA transaction identifier
+ * @txstate: a holder for the current state of the channel
+ */
+static enum dma_status ppc460ex_adma_tx_status(struct dma_chan *chan,
+			dma_cookie_t cookie, struct dma_tx_state *txstate)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan;
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	enum dma_status ret;
+
+	ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	last_used = chan->cookie;
+	last_complete = ppc460ex_chan->completed_cookie;
+
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret == DMA_SUCCESS)
+		return ret;
+
+	ppc460ex_adma_slot_cleanup(ppc460ex_chan);
+
+	last_used = chan->cookie;
+	last_complete = ppc460ex_chan->completed_cookie;
+
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
+
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+/*
+ * ppc460ex_adma_is_complete - poll the status of an ADMA transaction
+ * @chan: ADMA channel handle
+ * @cookie: ADMA transaction identifier
+ */
+enum dma_status ppc460ex_adma_is_complete(struct dma_chan *chan,
+	dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	dma_cookie_t last_used;
+	dma_cookie_t last_complete;
+	enum dma_status ret;
+
+	last_used = chan->cookie;
+	last_complete = ppc460ex_chan->completed_cookie;
+
+	if (done)
+		*done = last_complete;
+	if (used)
+		*used = last_used;
+
+	ret = dma_async_is_complete(cookie, last_complete, last_used);
+	if (ret == DMA_SUCCESS)
+		return ret;
+
+	ppc460ex_adma_slot_cleanup(ppc460ex_chan);
+
+	last_used = chan->cookie;
+	last_complete = ppc460ex_chan->completed_cookie;
+
+	if (done)
+		*done = last_complete;
+	if (used)
+		*used = last_used;
+
+	return dma_async_is_complete(cookie, last_complete, last_used);
+}
+/*
+ * ppc460ex_adma_eot_handler - end of transfer interrupt handler
+ */
+static irqreturn_t ppc460ex_adma_eot_handler(int irq, void *data)
+{
+	struct ppc460ex_adma_chan *chan = data;
+
+	dev_dbg(chan->device->common.dev,
+		"ppc460ex adma%d: %s\n", chan->device->id, __func__);
+
+	tasklet_schedule(&chan->irq_tasklet);
+	ppc460ex_adma_device_clear_eot_status(chan);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * ppc460ex_adma_err_handler - DMA error interrupt handler;
+ *	do the same things as a eot handler
+ */
+static irqreturn_t ppc460ex_adma_err_handler(int irq, void *data)
+{
+	struct ppc460ex_adma_chan *chan = data;
+	dev_dbg(chan->device->common.dev,
+		"ppc460ex adma%d: %s\n", chan->device->id, __func__);
+	tasklet_schedule(&chan->irq_tasklet);
+	ppc460ex_adma_device_clear_eot_status(chan);
+
+	return IRQ_HANDLED;
+}
+
+static void ppc460ex_test_rad6_callback(void *unused)
+{
+	complete(&ppc460ex_r6_test_comp);
+}
+/*
+ * ppc460ex_test_callback - called when test operation has been done
+ */
+static void ppc460ex_test_raid5_callback(void *unused)
+{
+	complete(&ppc460ex_r5_test_comp);
+}
+/*
+ * ppc460ex_adma_issue_pending - flush all pending descriptors to h/w
+ */
+static void ppc460ex_adma_issue_pending(struct dma_chan *chan)
+{
+	struct ppc460ex_adma_chan *ppc460ex_chan;
+
+	ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+	dev_dbg(ppc460ex_chan->device->common.dev,
+	"ppc460ex adma%d: %s %d\n", ppc460ex_chan->device->id, __func__,
+	ppc460ex_chan->pending);
+	if (ppc460ex_chan->pending) {
+		ppc460ex_chan->pending = 0;
+		ppc460ex_chan_append(ppc460ex_chan);
+	}
+}
+/*
+ * ppc460ex_test_raid6 - test are RAID-6 capabilities enabled successfully.
+ *	For this we just perform one WXOR operation with the same source
+ *	and destination addresses, the GF-multiplier is 1; so if RAID-6
+	o/of_platform_driver_unregister(&ppc460ex_adma_driver);
+ *	capabilities are enabled then we'll get src/dst filled with zero.
+ */
+static int ppc460ex_test_raid6(struct ppc460ex_adma_chan *chan)
+{
+	struct ppc460ex_adma_desc_slot *sw_desc, *iter;
+	struct page *pg;
+	char *a;
+	unsigned long  op = 0;
+	int rval = 0;
+	dma_addr_t dma_addr, addrs[2];;
+
+	if (!ppc460ex_r6_tchan)
+		return -1;
+
+	set_bit(PPC460EX_DESC_WXOR, &op);
+
+	pg = alloc_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+
+	spin_lock_bh(&chan->lock);
+	sw_desc = ppc460ex_adma_alloc_slots(chan, 1, 1);
+	if (sw_desc) {
+		/* 1 src, 1 dsr, int_ena, WXOR */
+		ppc460ex_desc_init_pq(sw_desc, 1, 1, 1, op);
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc460ex_desc_set_byte_count(iter, chan, PAGE_SIZE);
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
+	dma_addr = dma_map_page(chan->device->dev, pg, 0, PAGE_SIZE,
+	    DMA_BIDIRECTIONAL);
+
+	/* Setup adresses */
+	ppc460ex_adma_pqxor_set_src(sw_desc, dma_addr, 0);
+	ppc460ex_adma_pqxor_set_src_mult(sw_desc, 1, 0, 0);
+	addrs[0] = dma_addr;
+	addrs[1] = 0;
+	ppc460ex_adma_pqxor_set_dest(sw_desc, addrs, DMA_PREP_PQ_DISABLE_Q);
+
+	async_tx_ack(&sw_desc->async_tx);
+	sw_desc->async_tx.callback = ppc460ex_test_rad6_callback;
+	sw_desc->async_tx.callback_param = NULL;
+
+	init_completion(&ppc460ex_r6_test_comp);
+
+	ppc460ex_adma_tx_submit(&sw_desc->async_tx);
+	ppc460ex_adma_issue_pending(&chan->common);
+
+	wait_for_completion(&ppc460ex_r6_test_comp);
+
+	/* Now check is the test page zeroed */
+	a = page_address(pg);
+	if ((*(u32 *)a) == 0 && memcmp(a, a+4, PAGE_SIZE-4) == 0) {
+		/* page is zero - RAID-6 enabled */
+		rval = 0;
+	} else {
+		/* RAID-6 was not enabled */
+		rval = -EINVAL;
+	}
+exit:
+	__free_page(pg);
+	return rval;
+}
+/*
+ * ppc460ex_test_raid5 - test are RAID-5 capabilities enabled successfully.
+ *	For this we just perform one WXOR operation with the same source
+ *	and destination addresses, the GF-multiplier is 1; so if RAID-5
+	o/of_platform_driver_unregister(&ppc460ex_adma_driver);
+ *	capabilities are enabled then we'll get src/dst filled with zero.
+ */
+static int ppc460ex_test_raid5(struct ppc460ex_adma_chan *chan)
+{
+	struct ppc460ex_adma_desc_slot *sw_desc, *iter;
+	struct page *pg;
+	char *a;
+	dma_addr_t dma_addr, addrs[2];
+	unsigned long op = 0;
+	int rval = 0;
+
+	if (!ppc460ex_r5_tchan)
+		return -1;
+
+	set_bit(PPC460EX_DESC_WXOR, &op);
+
+	pg = alloc_page(GFP_KERNEL);
+	if (!pg)
+		return -ENOMEM;
+
+	spin_lock_bh(&chan->lock);
+	sw_desc = ppc460ex_adma_alloc_slots(chan, 1, 1);
+	if (sw_desc) {
+		/* 1 src, 1 dsr, int_ena, WXOR */
+		ppc460ex_desc_init_pq(sw_desc, 1, 1, 1, op);
+		list_for_each_entry(iter, &sw_desc->group_list, chain_node) {
+			ppc460ex_desc_set_byte_count(iter, chan, PAGE_SIZE);
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
+	dma_addr = dma_map_page(chan->device->dev, pg, 0, PAGE_SIZE,
+	    DMA_BIDIRECTIONAL);
+
+	/* Setup adresses */
+	ppc460ex_adma_pqxor_set_src(sw_desc, dma_addr, 0);
+	ppc460ex_adma_pqxor_set_src_mult(sw_desc, 1, 0, 0);
+	addrs[0] = dma_addr;
+	addrs[1] = 0;
+	ppc460ex_adma_pqxor_set_dest(sw_desc, addrs, DMA_PREP_PQ_DISABLE_Q);
+
+	async_tx_ack(&sw_desc->async_tx);
+	sw_desc->async_tx.callback = ppc460ex_test_raid5_callback;
+	sw_desc->async_tx.callback_param = NULL;
+
+	init_completion(&ppc460ex_r5_test_comp);
+
+	ppc460ex_adma_tx_submit(&sw_desc->async_tx);
+	ppc460ex_adma_issue_pending(&chan->common);
+
+	wait_for_completion(&ppc460ex_r5_test_comp);
+
+	/*Make sure cache is flushed to memory*/
+	dma_addr = dma_map_page(chan->device->dev, pg, 0, PAGE_SIZE,
+	    DMA_BIDIRECTIONAL);
+	/* Now check is the test page zeroed */
+	a = page_address(pg);
+	if ((*(u32 *)a) == 0 && memcmp(a, a+4, PAGE_SIZE-4) == 0) {
+		/* page is zero - RAID-5 enabled */
+		rval = 0;
+	} else {
+		/* RAID-5 was not enabled */
+		rval = -EINVAL;
+	}
+exit:
+	__free_page(pg);
+	return rval;
+}
+/*
+ * /sysfs interface
+ */
+static ssize_t ppc460ex_poly_read(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	u32 reg;
+
+	reg = dcr_read(ppc460ex_mq_dcr_host, DCRN_MQ0_CFBHL);
+	reg >>= MQ0_CFBHL_POLY;
+	reg &= 0xFF;
+
+	size = sprintf(buf, PAGE_SIZE,
+			"PPC460EX RAID-6 driver uses 0x1%02x polynomial.\n",
+			reg);
+	return size;
+}
+
+static ssize_t ppc460ex_poly_write(struct device_driver *dev,
+			const char *buf, size_t count)
+{
+	unsigned long val, rval;
+
+	if (!count || count > 6)
+		return -EINVAL;
+
+	sscanf(buf, "%lx", &val);
+	if (val & ~0x1FF)
+		return -EINVAL;
+
+	val &= 0xFF;
+	rval = dcr_read(ppc460ex_mq_dcr_host, DCRN_MQ0_CFBHL);
+	rval &= ~(0xFF << MQ0_CFBHL_POLY);
+	rval |= val << MQ0_CFBHL_POLY;
+	dcr_write(ppc460ex_mq_dcr_host, DCRN_MQ0_CFBHL, rval);
+
+	return count;
+}
+static ssize_t show_ppc460ex_devices(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	int i;
+
+	for (i = 0; i < PPC460EX_ADMA_ENGINES_NUM; i++) {
+		if (ppc460ex_adma_devices[i] == -1)
+			continue;
+		size += snprintf(buf + size, PAGE_SIZE - size,
+				 "PPC460EX-ADMA.%d: %s\n", i,
+				 ppc_adma_errors[ppc460ex_adma_devices[i]]);
+	}
+	return size;
+}
+static ssize_t ppc460ex_r6ena_read(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	size = snprintf(buf, PAGE_SIZE,
+			"PPC460EX RAID-6 capabilities are %sABLED.\n",
+			ppc460ex_r6_enabled ? "EN" : "DIS");
+	return size;
+}
+
+static ssize_t ppc460ex_r6ena_write(struct device_driver *dev,
+		const char *buf, size_t count)
+{
+	unsigned long val;
+
+	if (!count || count > 11)
+		return -EINVAL;
+
+	if (!ppc460ex_r6_tchan)
+		return -EFAULT;
+
+	/* Write a key */
+	sscanf(buf, "%lx", &val);
+	dcr_write(ppc460ex_mq_dcr_host, DCRN_MQ0_XORBA, val);
+	isync();
+
+	/* Verify does it really work now */
+	if (ppc460ex_test_raid6(ppc460ex_r6_tchan) == 0) {
+		/*
+		 * PPC460Ex RAID-6 has been activated successfully
+		 */;
+		dev_dbg(dev, "PPC460Ex RAID-6 has been activated "
+				"successfully\n");
+		ppc460ex_r6_enabled = 1;
+	} else {
+		/*
+		 * PPC460Ex RAID-6 hasn't been activated! Error key ?
+		 */
+		dev_dbg(dev, "PPC460Ex RAID-6 hasn't been activated!"
+				" Error key ?\n");
+		ppc460ex_r6_enabled = 0;
+	}
+
+	return count;
+}
+static ssize_t ppc460ex_r5ena_read(struct device_driver *dev, char *buf)
+{
+	ssize_t size = 0;
+	u32 reg;
+	reg = dcr_read(ppc460ex_mq_dcr_host, DCRN_MQ0_CFBHL);
+	reg >>= MQ0_CFBHL_POLY;
+	reg &= 0xFF;
+	size = snprintf(buf, PAGE_SIZE,
+			"PPC460EX RAID-5 capabilities are %sABLED.\n",
+			ppc460ex_r6_enabled ? "EN" : "DIS");
+	return size;
+}
+
+static ssize_t ppc460ex_r5ena_write(struct device_driver *dev,
+		const char *buf, size_t count)
+{
+	unsigned long val;
+
+	if (!count || count > 11)
+		return -EINVAL;
+
+	if (!ppc460ex_r6_tchan)
+		return -EFAULT;
+
+	/* Write a key */
+	sscanf(buf, "%lx", &val);
+	dcr_write(ppc460ex_mq_dcr_host, DCRN_MQ0_XORBA, val);
+	isync();
+
+	/* Verify does it really work now */
+	if (ppc460ex_test_raid5(ppc460ex_r5_tchan) == 0) {
+		/*
+		 * PPC460Ex RAID-5 has been activated successfully
+		 */
+		dev_dbg(dev, "PPC460Ex RAID-5 has been activated "
+		    "successfully\n");
+		ppc460ex_r5_enabled = 1;
+	} else {
+		/*
+		 * PPC460Ex RAID-5 hasn't been activated! Error key ?
+		 */
+		dev_dbg(dev, "PPC460Ex RAID-5 hasn't been activated!"
+		    " Error key ?\n");
+		ppc460ex_r5_enabled = 0;
+	}
+
+	return count;
+}
+static DRIVER_ATTR(devices, S_IRUGO, show_ppc460ex_devices, NULL);
+static DRIVER_ATTR(raid6_enable, S_IRUGO | S_IWUSR, ppc460ex_r6ena_read,
+		   ppc460ex_r6ena_write);
+static DRIVER_ATTR(poly, S_IRUGO | S_IWUSR, ppc460ex_poly_read,
+		   ppc460ex_poly_write);
+static DRIVER_ATTR(raid5_enable, S_IRUGO | S_IWUSR, ppc460ex_r5ena_read,
+		   ppc460ex_r5ena_write);
+static void ppc460ex_adma_init_capabilities(struct ppc460ex_adma_device *adev)
+{
+	dma_cap_set(DMA_MEMCPY, adev->common.cap_mask);
+	dma_cap_set(DMA_INTERRUPT, adev->common.cap_mask);
+	dma_cap_set(DMA_MEMSET, adev->common.cap_mask);
+	dma_cap_set(DMA_PQ, adev->common.cap_mask);
+	dma_cap_set(DMA_PQ_VAL, adev->common.cap_mask);
+	dma_cap_set(DMA_XOR_VAL, adev->common.cap_mask);
+
+	/* Set base routines */
+
+	adev->common.device_alloc_chan_resources =
+		ppc460ex_adma_alloc_chan_resources;
+	adev->common.device_free_chan_resources =
+		ppc460ex_adma_free_chan_resources;
+	adev->common.device_tx_status = ppc460ex_adma_tx_status;
+	adev->common.device_issue_pending =
+		ppc460ex_adma_issue_pending;
+
+
+	/*Setup routines based on capability*/
+	if (dma_has_cap(DMA_MEMCPY, adev->common.cap_mask)) {
+		adev->common.device_prep_dma_memcpy =
+			ppc460ex_adma_prep_dma_memcpy;
+	}
+	if (dma_has_cap(DMA_MEMSET, adev->common.cap_mask)) {
+		adev->common.device_prep_dma_memset =
+			ppc460ex_adma_prep_dma_memset;
+	}
+	if (dma_has_cap(DMA_XOR, adev->common.cap_mask)) {
+		adev->common.max_xor = XOR_MAX_OPS;
+		adev->common.device_prep_dma_xor =
+			ppc460ex_adma_prep_dma_mq_xor;
+	}
+	if (dma_has_cap(DMA_PQ, adev->common.cap_mask)) {
+		dma_set_maxpq(&adev->common,
+				DMA0_FIFO_SIZE / sizeof(struct dma_cdb), 0);
+		adev->common.device_prep_dma_pq =
+			ppc460ex_adma_prep_dma_pq;
+	}
+	if (dma_has_cap(DMA_PQ_VAL, adev->common.cap_mask)) {
+		adev->common.max_pq = DMA0_FIFO_SIZE / sizeof(struct dma_cdb);
+		adev->common.device_prep_dma_pq_val =
+			ppc460ex_adma_prep_dma_pqzero_sum;
+	}
+	if (dma_has_cap(DMA_XOR_VAL, adev->common.cap_mask)) {
+		adev->common.max_xor = DMA0_FIFO_SIZE /
+			sizeof(struct dma_cdb);
+		adev->common.device_prep_dma_xor_val =
+			ppc460ex_adma_prep_dma_xor_zero_sum;
+	}
+	if (dma_has_cap(DMA_INTERRUPT, adev->common.cap_mask)) {
+		adev->common.device_prep_dma_interrupt =
+			ppc460ex_adma_prep_dma_interrupt;
+	}
+	pr_info("%s: APM ppc460ex ADMA engine:"
+		"( %s%s%s%s%s%s%s)\n",
+		dev_name(adev->dev),
+		dma_has_cap(DMA_PQ, adev->common.cap_mask) ?
+		"pq " : "",
+		dma_has_cap(DMA_PQ_VAL, adev->common.cap_mask) ?
+		"pq_val " : "",
+		dma_has_cap(DMA_XOR, adev->common.cap_mask) ?
+		"xor " : "",
+		dma_has_cap(DMA_XOR_VAL, adev->common.cap_mask) ?
+		"xor_val " : "",
+		dma_has_cap(DMA_MEMCPY, adev->common.cap_mask) ?
+		"memcpy " : "",
+		dma_has_cap(DMA_MEMSET, adev->common.cap_mask)  ?
+		"memset " : "",
+		dma_has_cap(DMA_INTERRUPT, adev->common.cap_mask) ?
+		"intr " : "");
+}
+
+static int ppc460ex_setup_irqs(struct ppc460ex_adma_device *adev,
+		struct ppc460ex_adma_chan *chan, int *initcode)
+{
+	struct device_node *np;
+	int ret;
+
+	np = adev->dev->of_node;
+
+	adev->err_irq = irq_of_parse_and_map(np, 2);
+	if (adev->err_irq == NO_IRQ) {
+		dev_warn(adev->dev, "no err irq resource?\n");
+		*initcode = PPC_ADMA_INIT_IRQ2;
+		adev->err_irq = -ENXIO;
+	} else
+		atomic_inc(&ppc460ex_adma_err_irq_ref);
+
+	adev->irq = irq_of_parse_and_map(np, 0);
+	if (adev->irq == NO_IRQ) {
+		dev_err(adev->dev, "no irq resource\n");
+		*initcode = PPC_ADMA_INIT_IRQ1;
+		ret = -ENXIO;
+		goto err_irq_map;
+	}
+	dev_dbg(adev->dev, "irq %d, err irq %d\n",
+			adev->irq, adev->err_irq);
+	ret = request_irq(adev->irq, ppc460ex_adma_eot_handler,
+			0, dev_driver_string(adev->dev), chan);
+	if (ret) {
+		dev_err(adev->dev, "can't request irq %d\n",
+				adev->irq);
+		*initcode = PPC_ADMA_INIT_IRQ1;
+		ret = -EIO;
+		goto err_req1;
+	}
+	if (adev->err_irq > 0) {
+		u32 mask, enable;
+		ret = request_irq(adev->err_irq,
+				ppc460ex_adma_err_handler,
+				IRQF_SHARED,
+				dev_driver_string(adev->dev),
+				chan);
+		if (ret) {
+			dev_err(adev->dev, "can't request irq %d\n",
+					adev->err_irq);
+			*initcode = PPC_ADMA_INIT_IRQ2;
+			ret = -EIO;
+			goto err_req2;
+		}
+		np = of_find_compatible_node(NULL, NULL, "ibm,i2o-460ex");
+		if (!np) {
+			pr_err("%s: can't find I2O device tree node\n",
+				__func__);
+			return -ENODEV;
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
+		enable =  ~(I2O_IOPIM_P1EM | I2O_IOPIM_P1SNE);
+		mask = ioread32(&adev->i2o_reg->iopim) & enable;
+		iowrite32(mask, &adev->i2o_reg->iopim);
+	}
+	return 0;
+
+err_req2:
+	free_irq(adev->irq, chan);
+err_req1:
+	irq_dispose_mapping(adev->irq);
+err_irq_map:
+	if (adev->err_irq > 0) {
+		if (atomic_dec_and_test(&ppc460ex_adma_err_irq_ref))
+			irq_dispose_mapping(adev->err_irq);
+	}
+	return ret;
+}
+static void ppc460ex_adma_release_irqs(struct ppc460ex_adma_device *adev,
+					struct ppc460ex_adma_chan *chan)
+{
+	u32 mask;
+
+	/* disable DMAx engine interrupts */
+	mask = ioread32(&adev->i2o_reg->iopim) | I2O_IOPIM_P1SNE
+		| I2O_IOPIM_P1EM ;
+	iowrite32(mask, &adev->i2o_reg->iopim);
+
+	free_irq(adev->irq, chan);
+	irq_dispose_mapping(adev->irq);
+	if (adev->err_irq > 0) {
+		free_irq(adev->err_irq, chan);
+		if (atomic_dec_and_test(&ppc460ex_adma_err_irq_ref)) {
+			irq_dispose_mapping(adev->err_irq);
+			iounmap(adev->i2o_reg);
+		}
+	}
+}
+/*
+ * ppc460ex_adma_remove - remove the asynch device
+ */
+static int __devexit ppc460ex_adma_remove(struct of_device *ofdev)
+{
+	struct ppc460ex_adma_device *device = dev_get_drvdata(&ofdev->dev);
+	struct device_node *np = ofdev->dev.of_node;
+	struct resource res;
+	struct dma_chan *chan, *_chan;
+	struct ppc460ex_adma_chan *ppc460ex_chan;
+
+	dev_set_drvdata(&ofdev->dev, NULL);
+
+	dma_async_device_unregister(&device->common);
+
+	dma_free_coherent(device->dev, device->pool_size,
+			device->dma_desc_pool_virt, device->dma_desc_pool);
+
+	list_for_each_entry_safe(chan, _chan, &device->common.channels,
+				device_node) {
+		ppc460ex_chan = to_ppc460ex_adma_chan(chan);
+		dma_unmap_page(&ofdev->dev, ppc460ex_chan->pdest,
+				PAGE_SIZE, DMA_BIDIRECTIONAL);
+		dma_unmap_page(&ofdev->dev, ppc460ex_chan->qdest,
+				PAGE_SIZE, DMA_BIDIRECTIONAL);
+		__free_page(ppc460ex_chan->pdest_page);
+		__free_page(ppc460ex_chan->qdest_page);
+		list_del(&chan->device_node);
+		kfree(ppc460ex_chan);
+	}
+
+	dma_free_coherent(device->dev, device->pool_size,
+			  device->dma_desc_pool_virt, device->dma_desc_pool);
+
+
+	iounmap(device->dma_reg);
+	of_address_to_resource(np, 0, &res);
+	release_mem_region(res.start, resource_size(&res));
+	kfree(device);
+	return 0;
+}
+/*
+ * ppc460ex_adma_probe - Probe the DMA engine for features.
+ */
+static int __devinit ppc460ex_adma_probe(struct of_device *ofdev,
+		const struct of_device_id *match)
+{
+	struct device_node *np = ofdev->dev.of_node;
+	struct resource res;
+	struct ppc_dma_chan_ref *ref, *_ref;
+	struct ppc460ex_adma_device *adev;
+	struct ppc460ex_adma_chan *chan;
+	int ret = 0, initcode = PPC_ADMA_INIT_OK;
+	void *regs;
+
+	if (of_address_to_resource(np, 0, &res)) {
+		dev_err(&ofdev->dev, "Failed to get memory resource\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!request_mem_region(res.start, resource_size(&res),
+				dev_driver_string(&ofdev->dev))) {
+		dev_err(&ofdev->dev, "failed to request memory region "
+			"(0x%016llx-0x%016llx)\n",
+			(u64)res.start, (u64)res.end);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* create a device */
+	adev = kzalloc(sizeof(*adev), GFP_KERNEL);
+	if (!adev) {
+		dev_err(&ofdev->dev, "failed to allocate device\n");
+		initcode = PPC_ADMA_INIT_ALLOC;
+		ret = -ENOMEM;
+		goto err_adev_alloc;
+	}
+
+	adev->id = 0;
+	adev->pool_size = DMA_FIFO_SIZE << 2;
+	/*
+	 * allocate coherent memory for hardware descriptors
+	 */
+	adev->dma_desc_pool_virt = dma_alloc_coherent(&ofdev->dev,
+					adev->pool_size, &adev->dma_desc_pool,
+					GFP_KERNEL);
+	if (adev->dma_desc_pool_virt == NULL) {
+		dev_err(&ofdev->dev, "failed to allocate %d bytes of coherent "
+			"memory for hardware descriptors\n",
+			adev->pool_size);
+		ret = -ENOMEM;
+		goto err_dma_alloc;
+	}
+
+	regs = ioremap(res.start, resource_size(&res));
+	if (!regs) {
+		dev_err(&ofdev->dev, "failed to ioremap regs!\n");
+		goto err_regs_alloc;
+	}
+
+	adev->dma_reg = regs;
+	/*
+	 *DMA FIFO length = CSlength + CPlength;
+	 */
+	iowrite32(DMA_FIFO_ENABLE | ((DMA_FIFO_SIZE >> 3) - 2),
+			&adev->dma_reg->fsiz);
+	/* Configure DMA engine */
+	iowrite32(DMA_CFG_DXEPR_HP | DMA_CFG_DFMPP_HP | DMA_CFG_FALGN,
+			&adev->dma_reg->cfg);
+	/* Clear Status */
+	iowrite32(~0, &adev->dma_reg->dsts);
+
+	adev->dev = &ofdev->dev;
+	adev->common.dev = &ofdev->dev;
+	INIT_LIST_HEAD(&adev->common.channels);
+	dev_set_drvdata(&ofdev->dev, adev);
+
+	/* create a channel */
+	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
+	if (!chan) {
+		dev_err(&ofdev->dev, "can't allocate channel structure\n");
+		ret = -ENOMEM;
+		goto err_chan_alloc;
+	}
+	spin_lock_init(&chan->lock);
+	INIT_LIST_HEAD(&chan->chain);
+	INIT_LIST_HEAD(&chan->all_slots);
+	chan->device = adev;
+	chan->common.device = &adev->common;
+	list_add_tail(&chan->common.device_node, &adev->common.channels);
+	tasklet_init(&chan->irq_tasklet, ppc460ex_adma_tasklet,
+			(unsigned long)chan);
+	/*
+	 * allocate and map helper pages for async validation or
+	 * async_mult/async_sum_product operations on DMA0/1.
+	 */
+	chan->pdest_page = alloc_page(GFP_KERNEL);
+	chan->qdest_page = alloc_page(GFP_KERNEL);
+	if (!chan->pdest_page ||
+	    !chan->qdest_page) {
+		if (chan->pdest_page)
+			__free_page(chan->pdest_page);
+		if (chan->qdest_page)
+			__free_page(chan->qdest_page);
+		ret = -ENOMEM;
+		goto err_page_alloc;
+	}
+	chan->pdest = dma_map_page(&ofdev->dev, chan->pdest_page, 0,
+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
+	chan->qdest = dma_map_page(&ofdev->dev, chan->qdest_page, 0,
+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+	ref = kmalloc(sizeof(*ref), GFP_KERNEL);
+	if (ref) {
+		ref->chan = &chan->common;
+		INIT_LIST_HEAD(&ref->node);
+		list_add_tail(&ref->node, &ppc460ex_adma_chan_list);
+	} else {
+		dev_err(&ofdev->dev, "failed to allocate channel reference!\n");
+		ret = -ENOMEM;
+		goto err_ref_alloc;
+	}
+
+
+	ret = ppc460ex_setup_irqs(adev, chan, &initcode);
+	if (ret)
+		goto err_irq;
+	ppc460ex_adma_init_capabilities(adev);
+
+	ret = dma_async_device_register(&adev->common);
+	if (ret) {
+		dev_err(&ofdev->dev, "failed to register dma device\n");
+		goto err_dev_reg;
+	}
+	goto out;
+
+err_dev_reg:
+	ppc460ex_adma_release_irqs(adev, chan);
+err_irq:
+	list_for_each_entry_safe(ref, _ref, &ppc460ex_adma_chan_list, node) {
+		if (chan == to_ppc460ex_adma_chan(ref->chan)) {
+			list_del(&ref->node);
+			kfree(ref);
+		}
+	}
+
+err_ref_alloc:
+	dma_unmap_page(&ofdev->dev, chan->pdest,
+			PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_unmap_page(&ofdev->dev, chan->qdest,
+			PAGE_SIZE, DMA_BIDIRECTIONAL);
+	__free_page(chan->pdest_page);
+	__free_page(chan->qdest_page);
+
+err_page_alloc:
+	kfree(chan);
+err_chan_alloc:
+	iounmap(adev->dma_reg);
+err_regs_alloc:
+	dma_free_coherent(adev->dev, adev->pool_size,
+			adev->dma_desc_pool_virt,
+			adev->dma_desc_pool);
+err_dma_alloc:
+	kfree(adev);
+err_adev_alloc:
+	release_mem_region(res.start, resource_size(&res));
+out:
+	return ret;
+
+}
+/*
+ * Create sys fs entries to enable DMA engine and select RAID-6 Poly
+ * nomial
+ */
+/*
+ *One time initialization which would decide some proparties like
+ *FIO depth, priority LL HB buses etc.
+ */
+static int ppc460ex_configure_raid_devices(void)
+{
+	struct device_node *np;
+	struct resource i2o_res;
+	struct i2o_regs __iomem *i2o_reg;
+	dcr_host_t i2o_dcr_host;
+	unsigned int dcr_base, dcr_len;
+	int i, ret;
+
+	np = of_find_compatible_node(NULL, NULL, "ibm,i2o-460ex");
+	if (!np) {
+		pr_err("%s: can't find I2O device tree node\n",
+			__func__);
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
+			np->full_name);
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
+	ppc460ex_dma_fifo_buf = kmalloc(DMA_FIFO_SIZE, GFP_KERNEL);
+	if (!ppc460ex_dma_fifo_buf) {
+		pr_err("%s: DMA FIFO buffer allocation failed\n", __func__);
+		iounmap(i2o_reg);
+		dcr_unmap(i2o_dcr_host, dcr_len);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Confgiure HW
+	 */
+	/* reset DMA */
+	mtdcri(SDR0, DCRN_SDR0_SRST, DCRN_SDR0_SRST_I2ODMA);
+	mtdcri(SDR0, DCRN_SDR0_SRST, 0);
+
+	/* Setup the base address of mmapped registers */
+	dcr_write(i2o_dcr_host, DCRN_I2O0_IBAH, (u32)(i2o_res.start >> 32));
+	dcr_write(i2o_dcr_host, DCRN_I2O0_IBAL, (u32)(i2o_res.start) |
+			I2O_REG_ENABLE);
+	dcr_unmap(i2o_dcr_host, dcr_len);
+
+	/* Setup FIFO memory space base address */
+	iowrite32(0, &i2o_reg->ifbah);
+	iowrite32(((u32)__pa(ppc460ex_dma_fifo_buf)), &i2o_reg->ifbal);
+
+	/* set zero FIFO size for I2O, so the whole
+	 * ppc460ex_dma_fifo_buf is used by DMAs.
+	 * DMAx_FIFOs will be configured while probe.
+	 */
+	iowrite32(0, &i2o_reg->ifsiz);
+	iounmap(i2o_reg);
+
+	/* To prepare WXOR/RXOR functionality we need access to
+	 * Memory Queue Module DCRs (finally it will be enabled
+	 * via /sys interface of the ppc460ex ADMA driver).
+	 */
+	np = of_find_compatible_node(NULL, NULL, "ibm,mq-460ex");
+	if (!np) {
+		pr_err("%s: can't find MQ device tree node\n",
+			__func__);
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	/* Get MQ DCRs base */
+	dcr_base = dcr_resource_start(np, 0);
+	dcr_len = dcr_resource_len(np, 0);
+	if (!dcr_base && !dcr_len) {
+		pr_err("%s: can't get DCR registers base/len!\n",
+			np->full_name);
+		ret = -ENODEV;
+		goto out_mq;
+	}
+
+	ppc460ex_mq_dcr_host = dcr_map(np, dcr_base, dcr_len);
+	if (!DCR_MAP_OK(ppc460ex_mq_dcr_host)) {
+		pr_err("%s: failed to map DCRs!\n", np->full_name);
+		ret = -ENODEV;
+		goto out_mq;
+	}
+	of_node_put(np);
+	ppc460ex_mq_dcr_len = dcr_len;
+
+	/* Set HB alias */
+	dcr_write(ppc460ex_mq_dcr_host, DCRN_MQ0_BAUH, DMA_CUED_XOR_HB);
+
+	/* Set:
+	 * - LL transaction passing limit to 1;
+	 * - Memory controller cycle limit to 1;
+	 * - Galois Polynomial to 0x14d (default)
+	 */
+	dcr_write(ppc460ex_mq_dcr_host, DCRN_MQ0_CFBHL,
+		  (1 << MQ0_CFBHL_TPLM) | (1 << MQ0_CFBHL_HBCL) |
+		  (PPC460EX_DEFAULT_POLY << MQ0_CFBHL_POLY));
+
+	atomic_set(&ppc460ex_adma_err_irq_ref, 0);
+	for (i = 0; i < PPC460EX_ADMA_ENGINES_NUM; i++)
+		ppc460ex_adma_devices[i] = -1;
+
+	return 0;
+
+out_mq:
+	of_node_put(np);
+out_free:
+	kfree(ppc460ex_dma_fifo_buf);
+	return ret;
+
+}
+
+static struct of_device_id adma_match[] = {
+	{
+		.compatible     = "amcc,dma-460ex",
+	},
+	{},
+};
+static struct of_platform_driver ppc460ex_adma_driver = {
+	.probe		= ppc460ex_adma_probe,
+	.remove		= ppc460ex_adma_remove,
+	.driver = {
+		.name		= "PPC460Ex-ADMA",
+		.owner = THIS_MODULE,
+		.of_match_table = adma_match,
+	},
+};
+static int __init ppc460ex_adma_init(void)
+{
+	int rval;
+
+	rval = ppc460ex_configure_raid_devices();
+	if (rval)
+		return rval;
+
+	rval = of_register_platform_driver(&ppc460ex_adma_driver);
+	if (rval) {
+		pr_err("%s: Driver reigstration failed\n", __func__);
+		goto out_reg;
+	}
+	/* Initialization status */
+	rval = driver_create_file(&ppc460ex_adma_driver.driver,
+				 &driver_attr_devices);
+	if (rval)
+		goto out_dev;
+
+	/* RAID-6 h/w enable entry */
+	rval = driver_create_file(&ppc460ex_adma_driver.driver,
+				 &driver_attr_raid6_enable);
+	if (rval)
+		goto out_en;
+	/* RAID-5 h/w enable entry */
+	rval = driver_create_file(&ppc460ex_adma_driver.driver,
+				 &driver_attr_raid5_enable);
+	if (rval)
+		goto out_en;
+
+	/* GF polynomial to use */
+	rval = driver_create_file(&ppc460ex_adma_driver.driver,
+				 &driver_attr_poly);
+	if (!rval)
+		return rval;
+
+out_en:
+	driver_remove_file(&ppc460ex_adma_driver.driver,
+			   &driver_attr_devices);
+out_dev:
+	/* User will not be able to enable h/w RAID-6 */
+	pr_err("%s: failed to create RAID-6 driver interface\n",
+		__func__);
+	of_unregister_platform_driver(&ppc460ex_adma_driver);
+out_reg:
+	dcr_unmap(ppc460ex_mq_dcr_host , ppc460ex_mq_dcr_len);
+	kfree(ppc460ex_dma_fifo_buf);
+	return rval;
+
+
+}
+static void __exit ppc460ex_adma_exit(void)
+{
+	driver_remove_file(&ppc460ex_adma_driver.driver,
+			   &driver_attr_poly);
+	driver_remove_file(&ppc460ex_adma_driver.driver,
+			   &driver_attr_raid5_enable);
+	driver_remove_file(&ppc460ex_adma_driver.driver,
+			   &driver_attr_raid6_enable);
+	driver_remove_file(&ppc460ex_adma_driver.driver,
+			   &driver_attr_devices);
+	of_unregister_platform_driver(&ppc460ex_adma_driver);
+	dcr_unmap(ppc460ex_mq_dcr_host, ppc460ex_mq_dcr_len);
+}
+arch_initcall(ppc460ex_adma_init);
+module_exit(ppc460ex_adma_exit);
+
+MODULE_AUTHOR(" Tirumala R Marri <tmarri@apm.com>");
+MODULE_DESCRIPTION(" PPC460Ex ADMA Engine Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/dma/ppc4xx/adma1.h b/drivers/dma/ppc4xx/adma1.h
new file mode 100644
index 0000000..7a71f8d
--- /dev/null
+++ b/drivers/dma/ppc4xx/adma1.h
@@ -0,0 +1,192 @@
+/*
+ * 2010 (C) Applied Micro(APM).
+ *
+ * Author: Tirumala R Marri <tmarri@apm.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of
+ * any kind, whether express or implied.
+ */
+#ifndef PPC460EX_ADMA_H
+#define PPC460EX_ADMA_H
+
+#include <linux/types.h>
+#include "dma.h"
+
+#define to_ppc460ex_adma_chan(chan) \
+	container_of(chan, struct ppc460ex_adma_chan, common)
+#define to_ppc460ex_adma_device(dev) \
+	container_of(dev, struct ppc460ex_adma_device, common)
+#define tx_to_ppc460ex_adma_slot(tx) \
+	container_of(tx, struct ppc460ex_adma_desc_slot, async_tx)
+
+#define PPC460EX_R6_PROC_ROOT   "driver/460ex_raid6"
+#define PPC460EX_R5_PROC_ROOT   "driver/460ex_raid5"
+
+#define PPC460EX_DEFAULT_POLY   0x4d
+
+#define PPC460EX_ADMA_ENGINES_NUM 1
+#define PPC460EX_ADMA_WATCHDOG_MSEC 3
+#define PPC460EX_ADMA_THRESHOLD  1
+
+#define XOR_MAX_OPS 16
+
+
+#define PPC460EX_ADMA_DMA_MAX_BYTE_COUNT        0xFFFFFFUL
+/* this is the XOR_CBBCR width */
+#define PPC460EX_ADMA_XOR_MAX_BYTE_COUNT (1 << 31)
+#define PPC460EX_ADMA_ZERO_SUM_MAX_BYTE_COUNT PPC460EX_ADMA_XOR_MAX_BYTE_COUNT
+
+#define DMA_FIFO_SIZE          0x1000
+
+#define PPC460EX_RXOR_RUN       0
+#define MQ0_CF2H_RXOR_BS_MASK   0x1FF
+
+#define DMA_ZERO_P 7
+
+/**
+ * struct ppc460ex_adma_device - internal representation of an ADMA device
+ * @dev: device
+ * @dma_reg: DMA register base
+ * @i2o_reg: I2O register base
+ * @id: HW ADMA Device selector
+ * @dma_desc_pool_virt: base of DMA descriptor region (CPU address)
+ * @dma_desc_pool: base of DMA descriptor region (DMA address)
+ * @pool_size: Size of the descriptor pool.
+ * @irq: DMA completion interrupt
+ * @err_irq: DMA error interrupt
+ * @common: embedded struct dma_device
+ */
+struct ppc460ex_adma_device {
+	struct device *dev;
+	struct dma_regs __iomem *dma_reg;
+	struct i2o_regs __iomem *i2o_reg;
+	int id;
+	void *dma_desc_pool_virt;
+	dma_addr_t dma_desc_pool;
+	size_t pool_size;
+	int irq;
+	int err_irq;
+	struct dma_device common;
+};
+
+/**
+ * struct ppc460ex_adma_chan - internal representation of an ADMA channel
+ * @lock: serializes enqueue/dequeue operations to the slot pool
+ * @device: parent device
+ * @chain: device chain view of the descriptors
+ * @common: common dmaengine channel object members
+ * @all_slots: complete domain of slots usable by the channel
+ * @last_used:
+ * @pending: allows batching of hardware operations
+ * @completed_cookie: identifier for the most recently completed operation
+ * @slots_allocated: records the actual size of the descriptor slot pool
+ * @hw_chain_inited: h/w descriptor chain initialization flag
+ * @irq_tasklet: bottom half where ppc460ex_adma_slot_cleanup runs
+ * @needs_unmap: if buffers should not be unmapped upon final processing
+ * @pdest_page: P destination page for async validate operation
+ * @qdest_page: Q destination page for async validate operation
+ * @pdest: P dma addr for async validate operation
+ * @qdest: Q dma addr for async validate operation
+ */
+struct ppc460ex_adma_chan {
+	spinlock_t lock;
+	struct ppc460ex_adma_device *device;
+	struct list_head chain;
+	struct dma_chan common;
+	struct list_head all_slots;
+	struct ppc460ex_adma_desc_slot *last_used;
+	int pending;
+	dma_cookie_t completed_cookie;
+	int slots_allocated;
+	int hw_chain_inited;
+	struct tasklet_struct irq_tasklet;
+	u8 needs_unmap;
+	struct page *pdest_page;
+	struct page *qdest_page;
+	dma_addr_t pdest;
+	dma_addr_t qdest;
+};
+
+struct ppc460ex_rxor {
+	u32 addrl;
+	u32 addrh;
+	int len;
+	int xor_count;
+	int addr_count;
+	int desc_count;
+	int state;
+};
+
+/**
+ * struct ppc460ex_adma_desc_slot - PPC460EX-ADMA software descriptor
+ * @phys: hardware address of the hardware descriptor chain
+ * @group_head: first operation in a transaction
+ * @hw_next: pointer to the next descriptor in chain
+ * @async_tx: support for the async_tx api
+ * @slot_node: node on the iop_adma_chan.all_slots list
+ * @chain_node: node on the op_adma_chan.chain list
+ * @group_list: list of slots that make up a multi-descriptor transaction
+ *      for example transfer lengths larger than the supported hw max
+ * @unmap_len: transaction bytecount
+ * @hw_desc: virtual address of the hardware descriptor chain
+ * @stride: currently chained or not
+ * @idx: pool index
+ * @slot_cnt: total slots used in an transaction (group of operations)
+ * @src_cnt: number of sources set in this descriptor
+ * @dst_cnt: number of destinations set in the descriptor
+ * @slots_per_op: number of slots per operation
+ * @descs_per_op: number of slot per P/Q operation see comment
+ * for ppc460ex_prep_dma_pqxor function
+ * @flags: desc state/type
+ * @reverse_flags: 1 if a corresponding rxor address uses reversed address order
+ * @xor_check_result: result of zero sum
+ * @crc32_result: result crc calculation
+ */
+struct ppc460ex_adma_desc_slot {
+	dma_addr_t phys;
+	struct ppc460ex_adma_desc_slot *group_head;
+	struct ppc460ex_adma_desc_slot *hw_next;
+	struct dma_async_tx_descriptor async_tx;
+	struct list_head slot_node;
+	struct list_head chain_node; /* node in channel ops list */
+	struct list_head group_list; /* list */
+	unsigned int unmap_len;
+	void *hw_desc;
+	u16 stride;
+	u16 idx;
+	u16 slot_cnt;
+	u8 src_cnt;
+	u8 dst_cnt;
+	u8 slots_per_op;
+	u8 descs_per_op;
+	unsigned long flags;
+	unsigned long reverse_flags[8];
+
+#define PPC460EX_DESC_INT	0	/* generate interrupt on complete */
+#define PPC460EX_ZERO_P        1       /* clear P destionaion */
+#define PPC460EX_ZERO_Q        2       /* clear Q destination */
+#define PPC460EX_COHERENT	3	/* src/dst are coherent */
+
+#define PPC460EX_DESC_WXOR	4	/* WXORs are in chain */
+#define PPC460EX_DESC_RXOR	5	/* RXOR is in chain */
+
+#define PPC460EX_DESC_RXOR123	8	/* CDB for RXOR123 operation */
+#define PPC460EX_DESC_RXOR124	9	/* CDB for RXOR124 operation */
+#define PPC460EX_DESC_RXOR125	10	/* CDB for RXOR125 operation */
+#define PPC460EX_DESC_RXOR12	11	/* CDB for RXOR12 operation */
+#define PPC460EX_DESC_RXOR_REV	12	/* CDB cont srcs in reversed order*/
+
+#define PPC460EX_DESC_PCHECK   13
+#define PPC460EX_DESC_QCHECK   14
+
+#define PPC460EX_DESC_RXOR_MSK	0x3
+
+
+	union {
+		u32 *xor_check_result;
+		u32 *crc32_result;
+	};
+};
+
+#endif /* PPC460EX_ADMA_H*/
diff --git a/drivers/dma/ppc4xx/dma.h b/drivers/dma/ppc4xx/dma.h
index bcde2df..9c05b1f 100644
--- a/drivers/dma/ppc4xx/dma.h
+++ b/drivers/dma/ppc4xx/dma.h
@@ -10,11 +10,23 @@
  * kind, whether express or implied.
  */
 
-#ifndef	_PPC440SPE_DMA_H
-#define _PPC440SPE_DMA_H
+#ifndef	_PPC4XX_DMA_H
+#define _PPC4XX_DMA_H
 
 #include <linux/types.h>
 
+#if defined(CONFIG_PPC460EX)
+
+/* Number of elements in the array with statical CDBs */
+#define	MAX_STAT_DMA_CDBS	16
+/* Number of DMA engines available on the contoller */
+#define DMA_ENGINES_NUM		1
+/* Maximum h/w supported number of destinations */
+#define DMA_DEST_MAX_NUM	2
+
+#define DMA_FIFO_SIZE		0x1000
+#else
+
 /* Number of elements in the array with statical CDBs */
 #define	MAX_STAT_DMA_CDBS	16
 /* Number of DMA engines available on the contoller */
@@ -57,6 +69,8 @@
 #define I2O_IOPIM_P1SNE		(1<<6)
 #define I2O_IOPIM_P1EM		(1<<8)
 
+#endif /*defined(CONFIG_460EX)*/
+
 /* DMA CDB fields */
 #define DMA_CDB_MSK		(0xF)
 #define DMA_CDB_64B_ADDR	(1<<2)
@@ -220,4 +234,4 @@ struct i2o_regs {
 	u32	iopt;
 };
 
-#endif /* _PPC440SPE_DMA_H */
+#endif /* _PPC4XX_DMA_H */
-- 
1.6.1.rc3
