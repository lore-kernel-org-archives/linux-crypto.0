Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F0D5
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2X-0006Od-KH; Sun, 10 Dec 2023 23:12:45 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-00ExXr-IF; Sun, 10 Dec 2023 23:12:40 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-000RVo-98; Sun, 10 Dec 2023 23:12:40 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH 01/12] hwrng: atmel - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:16 +0100
Message-ID:  <89f6eebfa85b31c635b774e613f19b84b32f3e1f.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1870; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=GmbNDaUhHwKyIVnew22ILj2umAeQoC+JyFObDDBbKhg=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfAjlFLaqqtL+Rs91coinoQ6dAlqCg7J72OO U7JTxxI/Y+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3wAAKCRCPgPtYfRL+ TqT9B/9AzeQcDsubCeCc7ASpZHLCqp+QZFrbL0YBSSbkX93vuDAfIqvoNgCBknvBjhxaS3h6Uoe cPQ2w5nBHLg0OGAoO3sva4O0Oc3TDc6Rg6C3/NI4VdevUI7TabhW6TVJVSC+BTfhCfQQvYdUzwK QkLDycHQniRHNd1j6kT11x0a2OaUtjnPCdbcZSthUYQLMs6IV5UgijayXtIu6kaW1ST9G9Xi5Zs j4eUaO3pkqJ5I6z0snz36okix/e8MYl3otboKmmWvpawPtm5aKYNN6W/QCsOsGgIH1oJF1tuv4v aLKGy1kprQW1gDXR/lieS/ezgbW97z1k2fwQAYm/DBl1CxQO
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
 drivers/char/hw_random/atmel-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index a37367ebcbac..e9157255f851 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -161,15 +161,13 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int atmel_trng_remove(struct platform_device *pdev)
+static void atmel_trng_remove(struct platform_device *pdev)
 {
 	struct atmel_trng *trng = platform_get_drvdata(pdev);
 
 	atmel_trng_cleanup(trng);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-
-	return 0;
 }
 
 static int __maybe_unused atmel_trng_runtime_suspend(struct device *dev)
@@ -218,7 +216,7 @@ MODULE_DEVICE_TABLE(of, atmel_trng_dt_ids);
 
 static struct platform_driver atmel_trng_driver = {
 	.probe		= atmel_trng_probe,
-	.remove		= atmel_trng_remove,
+	.remove_new	= atmel_trng_remove,
 	.driver		= {
 		.name	= "atmel-trng",
 		.pm	= pm_ptr(&atmel_trng_pm_ops),
-- 
2.42.0

