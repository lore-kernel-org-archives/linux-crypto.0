Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3CAC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjHKJ3x (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjHKJ3v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:29:51 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9422D61
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:29:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOSo-0020Xf-6d; Fri, 11 Aug 2023 17:29:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:29:46 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:29:46 +0800
Subject: [PATCH 4/36] crypto: aspeed - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOSo-0020Xf-6d@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/aspeed/aspeed-acry.c        |    2 --
 drivers/crypto/aspeed/aspeed-hace-crypto.c |    2 --
 drivers/crypto/aspeed/aspeed-hace-hash.c   |   14 ++++++++------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 470122c87fea..5ae529ce6806 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -590,8 +590,6 @@ static int aspeed_acry_rsa_init_tfm(struct crypto_akcipher *tfm)
 	}
 
 	ctx->enginectx.op.do_one_request = aspeed_acry_do_request;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index ef73b0028b4d..8d6d9ecb3a28 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -714,8 +714,6 @@ static int aspeed_crypto_cra_init(struct crypto_skcipher *tfm)
 			 crypto_skcipher_reqsize(ctx->fallback_tfm));
 
 	ctx->enginectx.op.do_one_request = aspeed_crypto_do_request;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index 935135229ebd..f8c96568142e 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -565,8 +565,8 @@ static int aspeed_ahash_do_request(struct crypto_engine *engine, void *areq)
 	return 0;
 }
 
-static int aspeed_ahash_prepare_request(struct crypto_engine *engine,
-					void *areq)
+static void aspeed_ahash_prepare_request(struct crypto_engine *engine,
+					 void *areq)
 {
 	struct ahash_request *req = ahash_request_cast(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -581,8 +581,12 @@ static int aspeed_ahash_prepare_request(struct crypto_engine *engine,
 		hash_engine->dma_prepare = aspeed_ahash_dma_prepare_sg;
 	else
 		hash_engine->dma_prepare = aspeed_ahash_dma_prepare;
+}
 
-	return 0;
+static int aspeed_ahash_do_one(struct crypto_engine *engine, void *areq)
+{
+	aspeed_ahash_prepare_request(engine, areq);
+	return aspeed_ahash_do_request(engine, areq);
 }
 
 static int aspeed_sham_update(struct ahash_request *req)
@@ -876,9 +880,7 @@ static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
 		}
 	}
 
-	tctx->enginectx.op.do_one_request = aspeed_ahash_do_request;
-	tctx->enginectx.op.prepare_request = aspeed_ahash_prepare_request;
-	tctx->enginectx.op.unprepare_request = NULL;
+	tctx->enginectx.op.do_one_request = aspeed_ahash_do_one;
 
 	return 0;
 }
