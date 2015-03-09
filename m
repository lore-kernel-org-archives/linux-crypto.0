From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/4] hwrng: omap - remove incorrect __exit markups
Date: Mon,  9 Mar 2015 10:36:35 -0700
Message-ID: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37850 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbCIRgx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 13:36:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Even if bus is not hot-pluggable, the devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods. The only exception is drivers registered with
platform_driver_probe() which specifically disables sysfs bind/unbind
attributes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/omap-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d14dcf7..7f3597d 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -408,7 +408,7 @@ err_ioremap:
 	return ret;
 }
 
-static int __exit omap_rng_remove(struct platform_device *pdev)
+static int omap_rng_remove(struct platform_device *pdev)
 {
 	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
 
@@ -460,7 +460,7 @@ static struct platform_driver omap_rng_driver = {
 		.of_match_table = of_match_ptr(omap_rng_of_match),
 	},
 	.probe		= omap_rng_probe,
-	.remove		= __exit_p(omap_rng_remove),
+	.remove		= omap_rng_remove,
 };
 
 module_platform_driver(omap_rng_driver);
-- 
2.2.0.rc0.207.ga3a616c
