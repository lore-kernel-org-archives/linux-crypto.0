Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58BBC3524B
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 12:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BCF32084E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 12:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBDMeu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 07:34:50 -0500
Received: from inva021.nxp.com ([92.121.34.21]:38148 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbgBDMet (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 07:34:49 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4CBE322A0E2;
        Tue,  4 Feb 2020 13:34:47 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3DBD322A0CD;
        Tue,  4 Feb 2020 13:34:47 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 680AD20569;
        Tue,  4 Feb 2020 13:34:46 +0100 (CET)
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
Subject: [PATCH v2 1/2] crypto: engine - support for parallel requests
Date:   Tue,  4 Feb 2020 14:34:19 +0200
Message-Id: <1580819660-30211-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1580819660-30211-1-git-send-email-iuliana.prodan@nxp.com>
References: <1580819660-30211-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for executing multiple requests, in parallel,
for crypto engine.
A new callback is added, can_enqueue_more, which asks the
driver if the hardware has free space, to enqueue a new request.
The new crypto_engine_alloc_init_and_set function, initialize
crypto-engine, sets the maximum size for crypto-engine software
queue (not hardcoded anymore) and the can_enqueue_more callback.
On crypto_pump_requests, if can_enqueue_more callback returns true,
a new request is send to hardware, until there is no space and the
callback returns false.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 106 ++++++++++++++++++++++++++++++------------------
 include/crypto/engine.h |  10 +++--
 2 files changed, 72 insertions(+), 44 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff..aba934f 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -22,32 +22,18 @@
  * @err: error number
  */
 static void crypto_finalize_request(struct crypto_engine *engine,
-			     struct crypto_async_request *req, int err)
+				    struct crypto_async_request *req, int err)
 {
-	unsigned long flags;
-	bool finalize_cur_req = false;
 	int ret;
 	struct crypto_engine_ctx *enginectx;
 
-	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
-		finalize_cur_req = true;
-	spin_unlock_irqrestore(&engine->queue_lock, flags);
-
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
-
 	req->complete(req, err);
 
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -73,10 +59,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
-	/* Make sure we are not already running a request */
-	if (engine->cur_req)
-		goto out;
-
 	/* If another context is idling then defer */
 	if (engine->idling) {
 		kthread_queue_work(engine->kworker, &engine->pump_requests);
@@ -108,13 +90,18 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+start_request:
+	/* If hw is busy, do not send any request */
+	if (engine->can_enqueue_more &&
+	    !engine->can_enqueue_more(engine))
+		goto out;
+
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -130,7 +117,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err;
+			goto req_err_2;
 		}
 	}
 
@@ -141,26 +128,38 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
 
-req_err:
-	crypto_finalize_request(engine, async_req, ret);
-	return;
+	goto retry;
+
+req_err_1:
+	if (enginectx->op.unprepare_request) {
+		ret = enginectx->op.unprepare_request(engine, async_req);
+		if (ret)
+			dev_err(engine->dev, "failed to unprepare request\n");
+	}
+req_err_2:
+	async_req->complete(async_req, ret);
 
+retry:
+	if (engine->can_enqueue_more) {
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		goto start_request;
+	}
+	return;
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 }
@@ -386,15 +385,26 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
- * initialize it.
+ * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
+ * and initialize it by setting the maximum number of entries in the software
+ * crypto-engine queue.
  * @dev: the device attached with one hardware engine
+ * @cbk_can_enq: pointer to a callback function to be invoked when pumping
+ *               requests to check whether the hardware can process a new
+ *               request.
+ *               This has the form:
+ *               callback(struct crypto_engine *engine)
+ *               where:
+ *               @engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
+ * @qlen: maximum size of the crypto-engine queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool (*cbk_can_enq)(struct crypto_engine *engine),
+						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -411,12 +421,12 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->running = false;
 	engine->busy = false;
 	engine->idling = false;
-	engine->cur_req_prepared = false;
 	engine->priv_data = dev;
+	engine->can_enqueue_more = cbk_can_enq;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -433,6 +443,22 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
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
+	return crypto_engine_alloc_init_and_set(dev, NULL, rt,
+						CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67..07c3f80 100644
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
@@ -35,17 +34,17 @@
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
+ * @can_enqueue_more: callback to check whether the hardware can process
+ * a new request
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
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
@@ -56,12 +55,12 @@ struct crypto_engine {
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+	bool (*can_enqueue_more)(struct crypto_engine *engine);
 
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct crypto_async_request	*cur_req;
 };
 
 /*
@@ -102,6 +101,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       bool (*cbk_can_enq)(struct crypto_engine *engine),
+						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.1.0

