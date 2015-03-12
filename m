From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/6] hwrng: bcm63xx - make use of devm_hwrng_register
Date: Thu, 12 Mar 2015 14:00:03 -0700
Message-ID: <1426194007-22182-3-git-send-email-dmitry.torokhov@gmail.com>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This change converts bcm63xx-rng to use devm* API for managing all
resources, which allows us to dispense with the rest of error handling
path and remove() function. Also we combine hwern and driver-private
data into a single allocation, use clk_prepare_enable() instead
of "naked" clk_enable() and move clock enabling/disabling into hwrnd
inti(0 and cleanup() methods so the clock stays off until rng is
used.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 87 +++++++++++++-----------------------
 1 file changed, 31 insertions(+), 56 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index 27da00f..d1494ec 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -24,16 +24,22 @@
 #define RNG_MASK			0x10
 
 struct bcm63xx_rng_priv {
+	struct hwrng rng;
 	struct clk *clk;
 	void __iomem *regs;
 };
 
-#define to_rng_priv(rng)	((struct bcm63xx_rng_priv *)rng->priv)
+#define to_rng_priv(rng)	container_of(rng, struct bcm63xx_rng_priv, rng)
 
 static int bcm63xx_rng_init(struct hwrng *rng)
 {
 	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
 	u32 val;
+	int error;
+
+	error = clk_prepare_enable(priv->clk);
+	if (error)
+		return error;
 
 	val = __raw_readl(priv->regs + RNG_CTRL);
 	val |= RNG_EN;
@@ -50,6 +56,8 @@ static void bcm63xx_rng_cleanup(struct hwrng *rng)
 	val = __raw_readl(priv->regs + RNG_CTRL);
 	val &= ~RNG_EN;
 	__raw_writel(val, priv->regs + RNG_CTRL);
+
+	clk_didsable_unprepare(prov->clk);
 }
 
 static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
@@ -79,86 +87,53 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "no iomem resource\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
-	if (!rng) {
-		ret = -ENOMEM;
-		goto out;
+	if (!priv)
+		return -ENOMEM;
+
+	priv->rng.name = pdev->name;
+	priv->rng.init = bcm63xx_rng_init;
+	priv->rng.cleanup = bcm63xx_rng_cleanup;
+	prov->rng.data_present = bcm63xx_rng_data_present;
+	priv->rng.data_read = bcm63xx_rng_data_read;
+
+	priv->clk = devm_clk_get(&pdev->dev, "ipsec");
+	if (IS_ERR(priv->clk)) {
+		error = PTR_ERR(priv->clk);
+		dev_err(&pdev->dev, "no clock for device: %d\n", error);
+		return error;
 	}
 
-	platform_set_drvdata(pdev, rng);
-	rng->priv = (unsigned long)priv;
-	rng->name = pdev->name;
-	rng->init = bcm63xx_rng_init;
-	rng->cleanup = bcm63xx_rng_cleanup;
-	rng->data_present = bcm63xx_rng_data_present;
-	rng->data_read = bcm63xx_rng_data_read;
-
-	clk = clk_get(&pdev->dev, "ipsec");
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "no clock for device\n");
-		ret = PTR_ERR(clk);
-		goto out;
-	}
-
-	priv->clk = clk;
-
 	if (!devm_request_mem_region(&pdev->dev, r->start,
 					resource_size(r), pdev->name)) {
 		dev_err(&pdev->dev, "request mem failed");
-		ret = -ENOMEM;
-		goto out;
+		return -EBUSY;
 	}
 
 	priv->regs = devm_ioremap_nocache(&pdev->dev, r->start,
 					resource_size(r));
 	if (!priv->regs) {
 		dev_err(&pdev->dev, "ioremap failed");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
-	clk_enable(clk);
-
-	ret = hwrng_register(rng);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register rng device\n");
-		goto out_clk_disable;
+	error = devm_hwrng_register(&pdev->dev, &priv->rng);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register rng device: %d\n",
+			error);
+		return error;
 	}
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
 	return 0;
-
-out_clk_disable:
-	clk_disable(clk);
-out:
-	return ret;
-}
-
-static int bcm63xx_rng_remove(struct platform_device *pdev)
-{
-	struct hwrng *rng = platform_get_drvdata(pdev);
-	struct bcm63xx_rng_priv *priv = to_rng_priv(rng);
-
-	hwrng_unregister(rng);
-	clk_disable(priv->clk);
-
-	return 0;
 }
 
 static struct platform_driver bcm63xx_rng_driver = {
 	.probe		= bcm63xx_rng_probe,
-	.remove		= bcm63xx_rng_remove,
 	.driver		= {
 		.name	= "bcm63xx-rng",
 	},
-- 
2.2.0.rc0.207.ga3a616c
