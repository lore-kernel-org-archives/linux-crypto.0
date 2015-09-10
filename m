From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/7] crypto: talitos replace sg_count with sg_nents_for_len2
Date: Thu, 10 Sep 2015 15:21:40 +0200
Message-ID: <1441891302-12014-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33685 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbIJNVv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 09:21:51 -0400
In-Reply-To: <1441891302-12014-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/talitos.c | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3b20a1b..aca6a6a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1234,26 +1234,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 }
 
 /*
- * derive number of elements in scatterlist
- */
-static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
-{
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	*chained = false;
-	while (nbytes > 0 && sg) {
-		sg_nents++;
-		nbytes -= sg->length;
-		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = true;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
-}
-
-/*
  * allocate and map the extended descriptor
  */
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
@@ -1287,16 +1267,17 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
 
 	if (!dst || dst == src) {
-		src_nents = sg_count(src, assoclen + cryptlen + authsize,
-				     &src_chained);
+		src_nents = sg_nents_for_len2(src,
+					      assoclen + cryptlen + authsize,
+					      &src_chained);
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
 	} else { /* dst && dst != src*/
-		src_nents = sg_count(src, assoclen + cryptlen +
+		src_nents = sg_nents_for_len2(src, assoclen + cryptlen +
 					  (encrypt ? 0 : authsize),
 				     &src_chained);
 		src_nents = (src_nents == 1) ? 0 : src_nents;
-		dst_nents = sg_count(dst, assoclen + cryptlen +
+		dst_nents = sg_nents_for_len2(dst, assoclen + cryptlen +
 					  (encrypt ? authsize : 0),
 				     &dst_chained);
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
@@ -1902,7 +1883,8 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
 		sg_copy_to_buffer(areq->src,
-				  sg_count(areq->src, nbytes, &chained),
+				  sg_nents_for_len2(areq->src, nbytes,
+						    &chained),
 				  req_ctx->buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -1935,7 +1917,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		int nents = sg_count(areq->src, nbytes, &chained);
+		int nents = sg_nents_for_len2(areq->src, nbytes, &chained);
 		sg_pcopy_to_buffer(areq->src, nents,
 				      req_ctx->bufnext,
 				      to_hash_later,
-- 
2.4.6
