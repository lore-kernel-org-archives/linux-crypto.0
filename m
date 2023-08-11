Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D59CC001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbjHKJbf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbjHKJa6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4A030F4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:58 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTt-0020mN-Dz; Fri, 11 Aug 2023 17:30:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:53 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:53 +0800
Subject: [PATCH 36/36] crypto: engine - Remove crypto_engine_ctx
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTt-0020mN-Dz@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the obsolete crypto_engine_ctx structure.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/crypto_engine.c  |   12 +++---------
 include/crypto/engine.h |    4 ----
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index abfb1e6bfa48..108d9d55c509 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -79,7 +79,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	unsigned long flags;
 	bool was_busy = false;
 	int ret;
-	struct crypto_engine_ctx *enginectx;
 
 	spin_lock_irqsave(&engine->queue_lock, flags);
 
@@ -154,14 +153,9 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 				   struct crypto_engine_alg, base);
 		op = &alg->op;
 	} else {
-		enginectx = crypto_tfm_ctx(async_req->tfm);
-		op = &enginectx->op;
-
-		if (!op->do_one_request) {
-			dev_err(engine->dev, "failed to do request\n");
-			ret = -EINVAL;
-			goto req_err_1;
-		}
+		dev_err(engine->dev, "failed to do request\n");
+		ret = -EINVAL;
+		goto req_err_1;
 	}
 
 	ret = op->do_one_request(engine, async_req);
diff --git a/include/crypto/engine.h b/include/crypto/engine.h
index cf57e732566b..2835069c5997 100644
--- a/include/crypto/engine.h
+++ b/include/crypto/engine.h
@@ -26,10 +26,6 @@ struct crypto_engine_op {
 			      void *areq);
 };
 
-struct crypto_engine_ctx {
-	struct crypto_engine_op op;
-};
-
 struct aead_engine_alg {
 	struct aead_alg base;
 	struct crypto_engine_op op;
