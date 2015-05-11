From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/24] crypto: ixp4xx - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:44 +0800
Message-ID: <E1YrkJM-000191-Ja@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46771 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKJrr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:47 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJM-0000Do-PB
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:44 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ixp4xx_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 48f4535..a8875b4 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -25,7 +25,7 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/algapi.h>
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 
