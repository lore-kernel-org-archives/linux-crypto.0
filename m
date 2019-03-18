Return-Path: <SRS0=sPcw=RV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18986C10F0D
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE916217F9
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Mar 2019 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552929264;
	bh=TBiTnpqnDNbXb+i+BTpmBaZvLRAhCCO8ILCRjzwbKs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XG1FM21Lv1zU/lJ2TPC4tUhhLzBiJ8t131iALADN9JoYtgvEoiR1Kj0ta1nAMVcOg
	 n4t9tWTjaUtsXwZCMJe/REz2tfLl2j7KVKZD1GHe+G+HeUcNcu6n9wvF2PTtaEzKoB
	 l2Wt84seaP5kUUDL1ePRuhaJLf6oCuUWJQ37TPE4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfCRROX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfCRROX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Mar 2019 13:14:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE4621741;
        Mon, 18 Mar 2019 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552929262;
        bh=TBiTnpqnDNbXb+i+BTpmBaZvLRAhCCO8ILCRjzwbKs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfJ3CFLBsYaJzdambq/nqHNRPdGQeXKa6HSkVSgOj0WxQp3BZWUZCYcPP/TyfdB2+
         gXNIwshyqiqSQ7EQ34rHH/1UIlZrXEYv6hdUv5u4awJ/pwcI6wq0AzIi4b6GsWy7lJ
         zu5tOmqmi+/Ct/r2N26DIZCSSn81JH0nV1/uSqhs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 3/6] crypto/af_alg02: new regression test for salsa20 empty message bug
Date:   Mon, 18 Mar 2019 10:13:24 -0700
Message-Id: <20190318171327.237014-4-ebiggers@kernel.org>
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
 runtest/cve                        |  1 +
 testcases/kernel/crypto/.gitignore |  1 +
 testcases/kernel/crypto/af_alg02.c | 29 +++++++++++++++++++++++++++++
 4 files changed, 32 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg02.c

diff --git a/runtest/crypto b/runtest/crypto
index 45c8cdd2d..758586c19 100644
--- a/runtest/crypto
+++ b/runtest/crypto
@@ -1,3 +1,4 @@
 af_alg01 af_alg01
+af_alg02 af_alg02
 pcrypt_aead01 pcrypt_aead01
 crypto_user01 crypto_user01
diff --git a/runtest/cve b/runtest/cve
index f46c400cc..031bcdc2a 100644
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
index 998af1728..dc79f3275 100644
--- a/testcases/kernel/crypto/.gitignore
+++ b/testcases/kernel/crypto/.gitignore
@@ -1,3 +1,4 @@
 af_alg01
+af_alg02
 pcrypt_aead01
 crypto_user01
diff --git a/testcases/kernel/crypto/af_alg02.c b/testcases/kernel/crypto/af_alg02.c
new file mode 100644
index 000000000..a9e820423
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
2.21.0.225.g810b269d1ac-goog

