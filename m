From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Thu, 22 Jan 2009 10:32:17 +0800
Message-ID: <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com>
	 <20090116033105.GB10390@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Qj57/R5yChg7fhikCKK4"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61589 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbZAVCcU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Jan 2009 21:32:20 -0500
In-Reply-To: <20090116033105.GB10390@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-Qj57/R5yChg7fhikCKK4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 11:31 +0800, Herbert Xu wrote:
> On Fri, Jan 16, 2009 at 11:10:36AM +0800, Huang Ying wrote:
> >=20
> > The scalability of current cryptd implementation is not good. So a
> > per-CPU cryptd kthread implementation is necessary. The per-CPU kthread
> > pool implementation need to consider many issues such as CPU hotplug, s=
o
> > I suggest to base cryptd kthread implementation on workqueue, that is,
> > create a dedicate workqueue for crypto subsystem. This way, chainiv can
> > use this crypto workqueue too.
>=20
> Yes that sounds like a great idea.
>=20
> > I will implement it if you have no plan to do it yourself.
>=20
> Please do.

This is the first attempt to use a dedicate workqueue for crypto. It is
not intended to be merged. Please feedback your comments, especially on
desgin.

Best Regards,
Huang Ying

---------------------------------------------------->
Use dedicate workqueue for crypto

- A dedicated workqueue named kcrypto_wq is created.

- chainiv uses kcrypto_wq instead of keventd_wq.

- For cryptd, struct cryptd_queue is defined to be a per-CPU queue,
  which holds one struct cryptd_cpu_queue for each CPU. In struct
  cryptd_cpu_queue, a struct crypto_queue holds all requests for the
  CPU, a struct work_struct is used to run all requests for the CPU.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig             |    5=20
 crypto/Makefile            |    2=20
 crypto/chainiv.c           |    3=20
 crypto/cryptd.c            |  257 +++++++++++++++++++++++++---------------=
-----
 crypto/crypto_wq.c         |   39 ++++++
 include/crypto/crypto_wq.h |    7 +
 6 files changed, 203 insertions(+), 110 deletions(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -56,6 +56,7 @@ config CRYPTO_BLKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_RNG2
+	select CRYPTO_WORKQUEUE
=20
 config CRYPTO_HASH
 	tristate
@@ -106,11 +107,15 @@ config CRYPTO_NULL
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
=20
+config CRYPTO_WORKQUEUE
+       tristate
+
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
+	select CRYPTO_WORKQUEUE
 	help
 	  This is a generic software asynchronous crypto daemon that
 	  converts an arbitrary synchronous software crypto algorithm
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -5,6 +5,8 @@
 obj-$(CONFIG_CRYPTO) +=3D crypto.o
 crypto-objs :=3D api.o cipher.o digest.o compress.o
=20
+obj-$(CONFIG_CRYPTO_WORKQUEUE) +=3D crypto_wq.o
+
 obj-$(CONFIG_CRYPTO_FIPS) +=3D fips.o
=20
 crypto_algapi-$(CONFIG_PROC_FS) +=3D proc.o
--- /dev/null
+++ b/crypto/crypto_wq.c
@@ -0,0 +1,39 @@
+/*
+ * Workqueue for crypto subsystem
+ *
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the F=
ree
+ * Software Foundation; either version 2 of the License, or (at your optio=
n)
+ * any later version.
+ *
+ */
+
+#include <linux/workqueue.h>
+#include <crypto/algapi.h>
+#include <crypto/crypto_wq.h>
+
+struct workqueue_struct *kcrypto_wq;
+EXPORT_SYMBOL_GPL(kcrypto_wq);
+
+static int __init crypto_wq_init(void)
+{
+	kcrypto_wq =3D create_workqueue("crypto");
+	if (unlikely(!kcrypto_wq))
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit crypto_wq_exit(void)
+{
+	if (likely(kcrypto_wq))
+		destroy_workqueue(kcrypto_wq);
+}
+
+module_init(crypto_wq_init);
+module_exit(crypto_wq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Workqueue for crypto subsystem");
--- /dev/null
+++ b/include/crypto/crypto_wq.h
@@ -0,0 +1,7 @@
+#ifndef CRYPTO_WQ_H
+#define CRYPTO_WQ_H
+
+#include <linux/workqueue.h>
+
+extern struct workqueue_struct *kcrypto_wq;
+#endif
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -13,30 +13,37 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
 #include <crypto/cryptd.h>
+#include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
=20
-#define CRYPTD_MAX_QLEN 100
+#define CRYPTD_MAX_CPU_QLEN 100
=20
-struct cryptd_state {
+enum {
+	CRYPTD_STATE_INUSE,
+};
+
+struct cryptd_cpu_queue {
+	unsigned long state;
 	spinlock_t lock;
-	struct mutex mutex;
 	struct crypto_queue queue;
-	struct task_struct *task;
+	struct work_struct work;
+};
+
+struct cryptd_queue {
+	struct cryptd_cpu_queue *cpu_queue;
 };
=20
 struct cryptd_instance_ctx {
 	struct crypto_spawn spawn;
-	struct cryptd_state *state;
+	struct cryptd_queue *queue;
 };
=20
 struct cryptd_blkcipher_ctx {
@@ -55,11 +62,121 @@ struct cryptd_hash_request_ctx {
 	crypto_completion_t complete;
 };
=20
-static inline struct cryptd_state *cryptd_get_state(struct crypto_tfm *tfm=
)
+static void cryptd_queue_work(struct work_struct *work);
+
+int cryptd_init_queue(struct cryptd_queue *queue, unsigned int max_cpu_qle=
n)
+{
+	int cpu;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	queue->cpu_queue =3D alloc_percpu(struct cryptd_cpu_queue);
+	if (!queue->cpu_queue)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+		spin_lock_init(&cpu_queue->lock);
+		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
+		INIT_WORK(&cpu_queue->work, cryptd_queue_work);
+	}
+	return 0;
+}
+
+void cryptd_fini_queue(struct cryptd_queue *queue)
+{
+	int cpu;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	for_each_possible_cpu(cpu) {
+		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+		BUG_ON(cpu_queue->queue.qlen);
+	}
+	free_percpu(queue->cpu_queue);
+}
+
+int cryptd_enqueue_request(struct cryptd_queue *queue,
+			   struct crypto_async_request *request)
+{
+	int cpu, err, queued;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	cpu =3D get_cpu();
+	cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+	spin_lock_bh(&cpu_queue->lock);
+	err =3D crypto_enqueue_request(&cpu_queue->queue, request);
+	spin_unlock_bh(&cpu_queue->lock);
+	/* INUSE should be set after queue->qlen assigned, but
+	 * spin_unlock_bh imply a memory barrior already */
+	if (!test_and_set_bit_lock(CRYPTD_STATE_INUSE, &cpu_queue->state)) {
+		queued =3D queue_work(kcrypto_wq, &cpu_queue->work);
+		BUG_ON(!queued);
+	}
+	put_cpu();
+
+	return err;
+}
+
+int cryptd_tfm_in_queue(struct cryptd_queue *queue, struct crypto_tfm *tfm=
)
+{
+	int cpu, in_queue;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	for_each_possible_cpu(cpu) {
+		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+		spin_lock_bh(&cpu_queue->lock);
+		in_queue =3D crypto_tfm_in_queue(&cpu_queue->queue, tfm);
+		spin_unlock_bh(&cpu_queue->lock);
+		if (in_queue)
+			return 1;
+	}
+	return 0;
+}
+
+static void cryptd_queue_work_done(struct cryptd_cpu_queue *cpu_queue)
+{
+	int queued;
+
+	if (!cpu_queue->queue.qlen) {
+		clear_bit_unlock(CRYPTD_STATE_INUSE, &cpu_queue->state);
+		/* queue.qlen must be checked after INUSE bit cleared */
+		smp_mb();
+		if (!cpu_queue->queue.qlen ||
+		    test_and_set_bit_lock(CRYPTD_STATE_INUSE,
+					  &cpu_queue->state))
+			return;
+	}
+
+	queued =3D queue_work(kcrypto_wq, &cpu_queue->work);
+	BUG_ON(!queued);
+}
+
+static void cryptd_queue_work(struct work_struct *work)
+{
+	struct cryptd_cpu_queue *cpu_queue =3D
+		container_of(work, struct cryptd_cpu_queue, work);
+	struct crypto_async_request *req, *backlog;
+
+	/* Only handle one request at a time to avoid hogging crypto
+	 * workqueue */
+	spin_lock_bh(&cpu_queue->lock);
+	backlog =3D crypto_get_backlog(&cpu_queue->queue);
+	req =3D crypto_dequeue_request(&cpu_queue->queue);
+	spin_unlock_bh(&cpu_queue->lock);
+
+	if (!req)
+		goto out;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+	req->complete(req, 0);
+out:
+	cryptd_queue_work_done(cpu_queue);
+}
+
+static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm *tfm=
)
 {
 	struct crypto_instance *inst =3D crypto_tfm_alg_instance(tfm);
 	struct cryptd_instance_ctx *ictx =3D crypto_instance_ctx(inst);
-	return ictx->state;
+	return ictx->queue;
 }
=20
 static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
@@ -131,19 +248,13 @@ static int cryptd_blkcipher_enqueue(stru
 {
 	struct cryptd_blkcipher_request_ctx *rctx =3D ablkcipher_request_ctx(req)=
;
 	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
-	struct cryptd_state *state =3D
-		cryptd_get_state(crypto_ablkcipher_tfm(tfm));
-	int err;
+	struct cryptd_queue *queue =3D
+		cryptd_get_queue(crypto_ablkcipher_tfm(tfm));
=20
 	rctx->complete =3D req->base.complete;
 	req->base.complete =3D complete;
=20
-	spin_lock_bh(&state->lock);
-	err =3D ablkcipher_enqueue_request(&state->queue, req);
-	spin_unlock_bh(&state->lock);
-
-	wake_up_process(state->task);
-	return err;
+	return cryptd_enqueue_request(queue, &req->base);
 }
=20
 static int cryptd_blkcipher_encrypt_enqueue(struct ablkcipher_request *req=
)
@@ -177,21 +288,17 @@ static int cryptd_blkcipher_init_tfm(str
 static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct cryptd_blkcipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct cryptd_state *state =3D cryptd_get_state(tfm);
+	struct cryptd_queue *queue =3D cryptd_get_queue(tfm);
 	int active;
=20
-	mutex_lock(&state->mutex);
-	active =3D ablkcipher_tfm_in_queue(&state->queue,
-					 __crypto_ablkcipher_cast(tfm));
-	mutex_unlock(&state->mutex);
-
+	active =3D cryptd_tfm_in_queue(queue, tfm);
 	BUG_ON(active);
=20
 	crypto_free_blkcipher(ctx->child);
 }
=20
 static struct crypto_instance *cryptd_alloc_instance(struct crypto_alg *al=
g,
-						     struct cryptd_state *state)
+						     struct cryptd_queue *queue)
 {
 	struct crypto_instance *inst;
 	struct cryptd_instance_ctx *ctx;
@@ -214,7 +321,7 @@ static struct crypto_instance *cryptd_al
 	if (err)
 		goto out_free_inst;
=20
-	ctx->state =3D state;
+	ctx->queue =3D queue;
=20
 	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
=20
@@ -232,7 +339,7 @@ out_free_inst:
 }
=20
 static struct crypto_instance *cryptd_alloc_blkcipher(
-	struct rtattr **tb, struct cryptd_state *state)
+	struct rtattr **tb, struct cryptd_queue *queue)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -242,7 +349,7 @@ static struct crypto_instance *cryptd_al
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
=20
-	inst =3D cryptd_alloc_instance(alg, state);
+	inst =3D cryptd_alloc_instance(alg, queue);
 	if (IS_ERR(inst))
 		goto out_put_alg;
=20
@@ -290,14 +397,10 @@ static int cryptd_hash_init_tfm(struct c
 static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct cryptd_state *state =3D cryptd_get_state(tfm);
+	struct cryptd_queue *queue =3D cryptd_get_queue(tfm);
 	int active;
=20
-	mutex_lock(&state->mutex);
-	active =3D ahash_tfm_in_queue(&state->queue,
-				__crypto_ahash_cast(tfm));
-	mutex_unlock(&state->mutex);
-
+	active =3D cryptd_tfm_in_queue(queue, tfm);
 	BUG_ON(active);
=20
 	crypto_free_hash(ctx->child);
@@ -324,19 +427,13 @@ static int cryptd_hash_enqueue(struct ah
 {
 	struct cryptd_hash_request_ctx *rctx =3D ahash_request_ctx(req);
 	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
-	struct cryptd_state *state =3D
-		cryptd_get_state(crypto_ahash_tfm(tfm));
-	int err;
+	struct cryptd_queue *queue =3D
+		cryptd_get_queue(crypto_ahash_tfm(tfm));
=20
 	rctx->complete =3D req->base.complete;
 	req->base.complete =3D complete;
=20
-	spin_lock_bh(&state->lock);
-	err =3D ahash_enqueue_request(&state->queue, req);
-	spin_unlock_bh(&state->lock);
-
-	wake_up_process(state->task);
-	return err;
+	return cryptd_enqueue_request(queue, &req->base);
 }
=20
 static void cryptd_hash_init(struct crypto_async_request *req_async, int e=
rr)
@@ -469,7 +566,7 @@ static int cryptd_hash_digest_enqueue(st
 }
=20
 static struct crypto_instance *cryptd_alloc_hash(
-	struct rtattr **tb, struct cryptd_state *state)
+	struct rtattr **tb, struct cryptd_queue *queue)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -479,7 +576,7 @@ static struct crypto_instance *cryptd_al
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
=20
-	inst =3D cryptd_alloc_instance(alg, state);
+	inst =3D cryptd_alloc_instance(alg, queue);
 	if (IS_ERR(inst))
 		goto out_put_alg;
=20
@@ -503,7 +600,7 @@ out_put_alg:
 	return inst;
 }
=20
-static struct cryptd_state state;
+static struct cryptd_queue queue;
=20
 static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
 {
@@ -515,9 +612,9 @@ static struct crypto_instance *cryptd_al
=20
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
-		return cryptd_alloc_blkcipher(tb, &state);
+		return cryptd_alloc_blkcipher(tb, &queue);
 	case CRYPTO_ALG_TYPE_DIGEST:
-		return cryptd_alloc_hash(tb, &state);
+		return cryptd_alloc_hash(tb, &queue);
 	}
=20
 	return ERR_PTR(-EINVAL);
@@ -572,82 +669,24 @@ void cryptd_free_ablkcipher(struct crypt
 }
 EXPORT_SYMBOL_GPL(cryptd_free_ablkcipher);
=20
-static inline int cryptd_create_thread(struct cryptd_state *state,
-				       int (*fn)(void *data), const char *name)
-{
-	spin_lock_init(&state->lock);
-	mutex_init(&state->mutex);
-	crypto_init_queue(&state->queue, CRYPTD_MAX_QLEN);
-
-	state->task =3D kthread_run(fn, state, name);
-	if (IS_ERR(state->task))
-		return PTR_ERR(state->task);
-
-	return 0;
-}
-
-static inline void cryptd_stop_thread(struct cryptd_state *state)
-{
-	BUG_ON(state->queue.qlen);
-	kthread_stop(state->task);
-}
-
-static int cryptd_thread(void *data)
-{
-	struct cryptd_state *state =3D data;
-	int stop;
-
-	current->flags |=3D PF_NOFREEZE;
-
-	do {
-		struct crypto_async_request *req, *backlog;
-
-		mutex_lock(&state->mutex);
-		__set_current_state(TASK_INTERRUPTIBLE);
-
-		spin_lock_bh(&state->lock);
-		backlog =3D crypto_get_backlog(&state->queue);
-		req =3D crypto_dequeue_request(&state->queue);
-		spin_unlock_bh(&state->lock);
-
-		stop =3D kthread_should_stop();
-
-		if (stop || req) {
-			__set_current_state(TASK_RUNNING);
-			if (req) {
-				if (backlog)
-					backlog->complete(backlog,
-							  -EINPROGRESS);
-				req->complete(req, 0);
-			}
-		}
-
-		mutex_unlock(&state->mutex);
-
-		schedule();
-	} while (!stop);
-
-	return 0;
-}
-
 static int __init cryptd_init(void)
 {
 	int err;
=20
-	err =3D cryptd_create_thread(&state, cryptd_thread, "cryptd");
+	err =3D cryptd_init_queue(&queue, CRYPTD_MAX_CPU_QLEN);
 	if (err)
 		return err;
=20
 	err =3D crypto_register_template(&cryptd_tmpl);
 	if (err)
-		kthread_stop(state.task);
+		cryptd_fini_queue(&queue);
=20
 	return err;
 }
=20
 static void __exit cryptd_exit(void)
 {
-	cryptd_stop_thread(&state);
+	cryptd_fini_queue(&queue);
 	crypto_unregister_template(&cryptd_tmpl);
 }
=20
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -15,6 +15,7 @@
=20
 #include <crypto/internal/skcipher.h>
 #include <crypto/rng.h>
+#include <crypto/crypto_wq.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -133,7 +134,7 @@ static int async_chainiv_schedule_work(s
 			goto out;
 	}
=20
-	queued =3D schedule_work(&ctx->postponed);
+	queued =3D queue_work(kcryptd_wq, &ctx->postponed);
 	BUG_ON(!queued);
=20
 out:


--=-Qj57/R5yChg7fhikCKK4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl32qwACgkQKhFGF+eHlphKEgCeJKsTHDuo91K0pZemKjO3Yx77
5YAAnAqoeB81gN9tjkp6Fc3jOm3Pq+Ro
=fuLq
-----END PGP SIGNATURE-----

--=-Qj57/R5yChg7fhikCKK4--

