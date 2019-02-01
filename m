Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8B4C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8A620869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007610;
	bh=TrmiDGPY1e+XMjSI4/d9Y2vkZsthYE05GdYKDNdg4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UzOp65fZPY9C6hDnP42VzyyjBkOjITXoYmi9zLKm5F8/7HjNlOny720HOZPVYHIWo
	 +drytKraApqAjrofdXTx7za5oW29cUPuWGGgUJRK3PssxM7D3dyGPNIA34bXFCePb0
	 S4wQpQSBOnBGLKUppNhGhdNH2DX/xOBjZ0dossBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfBAHxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:53:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbfBAHwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B037218F0;
        Fri,  1 Feb 2019 07:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007523;
        bh=TrmiDGPY1e+XMjSI4/d9Y2vkZsthYE05GdYKDNdg4L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjyJCEhEDR0St/08KoBo94tCFPBQNyHrFvufyihZxwGTrnrSpgZQbB7LHSUMSFUHA
         VSY0KkVxIdS/Mb4Iq/Dj/hEVghC3OCwiEbrzP9Tjkf4FxDdFDMBxx73clzL4uQjX1g
         +ElAbHPazZYEW8G16s+nxuGBGhJ34uKp289dDzu8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/15] crypto: testmgr - introduce CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
Date:   Thu, 31 Jan 2019 23:51:44 -0800
Message-Id: <20190201075150.18644-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
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
index 86960aa53e0f2..bbab6bf335198 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -168,6 +168,16 @@ config CRYPTO_MANAGER_DISABLE_TESTS
 	  Disable run-time self tests that normally take place at
 	  algorithm registration.
 
+config CRYPTO_MANAGER_EXTRA_TESTS
+	bool "Enable extra run-time crypto self tests"
+	depends on DEBUG_KERNEL && !CRYPTO_MANAGER_DISABLE_TESTS
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
index 1163d39ef8c9a..5e527dbe6524c 100644
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
@@ -4106,6 +4116,10 @@ static void testmgr_onetime_init(void)
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
2.20.1

