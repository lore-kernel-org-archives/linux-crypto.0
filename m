From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 2/3] crypto: Per-CPU cryptd thread implementation based
	on kcrypto_wq
Date: Tue, 10 Feb 2009 14:13:58 +0800
Message-ID: <1234246438.20270.75.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8l0pDkOe+/eHFDZis6IS"
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50763 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZBJGOB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Feb 2009 01:14:01 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-8l0pDkOe+/eHFDZis6IS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Per-CPU cryptd thread implementation based on kcrypto_wq

Original cryptd thread implementation has scalability issue, this
patch solve the issue with a per-CPU thread implementation.

struct cryptd_queue is defined to be a per-CPU queue, which holds one
struct cryptd_cpu_queue for each CPU. In struct cryptd_cpu_queue, a
struct crypto_queue holds all requests for the CPU, a struct
work_struct is used to run all requests for the CPU.


Changlog:

v2:

- Minor fixes

- Add some comments


Testing based on dm-crypt on an Intel Core 2 E6400 (two cores) machine
shows 19.2% performance gain. The testing script is as follow:

-------------------- script begin ---------------------------
#!/bin/sh

dmc_create()
{
        # Create a crypt device using dmsetup
        dmsetup create $2 --table "0 `blockdev --getsize $1` crypt cbc(aes-=
asm)?cryptd?plain:plain babebabebabebabebabebabebabebabe 0 $1 0"
}

dmsetup remove crypt0
dmsetup remove crypt1

dd if=3D/dev/zero of=3D/dev/ram0 bs=3D1M count=3D4 >& /dev/null
dd if=3D/dev/zero of=3D/dev/ram1 bs=3D1M count=3D4 >& /dev/null

dmc_create /dev/ram0 crypt0
dmc_create /dev/ram1 crypt1

cat >tr.sh <<EOF
#!/bin/sh

for n in \$(seq 10); do
        dd if=3D/dev/dm-0 of=3D/dev/null >& /dev/null &
        dd if=3D/dev/dm-1 of=3D/dev/null >& /dev/null &
done
wait
EOF

for n in $(seq 10); do
        /usr/bin/time sh tr.sh
done
rm tr.sh
-------------------- script end   ---------------------------

The separator of dm-crypt parameter is changed from "-" to "?", because
"-" is used in some cipher driver name too, and cryptds need to specify
cipher driver name instead of cipher name.

The test result on an Intel Core2 E6400 (two cores) is as follow:

without patch:
-----------------wo begin --------------------------
0.04user 0.38system 0:00.39elapsed 107%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6566minor)pagefaults 0swaps
0.07user 0.35system 0:00.35elapsed 121%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6567minor)pagefaults 0swaps
0.06user 0.34system 0:00.30elapsed 135%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.37system 0:00.36elapsed 119%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6607minor)pagefaults 0swaps
0.06user 0.36system 0:00.35elapsed 120%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.37system 0:00.31elapsed 136%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6594minor)pagefaults 0swaps
0.04user 0.34system 0:00.30elapsed 126%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6597minor)pagefaults 0swaps
0.06user 0.32system 0:00.31elapsed 125%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6571minor)pagefaults 0swaps
0.06user 0.34system 0:00.31elapsed 134%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6581minor)pagefaults 0swaps
0.05user 0.38system 0:00.31elapsed 138%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6600minor)pagefaults 0swaps
-----------------wo end   --------------------------


with patch:
------------------w begin --------------------------
0.02user 0.31system 0:00.24elapsed 141%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6554minor)pagefaults 0swaps
0.05user 0.34system 0:00.31elapsed 127%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6606minor)pagefaults 0swaps
0.07user 0.33system 0:00.26elapsed 155%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6559minor)pagefaults 0swaps
0.07user 0.32system 0:00.26elapsed 151%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.05user 0.34system 0:00.26elapsed 150%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6603minor)pagefaults 0swaps
0.03user 0.36system 0:00.31elapsed 124%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.04user 0.35system 0:00.26elapsed 147%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6586minor)pagefaults 0swaps
0.03user 0.37system 0:00.27elapsed 146%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6562minor)pagefaults 0swaps
0.04user 0.36system 0:00.26elapsed 154%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6594minor)pagefaults 0swaps
0.04user 0.35system 0:00.26elapsed 154%CPU (0avgtext+0avgdata 0maxresident)=
k
0inputs+0outputs (0major+6557minor)pagefaults 0swaps
------------------w end   --------------------------

The middle value of elapsed time is:
wo cryptwq: 0.31
w  cryptwq: 0.26

The performance gain is about (0.31-0.26)/0.26 =3D 0.192.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 crypto/Kconfig  |    1=20
 crypto/cryptd.c |  220 ++++++++++++++++++++++++++-------------------------=
-----
 2 files changed, 104 insertions(+), 117 deletions(-)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -114,6 +114,7 @@ config CRYPTO_CRYPTD
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
+	select CRYPTO_WORKQUEUE
 	help
 	  This is a generic software asynchronous crypto daemon that
 	  converts an arbitrary synchronous software crypto algorithm
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -13,30 +13,30 @@
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
-#include <linux/spinlock.h>
=20
-#define CRYPTD_MAX_QLEN 100
+#define CRYPTD_MAX_CPU_QLEN 100
=20
-struct cryptd_state {
-	spinlock_t lock;
-	struct mutex mutex;
+struct cryptd_cpu_queue {
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
@@ -55,11 +55,85 @@ struct cryptd_hash_request_ctx {
 	crypto_completion_t complete;
 };
=20
-static inline struct cryptd_state *cryptd_get_state(struct crypto_tfm *tfm=
)
+static void cryptd_queue_worker(struct work_struct *work);
+
+static int cryptd_init_queue(struct cryptd_queue *queue,
+			     unsigned int max_cpu_qlen)
+{
+	int cpu;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	queue->cpu_queue =3D alloc_percpu(struct cryptd_cpu_queue);
+	if (!queue->cpu_queue)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
+		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
+	}
+	return 0;
+}
+
+static void cryptd_fini_queue(struct cryptd_queue *queue)
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
+static int cryptd_enqueue_request(struct cryptd_queue *queue,
+				  struct crypto_async_request *request)
+{
+	int cpu, err;
+	struct cryptd_cpu_queue *cpu_queue;
+
+	cpu =3D get_cpu();
+	cpu_queue =3D per_cpu_ptr(queue->cpu_queue, cpu);
+	err =3D crypto_enqueue_request(&cpu_queue->queue, request);
+	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+	put_cpu();
+
+	return err;
+}
+
+/* Called in workqueue context, do one real cryption work (via
+ * req->complete) and reschedule itself if there are more work to
+ * do. */
+static void cryptd_queue_worker(struct work_struct *work)
+{
+	struct cryptd_cpu_queue *cpu_queue;
+	struct crypto_async_request *req, *backlog;
+
+	cpu_queue =3D container_of(work, struct cryptd_cpu_queue, work);
+	/* Only handle one request at a time to avoid hogging crypto
+	 * workqueue. preempt_disable/enable is used to prevent
+	 * being preempted by cryptd_enqueue_request() */
+	preempt_disable();
+	backlog =3D crypto_get_backlog(&cpu_queue->queue);
+	req =3D crypto_dequeue_request(&cpu_queue->queue);
+	preempt_enable();
+
+	if (!req)
+		return;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+	req->complete(req, 0);
+
+	if (cpu_queue->queue.qlen)
+		queue_work(kcrypto_wq, &cpu_queue->work);
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
@@ -131,19 +205,13 @@ static int cryptd_blkcipher_enqueue(stru
 {
 	struct cryptd_blkcipher_request_ctx *rctx =3D ablkcipher_request_ctx(req)=
;
 	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
-	struct cryptd_state *state =3D
-		cryptd_get_state(crypto_ablkcipher_tfm(tfm));
-	int err;
+	struct cryptd_queue *queue;
=20
+	queue =3D cryptd_get_queue(crypto_ablkcipher_tfm(tfm));
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
@@ -177,21 +245,12 @@ static int cryptd_blkcipher_init_tfm(str
 static void cryptd_blkcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct cryptd_blkcipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct cryptd_state *state =3D cryptd_get_state(tfm);
-	int active;
-
-	mutex_lock(&state->mutex);
-	active =3D ablkcipher_tfm_in_queue(&state->queue,
-					 __crypto_ablkcipher_cast(tfm));
-	mutex_unlock(&state->mutex);
-
-	BUG_ON(active);
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
@@ -214,7 +273,7 @@ static struct crypto_instance *cryptd_al
 	if (err)
 		goto out_free_inst;
=20
-	ctx->state =3D state;
+	ctx->queue =3D queue;
=20
 	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
=20
@@ -232,7 +291,7 @@ out_free_inst:
 }
=20
 static struct crypto_instance *cryptd_alloc_blkcipher(
-	struct rtattr **tb, struct cryptd_state *state)
+	struct rtattr **tb, struct cryptd_queue *queue)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -242,7 +301,7 @@ static struct crypto_instance *cryptd_al
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
=20
-	inst =3D cryptd_alloc_instance(alg, state);
+	inst =3D cryptd_alloc_instance(alg, queue);
 	if (IS_ERR(inst))
 		goto out_put_alg;
=20
@@ -290,15 +349,6 @@ static int cryptd_hash_init_tfm(struct c
 static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct cryptd_hash_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	struct cryptd_state *state =3D cryptd_get_state(tfm);
-	int active;
-
-	mutex_lock(&state->mutex);
-	active =3D ahash_tfm_in_queue(&state->queue,
-				__crypto_ahash_cast(tfm));
-	mutex_unlock(&state->mutex);
-
-	BUG_ON(active);
=20
 	crypto_free_hash(ctx->child);
 }
@@ -324,19 +374,13 @@ static int cryptd_hash_enqueue(struct ah
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
@@ -469,7 +513,7 @@ static int cryptd_hash_digest_enqueue(st
 }
=20
 static struct crypto_instance *cryptd_alloc_hash(
-	struct rtattr **tb, struct cryptd_state *state)
+	struct rtattr **tb, struct cryptd_queue *queue)
 {
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
@@ -479,7 +523,7 @@ static struct crypto_instance *cryptd_al
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
=20
-	inst =3D cryptd_alloc_instance(alg, state);
+	inst =3D cryptd_alloc_instance(alg, queue);
 	if (IS_ERR(inst))
 		goto out_put_alg;
=20
@@ -503,7 +547,7 @@ out_put_alg:
 	return inst;
 }
=20
-static struct cryptd_state state;
+static struct cryptd_queue queue;
=20
 static struct crypto_instance *cryptd_alloc(struct rtattr **tb)
 {
@@ -515,9 +559,9 @@ static struct crypto_instance *cryptd_al
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
@@ -572,82 +616,24 @@ void cryptd_free_ablkcipher(struct crypt
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


--=-8l0pDkOe+/eHFDZis6IS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmRGyMACgkQKhFGF+eHlphCwgCgosa8XbwqluP8cTHGEwQo/M/B
yK0Anj59kJu6rpbHdLGCcxSslAqDgRAV
=O+Bn
-----END PGP SIGNATURE-----

--=-8l0pDkOe+/eHFDZis6IS--

