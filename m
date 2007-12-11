From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/19] [CRYPTO] skcipher: Added skcipher_givcrypt_complete
Date: Tue, 11 Dec 2007 12:05:39 +0800
Message-ID: <E1J1wNH-0002kn-00@gondolin.me.apana.org.au>
References: <20071211040215.GA10360@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1958 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbXLKEFm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 23:05:42 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1wNI-00067o-Kc
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 15:05:40 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Added skcipher_givcrypt_complete

This patch adds the helper skcipher_givcrypt_complete which should be
called when an ablkcipher algorithm has completed a givcrypt request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/internal/skcipher.h |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 07e7c82..80c5bfb 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -74,5 +74,17 @@ static inline void *skcipher_givcrypt_reqctx(
 	return ablkcipher_request_ctx(&req->creq);
 }
 
+static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
+					       int err)
+{
+	req->base.complete(&req->base, err);
+}
+
+static inline void skcipher_givcrypt_complete(
+	struct skcipher_givcrypt_request *req, int err)
+{
+	ablkcipher_request_complete(&req->creq, err);
+}
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
