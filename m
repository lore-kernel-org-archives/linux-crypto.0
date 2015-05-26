From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 06/13] mmc: omap: Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:01 +0300
Message-ID: <1432646768-12532-7-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37621 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbbEZN0x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 09:26:53 -0400
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: Jarkko Nikula <jarkko.nikula@bitmer.com>
---
 drivers/mmc/host/omap.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 68dd6c79c378..29238d0fbc24 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1390,20 +1390,32 @@ static int mmc_omap_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
 	if (res)
 		sig = res->start;
-	host->dma_tx = dma_request_slave_channel_compat(mask,
+	host->dma_tx = dma_request_slave_channel_compat_reason(mask,
 				omap_dma_filter_fn, &sig, &pdev->dev, "tx");
-	if (!host->dma_tx)
+	if (IS_ERR(host->dma_tx)) {
+		ret = PTR_ERR(host->dma_tx);
+		if (ret == -EPROBE_DEFER)
+			goto err_free_dma;
+
+		host->dma_tx = NULL;
 		dev_warn(host->dev, "unable to obtain TX DMA engine channel %u\n",
 			sig);
+	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
 	if (res)
 		sig = res->start;
-	host->dma_rx = dma_request_slave_channel_compat(mask,
+	host->dma_rx = dma_request_slave_channel_compat_reason(mask,
 				omap_dma_filter_fn, &sig, &pdev->dev, "rx");
-	if (!host->dma_rx)
+	if (IS_ERR(host->dma_rx)) {
+		ret = PTR_ERR(host->dma_rx);
+		if (ret == -EPROBE_DEFER)
+			goto err_free_dma;
+
+		host->dma_rx = NULL;
 		dev_warn(host->dev, "unable to obtain RX DMA engine channel %u\n",
 			sig);
+	}
 
 	ret = request_irq(host->irq, mmc_omap_irq, 0, DRIVER_NAME, host);
 	if (ret)
-- 
2.3.5
