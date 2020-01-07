Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98163C33C9B
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 13:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78CC6207E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 13:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgAGNgA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 08:36:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728301AbgAGNgA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 08:36:00 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5CFA47C50F4EC5F5ED37;
        Tue,  7 Jan 2020 21:35:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 21:35:49 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <Jason@zx2c4.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: curve25519 - Fix selftests build error
Date:   Tue, 7 Jan 2020 21:35:47 +0800
Message-ID: <20200107133547.44000-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_CURVE25519 is y, CRYPTO_LIB_CURVE25519_GENERIC will be
y, but CRYPTO_LIB_CURVE25519 may be set to m, cause build errors:

lib/crypto/curve25519-selftest.o: In function `curve25519':
curve25519-selftest.c:(.text.unlikely+0xc): undefined reference to `curve25519_arch'
lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
curve25519-selftest.c:(.init.text+0x17e): undefined reference to `curve25519_base_arch'

This splits the curve25519 test code into its own source file.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 lib/crypto/Makefile              |  6 +++++-
 lib/crypto/curve25519-selftest.c | 23 ++++++++++++++++++++++-
 lib/crypto/curve25519.c          | 17 -----------------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index f97f9b94..87c99da 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -36,5 +36,9 @@ libsha256-y					:= sha256.o
 ifneq ($(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS),y)
 libblake2s-y					+= blake2s-selftest.o
 libchacha20poly1305-y				+= chacha20poly1305-selftest.o
-libcurve25519-y					+= curve25519-selftest.o
+ifneq ($(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519),)
+obj-$(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519)	+= curve25519-selftest.o
+else
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= curve25519-selftest.o
+endif
 endif
diff --git a/lib/crypto/curve25519-selftest.c b/lib/crypto/curve25519-selftest.c
index c85e853..c4cfa26 100644
--- a/lib/crypto/curve25519-selftest.c
+++ b/lib/crypto/curve25519-selftest.c
@@ -4,6 +4,8 @@
  */
 
 #include <crypto/curve25519.h>
+#include <linux/module.h>
+#include <linux/init.h>
 
 struct curve25519_test_vector {
 	u8 private[CURVE25519_KEY_SIZE];
@@ -1280,7 +1282,7 @@ static const struct curve25519_test_vector curve25519_test_vectors[] __initconst
 	}
 };
 
-bool __init curve25519_selftest(void)
+static bool __init curve25519_selftest(void)
 {
 	bool success = true, ret, ret2;
 	size_t i = 0, j;
@@ -1319,3 +1321,22 @@ bool __init curve25519_selftest(void)
 
 	return success;
 }
+
+static int __init mod_init(void)
+{
+	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
+	    WARN_ON(!curve25519_selftest()))
+		return -ENODEV;
+	return 0;
+}
+
+static void __exit mod_exit(void)
+{
+}
+
+module_init(mod_init);
+module_exit(mod_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Curve25519 selftest");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index c03ccdb..0106beb 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -13,8 +13,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-bool curve25519_selftest(void);
-
 const u8 curve25519_null_point[CURVE25519_KEY_SIZE] __aligned(32) = { 0 };
 const u8 curve25519_base_point[CURVE25519_KEY_SIZE] __aligned(32) = { 9 };
 
@@ -22,21 +20,6 @@ EXPORT_SYMBOL(curve25519_null_point);
 EXPORT_SYMBOL(curve25519_base_point);
 EXPORT_SYMBOL(curve25519_generic);
 
-static int __init mod_init(void)
-{
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
-	    WARN_ON(!curve25519_selftest()))
-		return -ENODEV;
-	return 0;
-}
-
-static void __exit mod_exit(void)
-{
-}
-
-module_init(mod_init);
-module_exit(mod_exit);
-
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Curve25519 scalar multiplication");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
2.7.4


