Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9EDC433F4
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8709B21744
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgG1HTD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:03 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54798 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgG1HTD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jt6-0006MN-FB; Tue, 28 Jul 2020 17:19:01 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:00 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:00 +1000
Subject: [v3 PATCH 10/31] crypto: chacha-generic - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jt6-0006MN-FB@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands chacha cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/chacha_generic.c          |   43 +++++++++++++++++++++++++--------------
 include/crypto/internal/chacha.h |    8 ++++++-
 2 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
index 8beea79ab1178..f74ac54d7aa5b 100644
--- a/crypto/chacha_generic.c
+++ b/crypto/chacha_generic.c
@@ -6,22 +6,21 @@
  * Copyright (C) 2018 Google LLC
  */
 
-#include <asm/unaligned.h>
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
-#include <crypto/internal/skcipher.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
-static int chacha_stream_xor(struct skcipher_request *req,
-			     const struct chacha_ctx *ctx, const u8 *iv)
+static int chacha_stream_xor(struct skcipher_request *req, int nrounds)
 {
+	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_walk walk;
-	u32 state[16];
+	u32 *state = rctx->state;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	rctx->init = req->base.flags & CRYPTO_TFM_REQ_MORE;
 
-	chacha_init_generic(state, ctx->key, iv);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -30,7 +29,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
 			nbytes = round_down(nbytes, CHACHA_BLOCK_SIZE);
 
 		chacha_crypt_generic(state, walk.dst.virt.addr,
-				     walk.src.virt.addr, nbytes, ctx->nrounds);
+				     walk.src.virt.addr, nbytes, nrounds);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -40,30 +39,41 @@ static int chacha_stream_xor(struct skcipher_request *req,
 static int crypto_chacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_stream_xor(req, ctx, req->iv);
+	if (!rctx->init)
+		chacha_init_generic(rctx->state, ctx->key, req->iv);
+
+	return chacha_stream_xor(req, ctx->nrounds);
 }
 
 static int crypto_xchacha_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct chacha_ctx subctx;
-	u32 state[16];
+	int nrounds = ctx->nrounds;
+	u32 *state = rctx->state;
 	u8 real_iv[16];
+	u32 key[8];
+
+	if (rctx->init)
+		goto skip_init;
 
 	/* Compute the subkey given the original key and first 128 nonce bits */
 	chacha_init_generic(state, ctx->key, req->iv);
-	hchacha_block_generic(state, subctx.key, ctx->nrounds);
-	subctx.nrounds = ctx->nrounds;
+	hchacha_block_generic(state, key, nrounds);
 
 	/* Build the real IV */
 	memcpy(&real_iv[0], req->iv + 24, 8); /* stream position */
 	memcpy(&real_iv[8], req->iv + 16, 8); /* remaining 64 nonce bits */
 
+	chacha_init_generic(state, key, real_iv);
+
+skip_init:
 	/* Generate the stream and XOR it with the data */
-	return chacha_stream_xor(req, &subctx, real_iv);
+	return chacha_stream_xor(req, nrounds);
 }
 
 static struct skcipher_alg algs[] = {
@@ -79,6 +89,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= crypto_chacha_crypt,
 		.decrypt		= crypto_chacha_crypt,
@@ -94,6 +105,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= crypto_xchacha_crypt,
 		.decrypt		= crypto_xchacha_crypt,
@@ -109,6 +121,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha12_setkey,
 		.encrypt		= crypto_xchacha_crypt,
 		.decrypt		= crypto_xchacha_crypt,
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index b085dc1ac1516..149ff90fa4afd 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -3,15 +3,21 @@
 #ifndef _CRYPTO_INTERNAL_CHACHA_H
 #define _CRYPTO_INTERNAL_CHACHA_H
 
+#include <asm/unaligned.h>
 #include <crypto/chacha.h>
 #include <crypto/internal/skcipher.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 
 struct chacha_ctx {
 	u32 key[8];
 	int nrounds;
 };
 
+struct chacha_reqctx {
+	u32 state[16];
+	bool init;
+};
+
 static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				unsigned int keysize, int nrounds)
 {
