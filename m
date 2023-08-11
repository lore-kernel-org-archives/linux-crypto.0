Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C09DC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjHKJ3q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjHKJ3p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:29:45 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C6A26B2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:29:44 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOSh-0020X9-Qr; Fri, 11 Aug 2023 17:29:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:29:40 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:29:40 +0800
Subject: [PATCH 1/36] crypto: sun8i-ce - Remove prepare/unprepare request
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOSh-0020X9-Qr@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c |   20 ++++++++++++++------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   |    2 --
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index c13550090785..573a08fa7afa 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -294,7 +294,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	return err;
 }
 
-static int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
+static void sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(breq);
@@ -308,10 +308,10 @@ static int sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, breq, err);
 	local_bh_enable();
-	return 0;
 }
 
-static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_req)
+static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
+				      void *async_req)
 {
 	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -353,7 +353,17 @@ static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_r
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
+}
+
+static int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
+{
+	int err = sun8i_ce_cipher_prepare(engine, areq);
+
+	if (err)
+		return err;
 
+	sun8i_ce_cipher_run(engine, areq);
+	sun8i_ce_cipher_unprepare(engine, areq);
 	return 0;
 }
 
@@ -423,9 +433,7 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
 	       CRYPTO_MAX_ALG_NAME);
 
-	op->enginectx.op.do_one_request = sun8i_ce_cipher_run;
-	op->enginectx.op.prepare_request = sun8i_ce_cipher_prepare;
-	op->enginectx.op.unprepare_request = sun8i_ce_cipher_unprepare;
+	op->enginectx.op.do_one_request = sun8i_ce_cipher_do_one;
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 930ad157004c..04d7d890de58 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -32,8 +32,6 @@ int sun8i_ce_hash_crainit(struct crypto_tfm *tfm)
 	op->ce = algt->ce;
 
 	op->enginectx.op.do_one_request = sun8i_ce_hash_run;
-	op->enginectx.op.prepare_request = NULL;
-	op->enginectx.op.unprepare_request = NULL;
 
 	/* FALLBACK */
 	op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
