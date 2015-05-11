From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/24] crypto: aead - Add crypto_aead_set_reqsize helper
Date: Mon, 11 May 2015 17:47:52 +0800
Message-ID: <E1YrkJU-0001CF-81@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58386 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbEKJr4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:56 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJV-0000Gm-4w
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:53 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper crypto_aead_set_reqsize so that people
don't have to directly access the aead internals to set the reqsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/aead.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 2eba340..750948c 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -78,5 +78,11 @@ static inline void aead_givcrypt_complete(struct aead_givcrypt_request *req,
 	aead_request_complete(&req->areq, err);
 }
 
+static inline void crypto_aead_set_reqsize(struct crypto_aead *aead,
+					   unsigned int reqsize)
+{
+	crypto_aead_crt(aead)->reqsize = reqsize;
+}
+
 #endif	/* _CRYPTO_INTERNAL_AEAD_H */
 
