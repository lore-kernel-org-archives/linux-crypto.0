Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655C0C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiKJIPN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbiKJIPK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B37E1838F
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4E77B82089
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E4DC43470
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068105;
        bh=Zhs1hHWFhtMYTkWMZA8EQ/jCnYrhMwzyYJR3kWdmiyo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GHvCXqz9myQ8xxgnkYs7PzrDFIeIzGD6JjiF5ALsN5Vu75UkVtPmlMhgA1uHnAcCq
         69tkSe7JaOhWHchNrO1/oj2EpPMW4/5i85H+rQhuzV94vmboNNhS6JPtGPnDoYaBgN
         wGGyskI6mrmAQf0qWFkK9SG417PR+7/V8KyZCU/4DzuHfLelW27rr6PM3+yEz5RkqC
         P2uCRNtr/BkpNEsoz0XMO0rsp2JXb5c3PLd+DX7ZcTf88E/0Jp0JjSwSeW5qZZ7pSF
         3rWFA7yPsDdKhe/JzD+jcDBgV0q3xQmvSv+EZsf4FdxdVb+VOfGqzCMTqtaUz64jEV
         3IaLoYvqU5Srg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 3/6] crypto: compile out crypto_boot_test_finished when tests disabled
Date:   Thu, 10 Nov 2022 00:13:43 -0800
Message-Id: <20221110081346.336046-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110081346.336046-1-ebiggers@kernel.org>
References: <20221110081346.336046-1-ebiggers@kernel.org>
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
 crypto/algapi.c   | 10 ++++++++--
 crypto/api.c      |  8 +++++---
 crypto/internal.h | 13 ++++++++++++-
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index a8fa7c3f51be9..fbb4a88251bc8 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -451,7 +451,7 @@ int crypto_register_alg(struct crypto_alg *alg)
 	down_write(&crypto_alg_sem);
 	larval = __crypto_register_alg(alg, &algs_to_put);
 	if (!IS_ERR_OR_NULL(larval))
-		larval->test_started = static_key_enabled(&crypto_boot_test_finished);
+		larval->test_started = crypto_boot_test_finished();
 	up_write(&crypto_alg_sem);
 
 	if (IS_ERR(larval))
@@ -1246,6 +1246,11 @@ void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
 EXPORT_SYMBOL_GPL(crypto_stats_skcipher_decrypt);
 #endif
 
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+static void __init crypto_start_tests(void)
+{
+}
+#else
 static void __init crypto_start_tests(void)
 {
 	for (;;) {
@@ -1281,8 +1286,9 @@ static void __init crypto_start_tests(void)
 		crypto_wait_for_test(larval);
 	}
 
-	static_branch_enable(&crypto_boot_test_finished);
+	static_branch_enable(&__crypto_boot_test_finished);
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
 
 static int __init crypto_algapi_init(void)
 {
diff --git a/crypto/api.c b/crypto/api.c
index 64f2d365a8e94..3f002fe0336fc 100644
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
 
@@ -205,7 +207,7 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	struct crypto_larval *larval = (void *)alg;
 	long timeout;
 
-	if (!static_branch_likely(&crypto_boot_test_finished))
+	if (!crypto_boot_test_finished())
 		crypto_start_test(larval);
 
 	timeout = wait_for_completion_killable_timeout(
diff --git a/crypto/internal.h b/crypto/internal.h
index c08385571853e..a3bc1fbcefde7 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -47,7 +47,18 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-DECLARE_STATIC_KEY_FALSE(crypto_boot_test_finished);
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+static inline bool crypto_boot_test_finished(void)
+{
+	return true;
+}
+#else
+DECLARE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
+static inline bool crypto_boot_test_finished(void)
+{
+	return static_branch_likely(&__crypto_boot_test_finished);
+}
+#endif
 
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
-- 
2.38.1

