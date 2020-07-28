Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD93C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC365207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgG1HTB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54790 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1HTB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:01 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jt4-0006Lq-5D; Tue, 28 Jul 2020 17:18:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:58 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:58 +1000
Subject: [v3 PATCH 9/31] crypto: cryptd - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jt4-0006Lq-5D@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch makes cryptd pass along the CRYPTO_TFM_REQ_MORE flag to
its child skcipher as well as inheriting the final chunk size from
it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index a1bea0f4baa88..510c23b320082 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -261,13 +261,16 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_sync_skcipher *child = ctx->child;
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	unsigned int flags = req->base.flags;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
+	flags &= CRYPTO_TFM_REQ_MORE;
+	flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
+
 	skcipher_request_set_sync_tfm(subreq, child);
-	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
-				      NULL, NULL);
+	skcipher_request_set_callback(subreq, flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				   req->iv);
 
@@ -289,13 +292,16 @@ static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_sync_skcipher *child = ctx->child;
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	unsigned int flags = req->base.flags;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
+	flags &= CRYPTO_TFM_REQ_MORE;
+	flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
+
 	skcipher_request_set_sync_tfm(subreq, child);
-	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
-				      NULL, NULL);
+	skcipher_request_set_callback(subreq, flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				   req->iv);
 
@@ -400,6 +406,7 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
 	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.final_chunksize = crypto_skcipher_alg_final_chunksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
 
