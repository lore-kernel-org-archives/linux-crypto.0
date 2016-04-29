From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] crypto: omap-des: Use dma_request_chan() for requesting DMA channel
Date: Fri, 29 Apr 2016 16:02:56 +0300
Message-ID: <1461934976-28391-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, <t-kristo@ti.com>,
	<lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

With the new dma_request_chan() the client driver does not need to look for
the DMA resource and it does not need to pass filter_fn anymore.
By switching to the new API the driver can now support deferred probing
against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-des.c | 68 ++++++++++++-----------------------------------
 1 file changed, 17 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index dd7b93f2f94c..1f48b6d0738c 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -29,7 +29,6 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
-#include <linux/omap-dma.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -158,9 +157,7 @@ struct omap_des_dev {
 
 	struct scatter_walk		in_walk;
 	struct scatter_walk		out_walk;
-	int			dma_in;
 	struct dma_chan		*dma_lch_in;
-	int			dma_out;
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
@@ -340,30 +337,21 @@ static void omap_des_dma_out_callback(void *data)
 
 static int omap_des_dma_init(struct omap_des_dev *dd)
 {
-	int err = -ENOMEM;
-	dma_cap_mask_t mask;
+	int err;
 
 	dd->dma_lch_out = NULL;
 	dd->dma_lch_in = NULL;
 
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-
-	dd->dma_lch_in = dma_request_slave_channel_compat(mask,
-							  omap_dma_filter_fn,
-							  &dd->dma_in,
-							  dd->dev, "rx");
-	if (!dd->dma_lch_in) {
+	dd->dma_lch_in = dma_request_chan(dd->dev, "rx");
+	if (IS_ERR(dd->dma_lch_in)) {
 		dev_err(dd->dev, "Unable to request in DMA channel\n");
-		goto err_dma_in;
+		return PTR_ERR(dd->dma_lch_in);
 	}
 
-	dd->dma_lch_out = dma_request_slave_channel_compat(mask,
-							   omap_dma_filter_fn,
-							   &dd->dma_out,
-							   dd->dev, "tx");
-	if (!dd->dma_lch_out) {
+	dd->dma_lch_out = dma_request_chan(dd->dev, "tx");
+	if (IS_ERR(dd->dma_lch_out)) {
 		dev_err(dd->dev, "Unable to request out DMA channel\n");
+		err = PTR_ERR(dd->dma_lch_out);
 		goto err_dma_out;
 	}
 
@@ -371,14 +359,15 @@ static int omap_des_dma_init(struct omap_des_dev *dd)
 
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in);
-err_dma_in:
-	if (err)
-		pr_err("error: %d\n", err);
+
 	return err;
 }
 
 static void omap_des_dma_cleanup(struct omap_des_dev *dd)
 {
+	if (dd->pio_only)
+		return;
+
 	dma_release_channel(dd->dma_lch_out);
 	dma_release_channel(dd->dma_lch_in);
 }
@@ -999,8 +988,6 @@ static int omap_des_get_of(struct omap_des_dev *dd,
 		return -EINVAL;
 	}
 
-	dd->dma_out = -1; /* Dummy value that's unused */
-	dd->dma_in = -1; /* Dummy value that's unused */
 	dd->pdata = match->data;
 
 	return 0;
@@ -1016,33 +1003,10 @@ static int omap_des_get_of(struct omap_des_dev *dd,
 static int omap_des_get_pdev(struct omap_des_dev *dd,
 		struct platform_device *pdev)
 {
-	struct device *dev = &pdev->dev;
-	struct resource *r;
-	int err = 0;
-
-	/* Get the DMA out channel */
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r) {
-		dev_err(dev, "no DMA out resource info\n");
-		err = -ENODEV;
-		goto err;
-	}
-	dd->dma_out = r->start;
-
-	/* Get the DMA in channel */
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r) {
-		dev_err(dev, "no DMA in resource info\n");
-		err = -ENODEV;
-		goto err;
-	}
-	dd->dma_in = r->start;
-
 	/* non-DT devices get pdata from pdev */
 	dd->pdata = pdev->dev.platform_data;
 
-err:
-	return err;
+	return 0;
 }
 
 static int omap_des_probe(struct platform_device *pdev)
@@ -1106,7 +1070,9 @@ static int omap_des_probe(struct platform_device *pdev)
 	tasklet_init(&dd->queue_task, omap_des_queue_task, (unsigned long)dd);
 
 	err = omap_des_dma_init(dd);
-	if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
+	if (err == -EPROBE_DEFER) {
+		goto err_irq;
+	} else if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
 		dd->pio_only = 1;
 
 		irq = platform_get_irq(pdev, 0);
@@ -1150,8 +1116,8 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	if (!dd->pio_only)
-		omap_des_dma_cleanup(dd);
+
+	omap_des_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
-- 
2.8.1
