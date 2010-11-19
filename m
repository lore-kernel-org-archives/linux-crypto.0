From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 5/8] omap-sham: crypto_ahash_final() now not need to be called.
Date: Fri, 19 Nov 2010 16:04:26 +0200
Message-ID: <e1d88f7e0b7397bae0439b92010f0002258e7f19.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

According to the Herbert Xu, client may not always call
crypto_ahash_final().

In the case of error in hash calculation resources will be
automatically cleaned up.

But if no hash calculation error happens and client will not call
crypto_ahash_final() at all, then internal buffer will not be freed,
and clocks will not be disabled.

This patch provides support for atomic crypto_ahash_update() call.
Clocks are now enabled and disabled per update request.

Data buffer is now allocated as a part of request context.
Client is obligated to free it with crypto_free_ahash().

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |  168 +++++++++++++++++++++----------------------
 1 files changed, 82 insertions(+), 86 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6340c5e..85d6277 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -89,6 +89,11 @@
 #define OP_UPDATE	1
 #define OP_FINAL	2
 
+#define OMAP_ALIGN_MASK		(sizeof(u32)-1)
+#define OMAP_ALIGNED		__attribute__((aligned(sizeof(u32))))
+
+#define BUFLEN		PAGE_SIZE
+
 struct omap_sham_dev;
 
 struct omap_sham_reqctx {
@@ -96,9 +101,8 @@ struct omap_sham_reqctx {
 	unsigned long		flags;
 	unsigned long		op;
 
-	u8			digest[SHA1_DIGEST_SIZE];
+	u8			digest[SHA1_DIGEST_SIZE] OMAP_ALIGNED;
 	size_t			digcnt;
-	u8			*buffer;
 	size_t			bufcnt;
 	size_t			buflen;
 	dma_addr_t		dma_addr;
@@ -107,6 +111,8 @@ struct omap_sham_reqctx {
 	struct scatterlist	*sg;
 	unsigned int		offset;	/* offset in current sg */
 	unsigned int		total;	/* total request */
+
+	u8			buffer[0] OMAP_ALIGNED;
 };
 
 struct omap_sham_hmac_ctx {
@@ -219,31 +225,33 @@ static void omap_sham_copy_hash(struct ahash_request *req, int out)
 	}
 }
 
-static int omap_sham_write_ctrl(struct omap_sham_dev *dd, size_t length,
-				 int final, int dma)
+static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
-	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-	u32 val = length << 5, mask;
+	clk_enable(dd->iclk);
 
-	if (unlikely(!ctx->digcnt)) {
+	if (!(dd->flags & FLAGS_INIT)) {
+		omap_sham_write_mask(dd, SHA_REG_MASK,
+			SHA_REG_MASK_SOFTRESET, SHA_REG_MASK_SOFTRESET);
 
-		clk_enable(dd->iclk);
+		if (omap_sham_wait(dd, SHA_REG_SYSSTATUS,
+					SHA_REG_SYSSTATUS_RESETDONE))
+			return -ETIMEDOUT;
 
-		if (!(dd->flags & FLAGS_INIT)) {
-			omap_sham_write_mask(dd, SHA_REG_MASK,
-				SHA_REG_MASK_SOFTRESET, SHA_REG_MASK_SOFTRESET);
+		dd->flags |= FLAGS_INIT;
+		dd->err = 0;
+	}
 
-			if (omap_sham_wait(dd, SHA_REG_SYSSTATUS,
-						SHA_REG_SYSSTATUS_RESETDONE)) {
-				clk_disable(dd->iclk);
-				return -ETIMEDOUT;
-			}
-			dd->flags |= FLAGS_INIT;
-			dd->err = 0;
-		}
-	} else {
+	return 0;
+}
+
+static void omap_sham_write_ctrl(struct omap_sham_dev *dd, size_t length,
+				 int final, int dma)
+{
+	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
+	u32 val = length << 5, mask;
+
+	if (likely(ctx->digcnt))
 		omap_sham_write(dd, SHA_REG_DIGCNT, ctx->digcnt);
-	}
 
 	omap_sham_write_mask(dd, SHA_REG_MASK,
 		SHA_REG_MASK_IT_EN | (dma ? SHA_REG_MASK_DMA_EN : 0),
@@ -263,23 +271,19 @@ static int omap_sham_write_ctrl(struct omap_sham_dev *dd, size_t length,
 			SHA_REG_CTRL_ALGO | SHA_REG_CTRL_LENGTH;
 
 	omap_sham_write_mask(dd, SHA_REG_CTRL, val, mask);
-
-	return 0;
 }
 
 static int omap_sham_xmit_cpu(struct omap_sham_dev *dd, const u8 *buf,
 			      size_t length, int final)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-	int err, count, len32;
+	int count, len32;
 	const u32 *buffer = (const u32 *)buf;
 
 	dev_dbg(dd->dev, "xmit_cpu: digcnt: %d, length: %d, final: %d\n",
 						ctx->digcnt, length, final);
 
-	err = omap_sham_write_ctrl(dd, length, final, 0);
-	if (err)
-		return err;
+	omap_sham_write_ctrl(dd, length, final, 0);
 
 	/* should be non-zero before next lines to disable clocks later */
 	ctx->digcnt += length;
@@ -302,14 +306,10 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 			      size_t length, int final)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
-	int err, len32;
+	int len32;
 
 	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
 						ctx->digcnt, length, final);
-	/* flush cache entries related to our page */
-	if (dma_addr == ctx->dma_addr)
-		dma_sync_single_for_device(dd->dev, dma_addr, length,
-					   DMA_TO_DEVICE);
 
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
@@ -320,19 +320,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
 				dma_addr, 0, 0);
 
-	omap_set_dma_dest_params(dd->dma_lch, 0,
-			OMAP_DMA_AMODE_CONSTANT,
-			dd->phys_base + SHA_REG_DIN(0), 0, 16);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_16);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_4);
-
-	err = omap_sham_write_ctrl(dd, length, final, 1);
-	if (err)
-		return err;
+	omap_sham_write_ctrl(dd, length, final, 1);
 
 	ctx->digcnt += length;
 
@@ -384,6 +372,21 @@ static size_t omap_sham_append_sg(struct omap_sham_reqctx *ctx)
 	return 0;
 }
 
+static int omap_sham_xmit_dma_map(struct omap_sham_dev *dd,
+					struct omap_sham_reqctx *ctx,
+					size_t length, int final)
+{
+	ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer, ctx->buflen,
+				       DMA_TO_DEVICE);
+	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
+		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen);
+		return -EINVAL;
+	}
+
+	/* next call does not fail... so no unmap in the case of error */
+	return omap_sham_xmit_dma(dd, ctx->dma_addr, length, final);
+}
+
 static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
@@ -403,7 +406,7 @@ static int omap_sham_update_dma_slow(struct omap_sham_dev *dd)
 	if (final || (ctx->bufcnt == ctx->buflen && ctx->total)) {
 		count = ctx->bufcnt;
 		ctx->bufcnt = 0;
-		return omap_sham_xmit_dma(dd, ctx->dma_addr, count, final);
+		return omap_sham_xmit_dma_map(dd, ctx, count, final);
 	}
 
 	return 0;
@@ -413,7 +416,6 @@ static int omap_sham_update_dma_fast(struct omap_sham_dev *dd)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 	unsigned int length;
-	int err;
 
 	ctx->flags |= FLAGS_FAST;
 
@@ -427,11 +429,8 @@ static int omap_sham_update_dma_fast(struct omap_sham_dev *dd)
 
 	ctx->total -= length;
 
-	err = omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, 1);
-	if (err != -EINPROGRESS)
-		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
-
-	return err;
+	/* next call does not fail... so no unmap in the case of error */
+	return omap_sham_xmit_dma(dd, sg_dma_address(ctx->sg), length, 1);
 }
 
 static int omap_sham_update_cpu(struct omap_sham_dev *dd)
@@ -453,6 +452,9 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 	omap_stop_dma(dd->dma_lch);
 	if (ctx->flags & FLAGS_FAST)
 		dma_unmap_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE);
+	else
+		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen,
+				 DMA_TO_DEVICE);
 
 	return 0;
 }
@@ -471,18 +473,9 @@ static void omap_sham_cleanup(struct ahash_request *req)
 	ctx->flags |= FLAGS_CLEAN;
 	spin_unlock_irqrestore(&dd->lock, flags);
 
-	if (ctx->digcnt) {
-		clk_disable(dd->iclk);
+	if (ctx->digcnt)
 		memcpy(req->result, ctx->digest, (ctx->flags & FLAGS_SHA1) ?
 				SHA1_DIGEST_SIZE : MD5_DIGEST_SIZE);
-	}
-
-	if (ctx->dma_addr)
-		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen,
-				 DMA_TO_DEVICE);
-
-	if (ctx->buffer)
-		free_page((unsigned long)ctx->buffer);
 
 	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
 }
@@ -520,21 +513,7 @@ static int omap_sham_init(struct ahash_request *req)
 
 	ctx->bufcnt = 0;
 	ctx->digcnt = 0;
-
-	ctx->buflen = PAGE_SIZE;
-	ctx->buffer = (void *)__get_free_page(
-				(req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-				GFP_KERNEL : GFP_ATOMIC);
-	if (!ctx->buffer)
-		return -ENOMEM;
-
-	ctx->dma_addr = dma_map_single(dd->dev, ctx->buffer, ctx->buflen,
-					DMA_TO_DEVICE);
-	if (dma_mapping_error(dd->dev, ctx->dma_addr)) {
-		dev_err(dd->dev, "dma %u bytes error\n", ctx->buflen);
-		free_page((unsigned long)ctx->buffer);
-		return -EINVAL;
-	}
+	ctx->buflen = BUFLEN;
 
 	if (tctx->flags & FLAGS_HMAC) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
@@ -581,7 +560,7 @@ static int omap_sham_final_req(struct omap_sham_dev *dd)
 		use_dma = 0;
 
 	if (use_dma)
-		err = omap_sham_xmit_dma(dd, ctx->dma_addr, ctx->bufcnt, 1);
+		err = omap_sham_xmit_dma_map(dd, ctx, ctx->bufcnt, 1);
 	else
 		err = omap_sham_xmit_cpu(dd, ctx->buffer, ctx->bufcnt, 1);
 
@@ -615,6 +594,7 @@ static int omap_sham_finish_req_hmac(struct ahash_request *req)
 static void omap_sham_finish_req(struct ahash_request *req, int err)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
+	struct omap_sham_dev *dd = ctx->dd;
 
 	if (!err) {
 		omap_sham_copy_hash(ctx->dd->req, 1);
@@ -627,7 +607,8 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	if ((ctx->flags & FLAGS_FINAL) || err)
 		omap_sham_cleanup(req);
 
-	ctx->dd->flags &= ~FLAGS_BUSY;
+	clk_disable(dd->iclk);
+	dd->flags &= ~FLAGS_BUSY;
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
@@ -636,7 +617,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 				  struct ahash_request *req)
 {
-	struct crypto_async_request *async_req, *backlog;
+	struct crypto_async_request *async_req, *backlog = 0;
 	struct omap_sham_reqctx *ctx;
 	struct ahash_request *prev_req;
 	unsigned long flags;
@@ -672,7 +653,22 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	dev_dbg(dd->dev, "handling new req, op: %lu, nbytes: %d\n",
 						ctx->op, req->nbytes);
 
-	if (req != prev_req && ctx->digcnt)
+
+	err = omap_sham_hw_init(dd);
+	if (err)
+		goto err1;
+
+	omap_set_dma_dest_params(dd->dma_lch, 0,
+			OMAP_DMA_AMODE_CONSTANT,
+			dd->phys_base + SHA_REG_DIN(0), 0, 16);
+
+	omap_set_dma_dest_burst_mode(dd->dma_lch,
+			OMAP_DMA_DATA_BURST_16);
+
+	omap_set_dma_src_burst_mode(dd->dma_lch,
+			OMAP_DMA_DATA_BURST_4);
+
+	if (ctx->digcnt)
 		/* request has changed - restore hash */
 		omap_sham_copy_hash(req, 0);
 
@@ -684,7 +680,7 @@ static int omap_sham_handle_queue(struct omap_sham_dev *dd,
 	} else if (ctx->op == OP_FINAL) {
 		err = omap_sham_final_req(dd);
 	}
-
+err1:
 	if (err != -EINPROGRESS) {
 		/* done_task will not finish it, so do it here */
 		omap_sham_finish_req(req, err);
@@ -868,7 +864,7 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	}
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct omap_sham_reqctx));
+				 sizeof(struct omap_sham_reqctx) + BUFLEN);
 
 	if (alg_base) {
 		struct omap_sham_hmac_ctx *bctx = tctx->base;
@@ -954,7 +950,7 @@ static struct ahash_alg algs[] = {
 						CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -978,7 +974,7 @@ static struct ahash_alg algs[] = {
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_sha1_init,
 		.cra_exit		= omap_sham_cra_exit,
@@ -1002,7 +998,7 @@ static struct ahash_alg algs[] = {
 		.cra_blocksize		= SHA1_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct omap_sham_ctx) +
 					sizeof(struct omap_sham_hmac_ctx),
-		.cra_alignmask		= 0,
+		.cra_alignmask		= OMAP_ALIGN_MASK,
 		.cra_module		= THIS_MODULE,
 		.cra_init		= omap_sham_cra_md5_init,
 		.cra_exit		= omap_sham_cra_exit,
-- 
1.7.0.4

