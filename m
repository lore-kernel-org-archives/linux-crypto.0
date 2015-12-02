From: Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH] crypto: n2 - Use platform_register/unregister_drivers()
Date: Wed,  2 Dec 2015 17:16:36 +0100
Message-ID: <1449072996-10591-1-git-send-email-thierry.reding@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35599 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbLBQQi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Dec 2015 11:16:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

These new helpers simplify implementing multi-driver modules and
properly handle failure to register one driver by unregistering all
previously registered drivers.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/crypto/n2_core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 5450880abb7b..739a786b9f08 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2243,22 +2243,19 @@ static struct platform_driver n2_mau_driver = {
 	.remove		=	n2_mau_remove,
 };
 
+static struct platform_driver * const drivers[] = {
+	&n2_crypto_driver,
+	&n2_mau_driver,
+};
+
 static int __init n2_init(void)
 {
-	int err = platform_driver_register(&n2_crypto_driver);
-
-	if (!err) {
-		err = platform_driver_register(&n2_mau_driver);
-		if (err)
-			platform_driver_unregister(&n2_crypto_driver);
-	}
-	return err;
+	return platform_register_drivers(drivers, ARRAY_SIZE(drivers));
 }
 
 static void __exit n2_exit(void)
 {
-	platform_driver_unregister(&n2_mau_driver);
-	platform_driver_unregister(&n2_crypto_driver);
+	platform_unregister_drivers(drivers, ARRAY_SIZE(drivers));
 }
 
 module_init(n2_init);
-- 
2.5.0
