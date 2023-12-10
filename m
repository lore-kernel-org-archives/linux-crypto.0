Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA856D5
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:59 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2a-0006P2-Om; Sun, 10 Dec 2023 23:12:48 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2V-00ExYO-BZ; Sun, 10 Dec 2023 23:12:43 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2V-000RWg-2M; Sun, 10 Dec 2023 23:12:43 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>,
	Yu Zhe <yuzhe@nfschina.com>,
	Alexandru Ardelean <alex@shruggie.ro>,
	Andrei Coardos <aboutphysycs@gmail.com>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 12/12] hwrng: xgene - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:27 +0100
Message-ID:  <bc57ab04935fbe095bb8d57d429814f318b705c6.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=mN7xk7QsPOcC0j/g54df2+kqbjC/D4ebugbpGZYp7CA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfNynOBaBsJSCGl8hNZg+be4mu/4NwIYnf2x KEZFiauQWGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3zQAKCRCPgPtYfRL+ TtkrCACBWB9zjTG7BZO7yYsXtfz1fTzQ71AHPthrvZgeo1E+iXm8MjhD3RkQNbs8LwDcOYczR8P MUvwSmOdhWT7t9rvVZ7aJBbe/q83uE3572pNSRYHgVojWcu4UcYt+0IOw9hdTzrMJtvU/nEPAih +uaTNIyGitBeBXW8NyroVvfzmF1bF1Of4kw3y4jKE4Wwh+U535vZZUo5YcZfkegHNgwjPtLpD7u Efu6AO29iOTY7lGdSxiSiI43Os+mmavdtarN2yVeCxyEFGSTyX3tLIJI1d4DjigArWe5K+NPn6h L93lS/dmxYDKnL5/lqt0fk4IIZy4zmx9JrZidG6ldGzsi24R
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
 drivers/char/hw_random/xgene-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 7382724bf501..642d13519464 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -357,15 +357,13 @@ static int xgene_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int xgene_rng_remove(struct platform_device *pdev)
+static void xgene_rng_remove(struct platform_device *pdev)
 {
 	int rc;
 
 	rc = device_init_wakeup(&pdev->dev, 0);
 	if (rc)
 		dev_err(&pdev->dev, "RNG init wakeup failed error %d\n", rc);
-
-	return 0;
 }
 
 static const struct of_device_id xgene_rng_of_match[] = {
@@ -377,7 +375,7 @@ MODULE_DEVICE_TABLE(of, xgene_rng_of_match);
 
 static struct platform_driver xgene_rng_driver = {
 	.probe = xgene_rng_probe,
-	.remove	= xgene_rng_remove,
+	.remove_new = xgene_rng_remove,
 	.driver = {
 		.name		= "xgene-rng",
 		.of_match_table = xgene_rng_of_match,
-- 
2.42.0

