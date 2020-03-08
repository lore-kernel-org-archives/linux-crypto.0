Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF191C10DCE
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A0A20848
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 22:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgCHWv7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 18:51:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:57128 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgCHWv7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 18:51:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id EDA48200430;
        Sun,  8 Mar 2020 23:51:57 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DFA4A20020F;
        Sun,  8 Mar 2020 23:51:57 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5135C204CC;
        Sun,  8 Mar 2020 23:51:57 +0100 (CET)
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
Subject: [PATCH v4 2/2] crypto: engine - support for batch requests
Date:   Mon,  9 Mar 2020 00:51:33 +0200
Message-Id: <1583707893-23699-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for batch requests, per crypto engine.
A new callback is added, do_batch_requests, which executes a
batch of requests. This has the crypto_engine structure as argument
(for cases when more than one crypto-engine is used).
The crypto_engine_alloc_init_and_set function, initializes
crypto-engine, but also, sets the do_batch_requests callback.
On crypto_pump_requests, if do_batch_requests callback is
implemented in a driver, this will be executed. The link between
the requests will be done in driver, if possible.
do_batch_requests is available only if the hardware has support
for multiple request.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 30 +++++++++++++++++++++++++++---
 include/crypto/engine.h |  4 ++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index dbfd53c2..80723ad 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -116,8 +116,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
-	if (!async_req)
-		goto out;
+	if (!async_req) {
+		spin_unlock_irqrestore(&engine->queue_lock, flags);
+		goto batch;
+	}
 
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
@@ -195,6 +197,19 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
+batch:
+	/*
+	 * Batch requests is possible only if
+	 * hardware can enqueue multiple requests
+	 */
+	if (engine->do_batch_requests) {
+		ret = engine->do_batch_requests(engine);
+		if (ret)
+			dev_err(engine->dev, "failed to do batch requests: %d\n",
+				ret);
+	}
+	return;
 }
 
 static void crypto_pump_work(struct kthread_work *work)
@@ -422,6 +437,12 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  * and initialize it by setting the maximum number of entries in the software
  * crypto-engine queue.
  * @dev: the device attached with one hardware engine
+ * @cbk_do_batch: pointer to a callback function to be invoked when executing a
+ *                a batch of requests.
+ *                This has the form:
+ *                callback(struct crypto_engine *engine)
+ *                where:
+ *                @engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
  * @qlen: maximum size of the crypto-engine queue
  *
@@ -429,6 +450,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  * Return: the crypto engine structure on success, else NULL.
  */
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
@@ -449,6 +471,8 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	engine->cnt_do_req = 0;
 	engine->cnt_finalize = 0;
 	engine->priv_data = dev;
+	engine->do_batch_requests = cbk_do_batch;
+
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
@@ -482,7 +506,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
  */
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 {
-	return crypto_engine_alloc_init_and_set(dev, rt,
+	return crypto_engine_alloc_init_and_set(dev, NULL, rt,
 						CRYPTO_ENGINE_MAX_QLEN);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 33a5be2..c64d942 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -36,6 +36,7 @@
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
+ * @do_batch_requests: execute a batch of requests
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -58,6 +59,8 @@ struct crypto_engine {
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*do_batch_requests)(struct crypto_engine *engine);
+
 
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
@@ -104,6 +107,7 @@ int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
-- 
2.1.0

