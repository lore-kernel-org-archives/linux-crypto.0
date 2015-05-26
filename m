From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 09/13] crypto: omap-des - Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:04 +0300
Message-ID: <1432646768-12532-10-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Lokesh Vutla <lokeshvutla-l0cyMroinI0@public.gmane.org>
To: <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
CC: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
CC: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
CC: Lokesh Vutla <lokeshvutla-l0cyMroinI0@public.gmane.org>
---
 drivers/crypto/omap-des.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 46307098f8ba..06be02f520da 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -340,7 +340,7 @@ static void omap_des_dma_out_callback(void *data)
 
 static int omap_des_dma_init(struct omap_des_dev *dd)
 {
-	int err = -ENOMEM;
+	int err;
 	dma_cap_mask_t mask;
 
 	dd->dma_lch_out = NULL;
@@ -349,21 +349,20 @@ static int omap_des_dma_init(struct omap_des_dev *dd)
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
 
@@ -371,14 +370,15 @@ static int omap_des_dma_init(struct omap_des_dev *dd)
 
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
@@ -1110,7 +1110,9 @@ static int omap_des_probe(struct platform_device *pdev)
 	tasklet_init(&dd->queue_task, omap_des_queue_task, (unsigned long)dd);
 
 	err = omap_des_dma_init(dd);
-	if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
+	if (err == -EPROBE_DEFER) {
+		goto err_irq;
+	} else if (err && DES_REG_IRQ_STATUS(dd) && DES_REG_IRQ_ENABLE(dd)) {
 		dd->pio_only = 1;
 
 		irq = platform_get_irq(pdev, 0);
@@ -1154,8 +1156,8 @@ err_algs:
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
2.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
