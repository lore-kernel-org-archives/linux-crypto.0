From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] hw_random: octeon-rng: Use devm_hwrng_register
Date: Thu, 10 Sep 2015 11:32:26 +0530
Message-ID: <20150910060226.GA25426@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35634 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbbIJGCb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 02:02:31 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use resource managed function devm_hwrng_register instead of
hwrng_register to make the error-path simpler. Also, remove
octeon_rng_remove as it is now redundant.

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/char/hw_random/octeon-rng.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 6234a4a..8c78aa0 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -96,7 +96,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 	rng->ops = ops;
 
 	platform_set_drvdata(pdev, &rng->ops);
-	ret = hwrng_register(&rng->ops);
+	ret = devm_hwrng_register(&pdev->dev, &rng->ops);
 	if (ret)
 		return -ENOENT;
 
@@ -105,21 +105,11 @@ static int octeon_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int octeon_rng_remove(struct platform_device *pdev)
-{
-	struct hwrng *rng = platform_get_drvdata(pdev);
-
-	hwrng_unregister(rng);
-
-	return 0;
-}
-
 static struct platform_driver octeon_rng_driver = {
 	.driver = {
 		.name		= "octeon_rng",
 	},
 	.probe		= octeon_rng_probe,
-	.remove		= octeon_rng_remove,
 };
 
 module_platform_driver(octeon_rng_driver);
-- 
1.9.1
