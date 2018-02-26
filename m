From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH  2/2] crypto: talitos - do not perform unnecessary dma
 synchronisation
Date: Mon, 26 Feb 2018 17:40:06 +0100 (CET)
Message-ID: <e57399f4eb1de4b6330a47bdf8c82c9982999a8e.1519660621.git.christophe.leroy@c-s.fr>
References: <7c934f0788d60bd82fb1cb51d712c9ab1ea7fcb4.1519660621.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7c934f0788d60bd82fb1cb51d712c9ab1ea7fcb4.1519660621.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

req_ctx->hw_context is mainly used only by the HW. So it is not needed
to sync the HW and the CPU each time hw_context in DMA mapped.
This patch modifies the DMA mapping in order to limit synchronisation
to necessary situations.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 85 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bb44df1c1f2d..447cb8b1b16a 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -104,16 +104,34 @@ static void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val, bool is_sec1)
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
+static void __map_single_talitos_ptr(struct device *dev,
+				     struct talitos_ptr *ptr,
+				     unsigned int len, void *data,
+				     enum dma_data_direction dir,
+				     unsigned long attrs)
+{
+	dma_addr_t dma_addr = dma_map_single_attrs(dev, data, len, dir, attrs);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
+}
+
 static void map_single_talitos_ptr(struct device *dev,
 				   struct talitos_ptr *ptr,
 				   unsigned int len, void *data,
 				   enum dma_data_direction dir)
 {
-	dma_addr_t dma_addr = dma_map_single(dev, data, len, dir);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
+	__map_single_talitos_ptr(dev, ptr, len, data, dir, 0);
+}
 
-	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
+static void map_single_talitos_ptr_nosync(struct device *dev,
+					  struct talitos_ptr *ptr,
+					  unsigned int len, void *data,
+					  enum dma_data_direction dir)
+{
+	__map_single_talitos_ptr(dev, ptr, len, data, dir,
+				 DMA_ATTR_SKIP_CPU_SYNC);
 }
 
 /*
@@ -1785,10 +1803,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* hash context in */
 	if (!req_ctx->first || req_ctx->swinit) {
-		map_single_talitos_ptr(dev, &desc->ptr[1],
-				       req_ctx->hw_context_size,
-				       (char *)req_ctx->hw_context,
-				       DMA_TO_DEVICE);
+		map_single_talitos_ptr_nosync(dev, &desc->ptr[1],
+					      req_ctx->hw_context_size,
+					      req_ctx->hw_context,
+					      DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
@@ -1832,9 +1850,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       crypto_ahash_digestsize(tfm),
 				       areq->result, DMA_FROM_DEVICE);
 	else
-		map_single_talitos_ptr(dev, &desc->ptr[5],
-				       req_ctx->hw_context_size,
-				       req_ctx->hw_context, DMA_FROM_DEVICE);
+		map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
+					      req_ctx->hw_context_size,
+					      req_ctx->hw_context,
+					      DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
 
@@ -1857,10 +1876,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 			copy_talitos_ptr(&desc2->ptr[1], &desc->ptr[1],
 					 is_sec1);
 		else
-			map_single_talitos_ptr(dev, &desc2->ptr[1],
-					       req_ctx->hw_context_size,
-					       req_ctx->hw_context,
-					       DMA_TO_DEVICE);
+			map_single_talitos_ptr_nosync(dev, &desc2->ptr[1],
+						      req_ctx->hw_context_size,
+						      req_ctx->hw_context,
+						      DMA_TO_DEVICE);
 		copy_talitos_ptr(&desc2->ptr[2], &desc->ptr[2], is_sec1);
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
 					  &desc2->ptr[3], sg_count, offset, 0);
@@ -1868,10 +1887,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 			sync_needed = true;
 		copy_talitos_ptr(&desc2->ptr[5], &desc->ptr[5], is_sec1);
 		if (req_ctx->last)
-			map_single_talitos_ptr(dev, &desc->ptr[5],
-					       req_ctx->hw_context_size,
-					       req_ctx->hw_context,
-					       DMA_FROM_DEVICE);
+			map_single_talitos_ptr_nosync(dev, &desc->ptr[5],
+						      req_ctx->hw_context_size,
+						      req_ctx->hw_context,
+						      DMA_FROM_DEVICE);
 
 		next_desc = dma_map_single(dev, &desc2->hdr1, TALITOS_DESC_SIZE,
 					   DMA_BIDIRECTIONAL);
@@ -1909,8 +1928,11 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 static int ahash_init(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	unsigned int size;
+	dma_addr_t dma;
 
 	/* Initialize the context */
 	req_ctx->buf_idx = 0;
@@ -1922,6 +1944,10 @@ static int ahash_init(struct ahash_request *areq)
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
 	req_ctx->hw_context_size = size;
 
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
+
 	return 0;
 }
 
@@ -1933,9 +1959,6 @@ static int ahash_init_sha224_swinit(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	ahash_init(areq);
-	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
-
 	req_ctx->hw_context[0] = SHA224_H0;
 	req_ctx->hw_context[1] = SHA224_H1;
 	req_ctx->hw_context[2] = SHA224_H2;
@@ -1949,6 +1972,9 @@ static int ahash_init_sha224_swinit(struct ahash_request *areq)
 	req_ctx->hw_context[8] = 0;
 	req_ctx->hw_context[9] = 0;
 
+	ahash_init(areq);
+	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
+
 	return 0;
 }
 
@@ -2105,6 +2131,14 @@ static int ahash_export(struct ahash_request *areq, void *out)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_export_state *export = out;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	dma_addr_t dma;
+
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_FROM_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_FROM_DEVICE);
 
 	memcpy(export->hw_context, req_ctx->hw_context,
 	       req_ctx->hw_context_size);
@@ -2122,8 +2156,11 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 	const struct talitos_export_state *export = in;
 	unsigned int size;
+	dma_addr_t dma;
 
 	memset(req_ctx, 0, sizeof(*req_ctx));
 	size = (crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
@@ -2138,6 +2175,10 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	req_ctx->to_hash_later = export->to_hash_later;
 	req_ctx->nbuf = export->nbuf;
 
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
+
 	return 0;
 }
 
-- 
2.13.3
