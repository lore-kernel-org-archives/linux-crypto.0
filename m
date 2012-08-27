From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] crypto: geode-aes: Use module_pci_driver
Date: Mon, 27 Aug 2012 15:45:31 +0530
Message-ID: <1346062531-27827-1-git-send-email-sachin.kamat@linaro.org>
Cc: linux-geode@lists.infradead.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, sachin.kamat@linaro.org, patches@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41740 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2H0KRw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Aug 2012 06:17:52 -0400
Received: by pbbrr13 with SMTP id rr13so7181144pbb.19
        for <linux-crypto@vger.kernel.org>; Mon, 27 Aug 2012 03:17:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

module_pci_driver makes the code simpler by eliminating
module_init and module_exit calls.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/geode-aes.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 933fb4b4..51f196d 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -585,21 +585,8 @@ static struct pci_driver geode_aes_driver = {
 	.remove = __devexit_p(geode_aes_remove)
 };
 
-static int __init
-geode_aes_init(void)
-{
-	return pci_register_driver(&geode_aes_driver);
-}
-
-static void __exit
-geode_aes_exit(void)
-{
-	pci_unregister_driver(&geode_aes_driver);
-}
+module_pci_driver(geode_aes_driver);
 
 MODULE_AUTHOR("Advanced Micro Devices, Inc.");
 MODULE_DESCRIPTION("Geode LX Hardware AES driver");
 MODULE_LICENSE("GPL");
-
-module_init(geode_aes_init);
-module_exit(geode_aes_exit);
-- 
1.7.4.1
