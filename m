From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/10] crypto: hash - Add shash interface
Date: Fri, 07 Nov 2008 16:36:57 +0800
Message-ID: <E1KyMpt-0002kk-QK@gondolin.me.apana.org.au>
References: <20081107083536.GA10169@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39124 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751413AbYKGIhA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2008 03:37:00 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KyMpu-0006AI-1H
	for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2008 19:36:58 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Add shash interface

The shash interface replaces the current synchronous hash interface.
It improves over hash in two ways.  Firstly shash is reentrant,
meaning that the same tfm may be used by two threads simultaneously
as all hashing state is stored in a local descriptor.

The other enhancement is that shash no longer takes scatter list
entries.  This is because shash is specifically designed for
synchronous algorithms and as such scatter lists are unnecessary.

All existing hash users will be converted to shash once the
algorithms have been completely converted.

There is also a new finup function that combines update with final.
This will be extended to ahash once the algorithm conversion is
done.

This is also the first time that an algorithm type has their own
registration function.  Existing algorithm types will be converted
to this way in due course.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile                |    1 
 crypto/shash.c                 |  239 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/hash.h          |  104 +++++++++++++++++
 include/crypto/internal/hash.h |    8 +
 include/linux/crypto.h         |    1 
 5 files changed, 353 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 5862b80..0e93f32 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
 crypto_hash-objs += ahash.o
+crypto_hash-objs += shash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 cryptomgr-objs := algboss.o testmgr.o
diff --git a/crypto/shash.c b/crypto/shash.c
new file mode 100644
index 0000000..82ec4bd
--- /dev/null
+++ b/crypto/shash.c
@@ -0,0 +1,239 @@
+/*
+ * Synchronous Cryptographic Hash operations.
+ *
+ * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/internal/hash.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+
+static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
+{
+	return container_of(tfm, struct crypto_shash, base);
+}
+
+static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
+				  unsigned int keylen)
+{
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	unsigned long absize;
+	u8 *buffer, *alignbuffer;
+	int err;
+
+	absize = keylen + (alignmask & ~(CRYPTO_MINALIGN - 1));
+	buffer = kmalloc(absize, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	err = shash->setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, keylen);
+	kfree(buffer);
+	return err;
+}
+
+int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+
+	if ((unsigned long)key & alignmask)
+		return shash_setkey_unaligned(tfm, key, keylen);
+
+	return shash->setkey(tfm, key, keylen);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_setkey);
+
+static inline unsigned int shash_align_buffer_size(unsigned len,
+						   unsigned long mask)
+{
+	return len + (mask & ~(__alignof__(u8 __attribute__ ((aligned))) - 1));
+}
+
+static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
+				  unsigned int len)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	unsigned int unaligned_len = alignmask + 1 -
+				     ((unsigned long)data & alignmask);
+	u8 buf[shash_align_buffer_size(unaligned_len, alignmask)]
+		__attribute__ ((aligned));
+
+	memcpy(buf, data, unaligned_len);
+
+	return shash->update(desc, buf, unaligned_len) ?:
+	       shash->update(desc, data + unaligned_len, len - unaligned_len);
+}
+
+int crypto_shash_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+
+	if ((unsigned long)data & alignmask)
+		return shash_update_unaligned(desc, data, len);
+
+	return shash->update(desc, data, len);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_update);
+
+static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned int ds = crypto_shash_digestsize(tfm);
+	u8 buf[shash_align_buffer_size(ds, alignmask)]
+		__attribute__ ((aligned));
+	int err;
+
+	err = shash->final(desc, buf);
+	memcpy(out, buf, ds);
+	return err;
+}
+
+int crypto_shash_final(struct shash_desc *desc, u8 *out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+
+	if ((unsigned long)out & alignmask)
+		return shash_final_unaligned(desc, out);
+
+	return shash->final(desc, out);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_final);
+
+static int shash_finup_unaligned(struct shash_desc *desc, const u8 *data,
+				 unsigned int len, u8 *out)
+{
+	return crypto_shash_update(desc, data, len) ?:
+	       crypto_shash_final(desc, out);
+}
+
+int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
+		       unsigned int len, u8 *out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+
+	if (((unsigned long)data | (unsigned long)out) & alignmask ||
+	    !shash->finup)
+		return shash_finup_unaligned(desc, data, len, out);
+
+	return shash->finup(desc, data, len, out);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_finup);
+
+static int shash_digest_unaligned(struct shash_desc *desc, const u8 *data,
+				  unsigned int len, u8 *out)
+{
+	return crypto_shash_init(desc) ?:
+	       crypto_shash_update(desc, data, len) ?:
+	       crypto_shash_final(desc, out);
+}
+
+int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	unsigned long alignmask = crypto_shash_alignmask(tfm);
+
+	if (((unsigned long)data | (unsigned long)out) & alignmask ||
+	    !shash->digest)
+		return shash_digest_unaligned(desc, data, len, out);
+
+	return shash->digest(desc, data, len, out);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_digest);
+
+static int crypto_shash_init_tfm(struct crypto_tfm *tfm,
+				 const struct crypto_type *frontend)
+{
+	if (frontend->type != CRYPTO_ALG_TYPE_SHASH)
+		return -EINVAL;
+	return 0;
+}
+
+static unsigned int crypto_shash_extsize(struct crypto_alg *alg,
+					 const struct crypto_type *frontend)
+{
+	return alg->cra_ctxsize;
+}
+
+static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct shash_alg *salg = __crypto_shash_alg(alg);
+
+	seq_printf(m, "type         : shash\n");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "digestsize   : %u\n", salg->digestsize);
+	seq_printf(m, "descsize     : %u\n", salg->descsize);
+}
+
+static const struct crypto_type crypto_shash_type = {
+	.extsize = crypto_shash_extsize,
+	.init_tfm = crypto_shash_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_shash_show,
+#endif
+	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
+	.maskset = CRYPTO_ALG_TYPE_MASK,
+	.type = CRYPTO_ALG_TYPE_SHASH,
+	.tfmsize = offsetof(struct crypto_shash, base),
+};
+
+struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return __crypto_shash_cast(
+		crypto_alloc_tfm(alg_name, &crypto_shash_type, type, mask));
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_shash);
+
+int crypto_register_shash(struct shash_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	if (alg->digestsize > PAGE_SIZE / 8 ||
+	    alg->descsize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	base->cra_type = &crypto_shash_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_shash);
+
+int crypto_unregister_shash(struct shash_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_shash);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Synchronous cryptographic hash type");
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index ee48ef8..f9b51d4 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -15,10 +15,39 @@
 
 #include <linux/crypto.h>
 
+struct shash_desc {
+	struct crypto_shash *tfm;
+	u32 flags;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
+struct shash_alg {
+	int (*init)(struct shash_desc *desc);
+	int (*update)(struct shash_desc *desc, const u8 *data,
+		      unsigned int len);
+	int (*final)(struct shash_desc *desc, u8 *out);
+	int (*finup)(struct shash_desc *desc, const u8 *data,
+		     unsigned int len, u8 *out);
+	int (*digest)(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out);
+	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
+		      unsigned int keylen);
+
+	unsigned int descsize;
+	unsigned int digestsize;
+
+	struct crypto_alg base;
+};
+
 struct crypto_ahash {
 	struct crypto_tfm base;
 };
 
+struct crypto_shash {
+	struct crypto_tfm base;
+};
+
 static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_ahash *)tfm;
@@ -169,4 +198,79 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 	req->result = result;
 }
 
+struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
+					u32 mask);
+
+static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_shash(struct crypto_shash *tfm)
+{
+	crypto_free_tfm(crypto_shash_tfm(tfm));
+}
+
+static inline unsigned int crypto_shash_alignmask(
+	struct crypto_shash *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_shash_tfm(tfm));
+}
+
+static inline struct shash_alg *__crypto_shash_alg(struct crypto_alg *alg)
+{
+	return container_of(alg, struct shash_alg, base);
+}
+
+static inline struct shash_alg *crypto_shash_alg(struct crypto_shash *tfm)
+{
+	return __crypto_shash_alg(crypto_shash_tfm(tfm)->__crt_alg);
+}
+
+static inline unsigned int crypto_shash_digestsize(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->digestsize;
+}
+
+static inline u32 crypto_shash_get_flags(struct crypto_shash *tfm)
+{
+	return crypto_tfm_get_flags(crypto_shash_tfm(tfm));
+}
+
+static inline void crypto_shash_set_flags(struct crypto_shash *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_shash_tfm(tfm), flags);
+}
+
+static inline void crypto_shash_clear_flags(struct crypto_shash *tfm, u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_shash_tfm(tfm), flags);
+}
+
+static inline unsigned int crypto_shash_descsize(struct crypto_shash *tfm)
+{
+	return crypto_shash_alg(tfm)->descsize;
+}
+
+static inline void *shash_desc_ctx(struct shash_desc *desc)
+{
+	return desc->__ctx;
+}
+
+int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
+			unsigned int keylen);
+int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *out);
+
+static inline int crypto_shash_init(struct shash_desc *desc)
+{
+	return crypto_shash_alg(desc->tfm)->init(desc);
+}
+
+int crypto_shash_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len);
+int crypto_shash_final(struct shash_desc *desc, u8 *out);
+int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
+		       unsigned int len, u8 *out);
+
 #endif	/* _CRYPTO_HASH_H */
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 917ae57..32d3a8e 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -40,6 +40,9 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
 
+int crypto_register_shash(struct shash_alg *alg);
+int crypto_unregister_shash(struct shash_alg *alg);
+
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
@@ -74,5 +77,10 @@ static inline int ahash_tfm_in_queue(struct crypto_queue *queue,
 	return crypto_tfm_in_queue(queue, crypto_ahash_tfm(tfm));
 }
 
+static inline void *crypto_shash_ctx(struct crypto_shash *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ffaaa41..ee95c74 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -39,6 +39,7 @@
 #define CRYPTO_ALG_TYPE_HASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_SHASH		0x0000000d
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
