Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65460C10F00
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37C3320989
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552929277;
	bh=Ta/oUdZtSyBL/8KYuoMimTzJnCuW7WJmqGVQS5dFGng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UcjE+TlBJwh7bk+zhWFyXeCC8XPKthbu1kt6nHnP7J57hqFwZyo+wt5cS5dfjI6r2
	 uHky2LOBn6mzNVpJtiyyGVwM31un54kerWUaeGBjkrdB637E9Ijwj6ZzAAg1U2qDjr
	 Xb2odr/Swy5ELt2FWnB7NuuviRS2XAVgZuCa1vGA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfCRROg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfCRROX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 13:14:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C91217F4;
        Mon, 18 Mar 2019 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552929263;
        bh=Ta/oUdZtSyBL/8KYuoMimTzJnCuW7WJmqGVQS5dFGng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lub7VXmBtnTF3zsF+9cfIgWxSH5eU1vxUFE7vxVBQZ1vXDcHgh/tU33YoZOfasqF
         z1/Iz0tmOlne/CzT9Jc9HM1M1RhchDvlmsapfGo90D5cbwOsGfQnBWkgVbifZ65EyR
         B+/jJNhX3eGnBbCwJaYnsyfm5lvJztIQAW6H97w4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 6/6] crypto/af_alg05: new regression test for skcipher_walk error bug
Date:   Mon, 18 Mar 2019 10:13:27 -0700
Message-Id: <20190318171327.237014-7-ebiggers@kernel.org>
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
 testcases/kernel/crypto/af_alg05.c | 43 ++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg05.c

diff --git a/runtest/crypto b/runtest/crypto
index b6180c417..41ea7b81c 100644
--- a/runtest/crypto
+++ b/runtest/crypto
@@ -2,5 +2,6 @@ af_alg01 af_alg01
 af_alg02 af_alg02
 af_alg03 af_alg03
 af_alg04 af_alg04
+af_alg05 af_alg05
 pcrypt_aead01 pcrypt_aead01
 crypto_user01 crypto_user01
diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index df6b7e73c..17faf3eef 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -2,5 +2,6 @@ af_alg01
 af_alg02
 af_alg03
 af_alg04
+af_alg05
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg05.c b/testcases/kernel/crypto/af_alg05.c
new file mode 100644
index 000000000..419c65eab
--- /dev/null
+++ b/testcases/kernel/crypto/af_alg05.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+/*
+ * Regression test for commit 8088d3dd4d7c ("crypto: skcipher - fix crash
+ * flushing dcache in error path").  This test verifies the kernel doesn't crash
+ * when trying to encrypt a message with size not aligned to the block cipher's
+ * block size, and where the destination buffer starts exactly at a page
+ * boundary.  Based on the reproducer from the commit message.  Note that this
+ * issue only reproduces on certain architectures, such as arm and arm64.
+ */
+
+#include <errno.h>
+
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+static void run(void)
+{
+	char buffer[4096] __attribute__((aligned(4096))) = { 0 };
+	int reqfd;
+
+	reqfd = tst_alg_setup_reqfd("skcipher", "cbc(aes-generic)", NULL, 16);
+
+	SAFE_WRITE(1, reqfd, buffer, 15);
+	/* with the bug, this crashed the kernel on some architectures */
+	TEST(read(reqfd, buffer, 15));
+
+	if (TST_RET == 0)
+		tst_res(TBROK, "read() unexpectedly succeeded");
+	else if (TST_ERR == EINVAL)
+		tst_res(TPASS, "read() expectedly failed with EINVAL");
+	else
+		tst_res(TBROK | TTERRNO, "read() failed with unexpected error");
+
+	close(reqfd);
+}
+
+static struct tst_test test = {
+	.test_all = run,
+};
-- 
2.21.0.225.g810b269d1ac-goog

