From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/4] crypto: api - fix comment typo
Date: Wed, 30 Nov 2016 15:16:08 +0200
Message-ID: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Cc: linux-crypto@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54095 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756489AbcK3NQZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:16:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/linux/crypto.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7cee5551625b..e4f250a108e7 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -87,7 +87,7 @@
 #define CRYPTO_ALG_TESTED		0x00000400
 
 /*
- * Set if the algorithm is an instance that is build from templates.
+ * Set if the algorithm is an instance that is built from templates.
  */
 #define CRYPTO_ALG_INSTANCE		0x00000800
 
-- 
2.10.2
