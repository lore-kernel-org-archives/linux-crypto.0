From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/5] hwrng: exynos - Hide PM functions with __maybe_unused
Date: Fri, 11 Mar 2016 16:49:18 +0900
Message-ID: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10453 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259AbcCKHtj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 02:49:39 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Replace ifdef with __maybe_unused to silence compiler warning on when
SUSPEND=3Dn and PM=3Dy:

drivers/char/hw_random/exynos-rng.c:166:12: warning: =E2=80=98exynos_rn=
g_suspend=E2=80=99 defined but not used [-Wunused-function]
 static int exynos_rng_suspend(struct device *dev)
            ^
drivers/char/hw_random/exynos-rng.c:171:12: warning: =E2=80=98exynos_rn=
g_resume=E2=80=99 defined but not used [-Wunused-function]
 static int exynos_rng_resume(struct device *dev)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_rand=
om/exynos-rng.c
index 30cf4623184f..ada081232528 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -144,8 +144,7 @@ static int exynos_rng_probe(struct platform_device =
*pdev)
 	return devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
 }
=20
-#ifdef CONFIG_PM
-static int exynos_rng_runtime_suspend(struct device *dev)
+static int __maybe_unused exynos_rng_runtime_suspend(struct device *de=
v)
 {
 	struct platform_device *pdev =3D to_platform_device(dev);
 	struct exynos_rng *exynos_rng =3D platform_get_drvdata(pdev);
@@ -155,7 +154,7 @@ static int exynos_rng_runtime_suspend(struct device=
 *dev)
 	return 0;
 }
=20
-static int exynos_rng_runtime_resume(struct device *dev)
+static int __maybe_unused exynos_rng_runtime_resume(struct device *dev=
)
 {
 	struct platform_device *pdev =3D to_platform_device(dev);
 	struct exynos_rng *exynos_rng =3D platform_get_drvdata(pdev);
@@ -163,12 +162,12 @@ static int exynos_rng_runtime_resume(struct devic=
e *dev)
 	return clk_prepare_enable(exynos_rng->clk);
 }
=20
-static int exynos_rng_suspend(struct device *dev)
+static int __maybe_unused exynos_rng_suspend(struct device *dev)
 {
 	return pm_runtime_force_suspend(dev);
 }
=20
-static int exynos_rng_resume(struct device *dev)
+static int __maybe_unused exynos_rng_resume(struct device *dev)
 {
 	struct platform_device *pdev =3D to_platform_device(dev);
 	struct exynos_rng *exynos_rng =3D platform_get_drvdata(pdev);
@@ -180,7 +179,6 @@ static int exynos_rng_resume(struct device *dev)
=20
 	return exynos_rng_configure(exynos_rng);
 }
-#endif
=20
 static const struct dev_pm_ops exynos_rng_pm_ops =3D {
 	SET_SYSTEM_SLEEP_PM_OPS(exynos_rng_suspend, exynos_rng_resume)
--=20
2.5.0
