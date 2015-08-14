From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 12/13] crypto: aead - Remove old AEAD interfaces
Date: Fri, 14 Aug 2015 15:30:41 +0800
Message-ID: <20150814073041.GA3147@gondor.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
 <E1ZPoor-0005rY-IR@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38738 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbbHNHap (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 03:30:45 -0400
Content-Disposition: inline
In-Reply-To: <E1ZPoor-0005rY-IR@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 05:29:05PM +0800, Herbert Xu wrote:
> Now that the AEAD conversion is complete we can rip out the old
> AEAD interafce and associated code.

Missed some more legacy stuff in linux/crypto.h.  This update
adds them to the patch.

---8<---
Now that the AEAD conversion is complete we can rip out the old
AEAD interafce and associated code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                   |  606 ----------------------------------------
 include/crypto/aead.h           |  148 ---------
 include/crypto/internal/aead.h  |   42 --
 include/crypto/internal/geniv.h |    2 
 include/linux/crypto.h          |   48 ---
 5 files changed, 28 insertions(+), 818 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index a4dcd19..c40df2c 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -3,7 +3,7 @@
  *
  * This file provides API support for AEAD algorithms.
  *
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2007-2015 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/cryptouser.h>
@@ -29,17 +28,6 @@
 
 #include "internal.h"
 
-struct compat_request_ctx {
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
-	struct scatterlist ivbuf[2];
-	struct scatterlist *ivsg;
-	struct aead_givcrypt_request subreq;
-};
-
-static int aead_null_givencrypt(struct aead_givcrypt_request *req);
-static int aead_null_givdecrypt(struct aead_givcrypt_request *req);
-
 static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -55,7 +43,7 @@ static int setkey_unaligned(struct crypto_aead *tfm, const u8 *key,
 
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
-	ret = tfm->setkey(tfm, alignbuffer, keylen);
+	ret = crypto_aead_alg(tfm)->setkey(tfm, alignbuffer, keylen);
 	memset(alignbuffer, 0, keylen);
 	kfree(buffer);
 	return ret;
@@ -66,12 +54,10 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
 {
 	unsigned long alignmask = crypto_aead_alignmask(tfm);
 
-	tfm = tfm->child;
-
 	if ((unsigned long)key & alignmask)
 		return setkey_unaligned(tfm, key, keylen);
 
-	return tfm->setkey(tfm, key, keylen);
+	return crypto_aead_alg(tfm)->setkey(tfm, key, keylen);
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setkey);
 
@@ -82,100 +68,17 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 	if (authsize > crypto_aead_maxauthsize(tfm))
 		return -EINVAL;
 
-	if (tfm->setauthsize) {
-		err = tfm->setauthsize(tfm->child, authsize);
+	if (crypto_aead_alg(tfm)->setauthsize) {
+		err = crypto_aead_alg(tfm)->setauthsize(tfm, authsize);
 		if (err)
 			return err;
 	}
 
-	tfm->child->authsize = authsize;
 	tfm->authsize = authsize;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
-struct aead_old_request {
-	struct scatterlist srcbuf[2];
-	struct scatterlist dstbuf[2];
-	struct aead_request subreq;
-};
-
-unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
-{
-	return tfm->reqsize + sizeof(struct aead_old_request);
-}
-EXPORT_SYMBOL_GPL(crypto_aead_reqsize);
-
-static int old_crypt(struct aead_request *req,
-		     int (*crypt)(struct aead_request *req))
-{
-	struct aead_old_request *nreq = aead_request_ctx(req);
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct scatterlist *src, *dst;
-
-	if (req->old)
-		return crypt(req);
-
-	src = scatterwalk_ffwd(nreq->srcbuf, req->src, req->assoclen);
-	dst = req->src == req->dst ?
-	      src : scatterwalk_ffwd(nreq->dstbuf, req->dst, req->assoclen);
-
-	aead_request_set_tfm(&nreq->subreq, aead);
-	aead_request_set_callback(&nreq->subreq, aead_request_flags(req),
-				  req->base.complete, req->base.data);
-	aead_request_set_crypt(&nreq->subreq, src, dst, req->cryptlen,
-			       req->iv);
-	aead_request_set_assoc(&nreq->subreq, req->src, req->assoclen);
-
-	return crypt(&nreq->subreq);
-}
-
-static int old_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct old_aead_alg *alg = crypto_old_aead_alg(aead);
-
-	return old_crypt(req, alg->encrypt);
-}
-
-static int old_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct old_aead_alg *alg = crypto_old_aead_alg(aead);
-
-	return old_crypt(req, alg->decrypt);
-}
-
-static int no_givcrypt(struct aead_givcrypt_request *req)
-{
-	return -ENOSYS;
-}
-
-static int crypto_old_aead_init_tfm(struct crypto_tfm *tfm)
-{
-	struct old_aead_alg *alg = &tfm->__crt_alg->cra_aead;
-	struct crypto_aead *crt = __crypto_aead_cast(tfm);
-
-	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	crt->setkey = alg->setkey;
-	crt->setauthsize = alg->setauthsize;
-	crt->encrypt = old_encrypt;
-	crt->decrypt = old_decrypt;
-	if (alg->ivsize) {
-		crt->givencrypt = alg->givencrypt ?: no_givcrypt;
-		crt->givdecrypt = alg->givdecrypt ?: no_givcrypt;
-	} else {
-		crt->givencrypt = aead_null_givencrypt;
-		crt->givdecrypt = aead_null_givdecrypt;
-	}
-	crt->child = __crypto_aead_cast(tfm);
-	crt->authsize = alg->maxauthsize;
-
-	return 0;
-}
-
 static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
@@ -189,14 +92,6 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	if (crypto_old_aead_alg(aead)->encrypt)
-		return crypto_old_aead_init_tfm(tfm);
-
-	aead->setkey = alg->setkey;
-	aead->setauthsize = alg->setauthsize;
-	aead->encrypt = alg->encrypt;
-	aead->decrypt = alg->decrypt;
-	aead->child = __crypto_aead_cast(tfm);
 	aead->authsize = alg->maxauthsize;
 
 	if (alg->exit)
@@ -209,64 +104,6 @@ static int crypto_aead_init_tfm(struct crypto_tfm *tfm)
 }
 
 #ifdef CONFIG_NET
-static int crypto_old_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_aead raead;
-	struct old_aead_alg *aead = &alg->cra_aead;
-
-	strncpy(raead.type, "aead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv ?: "<built-in>", sizeof(raead.geniv));
-
-	raead.blocksize = alg->cra_blocksize;
-	raead.maxauthsize = aead->maxauthsize;
-	raead.ivsize = aead->ivsize;
-
-	if (nla_put(skb, CRYPTOCFGA_REPORT_AEAD,
-		    sizeof(struct crypto_report_aead), &raead))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-#else
-static int crypto_old_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-static void crypto_old_aead_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
-static void crypto_old_aead_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	struct old_aead_alg *aead = &alg->cra_aead;
-
-	seq_printf(m, "type         : aead\n");
-	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
-					     "yes" : "no");
-	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
-	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
-	seq_printf(m, "geniv        : %s\n", aead->geniv ?: "<built-in>");
-}
-
-const struct crypto_type crypto_aead_type = {
-	.extsize = crypto_alg_extsize,
-	.init_tfm = crypto_aead_init_tfm,
-#ifdef CONFIG_PROC_FS
-	.show = crypto_old_aead_show,
-#endif
-	.report = crypto_old_aead_report,
-	.lookup = crypto_lookup_aead,
-	.maskclear = ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV),
-	.maskset = CRYPTO_ALG_TYPE_MASK,
-	.type = CRYPTO_ALG_TYPE_AEAD,
-	.tfmsize = offsetof(struct crypto_aead, base),
-};
-EXPORT_SYMBOL_GPL(crypto_aead_type);
-
-#ifdef CONFIG_NET
 static int crypto_aead_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_aead raead;
@@ -321,7 +158,7 @@ static void crypto_aead_free_instance(struct crypto_instance *inst)
 	aead->free(aead);
 }
 
-static const struct crypto_type crypto_new_aead_type = {
+static const struct crypto_type crypto_aead_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_aead_init_tfm,
 	.free = crypto_aead_free_instance,
@@ -335,81 +172,6 @@ static const struct crypto_type crypto_new_aead_type = {
 	.tfmsize = offsetof(struct crypto_aead, base),
 };
 
-static int aead_null_givencrypt(struct aead_givcrypt_request *req)
-{
-	return crypto_aead_encrypt(&req->areq);
-}
-
-static int aead_null_givdecrypt(struct aead_givcrypt_request *req)
-{
-	return crypto_aead_decrypt(&req->areq);
-}
-
-#ifdef CONFIG_NET
-static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_aead raead;
-	struct old_aead_alg *aead = &alg->cra_aead;
-
-	strncpy(raead.type, "nivaead", sizeof(raead.type));
-	strncpy(raead.geniv, aead->geniv, sizeof(raead.geniv));
-
-	raead.blocksize = alg->cra_blocksize;
-	raead.maxauthsize = aead->maxauthsize;
-	raead.ivsize = aead->ivsize;
-
-	if (nla_put(skb, CRYPTOCFGA_REPORT_AEAD,
-		    sizeof(struct crypto_report_aead), &raead))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-#else
-static int crypto_nivaead_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-
-static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
-static void crypto_nivaead_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	struct old_aead_alg *aead = &alg->cra_aead;
-
-	seq_printf(m, "type         : nivaead\n");
-	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
-					     "yes" : "no");
-	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
-	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
-	seq_printf(m, "geniv        : %s\n", aead->geniv);
-}
-
-const struct crypto_type crypto_nivaead_type = {
-	.extsize = crypto_alg_extsize,
-	.init_tfm = crypto_aead_init_tfm,
-#ifdef CONFIG_PROC_FS
-	.show = crypto_nivaead_show,
-#endif
-	.report = crypto_nivaead_report,
-	.maskclear = ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV),
-	.maskset = CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV,
-	.type = CRYPTO_ALG_TYPE_AEAD,
-	.tfmsize = offsetof(struct crypto_aead, base),
-};
-EXPORT_SYMBOL_GPL(crypto_nivaead_type);
-
-static int crypto_grab_nivaead(struct crypto_aead_spawn *spawn,
-			       const char *name, u32 type, u32 mask)
-{
-	spawn->base.frontend = &crypto_nivaead_type;
-	return crypto_grab_spawn(&spawn->base, name, type, mask);
-}
-
 static int aead_geniv_setkey(struct crypto_aead *tfm,
 			     const u8 *key, unsigned int keylen)
 {
@@ -426,169 +188,6 @@ static int aead_geniv_setauthsize(struct crypto_aead *tfm,
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
 
-static void compat_encrypt_complete2(struct aead_request *req, int err)
-{
-	struct compat_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_givcrypt_request *subreq = &rctx->subreq;
-	struct crypto_aead *geniv;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	if (err)
-		goto out;
-
-	geniv = crypto_aead_reqtfm(req);
-	scatterwalk_map_and_copy(subreq->giv, rctx->ivsg, 0,
-				 crypto_aead_ivsize(geniv), 1);
-
-out:
-	kzfree(subreq->giv);
-}
-
-static void compat_encrypt_complete(struct crypto_async_request *base, int err)
-{
-	struct aead_request *req = base->data;
-
-	compat_encrypt_complete2(req, err);
-	aead_request_complete(req, err);
-}
-
-static int compat_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct compat_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_givcrypt_request *subreq = &rctx->subreq;
-	unsigned int ivsize = crypto_aead_ivsize(geniv);
-	struct scatterlist *src, *dst;
-	crypto_completion_t compl;
-	void *data;
-	u8 *info;
-	__be64 seq;
-	int err;
-
-	if (req->cryptlen < ivsize)
-		return -EINVAL;
-
-	compl = req->base.complete;
-	data = req->base.data;
-
-	rctx->ivsg = scatterwalk_ffwd(rctx->ivbuf, req->dst, req->assoclen);
-	info = PageHighMem(sg_page(rctx->ivsg)) ? NULL : sg_virt(rctx->ivsg);
-
-	if (!info) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
-
-		compl = compat_encrypt_complete;
-		data = req;
-	}
-
-	memcpy(&seq, req->iv + ivsize - sizeof(seq), sizeof(seq));
-
-	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen + ivsize);
-	dst = req->src == req->dst ?
-	      src : scatterwalk_ffwd(rctx->dst, rctx->ivsg, ivsize);
-
-	aead_givcrypt_set_tfm(subreq, ctx->child);
-	aead_givcrypt_set_callback(subreq, req->base.flags,
-				   req->base.complete, req->base.data);
-	aead_givcrypt_set_crypt(subreq, src, dst,
-				req->cryptlen - ivsize, req->iv);
-	aead_givcrypt_set_assoc(subreq, req->src, req->assoclen);
-	aead_givcrypt_set_giv(subreq, info, be64_to_cpu(seq));
-
-	err = crypto_aead_givencrypt(subreq);
-	if (unlikely(PageHighMem(sg_page(rctx->ivsg))))
-		compat_encrypt_complete2(req, err);
-	return err;
-}
-
-static int compat_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
-	struct compat_request_ctx *rctx = aead_request_ctx(req);
-	struct aead_request *subreq = &rctx->subreq.areq;
-	unsigned int ivsize = crypto_aead_ivsize(geniv);
-	struct scatterlist *src, *dst;
-	crypto_completion_t compl;
-	void *data;
-
-	if (req->cryptlen < ivsize)
-		return -EINVAL;
-
-	aead_request_set_tfm(subreq, ctx->child);
-
-	compl = req->base.complete;
-	data = req->base.data;
-
-	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen + ivsize);
-	dst = req->src == req->dst ?
-	      src : scatterwalk_ffwd(rctx->dst, req->dst,
-				     req->assoclen + ivsize);
-
-	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, src, dst,
-			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_assoc(subreq, req->src, req->assoclen);
-
-	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
-
-	return crypto_aead_decrypt(subreq);
-}
-
-static int compat_encrypt_first(struct aead_request *req)
-{
-	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err = 0;
-
-	spin_lock_bh(&ctx->lock);
-	if (geniv->encrypt != compat_encrypt_first)
-		goto unlock;
-
-	geniv->encrypt = compat_encrypt;
-
-unlock:
-	spin_unlock_bh(&ctx->lock);
-
-	if (err)
-		return err;
-
-	return compat_encrypt(req);
-}
-
-static int aead_geniv_init_compat(struct crypto_tfm *tfm)
-{
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	crypto_aead_set_reqsize(geniv, sizeof(struct compat_request_ctx));
-
-	err = aead_geniv_init(tfm);
-
-	ctx->child = geniv->child;
-	geniv->child = geniv;
-
-	return err;
-}
-
-static void aead_geniv_exit_compat(struct crypto_tfm *tfm)
-{
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
-	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
-
-	crypto_free_aead(ctx->child);
-}
-
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask)
 {
@@ -605,7 +204,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	if (IS_ERR(algt))
 		return ERR_CAST(algt);
 
-	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV)) &
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) &
 	    algt->mask & ~CRYPTO_ALG_AEAD_NEW)
 		return ERR_PTR(-EINVAL);
 
@@ -623,9 +222,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	mask |= crypto_requires_sync(algt->type, algt->mask);
 
 	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = (algt->mask & CRYPTO_ALG_GENIV) ?
-	      crypto_grab_nivaead(spawn, name, type, mask) :
-	      crypto_grab_aead(spawn, name, type, mask);
+	err = crypto_grab_aead(spawn, name, type, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -638,43 +235,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	if (ivsize < sizeof(u64))
 		goto err_drop_alg;
 
-	/*
-	 * This is only true if we're constructing an algorithm with its
-	 * default IV generator.  For the default generator we elide the
-	 * template name and double-check the IV generator.
-	 */
-	if (algt->mask & CRYPTO_ALG_GENIV) {
-		if (!alg->base.cra_aead.encrypt)
-			goto err_drop_alg;
-		if (strcmp(tmpl->name, alg->base.cra_aead.geniv))
-			goto err_drop_alg;
-
-		memcpy(inst->alg.base.cra_name, alg->base.cra_name,
-		       CRYPTO_MAX_ALG_NAME);
-		memcpy(inst->alg.base.cra_driver_name,
-		       alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME);
-
-		inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					   CRYPTO_ALG_GENIV;
-		inst->alg.base.cra_flags |= alg->base.cra_flags &
-					    CRYPTO_ALG_ASYNC;
-		inst->alg.base.cra_priority = alg->base.cra_priority;
-		inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
-		inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
-		inst->alg.base.cra_type = &crypto_aead_type;
-
-		inst->alg.base.cra_aead.ivsize = ivsize;
-		inst->alg.base.cra_aead.maxauthsize = maxauthsize;
-
-		inst->alg.base.cra_aead.setkey = alg->base.cra_aead.setkey;
-		inst->alg.base.cra_aead.setauthsize =
-			alg->base.cra_aead.setauthsize;
-		inst->alg.base.cra_aead.encrypt = alg->base.cra_aead.encrypt;
-		inst->alg.base.cra_aead.decrypt = alg->base.cra_aead.decrypt;
-
-		goto out;
-	}
-
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "%s(%s)", tmpl->name, alg->base.cra_name) >=
@@ -698,12 +258,6 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	inst->alg.ivsize = ivsize;
 	inst->alg.maxauthsize = maxauthsize;
 
-	inst->alg.encrypt = compat_encrypt_first;
-	inst->alg.decrypt = compat_decrypt;
-
-	inst->alg.base.cra_init = aead_geniv_init_compat;
-	inst->alg.base.cra_exit = aead_geniv_exit_compat;
-
 out:
 	return inst;
 
@@ -723,31 +277,6 @@ void aead_geniv_free(struct aead_instance *inst)
 }
 EXPORT_SYMBOL_GPL(aead_geniv_free);
 
-int aead_geniv_init(struct crypto_tfm *tfm)
-{
-	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_aead *child;
-	struct crypto_aead *aead;
-
-	aead = __crypto_aead_cast(tfm);
-
-	child = crypto_spawn_aead(crypto_instance_ctx(inst));
-	if (IS_ERR(child))
-		return PTR_ERR(child);
-
-	aead->child = child;
-	aead->reqsize += crypto_aead_reqsize(child);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(aead_geniv_init);
-
-void aead_geniv_exit(struct crypto_tfm *tfm)
-{
-	crypto_free_aead(__crypto_aead_cast(tfm)->child);
-}
-EXPORT_SYMBOL_GPL(aead_geniv_exit);
-
 int aead_init_geniv(struct crypto_aead *aead)
 {
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
@@ -801,123 +330,6 @@ void aead_exit_geniv(struct crypto_aead *tfm)
 }
 EXPORT_SYMBOL_GPL(aead_exit_geniv);
 
-static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
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
-				      CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV,
-				      CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_GENIV);
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
-	geniv = alg->cra_aead.geniv;
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
-struct crypto_alg *crypto_lookup_aead(const char *name, u32 type, u32 mask)
-{
-	struct crypto_alg *alg;
-
-	alg = crypto_alg_mod_lookup(name, type, mask);
-	if (IS_ERR(alg))
-		return alg;
-
-	if (alg->cra_type == &crypto_aead_type)
-		return alg;
-
-	if (!alg->cra_aead.ivsize)
-		return alg;
-
-	crypto_mod_put(alg);
-	alg = crypto_alg_mod_lookup(name, type | CRYPTO_ALG_TESTED,
-				    mask & ~CRYPTO_ALG_TESTED);
-	if (IS_ERR(alg))
-		return alg;
-
-	if (alg->cra_type == &crypto_aead_type) {
-		if (~alg->cra_flags & (type ^ ~mask) & CRYPTO_ALG_TESTED) {
-			crypto_mod_put(alg);
-			alg = ERR_PTR(-ENOENT);
-		}
-		return alg;
-	}
-
-	BUG_ON(!alg->cra_aead.ivsize);
-
-	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
-}
-EXPORT_SYMBOL_GPL(crypto_lookup_aead);
-
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask)
 {
@@ -939,7 +351,7 @@ static int aead_prepare_alg(struct aead_alg *alg)
 	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	base->cra_type = &crypto_new_aead_type;
+	base->cra_type = &crypto_aead_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
 
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 14e35364..077cae1 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -1,7 +1,7 @@
 /*
  * AEAD: Authenticated Encryption with Associated Data
  * 
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2007-2015 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -71,14 +71,14 @@
  * in the first scatter gather list entry pointing to a NULL buffer.
  */
 
+struct crypto_aead;
+
 /**
  *	struct aead_request - AEAD request
  *	@base: Common attributes for async crypto requests
- *	@old: Boolean whether the old or new AEAD API is used
  *	@assoclen: Length in bytes of associated data for authentication
  *	@cryptlen: Length of data to be encrypted or decrypted
  *	@iv: Initialisation vector
- *	@assoc: Associated data
  *	@src: Source data
  *	@dst: Destination data
  *	@__ctx: Start of private context data
@@ -86,14 +86,11 @@
 struct aead_request {
 	struct crypto_async_request base;
 
-	bool old;
-
 	unsigned int assoclen;
 	unsigned int cryptlen;
 
 	u8 *iv;
 
-	struct scatterlist *assoc;
 	struct scatterlist *src;
 	struct scatterlist *dst;
 
@@ -101,19 +98,6 @@ struct aead_request {
 };
 
 /**
- *	struct aead_givcrypt_request - AEAD request with IV generation
- *	@seq: Sequence number for IV generation
- *	@giv: Space for generated IV
- *	@areq: The AEAD request itself
- */
-struct aead_givcrypt_request {
-	u64 seq;
-	u8 *giv;
-
-	struct aead_request areq;
-};
-
-/**
  * struct aead_alg - AEAD cipher definition
  * @maxauthsize: Set the maximum authentication tag size supported by the
  *		 transformation. A transformation may support smaller tag sizes.
@@ -165,16 +149,6 @@ struct aead_alg {
 };
 
 struct crypto_aead {
-	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
-	              unsigned int keylen);
-	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
-	int (*encrypt)(struct aead_request *req);
-	int (*decrypt)(struct aead_request *req);
-	int (*givencrypt)(struct aead_givcrypt_request *req);
-	int (*givdecrypt)(struct aead_givcrypt_request *req);
-
-	struct crypto_aead *child;
-
 	unsigned int authsize;
 	unsigned int reqsize;
 
@@ -216,16 +190,6 @@ static inline void crypto_free_aead(struct crypto_aead *tfm)
 	crypto_destroy_tfm(tfm, crypto_aead_tfm(tfm));
 }
 
-static inline struct crypto_aead *crypto_aead_crt(struct crypto_aead *tfm)
-{
-	return tfm;
-}
-
-static inline struct old_aead_alg *crypto_old_aead_alg(struct crypto_aead *tfm)
-{
-	return &crypto_aead_tfm(tfm)->__crt_alg->cra_aead;
-}
-
 static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
 {
 	return container_of(crypto_aead_tfm(tfm)->__crt_alg,
@@ -234,8 +198,7 @@ static inline struct aead_alg *crypto_aead_alg(struct crypto_aead *tfm)
 
 static inline unsigned int crypto_aead_alg_ivsize(struct aead_alg *alg)
 {
-	return alg->base.cra_aead.encrypt ? alg->base.cra_aead.ivsize :
-					    alg->ivsize;
+	return alg->ivsize;
 }
 
 /**
@@ -361,7 +324,7 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
  */
 static inline int crypto_aead_encrypt(struct aead_request *req)
 {
-	return crypto_aead_reqtfm(req)->encrypt(req);
+	return crypto_aead_alg(crypto_aead_reqtfm(req))->encrypt(req);
 }
 
 /**
@@ -388,10 +351,12 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
  */
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
-	if (req->cryptlen < crypto_aead_authsize(crypto_aead_reqtfm(req)))
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+
+	if (req->cryptlen < crypto_aead_authsize(aead))
 		return -EINVAL;
 
-	return crypto_aead_reqtfm(req)->decrypt(req);
+	return crypto_aead_alg(aead)->decrypt(req);
 }
 
 /**
@@ -411,7 +376,10 @@ static inline int crypto_aead_decrypt(struct aead_request *req)
  *
  * Return: number of bytes
  */
-unsigned int crypto_aead_reqsize(struct crypto_aead *tfm);
+static inline unsigned int crypto_aead_reqsize(struct crypto_aead *tfm)
+{
+	return tfm->reqsize;
+}
 
 /**
  * aead_request_set_tfm() - update cipher handle reference in request
@@ -424,7 +392,7 @@ unsigned int crypto_aead_reqsize(struct crypto_aead *tfm);
 static inline void aead_request_set_tfm(struct aead_request *req,
 					struct crypto_aead *tfm)
 {
-	req->base.tfm = crypto_aead_tfm(tfm->child);
+	req->base.tfm = crypto_aead_tfm(tfm);
 }
 
 /**
@@ -550,23 +518,6 @@ static inline void aead_request_set_crypt(struct aead_request *req,
 }
 
 /**
- * aead_request_set_assoc() - set the associated data scatter / gather list
- * @req: request handle
- * @assoc: associated data scatter / gather list
- * @assoclen: number of bytes to process from @assoc
- *
- * Obsolete, do not use.
- */
-static inline void aead_request_set_assoc(struct aead_request *req,
-					  struct scatterlist *assoc,
-					  unsigned int assoclen)
-{
-	req->assoc = assoc;
-	req->assoclen = assoclen;
-	req->old = true;
-}
-
-/**
  * aead_request_set_ad - set associated data information
  * @req: request handle
  * @assoclen: number of bytes in associated data
@@ -578,77 +529,6 @@ static inline void aead_request_set_ad(struct aead_request *req,
 				       unsigned int assoclen)
 {
 	req->assoclen = assoclen;
-	req->old = false;
-}
-
-static inline struct crypto_aead *aead_givcrypt_reqtfm(
-	struct aead_givcrypt_request *req)
-{
-	return crypto_aead_reqtfm(&req->areq);
-}
-
-static inline int crypto_aead_givencrypt(struct aead_givcrypt_request *req)
-{
-	return aead_givcrypt_reqtfm(req)->givencrypt(req);
-};
-
-static inline int crypto_aead_givdecrypt(struct aead_givcrypt_request *req)
-{
-	return aead_givcrypt_reqtfm(req)->givdecrypt(req);
-};
-
-static inline void aead_givcrypt_set_tfm(struct aead_givcrypt_request *req,
-					 struct crypto_aead *tfm)
-{
-	req->areq.base.tfm = crypto_aead_tfm(tfm);
-}
-
-static inline struct aead_givcrypt_request *aead_givcrypt_alloc(
-	struct crypto_aead *tfm, gfp_t gfp)
-{
-	struct aead_givcrypt_request *req;
-
-	req = kmalloc(sizeof(struct aead_givcrypt_request) +
-		      crypto_aead_reqsize(tfm), gfp);
-
-	if (likely(req))
-		aead_givcrypt_set_tfm(req, tfm);
-
-	return req;
-}
-
-static inline void aead_givcrypt_free(struct aead_givcrypt_request *req)
-{
-	kfree(req);
-}
-
-static inline void aead_givcrypt_set_callback(
-	struct aead_givcrypt_request *req, u32 flags,
-	crypto_completion_t compl, void *data)
-{
-	aead_request_set_callback(&req->areq, flags, compl, data);
-}
-
-static inline void aead_givcrypt_set_crypt(struct aead_givcrypt_request *req,
-					   struct scatterlist *src,
-					   struct scatterlist *dst,
-					   unsigned int nbytes, void *iv)
-{
-	aead_request_set_crypt(&req->areq, src, dst, nbytes, iv);
-}
-
-static inline void aead_givcrypt_set_assoc(struct aead_givcrypt_request *req,
-					   struct scatterlist *assoc,
-					   unsigned int assoclen)
-{
-	aead_request_set_assoc(&req->areq, assoc, assoclen);
-}
-
-static inline void aead_givcrypt_set_giv(struct aead_givcrypt_request *req,
-					 u8 *giv, u64 seq)
-{
-	req->giv = giv;
-	req->seq = seq;
 }
 
 #endif	/* _CRYPTO_AEAD_H */
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 49f3179..5554cdd 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -1,7 +1,7 @@
 /*
  * AEAD: Authenticated Encryption with Associated Data
  * 
- * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ * Copyright (c) 2007-2015 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -39,20 +39,11 @@ struct aead_queue {
 	struct crypto_queue base;
 };
 
-extern const struct crypto_type crypto_aead_type;
-extern const struct crypto_type crypto_nivaead_type;
-
 static inline void *crypto_aead_ctx(struct crypto_aead *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
 }
 
-static inline struct crypto_instance *crypto_aead_alg_instance(
-	struct crypto_aead *aead)
-{
-	return crypto_tfm_alg_instance(&aead->base);
-}
-
 static inline struct crypto_instance *aead_crypto_instance(
 	struct aead_instance *inst)
 {
@@ -66,7 +57,7 @@ static inline struct aead_instance *aead_instance(struct crypto_instance *inst)
 
 static inline struct aead_instance *aead_alg_instance(struct crypto_aead *aead)
 {
-	return aead_instance(crypto_aead_alg_instance(aead));
+	return aead_instance(crypto_tfm_alg_instance(&aead->base));
 }
 
 static inline void *aead_instance_ctx(struct aead_instance *inst)
@@ -95,8 +86,6 @@ static inline void crypto_set_aead_spawn(
 	crypto_set_spawn(&spawn->base, inst);
 }
 
-struct crypto_alg *crypto_lookup_aead(const char *name, u32 type, u32 mask);
-
 int crypto_grab_aead(struct crypto_aead_spawn *spawn, const char *name,
 		     u32 type, u32 mask);
 
@@ -105,12 +94,6 @@ static inline void crypto_drop_aead(struct crypto_aead_spawn *spawn)
 	crypto_drop_spawn(&spawn->base);
 }
 
-static inline struct crypto_alg *crypto_aead_spawn_alg(
-	struct crypto_aead_spawn *spawn)
-{
-	return spawn->base.alg;
-}
-
 static inline struct aead_alg *crypto_spawn_aead_alg(
 	struct crypto_aead_spawn *spawn)
 {
@@ -123,32 +106,15 @@ static inline struct crypto_aead *crypto_spawn_aead(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-static inline struct crypto_aead *aead_geniv_base(struct crypto_aead *geniv)
-{
-	return geniv->child;
-}
-
-static inline void *aead_givcrypt_reqctx(struct aead_givcrypt_request *req)
-{
-	return aead_request_ctx(&req->areq);
-}
-
-static inline void aead_givcrypt_complete(struct aead_givcrypt_request *req,
-					  int err)
-{
-	aead_request_complete(&req->areq, err);
-}
-
 static inline void crypto_aead_set_reqsize(struct crypto_aead *aead,
 					   unsigned int reqsize)
 {
-	crypto_aead_crt(aead)->reqsize = reqsize;
+	aead->reqsize = reqsize;
 }
 
 static inline unsigned int crypto_aead_alg_maxauthsize(struct aead_alg *alg)
 {
-	return alg->base.cra_aead.encrypt ? alg->base.cra_aead.maxauthsize :
-					    alg->maxauthsize;
+	return alg->maxauthsize;
 }
 
 static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index b9c55be..5933363 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -27,8 +27,6 @@ struct aead_geniv_ctx {
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask);
 void aead_geniv_free(struct aead_instance *inst);
-int aead_geniv_init(struct crypto_tfm *tfm);
-void aead_geniv_exit(struct crypto_tfm *tfm);
 int aead_init_geniv(struct crypto_aead *tfm);
 void aead_exit_geniv(struct crypto_aead *tfm);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 81ef938..7f4aee9 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -142,13 +142,10 @@
 struct scatterlist;
 struct crypto_ablkcipher;
 struct crypto_async_request;
-struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
 struct crypto_tfm;
 struct crypto_type;
-struct aead_request;
-struct aead_givcrypt_request;
 struct skcipher_givcrypt_request;
 
 typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);
@@ -275,47 +272,6 @@ struct ablkcipher_alg {
 };
 
 /**
- * struct old_aead_alg - AEAD cipher definition
- * @maxauthsize: Set the maximum authentication tag size supported by the
- *		 transformation. A transformation may support smaller tag sizes.
- *		 As the authentication tag is a message digest to ensure the
- *		 integrity of the encrypted data, a consumer typically wants the
- *		 largest authentication tag possible as defined by this
- *		 variable.
- * @setauthsize: Set authentication size for the AEAD transformation. This
- *		 function is used to specify the consumer requested size of the
- * 		 authentication tag to be either generated by the transformation
- *		 during encryption or the size of the authentication tag to be
- *		 supplied during the decryption operation. This function is also
- *		 responsible for checking the authentication tag size for
- *		 validity.
- * @setkey: see struct ablkcipher_alg
- * @encrypt: see struct ablkcipher_alg
- * @decrypt: see struct ablkcipher_alg
- * @givencrypt: see struct ablkcipher_alg
- * @givdecrypt: see struct ablkcipher_alg
- * @geniv: see struct ablkcipher_alg
- * @ivsize: see struct ablkcipher_alg
- *
- * All fields except @givencrypt , @givdecrypt , @geniv and @ivsize are
- * mandatory and must be filled.
- */
-struct old_aead_alg {
-	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
-	              unsigned int keylen);
-	int (*setauthsize)(struct crypto_aead *tfm, unsigned int authsize);
-	int (*encrypt)(struct aead_request *req);
-	int (*decrypt)(struct aead_request *req);
-	int (*givencrypt)(struct aead_givcrypt_request *req);
-	int (*givdecrypt)(struct aead_givcrypt_request *req);
-
-	const char *geniv;
-
-	unsigned int ivsize;
-	unsigned int maxauthsize;
-};
-
-/**
  * struct blkcipher_alg - synchronous block cipher definition
  * @min_keysize: see struct ablkcipher_alg
  * @max_keysize: see struct ablkcipher_alg
@@ -409,7 +365,6 @@ struct compress_alg {
 
 
 #define cra_ablkcipher	cra_u.ablkcipher
-#define cra_aead	cra_u.aead
 #define cra_blkcipher	cra_u.blkcipher
 #define cra_cipher	cra_u.cipher
 #define cra_compress	cra_u.compress
@@ -460,7 +415,7 @@ struct compress_alg {
  *	      struct crypto_type, which implements callbacks common for all
  *	      transformation types. There are multiple options:
  *	      &crypto_blkcipher_type, &crypto_ablkcipher_type,
- *	      &crypto_ahash_type, &crypto_aead_type, &crypto_rng_type.
+ *	      &crypto_ahash_type, &crypto_rng_type.
  *	      This field might be empty. In that case, there are no common
  *	      callbacks. This is the case for: cipher, compress, shash.
  * @cra_u: Callbacks implementing the transformation. This is a union of
@@ -508,7 +463,6 @@ struct crypto_alg {
 
 	union {
 		struct ablkcipher_alg ablkcipher;
-		struct old_aead_alg aead;
 		struct blkcipher_alg blkcipher;
 		struct cipher_alg cipher;
 		struct compress_alg compress;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
