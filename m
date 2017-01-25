From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] crypto: doc - Fix hash export state information
Date: Wed, 25 Jan 2017 16:55:06 +0100
Message-ID: <1485359706-7184-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
        Rabin Vincent <rabinv@axis.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:41293 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdAYPzK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2017 10:55:10 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rabin Vincent <rabinv@axis.com>

The documentation states that crypto_ahash_reqsize() provides the size
of the state structure used by crypto_ahash_export().  But it's actually
crypto_ahash_statesize() which provides this size.

Signed-off-by: Rabin Vincent <rabinv@axis.com>
---
 include/crypto/hash.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 216a2b8..26ebbbc 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -329,6 +329,16 @@ static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 	return crypto_hash_alg_common(tfm)->digestsize;
 }
 
+/**
+ * crypto_ahash_statesize() - obtain size of the ahash state
+ * @tfm: cipher handle
+ *
+ * Return the size of the ahash state. With the crypto_ahash_export
+ * function, the caller can export the state into a buffer whose size is
+ * defined with this function.
+ *
+ * Return: size of the ahash state
+ */
 static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
 {
 	return crypto_hash_alg_common(tfm)->statesize;
@@ -365,16 +375,6 @@ static inline struct crypto_ahash *crypto_ahash_reqtfm(
 	return __crypto_ahash_cast(req->base.tfm);
 }
 
-/**
- * crypto_ahash_reqsize() - obtain size of the request data structure
- * @tfm: cipher handle
- *
- * Return the size of the ahash state size. With the crypto_ahash_export
- * function, the caller can export the state into a buffer whose size is
- * defined with this function.
- *
- * Return: size of the ahash state
- */
 static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 {
 	return tfm->reqsize;
@@ -453,7 +453,7 @@ int crypto_ahash_digest(struct ahash_request *req);
  *
  * This function exports the hash state of the ahash_request handle into the
  * caller-allocated output buffer out which must have sufficient size (e.g. by
- * calling crypto_ahash_reqsize).
+ * calling crypto_ahash_statesize).
  *
  * Return: 0 if the export was successful; < 0 if an error occurred
  */
-- 
2.1.4
