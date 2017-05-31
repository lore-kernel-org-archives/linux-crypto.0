From: <sean.wang@mediatek.com>
Subject: [PATCH 3/4] hwrng: mtk - add runtime PM support
Date: Thu, 1 Jun 2017 02:44:15 +0800
Message-ID: <efd8922452cbac89938309bdf25a5f41d8d48b3f.1496255334.git.sean.wang@mediatek.com>
References: <cover.1496255334.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1@huawei.com>, <devicetree@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
To: <herbert@gondor.apana.org.au>, <mpm@selenic.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <clabbe.montjoie@gmail.com>, <prasannatsmkumar@gmail.com>,
        <romain.perier@free-electrons.com>, <shannon.nelson@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1496255334.git.sean.wang@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Add runtime PM support.  There will be the benefit on SoCs where the
clock to the RNG used can be shutdown.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/char/hw_random/mtk-rng.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 3a1e1f1..59ded4e 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -25,6 +25,10 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+/* Runtime PM autosuspend timeout: */
+#define RNG_AUTOSUSPEND_TIMEOUT		100
 
 #define USEC_POLL			2
 #define TIMEOUT_POLL			20
@@ -90,6 +94,8 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	struct mtk_rng *priv = to_mtk_rng(rng);
 	int retval = 0;
 
+	pm_runtime_get_sync((struct device *)priv->rng.priv);
+
 	while (max >= sizeof(u32)) {
 		if (!mtk_rng_wait_ready(rng, wait))
 			break;
@@ -100,6 +106,9 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		max -= sizeof(u32);
 	}
 
+	pm_runtime_mark_last_busy((struct device *)priv->rng.priv);
+	pm_runtime_put_sync_autosuspend((struct device *)priv->rng.priv);
+
 	return retval || !wait ? retval : -EIO;
 }
 
@@ -120,9 +129,12 @@ static int mtk_rng_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->rng.name = pdev->name;
+#ifndef CONFIG_PM
 	priv->rng.init = mtk_rng_init;
 	priv->rng.cleanup = mtk_rng_cleanup;
+#endif
 	priv->rng.read = mtk_rng_read;
+	priv->rng.priv = (unsigned long)&pdev->dev;
 
 	priv->clk = devm_clk_get(&pdev->dev, "rng");
 	if (IS_ERR(priv->clk)) {
@@ -142,11 +154,40 @@ static int mtk_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	dev_set_drvdata(&pdev->dev, priv);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mtk_rng_runtime_suspend(struct device *dev)
+{
+	struct mtk_rng *priv = dev_get_drvdata(dev);
+
+	mtk_rng_cleanup(&priv->rng);
+
+	return 0;
+}
+
+static int mtk_rng_runtime_resume(struct device *dev)
+{
+	struct mtk_rng *priv = dev_get_drvdata(dev);
+
+	return mtk_rng_init(&priv->rng);
+}
+
+static UNIVERSAL_DEV_PM_OPS(mtk_rng_pm_ops, mtk_rng_runtime_suspend,
+			    mtk_rng_runtime_resume, NULL);
+#define MTK_RNG_PM_OPS (&mtk_rng_pm_ops)
+#else	/* CONFIG_PM */
+#define MTK_RNG_PM_OPS NULL
+#endif	/* CONFIG_PM */
+
 static const struct of_device_id mtk_rng_match[] = {
 	{ .compatible = "mediatek,generic-rng" },
 	{ .compatible = "mediatek,mt7623-rng" },
@@ -158,6 +199,7 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	.probe          = mtk_rng_probe,
 	.driver = {
 		.name = MTK_RNG_DEV,
+		.pm = MTK_RNG_PM_OPS,
 		.of_match_table = mtk_rng_match,
 	},
 };
-- 
1.9.1
