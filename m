Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264C3C43445
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08ECC207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgG1HTN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54828 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtG-0006Ot-1C; Tue, 28 Jul 2020 17:19:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:10 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:10 +1000
Subject: [v3 PATCH 14/31] crypto: x86/chacha - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtG-0006Ot-1C@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands chacha cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/chacha_glue.c |   55 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index e67a59130025e..96cbdcbfe4f8f 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -6,14 +6,16 @@
  * Copyright (C) 2015 Martin Willi
  */
 
-#include <crypto/algapi.h>
 #include <crypto/internal/chacha.h>
 #include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/simd.h>
 
+#define CHACHA_STATE_ALIGN 16
+#define CHACHA_REQSIZE sizeof(struct chacha_reqctx) + \
+		       ((CHACHA_STATE_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+
 asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
 				       unsigned int len, int nrounds);
 asmlinkage void chacha_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
@@ -38,6 +40,12 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_simd);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 
+static inline struct chacha_reqctx *chacha_request_ctx(
+	struct skcipher_request *req)
+{
+	return PTR_ALIGN(skcipher_request_ctx(req), CHACHA_STATE_ALIGN);
+}
+
 static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 {
 	len = min(len, maxblocks * CHACHA_BLOCK_SIZE);
@@ -159,16 +167,16 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
 }
 EXPORT_SYMBOL(chacha_crypt_arch);
 
-static int chacha_simd_stream_xor(struct skcipher_request *req,
-				  const struct chacha_ctx *ctx, const u8 *iv)
+static int chacha_simd_stream_xor(struct skcipher_request *req, int nrounds)
 {
-	u32 state[CHACHA_STATE_WORDS] __aligned(8);
+	struct chacha_reqctx *rctx = chacha_request_ctx(req);
 	struct skcipher_walk walk;
+	u32 *state = rctx->state;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, false);
+	rctx->init = req->base.flags & CRYPTO_TFM_REQ_MORE;
 
-	chacha_init_generic(state, ctx->key, iv);
+	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -180,12 +188,12 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 		    !crypto_simd_usable()) {
 			chacha_crypt_generic(state, walk.dst.virt.addr,
 					     walk.src.virt.addr, nbytes,
-					     ctx->nrounds);
+					     nrounds);
 		} else {
 			kernel_fpu_begin();
 			chacha_dosimd(state, walk.dst.virt.addr,
 				      walk.src.virt.addr, nbytes,
-				      ctx->nrounds);
+				      nrounds);
 			kernel_fpu_end();
 		}
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
@@ -197,33 +205,45 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
 static int chacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = chacha_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return chacha_simd_stream_xor(req, ctx, req->iv);
+	if (!rctx->init)
+		chacha_init_generic(rctx->state, ctx->key, req->iv);
+
+	return chacha_simd_stream_xor(req, ctx->nrounds);
 }
 
 static int xchacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct chacha_reqctx *rctx = chacha_request_ctx(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 state[CHACHA_STATE_WORDS] __aligned(8);
-	struct chacha_ctx subctx;
+	int nrounds = ctx->nrounds;
+	u32 *state = rctx->state;
 	u8 real_iv[16];
+	u32 key[8];
+
+	if (rctx->init)
+		goto skip_init;
 
 	chacha_init_generic(state, ctx->key, req->iv);
 
 	if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
 		kernel_fpu_begin();
-		hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
+		hchacha_block_ssse3(state, key, nrounds);
 		kernel_fpu_end();
 	} else {
-		hchacha_block_generic(state, subctx.key, ctx->nrounds);
+		hchacha_block_generic(state, key, nrounds);
 	}
-	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	return chacha_simd_stream_xor(req, &subctx, real_iv);
+
+	chacha_init_generic(state, key, real_iv);
+
+skip_init:
+	return chacha_simd_stream_xor(req, nrounds);
 }
 
 static struct skcipher_alg algs[] = {
@@ -239,6 +259,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= CHACHA_REQSIZE,
 		.setkey			= chacha20_setkey,
 		.encrypt		= chacha_simd,
 		.decrypt		= chacha_simd,
@@ -254,6 +275,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= CHACHA_REQSIZE,
 		.setkey			= chacha20_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
@@ -269,6 +291,7 @@ static struct skcipher_alg algs[] = {
 		.max_keysize		= CHACHA_KEY_SIZE,
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
+		.reqsize		= CHACHA_REQSIZE,
 		.setkey			= chacha12_setkey,
 		.encrypt		= xchacha_simd,
 		.decrypt		= xchacha_simd,
