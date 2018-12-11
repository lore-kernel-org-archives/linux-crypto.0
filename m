Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:46398 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbeLKKwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:52:04 -0500
From: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, indranil@chelsio.com
Cc: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 3/6] crypto:chelsio: cleanup:send addr as value in function argument
Date: Tue, 11 Dec 2018 16:21:39 +0530
Message-Id: <a73eb448a9c34549b3aa37d00438fa9e89c54d86.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Send dma address as value to function arguments instead of pointer.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index ee985ad..f94364b 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -391,7 +391,7 @@ static inline void dsgl_walk_end(struct dsgl_walk *walk, unsigned short qid,
 
 static inline void dsgl_walk_add_page(struct dsgl_walk *walk,
 					size_t size,
-					dma_addr_t *addr)
+					dma_addr_t addr)
 {
 	int j;
 
@@ -399,7 +399,7 @@ static inline void dsgl_walk_add_page(struct dsgl_walk *walk,
 		return;
 	j = walk->nents;
 	walk->to->len[j % 8] = htons(size);
-	walk->to->addr[j % 8] = cpu_to_be64(*addr);
+	walk->to->addr[j % 8] = cpu_to_be64(addr);
 	j++;
 	if ((j % 8) == 0)
 		walk->to++;
@@ -473,16 +473,16 @@ static inline void ulptx_walk_end(struct ulptx_walk *walk)
 
 static inline void ulptx_walk_add_page(struct ulptx_walk *walk,
 					size_t size,
-					dma_addr_t *addr)
+					dma_addr_t addr)
 {
 	if (!size)
 		return;
 
 	if (walk->nents == 0) {
 		walk->sgl->len0 = cpu_to_be32(size);
-		walk->sgl->addr0 = cpu_to_be64(*addr);
+		walk->sgl->addr0 = cpu_to_be64(addr);
 	} else {
-		walk->pair->addr[walk->pair_idx] = cpu_to_be64(*addr);
+		walk->pair->addr[walk->pair_idx] = cpu_to_be64(addr);
 		walk->pair->len[walk->pair_idx] = cpu_to_be32(size);
 		walk->pair_idx = !walk->pair_idx;
 		if (!walk->pair_idx)
@@ -2481,7 +2481,7 @@ void chcr_add_aead_src_ent(struct aead_request *req,
 		ulptx_walk_init(&ulp_walk, ulptx);
 		if (reqctx->b0_len)
 			ulptx_walk_add_page(&ulp_walk, reqctx->b0_len,
-					    &reqctx->b0_dma);
+					    reqctx->b0_dma);
 		ulptx_walk_add_sg(&ulp_walk, req->src, req->cryptlen +
 				  req->assoclen,  0);
 		ulptx_walk_end(&ulp_walk);
@@ -2500,7 +2500,7 @@ void chcr_add_aead_dst_ent(struct aead_request *req,
 	u32 temp;
 
 	dsgl_walk_init(&dsgl_walk, phys_cpl);
-	dsgl_walk_add_page(&dsgl_walk, IV + reqctx->b0_len, &reqctx->iv_dma);
+	dsgl_walk_add_page(&dsgl_walk, IV + reqctx->b0_len, reqctx->iv_dma);
 	temp = req->assoclen + req->cryptlen +
 		(reqctx->op ? -authsize : authsize);
 	dsgl_walk_add_sg(&dsgl_walk, req->dst, temp, 0);
@@ -2571,7 +2571,7 @@ void chcr_add_hash_src_ent(struct ahash_request *req,
 		ulptx_walk_init(&ulp_walk, ulptx);
 		if (param->bfr_len)
 			ulptx_walk_add_page(&ulp_walk, param->bfr_len,
-					    &reqctx->hctx_wr.dma_addr);
+					    reqctx->hctx_wr.dma_addr);
 		ulptx_walk_add_sg(&ulp_walk, reqctx->hctx_wr.srcsg,
 				  param->sg_len, reqctx->hctx_wr.src_ofst);
 		reqctx->hctx_wr.srcsg = ulp_walk.last_sg;
-- 
2.1.4
