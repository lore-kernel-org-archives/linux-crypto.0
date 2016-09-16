From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 4/8] hwrng: omap - Remove global definition of hwrng
Date: Fri, 16 Sep 2016 12:08:52 +0200
Message-ID: <20160916100856.31727-5-romain.perier@free-electrons.com>
References: <20160916100856.31727-1-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:60859 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758324AbcIPKMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 06:12:16 -0400
In-Reply-To: <20160916100856.31727-1-romain.perier@free-electrons.com>
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

Changes in v2:
 - Fix the goto label used when there is an error for devm_kstrdup

 drivers/char/hw_random/omap-rng.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index b3f6047..5ea804d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -127,6 +127,7 @@ struct omap_rng_dev {
 	void __iomem			*base;
 	struct device			*dev;
 	const struct omap_rng_pdata	*pdata;
+	struct hwrng rng;
 };
 
 static inline u32 omap_rng_read(struct omap_rng_dev *priv, u16 reg)
@@ -187,12 +188,6 @@ static void omap_rng_cleanup(struct hwrng *rng)
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
@@ -365,7 +360,11 @@ static int omap_rng_probe(struct platform_device *pdev)
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
 
@@ -376,6 +375,12 @@ static int omap_rng_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
+	priv->rng.name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
+	if (!priv->rng.name) {
+		ret = -ENOMEM;
+		goto err_ioremap;
+	}
+
 	pm_runtime_enable(&pdev->dev);
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret) {
@@ -389,7 +394,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_ioremap;
 
-	ret = hwrng_register(&omap_rng_ops);
+	ret = hwrng_register(&priv->rng);
 	if (ret)
 		goto err_register;
 
@@ -410,7 +415,7 @@ static int omap_rng_remove(struct platform_device *pdev)
 {
 	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
 
-	hwrng_unregister(&omap_rng_ops);
+	hwrng_unregister(&priv->rng);
 
 	priv->pdata->cleanup(priv);
 
-- 
2.9.3
