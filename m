Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2A1C43446
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83AB207F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgG1HTL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54822 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtD-0006OE-Pm; Tue, 28 Jul 2020 17:19:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:07 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:07 +1000
Subject: [v3 PATCH 13/31] crypto: mips/chacha - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtD-0006OE-Pm@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands chacha cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/mips/crypto/chacha-glue.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
index d1fd23e6ef844..658412bfdea29 100644
--- a/arch/mips/crypto/chacha-glue.c
+++ b/arch/mips/crypto/chacha-glue.c
@@ -7,9 +7,7 @@
  */
 
 #include <asm/byteorder.h>
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
-#include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -26,16 +24,16 @@ void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
 }
 EXPORT_SYMBOL(chacha_init_arch);
 
-static int chacha_mips_stream_xor(struct skcipher_request *req,
-				  const struct chacha_ctx *ctx, const u8 *iv)
+static int chacha_mips_stream_xor(struct skcipher_request *req, int nrounds)
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
@@ -44,7 +42,7 @@ static int chacha_mips_stream_xor(struct skcipher_request *req,
 			nbytes = round_down(nbytes, walk.stride);
 
 		chacha_crypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-			     nbytes, ctx->nrounds);
+			     nbytes, nrounds);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -54,27 +52,39 @@ static int chacha_mips_stream_xor(struct skcipher_request *req,
 static int chacha_mips(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = skcipher_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_mips_stream_xor(req, ctx, req->iv);
+	if (!rctx->init)
+		chacha_init_generic(rctx->state, ctx->key, req->iv);
+
+	return chacha_mips_stream_xor(req, ctx->nrounds);
 }
 
 static int xchacha_mips(struct skcipher_request *req)
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
 
-	hchacha_block(state, subctx.key, ctx->nrounds);
-	subctx.nrounds = ctx->nrounds;
+	hchacha_block(state, key, nrounds);
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_mips_stream_xor(req, &subctx, real_iv);
+
+	chacha_init_generic(rctx->state, key, real_iv);
+
+skip_init:
+	return chacha_mips_stream_xor(req, nrounds);
 }
 
 static struct skcipher_alg algs[] = {
@@ -90,6 +100,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_mips,
 		.decrypt		= chacha_mips,
@@ -105,6 +116,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_mips,
 		.decrypt		= xchacha_mips,
@@ -120,6 +132,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= sizeof(struct chacha_reqctx),
 		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_mips,
 		.decrypt		= xchacha_mips,
