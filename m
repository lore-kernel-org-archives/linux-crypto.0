From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 4/9] hwrng: omap - Use the managed device resource API for registration
Date: Tue,  6 Sep 2016 17:38:52 +0200
Message-ID: <20160906153857.5503-5-romain.perier@free-electrons.com>
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
Received: from down.free-electrons.com ([37.187.137.238]:59276 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933412AbcIFPkJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 11:40:09 -0400
In-Reply-To: <20160906153857.5503-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_hwrng_register instead of hwrng_register. It avoids the need
to handle unregistration explicitly from the remove function.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/char/hw_random/omap-rng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d47b24d..171c3e8 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -381,7 +381,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_ioremap;
 
-	ret = hwrng_register(&omap_rng_ops);
+	ret = devm_hwrng_register(dev, &omap_rng_ops);
 	if (ret)
 		goto err_register;
 
@@ -402,8 +402,6 @@ static int omap_rng_remove(struct platform_device *pdev)
 {
 	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
 
-	hwrng_unregister(&omap_rng_ops);
-
 	priv->pdata->cleanup(priv);
 
 	pm_runtime_put_sync(&pdev->dev);
-- 
2.9.3
