From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 11/13] spi: omap2-mcspi: Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:06 +0300
Message-ID: <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>, Mark Brown <broonie@kernel.org>
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. Only fall back to pio mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index a7d85c5ab2fa..e6ff937688ff 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -948,6 +948,7 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 	struct omap2_mcspi_dma	*mcspi_dma;
 	dma_cap_mask_t mask;
 	unsigned sig;
+	int ret = 0;
 
 	mcspi = spi_master_get_devdata(master);
 	mcspi_dma = mcspi->dma_channels + spi->chip_select;
@@ -959,30 +960,35 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
 	dma_cap_set(DMA_SLAVE, mask);
 	sig = mcspi_dma->dma_rx_sync_dev;
 
-	mcspi_dma->dma_rx =
-		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						 &sig, &master->dev,
-						 mcspi_dma->dma_rx_ch_name);
-	if (!mcspi_dma->dma_rx)
+	mcspi_dma->dma_rx = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &sig, &master->dev,
+					mcspi_dma->dma_rx_ch_name);
+	if (IS_ERR(mcspi_dma->dma_rx)) {
+		ret = PTR_ERR(mcspi_dma->dma_rx);
+		mcspi_dma->dma_rx = NULL;
+		if (ret != -EPROBE_DEFER)
+			ret = -EAGAIN;
 		goto no_dma;
+	}
 
 	sig = mcspi_dma->dma_tx_sync_dev;
-	mcspi_dma->dma_tx =
-		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						 &sig, &master->dev,
-						 mcspi_dma->dma_tx_ch_name);
+	mcspi_dma->dma_tx = dma_request_slave_channel_compat_reason(mask,
+					omap_dma_filter_fn, &sig, &master->dev,
+					mcspi_dma->dma_tx_ch_name);
 
-	if (!mcspi_dma->dma_tx) {
+	if (IS_ERR(mcspi_dma->dma_tx)) {
+		ret = PTR_ERR(mcspi_dma->dma_tx);
+		mcspi_dma->dma_tx = NULL;
 		dma_release_channel(mcspi_dma->dma_rx);
 		mcspi_dma->dma_rx = NULL;
-		goto no_dma;
+		if (ret != -EPROBE_DEFER)
+			ret = -EAGAIN;
 	}
 
-	return 0;
-
 no_dma:
-	dev_warn(&spi->dev, "not using DMA for McSPI\n");
-	return -EAGAIN;
+	if (ret && ret != -EPROBE_DEFER)
+		dev_warn(&spi->dev, "not using DMA for McSPI\n");
+	return ret;
 }
 
 static int omap2_mcspi_setup(struct spi_device *spi)
-- 
2.3.5
