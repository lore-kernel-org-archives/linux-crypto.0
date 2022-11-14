Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96EBC43217
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiKNANR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbiKNANP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F31DEDC
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E040ACE0DDD
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E074DC43470
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384791;
        bh=RnzViqMF3q68FW9jQlRJ/5jwuLyYStr5QE/K7GGVpAg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ORA2WpnG9rtYCntyuQFjIMsucX9zPk76NWJ3y/okxwsqX53wre0suixv/Jij1TN63
         2mva4wxTcMAIEtAHW1hsBbjZ5av1s3nyaEmq9HBRcDBr7jvgM4AzA87Lcoc/6FERfl
         Z9qx8Q03YWKEAt1uHmkGIXGXA4RnDu7tksdzCKY2CZ/WXbdRr4tDswatc6rzMFHTKG
         qSLMJCWn+riMfO15K1w6qgkQS6ccBXrjE0SmRu65zbxwMpKw+6t6ryZC7GnVzGOsGw
         Ujk5YRfQ25aFwMb2ivls4UG+eWxti9BfNaPhwxYL+cmlLsvSna1f7qulHc7C2WOpiH
         5fwk9GO/xhuag==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 2/6] crypto: optimize registration of internal algorithms
Date:   Sun, 13 Nov 2022 16:12:34 -0800
Message-Id: <20221114001238.163209-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
References: <20221114001238.163209-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since algboss always skips testing of algorithms with the
CRYPTO_ALG_INTERNAL flag, there is no need to go through the dance of
creating the test kthread, which creates a lot of overhead.  Instead, we
can just directly finish the algorithm registration, like is now done
when self-tests are disabled entirely.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c  |  3 ++-
 crypto/algboss.c | 13 +------------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 950195e90bfc9..851b247f043d3 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -278,7 +278,8 @@ static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 	struct crypto_larval *larval;
 
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER) ||
-	    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+	    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) ||
+	    (alg->cra_flags & CRYPTO_ALG_INTERNAL))
 		return NULL; /* No self-test needed */
 
 	larval = crypto_larval_alloc(alg->cra_name,
diff --git a/crypto/algboss.c b/crypto/algboss.c
index eb5fe84efb83e..13d37320a66eb 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -181,12 +181,8 @@ static int cryptomgr_test(void *data)
 	goto skiptest;
 #endif
 
-	if (type & CRYPTO_ALG_TESTED)
-		goto skiptest;
-
 	err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
 
-skiptest:
 	crypto_alg_tested(param->driver, err);
 
 	kfree(param);
@@ -197,7 +193,6 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 {
 	struct task_struct *thread;
 	struct crypto_test_param *param;
-	u32 type;
 
 	if (!try_module_get(THIS_MODULE))
 		goto err;
@@ -208,13 +203,7 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 
 	memcpy(param->driver, alg->cra_driver_name, sizeof(param->driver));
 	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
-	type = alg->cra_flags;
-
-	/* Do not test internal algorithms. */
-	if (type & CRYPTO_ALG_INTERNAL)
-		type |= CRYPTO_ALG_TESTED;
-
-	param->type = type;
+	param->type = alg->cra_flags;
 
 	thread = kthread_run(cryptomgr_test, param, "cryptomgr_test");
 	if (IS_ERR(thread))
-- 
2.38.1

