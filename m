From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 04/13] mmc: omap_hsmmc: No need to check DMA
	channel validity at module remove
Date: Tue, 26 May 2015 16:25:59 +0300
Message-ID: <1432646768-12532-5-git-send-email-peter.ujfalusi@ti.com>
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

The driver will not probe without valid DMA channels so no need to check
if they are valid when the module is removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/omap_hsmmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 2cd828f42151..57bb85930f81 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2190,10 +2190,8 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
 
-	if (host->tx_chan)
-		dma_release_channel(host->tx_chan);
-	if (host->rx_chan)
-		dma_release_channel(host->rx_chan);
+	dma_release_channel(host->tx_chan);
+	dma_release_channel(host->rx_chan);
 
 	pm_runtime_put_sync(host->dev);
 	pm_runtime_disable(host->dev);
-- 
2.3.5
