Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7162C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Nov 2022 08:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiKJIPM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiKJIPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Nov 2022 03:15:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C211AF24
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 00:15:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F299B820F4
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F12AC433C1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Nov 2022 08:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068106;
        bh=1wrT0gidSrDF4d1H3dgpVP/jA8cCHSsxQKy1HF5H8Lc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=n8+lYgwRrXgnsJDueBtOX6bBXDAyeiw4maHXOzNICPBu0tFDBNTiWlAO0XkLpiDaO
         mcJTCA8A1Np+8JOFwsWIAQHPjqPb9YIwXE1sOchFJAwEiXBvoZaGI4wBsCxtvJePx/
         M/XMIVY/8cSC15EkC0Pjbl4s3/rcVMgvXXJmw9VHghBPKjcK2ohCRYgdXW3HhfFolL
         oWiTLjomZIZDW5kjKIrYLZwIQ47ERdVArPlfrhBcklQfLRZXq01P3CRU2rCa8OsR2I
         c9JuaEUNDIo2Msq4IDbtfbrnLpzKjbVqWGxCsRxAvRzT99MbqjTZO/HEnG5WDTHhey
         RG5EiGMdwBqxA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 6/6] crypto: compile out test-related algboss code when tests disabled
Date:   Thu, 10 Nov 2022 00:13:46 -0800
Message-Id: <20221110081346.336046-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221110081346.336046-1-ebiggers@kernel.org>
References: <20221110081346.336046-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is set, the code in algboss.c
that handles CRYPTO_MSG_ALG_REGISTER is unnecessary, so make it be
compiled out.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algboss.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 13d37320a66eb..f3c6c9fe133d5 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -171,15 +171,17 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	return NOTIFY_OK;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+static int cryptomgr_schedule_test(struct crypto_alg *alg)
+{
+	return NOTIFY_DONE;
+}
+#else
 static int cryptomgr_test(void *data)
 {
 	struct crypto_test_param *param = data;
 	u32 type = param->type;
-	int err = 0;
-
-#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-	goto skiptest;
-#endif
+	int err;
 
 	err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
 
@@ -218,6 +220,7 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 err:
 	return NOTIFY_OK;
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
 
 static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
 			    void *data)
-- 
2.38.1

