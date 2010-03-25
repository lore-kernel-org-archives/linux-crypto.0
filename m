From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 2/2] crypto: omap-sham - omap sha1 & md5 driver
Date: Thu, 25 Mar 2010 16:00:23 +0200
Message-ID: <ed5aa0f98c578e289f637e563bdbd4d6c39bc245.1269524804.git.dmitry.kasatkin@nokia.com>
References: <cover.1269524804.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: tony@atomide.com, herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1269524804.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1269524804.git.dmitry.kasatkin@nokia.com>
References: <cover.1269524804.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
was not ported to new crypto APIs and removed from the source tree.

- implements async and sync crypto API using dma and cpu.
- supports multiple sham instances if available

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/Kconfig     |    9 +
 drivers/crypto/Makefile    |    2 +
 drivers/crypto/omap-sham.c | 1358 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1369 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/omap-sham.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b08403d..9073aa0 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -222,4 +222,13 @@ config CRYPTO_DEV_PPC4XX
 	help
 	  This option allows you to have support for AMCC crypto acceleration.
 
+config CRYPTO_DEV_OMAP_SHAM
+	tristate "Support for OMAP SHA1/MD5 hw accelerator"
+	depends on ARCH_OMAP2 || ARCH_OMAP3
+	select CRYPTO_SHA1
+	select CRYPTO_MD5
+	help
+	  OMAP processors have SHA1/MD5 hw accelerator. Select this if you
+	  want to use the OMAP module for SHA1/MD5 algorithms.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6ffcb3f..c9494e1 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -6,3 +6,5 @@ obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
+obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
+
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
new file mode 100644
index 0000000..aed323e
--- /dev/null
+++ b/drivers/crypto/omap-sham.c
@@ -0,0 +1,1358 @@
+/*
+ * Cryptographic API.
+ *
+ * Support for OMAP SHA1/MD5 HW acceleration.
+ *
+ * Copyright (c) 2007 Instituto Nokia de Tecnologia - INdT
+ * Authors: David Cohen <david.cohen@indt.org.br>
+ *          Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This driver is based on padlock-sha.c driver.
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/version.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/cryptohash.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/crypto.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/algapi.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+
+#include <plat/cpu.h>
+#include <plat/dma.h>
+#include <mach/irqs.h>
+#include <mach/io.h>
+
+#define SHA_REG_DIGEST(x)		(0x00 + ((x) * 0x04))
+#define SHA_REG_DIN(x)			(0x1C + ((x) * 0x04))
+
+#define SHA1_MD5_BLOCK_SIZE		SHA1_BLOCK_SIZE
+#define MD5_DIGEST_SIZE			16
+
+#define SHA_REG_DIGCNT			0x14
+
+#define SHA_REG_CTRL			0x18
+#define SHA_REG_CTRL_LENGTH		(0xFFFFFFFF << 5)
+#define SHA_REG_CTRL_CLOSE_HASH		(1 << 4)
+#define SHA_REG_CTRL_ALGO_CONST		(1 << 3)
+#define SHA_REG_CTRL_ALGO		(1 << 2)
+#define SHA_REG_CTRL_INPUT_READY	(1 << 1)
+#define SHA_REG_CTRL_OUTPUT_READY	(1 << 0)
+
+#define SHA_REG_REV			0x5C
+#define SHA_REG_REV_MAJOR		0xF0
+#define SHA_REG_REV_MINOR		0x0F
+
+#define SHA_REG_MASK			0x60
+#define SHA_REG_MASK_DMA_EN		(1 << 3)
+#define SHA_REG_MASK_IT_EN		(1 << 2)
+#define SHA_REG_MASK_SOFTRESET		(1 << 1)
+#define SHA_REG_AUTOIDLE		(1 << 0)
+
+#define SHA_REG_SYSSTATUS		0x64
+#define SHA_REG_SYSSTATUS_RESETDONE	(1 << 0)
+
+#define DEFAULT_TIMEOUT_INTERVAL	HZ
+
+struct omap_sham_desc {
+	/* should be last one to have desc area for fallback*/
+	struct shash_desc	fallback;
+};
+
+#define FLAGS_UPDATE		0x0001
+#define FLAGS_FINUP		0x0002
+#define FLAGS_FINAL		0x0004
+#define FLAGS_MAY_SLEEP		0x0008
+#define FLAGS_BYPASS_INIT	0x0010
+#define FLAGS_BYPASS		0x0030 /* it's a mask */
+#define FLAGS_FAST		0x0040
+#define FLAGS_SHA1		0x0080
+#define FLAGS_INPROGRESS	0x0100
+#define FLAGS_DMA_ACTIVE	0x0200
+#define FLAGS_READY		0x0400
+#define FLAGS_CLEAN		0x0800
+#define FLAGS_DMA		0x1000
+
+struct omap_sham_dev;
+
+struct omap_sham_ctx {
+	struct omap_sham_dev *dd;
+	unsigned long	flags;
+	int		digsize;
+	size_t		bufcnt;
+	size_t		digcnt;
+	size_t		dma_size;
+	u8		*buffer;
+	size_t		buffer_size;
+
+	/* shash stuff */
+	struct crypto_shash	*shash_fb;
+
+	/* ahash stuff */
+	struct crypto_ahash	*ahash_fb;
+	struct ahash_request	*req;
+
+	/* ahash walk state */
+	struct scatterlist *sg;
+	unsigned int	offset;	/* offset in current sg */
+	unsigned int	length;	/* length left in current sg */
+	unsigned int	total;	/* total request */
+};
+
+struct omap_sham_dev {
+	struct list_head		list;
+	unsigned long			phys_base;
+	struct device			*dev;
+	void __iomem			*io_base;
+	int				irq;
+	struct clk			*iclk;
+	struct omap_sham_ctx	*hw_ctx;
+	wait_queue_head_t		wq;
+	spinlock_t			lock;
+	int				dma;
+	dma_addr_t			dma_addr;
+	dma_addr_t			buffer_addr;
+	int				dma_lch;
+	struct completion		dma_wait;
+	struct tasklet_struct		done_task;
+};
+
+/* keep registered devices data here */
+static LIST_HEAD(dev_list);
+static DEFINE_SPINLOCK(list_lock);
+
+static int omap_sham_update_dma_slow(struct omap_sham_ctx *ctx);
+static int omap_sham_update_dma_stop(struct omap_sham_ctx *ctx);
+static void omap_sham_hw_cleanup(struct omap_sham_ctx *ctx, u8 *out);
+
+static inline u32 omap_sham_read(struct omap_sham_dev *dd, u32 offset)
+{
+	return __raw_readl(dd->io_base + offset);
+}
+
+static inline void omap_sham_write(struct omap_sham_dev *dd,
+					u32 offset, u32 value)
+{
+	__raw_writel(value, dd->io_base + offset);
+}
+
+static void omap_sham_write_mask(struct omap_sham_dev *dd, u32 address,
+					u32 value, u32 mask)
+{
+	u32 val;
+
+	val = omap_sham_read(dd, address);
+	val &= ~mask;
+	val |= value;
+	omap_sham_write(dd, address, val);
+}
+
+static int omap_sham_wait(struct omap_sham_dev *dd, u32 offset, u32 bit)
+{
+	unsigned long timeout = jiffies + DEFAULT_TIMEOUT_INTERVAL;
+
+	while (!(omap_sham_read(dd, offset) & bit)) {
+		if (time_is_before_jiffies(timeout))
+			return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void omap_sham_copy_hash(struct omap_sham_ctx *ctx, u32 *hash)
+{
+	int i;
+
+	if (ctx->flags & FLAGS_SHA1) {
+		/* SHA1 results are in big endian */
+		for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++)
+			hash[i] = be32_to_cpu(
+				omap_sham_read(ctx->dd, SHA_REG_DIGEST(i)));
+	} else {
+		/* MD5 results are in little endian */
+		for (i = 0; i < MD5_DIGEST_SIZE / sizeof(u32); i++)
+			hash[i] = le32_to_cpu(
+				omap_sham_read(ctx->dd, SHA_REG_DIGEST(i)));
+	}
+}
+
+static int omap_sham_wait_for_output_ready(struct omap_sham_ctx *ctx)
+{
+	int err;
+
+	if (ctx->flags & FLAGS_READY)
+		return 0;
+
+	if (ctx->flags & FLAGS_DMA) {
+		unsigned long timeout;
+		if (!(ctx->flags & FLAGS_MAY_SLEEP))
+			return -EINPROGRESS;
+		timeout = wait_event_interruptible_timeout(ctx->dd->wq,
+				(ctx->flags & FLAGS_READY),
+				DEFAULT_TIMEOUT_INTERVAL);
+		err = timeout > 0 ? 0 : -ETIMEDOUT;
+	} else {
+		err = omap_sham_wait(ctx->dd, SHA_REG_CTRL,
+					  SHA_REG_CTRL_OUTPUT_READY);
+	}
+	dev_dbg(ctx->dd->dev, "wait: output_ready: %d\n",
+		(omap_sham_read(ctx->dd, SHA_REG_CTRL) &
+				SHA_REG_CTRL_OUTPUT_READY) != 0);
+
+	return err;
+}
+
+static irqreturn_t omap_sham_irq(int irq, void *dev_id)
+{
+	struct omap_sham_dev *dd = dev_id;
+	struct omap_sham_ctx *ctx = dd->hw_ctx;
+
+	dev_dbg(dd->dev, "irq: output_ready: %d\n",
+		(omap_sham_read(dd, SHA_REG_CTRL) &
+			SHA_REG_CTRL_OUTPUT_READY) != 0);
+
+	if (!ctx) {
+		dev_err(dd->dev, "unknown interrupt.\n");
+		return IRQ_HANDLED;
+	}
+
+	if (unlikely(ctx->flags & FLAGS_FINAL))
+		/* final -> allow device to go to power-saving mode */
+		omap_sham_write_mask(dd, SHA_REG_CTRL, 0,
+					 SHA_REG_CTRL_LENGTH);
+
+	omap_sham_write_mask(dd, SHA_REG_CTRL, SHA_REG_CTRL_OUTPUT_READY,
+				 SHA_REG_CTRL_OUTPUT_READY);
+
+	if (likely(!(ctx->flags & FLAGS_FINAL)))
+		return IRQ_HANDLED;
+
+	ctx->flags |= FLAGS_READY;
+
+	dev_dbg(dd->dev, "irq: digest ready\n");
+
+	/* hash is done */
+	if (ctx->flags & FLAGS_MAY_SLEEP)
+		wake_up_interruptible(&dd->wq);
+	else
+		tasklet_schedule(&dd->done_task);
+
+	return IRQ_HANDLED;
+}
+
+static int omap_sham_wait_for_dma(struct omap_sham_ctx *ctx)
+{
+	int err = 0;
+
+	if ((ctx->flags & FLAGS_INPROGRESS) && !(ctx->flags & FLAGS_FINUP)) {
+		unsigned long timeout;
+		if (!(ctx->flags & FLAGS_MAY_SLEEP))
+			return -EINPROGRESS;
+		dev_dbg(ctx->dd->dev, "do wait\n");
+		timeout = wait_for_completion_timeout(&ctx->dd->dma_wait,
+			DEFAULT_TIMEOUT_INTERVAL);
+		err = timeout > 0 ? 0 : -ETIMEDOUT;
+	}
+
+	return err;
+}
+
+static void omap_sham_done(unsigned long data)
+{
+	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
+	struct omap_sham_ctx *ctx = dd->hw_ctx;
+
+	if (ctx->flags & FLAGS_FINAL)
+		omap_sham_hw_cleanup(ctx, ctx->req->result);
+
+	if (ctx->req && ctx->req->base.complete)
+		ctx->req->base.complete(&ctx->req->base, 0);
+
+}
+
+static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
+{
+	struct omap_sham_dev *dd = data;
+	struct omap_sham_ctx *ctx = dd->hw_ctx;
+
+	ctx->flags &= ~FLAGS_DMA_ACTIVE;
+
+	omap_sham_update_dma_stop(ctx);
+	omap_sham_update_dma_slow(ctx);
+
+	if (!(ctx->flags & FLAGS_DMA_ACTIVE)) {
+		ctx->flags &= ~FLAGS_INPROGRESS;
+		if (!(ctx->flags & FLAGS_FINAL)) {
+			/* irq handler will complete the the hash */
+			if (ctx->flags & FLAGS_MAY_SLEEP)
+				complete(&dd->dma_wait);
+			else
+				tasklet_schedule(&dd->done_task);
+		}
+	}
+
+}
+
+static int omap_sham_hw_init(struct omap_sham_ctx *ctx, int use_dma)
+{
+	struct omap_sham_dev *dd = ctx->dd;
+	int err;
+
+	/* in the case of error clk_disable() is in final() */
+	clk_enable(dd->iclk);
+
+	if (use_dma) {
+		err = omap_request_dma(dd->dma, dev_name(dd->dev),
+				omap_sham_dma_callback, dd, &dd->dma_lch);
+		if (err) {
+			dev_err(dd->dev, "Unable to request DMA channel\n");
+			return err;
+		}
+		omap_set_dma_dest_params(dd->dma_lch, 0,
+				OMAP_DMA_AMODE_CONSTANT,
+				dd->phys_base + SHA_REG_DIN(0), 0, 16);
+
+		omap_set_dma_dest_burst_mode(dd->dma_lch,
+				OMAP_DMA_DATA_BURST_16);
+
+		ctx->flags |= FLAGS_DMA;
+	}
+
+	omap_sham_write_mask(dd, SHA_REG_MASK, SHA_REG_MASK_SOFTRESET,
+				 SHA_REG_MASK_SOFTRESET);
+
+	if (omap_sham_wait(dd, SHA_REG_SYSSTATUS,
+					SHA_REG_SYSSTATUS_RESETDONE))
+		return -ETIMEDOUT;
+
+	/* we use irq handler with dma */
+	omap_sham_write_mask(dd, SHA_REG_MASK,
+			(dd->dma_lch >= 0 ? SHA_REG_MASK_IT_EN  : 0) |
+			(dd->dma_lch >= 0 ? SHA_REG_MASK_DMA_EN : 0),
+		SHA_REG_MASK_DMA_EN | SHA_REG_MASK_IT_EN);
+
+	return 0;
+}
+
+static void omap_sham_write_ctrl(struct omap_sham_ctx *ctx, size_t length,
+				 int final)
+{
+	u32 val = length << 5, mask;
+
+	/*
+	 * Setting ALGO_CONST only for the first iteration
+	 * and CLOSE_HASH only for the last one.
+	 */
+
+	if (ctx->flags & FLAGS_SHA1)
+		val |= SHA_REG_CTRL_ALGO;
+	if (!ctx->digcnt)
+		val |= SHA_REG_CTRL_ALGO_CONST;
+	if (final)
+		val |= SHA_REG_CTRL_CLOSE_HASH;
+
+	mask = SHA_REG_CTRL_ALGO_CONST | SHA_REG_CTRL_CLOSE_HASH |
+			SHA_REG_CTRL_ALGO | SHA_REG_CTRL_LENGTH;
+
+	omap_sham_write_mask(ctx->dd, SHA_REG_CTRL, val, mask);
+}
+
+static int omap_sham_xmit_cpu(struct omap_sham_ctx *ctx, const u8 *buf,
+			      size_t length, int final)
+{
+	struct omap_sham_dev *dd = ctx->dd;
+	int err, count, len32;
+	const u32 *buffer = (const u32 *)buf;
+
+	/*
+	 * enable it if every update info is needed
+	 * dev_dbg(dd->dev, "xmit_cpu: digcnt: %d, length: %d, final: %d\n",
+	 *			ctx->digcnt, length, final);
+	 */
+
+	if (likely(ctx->digcnt)) {
+		omap_sham_write(dd, SHA_REG_DIGCNT, ctx->digcnt);
+	} else {
+		err = omap_sham_hw_init(ctx, 0);
+		if (err)
+			return err;
+	}
+
+	omap_sham_write_ctrl(ctx, length, final);
+
+	ctx->digcnt += length;
+	if (omap_sham_wait(dd, SHA_REG_CTRL, SHA_REG_CTRL_INPUT_READY))
+		return -ETIMEDOUT;
+
+	if (final)
+		ctx->flags |= FLAGS_FINAL; /* catch last interrupt */
+
+	len32 = DIV_ROUND_UP(length, sizeof(u32));
+
+	for (count = 0; count < len32; count++)
+		omap_sham_write(dd, SHA_REG_DIN(count), buffer[count]);
+
+	return 0;
+}
+
+static int omap_sham_xmit_dma(struct omap_sham_ctx *ctx, dma_addr_t dma_addr,
+			      size_t length, int final)
+{
+	struct omap_sham_dev *dd = ctx->dd;
+	int err, len32;
+
+	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
+				ctx->digcnt, length, final);
+
+	if (likely(ctx->digcnt)) {
+		omap_sham_write(dd, SHA_REG_DIGCNT, ctx->digcnt);
+	} else {
+		err = omap_sham_hw_init(ctx, 1);
+		if (err)
+			return err;
+	}
+
+	/* flush cache entries related to our page */
+	if (dma_addr == dd->buffer_addr)
+		dma_sync_single_for_device(dd->dev, dma_addr, length,
+					   DMA_TO_DEVICE);
+
+	len32 = DIV_ROUND_UP(length, sizeof(u32));
+
+	omap_set_dma_transfer_params(dd->dma_lch, OMAP_DMA_DATA_TYPE_S32, len32,
+			1, OMAP_DMA_SYNC_PACKET, dd->dma, OMAP_DMA_DST_SYNC);
+
+	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
+				dma_addr, 0, 0);
+
+	omap_sham_write_ctrl(ctx, length, final);
+
+	ctx->digcnt += length;
+
+	if (final)
+		ctx->flags |= FLAGS_FINAL; /* catch last interrupt */
+
+	ctx->flags |= FLAGS_INPROGRESS | FLAGS_DMA_ACTIVE;
+
+	omap_start_dma(dd->dma_lch);
+
+	return 0;
+}
+
+static void omap_sham_append_cpu(struct omap_sham_ctx *ctx, const u8 *data,
+				 size_t length)
+{
+	memcpy(&ctx->buffer[ctx->bufcnt], data, length);
+	ctx->bufcnt += length;
+}
+
+static size_t omap_sham_append_buffer(struct omap_sham_ctx *ctx,
+				const u8 *data, size_t length)
+{
+	size_t count = min(length, ctx->buffer_size - ctx->bufcnt);
+
+	count = min(count, ctx->total);
+	if (count <= 0)
+		return 0;
+	memcpy(ctx->buffer + ctx->bufcnt, data, count);
+	ctx->bufcnt += count;
+	return count;
+}
+
+static size_t omap_sham_append_sg(struct omap_sham_ctx *ctx)
+{
+	size_t count;
+
+	while (ctx->sg) {
+		count = omap_sham_append_buffer(ctx,
+				sg_virt(ctx->sg) + ctx->offset, ctx->length);
+		if (!count)
+			break;
+		ctx->length -= count;
+		ctx->offset += count;
+		ctx->total -= count;
+		if (ctx->length == 0) {
+			ctx->sg = sg_next(ctx->sg);
+			if (ctx->sg) {
+				ctx->offset = 0;
+				ctx->length = ctx->sg->length;
+			} else {
+				ctx->total = 0;
+			}
+		}
+	}
+	return 0;
+}
+
+static int omap_sham_update_cpu(struct omap_sham_ctx *ctx, const u8 *data,
+				size_t length)
+{
+	unsigned int count;
+	int err;
+
+	if (ctx->bufcnt) {
+		count = min(length, SHA1_MD5_BLOCK_SIZE - ctx->bufcnt);
+		omap_sham_append_cpu(ctx, data, count);
+		data += count;
+		length -= count;
+		if (!length)
+			return 0;
+		ctx->bufcnt = 0;
+		err = omap_sham_xmit_cpu(ctx, ctx->buffer,
+					    SHA1_MD5_BLOCK_SIZE, 0);
+		if (err)
+			return err;
+	}
+	/*
+	 * We need to save the last buffer <= 64 to digest it with
+	 * CLOSE_HASH = 1
+	 */
+	while (length > SHA1_MD5_BLOCK_SIZE) {
+		err = omap_sham_xmit_cpu(ctx, data, SHA1_MD5_BLOCK_SIZE, 0);
+		if (err)
+			return err;
+		length -= SHA1_MD5_BLOCK_SIZE;
+		data += SHA1_MD5_BLOCK_SIZE;
+	}
+	omap_sham_append_cpu(ctx, data, length);
+
+	return 0;
+}
+
+static int omap_sham_update_dma_slow(struct omap_sham_ctx *ctx)
+{
+	unsigned int final;
+	size_t count;
+
+	if (!ctx->total)
+		return 0;
+
+	omap_sham_append_sg(ctx);
+
+	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
+
+	dev_dbg(ctx->dd->dev, "bufcnt: %u, digcnt: %d, final: %d\n",
+		 ctx->bufcnt, ctx->digcnt, final);
+
+	if (final || (ctx->bufcnt == ctx->buffer_size && ctx->total)) {
+		count = ctx->bufcnt;
+		ctx->bufcnt = 0;
+		return omap_sham_xmit_dma(ctx, ctx->dd->buffer_addr, count,
+					      final);
+	}
+
+	return 0;
+}
+
+static int omap_sham_update_dma_stop(struct omap_sham_ctx *ctx)
+{
+	struct omap_sham_dev *dd = ctx->dd;
+
+	omap_stop_dma(dd->dma_lch);
+	if (ctx->flags & FLAGS_FAST) {
+		if (dd->dma_addr) {
+			dma_unmap_single(dd->dev, dd->dma_addr, ctx->dma_size,
+				 DMA_TO_DEVICE);
+			dd->dma_addr = 0;
+		} else {
+			dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
+		}
+	}
+
+	return 0;
+}
+
+static int omap_sham_init(struct omap_sham_ctx *ctx)
+{
+	struct omap_sham_dev *dd = NULL, *tmp;
+
+	spin_lock_bh(&list_lock);
+	list_for_each_entry(tmp, &dev_list, list) {
+		if (likely(!tmp->hw_ctx)) {
+			dd = tmp;
+			break;
+		}
+	}
+	if (unlikely(!dd)) {
+		spin_unlock_bh(&list_lock);
+		ctx->flags |= FLAGS_BYPASS;
+		return 0;
+	}
+	dd->hw_ctx = ctx;
+	ctx->dd = dd;
+	spin_unlock_bh(&list_lock);
+
+	dev_dbg(dd->dev, "digest size: %d\n", ctx->digsize);
+
+	/* clean except may sleep */
+	ctx->flags &= FLAGS_MAY_SLEEP;
+
+	if (ctx->digsize == SHA1_DIGEST_SIZE)
+		ctx->flags |= FLAGS_SHA1;
+
+	ctx->bufcnt = 0;
+	ctx->digcnt = 0;
+
+	dd->dma_lch = -1;
+
+
+	ctx->buffer = (void *)__get_free_page((ctx->flags & FLAGS_MAY_SLEEP) ?
+			 GFP_KERNEL : GFP_ATOMIC);
+	if (!ctx->buffer)
+		return -ENOMEM;
+
+	ctx->buffer_size = PAGE_SIZE;
+	dd->buffer_addr = dma_map_single(dd->dev, ctx->buffer, ctx->buffer_size,
+					DMA_TO_DEVICE);
+	if (dma_mapping_error(dd->dev, dd->buffer_addr)) {
+		dev_err(dd->dev, "dma %u bytes error\n", ctx->buffer_size);
+		free_page((unsigned long)ctx->buffer);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int omap_sham_final(struct omap_sham_ctx *ctx)
+{
+	int err = 0, use_dma = !!ctx->req;
+
+	if (ctx->bufcnt) {
+		/* DMA is overhead if only data is <=64b */
+		if (ctx->bufcnt <= 64)
+			/* still use dma if it has been used already */
+			use_dma = ctx->dd->dma_lch >= 0;
+		if (use_dma)
+			err = omap_sham_xmit_dma(ctx, ctx->dd->buffer_addr,
+							ctx->bufcnt, 1);
+		else
+			err = omap_sham_xmit_cpu(ctx, ctx->buffer,
+							ctx->bufcnt, 1);
+	}
+
+	if (err)
+		return err;
+
+	err = omap_sham_wait_for_output_ready(ctx);
+
+	return err;
+}
+
+static void omap_sham_hw_cleanup(struct omap_sham_ctx *ctx, u8 *out)
+{
+	struct omap_sham_dev *dd = ctx->dd;
+	unsigned long flags;
+
+	if (ctx->flags & FLAGS_BYPASS)
+		goto exit;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	if (ctx->flags & FLAGS_CLEAN) {
+		spin_unlock_irqrestore(&dd->lock, flags);
+		dev_dbg(dd->dev, "already clean\n");
+		return;
+	}
+	ctx->flags |= FLAGS_CLEAN;
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	if (dd->dma_lch >= 0) {
+		/* We can free the channels */
+		omap_free_dma(dd->dma_lch);
+		dd->dma_lch = -1;
+	}
+
+	omap_sham_copy_hash(ctx, (u32 *)out);
+	clk_disable(dd->iclk);
+
+	if (dd->buffer_addr)
+		dma_unmap_single(dd->dev, dd->buffer_addr, ctx->buffer_size,
+				 DMA_TO_DEVICE);
+	if (ctx->buffer) {
+		free_page((unsigned long)ctx->buffer);
+		ctx->buffer = NULL;
+	}
+
+exit:
+	if (dd && dd->hw_ctx == ctx)
+		dd->hw_ctx = NULL;
+}
+
+
+/* ******************** SHASH ********************************************* */
+
+static int omap_sham_shash_update_bypass(struct shash_desc *desc,
+					const u8 *data, size_t length)
+{
+	struct omap_sham_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct omap_sham_desc *dctx = shash_desc_ctx(desc);
+
+	pr_debug("length: %d\n", length);
+
+	if (ctx->flags & FLAGS_BYPASS_INIT) {
+		int err = crypto_shash_init(&dctx->fallback);
+		pr_debug("switching to bypass, err: %d\n", err);
+		ctx->flags &= ~FLAGS_BYPASS_INIT;
+		if (err)
+			return err;
+	}
+
+	if (length)
+		return crypto_shash_update(&dctx->fallback, data, length);
+
+	return 0;
+}
+
+static int omap_sham_shash_init(struct shash_desc *desc)
+{
+	struct omap_sham_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct omap_sham_desc *dctx = shash_desc_ctx(desc);
+	int err;
+
+	dctx->fallback.tfm = ctx->shash_fb;
+	dctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ctx->digsize = crypto_shash_digestsize(desc->tfm);
+
+	if (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		ctx->flags |= FLAGS_MAY_SLEEP;
+
+	err = omap_sham_init(ctx);
+
+	return err;
+}
+
+static int omap_sham_shash_update(struct shash_desc *desc, const u8 *data,
+				  size_t length)
+{
+	struct omap_sham_ctx *ctx = crypto_shash_ctx(desc->tfm);
+
+	if (!length)
+		return 0;
+
+	if (ctx->flags & FLAGS_BYPASS)
+		return omap_sham_shash_update_bypass(desc, data, length);
+
+	dev_dbg(ctx->dd->dev, "update: length: %d\n", length);
+
+	if ((ctx->flags & FLAGS_FINUP) &&
+		    ((ctx->digcnt + ctx->bufcnt + length) < 9)) {
+		/*
+		 * OMAP HW accel works only with buffers >= 9
+		 * will switch to bypass in final()
+		 */
+		omap_sham_append_cpu(ctx, data, length);
+		return 0;
+	}
+
+	return omap_sham_update_cpu(ctx, data, length);
+}
+
+static int omap_sham_shash_final(struct shash_desc *desc, u8 *out)
+{
+	struct omap_sham_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct omap_sham_desc *dctx = shash_desc_ctx(desc);
+	int err = 0;
+
+	ctx->flags |= FLAGS_FINUP;
+
+	/* OMAP HW accel works only with buffers >= 9 */
+	if ((ctx->flags & FLAGS_BYPASS_INIT) ||
+	    ((ctx->digcnt + ctx->bufcnt) < 9 && !(ctx->flags & FLAGS_BYPASS))) {
+		ctx->flags |= FLAGS_BYPASS;
+		err = omap_sham_shash_update_bypass(desc, ctx->buffer,
+								ctx->bufcnt);
+		if (err)
+			goto exit;
+	}
+
+	if (unlikely(ctx->flags & FLAGS_BYPASS))
+		err = crypto_shash_final(&dctx->fallback, out);
+	else
+		err = omap_sham_final(ctx);
+
+exit:
+	omap_sham_hw_cleanup(ctx, out);
+
+	return err;
+}
+
+static int omap_sham_shash_finup(struct shash_desc *desc, const u8 *data,
+				 size_t length, u8 *out)
+{
+	struct omap_sham_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	int err1, err2;
+
+	ctx->flags |= FLAGS_FINUP;
+
+	err1 = omap_sham_shash_update(desc, data, length);
+
+	/*
+	 * final() has to be always called to cleanup resources
+	 * even if udpate() failed
+	 */
+	err2 = omap_sham_shash_final(desc, out);
+
+	return err1 ?: err2;
+}
+
+static int omap_sham_shash_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_shash *hash = __crypto_shash_cast(tfm);
+	struct omap_sham_ctx *ctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = tfm->__crt_alg->cra_name;
+
+	ctx->req = NULL;
+
+	/* Allocate a fallback and abort if it failed. */
+	ctx->shash_fb = crypto_alloc_shash(alg_name, 0,
+					 CRYPTO_ALG_ASYNC |
+					 CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->shash_fb)) {
+		pr_warning("omap-sham: fallback driver '%s' "
+				"could not be loaded.\n", alg_name);
+		return PTR_ERR(ctx->shash_fb);
+	}
+
+	hash->descsize += crypto_shash_descsize(ctx->shash_fb);
+
+	return 0;
+}
+
+static void omap_sham_shash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct omap_sham_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->shash_fb);
+	ctx->shash_fb = NULL;
+}
+
+/* ******************** AHASH ********************************************* */
+
+static int omap_sham_ahash_init_bypass(struct omap_sham_ctx *ctx,
+				       struct ahash_request *req)
+{
+	int err = 0;
+	u32 flags;
+
+	pr_debug("length: %d\n", req->nbytes);
+
+	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ctx->req = ahash_request_alloc(ctx->ahash_fb,
+					flags ? GFP_KERNEL : GFP_ATOMIC);
+	if (!ctx->req) {
+		pr_err("Failed to allocate request\n");
+		return -ENOMEM;
+	}
+
+	ahash_request_set_callback(ctx->req, flags,
+					req->base.complete, req->base.data);
+
+	ahash_request_set_crypt(ctx->req, req->src, req->result,
+				req->nbytes); /* needed before init? */
+	err = crypto_ahash_init(ctx->req);
+
+	ctx->flags &= ~FLAGS_BYPASS_INIT;
+
+	pr_debug("switching to bypass, err: %d\n", err);
+
+	return err;
+}
+
+static int omap_sham_ahash_update_bypass(struct omap_sham_ctx *ctx,
+					 struct ahash_request *req)
+{
+	int err;
+
+	pr_debug("length: %d\n", req->nbytes);
+
+	if (ctx->flags & FLAGS_BYPASS_INIT) {
+		err = omap_sham_ahash_init_bypass(ctx, req);
+		if (err)
+			return err;
+	}
+
+	if (!req->nbytes)
+		return 0;
+
+	ahash_request_set_crypt(ctx->req, req->src, req->result,
+				req->nbytes);
+	err = crypto_ahash_update(ctx->req);
+
+	if (err)
+		pr_err("err: %d\n", err);
+
+	return err;
+}
+
+static int omap_sham_ahash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	int err;
+
+	ctx->digsize = crypto_ahash_digestsize(tfm);
+	ctx->req = req;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		ctx->flags |= FLAGS_MAY_SLEEP;
+
+	err = omap_sham_init(ctx);
+
+	return err;
+
+}
+
+static int omap_sham_ahash_update_dma_fast(struct omap_sham_ctx *ctx)
+{
+	unsigned int length;
+
+	ctx->flags |= FLAGS_FAST;
+
+	length = min(ctx->total, sg_dma_len(ctx->sg));
+	ctx->total = length;
+
+	if (!dma_map_sg(ctx->dd->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
+		dev_err(ctx->dd->dev, "dma_map_sg  error\n");
+		return -EINVAL;
+	}
+
+	ctx->total -= length;
+
+	return omap_sham_xmit_dma(ctx, sg_dma_address(ctx->sg), length, 1);
+}
+
+static int omap_sham_ahash_update_dma(struct omap_sham_ctx *ctx,
+				      struct ahash_request *req)
+{
+	ctx->req = req;
+	ctx->total = req->nbytes;
+	ctx->sg = req->src;
+	ctx->offset = 0;
+	ctx->length = ctx->sg->length;
+
+	dev_dbg(ctx->dd->dev, "update: total: %u, digcnt: %d, final: %d\n",
+		 ctx->total, ctx->digcnt, (ctx->flags & FLAGS_FINUP) != 0);
+
+	if (sg_is_last(ctx->sg)) {
+		/* may be can use faster functions */
+		int aligned = IS_ALIGNED((u32)ctx->sg->offset, sizeof(u32));
+		int digest = (ctx->flags & FLAGS_FINUP) &&
+				!(ctx->flags & FLAGS_UPDATE);
+		if (digest && aligned)
+			/* digest: first and final */
+			return omap_sham_ahash_update_dma_fast(ctx);
+	}
+
+	return omap_sham_update_dma_slow(ctx);
+}
+
+static int omap_sham_ahash_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	int err;
+
+	if (!req->nbytes)
+		return 0;
+
+	if (ctx->flags & FLAGS_BYPASS)
+		return omap_sham_ahash_update_bypass(ctx, req);
+
+	if ((ctx->flags & FLAGS_FINUP) &&
+		    ((ctx->digcnt + ctx->bufcnt + req->nbytes) < 9)) {
+		/*
+		 * OMAP HW accel works only with buffers >= 9
+		 * will switch to bypass in final()
+		 * final has the same request and data
+		 */
+		return 0;
+	}
+
+	init_completion(&ctx->dd->dma_wait);
+
+	err = omap_sham_ahash_update_dma(ctx, req);
+
+	ctx->flags |= FLAGS_UPDATE;
+
+	/* wait for dma completion before can take more data */
+	if (!err)
+		err = omap_sham_wait_for_dma(ctx);
+
+	dev_dbg(ctx->dd->dev, "update: err: %d, digcnt: %d\n",
+							err, ctx->digcnt);
+
+	return err;
+}
+
+static int omap_sham_ahash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	int err = 0;
+
+	ctx->flags |= FLAGS_FINUP;
+
+	/* OMAP HW accel works only with buffers >= 9 */
+	if ((ctx->flags & FLAGS_BYPASS_INIT) ||
+	    ((ctx->digcnt + ctx->bufcnt + req->nbytes) < 9 &&
+		    !(ctx->flags & FLAGS_BYPASS))) {
+		ctx->flags |= FLAGS_BYPASS;
+		err = omap_sham_ahash_update_bypass(ctx, req);
+		if (err)
+			goto exit;
+	}
+
+	if (unlikely(ctx->flags & FLAGS_BYPASS)) {
+		err = crypto_ahash_final(ctx->req);
+		ahash_request_free(ctx->req);
+	} else {
+		ctx->req = req;
+		err = omap_sham_final(ctx);
+	}
+
+exit:
+	if (err != -EINPROGRESS)
+		omap_sham_hw_cleanup(ctx, req->result);
+
+	return err;
+}
+
+static int omap_sham_ahash_finup(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	int err1, err2;
+
+	ctx->flags |= FLAGS_FINUP;
+
+	err1 = omap_sham_ahash_update(req);
+	if (err1 == -EINPROGRESS)
+		return err1;
+
+	/*
+	 * final() has to be always called to cleanup resources
+	 * even if udpate() failed
+	 */
+	err2 = omap_sham_ahash_final(req);
+
+	return err1 ?: err2;
+}
+
+static int omap_sham_ahash_digest(struct ahash_request *req)
+{
+	return omap_sham_ahash_init(req) ?: omap_sham_ahash_finup(req);
+}
+
+static int omap_sham_ahash_cra_init(struct crypto_tfm *tfm)
+{
+	struct omap_sham_ctx *ctx = crypto_tfm_ctx(tfm);
+	const char *alg_name = tfm->__crt_alg->cra_name;
+
+	ctx->req = NULL;
+
+	/* Allocate a fallback and abort if it failed. */
+	ctx->ahash_fb = crypto_alloc_ahash(alg_name, 0,
+					 CRYPTO_ALG_ASYNC |
+					 CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->ahash_fb)) {
+		pr_warning("omap-sham: fallback driver '%s' "
+				"could not be loaded.\n", alg_name);
+		return PTR_ERR(ctx->ahash_fb);
+	}
+
+	return 0;
+}
+
+static void omap_sham_ahash_cra_exit(struct crypto_tfm *tfm)
+{
+	struct omap_sham_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(ctx->ahash_fb);
+	ctx->ahash_fb = NULL;
+}
+
+static struct ahash_alg omap_sha1_aalg = {
+	.init		= omap_sham_ahash_init,
+	.update		= omap_sham_ahash_update,
+	.final		= omap_sham_ahash_final,
+	.finup		= omap_sham_ahash_finup,
+	.digest		= omap_sham_ahash_digest,
+	.halg.digestsize	= SHA1_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "omap-sha1",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= omap_sham_ahash_cra_init,
+		.cra_exit		= omap_sham_ahash_cra_exit,
+	}
+};
+
+static struct ahash_alg omap_md5_aalg = {
+	.init		= omap_sham_ahash_init,
+	.update		= omap_sham_ahash_update,
+	.final		= omap_sham_ahash_final,
+	.finup		= omap_sham_ahash_finup,
+	.digest		= omap_sham_ahash_digest,
+	.halg.digestsize	= MD5_DIGEST_SIZE,
+	.halg.base	= {
+		.cra_name		= "md5",
+		.cra_driver_name	= "omap-md5",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= omap_sham_ahash_cra_init,
+		.cra_exit		= omap_sham_ahash_cra_exit,
+	}
+};
+
+static struct shash_alg omap_sha1_alg = {
+	.digestsize	= SHA1_DIGEST_SIZE,
+	.init		= omap_sham_shash_init,
+	.update		= omap_sham_shash_update,
+	.finup		= omap_sham_shash_finup,
+	.final		= omap_sham_shash_final,
+	.descsize	= sizeof(struct omap_sham_desc),
+	.base		= {
+		.cra_name		= "sha1",
+		.cra_driver_name	= "omap-sha1",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= omap_sham_shash_cra_init,
+		.cra_exit		= omap_sham_shash_cra_exit,
+	}
+};
+
+static struct shash_alg omap_md5_alg = {
+	.digestsize	= MD5_DIGEST_SIZE,
+	.init		= omap_sham_shash_init,
+	.update		= omap_sham_shash_update,
+	.finup		= omap_sham_shash_finup,
+	.final		= omap_sham_shash_final,
+	.descsize	= sizeof(struct omap_sham_desc),
+	.base		= {
+		.cra_name		= "md5",
+		.cra_driver_name	= "omap-md5",
+		.cra_priority		= 100,
+		.cra_flags		= CRYPTO_ALG_TYPE_SHASH |
+						CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= SHA1_MD5_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
+		.cra_alignmask		= 0,
+		.cra_module		= THIS_MODULE,
+		.cra_init		= omap_sham_shash_cra_init,
+		.cra_exit		= omap_sham_shash_cra_exit,
+	}
+};
+
+static int omap_sham_probe(struct platform_device *pdev)
+{
+	struct omap_sham_dev *dd;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int rc;
+
+	dd = kzalloc(sizeof(struct omap_sham_dev), GFP_KERNEL);
+	if (dd == NULL) {
+		dev_err(dev, "unable to alloc data struct.\n");
+		rc = -ENOMEM;
+		goto data_err;
+	}
+	dd->dev = dev;
+	platform_set_drvdata(pdev, dd);
+
+	INIT_LIST_HEAD(&dd->list);
+	spin_lock_init(&dd->lock);
+	init_waitqueue_head(&dd->wq);
+	tasklet_init(&dd->done_task, omap_sham_done, (unsigned long)dd);
+	dd->irq = -1;
+
+	/* Get the base address */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "no MEM resource info\n");
+		rc = -ENODEV;
+		goto res_err;
+	}
+	dd->phys_base = res->start;
+
+	/* Get the DMA */
+	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!res)
+		dev_info(dev, "no DMA resource info\n");
+	else
+		dd->dma = res->start;
+
+	/* for some reason non-dma hash calculation sometimes fails with irq */
+	if (dd->dma) {
+		/* Get the IRQ */
+		dd->irq = platform_get_irq(pdev,  0);
+		if (dd->irq < 0) {
+			dev_err(dev, "no IRQ resource info\n");
+			rc = dd->irq;
+			goto res_err;
+		}
+
+		rc = request_irq(dd->irq, omap_sham_irq,
+				IRQF_TRIGGER_LOW, dev_name(dev), dd);
+		if (rc) {
+			dev_err(dev, "unable to request irq.\n");
+			goto res_err;
+		}
+	}
+
+	/* Initializing the clock */
+	dd->iclk = clk_get(dev, "ick");
+	if (!dd->iclk) {
+		dev_err(dev, "clock intialization failed.\n");
+		rc = -ENODEV;
+		goto clk_err;
+	}
+
+	dd->io_base = ioremap(dd->phys_base, SZ_4K);
+	if (!dd->io_base) {
+		dev_err(dev, "can't ioremap\n");
+		rc = -ENOMEM;
+		goto io_err;
+	}
+
+	clk_enable(dd->iclk);
+	dev_info(dev, "hw accel on OMAP rev %u.%u\n",
+		(omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MAJOR) >> 4,
+		omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MINOR);
+	clk_disable(dd->iclk);
+
+	spin_lock(&list_lock);
+	list_add_tail(&dd->list, &dev_list);
+	spin_unlock(&list_lock);
+
+	rc = crypto_register_shash(&omap_sha1_alg);
+	if (rc)
+		goto sha1_err;
+	rc = crypto_register_shash(&omap_md5_alg);
+	if (rc)
+		goto md5_err;
+	rc = crypto_register_ahash(&omap_sha1_aalg);
+	if (rc)
+		goto asha1_err;
+	rc = crypto_register_ahash(&omap_md5_aalg);
+	if (rc)
+		goto amd5_err;
+
+	return 0;
+
+amd5_err:
+	crypto_unregister_ahash(&omap_sha1_aalg);
+asha1_err:
+	crypto_unregister_shash(&omap_md5_alg);
+md5_err:
+	crypto_unregister_shash(&omap_sha1_alg);
+sha1_err:
+	iounmap(dd->io_base);
+io_err:
+	clk_put(dd->iclk);
+clk_err:
+	if (dd->irq >= 0)
+		free_irq(dd->irq, dd);
+res_err:
+	kfree(dd);
+data_err:
+	dev_err(dev, "initialization failed.\n");
+
+	return rc;
+}
+
+static int omap_sham_remove(struct platform_device *pdev)
+{
+	static struct omap_sham_dev *dd;
+
+	dd = platform_get_drvdata(pdev);
+	if (!dd)
+		return -ENODEV;
+	spin_lock(&list_lock);
+	list_del(&dd->list);
+	spin_unlock(&list_lock);
+	crypto_unregister_ahash(&omap_md5_aalg);
+	crypto_unregister_ahash(&omap_sha1_aalg);
+	crypto_unregister_shash(&omap_sha1_alg);
+	crypto_unregister_shash(&omap_md5_alg);
+	tasklet_kill(&dd->done_task);
+	iounmap(dd->io_base);
+	clk_put(dd->iclk);
+	if (dd->irq >= 0)
+		free_irq(dd->irq, dd);
+	kfree(dd);
+	dd = NULL;
+	return 0;
+}
+
+static struct platform_driver omap_sham_driver = {
+	.probe	= omap_sham_probe,
+	.remove	= omap_sham_remove,
+	.driver	= {
+		.name	= "omap-sham",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init omap_sham_mod_init(void)
+{
+	pr_info("loading %s driver\n", "omap-sham");
+
+	if (!cpu_class_is_omap2() ||
+		omap_type() != OMAP2_DEVICE_TYPE_SEC) {
+		pr_err("Unsupported cpu\n");
+		return -ENODEV;
+	}
+
+	return platform_driver_register(&omap_sham_driver);
+}
+
+static void __exit omap_sham_mod_exit(void)
+{
+	platform_driver_unregister(&omap_sham_driver);
+}
+
+module_init(omap_sham_mod_init);
+module_exit(omap_sham_mod_exit);
+
+MODULE_DESCRIPTION("OMAP SHA1/MD5 hw acceleration support.");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("David Cohen");
+MODULE_AUTHOR("Dmitry Kasatkin");
-- 
1.6.3.3

