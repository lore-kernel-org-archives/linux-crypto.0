From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] crypto: clear htmldocs build warnings for crypto/hash
Date: Sun,  7 Jan 2018 10:01:43 +1100
Message-ID: <1515279703-14070-1-git-send-email-me@tobin.cc>
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53859 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752249AbeAFXBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 6 Jan 2018 18:01:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SPHINX build emits multiple warnings of kind:

	warning: duplicate section name 'Note'

(when building kernel via make target 'htmldocs')

This is caused by repeated use of comments of form:

	* Note: soau soaeusoa uoe

We can change the format without loss of clarity and clear the build
warnings.

Add '**[mandatory]**' or '**[optional]**' as kernel-doc field element
description prefix

This renders in HTML as (prefixes in bold)

final
    [mandatory] Retrieve result from the driver. This function finalizes the
    transformation and retrieves the resulting hash from the driver and
    pushes it back to upper layers. No data processing happens at this
    point unless hardware requires it to finish the transformation (then
    the data buffered by the device driver is processed).

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

This patch begs the question why the other members of struct ahash_alg
are not marked? Some are marked 'optional' some 'mandatory'. It would
seem that if the marking were necessary for some members it is necessary
for all to eliminate ambiguity?

thanks

 include/crypto/hash.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0ed31fd80242..d1cd75faff40 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -71,12 +71,11 @@ struct ahash_request {
 
 /**
  * struct ahash_alg - asynchronous message digest definition
- * @init: Initialize the transformation context. Intended only to initialize the
+ * @init: **[mandatory]** Initialize the transformation context. Intended only to initialize the
  *	  state of the HASH transformation at the beginning. This shall fill in
  *	  the internal structures used during the entire duration of the whole
  *	  transformation. No data processing happens at this point.
- *	  Note: mandatory.
- * @update: Push a chunk of data into the driver for transformation. This
+ * @update: **[mandatory]** Push a chunk of data into the driver for transformation. This
  *	   function actually pushes blocks of data from upper layers into the
  *	   driver, which then passes those to the hardware as seen fit. This
  *	   function must not finalize the HASH transformation by calculating the
@@ -85,20 +84,17 @@ struct ahash_request {
  *	   context, as this function may be called in parallel with the same
  *	   transformation object. Data processing can happen synchronously
  *	   [SHASH] or asynchronously [AHASH] at this point.
- *	   Note: mandatory.
- * @final: Retrieve result from the driver. This function finalizes the
+ * @final: **[mandatory]** Retrieve result from the driver. This function finalizes the
  *	   transformation and retrieves the resulting hash from the driver and
  *	   pushes it back to upper layers. No data processing happens at this
  *	   point unless hardware requires it to finish the transformation
  *	   (then the data buffered by the device driver is processed).
- *	   Note: mandatory.
- * @finup: Combination of @update and @final. This function is effectively a
+ * @finup: **[optional]** Combination of @update and @final. This function is effectively a
  *	   combination of @update and @final calls issued in sequence. As some
  *	   hardware cannot do @update and @final separately, this callback was
  *	   added to allow such hardware to be used at least by IPsec. Data
  *	   processing can happen synchronously [SHASH] or asynchronously [AHASH]
  *	   at this point.
- *	   Note: optional.
  * @digest: Combination of @init and @update and @final. This function
  *	    effectively behaves as the entire chain of operations, @init,
  *	    @update and @final issued in sequence. Just like @finup, this was
-- 
2.7.4
