From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 7/7] crypto: omap_sham: Remove usage of private DMA API
Date: Tue, 23 Oct 2012 19:36:07 -0700
Message-ID: <1351046167-4882-8-git-send-email-mgreer@animalcreek.com>
References: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1351046167-4882-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove usage of the private OMAP DMA API.
The dmaengine API will be used instead.

CC: Russell King <rmk+kernel@arm.linux.org.uk>
CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c | 117 ---------------------------------------------
 1 file changed, 117 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index c782f60..627f75e 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -13,8 +13,6 @@
  * Some ideas are from old omap-sha1-md5.c driver.
  */
 
-#define OMAP_SHAM_DMA_PRIVATE
-
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/err.h>
@@ -29,10 +27,8 @@
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#ifndef OMAP_SHAM_DMA_PRIVATE
 #include <linux/dmaengine.h>
 #include <linux/omap-dma.h>
-#endif
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
@@ -43,12 +39,6 @@
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-#include <plat/cpu.h>
-#include <plat/dma.h>
-#include <mach/irqs.h>
-#endif
-
 #define SHA_REG_DIGEST(x)		(0x00 + ((x) * 0x04))
 #define SHA_REG_DIN(x)			(0x1C + ((x) * 0x04))
 
@@ -120,9 +110,7 @@ struct omap_sham_reqctx {
 
 	/* walk state */
 	struct scatterlist	*sg;
-#ifndef OMAP_SHAM_DMA_PRIVATE
 	struct scatterlist	sgl;
-#endif
 	unsigned int		offset;	/* offset in current sg */
 	unsigned int		total;	/* total request */
 
@@ -156,12 +144,7 @@ struct omap_sham_dev {
 	int			irq;
 	spinlock_t		lock;
 	int			err;
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	int			dma;
-	int			dma_lch;
-#else
 	struct dma_chan		*dma_lch;
-#endif
 	struct tasklet_struct	done_task;
 
 	unsigned long		flags;
@@ -329,7 +312,6 @@ static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 	return -EINPROGRESS;
 }
 
-#ifndef OMAP_SHAM_DMA_PRIVATE
 static void omap_sham_dma_callback(void *param)
 {
 	struct omap_sham_dev *dd = param;
@@ -337,34 +319,18 @@ static void omap_sham_dma_callback(void *param)
 	set_bit(FLAGS_DMA_READY, &dd->flags);
 	tasklet_schedule(&dd->done_task);
 }
-#endif
 
 static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 			      size_t length, int final, int is_sg)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	int len32;
-#else
 	struct dma_async_tx_descriptor *tx;
 	struct dma_slave_config cfg;
 	int ret;
-#endif
 
 	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
 						ctx->digcnt, length, final);
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	len32 = DIV_ROUND_UP(length, sizeof(u32));
-
-	omap_set_dma_transfer_params(dd->dma_lch, OMAP_DMA_DATA_TYPE_S32, len32,
-			1, OMAP_DMA_SYNC_PACKET, dd->dma,
-				OMAP_DMA_DST_SYNC_PREFETCH);
-
-	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
-				dma_addr, 0, 0);
-
-#else
 	memset(&cfg, 0, sizeof(cfg));
 
 	cfg.dst_addr = dd->phys_base + SHA_REG_DIN(0);
@@ -404,7 +370,6 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 
 	tx->callback = omap_sham_dma_callback;
 	tx->callback_param = dd;
-#endif
 
 	omap_sham_write_ctrl(dd, length, final, 1);
 
@@ -415,12 +380,8 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 
 	set_bit(FLAGS_DMA_ACTIVE, &dd->flags);
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	omap_start_dma(dd->dma_lch);
-#else
 	dmaengine_submit(tx);
 	dma_async_issue_pending(dd->dma_lch);
-#endif
 
 	return -EINPROGRESS;
 }
@@ -526,7 +487,6 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	if (ctx->bufcnt || ctx->offset)
 		return omap_sham_update_dma_slow(dd);
 
-#ifndef OMAP_SHAM_DMA_PRIVATE
 	/*
 	 * Don't use the sg interface when the transfer size is less
 	 * than the number of elements in a DMA frame.  Otherwise,
@@ -535,7 +495,6 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	 */
 	if (ctx->total < (DST_MAXBURST * sizeof(u32)))
 		return omap_sham_update_dma_slow(dd);
-#endif
 
 	dev_dbg(dd->dev, "fast: digcnt: %d, bufcnt: %u, total: %u\n",
 			ctx->digcnt, ctx->bufcnt, ctx->total);
@@ -597,11 +556,7 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	omap_stop_dma(dd->dma_lch);
-#else
 	dmaengine_terminate_all(dd->dma_lch);
-#endif
 
 	if (ctx->flags & BIT(FLAGS_SG)) {
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
@@ -803,18 +758,6 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	if (err)
 		goto err1;
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	omap_set_dma_dest_params(dd->dma_lch, 0,
-			OMAP_DMA_AMODE_CONSTANT,
-			dd->phys_base + SHA_REG_DIN(0), 0, 16);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_16);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_4);
-#endif
-
 	if (ctx->digcnt)
 		/* request has changed - restore hash */
 		omap_sham_copy_hash(req, 0);
@@ -1205,55 +1148,13 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-static void omap_sham_dma_callback(int lch, u16 ch_status, void *data)
-{
-	struct omap_sham_dev *dd = data;
-
-	if (ch_status != OMAP_DMA_BLOCK_IRQ) {
-		pr_err("omap-sham DMA error status: 0x%hx\n", ch_status);
-		dd->err = -EIO;
-		clear_bit(FLAGS_INIT, &dd->flags);/* request to re-initialize */
-	}
-
-	set_bit(FLAGS_DMA_READY, &dd->flags);
-	tasklet_schedule(&dd->done_task);
-}
-
-static int omap_sham_dma_init(struct omap_sham_dev *dd)
-{
-	int err;
-
-	dd->dma_lch = -1;
-
-	err = omap_request_dma(dd->dma, dev_name(dd->dev),
-			omap_sham_dma_callback, dd, &dd->dma_lch);
-	if (err) {
-		dev_err(dd->dev, "Unable to request DMA channel\n");
-		return err;
-	}
-
-	return 0;
-}
-
-static void omap_sham_dma_cleanup(struct omap_sham_dev *dd)
-{
-	if (dd->dma_lch >= 0) {
-		omap_free_dma(dd->dma_lch);
-		dd->dma_lch = -1;
-	}
-}
-#endif
-
 static int __devinit omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-#ifndef OMAP_SHAM_DMA_PRIVATE
 	dma_cap_mask_t mask;
 	unsigned dma_chan;
-#endif
 	int err, i, j;
 
 	dd = kzalloc(sizeof(struct omap_sham_dev), GFP_KERNEL);
@@ -1288,11 +1189,7 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		err = -ENODEV;
 		goto res_err;
 	}
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	dd->dma = res->start;
-#else
 	dma_chan = res->start;
-#endif
 
 	/* Get the IRQ */
 	dd->irq = platform_get_irq(pdev,  0);
@@ -1309,11 +1206,6 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		goto res_err;
 	}
 
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	err = omap_sham_dma_init(dd);
-	if (err)
-		goto dma_err;
-#else
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
@@ -1324,7 +1216,6 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		err = -ENXIO;
 		goto dma_err;
 	}
-#endif
 
 	dd->io_base = ioremap(dd->phys_base, SZ_4K);
 	if (!dd->io_base) {
@@ -1358,11 +1249,7 @@ err_algs:
 	iounmap(dd->io_base);
 	pm_runtime_disable(dev);
 io_err:
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	omap_sham_dma_cleanup(dd);
-#else
 	dma_release_channel(dd->dma_lch);
-#endif
 dma_err:
 	if (dd->irq >= 0)
 		free_irq(dd->irq, dd);
@@ -1392,11 +1279,7 @@ static int __devexit omap_sham_remove(struct platform_device *pdev)
 	iounmap(dd->io_base);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-#ifdef OMAP_SHAM_DMA_PRIVATE
-	omap_sham_dma_cleanup(dd);
-#else
 	dma_release_channel(dd->dma_lch);
-#endif
 	if (dd->irq >= 0)
 		free_irq(dd->irq, dd);
 	kfree(dd);
-- 
1.7.12

