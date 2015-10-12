From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: ux500: Use devm_xxx() managed function
Date: Mon, 12 Oct 2015 19:47:04 +0200
Message-ID: <1444672025-21757-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1444672025-21757-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	asaf.vertz@tandemg.com, clabbe.montjoie@gmail.com,
	cristian.stoica@freescale.com, geert+renesas@glider.be,
	keescook@chromium.org, maxime.ripard@free-electrons.com,
	ulf.hansson@linaro.org, vinod.koul@intel.com, wsa@the-dreams.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444672025-21757-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Using the devm_xxx() managed function to stripdown the error
and remove code.
In the same time, we replace request_mem_region/ioremap by the unified
devm_ioremap_resource() function.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 70 +++++------------------------------
 drivers/crypto/ux500/hash/hash_core.c | 49 ++++--------------------
 2 files changed, 16 insertions(+), 103 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index fded0a5..1c1bd10 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1414,7 +1414,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	dev_dbg(dev, "[%s]", __func__);
-	device_data = kzalloc(sizeof(struct cryp_device_data), GFP_ATOMIC);
+	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_ATOMIC);
 	if (!device_data) {
 		dev_err(dev, "[%s]: kzalloc() failed!", __func__);
 		ret = -ENOMEM;
@@ -1435,23 +1435,15 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		dev_err(dev, "[%s]: platform_get_resource() failed",
 				__func__);
 		ret = -ENODEV;
-		goto out_kfree;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL) {
-		dev_err(dev, "[%s]: request_mem_region() failed",
-				__func__);
-		ret = -EBUSY;
-		goto out_kfree;
+		goto out;
 	}
 
 	device_data->phybase = res->start;
-	device_data->base = ioremap(res->start, resource_size(res));
+	device_data->base = devm_ioremap_resource(dev, res);
 	if (!device_data->base) {
 		dev_err(dev, "[%s]: ioremap failed!", __func__);
 		ret = -ENOMEM;
-		goto out_free_mem;
+		goto out;
 	}
 
 	spin_lock_init(&device_data->ctx_lock);
@@ -1463,11 +1455,11 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		dev_err(dev, "[%s]: could not get cryp regulator", __func__);
 		ret = PTR_ERR(device_data->pwr_regulator);
 		device_data->pwr_regulator = NULL;
-		goto out_unmap;
+		goto out;
 	}
 
 	/* Enable the clk for CRYP hardware block */
-	device_data->clk = clk_get(&pdev->dev, NULL);
+	device_data->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(device_data->clk)) {
 		dev_err(dev, "[%s]: clk_get() failed!", __func__);
 		ret = PTR_ERR(device_data->clk);
@@ -1477,7 +1469,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	ret = clk_prepare(device_data->clk);
 	if (ret) {
 		dev_err(dev, "[%s]: clk_prepare() failed!", __func__);
-		goto out_clk;
+		goto out_regulator;
 	}
 
 	/* Enable device power (and clock) */
@@ -1510,11 +1502,8 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_power;
 	}
 
-	ret = request_irq(res_irq->start,
-			  cryp_interrupt_handler,
-			  0,
-			  "cryp1",
-			  device_data);
+	ret = devm_request_irq(&pdev->dev, res_irq->start,
+			       cryp_interrupt_handler, 0, "cryp1", device_data);
 	if (ret) {
 		dev_err(dev, "[%s]: Unable to request IRQ", __func__);
 		goto out_power;
@@ -1550,28 +1539,15 @@ out_power:
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
 
-out_clk:
-	clk_put(device_data->clk);
-
 out_regulator:
 	regulator_put(device_data->pwr_regulator);
 
-out_unmap:
-	iounmap(device_data->base);
-
-out_free_mem:
-	release_mem_region(res->start, resource_size(res));
-
-out_kfree:
-	kfree(device_data);
 out:
 	return ret;
 }
 
 static int ux500_cryp_remove(struct platform_device *pdev)
 {
-	struct resource *res = NULL;
-	struct resource *res_irq = NULL;
 	struct cryp_device_data *device_data;
 
 	dev_dbg(&pdev->dev, "[%s]", __func__);
@@ -1607,37 +1583,18 @@ static int ux500_cryp_remove(struct platform_device *pdev)
 	if (list_empty(&driver_data.device_list.k_list))
 		cryp_algs_unregister_all();
 
-	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res_irq)
-		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
-			__func__);
-	else {
-		disable_irq(res_irq->start);
-		free_irq(res_irq->start, device_data);
-	}
-
 	if (cryp_disable_power(&pdev->dev, device_data, false))
 		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
 			__func__);
 
 	clk_unprepare(device_data->clk);
-	clk_put(device_data->clk);
 	regulator_put(device_data->pwr_regulator);
 
-	iounmap(device_data->base);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-
-	kfree(device_data);
-
 	return 0;
 }
 
 static void ux500_cryp_shutdown(struct platform_device *pdev)
 {
-	struct resource *res_irq = NULL;
 	struct cryp_device_data *device_data;
 
 	dev_dbg(&pdev->dev, "[%s]", __func__);
@@ -1673,15 +1630,6 @@ static void ux500_cryp_shutdown(struct platform_device *pdev)
 	if (list_empty(&driver_data.device_list.k_list))
 		cryp_algs_unregister_all();
 
-	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res_irq)
-		dev_err(&pdev->dev, "[%s]: IORESOURCE_IRQ, unavailable",
-			__func__);
-	else {
-		disable_irq(res_irq->start);
-		free_irq(res_irq->start, device_data);
-	}
-
 	if (cryp_disable_power(&pdev->dev, device_data, false))
 		dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
 			__func__);
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5f5f360..8b9391f 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1657,7 +1657,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	struct hash_device_data *device_data;
 	struct device		*dev = &pdev->dev;
 
-	device_data = kzalloc(sizeof(*device_data), GFP_ATOMIC);
+	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_ATOMIC);
 	if (!device_data) {
 		ret = -ENOMEM;
 		goto out;
@@ -1670,22 +1670,15 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_dbg(dev, "%s: platform_get_resource() failed!\n", __func__);
 		ret = -ENODEV;
-		goto out_kfree;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL) {
-		dev_dbg(dev, "%s: request_mem_region() failed!\n", __func__);
-		ret = -EBUSY;
-		goto out_kfree;
+		goto out;
 	}
 
 	device_data->phybase = res->start;
-	device_data->base = ioremap(res->start, resource_size(res));
+	device_data->base = devm_ioremap_resource(dev, res);
 	if (!device_data->base) {
 		dev_err(dev, "%s: ioremap() failed!\n", __func__);
 		ret = -ENOMEM;
-		goto out_free_mem;
+		goto out;
 	}
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
@@ -1696,11 +1689,11 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->regulator);
 		device_data->regulator = NULL;
-		goto out_unmap;
+		goto out;
 	}
 
 	/* Enable the clock for HASH1 hardware block */
-	device_data->clk = clk_get(dev, NULL);
+	device_data->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
 		dev_err(dev, "%s: clk_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->clk);
@@ -1710,7 +1703,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	ret = clk_prepare(device_data->clk);
 	if (ret) {
 		dev_err(dev, "%s: clk_prepare() failed!\n", __func__);
-		goto out_clk;
+		goto out_regulator;
 	}
 
 	/* Enable device power (and clock) */
@@ -1752,20 +1745,9 @@ out_power:
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
 
-out_clk:
-	clk_put(device_data->clk);
-
 out_regulator:
 	regulator_put(device_data->regulator);
 
-out_unmap:
-	iounmap(device_data->base);
-
-out_free_mem:
-	release_mem_region(res->start, resource_size(res));
-
-out_kfree:
-	kfree(device_data);
 out:
 	return ret;
 }
@@ -1776,7 +1758,6 @@ out:
  */
 static int ux500_hash_remove(struct platform_device *pdev)
 {
-	struct resource		*res;
 	struct hash_device_data *device_data;
 	struct device		*dev = &pdev->dev;
 
@@ -1816,17 +1797,8 @@ static int ux500_hash_remove(struct platform_device *pdev)
 			__func__);
 
 	clk_unprepare(device_data->clk);
-	clk_put(device_data->clk);
 	regulator_put(device_data->regulator);
 
-	iounmap(device_data->base);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-
-	kfree(device_data);
-
 	return 0;
 }
 
@@ -1836,7 +1808,6 @@ static int ux500_hash_remove(struct platform_device *pdev)
  */
 static void ux500_hash_shutdown(struct platform_device *pdev)
 {
-	struct resource *res = NULL;
 	struct hash_device_data *device_data;
 
 	device_data = platform_get_drvdata(pdev);
@@ -1870,12 +1841,6 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 	if (list_empty(&driver_data.device_list.k_list))
 		ahash_algs_unregister_all(device_data);
 
-	iounmap(device_data->base);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-
 	if (hash_disable_power(device_data, false))
 		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
 			__func__);
-- 
2.4.9
