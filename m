From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6/6] hwrng: iproc-rng200 - make use of devm_hwrng_register
Date: Thu, 12 Mar 2015 14:00:07 -0700
Message-ID: <1426194007-22182-7-git-send-email-dmitry.torokhov@gmail.com>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36750 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbbCLVAm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 17:00:42 -0400
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This allows us to get rid of driver's remove() method.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/iproc-rng200.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 2dbaf5c..3eaf7cb 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -208,29 +208,17 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 	priv->rng.cleanup = iproc_rng200_cleanup,
 
 	/* Register driver */
-	ret = hwrng_register(&priv->rng);
+	ret = devm_hwrng_register(dev, &priv->rng);
 	if (ret) {
 		dev_err(dev, "hwrng registration failed\n");
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, priv);
-
 	dev_info(dev, "hwrng registered\n");
 
 	return 0;
 }
 
-static int iproc_rng200_remove(struct platform_device *pdev)
-{
-	struct iproc_rng200_dev *priv = platform_get_drvdata(pdev);
-
-	/* Unregister driver */
-	hwrng_unregister(&priv->rng);
-
-	return 0;
-}
-
 static const struct of_device_id iproc_rng200_of_match[] = {
 	{ .compatible = "brcm,iproc-rng200", },
 	{},
@@ -243,7 +231,6 @@ static struct platform_driver iproc_rng200_driver = {
 		.of_match_table = iproc_rng200_of_match,
 	},
 	.probe		= iproc_rng200_probe,
-	.remove		= iproc_rng200_remove,
 };
 module_platform_driver(iproc_rng200_driver);
 
-- 
2.2.0.rc0.207.ga3a616c
