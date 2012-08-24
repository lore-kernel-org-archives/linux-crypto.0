From: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] crypto: ux500: hash: remove unneeded return at ux500_hash_mod_fini
Date: Fri, 24 Aug 2012 23:03:57 +0530
Message-ID: <1345829637-32062-1-git-send-email-develkernel412222@gmail.com>
Cc: Devendra Naga <develkernel412222@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab2HXReL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Aug 2012 13:34:11 -0400
Received: by pbbrr13 with SMTP id rr13so3860306pbb.19
        for <linux-crypto@vger.kernel.org>; Fri, 24 Aug 2012 10:34:10 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/crypto/ux500/hash/hash_core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 08d5032..873b69f 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -1991,7 +1991,6 @@ static int __init ux500_hash_mod_init(void)
 static void __exit ux500_hash_mod_fini(void)
 {
 	platform_driver_unregister(&hash_driver);
-	return;
 }
 
 module_init(ux500_hash_mod_init);
-- 
1.7.9.5
