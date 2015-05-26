From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 05/13] mmc: omap_hsmmc: Support for deferred
	probing when requesting DMA channels
Date: Tue, 26 May 2015 16:26:00 +0300
Message-ID: <1432646768-12532-6-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ulf Hansson <ulf.hansson@linaro.org>, linux-spi@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org,
 dmaengine@vger.kernel.org, dan.j.williams@intel.com,
 linux-omap@vger.kernel.org, linux-media@vger.kernel.org
To: <vinod.koul@intel.com>, <tony@atomide.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. In case of error, return the error code we received including
-EPROBE_DEFER

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/omap_hsmmc.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 57bb85930f81..d252478391ee 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2088,23 +2088,21 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	host->rx_chan =
-		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						 &rx_req, &pdev->dev, "rx");
+	host->rx_chan = dma_request_slave_channel_compat_reason(mask,
+				omap_dma_filter_fn, &rx_req, &pdev->dev, "rx");
 
-	if (!host->rx_chan) {
+	if (IS_ERR(host->rx_chan)) {
 		dev_err(mmc_dev(host->mmc), "unable to obtain RX DMA engine channel %u\n", rx_req);
-		ret = -ENXIO;
+		ret = PTR_ERR(host->rx_chan);
 		goto err_irq;
 	}
 
-	host->tx_chan =
-		dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						 &tx_req, &pdev->dev, "tx");
+	host->tx_chan = dma_request_slave_channel_compat_reason(mask,
+				omap_dma_filter_fn, &tx_req, &pdev->dev, "tx");
 
-	if (!host->tx_chan) {
+	if (IS_ERR(host->tx_chan)) {
 		dev_err(mmc_dev(host->mmc), "unable to obtain TX DMA engine channel %u\n", tx_req);
-		ret = -ENXIO;
+		ret = PTR_ERR(host->tx_chan);
 		goto err_irq;
 	}
 
@@ -2166,9 +2164,9 @@ err_slot_name:
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
 err_irq:
-	if (host->tx_chan)
+	if (!IS_ERR_OR_NULL(host->tx_chan))
 		dma_release_channel(host->tx_chan);
-	if (host->rx_chan)
+	if (!IS_ERR_OR_NULL(host->rx_chan))
 		dma_release_channel(host->rx_chan);
 	pm_runtime_put_sync(host->dev);
 	pm_runtime_disable(host->dev);
-- 
2.3.5
