From: Nishanth Menon <nm@ti.com>
Subject: [PATCH] crypto: omap-des - handle error of pm_runtime_get_sync
Date: Tue, 15 Apr 2014 10:33:02 -0500
Message-ID: <1397575982-24866-1-git-send-email-nm@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	Joachim Eastwood <manabian@gmail.com>,
	Nishanth Menon <nm@ti.com>
To: Joel Fernandes <joelf@ti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-omap-owner@vger.kernel.org>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pm_runtime_get_sync may not always succeed depending on SoC involved. So
handle the error appropriately.

Reported-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

based on v3.15-rc1

Report-thread: http://marc.info/?t=139750330400002&r=1&w=2

omap2plus_defconfig + CONFIG_CRYPTO_DEV_OMAP_DES=y

pandaboard-es-before: http://slexy.org/raw/s21rGPFnKl
pandaboard-es-after:  http://slexy.org/raw/s2A4UFQVna

 drivers/crypto/omap-des.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ec5f131..c2d362f 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -223,12 +223,18 @@ static void omap_des_write_n(struct omap_des_dev *dd, u32 offset,
 
 static int omap_des_hw_init(struct omap_des_dev *dd)
 {
+	int err;
+
 	/*
 	 * clocks are enabled when request starts and disabled when finished.
 	 * It may be long delays between requests.
 	 * Device might go to off mode to save power.
 	 */
-	pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_get_sync(dd->dev);
+	if (err < 0) {
+		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
+		return err;
+	}
 
 	if (!(dd->flags & FLAGS_INIT)) {
 		dd->flags |= FLAGS_INIT;
@@ -1083,7 +1089,11 @@ static int omap_des_probe(struct platform_device *pdev)
 	dd->phys_base = res->start;
 
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+	err = pm_runtime_get_sync(dev);
+	if (err < 0) {
+		dev_err(dd->dev, "failed to get_sync(%d)\n", err);
+		goto err_get;
+	}
 
 	omap_des_dma_stop(dd);
 
@@ -1148,6 +1158,7 @@ err_algs:
 err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
+err_get:
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
@@ -1191,8 +1202,7 @@ static int omap_des_suspend(struct device *dev)
 
 static int omap_des_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
-	return 0;
+	return pm_runtime_get_sync(dev);
 }
 #endif
 
-- 
1.7.9.5

