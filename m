From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 1/2] crypto: move crypto engine to its own header
Date: Wed, 31 Aug 2016 14:02:57 +0200
Message-ID: <1472644978-9003-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1472644978-9003-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, baolin.wang@linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34822 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933428AbcHaMD2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 08:03:28 -0400
In-Reply-To: <1472644978-9003-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch move the whole crypto engine API to its own header
crypto/engine.h.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c    |  1 +
 drivers/crypto/omap-aes.c |  1 +
 drivers/crypto/omap-des.c |  1 +
 include/crypto/algapi.h   | 70 ------------------------------------
 include/crypto/engine.h   | 90 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 93 insertions(+), 70 deletions(-)
 create mode 100644 include/crypto/engine.h

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index a55c82d..795b6f9 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/delay.h>
+#include <crypto/engine.h>
 #include "internal.h"
 
 #define CRYPTO_ENGINE_MAX_QLEN 10
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4ab53a6..993e08e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -36,6 +36,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
+#include <crypto/engine.h>
 
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 5691434..dc36e1c 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -39,6 +39,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/des.h>
 #include <crypto/algapi.h>
+#include <crypto/engine.h>
 
 #define DST_MAXBURST			2
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 8637cdf..404e955 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -15,7 +15,6 @@
 #include <linux/crypto.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/kthread.h>
 #include <linux/skbuff.h>
 
 struct crypto_aead;
@@ -129,75 +128,6 @@ struct ablkcipher_walk {
 	unsigned int		blocksize;
 };
 
-#define ENGINE_NAME_LEN	30
-/*
- * struct crypto_engine - crypto hardware engine
- * @name: the engine name
- * @idling: the engine is entering idle state
- * @busy: request pump is busy
- * @running: the engine is on working
- * @cur_req_prepared: current request is prepared
- * @list: link with the global crypto engine list
- * @queue_lock: spinlock to syncronise access to request queue
- * @queue: the crypto queue of the engine
- * @rt: whether this queue is set to run as a realtime task
- * @prepare_crypt_hardware: a request will soon arrive from the queue
- * so the subsystem requests the driver to prepare the hardware
- * by issuing this call
- * @unprepare_crypt_hardware: there are currently no more requests on the
- * queue so the subsystem notifies the driver that it may relax the
- * hardware by issuing this call
- * @prepare_request: do some prepare if need before handle the current request
- * @unprepare_request: undo any work done by prepare_message()
- * @crypt_one_request: do encryption for current request
- * @kworker: thread struct for request pump
- * @kworker_task: pointer to task for request pump kworker thread
- * @pump_requests: work struct for scheduling work to the request pump
- * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
- */
-struct crypto_engine {
-	char			name[ENGINE_NAME_LEN];
-	bool			idling;
-	bool			busy;
-	bool			running;
-	bool			cur_req_prepared;
-
-	struct list_head	list;
-	spinlock_t		queue_lock;
-	struct crypto_queue	queue;
-
-	bool			rt;
-
-	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
-	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
-
-	int (*prepare_request)(struct crypto_engine *engine,
-			       struct ablkcipher_request *req);
-	int (*unprepare_request)(struct crypto_engine *engine,
-				 struct ablkcipher_request *req);
-	int (*crypt_one_request)(struct crypto_engine *engine,
-				 struct ablkcipher_request *req);
-
-	struct kthread_worker           kworker;
-	struct task_struct              *kworker_task;
-	struct kthread_work             pump_requests;
-
-	void				*priv_data;
-	struct ablkcipher_request	*cur_req;
-};
-
-int crypto_transfer_request(struct crypto_engine *engine,
-			    struct ablkcipher_request *req, bool need_pump);
-int crypto_transfer_request_to_engine(struct crypto_engine *engine,
-				      struct ablkcipher_request *req);
-void crypto_finalize_request(struct crypto_engine *engine,
-			     struct ablkcipher_request *req, int err);
-int crypto_engine_start(struct crypto_engine *engine);
-int crypto_engine_stop(struct crypto_engine *engine);
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
-int crypto_engine_exit(struct crypto_engine *engine);
-
 extern const struct crypto_type crypto_ablkcipher_type;
 extern const struct crypto_type crypto_blkcipher_type;
 
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
new file mode 100644
index 0000000..40899bd
--- /dev/null
+++ b/include/crypto/engine.h
@@ -0,0 +1,90 @@
+/*
+ * Crypto engine API
+ *
+ * Copyright (c) 2016 Baolin Wang <baolin.wang@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_ENGINE_H
+#define _CRYPTO_ENGINE_H
+
+#include <linux/crypto.h>
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <crypto/algapi.h>
+
+#define ENGINE_NAME_LEN	30
+/*
+ * struct crypto_engine - crypto hardware engine
+ * @name: the engine name
+ * @idling: the engine is entering idle state
+ * @busy: request pump is busy
+ * @running: the engine is on working
+ * @cur_req_prepared: current request is prepared
+ * @list: link with the global crypto engine list
+ * @queue_lock: spinlock to syncronise access to request queue
+ * @queue: the crypto queue of the engine
+ * @rt: whether this queue is set to run as a realtime task
+ * @prepare_crypt_hardware: a request will soon arrive from the queue
+ * so the subsystem requests the driver to prepare the hardware
+ * by issuing this call
+ * @unprepare_crypt_hardware: there are currently no more requests on the
+ * queue so the subsystem notifies the driver that it may relax the
+ * hardware by issuing this call
+ * @prepare_request: do some prepare if need before handle the current request
+ * @unprepare_request: undo any work done by prepare_message()
+ * @crypt_one_request: do encryption for current request
+ * @kworker: thread struct for request pump
+ * @kworker_task: pointer to task for request pump kworker thread
+ * @pump_requests: work struct for scheduling work to the request pump
+ * @priv_data: the engine private data
+ * @cur_req: the current request which is on processing
+ */
+struct crypto_engine {
+	char			name[ENGINE_NAME_LEN];
+	bool			idling;
+	bool			busy;
+	bool			running;
+	bool			cur_req_prepared;
+
+	struct list_head	list;
+	spinlock_t		queue_lock;
+	struct crypto_queue	queue;
+
+	bool			rt;
+
+	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+
+	int (*prepare_request)(struct crypto_engine *engine,
+			       struct ablkcipher_request *req);
+	int (*unprepare_request)(struct crypto_engine *engine,
+				 struct ablkcipher_request *req);
+	int (*crypt_one_request)(struct crypto_engine *engine,
+				 struct ablkcipher_request *req);
+
+	struct kthread_worker           kworker;
+	struct task_struct              *kworker_task;
+	struct kthread_work             pump_requests;
+
+	void				*priv_data;
+	struct ablkcipher_request	*cur_req;
+};
+
+int crypto_transfer_request(struct crypto_engine *engine,
+			    struct ablkcipher_request *req, bool need_pump);
+int crypto_transfer_request_to_engine(struct crypto_engine *engine,
+				      struct ablkcipher_request *req);
+void crypto_finalize_request(struct crypto_engine *engine,
+			     struct ablkcipher_request *req, int err);
+int crypto_engine_start(struct crypto_engine *engine);
+int crypto_engine_stop(struct crypto_engine *engine);
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+int crypto_engine_exit(struct crypto_engine *engine);
+
+#endif /* _CRYPTO_ENGINE_H */
-- 
2.7.3
