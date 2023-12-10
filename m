Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F368FD9
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2W-0006Og-Ky; Sun, 10 Dec 2023 23:12:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-00ExY0-DC; Sun, 10 Dec 2023 23:12:41 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-000RW0-48; Sun, 10 Dec 2023 23:12:41 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 04/12] hwrng: ingenic - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:19 +0100
Message-ID:  <98f6381830d8134693e874c3771165a117e2d8e7.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=BzSzY+egDa38u2fJq725qloJVp+pK7gT9Jw7wYVpys4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfDWaKwPBgf7VfTqdxPsmep4C6oEeMEGZULJ urcZha/+U6JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3wwAKCRCPgPtYfRL+ TkeHB/9IErYhK93v9gJT3vegRHgSCgRUb9hD/XqDOsahUZX+ap+KBklpcSINVzglAEDEawUckIf i3SMKPGWvuIwISj+BCEXMHkfpYqR3EcrIrYb6RGBLn5m3X7x6gcTzLS7lLYu1BEr+IAwn/dn2XW TZ1yn4y4zght9Z15/VEJKBui91iZ2GTVn8VntO7iyl2a7+FpZ+IwbjqPyKlNsf5jv44JGtkLAOU FFf3MYNYA64o8z/nYi/jHahdWPcRfoaT8ke/T7V0Fl+ztgW+GOhTxyZNsNd32/pynvfEunxNaKC EdR3CfPjN1tK0XyF+ZgoBx8EzyOhVmxAIPjMk5pqfzFByp+P
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
 drivers/char/hw_random/ingenic-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/ingenic-rng.c b/drivers/char/hw_random/ingenic-rng.c
index c74ded64fbe3..2f9b6483c4a1 100644
--- a/drivers/char/hw_random/ingenic-rng.c
+++ b/drivers/char/hw_random/ingenic-rng.c
@@ -114,15 +114,13 @@ static int ingenic_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ingenic_rng_remove(struct platform_device *pdev)
+static void ingenic_rng_remove(struct platform_device *pdev)
 {
 	struct ingenic_rng *priv = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&priv->rng);
 
 	writel(0, priv->base + RNG_REG_ERNG_OFFSET);
-
-	return 0;
 }
 
 static const struct of_device_id ingenic_rng_of_match[] = {
@@ -134,7 +132,7 @@ MODULE_DEVICE_TABLE(of, ingenic_rng_of_match);
 
 static struct platform_driver ingenic_rng_driver = {
 	.probe		= ingenic_rng_probe,
-	.remove		= ingenic_rng_remove,
+	.remove_new	= ingenic_rng_remove,
 	.driver		= {
 		.name	= "ingenic-rng",
 		.of_match_table = ingenic_rng_of_match,
-- 
2.42.0

