From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] hwrng: exynos - Add Device Tree support
Date: Mon, 19 Oct 2015 13:37:42 +0900
Message-ID: <1445229462-32395-5-git-send-email-k.kozlowski@samsung.com>
References: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJSEiH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 00:38:07 -0400
In-reply-to: <1445229462-32395-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Device Tree support for the driver. The Pseudo Random Number
Generator module is the same in almost all of Exynos SoCs, since
Exynos4210 (however the tests were done only on Trats2 board with
Exynos4412). There are some differences on newer Exynos Octa
(Exynos542x) SoCs.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/char/hw_random/exynos-rng.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 162adbda1b70..7077c7741dae 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -188,10 +188,19 @@ static const struct dev_pm_ops exynos_rng_pm_ops = {
 			   exynos_rng_runtime_resume, NULL)
 };
 
+static const struct of_device_id exynos_rng_dt_match[] = {
+	{
+		.compatible = "samsung,exynos4-rng",
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
+
 static struct platform_driver exynos_rng_driver = {
 	.driver		= {
 		.name	= "exynos-rng",
 		.pm	= &exynos_rng_pm_ops,
+		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
 };
-- 
1.9.1
