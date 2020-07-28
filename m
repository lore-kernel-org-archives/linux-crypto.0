Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264B1C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0601320829
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgG1HS4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:56 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54774 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1HS4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:56 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsz-0006Ki-GN; Tue, 28 Jul 2020 17:18:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:53 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:53 +1000
Subject: [v3 PATCH 7/31] crypto: skcipher - Add alg reqsize field
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsz-0006Ki-GN@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it is the reqsize field only exists on the tfm object which means
that in order to set it you must provide an init function for the
tfm, even if the size is actually static.

This patch adds a reqsize field to the skcipher alg object which
allows it to be set without having an init function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/skcipher.c         |    4 +++-
 include/crypto/skcipher.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 467af525848a1..3bfa06fd25600 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -668,6 +668,8 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(skcipher);
 
+	skcipher->reqsize = alg->reqsize;
+
 	skcipher_set_needkey(skcipher);
 
 	if (alg->exit)
@@ -797,7 +799,7 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
-	    alg->walksize > PAGE_SIZE / 8)
+	    alg->walksize > PAGE_SIZE / 8 || alg->reqsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	if (!alg->chunksize)
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index fb90c3e1c26ba..c46ea1c157b29 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -100,6 +100,7 @@ struct crypto_sync_skcipher {
  * @final_chunksize: Number of bytes that must be processed together
  *		     at the end.  If set to -1 then chaining is not
  *		     possible.
+ * @reqsize: Size of the request data structure.
  * @base: Definition of a generic crypto algorithm.
  *
  * All fields except @ivsize are mandatory and must be filled.
@@ -118,6 +119,7 @@ struct skcipher_alg {
 	unsigned int chunksize;
 	unsigned int walksize;
 	int final_chunksize;
+	unsigned int reqsize;
 
 	struct crypto_alg base;
 };
