Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE349C4360F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806832133F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552929265;
	bh=2xXfZGA2gWop74PBtL+9o7zKb8dDxUQHO6PlEwooFW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hnSDAnzxjcK+rZHtISC+XauAq2n5ijerxwY/DJJxU7NXyN1bgfIMlSxGMLJmVGxx8
	 OchTTKCPfdbTOe7s/8JMT77b3jQ+rpOGVNcg43GfaTiFGMZfl5Dtg+PijvFT/0rW0N
	 3vn8Mruwmlk1thGlSEL6JUh1QTxx9smS8h2yJ66o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfCRROY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfCRROX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 13:14:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0043B217D8;
        Mon, 18 Mar 2019 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552929263;
        bh=2xXfZGA2gWop74PBtL+9o7zKb8dDxUQHO6PlEwooFW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNae4gv6ALnDVEgffSPuJHDqtlIUfKyulPtnD86UyI8OY/8bpXeG44ABirQ1Nca1T
         2wjZHjifOm4KpYCE3Irf012JcYVEbhyw24+2JsGDvtWJd0raNvgYE3n7Jtb5qsaGgW
         DhZ10XSa0GZD+LPEtKRCOy9uA++c0bKEg9qL8C/0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 5/6] crypto/af_alg04: new regression test for vmac race conditions
Date:   Mon, 18 Mar 2019 10:13:26 -0700
Message-Id: <20190318171327.237014-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
In-Reply-To: <20190318171327.237014-1-ebiggers@kernel.org>
References: <20190318171327.237014-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 runtest/crypto                     |  1 +
 testcases/kernel/crypto/.gitignore |  1 +
 testcases/kernel/crypto/af_alg04.c | 56 ++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg04.c

diff --git a/runtest/crypto b/runtest/crypto
index 03a49df3a..b6180c417 100644
--- a/runtest/crypto
+++ b/runtest/crypto
@@ -1,5 +1,6 @@
 af_alg01 af_alg01
 af_alg02 af_alg02
 af_alg03 af_alg03
+af_alg04 af_alg04
 pcrypt_aead01 pcrypt_aead01
 crypto_user01 crypto_user01
diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index 3e7936fc9..df6b7e73c 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -1,5 +1,6 @@
 af_alg01
 af_alg02
 af_alg03
+af_alg04
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg04.c b/testcases/kernel/crypto/af_alg04.c
new file mode 100644
index 000000000..b8e494b87
--- /dev/null
+++ b/testcases/kernel/crypto/af_alg04.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+/*
+ * Regression test for commit bb2964810233 ("crypto: vmac - separate tfm and
+ * request context").  This test verifies that a VMAC transform can be used by
+ * multiple concurrent hash requests without crashing the kernel.  Based on the
+ * reproducer from the commit message.
+ */
+
+#include <sys/wait.h>
+
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+static void run(void)
+{
+	int algfd, reqfd;
+	char buf[256] = { 0 };
+	pid_t pid;
+	int status;
+	int i;
+
+	if (tst_have_alg("hash", "vmac64(aes)"))
+		algfd = tst_alg_setup("hash", "vmac64(aes)", NULL, 16);
+	else
+		algfd = tst_alg_setup("hash", "vmac(aes)", NULL, 16);
+
+	pid = SAFE_FORK();
+
+	reqfd = tst_alg_accept(algfd);
+
+	for (i = 0; i < 500000; i++)
+		SAFE_WRITE(1, reqfd, buf, sizeof(buf));
+
+	close(reqfd);
+
+	if (pid != 0) {
+		SAFE_WAIT(&status);
+		if (WIFEXITED(status) && WEXITSTATUS(status) == 0)
+			tst_res(TPASS, "didn't crash");
+		else if (WIFSIGNALED(status) && WTERMSIG(status) == SIGKILL)
+			tst_res(TFAIL, "crashed");
+		else
+			tst_brk(TBROK, "child %s", tst_strstatus(status));
+
+		close(algfd);
+	}
+}
+
+static struct tst_test test = {
+	.test_all = run,
+	.forks_child = 1,
+};
-- 
2.21.0.225.g810b269d1ac-goog

