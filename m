From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/6] hwrng: exynos - make use of devm_hwrng_register
Date: Thu, 12 Mar 2015 14:00:04 -0700
Message-ID: <1426194007-22182-4-git-send-email-dmitry.torokhov@gmail.com>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This allows us to get rid of remove() method.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/exynos-rng.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index fed0830..dc4701f 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -131,16 +131,7 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return hwrng_register(&exynos_rng->rng);
-}
-
-static int exynos_rng_remove(struct platform_device *pdev)
-{
-	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
-
-	hwrng_unregister(&exynos_rng->rng);
-
-	return 0;
+	return devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
 }
 
 #ifdef CONFIG_PM
@@ -172,7 +163,6 @@ static struct platform_driver exynos_rng_driver = {
 		.pm	= &exynos_rng_pm_ops,
 	},
 	.probe		= exynos_rng_probe,
-	.remove		= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);
-- 
2.2.0.rc0.207.ga3a616c
