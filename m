Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FEDC43217
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 00:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiKNANO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Nov 2022 19:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiKNANN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2022 19:13:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62434FD23
        for <linux-crypto@vger.kernel.org>; Sun, 13 Nov 2022 16:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38FD60D58
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BC1C43145
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 00:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668384791;
        bh=ykc/Tpewh187QScIg9JszYEHkkg51goq0FijE0cae0Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pXM2fPALHnDWt3PrLHONDuqNrVAmzO2iyUfQckdgnWxZQO+A+9OoImrzDuxKKLUd4
         d+Lr9Nsrz7fLghEI+B2+9Pmt1ObuCVZeNKSWf9Sr5+TI6oS7Eno6N1mGyZlHjyQrqI
         G5nKXEY9s46tRsqbYtyXhXgH46S1kKQ5cwoAH1DGPma38wLlhj4pEGh09HbLFgYxvo
         f7hleFWpcrVXtTQKrgYj8+zqL9tcFtkjkU69cRt82Xr0DoARk+TslihI1mF0+fHbcW
         JCNmQ09GbwcCbRgH80XAYA1zFODFtk5EfxhzP5MkWGN9zmPfGdoIbNgscG0eO4PknH
         +WK9CAQOiFvBQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v3 6/6] crypto: compile out test-related algboss code when tests disabled
Date:   Sun, 13 Nov 2022 16:12:38 -0800
Message-Id: <20221114001238.163209-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114001238.163209-1-ebiggers@kernel.org>
References: <20221114001238.163209-1-ebiggers@kernel.org>
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
 crypto/algboss.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 13d37320a66eb..0de1e66979498 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -175,11 +175,7 @@ static int cryptomgr_test(void *data)
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
 
@@ -194,6 +190,9 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 	struct task_struct *thread;
 	struct crypto_test_param *param;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
+		return NOTIFY_DONE;
+
 	if (!try_module_get(THIS_MODULE))
 		goto err;
 
-- 
2.38.1

