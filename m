Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7812C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiKJIPK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiKJIPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F83AE4D
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBEA861DB1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C340C433D7
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068105;
        bh=BZEvWbxY95nJBhrcWwnIURZrOns/m0Y4Ua+jzzKP1ew=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QLWSjn+oWCKqaa8HGKdp0gtgsVGcgnlTvq3HMknBQzJiehZ64opOfqneplaFnwp/o
         8Iy0h+vmOjf8YzVITYtCHcfCC3jUpfNfttw3JQ5QSuk9mInl85hNJg9T6to5QuMKpM
         XFjeISCPIhG659fuyUU5ZuZ/RjgDWYXebSW6/9HpIhblrPInCvnuyFhUlMoWXzHTsh
         LjvBGHv1I1s9WsnWnyV185yiVKH6aIqF9zd6ItqN0/wRNDKEm31CS5XH14X1Hi2u5i
         /V16RMG3eFc/azaPq4U/k+Il+IYFEBnK8WVM3BWuwDbnCVGUnF6XGTup0yO3UkxUAM
         xjU15EiWinj4A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/6] crypto: optimize algorithm registration when self-tests disabled
Date:   Thu, 10 Nov 2022 00:13:41 -0800
Message-Id: <20221110081346.336046-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110081346.336046-1-ebiggers@kernel.org>
References: <20221110081346.336046-1-ebiggers@kernel.org>
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
 crypto/algapi.c | 151 ++++++++++++++++++++++++++----------------------
 1 file changed, 82 insertions(+), 69 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5c69ff8e8fa5c..8bbbd5dbbe157 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -222,12 +222,62 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
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
@@ -248,7 +298,8 @@ static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 	return larval;
 }
 
-static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
+static struct crypto_larval *
+__crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
 {
 	struct crypto_alg *q;
 	struct crypto_larval *larval;
@@ -259,9 +310,6 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
 	INIT_LIST_HEAD(&alg->cra_users);
 
-	/* No cheating! */
-	alg->cra_flags &= ~CRYPTO_ALG_TESTED;
-
 	ret = -EEXIST;
 
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -288,12 +336,17 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 
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
@@ -341,7 +394,10 @@ void crypto_alg_tested(const char *name, int err)
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
-	/* Only satisfy larval waiters if we are the best. */
+	/*
+	 * If a higher-priority implementation of the same algorithm is
+	 * currently being tested, then don't fulfill request larvals.
+	 */
 	best = true;
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (crypto_is_moribund(q) || !crypto_is_larval(q))
@@ -356,47 +412,7 @@ void crypto_alg_tested(const char *name, int err)
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
@@ -423,7 +439,7 @@ EXPORT_SYMBOL_GPL(crypto_remove_final);
 int crypto_register_alg(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
-	bool test_started;
+	LIST_HEAD(algs_to_put);
 	int err;
 
 	alg->cra_flags &= ~CRYPTO_ALG_DEAD;
@@ -432,17 +448,16 @@ int crypto_register_alg(struct crypto_alg *alg)
 		return err;
 
 	down_write(&crypto_alg_sem);
-	larval = __crypto_register_alg(alg);
-	test_started = static_key_enabled(&crypto_boot_test_finished);
+	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval))
-		larval->test_started = test_started;
+		larval->test_started = static_key_enabled(&crypto_boot_test_finished);
 	up_write(&crypto_alg_sem);
 
-	if (IS_ERR_OR_NULL(larval))
+	if (IS_ERR(larval))
 		return PTR_ERR(larval);
-
-	if (test_started)
+	if (larval && larval->test_started)
 		crypto_wait_for_test(larval);
+	crypto_remove_final(&algs_to_put);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_register_alg);
@@ -619,6 +634,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	struct crypto_larval *larval;
 	struct crypto_spawn *spawn;
 	u32 fips_internal = 0;
+	LIST_HEAD(algs_to_put);
 	int err;
 
 	err = crypto_check_alg(&inst->alg);
@@ -650,7 +666,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	inst->alg.cra_flags |= (fips_internal & CRYPTO_ALG_FIPS_INTERNAL);
 
-	larval = __crypto_register_alg(&inst->alg);
+	larval = __crypto_register_alg(&inst->alg, &algs_to_put);
 	if (IS_ERR(larval))
 		goto unlock;
 	else if (larval)
@@ -662,15 +678,12 @@ int crypto_register_instance(struct crypto_template *tmpl,
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
 

base-commit: f67dd6ce0723ad013395f20a3f79d8a437d3f455
-- 
2.38.1

