From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 5/9] hwrng: omap - Remove global definition of hwrng
Date: Tue,  6 Sep 2016 17:38:53 +0200
Message-ID: <20160906153857.5503-6-romain.perier@free-electrons.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Romain Perier <romain.perier@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59271 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933357AbcIFPkJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 11:40:09 -0400
In-Reply-To: <20160906153857.5503-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The omap-rng driver currently assumes that there will only ever be a
single instance of an RNG device. For this reason, there is a statically
allocated struct hwrng, with a fixed name. However, registering two
struct hwrng with the same isn't accepted by the RNG framework, so we
need to switch to a dynamically allocated struct hwrng, each using a
different name. Then, we define the name of this hwrng to "dev_name(dev)",
so the name of the data structure is unique per device.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 171c3e8..f9a99b2 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -127,6 +127,7 @@ struct omap_rng_dev {
 	void __iomem			*base;
 	struct device			*dev;
 	const struct omap_rng_pdata	*pdata;
+	struct hwrng rng;
 };
 
 static inline u32 omap_rng_read(struct omap_rng_dev *priv, u16 reg)
@@ -179,12 +180,6 @@ static void omap_rng_cleanup(struct hwrng *rng)
 	priv->pdata->cleanup(priv);
 }
 
-static struct hwrng omap_rng_ops = {
-	.name		= "omap",
-	.read 		= omap_rng_do_read,
-	.init		= omap_rng_init,
-	.cleanup	= omap_rng_cleanup,
-};
 
 static inline u32 omap2_rng_data_present(struct omap_rng_dev *priv)
 {
@@ -357,7 +352,11 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	omap_rng_ops.priv = (unsigned long)priv;
+	priv->rng.read = omap_rng_do_read;
+	priv->rng.init = omap_rng_init;
+	priv->rng.cleanup = omap_rng_cleanup;
+
+	priv->rng.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
 	priv->dev = dev;
 
@@ -368,6 +367,12 @@ static int omap_rng_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	priv->rng.name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!priv->rng.name) {
+		ret = -ENOMEM;
+		goto err_register;
+	}
+
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret) {
@@ -381,7 +386,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_ioremap;
 
-	ret = devm_hwrng_register(dev, &omap_rng_ops);
+	ret = devm_hwrng_register(dev, &priv->rng);
 	if (ret)
 		goto err_register;
 
-- 
2.9.3
