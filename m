From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v2] crypto: hash.h: Prevent use of req->result in ahash
 update
Date: Wed, 07 Mar 2018 11:49:33 +0100
Message-ID: <7850c31c-8703-51fb-0710-3b4920935bfc@partner.samsung.com>
References: <CGME20180307104934eucas1p18af0e65a519299997b5d2f7fb78cd39f@eucas1p1.samsung.com>
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

Prevent improper use of req->result field in ahash update, init, export and
import functions in drivers code. A driver should use ahash request context
if it needs to save internal state.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
version 2:
 Change req->digest to req->result, as pointed out by Tom Lendacky

 include/crypto/hash.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d1849dffb80..76e432cab75d 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -74,7 +74,8 @@ struct ahash_request {
  * @init: **[mandatory]** Initialize the transformation context. Intended only to initialize the
  *	  state of the HASH transformation at the beginning. This shall fill in
  *	  the internal structures used during the entire duration of the whole
- *	  transformation. No data processing happens at this point.
+ *	  transformation. No data processing happens at this point. Driver code
+ *	  implementation must not use req->result.
  * @update: **[mandatory]** Push a chunk of data into the driver for transformation. This
  *	   function actually pushes blocks of data from upper layers into the
  *	   driver, which then passes those to the hardware as seen fit. This
@@ -83,7 +84,8 @@ struct ahash_request {
  *	   transformation. This function shall not modify the transformation
  *	   context, as this function may be called in parallel with the same
  *	   transformation object. Data processing can happen synchronously
- *	   [SHASH] or asynchronously [AHASH] at this point.
+ *	   [SHASH] or asynchronously [AHASH] at this point. Driver must not use
+ *	   req->result.
  * @final: **[mandatory]** Retrieve result from the driver. This function finalizes the
  *	   transformation and retrieves the resulting hash from the driver and
  *	   pushes it back to upper layers. No data processing happens at this
@@ -120,11 +122,12 @@ struct ahash_request {
  *	    you want to save partial result of the transformation after
  *	    processing certain amount of data and reload this partial result
  *	    multiple times later on for multiple re-use. No data processing
- *	    happens at this point.
+ *	    happens at this point. Driver must not use req->result.
  * @import: Import partial state of the transformation. This function loads the
  *	    entire state of the ongoing transformation from a provided block of
  *	    data so the transformation can continue from this point onward. No
- *	    data processing happens at this point.
+ *	    data processing happens at this point. Driver must not use
+ *	    req->result.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
-- 
2.16.2
