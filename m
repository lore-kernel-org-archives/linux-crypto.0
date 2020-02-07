Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4F9C352A5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500CC20715
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGMg2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 07:36:28 -0500
Received: from inva021.nxp.com ([92.121.34.21]:38620 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbgBGMg2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 07:36:28 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 98E2420452A;
        Fri,  7 Feb 2020 13:36:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 89B5E204529;
        Fri,  7 Feb 2020 13:36:25 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E4C4B203CD;
        Fri,  7 Feb 2020 13:36:24 +0100 (CET)
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
Subject: [PATCH v3 2/2] crypto: engine - support for batch requests
Date:   Fri,  7 Feb 2020 14:36:14 +0200
Message-Id: <1581078974-14778-3-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1581078974-14778-1-git-send-email-iuliana.prodan@nxp.com>
References: <1581078974-14778-1-git-send-email-iuliana.prodan@nxp.com>
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
for multiple request (if can_enqueue_more callback is implemented).

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/crypto_engine.c  | 20 ++++++++++++++++++--
 include/crypto/engine.h |  3 +++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index dc33249..05f2895 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -192,6 +192,12 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	return;
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
+	if (engine->do_batch_requests) {
+		ret = engine->do_batch_requests(engine);
+		if (ret)
+			dev_err(engine->dev, "failed to do batch requests: %d\n",
+				ret);
+	}
 }
 
 static void crypto_pump_work(struct kthread_work *work)
@@ -426,6 +432,12 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  *               callback(struct crypto_engine *engine)
  *               where:
  *               @engine: the crypto engine structure.
+ * @cbk_do_batch: pointer to a callback function to be invoked when executing a
+ *                a batch of requests.
+ *                This has the form:
+ *                callback(struct crypto_engine *engine)
+ *                where:
+ *                @engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
  * @qlen: maximum size of the crypto-engine queue
  *
@@ -434,6 +446,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  */
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool (*cbk_can_enq)(struct crypto_engine *engine),
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
@@ -452,7 +465,10 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	engine->busy = false;
 	engine->idling = false;
 	engine->priv_data = dev;
-	engine->can_enqueue_more = cbk_can_enq;
+	if (cbk_can_enq) {
+		engine->can_enqueue_more = cbk_can_enq;
+		engine->do_batch_requests = cbk_do_batch;
+	}
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
@@ -486,7 +502,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
  */
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 {
-	return crypto_engine_alloc_init_and_set(dev, NULL, rt,
+	return crypto_engine_alloc_init_and_set(dev, NULL, NULL, rt,
 						CRYPTO_ENGINE_MAX_QLEN);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 00d35703..019f884 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -34,6 +34,7 @@
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
+ * @do_batch_requests: execute a batch of requests
  * @can_enqueue_more: callback to check whether the hardware can process
  * a new request
  * @kworker: kthread worker struct for request pump
@@ -57,6 +58,7 @@ struct crypto_engine {
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*do_batch_requests)(struct crypto_engine *engine);
 	bool (*can_enqueue_more)(struct crypto_engine *engine);
 
 	struct kthread_worker           *kworker;
@@ -106,6 +108,7 @@ int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool (*cbk_can_enq)(struct crypto_engine *engine),
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
-- 
2.1.0

