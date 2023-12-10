Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF64D8
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2W-0006Ox-Ky; Sun, 10 Dec 2023 23:12:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-00ExY9-6N; Sun, 10 Dec 2023 23:12:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-000RWM-TM; Sun, 10 Dec 2023 23:12:41 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 07/12] hwrng: n2 - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:22 +0100
Message-ID:  <8a470b0d899f42d49c679ff763d3133a109830b2.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1785; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=8DSLRtuH+m4SMxX9zwxvj2v6domeulWXdRnv2oPApBI=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfHJdbX/wTFWIIxAplaJw+kOoz5Zd89+LgU3 3YIdsB068qJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3xwAKCRCPgPtYfRL+ TtyvCACKcLL8YKWZbPbDToddG6ilsbTeNS/VGvFFmodKoqHEueCRgZnOLr7vgTbtgLfp4V6XRl+ UMh/cGqLnmbyCQ22EChCtuvmrOnKrsLZF9NfyUZ6G/Tqx7E+ekeCMHqfHQ4QqfbwlWF/T/EfZYG Xopwqfa2I3X4cEyE48cCuDopkpF7kdm9kn18jca18OyOmuiAV94/QNl531XCY8MauZ+vnlc9ofS x55CEQAuRt213ThTbN2xYNsWmOl8G+ve0zwTuvU29MnN1YXZfTnv/RqUbVPu3prGR2enUC4DmQX GSX5p014NuOMcUxK0D1TkfY2qQ+jsYbctshTBbTQFa27MWFc
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
 drivers/char/hw_random/n2-drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index aaae16b98475..2e669e7c14d3 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -781,7 +781,7 @@ static int n2rng_probe(struct platform_device *op)
 	return err;
 }
 
-static int n2rng_remove(struct platform_device *op)
+static void n2rng_remove(struct platform_device *op)
 {
 	struct n2rng *np = platform_get_drvdata(op);
 
@@ -790,8 +790,6 @@ static int n2rng_remove(struct platform_device *op)
 	cancel_delayed_work_sync(&np->work);
 
 	sun4v_hvapi_unregister(HV_GRP_RNG);
-
-	return 0;
 }
 
 static struct n2rng_template n2_template = {
@@ -860,7 +858,7 @@ static struct platform_driver n2rng_driver = {
 		.of_match_table = n2rng_match,
 	},
 	.probe		= n2rng_probe,
-	.remove		= n2rng_remove,
+	.remove_new	= n2rng_remove,
 };
 
 module_platform_driver(n2rng_driver);
-- 
2.42.0

