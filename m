Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E55C10F08
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DA10218C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727065;
	bh=gQPCOSJfsWJewBTLoBTcQ/3QKXLvlRPr+402AgwnCck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PtLqfX0J8XM6Q7hv0kfvbBGLwBcyXAv893PjJKsfklR7D+SJelix+HZ/RM3BzJ+ym
	 leJGN+zp/N+a99w8w5e4kfMrzFrmy7RnwH0qrxEsRdcnhg3x72+xpxLilrjg+MYJ5B
	 35JHSk3g3S6JTHgb1h5OFz+ig4iA1bNLhZHVdAYU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbfBUFbE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbfBUFbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C796218D8;
        Thu, 21 Feb 2019 05:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727063;
        bh=gQPCOSJfsWJewBTLoBTcQ/3QKXLvlRPr+402AgwnCck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/887sRV22xugyTL64VrtEiFT7N4X8Sh4JDZAAOddSKUrNXHiGrecQoJCrAUtOs7H
         7UXULf3weGB07LTyJq4ms4ui0nB0KWdKMMVV28QOvuxF9/4D3nZIlSqA+vKg/Xn8FX
         GnnLyPlR2e1LBnysvEIg0AXF1DF+/wB9DwpoY8Ss=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 6/6] crypto/af_alg05: new regression test for skcipher_walk error bug
Date:   Wed, 20 Feb 2019 21:30:26 -0800
Message-Id: <20190221053026.18489-7-ebiggers@kernel.org>
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
 testcases/kernel/crypto/af_alg05.c | 43 ++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg05.c

diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index df6b7e73cb..17faf3eefc 100644
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
index 0000000000..419c65eabd
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
2.20.1

