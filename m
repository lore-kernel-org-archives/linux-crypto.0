Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87D0C4345A
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B191520792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgG1HTU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:20 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54852 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtN-0006Qt-8G; Tue, 28 Jul 2020 17:19:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:17 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:17 +1000
Subject: [v3 PATCH 17/31] crypto: ctr - Allow rfc3686 to be chained
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtN-0006Qt-8G@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands rfc3686 cannot do chaining.  That is, it has to handle
each request as a whole.  This patch adds support for chaining when
the CRYPTO_TFM_REQ_MORE flag is set.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ctr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index c39fcffba27f5..eccfab07f2fbb 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -5,7 +5,6 @@
  * (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
-#include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
@@ -21,7 +20,8 @@ struct crypto_rfc3686_ctx {
 
 struct crypto_rfc3686_req_ctx {
 	u8 iv[CTR_RFC3686_BLOCK_SIZE];
-	struct skcipher_request subreq CRYPTO_MINALIGN_ATTR;
+	bool init;
+	struct skcipher_request subreq;
 };
 
 static void crypto_ctr_crypt_final(struct skcipher_walk *walk,
@@ -197,6 +197,9 @@ static int crypto_rfc3686_crypt(struct skcipher_request *req)
 	struct skcipher_request *subreq = &rctx->subreq;
 	u8 *iv = rctx->iv;
 
+	if (rctx->init)
+		goto skip_init;
+
 	/* set up counter block */
 	memcpy(iv, ctx->nonce, CTR_RFC3686_NONCE_SIZE);
 	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
@@ -205,6 +208,9 @@ static int crypto_rfc3686_crypt(struct skcipher_request *req)
 	*(__be32 *)(iv + CTR_RFC3686_NONCE_SIZE + CTR_RFC3686_IV_SIZE) =
 		cpu_to_be32(1);
 
+skip_init:
+	rctx->init = req->base.flags & CRYPTO_TFM_REQ_MORE;
+
 	skcipher_request_set_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, req->base.flags,
 				      req->base.complete, req->base.data);
