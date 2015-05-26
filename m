From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 08/13] crypto: omap-aes - Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:03 +0300
Message-ID: <1432646768-12532-9-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Lokesh Vutla <lokeshvutla@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9a28b7e07c71..699a14509adb 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -356,7 +356,7 @@ static void omap_aes_dma_out_callback(void *data)
 
 static int omap_aes_dma_init(struct omap_aes_dev *dd)
 {
-	int err = -ENOMEM;
+	int err;
 	dma_cap_mask_t mask;
 
 	dd->dma_lch_out = NULL;
@@ -365,21 +365,20 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dd->dma_lch_in = dma_request_slave_channel_compat(mask,
-							  omap_dma_filter_fn,
-							  &dd->dma_in,
-							  dd->dev, "rx");
-	if (!dd->dma_lch_in) {
+	dd->dma_lch_in = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &dd->dma_in,
+					dd->dev, "rx");
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
+	dd->dma_lch_out = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &dd->dma_out,
+					dd->dev, "tx");
+	if (IS_ERR(dd->dma_lch_out)) {
 		dev_err(dd->dev, "Unable to request out DMA channel\n");
+		err = PTR_ERR(dd->dma_lch_out);
 		goto err_dma_out;
 	}
 
@@ -387,14 +386,15 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 
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
@@ -1218,7 +1218,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	tasklet_init(&dd->queue_task, omap_aes_queue_task, (unsigned long)dd);
 
 	err = omap_aes_dma_init(dd);
-	if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
+	if (err == -EPROBE_DEFER) {
+		goto err_irq;
+	} else if (err && AES_REG_IRQ_STATUS(dd) && AES_REG_IRQ_ENABLE(dd)) {
 		dd->pio_only = 1;
 
 		irq = platform_get_irq(pdev, 0);
@@ -1262,8 +1264,8 @@ err_algs:
 		for (j = dd->pdata->algs_info[i].registered - 1; j >= 0; j--)
 			crypto_unregister_alg(
 					&dd->pdata->algs_info[i].algs_list[j]);
-	if (!dd->pio_only)
-		omap_aes_dma_cleanup(dd);
+
+	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
-- 
2.3.5
