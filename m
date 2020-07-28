Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36B1C433F7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7028207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgG1HTG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54804 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:05 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jt8-0006Mx-Tq; Tue, 28 Jul 2020 17:19:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:02 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:02 +1000
Subject: [v3 PATCH 11/31] crypto: arm/chacha - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jt8-0006Mx-Tq@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands chacha cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/arm/crypto/chacha-glue.c |   48 ++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 59da6c0b63b62..7f753fc54137a 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -7,10 +7,8 @@
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -106,16 +104,16 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 EXPORT_SYMBOL(chacha_crypt_arch);
 
 static int chacha_stream_xor(struct skcipher_request *req,
-			     const struct chacha_ctx *ctx, const u8 *iv,
-			     bool neon)
+			     int nrounds, bool neon)
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
@@ -125,12 +123,12 @@ static int chacha_stream_xor(struct skcipher_request *req,
 
 		if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
 			chacha_doarm(walk.dst.virt.addr, walk.src.virt.addr,
-				     nbytes, state, ctx->nrounds);
+				     nbytes, state, nrounds);
 			state[12] += DIV_ROUND_UP(nbytes, CHACHA_BLOCK_SIZE);
 		} else {
 			kernel_neon_begin();
 			chacha_doneon(state, walk.dst.virt.addr,
-				      walk.src.virt.addr, nbytes, ctx->nrounds);
+				      walk.src.virt.addr, nbytes, nrounds);
 			kernel_neon_end();
 		}
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
@@ -142,9 +140,13 @@ static int chacha_stream_xor(struct skcipher_request *req,
 static int do_chacha(struct skcipher_request *req, bool neon)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_stream_xor(req, ctx, req->iv, neon);
+	if (!rctx->init)
+		chacha_init_generic(rctx->state, ctx->key, req->iv);
+
+	return chacha_stream_xor(req, ctx->nrounds, neon);
 }
 
 static int chacha_arm(struct skcipher_request *req)
@@ -160,25 +162,33 @@ static int chacha_neon(struct skcipher_request *req)
 static int do_xchacha(struct skcipher_request *req, bool neon)
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
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
 	if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
-		hchacha_block_arm(state, subctx.key, ctx->nrounds);
+		hchacha_block_arm(state, key, nrounds);
 	} else {
 		kernel_neon_begin();
-		hchacha_block_neon(state, subctx.key, ctx->nrounds);
+		hchacha_block_neon(state, key, nrounds);
 		kernel_neon_end();
 	}
-	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_stream_xor(req, &subctx, real_iv, neon);
+
+	chacha_init_generic(state, key, real_iv);
+
+skip_init:
+	return chacha_stream_xor(req, nrounds, neon);
 }
 
 static int xchacha_arm(struct skcipher_request *req)
@@ -204,6 +214,7 @@ static struct skcipher_alg arm_algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_arm,
 		.decrypt		= chacha_arm,
@@ -219,6 +230,7 @@ static struct skcipher_alg arm_algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_arm,
 		.decrypt		= xchacha_arm,
@@ -234,6 +246,7 @@ static struct skcipher_alg arm_algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_arm,
 		.decrypt		= xchacha_arm,
@@ -254,6 +267,7 @@ static struct skcipher_alg neon_algs[] = {
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_neon,
 		.decrypt		= chacha_neon,
@@ -270,6 +284,7 @@ static struct skcipher_alg neon_algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
@@ -286,6 +301,7 @@ static struct skcipher_alg neon_algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.walksize		= 4 * CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_neon,
 		.decrypt		= xchacha_neon,
