Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A570BC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiKNANR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiKNANP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B061007F
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D5DCB80D0D
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC7FC433D7
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384790;
        bh=Is7UQHdoOoRSz6z+lWv6hBxzZdY6SFFlqSgPhXGkVZs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a6Mxm6CBToddlt2gICBeGUwy0Dlvy67J6KD6xczwDZ1cEy8EY/MILYARusLv/liBj
         rEiVQBH4XaIj7d9d2kpRv0iSeR2OCTaplbogy0S169kBXbtgNDxiwWqOs9hoaPGsuQ
         D3CSiWSnjLYHUDpkgRQQvCooa30t9nQKHqr+3rRQTF9K3nlHNOxEomcJ23nvB0i3p/
         IQn3mItdfvS3phQbLcNGDd/DH6qoHUfZhnRXDR87vs47YIQ9azV+fNmLdPyMPUaUm6
         TADx9quilVaVT2vv1IVm+vI6J1CLoFuqSoSSz+R2Wf2nvYkGvuAhM5cSeRw+21ET6R
         CdQdbJp06g3/Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 1/6] crypto: optimize algorithm registration when self-tests disabled
Date:   Sun, 13 Nov 2022 16:12:33 -0800
Message-Id: <20221114001238.163209-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
References: <20221114001238.163209-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, registering an algorithm with the crypto API always causes a
notification to be posted to the "cryptomgr", which then creates a
kthread to self-test the algorithm.  However, if self-tests are disabled
in the kconfig (as is the default option), then this kthread just
notifies waiters that the algorithm has been tested, then exits.

This causes a significant amount of overhead, especially in the kthread
creation and destruction, which is not necessary at all.  For example,
in a quick test I found that booting a "minimum" x86_64 kernel with all
the crypto options enabled (except for the self-tests) takes about 400ms
until PID 1 can start.  Of that, a full 13ms is spent just doing this
pointless dance, involving a kthread being created, run, and destroyed
over 200 times.  That's over 3% of the entire kernel start time.

Fix this by just skipping the creation of the test larval and the
posting of the registration notification entirely, when self-tests are
disabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c | 154 +++++++++++++++++++++++++++---------------------
 crypto/api.c    |   3 -
 2 files changed, 86 insertions(+), 71 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5c69ff8e8fa5c..950195e90bfc9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -222,12 +222,64 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 }
 EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
+static void crypto_alg_finish_registration(struct crypto_alg *alg,
+					   bool fulfill_requests,
+					   struct list_head *algs_to_put)
+{
+	struct crypto_alg *q;
+
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (q == alg)
+			continue;
+
+		if (crypto_is_moribund(q))
+			continue;
+
+		if (crypto_is_larval(q)) {
+			struct crypto_larval *larval = (void *)q;
+
+			/*
+			 * Check to see if either our generic name or
+			 * specific name can satisfy the name requested
+			 * by the larval entry q.
+			 */
+			if (strcmp(alg->cra_name, q->cra_name) &&
+			    strcmp(alg->cra_driver_name, q->cra_name))
+				continue;
+
+			if (larval->adult)
+				continue;
+			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
+				continue;
+
+			if (fulfill_requests && crypto_mod_get(alg))
+				larval->adult = alg;
+			else
+				larval->adult = ERR_PTR(-EAGAIN);
+
+			continue;
+		}
+
+		if (strcmp(alg->cra_name, q->cra_name))
+			continue;
+
+		if (strcmp(alg->cra_driver_name, q->cra_driver_name) &&
+		    q->cra_priority > alg->cra_priority)
+			continue;
+
+		crypto_remove_spawns(q, algs_to_put, alg);
+	}
+
+	crypto_notify(CRYPTO_MSG_ALG_LOADED, alg);
+}
+
 static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
 
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER))
-		return NULL;
+	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER) ||
+	    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+		return NULL; /* No self-test needed */
 
 	larval = crypto_larval_alloc(alg->cra_name,
 				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
@@ -248,7 +300,8 @@ static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 	return larval;
 }
 
-static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
+static struct crypto_larval *
+__crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 {
 	struct crypto_alg *q;
 	struct crypto_larval *larval;
@@ -259,9 +312,6 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
 	INIT_LIST_HEAD(&alg->cra_users);
 
-	/* No cheating! */
-	alg->cra_flags &= ~CRYPTO_ALG_TESTED;
-
 	ret = -EEXIST;
 
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -288,12 +338,17 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
 	list_add(&alg->cra_list, &crypto_alg_list);
 
-	if (larval)
+	crypto_stats_init(alg);
+
+	if (larval) {
+		/* No cheating! */
+		alg->cra_flags &= ~CRYPTO_ALG_TESTED;
+
 		list_add(&larval->alg.cra_list, &crypto_alg_list);
-	else
+	} else {
 		alg->cra_flags |= CRYPTO_ALG_TESTED;
-
-	crypto_stats_init(alg);
+		crypto_alg_finish_registration(alg, true, algs_to_put);
+	}
 
 out:
 	return larval;
@@ -341,7 +396,10 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
-	/* Only satisfy larval waiters if we are the best. */
+	/*
+	 * If a higher-priority implementation of the same algorithm is
+	 * currently being tested, then don't fulfill request larvals.
+	 */
 	best = true;
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (crypto_is_moribund(q) || !crypto_is_larval(q))
@@ -356,47 +414,7 @@ void crypto_alg_tested(const char *name, int err)
 		}
 	}
 
-	list_for_each_entry(q, &crypto_alg_list, cra_list) {
-		if (q == alg)
-			continue;
-
-		if (crypto_is_moribund(q))
-			continue;
-
-		if (crypto_is_larval(q)) {
-			struct crypto_larval *larval = (void *)q;
-
-			/*
-			 * Check to see if either our generic name or
-			 * specific name can satisfy the name requested
-			 * by the larval entry q.
-			 */
-			if (strcmp(alg->cra_name, q->cra_name) &&
-			    strcmp(alg->cra_driver_name, q->cra_name))
-				continue;
-
-			if (larval->adult)
-				continue;
-			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
-				continue;
-
-			if (best && crypto_mod_get(alg))
-				larval->adult = alg;
-			else
-				larval->adult = ERR_PTR(-EAGAIN);
-
-			continue;
-		}
-
-		if (strcmp(alg->cra_name, q->cra_name))
-			continue;
-
-		if (strcmp(alg->cra_driver_name, q->cra_driver_name) &&
-		    q->cra_priority > alg->cra_priority)
-			continue;
-
-		crypto_remove_spawns(q, &list, alg);
-	}
+	crypto_alg_finish_registration(alg, best, &list);
 
 complete:
 	complete_all(&test->completion);
@@ -423,7 +441,8 @@ EXPORT_SYMBOL_GPL(crypto_remove_final);
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
-	bool test_started;
+	LIST_HEAD(algs_to_put);
+	bool test_started = false;
 	int err;
 
 	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
@@ -432,17 +451,18 @@ int crypto_register_alg(struct crypto_alg *alg)
 		return err;
 
 	down_write(&crypto_alg_sem);
-	larval = __crypto_register_alg(alg);
-	test_started = static_key_enabled(&crypto_boot_test_finished);
-	if (!IS_ERR_OR_NULL(larval))
+	larval = __crypto_register_alg(alg, &algs_to_put);
+	if (!IS_ERR_OR_NULL(larval)) {
+		test_started = static_key_enabled(&crypto_boot_test_finished);
 		larval->test_started = test_started;
+	}
 	up_write(&crypto_alg_sem);
 
-	if (IS_ERR_OR_NULL(larval))
+	if (IS_ERR(larval))
 		return PTR_ERR(larval);
-
 	if (test_started)
 		crypto_wait_for_test(larval);
+	crypto_remove_final(&algs_to_put);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
@@ -619,6 +639,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	struct crypto_larval *larval;
 	struct crypto_spawn *spawn;
 	u32 fips_internal = 0;
+	LIST_HEAD(algs_to_put);
 	int err;
 
 	err = crypto_check_alg(&inst->alg);
@@ -650,7 +671,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	inst->alg.cra_flags |= (fips_internal & CRYPTO_ALG_FIPS_INTERNAL);
 
-	larval = __crypto_register_alg(&inst->alg);
+	larval = __crypto_register_alg(&inst->alg, &algs_to_put);
 	if (IS_ERR(larval))
 		goto unlock;
 	else if (larval)
@@ -662,15 +683,12 @@ int crypto_register_instance(struct crypto_template *tmpl,
 unlock:
 	up_write(&crypto_alg_sem);
 
-	err = PTR_ERR(larval);
-	if (IS_ERR_OR_NULL(larval))
-		goto err;
-
-	crypto_wait_for_test(larval);
-	err = 0;
-
-err:
-	return err;
+	if (IS_ERR(larval))
+		return PTR_ERR(larval);
+	if (larval)
+		crypto_wait_for_test(larval);
+	crypto_remove_final(&algs_to_put);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_instance);
 
diff --git a/crypto/api.c b/crypto/api.c
index 64f2d365a8e94..52ce10a353660 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -172,9 +172,6 @@ void crypto_wait_for_test(struct crypto_larval *larval)
 
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
-	if (!err)
-		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
-
 out:
 	crypto_larval_kill(&larval->alg);
 }

base-commit: 557ffd5a4726f8b6f0dd1d4b632ae02c1c063233
-- 
2.38.1

