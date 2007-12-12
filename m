From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/10] [CRYPTO] aead: Add aead_geniv_alloc/aead_geniv_free
Date: Wed, 12 Dec 2007 20:30:56 +0800
Message-ID: <E1J2Qjo-0006dd-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3733 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758214AbXLLMbD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:31:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] aead: Add aead_geniv_alloc/aead_geniv_free

This patch creates the infrastructure to help the construction of IV
generator templates that wrap around AEAD algorithms by adding an IV
generator to them.  This is useful for AEAD algorithms with no built-in
IV generator or to replace their built-in generator.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |  202 +++++++++++++++++++++++++++++++++++++++--
 include/crypto/internal/aead.h |   77 +++++++++++++++
 include/linux/crypto.h         |    7 +
 3 files changed, 280 insertions(+), 6 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 15335ed..e26d8d5 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -12,14 +12,16 @@
  *
  */
 
-#include <crypto/algapi.h>
-#include <linux/errno.h>
+#include <crypto/internal/aead.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
+#include "internal.h"
+
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -55,18 +57,20 @@ static int setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 
 int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 {
+	struct aead_tfm *crt = crypto_aead_crt(tfm);
 	int err;
 
 	if (authsize > crypto_aead_alg(tfm)->maxauthsize)
 		return -EINVAL;
 
 	if (crypto_aead_alg(tfm)->setauthsize) {
-		err = crypto_aead_alg(tfm)->setauthsize(tfm, authsize);
+		err = crypto_aead_alg(tfm)->setauthsize(crt->base, authsize);
 		if (err)
 			return err;
 	}
 
-	crypto_aead_crt(tfm)->authsize = authsize;
+	crypto_aead_crt(crt->base)->authsize = authsize;
+	crt->authsize = authsize;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
@@ -90,11 +94,13 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	crt->setkey = setkey;
+	crt->setkey = tfm->__crt_alg->cra_flags & CRYPTO_ALG_GENIV ?
+		      alg->setkey : setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
 	crt->givencrypt = alg->givencrypt ?: no_givcrypt;
 	crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
+	crt->base = __crypto_aead_cast(tfm);
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->maxauthsize;
 
@@ -111,6 +117,7 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
 	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
+	seq_printf(m, "geniv        : %s\n", aead->geniv ?: "<built-in>");
 }
 
 const struct crypto_type crypto_aead_type = {
@@ -122,5 +129,190 @@ const struct crypto_type crypto_aead_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
+static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
+	struct aead_tfm *crt = &tfm->crt_aead;
+
+	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	crt->setkey = setkey;
+	crt->encrypt = alg->encrypt;
+	crt->decrypt = alg->decrypt;
+	crt->base = __crypto_aead_cast(tfm);
+	crt->ivsize = alg->ivsize;
+	crt->authsize = alg->maxauthsize;
+
+	return 0;
+}
+
+static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct aead_alg *aead = &alg->cra_aead;
+
+	seq_printf(m, "type         : nivaead\n");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
+	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
+	seq_printf(m, "geniv        : %s\n", aead->geniv);
+}
+
+const struct crypto_type crypto_nivaead_type = {
+	.ctxsize = crypto_aead_ctxsize,
+	.init = crypto_init_nivaead_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_nivaead_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_nivaead_type);
+
+static int crypto_grab_nivaead(struct crypto_aead_spawn *spawn,
+			       const char *name, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type |= CRYPTO_ALG_TYPE_AEAD;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV;
+
+	alg = crypto_alg_mod_lookup(name, type, mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
+	crypto_mod_put(alg);
+	return err;
+}
+
+struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+					 struct rtattr **tb, u32 type,
+					 u32 mask)
+{
+	const char *name;
+	struct crypto_aead_spawn *spawn;
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV)) &
+	    algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		return ERR_PTR(err);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = crypto_instance_ctx(inst);
+
+	/* Ignore async algorithms if necessary. */
+	mask |= (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask;
+
+	crypto_set_aead_spawn(spawn, inst);
+	err = crypto_grab_nivaead(spawn, name, type, mask);
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_aead_spawn_alg(spawn);
+
+	err = -EINVAL;
+	if (!alg->cra_aead.ivsize)
+		goto err_drop_alg;
+
+	/*
+	 * This is only true if we're constructing an algorithm with its
+	 * default IV generator.  For the default generator we elide the
+	 * template name and double-check the IV generator.
+	 */
+	if (algt->mask & CRYPTO_ALG_GENIV) {
+		if (strcmp(tmpl->name, alg->cra_aead.geniv))
+			goto err_drop_alg;
+
+		memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+		memcpy(inst->alg.cra_driver_name, alg->cra_driver_name,
+		       CRYPTO_MAX_ALG_NAME);
+	} else {
+		err = -ENAMETOOLONG;
+		if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, alg->cra_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_drop_alg;
+		if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+			     "%s(%s)", tmpl->name, alg->cra_driver_name) >=
+		    CRYPTO_MAX_ALG_NAME)
+			goto err_drop_alg;
+	}
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV;
+	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.cra_priority = alg->cra_priority;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_type = &crypto_aead_type;
+
+	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
+	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
+	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
+
+	inst->alg.cra_aead.setkey = alg->cra_aead.setkey;
+	inst->alg.cra_aead.setauthsize = alg->cra_aead.setauthsize;
+	inst->alg.cra_aead.encrypt = alg->cra_aead.encrypt;
+	inst->alg.cra_aead.decrypt = alg->cra_aead.decrypt;
+
+out:
+	return inst;
+
+err_drop_alg:
+	crypto_drop_aead(spawn);
+err_free_inst:
+	kfree(inst);
+	inst = ERR_PTR(err);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(aead_geniv_alloc);
+
+void aead_geniv_free(struct crypto_instance *inst)
+{
+	crypto_drop_aead(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(aead_geniv_free);
+
+int aead_geniv_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = (void *)tfm->__crt_alg;
+	struct crypto_aead *aead;
+
+	aead = crypto_spawn_aead(crypto_instance_ctx(inst));
+	if (IS_ERR(aead))
+		return PTR_ERR(aead);
+
+	tfm->crt_aead.base = aead;
+	tfm->crt_aead.reqsize += crypto_aead_reqsize(aead);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aead_geniv_init);
+
+void aead_geniv_exit(struct crypto_tfm *tfm)
+{
+	crypto_free_aead(tfm->crt_aead.base);
+}
+EXPORT_SYMBOL_GPL(aead_geniv_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Authenticated Encryption with Associated Data (AEAD)");
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
new file mode 100644
index 0000000..eb4eee7
--- /dev/null
+++ b/include/crypto/internal/aead.h
@@ -0,0 +1,77 @@
+/*
+ * AEAD: Authenticated Encryption with Associated Data
+ * 
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_INTERNAL_AEAD_H
+#define _CRYPTO_INTERNAL_AEAD_H
+
+#include <crypto/aead.h>
+#include <crypto/algapi.h>
+#include <linux/types.h>
+
+struct rtattr;
+
+struct crypto_aead_spawn {
+	struct crypto_spawn base;
+};
+
+extern const struct crypto_type crypto_nivaead_type;
+
+static inline void crypto_set_aead_spawn(
+	struct crypto_aead_spawn *spawn, struct crypto_instance *inst)
+{
+	crypto_set_spawn(&spawn->base, inst);
+}
+
+static inline void crypto_drop_aead(struct crypto_aead_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_alg *crypto_aead_spawn_alg(
+	struct crypto_aead_spawn *spawn)
+{
+	return spawn->base.alg;
+}
+
+static inline struct crypto_aead *crypto_spawn_aead(
+	struct crypto_aead_spawn *spawn)
+{
+	return __crypto_aead_cast(
+		crypto_spawn_tfm(&spawn->base, CRYPTO_ALG_TYPE_AEAD,
+				 CRYPTO_ALG_TYPE_MASK));
+}
+
+struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+					 struct rtattr **tb, u32 type,
+					 u32 mask);
+void aead_geniv_free(struct crypto_instance *inst);
+int aead_geniv_init(struct crypto_tfm *tfm);
+void aead_geniv_exit(struct crypto_tfm *tfm);
+
+static inline struct crypto_aead *aead_geniv_base(struct crypto_aead *geniv)
+{
+	return crypto_aead_crt(geniv)->base;
+}
+
+static inline void *aead_givcrypt_reqctx(struct aead_givcrypt_request *req)
+{
+	return aead_request_ctx(&req->areq);
+}
+
+static inline void aead_givcrypt_complete(struct aead_givcrypt_request *req,
+					  int err)
+{
+	aead_request_complete(&req->areq, err);
+}
+
+#endif	/* _CRYPTO_INTERNAL_AEAD_H */
+
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7524928..e26e648 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -206,6 +206,8 @@ struct aead_alg {
 	int (*givencrypt)(struct aead_givcrypt_request *req);
 	int (*givdecrypt)(struct aead_givcrypt_request *req);
 
+	const char *geniv;
+
 	unsigned int ivsize;
 	unsigned int maxauthsize;
 };
@@ -353,6 +355,9 @@ struct aead_tfm {
 	int (*decrypt)(struct aead_request *req);
 	int (*givencrypt)(struct aead_givcrypt_request *req);
 	int (*givdecrypt)(struct aead_givcrypt_request *req);
+
+	struct crypto_aead *base;
+
 	unsigned int ivsize;
 	unsigned int authsize;
 	unsigned int reqsize;
@@ -809,7 +814,7 @@ static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
 static inline void aead_request_set_tfm(struct aead_request *req,
 					struct crypto_aead *tfm)
 {
-	req->base.tfm = crypto_aead_tfm(tfm);
+	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
 }
 
 static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
