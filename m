From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/10] crypto: hash - Export shash through ahash
Date: Fri, 07 Nov 2008 16:36:58 +0800
Message-ID: <E1KyMpu-0002ks-T2@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39125 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751550AbYKGIhB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:01 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpv-0006AL-3s
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:36:59 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Export shash through ahash

This patch allows shash algorithms to be used through the ahash
interface.  This is required before we can convert digest algorithms
over to shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c         |  143 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h |    2 
 2 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 82ec4bd..3f4c713 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -17,11 +18,15 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
+static const struct crypto_type crypto_shash_type;
+
 static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_shash, base);
 }
 
+#include "internal.h"
+
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
 {
@@ -167,6 +172,142 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
+static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
+
+	return crypto_shash_setkey(*ctx, key, keylen);
+}
+
+static int shash_async_init(struct ahash_request *req)
+{
+	struct crypto_shash **ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct shash_desc *desc = ahash_request_ctx(req);
+
+	desc->tfm = *ctx;
+	desc->flags = req->base.flags;
+
+	return crypto_shash_init(desc);
+}
+
+static int shash_async_update(struct ahash_request *req)
+{
+	struct shash_desc *desc = ahash_request_ctx(req);
+	struct crypto_hash_walk walk;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+
+	return nbytes;
+}
+
+static int shash_async_final(struct ahash_request *req)
+{
+	return crypto_shash_final(ahash_request_ctx(req), req->result);
+}
+
+static int shash_async_digest(struct ahash_request *req)
+{
+	struct scatterlist *sg = req->src;
+	unsigned int offset = sg->offset;
+	unsigned int nbytes = req->nbytes;
+	int err;
+
+	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
+		struct crypto_shash **ctx =
+			crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+		struct shash_desc *desc = ahash_request_ctx(req);
+		void *data;
+
+		desc->tfm = *ctx;
+		desc->flags = req->base.flags;
+
+		data = crypto_kmap(sg_page(sg), 0);
+		err = crypto_shash_digest(desc, data + offset, nbytes,
+					  req->result);
+		crypto_kunmap(data, 0);
+		crypto_yield(desc->flags);
+		goto out;
+	}
+
+	err = shash_async_init(req);
+	if (err)
+		goto out;
+
+	err = shash_async_update(req);
+	if (err)
+		goto out;
+
+	err = shash_async_final(req);
+
+out:
+	return err;
+}
+
+static void crypto_exit_shash_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(*ctx);
+}
+
+static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *calg = tfm->__crt_alg;
+	struct shash_alg *alg = __crypto_shash_alg(calg);
+	struct ahash_tfm *crt = &tfm->crt_ahash;
+	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
+	struct crypto_shash *shash;
+
+	if (!crypto_mod_get(calg))
+		return -EAGAIN;
+
+	shash = __crypto_shash_cast(crypto_create_tfm(
+		calg, &crypto_shash_type));
+	if (IS_ERR(shash)) {
+		crypto_mod_put(calg);
+		return PTR_ERR(shash);
+	}
+
+	*ctx = shash;
+	tfm->exit = crypto_exit_shash_ops_async;
+
+	crt->init = shash_async_init;
+	crt->update = shash_async_update;
+	crt->final  = shash_async_final;
+	crt->digest = shash_async_digest;
+	crt->setkey = shash_async_setkey;
+
+	crt->digestsize = alg->digestsize;
+	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
+
+	return 0;
+}
+
+static int crypto_init_shash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	switch (mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AHASH_MASK:
+		return crypto_init_shash_ops_async(tfm);
+	}
+
+	return -EINVAL;
+}
+
+static unsigned int crypto_shash_ctxsize(struct crypto_alg *alg, u32 type,
+					 u32 mask)
+{
+	switch (mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AHASH_MASK:
+		return sizeof(struct crypto_shash *);
+	}
+
+	return 0;
+}
+
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
 				 const struct crypto_type *frontend)
 {
@@ -194,7 +335,9 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 static const struct crypto_type crypto_shash_type = {
+	.ctxsize = crypto_shash_ctxsize,
 	.extsize = crypto_shash_extsize,
+	.init = crypto_init_shash_ops,
 	.init_tfm = crypto_shash_init_tfm,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ee95c74..44c72f0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -38,8 +38,8 @@
 #define CRYPTO_ALG_TYPE_DIGEST		0x00000008
 #define CRYPTO_ALG_TYPE_HASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
+#define CRYPTO_ALG_TYPE_SHASH		0x0000000b
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
-#define CRYPTO_ALG_TYPE_SHASH		0x0000000d
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
