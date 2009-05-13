From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 13 May 2009 15:08:18 +0200
Message-ID: <20090513130818.GF20366@secunet.com>
References: <20090513130618.GD20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:37473 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbZEMNGG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 May 2009 09:06:06 -0400
Content-Disposition: inline
In-Reply-To: <20090513130618.GD20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds an interface to wrap aead algorithms with an
arbitrary crypto template. This is useful to make a certain
version of an aead algorithm the system default of that algorithm.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/aead.c                  |  286 +++++++++++++++++++++++++++++++++++++++-
 include/crypto/internal/aead.h |    8 +
 include/linux/crypto.h         |   10 +-
 3 files changed, 295 insertions(+), 9 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index d9aa733..f45e27a 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -286,6 +286,7 @@ struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
 	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
 	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
+	inst->alg.cra_aead.wrapper = alg->cra_aead.wrapper;
 
 	inst->alg.cra_aead.setkey = alg->cra_aead.setkey;
 	inst->alg.cra_aead.setauthsize = alg->cra_aead.setauthsize;
@@ -407,6 +408,262 @@ out:
 	return err;
 }
 
+static int crypto_init_wrapaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
+	struct aead_tfm *crt = &tfm->crt_aead;
+
+	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
+		return -EINVAL;
+
+	crt->setkey = alg->setkey;
+	crt->encrypt = alg->encrypt;
+	crt->decrypt = alg->decrypt;
+	crt->givencrypt = alg->givencrypt ?: no_givcrypt;
+	crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
+	crt->base = __crypto_aead_cast(tfm);
+	crt->ivsize = alg->ivsize;
+	crt->authsize = alg->maxauthsize;
+
+	return 0;
+}
+
+static void crypto_wrapaead_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_wrapaead_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	struct aead_alg *aead = &alg->cra_aead;
+
+	seq_printf(m, "type         : wrapped aead\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
+	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
+	seq_printf(m, "geniv        : %s\n", aead->geniv ?: "<built-in>");
+	seq_printf(m, "wrapper      : %s\n", alg->cra_flags & CRYPTO_ALG_WRAP ?
+					     aead->wrapper : "<built-in>");
+}
+
+const struct crypto_type crypto_wrapaead_type = {
+	.ctxsize = crypto_aead_ctxsize,
+	.init = crypto_init_wrapaead_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_wrapaead_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_wrapaead_type);
+
+static int crypto_grab_wrapaead(struct crypto_aead_spawn *spawn,
+			       const char *name, u32 type, u32 mask)
+{
+	struct crypto_alg *alg;
+	int err;
+
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_WRAP);
+	type |= CRYPTO_ALG_TYPE_AEAD;
+	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_WRAP;
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
+struct crypto_instance *aead_wrap_alloc(struct crypto_template *tmpl,
+					 struct rtattr **tb,
+					 unsigned int ctx_size, u32 type,
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
+	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_WRAP)) &
+	    algt->mask)
+		return ERR_PTR(-EINVAL);
+
+	name = crypto_attr_alg_name(tb[1]);
+	err = PTR_ERR(name);
+	if (IS_ERR(name))
+		return ERR_PTR(err);
+
+	inst = kzalloc(sizeof(*inst) + ctx_size, GFP_KERNEL);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
+
+	spawn = crypto_instance_ctx(inst);
+
+	/* Ignore async algorithms if necessary. */
+	mask |= crypto_requires_sync(algt->type, algt->mask);
+
+	crypto_set_aead_spawn(spawn, inst);
+	err = crypto_grab_wrapaead(spawn, name, type, mask);
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_aead_spawn_alg(spawn);
+
+	err = -EINVAL;
+	if (alg->cra_type != &crypto_aead_type)
+		goto err_drop_alg;
+
+	if (algt->mask & CRYPTO_ALG_WRAP) {
+		if (strcmp(tmpl->name, alg->cra_aead.wrapper))
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
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_WRAP;
+	inst->alg.cra_flags |= alg->cra_flags
+			     & (CRYPTO_ALG_GENIV | CRYPTO_ALG_ASYNC);
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+	inst->alg.cra_aead.ivsize = alg->cra_aead.ivsize;
+	inst->alg.cra_aead.maxauthsize = alg->cra_aead.maxauthsize;
+	inst->alg.cra_type = &crypto_wrapaead_type;
+	inst->alg.cra_aead.wrapper = alg->cra_aead.wrapper;
+	inst->alg.cra_aead.geniv = alg->cra_aead.geniv;
+	inst->alg.cra_priority = alg->cra_priority + 100;
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
+EXPORT_SYMBOL_GPL(aead_wrap_alloc);
+
+void aead_wrap_free(struct crypto_instance *inst)
+{
+	crypto_drop_aead(crypto_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(aead_wrap_free);
+
+int aead_wrap_init(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
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
+EXPORT_SYMBOL_GPL(aead_wrap_init);
+
+void aead_wrap_exit(struct crypto_tfm *tfm)
+{
+	crypto_free_aead(tfm->crt_aead.base);
+}
+EXPORT_SYMBOL_GPL(aead_wrap_exit);
+
+static int crypto_wrapaead_default(struct crypto_alg *alg, u32 type, u32 mask)
+{
+	struct rtattr *tb[3];
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_type data;
+	} ptype;
+	struct {
+		struct rtattr attr;
+		struct crypto_attr_alg data;
+	} palg;
+	struct crypto_template *tmpl;
+	struct crypto_instance *inst;
+	struct crypto_alg *larval;
+	const char *wrapper;
+	int err;
+
+	larval = crypto_larval_lookup(alg->cra_driver_name,
+				      CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_WRAP,
+				      CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_WRAP);
+	err = PTR_ERR(larval);
+	if (IS_ERR(larval))
+		goto out;
+
+	err = -EAGAIN;
+	if (!crypto_is_larval(larval))
+		goto drop_larval;
+
+	ptype.attr.rta_len = sizeof(ptype);
+	ptype.attr.rta_type = CRYPTOA_TYPE;
+	ptype.data.type = type | CRYPTO_ALG_WRAP;
+	ptype.data.mask = mask | CRYPTO_ALG_WRAP;
+	tb[0] = &ptype.attr;
+
+	palg.attr.rta_len = sizeof(palg);
+	palg.attr.rta_type = CRYPTOA_ALG;
+	/* Must use the exact name to locate ourselves. */
+	memcpy(palg.data.name, alg->cra_driver_name, CRYPTO_MAX_ALG_NAME);
+	tb[1] = &palg.attr;
+
+	tb[2] = NULL;
+
+	wrapper = alg->cra_aead.wrapper;
+
+	tmpl = crypto_lookup_template(wrapper);
+	err = -ENOENT;
+	if (!tmpl)
+		goto kill_larval;
+
+	inst = tmpl->alloc(tb);
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto put_tmpl;
+
+	if ((err = crypto_register_instance(tmpl, inst))) {
+		tmpl->free(inst);
+		goto put_tmpl;
+	}
+
+	/* Redo the lookup to use the instance we just registered. */
+	err = -EAGAIN;
+
+put_tmpl:
+	crypto_tmpl_put(tmpl);
+kill_larval:
+	crypto_larval_kill(larval);
+drop_larval:
+	crypto_mod_put(larval);
+out:
+	crypto_mod_put(alg);
+	return err;
+}
+
 static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 					     u32 mask)
 {
@@ -416,10 +673,13 @@ static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 	if (IS_ERR(alg))
 		return alg;
 
-	if (alg->cra_type == &crypto_aead_type)
+	if (alg->cra_type == &crypto_wrapaead_type)
 		return alg;
 
-	if (!alg->cra_aead.ivsize)
+	if ((alg->cra_type == &crypto_aead_type) && !alg->cra_aead.wrapper)
+		return alg;
+
+	if (!alg->cra_aead.ivsize && !alg->cra_aead.wrapper)
 		return alg;
 
 	crypto_mod_put(alg);
@@ -428,7 +688,7 @@ static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 	if (IS_ERR(alg))
 		return alg;
 
-	if (alg->cra_type == &crypto_aead_type) {
+	if (alg->cra_type == &crypto_wrapaead_type) {
 		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
 			crypto_mod_put(alg);
 			alg = ERR_PTR(-ENOENT);
@@ -436,6 +696,18 @@ static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 		return alg;
 	}
 
+	if (alg->cra_type == &crypto_aead_type) {
+		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
+			crypto_mod_put(alg);
+			alg = ERR_PTR(-ENOENT);
+		}
+
+		if (!alg->cra_aead.wrapper)
+			return alg;
+
+		return ERR_PTR(crypto_wrapaead_default(alg, type, mask));
+	}
+
 	BUG_ON(!alg->cra_aead.ivsize);
 
 	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
@@ -447,9 +719,9 @@ int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 	struct crypto_alg *alg;
 	int err;
 
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV | CRYPTO_ALG_WRAP);
 	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV | CRYPTO_ALG_WRAP);
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	alg = crypto_lookup_aead(name, type, mask);
@@ -467,9 +739,9 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 	struct crypto_tfm *tfm;
 	int err;
 
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV | CRYPTO_ALG_WRAP);
 	type |= CRYPTO_ALG_TYPE_AEAD;
-	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
+	mask &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV | CRYPTO_ALG_WRAP);
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	for (;;) {
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index d838c94..4bf8a50 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -65,6 +65,14 @@ static inline struct crypto_aead *aead_geniv_base(struct crypto_aead *geniv)
 	return crypto_aead_crt(geniv)->base;
 }
 
+struct crypto_instance *aead_wrap_alloc(struct crypto_template *tmpl,
+					 struct rtattr **tb,
+					 unsigned int ctx_size, u32 type,
+					 u32 mask);
+void aead_wrap_free(struct crypto_instance *inst);
+int aead_wrap_init(struct crypto_tfm *tfm);
+void aead_wrap_exit(struct crypto_tfm *tfm);
+
 static inline void *aead_givcrypt_reqctx(struct aead_givcrypt_request *req)
 {
 	return aead_request_ctx(&req->areq);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ec29fa2..2548bf0 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -71,6 +71,8 @@
 
 #define CRYPTO_ALG_TESTED		0x00000400
 
+#define CRYPTO_ALG_WRAP			0x00000800
+
 /*
  * Transform masks and values (for crt_flags).
  */
@@ -242,6 +244,7 @@ struct aead_alg {
 	int (*givdecrypt)(struct aead_givcrypt_request *req);
 
 	const char *geniv;
+	const char *wrapper;
 
 	unsigned int ivsize;
 	unsigned int maxauthsize;
@@ -881,9 +884,12 @@ static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
 }
 
 static inline void aead_request_set_tfm(struct aead_request *req,
-					struct crypto_aead *tfm)
+					struct crypto_aead *aead)
 {
-	req->base.tfm = crypto_aead_tfm(crypto_aead_crt(tfm)->base);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+
+	req->base.tfm = tfm->__crt_alg->cra_flags & CRYPTO_ALG_WRAP ?
+			tfm : crypto_aead_tfm(crypto_aead_crt(aead)->base);
 }
 
 static inline struct aead_request *aead_request_alloc(struct crypto_aead *tfm,
-- 
1.5.4.2

