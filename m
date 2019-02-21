Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA08C10F0B
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964F1218EA
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727065;
	bh=Pf/JjXMmC5Bv9Wyy7WsM65RalSU1ALUXYcJrygTl5qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GxYRtVqoiwcoMEu7p39minJ+TGymKA0zHbTj0n7E+UoT1LFNLqeeuoRjxEjhSpcUs
	 RePSVgucQsZyK/3WtXXD17yCWO4VpvbxksYCs61RfFfQMRmiT9S+AKDbOYe8paTMZJ
	 W7UV+Br50feMuwGYAPKz+Yl/eyigCT5brlUOJGws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfBUFbE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfBUFbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB96321841;
        Thu, 21 Feb 2019 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727063;
        bh=Pf/JjXMmC5Bv9Wyy7WsM65RalSU1ALUXYcJrygTl5qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDcouHzqjPpCMwuLHNQbt9dJHVjPvA1CYa2vwH3xTdjEGY/MedLbtDAeZyD+QDVkI
         Z22oYzR81ScudM+jHn48Chf7B7WRmYMbEj1APfmy9eJP0kEP01EHcWpcxTRZrTPEy9
         ddrmkMeyGLlw6Z9p4fsdIO2LGQeaxUJmjUbZS/yw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/6] crypto/af_alg03: new regression test for rfc7539 hash alg validation
Date:   Wed, 20 Feb 2019 21:30:24 -0800
Message-Id: <20190221053026.18489-5-ebiggers@kernel.org>
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
 testcases/kernel/crypto/af_alg03.c | 31 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 testcases/kernel/crypto/af_alg03.c

diff --git a/testcases/kernel/crypto/.gitignore b/testcases/kernel/crypto/.gitignore
index dc79f3275b..3e7936fc94 100644
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
index 0000000000..240c52835f
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
2.20.1

