From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside the
 requests
Date: Fri,  6 Oct 2017 15:05:04 +0200 (CEST)
Message-ID: <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

At every request, we map and unmap the same hash hw_context.

This patch moves the dma mapping/unmapping in functions ahash_init()
and ahash_import().

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 80 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ebfd6d982ed6..d495649d5267 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -819,6 +819,7 @@ struct talitos_ctx {
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
+	dma_addr_t dma_hw_context;
 };
 
 #define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
@@ -1663,18 +1664,9 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 				       struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL, 0, 0);
 
-	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&edesc->desc.ptr[1], is_sec1))
-		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
-					 DMA_TO_DEVICE);
-
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
@@ -1744,10 +1736,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* hash context in */
 	if (!req_ctx->first || req_ctx->swinit) {
-		map_single_talitos_ptr(dev, &desc->ptr[1],
-				       req_ctx->hw_context_size,
-				       (char *)req_ctx->hw_context,
-				       DMA_TO_DEVICE);
+		to_talitos_ptr(&desc->ptr[1], ctx->dma_hw_context,
+			       req_ctx->hw_context_size, is_sec1);
 		req_ctx->swinit = 0;
 	}
 	/* Indicate next op is not the first. */
@@ -1780,9 +1770,8 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       crypto_ahash_digestsize(tfm),
 				       areq->result, DMA_FROM_DEVICE);
 	else
-		map_single_talitos_ptr(dev, &desc->ptr[5],
-				       req_ctx->hw_context_size,
-				       req_ctx->hw_context, DMA_FROM_DEVICE);
+		to_talitos_ptr(&desc->ptr[5], ctx->dma_hw_context,
+			       req_ctx->hw_context_size, is_sec1);
 
 	/* last DWORD empty */
 
@@ -1815,17 +1804,25 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 static int ahash_init(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	unsigned int size;
 
 	/* Initialize the context */
 	req_ctx->nbuf = 0;
 	req_ctx->first = 1; /* first indicates h/w must init its context */
 	req_ctx->swinit = 0; /* assume h/w init of context */
-	req_ctx->hw_context_size =
-		(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	req_ctx->hw_context_size = size;
 
+	if (ctx->dma_hw_context)
+		dma_unmap_single(dev, ctx->dma_hw_context, size,
+				 DMA_BIDIRECTIONAL);
+	ctx->dma_hw_context = dma_map_single(dev, req_ctx->hw_context, size,
+					     DMA_BIDIRECTIONAL);
 	return 0;
 }
 
@@ -1836,6 +1833,9 @@ static int ahash_init(struct ahash_request *areq)
 static int ahash_init_sha224_swinit(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 
 	ahash_init(areq);
 	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
@@ -1853,6 +1853,9 @@ static int ahash_init_sha224_swinit(struct ahash_request *areq)
 	req_ctx->hw_context[8] = 0;
 	req_ctx->hw_context[9] = 0;
 
+	dma_sync_single_for_device(dev, ctx->dma_hw_context,
+				   req_ctx->hw_context_size, DMA_TO_DEVICE);
+
 	return 0;
 }
 
@@ -1990,7 +1993,12 @@ static int ahash_export(struct ahash_request *areq, void *out)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_export_state *export = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = ctx->dev;
 
+	dma_sync_single_for_cpu(dev, ctx->dma_hw_context,
+				req_ctx->hw_context_size, DMA_FROM_DEVICE);
 	memcpy(export->hw_context, req_ctx->hw_context,
 	       req_ctx->hw_context_size);
 	memcpy(export->buf, req_ctx->buf, req_ctx->nbuf);
@@ -2008,14 +2016,22 @@ static int ahash_import(struct ahash_request *areq, const void *in)
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	const struct talitos_export_state *export = in;
+	unsigned int size;
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 
 	memset(req_ctx, 0, sizeof(*req_ctx));
-	req_ctx->hw_context_size =
-		(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+	size = (crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
 			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
 			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
-	memcpy(req_ctx->hw_context, export->hw_context,
-	       req_ctx->hw_context_size);
+	req_ctx->hw_context_size = size;
+	if (ctx->dma_hw_context)
+		dma_unmap_single(dev, ctx->dma_hw_context, size,
+				 DMA_BIDIRECTIONAL);
+
+	memcpy(req_ctx->hw_context, export->hw_context, size);
+	ctx->dma_hw_context = dma_map_single(dev, req_ctx->hw_context, size,
+					     DMA_BIDIRECTIONAL);
 	memcpy(req_ctx->buf, export->buf, export->nbuf);
 	req_ctx->swinit = export->swinit;
 	req_ctx->first = export->first;
@@ -2954,6 +2970,24 @@ static void talitos_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
 }
 
+static void talitos_cra_exit_ahash(struct crypto_tfm *tfm)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct device *dev = ctx->dev;
+	unsigned int size;
+
+	talitos_cra_exit(tfm);
+
+	size = (crypto_ahash_digestsize(__crypto_ahash_cast(tfm)) <=
+		SHA256_DIGEST_SIZE)
+	       ? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+	       : TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+
+	if (ctx->dma_hw_context)
+		dma_unmap_single(dev, ctx->dma_hw_context, size,
+				 DMA_BIDIRECTIONAL);
+}
+
 /*
  * given the alg's descriptor header template, determine whether descriptor
  * type and primary/secondary execution units required match the hw
@@ -3052,7 +3086,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
-		alg->cra_exit = talitos_cra_exit;
+		alg->cra_exit = talitos_cra_exit_ahash;
 		alg->cra_type = &crypto_ahash_type;
 		t_alg->algt.alg.hash.init = ahash_init;
 		t_alg->algt.alg.hash.update = ahash_update;
-- 
2.13.3
