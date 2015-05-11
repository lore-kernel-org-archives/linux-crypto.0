From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/24] crypto: authenc - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:41 +0800
Message-ID: <E1YrkJJ-000189-3e@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60374 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbEKJro (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:44 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJJ-0000DM-Be
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:41 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 78fb16c..325f37a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -10,7 +10,7 @@
  *
  */
 
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
