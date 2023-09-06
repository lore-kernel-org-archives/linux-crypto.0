Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B055EE14BC
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Sep 2023 17:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbjIFRse convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Sep 2023 13:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbjIFRsd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2023 13:48:33 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C52EBD
        for <linux-crypto@vger.kernel.org>; Wed,  6 Sep 2023 10:48:29 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-_GLHBdPRPIGYHMHOdRTMCQ-1; Wed, 06 Sep 2023 13:48:25 -0400
X-MC-Unique: _GLHBdPRPIGYHMHOdRTMCQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEE521C04B5B;
        Wed,  6 Sep 2023 17:48:24 +0000 (UTC)
Received: from hog.localdomain (unknown [10.45.224.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BE1C412F2D1;
        Wed,  6 Sep 2023 17:48:23 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     linux-crypto@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC -next] crypto: add debug knob to force async crypto
Date:   Wed,  6 Sep 2023 19:48:14 +0200
Message-Id: <9d664093b1bf7f47497b2c40b3a085b45f3274a2.1694021240.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The networking code has multiple users of async crypto (tls, ipsec,
macsec), but networking developers often don't have access to crypto
accelerators, which limits the testing we can do on the async
completion codepaths.

I've been using this patch to uncover some bugs [1] in the tls
implementation, forcing AESNI (which I do have on my laptop and test
machines) to go through cryptd.

The intent with the cryptd_delay_ms knob was to try to trigger some
issues with async completions and closing tls sockets.

Link: https://lore.kernel.org/netdev/cover.1694018970.git.sd@queasysnail.net/ [1]
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 crypto/Makefile   |  1 +
 crypto/algapi.c   |  2 ++
 crypto/cryptd.c   |  3 +++
 crypto/debugfs.c  | 38 ++++++++++++++++++++++++++++++++++++++
 crypto/internal.h | 19 +++++++++++++++++++
 crypto/simd.c     |  9 +++++----
 lib/Kconfig.debug |  6 ++++++
 7 files changed, 74 insertions(+), 4 deletions(-)
 create mode 100644 crypto/debugfs.c

diff --git a/crypto/Makefile b/crypto/Makefile
index 953a7e105e58..ce4f921b2bfe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_CRYPTO_FIPS) += fips.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
 crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
+crypto_algapi-$(CONFIG_DEBUG_CRYPTO) += debugfs.o
 obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 4fe95c448047..b3b218e133e0 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1098,11 +1098,13 @@ static int __init crypto_algapi_init(void)
 {
 	crypto_init_proc();
 	crypto_start_tests();
+	crypto_init_debugfs();
 	return 0;
 }
 
 static void __exit crypto_algapi_exit(void)
 {
+	crypto_exit_debugfs();
 	crypto_exit_proc();
 }
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index bbcc368b6a55..571b69441ca9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include "internal.h"
 
 static unsigned int cryptd_max_cpu_qlen = 1000;
 module_param(cryptd_max_cpu_qlen, uint, 0);
@@ -176,6 +177,8 @@ static void cryptd_queue_worker(struct work_struct *work)
 	if (!req)
 		return;
 
+	crypto_cryptd_delay();
+
 	if (backlog)
 		crypto_request_complete(backlog, -EINPROGRESS);
 	crypto_request_complete(req, 0);
diff --git a/crypto/debugfs.c b/crypto/debugfs.c
new file mode 100644
index 000000000000..f34a95f6bbfb
--- /dev/null
+++ b/crypto/debugfs.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+
+static struct dentry *crypto_debugfs_dir;
+static bool simd_force_async;
+static u32 cryptd_delay;
+
+bool crypto_simd_force_async(void)
+{
+	return simd_force_async;
+}
+
+void crypto_cryptd_delay(void)
+{
+	unsigned int d = READ_ONCE(cryptd_delay);
+
+	if (d)
+		msleep(d);
+}
+
+void __init crypto_init_debugfs(void)
+{
+	crypto_debugfs_dir = debugfs_create_dir("crypto", NULL);
+
+#if IS_ENABLED(CONFIG_CRYPTO_SIMD)
+	debugfs_create_bool("simd_force_async", 0644, crypto_debugfs_dir, &simd_force_async);
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_CRYPTD)
+	debugfs_create_u32("cryptd_delay_ms", 0644, crypto_debugfs_dir, &cryptd_delay);
+#endif
+}
+
+void __exit crypto_exit_debugfs(void)
+{
+	debugfs_remove_recursive(crypto_debugfs_dir);
+}
diff --git a/crypto/internal.h b/crypto/internal.h
index 63e59240d5fb..dfe0d859e51c 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -96,6 +96,25 @@ static inline void crypto_exit_proc(void)
 { }
 #endif
 
+#if IS_ENABLED(CONFIG_DEBUG_CRYPTO)
+void __init crypto_init_debugfs(void);
+void __exit crypto_exit_debugfs(void);
+
+bool crypto_simd_force_async(void);
+void crypto_cryptd_delay(void);
+#else
+static inline void crypto_init_debugfs(void)
+{ }
+static inline void crypto_exit_debugfs(void)
+{ }
+static inline bool crypto_simd_force_async(void)
+{
+	return false;
+}
+static inline void crypto_cryptd_delay(void)
+{ }
+#endif
+
 static inline unsigned int crypto_cipher_ctxsize(struct crypto_alg *alg)
 {
 	return alg->cra_ctxsize;
diff --git a/crypto/simd.c b/crypto/simd.c
index edaa479a1ec5..1833e9b7a061 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/preempt.h>
 #include <asm/simd.h>
+#include "internal.h"
 
 /* skcipher support */
 
@@ -69,7 +70,7 @@ static int simd_skcipher_encrypt(struct skcipher_request *req)
 	subreq = skcipher_request_ctx(req);
 	*subreq = *req;
 
-	if (!crypto_simd_usable() ||
+	if (crypto_simd_force_async() || !crypto_simd_usable() ||
 	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -90,7 +91,7 @@ static int simd_skcipher_decrypt(struct skcipher_request *req)
 	subreq = skcipher_request_ctx(req);
 	*subreq = *req;
 
-	if (!crypto_simd_usable() ||
+	if (crypto_simd_force_async() || !crypto_simd_usable() ||
 	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -317,7 +318,7 @@ static int simd_aead_encrypt(struct aead_request *req)
 	subreq = aead_request_ctx(req);
 	*subreq = *req;
 
-	if (!crypto_simd_usable() ||
+	if (crypto_simd_force_async() || !crypto_simd_usable() ||
 	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -338,7 +339,7 @@ static int simd_aead_decrypt(struct aead_request *req)
 	subreq = aead_request_ctx(req);
 	*subreq = *req;
 
-	if (!crypto_simd_usable() ||
+	if (crypto_simd_force_async() || !crypto_simd_usable() ||
 	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index fbc89baf7de6..54de2223cbd4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -679,6 +679,12 @@ source "net/Kconfig.debug"
 
 endmenu # "Networking Debugging"
 
+config DEBUG_CRYPTO
+	bool "Cryptographic API Debugging"
+	depends on DEBUG_KERNEL && CRYPTO && DEBUG_FS
+	help
+	  Enable debugging options in the core Cryptographic API.
+
 menu "Memory Debugging"
 
 source "mm/Kconfig.debug"
-- 
2.40.1

