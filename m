Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5958AC00319
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2370F218C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727064;
	bh=L/8mT/YN7JwwFH4tx9u4eaeOEk1tUKKnDtW3DjJSUuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YjRzHWYal0rpaUsX2Xcukql55IeJ28AUthpZ1BDVIQY/V8NCj68HcFXPlgKn2J8r9
	 Z3dkpYQ+WwKJ6OuXRhNB4MJc4g5lUwNta5klEaHhigu0FbAj0dCQypC288mUNFjMhv
	 4Y2t5ulvQc2TSDtR95bCnpDnYWjpLO5P/PBC84aE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfBUFbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbfBUFbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7985B21734;
        Thu, 21 Feb 2019 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727062;
        bh=L/8mT/YN7JwwFH4tx9u4eaeOEk1tUKKnDtW3DjJSUuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ir6ORDvKNF0c2O455JtUYJfCk59AhGxDHf4P/DOiW6DAwcPFZ5DoyJpg3toN5uxO+
         /b8SwFFv6EhP0TM4FVBF64FAEHqfCKb9xMLoDa7HL2oUv7n2O1COzuEYmXmmIM6Dsd
         jmnc9+x7Qmzn013l6B+hFvbMeKmodvnRevGLK7ek=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/6] crypto/af_alg01: new regression test for hmac nesting bug
Date:   Wed, 20 Feb 2019 21:30:22 -0800
Message-Id: <20190221053026.18489-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221053026.18489-1-ebiggers@kernel.org>
References: <20190221053026.18489-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 runtest/cve                        |  1 +
 testcases/kernel/crypto/.gitignore |  1 +
 testcases/kernel/crypto/af_alg01.c | 79 ++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg01.c

diff --git a/runtest/cve b/runtest/cve
index 8f38045e9a..f46c400cc4 100644
--- a/runtest/cve
+++ b/runtest/cve
@@ -27,6 +27,7 @@ cve-2017-15299 request_key03 -b cve-2017-15299
 cve-2017-15537 ptrace07
 cve-2017-15649 fanout01
 cve-2017-15951 request_key03 -b cve-2017-15951
+cve-2017-17806 af_alg01
 cve-2017-17807 request_key04
 cve-2017-1000364 stack_clash
 cve-2017-5754 meltdown
diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index 759592fbdf..998af17284 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -1,2 +1,3 @@
+af_alg01
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg01.c b/testcases/kernel/crypto/af_alg01.c
new file mode 100644
index 0000000000..79b61de279
--- /dev/null
+++ b/testcases/kernel/crypto/af_alg01.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+/*
+ * Regression test for commit af3ff8045bbf ("crypto: hmac - require that the
+ * underlying hash algorithm is unkeyed"), or CVE-2017-17806.  This test
+ * verifies that the hmac template cannot be nested inside itself.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+static void test_with_hash_alg(const char *hash_algname)
+{
+	char hmac_algname[64];
+	char key[4096] = { 0 };
+
+	if (!tst_have_alg("hash", hash_algname)) {
+		tst_res(TCONF, "kernel doesn't have hash algorithm '%s'",
+			hash_algname);
+		return;
+	}
+	sprintf(hmac_algname, "hmac(%s)", hash_algname);
+	if (!tst_have_alg("hash", hmac_algname)) {
+		tst_res(TCONF, "kernel doesn't have hash algorithm '%s'",
+			hmac_algname);
+		return;
+	}
+
+	sprintf(hmac_algname, "hmac(hmac(%s))", hash_algname);
+	if (tst_have_alg("hash", hmac_algname)) {
+		int algfd;
+
+		tst_res(TFAIL, "instantiated nested hmac algorithm ('%s')!",
+			hmac_algname);
+
+		/*
+		 * Be extra annoying; with the bug, setting a key on
+		 * "hmac(hmac(sha3-256-generic))" crashed the kernel.
+		 */
+		algfd = tst_alg_setup("hash", hmac_algname, NULL, 0);
+		if (setsockopt(algfd, SOL_ALG, ALG_SET_KEY,
+			       key, sizeof(key)) == 0) {
+			tst_res(TFAIL,
+				"set key on nested hmac algorithm ('%s')!",
+				hmac_algname);
+		}
+	} else {
+		tst_res(TPASS,
+			"couldn't instantiate nested hmac algorithm ('%s')",
+			hmac_algname);
+	}
+}
+
+static void run(void)
+{
+	/* try several different unkeyed hash algorithms */
+	static const char * const hash_algs[] = {
+		"md5", "md5-generic",
+		"sha1", "sha1-generic",
+		"sha224", "sha224-generic",
+		"sha256", "sha256-generic",
+		"sha3-256", "sha3-256-generic",
+		"sha3-512", "sha3-512-generic",
+	};
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_algs); i++)
+		test_with_hash_alg(hash_algs[i]);
+}
+
+static struct tst_test test = {
+	.test_all = run,
+};
-- 
2.20.1

