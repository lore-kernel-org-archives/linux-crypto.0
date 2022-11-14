Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3444C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiKNANP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiKNANN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDA9DEDC
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD06E60DF0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECD1C4347C
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384791;
        bh=n3oCR8QJ8+fRQAw4Chfym3kQIHqiOiIl2KSqxQ9tabs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pNVRRf2magBrPwaZsa/ecL6QwXlwUgi/dgSU6fpxoH3N8miQ+D6eZU194KzsYNNWu
         b2A16in25THpX4JlpOJA0QMQy7rLEAFomlc99nxkYuPOKa81BRMWLhVIiAi9BR3pFp
         cn23Vjh/ewi2WlG3CD/mISXwvkcf25m79EwfAlE+IzEJi/4HXd2RVvYyoO6WiCuFiu
         IGBkcQZmPloAKFvAmJZO9Fh7ZfYvSz04dc/4lMhoIearxQNxXBapQjdA8cIBbi+pbT
         lZoM9gjk/fefmJa+Y/5KcbvM9KYUkt/+xo4pPO3eETZcMcSFKUYoGRE49aCoLYOlJ9
         NwOs87uLhXa5Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/6] crypto: compile out crypto_boot_test_finished when tests disabled
Date:   Sun, 13 Nov 2022 16:12:35 -0800
Message-Id: <20221114001238.163209-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
References: <20221114001238.163209-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto_boot_test_finished static key is unnecessary when self-tests
are disabled in the kconfig, so optimize it out accordingly, along with
the entirety of crypto_start_tests().  This mainly avoids the overhead
of an unnecessary static_branch_enable() on every boot.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c   |  7 +++++--
 crypto/api.c      |  8 +++++---
 crypto/internal.h | 20 +++++++++++++++++++-
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 851b247f043d3..d08f864f08bee 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -454,7 +454,7 @@ int crypto_register_alg(struct crypto_alg *alg)
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval)) {
-		test_started = static_key_enabled(&crypto_boot_test_finished);
+		test_started = crypto_boot_test_finished();
 		larval->test_started = test_started;
 	}
 	up_write(&crypto_alg_sem);
@@ -1253,6 +1253,9 @@ EXPORT_SYMBOL_GPL(crypto_stats_skcipher_decrypt);
 
 static void __init crypto_start_tests(void)
 {
+	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+		return;
+
 	for (;;) {
 		struct crypto_larval *larval = NULL;
 		struct crypto_alg *q;
@@ -1286,7 +1289,7 @@ static void __init crypto_start_tests(void)
 		crypto_wait_for_test(larval);
 	}
 
-	static_branch_enable(&crypto_boot_test_finished);
+	set_crypto_boot_test_finished();
 }
 
 static int __init crypto_algapi_init(void)
diff --git a/crypto/api.c b/crypto/api.c
index 52ce10a353660..b022702f64367 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -31,8 +31,10 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
-DEFINE_STATIC_KEY_FALSE(crypto_boot_test_finished);
-EXPORT_SYMBOL_GPL(crypto_boot_test_finished);
+#ifndef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
+EXPORT_SYMBOL_GPL(__crypto_boot_test_finished);
+#endif
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
 
@@ -202,7 +204,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	struct crypto_larval *larval = (void *)alg;
 	long timeout;
 
-	if (!static_branch_likely(&crypto_boot_test_finished))
+	if (!crypto_boot_test_finished())
 		crypto_start_test(larval);
 
 	timeout = wait_for_completion_killable_timeout(
diff --git a/crypto/internal.h b/crypto/internal.h
index c08385571853e..932f0aafddc32 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -47,7 +47,25 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-DECLARE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+static inline bool crypto_boot_test_finished(void)
+{
+	return true;
+}
+static inline void set_crypto_boot_test_finished(void)
+{
+}
+#else
+DECLARE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
+static inline bool crypto_boot_test_finished(void)
+{
+	return static_branch_likely(&__crypto_boot_test_finished);
+}
+static inline void set_crypto_boot_test_finished(void)
+{
+	static_branch_enable(&__crypto_boot_test_finished);
+}
+#endif /* !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
 
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
-- 
2.38.1

