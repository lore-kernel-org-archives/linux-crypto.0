From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 18/30] crypto: skcipher - Remove top-level givcipher interface
Date: Tue, 12 Jul 2016 13:17:50 +0800
Message-ID: <E1bMq4s-0007Si-I0@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56721 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbcGLFRy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:54 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4s-0004e2-N2
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:50 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the old crypto_grab_skcipher helper and replaces
it with crypto_grab_skcipher2.

As this is the final entry point into givcipher this patch also
removes all traces of the top-level givcipher interface, including
all implicit IV generators such as chainiv.

The bottom-level givcipher interface remains until the drivers
using it are converted.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile                    |    2 
 crypto/ablkcipher.c                |  222 -------------------------
 crypto/blkcipher.c                 |  185 ---------------------
 crypto/chainiv.c                   |  317 -------------------------------------
 crypto/eseqiv.c                    |  242 ----------------------------
 crypto/seqiv.c                     |  162 ------------------
 crypto/skcipher.c                  |    4 
 include/crypto/internal/skcipher.h |   63 +------
 include/crypto/skcipher.h          |   76 --------
 include/linux/crypto.h             |   19 --
 10 files changed, 18 insertions(+), 1274 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index df1bcfb..99cc64ac 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -20,8 +20,6 @@ crypto_blkcipher-y := ablkcipher.o
 crypto_blkcipher-y += blkcipher.o
 crypto_blkcipher-y += skcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER2) += chainiv.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER2) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 obj-$(CONFIG_CRYPTO_ECHAINIV) += echainiv.o
 
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 6b80516..d676fc5 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -16,8 +16,6 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
-#include <linux/rtnetlink.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
@@ -348,16 +346,6 @@ static unsigned int crypto_ablkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 	return alg->cra_ctxsize;
 }
 
-int skcipher_null_givencrypt(struct skcipher_givcrypt_request *req)
-{
-	return crypto_ablkcipher_encrypt(&req->creq);
-}
-
-int skcipher_null_givdecrypt(struct skcipher_givcrypt_request *req)
-{
-	return crypto_ablkcipher_decrypt(&req->creq);
-}
-
 static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 				      u32 mask)
 {
@@ -370,10 +358,6 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
-	if (!alg->ivsize) {
-		crt->givencrypt = skcipher_null_givencrypt;
-		crt->givdecrypt = skcipher_null_givdecrypt;
-	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
@@ -435,11 +419,6 @@ const struct crypto_type crypto_ablkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_ablkcipher_type);
 
-static int no_givdecrypt(struct skcipher_givcrypt_request *req)
-{
-	return -ENOSYS;
-}
-
 static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 				      u32 mask)
 {
@@ -453,8 +432,6 @@ static int crypto_init_givcipher_ops(struct crypto_tfm *tfm, u32 type,
 		      alg->setkey : setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
-	crt->givencrypt = alg->givencrypt ?: no_givdecrypt;
-	crt->givdecrypt = alg->givdecrypt ?: no_givdecrypt;
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
@@ -515,202 +492,3 @@ const struct crypto_type crypto_givcipher_type = {
 	.report = crypto_givcipher_report,
 };
 EXPORT_SYMBOL_GPL(crypto_givcipher_type);
-
-const char *crypto_default_geniv(const struct crypto_alg *alg)
-{
-	if (((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
-					 alg->cra_ablkcipher.ivsize) !=
-	    alg->cra_blocksize)
-		return "chainiv";
-
-	return "eseqiv";
-}
-
-static int crypto_givcipher_default(struct crypto_alg *alg, u32 type, u32 mask)
-{
-	struct rtattr *tb[3];
-	struct {
-		struct rtattr attr;
-		struct crypto_attr_type data;
-	} ptype;
-	struct {
-		struct rtattr attr;
-		struct crypto_attr_alg data;
-	} palg;
-	struct crypto_template *tmpl;
-	struct crypto_instance *inst;
-	struct crypto_alg *larval;
-	const char *geniv;
-	int err;
-
-	larval = crypto_larval_lookup(alg->cra_driver_name,
-				      (type & ~CRYPTO_ALG_TYPE_MASK) |
-				      CRYPTO_ALG_TYPE_GIVCIPHER,
-				      mask | CRYPTO_ALG_TYPE_MASK);
-	err = PTR_ERR(larval);
-	if (IS_ERR(larval))
-		goto out;
-
-	err = -EAGAIN;
-	if (!crypto_is_larval(larval))
-		goto drop_larval;
-
-	ptype.attr.rta_len = sizeof(ptype);
-	ptype.attr.rta_type = CRYPTOA_TYPE;
-	ptype.data.type = type | CRYPTO_ALG_GENIV;
-	/* GENIV tells the template that we're making a default geniv. */
-	ptype.data.mask = mask | CRYPTO_ALG_GENIV;
-	tb[0] = &ptype.attr;
-
-	palg.attr.rta_len = sizeof(palg);
-	palg.attr.rta_type = CRYPTOA_ALG;
-	/* Must use the exact name to locate ourselves. */
-	memcpy(palg.data.name, alg->cra_driver_name, CRYPTO_MAX_ALG_NAME);
-	tb[1] = &palg.attr;
-
-	tb[2] = NULL;
-
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER)
-		geniv = alg->cra_blkcipher.geniv;
-	else
-		geniv = alg->cra_ablkcipher.geniv;
-
-	if (!geniv)
-		geniv = crypto_default_geniv(alg);
-
-	tmpl = crypto_lookup_template(geniv);
-	err = -ENOENT;
-	if (!tmpl)
-		goto kill_larval;
-
-	if (tmpl->create) {
-		err = tmpl->create(tmpl, tb);
-		if (err)
-			goto put_tmpl;
-		goto ok;
-	}
-
-	inst = tmpl->alloc(tb);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto put_tmpl;
-
-	err = crypto_register_instance(tmpl, inst);
-	if (err) {
-		tmpl->free(inst);
-		goto put_tmpl;
-	}
-
-ok:
-	/* Redo the lookup to use the instance we just registered. */
-	err = -EAGAIN;
-
-put_tmpl:
-	crypto_tmpl_put(tmpl);
-kill_larval:
-	crypto_larval_kill(larval);
-drop_larval:
-	crypto_mod_put(larval);
-out:
-	crypto_mod_put(alg);
-	return err;
-}
-
-struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-
-	alg = crypto_alg_mod_lookup(name, type, mask);
-	if (IS_ERR(alg))
-		return alg;
-
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_GIVCIPHER)
-		return alg;
-
-	if (!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
-					  alg->cra_ablkcipher.ivsize))
-		return alg;
-
-	crypto_mod_put(alg);
-	alg = crypto_alg_mod_lookup(name, type | CRYPTO_ALG_TESTED,
-				    mask & ~CRYPTO_ALG_TESTED);
-	if (IS_ERR(alg))
-		return alg;
-
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_GIVCIPHER) {
-		if (~alg->cra_flags & (type ^ ~mask) & CRYPTO_ALG_TESTED) {
-			crypto_mod_put(alg);
-			alg = ERR_PTR(-ENOENT);
-		}
-		return alg;
-	}
-
-	BUG_ON(!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-		 CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
-					     alg->cra_ablkcipher.ivsize));
-
-	return ERR_PTR(crypto_givcipher_default(alg, type, mask));
-}
-EXPORT_SYMBOL_GPL(crypto_lookup_skcipher);
-
-int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
-			 u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-	int err;
-
-	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask);
-
-	alg = crypto_lookup_skcipher(name, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
-	crypto_mod_put(alg);
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
-
-struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask)
-{
-	struct crypto_tfm *tfm;
-	int err;
-
-	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask);
-
-	for (;;) {
-		struct crypto_alg *alg;
-
-		alg = crypto_lookup_skcipher(alg_name, type, mask);
-		if (IS_ERR(alg)) {
-			err = PTR_ERR(alg);
-			goto err;
-		}
-
-		tfm = __crypto_alloc_tfm(alg, type, mask);
-		if (!IS_ERR(tfm))
-			return __crypto_ablkcipher_cast(tfm);
-
-		crypto_mod_put(alg);
-		err = PTR_ERR(tfm);
-
-err:
-		if (err != -EAGAIN)
-			break;
-		if (fatal_signal_pending(current)) {
-			err = -EINTR;
-			break;
-		}
-	}
-
-	return ERR_PTR(err);
-}
-EXPORT_SYMBOL_GPL(crypto_alloc_ablkcipher);
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 8cc1622..3699995 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -21,7 +21,6 @@
 #include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -466,10 +465,6 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	crt->setkey = async_setkey;
 	crt->encrypt = async_encrypt;
 	crt->decrypt = async_decrypt;
-	if (!alg->ivsize) {
-		crt->givencrypt = skcipher_null_givencrypt;
-		crt->givdecrypt = skcipher_null_givdecrypt;
-	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
@@ -560,185 +555,5 @@ const struct crypto_type crypto_blkcipher_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_blkcipher_type);
 
-static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
-				const char *name, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-	int err;
-
-	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask)| CRYPTO_ALG_GENIV;
-
-	alg = crypto_alg_mod_lookup(name, type, mask);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
-
-	err = crypto_init_spawn(&spawn->base, alg, spawn->base.inst, mask);
-	crypto_mod_put(alg);
-	return err;
-}
-
-struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
-					     struct rtattr **tb, u32 type,
-					     u32 mask)
-{
-	struct {
-		int (*setkey)(struct crypto_ablkcipher *tfm, const u8 *key,
-			      unsigned int keylen);
-		int (*encrypt)(struct ablkcipher_request *req);
-		int (*decrypt)(struct ablkcipher_request *req);
-
-		unsigned int min_keysize;
-		unsigned int max_keysize;
-		unsigned int ivsize;
-
-		const char *geniv;
-	} balg;
-	const char *name;
-	struct crypto_skcipher_spawn *spawn;
-	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
-	struct crypto_alg *alg;
-	int err;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	if ((algt->type ^ (CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV)) &
-	    algt->mask)
-		return ERR_PTR(-EINVAL);
-
-	name = crypto_attr_alg_name(tb[1]);
-	if (IS_ERR(name))
-		return ERR_CAST(name);
-
-	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
-	if (!inst)
-		return ERR_PTR(-ENOMEM);
-
-	spawn = crypto_instance_ctx(inst);
-
-	/* Ignore async algorithms if necessary. */
-	mask |= crypto_requires_sync(algt->type, algt->mask);
-
-	crypto_set_skcipher_spawn(spawn, inst);
-	err = crypto_grab_nivcipher(spawn, name, type, mask);
-	if (err)
-		goto err_free_inst;
-
-	alg = crypto_skcipher_spawn_alg(spawn);
-
-	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-	    CRYPTO_ALG_TYPE_BLKCIPHER) {
-		balg.ivsize = alg->cra_blkcipher.ivsize;
-		balg.min_keysize = alg->cra_blkcipher.min_keysize;
-		balg.max_keysize = alg->cra_blkcipher.max_keysize;
-
-		balg.setkey = async_setkey;
-		balg.encrypt = async_encrypt;
-		balg.decrypt = async_decrypt;
-
-		balg.geniv = alg->cra_blkcipher.geniv;
-	} else {
-		balg.ivsize = alg->cra_ablkcipher.ivsize;
-		balg.min_keysize = alg->cra_ablkcipher.min_keysize;
-		balg.max_keysize = alg->cra_ablkcipher.max_keysize;
-
-		balg.setkey = alg->cra_ablkcipher.setkey;
-		balg.encrypt = alg->cra_ablkcipher.encrypt;
-		balg.decrypt = alg->cra_ablkcipher.decrypt;
-
-		balg.geniv = alg->cra_ablkcipher.geniv;
-	}
-
-	err = -EINVAL;
-	if (!balg.ivsize)
-		goto err_drop_alg;
-
-	/*
-	 * This is only true if we're constructing an algorithm with its
-	 * default IV generator.  For the default generator we elide the
-	 * template name and double-check the IV generator.
-	 */
-	if (algt->mask & CRYPTO_ALG_GENIV) {
-		if (!balg.geniv)
-			balg.geniv = crypto_default_geniv(alg);
-		err = -EAGAIN;
-		if (strcmp(tmpl->name, balg.geniv))
-			goto err_drop_alg;
-
-		memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
-		memcpy(inst->alg.cra_driver_name, alg->cra_driver_name,
-		       CRYPTO_MAX_ALG_NAME);
-	} else {
-		err = -ENAMETOOLONG;
-		if (snprintf(inst->alg.cra_name, CRYPTO_MAX_ALG_NAME,
-			     "%s(%s)", tmpl->name, alg->cra_name) >=
-		    CRYPTO_MAX_ALG_NAME)
-			goto err_drop_alg;
-		if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-			     "%s(%s)", tmpl->name, alg->cra_driver_name) >=
-		    CRYPTO_MAX_ALG_NAME)
-			goto err_drop_alg;
-	}
-
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_GIVCIPHER | CRYPTO_ALG_GENIV;
-	inst->alg.cra_flags |= alg->cra_flags & CRYPTO_ALG_ASYNC;
-	inst->alg.cra_priority = alg->cra_priority;
-	inst->alg.cra_blocksize = alg->cra_blocksize;
-	inst->alg.cra_alignmask = alg->cra_alignmask;
-	inst->alg.cra_type = &crypto_givcipher_type;
-
-	inst->alg.cra_ablkcipher.ivsize = balg.ivsize;
-	inst->alg.cra_ablkcipher.min_keysize = balg.min_keysize;
-	inst->alg.cra_ablkcipher.max_keysize = balg.max_keysize;
-	inst->alg.cra_ablkcipher.geniv = balg.geniv;
-
-	inst->alg.cra_ablkcipher.setkey = balg.setkey;
-	inst->alg.cra_ablkcipher.encrypt = balg.encrypt;
-	inst->alg.cra_ablkcipher.decrypt = balg.decrypt;
-
-out:
-	return inst;
-
-err_drop_alg:
-	crypto_drop_skcipher(spawn);
-err_free_inst:
-	kfree(inst);
-	inst = ERR_PTR(err);
-	goto out;
-}
-EXPORT_SYMBOL_GPL(skcipher_geniv_alloc);
-
-void skcipher_geniv_free(struct crypto_instance *inst)
-{
-	crypto_drop_skcipher(crypto_instance_ctx(inst));
-	kfree(inst);
-}
-EXPORT_SYMBOL_GPL(skcipher_geniv_free);
-
-int skcipher_geniv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_ablkcipher *cipher;
-
-	cipher = crypto_spawn_skcipher(crypto_instance_ctx(inst));
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	tfm->crt_ablkcipher.base = cipher;
-	tfm->crt_ablkcipher.reqsize += crypto_ablkcipher_reqsize(cipher);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(skcipher_geniv_init);
-
-void skcipher_geniv_exit(struct crypto_tfm *tfm)
-{
-	crypto_free_ablkcipher(tfm->crt_ablkcipher.base);
-}
-EXPORT_SYMBOL_GPL(skcipher_geniv_exit);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
deleted file mode 100644
index b434001..0000000
--- a/crypto/chainiv.c
+++ /dev/null
@@ -1,317 +0,0 @@
-/*
- * chainiv: Chain IV Generator
- *
- * Generate IVs simply be using the last block of the previous encryption.
- * This is mainly useful for CBC with a synchronous algorithm.
- *
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#include <crypto/internal/skcipher.h>
-#include <crypto/rng.h>
-#include <crypto/crypto_wq.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/string.h>
-#include <linux/workqueue.h>
-
-enum {
-	CHAINIV_STATE_INUSE = 0,
-};
-
-struct chainiv_ctx {
-	spinlock_t lock;
-	char iv[];
-};
-
-struct async_chainiv_ctx {
-	unsigned long state;
-
-	spinlock_t lock;
-	int err;
-
-	struct crypto_queue queue;
-	struct work_struct postponed;
-
-	char iv[];
-};
-
-static int chainiv_givencrypt(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
-	unsigned int ivsize;
-	int err;
-
-	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
-	ablkcipher_request_set_callback(subreq, req->creq.base.flags &
-						~CRYPTO_TFM_REQ_MAY_SLEEP,
-					req->creq.base.complete,
-					req->creq.base.data);
-	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
-				     req->creq.nbytes, req->creq.info);
-
-	spin_lock_bh(&ctx->lock);
-
-	ivsize = crypto_ablkcipher_ivsize(geniv);
-
-	memcpy(req->giv, ctx->iv, ivsize);
-	memcpy(subreq->info, ctx->iv, ivsize);
-
-	err = crypto_ablkcipher_encrypt(subreq);
-	if (err)
-		goto unlock;
-
-	memcpy(ctx->iv, subreq->info, ivsize);
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	return err;
-}
-
-static int chainiv_init_common(struct crypto_tfm *tfm, char iv[])
-{
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	int err = 0;
-
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
-
-	if (iv) {
-		err = crypto_rng_get_bytes(crypto_default_rng, iv,
-					   crypto_ablkcipher_ivsize(geniv));
-		crypto_put_default_rng();
-	}
-
-	return err ?: skcipher_geniv_init(tfm);
-}
-
-static int chainiv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	struct chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
-	char *iv;
-
-	spin_lock_init(&ctx->lock);
-
-	iv = NULL;
-	if (!crypto_get_default_rng()) {
-		crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
-		iv = ctx->iv;
-	}
-
-	return chainiv_init_common(tfm, iv);
-}
-
-static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
-{
-	int queued;
-	int err = ctx->err;
-
-	if (!ctx->queue.qlen) {
-		smp_mb__before_atomic();
-		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
-
-		if (!ctx->queue.qlen ||
-		    test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
-			goto out;
-	}
-
-	queued = queue_work(kcrypto_wq, &ctx->postponed);
-	BUG_ON(!queued);
-
-out:
-	return err;
-}
-
-static int async_chainiv_postpone_request(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err;
-
-	spin_lock_bh(&ctx->lock);
-	err = skcipher_enqueue_givcrypt(&ctx->queue, req);
-	spin_unlock_bh(&ctx->lock);
-
-	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
-		return err;
-
-	ctx->err = err;
-	return async_chainiv_schedule_work(ctx);
-}
-
-static int async_chainiv_givencrypt_tail(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
-	unsigned int ivsize = crypto_ablkcipher_ivsize(geniv);
-
-	memcpy(req->giv, ctx->iv, ivsize);
-	memcpy(subreq->info, ctx->iv, ivsize);
-
-	ctx->err = crypto_ablkcipher_encrypt(subreq);
-	if (ctx->err)
-		goto out;
-
-	memcpy(ctx->iv, subreq->info, ivsize);
-
-out:
-	return async_chainiv_schedule_work(ctx);
-}
-
-static int async_chainiv_givencrypt(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
-
-	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
-	ablkcipher_request_set_callback(subreq, req->creq.base.flags,
-					req->creq.base.complete,
-					req->creq.base.data);
-	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
-				     req->creq.nbytes, req->creq.info);
-
-	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
-		goto postpone;
-
-	if (ctx->queue.qlen) {
-		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
-		goto postpone;
-	}
-
-	return async_chainiv_givencrypt_tail(req);
-
-postpone:
-	return async_chainiv_postpone_request(req);
-}
-
-static void async_chainiv_do_postponed(struct work_struct *work)
-{
-	struct async_chainiv_ctx *ctx = container_of(work,
-						     struct async_chainiv_ctx,
-						     postponed);
-	struct skcipher_givcrypt_request *req;
-	struct ablkcipher_request *subreq;
-	int err;
-
-	/* Only handle one request at a time to avoid hogging keventd. */
-	spin_lock_bh(&ctx->lock);
-	req = skcipher_dequeue_givcrypt(&ctx->queue);
-	spin_unlock_bh(&ctx->lock);
-
-	if (!req) {
-		async_chainiv_schedule_work(ctx);
-		return;
-	}
-
-	subreq = skcipher_givcrypt_reqctx(req);
-	subreq->base.flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = async_chainiv_givencrypt_tail(req);
-
-	local_bh_disable();
-	skcipher_givcrypt_complete(req, err);
-	local_bh_enable();
-}
-
-static int async_chainiv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	struct async_chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
-	char *iv;
-
-	spin_lock_init(&ctx->lock);
-
-	crypto_init_queue(&ctx->queue, 100);
-	INIT_WORK(&ctx->postponed, async_chainiv_do_postponed);
-
-	iv = NULL;
-	if (!crypto_get_default_rng()) {
-		crypto_ablkcipher_crt(geniv)->givencrypt =
-			async_chainiv_givencrypt;
-		iv = ctx->iv;
-	}
-
-	return chainiv_init_common(tfm, iv);
-}
-
-static void async_chainiv_exit(struct crypto_tfm *tfm)
-{
-	struct async_chainiv_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	BUG_ON(test_bit(CHAINIV_STATE_INUSE, &ctx->state) || ctx->queue.qlen);
-
-	skcipher_geniv_exit(tfm);
-}
-
-static struct crypto_template chainiv_tmpl;
-
-static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
-{
-	struct crypto_attr_type *algt;
-	struct crypto_instance *inst;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return ERR_CAST(algt);
-
-	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0, 0);
-	if (IS_ERR(inst))
-		goto out;
-
-	inst->alg.cra_init = chainiv_init;
-	inst->alg.cra_exit = skcipher_geniv_exit;
-
-	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx);
-
-	if (!crypto_requires_sync(algt->type, algt->mask)) {
-		inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
-
-		inst->alg.cra_init = async_chainiv_init;
-		inst->alg.cra_exit = async_chainiv_exit;
-
-		inst->alg.cra_ctxsize = sizeof(struct async_chainiv_ctx);
-	}
-
-	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
-
-out:
-	return inst;
-}
-
-static struct crypto_template chainiv_tmpl = {
-	.name = "chainiv",
-	.alloc = chainiv_alloc,
-	.free = skcipher_geniv_free,
-	.module = THIS_MODULE,
-};
-
-static int __init chainiv_module_init(void)
-{
-	return crypto_register_template(&chainiv_tmpl);
-}
-
-static void chainiv_module_exit(void)
-{
-	crypto_unregister_template(&chainiv_tmpl);
-}
-
-module_init(chainiv_module_init);
-module_exit(chainiv_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Chain IV Generator");
-MODULE_ALIAS_CRYPTO("chainiv");
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
deleted file mode 100644
index 16dda72..0000000
--- a/crypto/eseqiv.c
+++ /dev/null
@@ -1,242 +0,0 @@
-/*
- * eseqiv: Encrypted Sequence Number IV Generator
- *
- * This generator generates an IV based on a sequence number by xoring it
- * with a salt and then encrypting it with the same key as used to encrypt
- * the plain text.  This algorithm requires that the block size be equal
- * to the IV size.  It is mainly useful for CBC.
- *
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#include <crypto/internal/skcipher.h>
-#include <crypto/rng.h>
-#include <crypto/scatterwalk.h>
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/scatterlist.h>
-#include <linux/spinlock.h>
-#include <linux/string.h>
-
-struct eseqiv_request_ctx {
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
-	char tail[];
-};
-
-struct eseqiv_ctx {
-	spinlock_t lock;
-	unsigned int reqoff;
-	char salt[];
-};
-
-static void eseqiv_complete2(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct eseqiv_request_ctx *reqctx = skcipher_givcrypt_reqctx(req);
-
-	memcpy(req->giv, PTR_ALIGN((u8 *)reqctx->tail,
-			 crypto_ablkcipher_alignmask(geniv) + 1),
-	       crypto_ablkcipher_ivsize(geniv));
-}
-
-static void eseqiv_complete(struct crypto_async_request *base, int err)
-{
-	struct skcipher_givcrypt_request *req = base->data;
-
-	if (err)
-		goto out;
-
-	eseqiv_complete2(req);
-
-out:
-	skcipher_givcrypt_complete(req, err);
-}
-
-static int eseqiv_givencrypt(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	struct eseqiv_request_ctx *reqctx = skcipher_givcrypt_reqctx(req);
-	struct ablkcipher_request *subreq;
-	crypto_completion_t compl;
-	void *data;
-	struct scatterlist *osrc, *odst;
-	struct scatterlist *dst;
-	struct page *srcp;
-	struct page *dstp;
-	u8 *giv;
-	u8 *vsrc;
-	u8 *vdst;
-	__be64 seq;
-	unsigned int ivsize;
-	unsigned int len;
-	int err;
-
-	subreq = (void *)(reqctx->tail + ctx->reqoff);
-	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
-
-	giv = req->giv;
-	compl = req->creq.base.complete;
-	data = req->creq.base.data;
-
-	osrc = req->creq.src;
-	odst = req->creq.dst;
-	srcp = sg_page(osrc);
-	dstp = sg_page(odst);
-	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + osrc->offset;
-	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + odst->offset;
-
-	ivsize = crypto_ablkcipher_ivsize(geniv);
-
-	if (vsrc != giv + ivsize && vdst != giv + ivsize) {
-		giv = PTR_ALIGN((u8 *)reqctx->tail,
-				crypto_ablkcipher_alignmask(geniv) + 1);
-		compl = eseqiv_complete;
-		data = req;
-	}
-
-	ablkcipher_request_set_callback(subreq, req->creq.base.flags, compl,
-					data);
-
-	sg_init_table(reqctx->src, 2);
-	sg_set_buf(reqctx->src, giv, ivsize);
-	scatterwalk_crypto_chain(reqctx->src, osrc, vsrc == giv + ivsize, 2);
-
-	dst = reqctx->src;
-	if (osrc != odst) {
-		sg_init_table(reqctx->dst, 2);
-		sg_set_buf(reqctx->dst, giv, ivsize);
-		scatterwalk_crypto_chain(reqctx->dst, odst, vdst == giv + ivsize, 2);
-
-		dst = reqctx->dst;
-	}
-
-	ablkcipher_request_set_crypt(subreq, reqctx->src, dst,
-				     req->creq.nbytes + ivsize,
-				     req->creq.info);
-
-	memcpy(req->creq.info, ctx->salt, ivsize);
-
-	len = ivsize;
-	if (ivsize > sizeof(u64)) {
-		memset(req->giv, 0, ivsize - sizeof(u64));
-		len = sizeof(u64);
-	}
-	seq = cpu_to_be64(req->seq);
-	memcpy(req->giv + ivsize - len, &seq, len);
-
-	err = crypto_ablkcipher_encrypt(subreq);
-	if (err)
-		goto out;
-
-	if (giv != req->giv)
-		eseqiv_complete2(req);
-
-out:
-	return err;
-}
-
-static int eseqiv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	unsigned long alignmask;
-	unsigned int reqsize;
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	alignmask = crypto_tfm_ctx_alignment() - 1;
-	reqsize = sizeof(struct eseqiv_request_ctx);
-
-	if (alignmask & reqsize) {
-		alignmask &= reqsize;
-		alignmask--;
-	}
-
-	alignmask = ~alignmask;
-	alignmask &= crypto_ablkcipher_alignmask(geniv);
-
-	reqsize += alignmask;
-	reqsize += crypto_ablkcipher_ivsize(geniv);
-	reqsize = ALIGN(reqsize, crypto_tfm_ctx_alignment());
-
-	ctx->reqoff = reqsize - sizeof(struct eseqiv_request_ctx);
-
-	tfm->crt_ablkcipher.reqsize = reqsize +
-				      sizeof(struct ablkcipher_request);
-
-	err = 0;
-	if (!crypto_get_default_rng()) {
-		crypto_ablkcipher_crt(geniv)->givencrypt = eseqiv_givencrypt;
-		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-					   crypto_ablkcipher_ivsize(geniv));
-		crypto_put_default_rng();
-	}
-
-	return err ?: skcipher_geniv_init(tfm);
-}
-
-static struct crypto_template eseqiv_tmpl;
-
-static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
-{
-	struct crypto_instance *inst;
-	int err;
-
-	inst = skcipher_geniv_alloc(&eseqiv_tmpl, tb, 0, 0);
-	if (IS_ERR(inst))
-		goto out;
-
-	err = -EINVAL;
-	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
-		goto free_inst;
-
-	inst->alg.cra_init = eseqiv_init;
-	inst->alg.cra_exit = skcipher_geniv_exit;
-
-	inst->alg.cra_ctxsize = sizeof(struct eseqiv_ctx);
-	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
-
-out:
-	return inst;
-
-free_inst:
-	skcipher_geniv_free(inst);
-	inst = ERR_PTR(err);
-	goto out;
-}
-
-static struct crypto_template eseqiv_tmpl = {
-	.name = "eseqiv",
-	.alloc = eseqiv_alloc,
-	.free = skcipher_geniv_free,
-	.module = THIS_MODULE,
-};
-
-static int __init eseqiv_module_init(void)
-{
-	return crypto_register_template(&eseqiv_tmpl);
-}
-
-static void __exit eseqiv_module_exit(void)
-{
-	crypto_unregister_template(&eseqiv_tmpl);
-}
-
-module_init(eseqiv_module_init);
-module_exit(eseqiv_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Encrypted Sequence Number IV Generator");
-MODULE_ALIAS_CRYPTO("eseqiv");
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index a859b3a..c704923 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -14,50 +14,17 @@
  */
 
 #include <crypto/internal/geniv.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/spinlock.h>
 #include <linux/string.h>
 
-struct seqiv_ctx {
-	spinlock_t lock;
-	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
-};
-
 static void seqiv_free(struct crypto_instance *inst);
 
-static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
-{
-	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
-	struct crypto_ablkcipher *geniv;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (err)
-		goto out;
-
-	geniv = skcipher_givcrypt_reqtfm(req);
-	memcpy(req->creq.info, subreq->info, crypto_ablkcipher_ivsize(geniv));
-
-out:
-	kfree(subreq->info);
-}
-
-static void seqiv_complete(struct crypto_async_request *base, int err)
-{
-	struct skcipher_givcrypt_request *req = base->data;
-
-	seqiv_complete2(req, err);
-	skcipher_givcrypt_complete(req, err);
-}
-
 static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 {
 	struct aead_request *subreq = aead_request_ctx(req);
@@ -85,65 +52,6 @@ static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
 	aead_request_complete(req, err);
 }
 
-static void seqiv_geniv(struct seqiv_ctx *ctx, u8 *info, u64 seq,
-			unsigned int ivsize)
-{
-	unsigned int len = ivsize;
-
-	if (ivsize > sizeof(u64)) {
-		memset(info, 0, ivsize - sizeof(u64));
-		len = sizeof(u64);
-	}
-	seq = cpu_to_be64(seq);
-	memcpy(info + ivsize - len, &seq, len);
-	crypto_xor(info, ctx->salt, ivsize);
-}
-
-static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
-{
-	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
-	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
-	crypto_completion_t compl;
-	void *data;
-	u8 *info;
-	unsigned int ivsize;
-	int err;
-
-	ablkcipher_request_set_tfm(subreq, skcipher_geniv_cipher(geniv));
-
-	compl = req->creq.base.complete;
-	data = req->creq.base.data;
-	info = req->creq.info;
-
-	ivsize = crypto_ablkcipher_ivsize(geniv);
-
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_ablkcipher_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->creq.base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
-
-		compl = seqiv_complete;
-		data = req;
-	}
-
-	ablkcipher_request_set_callback(subreq, req->creq.base.flags, compl,
-					data);
-	ablkcipher_request_set_crypt(subreq, req->creq.src, req->creq.dst,
-				     req->creq.nbytes, info);
-
-	seqiv_geniv(ctx, info, req->seq, ivsize);
-	memcpy(req->giv, info, ivsize);
-
-	err = crypto_ablkcipher_encrypt(subreq);
-	if (unlikely(info != req->creq.info))
-		seqiv_complete2(req, err);
-	return err;
-}
-
 static int seqiv_aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
@@ -233,62 +141,6 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	return crypto_aead_decrypt(subreq);
 }
 
-static int seqiv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
-	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ablkcipher_request);
-
-	err = 0;
-	if (!crypto_get_default_rng()) {
-		crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
-		err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
-					   crypto_ablkcipher_ivsize(geniv));
-		crypto_put_default_rng();
-	}
-
-	return err ?: skcipher_geniv_init(tfm);
-}
-
-static int seqiv_ablkcipher_create(struct crypto_template *tmpl,
-				   struct rtattr **tb)
-{
-	struct crypto_instance *inst;
-	int err;
-
-	inst = skcipher_geniv_alloc(tmpl, tb, 0, 0);
-
-	if (IS_ERR(inst))
-		return PTR_ERR(inst);
-
-	err = -EINVAL;
-	if (inst->alg.cra_ablkcipher.ivsize < sizeof(u64))
-		goto free_inst;
-
-	inst->alg.cra_init = seqiv_init;
-	inst->alg.cra_exit = skcipher_geniv_exit;
-
-	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
-	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
-
-	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
-
-	err = crypto_register_instance(tmpl, inst);
-	if (err)
-		goto free_inst;
-
-out:
-	return err;
-
-free_inst:
-	skcipher_geniv_free(inst);
-	goto out;
-}
-
 static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct aead_instance *inst;
@@ -334,26 +186,20 @@ free_inst:
 static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
-	int err;
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return PTR_ERR(algt);
 
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
-		err = seqiv_ablkcipher_create(tmpl, tb);
-	else
-		err = seqiv_aead_create(tmpl, tb);
+		return -EINVAL;
 
-	return err;
+	return seqiv_aead_create(tmpl, tb);
 }
 
 static void seqiv_free(struct crypto_instance *inst)
 {
-	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
-		skcipher_geniv_free(inst);
-	else
-		aead_geniv_free(aead_instance(inst));
+	aead_geniv_free(aead_instance(inst));
 }
 
 static struct crypto_template seqiv_tmpl = {
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index d248008..f7d0018 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -325,13 +325,13 @@ static const struct crypto_type crypto_skcipher_type2 = {
 	.tfmsize = offsetof(struct crypto_skcipher, base),
 };
 
-int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
+int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			  const char *name, u32 type, u32 mask)
 {
 	spawn->base.frontend = &crypto_skcipher_type2;
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_grab_skcipher2);
+EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 
 struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask)
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index ce6619c..a21a95e 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -67,8 +67,12 @@ static inline void crypto_set_skcipher_spawn(
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 			 u32 type, u32 mask);
-int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
-			  const char *name, u32 type, u32 mask);
+
+static inline int crypto_grab_skcipher2(struct crypto_skcipher_spawn *spawn,
+					const char *name, u32 type, u32 mask)
+{
+	return crypto_grab_skcipher(spawn, name, type, mask);
+}
 
 struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type, u32 mask);
 
@@ -77,30 +81,28 @@ static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 	crypto_drop_spawn(&spawn->base);
 }
 
-static inline struct crypto_alg *crypto_skcipher_spawn_alg(
+static inline struct skcipher_alg *crypto_skcipher_spawn_alg(
 	struct crypto_skcipher_spawn *spawn)
 {
-	return spawn->base.alg;
+	return container_of(spawn->base.alg, struct skcipher_alg, base);
 }
 
 static inline struct skcipher_alg *crypto_spawn_skcipher_alg(
 	struct crypto_skcipher_spawn *spawn)
 {
-	return container_of(spawn->base.alg, struct skcipher_alg, base);
+	return crypto_skcipher_spawn_alg(spawn);
 }
 
-static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
+static inline struct crypto_skcipher *crypto_spawn_skcipher(
 	struct crypto_skcipher_spawn *spawn)
 {
-	return __crypto_ablkcipher_cast(
-		crypto_spawn_tfm(&spawn->base, crypto_skcipher_type(0),
-				 crypto_skcipher_mask(0)));
+	return crypto_spawn_tfm2(&spawn->base);
 }
 
 static inline struct crypto_skcipher *crypto_spawn_skcipher2(
 	struct crypto_skcipher_spawn *spawn)
 {
-	return crypto_spawn_tfm2(&spawn->base);
+	return crypto_spawn_skcipher(spawn);
 }
 
 static inline void crypto_skcipher_set_reqsize(
@@ -116,53 +118,12 @@ void crypto_unregister_skciphers(struct skcipher_alg *algs, int count);
 int skcipher_register_instance(struct crypto_template *tmpl,
 			       struct skcipher_instance *inst);
 
-int skcipher_null_givencrypt(struct skcipher_givcrypt_request *req);
-int skcipher_null_givdecrypt(struct skcipher_givcrypt_request *req);
-const char *crypto_default_geniv(const struct crypto_alg *alg);
-
-struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
-					     struct rtattr **tb, u32 type,
-					     u32 mask);
-void skcipher_geniv_free(struct crypto_instance *inst);
-int skcipher_geniv_init(struct crypto_tfm *tfm);
-void skcipher_geniv_exit(struct crypto_tfm *tfm);
-
-static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
-	struct crypto_ablkcipher *geniv)
-{
-	return crypto_ablkcipher_crt(geniv)->base;
-}
-
-static inline int skcipher_enqueue_givcrypt(
-	struct crypto_queue *queue, struct skcipher_givcrypt_request *request)
-{
-	return ablkcipher_enqueue_request(queue, &request->creq);
-}
-
-static inline struct skcipher_givcrypt_request *skcipher_dequeue_givcrypt(
-	struct crypto_queue *queue)
-{
-	return skcipher_givcrypt_cast(crypto_dequeue_request(queue));
-}
-
-static inline void *skcipher_givcrypt_reqctx(
-	struct skcipher_givcrypt_request *req)
-{
-	return ablkcipher_request_ctx(&req->creq);
-}
-
 static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
 					       int err)
 {
 	req->base.complete(&req->base, err);
 }
 
-static inline void skcipher_givcrypt_complete(
-	struct skcipher_givcrypt_request *req, int err)
-{
-	ablkcipher_request_complete(&req->creq, err);
-}
-
 static inline u32 ablkcipher_request_flags(struct ablkcipher_request *req)
 {
 	return req->base.flags;
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index a381f57..59c8f6c 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -139,82 +139,6 @@ struct skcipher_alg {
 		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
 	struct skcipher_request *name = (void *)__##name##_desc
 
-static inline struct crypto_ablkcipher *skcipher_givcrypt_reqtfm(
-	struct skcipher_givcrypt_request *req)
-{
-	return crypto_ablkcipher_reqtfm(&req->creq);
-}
-
-static inline int crypto_skcipher_givencrypt(
-	struct skcipher_givcrypt_request *req)
-{
-	struct ablkcipher_tfm *crt =
-		crypto_ablkcipher_crt(skcipher_givcrypt_reqtfm(req));
-	return crt->givencrypt(req);
-};
-
-static inline int crypto_skcipher_givdecrypt(
-	struct skcipher_givcrypt_request *req)
-{
-	struct ablkcipher_tfm *crt =
-		crypto_ablkcipher_crt(skcipher_givcrypt_reqtfm(req));
-	return crt->givdecrypt(req);
-};
-
-static inline void skcipher_givcrypt_set_tfm(
-	struct skcipher_givcrypt_request *req, struct crypto_ablkcipher *tfm)
-{
-	req->creq.base.tfm = crypto_ablkcipher_tfm(tfm);
-}
-
-static inline struct skcipher_givcrypt_request *skcipher_givcrypt_cast(
-	struct crypto_async_request *req)
-{
-	return container_of(ablkcipher_request_cast(req),
-			    struct skcipher_givcrypt_request, creq);
-}
-
-static inline struct skcipher_givcrypt_request *skcipher_givcrypt_alloc(
-	struct crypto_ablkcipher *tfm, gfp_t gfp)
-{
-	struct skcipher_givcrypt_request *req;
-
-	req = kmalloc(sizeof(struct skcipher_givcrypt_request) +
-		      crypto_ablkcipher_reqsize(tfm), gfp);
-
-	if (likely(req))
-		skcipher_givcrypt_set_tfm(req, tfm);
-
-	return req;
-}
-
-static inline void skcipher_givcrypt_free(struct skcipher_givcrypt_request *req)
-{
-	kfree(req);
-}
-
-static inline void skcipher_givcrypt_set_callback(
-	struct skcipher_givcrypt_request *req, u32 flags,
-	crypto_completion_t compl, void *data)
-{
-	ablkcipher_request_set_callback(&req->creq, flags, compl, data);
-}
-
-static inline void skcipher_givcrypt_set_crypt(
-	struct skcipher_givcrypt_request *req,
-	struct scatterlist *src, struct scatterlist *dst,
-	unsigned int nbytes, void *iv)
-{
-	ablkcipher_request_set_crypt(&req->creq, src, dst, nbytes, iv);
-}
-
-static inline void skcipher_givcrypt_set_giv(
-	struct skcipher_givcrypt_request *req, u8 *giv, u64 seq)
-{
-	req->giv = giv;
-	req->seq = seq;
-}
-
 /**
  * DOC: Symmetric Key Cipher API
  *
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 37a652d..7cee555 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -488,8 +488,6 @@ struct ablkcipher_tfm {
 	              unsigned int keylen);
 	int (*encrypt)(struct ablkcipher_request *req);
 	int (*decrypt)(struct ablkcipher_request *req);
-	int (*givencrypt)(struct skcipher_givcrypt_request *req);
-	int (*givdecrypt)(struct skcipher_givcrypt_request *req);
 
 	struct crypto_ablkcipher *base;
 
@@ -714,23 +712,6 @@ static inline u32 crypto_skcipher_mask(u32 mask)
  * state information is unused by the kernel crypto API.
  */
 
-/**
- * crypto_alloc_ablkcipher() - allocate asynchronous block cipher handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      ablkcipher cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for an ablkcipher. The returned struct
- * crypto_ablkcipher is the cipher handle that is required for any subsequent
- * API invocation for that ablkcipher.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask);
-
 static inline struct crypto_tfm *crypto_ablkcipher_tfm(
 	struct crypto_ablkcipher *tfm)
 {
