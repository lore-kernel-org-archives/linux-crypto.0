From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/30] crypto: skcipher - Add low-level skcipher interface
Date: Tue, 12 Jul 2016 13:17:31 +0800
Message-ID: <E1bMq4Z-0007O1-Fi@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57996 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbcGLFRe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4Z-0004Xx-Kw
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:31 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows skcipher algorithms and instances to be created
and registered with the crypto API.  They are accessible through
the top-level skcipher interface, along with ablkcipher/blkcipher
algorithms and instances.

This patch also introduces a new parameter called chunk size
which is meant for ciphers such as CTR and CTS which ostensibly
can handle arbitrary lengths, but still behave like block ciphers
in that you can only process a partial block at the very end.

For these ciphers the block size will continue to be set to 1
as it is now while the chunk size will be set to the underlying
block size.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/skcipher.c                  |  196 +++++++++++++++++++++++++++++++++++--
 include/crypto/internal/skcipher.h |   87 ++++++++++++++++
 include/crypto/skcipher.h          |  130 ++++++++++++++++++++++++
 include/linux/crypto.h             |    1 
 4 files changed, 407 insertions(+), 7 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 69230e9..d248008 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -16,7 +16,11 @@
 
 #include <crypto/internal/skcipher.h>
 #include <linux/bug.h>
+#include <linux/cryptouser.h>
 #include <linux/module.h>
+#include <linux/rtnetlink.h>
+#include <linux/seq_file.h>
+#include <net/netlink.h>
 
 #include "internal.h"
 
@@ -25,10 +29,11 @@ static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
 	if (alg->cra_type == &crypto_blkcipher_type)
 		return sizeof(struct crypto_blkcipher *);
 
-	BUG_ON(alg->cra_type != &crypto_ablkcipher_type &&
-	       alg->cra_type != &crypto_givcipher_type);
+	if (alg->cra_type == &crypto_ablkcipher_type ||
+	    alg->cra_type == &crypto_givcipher_type)
+		return sizeof(struct crypto_ablkcipher *);
 
-	return sizeof(struct crypto_ablkcipher *);
+	return crypto_alg_extsize(alg);
 }
 
 static int skcipher_setkey_blkcipher(struct crypto_skcipher *tfm,
@@ -216,26 +221,118 @@ static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
+
+	alg->exit(skcipher);
+}
+
 static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 {
+	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
+
 	if (tfm->__crt_alg->cra_type == &crypto_blkcipher_type)
 		return crypto_init_skcipher_ops_blkcipher(tfm);
 
-	BUG_ON(tfm->__crt_alg->cra_type != &crypto_ablkcipher_type &&
-	       tfm->__crt_alg->cra_type != &crypto_givcipher_type);
+	if (tfm->__crt_alg->cra_type == &crypto_ablkcipher_type ||
+	    tfm->__crt_alg->cra_type == &crypto_givcipher_type)
+		return crypto_init_skcipher_ops_ablkcipher(tfm);
+
+	skcipher->setkey = alg->setkey;
+	skcipher->encrypt = alg->encrypt;
+	skcipher->decrypt = alg->decrypt;
+	skcipher->ivsize = alg->ivsize;
+	skcipher->keysize = alg->max_keysize;
+
+	if (alg->exit)
+		skcipher->base.exit = crypto_skcipher_exit_tfm;
 
-	return crypto_init_skcipher_ops_ablkcipher(tfm);
+	if (alg->init)
+		return alg->init(skcipher);
+
+	return 0;
+}
+
+static void crypto_skcipher_free_instance(struct crypto_instance *inst)
+{
+	struct skcipher_instance *skcipher =
+		container_of(inst, struct skcipher_instance, s.base);
+
+	skcipher->free(skcipher);
+}
+
+static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
+						     base);
+
+	seq_printf(m, "type         : skcipher\n");
+	seq_printf(m, "async        : %s\n",
+		   alg->cra_flags & CRYPTO_ALG_ASYNC ?  "yes" : "no");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "min keysize  : %u\n", skcipher->min_keysize);
+	seq_printf(m, "max keysize  : %u\n", skcipher->max_keysize);
+	seq_printf(m, "ivsize       : %u\n", skcipher->ivsize);
+	seq_printf(m, "chunksize    : %u\n", skcipher->chunksize);
 }
 
+#ifdef CONFIG_NET
+static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	struct crypto_report_blkcipher rblkcipher;
+	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
+						     base);
+
+	strncpy(rblkcipher.type, "skcipher", sizeof(rblkcipher.type));
+	strncpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
+
+	rblkcipher.blocksize = alg->cra_blocksize;
+	rblkcipher.min_keysize = skcipher->min_keysize;
+	rblkcipher.max_keysize = skcipher->max_keysize;
+	rblkcipher.ivsize = skcipher->ivsize;
+
+	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
+		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+#else
+static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -ENOSYS;
+}
+#endif
+
 static const struct crypto_type crypto_skcipher_type2 = {
 	.extsize = crypto_skcipher_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
+	.free = crypto_skcipher_free_instance,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_skcipher_show,
+#endif
+	.report = crypto_skcipher_report,
 	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
 	.maskset = CRYPTO_ALG_TYPE_BLKCIPHER_MASK,
-	.type = CRYPTO_ALG_TYPE_BLKCIPHER,
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.tfmsize = offsetof(struct crypto_skcipher, base),
 };
 
+int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
+			  const char *name, u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_skcipher_type2;
+	return crypto_grab_spawn(&spawn->base, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_skcipher2);
+
 struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask)
 {
@@ -243,5 +340,90 @@ struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_skcipher);
 
+int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_type_has_alg(alg_name, &crypto_skcipher_type2,
+				   type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_has_skcipher2);
+
+static int skcipher_prepare_alg(struct skcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	if (!alg->chunksize)
+		alg->chunksize = base->cra_blocksize;
+
+	base->cra_type = &crypto_skcipher_type2;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_SKCIPHER;
+
+	return 0;
+}
+
+int crypto_register_skcipher(struct skcipher_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+	int err;
+
+	err = skcipher_prepare_alg(alg);
+	if (err)
+		return err;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_skcipher);
+
+void crypto_unregister_skcipher(struct skcipher_alg *alg)
+{
+	crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_skcipher);
+
+int crypto_register_skciphers(struct skcipher_alg *algs, int count)
+{
+	int i, ret;
+
+	for (i = 0; i < count; i++) {
+		ret = crypto_register_skcipher(&algs[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	for (--i; i >= 0; --i)
+		crypto_unregister_skcipher(&algs[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_register_skciphers);
+
+void crypto_unregister_skciphers(struct skcipher_alg *algs, int count)
+{
+	int i;
+
+	for (i = count - 1; i >= 0; --i)
+		crypto_unregister_skcipher(&algs[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_skciphers);
+
+int skcipher_register_instance(struct crypto_template *tmpl,
+			   struct skcipher_instance *inst)
+{
+	int err;
+
+	err = skcipher_prepare_alg(&inst->alg);
+	if (err)
+		return err;
+
+	return crypto_register_instance(tmpl, skcipher_crypto_instance(inst));
+}
+EXPORT_SYMBOL_GPL(skcipher_register_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Symmetric key cipher type");
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 2cf7a61..ce6619c 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -19,12 +19,46 @@
 
 struct rtattr;
 
+struct skcipher_instance {
+	void (*free)(struct skcipher_instance *inst);
+	union {
+		struct {
+			char head[offsetof(struct skcipher_alg, base)];
+			struct crypto_instance base;
+		} s;
+		struct skcipher_alg alg;
+	};
+};
+
 struct crypto_skcipher_spawn {
 	struct crypto_spawn base;
 };
 
 extern const struct crypto_type crypto_givcipher_type;
 
+static inline struct crypto_instance *skcipher_crypto_instance(
+	struct skcipher_instance *inst)
+{
+	return &inst->s.base;
+}
+
+static inline struct skcipher_instance *skcipher_alg_instance(
+	struct crypto_skcipher *skcipher)
+{
+	return container_of(crypto_skcipher_alg(skcipher),
+			    struct skcipher_instance, alg);
+}
+
+static inline void *skcipher_instance_ctx(struct skcipher_instance *inst)
+{
+	return crypto_instance_ctx(skcipher_crypto_instance(inst));
+}
+
+static inline void skcipher_request_complete(struct skcipher_request *req, int err)
+{
+	req->base.complete(&req->base, err);
+}
+
 static inline void crypto_set_skcipher_spawn(
 	struct crypto_skcipher_spawn *spawn, struct crypto_instance *inst)
 {
@@ -33,6 +67,8 @@ static inline void crypto_set_skcipher_spawn(
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask);
+int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
+			  const char *name, u32 type, u32 mask);
 
 struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask);
 
@@ -47,6 +83,12 @@ static inline struct crypto_alg *crypto_skcipher_spawn_alg(
 	return spawn->base.alg;
 }
 
+static inline struct skcipher_alg *crypto_spawn_skcipher_alg(
+	struct crypto_skcipher_spawn *spawn)
+{
+	return container_of(spawn->base.alg, struct skcipher_alg, base);
+}
+
 static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
 	struct crypto_skcipher_spawn *spawn)
 {
@@ -55,6 +97,25 @@ static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
 				 crypto_skcipher_mask(0)));
 }
 
+static inline struct crypto_skcipher *crypto_spawn_skcipher2(
+	struct crypto_skcipher_spawn *spawn)
+{
+	return crypto_spawn_tfm2(&spawn->base);
+}
+
+static inline void crypto_skcipher_set_reqsize(
+	struct crypto_skcipher *skcipher, unsigned int reqsize)
+{
+	skcipher->reqsize = reqsize;
+}
+
+int crypto_register_skcipher(struct skcipher_alg *alg);
+void crypto_unregister_skcipher(struct skcipher_alg *alg);
+int crypto_register_skciphers(struct skcipher_alg *algs, int count);
+void crypto_unregister_skciphers(struct skcipher_alg *algs, int count);
+int skcipher_register_instance(struct crypto_template *tmpl,
+			       struct skcipher_instance *inst);
+
 int skcipher_null_givencrypt(struct skcipher_givcrypt_request *req);
 int skcipher_null_givdecrypt(struct skcipher_givcrypt_request *req);
 const char *crypto_default_geniv(const struct crypto_alg *alg);
@@ -122,5 +183,31 @@ static inline u32 skcipher_request_flags(struct skcipher_request *req)
 	return req->base.flags;
 }
 
+static inline unsigned int crypto_skcipher_alg_min_keysize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blkcipher.min_keysize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_ablkcipher.min_keysize;
+
+	return alg->min_keysize;
+}
+
+static inline unsigned int crypto_skcipher_alg_max_keysize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blkcipher.max_keysize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_ablkcipher.max_keysize;
+
+	return alg->max_keysize;
+}
+
 #endif	/* _CRYPTO_INTERNAL_SKCIPHER_H */
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 0f987f5..a381f57 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -65,6 +65,75 @@ struct crypto_skcipher {
 	struct crypto_tfm base;
 };
 
+/**
+ * struct skcipher_alg - symmetric key cipher definition
+ * @min_keysize: Minimum key size supported by the transformation. This is the
+ *		 smallest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MIN_KEY_SIZE" include/crypto/
+ * @max_keysize: Maximum key size supported by the transformation. This is the
+ *		 largest key length supported by this transformation algorithm.
+ *		 This must be set to one of the pre-defined values as this is
+ *		 not hardware specific. Possible values for this field can be
+ *		 found via git grep "_MAX_KEY_SIZE" include/crypto/
+ * @setkey: Set key for the transformation. This function is used to either
+ *	    program a supplied key into the hardware or store the key in the
+ *	    transformation context for programming it later. Note that this
+ *	    function does modify the transformation context. This function can
+ *	    be called multiple times during the existence of the transformation
+ *	    object, so one must make sure the key is properly reprogrammed into
+ *	    the hardware. This function is also responsible for checking the key
+ *	    length for validity. In case a software fallback was put in place in
+ *	    the @cra_init call, this function might need to use the fallback if
+ *	    the algorithm doesn't support all of the key sizes.
+ * @encrypt: Encrypt a scatterlist of blocks. This function is used to encrypt
+ *	     the supplied scatterlist containing the blocks of data. The crypto
+ *	     API consumer is responsible for aligning the entries of the
+ *	     scatterlist properly and making sure the chunks are correctly
+ *	     sized. In case a software fallback was put in place in the
+ *	     @cra_init call, this function might need to use the fallback if
+ *	     the algorithm doesn't support all of the key sizes. In case the
+ *	     key was stored in transformation context, the key might need to be
+ *	     re-programmed into the hardware in this function. This function
+ *	     shall not modify the transformation context, as this function may
+ *	     be called in parallel with the same transformation object.
+ * @decrypt: Decrypt a single block. This is a reverse counterpart to @encrypt
+ *	     and the conditions are exactly the same.
+ * @init: Initialize the cryptographic transformation object. This function
+ *	  is used to initialize the cryptographic transformation object.
+ *	  This function is called only once at the instantiation time, right
+ *	  after the transformation context was allocated. In case the
+ *	  cryptographic hardware has some special requirements which need to
+ *	  be handled by software, this function shall check for the precise
+ *	  requirement of the transformation and put any software fallbacks
+ *	  in place.
+ * @exit: Deinitialize the cryptographic transformation object. This is a
+ *	  counterpart to @init, used to remove various changes set in
+ *	  @init.
+ * @ivsize: IV size applicable for transformation. The consumer must provide an
+ *	    IV of exactly that size to perform the encrypt or decrypt operation.
+ * @chunksize: Equal to the block size except for stream ciphers such as
+ *	       CTR where it is set to the underlying block size.
+ *
+ * All fields except @ivsize are mandatory and must be filled.
+ */
+struct skcipher_alg {
+	int (*setkey)(struct crypto_skcipher *tfm, const u8 *key,
+	              unsigned int keylen);
+	int (*encrypt)(struct skcipher_request *req);
+	int (*decrypt)(struct skcipher_request *req);
+	int (*init)(struct crypto_skcipher *tfm);
+	void (*exit)(struct crypto_skcipher *tfm);
+
+	unsigned int min_keysize;
+	unsigned int max_keysize;
+	unsigned int ivsize;
+	unsigned int chunksize;
+
+	struct crypto_alg base;
+};
+
 #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
 	char __##name##_desc[sizeof(struct skcipher_request) + \
 		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
@@ -231,12 +300,43 @@ static inline int crypto_has_skcipher(const char *alg_name, u32 type,
 			      crypto_skcipher_mask(mask));
 }
 
+/**
+ * crypto_has_skcipher2() - Search for the availability of an skcipher.
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      skcipher
+ * @type: specifies the type of the skcipher
+ * @mask: specifies the mask for the skcipher
+ *
+ * Return: true when the skcipher is known to the kernel crypto API; false
+ *	   otherwise
+ */
+int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask);
+
 static inline const char *crypto_skcipher_driver_name(
 	struct crypto_skcipher *tfm)
 {
 	return crypto_tfm_alg_driver_name(crypto_skcipher_tfm(tfm));
 }
 
+static inline struct skcipher_alg *crypto_skcipher_alg(
+	struct crypto_skcipher *tfm)
+{
+	return container_of(crypto_skcipher_tfm(tfm)->__crt_alg,
+			    struct skcipher_alg, base);
+}
+
+static inline unsigned int crypto_skcipher_alg_ivsize(struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blkcipher.ivsize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_ablkcipher.ivsize;
+
+	return alg->ivsize;
+}
+
 /**
  * crypto_skcipher_ivsize() - obtain IV size
  * @tfm: cipher handle
@@ -251,6 +351,36 @@ static inline unsigned int crypto_skcipher_ivsize(struct crypto_skcipher *tfm)
 	return tfm->ivsize;
 }
 
+static inline unsigned int crypto_skcipher_alg_chunksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->chunksize;
+}
+
+/**
+ * crypto_skcipher_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CTR.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_skcipher_chunksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
+}
+
 /**
  * crypto_skcipher_blocksize() - obtain block size of cipher
  * @tfm: cipher handle
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 992cfc2..37a652d 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -47,6 +47,7 @@
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
+#define CRYPTO_ALG_TYPE_SKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_KPP		0x00000008
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
