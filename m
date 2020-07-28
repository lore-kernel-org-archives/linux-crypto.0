Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4A6C433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86E6207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgG1HSr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54742 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgG1HSr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:47 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsq-0006I8-1l; Tue, 28 Jul 2020 17:18:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:44 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:44 +1000
Subject: [v3 PATCH 3/31] crypto: cts - Add support for chaining
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsq-0006I8-1l@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands cts cannot do chaining.  That is, it always performs
the cipher-text stealing at the end of a request.  This patch adds
support for chaining when the CRYPTO_TM_REQ_MORE flag is set.

It also sets final_chunksize so that data can be withheld by the
caller to enable correct processing at the true end of a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cts.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 3766d47ebcc01..67990146c9b06 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -100,7 +100,7 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
+	int bsize = crypto_skcipher_chunksize(tfm);
 	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
@@ -146,7 +146,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
 	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
 	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
+	int bsize = crypto_skcipher_chunksize(tfm);
 	unsigned int nbytes = req->cryptlen;
 	unsigned int offset;
 
@@ -155,7 +155,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
 	if (nbytes < bsize)
 		return -EINVAL;
 
-	if (nbytes == bsize) {
+	if (nbytes == bsize || req->base.flags & CRYPTO_TFM_REQ_MORE) {
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      req->base.complete,
 					      req->base.data);
@@ -181,7 +181,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
+	int bsize = crypto_skcipher_chunksize(tfm);
 	u8 d[MAX_CIPHER_BLOCKSIZE * 2] __aligned(__alignof__(u32));
 	struct scatterlist *sg;
 	unsigned int offset;
@@ -240,7 +240,7 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
 	struct crypto_cts_reqctx *rctx = skcipher_request_ctx(req);
 	struct crypto_cts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_request *subreq = &rctx->subreq;
-	int bsize = crypto_skcipher_blocksize(tfm);
+	int bsize = crypto_skcipher_chunksize(tfm);
 	unsigned int nbytes = req->cryptlen;
 	unsigned int offset;
 	u8 *space;
@@ -250,7 +250,7 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
 	if (nbytes < bsize)
 		return -EINVAL;
 
-	if (nbytes == bsize) {
+	if (nbytes == bsize || req->base.flags & CRYPTO_TFM_REQ_MORE) {
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      req->base.complete,
 					      req->base.data);
@@ -297,7 +297,7 @@ static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
 	ctx->child = cipher;
 
 	align = crypto_skcipher_alignmask(tfm);
-	bsize = crypto_skcipher_blocksize(cipher);
+	bsize = crypto_skcipher_chunksize(cipher);
 	reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
 			crypto_skcipher_reqsize(cipher),
 			crypto_tfm_ctx_alignment()) +
@@ -359,11 +359,12 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->base.cra_priority;
-	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
 	inst->alg.ivsize = alg->base.cra_blocksize;
-	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.chunksize = alg->base.cra_blocksize;
+	inst->alg.final_chunksize = inst->alg.chunksize * 2;
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
 	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
 
