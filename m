From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 05/17] crypto: talitos - remove param 'extent' in
 map_single_talitos_ptr()
Date: Fri, 17 Apr 2015 16:31:57 +0200 (CEST)
Message-ID: <20150417143157.5C5201A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

map_single_talitos_ptr() is always called with extent == 0, so lets remove this unused parameter

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c93f79b..81e5636 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -72,14 +72,13 @@ static void to_talitos_ptr_extent_clear(struct talitos_ptr *ptr)
 static void map_single_talitos_ptr(struct device *dev,
 				   struct talitos_ptr *ptr,
 				   unsigned short len, void *data,
-				   unsigned char extent,
 				   enum dma_data_direction dir)
 {
 	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
 
 	ptr->len = cpu_to_be16(len);
 	to_talitos_ptr(ptr, dma_addr);
-	ptr->j_extent = extent;
+	to_talitos_ptr_extent_clear(ptr);
 }
 
 /*
@@ -958,7 +957,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
-			       0, DMA_TO_DEVICE);
+			       DMA_TO_DEVICE);
 
 	/* hmac data */
 	desc->ptr[1].len = cpu_to_be16(areq->assoclen + ivsize);
@@ -1002,7 +1001,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
-			       (char *)&ctx->key + ctx->authkeylen, 0,
+			       (char *)&ctx->key + ctx->authkeylen,
 			       DMA_TO_DEVICE);
 
 	/*
@@ -1080,7 +1079,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
+	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
 			       DMA_FROM_DEVICE);
 
 	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
@@ -1453,7 +1452,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-			       (char *)&ctx->key, 0, DMA_TO_DEVICE);
+			       (char *)&ctx->key, DMA_TO_DEVICE);
 
 	/*
 	 * cipher in
@@ -1470,7 +1469,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			       &desc->ptr[4], sg_count);
 
 	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv, 0,
+	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
@@ -1595,7 +1594,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (!req_ctx->first || req_ctx->swinit) {
 		map_single_talitos_ptr(dev, &desc->ptr[1],
 				       req_ctx->hw_context_size,
-				       (char *)req_ctx->hw_context, 0,
+				       (char *)req_ctx->hw_context,
 				       DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
 	} else {
@@ -1607,7 +1606,7 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	/* HMAC key */
 	if (ctx->keylen)
 		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
-				       (char *)&ctx->key, 0, DMA_TO_DEVICE);
+				       (char *)&ctx->key, DMA_TO_DEVICE);
 	else
 		desc->ptr[2] = zero_entry;
 
@@ -1624,11 +1623,11 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (req_ctx->last)
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       crypto_ahash_digestsize(tfm),
-				       areq->result, 0, DMA_FROM_DEVICE);
+				       areq->result, DMA_FROM_DEVICE);
 	else
 		map_single_talitos_ptr(dev, &desc->ptr[5],
 				       req_ctx->hw_context_size,
-				       req_ctx->hw_context, 0, DMA_FROM_DEVICE);
+				       req_ctx->hw_context, DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
 	desc->ptr[6] = zero_entry;
-- 
2.1.0
