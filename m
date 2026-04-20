Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6A2346E7E;
	Mon, 20 Apr 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776702932; cv=none; b=nwtphqC2b93ELajwqm3HOjH7lMNDXpVCuhlA85wGevycJha/92o/S5CtU6hOqOgu/tySXATeofjOaOuJPciPOoYxIXKr2rxWSWmzuxxQckruXnlmSwEo0lMfczoL7wvY1BVJuCmxXYBoLFgmMRuY9x7yEmC8swA1AKnWfnWDAWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776702932; c=relaxed/simple;
	bh=ssLqSFLTYxVIUk25VJfp+OL2Z27tYstNKSVXAyJTL3w=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUaf/sXDOhXj4sZHkR63S42r+v9dygy5t2x7YSiZmg2fmZN+W/SJKQteVHEie3XaoY8ZL/2MgwL42wcgkdXJ2FUjR+EfnRuobK4vlr0eWwMfBQOlu+ZAEczyIndIHJ7czmDwEpxUigdK5YE0sNl0KX933vGxbc0uAPuGJgNw36k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wErap-000000001D6-1tcW;
	Mon, 20 Apr 2026 16:35:27 +0000
Date: Mon, 20 Apr 2026 17:35:24 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v4 3/3] hwrng: mtk - add support for hw access via SMCC
Message-ID: <e12b133a762f68628e29ac358a3a0605731ab7bd.1776702734.git.daniel@makrotopia.org>
References: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <912fe579eccf577f3064b69d6c945e2c9087cab8.1776702734.git.daniel@makrotopia.org>

Newer versions of ARM TrustedFirmware-A on MediaTek's ARMv8 SoCs no longer
allow accessing the TRNG from outside of the trusted firmware.
Instead, a vendor-defined custom Secure Monitor Call can be used to
acquire random bytes.

Add support for newer SoCs (MT7981, MT7987, MT7988).

As TF-A for the MT7986 may either follow the old or the new
convention, the best bet is to test if firmware blocks direct access
to the hwrng and if so, expect the SMCC interface to be usable.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v4: unchanged
v3: unchanged
v2: unchanged

 drivers/char/hw_random/mtk-rng.c | 127 ++++++++++++++++++++++++++-----
 1 file changed, 106 insertions(+), 21 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 5808d09d12c45..8f5856b59ad66 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -3,6 +3,7 @@
  * Driver for Mediatek Hardware Random Number Generator
  *
  * Copyright (C) 2017 Sean Wang <sean.wang@mediatek.com>
+ * Copyright (C) 2026 Daniel Golle <daniel@makrotopia.org>
  */
 #define MTK_RNG_DEV KBUILD_MODNAME
 
@@ -17,6 +18,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/arm-smccc.h>
+#include <linux/soc/mediatek/mtk_sip_svc.h>
 
 /* Runtime PM autosuspend timeout: */
 #define RNG_AUTOSUSPEND_TIMEOUT		100
@@ -30,6 +33,11 @@
 
 #define RNG_DATA			0x08
 
+/* Driver feature flags */
+#define MTK_RNG_SMC			BIT(0)
+
+#define MTK_SIP_KERNEL_GET_RND		MTK_SIP_SMC_CMD(0x550)
+
 #define to_mtk_rng(p)	container_of(p, struct mtk_rng, rng)
 
 struct mtk_rng {
@@ -37,6 +45,7 @@ struct mtk_rng {
 	struct clk *clk;
 	struct hwrng rng;
 	struct device *dev;
+	unsigned long flags;
 };
 
 static int mtk_rng_init(struct hwrng *rng)
@@ -103,6 +112,56 @@ static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return retval || !wait ? retval : -EIO;
 }
 
+static int mtk_rng_read_smc(struct hwrng *rng, void *buf, size_t max,
+			    bool wait)
+{
+	struct arm_smccc_res res;
+	int retval = 0;
+
+	while (max >= sizeof(u32)) {
+		arm_smccc_smc(MTK_SIP_KERNEL_GET_RND, 0, 0, 0, 0, 0, 0, 0,
+			      &res);
+		if (res.a0)
+			break;
+
+		*(u32 *)buf = res.a1;
+		retval += sizeof(u32);
+		buf += sizeof(u32);
+		max -= sizeof(u32);
+	}
+
+	return retval || !wait ? retval : -EIO;
+}
+
+static bool mtk_rng_hw_accessible(struct mtk_rng *priv)
+{
+	u32 val;
+	int err;
+
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		return false;
+
+	val = readl(priv->base + RNG_CTRL);
+	val |= RNG_EN;
+	writel(val, priv->base + RNG_CTRL);
+
+	val = readl(priv->base + RNG_CTRL);
+
+	if (val & RNG_EN) {
+		/* HW is accessible, clean up: disable RNG and clock */
+		writel(val & ~RNG_EN, priv->base + RNG_CTRL);
+		clk_disable_unprepare(priv->clk);
+		return true;
+	}
+
+	/*
+	 * If TF-A blocks direct access, the register reads back as 0.
+	 * Leave the clock enabled as TF-A needs it.
+	 */
+	return false;
+}
+
 static int mtk_rng_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -114,23 +173,42 @@ static int mtk_rng_probe(struct platform_device *pdev)
 
 	priv->dev = &pdev->dev;
 	priv->rng.name = pdev->name;
-#ifndef CONFIG_PM
-	priv->rng.init = mtk_rng_init;
-	priv->rng.cleanup = mtk_rng_cleanup;
-#endif
-	priv->rng.read = mtk_rng_read;
 	priv->rng.quality = 900;
-
-	priv->clk = devm_clk_get(&pdev->dev, "rng");
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		dev_err(&pdev->dev, "no clock for device: %d\n", ret);
-		return ret;
+	priv->flags = (unsigned long)device_get_match_data(&pdev->dev);
+
+	if (!(priv->flags & MTK_RNG_SMC)) {
+		priv->clk = devm_clk_get(&pdev->dev, "rng");
+		if (IS_ERR(priv->clk)) {
+			ret = PTR_ERR(priv->clk);
+			dev_err(&pdev->dev, "no clock for device: %d\n", ret);
+			return ret;
+		}
+
+		priv->base = devm_platform_ioremap_resource(pdev, 0);
+		if (IS_ERR(priv->base))
+			return PTR_ERR(priv->base);
+
+		if (IS_ENABLED(CONFIG_HAVE_ARM_SMCCC) &&
+		    of_device_is_compatible(pdev->dev.of_node,
+					    "mediatek,mt7986-rng") &&
+		    !mtk_rng_hw_accessible(priv)) {
+			priv->flags |= MTK_RNG_SMC;
+			dev_info(&pdev->dev,
+				 "HW RNG not MMIO accessible, using SMC\n");
+		}
 	}
 
-	priv->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(priv->base))
-		return PTR_ERR(priv->base);
+	if (priv->flags & MTK_RNG_SMC) {
+		if (!IS_ENABLED(CONFIG_HAVE_ARM_SMCCC))
+			return -ENODEV;
+		priv->rng.read = mtk_rng_read_smc;
+	} else {
+#ifndef CONFIG_PM
+		priv->rng.init = mtk_rng_init;
+		priv->rng.cleanup = mtk_rng_cleanup;
+#endif
+		priv->rng.read = mtk_rng_read;
+	}
 
 	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
 	if (ret) {
@@ -139,12 +217,15 @@ static int mtk_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	dev_set_drvdata(&pdev->dev, priv);
-	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
-	pm_runtime_use_autosuspend(&pdev->dev);
-	ret = devm_pm_runtime_enable(&pdev->dev);
-	if (ret)
-		return ret;
+	if (!(priv->flags & MTK_RNG_SMC)) {
+		dev_set_drvdata(&pdev->dev, priv);
+		pm_runtime_set_autosuspend_delay(&pdev->dev,
+						 RNG_AUTOSUSPEND_TIMEOUT);
+		pm_runtime_use_autosuspend(&pdev->dev);
+		ret = devm_pm_runtime_enable(&pdev->dev);
+		if (ret)
+			return ret;
+	}
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
@@ -181,8 +262,11 @@ static const struct dev_pm_ops mtk_rng_pm_ops = {
 #endif	/* CONFIG_PM */
 
 static const struct of_device_id mtk_rng_match[] = {
-	{ .compatible = "mediatek,mt7986-rng" },
 	{ .compatible = "mediatek,mt7623-rng" },
+	{ .compatible = "mediatek,mt7981-rng", .data = (void *)MTK_RNG_SMC },
+	{ .compatible = "mediatek,mt7986-rng" },
+	{ .compatible = "mediatek,mt7987-rng", .data = (void *)MTK_RNG_SMC },
+	{ .compatible = "mediatek,mt7988-rng", .data = (void *)MTK_RNG_SMC },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mtk_rng_match);
@@ -200,4 +284,5 @@ module_platform_driver(mtk_rng_driver);
 
 MODULE_DESCRIPTION("Mediatek Random Number Generator Driver");
 MODULE_AUTHOR("Sean Wang <sean.wang@mediatek.com>");
+MODULE_AUTHOR("Daniel Golle <daniel@makrotopia.org>");
 MODULE_LICENSE("GPL");
-- 
2.53.0
