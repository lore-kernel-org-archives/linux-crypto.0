Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEB5C001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbjHKJa0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbjHKJaK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:10 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08A030C0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:09 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOT7-0020cX-3n; Fri, 11 Aug 2023 17:30:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:05 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:05 +0800
Subject: [PATCH 13/36] crypto: engine - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOT7-0020cX-3n@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_engine.c  |   42 +-----------------------------------------
 include/crypto/engine.h |    6 ------
 2 files changed, 1 insertion(+), 47 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 74fcc0897041..17f7955500a0 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -26,9 +26,6 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 				    struct crypto_async_request *req, int err)
 {
 	unsigned long flags;
-	bool finalize_req = false;
-	int ret;
-	struct crypto_engine_ctx *enginectx;
 
 	/*
 	 * If hardware cannot enqueue more requests
@@ -38,21 +35,11 @@ static void crypto_finalize_request(struct crypto_engine *engine,
 	if (!engine->retry_support) {
 		spin_lock_irqsave(&engine->queue_lock, flags);
 		if (engine->cur_req == req) {
-			finalize_req = true;
 			engine->cur_req = NULL;
 		}
 		spin_unlock_irqrestore(&engine->queue_lock, flags);
 	}
 
-	if (finalize_req || engine->retry_support) {
-		enginectx = crypto_tfm_ctx(req->tfm);
-		if (enginectx->op.prepare_request &&
-		    enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine, req);
-			if (ret)
-				dev_err(engine->dev, "failed to unprepare request\n");
-		}
-	}
 	lockdep_assert_in_softirq();
 	crypto_request_complete(req, err);
 
@@ -141,20 +128,12 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		ret = engine->prepare_crypt_hardware(engine);
 		if (ret) {
 			dev_err(engine->dev, "failed to prepare crypt hardware\n");
-			goto req_err_2;
+			goto req_err_1;
 		}
 	}
 
 	enginectx = crypto_tfm_ctx(async_req->tfm);
 
-	if (enginectx->op.prepare_request) {
-		ret = enginectx->op.prepare_request(engine, async_req);
-		if (ret) {
-			dev_err(engine->dev, "failed to prepare request: %d\n",
-				ret);
-			goto req_err_2;
-		}
-	}
 	if (!enginectx->op.do_one_request) {
 		dev_err(engine->dev, "failed to do request\n");
 		ret = -EINVAL;
@@ -177,18 +156,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				ret);
 			goto req_err_1;
 		}
-		/*
-		 * If retry mechanism is supported,
-		 * unprepare current request and
-		 * enqueue it back into crypto-engine queue.
-		 */
-		if (enginectx->op.unprepare_request) {
-			ret = enginectx->op.unprepare_request(engine,
-							      async_req);
-			if (ret)
-				dev_err(engine->dev,
-					"failed to unprepare request\n");
-		}
 		spin_lock_irqsave(&engine->queue_lock, flags);
 		/*
 		 * If hardware was unable to execute request, enqueue it
@@ -204,13 +171,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	goto retry;
 
 req_err_1:
-	if (enginectx->op.unprepare_request) {
-		ret = enginectx->op.unprepare_request(engine, async_req);
-		if (ret)
-			dev_err(engine->dev, "failed to unprepare request\n");
-	}
-
-req_err_2:
 	crypto_request_complete(async_req, ret);
 
 retry:
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index 2038764b30c2..1b02f69e0a79 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -78,15 +78,9 @@ struct crypto_engine {
 
 /*
  * struct crypto_engine_op - crypto hardware engine operations
- * @prepare_request: do some preparation if needed before handling the current request
- * @unprepare_request: undo any work done by prepare_request()
  * @do_one_request: do encryption for current request
  */
 struct crypto_engine_op {
-	int (*prepare_request)(struct crypto_engine *engine,
-			       void *areq);
-	int (*unprepare_request)(struct crypto_engine *engine,
-				 void *areq);
 	int (*do_one_request)(struct crypto_engine *engine,
 			      void *areq);
 };
