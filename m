Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5672F4
	for <linux-crypto@vger.kernel.org>; Sun, 10 Dec 2023 14:12:53 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2a-0006P0-BC; Sun, 10 Dec 2023 23:12:48 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-00ExYI-U3; Sun, 10 Dec 2023 23:12:42 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1rCS2U-000RWY-Ks; Sun, 10 Dec 2023 23:12:42 +0100
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Rob Herring <robh@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: [PATCH 10/12] hwrng: stm32 - Convert to platform remove callback returning void
Date: Sun, 10 Dec 2023 23:12:25 +0100
Message-ID:  <855e8e89de0c0e2a82e181b883275754f8c16a38.1702245873.git.u.kleine-koenig@pengutronix.de>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686; i=u.kleine-koenig@pengutronix.de; h=from:subject:message-id; bh=tJ2yKb21/v8dgfuhgALzaxDexLMP8sgVYPpXDzQrTKs=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBldjfKeIvGJORSVKGHwwwyFKf7y9MUJlfleH1Jl DiYf7f3Vr+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZXY3ygAKCRCPgPtYfRL+ TtbwCACuhFqANg8WSx60uhQJSpr0JdPEteh6pcmqE2mfzI4AetRrLIKWj1F8o/MM6mj3cU8M+4S hcitsrZA76q3cL4RTQFzPX8JkrSwm4OjxGDEQFOrAa/l69INUglpYKYPEFBrrLks8D/HDJ2Ift7 rKB3lNgzJ7lTJe+SpojQGsoe5gLsxivIIcc4XsVJ0iuoDVp57EN5iyVZoA+mGSTvkQwi44SaX8Q VUbOiHSuksPBkyd8R06N588Wo369O08Ff6WCrv/QbArB+eI+pjwBKaW7YNTIA9cVbfxX+/qKx+z 99S4hJ0pj3y0TEfK3h400SL6iP3K9C10AE+L30YTDOrqLhro
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
 drivers/char/hw_random/stm32-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 41e1dbea5d2e..98c92b914cfd 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -362,11 +362,9 @@ static int stm32_rng_init(struct hwrng *rng)
 	return 0;
 }
 
-static int stm32_rng_remove(struct platform_device *ofdev)
+static void stm32_rng_remove(struct platform_device *ofdev)
 {
 	pm_runtime_disable(&ofdev->dev);
-
-	return 0;
 }
 
 static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
@@ -557,7 +555,7 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
+	.remove_new = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
-- 
2.42.0

