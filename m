Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47649C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 07:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AD9760F46
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Sep 2021 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhIMHOM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Sep 2021 03:14:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55096 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237532AbhIMHOI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Sep 2021 03:14:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mPg96-0000SU-IE; Mon, 13 Sep 2021 15:12:52 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mPg95-0003yg-Sf; Mon, 13 Sep 2021 15:12:51 +0800
Date:   Mon, 13 Sep 2021 15:12:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Vladis Dronov <vdronov@redhat.com>, Simo Sorce <ssorce@redhat.com>
Subject: [PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20210913071251.GA15235@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When complex algorithms that depend on other algorithms are built
into the kernel, the order of registration must be done such that
the underlying algorithms are ready before the ones on top are
registered.  As otherwise they would fail during the self-test
which is required during registration.

In the past we have used subsystem initialisation ordering to
guarantee this.  The number of such precedence levels are limited
and they may cause ripple effects in other subsystems.

This patch solves this problem by delaying all self-tests during
boot-up for built-in algorithms.  They will be tested either when
something else in the kernel requests for them, or when we have
finished registering all built-in algorithms, whichever comes
earlier.

Reported-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 43f999dba4dc..99aa23a50084 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -389,29 +389,10 @@ void crypto_remove_final(struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(crypto_remove_final);
 
-static void crypto_wait_for_test(struct crypto_larval *larval)
-{
-	int err;
-
-	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
-	if (err != NOTIFY_STOP) {
-		if (WARN_ON(err != NOTIFY_DONE))
-			goto out;
-		crypto_alg_tested(larval->alg.cra_driver_name, 0);
-	}
-
-	err = wait_for_completion_killable(&larval->completion);
-	WARN_ON(err);
-	if (!err)
-		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
-
-out:
-	crypto_larval_kill(&larval->alg);
-}
-
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
+	bool tested;
 	int err;
 
 	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
@@ -421,12 +402,15 @@ int crypto_register_alg(struct crypto_alg *alg)
 
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg);
+	tested = static_key_enabled(&crypto_boot_test_finished);
+	larval->tested = tested;
 	up_write(&crypto_alg_sem);
 
 	if (IS_ERR(larval))
 		return PTR_ERR(larval);
 
-	crypto_wait_for_test(larval);
+	if (tested)
+		crypto_wait_for_test(larval);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
@@ -633,6 +617,8 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (IS_ERR(larval))
 		goto unlock;
 
+	larval->tested = true;
+
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
 
@@ -1261,9 +1247,48 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
 EXPORT_SYMBOL_GPL(crypto_stats_skcipher_decrypt);
 #endif
 
+static void __init crypto_start_tests(void)
+{
+	for (;;) {
+		struct crypto_larval *larval = NULL;
+		struct crypto_alg *q;
+
+		down_write(&crypto_alg_sem);
+
+		list_for_each_entry(q, &crypto_alg_list, cra_list) {
+			struct crypto_larval *l;
+
+			if (!crypto_is_larval(q))
+				continue;
+
+			l = (void *)q;
+
+			if (!crypto_is_test_larval(l))
+				continue;
+
+			if (l->tested)
+				continue;
+
+			l->tested = true;
+			larval = l;
+			break;
+		}
+
+		up_write(&crypto_alg_sem);
+
+		if (!larval)
+			break;
+
+		crypto_wait_for_test(larval);
+	}
+
+	static_branch_enable(&crypto_boot_test_finished);
+}
+
 static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
+	crypto_start_tests();
 	return 0;
 }
 
@@ -1272,7 +1297,7 @@ static void __exit crypto_algapi_exit(void)
 	crypto_exit_proc();
 }
 
-module_init(crypto_algapi_init);
+late_initcall(crypto_algapi_init);
 module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/crypto/api.c b/crypto/api.c
index c4eda56cff89..77fbf04fdc38 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -12,6 +12,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
@@ -30,6 +31,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
+DEFINE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
 
 struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
@@ -47,11 +50,6 @@ void crypto_mod_put(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_mod_put);
 
-static inline int crypto_is_test_larval(struct crypto_larval *larval)
-{
-	return larval->alg.cra_driver_name[0];
-}
-
 static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 					      u32 mask)
 {
@@ -163,11 +161,55 @@ void crypto_larval_kill(struct crypto_alg *alg)
 }
 EXPORT_SYMBOL_GPL(crypto_larval_kill);
 
+void crypto_wait_for_test(struct crypto_larval *larval)
+{
+	int err;
+
+	err = crypto_probing_notify(CRYPTO_MSG_ALG_REGISTER, larval->adult);
+	if (err != NOTIFY_STOP) {
+		if (WARN_ON(err != NOTIFY_DONE))
+			goto out;
+		crypto_alg_tested(larval->alg.cra_driver_name, 0);
+	}
+
+	err = wait_for_completion_killable(&larval->completion);
+	WARN_ON(err);
+	if (!err)
+		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
+
+out:
+	crypto_larval_kill(&larval->alg);
+}
+EXPORT_SYMBOL_GPL(crypto_wait_for_test);
+
+static void crypto_start_test(struct crypto_larval *larval)
+{
+	if (!crypto_is_test_larval(larval))
+		return;
+
+	if (larval->tested)
+		return;
+
+	down_write(&crypto_alg_sem);
+	if (larval->tested) {
+		up_write(&crypto_alg_sem);
+		return;
+	}
+
+	larval->tested = true;
+	up_write(&crypto_alg_sem);
+
+	crypto_wait_for_test(larval);
+}
+
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval = (void *)alg;
 	long timeout;
 
+	if (!static_branch_likely(&crypto_boot_test_finished))
+		crypto_start_test(larval);
+
 	timeout = wait_for_completion_killable_timeout(
 		&larval->completion, 60 * HZ);
 
diff --git a/crypto/internal.h b/crypto/internal.h
index f00869af689f..5e07e77bc9a5 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
+#include <linux/jump_label.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
@@ -27,6 +28,7 @@ struct crypto_larval {
 	struct crypto_alg *adult;
 	struct completion completion;
 	u32 mask;
+	bool tested;
 };
 
 enum {
@@ -45,6 +47,8 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
+DECLARE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
 void __exit crypto_exit_proc(void);
@@ -70,6 +74,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask);
 
 struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask);
 void crypto_larval_kill(struct crypto_alg *alg);
+void crypto_wait_for_test(struct crypto_larval *larval);
 void crypto_alg_tested(const char *name, int err);
 
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
@@ -156,5 +161,10 @@ static inline void crypto_yield(u32 flags)
 		cond_resched();
 }
 
+static inline int crypto_is_test_larval(struct crypto_larval *larval)
+{
+	return larval->alg.cra_driver_name[0];
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
