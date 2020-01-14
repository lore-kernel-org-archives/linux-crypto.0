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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E265C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 535162468C
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LRbl4YL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgANOAB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50650 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbgANOAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id a5so13907447wmb.0;
        Tue, 14 Jan 2020 05:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vwz74GVw3RqN4zv8KJzc6WOhikJUNutjS1yfSHb85f4=;
        b=LRbl4YL7xfmzQ1ubfonhUq+riBVo7Eyg2CecNwz5sXvOhYgCzzU5f4KizEPmiziF4m
         D5jqMuwxJGXYuIgRLNfSlIMO+OvP0h0nyl6yQNA07t23ws19poi5JoP44FXZMMfT1blT
         T3g1hisBu9zecBZnslMBQqKKbPPRXL+YE/DWuBrcGUUkV79ew8rqEstIc7XJNGwgFxr4
         3iIX6iHzJCNHtV57Fr2N1q7nvQvfgoyA65gMyrBolpyP0gZSZgu2GCp/UZhTJaZcRuV4
         BIIJ1IGwfAmSGYq+Sz31qndyOjB9icWSWIwv2nO1LrhDw0SIB1FsPcGfwJW5AK9eqv2g
         ZHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vwz74GVw3RqN4zv8KJzc6WOhikJUNutjS1yfSHb85f4=;
        b=FZmYRyq4dSOP4Pew2XLld+wIGyj8cupiT39jiPeni65BU4zB+dKOiVwbTO22ozJNoW
         X/ni2S3K2mLfD9UxqVGpnVrsNQgak3lOMbUvJ3w+XT0OY3w1Kvdqq6wyILt1dCEHbXd2
         rkELsKTJr20XDFzQclJPXeyr6NxviRjlQAALX5JHYRAcJBMg3O3Se7YAqQ99AQjS9CJl
         6NiCWueeN86MOyKomvBetadYtzPrHTl6PcrbAecevJE0FKebXi1QmLVhFhCNWaDOyf2l
         TWnRj2Qyb1sFeWtMDxCUwg04IfOY9SD5H1J54sCHcIlkJlO3uLdIfYrOFsN9bbc5z7NK
         rOtA==
X-Gm-Message-State: APjAAAWZDXusv0+DTTiJ/nQjnNRyldca6FUSbqVCQ3IEIUvUfr8dz9ml
        4gtBgk8GfOdS6v5T7RVOI24=
X-Google-Smtp-Source: APXvYqy5IpziUXqSl8mzGqH49R4MKas13Mk/3/YX/GN9HtlxDzqVTADoOUc6wXiGyyxKvj7oJv29NA==
X-Received: by 2002:a1c:9c87:: with SMTP id f129mr26421503wme.26.1579010399002;
        Tue, 14 Jan 2020 05:59:59 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:58 -0800 (PST)
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
Subject: [PATCH RFC 06/10] crypto: engine: introduce ct
Date:   Tue, 14 Jan 2020 14:59:32 +0100
Message-Id: <20200114135936.32422-7-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We will store the number of request in a batch in engine->ct.
This patch adds all loop to unprepare all requests of a batch.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 crypto/crypto_engine.c  | 30 ++++++++++++++++++------------
 include/crypto/engine.h |  2 ++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index b72873550587..591dea5ddeec 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -28,6 +28,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 	bool finalize_cur_req = false;
 	int ret;
 	struct crypto_engine_ctx *enginectx;
+	int i = 0;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 	if (engine->cur_reqs[0].req == req)
@@ -35,17 +36,20 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 
 	if (finalize_cur_req) {
-		enginectx = crypto_tfm_ctx(engine->cur_reqs[0].req->tfm);
-		if (engine->cur_reqs[0].prepared &&
-		    enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine, engine->cur_reqs[0].req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-		engine->cur_reqs[0].req->complete(engine->cur_reqs[0].req, err);
+		do {
+			enginectx = crypto_tfm_ctx(engine->cur_reqs[i].req->tfm);
+			if (engine->cur_reqs[i].prepared &&
+			    enginectx->op.unprepare_request) {
+				ret = enginectx->op.unprepare_request(engine, engine->cur_reqs[i].req);
+				if (ret)
+					dev_err(engine->dev, "failed to unprepare request\n");
+			}
+			engine->cur_reqs[i].prepared = false;
+			engine->cur_reqs[i].req->complete(engine->cur_reqs[i].req, err);
+		} while (++i < engine->ct);
 		spin_lock_irqsave(&engine->queue_lock, flags);
-		engine->cur_reqs[0].prepared = false;
-		engine->cur_reqs[0].req = NULL;
+		while (engine->ct-- > 0)
+			engine->cur_reqs[engine->ct].req = NULL;
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	} else {
 		req->complete(req, err);
@@ -109,13 +113,14 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
+	engine->ct = 0;
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
 	if (!async_req)
 		goto out;
 
-	engine->cur_reqs[0].req = async_req;
+	engine->cur_reqs[engine->ct].req = async_req;
 	if (backlog)
 		backlog->complete(backlog, -EINPROGRESS);
 
@@ -144,8 +149,9 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				ret);
 			goto req_err;
 		}
-		engine->cur_reqs[0].prepared = true;
+		engine->cur_reqs[engine->ct].prepared = true;
 	}
+	engine->ct++;
 	if (!enginectx->op.do_one_request) {
 		dev_err(engine->dev, "failed to do request\n");
 		ret = -EINVAL;
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 362134e226f4..021136a47b93 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -50,6 +50,7 @@ struct cur_req {
  * @priv_data: the engine private data
  * @rmax:	The number of request which can be processed in one batch
  * @cur_reqs: 	A list for requests to be processed
+ * @ct:		How many requests will be handled in one batch
  */
 struct crypto_engine {
 	char			name[ENGINE_NAME_LEN];
@@ -73,6 +74,7 @@ struct crypto_engine {
 	void				*priv_data;
 	int 				rmax;
 	struct cur_req 			*cur_reqs;
+	int ct;
 };
 
 /*
-- 
2.24.1

