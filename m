Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF874C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CFCB2184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284001;
	bh=C8TKeeMhQf8479EZg15Ln589zEiTSuXOTM+X2AkqBhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QUqk+jGK2DMgX/gunwgDloZQBlCBHeuLSsjk5eWPUTPdh/dLGgqmp6qPOipavP1xS
	 vBYEnIavZ0dSNA8BE6ibI8ytVe+2b1DRpbbvUQ/hN2vaj1Aag8UWtU0RQKNM+LHTFZ
	 Wkl4Wz9nm4r+5l7M7Ud/XKNMRge1UwX/w4GCKAg8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfAWWxU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbfAWWwe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:34 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9074218AF;
        Wed, 23 Jan 2019 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283954;
        bh=C8TKeeMhQf8479EZg15Ln589zEiTSuXOTM+X2AkqBhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiqCrMXoohQQwKOPyPb7vGRZrk9BYTUlbnLQfftmzuuWv3aWWz2LlJAuxWMfeF6mj
         WtVosqIdVFZWL91FcSoEXHFpDtFP0ZNDtceNHQeYEzZCLaToFXDJgF3sjNzgCwEkPu
         zn1Wh0d7WzdBJwOHy8X+yZ586LzIWzcVwXE8Mp2U=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC/RFT PATCH 09/15] crypto: testmgr - introduce CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
Date:   Wed, 23 Jan 2019 14:49:20 -0800
Message-Id: <20190123224926.250525-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To achieve more comprehensive crypto test coverage, I'd like to add fuzz
tests that use random data layouts and request flags.

To be most effective these tests should be part of testmgr, so they
automatically run on every algorithm registered with the crypto API.
However, they will take much longer to run than the current tests and
therefore will only really be intended to be run by developers, whereas
the current tests have a wider audience.

Therefore, add a new kconfig option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
that can be set by developers to enable these extra, expensive tests.

Similar to the regular tests, also add a module parameter
cryptomgr.noextratests to support disabling the tests.

Finally, another module parameter cryptomgr.fuzz_iterations is added to
control how many iterations the fuzz tests do.  Note: for now setting
this to 0 will be equivalent to cryptomgr.noextratests=1.  But I opted
for separate parameters to provide more flexibility to add other types
of tests under the "extra tests" category in the future.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig   | 10 ++++++++++
 crypto/testmgr.c | 14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 86960aa53e0f..cbeba16fd8c1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -168,6 +168,16 @@ config CRYPTO_MANAGER_DISABLE_TESTS
 	  Disable run-time self tests that normally take place at
 	  algorithm registration.
 
+config CRYPTO_MANAGER_EXTRA_TESTS
+	bool "Enable extra run-time crypto self tests"
+	depends on !CRYPTO_MANAGER_DISABLE_TESTS
+	help
+	  Enable extra run-time self tests of registered crypto algorithms,
+	  including randomized fuzz tests.
+
+	  This is intended for developer use only, as these tests take much
+	  longer to run than the normal self tests.
+
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions"
 	help
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a29b42a17841..7c68b4101bd0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -43,6 +43,16 @@ static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+static bool noextratests;
+module_param(noextratests, bool, 0644);
+MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
+
+static unsigned int fuzz_iterations = 100;
+module_param(fuzz_iterations, uint, 0644);
+MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
+#endif
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -4099,6 +4109,10 @@ static void testmgr_onetime_init(void)
 {
 	alg_check_test_descs_order();
 	alg_check_testvec_configs();
+
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+	pr_warn("alg: extra crypto tests enabled.  This is intended for developer use only.\n");
+#endif
 }
 
 static int alg_find_test(const char *alg)
-- 
2.20.1.321.g9e740568ce-goog

