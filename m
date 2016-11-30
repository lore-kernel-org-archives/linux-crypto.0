From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 3/4] crypt: doc - remove misleading mention of async API
Date: Wed, 30 Nov 2016 15:16:10 +0200
Message-ID: <10a29b13570a83bc506b5113064b02e016d1f3db.1480511771.git.baruch@tkos.co.il>
References: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Cc: linux-crypto@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54100 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcK3NQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:16:24 -0500
In-Reply-To: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The asynchronous API is quite mature. Not mentioning is at all is probably
better than saying it is under development.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/crypto/api-intro.txt | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 96bd46033d28..45d943fcae5b 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -44,9 +44,6 @@ one block while the former can operate on an arbitrary amount of data,
 subject to block size requirements (i.e., non-stream ciphers can only
 process multiples of blocks).
 
-Support for hardware crypto devices via an asynchronous interface is
-under development.
-
 Here's an example of how to use the API:
 
 	#include <crypto/hash.h>
-- 
2.10.2
