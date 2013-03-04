From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/2] crypto: omap-sham: Use module_platform_driver macro
Date: Mon,  4 Mar 2013 15:09:43 +0530
Message-ID: <1362389983-14141-2-git-send-email-sachin.kamat@linaro.org>
References: <1362389983-14141-1-git-send-email-sachin.kamat@linaro.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:40738 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3CDJuN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Mar 2013 04:50:13 -0500
Received: by mail-da0-f48.google.com with SMTP id w4so2444959dam.21
        for <linux-crypto@vger.kernel.org>; Mon, 04 Mar 2013 01:50:12 -0800 (PST)
In-Reply-To: <1362389983-14141-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

module_platform_driver() makes the code simpler by eliminating boilerplate
code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/omap-sham.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 3d1611f..7a67d30 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1813,18 +1813,7 @@ static struct platform_driver omap_sham_driver = {
 	},
 };
 
-static int __init omap_sham_mod_init(void)
-{
-	return platform_driver_register(&omap_sham_driver);
-}
-
-static void __exit omap_sham_mod_exit(void)
-{
-	platform_driver_unregister(&omap_sham_driver);
-}
-
-module_init(omap_sham_mod_init);
-module_exit(omap_sham_mod_exit);
+module_platform_driver(omap_sham_driver);
 
 MODULE_DESCRIPTION("OMAP SHA1/MD5 hw acceleration support.");
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1
