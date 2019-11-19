Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8DDC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 13:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622BC20409
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 13:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKSNGD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:06:03 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51834 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfKSNGD (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 19 Nov 2019 08:06:03 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iX3Cj-0005kX-Vq; Tue, 19 Nov 2019 21:06:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iX3Cf-0002Km-5N; Tue, 19 Nov 2019 21:05:57 +0800
Date:   Tue, 19 Nov 2019 21:05:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@google.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] crypto: pcrypt - Avoid deadlock by using per-instance padata
 queues
Message-ID: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the pcrypt template is used multiple times in an algorithm, then a
deadlock occurs because all pcrypt instances share the same
padata_instance, which completes requests in the order submitted.  That
is, the inner pcrypt request waits for the outer pcrypt request while
the outer request is already waiting for the inner.

This patch fixes this by allocating a set of queues for each pcrypt
instance instead of using two global queues.  In order to maintain
the existing user-space interface, the pinst structure remains global
so any sysfs modifications will apply to every instance.

The new per-instance data structure is called padata_shell and is
essentially a wrapper around parallel_data.

Reproducer:

	#include <linux/if_alg.h>
	#include <sys/socket.h>
	#include <unistd.h>

	int main()
	{
		struct sockaddr_alg addr = {
			.salg_type = "aead",
			.salg_name = "pcrypt(pcrypt(rfc4106-gcm-aesni))"
		};
		int algfd, reqfd;
		char buf[32] = { 0 };

		algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
		bind(algfd, (void *)&addr, sizeof(addr));
		setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, 20);
		reqfd = accept(algfd, 0, 0);
		write(reqfd, buf, 32);
		read(reqfd, buf, 16);
	}

Reported-by: syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto parallelization wrapper")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 81bbea7f2ba6..3e026e7a7e75 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -24,6 +24,8 @@ static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
 	struct crypto_aead_spawn spawn;
+	struct padata_shell *psenc;
+	struct padata_shell *psdec;
 	atomic_t tfm_count;
 };
 
@@ -32,6 +34,12 @@ struct pcrypt_aead_ctx {
 	unsigned int cb_cpu;
 };
 
+static inline struct pcrypt_instance_ctx *pcrypt_tfm_ictx(
+	struct crypto_aead *tfm)
+{
+	return aead_instance_ctx(aead_alg_instance(tfm));
+}
+
 static int pcrypt_aead_setkey(struct crypto_aead *parent,
 			      const u8 *key, unsigned int keylen)
 {
@@ -90,6 +98,9 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
 	u32 flags = aead_request_flags(req);
+	struct pcrypt_instance_ctx *ictx;
+
+	ictx = pcrypt_tfm_ictx(aead);
 
 	memset(padata, 0, sizeof(struct padata_priv));
 
@@ -103,7 +114,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(pencrypt, padata, &ctx->cb_cpu);
+	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -132,6 +143,9 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
 	u32 flags = aead_request_flags(req);
+	struct pcrypt_instance_ctx *ictx;
+
+	ictx = pcrypt_tfm_ictx(aead);
 
 	memset(padata, 0, sizeof(struct padata_priv));
 
@@ -145,7 +159,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(pdecrypt, padata, &ctx->cb_cpu);
+	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -192,6 +206,8 @@ static void pcrypt_free(struct aead_instance *inst)
 	struct pcrypt_instance_ctx *ctx = aead_instance_ctx(inst);
 
 	crypto_drop_aead(&ctx->spawn);
+	padata_free_shell(ctx->psdec);
+	padata_free_shell(ctx->psenc);
 	kfree(inst);
 }
 
@@ -233,12 +249,22 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 	if (!inst)
 		return -ENOMEM;
 
+	err = -ENOMEM;
+
 	ctx = aead_instance_ctx(inst);
+	ctx->psenc = padata_alloc_shell(pencrypt);
+	if (!ctx->psenc)
+		goto out_free_inst;
+
+	ctx->psdec = padata_alloc_shell(pdecrypt);
+	if (!ctx->psdec)
+		goto out_free_psenc;
+
 	crypto_set_aead_spawn(&ctx->spawn, aead_crypto_instance(inst));
 
 	err = crypto_grab_aead(&ctx->spawn, name, 0, 0);
 	if (err)
-		goto out_free_inst;
+		goto out_free_psdec;
 
 	alg = crypto_spawn_aead_alg(&ctx->spawn);
 	err = pcrypt_init_instance(aead_crypto_instance(inst), &alg->base);
@@ -271,6 +297,10 @@ static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
 
 out_drop_aead:
 	crypto_drop_aead(&ctx->spawn);
+out_free_psdec:
+	padata_free_shell(ctx->psdec);
+out_free_psenc:
+	padata_free_shell(ctx->psenc);
 out_free_inst:
 	kfree(inst);
 	goto out;
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 23717eeaad23..fd38897e1b91 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -9,6 +9,7 @@
 #ifndef PADATA_H
 #define PADATA_H
 
+#include <linux/compiler_types.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
@@ -98,7 +99,7 @@ struct padata_cpumask {
  * struct parallel_data - Internal control structure, covers everything
  * that depends on the cpumask in use.
  *
- * @pinst: padata instance.
+ * @sh: padata_shell object.
  * @pqueue: percpu padata queues used for parallelization.
  * @squeue: percpu padata queues used for serialuzation.
  * @reorder_objects: Number of objects waiting in the reorder queues.
@@ -111,7 +112,7 @@ struct padata_cpumask {
  * @lock: Reorder lock.
  */
 struct parallel_data {
-	struct padata_instance		*pinst;
+	struct padata_shell		*ps;
 	struct padata_parallel_queue	__percpu *pqueue;
 	struct padata_serial_queue	__percpu *squeue;
 	atomic_t			reorder_objects;
@@ -125,12 +126,27 @@ struct parallel_data {
 };
 
 /**
+ * struct padata_shell - Wrapper around struct parallel_data, its
+ * purpose is to allow the underlying control structure to be replaced
+ * on the fly using RCU.
+ *
+ * @pinst: padat instance.
+ * @pd: Actual parallel_data structure which may be substituted on the fly.
+ * @list: List entry in padata_instance list.
+ */
+struct padata_shell {
+	struct padata_instance		*pinst;
+	struct parallel_data __rcu	*pd;
+	struct list_head		list;
+};
+
+/**
  * struct padata_instance - The overall control structure.
  *
  * @cpu_notifier: cpu hotplug notifier.
  * @parallel_wq: The workqueue used for parallel work.
  * @serial_wq: The workqueue used for serial work.
- * @pd: The internal control structure.
+ * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
  * @cpumask_change_notifier: Notifiers chain for user-defined notify
  *            callbacks that will be called when either @pcpu or @cbcpu
@@ -143,7 +159,7 @@ struct padata_instance {
 	struct hlist_node		 node;
 	struct workqueue_struct		*parallel_wq;
 	struct workqueue_struct		*serial_wq;
-	struct parallel_data		*pd;
+	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
 	struct blocking_notifier_head	 cpumask_change_notifier;
 	struct kobject                   kobj;
@@ -156,7 +172,9 @@ struct padata_instance {
 
 extern struct padata_instance *padata_alloc_possible(const char *name);
 extern void padata_free(struct padata_instance *pinst);
-extern int padata_do_parallel(struct padata_instance *pinst,
+extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
+extern void padata_free_shell(struct padata_shell *ps);
+extern int padata_do_parallel(struct padata_shell *ps,
 			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
diff --git a/kernel/padata.c b/kernel/padata.c
index da56a235a255..0c33833c99dd 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -89,7 +89,7 @@ static void padata_parallel_worker(struct work_struct *parallel_work)
 /**
  * padata_do_parallel - padata parallelization function
  *
- * @pinst: padata instance
+ * @ps: padatashell 
  * @padata: object to be parallelized
  * @cb_cpu: pointer to the CPU that the serialization callback function should
  *          run on.  If it's not in the serial cpumask of @pinst
@@ -100,16 +100,17 @@ static void padata_parallel_worker(struct work_struct *parallel_work)
  * Note: Every object which is parallelized by padata_do_parallel
  * must be seen by padata_do_serial.
  */
-int padata_do_parallel(struct padata_instance *pinst,
+int padata_do_parallel(struct padata_shell *ps,
 		       struct padata_priv *padata, int *cb_cpu)
 {
+	struct padata_instance *pinst = ps->pinst;
 	int i, cpu, cpu_index, target_cpu, err;
 	struct padata_parallel_queue *queue;
 	struct parallel_data *pd;
 
 	rcu_read_lock_bh();
 
-	pd = rcu_dereference_bh(pinst->pd);
+	pd = rcu_dereference_bh(ps->pd);
 
 	err = -EINVAL;
 	if (!(pinst->flags & PADATA_INIT) || pinst->flags & PADATA_INVALID)
@@ -212,10 +213,10 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 
 static void padata_reorder(struct parallel_data *pd)
 {
+	struct padata_instance *pinst = pd->ps->pinst;
 	int cb_cpu;
 	struct padata_priv *padata;
 	struct padata_serial_queue *squeue;
-	struct padata_instance *pinst = pd->pinst;
 	struct padata_parallel_queue *next_queue;
 
 	/*
@@ -370,7 +371,7 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
 
 	/* Restrict parallel_wq workers to pd->cpumask.pcpu. */
 	cpumask_copy(attrs->cpumask, pd->cpumask.pcpu);
-	err = apply_workqueue_attrs(pd->pinst->parallel_wq, attrs);
+	err = apply_workqueue_attrs(pd->ps->pinst->parallel_wq, attrs);
 	free_workqueue_attrs(attrs);
 	if (err < 0)
 		goto free_cbcpu_mask;
@@ -422,12 +423,16 @@ static void padata_init_pqueues(struct parallel_data *pd)
 }
 
 /* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
-					     const struct cpumask *pcpumask,
-					     const struct cpumask *cbcpumask)
+static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 {
+	struct padata_instance *pinst = ps->pinst;
+	const struct cpumask *cbcpumask;
+	const struct cpumask *pcpumask;
 	struct parallel_data *pd;
 
+	cbcpumask = pinst->cpumask.cbcpu;
+	pcpumask = pinst->cpumask.pcpu;
+
 	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
 	if (!pd)
 		goto err;
@@ -440,7 +445,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	if (!pd->squeue)
 		goto err_free_pqueue;
 
-	pd->pinst = pinst;
+	pd->ps = ps;
 	if (padata_setup_cpumasks(pd, pcpumask, cbcpumask) < 0)
 		goto err_free_squeue;
 
@@ -490,17 +495,17 @@ static void __padata_stop(struct padata_instance *pinst)
 }
 
 /* Replace the internal control structure with a new one. */
-static void padata_replace(struct padata_instance *pinst,
-			   struct parallel_data *pd_new)
+static int padata_replace_one(struct padata_shell *ps)
 {
-	struct parallel_data *pd_old = pinst->pd;
+	struct parallel_data *pd_old = rcu_dereference_protected(ps->pd, 1);
+	struct parallel_data *pd_new;
 	int notification_mask = 0;
 
-	pinst->flags |= PADATA_RESET;
-
-	rcu_assign_pointer(pinst->pd, pd_new);
+	pd_new = padata_alloc_pd(ps);
+	if (!pd_new)
+		return -ENOMEM;
 
-	synchronize_rcu();
+	rcu_assign_pointer(ps->pd, pd_new);
 
 	if (!cpumask_equal(pd_old->cpumask.pcpu, pd_new->cpumask.pcpu))
 		notification_mask |= PADATA_CPU_PARALLEL;
@@ -510,10 +515,25 @@ static void padata_replace(struct padata_instance *pinst,
 	if (atomic_dec_and_test(&pd_old->refcnt))
 		padata_free_pd(pd_old);
 
+	return notification_mask;
+}
+
+static void padata_replace(struct padata_instance *pinst)
+{
+	int notification_mask = 0;
+	struct padata_shell *ps;
+
+	pinst->flags |= PADATA_RESET;
+
+	list_for_each_entry(ps, &pinst->pslist, list)
+		notification_mask |= padata_replace_one(ps);
+
+	synchronize_rcu();
+
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
 					     notification_mask,
-					     &pd_new->cpumask);
+					     &pinst->cpumask);
 
 	pinst->flags &= ~PADATA_RESET;
 }
@@ -568,7 +588,6 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 				 cpumask_var_t cbcpumask)
 {
 	int valid;
-	struct parallel_data *pd;
 
 	valid = padata_validate_cpumask(pinst, pcpumask);
 	if (!valid) {
@@ -581,14 +600,10 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 		__padata_stop(pinst);
 
 out_replace:
-	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
-	if (!pd)
-		return -ENOMEM;
-
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
-	padata_replace(pinst, pd);
+	padata_replace(pinst);
 
 	if (valid)
 		__padata_start(pinst);
@@ -676,15 +691,8 @@ EXPORT_SYMBOL(padata_stop);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-	struct parallel_data *pd;
-
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
-				     pinst->cpumask.cbcpu);
-		if (!pd)
-			return -ENOMEM;
-
-		padata_replace(pinst, pd);
+		padata_replace(pinst);
 
 		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
 		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -696,23 +704,15 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
-	struct parallel_data *pd = NULL;
-
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
+		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
 
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
 			__padata_stop(pinst);
 
-		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
-				     pinst->cpumask.cbcpu);
-		if (!pd)
-			return -ENOMEM;
-
-		padata_replace(pinst, pd);
-
-		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
-		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
+		padata_replace(pinst);
 	}
 
 	return 0;
@@ -798,8 +798,9 @@ static void __padata_free(struct padata_instance *pinst)
 	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
 
+	WARN_ON(!list_empty(&pinst->pslist));
+
 	padata_stop(pinst);
-	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
 	destroy_workqueue(pinst->serial_wq);
@@ -946,7 +947,6 @@ static struct padata_instance *padata_alloc(const char *name,
 					    const struct cpumask *cbcpumask)
 {
 	struct padata_instance *pinst;
-	struct parallel_data *pd = NULL;
 
 	pinst = kzalloc(sizeof(struct padata_instance), GFP_KERNEL);
 	if (!pinst)
@@ -974,11 +974,8 @@ static struct padata_instance *padata_alloc(const char *name,
 	    !padata_validate_cpumask(pinst, cbcpumask))
 		goto err_free_masks;
 
-	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
-	if (!pd)
-		goto err_free_masks;
 
-	rcu_assign_pointer(pinst->pd, pd);
+	INIT_LIST_HEAD(&pinst->pslist);
 
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
@@ -1035,6 +1032,60 @@ void padata_free(struct padata_instance *pinst)
 }
 EXPORT_SYMBOL(padata_free);
 
+/**
+ * padata_alloc_shell - Allocate and initialize padata shell.
+ *
+ * @pinst: Parent padata_instance object.
+ */
+struct padata_shell *padata_alloc_shell(struct padata_instance *pinst)
+{
+	struct parallel_data *pd;
+	struct padata_shell *ps;
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto out;
+
+	ps->pinst = pinst;
+
+	mutex_lock(&pinst->lock);
+	pd = padata_alloc_pd(ps);
+	if (!pd)
+		goto out_unlock;
+
+	RCU_INIT_POINTER(ps->pd, pd);
+	list_add(&ps->list, &pinst->pslist);
+
+	mutex_unlock(&pinst->lock);
+	return ps;
+
+out_unlock:
+	mutex_unlock(&pinst->lock);
+	kfree(ps);
+
+out:
+	return NULL;
+}
+EXPORT_SYMBOL(padata_alloc_shell);
+
+/**
+ * padata_free_shell - free a padata shell
+ *
+ * @ps: padata shell to free
+ */
+void padata_free_shell(struct padata_shell *ps)
+{
+	struct padata_instance *pinst = ps->pinst;
+
+	mutex_lock(&pinst->lock);
+	list_del(&ps->list);
+	padata_free_pd(rcu_dereference_protected(ps->pd, 1));
+	mutex_unlock(&pinst->lock);
+
+	kfree(ps);
+}
+EXPORT_SYMBOL(padata_free_shell);
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 static __init int padata_driver_init(void)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
