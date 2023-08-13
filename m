Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4BFC04A6A
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjHMGyk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjHMGy3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:54:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC901718
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:54:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV4zZ-002bkr-Ut; Sun, 13 Aug 2023 14:54:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:54:26 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:54:26 +0800
Subject: [v2 PATCH 10/36] crypto: stm32 - Remove prepare/unprepare request
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV4zZ-002bkr-Ut@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-cryp.c |   37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 6b8d731092a4..07e32b8dbe29 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -825,8 +825,6 @@ static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
 }
 
 static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq);
-static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
-					 void *areq);
 
 static int stm32_cryp_init_tfm(struct crypto_skcipher *tfm)
 {
@@ -835,14 +833,10 @@ static int stm32_cryp_init_tfm(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct stm32_cryp_reqctx));
 
 	ctx->enginectx.op.do_one_request = stm32_cryp_cipher_one_req;
-	ctx->enginectx.op.prepare_request = stm32_cryp_prepare_cipher_req;
-	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
 static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq);
-static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine,
-				       void *areq);
 
 static int stm32_cryp_aes_aead_init(struct crypto_aead *tfm)
 {
@@ -851,8 +845,6 @@ static int stm32_cryp_aes_aead_init(struct crypto_aead *tfm)
 	tfm->reqsize = sizeof(struct stm32_cryp_reqctx);
 
 	ctx->enginectx.op.do_one_request = stm32_cryp_aead_one_req;
-	ctx->enginectx.op.prepare_request = stm32_cryp_prepare_aead_req;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
@@ -1180,9 +1172,6 @@ static int stm32_cryp_prepare_req(struct skcipher_request *req,
 
 	cryp = ctx->cryp;
 
-	if (!cryp)
-		return -ENODEV;
-
 	rctx = req ? skcipher_request_ctx(req) : aead_request_ctx(areq);
 	rctx->mode &= FLG_MODE_MASK;
 
@@ -1248,16 +1237,6 @@ static int stm32_cryp_prepare_req(struct skcipher_request *req,
 	return ret;
 }
 
-static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
-					 void *areq)
-{
-	struct skcipher_request *req = container_of(areq,
-						      struct skcipher_request,
-						      base);
-
-	return stm32_cryp_prepare_req(req, NULL);
-}
-
 static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq,
@@ -1270,15 +1249,8 @@ static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
 	if (!cryp)
 		return -ENODEV;
 
-	return stm32_cryp_cpu_start(cryp);
-}
-
-static int stm32_cryp_prepare_aead_req(struct crypto_engine *engine, void *areq)
-{
-	struct aead_request *req = container_of(areq, struct aead_request,
-						base);
-
-	return stm32_cryp_prepare_req(NULL, req);
+	return stm32_cryp_prepare_req(req, NULL) ?:
+	       stm32_cryp_cpu_start(cryp);
 }
 
 static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq)
@@ -1287,10 +1259,15 @@ static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq)
 						base);
 	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct stm32_cryp *cryp = ctx->cryp;
+	int err;
 
 	if (!cryp)
 		return -ENODEV;
 
+	err = stm32_cryp_prepare_req(NULL, req);
+	if (err)
+		return err;
+
 	if (unlikely(!cryp->payload_in && !cryp->header_in)) {
 		/* No input data to process: get tag and finish */
 		stm32_cryp_finish_req(cryp, 0);
