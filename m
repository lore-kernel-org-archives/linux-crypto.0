From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/4] hwrng: exynos - Fix missing configuration after suspend to
 RAM
Date: Mon, 19 Oct 2015 13:37:41 +0900
Message-ID: <1445229462-32395-4-git-send-email-k.kozlowski@samsung.com>
References: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Cc: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1445229462-32395-1-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

After suspend to RAM the device stopped to work with ETIMEDOUT error:

$ dd if=/dev/hwrng of=/dev/null bs=1 count=16
dd: reading `/dev/hwrng': Connection timed out

In the STATUS register the bits #5 (PRNG_DONE) and #1
(SEED_SETTING_DONE) were not set. Instead PRNG_ERROR (seventh bit) was
high.

After each system suspend initialize the seed to fix the error.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/char/hw_random/exynos-rng.c | 42 ++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index dfaaaafb8ddd..162adbda1b70 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -53,15 +53,11 @@ static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
 	__raw_writel(val, rng->mem + offset);
 }
 
-static int exynos_init(struct hwrng *rng)
+static int exynos_rng_configure(struct exynos_rng *exynos_rng)
 {
-	struct exynos_rng *exynos_rng = container_of(rng,
-						struct exynos_rng, rng);
 	int i;
 	int ret = 0;
 
-	pm_runtime_get_sync(exynos_rng->dev);
-
 	for (i = 0 ; i < 5 ; i++)
 		exynos_rng_writel(exynos_rng, jiffies,
 				EXYNOS_PRNG_SEED_OFFSET + 4*i);
@@ -70,6 +66,17 @@ static int exynos_init(struct hwrng *rng)
 						 & SEED_SETTING_DONE))
 		ret = -EIO;
 
+	return ret;
+}
+
+static int exynos_init(struct hwrng *rng)
+{
+	struct exynos_rng *exynos_rng = container_of(rng,
+						struct exynos_rng, rng);
+	int ret = 0;
+
+	pm_runtime_get_sync(exynos_rng->dev);
+	ret = exynos_rng_configure(exynos_rng);
 	pm_runtime_put_noidle(exynos_rng->dev);
 
 	return ret;
@@ -155,10 +162,31 @@ static int exynos_rng_runtime_resume(struct device *dev)
 
 	return clk_prepare_enable(exynos_rng->clk);
 }
+
+static int exynos_rng_suspend(struct device *dev)
+{
+	return pm_runtime_force_suspend(dev);
+}
+
+static int exynos_rng_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret)
+		return ret;
+
+	return exynos_rng_configure(exynos_rng);
+}
 #endif
 
-static UNIVERSAL_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_runtime_suspend,
-					exynos_rng_runtime_resume, NULL);
+static const struct dev_pm_ops exynos_rng_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(exynos_rng_suspend, exynos_rng_resume)
+	SET_RUNTIME_PM_OPS(exynos_rng_runtime_suspend,
+			   exynos_rng_runtime_resume, NULL)
+};
 
 static struct platform_driver exynos_rng_driver = {
 	.driver		= {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
