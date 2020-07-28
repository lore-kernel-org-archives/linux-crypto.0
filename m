Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BFDC433F2
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA9120792
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgG1HS7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54782 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1HS6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jt1-0006LB-SV; Tue, 28 Jul 2020 17:18:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:55 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:55 +1000
Subject: [v3 PATCH 8/31] crypto: skcipher - Initialise requests to zero
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jt1-0006LB-SV@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch initialises skcipher requests to zero.  This allows
algorithms to distinguish between the first operation versus
subsequent ones.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/crypto/skcipher.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index c46ea1c157b29..6db5f83d6e482 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -129,13 +129,14 @@ struct skcipher_alg {
  * This performs a type-check against the "tfm" argument to make sure
  * all users have the correct skcipher tfm for doing on-stack requests.
  */
-#define SYNC_SKCIPHER_REQUEST_ON_STACK(name, tfm) \
-	char __##name##_desc[sizeof(struct skcipher_request) + \
-			     MAX_SYNC_SKCIPHER_REQSIZE + \
-			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
-				       (typeof(tfm))1))) \
-			    ] CRYPTO_MINALIGN_ATTR; \
-	struct skcipher_request *name = (void *)__##name##_desc
+#define SYNC_SKCIPHER_REQUEST_ON_STACK(name, sync) \
+	struct { \
+		struct skcipher_request req; \
+		char ext[MAX_SYNC_SKCIPHER_REQSIZE]; \
+	} __##name##_desc = { \
+		.req.base.tfm = crypto_skcipher_tfm(&sync->base), \
+	}; \
+	struct skcipher_request *name = &__##name##_desc.req
 
 /**
  * DOC: Symmetric Key Cipher API
@@ -519,8 +520,7 @@ static inline struct skcipher_request *skcipher_request_alloc(
 {
 	struct skcipher_request *req;
 
-	req = kmalloc(sizeof(struct skcipher_request) +
-		      crypto_skcipher_reqsize(tfm), gfp);
+	req = kzalloc(sizeof(*req) + crypto_skcipher_reqsize(tfm), gfp);
 
 	if (likely(req))
 		skcipher_request_set_tfm(req, tfm);
