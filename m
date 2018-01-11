From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 1/5] crypto: chelsio - Fix Indentation
Date: Thu, 11 Jan 2018 16:45:48 +0530
Message-ID: <7a98a5b0e25ed50a30372e0fa667639f40033729.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:47872 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933728AbeAKLQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:03 -0500
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix inconsistent Indenting.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index b663b93..f6b1161 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -683,7 +683,7 @@ static int chcr_sg_ent_in_wr(struct scatterlist *src,
 			if (srclen <= dstlen)
 				break;
 			less = min_t(unsigned int, sg_dma_len(dst) - offset -
-				dstskip, CHCR_DST_SG_SIZE);
+				     dstskip, CHCR_DST_SG_SIZE);
 			dstlen += less;
 			offset += less;
 			if (offset == sg_dma_len(dst)) {
@@ -694,7 +694,7 @@ static int chcr_sg_ent_in_wr(struct scatterlist *src,
 			dstskip = 0;
 		}
 		src = sg_next(src);
-		 srcskip = 0;
+		srcskip = 0;
 	}
 	return min(srclen, dstlen);
 }
@@ -1142,10 +1142,10 @@ static int chcr_handle_cipher_resp(struct ablkcipher_request *req,
 		bytes = chcr_sg_ent_in_wr(reqctx->srcsg, reqctx->dstsg, 1,
 					  SPACE_LEFT(ablkctx->enckey_len),
 					  reqctx->src_ofst, reqctx->dst_ofst);
-	if ((bytes + reqctx->processed) >= req->nbytes)
-		bytes  = req->nbytes - reqctx->processed;
-	else
-		bytes = ROUND_16(bytes);
+		if ((bytes + reqctx->processed) >= req->nbytes)
+			bytes  = req->nbytes - reqctx->processed;
+		else
+			bytes = ROUND_16(bytes);
 	} else {
 		/*CTR mode counter overfloa*/
 		bytes  = req->nbytes - reqctx->processed;
@@ -1246,15 +1246,15 @@ static int process_cipher(struct ablkcipher_request *req,
 					  MIN_CIPHER_SG,
 					  SPACE_LEFT(ablkctx->enckey_len),
 					  0, 0);
-	if ((bytes + reqctx->processed) >= req->nbytes)
-		bytes  = req->nbytes - reqctx->processed;
-	else
-		bytes = ROUND_16(bytes);
+		if ((bytes + reqctx->processed) >= req->nbytes)
+			bytes  = req->nbytes - reqctx->processed;
+		else
+			bytes = ROUND_16(bytes);
 	} else {
 		bytes = req->nbytes;
 	}
 	if (get_cryptoalg_subtype(crypto_ablkcipher_tfm(tfm)) ==
-				  CRYPTO_ALG_SUB_TYPE_CTR) {
+	    CRYPTO_ALG_SUB_TYPE_CTR) {
 		bytes = adjust_ctr_overflow(req->info, bytes);
 	}
 	if (get_cryptoalg_subtype(crypto_ablkcipher_tfm(tfm)) ==
@@ -2399,10 +2399,8 @@ void chcr_add_hash_src_ent(struct ahash_request *req,
 			ulptx_walk_add_page(&ulp_walk, param->bfr_len,
 					    &reqctx->dma_addr);
 		ulptx_walk_add_sg(&ulp_walk, req->src, param->sg_len,
-					  0);
-//	       reqctx->srcsg = ulp_walk.last_sg;
-//	       reqctx->src_ofst = ulp_walk.last_sg_len;
-			ulptx_walk_end(&ulp_walk);
+				  0);
+		ulptx_walk_end(&ulp_walk);
 	}
 }
 
-- 
2.1.4
