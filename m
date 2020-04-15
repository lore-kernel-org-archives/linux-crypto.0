Return-Path: <SRS0=7EYG=57=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEF9C2BA19
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87C0620784
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437867AbgDOU0y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Apr 2020 16:26:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54544 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437804AbgDOU0v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Apr 2020 16:26:51 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2BB151A0A17;
        Wed, 15 Apr 2020 22:26:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0ED6B1A0A0E;
        Wed, 15 Apr 2020 22:26:38 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6C183202B0;
        Wed, 15 Apr 2020 22:26:37 +0200 (CEST)
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
Subject: [PATCH v5 3/3] crypto: engine - support for batch requests
Date:   Wed, 15 Apr 2020 23:26:15 +0300
Message-Id: <1586982375-18710-4-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
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
 crypto/crypto_engine.c  | 27 ++++++++++++++++++++++++++-
 include/crypto/engine.h |  5 +++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 2e2b879d31bb..217eae3e8037 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -221,6 +221,18 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 
 out:
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
+
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
+
 	return;
 }
 
@@ -450,6 +462,12 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  * crypto-engine queue.
  * @dev: the device attached with one hardware engine
  * @retry_support: whether hardware has support for retry mechanism
+ * @cbk_do_batch: pointer to a callback function to be invoked when executing a
+ *                a batch of requests.
+ *                This has the form:
+ *                callback(struct crypto_engine *engine)
+ *                where:
+ *                @engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
  * @qlen: maximum size of the crypto-engine queue
  *
@@ -458,6 +476,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  */
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool retry_support,
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
@@ -477,6 +496,12 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	engine->idling = false;
 	engine->retry_support = retry_support;
 	engine->priv_data = dev;
+	/*
+	 * Batch requests is possible only if
+	 * hardware has support for retry mechanism.
+	 */
+	engine->do_batch_requests = retry_support ? cbk_do_batch : NULL;
+
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
@@ -510,7 +535,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
  */
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 {
-	return crypto_engine_alloc_init_and_set(dev, false, rt,
+	return crypto_engine_alloc_init_and_set(dev, false, NULL, rt,
 						CRYPTO_ENGINE_MAX_QLEN);
 }
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index b92d7ff1528a..3f06e40d063a 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -37,6 +37,8 @@
  * @unprepare_crypt_hardware: there are currently no more requests on the
  * queue so the subsystem notifies the driver that it may relax the
  * hardware by issuing this call
+ * @do_batch_requests: execute a batch of requests. Depends on multiple
+ * requests support.
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
@@ -59,6 +61,8 @@ struct crypto_engine {
 
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
+	int (*do_batch_requests)(struct crypto_engine *engine);
+
 
 	struct kthread_worker           *kworker;
 	struct kthread_work             pump_requests;
@@ -107,6 +111,7 @@ int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
 struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 						       bool retry_support,
+						       int (*cbk_do_batch)(struct crypto_engine *engine),
 						       bool rt, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
-- 
2.17.1

