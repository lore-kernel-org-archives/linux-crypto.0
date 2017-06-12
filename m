From: <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 2/3] hwrng: mtk - add runtime PM support
Date: Mon, 12 Jun 2017 23:56:55 +0800
Message-ID: <9b259abd36f38e3699e53784c0158f3b5e31d7d7.1497280813.git.sean.wang@mediatek.com>
References: <cover.1497280813.git.sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <keyhaede-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
To: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <romain.perier-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, <shannon.nelson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1497280813.git.sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

Add runtime PM support.  There will be the benefit on SoCs where the
clock to the RNG used can be shutdown.

Signed-off-by: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
---
 drivers/char/hw_random/mtk-rng.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index df8eb54..8da7bcf 100644
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
 	{ .compatible = "mediatek,mt7623-rng" },
 	{},
@@ -157,6 +198,7 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	.probe          = mtk_rng_probe,
 	.driver = {
 		.name = MTK_RNG_DEV,
+		.pm = MTK_RNG_PM_OPS,
 		.of_match_table = mtk_rng_match,
 	},
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
