Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9356D5
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2X-0006Oz-36; Sun, 10 Dec 2023 23:12:45 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-00ExYF-NY; Sun, 10 Dec 2023 23:12:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-000RWU-EL; Sun, 10 Dec 2023 23:12:42 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Deepak Saxena <dsaxena@plexity.net>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 09/12] hwrng: omap - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:24 +0100
Message-ID:  <ac07e92ffdaee27d2c4616de89f58de272641d5b.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1878; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=LfUR14esOo8oEFXn7iRhYS5wKFCP5zWPXp6cKLmQ68A=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfJ4k9pmj/OWf8r30NDz3h+byxGGc2Ty8xDu 7gpM2R4Vz+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3yQAKCRCPgPtYfRL+ To22CACbE1sSOtnN4RHFx7kDvy/pll0IlUcR+ZVvcOQ0I10z29krE05S+iVwBCicdBECyMBsUha 9LuQKR2d/xy7+Oe4GjMSfXsnq51cowNKKWCvhxwvA+G0FmGPhmQa9DFR/fw8/OI9pqSOEAOoF5r N+y+y13qGyVHoiQ+q+75lH1JKrWcraU75EJs1csKSyCd2SDOTzznr8jznQdOSxE7KuQHBggIEUp W+UXayUc9lBsf2iOEW1UqE3frJEPWeXSKo+kHQlZhS0U4U9anL4tOduzO7PB1FMF4cocxYZODco JsfKv6mZ79sowdqwq9EOa6j4P/qpSJveJqxOLSwuSkhG/iKF
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
 drivers/char/hw_random/omap-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index be03f76a2a80..d4c02e900466 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -509,7 +509,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap_rng_remove(struct platform_device *pdev)
+static void omap_rng_remove(struct platform_device *pdev)
 {
 	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
 
@@ -521,8 +521,6 @@ static int omap_rng_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(priv->clk);
 	clk_disable_unprepare(priv->clk_reg);
-
-	return 0;
 }
 
 static int __maybe_unused omap_rng_suspend(struct device *dev)
@@ -560,7 +558,7 @@ static struct platform_driver omap_rng_driver = {
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-	.remove		= omap_rng_remove,
+	.remove_new	= omap_rng_remove,
 };
 
 module_platform_driver(omap_rng_driver);
-- 
2.42.0

