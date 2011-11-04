From: vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org
Subject: [PATCH] crypto: driver for tegra AES hardware
Date: Fri,  4 Nov 2011 16:44:16 +0530
Message-ID: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
To: herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

driver supports ecb/cbc/ofb/ansi_x9.31rng modes,
128, 192 and 256-bit key sizes.

Change-Id: Ic7d8d6d76b8ab6712f3bc9048e2dee7b5ebd13ff
Signed-off-by: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 drivers/crypto/Kconfig     |    8 +
 drivers/crypto/Makefile    |    2 +
 drivers/crypto/tegra-aes.c | 1120 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/tegra-aes.h |  114 +++++
 4 files changed, 1244 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/tegra-aes.c
 create mode 100644 drivers/crypto/tegra-aes.h

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6d16b4b..8a7bf8d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -293,4 +293,12 @@ config CRYPTO_DEV_S5P
 	  Select this to offload Samsung S5PV210 or S5PC110 from AES
 	  algorithms execution.
 
+config CRYPTO_DEV_TEGRA_AES
+	tristate "Support for TEGRA AES hw engine"
+	depends on ARCH_TEGRA_2x_SOC
+	select CRYPTO_AES
+	help
+	  TEGRA processors have AES module accelerator. Select this if you
+	  want to use the TEGRA module for AES algorithms.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 53ea501..e9ab276 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
+obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
+
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
new file mode 100644
index 0000000..b180a93
--- /dev/null
+++ b/drivers/crypto/tegra-aes.c
@@ -0,0 +1,1120 @@
+/*
+ * drivers/crypto/tegra-aes.c
+ *
+ * Driver for NVIDIA Tegra AES hardware engine residing inside the
+ * Bit Stream Engine for Video (BSEV) hardware block.
+ *
+ * The programming sequence for this engine is with the help
+ * of commands which travel via a command queue residing between the
+ * CPU and the BSEV block. The BSEV engine has an internal RAM (VRAM)
+ * where the final input plaintext, keys and the IV have to be copied
+ * before starting the encrypt/decrypt operation.
+ *
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+
+#include <mach/clk.h>
+
+#include <crypto/scatterwalk.h>
+#include <crypto/aes.h>
+#include <crypto/internal/rng.h>
+
+#include "tegra-aes.h"
+
+#define FLAGS_MODE_MASK		0x00ff
+#define FLAGS_ENCRYPT		BIT(0)
+#define FLAGS_CBC			BIT(1)
+#define FLAGS_GIV			BIT(2)
+#define FLAGS_RNG			BIT(3)
+#define FLAGS_OFB			BIT(4)
+#define FLAGS_NEW_KEY			BIT(5)
+#define FLAGS_NEW_IV			BIT(6)
+#define FLAGS_INIT			BIT(7)
+#define FLAGS_FAST			BIT(8)
+#define FLAGS_BUSY			9
+
+/*
+ * Defines AES engine Max process bytes size in one go, which takes 1 msec.
+ * AES engine spends about 176 cycles/16-bytes or 11 cycles/byte
+ * The duration CPU can use the BSE to 1 msec, then the number of available
+ * cycles of AVP/BSE is 216K. In this duration, AES can process 216/11 ~= 19KB
+ * Based on this AES_HW_DMA_BUFFER_SIZE_BYTES is configured to 16KB.
+ */
+#define AES_HW_DMA_BUFFER_SIZE_BYTES 0x4000
+
+/*
+ * The key table length is 64 bytes
+ * (This includes first upto 32 bytes key + 16 bytes original initial vector
+ * and 16 bytes updated initial vector)
+ */
+#define AES_HW_KEY_TABLE_LENGTH_BYTES 64
+
+/*
+ * The memory being used is divides as follows:
+ * 1. Key - 32 bytes
+ * 2. Original IV - 16 bytes
+ * 3. Updated IV - 16 bytes
+ * 4. Key schedule - 256 bytes
+ *
+ * 1+2+3 constitute the hw key table.
+ */
+#define AES_HW_IV_SIZE 16
+#define AES_HW_KEYSCHEDULE_LEN 256
+#define AES_IVKEY_SIZE (AES_HW_KEY_TABLE_LENGTH_BYTES + AES_HW_KEYSCHEDULE_LEN)
+
+/* Define commands required for AES operation */
+enum {
+	CMD_BLKSTARTENGINE = 0x0E,
+	CMD_DMASETUP = 0x10,
+	CMD_DMACOMPLETE = 0x11,
+	CMD_SETTABLE = 0x15,
+	CMD_MEMDMAVD = 0x22,
+};
+
+/* Define sub-commands */
+enum {
+	SUBCMD_VRAM_SEL = 0x1,
+	SUBCMD_CRYPTO_TABLESEL = 0x3,
+	SUBCMD_KEYTABLESEL = 0x8,
+};
+
+/* memdma_vd command */
+#define MEMDMA_DIR_DTOVRAM		0 /* sdram -> vram */
+#define MEMDMA_DIR_VTODRAM		1 /* vram -> sdram */
+#define MEMDMABITSHIFT_DIR		25
+#define MEMDMABITSHIFT_NUM_WORDS	12
+
+/* command queue bit shifts */
+enum {
+	CMDQBITSHIFT_KEYTABLEADDR = 0,
+	CMDQBITSHIFT_KEYTABLEID = 17,
+	CMDQBITSHIFT_VRAMSEL = 23,
+	CMDQBITSHIFT_TABLESEL = 24,
+	CMDQBITSHIFT_OPCODE = 26,
+};
+
+/*
+ * The secure key slot contains a unique secure key generated
+ * and loaded by the bootloader. This slot is marked as non-accessible
+ * to the kernel.
+ */
+#define SSK_SLOT_NUM		4
+
+#define AES_NR_KEYSLOTS		8
+#define TEGRA_AES_QUEUE_LENGTH	50
+#define DEFAULT_RNG_BLK_SZ	16
+
+/* The command queue depth */
+#define AES_HW_MAX_ICQ_LENGTH	5
+
+struct tegra_aes_slot {
+	struct list_head node;
+	int slot_num;
+	bool available;
+};
+
+static struct tegra_aes_slot ssk = {
+	.slot_num = SSK_SLOT_NUM,
+	.available = true,
+};
+
+struct tegra_aes_reqctx {
+	unsigned long mode;
+};
+
+struct tegra_aes_dev {
+	struct device *dev;
+	unsigned long phys_base;
+	void __iomem *io_base;
+	dma_addr_t ivkey_phys_base;
+	void __iomem *ivkey_base;
+	struct clk *aes_clk;
+	struct tegra_aes_ctx *ctx;
+	unsigned long flags;
+	struct completion op_complete;
+	u32 *buf_in;
+	dma_addr_t dma_buf_in;
+	u32 *buf_out;
+	dma_addr_t dma_buf_out;
+	u8 *iv;
+	u8 dt[DEFAULT_RNG_BLK_SZ];
+	int ivlen;
+	u64 ctr;
+	spinlock_t lock;
+	struct crypto_queue queue;
+	struct tegra_aes_slot *slots;
+	struct ablkcipher_request *req;
+	size_t total;
+	struct scatterlist *in_sg;
+	size_t in_offset;
+	struct scatterlist *out_sg;
+	size_t out_offset;
+};
+
+static struct tegra_aes_dev *aes_dev;
+
+struct tegra_aes_ctx {
+	struct tegra_aes_dev *dd;
+	unsigned long flags;
+	struct tegra_aes_slot *slot;
+	u8 key[AES_MAX_KEY_SIZE];
+	int keylen;
+};
+
+static struct tegra_aes_ctx rng_ctx = {
+	.flags = FLAGS_NEW_KEY,
+	.keylen = AES_KEYSIZE_128,
+};
+
+/* keep registered devices data here */
+static LIST_HEAD(dev_list);
+static DEFINE_SPINLOCK(list_lock);
+static DEFINE_MUTEX(aes_lock);
+
+static void aes_workqueue_handler(struct work_struct *work);
+static DECLARE_WORK(aes_work, aes_workqueue_handler);
+static struct workqueue_struct *aes_wq;
+
+extern unsigned long long tegra_chip_uid(void);
+
+static inline u32 aes_readl(struct tegra_aes_dev *dd, u32 offset)
+{
+	return readl(dd->io_base + offset);
+}
+
+static inline void aes_writel(struct tegra_aes_dev *dd, u32 val, u32 offset)
+{
+	writel(val, dd->io_base + offset);
+}
+
+static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
+	int nblocks, int mode, bool upd_iv)
+{
+	u32 cmdq[AES_HW_MAX_ICQ_LENGTH];
+	int qlen = 0, i, eng_busy, icq_empty, ret;
+	u32 value;
+
+	/* reset all the interrupt bits */
+	aes_writel(eng, 0xFFFFFFFF, INTR_STATUS);
+
+	/* enable error, dma xfer complete interrupts */
+	aes_writel(dd, 0x33, INT_ENB);
+	enable_irq(INT_VDE_BSE_V);
+
+	cmdq[qlen++] = CMD_DMASETUP << CMDQBITSHIFT_OPCODE;
+	cmdq[qlen++] = in_addr;
+	cmdq[qlen++] = CMD_BLKSTARTENGINE << CMDQBITSHIFT_OPCODE | (nblocks-1);
+	cmdq[qlen++] = CMD_DMACOMPLETE << CMDQBITSHIFT_OPCODE;
+
+	value = aes_readl(dd, CMDQUE_CONTROL);
+	/* access SDRAM through AHB */
+	value &= ~CMDQ_CTRL_SRC_STM_SEL_FIELD;
+	value &= ~CMDQ_CTRL_DST_STM_SEL_FIELD;
+	value |= (CMDQ_CTRL_SRC_STM_SEL_FIELD | CMDQ_CTRL_DST_STM_SEL_FIELD |
+		CMDQ_CTRL_ICMDQEN_FIELD);
+	aes_writel(dd, value, CMDQUE_CONTROL);
+	dev_dbg(dd->dev, "cmd_q_ctrl=0x%x", value);
+
+	value = (0x1 << SECURE_INPUT_ALG_SEL_SHIFT) |
+		((dd->ctx->keylen * 8) << SECURE_INPUT_KEY_LEN_SHIFT) |
+		((u32)upd_iv << SECURE_IV_SELECT_SHIFT);
+
+	if (mode & FLAGS_CBC) {
+		value |= ((((mode & FLAGS_ENCRYPT) ? 2 : 3)
+				<< SECURE_XOR_POS_SHIFT) |
+			(0 << SECURE_INPUT_SEL_SHIFT) |
+			(((mode & FLAGS_ENCRYPT) ? 2 : 3)
+				<< SECURE_VCTRAM_SEL_SHIFT) |
+			((mode & FLAGS_ENCRYPT) ? 1 : 0)
+				<< SECURE_CORE_SEL_SHIFT |
+			(0 << SECURE_RNG_ENB_SHIFT) |
+			(0 << SECURE_HASH_ENB_SHIFT));
+	} else if (mode & FLAGS_OFB) {
+		value |= ((0 << SECURE_IV_SELECT_SHIFT) |
+			(SECURE_XOR_POS_FIELD) |
+			(2 << SECURE_INPUT_SEL_SHIFT) |
+			(0 << SECURE_VCTRAM_SEL_SHIFT) |
+			(SECURE_CORE_SEL_FIELD) |
+			(0 << SECURE_RNG_ENB_SHIFT) |
+			(0 << SECURE_HASH_ENB_SHIFT));
+	} else if (mode & FLAGS_RNG){
+		value |= ((0 << SECURE_XOR_POS_SHIFT) |
+			(0 << SECURE_INPUT_SEL_SHIFT) |
+			((mode & FLAGS_ENCRYPT) ? 1 : 0)
+				<< SECURE_CORE_SEL_SHIFT |
+			(1 << SECURE_RNG_ENB_SHIFT) |
+			(0 << SECURE_HASH_ENB_SHIFT));
+	} else {
+		value |= ((0 << SECURE_XOR_POS_SHIFT) |
+			(0 << SECURE_INPUT_SEL_SHIFT) |
+			(((mode & FLAGS_ENCRYPT) ? 1 : 0)
+				<< SECURE_CORE_SEL_SHIFT) |
+			(0 << SECURE_RNG_ENB_SHIFT) |
+				(0 << SECURE_HASH_ENB_SHIFT));
+	}
+	dev_dbg(dd->dev, "secure_in_sel=0x%x", value);
+	aes_writel(dd, value, SECURE_INPUT_SELECT);
+
+	aes_writel(dd, out_addr, SECURE_DEST_ADDR);
+	INIT_COMPLETION(dd->op_complete);
+
+	for (i = 0; i < qlen - 1; i++) {
+		do {
+			value = aes_readl(dd, INTR_STATUS);
+			eng_busy = value & BIT(0);
+			icq_empty = value & BIT(3);
+		} while (eng_busy & (!icq_empty));
+		aes_writel(dd, cmdq[i], ICMDQUE_WR);
+	}
+
+	ret = wait_for_completion_timeout(&dd->op_complete, msecs_to_jiffies(150));
+	if (ret == 0) {
+		dev_err(dd->dev, "timed out (0x%x)\n",
+			aes_readl(dd, INTR_STATUS));
+		disable_irq(INT_VDE_BSE_V);
+		return -ETIMEDOUT;
+	}
+
+	disable_irq(INT_VDE_BSE_V);
+	aes_writel(dd, cmdq[qlen - 1], ICMDQUE_WR);
+	return 0;
+}
+
+static void aes_release_key_slot(struct tegra_aes_ctx *ctx)
+{
+	spin_lock(&list_lock);
+	ctx->slot->available = true;
+	ctx->slot = NULL;
+	spin_unlock(&list_lock);
+}
+
+static struct tegra_aes_slot *aes_find_key_slot(struct tegra_aes_dev *dd)
+{
+	struct tegra_aes_slot *slot = NULL;
+	bool found = false;
+
+	spin_lock(&list_lock);
+	list_for_each_entry(slot, &dev_list, node) {
+		dev_dbg(dd->dev, "empty:%d, num:%d\n", slot->available,
+			slot->slot_num);
+		if (slot->available) {
+			slot->available = false;
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&list_lock);
+	return found ? slot : NULL;
+}
+
+static int aes_set_key(struct tegra_aes_dev *dd)
+{
+	u32 value, cmdq[2];
+	struct tegra_aes_ctx *ctx = dd->ctx;
+	int i, eng_busy, icq_empty, dma_busy;
+	bool use_ssk = false;
+
+	if (!ctx) {
+		dev_err(dd->dev, "%s: context invalid\n", __func__);
+		return -EINVAL;
+	}
+
+	/* use ssk? */
+	if (!dd->ctx->slot) {
+		dev_dbg(dd->dev, "using ssk");
+		dd->ctx->slot = &ssk;
+		use_ssk = true;
+	}
+
+	/* enable key schedule generation in hardware */
+	value = aes_readl(dd, SECURE_CONFIG_EXT);
+	value &= ~SECURE_KEY_SCH_DIS_FIELD;
+	aes_writel(dd, value, SECURE_CONFIG_EXT);
+
+	/* select the key slot */
+	value = aes_readl(dd, SECURE_CONFIG);
+	value &= ~SECURE_KEY_INDEX_FIELD;
+	value |= (ctx->slot->slot_num << SECURE_KEY_INDEX_SHIFT);
+	aes_writel(dd, value, SECURE_CONFIG);
+
+	if (use_ssk)
+		goto out;
+
+	/* copy the key table from sdram to vram */
+	cmdq[0] = 0;
+	cmdq[0] = CMD_MEMDMAVD << CMDQBITSHIFT_OPCODE |
+		(MEMDMA_DIR_DTOVRAM << MEMDMABITSHIFT_DIR) |
+		(AES_HW_KEY_TABLE_LENGTH_BYTES/sizeof(u32))
+			<< MEMDMABITSHIFT_NUM_WORDS;
+	cmdq[1] = (u32)dd->ivkey_phys_base;
+
+	for (i = 0; i < ARRAY_SIZE(cmdq); i++)
+		aes_writel(dd, cmdq[i], ICMDQUE_WR);
+
+	do {
+		value = aes_readl(dd, INTR_STATUS);
+		eng_busy = value & BIT(0);
+		icq_empty = value & BIT(3);
+		dma_busy = value & BIT(23);
+	} while (eng_busy & (!icq_empty) & dma_busy);
+
+	/* settable command to get key into internal registers */
+	value = 0;
+	value = CMD_SETTABLE << CMDQBITSHIFT_OPCODE |
+		SUBCMD_CRYPTO_TABLESEL << CMDQBITSHIFT_TABLESEL |
+		SUBCMD_VRAM_SEL << CMDQBITSHIFT_VRAMSEL |
+		(SUBCMD_KEYTABLESEL | ctx->slot->slot_num)
+			<< CMDQBITSHIFT_KEYTABLEID;
+	aes_writel(dd, value, ICMDQUE_WR);
+
+	do {
+		value = aes_readl(dd, INTR_STATUS);
+		eng_busy = value & BIT(0);
+		icq_empty = value & BIT(3);
+	} while (eng_busy & (!icq_empty));
+
+out:
+	return 0;
+}
+
+static int tegra_aes_handle_req(struct tegra_aes_dev *dd)
+{
+	struct crypto_async_request *async_req, *backlog;
+	struct tegra_aes_ctx *ctx;
+	struct tegra_aes_reqctx *rctx;
+	struct ablkcipher_request *req;
+	unsigned long flags;
+	int dma_max = AES_HW_DMA_BUFFER_SIZE_BYTES;
+	int ret = 0, nblocks, total;
+	int count = 0;
+	dma_addr_t addr_in, addr_out;
+	struct scatterlist *in_sg, *out_sg;
+
+	if (!dd)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	backlog = crypto_get_backlog(&dd->queue);
+	async_req = crypto_dequeue_request(&dd->queue);
+	if (!async_req)
+		clear_bit(FLAGS_BUSY, &dd->flags);
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	if (!async_req)
+		return -ENODATA;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req = ablkcipher_request_cast(async_req);
+
+	dev_dbg(dd->dev, "%s: get new req\n", __func__);
+
+	if (!req->src || !req->dst)
+		return -EINVAL;
+
+	/* take mutex to access the aes hw */
+	mutex_lock(&aes_lock);
+
+	/* assign new request to device */
+	dd->req = req;
+	dd->total = req->nbytes;
+	dd->in_offset = 0;
+	dd->in_sg = req->src;
+	dd->out_offset = 0;
+	dd->out_sg = req->dst;
+
+	in_sg = dd->in_sg;
+	out_sg = dd->out_sg;
+
+	total = dd->total;
+	rctx = ablkcipher_request_ctx(req);
+	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+	rctx->mode &= FLAGS_MODE_MASK;
+	dd->flags = (dd->flags & ~FLAGS_MODE_MASK) | rctx->mode;
+
+	dd->iv = (u8 *)req->info;
+	dd->ivlen = AES_BLOCK_SIZE;
+
+	/* assign new context to device */
+	ctx->dd = dd;
+	dd->ctx = ctx;
+
+	if (ctx->flags & FLAGS_NEW_KEY) {
+		/* copy the key */
+		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
+		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
+		aes_set_key(dd);
+		ctx->flags &= ~FLAGS_NEW_KEY;
+	}
+
+	if (((dd->flags & FLAGS_CBC) || (dd->flags & FLAGS_OFB)) && dd->iv) {
+		/* set iv to the aes hw slot
+		 * Hw generates updated iv only after iv is set in slot.
+		 * So key and iv is passed asynchronously.
+		 */
+		memcpy(dd->buf_in, dd->iv, dd->ivlen);
+
+		ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
+		  (u32)dd->dma_buf_out, 1, FLAGS_CBC, false);
+		if (ret < 0) {
+			dev_err(dd->dev, "aes_start_crypt fail(%d)\n", ret);
+			goto out;
+		}
+	}
+
+	while (total) {
+		dev_dbg(dd->dev, "remain: %d\n", total);
+		ret = dma_map_sg(dd->dev, in_sg, 1, DMA_TO_DEVICE);
+		if (!ret) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			goto out;
+		}
+
+		ret = dma_map_sg(dd->dev, out_sg, 1, DMA_FROM_DEVICE);
+		if (!ret) {
+			dev_err(dd->dev, "dma_map_sg() error\n");
+			dma_unmap_sg(dd->dev, dd->in_sg,
+				1, DMA_TO_DEVICE);
+			goto out;
+		}
+
+		addr_in = sg_dma_address(in_sg);
+		addr_out = sg_dma_address(out_sg);
+		dd->flags |= FLAGS_FAST;
+		count = min((int)sg_dma_len(in_sg), (int)dma_max);
+		WARN_ON(sg_dma_len(in_sg) != sg_dma_len(out_sg));
+		nblocks = DIV_ROUND_UP(count, AES_BLOCK_SIZE);
+
+		ret = aes_start_crypt(dd, addr_in, addr_out, nblocks,
+			dd->flags, true);
+
+		dma_unmap_sg(dd->dev, out_sg, 1, DMA_FROM_DEVICE);
+		dma_unmap_sg(dd->dev, in_sg, 1, DMA_TO_DEVICE);
+
+		if (ret < 0) {
+			dev_err(dd->dev, "aes_start_crypt fail(%d)\n", ret);
+			goto out;
+		}
+		dd->flags &= ~FLAGS_FAST;
+
+		dev_dbg(dd->dev, "out: copied %d\n", count);
+		total -= count;
+		in_sg = sg_next(in_sg);
+		out_sg = sg_next(out_sg);
+		WARN_ON(((total != 0) && (!in_sg || !out_sg)));
+	}
+
+out:
+	mutex_unlock(&aes_lock);
+
+	dd->total = total;
+
+	if (dd->req->base.complete)
+		dd->req->base.complete(&dd->req->base, ret);
+
+	dev_dbg(dd->dev, "%s: exit\n", __func__);
+	return ret;
+}
+
+static int tegra_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+	unsigned int keylen)
+{
+	struct tegra_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	struct tegra_aes_dev *dd = aes_dev;
+	struct tegra_aes_slot *key_slot;
+
+	if (!ctx || !dd) {
+		pr_err("ctx=0x%x, dd=0x%x\n",
+			(unsigned int)ctx, (unsigned int)dd);
+		return -EINVAL;
+	}
+
+	if ((keylen != AES_KEYSIZE_128) && (keylen != AES_KEYSIZE_192) &&
+		(keylen != AES_KEYSIZE_256)) {
+		dev_err(dd->dev, "unsupported key size\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dd->dev, "keylen: %d\n", keylen);
+
+	ctx->dd = dd;
+
+	if (key) {
+		if (!ctx->slot) {
+			key_slot = aes_find_key_slot(dd);
+			if (!key_slot) {
+				dev_err(dd->dev, "no empty slot\n");
+				return -ENOMEM;
+			}
+
+			ctx->slot = key_slot;
+		}
+
+		memcpy(ctx->key, key, keylen);
+		ctx->keylen = keylen;
+	}
+
+	ctx->flags |= FLAGS_NEW_KEY;
+	dev_dbg(dd->dev, "done\n");
+	return 0;
+}
+
+static void aes_workqueue_handler(struct work_struct *work)
+{
+	struct tegra_aes_dev *dd = aes_dev;
+	int ret;
+
+	clk_enable(dd->aes_clk);
+
+	/* empty the crypto queue and then return */
+	do {
+		ret = tegra_aes_handle_req(dd);
+	} while (!ret);
+
+	clk_disable(dd->aes_clk);
+}
+
+#define INT_ERROR_MASK 0xFFF000
+static irqreturn_t aes_irq(int irq, void *dev_id)
+{
+	struct tegra_aes_dev *dd = (struct tegra_aes_dev *)dev_id;
+	u32 value = aes_readl(dd, INTR_STATUS);
+
+	dev_dbg(dd->dev, "irq_stat: 0x%x", value);
+	if (value & INT_ERROR_MASK)
+		aes_writel(dd, intr_err_mask, INTR_STATUS);
+
+	value = aes_readl(dd, INTR_STATUS);
+	if (!(value & ENGINE_BUSY_FIELD))
+		complete(&dd->op_complete);
+
+done:
+	return IRQ_HANDLED;
+}
+
+static int tegra_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
+{
+	struct tegra_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct tegra_aes_dev *dd = aes_dev;
+	unsigned long flags;
+	int err = 0;
+	int busy;
+
+	dev_dbg(dd->dev, "nbytes: %d, enc: %d, cbc: %d, ofb: %d\n",
+		req->nbytes, !!(mode & FLAGS_ENCRYPT),
+		!!(mode & FLAGS_CBC), !!(mode & FLAGS_OFB));
+
+	rctx->mode = mode;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	err = ablkcipher_enqueue_request(&dd->queue, req);
+	busy = test_and_set_bit(FLAGS_BUSY, &dd->flags);
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	if (!busy)
+		queue_work(aes_wq, &aes_work);
+
+	return err;
+}
+
+static int tegra_aes_ecb_encrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, FLAGS_ENCRYPT);
+}
+
+static int tegra_aes_ecb_decrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, 0);
+}
+
+static int tegra_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, FLAGS_ENCRYPT | FLAGS_CBC);
+}
+
+static int tegra_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, FLAGS_CBC);
+}
+static int tegra_aes_ofb_encrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, FLAGS_ENCRYPT | FLAGS_OFB);
+}
+
+static int tegra_aes_ofb_decrypt(struct ablkcipher_request *req)
+{
+	return tegra_aes_crypt(req, FLAGS_OFB);
+}
+
+static int tegra_aes_get_random(struct crypto_rng *tfm, u8 *rdata,
+	unsigned int dlen)
+{
+	struct tegra_aes_dev *dd = aes_dev;
+	struct tegra_aes_ctx *ctx = &rng_ctx;
+	int ret, i;
+	u8 *dest = rdata, *dt = dd->dt;
+
+	/* take mutex to access the aes hw */
+	mutex_lock(&aes_lock);
+
+	clk_enable(dd->aes_clk);
+
+	ctx->dd = dd;
+	dd->ctx = ctx;
+	dd->flags = FLAGS_ENCRYPT | FLAGS_RNG;
+
+	memset(dd->buf_in, 0, AES_BLOCK_SIZE);
+	memcpy(dd->buf_in, dt, DEFAULT_RNG_BLK_SZ);
+
+	ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
+		(u32)dd->dma_buf_out, 1, dd->flags, true);
+	if (ret < 0) {
+		dev_err(dd->dev, "aes_start_crypt fail(%d)\n", ret);
+		dlen = ret;
+		goto out;
+	}
+	memcpy(dest, dd->buf_out, dlen);
+
+	/* update the DT */
+	for (i = DEFAULT_RNG_BLK_SZ - 1; i >= 0; i--) {
+		dt[i] += 1;
+		if (dt[i] != 0)
+			break;
+	}
+
+out:
+	clk_disable(dd->aes_clk);
+	mutex_unlock(&aes_lock);
+
+	dev_dbg(dd->dev, "%s: done\n", __func__);
+	return dlen;
+}
+
+static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
+	unsigned int slen)
+{
+	struct tegra_aes_dev *dd = aes_dev;
+	struct tegra_aes_ctx *ctx = &rng_ctx;
+	struct tegra_aes_slot *key_slot;
+	struct timespec ts;
+	int ret = 0;
+	u64 nsec, tmp[2];
+	u8 *dt;
+
+	if (!ctx || !dd) {
+		dev_err(dd->dev, "ctx=0x%x, dd=0x%x\n",
+			(unsigned int)ctx, (unsigned int)dd);
+		return -EINVAL;
+	}
+
+	if (slen < (DEFAULT_RNG_BLK_SZ + AES_KEYSIZE_128)) {
+		dev_err(dd->dev, "seed size invalid");
+		return -ENOMEM;
+	}
+
+	/* take mutex to access the aes hw */
+	mutex_lock(&aes_lock);
+
+	if (!ctx->slot) {
+		key_slot = aes_find_key_slot(dd);
+		if (!key_slot) {
+			dev_err(dd->dev, "no empty slot\n");
+			mutex_unlock(&aes_lock);
+			return -ENOMEM;
+		}
+		ctx->slot = key_slot;
+	}
+
+	ctx->dd = dd;
+	dd->ctx = ctx;
+	dd->ctr = 0;
+
+	ctx->keylen = AES_KEYSIZE_128;
+	ctx->flags |= FLAGS_NEW_KEY;
+
+	/* copy the key to the key slot */
+	memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
+	memcpy(dd->ivkey_base, seed + DEFAULT_RNG_BLK_SZ, AES_KEYSIZE_128);
+
+	dd->iv = seed;
+	dd->ivlen = slen;
+
+	dd->flags = FLAGS_ENCRYPT | FLAGS_RNG;
+
+	clk_enable(dd->aes_clk);
+
+	aes_set_key(dd);
+
+	/* set seed to the aes hw slot */
+	memset(dd->buf_in, 0, AES_BLOCK_SIZE);
+	memcpy(dd->buf_in, dd->iv, DEFAULT_RNG_BLK_SZ);
+	ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
+	  (u32)dd->dma_buf_out, 1, FLAGS_CBC, false);
+	if (ret < 0) {
+		dev_err(dd->dev, "aes_start_crypt fail(%d)\n", ret);
+		goto out;
+	}
+
+	if (dd->ivlen >= (2 * DEFAULT_RNG_BLK_SZ + AES_KEYSIZE_128)) {
+		dt = dd->iv + DEFAULT_RNG_BLK_SZ + AES_KEYSIZE_128;
+	} else {
+		getnstimeofday(&ts);
+		nsec = timespec_to_ns(&ts);
+		do_div(nsec, 1000);
+		nsec ^= dd->ctr << 56;
+		dd->ctr++;
+		tmp[0] = nsec;
+		tmp[1] = tegra_chip_uid();
+		dt = (u8 *)tmp;
+	}
+	memcpy(dd->dt, dt, DEFAULT_RNG_BLK_SZ);
+
+out:
+	clk_disable(dd->aes_clk);
+	mutex_unlock(&aes_lock);
+
+	dev_dbg(dd->dev, "%s: done\n", __func__);
+	return ret;
+}
+
+static int tegra_aes_cra_init(struct crypto_tfm *tfm)
+{
+	tfm->crt_ablkcipher.reqsize = sizeof(struct tegra_aes_reqctx);
+
+	return 0;
+}
+
+void tegra_aes_cra_exit(struct crypto_tfm *tfm)
+{
+	struct tegra_aes_ctx *ctx = crypto_ablkcipher_ctx((struct crypto_ablkcipher *)tfm);
+
+	if (ctx && ctx->slot)
+		aes_release_key_slot(ctx);
+}
+
+static struct crypto_alg algs[] = {
+	{
+		.cra_name = "ecb(aes)",
+		.cra_driver_name = "ecb-aes-tegra",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize = sizeof(struct tegra_aes_ctx),
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_module = THIS_MODULE,
+		.cra_init = tegra_aes_cra_init,
+		.cra_exit = tegra_aes_cra_exit,
+		.cra_u.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = tegra_aes_setkey,
+			.encrypt = tegra_aes_ecb_encrypt,
+			.decrypt = tegra_aes_ecb_decrypt,
+		},
+	}, {
+		.cra_name = "cbc(aes)",
+		.cra_driver_name = "cbc-aes-tegra",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize  = sizeof(struct tegra_aes_ctx),
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_module = THIS_MODULE,
+		.cra_init = tegra_aes_cra_init,
+		.cra_exit = tegra_aes_cra_exit,
+		.cra_u.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_MIN_KEY_SIZE,
+			.setkey = tegra_aes_setkey,
+			.encrypt = tegra_aes_cbc_encrypt,
+			.decrypt = tegra_aes_cbc_decrypt,
+		}
+	}, {
+		.cra_name = "ofb(aes)",
+		.cra_driver_name = "ofb-aes-tegra",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize  = sizeof(struct tegra_aes_ctx),
+		.cra_alignmask = 3,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_module = THIS_MODULE,
+		.cra_init = tegra_aes_cra_init,
+		.cra_exit = tegra_aes_cra_exit,
+		.cra_u.ablkcipher = {
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_MIN_KEY_SIZE,
+			.setkey = tegra_aes_setkey,
+			.encrypt = tegra_aes_ofb_encrypt,
+			.decrypt = tegra_aes_ofb_decrypt,
+		}
+	}, {
+		.cra_name = "ansi_cprng",
+		.cra_driver_name = "rng-aes-tegra",
+		.cra_priority = 300,
+		.cra_flags = CRYPTO_ALG_TYPE_RNG,
+		.cra_ctxsize = sizeof(struct tegra_aes_ctx),
+		.cra_type = &crypto_rng_type,
+		.cra_module = THIS_MODULE,
+		.cra_init = tegra_aes_cra_init,
+		.cra_exit = tegra_aes_cra_exit,
+		.cra_u.rng = {
+			.rng_make_random = tegra_aes_get_random,
+			.rng_reset = tegra_aes_rng_reset,
+			.seedsize = AES_KEYSIZE_128 + (2 * DEFAULT_RNG_BLK_SZ),
+		}
+	}
+};
+
+static int tegra_aes_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_aes_dev *dd;
+	struct resource *res;
+	int err = -ENOMEM, i = 0, j;
+
+	if (aes_dev)
+		return -EEXIST;
+
+	dd = kzalloc(sizeof(struct tegra_aes_dev), GFP_KERNEL);
+	if (dd == NULL) {
+		dev_err(dev, "unable to alloc data struct.\n");
+		return -ENOMEM;;
+	}
+
+	dd->dev = dev;
+	platform_set_drvdata(pdev, dd);
+
+	dd->slots = kzalloc(sizeof(struct tegra_aes_slot) * AES_NR_KEYSLOTS,
+		GFP_KERNEL);
+	if (dd->slots == NULL) {
+		dev_err(dev, "unable to alloc slot struct.\n");
+		goto out;
+	}
+
+	spin_lock_init(&dd->lock);
+	crypto_init_queue(&dd->queue, TEGRA_AES_QUEUE_LENGTH);
+
+	/* Get the module base address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "invalid resource type: base\n");
+		err = -ENODEV;
+		goto out;
+	}
+	dd->phys_base = res->start;
+
+	dd->io_base = ioremap(dd->phys_base, resource_size(res));
+	if (!dd->io_base) {
+		dev_err(dev, "can't ioremap phys_base\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Initialize the vde clock */
+	dd->aes_clk = clk_get(dev, "vde");
+	if (IS_ERR(dd->aes_clk)) {
+		dev_err(dev, "iclock intialization failed.\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	err = clk_set_rate(dd->aes_clk, ULONG_MAX);
+	if (err) {
+		dev_err(dd->dev, "iclk set_rate fail(%d)\n", err);
+		goto out;
+	}
+
+	/*
+	 * the foll contiguous memory is allocated as follows -
+	 * - hardware key table
+	 * - key schedule
+	 */
+	dd->ivkey_base = dma_alloc_coherent(dev, SZ_512, &dd->ivkey_phys_base,
+		GFP_KERNEL);
+	if (!dd->ivkey_base) {
+		dev_err(dev, "can not allocate iv/key buffer\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	dd->buf_in = dma_alloc_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+		&dd->dma_buf_in, GFP_KERNEL);
+	if (!dd->buf_in) {
+		dev_err(dev, "can not allocate dma-in buffer\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	dd->buf_out = dma_alloc_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+		&dd->dma_buf_out, GFP_KERNEL);
+	if (!dd->buf_out) {
+		dev_err(dev, "can not allocate dma-out buffer\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	init_completion(&dd->op_complete);
+	aes_wq = alloc_workqueue("tegra_aes_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);
+	if (!aes_wq) {
+		dev_err(dev, "alloc_workqueue failed\n");
+		goto out;
+	}
+
+	/* get the irq */
+	err = request_irq(INT_VDE_BSE_V, aes_irq, IRQF_TRIGGER_HIGH,
+		"tegra-aes", dd);
+	if (err) {
+		dev_err(dev, "request_irq failed\n");
+		goto out;
+	}
+
+	disable_irq(INT_VDE_BSE_V);
+
+	spin_lock_init(&list_lock);
+	spin_lock(&list_lock);
+	for (i = 0; i < AES_NR_KEYSLOTS; i++) {
+		if (i == SSK_SLOT_NUM)
+			continue;
+		dd->slots[i].available = true;
+		dd->slots[i].slot_num = i;
+		INIT_LIST_HEAD(&dd->slots[i].node);
+		list_add_tail(&dd->slots[i].node, &dev_list);
+	}
+	spin_unlock(&list_lock);
+
+	aes_dev = dd;
+	for (i = 0; i < ARRAY_SIZE(algs); i++) {
+		INIT_LIST_HEAD(&algs[i].cra_list);
+		err = crypto_register_alg(&algs[i]);
+		if (err)
+			goto out;
+	}
+
+	dev_info(dev, "registered");
+	return 0;
+
+out:
+	for (j = 0; j < i; j++)
+		crypto_unregister_alg(&algs[j]);
+	if (dd->ivkey_base)
+		dma_free_coherent(dev, SZ_512, dd->ivkey_base,
+			dd->ivkey_phys_base);
+	if (dd->buf_in)
+		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+			dd->buf_in, dd->dma_buf_in);
+	if (dd->buf_out)
+		dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+			dd->buf_out, dd->dma_buf_out);
+	if (dd->io_base)
+		iounmap(dd->io_base);
+	if (dd->aes_clk)
+		clk_put(dd->aes_clk);
+	if (aes_wq)
+		destroy_workqueue(aes_wq);
+	free_irq(INT_VDE_BSE_V, dd);
+	spin_lock(&list_lock);
+	list_del(&dev_list);
+	spin_unlock(&list_lock);
+
+	kfree(dd->slots);
+	kfree(dd);
+	aes_dev = NULL;
+	dev_err(dev, "%s: initialization failed.\n", __func__);
+	return err;
+}
+
+static int __devexit tegra_aes_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct tegra_aes_dev *dd = platform_get_drvdata(pdev);
+	int i;
+
+	if (!dd)
+		return -ENODEV;
+
+	cancel_work_sync(&aes_work);
+	destroy_workqueue(aes_wq);
+	free_irq(INT_VDE_BSE_V, dd);
+	spin_lock(&list_lock);
+	list_del(&dev_list);
+	spin_unlock(&list_lock);
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++)
+		crypto_unregister_alg(&algs[i]);
+
+	dma_free_coherent(dev, SZ_512, dd->ivkey_base,
+		dd->ivkey_phys_base);
+	dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+		dd->buf_in, dd->dma_buf_in);
+	dma_free_coherent(dev, AES_HW_DMA_BUFFER_SIZE_BYTES,
+		dd->buf_out, dd->dma_buf_out);
+	iounmap(dd->io_base);
+	clk_put(dd->aes_clk);
+	kfree(dd->slots);
+	kfree(dd);
+	aes_dev = NULL;
+
+	return 0;
+}
+
+static struct platform_driver tegra_aes_driver = {
+	.probe  = tegra_aes_probe,
+	.remove = __devexit_p(tegra_aes_remove),
+	.driver = {
+		.name   = "tegra-aes",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int __init tegra_aes_module_init(void)
+{
+	mutex_init(&aes_lock);
+	INIT_LIST_HEAD(&dev_list);
+	return  platform_driver_register(&tegra_aes_driver);
+}
+
+static void __exit tegra_aes_module_exit(void)
+{
+	platform_driver_unregister(&tegra_aes_driver);
+}
+
+module_init(tegra_aes_module_init);
+module_exit(tegra_aes_module_exit);
+
+MODULE_DESCRIPTION("Tegra AES/OFB/CPRNG hw acceleration support.");
+MODULE_AUTHOR("NVIDIA Corporation");
+MODULE_LICENSE("GPLv2");
diff --git a/drivers/crypto/tegra-aes.h b/drivers/crypto/tegra-aes.h
new file mode 100644
index 0000000..909474c
--- /dev/null
+++ b/drivers/crypto/tegra-aes.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2010, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __CRYPTODEV_TEGRA_AES_H
+#define __CRYPTODEV_TEGRA_AES_H
+
+#define ICMDQUE_WR		0x1000
+#define CMDQUE_CONTROL		0x1008
+#define INTR_STATUS		0x1018
+#define INT_ENB			0x1040
+#define CONFIG			0x1044
+#define IRAM_ACCESS_CFG		0x10A0
+#define SECURE_DEST_ADDR	0x1100
+#define SECURE_INPUT_SELECT	0x1104
+#define SECURE_CONFIG		0x1108
+#define SECURE_CONFIG_EXT	0x110C
+#define SECURE_SECURITY		0x1110
+#define SECURE_HASH_RESULT0	0x1120
+#define SECURE_HASH_RESULT1	0x1124
+#define SECURE_HASH_RESULT2	0x1128
+#define SECURE_HASH_RESULT3	0x112C
+#define SECURE_SEC_SEL0		0x1140
+#define SECURE_SEC_SEL1		0x1144
+#define SECURE_SEC_SEL2		0x1148
+#define SECURE_SEC_SEL3		0x114C
+#define SECURE_SEC_SEL4		0x1150
+#define SECURE_SEC_SEL5		0x1154
+#define SECURE_SEC_SEL6		0x1158
+#define SECURE_SEC_SEL7		0x115C
+
+/* interrupt status reg masks and shifts */
+#define DMA_BUSY_SHIFT		(9)
+#define DMA_BUSY_FIELD	(0x1 << DMA_BUSY_SHIFT)
+#define ICQ_EMPTY_SHIFT		(3)
+#define ICQ_EMPTY_FIELD	(0x1 << ICQ_EMPTY_SHIFT)
+#define ENGINE_BUSY_SHIFT	(0)
+#define ENGINE_BUSY_FIELD	(0x1 << ENGINE_BUSY_SHIFT)
+
+/* secure select reg masks and shifts */
+#define SECURE_SEL0_KEYREAD_ENB0_SHIFT	(0)
+#define SECURE_SEL0_KEYREAD_ENB0_FIELD	(0x1 << SECURE_SEL0_KEYREAD_ENB0_SHIFT)
+
+/* secure config ext masks and shifts */
+#define SECURE_KEY_SCH_DIS_SHIFT	(15)
+#define SECURE_KEY_SCH_DIS_FIELD	(0x1 << SECURE_KEY_SCH_DIS_SHIFT)
+
+/* secure config masks and shifts */
+#define SECURE_KEY_INDEX_SHIFT		(20)
+#define SECURE_KEY_INDEX_FIELD		(0x1F << SECURE_KEY_INDEX_SHIFT)
+#define SECURE_BLOCK_CNT_SHIFT		(0)
+#define SECURE_BLOCK_CNT_FIELD		(0xFFFFF << SECURE_BLOCK_CNT_SHIFT)
+
+/* stream interface select masks and shifts */
+#define CMDQ_CTRL_SRC_STM_SEL_SHIFT	(4)
+#define CMDQ_CTRL_SRC_STM_SEL_FIELD	(1 << CMDQ_CTRL_SRC_STM_SEL_SHIFT)
+#define CMDQ_CTRL_DST_STM_SEL_SHIFT	(5)
+#define CMDQ_CTRL_DST_STM_SEL_FIELD	(1 << CMDQ_CTRL_DST_STM_SEL_SHIFT)
+#define CMDQ_CTRL_ICMDQEN_SHIFT		(1)
+#define CMDQ_CTRL_ICMDQEN_FIELD		(1 << CMDQ_CTRL_ICMDQEN_SHIFT)
+#define CMDQ_CTRL_UCMDQEN_SHIFT		(0)
+#define CMDQ_CTRL_UCMDQEN_FIELD		(1 << CMDQ_CTRL_UCMDQEN_SHIFT)
+
+/* config regsiter masks and shifts */
+#define CONFIG_ENDIAN_ENB_SHIFT		(10)
+#define CONFIG_ENDIAN_ENB_FIELD		(0x1 << CONFIG_ENDIAN_ENB_SHIFT)
+#define CONFIG_MODE_SEL_SHIFT		(0)
+#define CONFIG_MODE_SEL_FIELD		(0x1F << CONFIG_MODE_SEL_SHIFT)
+
+/* extended config */
+#define SECURE_OFFSET_CNT_SHIFT		(24)
+#define SECURE_OFFSET_CNT_FIELD		(0xFF << SECURE_OFFSET_CNT_SHIFT)
+#define SECURE_KEYSCHED_GEN_SHIFT	(15)
+#define SECURE_KEYSCHED_GEN_FIELD	(1 << SECURE_KEYSCHED_GEN_SHIFT)
+
+/* init vector select */
+#define SECURE_IV_SELECT_SHIFT		(10)
+#define SECURE_IV_SELECT_FIELD		(1 << SECURE_IV_SELECT_SHIFT)
+
+/* secure engine input */
+#define SECURE_INPUT_ALG_SEL_SHIFT	(28)
+#define SECURE_INPUT_ALG_SEL_FIELD	(0xF << SECURE_INPUT_ALG_SEL_SHIFT)
+#define SECURE_INPUT_KEY_LEN_SHIFT	(16)
+#define SECURE_INPUT_KEY_LEN_FIELD	(0xFFF << SECURE_INPUT_KEY_LEN_SHIFT)
+#define SECURE_RNG_ENB_SHIFT		(11)
+#define SECURE_RNG_ENB_FIELD		(0x1 << SECURE_RNG_ENB_SHIFT)
+#define SECURE_CORE_SEL_SHIFT		(9)
+#define SECURE_CORE_SEL_FIELD		(0x1 << SECURE_CORE_SEL_SHIFT)
+#define SECURE_VCTRAM_SEL_SHIFT		(7)
+#define SECURE_VCTRAM_SEL_FIELD		(0x3 << SECURE_VCTRAM_SEL_SHIFT)
+#define SECURE_INPUT_SEL_SHIFT		(5)
+#define SECURE_INPUT_SEL_FIELD		(0x3 << SECURE_INPUT_SEL_SHIFT)
+#define SECURE_XOR_POS_SHIFT		(3)
+#define SECURE_XOR_POS_FIELD		(0x3 << SECURE_XOR_POS_SHIFT)
+#define SECURE_HASH_ENB_SHIFT		(2)
+#define SECURE_HASH_ENB_FIELD		(0x1 << SECURE_HASH_ENB_SHIFT)
+#define SECURE_ON_THE_FLY_SHIFT		(0)
+#define SECURE_ON_THE_FLY_FIELD		(1 << SECURE_ON_THE_FLY_SHIFT)
+
+#endif
-- 
1.7.1
