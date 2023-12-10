Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0638AF1
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:50 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2X-0006Oe-12; Sun, 10 Dec 2023 23:12:45 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-00ExXu-TN; Sun, 10 Dec 2023 23:12:40 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2S-000RVs-KN; Sun, 10 Dec 2023 23:12:40 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hadar Gat <hadar.gat@arm.com>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 02/12] hwrng: cctrng - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:17 +0100
Message-ID:  <12bbad702295f61973f7748202d974c1ce0a1ffd.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=og/MzwfUHeURuBEhoT2JDT4GfuRVh9ytkXP407qamAw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfBwAFzkLCXDU51FssjUbiXsuSDkxgSYi1lm ZrMwZLW7oCJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3wQAKCRCPgPtYfRL+ TpB7B/41WZTzMuKei168iiuj1+4u12AjSjAwLxH6aZlinG+OQJt7iPj4Dqhba92D2VHbO3/LjBo HW6dfQGu/6Vakkc3NBIUqqjq70PAK1v+zAHUXHBYerD2r/B/P0TxEhzWzaifyFTjW979HxRvls1 ol/boVwCLg1s1+zS478pEk8R+IbJkbaQPqAB8XsREiHQ/SHGWvNrDJtR84QrE2DnJ0Gp6Qgw/cd j3NQEeoxEK2OO0lS9NwLuckDFfhHkcOaNvjuOaztLVkWIFBIQHJLPlQZpbbznreyE3XoKQ3A0hl Lom/YK4RT/H3V/pGFSdso0vvh26RkZp70sxSKVPNP7ybxtkO
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
 drivers/char/hw_random/cctrng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 1abbff04a015..c0d2f824769f 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -560,7 +560,7 @@ static int cctrng_probe(struct platform_device *pdev)
 	return rc;
 }
 
-static int cctrng_remove(struct platform_device *pdev)
+static void cctrng_remove(struct platform_device *pdev)
 {
 	struct cctrng_drvdata *drvdata = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
@@ -570,8 +570,6 @@ static int cctrng_remove(struct platform_device *pdev)
 	cc_trng_pm_fini(drvdata);
 
 	dev_info(dev, "ARM cctrng device terminated\n");
-
-	return 0;
 }
 
 static int __maybe_unused cctrng_suspend(struct device *dev)
@@ -654,7 +652,7 @@ static struct platform_driver cctrng_driver = {
 		.pm = &cctrng_pm,
 	},
 	.probe = cctrng_probe,
-	.remove = cctrng_remove,
+	.remove_new = cctrng_remove,
 };
 
 module_platform_driver(cctrng_driver);
-- 
2.42.0

