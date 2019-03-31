Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5359C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7872C20872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062994;
	bh=hStNqJG9HVwuSv4CBq6zRg0EIZvgnvWy4flgzyWx88I=;
	h=From:To:Subject:Date:List-ID:From;
	b=y29LFWb8AnNa/ukM1IAWGubMyg4gU+F6LVmDu5+MoeZANl9dqyySRM61bAGm1GlCJ
	 7uf6LrG5px39FY1k3U344cjsNnDU9cy9lrzZWe5CINotUJTaCGq7xChy4mqurOyJne
	 P6192CDfIVHEacvz7NYN44zve0A+bQeG8tBRaAq4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfCaUJx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731432AbfCaUJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:09:53 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9BD32086C;
        Sun, 31 Mar 2019 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062993;
        bh=hStNqJG9HVwuSv4CBq6zRg0EIZvgnvWy4flgzyWx88I=;
        h=From:To:Subject:Date:From;
        b=d64iMKcr3dWCwFLUXWx0jWfSf1d96kFn2mHBSmM884bsbXHpVE1EtEPh+HqX0Vh9r
         QWhpzT9yzS5ge/58VvedtE4KRd70iDOHxp0rZsGAfl2DtILeHS01FQA1gRcjhr3ZZ+
         ivttVqe+mSrOgCDz/5RLjk2nYpv0X3ytxtofXhjw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: testmgr - add panic_on_fail module parameter
Date:   Sun, 31 Mar 2019 13:09:14 -0700
Message-Id: <20190331200914.27341-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a module parameter cryptomgr.panic_on_fail which causes the kernel
to panic if any crypto self-tests fail.

Use cases:

- More easily detect crypto self-test failures by boot testing,
  e.g. on KernelCI.
- Get a bug report if syzkaller manages to use the template system to
  instantiate an algorithm that fails its self-tests.

The command-line option "fips=1" already does this, but it also makes
other changes not wanted for general testing, such as disabling
"unapproved" algorithms.  panic_on_fail just does what it says.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2c2ddebb48d37..0f6bfb6ce6a46 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -45,6 +45,9 @@ static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
 
+static bool panic_on_fail;
+module_param(panic_on_fail, bool, 0444);
+
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 static bool noextratests;
 module_param(noextratests, bool, 0644);
@@ -4109,8 +4112,9 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 					     type, mask);
 
 test_done:
-	if (fips_enabled && rc)
-		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
+	if (rc && (fips_enabled || panic_on_fail))
+		panic("alg: self-tests for %s (%s) failed in %s mode!\n",
+		      driver, alg, fips_enabled ? "fips" : "panic_on_fail");
 
 	if (fips_enabled && !rc)
 		pr_info("alg: self-tests for %s (%s) passed\n", driver, alg);
-- 
2.21.0

