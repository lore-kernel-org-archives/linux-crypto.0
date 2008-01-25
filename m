From: "Loc Ho" <locnho@sbcglobal.net>
Subject: [PATCH 1/1] CryptoAPI: Add Async Hash Support
Date: Thu, 24 Jan 2008 18:45:25 -0800
Message-ID: <004a01c85efc$56f2ee70$5c05420a@amcc.com>
References: <E1IrkmY-0007gp-00@gondolin.me.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603EB866F@SDCEXCHANGE01.ad.amcc.com> <20071225073202.GA31076@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D603FCC15D@SDCEXCHANGE01.ad.amcc.com> <20080117112314.GC9020@gondor.apana.org.au> <001c01c85937$ff3313f0$5c05420a@amcc.com> <20080117202735.GA22733@Chamillionaire.breakpoint.cc> <0CA0A16855646F4FA96D25A158E299D603FCC4D7@SDCEXCHANGE01.ad.amcc.com> <20080118230721.GA30470@Chamillionaire.breakpoint.cc> <002301c85c96$32a67a40$5c05420a@amcc.com> <20080122231818.GB6920@Chamillionaire.breakpoint.cc> <002d01c85d66$11e1d7c0$5c05420a@amcc.com> <004601c85ecd$1eb53d80$5c05420a@amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	"'Sebastian Siewior'" <linux-crypto@ml.breakpoint.cc>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:41642 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751770AbYAYCpY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jan 2008 21:45:24 -0500
In-Reply-To: <004601c85ecd$1eb53d80$5c05420a@amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom e5d67c3670f1ec15339a92cc291027c0a059aaed Mon Sep 17 00:00:00 200=
1
=46rom: Loc Ho <lho@amcc.com>
Date: Thu, 24 Jan 2008 18:13:28 -0800
Subject: [PATCH] Add Async Hash Support

---
 crypto/Makefile               |    1 +
 crypto/ahash.c                |  151 +++++++++++++++++
 crypto/algapi.c               |    2 +-
 crypto/api.c                  |    2 +-
 crypto/cryptd.c               |  220 +++++++++++++++++++++++++
 crypto/digest.c               |    4 +-
 crypto/hash.c                 |  102 +++++++++++-
 crypto/tcrypt.c               |  142 ++++++++++++++++-
 drivers/crypto/Kconfig        |    8 +-
 drivers/crypto/Makefile       |    1 +
 drivers/crypto/ahash_sample.c |  354
+++++++++++++++++++++++++++++++++++++++++
 include/crypto/algapi.h       |   36 ++++
 include/linux/crypto.h        |  183 ++++++++++++++++++++-
 13 files changed, 1183 insertions(+), 23 deletions(-)
 create mode 100644 crypto/ahash.c
 create mode 100644 drivers/crypto/ahash_sample.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 48c7583..a9c3d09 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_CRYPTO_BLKCIPHER) +=3D eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) +=3D seqiv.o
=20
 crypto_hash-objs :=3D hash.o
+crypto_hash-objs +=3D ahash.o
 obj-$(CONFIG_CRYPTO_HASH) +=3D crypto_hash.o
=20
 obj-$(CONFIG_CRYPTO_MANAGER) +=3D cryptomgr.o
diff --git a/crypto/ahash.c b/crypto/ahash.c
new file mode 100644
index 0000000..e9bf72f
--- /dev/null
+++ b/crypto/ahash.c
@@ -0,0 +1,151 @@
+/*
+ * Asynchronous Cryptographic Hash operations.
+ *
+ * This is the asynchronous version of hash.c with notification of
+ * completion via a callback.
+ *
+ * Copyright (c) 2008 Loc Ho <lho@amcc.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by t=
he
=46ree
+ * Software Foundation; either version 2 of the License, or (at your
option)
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
+static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *=
key,
+				unsigned int keylen)
+{
+	struct ahash_alg *ahash =3D crypto_ahash_alg(tfm);
+	unsigned long alignmask =3D crypto_ahash_alignmask(tfm);
+	int ret;
+	u8 *buffer, *alignbuffer;
+	unsigned long absize;
+
+	absize =3D keylen + alignmask;
+	buffer =3D kmalloc(absize, GFP_ATOMIC);
+	if (!buffer)
+		return -ENOMEM;
+
+	alignbuffer =3D (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
+	memcpy(alignbuffer, key, keylen);
+	ret =3D ahash->setkey(tfm, alignbuffer, keylen);
+	memset(alignbuffer, 0, keylen);
+	kfree(buffer);
+	return ret;
+}
+
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct ahash_alg *ahash =3D crypto_ahash_alg(tfm);
+	unsigned long alignmask =3D crypto_ahash_alignmask(tfm);
+
+	if ((unsigned long)key & alignmask)
+		return ahash_setkey_unaligned(tfm, key, keylen);
+
+	return ahash->setkey(tfm, key, keylen);
+}
+
+static unsigned int crypto_ahash_ctxsize(struct crypto_alg *alg, u32 t=
ype,
+					u32 mask)
+{
+	return alg->cra_ctxsize;
+}
+
+static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32
mask)
+{
+	struct ahash_alg *alg =3D &tfm->__crt_alg->cra_ahash;
+	struct ahash_tfm *crt   =3D &tfm->crt_ahash;
+
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	crt->init =3D alg->init;
+	crt->update =3D alg->update;
+	crt->final  =3D alg->final;
+	crt->digest =3D alg->digest;
+	crt->setkey =3D ahash_setkey;
+	crt->base   =3D __crypto_ahash_cast(tfm);
+	crt->digestsize =3D alg->digestsize;
+
+	return 0;
+}
+
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *a=
lg)
+	__attribute__ ((unused));
+static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *a=
lg)
+{
+	seq_printf(m, "type         : hash\n");
+	seq_printf(m, "async        : %s\n", alg->cra_flags &
CRYPTO_ALG_ASYNC ?
+					     "yes" : "no");
+	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
+	seq_printf(m, "digestsize   : %u\n", alg->cra_hash.digestsize);
+}
+
+const struct crypto_type crypto_ahash_type =3D {
+	.ctxsize =3D crypto_ahash_ctxsize,
+	.init =3D crypto_init_ahash_ops,
+#ifdef CONFIG_PROC_FS
+	.show =3D crypto_ahash_show,
+#endif
+};
+EXPORT_SYMBOL_GPL(crypto_ahash_type);
+
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask)
+{
+	struct crypto_tfm *tfm;
+	int err;
+
+	mask &=3D ~CRYPTO_ALG_TYPE_MASK;
+	mask |=3D CRYPTO_ALG_TYPE_HASH_MASK;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		type &=3D ~CRYPTO_ALG_TYPE_MASK;
+		type |=3D CRYPTO_ALG_TYPE_AHASH;
+		alg =3D crypto_alg_mod_lookup(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			type &=3D ~CRYPTO_ALG_TYPE_MASK;
+			type |=3D CRYPTO_ALG_TYPE_HASH;
+			alg =3D crypto_alg_mod_lookup(alg_name, type, mask);
+			if (IS_ERR(alg)) {
+				err =3D PTR_ERR(alg);
+				goto err;
+			}
+		}
+
+		tfm =3D __crypto_alloc_tfm(alg, type, mask |
CRYPTO_ALG_ASYNC);
+		if (!IS_ERR(tfm))
+			return __crypto_ahash_cast(tfm);
+
+		crypto_mod_put(alg);
+		err =3D PTR_ERR(tfm);
+
+err:
+		if (err !=3D -EAGAIN)
+			break;
+		if (signal_pending(current)) {
+			err =3D -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_ahash);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/algapi.c b/crypto/algapi.c
index e65cb50..5fdb974 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -182,7 +182,7 @@ static int __crypto_register_alg(struct crypto_alg =
*alg,
=20
 		crypto_remove_spawns(&q->cra_users, list, alg->cra_flags);
 	}
-=09
+
 	list_add(&alg->cra_list, &crypto_alg_list);
=20
 	crypto_notify(CRYPTO_MSG_ALG_REGISTER, alg);
diff --git a/crypto/api.c b/crypto/api.c
index a2496d1..c3213f4 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -10,7 +10,7 @@
  *
  * This program is free software; you can redistribute it and/or modif=
y it
  * under the terms of the GNU General Public License as published by t=
he
=46ree
- * Software Foundation; either version 2 of the License, or (at your
option)=20
+ * Software Foundation; either version 2 of the License, or (at your
option)
  * any later version.
  *
  */
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 074298f..cdf57c8 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -45,6 +45,14 @@ struct cryptd_blkcipher_request_ctx {
 	crypto_completion_t complete;
 };
=20
+struct cryptd_hash_ctx {
+	struct crypto_hash *child;
+};
+
+struct cryptd_hash_request_ctx {
+	crypto_completion_t complete;
+	struct hash_desc    desc;
+};
=20
 static inline struct cryptd_state *cryptd_get_state(struct crypto_tfm =
*tfm)
 {
@@ -259,6 +267,216 @@ out_put_alg:
 	return inst;
 }
=20
+static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst =3D crypto_tfm_alg_instance(tfm);
+	struct cryptd_instance_ctx *ictx =3D crypto_instance_ctx(inst);
+	struct crypto_spawn *spawn =3D &ictx->spawn;
+	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	struct crypto_hash *cipher;
+
+	cipher =3D crypto_spawn_hash(spawn);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child =3D cipher;
+	tfm->crt_ahash.reqsize =3D
+		sizeof(struct cryptd_hash_request_ctx);
+	return 0;
+}
+
+static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	struct cryptd_state *state =3D cryptd_get_state(tfm);
+	int active;
+
+	mutex_lock(&state->mutex);
+	active =3D ahash_tfm_in_queue(&state->queue,
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
+	struct cryptd_hash_ctx *ctx   =3D crypto_ahash_ctx(parent);
+	struct crypto_hash     *child =3D ctx->child;
+	int err;
+
+	crypto_hash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_hash_set_flags(child, crypto_ahash_get_flags(parent) &
+					  CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_hash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_hash_get_flags(child) &
+					    CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int cryptd_hash_init(struct ahash_request *req)
+{
+	struct cryptd_hash_ctx *ctx   =3D ahash_request_ctx(req);
+	struct crypto_hash     *child =3D ctx->child;
+	struct cryptd_hash_request_ctx *rctx =3D ahash_request_ctx(req);
+	int err;
+
+	err =3D crypto_hash_crt(child)->init(&rctx->desc);
+	rctx->desc.flags |=3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	return err;
+}
+
+static int cryptd_hash_enqueue(struct ahash_request *req,
+				crypto_completion_t complete)
+{
+	struct cryptd_hash_request_ctx *rctx =3D ahash_request_ctx(req);
+	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
+	struct cryptd_state *state =3D
+		cryptd_get_state(crypto_ahash_tfm(tfm));
+	int err;
+
+	rctx->complete =3D req->base.complete;
+	req->base.complete =3D complete;
+
+	spin_lock_bh(&state->lock);
+	err =3D ahash_enqueue_request(&state->queue, req);
+	spin_unlock_bh(&state->lock);
+
+	wake_up_process(state->task);
+	return err;
+}
+
+static void cryptd_hash_update(struct crypto_async_request *req_async,=
 int
err)
+{
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child =3D ctx->child;
+	struct ahash_request    *req =3D ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+
+	rctx =3D ahash_request_ctx(req);
+
+	if (unlikely(err =3D=3D -EINPROGRESS)) {
+		rctx->complete(&req->base, err);
+		return;
+	}
+
+	err =3D crypto_hash_crt(child)->update(&rctx->desc,
+						req->src,
+						req->nbytes);
+
+	req->base.complete =3D rctx->complete;
+
+	local_bh_disable();
+	req->base.complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_update_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_update);
+}
+
+static void cryptd_hash_final(struct crypto_async_request *req_async, =
int
err)
+{
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child =3D ctx->child;
+	struct ahash_request    *req =3D ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+
+	rctx =3D ahash_request_ctx(req);
+
+	if (unlikely(err =3D=3D -EINPROGRESS)) {
+		rctx->complete(&req->base, err);
+		return;
+	}
+
+	err =3D crypto_hash_crt(child)->final(&rctx->desc, req->result);
+
+	req->base.complete =3D rctx->complete;
+
+	local_bh_disable();
+	req->base.complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int cryptd_hash_final_enqueue(struct ahash_request *req)
+{
+	return cryptd_hash_enqueue(req, cryptd_hash_final);
+}
+
+static void cryptd_hash_digest(struct crypto_async_request *req_async,=
 int
err)
+{
+	struct cryptd_hash_ctx *ctx   =3D crypto_tfm_ctx(req_async->tfm);
+	struct crypto_hash     *child =3D ctx->child;
+	struct ahash_request    *req =3D ahash_request_cast(req_async);
+	struct cryptd_hash_request_ctx *rctx;
+	struct hash_desc desc;
+
+	rctx =3D ahash_request_ctx(req);
+
+	if (unlikely(err =3D=3D -EINPROGRESS)) {
+		rctx->complete(&req->base, err);
+		return;
+	}
+
+	desc.tfm =3D child;
+	desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err =3D crypto_hash_crt(child)->digest(&desc,
+						req->src,
+						req->nbytes,
+						req->result);
+
+	req->base.complete =3D rctx->complete;
+
+	local_bh_disable();
+	req->base.complete(&req->base, err);
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
+	alg =3D crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(alg))
+		return ERR_PTR(PTR_ERR(alg));
+
+	inst =3D cryptd_alloc_instance(alg, state);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	inst->alg.cra_flags =3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_type =3D &crypto_ahash_type;
+
+	inst->alg.cra_ahash.digestsize =3D alg->cra_hash.digestsize;
+	inst->alg.cra_ctxsize =3D sizeof(struct cryptd_hash_ctx);
+
+	inst->alg.cra_init =3D cryptd_hash_init_tfm;
+	inst->alg.cra_exit =3D cryptd_hash_exit_tfm;
+
+	inst->alg.cra_ahash.init   =3D cryptd_hash_init;
+	inst->alg.cra_ahash.update =3D cryptd_hash_update_enqueue;
+	inst->alg.cra_ahash.final  =3D cryptd_hash_final_enqueue;
+	inst->alg.cra_ahash.setkey =3D cryptd_hash_setkey;
+	inst->alg.cra_ahash.digest =3D cryptd_hash_digest_enqueue;
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return inst;
+}
+
 static struct cryptd_state state;
=20
 static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
@@ -272,6 +490,8 @@ static struct crypto_instance *cryptd_alloc(struct
rtattr **tb)
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
 		return cryptd_alloc_blkcipher(tb, &state);
+	case CRYPTO_ALG_TYPE_HASH:
+		return cryptd_alloc_hash(tb, &state);
 	}
=20
 	return ERR_PTR(-EINVAL);
diff --git a/crypto/digest.c b/crypto/digest.c
index 6fd43bd..19b7ade 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -141,14 +141,14 @@ int crypto_init_digest_ops(struct crypto_tfm *tfm=
)
=20
 	if (dalg->dia_digestsize > crypto_tfm_alg_blocksize(tfm))
 		return -EINVAL;
-=09
+
 	ops->init	=3D init;
 	ops->update	=3D update;
 	ops->final	=3D final;
 	ops->digest	=3D digest;
 	ops->setkey	=3D dalg->dia_setkey ? setkey : nosetkey;
 	ops->digestsize	=3D dalg->dia_digestsize;
-=09
+
 	return 0;
 }
=20
diff --git a/crypto/hash.c b/crypto/hash.c
index 7dcff67..6df8a8c 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -59,24 +59,108 @@ static int hash_setkey(struct crypto_hash *crt, co=
nst
u8 *key,
 	return alg->setkey(crt, key, keylen);
 }
=20
-static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 =
mask)
+static int hash_async_setkey(struct crypto_ahash *tfm_async, const u8 =
*key,
+			unsigned int keylen)
+{
+	struct crypto_tfm  *tfm      =3D crypto_ahash_tfm(tfm_async);
+	struct crypto_hash *tfm_hash =3D __crypto_hash_cast(tfm);
+	struct hash_alg    *alg      =3D &tfm->__crt_alg->cra_hash;
+
+	return alg->setkey(tfm_hash, key, keylen);
+}
+
+static int hash_async_init(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm =3D req->base.tfm;
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc =3D {
+		.tfm =3D __crypto_hash_cast(tfm),
+		.flags =3D req->base.flags,
+	};
+
+	return alg->init(&desc);
+}
+
+static int hash_async_update(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm =3D req->base.tfm;
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc =3D {
+		.tfm =3D __crypto_hash_cast(tfm),
+		.flags =3D req->base.flags,
+	};
+
+	return alg->update(&desc, req->src, req->nbytes);
+}
+
+static int hash_async_final(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm =3D req->base.tfm;
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc =3D {
+		.tfm =3D __crypto_hash_cast(tfm),
+		.flags =3D req->base.flags,
+	};
+
+	return alg->final(&desc, req->result);
+}
+
+static int hash_async_digest(struct ahash_request *req)
+{
+	struct crypto_tfm *tfm =3D req->base.tfm;
+	struct hash_alg   *alg =3D &tfm->__crt_alg->cra_hash;
+	struct hash_desc  desc =3D {
+		.tfm =3D __crypto_hash_cast(tfm),
+		.flags =3D req->base.flags,
+	};
+
+	return alg->digest(&desc, req->src, req->nbytes, req->result);
+}
+
+static int crypto_init_hash_ops_async(struct crypto_tfm *tfm)
+{
+	struct ahash_tfm *crt =3D &tfm->crt_ahash;
+	struct hash_alg  *alg =3D &tfm->__crt_alg->cra_hash;
+
+	crt->init       =3D hash_async_init;
+	crt->update     =3D hash_async_update;
+	crt->final      =3D hash_async_final;
+	crt->digest     =3D hash_async_digest;
+	crt->setkey     =3D hash_async_setkey;
+	crt->digestsize =3D alg->digestsize;
+	crt->base       =3D __crypto_ahash_cast(tfm);
+
+	return 0;
+}
+
+static int crypto_init_hash_ops_sync(struct crypto_tfm *tfm)
 {
 	struct hash_tfm *crt =3D &tfm->crt_hash;
 	struct hash_alg *alg =3D &tfm->__crt_alg->cra_hash;
=20
-	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
-		return -EINVAL;
-
-	crt->init =3D alg->init;
-	crt->update =3D alg->update;
-	crt->final =3D alg->final;
-	crt->digest =3D alg->digest;
-	crt->setkey =3D hash_setkey;
+	crt->init       =3D alg->init;
+	crt->update     =3D alg->update;
+	crt->final      =3D alg->final;
+	crt->digest     =3D alg->digest;
+	crt->setkey     =3D hash_setkey;
 	crt->digestsize =3D alg->digestsize;
=20
 	return 0;
 }
=20
+static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 =
mask)
+{
+	struct hash_alg *alg =3D &tfm->__crt_alg->cra_hash;
+
+	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+		return -EINVAL;
+
+	if (mask & CRYPTO_ALG_ASYNC)
+		return crypto_init_hash_ops_async(tfm);
+	else
+		return crypto_init_hash_ops_sync(tfm);
+}
+
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *al=
g)
 	__attribute__ ((unused));
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *al=
g)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..784f0b5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -35,6 +35,7 @@
 #include <linux/jiffies.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
+#include <linux/delay.h>
 #include "tcrypt.h"
=20
 /*
@@ -220,6 +221,98 @@ out:
 	crypto_free_hash(tfm);
 }
=20
+static void test_ahash(char *algo, struct hash_testvec *template,
+		      unsigned int tcount)
+{
+	struct hash_testvec  *hash_tv;
+	struct crypto_ahash  *tfm =3D NULL;
+	struct ahash_request *req =3D NULL;
+	struct tcrypt_result result;
+	struct scatterlist   sg[8];
+	char 		digest_result[tcount][4*16];
+	unsigned int 	tsize;
+	unsigned int 	i;
+	int 		ret;
+
+	printk(KERN_INFO "\ntesting %s\n", algo);
+
+	tsize =3D sizeof(struct hash_testvec);
+	tsize *=3D tcount;
+	if (tsize > TVMEMSIZE) {
+		printk(KERN_ERR "template (%u) too big for tvmem (%u)\n",
+			tsize, TVMEMSIZE);
+		return;
+	}
+	memcpy(tvmem, template, tsize);
+	hash_tv =3D (void *)tvmem;
+
+	init_completion(&result.completion);
+
+	tfm =3D crypto_alloc_ahash(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		printk(KERN_ERR "failed to load transform for %s: %ld\n",
algo,
+		       PTR_ERR(tfm));
+		return;
+	}
+	req =3D ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_ERR "failed to allocate request for %s\n",
algo);
+		goto out;
+	}
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				tcrypt_complete, &result);
+
+	for (i =3D 0; i < tcount; i++) {
+		printk(KERN_INFO "test %u:\n", i + 1);
+		memset(&digest_result[i], 0, 4*16);
+		crypto_ahash_clear_flags(tfm, ~0);
+		if (hash_tv[i].ksize) {
+			ret =3D crypto_ahash_setkey(tfm, hash_tv[i].key,
+						 hash_tv[i].ksize);
+			if (ret) {
+				printk(KERN_ERR "setkey() failed error
%d\n",
+					ret);
+				goto out;
+			}
+		}
+
+		sg_init_one(&sg[0], hash_tv[i].plaintext, hash_tv[i].psize);
+
+		ahash_request_set_crypt(req, sg, digest_result[i],
+					hash_tv[i].psize);
+
+		ret =3D crypto_ahash_digest(req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret =3D wait_for_completion_interruptible(
+				&result.completion);
+			if (!ret && !((ret =3D result.err))) {
+				INIT_COMPLETION(result.completion);
+				break;
+			}
+			/* fall through */
+		default:
+			printk(KERN_ERR "hash() failed error %d\n", ret);
+			goto out;
+		}
+
+		hexdump(digest_result[i], crypto_ahash_digestsize(tfm));
+		printk(KERN_INFO "%s\n",
+		       memcmp(digest_result[i], hash_tv[i].digest,
+			      crypto_ahash_digestsize(tfm)) ?
+		       "fail" : "pass");
+	}
+
+out:
+	if (req)
+		ahash_request_free(req);
+
+	crypto_free_ahash(tfm);
+}
+
 static void test_aead(char *algo, int enc, struct aead_testvec *templa=
te,
 		      unsigned int tcount)
 {
@@ -471,7 +564,7 @@ static void test_cipher(char *algo, int enc,
 	else
 		e =3D "decryption";
=20
-	printk("\ntesting %s %s\n", algo, e);
+	printk(KERN_INFO "\ntesting cipher %s %s\n", algo, e);
=20
 	tsize =3D sizeof (struct cipher_testvec);
 	if (tsize > TVMEMSIZE) {
@@ -1619,6 +1712,51 @@ static void do_test(void)
 			  XCBC_AES_TEST_VECTORS);
 		break;
=20
+	case 110:
+		test_ahash("hmac(md5)", hmac_md5_tv_template,
+			  HMAC_MD5_TEST_VECTORS);
+		break;
+
+	case 111:
+		test_ahash("hmac(sha1)", hmac_sha1_tv_template,
+			  HMAC_SHA1_TEST_VECTORS);
+		break;
+
+	case 112:
+		test_ahash("hmac(sha256)", hmac_sha256_tv_template,
+			  HMAC_SHA256_TEST_VECTORS);
+		break;
+
+	case 113:
+		test_ahash("hmac(sha384)", hmac_sha384_tv_template,
+			  HMAC_SHA384_TEST_VECTORS);
+		break;
+
+	case 114:
+		test_ahash("hmac(sha512)", hmac_sha512_tv_template,
+			  HMAC_SHA512_TEST_VECTORS);
+		break;
+
+	case 115:
+		test_ahash("hmac(sha224)", hmac_sha224_tv_template,
+			  HMAC_SHA224_TEST_VECTORS);
+		break;
+
+	case 120:
+		test_ahash("hmac(md5)", hmac_md5_tv_template,
+			  HMAC_MD5_TEST_VECTORS);
+		test_ahash("hmac(sha1)", hmac_sha1_tv_template,
+			  HMAC_SHA1_TEST_VECTORS);
+		test_ahash("hmac(sha224)", hmac_sha224_tv_template,
+			  HMAC_SHA224_TEST_VECTORS);
+		test_ahash("hmac(sha256)", hmac_sha256_tv_template,
+			  HMAC_SHA256_TEST_VECTORS);
+		test_ahash("hmac(sha384)", hmac_sha384_tv_template,
+			  HMAC_SHA384_TEST_VECTORS);
+		test_ahash("hmac(sha512)", hmac_sha512_tv_template,
+			  HMAC_SHA512_TEST_VECTORS);
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				  aes_speed_template);
@@ -1795,7 +1933,7 @@ static int __init init(void)
=20
 	/* We intentionaly return -EAGAIN to prevent keeping
 	 * the module. It does all its work from init()
-	 * and doesn't offer any runtime functionality=20
+	 * and doesn't offer any runtime functionality
 	 * =3D> we don't need it in the memory, do we?
 	 *                                        -- mludvig
 	 */
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d8c7040..21e4234 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -92,6 +92,12 @@ config CRYPTO_DEV_HIFN_795X
 	help
 	  This option allows you to have support for HIFN 795x crypto
adapters.
=20
-
+config CRYPTO_DEV_AHASH_SAMPLE
+	tristate "Asynchronous HASH sample driver over software synchronous
HASH"
+	select CRYPTO_HASH
+	select CRYPTO_ALGAPI
+	help
+	  This is a sample asynchronous HASH device driver over synchronous
software
+          HASH.
=20
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c0327f0..0b1cc2f 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) +=3D padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) +=3D padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) +=3D geode-aes.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) +=3D hifn_795x.o
+obj-$(CONFIG_CRYPTO_DEV_AHASH_SAMPLE) +=3D ahash_sample.o
diff --git a/drivers/crypto/ahash_sample.c b/drivers/crypto/ahash_sampl=
e.c
new file mode 100644
index 0000000..0c1ad60
--- /dev/null
+++ b/drivers/crypto/ahash_sample.c
@@ -0,0 +1,354 @@
+/*
+ * Sample Asynchronous device driver that wraps around software sync H=
ASH
+ *
+ * 2008 Copyright (c) Loc Ho <lho@amcc.com>
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7
USA
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mod_devicetable.h>
+#include <linux/interrupt.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+
+struct ahash_sample_device {
+	char			name[64];
+	struct tasklet_struct	tasklet;
+	struct crypto_queue 	queue;
+	spinlock_t		lock;		/**< Queue lock protection
*/
+	struct list_head	alg_list;
+};
+
+#define AHASH_SAMPLE_OP_DIGEST	0
+#define AHASH_SAMPLE_OP_UPDATE	1
+#define AHASH_SAMPLE_OP_FINAL	2
+
+struct ahash_sample_context {
+	struct ahash_sample_device *dev;
+	u8			key[16];
+	unsigned int		keysize;
+	struct crypto_hash 	*sync_tfm;
+	struct hash_desc 	desc;
+	u8	ops;
+};
+
+struct ahash_sample_alg {
+	struct list_head    	entry;
+	struct crypto_alg   	alg;
+	struct ahash_sample_device *dev;
+};
+
+static struct ahash_sample_device *ahash_sample_dev;
+
+#define crypto_alg_to_ahash_sample_alg(a)	container_of(a, \
+						struct ahash_sample_alg, \
+						alg)
+
+static int ahash_sample_alg_init(struct crypto_tfm *tfm)
+{
+	struct crypto_alg    *alg          =3D tfm->__crt_alg;
+	struct ahash_sample_alg *ahash_alg =3D crypto_alg_to_ahash_sample_alg=
(
+
alg);
+	struct ahash_sample_context *ctx   =3D crypto_tfm_ctx(tfm);
+
+	ctx->dev      =3D ahash_alg->dev;
+	ctx->sync_tfm =3D crypto_alloc_hash(alg->cra_name, 0,
CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->sync_tfm)) {
+		printk(KERN_ERR
+			"AHASH_SAMPLE: failed to load transform for %s:
%ld\n",
+			alg->cra_name, PTR_ERR(ctx->sync_tfm));
+		return -ENOMEM;
+	}
+	printk(KERN_INFO "AHASH_SAMPLE: initialize alg %s\n",
alg->cra_name);
+	return 0;
+}
+
+static void ahash_sample_alg_exit(struct crypto_tfm *tfm)
+{
+	struct crypto_alg           *alg =3D tfm->__crt_alg;
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(tfm);
+
+	printk(KERN_INFO "AHASH_SAMPLE: exit alg %s\n", alg->cra_name);
+
+	if (ctx->sync_tfm) {
+		crypto_free_hash(ctx->sync_tfm);
+		ctx->sync_tfm =3D NULL;
+		ctx->dev      =3D NULL;
+	}
+}
+
+static int ahash_sample_ops_setkey(struct crypto_ahash *cipher, const =
u8
*key,
+			unsigned int keylen)
+{
+	struct crypto_tfm           *tfm =3D crypto_ahash_tfm(cipher);
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(tfm);
+	int    ret;
+
+	printk(KERN_INFO "AHASH_SAMPLE: setkey\n");
+
+	ret =3D crypto_hash_setkey(ctx->sync_tfm, key, keylen);
+	if (ret) {
+		printk(KERN_ERR
+			"aynchronous hash generic setkey failed error %d\n",
+			ret);
+		return -1;
+	}
+	return ret;
+}
+
+static inline int ahash_sample_ops_init(struct ahash_request *req)
+{
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);
+
+	printk(KERN_INFO "AHASH_SAMPLE: init\n");
+
+	ctx->desc.tfm   =3D ctx->sync_tfm;
+	ctx->desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
+	return crypto_hash_init(&ctx->desc);
+}
+
+static inline int ahash_sample_ops_update(struct ahash_request *req)
+{
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	unsigned long flags;
+	int ret;
+
+	printk(KERN_INFO "AHASH_SAMPLE: update\n");
+
+	ctx->ops =3D AHASH_SAMPLE_OP_UPDATE;
+	spin_lock_irqsave(&ctx->dev->lock, flags);
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);
+
+	tasklet_schedule(&ctx->dev->tasklet);
+	return ret;
+}
+
+static inline int ahash_sample_ops_final(struct ahash_request *req)
+{
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	unsigned long flags;
+	int ret;
+
+	printk(KERN_INFO "AHASH_SAMPLE: final\n");
+
+	ctx->ops =3D AHASH_SAMPLE_OP_FINAL;
+	spin_lock_irqsave(&ctx->dev->lock, flags);
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);
+
+	tasklet_schedule(&ctx->dev->tasklet);
+	return ret;
+}
+
+static inline int ahash_sample_ops_digest(struct ahash_request *req)
+{
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	unsigned long flags;
+	int ret;
+
+	printk(KERN_INFO "AHASH_SAMPLE: digest\n");
+
+	ctx->ops =3D AHASH_SAMPLE_OP_DIGEST;
+	spin_lock_irqsave(&ctx->dev->lock, flags);
+	ret =3D ahash_enqueue_request(&ctx->dev->queue, req);
+	spin_unlock_irqrestore(&ctx->dev->lock, flags);
+
+	tasklet_schedule(&ctx->dev->tasklet);
+	return ret;
+}
+
+static int ahash_sample_handle_req(struct ahash_request *req)
+{
+	struct ahash_sample_context *ctx =3D crypto_tfm_ctx(req->base.tfm);
+	struct hash_desc desc;
+	int    ret;
+
+	desc.tfm   =3D ctx->sync_tfm;
+	desc.flags =3D 0;
+	switch (ctx->ops) {
+	case AHASH_SAMPLE_OP_UPDATE:
+		ret =3D crypto_hash_update(&desc, req->src, req->nbytes);
+		break;
+	case AHASH_SAMPLE_OP_FINAL:
+		ret =3D crypto_hash_final(&desc, req->result);
+		break;
+	case AHASH_SAMPLE_OP_DIGEST:
+	default:
+		ret =3D crypto_hash_digest(&desc, req->src,
+					req->nbytes, req->result);
+		break;
+	}
+	if (ret) {
+		printk(KERN_ERR "AHASH_SAMPLE: "
+			"asynchronous hash generic digest failed error
%d\n",
+			ret);
+		return ret;
+	}
+	return 0;
+}
+
+static void ahash_sample_bh_tasklet_cb(unsigned long data)
+{
+	struct ahash_sample_device  *dev =3D (struct ahash_sample_device *)
data;
+	struct crypto_async_request *async_req;
+	struct ahash_sample_context *ctx;
+	struct ahash_request        *req;
+	unsigned long 	flags;
+	int 		err;
+
+	while (1) {
+		spin_lock_irqsave(&dev->lock, flags);
+		async_req =3D crypto_dequeue_request(&dev->queue);
+		spin_unlock_irqrestore(&dev->lock, flags);
+
+		if (!async_req)
+			break;
+
+		ctx =3D crypto_tfm_ctx(async_req->tfm);
+		req =3D container_of(async_req, struct ahash_request, base);
+
+		/* Process the request */
+		err =3D ahash_sample_handle_req(req);
+
+		/* Notify packet completed */
+		req->base.complete(&req->base, err);
+	}
+}
+
+static struct crypto_alg ahash_sample_alg_tbl[] =3D
+{
+	{ .cra_name		=3D "hmac(md5)",
+	  .cra_driver_name	=3D "ahash-md5",
+	  .cra_priority		=3D 300,
+	  .cra_flags		=3D CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+	  .cra_blocksize	=3D 64, /* MD5-HMAC block size is 512-bits */
+	  .cra_ctxsize		=3D sizeof(struct ahash_sample_context),
+	  .cra_alignmask 	=3D 0,
+	  .cra_type		=3D &crypto_ahash_type,
+	  .cra_module		=3D THIS_MODULE,
+	  .cra_u		=3D { .ahash =3D {
+	  .digestsize		=3D 16, /* Disgest is 128-bits */
+	  .init   		=3D ahash_sample_ops_init,
+	  .update   		=3D ahash_sample_ops_update,
+	  .final   		=3D ahash_sample_ops_final,
+	  .digest 		=3D ahash_sample_ops_digest,
+	  .setkey		=3D ahash_sample_ops_setkey,
+	  } },
+	},
+	{ .cra_name		=3D "" }
+};
+
+static void ahash_sample_unregister_alg(struct ahash_sample_device *de=
v)
+{
+	struct ahash_sample_alg *alg, *tmp;
+
+	list_for_each_entry_safe(alg, tmp, &dev->alg_list, entry) {
+		list_del(&alg->entry);
+		crypto_unregister_alg(&alg->alg);
+		kfree(alg);
+	}
+}
+
+static int ahash_sample_register_alg(struct ahash_sample_device *dev)
+{
+	struct ahash_sample_alg *alg;
+	int i;
+	int rc =3D 0;
+
+	for (i =3D 0; ahash_sample_alg_tbl[i].cra_name[0] !=3D '\0'; i++) {
+		alg =3D kzalloc(sizeof(struct ahash_sample_alg), GFP_KERNEL);
+		if (!alg)
+			return -ENOMEM;
+
+		alg->alg 		=3D ahash_sample_alg_tbl[i];
+		INIT_LIST_HEAD(&alg->alg.cra_list);
+		alg->dev 		=3D dev;
+		alg->alg.cra_init	=3D ahash_sample_alg_init;
+		alg->alg.cra_exit	=3D ahash_sample_alg_exit;
+		list_add_tail(&alg->entry, &dev->alg_list);
+		rc =3D crypto_register_alg(&alg->alg);
+		if (rc) {
+			printk(KERN_ERR
+				"AHASH_SAMPLE: failed to register alg
%s.%s",
+				ahash_sample_alg_tbl[i].cra_driver_name,
+				ahash_sample_alg_tbl[i].cra_name);
+
+			list_del(&alg->entry);
+			kfree(alg);
+			return rc;
+		}
+	}
+	return rc;
+}
+
+static int __devinit ahash_sample_init(void)
+{
+	int err;
+
+	ahash_sample_dev =3D kzalloc(sizeof(struct ahash_sample_device) +
+				sizeof(struct crypto_alg),
+				GFP_KERNEL);
+	if (!ahash_sample_dev) {
+		err =3D -ENOMEM;
+		goto err_nomem;
+	}
+
+	INIT_LIST_HEAD(&ahash_sample_dev->alg_list);
+	strncpy(ahash_sample_dev->name, "AHASH_generic",
+		sizeof(ahash_sample_dev->name));
+
+	err =3D ahash_sample_register_alg(ahash_sample_dev);
+	if (err)
+		goto err_register_alg;
+
+	/* Init tasklet for asynchronous processing */
+	tasklet_init(&ahash_sample_dev->tasklet, ahash_sample_bh_tasklet_cb,
+		(unsigned long) ahash_sample_dev);
+	crypto_init_queue(&ahash_sample_dev->queue, 64*1024);
+
+	printk(KERN_INFO "AHASH_SAMPLE: Asynchronous "
+		"hashing sample driver successfully registered.\n");
+	return 0;
+
+err_register_alg:
+	kfree(ahash_sample_dev);
+	ahash_sample_dev =3D NULL;
+
+err_nomem:
+	return err;
+}
+
+static void __devexit ahash_sample_fini(void)
+{
+	ahash_sample_unregister_alg(ahash_sample_dev);
+	kfree(ahash_sample_dev);
+	ahash_sample_dev =3D NULL;
+	printk(KERN_INFO
+		"AHASH_SAMPLE: Driver for testing asynchronous hash support
"
+		"framework has been successfully unregistered.\n");
+}
+
+module_init(ahash_sample_init);
+module_exit(ahash_sample_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Loc Ho <lho@amcc.com>");
+MODULE_DESCRIPTION("Sample asynchronous hash driver");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 60d06e7..fef272a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -98,6 +98,7 @@ extern const struct crypto_type crypto_ablkcipher_typ=
e;
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_blkcipher_type;
 extern const struct crypto_type crypto_hash_type;
+extern const struct crypto_type crypto_ahash_type;
=20
 void crypto_mod_put(struct crypto_alg *alg);
=20
@@ -314,5 +315,40 @@ static inline int crypto_requires_sync(u32 type, u=
32
mask)
 	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
 }
=20
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
=20
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 5e02d1b..fe9a5c2 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -7,10 +7,10 @@
  *
  * Portions derived from Cryptoapi, by Alexander Kjeldaas <astor@fast.=
no>
  * and Nettle, by Niels M=C3=B6ller.
- *=20
+ *
  * This program is free software; you can redistribute it and/or modif=
y it
  * under the terms of the GNU General Public License as published by t=
he
=46ree
- * Software Foundation; either version 2 of the License, or (at your
option)=20
+ * Software Foundation; either version 2 of the License, or (at your
option)
  * any later version.
  *
  */
@@ -37,6 +37,7 @@
 #define CRYPTO_ALG_TYPE_GIVCIPHER	0x00000006
 #define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
 #define CRYPTO_ALG_TYPE_AEAD		0x00000009
+#define CRYPTO_ALG_TYPE_AHASH		0x0000000A
=20
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
@@ -102,6 +103,7 @@ struct crypto_async_request;
 struct crypto_aead;
 struct crypto_blkcipher;
 struct crypto_hash;
+struct crypto_ahash;
 struct crypto_tfm;
 struct crypto_type;
 struct aead_givcrypt_request;
@@ -131,6 +133,16 @@ struct ablkcipher_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
=20
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
@@ -195,6 +207,17 @@ struct ablkcipher_alg {
 	unsigned int ivsize;
 };
=20
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
@@ -272,6 +295,7 @@ struct compress_alg {
 #define cra_cipher	cra_u.cipher
 #define cra_digest	cra_u.digest
 #define cra_hash	cra_u.hash
+#define cra_ahash	cra_u.ahash
 #define cra_compress	cra_u.compress
=20
 struct crypto_alg {
@@ -298,13 +322,14 @@ struct crypto_alg {
 		struct cipher_alg cipher;
 		struct digest_alg digest;
 		struct hash_alg hash;
+		struct ahash_alg ahash;
 		struct compress_alg compress;
 	} cra_u;
=20
 	int (*cra_init)(struct crypto_tfm *tfm);
 	void (*cra_exit)(struct crypto_tfm *tfm);
 	void (*cra_destroy)(struct crypto_alg *alg);
-=09
+
 	struct module *cra_module;
 };
=20
@@ -390,6 +415,19 @@ struct hash_tfm {
 	unsigned int digestsize;
 };
=20
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
@@ -404,21 +442,23 @@ struct compress_tfm {
 #define crt_blkcipher	crt_u.blkcipher
 #define crt_cipher	crt_u.cipher
 #define crt_hash	crt_u.hash
+#define crt_ahash	crt_u.ahash
 #define crt_compress	crt_u.compress
=20
 struct crypto_tfm {
=20
 	u32 crt_flags;
-=09
+
 	union {
 		struct ablkcipher_tfm ablkcipher;
 		struct aead_tfm aead;
 		struct blkcipher_tfm blkcipher;
 		struct cipher_tfm cipher;
 		struct hash_tfm hash;
+		struct ahash_tfm ahash;
 		struct compress_tfm compress;
 	} crt_u;
-=09
+
 	struct crypto_alg *__crt_alg;
=20
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
@@ -448,6 +488,10 @@ struct crypto_hash {
 	struct crypto_tfm base;
 };
=20
+struct crypto_ahash {
+	struct crypto_tfm base;
+};
+
 enum {
 	CRYPTOA_UNSPEC,
 	CRYPTOA_ALG,
@@ -477,7 +521,7 @@ struct crypto_attr_u32 {
 /*=20
  * Transform user interface.
  */
-=20
+
 struct crypto_tfm *crypto_alloc_tfm(const char *alg_name, u32 tfm_flag=
s);
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u=
32
mask);
 void crypto_free_tfm(struct crypto_tfm *tfm);
@@ -1112,7 +1156,7 @@ static inline struct crypto_hash
*crypto_alloc_hash(const char *alg_name,
 						    u32 type, u32 mask)
 {
 	type &=3D ~CRYPTO_ALG_TYPE_MASK;
-	mask &=3D ~CRYPTO_ALG_TYPE_MASK;
+	mask &=3D ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	type |=3D CRYPTO_ALG_TYPE_HASH;
 	mask |=3D CRYPTO_ALG_TYPE_HASH_MASK;
=20
@@ -1271,5 +1315,130 @@ static inline int crypto_comp_decompress(struct
crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
=20
+static inline struct crypto_tfm *crypto_ahash_tfm(
+	struct crypto_ahash *tfm)
+{
+	return &tfm->base;
+}
+
+struct crypto_ahash *crypto_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask);
+
+static inline void crypto_free_ahash(struct crypto_ahash *tfm)
+{
+	crypto_free_tfm(crypto_ahash_tfm(tfm));
+}
+
+static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_t=
fm
*tfm)
+{
+	return (struct crypto_ahash *) tfm;
+}
+
+static inline unsigned int crypto_ahash_alignmask(
+	struct crypto_ahash *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_ahash_tfm(tfm));
+}
+
+static inline struct ahash_tfm *crypto_ahash_crt(struct crypto_ahash *=
tfm)
+{
+	return &crypto_ahash_tfm(tfm)->crt_ahash;
+}
+
+static inline unsigned int crypto_ahash_digestsize(struct crypto_ahash
*tfm)
+{
+	return crypto_ahash_crt(tfm)->digestsize;
+}
+
+static inline u32 crypto_ahash_get_flags(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_get_flags(crypto_ahash_tfm(tfm));
+}
+
+static inline void crypto_ahash_set_flags(struct crypto_ahash *tfm, u3=
2
flags)
+{
+	crypto_tfm_set_flags(crypto_ahash_tfm(tfm), flags);
+}
+
+static inline void crypto_ahash_clear_flags(struct crypto_ahash *tfm, =
u32
flags)
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
+static inline unsigned int crypto_ahash_reqsize(struct crypto_ahash *t=
fm)
+{
+	return crypto_ahash_crt(tfm)->reqsize;
+}
+
+static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
+					const u8 *key, unsigned int keylen)
+{
+	struct ahash_tfm *crt =3D crypto_ahash_crt(tfm);
+
+	return crt->setkey(crt->base, key, keylen);
+}
+
+static inline int crypto_ahash_digest(struct ahash_request *req)
+{
+	struct ahash_tfm *crt =3D crypto_ahash_crt(crypto_ahash_reqtfm(req));
+	return crt->digest(req);
+}
+
+static inline void ahash_request_set_tfm(
+	struct ahash_request *req, struct crypto_ahash *tfm)
+{
+	req->base.tfm =3D crypto_ahash_tfm(crypto_ahash_crt(tfm)->base);
+}
+
+static inline struct ahash_request *ahash_request_alloc(
+	struct crypto_ahash *tfm, gfp_t gfp)
+{
+	struct ahash_request *req;
+
+	req =3D kmalloc(sizeof(struct ahash_request) +
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
+static inline void ahash_request_set_callback(
+	struct ahash_request *req,
+	u32 flags, crypto_completion_t complete, void *data)
+{
+	req->base.complete =3D complete;
+	req->base.data =3D data;
+	req->base.flags =3D flags;
+}
+
+static inline void ahash_request_set_crypt(
+	struct ahash_request *req,
+	struct scatterlist *src, u8 *result,
+	unsigned int nbytes)
+{
+	req->src =3D src;
+	req->nbytes =3D nbytes;
+	req->result =3D result;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
=20
--=20
1.5.3
