From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] crypto: doc - clarify return values for async hash methods
Date: Thu, 17 Aug 2017 12:27:12 +0200
Message-ID: <c00e8de8-fbf0-d92d-4b3c-959dd0ca3113@partner.samsung.com>
References: <CGME20170817102713eucas1p226423aedceb56acc9374f1a3cc28ee99@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>From af1b10e1e6aaf67f8dc45ed78de89b0469794a98 Mon Sep 17 00:00:00 2001
From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Date: Thu, 17 Aug 2017 12:11:36 +0200
Subject: [PATCH] crypto: doc - clarify return values for async hash methods

* fix documentation of return values for crypto_ahash_init(),
  crypto_ahash_finup(), crypto_ahash_final(),
  crypto_ahash_digest() and crypto_ahash_update()

Also while at it:

* add notes for device driver developers in struct ahash_alg
  description

* fix description of @final method in struct ahash_alg

* fix typo in crypto_ahash_finup() description

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 include/crypto/hash.h | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b5727bcd2336..0ed31fd80242 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -75,6 +75,7 @@ struct ahash_request {
  *	  state of the HASH transformation at the beginning. This shall fill in
  *	  the internal structures used during the entire duration of the whole
  *	  transformation. No data processing happens at this point.
+ *	  Note: mandatory.
  * @update: Push a chunk of data into the driver for transformation. This
  *	   function actually pushes blocks of data from upper layers into the
  *	   driver, which then passes those to the hardware as seen fit. This
@@ -84,16 +85,20 @@ struct ahash_request {
  *	   context, as this function may be called in parallel with the same
  *	   transformation object. Data processing can happen synchronously
  *	   [SHASH] or asynchronously [AHASH] at this point.
+ *	   Note: mandatory.
  * @final: Retrieve result from the driver. This function finalizes the
  *	   transformation and retrieves the resulting hash from the driver and
  *	   pushes it back to upper layers. No data processing happens at this
- *	   point.
+ *	   point unless hardware requires it to finish the transformation
+ *	   (then the data buffered by the device driver is processed).
+ *	   Note: mandatory.
  * @finup: Combination of @update and @final. This function is effectively a
  *	   combination of @update and @final calls issued in sequence. As some
  *	   hardware cannot do @update and @final separately, this callback was
  *	   added to allow such hardware to be used at least by IPsec. Data
  *	   processing can happen synchronously [SHASH] or asynchronously [AHASH]
  *	   at this point.
+ *	   Note: optional.
  * @digest: Combination of @init and @update and @final. This function
  *	    effectively behaves as the entire chain of operations, @init,
  *	    @update and @final issued in sequence. Just like @finup, this was
@@ -416,11 +421,10 @@ static inline bool crypto_ahash_has_setkey(struct crypto_ahash *tfm)
  *	 needed to perform the cipher operation
  *
  * This function is a "short-hand" for the function calls of
- * crypto_ahash_update and crypto_shash_final. The parameters have the same
+ * crypto_ahash_update and crypto_ahash_final. The parameters have the same
  * meaning as discussed for those separate functions.
  *
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
+ * Return: see crypto_ahash_final()
  */
 int crypto_ahash_finup(struct ahash_request *req);
 
@@ -433,8 +437,11 @@ int crypto_ahash_finup(struct ahash_request *req);
  * based on all data added to the cipher handle. The message digest is placed
  * into the output buffer registered with the ahash_request handle.
  *
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
+ * Return:
+ * 0		if the message digest was successfully calculated;
+ * -EINPROGRESS	if data is feeded into hardware (DMA) or queued for later;
+ * -EBUSY	if queue is full and request should be resubmitted later;
+ * other < 0	if an error occurred
  */
 int crypto_ahash_final(struct ahash_request *req);
 
@@ -447,8 +454,7 @@ int crypto_ahash_final(struct ahash_request *req);
  * crypto_ahash_update and crypto_ahash_final. The parameters have the same
  * meaning as discussed for those separate three functions.
  *
- * Return: 0 if the message digest creation was successful; < 0 if an error
- *	   occurred
+ * Return: see crypto_ahash_final()
  */
 int crypto_ahash_digest(struct ahash_request *req);
 
@@ -493,8 +499,7 @@ static inline int crypto_ahash_import(struct ahash_request *req, const void *in)
  * handle. Any potentially existing state created by previous operations is
  * discarded.
  *
- * Return: 0 if the message digest initialization was successful; < 0 if an
- *	   error occurred
+ * Return: see crypto_ahash_final()
  */
 static inline int crypto_ahash_init(struct ahash_request *req)
 {
@@ -510,8 +515,7 @@ static inline int crypto_ahash_init(struct ahash_request *req)
  * is pointed to by the scatter/gather list registered in the &ahash_request
  * handle
  *
- * Return: 0 if the message digest update was successful; < 0 if an error
- *	   occurred
+ * Return: see crypto_ahash_final()
  */
 static inline int crypto_ahash_update(struct ahash_request *req)
 {
-- 
2.7.4
