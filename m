From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/7] crypto: doc - fix source comments for Sphinx
Date: Sun, 16 Oct 2016 05:18:00 +0200
Message-ID: <2601538.cyVHbpjp9L@positron.chronox.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2721226.4nLlHD9uQ6@positron.chronox.de>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update comments to avoid any complaints from Sphinx during compilation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/aead.h     | 14 +++++++-------
 include/crypto/hash.h     |  2 +-
 include/crypto/skcipher.h |  4 ++--
 include/linux/crypto.h    |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 12f8432..1bd3a2f 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -55,14 +55,14 @@
  * The scatter list pointing to the input data must contain:
  *
  * * for RFC4106 ciphers, the concatenation of
- * associated authentication data || IV || plaintext or ciphertext. Note, the
- * same IV (buffer) is also set with the aead_request_set_crypt call. Note,
- * the API call of aead_request_set_ad must provide the length of the AAD and
- * the IV. The API call of aead_request_set_crypt only points to the size of
- * the input plaintext or ciphertext.
+ *   associated authentication data || IV || plaintext or ciphertext. Note, the
+ *   same IV (buffer) is also set with the aead_request_set_crypt call. Note,
+ *   the API call of aead_request_set_ad must provide the length of the AAD and
+ *   the IV. The API call of aead_request_set_crypt only points to the size of
+ *   the input plaintext or ciphertext.
  *
  * * for "normal" AEAD ciphers, the concatenation of
- * associated authentication data || plaintext or ciphertext.
+ *   associated authentication data || plaintext or ciphertext.
  *
  * It is important to note that if multiple scatter gather list entries form
  * the input data mentioned above, the first entry must not point to a NULL
@@ -454,7 +454,7 @@ static inline void aead_request_free(struct aead_request *req)
  * The callback function is registered with the aead_request handle and
  * must comply with the following template
  *
- *	void callback_function(struct crypto_async_request *req, int error)
+ *	void callback_function(struct crypto_async_request \*req, int error)
  */
 static inline void aead_request_set_callback(struct aead_request *req,
 					     u32 flags,
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2660588..23f15d0 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -607,7 +607,7 @@ static inline struct ahash_request *ahash_request_cast(
  * The callback function is registered with the &ahash_request handle and
  * must comply with the following template
  *
- *	void callback_function(struct crypto_async_request *req, int error)
+ *	void callback_function(struct crypto_async_request \*req, int error)
  */
 static inline void ahash_request_set_callback(struct ahash_request *req,
 					      u32 flags,
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index cc4d98a..78a1de0 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -516,7 +516,7 @@ static inline void skcipher_request_zero(struct skcipher_request *req)
  * skcipher_request_set_callback() - set asynchronous callback function
  * @req: request handle
  * @flags: specify zero or an ORing of the flags
- *         CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
+ *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
  *	   increase the wait queue beyond the initial maximum size;
  *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
  * @compl: callback function pointer to be registered with the request handle
@@ -535,7 +535,7 @@ static inline void skcipher_request_zero(struct skcipher_request *req)
  * The callback function is registered with the skcipher_request handle and
  * must comply with the following template
  *
- *	void callback_function(struct crypto_async_request *req, int error)
+ *	void callback_function(struct crypto_async_request \*req, int error)
  */
 static inline void skcipher_request_set_callback(struct skcipher_request *req,
 						 u32 flags,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7cee555..615a326 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -960,7 +960,7 @@ static inline void ablkcipher_request_free(struct ablkcipher_request *req)
  * ablkcipher_request_set_callback() - set asynchronous callback function
  * @req: request handle
  * @flags: specify zero or an ORing of the flags
- *         CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
+ *	   CRYPTO_TFM_REQ_MAY_BACKLOG the request queue may back log and
  *	   increase the wait queue beyond the initial maximum size;
  *	   CRYPTO_TFM_REQ_MAY_SLEEP the request processing may sleep
  * @compl: callback function pointer to be registered with the request handle
@@ -979,7 +979,7 @@ static inline void ablkcipher_request_free(struct ablkcipher_request *req)
  * The callback function is registered with the ablkcipher_request handle and
  * must comply with the following template
  *
- *	void callback_function(struct crypto_async_request *req, int error)
+ *	void callback_function(struct crypto_async_request \*req, int error)
  */
 static inline void ablkcipher_request_set_callback(
 	struct ablkcipher_request *req,
-- 
2.7.4


