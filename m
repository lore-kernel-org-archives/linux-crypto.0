From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hash - Add AHASH_REQUEST_ON_STACK
Date: Thu, 20 Aug 2015 17:02:40 +0800
Message-ID: <20150820090240.GA27976@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43442 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbHTJCo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 05:02:44 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helper AHASH_REQUEST_ON_STACK for those users
of ahash that are synchronous only.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/hash.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 57c8a6e..8e920b4 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -63,6 +63,11 @@ struct ahash_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+#define AHASH_REQUEST_ON_STACK(name, ahash) \
+	char __##name##_desc[sizeof(struct ahash_request) + \
+		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
+	struct ahash_request *name = (void *)__##name##_desc
+
 /**
  * struct ahash_alg - asynchronous message digest definition
  * @init: Initialize the transformation context. Intended only to initialize the
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
