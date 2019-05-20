Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD7DC04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE532171F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558371264;
	bh=7PqKepwG1KHg8b6GulaQGy+H263dxXKC4nz45WbUENE=;
	h=From:To:Subject:Date:List-ID:From;
	b=jwefaDeSa+XTTsGyc5eO7aXGfWTXLhUDGmnqQ6VIsDX4DppXeIZbkf32q3iPb3fBy
	 Mwl9dYFkY1+2o2G60AAsT2IVUPVovId5vG5KPStmFrIVmp5TfLioc7/TRU/swvcaOn
	 IVO7uYWz7rmUV242Lu5gElPU4cO48jNXHlde3SUU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389676AbfETQyY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfETQyY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:54:24 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46F78216B7;
        Mon, 20 May 2019 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558371263;
        bh=7PqKepwG1KHg8b6GulaQGy+H263dxXKC4nz45WbUENE=;
        h=From:To:Subject:Date:From;
        b=05DMDoDGkPWQtqXhvbPwYECz++9CrOMNBbMML5GFGceAZeWc46XnjHUvVQYkIz8Td
         XvtmIM/RzF2WEzM3GU234ZJbBTc/k2F+O1Z7vvdaVLy2VTQJ6TWTlNHhhbEdfKEwXU
         dH6xoUKPg55hhqmL6VpnWOJpRWRuMGqWfmDbH704=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: cryptd - move kcrypto_wq into cryptd
Date:   Mon, 20 May 2019 09:53:58 -0700
Message-Id: <20190520165358.169396-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

kcrypto_wq is only used by cryptd, so move it into cryptd.c and change
the workqueue name from "crypto" to "cryptd".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig                         |  5 ----
 crypto/Makefile                        |  2 --
 crypto/cryptd.c                        | 24 ++++++++++++----
 crypto/crypto_wq.c                     | 40 --------------------------
 drivers/crypto/cavium/cpt/cptvf_algs.c |  1 -
 include/crypto/crypto_wq.h             |  8 ------
 6 files changed, 19 insertions(+), 61 deletions(-)
 delete mode 100644 crypto/crypto_wq.c
 delete mode 100644 include/crypto/crypto_wq.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5350aa9368ecd..9cdd92520f00f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -61,7 +61,6 @@ config CRYPTO_BLKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
 	select CRYPTO_RNG2
-	select CRYPTO_WORKQUEUE
 
 config CRYPTO_HASH
 	tristate
@@ -183,15 +182,11 @@ config CRYPTO_PCRYPT
 	  This converts an arbitrary crypto algorithm into a parallel
 	  algorithm that executes in kernel threads.
 
-config CRYPTO_WORKQUEUE
-       tristate
-
 config CRYPTO_CRYPTD
 	tristate "Software async crypto daemon"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
-	select CRYPTO_WORKQUEUE
 	help
 	  This is a generic software asynchronous crypto daemon that
 	  converts an arbitrary synchronous software crypto algorithm
diff --git a/crypto/Makefile b/crypto/Makefile
index 266a4cdbb9e2a..2adf06b178e9c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -6,8 +6,6 @@
 obj-$(CONFIG_CRYPTO) += crypto.o
 crypto-y := api.o cipher.o compress.o memneq.o
 
-obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
-
 obj-$(CONFIG_CRYPTO_ENGINE) += crypto_engine.o
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index b3bb99390ae79..1bf777b765127 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -21,7 +21,6 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/cryptd.h>
-#include <crypto/crypto_wq.h>
 #include <linux/atomic.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -31,11 +30,14 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 static unsigned int cryptd_max_cpu_qlen = 1000;
 module_param(cryptd_max_cpu_qlen, uint, 0);
 MODULE_PARM_DESC(cryptd_max_cpu_qlen, "Set cryptd Max queue depth");
 
+static struct workqueue_struct *cryptd_wq;
+
 struct cryptd_cpu_queue {
 	struct crypto_queue queue;
 	struct work_struct work;
@@ -141,7 +143,7 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 	if (err == -ENOSPC)
 		goto out_put_cpu;
 
-	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+	queue_work_on(cpu, cryptd_wq, &cpu_queue->work);
 
 	if (!atomic_read(refcnt))
 		goto out_put_cpu;
@@ -184,7 +186,7 @@ static void cryptd_queue_worker(struct work_struct *work)
 	req->complete(req, 0);
 
 	if (cpu_queue->queue.qlen)
-		queue_work(kcrypto_wq, &cpu_queue->work);
+		queue_work(cryptd_wq, &cpu_queue->work);
 }
 
 static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm *tfm)
@@ -1123,19 +1125,31 @@ static int __init cryptd_init(void)
 {
 	int err;
 
+	cryptd_wq = alloc_workqueue("cryptd", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
+				    1);
+	if (!cryptd_wq)
+		return -ENOMEM;
+
 	err = cryptd_init_queue(&queue, cryptd_max_cpu_qlen);
 	if (err)
-		return err;
+		goto err_destroy_wq;
 
 	err = crypto_register_template(&cryptd_tmpl);
 	if (err)
-		cryptd_fini_queue(&queue);
+		goto err_fini_queue;
 
+	return 0;
+
+err_fini_queue:
+	cryptd_fini_queue(&queue);
+err_destroy_wq:
+	destroy_workqueue(cryptd_wq);
 	return err;
 }
 
 static void __exit cryptd_exit(void)
 {
+	destroy_workqueue(cryptd_wq);
 	cryptd_fini_queue(&queue);
 	crypto_unregister_template(&cryptd_tmpl);
 }
diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
deleted file mode 100644
index 2f1b8d12952af..0000000000000
--- a/crypto/crypto_wq.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Workqueue for crypto subsystem
- *
- * Copyright (c) 2009 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#include <linux/workqueue.h>
-#include <linux/module.h>
-#include <crypto/algapi.h>
-#include <crypto/crypto_wq.h>
-
-struct workqueue_struct *kcrypto_wq;
-EXPORT_SYMBOL_GPL(kcrypto_wq);
-
-static int __init crypto_wq_init(void)
-{
-	kcrypto_wq = alloc_workqueue("crypto",
-				     WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
-	if (unlikely(!kcrypto_wq))
-		return -ENOMEM;
-	return 0;
-}
-
-static void __exit crypto_wq_exit(void)
-{
-	destroy_workqueue(kcrypto_wq);
-}
-
-subsys_initcall(crypto_wq_init);
-module_exit(crypto_wq_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Workqueue for crypto subsystem");
diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 9810ad8ac5197..f6b0c9df12edb 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -10,7 +10,6 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/crypto_wq.h>
 #include <crypto/des.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
diff --git a/include/crypto/crypto_wq.h b/include/crypto/crypto_wq.h
deleted file mode 100644
index 23114746ac087..0000000000000
--- a/include/crypto/crypto_wq.h
+++ /dev/null
@@ -1,8 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef CRYPTO_WQ_H
-#define CRYPTO_WQ_H
-
-#include <linux/workqueue.h>
-
-extern struct workqueue_struct *kcrypto_wq;
-#endif
-- 
2.21.0.1020.gf2820cf01a-goog

