From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hash - Add helpers to zero stack request/descriptor
Date: Fri, 22 Jan 2016 23:17:58 +0800
Message-ID: <20160122151758.GA18223@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60696 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcAVPSB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 10:18:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As the size of an ahash_request or shash_desc is variable, it's
awkward to zero them explicitly.  This patch adds helpers to do
that which should be used when they are created on the stack.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 6361892..aef8192 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -14,6 +14,7 @@
 #define _CRYPTO_HASH_H
 
 #include <linux/crypto.h>
+#include <linux/string.h>
 
 struct crypto_ahash;
 
@@ -550,6 +551,12 @@ static inline void ahash_request_free(struct ahash_request *req)
 	kzfree(req);
 }
 
+static inline void ahash_request_zero(struct ahash_request *req)
+{
+	memzero_explicit(req, sizeof(*req) +
+			      crypto_ahash_reqsize(crypto_ahash_reqtfm(req)));
+}
+
 static inline struct ahash_request *ahash_request_cast(
 	struct crypto_async_request *req)
 {
@@ -872,4 +879,10 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out);
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out);
 
+static inline void shash_desc_zero(struct shash_desc *desc)
+{
+	memzero_explicit(desc,
+			 sizeof(*desc) + crypto_shash_descsize(desc->tfm));
+}
+
 #endif	/* _CRYPTO_HASH_H */
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
