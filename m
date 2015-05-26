From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 10/13] crypto: omap-sham - Support for deferred probing when requesting DMA channel
Date: Tue, 26 May 2015 16:26:05 +0300
Message-ID: <1432646768-12532-11-git-send-email-peter.ujfalusi@ti.com>
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
channel. Only fall back to polling mode if the error code returned is not
-EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b2024c95a3cf..66bae8288741 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1946,9 +1946,14 @@ static int omap_sham_probe(struct platform_device *pdev)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	dd->dma_lch = dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
-						       &dd->dma, dev, "rx");
-	if (!dd->dma_lch) {
+	dd->dma_lch = dma_request_slave_channel_compat_reason(mask,
+						omap_dma_filter_fn,
+						&dd->dma, dev, "rx");
+	if (IS_ERR(dd->dma_lch)) {
+		err = PTR_ERR(dd->dma_lch);
+		if (err == -EPROBE_DEFER)
+			goto data_err;
+
 		dd->polling_mode = 1;
 		dev_dbg(dev, "using polling mode instead of dma\n");
 	}
@@ -1995,7 +2000,7 @@ err_algs:
 					&dd->pdata->algs_info[i].algs_list[j]);
 err_pm:
 	pm_runtime_disable(dev);
-	if (dd->dma_lch)
+	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
 data_err:
 	dev_err(dev, "initialization failed.\n");
@@ -2021,7 +2026,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	pm_runtime_disable(&pdev->dev);
 
-	if (dd->dma_lch)
+	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
 
 	return 0;
-- 
2.3.5
