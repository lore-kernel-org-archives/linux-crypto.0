From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/16] crypto: aead - Add crypto_aead_maxauthsize
Date: Thu, 21 May 2015 15:11:05 +0800
Message-ID: <E1YvKdF-0005eT-Ay@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33409 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbbEUHLI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:08 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdF-0002xw-Hk
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:05 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_aead_maxauthsize to remove the
need to directly dereference aead_alg internals by AEAD implementors.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/aead.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 84c17bb..4614f79 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -119,5 +119,10 @@ static inline void crypto_aead_set_reqsize(struct crypto_aead *aead,
 	crypto_aead_crt(aead)->reqsize = reqsize;
 }
 
+static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
+{
+	return crypto_old_aead_alg(aead)->maxauthsize;
+}
+
 #endif	/* _CRYPTO_INTERNAL_AEAD_H */
 
