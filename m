From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 4/4] hwrng: exynos - Disable runtime PM on driver unbind
Date: Mon, 14 Mar 2016 09:07:15 +0900
Message-ID: <1457914035-26856-4-git-send-email-k.kozlowski@samsung.com>
References: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1457914035-26856-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Driver enabled runtime PM but did not revert this on removal. Re-binding
of a device triggered warning:
	exynos-rng 10830400.rng: Unbalanced pm_runtime_enable!

Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random number generator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. Call also pm_runtime_dont_use_autosuspend() to revert everything set
   during probe.
---
 drivers/char/hw_random/exynos-rng.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 71b45b153cf2..ed78f25e4ec6 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -156,6 +156,14 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int exynos_rng_remove(struct platform_device *pdev)
+{
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
 static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -213,6 +221,7 @@ static struct platform_driver exynos_rng_driver = {
 		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
+	.remove		= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);
-- 
2.5.0
