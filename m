From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/4] crypto: caam - platform_bus_type migration
Date: Sat, 14 May 2011 22:07:55 -0500
Message-ID: <20110514220755.a5dad77f.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:9335 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1EODIG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 May 2011 23:08:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

this fixes a build error since cryptodev-2.6 got rebased
to include commit d714d1979d7b4df7e2c127407f4014ce71f73cd0
"dt: eliminate of_platform_driver shim code".

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 59aae4e..9009713 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -44,8 +44,7 @@ static int caam_remove(struct platform_device *pdev)
 }
 
 /* Probe routine for CAAM top (controller) level */
-static int caam_probe(struct platform_device *pdev,
-		      const struct of_device_id *devmatch)
+static int caam_probe(struct platform_device *pdev)
 {
 	int d, ring, rspec;
 	struct device *dev;
@@ -242,7 +241,7 @@ static struct of_device_id caam_match[] = {
 };
 MODULE_DEVICE_TABLE(of, caam_match);
 
-static struct of_platform_driver caam_driver = {
+static struct platform_driver caam_driver = {
 	.driver = {
 		.name = "caam",
 		.owner = THIS_MODULE,
@@ -254,12 +253,12 @@ static struct of_platform_driver caam_driver = {
 
 static int __init caam_base_init(void)
 {
-	return of_register_platform_driver(&caam_driver);
+	return platform_driver_register(&caam_driver);
 }
 
 static void __exit caam_base_exit(void)
 {
-	return of_unregister_platform_driver(&caam_driver);
+	return platform_driver_unregister(&caam_driver);
 }
 
 module_init(caam_base_init);
-- 
1.7.5.1
