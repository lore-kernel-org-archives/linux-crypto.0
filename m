Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C02EC4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3010221841
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727067;
	bh=r/750kU+RajtSgc4JeJzMXO/+77Fx8fBlrSa4+BuTi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QTLxsVBKXWBjOr1d8WSiLz2WHhxBSEa4orV9J5TBjrF2UoSBnAR/60bzaHaSyZkte
	 QrozCkNAr3E2qvsHEjUJLh4aMJ2TT8pioh8GBe7YHJ8laoFpCdlEeGXTFIZkURKSPC
	 /Hi97KRtQv8ejgNWyzXj+Lq1ADoNkCQItjsVELS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfBUFbG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfBUFbE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:04 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3343921848;
        Thu, 21 Feb 2019 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727063;
        bh=r/750kU+RajtSgc4JeJzMXO/+77Fx8fBlrSa4+BuTi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzb0Q2QP/XXuqB3UMpmyVPi4fYXDXbbFp6lEnTb3YK0JLupGwWQYadbnDcLnlttW/
         /7RZB9Or1T0464438T129g0yqLJLkT0vTAOmcq+YB1edcnwRVq/TA892KAXGCImVnF
         edr48cndvIE3ZcF60co7P4jSqU1kGAGNdgJ7emOU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/6] crypto/af_alg04: new regression test for vmac race conditions
Date:   Wed, 20 Feb 2019 21:30:25 -0800
Message-Id: <20190221053026.18489-6-ebiggers@kernel.org>
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
 testcases/kernel/crypto/.gitignore |  1 +
 testcases/kernel/crypto/af_alg04.c | 56 ++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg04.c

diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index 3e7936fc94..df6b7e73cb 100644
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
index 0000000000..b8e494b870
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
2.20.1

