From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 5/5] hwrng: exynos - Disable runtime PM on driver unbind
Date: Fri, 11 Mar 2016 16:49:22 +0900
Message-ID: <1457682562-21219-5-git-send-email-k.kozlowski@samsung.com>
References: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8374 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934502AbcCKHts (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 02:49:48 -0500
In-reply-to: <1457682562-21219-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Driver enabled runtime PM but did not revert this on removal. Re-binding
of a device triggered warning:
	exynos-rng 10830400.rng: Unbalanced pm_runtime_enable!

Fixes: b329669ea0b5 ("hwrng: exynos - Add support for Exynos random number generator")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 68c349bf66a0..cba1ff538c46 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -154,6 +154,13 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int exynos_rng_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
 static int __maybe_unused exynos_rng_runtime_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -211,6 +218,7 @@ static struct platform_driver exynos_rng_driver = {
 		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
+	.remove		= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);
-- 
2.5.0
