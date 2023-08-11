Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C205C001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjHKJar (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjHKJa0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:26 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1133430FE
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTL-0020fR-RX; Fri, 11 Aug 2023 17:30:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:20 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:20 +0800
Subject: [PATCH 20/36] crypto: engine - Move struct crypto_engine into internal/engine.h
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTL-0020fR-RX@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Most drivers should not access the internal details of struct
crypto_engine.  Move it into the internal header file.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/engine.h          |   58 -------------------------------------
 include/crypto/internal/engine.h |   61 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 643639c3227c..cc9c7fd1c4d9 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -7,72 +7,16 @@
 #ifndef _CRYPTO_ENGINE_H
 #define _CRYPTO_ENGINE_H
 
-#include <crypto/algapi.h>
-#include <linux/kthread.h>
-#include <linux/spinlock_types.h>
 #include <linux/types.h>
 
 struct aead_request;
 struct ahash_request;
 struct akcipher_request;
+struct crypto_engine;
 struct device;
 struct kpp_request;
 struct skcipher_request;
 
-#define ENGINE_NAME_LEN	30
-/*
- * struct crypto_engine - crypto hardware engine
- * @name: the engine name
- * @idling: the engine is entering idle state
- * @busy: request pump is busy
- * @running: the engine is on working
- * @retry_support: indication that the hardware allows re-execution
- * of a failed backlog request
- * crypto-engine, in head position to keep order
- * @list: link with the global crypto engine list
- * @queue_lock: spinlock to synchronise access to request queue
- * @queue: the crypto queue of the engine
- * @rt: whether this queue is set to run as a realtime task
- * @prepare_crypt_hardware: a request will soon arrive from the queue
- * so the subsystem requests the driver to prepare the hardware
- * by issuing this call
- * @unprepare_crypt_hardware: there are currently no more requests on the
- * queue so the subsystem notifies the driver that it may relax the
- * hardware by issuing this call
- * @do_batch_requests: execute a batch of requests. Depends on multiple
- * requests support.
- * @kworker: kthread worker struct for request pump
- * @pump_requests: work struct for scheduling work to the request pump
- * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
- */
-struct crypto_engine {
-	char			name[ENGINE_NAME_LEN];
-	bool			idling;
-	bool			busy;
-	bool			running;
-
-	bool			retry_support;
-
-	struct list_head	list;
-	spinlock_t		queue_lock;
-	struct crypto_queue	queue;
-	struct device		*dev;
-
-	bool			rt;
-
-	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
-	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
-	int (*do_batch_requests)(struct crypto_engine *engine);
-
-
-	struct kthread_worker           *kworker;
-	struct kthread_work             pump_requests;
-
-	void				*priv_data;
-	struct crypto_async_request	*cur_req;
-};
-
 /*
  * struct crypto_engine_op - crypto hardware engine operations
  * @do_one_request: do encryption for current request
diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
index ffa1bb39d5e4..fbf4be56cf12 100644
--- a/include/crypto/internal/engine.h
+++ b/include/crypto/internal/engine.h
@@ -8,6 +8,67 @@
 #ifndef _CRYPTO_INTERNAL_ENGINE_H
 #define _CRYPTO_INTERNAL_ENGINE_H
 
+#include <crypto/algapi.h>
 #include <crypto/engine.h>
+#include <linux/kthread.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+
+#define ENGINE_NAME_LEN	30
+
+struct device;
+
+/*
+ * struct crypto_engine - crypto hardware engine
+ * @name: the engine name
+ * @idling: the engine is entering idle state
+ * @busy: request pump is busy
+ * @running: the engine is on working
+ * @retry_support: indication that the hardware allows re-execution
+ * of a failed backlog request
+ * crypto-engine, in head position to keep order
+ * @list: link with the global crypto engine list
+ * @queue_lock: spinlock to synchronise access to request queue
+ * @queue: the crypto queue of the engine
+ * @rt: whether this queue is set to run as a realtime task
+ * @prepare_crypt_hardware: a request will soon arrive from the queue
+ * so the subsystem requests the driver to prepare the hardware
+ * by issuing this call
+ * @unprepare_crypt_hardware: there are currently no more requests on the
+ * queue so the subsystem notifies the driver that it may relax the
+ * hardware by issuing this call
+ * @do_batch_requests: execute a batch of requests. Depends on multiple
+ * requests support.
+ * @kworker: kthread worker struct for request pump
+ * @pump_requests: work struct for scheduling work to the request pump
+ * @priv_data: the engine private data
+ * @cur_req: the current request which is on processing
+ */
+struct crypto_engine {
+	char			name[ENGINE_NAME_LEN];
+	bool			idling;
+	bool			busy;
+	bool			running;
+
+	bool			retry_support;
+
+	struct list_head	list;
+	spinlock_t		queue_lock;
+	struct crypto_queue	queue;
+	struct device		*dev;
+
+	bool			rt;
+
+	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*do_batch_requests)(struct crypto_engine *engine);
+
+
+	struct kthread_worker           *kworker;
+	struct kthread_work             pump_requests;
+
+	void				*priv_data;
+	struct crypto_async_request	*cur_req;
+};
 
 #endif
