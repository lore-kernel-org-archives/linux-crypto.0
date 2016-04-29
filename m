From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] crypto: omap-aes: Use dma_request_chan() for requesting DMA channel
Date: Fri, 29 Apr 2016 16:02:18 +0300
Message-ID: <1461934938-28297-1-git-send-email-peter.ujfalusi@ti.com>
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
 drivers/crypto/omap-aes.c | 62 ++++++++++++-----------------------------------
 1 file changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d420ec751c7c..ce174d3b842c 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -26,7 +26,6 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
-#include <linux/omap-dma.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -176,9 +175,7 @@ struct omap_aes_dev {
 
 	struct scatter_walk		in_walk;
 	struct scatter_walk		out_walk;
-	int			dma_in;
 	struct dma_chan		*dma_lch_in;
-	int			dma_out;
 	struct dma_chan		*dma_lch_out;
 	int			in_sg_len;
 	int			out_sg_len;
@@ -351,30 +348,21 @@ static void omap_aes_dma_out_callback(void *data)
 
 static int omap_aes_dma_init(struct omap_aes_dev *dd)
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
 
@@ -382,14 +370,15 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in);
-err_dma_in:
-	if (err)
-		pr_err("error: %d\n", err);
+
 	return err;
 }
 
 static void omap_aes_dma_cleanup(struct omap_aes_dev *dd)
 {
+	if (dd->pio_only)
+		return;
+
 	dma_release_channel(dd->dma_lch_out);
 	dma_release_channel(dd->dma_lch_in);
 }
@@ -1080,9 +1069,6 @@ static int omap_aes_get_res_of(struct omap_aes_dev *dd,
 		goto err;
 	}
 
-	dd->dma_out = -1; /* Dummy value that's unused */
-	dd->dma_in = -1; /* Dummy value that's unused */
-
 	dd->pdata = match->data;
 
 err:
@@ -1116,24 +1102,6 @@ static int omap_aes_get_res_pdev(struct omap_aes_dev *dd,
 	}
 	memcpy(res, r, sizeof(*res));
 
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
 	/* Only OMAP2/3 can be non-DT */
 	dd->pdata = &omap_aes_pdata_omap2;
 
@@ -1191,7 +1159,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
 
 	err = omap_aes_dma_init(dd);
-	if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
+	if (err == -EPROBE_DEFER) {
+		goto err_irq;
+	} else if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
 		dd->pio_only = 1;
 
 		irq = platform_get_irq(pdev, 0);
@@ -1248,8 +1218,8 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	if (!dd->pio_only)
-		omap_aes_dma_cleanup(dd);
+
+	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(dev);
-- 
2.8.1
