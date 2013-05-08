From: Tobias Rauter <tobiasrauter@gmail.com>
Subject: [PATCH 1/1] crypto: Added support for Freescale's DCP co-processor
Date: Wed,  8 May 2013 20:41:13 +0200
Message-ID: <1368038473-6979-2-git-send-email-tobias.rauter@gmail.com>
References: <1368038473-6979-1-git-send-email-tobias.rauter@gmail.com>
Cc: "Christoph G. Baumann" <cb@sgoc.de>,
	Tobias Rauter <tobias.rauter@gmail.com>
To: Tobias Rauter <tobias.rauter@smaxtec.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51014 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3EHSlu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 May 2013 14:41:50 -0400
Received: by mail-ee0-f53.google.com with SMTP id d49so1140433eek.12
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2013 11:41:49 -0700 (PDT)
In-Reply-To: <1368038473-6979-1-git-send-email-tobias.rauter@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Tobias Rauter <tobias.rauter@gmail.com>
---
 arch/arm/boot/dts/imx28.dtsi |   2 +-
 drivers/crypto/Kconfig       |  10 +
 drivers/crypto/Makefile      |   1 +
 drivers/crypto/dcp.c         | 752 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 764 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/dcp.c

diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
index 7ba4966..cd428d6 100644
--- a/arch/arm/boot/dts/imx28.dtsi
+++ b/arch/arm/boot/dts/imx28.dtsi
@@ -666,7 +666,7 @@
 			dcp@80028000 {
 				reg = <0x80028000 0x2000>;
 				interrupts = <52 53 54>;
-				status = "disabled";
+				compatible = "fsl-dcp";
 			};
 
 			pxp@8002a000 {
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 87ec4d0..1f98eca 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -276,6 +276,16 @@ config CRYPTO_DEV_PICOXCELL
 
 	  Saying m here will build a module named pipcoxcell_crypto.
 
+config CRYPTO_DEV_DCP
+	tristate "Support for the DCP engine"
+	depends on ARCH_MXS && OF
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	help
+	  This options enables support for the hardware crypto-acceleration
+	  capabilities of the DCP co-processor
+
 config CRYPTO_DEV_S5P
 	tristate "Support for Samsung S5PV210 crypto accelerator"
 	depends on ARCH_S5PV210
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 880a47b..603b92e 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
+obj-$(CONFIG_CRYPTO_DEV_DCP) += dcp.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
new file mode 100644
index 0000000..ad0bae5
--- /dev/null
+++ b/drivers/crypto/dcp.c
@@ -0,0 +1,752 @@
+/*
+ * Cryptographic API.
+ *
+ * Support for DCP cryptographic accelerator.
+ *
+ * Copyright (c) 2013
+ * Author: Tobias Rauter <tobias.rauter@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Based on tegra-aes.c, dcp.c (from freescale SDK) and sahara.c
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/crypto.h>
+
+#include <crypto/scatterwalk.h>
+#include <crypto/aes.h>
+
+
+/* DCP CHANNEL USED FOR AES */
+#define USED_CHANNEL 1
+#define DCP_MAX_PKG 20
+
+/* Control Register */
+#define DCP_REG_CTRL 0x000
+#define DCP_CTRL_SFRST (1<<31)
+#define DCP_CTRL_CLKGATE (1<<30)
+#define DCP_CTRL_CRYPTO_PRESENT (1<<29)
+#define DCP_CTRL_SHA_PRESENT (1<<28)
+#define DCP_CTRL_GATHER_RES_WRITE (1<<23)
+#define DCP_CTRL_ENABLE_CONTEXT_CACHE (1<<22)
+#define DCP_CTRL_ENABLE_CONTEXT_SWITCH (1<<21)
+#define DCP_CTRL_CH_IRQ_E_0 0x01
+#define DCP_CTRL_CH_IRQ_E_1 0x02
+#define DCP_CTRL_CH_IRQ_E_2 0x04
+#define DCP_CTRL_CH_IRQ_E_3 0x08
+
+/* Status register */
+#define DCP_REG_STAT 0x010
+#define DCP_STAT_OTP_KEY_READY (1<<28)
+#define DCP_STAT_CUR_CHANNEL(stat) ((stat>>24)&0x0F)
+#define DCP_STAT_READY_CHANNEL(stat) ((stat>>16)&0x0F)
+#define DCP_STAT_IRQ(stat) (stat&0x0F)
+#define DCP_STAT_CHAN_0 (0x01)
+#define DCP_STAT_CHAN_1 (0x02)
+#define DCP_STAT_CHAN_2 (0x04)
+#define DCP_STAT_CHAN_3 (0x08)
+
+/* Channel Control Register */
+#define DCP_REG_CHAN_CTRL 0x020
+#define DCP_CHAN_CTRL_CH0_IRQ_MERGED (1<<16)
+#define DCP_CHAN_CTRL_HIGH_PRIO_0 (0x0100)
+#define DCP_CHAN_CTRL_HIGH_PRIO_1 (0x0200)
+#define DCP_CHAN_CTRL_HIGH_PRIO_2 (0x0400)
+#define DCP_CHAN_CTRL_HIGH_PRIO_3 (0x0800)
+#define DCP_CHAN_CTRL_ENABLE_0 (0x01)
+#define DCP_CHAN_CTRL_ENABLE_1 (0x02)
+#define DCP_CHAN_CTRL_ENABLE_2 (0x04)
+#define DCP_CHAN_CTRL_ENABLE_3 (0x08)
+
+/*
+ * Channel Registers:
+ * The DCP has 4 channels. Each of this channels
+ * has 4 registers (command pointer, semaphore, status and options).
+ * The address of register REG of channel CHAN is obtained by
+ * dcp_chan_reg(REG, CHAN)
+ */
+#define DCP_REG_CHAN_PTR	0x00000100
+#define DCP_REG_CHAN_SEMA	0x00000110
+#define DCP_REG_CHAN_STAT	0x00000120
+#define DCP_REG_CHAN_OPT	0x00000130
+
+#define DCP_CHAN_STAT_NEXT_CHAIN_IS_0	0x010000
+#define DCP_CHAN_STAT_NO_CHAIN		0x020000
+#define DCP_CHAN_STAT_CONTEXT_ERROR	0x030000
+#define DCP_CHAN_STAT_PAYLOAD_ERROR	0x040000
+#define DCP_CHAN_STAT_INVALID_MODE	0x050000
+#define DCP_CHAN_STAT_PAGEFAULT		0x40
+#define DCP_CHAN_STAT_DST		0x20
+#define DCP_CHAN_STAT_SRC		0x10
+#define DCP_CHAN_STAT_PACKET		0x08
+#define DCP_CHAN_STAT_SETUP		0x04
+#define DCP_CHAN_STAT_MISMATCH		0x02
+
+/* hw packet control*/
+
+#define DCP_PKT_PAYLOAD_KEY	(1<<11)
+#define DCP_PKT_CIPHER_INIT	(1<<9)
+#define DCP_PKG_CIPHER_ENCRYPT	(1<<8)
+#define DCP_PKT_CIPHER_ENABLE	(1<<5)
+#define DCP_PKT_DECR_SEM	(1<<1)
+#define DCP_PKT_CHAIN		(1<<2)
+#define DCP_PKT_IRQ		1
+
+#define CIPHER_MODE_CBC (1<<4)
+
+/* cipher flags */
+#define DCP_ENC		0x0001
+#define DCP_DEC		0x0002
+#define DCP_ECB		0x0004
+#define DCP_CBC		0x0008
+#define DCP_CBC_INIT	0x0010
+#define DCP_NEW_KEY	0x0020
+#define DCP_AES		0x1000
+
+/* clock defines */
+#define CLOCK_ON	1
+#define CLOCK_OFF	0
+
+struct dcp_dev_req_ctx {
+	int mode;
+};
+
+struct dcp_op {
+	unsigned int flags;
+	u8 key[AES_KEYSIZE_128];
+	int keylen;
+
+	struct scatterlist *in_sg;
+	struct scatterlist *out_sg;
+	int sg_in_nents;
+	int sg_out_nents;
+
+	void *iv;
+	int nbytes;
+
+	struct crypto_ablkcipher *fallback;
+};
+
+struct dcp_dev {
+	struct device *dev;
+	void __iomem *dcp_regs_base;
+
+	int dcp_vmi_irq;
+	int dcp_irq;
+
+	spinlock_t queue_lock;
+	struct crypto_queue queue;
+
+	struct mutex op_mutex;
+	struct completion op_completion;
+	struct dcp_dev_hw_packet *hw_pkg[DCP_MAX_PKG];
+	dma_addr_t hw_phys_pkg[DCP_MAX_PKG];
+
+	/* [KEY][IV] Both with 16 Bytes*/
+	u8 *key_iv_base;
+	dma_addr_t key_iv_phys_base;
+
+	struct dcp_op *ctx;
+};
+
+struct dcp_dev_hw_packet {
+	uint32_t next;
+	uint32_t pkt1;
+	uint32_t pkt2;
+	uint32_t src;
+	uint32_t dst;
+	uint32_t size;
+	uint32_t payload;
+	uint32_t stat;
+};
+
+/*FIXME: get rid of globals */
+static void dcp_workqueue_handler(struct work_struct *work);
+static DECLARE_WORK(dcp_work, dcp_workqueue_handler);
+static struct workqueue_struct *dcp_wq;
+struct dcp_dev *global_dev;
+
+static inline u32 dcp_chan_reg(u32 reg, int chan)
+{
+	return reg + (chan) * 0x40;
+}
+
+static inline void dcp_write(struct dcp_dev *dev, u32 data, u32 reg)
+{
+	writel(data, dev->dcp_regs_base + reg);
+}
+
+static inline void dcp_set(struct dcp_dev *dev, u32 data, u32 reg)
+{
+	writel(data, dev->dcp_regs_base + (reg | 0x04));
+}
+
+static inline void dcp_clear(struct dcp_dev *dev, u32 data, u32 reg)
+{
+	writel(data, dev->dcp_regs_base + (reg | 0x08));
+}
+
+static inline void dcp_toggle(struct dcp_dev *dev, u32 data, u32 reg)
+{
+	writel(data, dev->dcp_regs_base + (reg | 0x0C));
+}
+
+static inline unsigned int dcp_read(struct dcp_dev *dev, u32 reg)
+{
+	return readl(dev->dcp_regs_base + reg);
+}
+
+static int dcp_perform_op(struct dcp_dev *dev, int nbytes)
+{
+	struct dcp_op *ctx = dev->ctx;
+	struct dcp_dev_hw_packet *pkt;
+	struct scatterlist *in_sg, *out_sg;
+	int in_off, out_off;
+	int act_packet = 0;
+	u32 pkt1, pkt2;
+	u32 stat = 0;
+
+	if (ctx->flags & DCP_NEW_KEY) {
+		memcpy(dev->key_iv_base, ctx->key, ctx->keylen);
+		ctx->flags &= ~DCP_NEW_KEY;
+	}
+
+	pkt1 = 0;
+	pkt1 |= DCP_PKT_CIPHER_ENABLE;
+	pkt1 |= DCP_PKT_PAYLOAD_KEY;
+
+	if (ctx->flags & DCP_ENC)
+		pkt1 |= DCP_PKG_CIPHER_ENCRYPT;
+
+	pkt2 = 0;
+	if (ctx->flags & DCP_CBC)
+		pkt2 |= CIPHER_MODE_CBC;
+
+	pkt = dev->hw_pkg[act_packet];
+	in_sg = ctx->in_sg;
+	out_sg = ctx->out_sg;
+	in_off = 0;
+	out_off = 0;
+
+	while (nbytes > 0) {
+		int len = min(in_sg->length - in_off, out_sg->length - out_off);
+
+		pkt->pkt1 = pkt1;
+		pkt->pkt2 = pkt2;
+
+		pkt->payload = (u32) dev->key_iv_phys_base;
+		pkt->stat = 0;
+
+		if (ctx->flags & DCP_CBC_INIT) {
+			pkt->pkt1 |= DCP_PKT_CIPHER_INIT;
+			ctx->flags &= ~DCP_CBC_INIT;
+		}
+
+		pkt->src = in_sg->dma_address + in_off;
+		pkt->dst = out_sg->dma_address + out_off;
+		pkt->size = len;
+		nbytes -= len;
+
+		if (nbytes <= 0) {
+			pkt->next = 0;
+			pkt->pkt1 |= DCP_PKT_IRQ;
+			pkt->pkt1 |= DCP_PKT_DECR_SEM;
+		} else {
+			pkt->next = dev->hw_phys_pkg[++act_packet];
+			pkt->pkt1 |= DCP_PKT_CHAIN;
+			pkt = dev->hw_pkg[act_packet];
+			in_off += len;
+			out_off += len;
+			if (in_sg->length == in_off) {
+				in_off = 0;
+				in_sg = sg_next(in_sg);
+			}
+			if (out_sg->length == out_off) {
+				out_off = 0;
+				out_sg = sg_next(out_sg);
+			}
+		}
+	}
+
+	dcp_clear(dev, -1, dcp_chan_reg(DCP_REG_CHAN_STAT, USED_CHANNEL));
+
+	dcp_write(dev, (u32) dev->hw_phys_pkg[0],
+			dcp_chan_reg(DCP_REG_CHAN_PTR, USED_CHANNEL));
+
+
+	dcp_write(dev, 1, dcp_chan_reg(DCP_REG_CHAN_SEMA, USED_CHANNEL));
+
+	wait_for_completion_timeout(&dev->op_completion,
+			msecs_to_jiffies(1000));
+
+	stat = dcp_read(dev, dcp_chan_reg(DCP_REG_CHAN_STAT, USED_CHANNEL));
+
+	if (stat)
+		dev_err(dev->dev, "Channel stat error 0x%x\n", stat);
+
+	return stat;
+}
+
+
+static irqreturn_t dcp_common_irq(int irq, void *context)
+{
+	u32 msk;
+	struct dcp_dev *dev = (struct dcp_dev *) context;
+
+	msk = DCP_STAT_IRQ(dcp_read(dev, DCP_REG_STAT));
+	dcp_clear(dev, msk, DCP_REG_STAT);
+
+	if (msk == 0)
+		return IRQ_NONE;
+
+	if (msk & DCP_STAT_CHAN_1)
+		complete(&dev->op_completion);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t dcp_vmi_irq(int irq, void *context)
+{
+	return dcp_common_irq(irq, context);
+}
+
+static irqreturn_t dcp_irq(int irq, void *context)
+{
+	return dcp_common_irq(irq, context);
+}
+
+static int dcp_sg_nents(struct scatterlist *sg, int nbytes)
+{
+	int nents;
+	for (nents = 0; sg && nbytes > 0; sg = sg_next(sg)) {
+		nbytes -= sg->length;
+		nents++;
+	}
+	return nents;
+}
+
+static int dcp_crypt(struct dcp_dev *dev, struct dcp_op *ctx)
+{
+	int ret = 0;
+
+	ctx->sg_in_nents = dcp_sg_nents(ctx->in_sg, ctx->nbytes);
+	ctx->sg_out_nents = dcp_sg_nents(ctx->out_sg, ctx->nbytes);
+
+	mutex_lock(&dev->op_mutex);
+	dev->ctx = ctx;
+
+	if ((ctx->flags & DCP_CBC) && ctx->iv) {
+		ctx->flags |= DCP_CBC_INIT;
+		memcpy(dev->key_iv_base + AES_KEYSIZE_128,
+			ctx->iv, AES_KEYSIZE_128);
+	}
+
+	ret = dma_map_sg(dev->dev, ctx->in_sg, ctx->sg_in_nents, DMA_TO_DEVICE);
+	if (ret != ctx->sg_in_nents) {
+		dev_err(dev->dev, "couldn't map src sg\n");
+		goto out;
+	}
+
+	ret = dma_map_sg(dev->dev, ctx->out_sg, ctx->sg_out_nents,
+		DMA_FROM_DEVICE);
+	if (ret != ctx->sg_out_nents) {
+		dev_err(dev->dev, "couldn't map dest sg\n");
+		goto unmap_in;
+	}
+
+	ret = dcp_perform_op(dev, ctx->nbytes);
+
+	dma_unmap_sg(dev->dev, ctx->out_sg, ctx->sg_out_nents, DMA_FROM_DEVICE);
+unmap_in:
+	dma_unmap_sg(dev->dev, ctx->in_sg, ctx->sg_in_nents, DMA_TO_DEVICE);
+out:
+
+	mutex_unlock(&dev->op_mutex);
+
+	return ret;
+
+}
+
+static void dcp_workqueue_handler(struct work_struct *work)
+{
+	struct dcp_dev *dev = global_dev;
+	struct crypto_async_request *async_req, *backlog;
+	struct crypto_ablkcipher *tfm;
+	struct dcp_op *ctx;
+	struct dcp_dev_req_ctx *rctx;
+	struct ablkcipher_request *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->queue_lock, flags);
+
+	backlog = crypto_get_backlog(&dev->queue);
+	async_req = crypto_dequeue_request(&dev->queue);
+
+	spin_unlock_irqrestore(&dev->queue_lock, flags);
+
+	if (!async_req)
+		return;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	req = ablkcipher_request_cast(async_req);
+	tfm = crypto_ablkcipher_reqtfm(req);
+	rctx = ablkcipher_request_ctx(req);
+	ctx = crypto_ablkcipher_ctx(tfm);
+
+	if (!req->src || !req->dst)
+		return;
+
+	ctx->nbytes = req->nbytes;
+	ctx->in_sg = req->src;
+	ctx->out_sg = req->dst;
+	ctx->iv = req->info;
+	ctx->flags |= rctx->mode;
+
+	async_req->complete(async_req, dcp_crypt(dev, ctx));
+}
+
+
+static int dcp_cra_init(struct crypto_tfm *tfm)
+{
+	const char *name = tfm->__crt_alg->cra_name;
+	struct dcp_op *ctx = crypto_tfm_ctx(tfm);
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct dcp_dev_req_ctx);
+
+	ctx->fallback = crypto_alloc_ablkcipher(name, 0,
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+
+	if (IS_ERR(ctx->fallback)) {
+		dev_err(global_dev->dev, "Error allocating fallback algo %s\n",
+			name);
+		return PTR_ERR(ctx->fallback);
+	}
+
+	return 0;
+}
+
+static void dcp_cra_exit(struct crypto_tfm *tfm)
+{
+	struct dcp_op *ctx = crypto_tfm_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_ablkcipher(ctx->fallback);
+
+	ctx->fallback = NULL;
+}
+
+/* async interface */
+static int dcp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int len)
+{
+	struct dcp_op *ctx = crypto_ablkcipher_ctx(tfm);
+	unsigned int ret = 0;
+	ctx->keylen = len;
+	ctx->flags = 0;
+	if (len == AES_KEYSIZE_128) {
+		memcpy(ctx->key, key, len);
+		ctx->flags |= DCP_NEW_KEY;
+		return 0;
+	}
+
+	dev_dbg(global_dev->dev, "key size %d not supported, using fallback ",
+		len);
+
+	ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	ctx->fallback->base.crt_flags |=
+		(tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_ablkcipher_setkey(ctx->fallback, key, len);
+	if (ret) {
+		struct crypto_tfm *tfm_aux = crypto_ablkcipher_tfm(tfm);
+
+		tfm_aux->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+		tfm_aux->crt_flags |=
+			(ctx->fallback->base.crt_flags & CRYPTO_TFM_RES_MASK);
+	}
+	return ret;
+}
+
+static int dcp_aes_cbc_crypt(struct ablkcipher_request *req, int mode)
+{
+	struct dcp_dev_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct dcp_dev *dcp = global_dev;
+	unsigned long flags;
+	int err = 0;
+	rctx->mode = mode;
+	spin_lock_irqsave(&dcp->queue_lock, flags);
+	err = ablkcipher_enqueue_request(&dcp->queue, req);
+	spin_unlock_irqrestore(&dcp->queue_lock, flags);
+
+	if (!IS_ALIGNED(req->nbytes, AES_BLOCK_SIZE))
+		return -EINVAL;
+
+	queue_work(dcp_wq, &dcp_work);
+
+	return err;
+}
+
+static int dcp_aes_cbc_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto_tfm *tfm =
+		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
+	struct dcp_op *ctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
+		int err = 0;
+		ablkcipher_request_set_tfm(req, ctx->fallback);
+		err = crypto_ablkcipher_encrypt(req);
+		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		return err;
+	}
+
+	return dcp_aes_cbc_crypt(req, DCP_AES | DCP_ENC | DCP_CBC);
+}
+
+static int dcp_aes_cbc_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto_tfm *tfm =
+		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
+	struct dcp_op *ctx = crypto_ablkcipher_ctx(
+		crypto_ablkcipher_reqtfm(req));
+
+	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
+		int err = 0;
+		ablkcipher_request_set_tfm(req, ctx->fallback);
+		err = crypto_ablkcipher_decrypt(req);
+		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		return err;
+	}
+	return dcp_aes_cbc_crypt(req, DCP_AES | DCP_DEC | DCP_CBC);
+}
+
+static struct crypto_alg algs[] = {
+{
+	.cra_name = "cbc(aes)",
+	.cra_driver_name = "dcp-cbc-aes",
+	.cra_alignmask = 15,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+	  CRYPTO_ALG_NEED_FALLBACK,
+	.cra_blocksize = AES_KEYSIZE_128,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_priority = 300,
+	.cra_u.ablkcipher = {
+		.min_keysize =	AES_KEYSIZE_128,
+		.max_keysize = AES_KEYSIZE_128,
+		.setkey = dcp_aes_setkey,
+		.encrypt = dcp_aes_cbc_encrypt,
+		.decrypt = dcp_aes_cbc_decrypt,
+		.ivsize = AES_KEYSIZE_128,
+	}
+
+},
+};
+
+static int dcp_probe(struct platform_device *pdev)
+{
+	struct dcp_dev *dev = NULL;
+	struct resource *r;
+	int i, ret, j;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&pdev->dev, "Failed to allocate structure\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+	global_dev = dev;
+	dev->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, dev);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get IORESOURCE_MEM\n");
+		ret = -ENXIO;
+		goto err_dev;
+	}
+	dev->dcp_regs_base = ioremap(r->start, resource_size(r));
+
+
+	dcp_set(dev, DCP_CTRL_SFRST, DCP_REG_CTRL);
+	udelay(10);
+	dcp_clear(dev, DCP_CTRL_SFRST | DCP_CTRL_CLKGATE, DCP_REG_CTRL);
+
+	dcp_write(dev, DCP_CTRL_GATHER_RES_WRITE |
+		DCP_CTRL_ENABLE_CONTEXT_CACHE | DCP_CTRL_CH_IRQ_E_1,
+		DCP_REG_CTRL);
+
+	dcp_write(dev, DCP_CHAN_CTRL_ENABLE_1, DCP_REG_CHAN_CTRL);
+
+	for (i = 0; i < 4; i++)
+		dcp_clear(dev, -1, dcp_chan_reg(DCP_REG_CHAN_STAT, i));
+
+	dcp_clear(dev, -1, DCP_REG_STAT);
+
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "can't get IRQ resource (0)\n");
+		ret = -EIO;
+		goto err_unmap_mem;
+	}
+	dev->dcp_vmi_irq = r->start;
+	ret = request_irq(dev->dcp_vmi_irq, dcp_vmi_irq, 0, "dcp", dev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "can't request_irq (0)\n");
+		ret = -EIO;
+		goto err_unmap_mem;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	if (!r) {
+		dev_err(&pdev->dev, "can't get IRQ resource (1)\n");
+		ret = -EIO;
+		goto err_free_irq0;
+	}
+	dev->dcp_irq = r->start;
+	ret = request_irq(dev->dcp_irq, dcp_irq, 0, "dcp", dev);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "can't request_irq (1)\n");
+		ret = -EIO;
+		goto err_free_irq0;
+	}
+
+	dev->hw_pkg[0] = dma_alloc_coherent(&pdev->dev,
+			DCP_MAX_PKG * sizeof(struct dcp_dev_hw_packet),
+			&dev->hw_phys_pkg[0],
+			GFP_KERNEL);
+	if (!dev->hw_pkg[0]) {
+		dev_err(&pdev->dev, "Could not allocate hw descriptors\n");
+		ret = -ENOMEM;
+		goto err_free_irq1;
+	}
+
+	for (i = 1; i < DCP_MAX_PKG; i++) {
+		dev->hw_phys_pkg[i] = dev->hw_phys_pkg[i - 1]
+				+ sizeof(struct dcp_dev_hw_packet);
+		dev->hw_pkg[i] = dev->hw_pkg[i - 1] + 1;
+
+	}
+
+	dev->key_iv_base = dma_alloc_coherent(&pdev->dev, 2 * AES_KEYSIZE_128,
+			&dev->key_iv_phys_base, GFP_KERNEL);
+	if (!dev->key_iv_base) {
+		dev_err(&pdev->dev, "Could not allocate memory for key\n");
+		ret = -ENOMEM;
+		goto err_free_hw_packet;
+	}
+
+	spin_lock_init(&dev->queue_lock);
+	crypto_init_queue(&dev->queue, 10);
+	mutex_init(&dev->op_mutex);
+	init_completion(&dev->op_completion);
+
+	dcp_wq = alloc_workqueue("dcp_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);
+	if (!dcp_wq) {
+		dev_err(&pdev->dev, "alloc_workqueue failed\n");
+		ret = -ENOMEM;
+		goto err_free_key_iv;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++) {
+		algs[i].cra_priority = 500;
+		algs[i].cra_ctxsize = sizeof(struct dcp_op);
+		algs[i].cra_module = THIS_MODULE;
+		algs[i].cra_init = dcp_cra_init;
+		algs[i].cra_exit = dcp_cra_exit;
+		if (crypto_register_alg(&algs[i])) {
+			dev_err(&pdev->dev, "register algorithm failed\n");
+			ret = -ENOMEM;
+			goto err_unregister;
+		}
+	}
+	dev_notice(&pdev->dev, "DCP crypto enabled.!\n");
+
+	return 0;
+
+err_unregister:
+	for (j = 0; j < i; j++)
+		crypto_unregister_alg(&algs[j]);
+err_free_key_iv:
+	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->key_iv_base,
+			dev->key_iv_phys_base);
+err_free_hw_packet:
+	dma_free_coherent(&pdev->dev, DCP_MAX_PKG *
+		sizeof(struct dcp_dev_hw_packet), dev->hw_pkg[0],
+		dev->hw_phys_pkg[0]);
+err_free_irq1:
+	free_irq(dev->dcp_irq, dev);
+err_free_irq0:
+	free_irq(dev->dcp_vmi_irq, dev);
+err_unmap_mem:
+	iounmap((void *) dev->dcp_regs_base);
+err_dev:
+	kfree(dev);
+err:
+	return ret;
+}
+
+static int dcp_remove(struct platform_device *pdev)
+{
+	struct dcp_dev *dev;
+	int j;
+	dev = platform_get_drvdata(pdev);
+	platform_set_drvdata(pdev, NULL);
+
+	dma_free_coherent(&pdev->dev,
+			DCP_MAX_PKG * sizeof(struct dcp_dev_hw_packet),
+			dev->hw_pkg[0],	dev->hw_phys_pkg[0]);
+
+	dma_free_coherent(&pdev->dev, 2 * AES_KEYSIZE_128, dev->key_iv_base,
+			dev->key_iv_phys_base);
+
+	free_irq(dev->dcp_irq, dev);
+	free_irq(dev->dcp_vmi_irq, dev);
+
+	iounmap((void *) dev->dcp_regs_base);
+
+	for (j = 0; j < ARRAY_SIZE(algs); j++)
+		crypto_unregister_alg(&algs[j]);
+
+	kfree(dev);
+	return 0;
+}
+
+static struct of_device_id fs_dcp_of_match[] = {
+	{	.compatible = "fsl-dcp"},
+	{},
+};
+
+static struct platform_driver fs_dcp_driver = {
+	.probe = dcp_probe,
+	.remove = dcp_remove,
+	.driver = {
+		.name = "fsl-dcp",
+		.owner = THIS_MODULE,
+		.of_match_table = fs_dcp_of_match
+	}
+};
+
+module_platform_driver(fs_dcp_driver);
+
+
+MODULE_AUTHOR("Tobias Rauter <tobias.rauter@gmail.com>");
+MODULE_DESCRIPTION("Freescale DCP Crypto Driver");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2
