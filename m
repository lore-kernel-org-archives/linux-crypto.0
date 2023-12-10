Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9022F2
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:51 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2a-0006P1-HV; Sun, 10 Dec 2023 23:12:48 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2V-00ExYL-4i; Sun, 10 Dec 2023 23:12:43 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-000RWc-Rr; Sun, 10 Dec 2023 23:12:42 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Martin Kaiser <martin@kaiser.cx>,
	Yangtao Li <frank.li@vivo.com>,
	linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 11/12] hwrng: timeriomem - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:26 +0100
Message-ID:  <e0179f207f9a2ab4666c72815dfbe3be6148d807.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1826; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=GoyYhW4hqUD9otfip9b0ONnav2BwKPc9Zk90sy92jcc=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfMZsY79aVg6OTRVxuPEwEwxPs3Oa6gJt+uI I5yFQJcnDuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3zAAKCRCPgPtYfRL+ TuzEB/9Csdi0tK9fgYn3RExFiJcfEWtBoVJj+JqHIcP+uaCOL9mOblmxi5Mpi2R197nNFLAggt0 nNZwf0s4jVQoB1Zdqv6hyCOUPooH3QUogSM1R6RH44xVmw7OwM0sU8C4ZFS6ruTGvKivcVgr4Rn 7FbVq7I1VNTH+9Mc3NlLPywE2qdhAZ2VryTk9NsY3OUev43p6K1yesniobyWC+OyeX5OF0ISuH0 oTgCYllJwukj5QkHp6sDgdWXl/VnFdmsmfSBh2vrHCltKPW0yI1xMWNQqg9b1XuPfWmnPGxKwW/ 5aKm3bUmkGn0MRGhybRbVKpF8iblIXuaNFHCr5WL7Zn+CZcu
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
 drivers/char/hw_random/timeriomem-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index 3db9d868efb1..65b8260339f5 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -174,13 +174,11 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int timeriomem_rng_remove(struct platform_device *pdev)
+static void timeriomem_rng_remove(struct platform_device *pdev)
 {
 	struct timeriomem_rng_private *priv = platform_get_drvdata(pdev);
 
 	hrtimer_cancel(&priv->timer);
-
-	return 0;
 }
 
 static const struct of_device_id timeriomem_rng_match[] = {
@@ -195,7 +193,7 @@ static struct platform_driver timeriomem_rng_driver = {
 		.of_match_table	= timeriomem_rng_match,
 	},
 	.probe		= timeriomem_rng_probe,
-	.remove		= timeriomem_rng_remove,
+	.remove_new	= timeriomem_rng_remove,
 };
 
 module_platform_driver(timeriomem_rng_driver);
-- 
2.42.0

