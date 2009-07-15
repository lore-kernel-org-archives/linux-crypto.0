From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/35] crypto: async - Use kzfree for requests
Date: Wed, 15 Jul 2009 15:16:03 +0800
Message-ID: <E1MQyih-0004z5-7d@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53622 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752610AbZGOHQF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyih-0004pl-SK
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:04 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: async - Use kzfree for requests

This patch changes the kfree call to kzfree for async requests.
As the request may contain sensitive data it needs to be zeroed
before it can be reallocated by others.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/hash.h  |    2 +-
 include/linux/crypto.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3c4cce6..f74214a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -186,7 +186,7 @@ static inline struct ahash_request *ahash_request_alloc(
 
 static inline void ahash_request_free(struct ahash_request *req)
 {
-	kfree(req);
+	kzfree(req);
 }
 
 static inline struct ahash_request *ahash_request_cast(
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ec29fa2..274f9c7 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -770,7 +770,7 @@ static inline struct ablkcipher_request *ablkcipher_request_alloc(
 
 static inline void ablkcipher_request_free(struct ablkcipher_request *req)
 {
-	kfree(req);
+	kzfree(req);
 }
 
 static inline void ablkcipher_request_set_callback(
@@ -901,7 +901,7 @@ static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 
 static inline void aead_request_free(struct aead_request *req)
 {
-	kfree(req);
+	kzfree(req);
 }
 
 static inline void aead_request_set_callback(struct aead_request *req,
