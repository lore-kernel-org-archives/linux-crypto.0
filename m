From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/24] crypto: authencesn - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:42 +0800
Message-ID: <E1YrkJK-00018R-7l@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57819 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKJrp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJK-0000DX-FM
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:42 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authencesn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 024bff2..91e2cc3 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
