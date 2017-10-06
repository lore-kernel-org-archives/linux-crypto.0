From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 18/18] crypto: talitos - avoid useless copy
Date: Fri,  6 Oct 2017 15:05:08 +0200 (CEST)
Message-ID: <288da85f9b346d81f0c53263268ac97c46e36029.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch avoids copy of buffered data to hash from bufnext to buf

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5c4499a85611..5bd8191405d8 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -842,8 +842,8 @@ struct talitos_ctx {
 struct talitos_ahash_req_ctx {
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	unsigned int hw_context_size;
-	u8 buf[HASH_MAX_BLOCK_SIZE];
-	u8 bufnext[HASH_MAX_BLOCK_SIZE];
+	u8 buf[2][HASH_MAX_BLOCK_SIZE];
+	int buf_idx;
 	unsigned int swinit;
 	unsigned int first;
 	unsigned int last;
@@ -1709,7 +1709,7 @@ static void ahash_done(struct device *dev,
 
 	if (!req_ctx->last && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
-		memcpy(req_ctx->buf, req_ctx->bufnext, req_ctx->to_hash_later);
+		req_ctx->buf_idx = (req_ctx->buf_idx + 1) & 1;
 		req_ctx->nbuf = req_ctx->to_hash_later;
 	}
 	common_nonsnoop_hash_unmap(dev, edesc, areq);
@@ -1789,8 +1789,10 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	 * data in
 	 */
 	if (is_sec1 && req_ctx->nbuf) {
-		to_talitos_ptr(&desc->ptr[3], ctx->dma_buf, req_ctx->nbuf,
-			       is_sec1);
+		dma_addr_t dma_buf = ctx->dma_buf + req_ctx->buf_idx *
+						    HASH_MAX_BLOCK_SIZE;
+
+		to_talitos_ptr(&desc->ptr[3], dma_buf, req_ctx->nbuf, is_sec1);
 	} else {
 		sg_count = talitos_sg_map(dev, req_ctx->psrc, length, edesc,
 					  &desc->ptr[3], sg_count, offset, 0);
@@ -1883,6 +1885,7 @@ static int ahash_init(struct ahash_request *areq)
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* Initialize the context */
+	req_ctx->buf_idx = 0;
 	req_ctx->nbuf = 0;
 	req_ctx->first = 1; /* first indicates h/w must init its context */
 	req_ctx->swinit = 0; /* assume h/w init of context */
@@ -1955,6 +1958,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	int offset = 0;
+	u8 *ctx_buf = req_ctx->buf[req_ctx->buf_idx];
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
@@ -1964,7 +1968,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			return nents;
 		}
 		sg_copy_to_buffer(areq->src, nents,
-				  req_ctx->buf + req_ctx->nbuf, nbytes);
+				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
 	}
@@ -1988,7 +1992,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (!is_sec1 && req_ctx->nbuf) {
 		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
 		sg_init_table(req_ctx->bufsl, nsg);
-		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
+		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
 			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
@@ -2003,7 +2007,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			return nents;
 		}
 		sg_copy_to_buffer(areq->src, nents,
-				  req_ctx->buf + req_ctx->nbuf, offset);
+				  ctx_buf + req_ctx->nbuf, offset);
 		req_ctx->nbuf += offset;
 		req_ctx->psrc = areq->src;
 	} else
@@ -2016,7 +2020,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			return nents;
 		}
 		sg_pcopy_to_buffer(areq->src, nents,
-				      req_ctx->bufnext,
+				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
 	}
@@ -2038,9 +2042,13 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	/* request SEC to INIT hash. */
 	if (req_ctx->first && !req_ctx->swinit)
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
-	if (is_sec1)
-		dma_sync_single_for_device(dev, ctx->dma_buf,
+	if (is_sec1) {
+		dma_addr_t dma_buf = ctx->dma_buf + req_ctx->buf_idx *
+						    HASH_MAX_BLOCK_SIZE;
+
+		dma_sync_single_for_device(dev, dma_buf,
 					   req_ctx->nbuf, DMA_TO_DEVICE);
+	}
 
 	/* When the tfm context has a keylen, it's an HMAC.
 	 * A first or last (ie. not middle) descriptor must request HMAC.
@@ -2102,7 +2110,7 @@ static int ahash_export(struct ahash_request *areq, void *out)
 				req_ctx->hw_context_size, DMA_FROM_DEVICE);
 	memcpy(export->hw_context, req_ctx->hw_context,
 	       req_ctx->hw_context_size);
-	memcpy(export->buf, req_ctx->buf, req_ctx->nbuf);
+	memcpy(export->buf, req_ctx->buf[req_ctx->buf_idx], req_ctx->nbuf);
 	export->swinit = req_ctx->swinit;
 	export->first = req_ctx->first;
 	export->last = req_ctx->last;
@@ -2138,7 +2146,7 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	if (ctx->dma_buf)
 		dma_unmap_single(dev, ctx->dma_buf, sizeof(req_ctx->buf),
 				 DMA_TO_DEVICE);
-	memcpy(req_ctx->buf, export->buf, export->nbuf);
+	memcpy(req_ctx->buf[0], export->buf, export->nbuf);
 	if (is_sec1)
 		ctx->dma_buf = dma_map_single(dev, req_ctx->buf,
 					      sizeof(req_ctx->buf),
@@ -3097,7 +3105,7 @@ static void talitos_cra_exit_ahash(struct crypto_tfm *tfm)
 		dma_unmap_single(dev, ctx->dma_hw_context, size,
 				 DMA_BIDIRECTIONAL);
 	if (ctx->dma_buf)
-		dma_unmap_single(dev, ctx->dma_buf, HASH_MAX_BLOCK_SIZE,
+		dma_unmap_single(dev, ctx->dma_buf, HASH_MAX_BLOCK_SIZE * 2,
 				 DMA_TO_DEVICE);
 }
 
-- 
2.13.3
