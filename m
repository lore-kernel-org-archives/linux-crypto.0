From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 4/4] crypto: omap-sham: Convert to devm_kzalloc()
Date: Fri, 26 Jul 2013 12:29:17 +0530
Message-ID: <1374821957-30141-5-git-send-email-lokeshvutla@ti.com>
References: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
	<herbert@gondor.hengli.com.au>, <rnayak@ti.com>, <nsekhar@ti.com>,
	<joelf@ti.com>, <lokeshvutla@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36602 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab3GZHAD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 03:00:03 -0400
In-Reply-To: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b82b140..ae1ca8b2 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1870,7 +1870,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	int err, i, j;
 	u32 rev;
 
-	dd = kzalloc(sizeof(struct omap_sham_dev), GFP_KERNEL);
+	dd = devm_kzalloc(dev, sizeof(struct omap_sham_dev), GFP_KERNEL);
 	if (dd == NULL) {
 		dev_err(dev, "unable to alloc data struct.\n");
 		err = -ENOMEM;
@@ -1887,12 +1887,12 @@ static int omap_sham_probe(struct platform_device *pdev)
 	err = (dev->of_node) ? omap_sham_get_res_of(dd, dev, &res) :
 			       omap_sham_get_res_pdev(dd, pdev, &res);
 	if (err)
-		goto res_err;
+		goto data_err;
 
 	dd->io_base = devm_ioremap_resource(dev, &res);
 	if (IS_ERR(dd->io_base)) {
 		err = PTR_ERR(dd->io_base);
-		goto res_err;
+		goto data_err;
 	}
 	dd->phys_base = res.start;
 
@@ -1901,7 +1901,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(dev, "unable to request irq %d, err = %d\n",
 			dd->irq, err);
-		goto res_err;
+		goto data_err;
 	}
 
 	dma_cap_zero(mask);
@@ -1913,7 +1913,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 		dev_err(dev, "unable to obtain RX DMA engine channel %u\n",
 			dd->dma);
 		err = -ENXIO;
-		goto res_err;
+		goto data_err;
 	}
 
 	dd->flags |= dd->pdata->flags;
@@ -1951,9 +1951,6 @@ err_algs:
 					&dd->pdata->algs_info[i].algs_list[j]);
 	pm_runtime_disable(dev);
 	dma_release_channel(dd->dma_lch);
-res_err:
-	kfree(dd);
-	dd = NULL;
 data_err:
 	dev_err(dev, "initialization failed.\n");
 
@@ -1978,8 +1975,6 @@ static int omap_sham_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
 	dma_release_channel(dd->dma_lch);
-	kfree(dd);
-	dd = NULL;
 
 	return 0;
 }
-- 
1.7.9.5
