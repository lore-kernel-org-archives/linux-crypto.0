From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 2/5] crypto: talitos - prune unneeded descriptor allocation param
Date: Thu, 2 Aug 2012 17:16:38 +0300
Message-ID: <1343917001-20001-2-git-send-email-horia.geanta@freescale.com>
References: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:54831
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669Ab2HBORj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 10:17:39 -0400
In-Reply-To: <1343917001-20001-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

talitos_edesc_alloc does not need hash_result param.
Checking whether dst scatterlist is NULL or not is all that is required.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 9d56763..940b09d 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1134,7 +1134,6 @@ static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
-						 int hash_result,
 						 unsigned int cryptlen,
 						 unsigned int authsize,
 						 int icv_stashing,
@@ -1154,7 +1153,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	src_nents = sg_count(src, cryptlen + authsize, &src_chained);
 	src_nents = (src_nents == 1) ? 0 : src_nents;
 
-	if (hash_result) {
+	if (!dst) {
 		dst_nents = 0;
 	} else {
 		if (dst == src) {
@@ -1206,7 +1205,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, 0,
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
 				   areq->cryptlen, ctx->authsize, icv_stashing,
 				   areq->base.flags);
 }
@@ -1451,8 +1450,8 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, 0,
-				   areq->nbytes, 0, 0, areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, areq->nbytes,
+				   0, 0, areq->base.flags);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1631,8 +1630,8 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, 1,
-				   nbytes, 0, 0, areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, nbytes, 0, 0,
+				   areq->base.flags);
 }
 
 static int ahash_init(struct ahash_request *areq)
-- 
1.7.3.4
