Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DDBC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658BC20792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgG1HTx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54964 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgG1HTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:53 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jtu-0006YO-7O; Tue, 28 Jul 2020 17:19:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:50 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:50 +1000
Subject: [v3 PATCH 31/31] crypto: salsa20-generic - dd support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jtu-0006YO-7O@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands salsa20 cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/salsa20_generic.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 3418869dabefd..dd4b4cc8e76b9 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -21,7 +21,10 @@
 
 #include <asm/unaligned.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 #define SALSA20_IV_SIZE        8
 #define SALSA20_MIN_KEY_SIZE  16
@@ -32,6 +35,11 @@ struct salsa20_ctx {
 	u32 initial_state[16];
 };
 
+struct salsa20_reqctx {
+	u32 state[16];
+	bool init;
+};
+
 static void salsa20_block(u32 *state, __le32 *stream)
 {
 	u32 x[16];
@@ -154,13 +162,16 @@ static int salsa20_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct salsa20_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct salsa20_reqctx *rctx = skcipher_request_ctx(req);
 	struct skcipher_walk walk;
-	u32 state[16];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	salsa20_init(state, ctx, req->iv);
+	if (!rctx->init)
+		salsa20_init(rctx->state, ctx, req->iv);
+
+	rctx->init = req->base.flags & CRYPTO_TFM_REQ_MORE;
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
@@ -168,8 +179,8 @@ static int salsa20_crypt(struct skcipher_request *req)
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		salsa20_docrypt(state, walk.dst.virt.addr, walk.src.virt.addr,
-				nbytes);
+		salsa20_docrypt(rctx->state, walk.dst.virt.addr,
+				walk.src.virt.addr, nbytes);
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
@@ -188,6 +199,7 @@ static struct skcipher_alg alg = {
 	.max_keysize		= SALSA20_MAX_KEY_SIZE,
 	.ivsize			= SALSA20_IV_SIZE,
 	.chunksize		= SALSA20_BLOCK_SIZE,
+	.reqsize		= sizeof(struct salsa20_reqctx),
 	.setkey			= salsa20_setkey,
 	.encrypt		= salsa20_crypt,
 	.decrypt		= salsa20_crypt,
