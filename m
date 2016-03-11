From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/5] hwrng: exynos - Disable runtime PM on probe failure
Date: Fri, 11 Mar 2016 16:49:21 +0900
Message-ID: <1457682562-21219-4-git-send-email-k.kozlowski@samsung.com>
References: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65420 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259AbcCKHtr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 02:49:47 -0500
In-reply-to: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add proper error path (for disabling runtime PM) when registering of
hwrng fails.

Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random number generator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 38b80f82ddd2..68c349bf66a0 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -119,6 +119,7 @@ static int exynos_rng_probe(struct platform_device *pdev)
 {
 	struct exynos_rng *exynos_rng;
 	struct resource *res;
+	int ret;
 
 	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
 					GFP_KERNEL);
@@ -146,7 +147,11 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	return devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
+	ret = devm_hwrng_register(&pdev->dev, &exynos_rng->rng);
+	if (ret)
+		pm_runtime_disable(&pdev->dev);
+
+	return ret;
 }
 
 static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
-- 
2.5.0
