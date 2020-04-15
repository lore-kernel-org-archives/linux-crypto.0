Return-Path: <SRS0=7EYG=57=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF40C2BA19
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5D4D20774
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437905AbgDOU1J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Apr 2020 16:27:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45142 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437803AbgDOU0x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Apr 2020 16:26:53 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35C09200A21;
        Wed, 15 Apr 2020 22:26:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1E71C200A0C;
        Wed, 15 Apr 2020 22:26:34 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 83E09202B0;
        Wed, 15 Apr 2020 22:26:33 +0200 (CEST)
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
Subject: [PATCH v5 2/3] crypto: engine - support for parallel requests based on retry mechanism
Date:   Wed, 15 Apr 2020 23:26:14 +0300
Message-Id: <1586982375-18710-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple requests, in parallel,
for crypto engine based on a retry mechanism.
If hardware was unable to execute a backlog request, enqueue it
back in front of crypto-engine queue, to keep the order
of requests.

A new variable is added, retry_support (this is to keep the
backward compatibility of crypto-engine) , which keeps track
whether the hardware has support for retry mechanism and,
also, if can run multiple requests.

If do_one_request() returns:
>= 0: hardware executed the request successfully;
< 0: this is the old error path. If hardware has support for retry
mechanism, the request is put back in front of crypto-engine queue.
For backwards compatibility, if the retry support is not available,
the crypto-engine will work as before.
Only MAY_BACKLOG requests are enqueued back into
crypto-engine's queue, since the others can be dropped.

The new crypto_engine_alloc_init_and_set function, initializes
crypto-engine, sets the maximum size for crypto-engine software
queue (not hardcoded anymore) and the retry_support variable
is set, by default, to false.
On crypto_pump_requests(), if do_one_request() returns >= 0,
a new request is send to hardware, until there is no space in
hardware and do_one_request() returns < 0.

By default, retry_support is false and crypto-engine will
work as before - will send requests to hardware,
one-by-one, on crypto_pump_requests(), and complete it, on
crypto_finalize_request(), and so on.

To support multiple requests, in each driver, retry_support
must be set on true, and if do_one_request() returns an error
the request must not be freed, since it will be enqueued back
into crypto-engine's queue.

When all drivers, that use crypto-engine now, will be updated for
retry mechanism, the retry_support variable can be removed.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 140 +++++++++++++++++++++++++++++++---------
 include/crypto/engine.h |  10 ++-
 2 files changed, 118 insertions(+), 32 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff1e05a..2e2b879d31bb 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -22,32 +22,36 @@
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
 
-	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
-		finalize_cur_req = true;
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	/*
+	 * If hardware cannot enqueue more requests
+	 * and retry mechanism is not supported
+	 * make sure we are completing the current request
+	 */
+	if (!engine->retry_support) {
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		if (engine->cur_req == req) {
+			finalize_req = true;
+			engine->cur_req = NULL;
+		}
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	}
 
-	if (finalize_cur_req) {
+	if (finalize_req || engine->retry_support) {
 		enginectx = crypto_tfm_ctx(req->tfm);
-		if (engine->cur_req_prepared &&
+		if (enginectx->op.prepare_request &&
 		    enginectx->op.unprepare_request) {
 			ret = enginectx->op.unprepare_request(engine, req);
 			if (ret)
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
-		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		engine->cur_req_prepared = false;
-		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
-
 	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -74,7 +78,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
 	/* Make sure we are not already running a request */
-	if (engine->cur_req)
+	if (!engine->retry_support && engine->cur_req)
 		goto out;
 
 	/* If another context is idling then defer */
@@ -108,13 +112,21 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+start_request:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
+	/*
+	 * If hardware doesn't support the retry mechanism,
+	 * keep track of the request we are processing now.
+	 * We'll need it on completion (crypto_finalize_request).
+	 */
+	if (!engine->retry_support)
+		engine->cur_req = async_req;
+
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -130,7 +142,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err;
+			goto req_err_2;
 		}
 	}
 
@@ -141,28 +153,75 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
-	if (ret) {
-		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
-		goto req_err;
+
+	/* Request unsuccessfully executed by hardware */
+	if (ret < 0) {
+		/* Non-backlog requests can be dropped */
+		if (!engine->retry_support ||
+		    !(async_req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+			dev_err(engine->dev,
+				"Failed to do one request from queue: %d\n",
+				ret);
+			goto req_err_1;
+		}
+		/*
+		 * If retry mechanism is supported,
+		 * unprepare current request and
+		 * enqueue it back into crypto-engine queue.
+		 */
+		if (enginectx->op.unprepare_request) {
+			ret = enginectx->op.unprepare_request(engine,
+							      async_req);
+			if (ret)
+				dev_err(engine->dev,
+					"failed to unprepare request\n");
+		}
+
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		/*
+		 * If hardware was unable to execute request, enqueue it
+		 * back in front of crypto-engine queue, to keep the order
+		 * of requests.
+		 */
+		crypto_enqueue_request_head(&engine->queue, async_req);
+
+		kthread_queue_work(engine->kworker, &engine->pump_requests);
+		goto out;
 	}
-	return;
 
-req_err:
-	crypto_finalize_request(engine, async_req, ret);
+	goto retry;
+
+req_err_1:
+	if (enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, async_req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
+	}
+
+req_err_2:
+	async_req->complete(async_req, ret);
+
+retry:
+	/* If retry mechanism is supported, send new requests to engine */
+	if (engine->retry_support) {
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		goto start_request;
+	}
 	return;
 
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	return;
 }
 
 static void crypto_pump_work(struct kthread_work *work)
@@ -386,15 +445,20 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
- * initialize it.
+ * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
+ * and initialize it by setting the maximum number of entries in the software
+ * crypto-engine queue.
  * @dev: the device attached with one hardware engine
+ * @retry_support: whether hardware has support for retry mechanism
  * @rt: whether this queue is set to run as a realtime task
+ * @qlen: maximum size of the crypto-engine queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool retry_support,
+						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -411,12 +475,12 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->running = false;
 	engine->busy = false;
 	engine->idling = false;
-	engine->cur_req_prepared = false;
+	engine->retry_support = retry_support;
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -433,6 +497,22 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
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
+	return crypto_engine_alloc_init_and_set(dev, false, rt,
+						CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67f93c7..b92d7ff1528a 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -24,7 +24,9 @@
  * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
- * @cur_req_prepared: current request is prepared
+ * @retry_support: indication that the hardware allows re-execution
+ * of a failed backlog request
+ * crypto-engine, in head position to keep order
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to syncronise access to request queue
  * @queue: the crypto queue of the engine
@@ -45,7 +47,8 @@ struct crypto_engine {
 	bool			idling;
 	bool			busy;
 	bool			running;
-	bool			cur_req_prepared;
+
+	bool			retry_support;
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
@@ -102,6 +105,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool retry_support,
+						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.17.1

