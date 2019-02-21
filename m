Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA3AC4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52410218EA
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727064;
	bh=qONswH9D92mzxsmii4nDlzxEMrCWcwGmATtoTmD7W0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CEfX8RDk/5nKwJl69uLuTqGpc2UxMJoye9UoSTdA00/15G+a9VSYHtksVOQHlF4mo
	 OSvRGfNoAwILPHlDePbkuBrWIxwRdgY9sx5KiKwAUL8UH/T4HINh0HkFYmxZjwEwJr
	 cAgLN9G3ExjtIA8ngeCWaSz4cwwJGODvCVsWDYDI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfBUFbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfBUFbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B252F21738;
        Thu, 21 Feb 2019 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727062;
        bh=qONswH9D92mzxsmii4nDlzxEMrCWcwGmATtoTmD7W0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6JBcYoxpsgHWavPAVJp5ppk/0LPo2sD7Md6s8i7DcJCsiZ/Rrx4OVWFZYNjn0nij
         KZP/1YPLcSwdIpHCdCBhYSlLIum5k84/dFwirCyDZfl64dqq1gp60a5KIdNWfkVRpZ
         5FL+rhe7BhlHmnkW8KxU8uMlyaXRaGXoUawFIq1E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/6] crypto/af_alg02: new regression test for salsa20 empty message bug
Date:   Wed, 20 Feb 2019 21:30:23 -0800
Message-Id: <20190221053026.18489-4-ebiggers@kernel.org>
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
 testcases/kernel/crypto/af_alg02.c | 29 +++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg02.c

diff --git a/runtest/cve b/runtest/cve
index f46c400cc4..031bcdc2a7 100644
--- a/runtest/cve
+++ b/runtest/cve
@@ -27,6 +27,7 @@ cve-2017-15299 request_key03 -b cve-2017-15299
 cve-2017-15537 ptrace07
 cve-2017-15649 fanout01
 cve-2017-15951 request_key03 -b cve-2017-15951
+cve-2017-17805 af_alg02
 cve-2017-17806 af_alg01
 cve-2017-17807 request_key04
 cve-2017-1000364 stack_clash
diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index 998af17284..dc79f3275b 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -1,3 +1,4 @@
 af_alg01
+af_alg02
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg02.c b/testcases/kernel/crypto/af_alg02.c
new file mode 100644
index 0000000000..a9e8204230
--- /dev/null
+++ b/testcases/kernel/crypto/af_alg02.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+/*
+ * Regression test for commit ecaaab564978 ("crypto: salsa20 - fix
+ * blkcipher_walk API usage"), or CVE-2017-17805.  This test verifies that an
+ * empty message can be encrypted with Salsa20 without crashing the kernel.
+ */
+
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+static void run(void)
+{
+	char buf[16];
+	int reqfd = tst_alg_setup_reqfd("skcipher", "salsa20", NULL, 16);
+
+	/* With the bug the kernel crashed here */
+	if (read(reqfd, buf, 16) == 0)
+		tst_res(TPASS, "Successfully \"encrypted\" an empty message");
+	else
+		tst_res(TBROK, "read() didn't return 0");
+}
+
+static struct tst_test test = {
+	.test_all = run,
+};
-- 
2.20.1

