From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: af_alg - Fix chained tsgl construction
Date: Wed, 13 Sep 2017 22:13:53 +0800
Message-ID: <20170913141353.GA4702@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40364 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750993AbdIMOOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2017 10:14:11 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When af_alg_pull_tsgl encounters a chained tsgl list, it will
produce a bogus SG list because the output index gets incorrectly
reset to zero when we move to the next chained list.

This patch fixes it by moving the index initialisation outside
the loop.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory...")
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ffa9f4c..337cf38 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -619,14 +619,14 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 	struct af_alg_ctx *ctx = ask->private;
 	struct af_alg_tsgl *sgl;
 	struct scatterlist *sg;
-	unsigned int i, j;
+	unsigned int i, j = 0;
 
 	while (!list_empty(&ctx->tsgl_list)) {
 		sgl = list_first_entry(&ctx->tsgl_list, struct af_alg_tsgl,
 				       list);
 		sg = sgl->sg;
 
-		for (i = 0, j = 0; i < sgl->cur; i++) {
+		for (i = 0; i < sgl->cur; i++) {
 			size_t plen = min_t(size_t, used, sg[i].length);
 			struct page *page = sg_page(sg + i);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
