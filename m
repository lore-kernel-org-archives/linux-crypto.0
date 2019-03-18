Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A9CC4360F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED74E2133F
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552929267;
	bh=VtXQbZjv7XDhKKMQfOH4IL9aHbsqWdRqP9v/1wZocIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=O7MANAGRnDdB2ZHoqKOuxLrwzKqFr9/YDHHj/MMcKCmZYVQIPYYzDCnDQcL5OOCPG
	 y8y2XQjfVPckGq1MhbUQJK1dYz49GIaPzPaUoDcCP6rwY9Rr+e29GvAMTxOGzXmXG2
	 21waSwXwuxN6EMSQ0/nONEojbreRRb1/sOMn2sAg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfCRROY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfCRROX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 13:14:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00622175B;
        Mon, 18 Mar 2019 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552929262;
        bh=VtXQbZjv7XDhKKMQfOH4IL9aHbsqWdRqP9v/1wZocIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnMHJMMX3AtnH77sHEKKcTHlvkAHv1B/bgQfSMFH3lFoIm/UpQ7658AzjIyhwExrc
         Oze08tdHeawUFO6z8tGTz3/GWWkAmE7DdQYSHTXtcTnoQBoj2GwWhbh4Fb13ophqct
         ogoBvHcreTqt/MIJXlUpVU+FDO3GSlOOMXcbCZLo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 4/6] crypto/af_alg03: new regression test for rfc7539 hash alg validation
Date:   Mon, 18 Mar 2019 10:13:25 -0700
Message-Id: <20190318171327.237014-5-ebiggers@kernel.org>
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
 testcases/kernel/crypto/af_alg03.c | 31 ++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg03.c

diff --git a/runtest/crypto b/runtest/crypto
index 758586c19..03a49df3a 100644
--- a/runtest/crypto
+++ b/runtest/crypto
@@ -1,4 +1,5 @@
 af_alg01 af_alg01
 af_alg02 af_alg02
+af_alg03 af_alg03
 pcrypt_aead01 pcrypt_aead01
 crypto_user01 crypto_user01
diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index dc79f3275..3e7936fc9 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -1,4 +1,5 @@
 af_alg01
 af_alg02
+af_alg03
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg03.c b/testcases/kernel/crypto/af_alg03.c
new file mode 100644
index 000000000..240c52835
--- /dev/null
+++ b/testcases/kernel/crypto/af_alg03.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+/*
+ * Regression test for commit e57121d08c38 ("crypto: chacha20poly1305 - validate
+ * the digest size").  This test verifies that the rfc7539 template can't be
+ * instantiated with a hash algorithm whose digest size is not 16 bytes.
+ */
+
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+static void run(void)
+{
+	tst_require_alg("aead", "rfc7539(chacha20,poly1305)");
+	tst_require_alg("hash", "sha256");
+
+	if (tst_have_alg("aead", "rfc7539(chacha20,sha256)")) {
+		tst_res(TFAIL,
+			"instantiated rfc7539 template with wrong digest size");
+	} else {
+		tst_res(TPASS,
+			"couldn't instantiate rfc7539 template with wrong digest size");
+	}
+}
+
+static struct tst_test test = {
+	.test_all = run,
+};
-- 
2.21.0.225.g810b269d1ac-goog

