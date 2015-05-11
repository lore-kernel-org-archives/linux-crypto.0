From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 23/24] crypto: cryptd - Add missing aead.h inclusion
Date: Mon, 11 May 2015 17:48:11 +0800
Message-ID: <E1YrkJn-0001GT-32@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58449 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbbEKJsO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:48:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJn-0000Mi-Uo
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:48:12 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptd.h needs to include crypto/aead.h because it uses crypto_aead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/cryptd.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/crypto/cryptd.h b/include/crypto/cryptd.h
index ba98918..1547f54 100644
--- a/include/crypto/cryptd.h
+++ b/include/crypto/cryptd.h
@@ -14,6 +14,7 @@
 
 #include <linux/crypto.h>
 #include <linux/kernel.h>
+#include <crypto/aead.h>
 #include <crypto/hash.h>
 
 struct cryptd_ablkcipher {
