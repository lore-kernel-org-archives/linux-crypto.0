From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/10] crypto: hash - Add import/export interface
Date: Fri, 07 Nov 2008 16:36:59 +0800
Message-ID: <E1KyMpv-0002l0-VU@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39126 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbYKGIhF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpw-0006AO-6P
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:00 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Add import/export interface

It is often useful to save the partial state of a hash function
so that it can be used as a base for two or more computations.

The most prominent example is HMAC where all hashes start from
a base determined by the key.  Having an import/export interface
means that we only have to compute that base once rather than
for each message.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   14 ++++++++++++++
 crypto/shash.c                 |   14 ++++++++++++++
 include/crypto/hash.h          |   21 +++++++++++++++++++++
 include/crypto/internal/hash.h |    5 -----
 include/linux/crypto.h         |    1 +
 5 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 27128f2..7d4e33d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -146,6 +146,20 @@ static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 	return ahash->setkey(tfm, key, keylen);
 }
 
+int crypto_ahash_import(struct ahash_request *req, const u8 *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+	memcpy(ahash_request_ctx(req), in, crypto_ahash_reqsize(tfm));
+
+	if (alg->reinit)
+		alg->reinit(req);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_import);
+
 static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 type,
 					u32 mask)
 {
diff --git a/crypto/shash.c b/crypto/shash.c
index 3f4c713..26aff3f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -172,6 +172,20 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
+int crypto_shash_import(struct shash_desc *desc, const u8 *in)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *alg = crypto_shash_alg(tfm);
+
+	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
+
+	if (alg->reinit)
+		alg->reinit(desc);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_import);
+
 static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
 {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f9b51d4..cd16d6e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -24,6 +24,7 @@ struct shash_desc {
 
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
+	int (*reinit)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len);
 	int (*final)(struct shash_desc *desc, u8 *out);
@@ -116,6 +117,11 @@ static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
 	return crypto_ahash_crt(tfm)->reqsize;
 }
 
+static inline void *ahash_request_ctx(struct ahash_request *req)
+{
+	return req->__ctx;
+}
+
 static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
 				      const u8 *key, unsigned int keylen)
 {
@@ -130,6 +136,14 @@ static inline int crypto_ahash_digest(struct ahash_request *req)
 	return crt->digest(req);
 }
 
+static inline void crypto_ahash_export(struct ahash_request *req, u8 *out)
+{
+	memcpy(out, ahash_request_ctx(req),
+	       crypto_ahash_reqsize(crypto_ahash_reqtfm(req)));
+}
+
+int crypto_ahash_import(struct ahash_request *req, const u8 *in);
+
 static inline int crypto_ahash_init(struct ahash_request *req)
 {
 	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
@@ -262,6 +276,13 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out);
 
+static inline void crypto_shash_export(struct shash_desc *desc, u8 *out)
+{
+	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm));
+}
+
+int crypto_shash_import(struct shash_desc *desc, const u8 *in);
+
 static inline int crypto_shash_init(struct shash_desc *desc)
 {
 	return crypto_shash_alg(desc->tfm)->init(desc);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 32d3a8e..92fbe73 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -66,11 +66,6 @@ static inline struct ahash_request *ahash_dequeue_request(
 	return ahash_request_cast(crypto_dequeue_request(queue));
 }
 
-static inline void *ahash_request_ctx(struct ahash_request *req)
-{
-	return req->__ctx;
-}
