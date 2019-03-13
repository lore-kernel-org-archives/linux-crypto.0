Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED8FC4360F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D4F721874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454137;
	bh=lzkvbYwAbu6mfSnM6YOnS1aqXWrT8fyKTWOJhCF764w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cG9Qfam2GHtP/Lm3pb6Uzf5YMH73nS3sQByKxRVeDLsbUbD1frDGf9b1a0qPegwKv
	 PXwwdqBqou8xV3UkWaKDx/QFfGDbPs1tITdj/j2g+JX2zCaW1+tP6W9qnWd0h5oL/n
	 DJQqXNEADB20j8WGBul3+YIfUqyIBYv+zPff78c8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfCMFPg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfCMFPg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:36 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5B402184D;
        Wed, 13 Mar 2019 05:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454135;
        bh=lzkvbYwAbu6mfSnM6YOnS1aqXWrT8fyKTWOJhCF764w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJhFhqKzwsbnjcwlw6WhjSo+O9KOE/k6i3AOMjOimKnZyt2MJaUKeV8aiF9n645SQ
         yaIgugpVpbQtqWHhF6gEoE8jBbF3QDOeFyod7wg547F8yUuvIsieNfu55RItVfdmwh
         DKMDeK//xTUVHS08VKDzPy930GblsERB9h21PcEk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 3/8] crypto: simd,testmgr - introduce crypto_simd_usable()
Date:   Tue, 12 Mar 2019 22:12:47 -0700
Message-Id: <20190313051252.2917-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

So that the no-SIMD fallback code can be tested by the crypto
self-tests, add a macro crypto_simd_usable() which wraps may_use_simd(),
but also returns false if the crypto self-tests have set a per-CPU bool
to disable SIMD in crypto code on the current CPU.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c               | 26 +++++++++++++++++++++++++-
 include/crypto/internal/simd.h | 24 ++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5d56b2990762..52417dde811f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -37,6 +37,7 @@
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
 #include <crypto/acompress.h>
+#include <crypto/internal/simd.h>
 
 #include "internal.h"
 
@@ -52,6 +53,9 @@ MODULE_PARM_DESC(noextratests, "disable expensive crypto self-tests");
 static unsigned int fuzz_iterations = 100;
 module_param(fuzz_iterations, uint, 0644);
 MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
+
+DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
+EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
 #endif
 
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
@@ -838,7 +842,27 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 
 	WARN_ON_ONCE(!valid_testvec_config(cfg));
 }
-#endif /* CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+
+static void crypto_disable_simd_for_test(void)
+{
+	preempt_disable();
+	__this_cpu_write(crypto_simd_disabled_for_test, true);
+}
+
+static void crypto_reenable_simd_for_test(void)
+{
+	__this_cpu_write(crypto_simd_disabled_for_test, false);
+	preempt_enable();
+}
+#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+static void crypto_disable_simd_for_test(void)
+{
+}
+
+static void crypto_reenable_simd_for_test(void)
+{
+}
+#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
 static int check_nonfinal_hash_op(const char *op, int err,
 				  u8 *result, unsigned int digestsize,
diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index a23b18b6ad61..d2316242a988 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -6,6 +6,9 @@
 #ifndef _CRYPTO_INTERNAL_SIMD_H
 #define _CRYPTO_INTERNAL_SIMD_H
 
+#include <linux/percpu.h>
+#include <linux/types.h>
+
 /* skcipher support */
 
 struct simd_skcipher_alg;
@@ -42,4 +45,25 @@ int simd_register_aeads_compat(struct aead_alg *algs, int count,
 void simd_unregister_aeads(struct aead_alg *algs, int count,
 			   struct simd_aead_alg **simd_algs);
 
+/*
+ * crypto_simd_usable() - is it allowed at this time to use SIMD instructions or
+ *			  access the SIMD register file?
+ *
+ * This delegates to may_use_simd(), except that this also returns false if SIMD
+ * in crypto code has been temporarily disabled on this CPU by the crypto
+ * self-tests, in order to test the no-SIMD fallback code.  This override is
+ * currently limited to configurations where the extra self-tests are enabled,
+ * because it might be a bit too invasive to be part of the regular self-tests.
+ *
+ * This is a macro so that <asm/simd.h>, which some architectures don't have,
+ * doesn't have to be included directly here.
+ */
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
+#define crypto_simd_usable() \
+	(may_use_simd() && !this_cpu_read(crypto_simd_disabled_for_test))
+#else
+#define crypto_simd_usable() may_use_simd()
+#endif
+
 #endif /* _CRYPTO_INTERNAL_SIMD_H */
-- 
2.21.0

