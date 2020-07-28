Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A1DC433E4
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E15207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgG1HSo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:44 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54730 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgG1HSo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsn-0006Hw-QM; Tue, 28 Jul 2020 17:18:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:41 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:41 +1000
Subject: [v3 PATCH 2/31] crypto: algif_skcipher - Add support for final_chunksize
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsn-0006Hw-QM@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands algif_skcipher assumes all algorithms support chaining.
This patch teaches it about the new final_chunksize attribute which
can be used to disable chaining on a given algorithm.  It can also
be used to support chaining on algorithms such as cts that cannot
otherwise do chaining.  For that case algif_skcipher will also now
set the request flag CRYPTO_TFM_REQ_MORE when needed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_skcipher.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a51ba22fef58f..1d50f042dd319 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -57,12 +57,15 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
+	unsigned int rflags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	int fc = crypto_skcipher_final_chunksize(tfm);
+	unsigned int min = bs + (fc > 0 ? fc : 0);
 	struct af_alg_async_req *areq;
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->init || (ctx->more && ctx->used < bs)) {
-		err = af_alg_wait_for_data(sk, flags, bs);
+	if (!ctx->init || (ctx->more && ctx->used < min)) {
+		err = af_alg_wait_for_data(sk, flags, min);
 		if (err)
 			return err;
 	}
@@ -78,13 +81,23 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		goto free;
 
+	err = -EINVAL;
+
 	/*
 	 * If more buffers are to be expected to be processed, process only
-	 * full block size buffers.
+	 * full block size buffers and withhold data according to the final
+	 * chunk size.
 	 */
-	if (ctx->more || len < ctx->used)
+	if (ctx->more || len < ctx->used) {
+		if (fc < 0)
+			goto free;
+
+		len -= fc;
 		len -= len % bs;
 
+		rflags |= CRYPTO_TFM_REQ_MORE;
+	}
+
 	/*
 	 * Create a per request TX SGL for this request which tracks the
 	 * SG entries from the global TX SGL.
@@ -116,8 +129,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		areq->outlen = len;
 
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      af_alg_async_cb, areq);
+					      rflags, af_alg_async_cb, areq);
 		err = ctx->enc ?
 			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
@@ -129,9 +141,9 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		sock_put(sk);
 	} else {
 		/* Synchronous operation */
+		rflags |= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP |
-					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+					      rflags,
 					      crypto_req_done, &ctx->wait);
 		err = crypto_wait_req(ctx->enc ?
 			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
