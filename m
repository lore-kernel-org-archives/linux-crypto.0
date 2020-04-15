Return-Path: <SRS0=7EYG=57=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D9DC2BA19
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA8E2076D
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 20:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437848AbgDOU0x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Apr 2020 16:26:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45094 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437346AbgDOU0v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Apr 2020 16:26:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E061A200A1C;
        Wed, 15 Apr 2020 22:26:29 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D3A6D200A0C;
        Wed, 15 Apr 2020 22:26:29 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 14695202B0;
        Wed, 15 Apr 2020 22:26:29 +0200 (CEST)
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
Subject: [PATCH v5 1/3] crypto: algapi - create function to add request in front of queue
Date:   Wed, 15 Apr 2020 23:26:13 +0300
Message-Id: <1586982375-18710-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_enqueue_request_head function that enqueues a
MAY_BACKLOG request in front of queue.
This will be used in crypto-engine, on error path. In case a request
was not executed by hardware, enqueue it back in front of queue (to
keep the order of requests).

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 crypto/algapi.c         | 11 +++++++++++
 include/crypto/algapi.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 69605e21af92..a8732e8e7843 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -904,6 +904,17 @@ int crypto_enqueue_request(struct crypto_queue *queue,
 }
 EXPORT_SYMBOL_GPL(crypto_enqueue_request);
 
+void crypto_enqueue_request_head(struct crypto_queue *queue,
+				 struct crypto_async_request *request)
+{
+	/* only backlog requests can be enqueued */
+	BUG_ON(!(request->flags & CRYPTO_TFM_REQ_MAY_BACKLOG));
+
+	queue->qlen++;
+	list_add(&request->list, &queue->list);
+}
+EXPORT_SYMBOL_GPL(crypto_enqueue_request_head);
+
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
 {
 	struct list_head *request;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e115f9215ed5..00a9cf98debe 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -125,6 +125,8 @@ int crypto_inst_setname(struct crypto_instance *inst, const char *name,
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
 			   struct crypto_async_request *request);
+void crypto_enqueue_request_head(struct crypto_queue *queue,
+				 struct crypto_async_request *request);
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
 static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 {
-- 
2.17.1

