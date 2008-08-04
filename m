From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/5] crypto: api - Use test infrastructure
Date: Mon, 04 Aug 2008 15:02:40 +0800
Message-ID: <E1KPu5Y-0002B1-00@gondolin.me.apana.org.au>
References: <20080804065958.GA8264@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44859 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932077AbYHDHCq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 03:02:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KPu5Z-0001ou-5D
	for <linux-crypto@vger.kernel.org>; Mon, 04 Aug 2008 17:02:42 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: api - Use test infrastructure

This patch makes use of the new testing infrastructure by requiring
algorithms to pass a run-time test before they're made available to
users.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c        |  140 ++++++++++++++++++++++++++++++++++++++++++-------
 crypto/algboss.c       |   68 ++++++++++++++++++++++-
 crypto/api.c           |   73 ++++++++++++++++++++-----
 crypto/internal.h      |    7 +-
 crypto/proc.c          |    3 +
 include/linux/crypto.h |    8 ++
 6 files changed, 258 insertions(+), 41 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index e9154c1..05ac0a9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -21,6 +21,8 @@
 
 #include "internal.h"
 
+static void crypto_remove_final(struct list_head *list);
+
 static LIST_HEAD(crypto_template_list);
 
 void crypto_larval_error(const char *name, u32 type, u32 mask)
@@ -126,23 +128,97 @@ static void crypto_remove_spawns(struct list_head *spawns,
 	}
 }
 
-static int __crypto_register_alg(struct crypto_alg *alg,
-				 struct list_head *list)
+static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_alg *q;
+	struct crypto_larval *larval;
 	int ret = -EAGAIN;
 
 	if (crypto_is_dead(alg))
-		goto out;
+		goto err;
 
 	INIT_LIST_HEAD(&alg->cra_users);
 
+	/* No cheating! */
+	alg->cra_flags &= ~CRYPTO_ALG_TESTED;
+
 	ret = -EEXIST;
 
 	atomic_set(&alg->cra_refcnt, 1);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (q == alg)
-			goto out;
+			goto err;
+
+		if (crypto_is_larval(q)) {
+			if (!strcmp(alg->cra_driver_name, q->cra_driver_name))
+				goto err;
+			continue;
+		}
+
+		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
+		    !strcmp(q->cra_name, alg->cra_driver_name))
+			goto err;
+	}
+
+	larval = crypto_larval_alloc(alg->cra_name,
+				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
+	if (IS_ERR(larval))
+		goto out;
+
+	ret = -ENOENT;
+	larval->adult = crypto_mod_get(alg);
+	if (!larval->adult)
+		goto free_larval;
+
+	atomic_set(&larval->alg.cra_refcnt, 1);
+	memcpy(larval->alg.cra_driver_name, alg->cra_driver_name,
+	       CRYPTO_MAX_ALG_NAME);
+	larval->alg.cra_priority = alg->cra_priority;
+
+	list_add(&alg->cra_list, &crypto_alg_list);
+	list_add(&larval->alg.cra_list, &crypto_alg_list);
+
+out:	
+	return larval;
+
+free_larval:
+	kfree(larval);
+err:
+	larval = ERR_PTR(ret);
+	goto out;
+}
+
+void crypto_alg_tested(const char *name, int err)
+{
+	struct crypto_larval *test;
+	struct crypto_alg *alg;
+	struct crypto_alg *q;
+	LIST_HEAD(list);
+
+	down_write(&crypto_alg_sem);
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (!crypto_is_larval(q))
+			continue;
+
+		test = (struct crypto_larval *)q;
+
+		if (!strcmp(q->cra_driver_name, name))
+			goto found;
+	}
+
+	printk(KERN_ERR "alg: Unexpected test result for %s: %d\n", name, err);
+	goto unlock;
+
+found:
+	alg = test->adult;
+	if (err || list_empty(&alg->cra_list))
+		goto complete;
+
+	alg->cra_flags |= CRYPTO_ALG_TESTED;
+
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (q == alg)
+			continue;
 
 		if (crypto_is_moribund(q))
 			continue;
@@ -178,17 +254,18 @@ static int __crypto_register_alg(struct crypto_alg *alg,
 		    q->cra_priority > alg->cra_priority)
 			continue;
 
-		crypto_remove_spawns(&q->cra_users, list, alg->cra_flags);
+		crypto_remove_spawns(&q->cra_users, &list, alg->cra_flags);
 	}
-	
-	list_add(&alg->cra_list, &crypto_alg_list);
 
-	crypto_notify(CRYPTO_MSG_ALG_REGISTER, alg);
-	ret = 0;
+complete:
+	complete_all(&test->completion);
 
-out:	
-	return ret;
+unlock:
+	up_write(&crypto_alg_sem);
+
+	crypto_remove_final(&list);
 }
+EXPORT_SYMBOL_GPL(crypto_alg_tested);
 
 static void crypto_remove_final(struct list_head *list)
 {
@@ -201,9 +278,24 @@ static void crypto_remove_final(struct list_head *list)
 	}
 }
 
+static void crypto_wait_for_test(struct crypto_larval *larval)
+{
+	int err;
+
+	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
+	if (WARN_ON(err != NOTIFY_STOP))
+		goto out;
+
+	err = wait_for_completion_interruptible(&larval->completion);
+	WARN_ON(err);
+
+out:
+	crypto_larval_kill(&larval->alg);
+}
+
 int crypto_register_alg(struct crypto_alg *alg)
 {
-	LIST_HEAD(list);
+	struct crypto_larval *larval;
 	int err;
 
 	err = crypto_check_alg(alg);
@@ -211,11 +303,14 @@ int crypto_register_alg(struct crypto_alg *alg)
 		return err;
 
 	down_write(&crypto_alg_sem);
-	err = __crypto_register_alg(alg, &list);
+	larval = __crypto_register_alg(alg);
 	up_write(&crypto_alg_sem);
 
-	crypto_remove_final(&list);
-	return err;
+	if (IS_ERR(larval))
+		return PTR_ERR(larval);
+
+	crypto_wait_for_test(larval);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
 
@@ -333,8 +428,8 @@ EXPORT_SYMBOL_GPL(crypto_lookup_template);
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst)
 {
-	LIST_HEAD(list);
-	int err = -EINVAL;
+	struct crypto_larval *larval;
+	int err;
 
 	err = crypto_check_alg(&inst->alg);
 	if (err)
@@ -344,8 +439,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	down_write(&crypto_alg_sem);
 
-	err = __crypto_register_alg(&inst->alg, &list);
-	if (err)
+	larval = __crypto_register_alg(&inst->alg);
+	if (IS_ERR(larval))
 		goto unlock;
 
 	hlist_add_head(&inst->list, &tmpl->instances);
@@ -354,7 +449,12 @@ int crypto_register_instance(struct crypto_template *tmpl,
 unlock:
 	up_write(&crypto_alg_sem);
 
-	crypto_remove_final(&list);
+	err = PTR_ERR(larval);
+	if (IS_ERR(larval))
+		goto err;
+
+	crypto_wait_for_test(larval);
+	err = 0;
 
 err:
 	return err;
diff --git a/crypto/algboss.c b/crypto/algboss.c
index 455134c..b36f1b1 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -47,6 +47,12 @@ struct cryptomgr_param {
 	char template[CRYPTO_MAX_ALG_NAME];
 };
 
+struct crypto_test_param {
+	char driver[CRYPTO_MAX_ALG_NAME];
+	char alg[CRYPTO_MAX_ALG_NAME];
+	u32 type;
+};
+
 static int cryptomgr_probe(void *data)
 {
 	struct cryptomgr_param *param = data;
@@ -169,13 +175,65 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 
 	param->type.attr.rta_len = sizeof(param->type);
 	param->type.attr.rta_type = CRYPTOA_TYPE;
-	param->type.data.type = larval->alg.cra_flags;
-	param->type.data.mask = larval->mask;
+	param->type.data.type = larval->alg.cra_flags & ~CRYPTO_ALG_TESTED;
+	param->type.data.mask = larval->mask & ~CRYPTO_ALG_TESTED;
 	param->tb[0] = &param->type.attr;
 
 	memcpy(param->larval, larval->alg.cra_name, CRYPTO_MAX_ALG_NAME);
 
-	thread = kthread_run(cryptomgr_probe, param, "cryptomgr");
+	thread = kthread_run(cryptomgr_probe, param, "cryptomgr_probe");
+	if (IS_ERR(thread))
+		goto err_free_param;
+
+	return NOTIFY_STOP;
+
+err_free_param:
+	kfree(param);
+err_put_module:
+	module_put(THIS_MODULE);
+err:
+	return NOTIFY_OK;
+}
+
+static int cryptomgr_test(void *data)
+{
+	struct crypto_test_param *param = data;
+	u32 type = param->type;
+	int err = 0;
+
+	if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
+	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV))
+		goto skiptest;
+
+	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER)
+		goto skiptest;
+
+	err = alg_test(param->driver, param->alg, 0, CRYPTO_ALG_TESTED);
+
+skiptest:
+	crypto_alg_tested(param->driver, err);
+
+	kfree(param);
+	module_put_and_exit(0);
+}
+
+static int cryptomgr_schedule_test(struct crypto_alg *alg)
+{
+	struct task_struct *thread;
+	struct crypto_test_param *param;
+
+	if (!try_module_get(THIS_MODULE))
+		goto err;
+
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param)
+		goto err_put_module;
+
+	memcpy(param->driver, alg->cra_driver_name, sizeof(param->driver));
+	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
+	param->type = alg->cra_flags;
+
+	thread = kthread_run(cryptomgr_test, param, "cryptomgr_test");
 	if (IS_ERR(thread))
 		goto err_free_param;
 
@@ -195,9 +253,11 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 	switch (msg) {
 	case CRYPTO_MSG_ALG_REQUEST:
 		return cryptomgr_schedule_probe(data);
+	case CRYPTO_MSG_ALG_REGISTER:
+		return cryptomgr_schedule_test(data);
 	}
 
-	return NOTIFY_DONE;
+	return NOTIFY_OK;
 }
 
 static struct notifier_block cryptomgr_notifier = {
diff --git a/crypto/api.c b/crypto/api.c
index 0906ced..0444d24 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -55,6 +55,11 @@ void crypto_mod_put(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_mod_put);
 
+static inline int crypto_is_test_larval(struct crypto_larval *larval)
+{
+	return larval->alg.cra_driver_name[0];
+}
+
 static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 					      u32 mask)
 {
@@ -71,6 +76,7 @@ static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 			continue;
 
 		if (crypto_is_larval(q) &&
+		    !crypto_is_test_larval((struct crypto_larval *)q) &&
 		    ((struct crypto_larval *)q)->mask != mask)
 			continue;
 
@@ -104,10 +110,8 @@ static void crypto_larval_destroy(struct crypto_alg *alg)
 	kfree(larval);
 }
 
-static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
-					      u32 mask)
+struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 {
-	struct crypto_alg *alg;
 	struct crypto_larval *larval;
 
 	larval = kzalloc(sizeof(*larval), GFP_KERNEL);
@@ -119,10 +123,25 @@ static struct crypto_alg *crypto_larval_alloc(const char *name, u32 type,
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
 
-	atomic_set(&larval->alg.cra_refcnt, 2);
 	strlcpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
 	init_completion(&larval->completion);
 
+	return larval;
+}
+EXPORT_SYMBOL_GPL(crypto_larval_alloc);
+
+static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
+					    u32 mask)
+{
+	struct crypto_alg *alg;
+	struct crypto_larval *larval;
+
+	larval = crypto_larval_alloc(name, type, mask);
+	if (IS_ERR(larval))
+		return ERR_CAST(larval);
+
+	atomic_set(&larval->alg.cra_refcnt, 2);
+
 	down_write(&crypto_alg_sem);
 	alg = __crypto_alg_lookup(name, type, mask);
 	if (!alg) {
@@ -152,14 +171,23 @@ EXPORT_SYMBOL_GPL(crypto_larval_kill);
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval = (void *)alg;
+	long timeout;
+
+	timeout = wait_for_completion_interruptible_timeout(
+		&larval->completion, 60 * HZ);
 
-	wait_for_completion_interruptible_timeout(&larval->completion, 60 * HZ);
 	alg = larval->adult;
-	if (alg) {
-		if (!crypto_mod_get(alg))
-			alg = ERR_PTR(-EAGAIN);
-	} else
+	if (timeout < 0)
+		alg = ERR_PTR(-EINTR);
+	else if (!timeout)
+		alg = ERR_PTR(-ETIMEDOUT);
+	else if (!alg)
 		alg = ERR_PTR(-ENOENT);
+	else if (crypto_is_test_larval(larval) &&
+		 !(alg->cra_flags & CRYPTO_ALG_TESTED))
+		alg = ERR_PTR(-EAGAIN);
+	else if (!crypto_mod_get(alg))
+		alg = ERR_PTR(-EAGAIN);
 	crypto_mod_put(&larval->alg);
 
 	return alg;
@@ -192,25 +220,40 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;
 
-	return crypto_larval_alloc(name, type, mask);
+	return crypto_larval_add(name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_larval_lookup);
 
+int crypto_probing_notify(unsigned long val, void *v)
+{
+	int ok;
+
+	ok = blocking_notifier_call_chain(&crypto_chain, val, v);
+	if (ok == NOTIFY_DONE) {
+		request_module("cryptomgr");
+		ok = blocking_notifier_call_chain(&crypto_chain, val, v);
+	}
+
+	return ok;
+}
+EXPORT_SYMBOL_GPL(crypto_probing_notify);
+
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
 	struct crypto_alg *larval;
 	int ok;
 
+	if (!(mask & CRYPTO_ALG_TESTED)) {
+		type |= CRYPTO_ALG_TESTED;
+		mask |= CRYPTO_ALG_TESTED;
+	}
+
 	larval = crypto_larval_lookup(name, type, mask);
 	if (IS_ERR(larval) || !crypto_is_larval(larval))
 		return larval;
 
-	ok = crypto_notify(CRYPTO_MSG_ALG_REQUEST, larval);
-	if (ok == NOTIFY_DONE) {
-		request_module("cryptomgr");
-		ok = crypto_notify(CRYPTO_MSG_ALG_REQUEST, larval);
-	}
+	ok = crypto_probing_notify(CRYPTO_MSG_ALG_REQUEST, larval);
 
 	if (ok == NOTIFY_STOP)
 		alg = crypto_larval_wait(larval);
diff --git a/crypto/internal.h b/crypto/internal.h
index 48cb704..fc93743 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -94,9 +94,11 @@ void crypto_exit_digest_ops(struct crypto_tfm *tfm);
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
 void crypto_exit_compress_ops(struct crypto_tfm *tfm);
 
+struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask);
 void crypto_larval_error(const char *name, u32 type, u32 mask);
+void crypto_alg_tested(const char *name, int err);
 
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
@@ -107,6 +109,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 int crypto_register_notifier(struct notifier_block *nb);
 int crypto_unregister_notifier(struct notifier_block *nb);
+int crypto_probing_notify(unsigned long val, void *v);
 
 int __init testmgr_init(void);
 void testmgr_exit(void);
@@ -142,9 +145,9 @@ static inline int crypto_is_moribund(struct crypto_alg *alg)
 	return alg->cra_flags & (CRYPTO_ALG_DEAD | CRYPTO_ALG_DYING);
 }
 
-static inline int crypto_notify(unsigned long val, void *v)
+static inline void crypto_notify(unsigned long val, void *v)
 {
-	return blocking_notifier_call_chain(&crypto_chain, val, v);
+	blocking_notifier_call_chain(&crypto_chain, val, v);
 }
 
 #endif	/* _CRYPTO_INTERNAL_H */
diff --git a/crypto/proc.c b/crypto/proc.c
index c6ede1e..1d616ad 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -46,6 +46,9 @@ static int c_show(struct seq_file *m, void *p)
 	seq_printf(m, "module       : %s\n", module_name(alg->cra_module));
 	seq_printf(m, "priority     : %d\n", alg->cra_priority);
 	seq_printf(m, "refcnt       : %d\n", atomic_read(&alg->cra_refcnt));
+	seq_printf(m, "selftest     : %s\n",
+		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
+		   "passed" : "unknown");
 	
 	switch (alg->cra_flags & (CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_LARVAL)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7ea0a4b..81d994a 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -61,6 +61,14 @@
 #define CRYPTO_ALG_GENIV		0x00000200
 
 /*
+ * Set if the algorithm has passed automated run-time testing.  Note that
+ * if there is no run-time testing for a given algorithm it is considered
+ * to have passed.
+ */
+
+#define CRYPTO_ALG_TESTED		0x00000400
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
