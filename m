From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: document correct return value for request allocation
Date: Sat,  2 Apr 2016 10:54:56 -0500
Message-ID: <1459612496-5094-1-git-send-email-ebiggers3@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers3@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 Documentation/DocBook/crypto-API.tmpl | 6 +++---
 include/crypto/aead.h                 | 3 +--
 include/crypto/hash.h                 | 3 +--
 include/crypto/skcipher.h             | 3 +--
 include/linux/crypto.h                | 3 +--
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index 348619f..d55dc5a 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -1936,9 +1936,9 @@ static int test_skcipher(void)
 	}
 
 	req = skcipher_request_alloc(skcipher, GFP_KERNEL);
-	if (IS_ERR(req)) {
-		pr_info("could not allocate request queue\n");
-		ret = PTR_ERR(req);
+	if (!req) {
+		pr_info("could not allocate skcipher request\n");
+		ret = -ENOMEM;
 		goto out;
 	}
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 957bb87..75174f8 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -405,8 +405,7 @@ static inline void aead_request_set_tfm(struct aead_request *req,
  * encrypt and decrypt API calls. During the allocation, the provided aead
  * handle is registered in the request data structure.
  *
- * Return: allocated request handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
+ * Return: allocated request handle in case of success, or NULL if out of memory
  */
 static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
 						      gfp_t gfp)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 1969f14..2660588 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -547,8 +547,7 @@ static inline void ahash_request_set_tfm(struct ahash_request *req,
  * the allocation, the provided ahash handle
  * is registered in the request data structure.
  *
- * Return: allocated request handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
+ * Return: allocated request handle in case of success, or NULL if out of memory
  */
 static inline struct ahash_request *ahash_request_alloc(
 	struct crypto_ahash *tfm, gfp_t gfp)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 905490c..0f987f5 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -425,8 +425,7 @@ static inline struct skcipher_request *skcipher_request_cast(
  * encrypt and decrypt API calls. During the allocation, the provided skcipher
  * handle is registered in the request data structure.
  *
- * Return: allocated request handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
+ * Return: allocated request handle in case of success, or NULL if out of memory
  */
 static inline struct skcipher_request *skcipher_request_alloc(
 	struct crypto_skcipher *tfm, gfp_t gfp)
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 99c9489..6e28c89 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -948,8 +948,7 @@ static inline struct ablkcipher_request *ablkcipher_request_cast(
  * encrypt and decrypt API calls. During the allocation, the provided ablkcipher
  * handle is registered in the request data structure.
  *
- * Return: allocated request handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
+ * Return: allocated request handle in case of success, or NULL if out of memory
  */
 static inline struct ablkcipher_request *ablkcipher_request_alloc(
 	struct crypto_ablkcipher *tfm, gfp_t gfp)
-- 
2.7.4
