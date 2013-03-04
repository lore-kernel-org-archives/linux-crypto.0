From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/2] crypto: omap-aes: Use module_platform_driver macro
Date: Mon,  4 Mar 2013 15:09:42 +0530
Message-ID: <1362389983-14141-1-git-send-email-sachin.kamat@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52954 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3CDJuK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Mar 2013 04:50:10 -0500
Received: by mail-pa0-f49.google.com with SMTP id kp6so3028097pab.8
        for <linux-crypto@vger.kernel.org>; Mon, 04 Mar 2013 01:50:10 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

module_platform_driver() makes the code simpler by eliminating boilerplate
code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/omap-aes.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 6aa425f..bd304e1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1248,18 +1248,7 @@ static struct platform_driver omap_aes_driver = {
 	},
 };
 
-static int __init omap_aes_mod_init(void)
-{
-	return  platform_driver_register(&omap_aes_driver);
-}
-
-static void __exit omap_aes_mod_exit(void)
-{
-	platform_driver_unregister(&omap_aes_driver);
-}
-
-module_init(omap_aes_mod_init);
-module_exit(omap_aes_mod_exit);
+module_platform_driver(omap_aes_driver);
 
 MODULE_DESCRIPTION("OMAP AES hw acceleration support.");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1
