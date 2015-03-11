From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [RESEND PATCH] hwrng: omap - remove #ifdefery around PM methods
Date: Wed, 11 Mar 2015 14:08:36 -0700
Message-ID: <20150311210836.GA8253@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Deepak Saxena <dsaxena@plexity.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35041 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbCKVIp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 17:08:45 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of using #ifdefs let's mark suspend and resume methods as
__maybe_unused which will suppress compiler warnings about them being
unused and provide better compile coverage.

Because SIMPLE_DEV_PM_OPS() produces an empty omap_rng_pm structure in
case of !CONFIG_PM_SLEEP neither omap_rng_suspend nor omap_rng_resume
will end up being referenced and the change will not result in
increasing image size.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/omap-rng.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 7f3597d..5c171b1 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -422,9 +422,7 @@ static int omap_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-
-static int omap_rng_suspend(struct device *dev)
+static int __maybe_unused omap_rng_suspend(struct device *dev)
 {
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
 
@@ -434,7 +432,7 @@ static int omap_rng_suspend(struct device *dev)
 	return 0;
 }
 
-static int omap_rng_resume(struct device *dev)
+static int __maybe_unused omap_rng_resume(struct device *dev)
 {
 	struct omap_rng_dev *priv = dev_get_drvdata(dev);
 
@@ -445,18 +443,11 @@ static int omap_rng_resume(struct device *dev)
 }
 
 static SIMPLE_DEV_PM_OPS(omap_rng_pm, omap_rng_suspend, omap_rng_resume);
-#define	OMAP_RNG_PM	(&omap_rng_pm)
-
-#else
-
-#define	OMAP_RNG_PM	NULL
-
-#endif
 
 static struct platform_driver omap_rng_driver = {
 	.driver = {
 		.name		= "omap_rng",
-		.pm		= OMAP_RNG_PM,
+		.pm		= &omap_rng_pm,
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-- 
2.2.0.rc0.207.ga3a616c


-- 
Dmitry
