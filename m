From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 8/8] omap-sham: zero-copy scatterlist handling
Date: Fri, 19 Nov 2010 16:04:29 +0200
Message-ID: <30424eea66d4a1444b8a7e4f81c813bf82d689fd.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:58047 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab0KSOD5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Nov 2010 09:03:57 -0500
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If scatterlist have more than one entry, current driver uses
aligned buffer to copy data to to accelerator to tackle possible
issues with DMA and SHA buffer alignment.

This commit adds more intelligence to verify SG alignment and
possibility to use DMA directly on the data without using copy
buffer.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   87 +++++++++++++++++++++++++++++++-------------
 1 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index d88d7eb..eb988e7 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -74,7 +74,7 @@
 
 #define FLAGS_FINUP		0x0002
 #define FLAGS_FINAL		0x0004
-#define FLAGS_FAST		0x0008
+#define FLAGS_SG		0x0008
 #define FLAGS_SHA1		0x0010
 #define FLAGS_DMA_ACTIVE	0x0020
 #define FLAGS_OUTPUT_READY	0x0040
@@ -393,6 +393,8 @@ static int omap_sham_xmit_dma_map(struct omap_sham_dev *dd,
 		return -EINVAL;
 	}
 
+	ctx->flags &= ~FLAGS_SG;
+
 	/* next call does not fail... so no unmap in the case of error */
 	return omap_sham_xmit_dma(dd, ctx->dma_addr, length, final);
 }
@@ -403,9 +405,6 @@ static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
 	unsigned int final;
 	size_t count;
 
-	if (!ctx->total)
-		return 0;
-
 	omap_sham_append_sg(ctx);
 
 	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
@@ -422,25 +421,62 @@ static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
 	return 0;
 }
 
-static int omap_sham_update_dma_fast(struct omap_sham_dev *dd)
+/* Start address alignment */
+#define SG_AA(sg)	(IS_ALIGNED(sg->offset, sizeof(u32)))
+/* SHA1 block size alignment */
+#define SG_SA(sg)	(IS_ALIGNED(sg->length, SHA1_MD5_BLOCK_SIZE))
+
+static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-	unsigned int length;
+	unsigned int length, final, tail;
+	struct scatterlist *sg;
+
+	if (!ctx->total)
+		return 0;
+
+	if (ctx->bufcnt || ctx->offset)
+		return omap_sham_update_dma_slow(dd);
+
+	dev_dbg(dd->dev, "fast: digcnt: %d, bufcnt: %u, total: %u\n",
+			ctx->digcnt, ctx->bufcnt, ctx->total);
+
+	sg = ctx->sg;
 
-	ctx->flags |= FLAGS_FAST;
+	if (!SG_AA(sg))
+		return omap_sham_update_dma_slow(dd);
 
-	length = min(ctx->total, sg_dma_len(ctx->sg));
-	ctx->total = length;
+	if (!sg_is_last(sg) && !SG_SA(sg))
+		/* size is not SHA1_BLOCK_SIZE aligned */
+		return omap_sham_update_dma_slow(dd);
+
+	length = min(ctx->total, sg->length);
+
+	if (sg_is_last(sg)) {
+		if (!(ctx->flags & FLAGS_FINUP)) {
+			/* not last sg must be SHA1_MD5_BLOCK_SIZE aligned */
+			tail = length & (SHA1_MD5_BLOCK_SIZE - 1);
+			/* without finup() we need one block to close hash */
+			if (!tail)
+				tail = SHA1_MD5_BLOCK_SIZE;
+			length -= tail;
+		}
+	}
 
 	if (!dma_map_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
 		dev_err(dd->dev, "dma_map_sg  error\n");
 		return -EINVAL;
 	}
 
+	ctx->flags |= FLAGS_SG;
+
 	ctx->total -= length;
+	ctx->offset = length; /* offset where to start slow */
+
+	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
 
 	/* next call does not fail... so no unmap in the case of error */
-	return omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, 1);
+	return omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, final);
 }
 
 static int omap_sham_update_cpu(struct omap_sham_dev *dd)
@@ -460,11 +496,17 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 
 	omap_stop_dma(dd->dma_lch);
-	if (ctx->flags & FLAGS_FAST)
+	if (ctx->flags & FLAGS_SG) {
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
-	else
+		if (ctx->sg->length == ctx->offset) {
+			ctx->sg = sg_next(ctx->sg);
+			if (ctx->sg)
+				ctx->offset = 0;
+		}
+	} else {
 		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen,
 				 DMA_TO_DEVICE);
+	}
 
 	return 0;
 }
@@ -545,10 +587,8 @@ static int omap_sham_update_req(struct omap_sham_dev *dd)
 
 	if (ctx->flags & FLAGS_CPU)
 		err = omap_sham_update_cpu(dd);
-	else if (ctx->flags & FLAGS_FAST)
-		err = omap_sham_update_dma_fast(dd);
 	else
-		err = omap_sham_update_dma_slow(dd);
+		err = omap_sham_update_dma_start(dd);
 
 	/* wait for dma completion before can take more data */
 	dev_dbg(dd->dev, "update: err: %d, digcnt: %d\n", err, ctx->digcnt);
@@ -730,18 +770,13 @@ static int omap_sham_update(struct ahash_request *req)
 			*/
 			omap_sham_append_sg(ctx);
 			return 0;
-		} else if (ctx->bufcnt + ctx->total <= 64) {
+		} else if (ctx->bufcnt + ctx->total <= SHA1_MD5_BLOCK_SIZE) {
+			/*
+			* faster to use CPU for short transfers
+			*/
 			ctx->flags |= FLAGS_CPU;
-		} else if (!ctx->bufcnt && sg_is_last(ctx->sg)) {
-			/* may be can use faster functions */
-			int aligned = IS_ALIGNED((u32)ctx->sg->offset,
-								sizeof(u32));
-			if (aligned)
-				/* digest: first and final */
-				ctx->flags |= FLAGS_FAST;
 		}
-	} else if (ctx->bufcnt + ctx->total <= ctx->buflen) {
-		/* if not finaup -> not fast */
+	} else if (ctx->bufcnt + ctx->total < ctx->buflen) {
 		omap_sham_append_sg(ctx);
 		return 0;
 	}
@@ -1026,7 +1061,7 @@ static void omap_sham_done_task(unsigned long data)
 		dd->flags &= ~FLAGS_DMA_ACTIVE;
 		omap_sham_update_dma_stop(dd);
 		if (!dd->err)
-			err = omap_sham_update_dma_slow(dd);
+			err = omap_sham_update_dma_start(dd);
 	}
 
 	err = dd->err ? : err;
-- 
1.7.0.4
