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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F100C33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD1BB2468D
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efXBmH3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgANOAB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37866 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgANOAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so13858985wmf.2;
        Tue, 14 Jan 2020 05:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QK7uW2JyHvV/1Sv2A8qlxlva+nc6onlWMSezJazY5hk=;
        b=efXBmH3q24U2Ufo+ifFyvvi/Yqw1RTmkeHkZXJeT9nLqdmsYllLF/q2N9FAhZlqGqu
         RBRE6imvHtTjPuAT6uSI0u8gEa/aPiV6fx5u9Qii+wAEjQj3bN75LYbj3UReGbmzuu/S
         +EzcxW3bE2JtTlpJKXIIUfixjAHAB/MQ0QBD0T6YKviQ0xcdASq9RQWCkCEqLyk9Yur1
         wclEEH0H2U8Vb3gbbzVV57N6NPZcXUO0AMROkDiuduyRPXBEl4w51A/OdtHtlcbeBr/v
         80KsdAyRRVrqwaBL/Cr8miC6ZA8T/MZhNVmkKio/bN9Ns/IdyFqzfoBa/JNmlZzDl1fz
         RpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QK7uW2JyHvV/1Sv2A8qlxlva+nc6onlWMSezJazY5hk=;
        b=UGzfRfT/MDVcHYwmJhFL06OMwiCi25XBroy00lFDlp35UxG2Lv44DfR2b1mVJwlQf3
         pihc29BBGDeRhfZBwfFnv8T9RG6X/mwNO5b0eiPNFokWYV/4ss7oeaOb28rzTjeUNaID
         gouza+QP97Pprjyeu+JFhLcpBJc7O7fAqlQBCjcACWZjStIiqscwKnb9yBhQ4KRNLUdG
         vMIyiPMlrM/ijFsnI98osskOyLNPq7RJbJhyk0E4/2Mt4MNMkCF4CheN5pnp6vSqGmgR
         MzknDtLVXrfD1ETc6qbjOaQZyZZMOvc3RVozveWsoWO8a0Bq2Mf3inOVmeFcVWrop5TN
         m/mg==
X-Gm-Message-State: APjAAAXonO638IBONKh0oRhaZhF7Og4cB0SmV8cL8cN3r0y3j+MuOkkh
        si2ST3vgp6czMKIRkHo3fm8=
X-Google-Smtp-Source: APXvYqwah42w9ldVBz5YQTGbbxH1zgfKmZAqapYTzwVE0gSRGQr7ndjMeZOzQrZT2x49dlCWNGYM4g==
X-Received: by 2002:a1c:1d16:: with SMTP id d22mr27986303wmd.158.1579010397577;
        Tue, 14 Jan 2020 05:59:57 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:57 -0800 (PST)
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
Subject: [PATCH RFC 05/10] crypto: engine: transform cur_req in an array
Date:   Tue, 14 Jan 2020 14:59:31 +0100
Message-Id: <20200114135936.32422-6-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

For having the ability of doing a batch of request in one do_one_request(), we
should be able to store them in an array. (for unpreparing them later).
This patch converts cur_req in an array of request, but for the moment
hardcode the maximum to 1.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 32 ++++++++++++++++++--------------
 include/crypto/engine.h | 19 +++++++++++++++----
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index eb029ff1e05a..b72873550587 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -30,26 +30,27 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 	struct crypto_engine_ctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
-	if (engine->cur_req == req)
+	if (engine->cur_reqs[0].req == req)
 		finalize_cur_req = true;
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
 	if (finalize_cur_req) {
-		enginectx = crypto_tfm_ctx(req->tfm);
-		if (engine->cur_req_prepared &&
+		enginectx = crypto_tfm_ctx(engine->cur_reqs[0].req->tfm);
+		if (engine->cur_reqs[0].prepared &&
 		    enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine, req);
+			ret = enginectx->op.unprepare_request(engine, engine->cur_reqs[0].req);
 			if (ret)
 				dev_err(engine->dev, "failed to unprepare request\n");
 		}
+		engine->cur_reqs[0].req->complete(engine->cur_reqs[0].req, err);
 		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_req = NULL;
-		engine->cur_req_prepared = false;
+		engine->cur_reqs[0].prepared = false;
+		engine->cur_reqs[0].req = NULL;
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
+	} else {
+		req->complete(req, err);
 	}
 
-	req->complete(req, err);
-
 	kthread_queue_work(engine->kworker, &engine->pump_requests);
 }
 
@@ -74,7 +75,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
 	/* Make sure we are not already running a request */
-	if (engine->cur_req)
+	if (engine->cur_reqs[0].req)
 		goto out;
 
 	/* If another context is idling then defer */
@@ -114,7 +115,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!async_req)
 		goto out;
 
-	engine->cur_req = async_req;
+	engine->cur_reqs[0].req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -143,14 +144,14 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				ret);
 			goto req_err;
 		}
-		engine->cur_req_prepared = true;
+		engine->cur_reqs[0].prepared = true;
 	}
 	if (!enginectx->op.do_one_request) {
 		dev_err(engine->dev, "failed to do request\n");
 		ret = -EINVAL;
 		goto req_err;
 	}
-	ret = enginectx->op.do_one_request(engine, async_req);
+	ret = enginectx->op.do_one_request(engine, engine->cur_reqs[0].req);
 	if (ret) {
 		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
 		goto req_err;
@@ -158,7 +159,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	return;
 
 req_err:
-	crypto_finalize_request(engine, async_req, ret);
+	crypto_finalize_request(engine, engine->cur_reqs[0].req, ret);
 	return;
 
 out:
@@ -411,10 +412,13 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 	engine->running = false;
 	engine->busy = false;
 	engine->idling = false;
-	engine->cur_req_prepared = false;
 	engine->priv_data = dev;
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
+	engine->rmax = 1;
+	engine->cur_reqs = devm_kzalloc(dev, sizeof(struct cur_req) * engine->rmax, GFP_KERNEL);
+	if (!engine->cur_reqs)
+		return NULL;
 
 	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
 	spin_lock_init(&engine->queue_lock);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index e29cd67f93c7..362134e226f4 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -18,13 +18,23 @@
 #include <crypto/skcipher.h>
 
 #define ENGINE_NAME_LEN	30
+
+/*
+ * struct cur_req - Represent a request to be processed
+ * @prepared:	Does the request was prepared
+ * @req:	The request to be processed
+ */
+struct cur_req {
+	bool				prepared;
+	struct crypto_async_request	*req;
+};
+
 /*
  * struct crypto_engine - crypto hardware engine
  * @name: the engine name
  * @idling: the engine is entering idle state
  * @busy: request pump is busy
  * @running: the engine is on working
- * @cur_req_prepared: current request is prepared
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to syncronise access to request queue
  * @queue: the crypto queue of the engine
@@ -38,14 +48,14 @@
  * @kworker: kthread worker struct for request pump
  * @pump_requests: work struct for scheduling work to the request pump
  * @priv_data: the engine private data
- * @cur_req: the current request which is on processing
+ * @rmax:	The number of request which can be processed in one batch
+ * @cur_reqs: 	A list for requests to be processed
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
 	bool			idling;
 	bool			busy;
 	bool			running;
-	bool			cur_req_prepared;
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
@@ -61,7 +71,8 @@ struct crypto_engine {
 	struct kthread_work             pump_requests;
 
 	void				*priv_data;
-	struct crypto_async_request	*cur_req;
+	int 				rmax;
+	struct cur_req 			*cur_reqs;
 };
 
 /*
-- 
2.24.1

