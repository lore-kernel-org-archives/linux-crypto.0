Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A65C33CB2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EF4524679
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMlWfiRv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgANOAH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:07 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45867 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbgANOAG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so12230004wrj.12;
        Tue, 14 Jan 2020 06:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lxb7PN4lvjObtQ59KMU2hHjHYfZBsU9IrbvtHskV7n0=;
        b=CMlWfiRvaRRJU+hOQ4WPokjIT8GHSX3vkbMyfsBc8DCF2hmxmKbLRl3XuVhkhou0oY
         8ildadcB1t+iC3etvIdUbg1E1UntznuFyodZFJWT/fKIama5xaeApXEASHJT7JgN2ozv
         QCnT8RndunnruzJfnh/71PB8HtxvyO7XJKZnUF7uB+UEQl7A2erDumW8cUH7LVKRRVSc
         clHmeeo+WxvTbERdluTb53uZ8A62/xxsCsI0ksjNmkSLPYzaqbl3ZsQ8rb2gQr+2OhwQ
         umwgvNEbrkvZ6ozlVfbhYTa8lSeqFFXS2E6ACT6PSnFlW92eK2gHkYubDtNs9tVVSPeA
         TMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lxb7PN4lvjObtQ59KMU2hHjHYfZBsU9IrbvtHskV7n0=;
        b=NPDZkZkATGrsehWJwVpX5sTDm6l8I1aj7qeGxtJZjjeykbOpdnbKPnhyjesJcx2Oew
         pN8R1lX+vBzpSut7nvYdvV01NjVZZL12f0FDf2sqxEreIqq5Z+65rijtvmsG4DIRoYhm
         yGlgpCE9qxzs2afEpv17qxKI0GAzN/EWu2eZeqhMdNaKtOuqzsB5ehq9qPcJC1iOOsT2
         G2otXiPvhnL7aSp+fjQ35tLy7YAJg2klS8ydfDmge0hPYCdjeqkKJ7oSgQQspPe7ZSl5
         n0lo4gaXnVLE+SJMA87E8egqv11uvczehTjZ2IrL82MxBF64YiGBjM5nlSQUCkEDMmvQ
         EXSQ==
X-Gm-Message-State: APjAAAW6/VJ8BePzN5/fgVlgDuxTUhFzSm3XXp8bAssIgEFaqGJU9B+u
        Wa9zxgEW6ZJRRkgPPsbY4+IORX1+
X-Google-Smtp-Source: APXvYqxq5XivXy1rjI7OaJJ+olOKx4Pgt9tO+9ND8MTyENMvSQ3szmCgKQXFPKTU/w3I7VW7kOqisA==
X-Received: by 2002:a5d:4651:: with SMTP id j17mr26245596wrs.237.1579010403794;
        Tue, 14 Jan 2020 06:00:03 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.06.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 06:00:03 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 09/10] crypto: engine: permit to batch requests
Date:   Tue, 14 Jan 2020 14:59:35 +0100
Message-Id: <20200114135936.32422-10-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now everything is ready, this patch permits to choose the number of
request to batch.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 32 +++++++++++++++++++++++++++-----
 include/crypto/engine.h |  2 ++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index e23a398ba330..e9cd9ec9a732 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -114,6 +114,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	}
 
 	engine->ct = 0;
+retry:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
@@ -151,7 +152,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		}
 		engine->cur_reqs[engine->ct].prepared = true;
 	}
-	engine->ct++;
+	if (++engine->ct < engine->rmax && engine->queue.qlen > 0) {
+		spin_lock_irqsave(&engine->queue_lock, flags);
+		goto retry;
+	}
 	if (!enginectx->op.do_one_request) {
 		dev_err(engine->dev, "failed to do request\n");
 		ret = -EINVAL;
@@ -393,15 +397,18 @@ int crypto_engine_stop(struct crypto_engine *engine)
 EXPORT_SYMBOL_GPL(crypto_engine_stop);
 
 /**
- * crypto_engine_alloc_init - allocate crypto hardware engine structure and
+ * crypto_engine_alloc_init2 - allocate crypto hardware engine structure and
  * initialize it.
  * @dev: the device attached with one hardware engine
  * @rt: whether this queue is set to run as a realtime task
+ * @rmax: The number of request that the engine can batch in one
+ * @qlen: The size of the crypto queue
  *
  * This must be called from context that can sleep.
  * Return: the crypto engine structure on success, else NULL.
  */
-struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
+struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool rt,
+						int rmax, int qlen)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
@@ -421,12 +428,12 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
-	engine->rmax = 1;
+	engine->rmax = rmax;
 	engine->cur_reqs = devm_kzalloc(dev, sizeof(struct cur_req) * engine->rmax, GFP_KERNEL);
 	if (!engine->cur_reqs)
 		return NULL;
 
-	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
+	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
 
 	engine->kworker = kthread_create_worker(0, "%s", engine->name);
@@ -443,6 +450,21 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 
 	return engine;
 }
+EXPORT_SYMBOL_GPL(crypto_engine_alloc_init2);
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
+	return crypto_engine_alloc_init2(dev, rt, 1, CRYPTO_ENGINE_MAX_QLEN);
+}
 EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
 
 /**
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 55d3dbc2498c..fe0dfea8bf07 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -115,6 +115,8 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
 int crypto_engine_start(struct crypto_engine *engine);
 int crypto_engine_stop(struct crypto_engine *engine);
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
+struct crypto_engine *crypto_engine_alloc_init2(struct device *dev, bool rt,
+						int rmax, int qlen);
 int crypto_engine_exit(struct crypto_engine *engine);
 
 #endif /* _CRYPTO_ENGINE_H */
-- 
2.24.1

