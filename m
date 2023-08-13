Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A47C001B0
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjHMGyj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjHMGy3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:54:29 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891E81736
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:54:28 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV4zX-002bkf-Ra; Sun, 13 Aug 2023 14:54:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:54:24 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:54:24 +0800
Subject: [v2 PATCH 9/36] crypto: jh1100 - Remove prepare/unprepare request
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV4zX-002bkf-Ra@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The callbacks for prepare and unprepare request in crypto_engine
is superfluous.  They can be done directly from do_one_request.

Move the code into do_one_request and remove the unused callbacks.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/starfive/jh7110-aes.c  |   54 ++++++----------------------------
 drivers/crypto/starfive/jh7110-hash.c |    7 ----
 2 files changed, 11 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 278dfa4aa743..777656cbb7ce 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -518,8 +518,13 @@ static int starfive_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	u32 block[AES_BLOCK_32];
 	u32 stat;
+	int err;
 	int i;
 
+	err = starfive_aes_prepare_req(req, NULL);
+	if (err)
+		return err;
+
 	/*
 	 * Write first plain/ciphertext block to start the module
 	 * then let irq tasklet handle the rest of the data blocks.
@@ -538,15 +543,6 @@ static int starfive_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	return 0;
 }
 
-static int starfive_aes_skcipher_prepare_req(struct crypto_engine *engine,
-					     void *areq)
-{
-	struct skcipher_request *req =
-		container_of(areq, struct skcipher_request, base);
-
-	return starfive_aes_prepare_req(req, NULL);
-}
-
 static int starfive_aes_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct starfive_cryp_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -559,21 +555,10 @@ static int starfive_aes_init_tfm(struct crypto_skcipher *tfm)
 				    sizeof(struct skcipher_request));
 
 	ctx->enginectx.op.do_one_request = starfive_aes_do_one_req;
-	ctx->enginectx.op.prepare_request = starfive_aes_skcipher_prepare_req;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
 
-static void starfive_aes_exit_tfm(struct crypto_skcipher *tfm)
-{
-	struct starfive_cryp_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->enginectx.op.do_one_request = NULL;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
-}
-
 static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req =
@@ -584,8 +569,13 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
 	u32 block[AES_BLOCK_32];
 	u32 stat;
+	int err;
 	int i;
 
+	err = starfive_aes_prepare_req(NULL, req);
+	if (err)
+		return err;
+
 	if (!cryp->assoclen)
 		goto write_text;
 
@@ -625,14 +615,6 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 	return 0;
 }
 
-static int starfive_aes_aead_prepare_req(struct crypto_engine *engine, void *areq)
-{
-	struct aead_request *req =
-		container_of(areq, struct aead_request, base);
-
-	return starfive_aes_prepare_req(NULL, req);
-}
-
 static int starfive_aes_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct starfive_cryp_ctx *ctx = crypto_aead_ctx(tfm);
@@ -657,8 +639,6 @@ static int starfive_aes_aead_init_tfm(struct crypto_aead *tfm)
 				sizeof(struct aead_request));
 
 	ctx->enginectx.op.do_one_request = starfive_aes_aead_do_one_req;
-	ctx->enginectx.op.prepare_request = starfive_aes_aead_prepare_req;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
@@ -667,14 +647,7 @@ static void starfive_aes_aead_exit_tfm(struct crypto_aead *tfm)
 {
 	struct starfive_cryp_ctx *ctx = crypto_aead_ctx(tfm);
 
-	if (ctx->aead_fbk) {
-		crypto_free_aead(ctx->aead_fbk);
-		ctx->aead_fbk = NULL;
-	}
-
-	ctx->enginectx.op.do_one_request = NULL;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
+	crypto_free_aead(ctx->aead_fbk);
 }
 
 static int starfive_aes_crypt(struct skcipher_request *req, unsigned long flags)
@@ -874,7 +847,6 @@ static int starfive_aes_ccm_decrypt(struct aead_request *req)
 static struct skcipher_alg skcipher_algs[] = {
 {
 	.init				= starfive_aes_init_tfm,
-	.exit				= starfive_aes_exit_tfm,
 	.setkey				= starfive_aes_setkey,
 	.encrypt			= starfive_aes_ecb_encrypt,
 	.decrypt			= starfive_aes_ecb_decrypt,
@@ -892,7 +864,6 @@ static struct skcipher_alg skcipher_algs[] = {
 	},
 }, {
 	.init				= starfive_aes_init_tfm,
-	.exit				= starfive_aes_exit_tfm,
 	.setkey				= starfive_aes_setkey,
 	.encrypt			= starfive_aes_cbc_encrypt,
 	.decrypt			= starfive_aes_cbc_decrypt,
@@ -911,7 +882,6 @@ static struct skcipher_alg skcipher_algs[] = {
 	},
 }, {
 	.init				= starfive_aes_init_tfm,
-	.exit				= starfive_aes_exit_tfm,
 	.setkey				= starfive_aes_setkey,
 	.encrypt			= starfive_aes_ctr_encrypt,
 	.decrypt			= starfive_aes_ctr_decrypt,
@@ -930,7 +900,6 @@ static struct skcipher_alg skcipher_algs[] = {
 	},
 }, {
 	.init				= starfive_aes_init_tfm,
-	.exit				= starfive_aes_exit_tfm,
 	.setkey				= starfive_aes_setkey,
 	.encrypt			= starfive_aes_cfb_encrypt,
 	.decrypt			= starfive_aes_cfb_decrypt,
@@ -949,7 +918,6 @@ static struct skcipher_alg skcipher_algs[] = {
 	},
 }, {
 	.init				= starfive_aes_init_tfm,
-	.exit				= starfive_aes_exit_tfm,
 	.setkey				= starfive_aes_setkey,
 	.encrypt			= starfive_aes_ofb_encrypt,
 	.decrypt			= starfive_aes_ofb_decrypt,
diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 5064150b8a1c..7fe89cd13336 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -434,8 +434,6 @@ static int starfive_hash_init_tfm(struct crypto_ahash *hash,
 	ctx->hash_mode = mode;
 
 	ctx->enginectx.op.do_one_request = starfive_hash_one_request;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 
 	return 0;
 }
@@ -445,11 +443,6 @@ static void starfive_hash_exit_tfm(struct crypto_ahash *hash)
 	struct starfive_cryp_ctx *ctx = crypto_ahash_ctx(hash);
 
 	crypto_free_ahash(ctx->ahash_fbk);
-
-	ctx->ahash_fbk = NULL;
-	ctx->enginectx.op.do_one_request = NULL;
-	ctx->enginectx.op.prepare_request = NULL;
-	ctx->enginectx.op.unprepare_request = NULL;
 }
 
 static int starfive_hash_long_setkey(struct starfive_cryp_ctx *ctx,
