Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF5CC10DCE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AA05206D5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCHWvy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 18:51:54 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57088 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgCHWvy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 18:51:54 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8BEF9200A7B;
        Sun,  8 Mar 2020 23:51:51 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7CDDE20020F;
        Sun,  8 Mar 2020 23:51:51 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E1DD7204CC;
        Sun,  8 Mar 2020 23:51:50 +0100 (CET)
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
Subject: [PATCH v4 1/2] crypto: engine - support for parallel requests
Date:   Mon,  9 Mar 2020 00:51:32 +0200
Message-Id: <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple requests, in parallel,
for crypto engine.

Two new variables are added, cnt_do_req (number of requests accepted
by hardware) and cnt_finalize (number of completed/
finalized requests), which keeps track whether the hardware
can enqueue new requests.
cnt_do_req will be set based on the return value of
do_one_request(), which is expected to be:
> 0: if hardware still has space in its queue. A driver can implement
do_one_request() to return the number of free entries in
hardware queue;
0: if the request was accepted, by hardware, with success, but the
hardware doesn't support multiple requests or there is no space
left in the hardware queue.
This is to keep the backward compatibility of crypto-engine.
< 0: error.

cnt_finalize will be increased in crypto_finalize_request.

The new crypto_engine_alloc_init_and_set function, initialize
crypto-engine, sets the maximum size for crypto-engine software
queue (not hardcoded anymore) and the cnt_do_req and cnt_finalize
variables will be set, by default, to 0.
On crypto_pump_requests(), if do_one_request() returns > 0,
a new request is send to hardware, until there is no space
and do_one_request() returns 0.

By default, if do_one_request() returns 0, crypto-engine will
work as before - will send requests to hardware,
one-by-one, on crypto_pump_requests(), and complete it, on
crypto_finalize_request(), and so on.
To support multiple requests, in each driver, do_one_request()
needs to be updated to return > 0, if there is space in
hardware queue, otherwise will work as before.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 122 ++++++++++++++++++++++++++++++++++--------------
 include/crypto/engine.h |  11 +++--
 2 files changed, 94 insertions(+), 39 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff..dbfd53c2 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -22,30 +22,27 @@
  * @err: error number
  */
 static void crypto_finalize_request(struct crypto_engine *engine,
-			     struct crypto_async_request *req, int err)
+				    struct crypto_async_request *req, int err)
 {
 	unsigned long flags;
-	bool finalize_cur_req = false;
 	int ret;
 	struct crypto_engine_ctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
-		finalize_cur_req = true;
+	/*
+	 * Increment the number of requests completed.
+	 * We'll need it to start the engine on pump_requests,
+	 * if hardware can enqueue new requests.
+	 */
+	engine->cnt_finalize++;
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
+	if (enginectx->op.prepare_request &&
+	    enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
 	}
 
 	req->complete(req, err);
@@ -69,12 +66,19 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	unsigned long flags;
 	bool was_busy = false;
 	int ret;
+	int can_enq_more = 0;
 	struct crypto_engine_ctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
-	/* Make sure we are not already running a request */
-	if (engine->cur_req)
+	/*
+	 * If hardware cannot enqueue new requests,
+	 * stop the engine, until requests are processed and
+	 * hardware can execute new requests.
+	 * We'll start the engine on request completion
+	 * (crypto_finalize_request).
+	 */
+	if (engine->cnt_finalize != engine->cnt_do_req)
 		goto out;
 
 	/* If another context is idling then defer */
@@ -108,13 +112,13 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+start_request:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -130,7 +134,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err;
+			goto req_err_2;
 		}
 	}
 
@@ -141,25 +145,53 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
+	can_enq_more = ret;
+	if (can_enq_more < 0) {
+		dev_err(engine->dev, "Failed to do one request from queue: %d\n",
+			ret);
+		goto req_err_1;
+	}
+
+	goto retry;
+
+req_err_1:
+	if (enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, async_req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
 	}
-	return;
 
-req_err:
-	crypto_finalize_request(engine, async_req, ret);
-	return;
+req_err_2:
+	async_req->complete(async_req, ret);
+
+retry:
+	spin_lock_irqsave(&engine->queue_lock, flags);
+
+	/*
+	 * If hardware can still enqueue requests,
+	 * increment the number of requests accepted by hardware.
+	 * We'll need it to start the engine on pump_requests.
+	 */
+	if (can_enq_more >= 0)
+		engine->cnt_do_req++;
+
+	/*
+	 * We'll send new requests to engine, if there is space.
+	 * If the 2 counters are equal, that means that all requests
+	 * were executed, so we can send new requests.
+	 */
+	if (engine->cnt_finalize == engine->cnt_do_req || can_enq_more > 0)
+		goto start_request;
 
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
@@ -386,15 +418,18 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
- * initialize it.
+ * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
+ * and initialize it by setting the maximum number of entries in the software
+ * crypto-engine queue.
  * @dev: the device attached with one hardware engine
  * @rt: whether this queue is set to run as a realtime task
+ * @qlen: maximum size of the crypto-engine queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -411,12 +446,13 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->running = false;
 	engine->busy = false;
 	engine->idling = false;
-	engine->cur_req_prepared = false;
+	engine->cnt_do_req = 0;
+	engine->cnt_finalize = 0;
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -433,6 +469,22 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
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
+						CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67..33a5be2 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -24,7 +24,8 @@
  * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
- * @cur_req_prepared: current request is prepared
+ * @cnt_finalize: number of completed/finalized requests
+ * @cnt_do_req: number of requests accepted by hardware
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to syncronise access to request queue
  * @queue: the crypto queue of the engine
@@ -38,14 +39,15 @@
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
 	bool			idling;
 	bool			busy;
 	bool			running;
-	bool			cur_req_prepared;
+
+	u32			cnt_finalize;
+	u32			cnt_do_req;
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
@@ -61,7 +63,6 @@ struct crypto_engine {
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct crypto_async_request	*cur_req;
 };
 
 /*
@@ -102,6 +103,8 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.1.0

