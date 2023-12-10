Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45211F3
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:52 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2W-0006Oy-UR; Sun, 10 Dec 2023 23:12:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-00ExYC-Do; Sun, 10 Dec 2023 23:12:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-000RWQ-4g; Sun, 10 Dec 2023 23:12:42 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>,
	Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>,
	openbmc@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 08/12] hwrng: npcm - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:23 +0100
Message-ID:  <a6cf7061713748667743e445ec00aa31f7c824b0.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1787; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=MuGl9Pi4du6aDKFhb44ZUIU1I3q41zByvx0vfz3i41g=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfI6ggc1VYruEGcrSh92NPHvPtjsOYybF78I 0GLTXesNLGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3yAAKCRCPgPtYfRL+ ToIjB/0cwvqloENXYLTCrsQoQM5KyK7tYCvgofA5HhRvmFooSWKH622upb1j9DGqYeIWYP1+blz WTD9Yh2+AeiHGILYNCQlnTZioP1F5dOwoMZINC1vA5xF0HnHV9R62osPbvGnTyMz7oVr4YZb/+O e43ibfm6Gx++mMH4OZJ4Vi2g78dP4lWFSSdwQyD7ojkfGi1XeHpljA41ujzJd35ddCbiaYJI7k+ Mf6ohtSWKCxf5mjZLL0EFuenz28xFuroQS9W28iBu+zbG+kRIhCHaz+unE7q7tpNxzDq62DKr2B y9l3aB+uStiRgEONbP3l1ula+SJ4WFylwXMKXcWzTr3MXZ5O
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
 drivers/char/hw_random/npcm-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 8a304b754217..bce8c4829a1f 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -126,15 +126,13 @@ static int npcm_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int npcm_rng_remove(struct platform_device *pdev)
+static void npcm_rng_remove(struct platform_device *pdev)
 {
 	struct npcm_rng *priv = platform_get_drvdata(pdev);
 
 	devm_hwrng_unregister(&pdev->dev, &priv->rng);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -178,7 +176,7 @@ static struct platform_driver npcm_rng_driver = {
 		.of_match_table = of_match_ptr(rng_dt_id),
 	},
 	.probe		= npcm_rng_probe,
-	.remove		= npcm_rng_remove,
+	.remove_new	= npcm_rng_remove,
 };
 
 module_platform_driver(npcm_rng_driver);
-- 
2.42.0

