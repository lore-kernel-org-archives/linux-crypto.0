Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99ABC32771
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 23:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F6F2253D
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 23:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgATXc7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 18:32:59 -0500
Received: from inva021.nxp.com ([92.121.34.21]:51010 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgATXc6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 18:32:58 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D1BEB200AE1;
        Tue, 21 Jan 2020 00:32:55 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C343C200ADB;
        Tue, 21 Jan 2020 00:32:55 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 214CD2056E;
        Tue, 21 Jan 2020 00:32:55 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [RFC PATCH] Crypto-engine support for parallel requests
Date:   Tue, 21 Jan 2020 01:32:29 +0200
Message-Id: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple requests, in parallel,
for crypto engine.
A no_reqs is initialized and set in the new
crypto_engine_alloc_init_and_set function.
Here, is also set the maximum size for crypto-engine software
queue (not hardcoded anymore).
On crypto_pump_requests the no_reqs is increased, until the
max_no_reqs is reached, and decreased on crypto_finalize_request,
or on error path (in case a prepare_request or do_one_request
operation was unsuccessful).

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 112 +++++++++++++++++++++++++++++++++---------------
 include/crypto/engine.h |  11 +++--
 2 files changed, 84 insertions(+), 39 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff..5219141 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -14,6 +14,7 @@
 #include "internal.h"
 
 #define CRYPTO_ENGINE_MAX_QLEN 10
+#define CRYPTO_ENGINE_MAX_CONCURRENT_REQS 1
 
 /**
  * crypto_finalize_request - finalize one request if the request is done
@@ -22,32 +23,27 @@
  * @err: error number
  */
 static void crypto_finalize_request(struct crypto_engine *engine,
-			     struct crypto_async_request *req, int err)
+				    struct crypto_async_request *req, int err)
 {
 	unsigned long flags;
-	bool finalize_cur_req = false;
+	bool finalize_req = false;
 	int ret;
 	struct crypto_engine_ctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
-		finalize_cur_req = true;
+	if (engine->no_reqs > 0) {
+		finalize_req = true;
+		engine->no_reqs--;
+	}
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
-	if (finalize_cur_req) {
-		enginectx = crypto_tfm_ctx(req->tfm);
-		if (engine->cur_req_prepared &&
-		    enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine, req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		engine->cur_req_prepared = false;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	enginectx = crypto_tfm_ctx(req->tfm);
+	if (finalize_req && enginectx->op.prepare_request &&
+	    enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
 	}
-
 	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -73,8 +69,8 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
-	/* Make sure we are not already running a request */
-	if (engine->cur_req)
+	/* Make sure we have space, for more requests to run */
+	if (engine->no_reqs >= engine->max_no_reqs)
 		goto out;
 
 	/* If another context is idling then defer */
@@ -108,13 +104,16 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+retry:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
+	/* Increase the number of concurrent requests that are in execution */
+	engine->no_reqs++;
+
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -130,7 +129,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err;
+			goto req_err_2;
 		}
 	}
 
@@ -141,26 +140,45 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare request: %d\n",
 				ret);
-			goto req_err;
+			goto req_err_2;
 		}
-		engine->cur_req_prepared = true;
 	}
 	if (!enginectx->op.do_one_request) {
 		dev_err(engine->dev, "failed to do request\n");
 		ret = -EINVAL;
-		goto req_err;
+		goto req_err_1;
 	}
+
 	ret = enginectx->op.do_one_request(engine, async_req);
 	if (ret) {
 		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
-		goto req_err;
+		goto req_err_1;
 	}
-	return;
-
-req_err:
-	crypto_finalize_request(engine, async_req, ret);
-	return;
 
+	/*
+	 * If there is still space for concurrent requests,
+	 * try and send a new one
+	 */
+	spin_lock_irqsave(&engine->queue_lock, flags);
+	if (engine->no_reqs < engine->max_no_reqs)
+		goto retry;
+	goto out;
+
+req_err_1:
+	if (enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, async_req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
+	}
+req_err_2:
+	async_req->complete(async_req, ret);
+	spin_lock_irqsave(&engine->queue_lock, flags);
+	/*
+	 * If unable to prepare or execute the request,
+	 * decrease the number of concurrent requests
+	 */
+	engine->no_reqs--;
+	goto retry;
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 }
@@ -386,15 +404,21 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
- * initialize it.
+ * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
+ * and initialize it by setting the maximum number of entries in the software
+ * crypto-engine queue and the maximum number of concurrent requests that can
+ * be executed at once.
  * @dev: the device attached with one hardware engine
  * @rt: whether this queue is set to run as a realtime task
+ * @max_no_reqs: maximum number of request that can be executed in parallel
+ * @qlen: maximum size of the crypto-engine queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool rt, int max_no_reqs,
+						       int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -411,12 +435,13 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->running = false;
 	engine->busy = false;
 	engine->idling = false;
-	engine->cur_req_prepared = false;
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
+	engine->max_no_reqs = max_no_reqs;
+	engine->no_reqs = 0;
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -433,6 +458,23 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
 	return engine;
 }
+EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
+
+/**
+ * crypto_engine_alloc_init - allocate crypto hardware engine structure and
+ * initialize it.
+ * @dev: the device attached with one hardware engine
+ * @rt: whether this queue is set to run as a realtime task
+ *
+ * This must be called from context that can sleep.
+ * Return: the crypto engine structure on success, else NULL.
+ */
+struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+{
+	return crypto_engine_alloc_init_and_set(dev, rt,
+						CRYPTO_ENGINE_MAX_CONCURRENT_REQS,
+						CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67..5f9a6df 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -24,7 +24,6 @@
  * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
- * @cur_req_prepared: current request is prepared
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to syncronise access to request queue
  * @queue: the crypto queue of the engine
@@ -38,14 +37,14 @@
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
+ * @max_no_reqs: maximum number of request which can be processed in parallel
+ * @no_reqs: current number of request which are processed in parallel
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
 	bool			idling;
 	bool			busy;
 	bool			running;
-	bool			cur_req_prepared;
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
@@ -61,7 +60,8 @@ struct crypto_engine {
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct crypto_async_request	*cur_req;
+	int			max_no_reqs;
+	int			no_reqs;
 };
 
 /*
@@ -102,6 +102,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool rt, int max_no_reqs,
+						       int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.1.0

