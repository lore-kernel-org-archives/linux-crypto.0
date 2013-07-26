From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 3/4] crypto: omap-sham: Convert to devm_request_irq()
Date: Fri, 26 Jul 2013 12:29:16 +0530
Message-ID: <1374821957-30141-4-git-send-email-lokeshvutla@ti.com>
References: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
	<herbert@gondor.hengli.com.au>, <rnayak@ti.com>, <nsekhar@ti.com>,
	<joelf@ti.com>, <lokeshvutla@ti.com>
To: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40392 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3GZG77 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jul 2013 02:59:59 -0400
In-Reply-To: <1374821957-30141-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using devm_request_irq() rather than request_irq().
So removing free_irq() calls from the probe error
path and the remove handler.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a6eb6a8..b82b140 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1896,10 +1896,11 @@ static int omap_sham_probe(struct platform_device *pdev)
 	}
 	dd->phys_base = res.start;
 
-	err = request_irq(dd->irq, dd->pdata->intr_hdlr, IRQF_TRIGGER_LOW,
-			  dev_name(dev), dd);
+	err = devm_request_irq(dev, dd->irq, dd->pdata->intr_hdlr,
+			       IRQF_TRIGGER_NONE, dev_name(dev), dd);
 	if (err) {
-		dev_err(dev, "unable to request irq.\n");
+		dev_err(dev, "unable to request irq %d, err = %d\n",
+			dd->irq, err);
 		goto res_err;
 	}
 
@@ -1912,7 +1913,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 		dev_err(dev, "unable to obtain RX DMA engine channel %u\n",
 			dd->dma);
 		err = -ENXIO;
-		goto dma_err;
+		goto res_err;
 	}
 
 	dd->flags |= dd->pdata->flags;
@@ -1950,8 +1951,6 @@ err_algs:
 					&dd->pdata->algs_info[i].algs_list[j]);
 	pm_runtime_disable(dev);
 	dma_release_channel(dd->dma_lch);
-dma_err:
-	free_irq(dd->irq, dd);
 res_err:
 	kfree(dd);
 	dd = NULL;
@@ -1979,7 +1978,6 @@ static int omap_sham_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
 	dma_release_channel(dd->dma_lch);
-	free_irq(dd->irq, dd);
 	kfree(dd);
 	dd = NULL;
 
-- 
1.7.9.5
