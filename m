Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11F6D6
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2X-0006Oh-8C; Sun, 10 Dec 2023 23:12:45 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-00ExY3-MF; Sun, 10 Dec 2023 23:12:41 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-000RW4-DD; Sun, 10 Dec 2023 23:12:41 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Martin Kaiser <martin@kaiser.cx>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 05/12] hwrng: ks-sa - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:20 +0100
Message-ID:  <159e2800fe1412090a33884f4a8b9cae24b3d28f.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1770; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=WpUWyc5StSRgNEpaQ04zjgxYp4K0Xqr+B/hROAvvVE4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfElnlO4Y6Ge+qeStX52B/XbeTTaUFUZ95zB efifYQDRnWJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3xAAKCRCPgPtYfRL+ Tk2kCAC7I3d4CFuamh7B8TmLhet9XFbS5C6uvP2cgh3Y2WEuxnyrz4HwbR/DkemAwBYBjd6tgPs pFEItmYKVdq0aePCPENQ/CAV7BaR/qFylWBbMv7JlqJks4wN14pzQMAFG7A6hL6EcN+FGMXqKWf MO2K0TTdWxhxJrUUImxUqN6yw/F2OZi3z6PxhXOOgpwp0xk8EavuMWt/oL+qI93CHFviTJSsysR ZAOdDzI6YNd6MX8GS9uebFYmibI/AR3xyEGTK6w3oFrlf6mzJlS7Va/4xNJlgZBUpmE6SdJzQlS vqgc4audiibzNj3pYOhN+ZDy5y4GBsDmI35kx516rrhOOsMl
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
 drivers/char/hw_random/ks-sa-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index dff7b9db7044..36c34252b4f6 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -241,12 +241,10 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 	return devm_hwrng_register(&pdev->dev, &ks_sa_rng->rng);
 }
 
-static int ks_sa_rng_remove(struct platform_device *pdev)
+static void ks_sa_rng_remove(struct platform_device *pdev)
 {
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static const struct of_device_id ks_sa_rng_dt_match[] = {
@@ -263,7 +261,7 @@ static struct platform_driver ks_sa_rng_driver = {
 		.of_match_table = ks_sa_rng_dt_match,
 	},
 	.probe		= ks_sa_rng_probe,
-	.remove		= ks_sa_rng_remove,
+	.remove_new	= ks_sa_rng_remove,
 };
 
 module_platform_driver(ks_sa_rng_driver);
-- 
2.42.0

