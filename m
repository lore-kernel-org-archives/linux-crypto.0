From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCHv2] crypto: doc - Fix hash export state information
Date: Thu, 26 Jan 2017 16:33:00 +0100
Message-ID: <1485444780-17201-1-git-send-email-rabin.vincent@axis.com>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
        Rabin Vincent <rabinv@axis.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:50728 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753907AbdAZPdp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 10:33:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rabin Vincent <rabinv@axis.com>

The documentation states that crypto_ahash_reqsize() provides the size
of the state structure used by crypto_ahash_export().  But it's actually
crypto_ahash_statesize() which provides this size.

Signed-off-by: Rabin Vincent <rabinv@axis.com>
---
v2: Add crypto_ahash_statesize() to api-digest; don't remove doc for crypto_ahash_reqsize()

 Documentation/crypto/api-digest.rst |  2 +-
 include/crypto/hash.h               | 18 ++++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/crypto/api-digest.rst b/Documentation/crypto/api-digest.rst
index 07356fa..7a1e670 100644
--- a/Documentation/crypto/api-digest.rst
+++ b/Documentation/crypto/api-digest.rst
@@ -14,7 +14,7 @@ Asynchronous Message Digest API
    :doc: Asynchronous Message Digest API
 
 .. kernel-doc:: include/crypto/hash.h
-   :functions: crypto_alloc_ahash crypto_free_ahash crypto_ahash_init crypto_ahash_digestsize crypto_ahash_reqtfm crypto_ahash_reqsize crypto_ahash_setkey crypto_ahash_finup crypto_ahash_final crypto_ahash_digest crypto_ahash_export crypto_ahash_import
+   :functions: crypto_alloc_ahash crypto_free_ahash crypto_ahash_init crypto_ahash_digestsize crypto_ahash_reqtfm crypto_ahash_reqsize crypto_ahash_statesize crypto_ahash_setkey crypto_ahash_finup crypto_ahash_final crypto_ahash_digest crypto_ahash_export crypto_ahash_import
 
 Asynchronous Hash Request Handle
 --------------------------------
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 216a2b8..b5727bc 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -329,6 +329,16 @@ static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
 	return crypto_hash_alg_common(tfm)->digestsize;
 }
 
+/**
+ * crypto_ahash_statesize() - obtain size of the ahash state
+ * @tfm: cipher handle
+ *
+ * Return the size of the ahash state. With the crypto_ahash_export()
+ * function, the caller can export the state into a buffer whose size is
+ * defined with this function.
+ *
+ * Return: size of the ahash state
+ */
 static inline unsigned int crypto_ahash_statesize(struct crypto_ahash *tfm)
 {
 	return crypto_hash_alg_common(tfm)->statesize;
@@ -369,11 +379,7 @@ static inline struct crypto_ahash *crypto_ahash_reqtfm(
  * crypto_ahash_reqsize() - obtain size of the request data structure
  * @tfm: cipher handle
  *
- * Return the size of the ahash state size. With the crypto_ahash_export
- * function, the caller can export the state into a buffer whose size is
- * defined with this function.
- *
- * Return: size of the ahash state
+ * Return: size of the request data
  */
 static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 {
@@ -453,7 +459,7 @@ int crypto_ahash_digest(struct ahash_request *req);
  *
  * This function exports the hash state of the ahash_request handle into the
  * caller-allocated output buffer out which must have sufficient size (e.g. by
- * calling crypto_ahash_reqsize).
+ * calling crypto_ahash_statesize()).
  *
  * Return: 0 if the export was successful; < 0 if an error occurred
  */
-- 
2.1.4
