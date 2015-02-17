From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4/4] hw_random: bcm63xx-rng: use devm_* helpers
Date: Mon, 16 Feb 2015 18:09:16 -0800
Message-ID: <1424138956-11563-5-git-send-email-f.fainelli@gmail.com>
References: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mpm@selenic.com, herbert@gondor.apana.org.au, wsa@the-dreams.de,
	cernekee@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
To: linux-mips@linux-mips.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Simplify the driver's probe function and error handling by using the
device managed allocators, while at it, drop the redundant "out of
memory" messages since these are already printed by the allocator.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/bcm63xx-rng.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
index c7f3af852599..27da00f68c8f 100644
--- a/drivers/char/hw_random/bcm63xx-rng.c
+++ b/drivers/char/hw_random/bcm63xx-rng.c
@@ -83,18 +83,16 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-		dev_err(&pdev->dev, "no memory for private structure\n");
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	rng = kzalloc(sizeof(*rng), GFP_KERNEL);
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
 	if (!rng) {
-		dev_err(&pdev->dev, "no memory for rng structure\n");
 		ret = -ENOMEM;
-		goto out_free_priv;
+		goto out;
 	}
 
 	platform_set_drvdata(pdev, rng);
@@ -109,7 +107,7 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "no clock for device\n");
 		ret = PTR_ERR(clk);
-		goto out_free_rng;
+		goto out;
 	}
 
 	priv->clk = clk;
@@ -118,7 +116,7 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 					resource_size(r), pdev->name)) {
 		dev_err(&pdev->dev, "request mem failed");
 		ret = -ENOMEM;
-		goto out_free_rng;
+		goto out;
 	}
 
 	priv->regs = devm_ioremap_nocache(&pdev->dev, r->start,
@@ -126,7 +124,7 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 	if (!priv->regs) {
 		dev_err(&pdev->dev, "ioremap failed");
 		ret = -ENOMEM;
-		goto out_free_rng;
+		goto out;
 	}
 
 	clk_enable(clk);
@@ -143,10 +141,6 @@ static int bcm63xx_rng_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable(clk);
-out_free_rng:
-	kfree(rng);
-out_free_priv:
-	kfree(priv);
 out:
 	return ret;
 }
@@ -158,8 +152,6 @@ static int bcm63xx_rng_remove(struct platform_device *pdev)
 
 	hwrng_unregister(rng);
 	clk_disable(priv->clk);
-	kfree(priv);
-	kfree(rng);
 
 	return 0;
 }
-- 
2.1.0
