From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/10] crypto: hash - Export shash through hash
Date: Fri, 07 Nov 2008 16:37:02 +0800
Message-ID: <E1KyMpy-0002lH-4N@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39128 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751576AbYKGIhF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:05 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpy-0006AU-Bt
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:37:02 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Export shash through hash

This patch allows shash algorithms to be used through the old hash
interface.  This is a transitional measure so we can convert the
underlying algorithms to shash before converting the users across.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   16 ++++++
 crypto/authenc.c               |    3 +
 crypto/hmac.c                  |   10 ++-
 crypto/shash.c                 |  109 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |    5 +
 include/crypto/internal/hash.h |    3 +
 include/linux/crypto.h         |    4 -
 7 files changed, 144 insertions(+), 6 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7d4e33d..9f98956 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -112,6 +112,22 @@ int crypto_hash_walk_first(struct ahash_request *req,
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
+int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
+				  struct crypto_hash_walk *walk,
+				  struct scatterlist *sg, unsigned int len)
+{
+	walk->total = len;
+
+	if (!walk->total)
+		return 0;
+
+	walk->alignmask = crypto_hash_alignmask(hdesc->tfm);
+	walk->sg = sg;
+	walk->flags = hdesc->flags;
+
+	return hash_walk_new_entry(walk);
+}
+
 static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 				unsigned int keylen)
 {
diff --git a/crypto/authenc.c b/crypto/authenc.c
index fd9f06c..40b6e9e 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -11,6 +11,7 @@
  */
 
 #include <crypto/aead.h>
+#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
@@ -431,6 +432,8 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.ivsize = enc->cra_ablkcipher.ivsize;
 	inst->alg.cra_aead.maxauthsize = auth->cra_type == &crypto_hash_type ?
 					 auth->cra_hash.digestsize :
+					 auth->cra_type ?
+					 __crypto_shash_alg(auth)->digestsize :
 					 auth->cra_digest.dia_digestsize;
 
 	inst->alg.cra_ctxsize = sizeof(struct crypto_authenc_ctx);
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 7ff2d6a..0ad39c3 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -16,7 +16,7 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -238,9 +238,11 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 		return ERR_CAST(alg);
 
 	inst = ERR_PTR(-EINVAL);
-	ds = (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	     CRYPTO_ALG_TYPE_HASH ? alg->cra_hash.digestsize :
-				    alg->cra_digest.dia_digestsize;
+	ds = alg->cra_type == &crypto_hash_type ?
+	     alg->cra_hash.digestsize :
+	     alg->cra_type ?
+	     __crypto_shash_alg(alg)->digestsize :
+	     alg->cra_digest.dia_digestsize;
 	if (ds > alg->cra_blocksize)
 		goto out_put_alg;
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 26aff3f..50d69a4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -301,9 +301,114 @@ static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int shash_compat_setkey(struct crypto_hash *tfm, const u8 *key,
+			       unsigned int keylen)
+{
+	struct shash_desc *desc = crypto_hash_ctx(tfm);
+
+	return crypto_shash_setkey(desc->tfm, key, keylen);
+}
+
+static int shash_compat_init(struct hash_desc *hdesc)
+{
+	struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+
+	desc->flags = hdesc->flags;
+
+	return crypto_shash_init(desc);
+}
+
+static int shash_compat_update(struct hash_desc *hdesc, struct scatterlist *sg,
+			       unsigned int len)
+{
+	struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first_compat(hdesc, &walk, sg, len);
+	     nbytes > 0; nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+
+	return nbytes;
+}
+
+static int shash_compat_final(struct hash_desc *hdesc, u8 *out)
+{
+	return crypto_shash_final(crypto_hash_ctx(hdesc->tfm), out);
+}
+
+static int shash_compat_digest(struct hash_desc *hdesc, struct scatterlist *sg,
+			       unsigned int nbytes, u8 *out)
+{
+	unsigned int offset = sg->offset;
+	int err;
+
+	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
+		struct shash_desc *desc = crypto_hash_ctx(hdesc->tfm);
+		void *data;
+
+		desc->flags = hdesc->flags;
+
+		data = crypto_kmap(sg_page(sg), 0);
+		err = crypto_shash_digest(desc, data + offset, nbytes, out);
+		crypto_kunmap(data, 0);
+		crypto_yield(desc->flags);
+		goto out;
+	}
+
+	err = shash_compat_init(hdesc);
+	if (err)
+		goto out;
+
+	err = shash_compat_update(hdesc, sg, nbytes);
+	if (err)
+		goto out;
+
+	err = shash_compat_final(hdesc, out);
+
+out:
+	return err;
+}
+
+static void crypto_exit_shash_ops_compat(struct crypto_tfm *tfm)
+{
+	struct shash_desc *desc= crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(desc->tfm);
+}
+
+static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
+{
+	struct hash_tfm *crt = &tfm->crt_hash;
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct shash_alg *alg = __crypto_shash_alg(calg);
+	struct shash_desc *desc = crypto_tfm_ctx(tfm);
+	struct crypto_shash *shash;
+
+	shash = __crypto_shash_cast(crypto_create_tfm(
+		calg, &crypto_shash_type));
+	if (IS_ERR(shash))
+		return PTR_ERR(shash);
+
+	desc->tfm = shash;
+	tfm->exit = crypto_exit_shash_ops_compat;
+
+	crt->init = shash_compat_init;
+	crt->update = shash_compat_update;
+	crt->final  = shash_compat_final;
+	crt->digest = shash_compat_digest;
+	crt->setkey = shash_compat_setkey;
+
+	crt->digestsize = alg->digestsize;
+
+	return 0;
+}
+
 static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_HASH_MASK:
+		return crypto_init_shash_ops_compat(tfm);
 	case CRYPTO_ALG_TYPE_AHASH_MASK:
 		return crypto_init_shash_ops_async(tfm);
 	}
@@ -314,7 +419,11 @@ static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
 					 u32 mask)
 {
+	struct shash_alg *salg = __crypto_shash_alg(alg);
+
 	switch (mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_HASH_MASK:
+		return sizeof(struct shash_desc) + salg->descsize;
 	case CRYPTO_ALG_TYPE_AHASH_MASK:
 		return sizeof(struct crypto_shash *);
 	}
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 986db68..0105454 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -248,6 +248,11 @@ static inline struct crypto_hash *crypto_spawn_hash(struct crypto_spawn *spawn)
 	return __crypto_hash_cast(crypto_spawn_tfm(spawn, type, mask));
 }
 
+static inline void *crypto_hash_ctx(struct crypto_hash *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
 static inline void *crypto_hash_ctx_aligned(struct crypto_hash *tfm)
 {
 	return crypto_tfm_ctx_aligned(&tfm->base);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 92fbe73..82b7056 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -39,6 +39,9 @@ extern const struct crypto_type crypto_ahash_type;
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
+int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
+				  struct crypto_hash_walk *walk,
+				  struct scatterlist *sg, unsigned int len);
 
 int crypto_register_shash(struct shash_alg *alg);
 int crypto_unregister_shash(struct shash_alg *alg);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 77a1f3d..3bacd71 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -36,9 +36,9 @@
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_DIGEST		0x00000008
-#define CRYPTO_ALG_TYPE_HASH		0x00000009
+#define CRYPTO_ALG_TYPE_HASH		0x00000008
+#define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
-#define CRYPTO_ALG_TYPE_SHASH		0x0000000b
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
