Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991C0C06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0BD21473
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGBLjk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:39:40 -0400
Received: from foss.arm.com ([217.140.110.172]:48118 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfGBLjk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 07:39:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AD17344;
        Tue,  2 Jul 2019 04:39:39 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42F4D3F246;
        Tue,  2 Jul 2019 04:39:38 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: fips: add FIPS test failure notification chain
Date:   Tue,  2 Jul 2019 14:39:20 +0300
Message-Id: <20190702113922.24911-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702113922.24911-1-gilad@benyossef.com>
References: <20190702113922.24911-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto test failures in FIPS mode cause an immediate panic, but
on some system the cryptographic boundary extends beyond just
the Linux controlled domain.

Add a simple atomic notification chain to allow interested parties
to register to receive notification prior to us kicking the bucket.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/fips.c        | 11 +++++++++++
 crypto/testmgr.c     |  4 +++-
 include/linux/fips.h |  7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 9dfed122d6da..b30a67b6c441 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -16,10 +16,14 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sysctl.h>
+#include <linux/notifier.h>
 
 int fips_enabled;
 EXPORT_SYMBOL_GPL(fips_enabled);
 
+ATOMIC_NOTIFIER_HEAD(fips_fail_notif_chain);
+EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
+
 /* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
 static int fips_enable(char *str)
 {
@@ -63,6 +67,13 @@ static void crypto_proc_fips_exit(void)
 	unregister_sysctl_table(crypto_sysctls);
 }
 
+void fips_fail_notify(void)
+{
+	if (fips_enabled)
+		atomic_notifier_call_chain(&fips_fail_notif_chain, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(fips_fail_notify);
+
 static int __init fips_init(void)
 {
 	crypto_proc_fips_init();
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d760f5cd35b2..fc2407d7a78f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5245,9 +5245,11 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 					     type, mask);
 
 test_done:
-	if (rc && (fips_enabled || panic_on_fail))
+	if (rc && (fips_enabled || panic_on_fail)) {
+		fips_fail_notify();
 		panic("alg: self-tests for %s (%s) failed in %s mode!\n",
 		      driver, alg, fips_enabled ? "fips" : "panic_on_fail");
+	}
 
 	if (fips_enabled && !rc)
 		pr_info("alg: self-tests for %s (%s) passed\n", driver, alg);
diff --git a/include/linux/fips.h b/include/linux/fips.h
index afeeece92302..c6961e932fef 100644
--- a/include/linux/fips.h
+++ b/include/linux/fips.h
@@ -4,8 +4,15 @@
 
 #ifdef CONFIG_CRYPTO_FIPS
 extern int fips_enabled;
+extern struct atomic_notifier_head fips_fail_notif_chain;
+
+void fips_fail_notify(void);
+
 #else
 #define fips_enabled 0
+
+static inline void fips_fail_notify(void) {}
+
 #endif
 
 #endif
-- 
2.21.0

