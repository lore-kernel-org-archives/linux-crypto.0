Return-Path: <SRS0=QJ87=B6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154B3C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 18:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B98207DE
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Aug 2020 18:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597947684;
	bh=UoGnlqDwJu4BiJVgFEDrzpJXmkl4E75bbnDjQUHNH/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=04fzXfSzVpgGASeF+XLNIO6IqukqUxMZuUp9/I6n3gIy8f4c6dnsnbUr5Dp2RXJKL
	 dBx2084sEcwZvJ3e8IKpuzuvF3mXnPIFeAQ7izlkEN4kGDi7XVwPjxNnA1TkRcubRo
	 GAzgNVrEetLGgTlHvyNO+/KwbEkWGocd328eUgss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgHTSVX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgHTSVT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Aug 2020 14:21:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58FE4207DE;
        Thu, 20 Aug 2020 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597947678;
        bh=UoGnlqDwJu4BiJVgFEDrzpJXmkl4E75bbnDjQUHNH/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EArwUhlI0qdfBNsbxnRHoDVsrOFxrOzF063nGYwhjOxgWYow28UvObMivpMHMv8uG
         rqMnTF3a8UMgvqcIAoX6fV+QYUNiJXV+b+N44bQOGo7/Ek/E5TkwiTBr/EHV6OfyxC
         HGodADQtM6+Kw9ikBgO8LLPPby58je96DeYCkMZs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [LTP PATCH 2/2] crypto/af_alg02: send message with control data before reading
Date:   Thu, 20 Aug 2020 11:19:18 -0700
Message-Id: <20200820181918.404758-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820181918.404758-1-ebiggers@kernel.org>
References: <20200820181918.404758-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

It isn't clearly defined what happens if you read from an AF_ALG request
socket without previously sending the control data to begin an
encryption or decryption operation.  On some kernels the read will
return 0, while on others it will block.

Testing this corner case isn't the purpose of af_alg02; it just wants to
try to encrypt a zero-length message.  So, change it to explicitly send
a zero-length message with control data.

This fixes the test failure reported at
https://lkml.kernel.org/r/CA+G9fYtebf78TH-XpqArunHc1L6s9mHdLEbpY1EY9tSyDjp=sg@mail.gmail.com

Fixing the test in this way was also previously suggested at
https://lkml.kernel.org/r/20200702033221.GA19367@gondor.apana.org.au

Note, this patch doesn't change the fact that the read() still blocks on
pre-4.14 kernels (which is a kernel bug), and thus the timeout logic in
the test is still needed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 testcases/kernel/crypto/af_alg02.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/testcases/kernel/crypto/af_alg02.c b/testcases/kernel/crypto/af_alg02.c
index fab0010c9..31d30777c 100644
--- a/testcases/kernel/crypto/af_alg02.c
+++ b/testcases/kernel/crypto/af_alg02.c
@@ -21,14 +21,29 @@
 #include <pthread.h>
 #include <errno.h>
 
+#define SALSA20_IV_SIZE       8
+#define SALSA20_MIN_KEY_SIZE  16
+
 static void *verify_encrypt(void *arg)
 {
+	const uint8_t iv[SALSA20_IV_SIZE] = { 0 };
+	const struct tst_alg_sendmsg_params params = {
+		.encrypt = true,
+		.iv = iv,
+		.ivlen = SALSA20_IV_SIZE,
+	};
 	char buf[16];
-	int reqfd = tst_alg_setup_reqfd("skcipher", "salsa20", NULL, 16);
+	int reqfd = tst_alg_setup_reqfd("skcipher", "salsa20", NULL,
+					SALSA20_MIN_KEY_SIZE);
 
-	TST_CHECKPOINT_WAKE(0);
+	/* Send a zero-length message to encrypt */
+	tst_alg_sendmsg(reqfd, NULL, 0, &params);
 
-	/* With the bug the kernel crashed here */
+	/*
+	 * Read the zero-length encrypted data.
+	 * With the bug, the kernel crashed here.
+	 */
+	TST_CHECKPOINT_WAKE(0);
 	if (read(reqfd, buf, 16) == 0)
 		tst_res(TPASS, "Successfully \"encrypted\" an empty message");
 	else
-- 
2.28.0

