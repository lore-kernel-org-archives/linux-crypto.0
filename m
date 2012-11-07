From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v3 6/7] crypto: omap-sham: Add code to use dmaengine API
Date: Tue,  6 Nov 2012 19:57:12 -0700
Message-ID: <1352257033-32495-7-git-send-email-mgreer@animalcreek.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:34559 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2KGC5h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2012 21:57:37 -0500
In-Reply-To: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Add code to use the new dmaengine API alongside
the existing DMA code that uses the private
OMAP DMA API.  The API to use is chosen by
defining or undefining 'OMAP_SHAM_DMA_PRIVATE'.

CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c | 150 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 145 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 85d43b2..b57277c 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -13,6 +13,8 @@
  * Some ideas are from old omap-sha1-md5.c driver.
  */
 
+#define OMAP_SHAM_DMA_PRIVATE
+
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/err.h>
@@ -27,6 +29,10 @@
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#ifndef OMAP_SHAM_DMA_PRIVATE
+#include <linux/dmaengine.h>
+#include <linux/omap-dma.h>
+#endif
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
@@ -37,9 +43,11 @@
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 #include <plat/cpu.h>
 #include <plat/dma.h>
 #include <mach/irqs.h>
+#endif
 
 #define SHA_REG_DIGEST(x)		(0x00 + ((x) * 0x04))
 #define SHA_REG_DIN(x)			(0x1C + ((x) * 0x04))
@@ -47,6 +55,8 @@
 #define SHA1_MD5_BLOCK_SIZE		SHA1_BLOCK_SIZE
 #define MD5_DIGEST_SIZE			16
 
+#define	DST_MAXBURST			16 /* Really element number (en) */
+
 #define SHA_REG_DIGCNT			0x14
 
 #define SHA_REG_CTRL			0x18
@@ -110,6 +120,9 @@ struct omap_sham_reqctx {
 
 	/* walk state */
 	struct scatterlist	*sg;
+#ifndef OMAP_SHAM_DMA_PRIVATE
+	struct scatterlist	sgl;
+#endif
 	unsigned int		offset;	/* offset in current sg */
 	unsigned int		total;	/* total request */
 
@@ -143,8 +156,12 @@ struct omap_sham_dev {
 	int			irq;
 	spinlock_t		lock;
 	int			err;
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	int			dma;
 	int			dma_lch;
+#else
+	struct dma_chan		*dma_lch;
+#endif
 	struct tasklet_struct	done_task;
 
 	unsigned long		flags;
@@ -314,15 +331,32 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 	return -EINPROGRESS;
 }
 
+#ifndef OMAP_SHAM_DMA_PRIVATE
+static void omap_sham_dma_callback(void *param)
+{
+	struct omap_sham_dev *dd = param;
+
+	set_bit(FLAGS_DMA_READY, &dd->flags);
+	tasklet_schedule(&dd->done_task);
+}
+#endif
+
 static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
-			      size_t length, int final)
+			      size_t length, int final, int is_sg)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	int len32;
+#else
+	struct dma_async_tx_descriptor *tx;
+	struct dma_slave_config cfg;
+	int ret;
+#endif
 
 	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
 						ctx->digcnt, length, final);
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
 	omap_set_dma_transfer_params(dd->dma_lch, OMAP_DMA_DATA_TYPE_S32, len32,
@@ -332,6 +366,48 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
 				dma_addr, 0, 0);
 
+#else
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.dst_addr = dd->phys_base + SHA_REG_DIN(0);
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = DST_MAXBURST;
+
+	ret = dmaengine_slave_config(dd->dma_lch, &cfg);
+	if (ret) {
+		pr_err("omap-sham: can't configure dmaengine slave: %d\n", ret);
+		return ret;
+	}
+
+	if (is_sg) {
+		/*
+		 * The SG entry passed in may not have the 'length' member
+		 * set correctly so use a local SG entry (sgl) with the
+		 * proper value for 'length' instead.  If this is not done,
+		 * the dmaengine may try to DMA the incorrect amount of data.
+		 */
+		sg_init_table(&ctx->sgl, 1);
+		ctx->sgl.page_link = ctx->sg->page_link;
+		ctx->sgl.offset = ctx->sg->offset;
+		sg_dma_len(&ctx->sgl) = length;
+		sg_dma_address(&ctx->sgl) = sg_dma_address(ctx->sg);
+
+		tx = dmaengine_prep_slave_sg(dd->dma_lch, &ctx->sgl, 1,
+			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	} else {
+		tx = dmaengine_prep_slave_single(dd->dma_lch, dma_addr, length,
+			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	}
+
+	if (!tx) {
+		dev_err(dd->dev, "prep_slave_sg/single() failed\n");
+		return -EINVAL;
+	}
+
+	tx->callback = omap_sham_dma_callback;
+	tx->callback_param = dd;
+#endif
+
 	omap_sham_write_ctrl(dd, length, final, 1);
 
 	ctx->digcnt += length;
@@ -341,7 +417,12 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 
 	set_bit(FLAGS_DMA_ACTIVE, &dd->flags);
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	omap_start_dma(dd->dma_lch);
+#else
+	dmaengine_submit(tx);
+	dma_async_issue_pending(dd->dma_lch);
+#endif
 
 	return -EINPROGRESS;
 }
@@ -388,6 +469,8 @@ static int omap_sham_xmit_dma_map(struct omap_sham_dev *dd,
 					struct omap_sham_reqctx *ctx,
 					size_t length, int final)
 {
+	int ret;
+
 	ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer, ctx->buflen,
 				       DMA_TO_DEVICE);
 	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
@@ -397,8 +480,12 @@ static int omap_sham_xmit_dma_map(struct omap_sham_dev *dd,
 
 	ctx->flags &= ~BIT(FLAGS_SG);
 
-	/* next call does not fail... so no unmap in the case of error */
-	return omap_sham_xmit_dma(dd, ctx->dma_addr, length, final);
+	ret = omap_sham_xmit_dma(dd, ctx->dma_addr, length, final, 0);
+	if (ret)
+		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen,
+				 DMA_TO_DEVICE);
+
+	return ret;
 }
 
 static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
@@ -433,6 +520,7 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 	unsigned int length, final, tail;
 	struct scatterlist *sg;
+	int ret;
 
 	if (!ctx->total)
 		return 0;
@@ -440,6 +528,17 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	if (ctx->bufcnt || ctx->offset)
 		return omap_sham_update_dma_slow(dd);
 
+#ifndef OMAP_SHAM_DMA_PRIVATE
+	/*
+	 * Don't use the sg interface when the transfer size is less
+	 * than the number of elements in a DMA frame.  Otherwise,
+	 * the dmaengine infrastructure will calculate that it needs
+	 * to transfer 0 frames which ultimately fails.
+	 */
+	if (ctx->total < (DST_MAXBURST * sizeof(u32)))
+		return omap_sham_update_dma_slow(dd);
+#endif
+
 	dev_dbg(dd->dev, "fast: digcnt: %d, bufcnt: %u, total: %u\n",
 			ctx->digcnt, ctx->bufcnt, ctx->total);
 
@@ -477,8 +576,11 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 
 	final = (ctx->flags & BIT(FLAGS_FINUP)) && !ctx->total;
 
-	/* next call does not fail... so no unmap in the case of error */
-	return omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, final);
+	ret = omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, final, 1);
+	if (ret)
+		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
+
+	return ret;
 }
 
 static int omap_sham_update_cpu(struct omap_sham_dev *dd)
@@ -497,7 +599,12 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	omap_stop_dma(dd->dma_lch);
+#else
+	dmaengine_terminate_all(dd->dma_lch);
+#endif
+
 	if (ctx->flags & BIT(FLAGS_SG)) {
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
 		if (ctx->sg->length == ctx->offset) {
@@ -700,6 +807,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	if (err)
 		goto err1;
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	omap_set_dma_dest_params(dd->dma_lch, 0,
 			OMAP_DMA_AMODE_CONSTANT,
 			dd->phys_base + SHA_REG_DIN(0), 0, 16);
@@ -709,6 +817,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 
 	omap_set_dma_src_burst_mode(dd->dma_lch,
 			OMAP_DMA_DATA_BURST_4);
+#endif
 
 	if (ctx->digcnt)
 		/* request has changed - restore hash */
@@ -1100,6 +1209,7 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
 {
 	struct omap_sham_dev *dd = data;
@@ -1137,12 +1247,17 @@ static void omap_sham_dma_cleanup(struct omap_sham_dev *dd)
 		dd->dma_lch = -1;
 	}
 }
+#endif
 
 static int __devinit omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+#ifndef OMAP_SHAM_DMA_PRIVATE
+	dma_cap_mask_t mask;
+	unsigned dma_chan;
+#endif
 	int err, i, j;
 
 	dd = kzalloc(sizeof(struct omap_sham_dev), GFP_KERNEL);
@@ -1177,7 +1292,11 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		err = -ENODEV;
 		goto res_err;
 	}
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	dd->dma = res->start;
+#else
+	dma_chan = res->start;
+#endif
 
 	/* Get the IRQ */
 	dd->irq = platform_get_irq(pdev,  0);
@@ -1194,9 +1313,22 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	err = omap_sham_dma_init(dd);
 	if (err)
 		goto dma_err;
+#else
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	dd->dma_lch = dma_request_channel(mask, omap_dma_filter_fn, &dma_chan);
+	if (!dd->dma_lch) {
+		dev_err(dev, "unable to obtain RX DMA engine channel %u\n",
+			dma_chan);
+		err = -ENXIO;
+		goto dma_err;
+	}
+#endif
 
 	dd->io_base = ioremap(dd->phys_base, SZ_4K);
 	if (!dd->io_base) {
@@ -1232,7 +1364,11 @@ err_algs:
 	iounmap(dd->io_base);
 	pm_runtime_disable(dev);
 io_err:
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	omap_sham_dma_cleanup(dd);
+#else
+	dma_release_channel(dd->dma_lch);
+#endif
 dma_err:
 	if (dd->irq >= 0)
 		free_irq(dd->irq, dd);
@@ -1261,7 +1397,11 @@ static int __devexit omap_sham_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	iounmap(dd->io_base);
 	pm_runtime_disable(&pdev->dev);
+#ifdef OMAP_SHAM_DMA_PRIVATE
 	omap_sham_dma_cleanup(dd);
+#else
+	dma_release_channel(dd->dma_lch);
+#endif
 	if (dd->irq >= 0)
 		free_irq(dd->irq, dd);
 	kfree(dd);
-- 
1.7.12
