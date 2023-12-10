Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD676FC
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2X-0006Of-R0; Sun, 10 Dec 2023 23:12:45 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-00ExXx-5k; Sun, 10 Dec 2023 23:12:41 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-000RVw-Sp; Sun, 10 Dec 2023 23:12:40 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH 03/12] hwrng: exynos - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:18 +0100
Message-ID:  <817e91f7bb257745c0fb483037b83c1a6ba14e75.1702245873.git.u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>
References: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1892; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=n55rfa/lUXGB2/hckh9miapviN5gRi067G9G5cA6tPg=; b=owGbwMvMwMXY3/A7olbonx/jabUkhtQy80OzJxX9EZyQstk3oj2cQ/y5av9KFeUZPcpPXKbwc oTzK57rZDRmYWDkYpAVU2Sxb1yTaVUlF9m59t9lmEGsTCBTGLg4BWAi1+TY//uuMfPrb37feXCa ln/WCr+mpKkq/MtSuzZ/u35X8kpefSq/q1rkb8HyvsKn946VWiuHH1yyn0nXatMlZ6X8jkb1Sev EtzhkHxE69fzZ47hPQr0e+1v7VObtEtoS2McoEXbqApfHC38b4ex/N1t7+BiNb0ydWiYVYfHu0W sdnW+yEdenrExxzetwf7a45k/XXjWPx+eq1/1j6lSydK0Re5yovl9OcUJWZC1fVBqrbbu375bXR f43nuy46/op1V+P0c6o8M2kld9zL8/0TE1+dfjSzUAd5fInNmeP3032dS11WZv6XXP3jYfNE8Sv /hERf2DGFLAzTXtRiFqOdFPQBBdB9vjk+OfuRv9/V0UAAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/hw_random/exynos-trng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 30207b7ac5f4..0ed5d22fe667 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -173,7 +173,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int exynos_trng_remove(struct platform_device *pdev)
+static void exynos_trng_remove(struct platform_device *pdev)
 {
 	struct exynos_trng_dev *trng =  platform_get_drvdata(pdev);
 
@@ -181,8 +181,6 @@ static int exynos_trng_remove(struct platform_device *pdev)
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static int exynos_trng_suspend(struct device *dev)
@@ -223,7 +221,7 @@ static struct platform_driver exynos_trng_driver = {
 		.of_match_table = exynos_trng_dt_match,
 	},
 	.probe = exynos_trng_probe,
-	.remove = exynos_trng_remove,
+	.remove_new = exynos_trng_remove,
 };
 
 module_platform_driver(exynos_trng_driver);
-- 
2.42.0

