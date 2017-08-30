From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - update correct dst SGL entry
Date: Wed, 30 Aug 2017 09:17:39 +0200
Message-ID: <2484753.VGNM65Hb0R@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34512 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdH3HRt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2017 03:17:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When two adjacent TX SGL are processed and parts of both TX SGLs
are pulled into the per-request TX SGL, the wrong per-request
TX SGL entries were updated.

This fixes a NULL pointer dereference when a cipher implementation walks
the TX SGL where some of the SGL entries were NULL.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ffa9f4ccd9b4..337cf382718e 100644
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
2.13.5
