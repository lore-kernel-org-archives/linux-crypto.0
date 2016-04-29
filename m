From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH] crypto: omap-sham: Use dma_request_chan() for requesting DMA channel
Date: Fri, 29 Apr 2016 16:03:41 +0300
Message-ID: <1461935021-28506-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, <t-kristo@ti.com>,
	<lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59941 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbcD2NEc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 09:04:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With the new dma_request_chan() the client driver does not need to look for
the DMA resource and it does not need to pass filter_fn anymore.
By switching to the new API the driver can now support deferred probing
against DMA.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 48adb2a0903e..6eefaa2fe58f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -29,7 +29,6 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
-#include <linux/omap-dma.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -219,7 +218,6 @@ struct omap_sham_dev {
 	int			irq;
 	spinlock_t		lock;
 	int			err;
-	unsigned int		dma;
 	struct dma_chan		*dma_lch;
 	struct tasklet_struct	done_task;
 	u8			polling_mode;
@@ -1842,7 +1840,6 @@ static int omap_sham_get_res_of(struct omap_sham_dev *dd,
 		goto err;
 	}
 
-	dd->dma = -1; /* Dummy value that's unused */
 	dd->pdata = match->data;
 
 err:
@@ -1884,15 +1881,6 @@ static int omap_sham_get_res_pdev(struct omap_sham_dev *dd,
 		goto err;
 	}
 
-	/* Get the DMA */
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r) {
-		dev_err(dev, "no DMA resource info\n");
-		err = -ENODEV;
-		goto err;
-	}
-	dd->dma = r->start;
-
 	/* Only OMAP2/3 can be non-DT */
 	dd->pdata = &omap_sham_pdata_omap2;
 
@@ -1946,9 +1934,12 @@ static int omap_sham_probe(struct platform_device *pdev)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dd->dma_lch = dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						       &dd->dma, dev, "rx");
-	if (!dd->dma_lch) {
+	dd->dma_lch = dma_request_chan(dev, "rx");
+	if (IS_ERR(dd->dma_lch)) {
+		err = PTR_ERR(dd->dma_lch);
+		if (err == -EPROBE_DEFER)
+			goto data_err;
+
 		dd->polling_mode = 1;
 		dev_dbg(dev, "using polling mode instead of dma\n");
 	}
@@ -1995,7 +1986,7 @@ err_algs:
 					&dd->pdata->algs_info[i].algs_list[j]);
 err_pm:
 	pm_runtime_disable(dev);
-	if (dd->dma_lch)
+	if (dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
 data_err:
 	dev_err(dev, "initialization failed.\n");
@@ -2021,7 +2012,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
 
-	if (dd->dma_lch)
+	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
 
 	return 0;
-- 
2.8.1
