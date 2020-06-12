Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5EFC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 12:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25A3D2081A
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 12:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgFLMVb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 08:21:31 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:39538 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFLMVb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 08:21:31 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjiga-0005Pj-Ej; Fri, 12 Jun 2020 22:21:29 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2020 22:21:28 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 12 Jun 2020 22:21:28 +1000
Subject: [v2 PATCH 2/3] crypto: algif_skcipher - Add support for fcsize
References: <20200612122105.GA18892@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Message-Id: <E1jjiga-0005Pj-Ej@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands algif_skcipher assumes all algorithms support chaining.
This patch teaches it about the new fcsize attribute which can be
used to disable chaining on a given algorithm.  It can also be used
to support chaining on algorithms such as cts that cannot otherwise
do chaining.  For that case algif_skcipher will also now set the
request flag CRYPTO_TFM_REQ_MORE when needed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_skcipher.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f8a7fca3203eb..7fc873d28f4a7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -57,12 +57,18 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct af_alg_ctx *ctx = ask->private;
 	struct crypto_skcipher *tfm = pask->private;
 	unsigned int bs = crypto_skcipher_chunksize(tfm);
+	unsigned int rflags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	int fc = crypto_skcipher_fcsize(tfm);
 	struct af_alg_async_req *areq;
+	unsigned int min = bs;
 	int err = 0;
 	size_t len = 0;
 
-	if (!ctx->init || (ctx->more && ctx->used < bs)) {
-		err = af_alg_wait_for_data(sk, flags, bs);
+	if (fc >= 0)
+		min += fc;
+
+	if (!ctx->init || (ctx->more && ctx->used < min)) {
+		err = af_alg_wait_for_data(sk, flags, min);
 		if (err)
 			return err;
 	}
@@ -78,13 +84,22 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (err)
 		goto free;
 
+	err = -EINVAL;
+
 	/*
 	 * If more buffers are to be expected to be processed, process only
-	 * full block size buffers.
+	 * full block size buffers and withhold data according to fcsize.
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
@@ -116,8 +131,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		areq->outlen = len;
 
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
-					      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      af_alg_async_cb, areq);
+					      rflags, af_alg_async_cb, areq);
 		err = ctx->enc ?
 			crypto_skcipher_encrypt(&areq->cra_u.skcipher_req) :
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
@@ -129,9 +143,9 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
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
