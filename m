From: "Loc Ho" <locnho@sbcglobal.net>
Subject: RFC: Async Hash Support
Date: Thu, 24 Jan 2008 13:07:24 -0800
Message-ID: <004601c85ecd$1eb53d80$5c05420a@amcc.com>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0047_01C85E8A.1091FD80"
Cc: <linux-crypto@vger.kernel.org>,
	"'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:40730 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758359AbYAXVHX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jan 2008 16:07:23 -0500
In-Reply-To: <002d01c85d66$11e1d7c0$5c05420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0047_01C85E8A.1091FD80
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I have a working version of async hash support. It is attached. This follows
ablkciper implementation. 

It looks like crypto async dispatch to kernel thread isn't been use anymore
(cryptd.c). Am I correct? 

Is there a particular format for submitting patch?

-Loc


------=_NextPart_000_0047_01C85E8A.1091FD80
Content-Type: application/octet-stream;
	name="cryptodev_ahash.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="cryptodev_ahash.patch"

diff --git a/crypto/Makefile b/crypto/Makefile=0A=
index 48c7583..a9c3d09 100644=0A=
--- a/crypto/Makefile=0A=
+++ b/crypto/Makefile=0A=
@@ -18,6 +18,7 @@ obj-$(CONFIG_CRYPTO_BLKCIPHER) +=3D eseqiv.o=0A=
 obj-$(CONFIG_CRYPTO_SEQIV) +=3D seqiv.o=0A=
 =0A=
 crypto_hash-objs :=3D hash.o=0A=
+crypto_hash-objs +=3D ahash.o=0A=
 obj-$(CONFIG_CRYPTO_HASH) +=3D crypto_hash.o=0A=
 =0A=
 obj-$(CONFIG_CRYPTO_MANAGER) +=3D cryptomgr.o=0A=
diff --git a/crypto/ahash.c b/crypto/ahash.c=0A=
new file mode 100644=0A=
index 0000000..6f07179=0A=
--- /dev/null=0A=
+++ b/crypto/ahash.c=0A=
@@ -0,0 +1,151 @@=0A=
+/*=0A=
+ * Asynchronous Cryptographic Hash operations.=0A=
+ *=0A=
+ * This is the asynchronous version of hash.c with notification of=0A=
+ * completion via a callback.=0A=
+ *=0A=
+ * Copyright (c) 2008 Loc Ho <lho@amcc.com>=0A=
+ *=0A=
+ * This program is free software; you can redistribute it and/or modify =
it=0A=
+ * under the terms of the GNU General Public License as published by =
the Free=0A=
+ * Software Foundation; either version 2 of the License, or (at your =
option)=0A=
+ * any later version.=0A=
+ *=0A=
+ */=0A=
+=0A=
+#include <crypto/algapi.h>=0A=
+#include <linux/err.h>=0A=
+#include <linux/kernel.h>=0A=
+#include <linux/module.h>=0A=
+#include <linux/sched.h>=0A=
+#include <linux/slab.h>=0A=
+#include <linux/seq_file.h>=0A=
+=0A=
+#include "internal.h"=0A=
+=0A=
+static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 =
*key,=0A=
+				unsigned int keylen)=0A=
+{=0A=
+	struct ahash_alg *ahash =3D crypto_ahash_alg(tfm);=0A=
+	unsigned long alignmask =3D crypto_ahash_alignmask(tfm);=0A=
+	int ret;=0A=
+	u8 *buffer, *alignbuffer;=0A=
+	unsigned long absize;=0A=
+=0A=
+	absize =3D keylen + alignmask;=0A=
+	buffer =3D kmalloc(absize, GFP_ATOMIC);=0A=
+	if (!buffer)=0A=
+		return -ENOMEM;=0A=
+=0A=
+	alignbuffer =3D (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);=0A=
+	memcpy(alignbuffer, key, keylen);=0A=
+	ret =3D ahash->setkey(tfm, alignbuffer, keylen);=0A=
+	memset(alignbuffer, 0, keylen);=0A=
+	kfree(buffer);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,=0A=
+			unsigned int keylen)=0A=
+{=0A=
+	struct ahash_alg *ahash =3D crypto_ahash_alg(tfm);=0A=
+	unsigned long alignmask =3D crypto_ahash_alignmask(tfm);=0A=
+=0A=
+	if ((unsigned long)key & alignmask)=0A=
+		return ahash_setkey_unaligned(tfm, key, keylen);=0A=
+=0A=
+	return ahash->setkey(tfm, key, keylen);=0A=
+}=0A=
+=0A=
+static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 =
type,=0A=
+					u32 mask)=0A=
+{=0A=
+	return alg->cra_ctxsize;=0A=
+}=0A=
+=0A=
+static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 =
mask)=0A=
+{=0A=
+	struct ahash_alg *alg =3D &tfm->__crt_alg->cra_ahash;=0A=
+	struct ahash_tfm *crt   =3D &tfm->crt_ahash;=0A=
+=0A=
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))=0A=
+		return -EINVAL;=0A=
+=0A=
+	crt->init =3D alg->init;=0A=
+	crt->update =3D alg->update;=0A=
+	crt->final  =3D alg->final;=0A=
+	crt->digest =3D alg->digest;=0A=
+	crt->setkey =3D ahash_setkey;=0A=
+	crt->base   =3D __crypto_ahash_cast(tfm);=0A=
+	crt->digestsize =3D alg->digestsize;=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg =
*alg)=0A=
+	__attribute__ ((unused));=0A=
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg =
*alg)=0A=
+{=0A=
+	seq_printf(m, "type         : hash\n");=0A=
+	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC =
?=0A=
+					     "yes" : "no");=0A=
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);=0A=
+	seq_printf(m, "digestsize   : %u\n", alg->cra_hash.digestsize);=0A=
+}=0A=
+=0A=
+const struct crypto_type crypto_ahash_type =3D {=0A=
+	.ctxsize =3D crypto_ahash_ctxsize,=0A=
+	.init =3D crypto_init_ahash_ops,=0A=
+#ifdef CONFIG_PROC_FS=0A=
+	.show =3D crypto_ahash_show,=0A=
+#endif=0A=
+};=0A=
+EXPORT_SYMBOL_GPL(crypto_ahash_type);=0A=
+=0A=
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,=0A=
+					u32 type, u32 mask)=0A=
+{=0A=
+	struct crypto_tfm *tfm;=0A=
+	int err;=0A=
+=0A=
+	mask &=3D ~CRYPTO_ALG_TYPE_MASK;=0A=
+	mask |=3D CRYPTO_ALG_TYPE_HASH_MASK;=0A=
+=0A=
+	for (;;) {=0A=
+		struct crypto_alg *alg;=0A=
+=0A=
+		type &=3D ~CRYPTO_ALG_TYPE_MASK;=0A=
+		type |=3D CRYPTO_ALG_TYPE_AHASH;=0A=
+		alg =3D crypto_alg_mod_lookup(alg_name, type, mask);=0A=
+		if (IS_ERR(alg)) {=0A=
+			type &=3D ~CRYPTO_ALG_TYPE_MASK;=0A=
+			type |=3D CRYPTO_ALG_TYPE_HASH;=0A=
+		alg =3D crypto_alg_mod_lookup(alg_name, type, mask);=0A=
+		if (IS_ERR(alg)) {=0A=
+			err =3D PTR_ERR(alg);=0A=
+			goto err;=0A=
+		}=0A=
+		}=0A=
+=0A=
+		tfm =3D __crypto_alloc_tfm(alg, type, mask | CRYPTO_ALG_ASYNC);=0A=
+		if (!IS_ERR(tfm))=0A=
+			return __crypto_ahash_cast(tfm);=0A=
+=0A=
+		crypto_mod_put(alg);=0A=
+		err =3D PTR_ERR(tfm);=0A=
+=0A=
+err:=0A=
+		if (err !=3D -EAGAIN)=0A=
+			break;=0A=
+		if (signal_pending(current)) {=0A=
+			err =3D -EINTR;=0A=
+			break;=0A=
+		}=0A=
+	}=0A=
+=0A=
+	return ERR_PTR(err);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(crypto_alloc_ahash);=0A=
+=0A=
+MODULE_LICENSE("GPL");=0A=
+MODULE_DESCRIPTION("Asynchronous cryptographic hash type");=0A=
diff --git a/crypto/cryptd.c b/crypto/cryptd.c=0A=
index 074298f..29b5151 100644=0A=
--- a/crypto/cryptd.c=0A=
+++ b/crypto/cryptd.c=0A=
@@ -45,6 +45,14 @@ struct cryptd_blkcipher_request_ctx {=0A=
 	crypto_completion_t complete;=0A=
 };=0A=
 =0A=
+struct cryptd_hash_ctx {=0A=
+	struct crypto_hash *child;=0A=
+};=0A=
+=0A=
+struct cryptd_hash_request_ctx {=0A=
+	crypto_completion_t complete;=0A=
+	struct hash_desc    desc;=0A=
+};=0A=
 =0A=
 static inline struct cryptd_state *cryptd_get_state(struct crypto_tfm =
*tfm)=0A=
 {=0A=
@@ -259,6 +267,211 @@ out_put_alg:=0A=
 	return inst;=0A=
 }=0A=
 =0A=
+static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct crypto_instance *inst =3D crypto_tfm_alg_instance(tfm);=0A=
+	struct cryptd_instance_ctx *ictx =3D crypto_instance_ctx(inst);=0A=
+	struct crypto_spawn *spawn =3D &ictx->spawn;=0A=
+	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);=0A=
+	struct crypto_hash *cipher;=0A=
+=0A=
+	cipher =3D crypto_spawn_hash(spawn);=0A=
+	if (IS_ERR(cipher))=0A=
+		return PTR_ERR(cipher);=0A=
+=0A=
+	ctx->child =3D cipher;=0A=
+	tfm->crt_ahash.reqsize =3D=0A=
+		sizeof(struct cryptd_hash_request_ctx);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);=0A=
+	struct cryptd_state *state =3D cryptd_get_state(tfm);=0A=
+	int active;=0A=
+=0A=
+	mutex_lock(&state->mutex);=0A=
+	active =3D ahash_tfm_in_queue(&state->queue,=0A=
+				 	__crypto_ahash_cast(tfm));=0A=
+	mutex_unlock(&state->mutex);=0A=
+=0A=
+	BUG_ON(active);=0A=
+=0A=
+	crypto_free_hash(ctx->child);=0A=
+}=0A=
+=0A=
+static int cryptd_hash_setkey(struct crypto_ahash *parent,=0A=
+				   const u8 *key, unsigned int keylen)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx =3D crypto_ahash_ctx(parent);=0A=
+	struct crypto_hash *child =3D ctx->child;=0A=
+	int err;=0A=
+=0A=
+	crypto_hash_clear_flags(child, CRYPTO_TFM_REQ_MASK);=0A=
+	crypto_hash_set_flags(child, crypto_ahash_get_flags(parent) &=0A=
+					  CRYPTO_TFM_REQ_MASK);=0A=
+	err =3D crypto_hash_setkey(child, key, keylen);=0A=
+	crypto_ahash_set_flags(parent, crypto_hash_get_flags(child) &=0A=
+					    CRYPTO_TFM_RES_MASK);=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static int cryptd_hash_init(struct ahash_request *req)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx   =3D ahash_request_ctx(req);=0A=
+	struct crypto_hash     *child =3D ctx->child;=0A=
+	struct cryptd_hash_request_ctx *rctx =3D ahash_request_ctx(req);=0A=
+	int err;=0A=
+=0A=
+	err =3D crypto_hash_crt(child)->init(&rctx->desc);=0A=
+	rctx->desc.flags |=3D CRYPTO_TFM_REQ_MAY_SLEEP;=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static int cryptd_hash_enqueue(struct ahash_request *req,=0A=
+				crypto_completion_t complete)=0A=
+{=0A=
+	struct cryptd_hash_request_ctx *rctx =3D ahash_request_ctx(req);=0A=
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);=0A=
+	struct cryptd_state *state =3D=0A=
+		cryptd_get_state(crypto_ahash_tfm(tfm));=0A=
+	int err;=0A=
+=0A=
+	rctx->complete =3D req->base.complete;=0A=
+	req->base.complete =3D complete;=0A=
+=0A=
+	spin_lock_bh(&state->lock);=0A=
+	err =3D ahash_enqueue_request(&state->queue, req);=0A=
+	spin_unlock_bh(&state->lock);=0A=
+=0A=
+	wake_up_process(state->task);=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static void cryptd_hash_update(struct crypto_async_request *req_async, =
int err)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);=0A=
+	struct crypto_hash     *child =3D ctx->child;=0A=
+	struct ahash_request    *req =3D ahash_request_cast(req_async);=0A=
+	struct cryptd_hash_request_ctx *rctx;=0A=
+=0A=
+	rctx =3D ahash_request_ctx(req);=0A=
+=0A=
+	if (unlikely(err =3D=3D -EINPROGRESS)) {=0A=
+		rctx->complete(&req->base, err);=0A=
+		return;=0A=
+	}=0A=
+=0A=
+	err =3D crypto_hash_crt(child)->update(&rctx->desc, req->src, =
req->nbytes);=0A=
+=0A=
+	req->base.complete =3D rctx->complete;=0A=
+=0A=
+	local_bh_disable();=0A=
+	req->base.complete(&req->base, err);=0A=
+	local_bh_enable();=0A=
+}=0A=
+=0A=
+static int cryptd_hash_update_enqueue(struct ahash_request *req)=0A=
+{=0A=
+	return cryptd_hash_enqueue(req, cryptd_hash_update);=0A=
+}=0A=
+=0A=
+static void cryptd_hash_final(struct crypto_async_request *req_async, =
int err)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);=0A=
+	struct crypto_hash     *child =3D ctx->child;=0A=
+	struct ahash_request    *req =3D ahash_request_cast(req_async);=0A=
+	struct cryptd_hash_request_ctx *rctx;=0A=
+=0A=
+	rctx =3D ahash_request_ctx(req);=0A=
+=0A=
+	if (unlikely(err =3D=3D -EINPROGRESS)) {=0A=
+		rctx->complete(&req->base, err);=0A=
+		return;=0A=
+	}=0A=
+=0A=
+	err =3D crypto_hash_crt(child)->final(&rctx->desc, req->result);=0A=
+=0A=
+	req->base.complete =3D rctx->complete;=0A=
+=0A=
+	local_bh_disable();=0A=
+	req->base.complete(&req->base, err);=0A=
+	local_bh_enable();=0A=
+}=0A=
+=0A=
+static int cryptd_hash_final_enqueue(struct ahash_request *req)=0A=
+{=0A=
+	return cryptd_hash_enqueue(req, cryptd_hash_final);=0A=
+}=0A=
+=0A=
+static void cryptd_hash_digest(struct crypto_async_request *req_async, =
int err)=0A=
+{=0A=
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);=0A=
+	struct crypto_hash     *child =3D ctx->child;=0A=
+	struct ahash_request    *req =3D ahash_request_cast(req_async);=0A=
+	struct cryptd_hash_request_ctx *rctx;=0A=
+	struct hash_desc desc;=0A=
+=0A=
+	rctx =3D ahash_request_ctx(req);=0A=
+=0A=
+	if (unlikely(err =3D=3D -EINPROGRESS)) {=0A=
+		rctx->complete(&req->base, err);=0A=
+		return;=0A=
+	}=0A=
+=0A=
+	desc.tfm =3D child;=0A=
+	desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;=0A=
+=0A=
+	err =3D crypto_hash_crt(child)->digest(&desc, req->src, req->nbytes, =
req->result);=0A=
+=0A=
+	req->base.complete =3D rctx->complete;=0A=
+=0A=
+	local_bh_disable();=0A=
+	req->base.complete(&req->base, err);=0A=
+	local_bh_enable();=0A=
+}=0A=
+=0A=
+static int cryptd_hash_digest_enqueue(struct ahash_request *req)=0A=
+{=0A=
+	return cryptd_hash_enqueue(req, cryptd_hash_digest);=0A=
+}=0A=
+=0A=
+static struct crypto_instance *cryptd_alloc_hash(=0A=
+	struct rtattr **tb, struct cryptd_state *state)=0A=
+{=0A=
+	struct crypto_instance *inst;=0A=
+	struct crypto_alg *alg;=0A=
+=0A=
+	alg =3D crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,=0A=
+				  CRYPTO_ALG_TYPE_MASK);=0A=
+	if (IS_ERR(alg))=0A=
+		return ERR_PTR(PTR_ERR(alg));=0A=
+=0A=
+	inst =3D cryptd_alloc_instance(alg, state);=0A=
+	if (IS_ERR(inst))=0A=
+		goto out_put_alg;=0A=
+=0A=
+	inst->alg.cra_flags =3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;=0A=
+	inst->alg.cra_type =3D &crypto_ahash_type;=0A=
+=0A=
+	inst->alg.cra_ahash.digestsize =3D alg->cra_hash.digestsize;=0A=
+	inst->alg.cra_ctxsize =3D sizeof(struct cryptd_hash_ctx);=0A=
+=0A=
+	inst->alg.cra_init =3D cryptd_hash_init_tfm;=0A=
+	inst->alg.cra_exit =3D cryptd_hash_exit_tfm;=0A=
+=0A=
+	inst->alg.cra_ahash.init   =3D cryptd_hash_init;=0A=
+	inst->alg.cra_ahash.update =3D cryptd_hash_update_enqueue;=0A=
+	inst->alg.cra_ahash.final  =3D cryptd_hash_final_enqueue;=0A=
+	inst->alg.cra_ahash.setkey =3D cryptd_hash_setkey;=0A=
+	inst->alg.cra_ahash.digest =3D cryptd_hash_digest_enqueue;=0A=
+=0A=
+out_put_alg:=0A=
+	crypto_mod_put(alg);=0A=
+	return inst;=0A=
+}=0A=
+=0A=
 static struct cryptd_state state;=0A=
 =0A=
 static struct crypto_instance *cryptd_alloc(struct rtattr **tb)=0A=
@@ -272,6 +485,8 @@ static struct crypto_instance *cryptd_alloc(struct =
rtattr **tb)=0A=
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {=0A=
 	case CRYPTO_ALG_TYPE_BLKCIPHER:=0A=
 		return cryptd_alloc_blkcipher(tb, &state);=0A=
+	case CRYPTO_ALG_TYPE_HASH:=0A=
+		return cryptd_alloc_hash(tb, &state);=0A=
 	}=0A=
 =0A=
 	return ERR_PTR(-EINVAL);=0A=
diff --git a/crypto/hash.c b/crypto/hash.c=0A=
index 7dcff67..db81315 100644=0A=
--- a/crypto/hash.c=0A=
+++ b/crypto/hash.c=0A=
@@ -59,13 +59,84 @@ static int hash_setkey(struct crypto_hash *crt, =
const u8 *key,=0A=
 	return alg->setkey(crt, key, keylen);=0A=
 }=0A=
 =0A=
-static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 =
mask)=0A=
+static int hash_async_setkey(struct crypto_ahash *tfm_async, const u8 =
*key,=0A=
+			unsigned int keylen)=0A=
 {=0A=
-	struct hash_tfm *crt =3D &tfm->crt_hash;=0A=
+	struct crypto_tfm  *tfm      =3D crypto_ahash_tfm(tfm_async);=0A=
+	struct crypto_hash *tfm_hash =3D __crypto_hash_cast(tfm);=0A=
 	struct hash_alg *alg =3D &tfm->__crt_alg->cra_hash;=0A=
 =0A=
-	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))=0A=
-		return -EINVAL;=0A=
+	return alg->setkey(tfm_hash, key, keylen);=0A=
+}=0A=
+=0A=
+static int hash_async_init(struct ahash_request *req)=0A=
+{=0A=
+	struct crypto_tfm *tfm =3D req->base.tfm;=0A=
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+	struct hash_desc  desc =3D {=0A=
+		.tfm =3D __crypto_hash_cast(tfm),=0A=
+		.flags =3D req->base.flags,=0A=
+	};=0A=
+=0A=
+	return alg->init(&desc);=0A=
+}=0A=
+=0A=
+static int hash_async_update(struct ahash_request *req)=0A=
+{=0A=
+	struct crypto_tfm *tfm =3D req->base.tfm;=0A=
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+	struct hash_desc  desc =3D {=0A=
+		.tfm =3D __crypto_hash_cast(tfm),=0A=
+		.flags =3D req->base.flags,=0A=
+	};=0A=
+=0A=
+	return alg->update(&desc, req->src, req->nbytes);=0A=
+}=0A=
+=0A=
+static int hash_async_final(struct ahash_request *req)=0A=
+{=0A=
+	struct crypto_tfm *tfm =3D req->base.tfm;=0A=
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+	struct hash_desc  desc =3D {=0A=
+		.tfm =3D __crypto_hash_cast(tfm),=0A=
+		.flags =3D req->base.flags,=0A=
+	};=0A=
+=0A=
+	return alg->final(&desc, req->result);=0A=
+}=0A=
+=0A=
+static int hash_async_digest(struct ahash_request *req)=0A=
+{=0A=
+	struct crypto_tfm *tfm =3D req->base.tfm;=0A=
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+	struct hash_desc  desc =3D {=0A=
+		.tfm =3D __crypto_hash_cast(tfm),=0A=
+		.flags =3D req->base.flags,=0A=
+	};=0A=
+=0A=
+	return alg->digest(&desc, req->src, req->nbytes, req->result);=0A=
+}=0A=
+=0A=
+static int crypto_init_hash_ops_async(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct ahash_tfm *crt =3D &tfm->crt_ahash;=0A=
+	struct hash_alg  *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+=0A=
+	crt->init       =3D hash_async_init;=0A=
+	crt->update     =3D hash_async_update;=0A=
+	crt->final      =3D hash_async_final;=0A=
+	crt->digest     =3D hash_async_digest;=0A=
+	crt->setkey     =3D hash_async_setkey;=0A=
+	crt->digestsize =3D alg->digestsize;=0A=
+	crt->base       =3D __crypto_ahash_cast(tfm);=0A=
+=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int crypto_init_hash_ops_sync(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct hash_tfm *crt =3D &tfm->crt_hash;=0A=
+	struct hash_alg *alg =3D &tfm->__crt_alg->cra_hash;=0A=
 =0A=
 	crt->init =3D alg->init;=0A=
 	crt->update =3D alg->update;=0A=
@@ -77,6 +148,19 @@ static int crypto_init_hash_ops(struct crypto_tfm =
*tfm, u32 type, u32 mask)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 =
mask)=0A=
+{=0A=
+	struct hash_alg *alg =3D &tfm->__crt_alg->cra_hash;=0A=
+=0A=
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))=0A=
+		return -EINVAL;=0A=
+=0A=
+	if (mask & CRYPTO_ALG_ASYNC)=0A=
+		return crypto_init_hash_ops_async(tfm);=0A=
+	else=0A=
+		return crypto_init_hash_ops_sync(tfm);=0A=
+}=0A=
+=0A=
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)=0A=
 	__attribute__ ((unused));=0A=
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)=0A=
diff --git a/crypto/hmac.c b/crypto/hmac.c=0A=
index a1d016a..1497024 100644=0A=
--- a/crypto/hmac.c=0A=
+++ b/crypto/hmac.c=0A=
@@ -183,7 +183,6 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)=0A=
 	hash =3D crypto_spawn_hash(spawn);=0A=
 	if (IS_ERR(hash))=0A=
 		return PTR_ERR(hash);=0A=
-=0A=
 	ctx->child =3D hash;=0A=
 	return 0;=0A=
 }=0A=
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c=0A=
index 1ab8c01..d1f3767 100644=0A=
--- a/crypto/tcrypt.c=0A=
+++ b/crypto/tcrypt.c=0A=
@@ -35,6 +35,7 @@=0A=
 #include <linux/jiffies.h>=0A=
 #include <linux/timex.h>=0A=
 #include <linux/interrupt.h>=0A=
+#include <linux/delay.h>=0A=
 #include "tcrypt.h"=0A=
 =0A=
 /*=0A=
@@ -220,6 +221,96 @@ out:=0A=
 	crypto_free_hash(tfm);=0A=
 }=0A=
 =0A=
+static void test_ahash(char *algo, struct hash_testvec *template,=0A=
+		      unsigned int tcount)=0A=
+{=0A=
+	struct hash_testvec  *hash_tv;=0A=
+	struct crypto_ahash  *tfm =3D NULL;=0A=
+	struct ahash_request *req =3D NULL;=0A=
+	struct tcrypt_result result;=0A=
+	struct scatterlist   sg[8];=0A=
+	char 		digest_result[tcount][4*16];=0A=
+	unsigned int 	tsize;=0A=
+	unsigned int 	i;=0A=
+	int 		ret;=0A=
+=0A=
+	printk("\ntesting %s\n", algo);=0A=
+=0A=
+	tsize =3D sizeof(struct hash_testvec);=0A=
+	tsize *=3D tcount;=0A=
+	if (tsize > TVMEMSIZE) {=0A=
+		printk("template (%u) too big for tvmem (%u)\n", tsize, TVMEMSIZE);=0A=
+		return;=0A=
+	}=0A=
+	memcpy(tvmem, template, tsize);=0A=
+	hash_tv =3D (void *)tvmem;=0A=
+=0A=
+	init_completion(&result.completion);=0A=
+=0A=
+	tfm =3D crypto_alloc_ahash(algo, 0, 0);=0A=
+	if (IS_ERR(tfm)) {=0A=
+		printk("failed to load transform for %s: %ld\n", algo,=0A=
+		       PTR_ERR(tfm));=0A=
+		return;=0A=
+	}=0A=
+	req =3D ahash_request_alloc(tfm, GFP_KERNEL);=0A=
+	if (!req) {=0A=
+		printk("failed to allocate request for %s\n", algo);=0A=
+		goto out;=0A=
+	}=0A=
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,=0A=
+				tcrypt_complete, &result);=0A=
+=0A=
+	for (i =3D 0; i < tcount; i++) {=0A=
+		printk("test %u:\n", i + 1);=0A=
+		memset(&digest_result[i], 0, 4*16);=0A=
+		crypto_ahash_clear_flags(tfm, ~0);=0A=
+		if (hash_tv[i].ksize) {=0A=
+			ret =3D crypto_ahash_setkey(tfm, hash_tv[i].key,=0A=
+						 hash_tv[i].ksize);=0A=
+			if (ret) {=0A=
+				printk("setkey() failed error %d\n", ret);=0A=
+				goto out;=0A=
+			}=0A=
+		}=0A=
+=0A=
+		sg_init_one(&sg[0], hash_tv[i].plaintext, hash_tv[i].psize);=0A=
+=0A=
+		ahash_request_set_crypt(req, sg, digest_result[i],=0A=
+					hash_tv[i].psize);=0A=
+=0A=
+		ret =3D crypto_ahash_digest(req);=0A=
+		switch (ret) {=0A=
+		case 0:=0A=
+			break;=0A=
+		case -EINPROGRESS:=0A=
+		case -EBUSY:=0A=
+			ret =3D wait_for_completion_interruptible(=0A=
+				&result.completion);=0A=
+			if (!ret && !((ret =3D result.err))) {=0A=
+				INIT_COMPLETION(result.completion);=0A=
+				break;=0A=
+			}=0A=
+			/* fall through */=0A=
+		default:=0A=
+			printk("hash() failed error %d\n", ret);=0A=
+			goto out;=0A=
+		}=0A=
+=0A=
+		hexdump(digest_result[i], crypto_ahash_digestsize(tfm));=0A=
+		printk("%s\n",=0A=
+		       memcmp(digest_result[i], hash_tv[i].digest,=0A=
+			      crypto_ahash_digestsize(tfm)) ?=0A=
+		       "fail" : "pass");=0A=
+	}=0A=
+=0A=
+out:=0A=
+	if (req) {=0A=
+		ahash_request_free(req);=0A=
+	}=0A=
+	crypto_free_ahash(tfm);=0A=
+}=0A=
+=0A=
 static void test_aead(char *algo, int enc, struct aead_testvec =
*template,=0A=
 		      unsigned int tcount)=0A=
 {=0A=
@@ -471,7 +562,7 @@ static void test_cipher(char *algo, int enc,=0A=
 	else=0A=
 		e =3D "decryption";=0A=
 =0A=
-	printk("\ntesting %s %s\n", algo, e);=0A=
+	printk("\ntesting cipher %s %s\n", algo, e);=0A=
 =0A=
 	tsize =3D sizeof (struct cipher_testvec);=0A=
 	if (tsize > TVMEMSIZE) {=0A=
@@ -1619,6 +1710,51 @@ static void do_test(void)=0A=
 			  XCBC_AES_TEST_VECTORS);=0A=
 		break;=0A=
 =0A=
+	case 110:=0A=
+		test_ahash("hmac(md5)", hmac_md5_tv_template,=0A=
+			  HMAC_MD5_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 111:=0A=
+		test_ahash("hmac(sha1)", hmac_sha1_tv_template,=0A=
+			  HMAC_SHA1_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 112:=0A=
+		test_ahash("hmac(sha256)", hmac_sha256_tv_template,=0A=
+			  HMAC_SHA256_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 113:=0A=
+		test_ahash("hmac(sha384)", hmac_sha384_tv_template,=0A=
+			  HMAC_SHA384_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 114:=0A=
+		test_ahash("hmac(sha512)", hmac_sha512_tv_template,=0A=
+			  HMAC_SHA512_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 115:=0A=
+		test_ahash("hmac(sha224)", hmac_sha224_tv_template,=0A=
+			  HMAC_SHA224_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
+	case 120:=0A=
+		test_ahash("hmac(md5)", hmac_md5_tv_template,=0A=
+			  HMAC_MD5_TEST_VECTORS);=0A=
+		test_ahash("hmac(sha1)", hmac_sha1_tv_template,=0A=
+			  HMAC_SHA1_TEST_VECTORS);=0A=
+		test_ahash("hmac(sha224)", hmac_sha224_tv_template,=0A=
+			  HMAC_SHA224_TEST_VECTORS);=0A=
+		test_ahash("hmac(sha256)", hmac_sha256_tv_template,=0A=
+			  HMAC_SHA256_TEST_VECTORS);=0A=
+		test_ahash("hmac(sha384)", hmac_sha384_tv_template,=0A=
+			  HMAC_SHA384_TEST_VECTORS);=0A=
+		test_ahash("hmac(sha512)", hmac_sha512_tv_template,=0A=
+			  HMAC_SHA512_TEST_VECTORS);=0A=
+		break;=0A=
+=0A=
 	case 200:=0A=
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,=0A=
 				  aes_speed_template);=0A=
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig=0A=
index d8c7040..21e4234 100644=0A=
--- a/drivers/crypto/Kconfig=0A=
+++ b/drivers/crypto/Kconfig=0A=
@@ -92,6 +92,12 @@ config CRYPTO_DEV_HIFN_795X=0A=
 	help=0A=
 	  This option allows you to have support for HIFN 795x crypto adapters.=0A=
 =0A=
-=0A=
+config CRYPTO_DEV_AHASH_SAMPLE=0A=
+	tristate "Asynchronous HASH sample driver over software synchronous =
HASH"=0A=
+	select CRYPTO_HASH=0A=
+	select CRYPTO_ALGAPI=0A=
+	help=0A=
+	  This is a sample asynchronous HASH device driver over synchronous =
software=0A=
+          HASH.=0A=
 =0A=
 endif # CRYPTO_HW=0A=
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile=0A=
index c0327f0..0b1cc2f 100644=0A=
--- a/drivers/crypto/Makefile=0A=
+++ b/drivers/crypto/Makefile=0A=
@@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) +=3D padlock-aes.o=0A=
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) +=3D padlock-sha.o=0A=
 obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o=0A=
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o=0A=
+obj-$(CONFIG_CRYPTO_DEV_AHASH_SAMPLE) +=3D ahash_sample.o=0A=
diff --git a/drivers/crypto/ahash_sample.c =
b/drivers/crypto/ahash_sample.c=0A=
new file mode 100644=0A=
index 0000000..44b5c69=0A=
--- /dev/null=0A=
+++ b/drivers/crypto/ahash_sample.c=0A=
@@ -0,0 +1,345 @@=0A=
+/*=0A=
+ * Sample Asynchronous device driver that wraps around software sync =
HASH=0A=
+ *=0A=
+ * 2008 Copyright (c) Loc Ho <lho@amcc.com>=0A=
+ * All rights reserved.=0A=
+ *=0A=
+ * This program is free software; you can redistribute it and/or modify=0A=
+ * it under the terms of the GNU General Public License as published by=0A=
+ * the Free Software Foundation; either version 2 of the License, or=0A=
+ * (at your option) any later version.=0A=
+ *=0A=
+ * This program is distributed in the hope that it will be useful,=0A=
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
+ * GNU General Public License for more details.=0A=
+ *=0A=
+ * You should have received a copy of the GNU General Public License=0A=
+ * along with this program; if not, write to the Free Software=0A=
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 =
 USA=0A=
+ */=0A=
+#include <linux/kernel.h>=0A=
+#include <linux/module.h>=0A=
+#include <linux/moduleparam.h>=0A=
+#include <linux/mod_devicetable.h>=0A=
+#include <linux/interrupt.h>=0A=
+#include <linux/highmem.h>=0A=
+#include <linux/scatterlist.h>=0A=
+#include <linux/crypto.h>=0A=
+#include <crypto/algapi.h>=0A=
+=0A=
+struct ahash_sample_device=0A=
+{=0A=
+	char			name[64];=0A=
+	struct tasklet_struct	tasklet;=0A=
+	struct crypto_queue 	queue;=0A=
+	spinlock_t		lock;		/**< Queue lock protection */=0A=
+	struct list_head	alg_list;=0A=
+};=0A=
+=0A=
+#define AHASH_SAMPLE_OP_DIGEST	0=0A=
+#define AHASH_SAMPLE_OP_UPDATE	1=0A=
+#define AHASH_SAMPLE_OP_FINAL	2=0A=
+=0A=
+struct ahash_sample_context=0A=
+{=0A=
+	struct ahash_sample_device *dev;=0A=
+	u8			key[16];=0A=
+	unsigned int		keysize;=0A=
+	struct crypto_hash 	*sync_tfm;=0A=
+	struct hash_desc 	desc;=0A=
+	u8	ops;=0A=
+};=0A=
+=0A=
+struct ahash_sample_alg=0A=
+{=0A=
+	struct list_head    	entry;=0A=
+	struct crypto_alg   	alg;=0A=
+	struct ahash_sample_device *dev;=0A=
+};=0A=
+=0A=
+static struct ahash_sample_device * ahash_sample_dev =3D NULL;=0A=
+=0A=
+#define crypto_alg_to_ahash_sample_alg(a)	container_of(a, struct =
ahash_sample_alg, alg)=0A=
+=0A=
+static int ahash_sample_alg_init(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct crypto_alg    *alg       =3D tfm->__crt_alg;=0A=
+	struct ahash_sample_alg *ahash_alg =3D =
crypto_alg_to_ahash_sample_alg(alg);=0A=
+	struct ahash_sample_context *ctx   =3D crypto_tfm_ctx(tfm);=0A=
+=0A=
+	ctx->dev =3D ahash_alg->dev;=0A=
+	ctx->sync_tfm =3D crypto_alloc_hash(alg->cra_name, 0, =
CRYPTO_ALG_ASYNC);=0A=
+	if (IS_ERR(ctx->sync_tfm)) {=0A=
+		printk(KERN_ERR "AHASH_SAMPLE: failed to load transform for %s: =
%ld\n",=0A=
+			alg->cra_name, PTR_ERR(ctx->sync_tfm));=0A=
+		return -ENOMEM;=0A=
+	}=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: initialize alg %s\n", alg->cra_name);=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void ahash_sample_alg_exit(struct crypto_tfm *tfm)=0A=
+{=0A=
+	struct crypto_alg           *alg =3D tfm->__crt_alg;=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(tfm);=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: exit alg %s\n", alg->cra_name);=0A=
+=0A=
+	if (ctx->sync_tfm) {=0A=
+		crypto_free_hash(ctx->sync_tfm);=0A=
+		ctx->sync_tfm =3D NULL;=0A=
+		ctx->dev      =3D NULL;=0A=
+	}=0A=
+}=0A=
+=0A=
+static int ahash_sample_ops_setkey(struct crypto_ahash *cipher, const =
u8 *key,=0A=
+			unsigned int keylen)=0A=
+{=0A=
+	struct crypto_tfm        *tfm =3D crypto_ahash_tfm(cipher);=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(tfm);=0A=
+	int    ret;=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: setkey\n");=0A=
+=0A=
+	ret =3D crypto_hash_setkey(ctx->sync_tfm, key, keylen);=0A=
+	if (ret) {=0A=
+		printk(KERN_ERR "aynchronous hash generic setkey failed error %d\n", =
ret);=0A=
+		return -1;=0A=
+	}=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static inline int ahash_sample_ops_init(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: init\n");=0A=
+=0A=
+	ctx->desc.tfm   =3D ctx->sync_tfm;=0A=
+	ctx->desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;=0A=
+	return crypto_hash_init(&ctx->desc);=0A=
+}=0A=
+=0A=
+static inline int ahash_sample_ops_update(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);=0A=
+	unsigned long flags;=0A=
+	int ret;=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: update\n");=0A=
+=0A=
+	ctx->ops =3D AHASH_SAMPLE_OP_UPDATE;=0A=
+	spin_lock_irqsave(&ctx->dev->lock, flags);=0A=
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);=0A=
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);=0A=
+=0A=
+	tasklet_schedule(&ctx->dev->tasklet);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static inline int ahash_sample_ops_final(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);=0A=
+	unsigned long flags;=0A=
+	int    ret;=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: final\n");=0A=
+=0A=
+	ctx->ops =3D AHASH_SAMPLE_OP_FINAL;=0A=
+	spin_lock_irqsave(&ctx->dev->lock, flags);=0A=
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);=0A=
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);=0A=
+=0A=
+	tasklet_schedule(&ctx->dev->tasklet);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static inline int ahash_sample_ops_digest(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);=0A=
+	unsigned long flags;=0A=
+	int ret;=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: digest\n");=0A=
+=0A=
+	ctx->ops =3D AHASH_SAMPLE_OP_DIGEST;=0A=
+	spin_lock_irqsave(&ctx->dev->lock, flags);=0A=
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);=0A=
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);=0A=
+=0A=
+	tasklet_schedule(&ctx->dev->tasklet);=0A=
+	return ret;=0A=
+}=0A=
+=0A=
+static int ahash_sample_handle_req(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);=0A=
+	struct hash_desc desc;=0A=
+	int    ret;=0A=
+=0A=
+	desc.tfm   =3D ctx->sync_tfm;=0A=
+	desc.flags =3D 0;=0A=
+	switch(ctx->ops) {=0A=
+	case AHASH_SAMPLE_OP_UPDATE:=0A=
+		ret =3D crypto_hash_update(&desc, req->src, req->nbytes);=0A=
+		break;=0A=
+	case AHASH_SAMPLE_OP_FINAL:=0A=
+		ret =3D crypto_hash_final(&desc, req->result);=0A=
+		break;=0A=
+	case AHASH_SAMPLE_OP_DIGEST:=0A=
+	default:=0A=
+	ret =3D crypto_hash_digest(&desc, req->src, req->nbytes, req->result);=0A=
+		break;=0A=
+	}=0A=
+	if (ret) {=0A=
+		printk(KERN_ERR "AHASH_SAMPLE: asynchronous hash generic digest =
failed error %d\n", ret);=0A=
+		return ret;=0A=
+	}=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static void ahash_sample_bh_tasklet_cb(unsigned long data)=0A=
+{=0A=
+	struct ahash_sample_device     *dev =3D (struct ahash_sample_device *) =
data;=0A=
+	struct crypto_async_request *async_req;=0A=
+	struct ahash_sample_context    *ctx;=0A=
+	struct ahash_request        *req;=0A=
+	unsigned long 	flags;=0A=
+	int 		err;=0A=
+=0A=
+	while(1) {=0A=
+		spin_lock_irqsave(&dev->lock, flags);=0A=
+		async_req =3D crypto_dequeue_request(&dev->queue);=0A=
+		spin_unlock_irqrestore(&dev->lock, flags);=0A=
+=0A=
+		if (!async_req) {=0A=
+			break;=0A=
+		}=0A=
+=0A=
+		ctx =3D crypto_tfm_ctx(async_req->tfm);=0A=
+		req =3D container_of(async_req, struct ahash_request, base);=0A=
+=0A=
+		/* Process the request */=0A=
+		err =3D ahash_sample_handle_req(req);=0A=
+=0A=
+		/* Notify packet completed */=0A=
+		req->base.complete(&req->base, err);=0A=
+	}=0A=
+}=0A=
+=0A=
+static struct crypto_alg ahash_sample_alg_tbl[] =3D=0A=
+{=0A=
+	{ .cra_name		=3D "hmac(md5)",=0A=
+	  .cra_driver_name	=3D "ahash-md5",=0A=
+	  .cra_priority		=3D 300,=0A=
+	  .cra_flags		=3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,=0A=
+	  .cra_blocksize	=3D 64, /* MD5-HMAC block size is 512-bits */=0A=
+	  .cra_ctxsize		=3D sizeof(struct ahash_sample_context),=0A=
+	  .cra_alignmask 	=3D 0,=0A=
+	  .cra_type		=3D &crypto_ahash_type,=0A=
+	  .cra_module		=3D THIS_MODULE,=0A=
+	  .cra_u		=3D { .ahash =3D {=0A=
+	  .digestsize		=3D 16, /* Disgest is 128-bits */=0A=
+	  .init   		=3D ahash_sample_ops_init,=0A=
+	  .update   		=3D ahash_sample_ops_update,=0A=
+	  .final   		=3D ahash_sample_ops_final,=0A=
+	  .digest 		=3D ahash_sample_ops_digest,=0A=
+	  .setkey		=3D ahash_sample_ops_setkey,=0A=
+	  } },=0A=
+	},=0A=
+	{ .cra_name		=3D "" }=0A=
+};=0A=
+=0A=
+static void ahash_sample_unregister_alg(struct ahash_sample_device * =
dev)=0A=
+{=0A=
+	struct ahash_sample_alg *alg, *tmp;=0A=
+=0A=
+	list_for_each_entry_safe(alg, tmp, &dev->alg_list, entry) {=0A=
+		list_del(&alg->entry);=0A=
+		crypto_unregister_alg(&alg->alg);=0A=
+		kfree(alg);=0A=
+	}=0A=
+}=0A=
+=0A=
+static int ahash_sample_register_alg(struct ahash_sample_device * dev)=0A=
+{=0A=
+	struct ahash_sample_alg *alg;=0A=
+	int i;=0A=
+	int rc =3D 0;=0A=
+=0A=
+	for(i =3D 0; ahash_sample_alg_tbl[i].cra_name[0] !=3D '\0'; i++) {=0A=
+		alg =3D kzalloc(sizeof(struct ahash_sample_alg), GFP_KERNEL);=0A=
+		if (!alg) {=0A=
+			return -ENOMEM;=0A=
+		}=0A=
+		alg->alg 		=3D ahash_sample_alg_tbl[i];=0A=
+		INIT_LIST_HEAD(&alg->alg.cra_list);=0A=
+		alg->dev 		=3D dev;=0A=
+		alg->alg.cra_init	=3D ahash_sample_alg_init;=0A=
+		alg->alg.cra_exit	=3D ahash_sample_alg_exit;=0A=
+		list_add_tail(&alg->entry, &dev->alg_list);=0A=
+		rc =3D crypto_register_alg(&alg->alg);=0A=
+		if (rc) {=0A=
+			printk(KERN_ERR "AHASH_SAMPLE: failed to register alg %s.%s",=0A=
+				ahash_sample_alg_tbl[i].cra_driver_name,=0A=
+				ahash_sample_alg_tbl[i].cra_name);=0A=
+=0A=
+			list_del(&alg->entry);=0A=
+			kfree(alg);=0A=
+			return rc;=0A=
+		}=0A=
+	}=0A=
+	return rc;=0A=
+}=0A=
+=0A=
+static int __devinit ahash_sample_init(void)=0A=
+{=0A=
+	int err;=0A=
+=0A=
+	ahash_sample_dev =3D kzalloc(sizeof(struct ahash_sample_device) + =
sizeof(struct crypto_alg),=0A=
+				GFP_KERNEL);=0A=
+	if (!ahash_sample_dev) {=0A=
+		err =3D -ENOMEM;=0A=
+		goto err_nomem;=0A=
+	}=0A=
+=0A=
+	INIT_LIST_HEAD(&ahash_sample_dev->alg_list);=0A=
+	strncpy(ahash_sample_dev->name, "AHASH_generic", =
sizeof(ahash_sample_dev->name));=0A=
+=0A=
+	err =3D ahash_sample_register_alg(ahash_sample_dev);=0A=
+	if (err) {=0A=
+		goto err_register_alg;=0A=
+	}=0A=
+=0A=
+	/* Init tasklet for asynchronous processing */=0A=
+	tasklet_init(&ahash_sample_dev->tasklet, ahash_sample_bh_tasklet_cb,=0A=
+		(unsigned long) ahash_sample_dev);=0A=
+	crypto_init_queue(&ahash_sample_dev->queue, 64*1024);=0A=
+=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: Asynchronous hashing sample driver =
successfully registered.\n");=0A=
+	return 0;=0A=
+=0A=
+err_register_alg:=0A=
+	kfree(ahash_sample_dev);=0A=
+	ahash_sample_dev =3D NULL;=0A=
+=0A=
+err_nomem:=0A=
+	return err;=0A=
+}=0A=
+=0A=
+static void __devexit ahash_sample_fini(void)=0A=
+{=0A=
+	ahash_sample_unregister_alg(ahash_sample_dev);=0A=
+	kfree(ahash_sample_dev);=0A=
+	ahash_sample_dev =3D NULL;=0A=
+	printk(KERN_INFO "AHASH_SAMPLE: Driver for testing asynchronous hash =
support framework "=0A=
+			"has been successfully unregistered.\n");=0A=
+}=0A=
+=0A=
+module_init(ahash_sample_init);=0A=
+module_exit(ahash_sample_fini);=0A=
+=0A=
+MODULE_LICENSE("GPL");=0A=
+MODULE_AUTHOR("Loc Ho <lho@amcc.com>");=0A=
+MODULE_DESCRIPTION("Sample asynchronous hash driver");=0A=
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h=0A=
index 60d06e7..fef272a 100644=0A=
--- a/include/crypto/algapi.h=0A=
+++ b/include/crypto/algapi.h=0A=
@@ -98,6 +98,7 @@ extern const struct crypto_type crypto_ablkcipher_type;=0A=
 extern const struct crypto_type crypto_aead_type;=0A=
 extern const struct crypto_type crypto_blkcipher_type;=0A=
 extern const struct crypto_type crypto_hash_type;=0A=
+extern const struct crypto_type crypto_ahash_type;=0A=
 =0A=
 void crypto_mod_put(struct crypto_alg *alg);=0A=
 =0A=
@@ -314,5 +315,40 @@ static inline int crypto_requires_sync(u32 type, =
u32 mask)=0A=
 	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;=0A=
 }=0A=
 =0A=
+static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)=0A=
+{=0A=
+	return crypto_tfm_ctx(&tfm->base);=0A=
+}=0A=
+=0A=
+static inline struct ahash_alg *crypto_ahash_alg(=0A=
+	struct crypto_ahash *tfm)=0A=
+{=0A=
+	return &crypto_ahash_tfm(tfm)->__crt_alg->cra_ahash;=0A=
+}=0A=
+=0A=
+static inline int ahash_enqueue_request(struct crypto_queue *queue,=0A=
+					     struct ahash_request *request)=0A=
+{=0A=
+	return crypto_enqueue_request(queue, &request->base);=0A=
+}=0A=
+=0A=
+static inline struct ahash_request *ahash_dequeue_request(=0A=
+	struct crypto_queue *queue)=0A=
+{=0A=
+	return ahash_request_cast(crypto_dequeue_request(queue));=0A=
+}=0A=
+=0A=
+static inline void *ahash_request_ctx(struct ahash_request *req)=0A=
+{=0A=
+	return req->__ctx;=0A=
+}=0A=
+=0A=
+static inline int ahash_tfm_in_queue(struct crypto_queue *queue,=0A=
+					  struct crypto_ahash *tfm)=0A=
+{=0A=
+	return crypto_tfm_in_queue(queue, crypto_ahash_tfm(tfm));=0A=
+}=0A=
+=0A=
+=0A=
 #endif	/* _CRYPTO_ALGAPI_H */=0A=
 =0A=
diff --git a/include/linux/crypto.h b/include/linux/crypto.h=0A=
index 5e02d1b..bb7c752 100644=0A=
--- a/include/linux/crypto.h=0A=
+++ b/include/linux/crypto.h=0A=
@@ -7,10 +7,10 @@=0A=
  *=0A=
  * Portions derived from Cryptoapi, by Alexander Kjeldaas =
<astor@fast.no>=0A=
  * and Nettle, by Niels M=C3=B6ller.=0A=
- * =0A=
+ *=0A=
  * This program is free software; you can redistribute it and/or modify =
it=0A=
  * under the terms of the GNU General Public License as published by =
the Free=0A=
- * Software Foundation; either version 2 of the License, or (at your =
option) =0A=
+ * Software Foundation; either version 2 of the License, or (at your =
option)=0A=
  * any later version.=0A=
  *=0A=
  */=0A=
@@ -37,6 +37,7 @@=0A=
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006=0A=
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000008=0A=
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009=0A=
+#define CRYPTO_ALG_TYPE_AHASH		0x0000000A=0A=
 =0A=
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e=0A=
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c=0A=
@@ -102,6 +103,7 @@ struct crypto_async_request;=0A=
 struct crypto_aead;=0A=
 struct crypto_blkcipher;=0A=
 struct crypto_hash;=0A=
+struct crypto_ahash;=0A=
 struct crypto_tfm;=0A=
 struct crypto_type;=0A=
 struct aead_givcrypt_request;=0A=
@@ -131,6 +133,16 @@ struct ablkcipher_request {=0A=
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;=0A=
 };=0A=
 =0A=
+struct ahash_request {=0A=
+	struct crypto_async_request base;=0A=
+=0A=
+	unsigned int nbytes;=0A=
+	struct scatterlist *src;=0A=
+	u8		   *result;=0A=
+=0A=
+	void *__ctx[] CRYPTO_MINALIGN_ATTR;=0A=
+};=0A=
+=0A=
 /**=0A=
  *	struct aead_request - AEAD request=0A=
  *	@base: Common attributes for async crypto requests=0A=
@@ -195,6 +207,17 @@ struct ablkcipher_alg {=0A=
 	unsigned int ivsize;=0A=
 };=0A=
 =0A=
+struct ahash_alg {=0A=
+	int (*init)(struct ahash_request *req);=0A=
+	int (*update)(struct ahash_request *req);=0A=
+	int (*final)(struct ahash_request *req);=0A=
+	int (*digest)(struct ahash_request *req);=0A=
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,=0A=
+		unsigned int keylen);=0A=
+=0A=
+	unsigned int digestsize;=0A=
+};=0A=
+=0A=
 struct aead_alg {=0A=
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,=0A=
 	              unsigned int keylen);=0A=
@@ -272,6 +295,7 @@ struct compress_alg {=0A=
 #define cra_cipher	cra_u.cipher=0A=
 #define cra_digest	cra_u.digest=0A=
 #define cra_hash	cra_u.hash=0A=
+#define cra_ahash	cra_u.ahash=0A=
 #define cra_compress	cra_u.compress=0A=
 =0A=
 struct crypto_alg {=0A=
@@ -298,13 +322,14 @@ struct crypto_alg {=0A=
 		struct cipher_alg cipher;=0A=
 		struct digest_alg digest;=0A=
 		struct hash_alg hash;=0A=
+		struct ahash_alg ahash;=0A=
 		struct compress_alg compress;=0A=
 	} cra_u;=0A=
 =0A=
 	int (*cra_init)(struct crypto_tfm *tfm);=0A=
 	void (*cra_exit)(struct crypto_tfm *tfm);=0A=
 	void (*cra_destroy)(struct crypto_alg *alg);=0A=
-	=0A=
+=0A=
 	struct module *cra_module;=0A=
 };=0A=
 =0A=
@@ -390,6 +415,19 @@ struct hash_tfm {=0A=
 	unsigned int digestsize;=0A=
 };=0A=
 =0A=
+struct ahash_tfm {=0A=
+	int (*init)(struct ahash_request *req);=0A=
+	int (*update)(struct ahash_request *req);=0A=
+	int (*final)(struct ahash_request *req);=0A=
+	int (*digest)(struct ahash_request * req);=0A=
+	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,=0A=
+		      unsigned int keylen);=0A=
+=0A=
+	unsigned int digestsize;=0A=
+	struct crypto_ahash *base;=0A=
+	unsigned int reqsize;=0A=
+};=0A=
+=0A=
 struct compress_tfm {=0A=
 	int (*cot_compress)(struct crypto_tfm *tfm,=0A=
 	                    const u8 *src, unsigned int slen,=0A=
@@ -404,21 +442,23 @@ struct compress_tfm {=0A=
 #define crt_blkcipher	crt_u.blkcipher=0A=
 #define crt_cipher	crt_u.cipher=0A=
 #define crt_hash	crt_u.hash=0A=
+#define crt_ahash	crt_u.ahash=0A=
 #define crt_compress	crt_u.compress=0A=
 =0A=
 struct crypto_tfm {=0A=
 =0A=
 	u32 crt_flags;=0A=
-	=0A=
+=0A=
 	union {=0A=
 		struct ablkcipher_tfm ablkcipher;=0A=
 		struct aead_tfm aead;=0A=
 		struct blkcipher_tfm blkcipher;=0A=
 		struct cipher_tfm cipher;=0A=
 		struct hash_tfm hash;=0A=
+		struct ahash_tfm ahash;=0A=
 		struct compress_tfm compress;=0A=
 	} crt_u;=0A=
-	=0A=
+=0A=
 	struct crypto_alg *__crt_alg;=0A=
 =0A=
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;=0A=
@@ -448,6 +488,10 @@ struct crypto_hash {=0A=
 	struct crypto_tfm base;=0A=
 };=0A=
 =0A=
+struct crypto_ahash {=0A=
+	struct crypto_tfm base;=0A=
+};=0A=
+=0A=
 enum {=0A=
 	CRYPTOA_UNSPEC,=0A=
 	CRYPTOA_ALG,=0A=
@@ -477,7 +521,7 @@ struct crypto_attr_u32 {=0A=
 /* =0A=
  * Transform user interface.=0A=
  */=0A=
- =0A=
+=0A=
 struct crypto_tfm *crypto_alloc_tfm(const char *alg_name, u32 =
tfm_flags);=0A=
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, =
u32 mask);=0A=
 void crypto_free_tfm(struct crypto_tfm *tfm);=0A=
@@ -1112,7 +1156,7 @@ static inline struct crypto_hash =
*crypto_alloc_hash(const char *alg_name,=0A=
 						    u32 type, u32 mask)=0A=
 {=0A=
 	type &=3D ~CRYPTO_ALG_TYPE_MASK;=0A=
-	mask &=3D ~CRYPTO_ALG_TYPE_MASK;=0A=
+	mask &=3D ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);=0A=
 	type |=3D CRYPTO_ALG_TYPE_HASH;=0A=
 	mask |=3D CRYPTO_ALG_TYPE_HASH_MASK;=0A=
 =0A=
@@ -1271,5 +1315,130 @@ static inline int crypto_comp_decompress(struct =
crypto_comp *tfm,=0A=
 						    src, slen, dst, dlen);=0A=
 }=0A=
 =0A=
+static inline struct crypto_tfm *crypto_ahash_tfm(=0A=
+	struct crypto_ahash *tfm)=0A=
+{=0A=
+	return &tfm->base;=0A=
+}=0A=
+=0A=
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,=0A=
+					u32 type, u32 mask);=0A=
+=0A=
+static inline void crypto_free_ahash(struct crypto_ahash *tfm)=0A=
+{=0A=
+	crypto_free_tfm(crypto_ahash_tfm(tfm));=0A=
+}=0A=
+=0A=
+static inline struct crypto_ahash *__crypto_ahash_cast(struct =
crypto_tfm *tfm)=0A=
+{=0A=
+	return (struct crypto_ahash *) tfm;=0A=
+}=0A=
+=0A=
+static inline unsigned int crypto_ahash_alignmask(=0A=
+	struct crypto_ahash *tfm)=0A=
+{=0A=
+	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));=0A=
+}=0A=
+=0A=
+static inline struct ahash_tfm *crypto_ahash_crt(struct crypto_ahash =
*tfm)=0A=
+{=0A=
+	return &crypto_ahash_tfm(tfm)->crt_ahash;=0A=
+}=0A=
+=0A=
+static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash =
*tfm)=0A=
+{=0A=
+	return crypto_ahash_crt(tfm)->digestsize;=0A=
+}=0A=
+=0A=
+static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)=0A=
+{=0A=
+	return crypto_tfm_get_flags(crypto_ahash_tfm(tfm));=0A=
+}=0A=
+=0A=
+static inline void crypto_ahash_set_flags(struct crypto_ahash *tfm, u32 =
flags)=0A=
+{=0A=
+	crypto_tfm_set_flags(crypto_ahash_tfm(tfm), flags);=0A=
+}=0A=
+=0A=
+static inline void crypto_ahash_clear_flags(struct crypto_ahash *tfm, =
u32 flags)=0A=
+{=0A=
+	crypto_tfm_clear_flags(crypto_ahash_tfm(tfm), flags);=0A=
+}=0A=
+=0A=
+static inline struct crypto_ahash *crypto_ahash_reqtfm(=0A=
+	struct ahash_request *req)=0A=
+{=0A=
+	return __crypto_ahash_cast(req->base.tfm);=0A=
+}=0A=
+=0A=
+static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash =
*tfm)=0A=
+{=0A=
+	return crypto_ahash_crt(tfm)->reqsize;=0A=
+}=0A=
+=0A=
+static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,=0A=
+					const u8 *key, unsigned int keylen)=0A=
+{=0A=
+	struct ahash_tfm *crt =3D crypto_ahash_crt(tfm);=0A=
+=0A=
+	return crt->setkey(crt->base, key, keylen);=0A=
+}=0A=
+=0A=
+static inline int crypto_ahash_digest(struct ahash_request *req)=0A=
+{=0A=
+	struct ahash_tfm *crt =3D crypto_ahash_crt(crypto_ahash_reqtfm(req));=0A=
+	return crt->digest(req);=0A=
+}=0A=
+=0A=
+static inline void ahash_request_set_tfm(=0A=
+	struct ahash_request *req, struct crypto_ahash *tfm)=0A=
+{=0A=
+	req->base.tfm =3D crypto_ahash_tfm(crypto_ahash_crt(tfm)->base);=0A=
+}=0A=
+=0A=
+static inline struct ahash_request *ahash_request_alloc(=0A=
+	struct crypto_ahash *tfm, gfp_t gfp)=0A=
+{=0A=
+	struct ahash_request *req;=0A=
+=0A=
+	req =3D kmalloc(sizeof(struct ahash_request) +=0A=
+		      crypto_ahash_reqsize(tfm), gfp);=0A=
+=0A=
+	if (likely(req))=0A=
+		ahash_request_set_tfm(req, tfm);=0A=
+=0A=
+	return req;=0A=
+}=0A=
+=0A=
+static inline void ahash_request_free(struct ahash_request *req)=0A=
+{=0A=
+	kfree(req);=0A=
+}=0A=
+=0A=
+static inline struct ahash_request *ahash_request_cast(=0A=
+	struct crypto_async_request *req)=0A=
+{=0A=
+	return container_of(req, struct ahash_request, base);=0A=
+}=0A=
+=0A=
+static inline void ahash_request_set_callback(=0A=
+	struct ahash_request *req,=0A=
+	u32 flags, crypto_completion_t complete, void *data)=0A=
+{=0A=
+	req->base.complete =3D complete;=0A=
+	req->base.data =3D data;=0A=
+	req->base.flags =3D flags;=0A=
+}=0A=
+=0A=
+static inline void ahash_request_set_crypt(=0A=
+	struct ahash_request *req,=0A=
+	struct scatterlist *src, u8 * result,=0A=
+	unsigned int nbytes)=0A=
+{=0A=
+	req->src =3D src;=0A=
+	req->nbytes =3D nbytes;=0A=
+	req->result =3D result;=0A=
+}=0A=
+=0A=
 #endif	/* _LINUX_CRYPTO_H */=0A=
 =0A=

------=_NextPart_000_0047_01C85E8A.1091FD80--
