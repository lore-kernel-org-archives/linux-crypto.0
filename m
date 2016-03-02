From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/14] hw_random: exynos: use __maybe_unused to hide pm
 functions
Date: Wed,  2 Mar 2016 16:58:59 +0100
Message-ID: <1456934350-1389172-8-git-send-email-arnd@arndb.de>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
 linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Kukjin Kim <kgene@kernel.org>,
 Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The exynos random driver uses #ifdef to check for CONFIG_PM, but
then uses SIMPLE_DEV_PM_OPS, which leaves the references out when
CONFIG_PM_SLEEP is not defined, so we get a warning with
PM=y && PM_SLEEP=n:

drivers/char/hw_random/exynos-rng.c:166:12: error: 'exynos_rng_suspend' defined but not used [-Werror=unused-function]
drivers/char/hw_random/exynos-rng.c:171:12: error: 'exynos_rng_resume' defined but not used [-Werror=unused-function]

This removes the incorrect #ifdef and instead uses a __maybe_unused
annotation to let the compiler know it can silently drop
the function definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hw_random/exynos-rng.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 30cf4623184f..ada081232528 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -144,8 +144,7 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	return devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
 }
 
-#ifdef CONFIG_PM
-static int exynos_rng_runtime_suspend(struct device *dev)
+static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
@@ -155,7 +154,7 @@ static int exynos_rng_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int exynos_rng_runtime_resume(struct device *dev)
+static int __maybe_unused exynos_rng_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
@@ -163,12 +162,12 @@ static int exynos_rng_runtime_resume(struct device *dev)
 	return clk_prepare_enable(exynos_rng->clk);
 }
 
-static int exynos_rng_suspend(struct device *dev)
+static int __maybe_unused exynos_rng_suspend(struct device *dev)
 {
 	return pm_runtime_force_suspend(dev);
 }
 
-static int exynos_rng_resume(struct device *dev)
+static int __maybe_unused exynos_rng_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
@@ -180,7 +179,6 @@ static int exynos_rng_resume(struct device *dev)
 
 	return exynos_rng_configure(exynos_rng);
 }
-#endif
 
 static const struct dev_pm_ops exynos_rng_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(exynos_rng_suspend, exynos_rng_resume)
-- 
2.7.0
