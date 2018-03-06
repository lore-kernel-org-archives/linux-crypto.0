From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] crypto: hash.h: Prevent use of req->digest in ahash update
Date: Tue, 06 Mar 2018 12:45:11 +0100
Message-ID: <c29d442e-22b6-9013-05a4-32c8eb04b692@partner.samsung.com>
References: <CGME20180306114512eucas1p286d36bafa1bc719d7e7ccbaa9f549fc1@eucas1p2.samsung.com>
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

Prevent improper use of req->digest field in ahash update, init, export and
import functions in drivers code. A driver should use ahash request context
if it needs to save internal state.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 include/crypto/hash.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d1849dffb80..e97c2e662d6a 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -74,7 +74,8 @@ struct ahash_request {
  * @init: **[mandatory]** Initialize the transformation context. Intended only to initialize the
  *	  state of the HASH transformation at the beginning. This shall fill in
  *	  the internal structures used during the entire duration of the whole
- *	  transformation. No data processing happens at this point.
+ *	  transformation. No data processing happens at this point. Driver code
+ *	  implementation must not use req->digest.
  * @update: **[mandatory]** Push a chunk of data into the driver for transformation. This
  *	   function actually pushes blocks of data from upper layers into the
  *	   driver, which then passes those to the hardware as seen fit. This
@@ -83,7 +84,8 @@ struct ahash_request {
  *	   transformation. This function shall not modify the transformation
  *	   context, as this function may be called in parallel with the same
  *	   transformation object. Data processing can happen synchronously
- *	   [SHASH] or asynchronously [AHASH] at this point.
+ *	   [SHASH] or asynchronously [AHASH] at this point. Driver must not use
+ *	   req->digest.
  * @final: **[mandatory]** Retrieve result from the driver. This function finalizes the
  *	   transformation and retrieves the resulting hash from the driver and
  *	   pushes it back to upper layers. No data processing happens at this
@@ -120,11 +122,12 @@ struct ahash_request {
  *	    you want to save partial result of the transformation after
  *	    processing certain amount of data and reload this partial result
  *	    multiple times later on for multiple re-use. No data processing
- *	    happens at this point.
+ *	    happens at this point. Driver must not use req->digest.
  * @import: Import partial state of the transformation. This function loads the
  *	    entire state of the ongoing transformation from a provided block of
  *	    data so the transformation can continue from this point onward. No
- *	    data processing happens at this point.
+ *	    data processing happens at this point. Driver must not use
+ *	    req->digest.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
-- 
2.16.2
