From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Wed, 7 May 2008 21:00:47 +0800
Message-ID: <20080507130047.GA26872@gondor.apana.org.au>
References: <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com> <004a01c85efc$56f2ee70$5c05420a@amcc.com> <20080313114230.GC8393@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6044D6442@SDCEXCHANGE01.ad.amcc.com> <20080422111635.GA19543@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6045B3153@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47064 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbYEGNAw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:00:52 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6045B3153@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 22, 2008 at 10:23:23AM -0700, Loc Ho wrote:
> 
> They are attached instead inline until I figure out how to not wrap long
> line.

Thanks.  I've finally finished testing and integrating it.  I've
merged them into one patch and dropped unrelated white-space
changes.  You can resubmit those in a separate patch.

Could you please recheck this and if everything looks OK then
send it to me again with a sign-off? Oh and if you don't mind
please split the tcrypt and cryptd parts into separate patches
since they're conceptually distinct from the API bits.

Finally a proper description before each patch would be nice :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Makefile b/crypto/Makefile
index ca02441..6ea428a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
+crypto_hash-objs += ahash.o
 obj-$(CONFIG_CRYPTO_HASH) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_MANAGER) += cryptomgr.o
diff --git a/crypto/ahash.c b/crypto/ahash.c
new file mode 100644
index 0000000..a83e035
--- /dev/null
+++ b/crypto/ahash.c
@@ -0,0 +1,106 @@
+/*
+ * Asynchronous Cryptographic Hash operations.
+ *
+ * This is the asynchronous version of hash.c with notification of
+ * completion via a callback.
+ *
+ * Copyright (c) 2008 Loc Ho <lho@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+
+#include "internal.h"
+
+static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
+				unsigned int keylen)
+{
+	struct ahash_alg *ahash = crypto_ahash_alg(tfm);
+	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize = keylen + alignmask;
+	buffer = kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret = ahash->setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, keylen);
+	kfree(buffer);
+	return ret;
+}
+
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct ahash_alg *ahash = crypto_ahash_alg(tfm);
+	unsigned long alignmask = crypto_ahash_alignmask(tfm);
+
+	if ((unsigned long)key & alignmask)
+		return ahash_setkey_unaligned(tfm, key, keylen);
+
+	return ahash->setkey(tfm, key, keylen);
+}
+
+static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 type,
+					u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct ahash_alg *alg = &tfm->__crt_alg->cra_ahash;
+	struct ahash_tfm *crt   = &tfm->crt_ahash;
+
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	crt->init = alg->init;
+	crt->update = alg->update;
+	crt->final  = alg->final;
+	crt->digest = alg->digest;
+	crt->setkey = ahash_setkey;
+	crt->base   = __crypto_ahash_cast(tfm);
+	crt->digestsize = alg->digestsize;
+
+	return 0;
+}
+
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_printf(m, "type         : ahash\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "digestsize   : %u\n", alg->cra_hash.digestsize);
+}
+
+const struct crypto_type crypto_ahash_type = {
+	.ctxsize = crypto_ahash_ctxsize,
+	.init = crypto_init_ahash_ops,
+#ifdef CONFIG_PROC_FS
+	.show = crypto_ahash_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_ahash_type);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/api.c b/crypto/api.c
index 0a0f41e..d06e332 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -235,8 +235,12 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 		return crypto_init_cipher_ops(tfm);
 		
 	case CRYPTO_ALG_TYPE_DIGEST:
-		return crypto_init_digest_ops(tfm);
-		
+		if ((mask & CRYPTO_ALG_TYPE_HASH_MASK) !=
+		    CRYPTO_ALG_TYPE_HASH_MASK)
+			return crypto_init_digest_ops_async(tfm);
+		else
+			return crypto_init_digest_ops(tfm);
+
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		return crypto_init_compress_ops(tfm);
 	
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2504252..83fe67f 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -45,6 +45,13 @@ struct cryptd_blkcipher_request_ctx {
 	crypto_completion_t complete;
 };
 
+struct cryptd_hash_ctx {
+	struct crypto_hash *child;
+};
+
+struct cryptd_hash_request_ctx {
+	crypto_completion_t complete;
+};
 
 static inline struct cryptd_state *cryptd_get_state(struct crypto_tfm *tfm)
 {
@@ -259,6 +266,240 @@ out_put_alg:
 	return inst;
 }
 
+static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct cryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_spawn *spawn = &ictx->spawn;
+	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_hash *cipher;
+
+	cipher = crypto_spawn_hash(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+	tfm->crt_ahash.reqsize =
+		sizeof(struct cryptd_hash_request_ctx);
+	return 0;
+}
+
+static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_state *state = cryptd_get_state(tfm);
+	int active;
+
+	mutex_lock(&state->mutex);
+	active = ahash_tfm_in_queue(&state->queue,
+				__crypto_ahash_cast(tfm));
+	mutex_unlock(&state->mutex);
+
+	BUG_ON(active);
+
+	crypto_free_hash(ctx->child);
+}
+
+static int cryptd_hash_setkey(struct crypto_ahash *parent,
+				   const u8 *key, unsigned int keylen)
+{
+	struct cryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
+	struct crypto_hash     *child = ctx->child;
+	int err;
+
+	crypto_hash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_hash_set_flags(child, crypto_ahash_get_flags(parent) &
+					  CRYPTO_TFM_REQ_MASK);
+	err = crypto_hash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_hash_get_flags(child) &
+					    CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int cryptd_hash_enqueue(struct ahash_request *req,
+				crypto_completion_t complete)
+{
+	struct cryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct cryptd_state *state =
+		cryptd_get_state(crypto_ahash_tfm(tfm));
+	int err;
+
+	rctx->complete = req->base.complete;
+	req->base.complete = complete;
+
+	spin_lock_bh(&state->lock);
+	err = ahash_enqueue_request(&state->queue, req);
+	spin_unlock_bh(&state->lock);
+
+	wake_up_process(state->task);
+	return err;
+}
+
+static void cryptd_hash_init(struct crypto_async_request *req_async, int err)
+{
+	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child = ctx->child;
+	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+	struct hash_desc desc;
+
+	rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc.tfm = child;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_hash_crt(child)->init(&desc);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_init_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_init);
+}
+
+static void cryptd_hash_update(struct crypto_async_request *req_async, int err)
+{
+	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child = ctx->child;
+	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+	struct hash_desc desc;
+
+	rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc.tfm = child;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_hash_crt(child)->update(&desc,
+						req->src,
+						req->nbytes);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_update_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_update);
+}
+
+static void cryptd_hash_final(struct crypto_async_request *req_async, int err)
+{
+	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child = ctx->child;
+	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+	struct hash_desc desc;
+
+	rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc.tfm = child;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_hash_crt(child)->final(&desc, req->result);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_final_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_final);
+}
+
+static void cryptd_hash_digest(struct crypto_async_request *req_async, int err)
+{
+	struct cryptd_hash_ctx *ctx   = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child = ctx->child;
+	struct ahash_request    *req = ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+	struct hash_desc desc;
+
+	rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc.tfm = child;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_hash_crt(child)->digest(&desc,
+						req->src,
+						req->nbytes,
+						req->result);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_digest_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_digest);
+}
+
+static struct crypto_instance *cryptd_alloc_hash(
+	struct rtattr **tb, struct cryptd_state *state)
+{
+	struct crypto_instance *inst;
+	struct crypto_alg *alg;
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
+				  CRYPTO_ALG_TYPE_HASH_MASK);
+	if (IS_ERR(alg))
+		return ERR_PTR(PTR_ERR(alg));
+
+	inst = cryptd_alloc_instance(alg, state);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_type = &crypto_ahash_type;
+
+	inst->alg.cra_ahash.digestsize = alg->cra_hash.digestsize;
+	inst->alg.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
+
+	inst->alg.cra_init = cryptd_hash_init_tfm;
+	inst->alg.cra_exit = cryptd_hash_exit_tfm;
+
+	inst->alg.cra_ahash.init   = cryptd_hash_init_enqueue;
+	inst->alg.cra_ahash.update = cryptd_hash_update_enqueue;
+	inst->alg.cra_ahash.final  = cryptd_hash_final_enqueue;
+	inst->alg.cra_ahash.setkey = cryptd_hash_setkey;
+	inst->alg.cra_ahash.digest = cryptd_hash_digest_enqueue;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
 static struct cryptd_state state;
 
 static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
@@ -272,6 +513,8 @@ static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
 		return cryptd_alloc_blkcipher(tb, &state);
+	case CRYPTO_ALG_TYPE_DIGEST:
+		return cryptd_alloc_hash(tb, &state);
 	}
 
 	return ERR_PTR(-EINVAL);
diff --git a/crypto/digest.c b/crypto/digest.c
index b526cc3..025c9ae 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -157,3 +157,84 @@ int crypto_init_digest_ops(struct crypto_tfm *tfm)
 void crypto_exit_digest_ops(struct crypto_tfm *tfm)
 {
 }
+
+static int digest_async_nosetkey(struct crypto_ahash *tfm_async, const u8 *key,
+			unsigned int keylen)
+{
+	crypto_ahash_clear_flags(tfm_async, CRYPTO_TFM_RES_MASK);
+	return -ENOSYS;
+}
+
+static int digest_async_setkey(struct crypto_ahash *tfm_async, const u8 *key,
+			unsigned int keylen)
+{
+	struct crypto_tfm    *tfm        = crypto_ahash_tfm(tfm_async);
+	struct digest_alg    *dalg       = &tfm->__crt_alg->cra_digest;
+
+	crypto_ahash_clear_flags(tfm_async, CRYPTO_TFM_RES_MASK);
+	return dalg->dia_setkey(tfm, key, keylen);
+}
+
+static int digest_async_init(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
+
+	dalg->dia_init(tfm);
+	return 0;
+}
+
+static int digest_async_update(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	update(&desc, req->src, req->nbytes);
+	return 0;
+}
+
+static int digest_async_final(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	final(&desc, req->result);
+	return 0;
+}
+
+static int digest_async_digest(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm  = req->base.tfm;
+	struct hash_desc  desc = {
+		.tfm   = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return digest(&desc, req->src, req->nbytes, req->result);
+}
+
+int crypto_init_digest_ops_async(struct crypto_tfm *tfm)
+{
+	struct ahash_tfm  *crt  = &tfm->crt_ahash;
+	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
+
+	if (dalg->dia_digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	crt->init       = digest_async_init;
+	crt->update     = digest_async_update;
+	crt->final      = digest_async_final;
+	crt->digest     = digest_async_digest;
+	crt->setkey     = dalg->dia_setkey ? digest_async_setkey :
+						digest_async_nosetkey;
+	crt->digestsize = dalg->dia_digestsize;
+	crt->base       = __crypto_ahash_cast(tfm);
+
+	return 0;
+}
diff --git a/crypto/hash.c b/crypto/hash.c
index 7dcff67..f9400a0 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -59,24 +59,108 @@ static int hash_setkey(struct crypto_hash *crt, const u8 *key,
 	return alg->setkey(crt, key, keylen);
 }
 
-static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+static int hash_async_setkey(struct crypto_ahash *tfm_async, const u8 *key,
+			unsigned int keylen)
+{
+	struct crypto_tfm  *tfm      = crypto_ahash_tfm(tfm_async);
+	struct crypto_hash *tfm_hash = __crypto_hash_cast(tfm);
+	struct hash_alg    *alg      = &tfm->__crt_alg->cra_hash;
+
+	return alg->setkey(tfm_hash, key, keylen);
+}
+
+static int hash_async_init(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_alg   *alg = &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc = {
+		.tfm = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return alg->init(&desc);
+}
+
+static int hash_async_update(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_alg   *alg = &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc = {
+		.tfm = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return alg->update(&desc, req->src, req->nbytes);
+}
+
+static int hash_async_final(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_alg   *alg = &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc = {
+		.tfm = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return alg->final(&desc, req->result);
+}
+
+static int hash_async_digest(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm = req->base.tfm;
+	struct hash_alg   *alg = &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc = {
+		.tfm = __crypto_hash_cast(tfm),
+		.flags = req->base.flags,
+	};
+
+	return alg->digest(&desc, req->src, req->nbytes, req->result);
+}
+
+static int crypto_init_hash_ops_async(struct crypto_tfm *tfm)
+{
+	struct ahash_tfm *crt = &tfm->crt_ahash;
+	struct hash_alg  *alg = &tfm->__crt_alg->cra_hash;
+
+	crt->init       = hash_async_init;
+	crt->update     = hash_async_update;
+	crt->final      = hash_async_final;
+	crt->digest     = hash_async_digest;
+	crt->setkey     = hash_async_setkey;
+	crt->digestsize = alg->digestsize;
+	crt->base       = __crypto_ahash_cast(tfm);
+
+	return 0;
+}
+
+static int crypto_init_hash_ops_sync(struct crypto_tfm *tfm)
 {
 	struct hash_tfm *crt = &tfm->crt_hash;
 	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
 
-	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
-		return -EINVAL;
-
-	crt->init = alg->init;
-	crt->update = alg->update;
-	crt->final = alg->final;
-	crt->digest = alg->digest;
-	crt->setkey = hash_setkey;
+	crt->init       = alg->init;
+	crt->update     = alg->update;
+	crt->final      = alg->final;
+	crt->digest     = alg->digest;
+	crt->setkey     = hash_setkey;
 	crt->digestsize = alg->digestsize;
 
 	return 0;
 }
 
+static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
+
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	if ((mask & CRYPTO_ALG_TYPE_HASH_MASK) != CRYPTO_ALG_TYPE_HASH_MASK)
+		return crypto_init_hash_ops_async(tfm);
+	else
+		return crypto_init_hash_ops_sync(tfm);
+}
+
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)
 	__attribute__ ((unused));
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)
diff --git a/crypto/internal.h b/crypto/internal.h
index 32f4c21..683fcb2 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -86,6 +86,7 @@ struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type, u32 mask);
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 int crypto_init_digest_ops(struct crypto_tfm *tfm);
+int crypto_init_digest_ops_async(struct crypto_tfm *tfm);
 int crypto_init_cipher_ops(struct crypto_tfm *tfm);
 int crypto_init_compress_ops(struct crypto_tfm *tfm);
 
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..82919f9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -110,22 +110,30 @@ static void test_hash(char *algo, struct hash_testvec *template,
 	unsigned int i, j, k, temp;
 	struct scatterlist sg[8];
 	char result[64];
-	struct crypto_hash *tfm;
-	struct hash_desc desc;
+	struct crypto_ahash *tfm;
+	struct ahash_request *req;
+	struct tcrypt_result tresult;
 	int ret;
 	void *hash_buff;
 
 	printk("\ntesting %s\n", algo);
 
-	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
+	init_completion(&tresult.completion);
+
+	tfm = crypto_alloc_ahash(algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		return;
 	}
 
-	desc.tfm = tfm;
-	desc.flags = 0;
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_ERR "failed to allocate request for %s\n", algo);
+		goto out_noreq;
+	}
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   tcrypt_complete, &tresult);
 
 	for (i = 0; i < tcount; i++) {
 		printk("test %u:\n", i + 1);
@@ -139,8 +147,9 @@ static void test_hash(char *algo, struct hash_testvec *template,
 		sg_init_one(&sg[0], hash_buff, template[i].psize);
 
 		if (template[i].ksize) {
-			ret = crypto_hash_setkey(tfm, template[i].key,
-						 template[i].ksize);
+			crypto_ahash_clear_flags(tfm, ~0);
+			ret = crypto_ahash_setkey(tfm, template[i].key,
+						  template[i].ksize);
 			if (ret) {
 				printk("setkey() failed ret=%d\n", ret);
 				kfree(hash_buff);
@@ -148,17 +157,30 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			}
 		}
 
-		ret = crypto_hash_digest(&desc, sg, template[i].psize, result);
-		if (ret) {
+		ahash_request_set_crypt(req, sg, result, template[i].psize);
+		ret = crypto_ahash_digest(req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&tresult.completion);
+			if (!ret && !(ret = tresult.err)) {
+				INIT_COMPLETION(tresult.completion);
+				break;
+			}
+			/* fall through */
+		default:
 			printk("digest () failed ret=%d\n", ret);
 			kfree(hash_buff);
 			goto out;
 		}
 
-		hexdump(result, crypto_hash_digestsize(tfm));
+		hexdump(result, crypto_ahash_digestsize(tfm));
 		printk("%s\n",
 		       memcmp(result, template[i].digest,
-			      crypto_hash_digestsize(tfm)) ?
+			      crypto_ahash_digestsize(tfm)) ?
 		       "fail" : "pass");
 		kfree(hash_buff);
 	}
@@ -187,8 +209,9 @@ static void test_hash(char *algo, struct hash_testvec *template,
 			}
 
 			if (template[i].ksize) {
-				ret = crypto_hash_setkey(tfm, template[i].key,
-							 template[i].ksize);
+				crypto_ahash_clear_flags(tfm, ~0);
+				ret = crypto_ahash_setkey(tfm, template[i].key,
+							  template[i].ksize);
 
 				if (ret) {
 					printk("setkey() failed ret=%d\n", ret);
@@ -196,23 +219,38 @@ static void test_hash(char *algo, struct hash_testvec *template,
 				}
 			}
 
-			ret = crypto_hash_digest(&desc, sg, template[i].psize,
-						 result);
-			if (ret) {
+			ahash_request_set_crypt(req, sg, result,
+						template[i].psize);
+			ret = crypto_ahash_digest(req);
+			switch (ret) {
+			case 0:
+				break;
+			case -EINPROGRESS:
+			case -EBUSY:
+				ret = wait_for_completion_interruptible(
+					&tresult.completion);
+				if (!ret && !(ret = tresult.err)) {
+					INIT_COMPLETION(tresult.completion);
+					break;
+				}
+				/* fall through */
+			default:
 				printk("digest () failed ret=%d\n", ret);
 				goto out;
 			}
 
-			hexdump(result, crypto_hash_digestsize(tfm));
+			hexdump(result, crypto_ahash_digestsize(tfm));
 			printk("%s\n",
 			       memcmp(result, template[i].digest,
-				      crypto_hash_digestsize(tfm)) ?
+				      crypto_ahash_digestsize(tfm)) ?
 			       "fail" : "pass");
 		}
 	}
 
 out:
-	crypto_free_hash(tfm);
+	ahash_request_free(req);
+out_noreq:
+	crypto_free_ahash(tfm);
 }
 
 static void test_aead(char *algo, int enc, struct aead_testvec *template,
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 60d06e7..fef272a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -98,6 +98,7 @@ extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
+extern const struct crypto_type crypto_ahash_type;
 
 void crypto_mod_put(struct crypto_alg *alg);
 
@@ -314,5 +315,40 @@ static inline int crypto_requires_sync(u32 type, u32 mask)
 	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
 }
 
+static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_ctx(&tfm->base);
+}
+
+static inline struct ahash_alg *crypto_ahash_alg(
+	struct crypto_ahash *tfm)
+{
+	return &crypto_ahash_tfm(tfm)->__crt_alg->cra_ahash;
+}
+
+static inline int ahash_enqueue_request(struct crypto_queue *queue,
+					     struct ahash_request *request)
+{
+	return crypto_enqueue_request(queue, &request->base);
+}
+
+static inline struct ahash_request *ahash_dequeue_request(
+	struct crypto_queue *queue)
+{
+	return ahash_request_cast(crypto_dequeue_request(queue));
+}
+
+static inline void *ahash_request_ctx(struct ahash_request *req)
+{
+	return req->__ctx;
+}
+
+static inline int ahash_tfm_in_queue(struct crypto_queue *queue,
+					  struct crypto_ahash *tfm)
+{
+	return crypto_tfm_in_queue(queue, crypto_ahash_tfm(tfm));
+}
+
+
 #endif	/* _CRYPTO_ALGAPI_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 425824b..2446428 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -30,15 +30,17 @@
  */
 #define CRYPTO_ALG_TYPE_MASK		0x0000000f
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
-#define CRYPTO_ALG_TYPE_DIGEST		0x00000002
-#define CRYPTO_ALG_TYPE_HASH		0x00000003
+#define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
+#define CRYPTO_ALG_TYPE_AEAD		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
-#define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
-#define CRYPTO_ALG_TYPE_AEAD		0x00000009
+#define CRYPTO_ALG_TYPE_DIGEST		0x00000008
+#define CRYPTO_ALG_TYPE_HASH		0x00000009
+#define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
+#define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
@@ -102,6 +104,7 @@ struct crypto_async_request;
 struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
+struct crypto_ahash;
 struct crypto_tfm;
 struct crypto_type;
 struct aead_givcrypt_request;
@@ -131,6 +134,16 @@ struct ablkcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+struct ahash_request {
+	struct crypto_async_request base;
+
+	unsigned int nbytes;
+	struct scatterlist *src;
+	u8		   *result;
+
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;
+};
+
 /**
  *	struct aead_request - AEAD request
  *	@base: Common attributes for async crypto requests
@@ -195,6 +208,17 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
 
+struct ahash_alg {
+	int (*init)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req);
+	int (*final)(struct ahash_request *req);
+	int (*digest)(struct ahash_request *req);
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen);
+
+	unsigned int digestsize;
+};
+
 struct aead_alg {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
@@ -272,6 +296,7 @@ struct compress_alg {
 #define cra_cipher	cra_u.cipher
 #define cra_digest	cra_u.digest
 #define cra_hash	cra_u.hash
+#define cra_ahash	cra_u.ahash
 #define cra_compress	cra_u.compress
 
 struct crypto_alg {
@@ -298,6 +323,7 @@ struct crypto_alg {
 		struct cipher_alg cipher;
 		struct digest_alg digest;
 		struct hash_alg hash;
+		struct ahash_alg ahash;
 		struct compress_alg compress;
 	} cra_u;
 
@@ -383,6 +409,19 @@ struct hash_tfm {
 	unsigned int digestsize;
 };
 
+struct ahash_tfm {
+	int (*init)(struct ahash_request *req);
+	int (*update)(struct ahash_request *req);
+	int (*final)(struct ahash_request *req);
+	int (*digest)(struct ahash_request *req);
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen);
+
+	unsigned int digestsize;
+	struct crypto_ahash *base;
+	unsigned int reqsize;
+};
+
 struct compress_tfm {
 	int (*cot_compress)(struct crypto_tfm *tfm,
 	                    const u8 *src, unsigned int slen,
@@ -397,6 +436,7 @@ struct compress_tfm {
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
+#define crt_ahash	crt_u.ahash
 #define crt_compress	crt_u.compress
 
 struct crypto_tfm {
@@ -409,6 +449,7 @@ struct crypto_tfm {
 		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
+		struct ahash_tfm ahash;
 		struct compress_tfm compress;
 	} crt_u;
 	
@@ -441,6 +482,10 @@ struct crypto_hash {
 	struct crypto_tfm base;
 };
 
+struct crypto_ahash {
+	struct crypto_tfm base;
+};
+
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
@@ -1264,5 +1309,137 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_ahash *)tfm;
+}
+
+static inline struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,
+						      u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	mask &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_AHASH;
+	mask |= CRYPTO_ALG_TYPE_AHASH_MASK;
+
+	return __crypto_ahash_cast(crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
+{
+	return &tfm->base;
+}
+
+static inline void crypto_free_ahash(struct crypto_ahash *tfm)
+{
+	crypto_free_tfm(crypto_ahash_tfm(tfm));
+}
+
+static inline unsigned int crypto_ahash_alignmask(
+	struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));
+}
+
+static inline struct ahash_tfm *crypto_ahash_crt(struct crypto_ahash *tfm)
+{
+	return &crypto_ahash_tfm(tfm)->crt_ahash;
+}
+
+static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash *tfm)
+{
+	return crypto_ahash_crt(tfm)->digestsize;
+}
+
+static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_get_flags(crypto_ahash_tfm(tfm));
+}
+
+static inline void crypto_ahash_set_flags(struct crypto_ahash *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_ahash_tfm(tfm), flags);
+}
+
+static inline void crypto_ahash_clear_flags(struct crypto_ahash *tfm, u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_ahash_tfm(tfm), flags);
+}
+
+static inline struct crypto_ahash *crypto_ahash_reqtfm(
+	struct ahash_request *req)
+{
+	return __crypto_ahash_cast(req->base.tfm);
+}
+
+static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *tfm)
+{
+	return crypto_ahash_crt(tfm)->reqsize;
+}
+
+static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
+				      const u8 *key, unsigned int keylen)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(tfm);
+
+	return crt->setkey(crt->base, key, keylen);
+}
+
+static inline int crypto_ahash_digest(struct ahash_request *req)
+{
+	struct ahash_tfm *crt = crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->digest(req);
+}
+
+static inline void ahash_request_set_tfm(struct ahash_request *req,
+					 struct crypto_ahash *tfm)
+{
+	req->base.tfm = crypto_ahash_tfm(crypto_ahash_crt(tfm)->base);
+}
+
+static inline struct ahash_request *ahash_request_alloc(
+	struct crypto_ahash *tfm, gfp_t gfp)
+{
+	struct ahash_request *req;
+
+	req = kmalloc(sizeof(struct ahash_request) +
+		      crypto_ahash_reqsize(tfm), gfp);
+
+	if (likely(req))
+		ahash_request_set_tfm(req, tfm);
+
+	return req;
+}
+
+static inline void ahash_request_free(struct ahash_request *req)
+{
+	kfree(req);
+}
+
+static inline struct ahash_request *ahash_request_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(req, struct ahash_request, base);
+}
+
+static inline void ahash_request_set_callback(struct ahash_request *req,
+					      u32 flags,
+					      crypto_completion_t complete,
+					      void *data)
+{
+	req->base.complete = complete;
+	req->base.data = data;
+	req->base.flags = flags;
+}
+
+static inline void ahash_request_set_crypt(struct ahash_request *req,
+					   struct scatterlist *src, u8 *result,
+					   unsigned int nbytes)
+{
+	req->src = src;
+	req->nbytes = nbytes;
+	req->result = result;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
