Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A07CF
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2W-0006Oi-Kx; Sun, 10 Dec 2023 23:12:44 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-00ExY6-Tc; Sun, 10 Dec 2023 23:12:41 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2T-000RW8-KW; Sun, 10 Dec 2023 23:12:41 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH 06/12] hwrng: mxc - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:21 +0100
Message-ID:  <e6b365656865c8934342edab9a730652d976dd04.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1835; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=aWklsF4m7KKS+I4Wu0a1XcRMXztlVelCPKUldjZc5lU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfGnlS9qcVg8DF1/UVfFAhCNntrcLhQhl/bO onS9PJT3zqJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3xgAKCRCPgPtYfRL+ TkRyB/9eGmF+oyV93mG2GqUCsKtWDoglXP47aDDsEkzLD+tlsMSaXQ3XL7VYbEj2a597AVRDjSJ rasTo4nUCMz55qGppijQWoGD0thOJRpbx1KZ5DejYAg6fMWwRLyC+wXocL+8dHUYUjIEAOPfEwu OaAS3Debw0pWlkuFrVrAJa23MEqST0uwbcP4dxXeDA3LfOQAlWbLQaaIW8gttVULD74271NtVg3 s3EjmulKkLDK9zUBpqDJsyvKkqxaXDdltGZphTSMGnsMup9EGX19zKygApLVK4iVDRca3vAf28X l0ao+HU+UZHISJ2ZWKKX/vgGA7tpVpewP9Em7YQ9FUD8r0Fa
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
 drivers/char/hw_random/mxc-rnga.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 008763c988ed..07ec000e4cd7 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -176,15 +176,13 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit mxc_rnga_remove(struct platform_device *pdev)
+static void __exit mxc_rnga_remove(struct platform_device *pdev)
 {
 	struct mxc_rng *mxc_rng = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&mxc_rng->rng);
 
 	clk_disable_unprepare(mxc_rng->clk);
-
-	return 0;
 }
 
 static const struct of_device_id mxc_rnga_of_match[] = {
@@ -199,7 +197,7 @@ static struct platform_driver mxc_rnga_driver = {
 		.name = "mxc_rnga",
 		.of_match_table = mxc_rnga_of_match,
 	},
-	.remove = __exit_p(mxc_rnga_remove),
+	.remove_new = __exit_p(mxc_rnga_remove),
 };
 
 module_platform_driver_probe(mxc_rnga_driver, mxc_rnga_probe);
-- 
2.42.0

