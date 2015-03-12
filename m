From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/6] hwrng: msm - make use of devm_hwrng_register
Date: Thu, 12 Mar 2015 14:00:05 -0700
Message-ID: <1426194007-22182-5-git-send-email-dmitry.torokhov@gmail.com>
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
 drivers/char/hw_random/msm-rng.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
index cea1c70..96fb986 100644
--- a/drivers/char/hw_random/msm-rng.c
+++ b/drivers/char/hw_random/msm-rng.c
@@ -157,7 +157,7 @@ static int msm_rng_probe(struct platform_device *pdev)
 	rng->hwrng.cleanup = msm_rng_cleanup,
 	rng->hwrng.read = msm_rng_read,
 
-	ret = hwrng_register(&rng->hwrng);
+	ret = devm_hwrng_register(&pdev->dev, &rng->hwrng);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register hwrng\n");
 		return ret;
@@ -166,14 +166,6 @@ static int msm_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int msm_rng_remove(struct platform_device *pdev)
-{
-	struct msm_rng *rng = platform_get_drvdata(pdev);
-
-	hwrng_unregister(&rng->hwrng);
-	return 0;
-}
-
 static const struct of_device_id msm_rng_of_match[] = {
 	{ .compatible = "qcom,prng", },
 	{}
@@ -182,7 +174,6 @@ MODULE_DEVICE_TABLE(of, msm_rng_of_match);
 
 static struct platform_driver msm_rng_driver = {
 	.probe = msm_rng_probe,
-	.remove = msm_rng_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 		.of_match_table = of_match_ptr(msm_rng_of_match),
-- 
2.2.0.rc0.207.ga3a616c
