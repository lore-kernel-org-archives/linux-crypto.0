From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/11] crypto: aead - Add common IV generation code
Date: Wed, 27 May 2015 14:37:30 +0800
Message-ID: <E1YxUy2-0006ll-61@gondolin.me.apana.org.au>
References: <20150527063539.GA25889@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43649 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbbE0Ghe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 02:37:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YxUy2-0005bZ-S2
	for <linux-crypto@vger.kernel.org>; Wed, 27 May 2015 16:37:31 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds some common IV generation code currently duplicated
by seqiv and echainiv.  For example, the setkey and setauthsize
functions are completely identical.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                   |  205 +++++++++++++++++++++++++++++++++++++++-
 include/crypto/internal/geniv.h |   24 ++++
 2 files changed, 226 insertions(+), 3 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 35c55e0..8cdea89 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -12,7 +12,7 @@
  *
  */
 
-#include <crypto/internal/aead.h>
+#include <crypto/internal/geniv.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -27,6 +27,14 @@
 
 #include "internal.h"
 
+struct compat_request_ctx {
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
+	struct scatterlist ivbuf[2];
+	struct scatterlist *ivsg;
+	struct aead_givcrypt_request subreq;
+};
+
 static int aead_null_givencrypt(struct aead_givcrypt_request *req);
 static int aead_null_givdecrypt(struct aead_givcrypt_request *req);
 
@@ -373,6 +381,185 @@ static int crypto_grab_nivaead(struct crypto_aead_spawn *spawn,
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 
+static int aead_geniv_setkey(struct crypto_aead *tfm,
+			     const u8 *key, unsigned int keylen)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setkey(ctx->child, key, keylen);
+}
+
+static int aead_geniv_setauthsize(struct crypto_aead *tfm,
+				  unsigned int authsize)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return crypto_aead_setauthsize(ctx->child, authsize);
+}
+
+static void compat_encrypt_complete2(struct aead_request *req, int err)
+{
+	struct compat_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_givcrypt_request *subreq = &rctx->subreq;
+	struct crypto_aead *geniv;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	if (err)
+		goto out;
+
+	geniv = crypto_aead_reqtfm(req);
+	scatterwalk_map_and_copy(subreq->giv, rctx->ivsg, 0,
+				 crypto_aead_ivsize(geniv), 1);
+
+out:
+	kzfree(subreq->giv);
+}
+
+static void compat_encrypt_complete(struct crypto_async_request *base, int err)
+{
+	struct aead_request *req = base->data;
+
+	compat_encrypt_complete2(req, err);
+	aead_request_complete(req, err);
+}
+
+static int compat_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
+	struct compat_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_givcrypt_request *subreq = &rctx->subreq;
+	unsigned int ivsize = crypto_aead_ivsize(geniv);
+	struct scatterlist *src, *dst;
+	crypto_completion_t compl;
+	void *data;
+	u8 *info;
+	__be64 seq;
+	int err;
+
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
+
+	compl = req->base.complete;
+	data = req->base.data;
+
+	rctx->ivsg = scatterwalk_ffwd(rctx->ivbuf, req->dst, req->assoclen);
+	info = PageHighMem(sg_page(rctx->ivsg)) ? NULL : sg_virt(rctx->ivsg);
+
+	if (!info) {
+		info = kmalloc(ivsize, req->base.flags &
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+								  GFP_ATOMIC);
+		if (!info)
+			return -ENOMEM;
+
+		compl = compat_encrypt_complete;
+		data = req;
+	}
+
+	memcpy(&seq, req->iv + ivsize - sizeof(seq), sizeof(seq));
+
+	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen + ivsize);
+	dst = req->src == req->dst ?
+	      src : scatterwalk_ffwd(rctx->dst, rctx->ivsg, ivsize);
+
+	aead_givcrypt_set_tfm(subreq, ctx->child);
+	aead_givcrypt_set_callback(subreq, req->base.flags,
+				   req->base.complete, req->base.data);
+	aead_givcrypt_set_crypt(subreq, src, dst,
+				req->cryptlen - ivsize, req->iv);
+	aead_givcrypt_set_assoc(subreq, req->src, req->assoclen);
+	aead_givcrypt_set_giv(subreq, info, be64_to_cpu(seq));
+
+	err = crypto_aead_givencrypt(subreq);
+	if (unlikely(PageHighMem(sg_page(rctx->ivsg))))
+		compat_encrypt_complete2(req, err);
+	return err;
+}
+
+static int compat_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
+	struct compat_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_request *subreq = &rctx->subreq.areq;
+	unsigned int ivsize = crypto_aead_ivsize(geniv);
+	struct scatterlist *src, *dst;
+	crypto_completion_t compl;
+	void *data;
+
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
+
+	aead_request_set_tfm(subreq, ctx->child);
+
+	compl = req->base.complete;
+	data = req->base.data;
+
+	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen + ivsize);
+	dst = req->src == req->dst ?
+	      src : scatterwalk_ffwd(rctx->dst, req->dst,
+				     req->assoclen + ivsize);
+
+	aead_request_set_callback(subreq, req->base.flags, compl, data);
+	aead_request_set_crypt(subreq, src, dst,
+			       req->cryptlen - ivsize, req->iv);
+	aead_request_set_assoc(subreq, req->src, req->assoclen);
+
+	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
+
+	return crypto_aead_decrypt(subreq);
+}
+
+static int compat_encrypt_first(struct aead_request *req)
+{
+	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
+
+	spin_lock_bh(&ctx->lock);
+	if (geniv->encrypt != compat_encrypt_first)
+		goto unlock;
+
+	geniv->encrypt = compat_encrypt;
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return compat_encrypt(req);
+}
+
+static int aead_geniv_init_compat(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err;
+
+	spin_lock_init(&ctx->lock);
+
+	crypto_aead_set_reqsize(geniv, sizeof(struct compat_request_ctx));
+
+	err = aead_geniv_init(tfm);
+
+	ctx->child = geniv->child;
+	geniv->child = geniv;
+
+	return err;
+}
+
+static void aead_geniv_exit_compat(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(geniv);
+
+	crypto_free_aead(ctx->child);
+}
+
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 				       struct rtattr **tb, u32 type, u32 mask)
 {
@@ -407,7 +594,9 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	mask |= crypto_requires_sync(algt->type, algt->mask);
 
 	crypto_set_aead_spawn(spawn, aead_crypto_instance(inst));
-	err = crypto_grab_nivaead(spawn, name, type, mask);
+	err = (algt->mask & CRYPTO_ALG_GENIV) ?
+	      crypto_grab_nivaead(spawn, name, type, mask) :
+	      crypto_grab_aead(spawn, name, type, mask);
 	if (err)
 		goto err_free_inst;
 
@@ -417,7 +606,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	err = -EINVAL;
-	if (!ivsize)
+	if (ivsize < sizeof(u64))
 		goto err_drop_alg;
 
 	/*
@@ -471,10 +660,20 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct aead_geniv_ctx);
+
+	inst->alg.setkey = aead_geniv_setkey;
+	inst->alg.setauthsize = aead_geniv_setauthsize;
 
 	inst->alg.ivsize = ivsize;
 	inst->alg.maxauthsize = maxauthsize;
 
+	inst->alg.encrypt = compat_encrypt_first;
+	inst->alg.decrypt = compat_decrypt;
+
+	inst->alg.base.cra_init = aead_geniv_init_compat;
+	inst->alg.base.cra_exit = aead_geniv_exit_compat;
+
 out:
 	return inst;
 
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
new file mode 100644
index 0000000..9ca9b87
--- /dev/null
+++ b/include/crypto/internal/geniv.h
@@ -0,0 +1,24 @@
+/*
+ * geniv: IV generation
+ *
+ * Copyright (c) 2015 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_INTERNAL_GENIV_H
+#define _CRYPTO_INTERNAL_GENIV_H
+
+#include <crypto/internal/aead.h>
+#include <linux/spinlock.h>
+
+struct aead_geniv_ctx {
+	spinlock_t lock;
+	struct crypto_aead *child;
+};
+
+#endif	/* _CRYPTO_INTERNAL_GENIV_H */
