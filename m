From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/35] crypto: shash - Export/import hash state only
Date: Wed, 15 Jul 2009 15:15:53 +0800
Message-ID: <E1MQyiX-0004xl-Cu@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53609 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916AbZGOHPz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:15:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyiX-0004nz-NN
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:15:53 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Export/import hash state only

This patch replaces the full descriptor export with an export of
the partial hash state.  This allows the use of a consistent export
format across all implementations of a given algorithm.

This is useful because a number of cases require the use of the
partial hash state, e.g., PadLock can use the SHA1 hash state
to get around the fact that it can only hash contiguous data
chunks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c        |   25 ++++++++++++++-----------
 include/crypto/hash.h |   18 ++++++++++++++----
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 23e05a1..14a3b70 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -172,19 +172,15 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
-int crypto_shash_import(struct shash_desc *desc, const u8 *in)
+static int shash_no_export(struct shash_desc *desc, void *out)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *alg = crypto_shash_alg(tfm);
-
-	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
-
-	if (alg->reinit)
-		return alg->reinit(desc);
+	return -ENOSYS;
+}
 
-	return 0;
+static int shash_no_import(struct shash_desc *desc, const void *in)
+{
+	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(crypto_shash_import);
 
 static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
@@ -484,12 +480,19 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->digestsize > PAGE_SIZE / 8 ||
-	    alg->descsize > PAGE_SIZE / 8)
+	    alg->descsize > PAGE_SIZE / 8 ||
+	    alg->statesize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
+
+	if (!alg->import)
+		alg->import = shash_no_import;
+	if (!alg->export)
+		alg->export = shash_no_export;
+
 	return 0;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index d56bb71..3c4cce6 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -24,7 +24,6 @@ struct shash_desc {
 
 struct shash_alg {
 	int (*init)(struct shash_desc *desc);
-	int (*reinit)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len);
 	int (*final)(struct shash_desc *desc, u8 *out);
@@ -32,11 +31,14 @@ struct shash_alg {
 		     unsigned int len, u8 *out);
 	int (*digest)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out);
+	int (*export)(struct shash_desc *desc, void *out);
+	int (*import)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
 		      unsigned int keylen);
 
 	unsigned int descsize;
 	unsigned int digestsize;
+	unsigned int statesize;
 
 	struct crypto_alg base;
 };
@@ -251,6 +253,11 @@ static inline unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
 	return crypto_shash_alg(tfm)->digestsize;
 }
 
+static inline unsigned int crypto_shash_statesize(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->statesize;
+}
+
 static inline u32 crypto_shash_get_flags(struct crypto_shash *tfm)
 {
 	return crypto_tfm_get_flags(crypto_shash_tfm(tfm));
@@ -281,12 +288,15 @@ int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out);
 
-static inline void crypto_shash_export(struct shash_desc *desc, u8 *out)
+static inline int crypto_shash_export(struct shash_desc *desc, void *out)
 {
-	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm));
+	return crypto_shash_alg(desc->tfm)->export(desc, out);
 }
 
-int crypto_shash_import(struct shash_desc *desc, const u8 *in);
+static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
+{
+	return crypto_shash_alg(desc->tfm)->import(desc, in);
+}
 
 static inline int crypto_shash_init(struct shash_desc *desc)
 {
