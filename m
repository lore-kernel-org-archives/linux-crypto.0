From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/4] crypto: doc - fix header file name
Date: Wed, 30 Nov 2016 15:16:09 +0200
Message-ID: <25e074fd92dedfed22387e694b049300386cf034.1480511771.git.baruch@tkos.co.il>
References: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Cc: linux-crypto@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54096 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756482AbcK3NQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:16:24 -0500
In-Reply-To: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes: 8bc618d6a2e0 ("crypto: doc - Use ahash")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/crypto/api-intro.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index beda682e8d77..96bd46033d28 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -49,7 +49,7 @@ under development.
 
 Here's an example of how to use the API:
 
-	#include <crypto/ahash.h>
+	#include <crypto/hash.h>
 	#include <linux/err.h>
 	#include <linux/scatterlist.h>
 	
-- 
2.10.2
