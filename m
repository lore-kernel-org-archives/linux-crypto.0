Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBEAC433E5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CC7207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgG1HSt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54750 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgG1HSt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:49 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jss-0006IS-GM; Tue, 28 Jul 2020 17:18:47 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:46 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:46 +1000
Subject: [v3 PATCH 4/31] crypto: arm64/aes-glue - Add support for chaining CTS
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jss-0006IS-GM@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands cts cannot do chaining.  That is, it always performs
the cipher-text stealing at the end of a request.  This patch adds
support for chaining when the CRYPTO_TM_REQ_MORE flag is set.

It also sets the final_chunksize so that data can be withheld by
the caller to enable correct processing at the true end of a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/arm64/crypto/aes-glue.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 395bbf64b2abb..f63feb00e354d 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -283,11 +283,15 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
 				      NULL, NULL);
 
-	if (req->cryptlen <= AES_BLOCK_SIZE) {
-		if (req->cryptlen < AES_BLOCK_SIZE)
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MORE) {
+		if (req->cryptlen & (AES_BLOCK_SIZE - 1))
 			return -EINVAL;
+		cbc_blocks += 2;
+	} else if (req->cryptlen == AES_BLOCK_SIZE)
 		cbc_blocks = 1;
-	}
 
 	if (cbc_blocks > 0) {
 		skcipher_request_set_crypt(&subreq, req->src, req->dst,
@@ -299,7 +303,8 @@ static int cts_cbc_encrypt(struct skcipher_request *req)
 		if (err)
 			return err;
 
-		if (req->cryptlen == AES_BLOCK_SIZE)
+		if (req->cryptlen == AES_BLOCK_SIZE ||
+		    req->base.flags & CRYPTO_TFM_REQ_MORE)
 			return 0;
 
 		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
@@ -738,13 +743,15 @@ static struct skcipher_alg aes_algs[] = { {
 		.cra_driver_name	= "__cts-cbc-aes-" MODE,
 		.cra_priority		= PRIO,
 		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 	.min_keysize	= AES_MIN_KEY_SIZE,
 	.max_keysize	= AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.final_chunksize	= 2 * AES_BLOCK_SIZE,
 	.walksize	= 2 * AES_BLOCK_SIZE,
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= cts_cbc_encrypt,
