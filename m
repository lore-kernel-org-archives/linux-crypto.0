From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 02/13] crypto: omap-aes: fix context handling for multiple cores
Date: Wed, 24 May 2017 10:35:23 +0300
Message-ID: <1495611334-15039-3-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:35392 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966618AbdEXHgA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:00 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AES can have multiple HW accelerator cores in the system, in which case
each core has its own crypto engine in use. Currently, the used hardware
device is stored under the omap_aes_ctx struct, which is global for
the algorithm itself, causing conflicts when used with multiple cores.
Fix this by moving the used HW device under reqctx, which is stored
per-request basis.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ad6e2b3..379d701 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -101,14 +101,13 @@
 #define AES_BLOCK_WORDS		(AES_BLOCK_SIZE >> 2)
 
 struct omap_aes_ctx {
-	struct omap_aes_dev *dd;
-
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	struct crypto_skcipher	*fallback;
 };
 
 struct omap_aes_reqctx {
+	struct omap_aes_dev *dd;
 	unsigned long mode;
 };
 
@@ -328,14 +327,14 @@ static void omap_aes_dma_stop(struct omap_aes_dev *dd)
 	omap_aes_write_mask(dd, AES_REG_MASK(dd), 0, mask);
 }
 
-static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
+static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_reqctx *rctx)
 {
 	struct omap_aes_dev *dd;
 
 	spin_lock_bh(&list_lock);
 	dd = list_first_entry(&dev_list, struct omap_aes_dev, list);
 	list_move_tail(&dd->list, &dev_list);
-	ctx->dd = dd;
+	rctx->dd = dd;
 	spin_unlock_bh(&list_lock);
 
 	return dd;
@@ -400,12 +399,11 @@ static void sg_copy_buf(void *buf, struct scatterlist *sg,
 	scatterwalk_done(&walk, out, 0);
 }
 
-static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
-		struct scatterlist *in_sg, struct scatterlist *out_sg,
-		int in_sg_len, int out_sg_len)
+static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
+			      struct scatterlist *in_sg,
+			      struct scatterlist *out_sg,
+			      int in_sg_len, int out_sg_len)
 {
-	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct omap_aes_dev *dd = ctx->dd;
 	struct dma_async_tx_descriptor *tx_in, *tx_out;
 	struct dma_slave_config cfg;
 	int ret;
@@ -483,8 +481,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 
 static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(
-					crypto_ablkcipher_reqtfm(dd->req));
 	int err;
 
 	pr_debug("total: %d\n", dd->total);
@@ -505,7 +501,7 @@ static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
 		}
 	}
 
-	err = omap_aes_crypt_dma(tfm, dd->in_sg, dd->out_sg, dd->in_sg_len,
+	err = omap_aes_crypt_dma(dd, dd->in_sg, dd->out_sg, dd->in_sg_len,
 				 dd->out_sg_len);
 	if (err && !dd->pio_only) {
 		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
@@ -608,8 +604,8 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
-	struct omap_aes_dev *dd = ctx->dd;
-	struct omap_aes_reqctx *rctx;
+	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct omap_aes_dev *dd = rctx->dd;
 
 	if (!dd)
 		return -ENODEV;
@@ -638,13 +634,11 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 		dd->sgs_copied = 0;
 	}
 
-	rctx = ablkcipher_request_ctx(req);
-	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
 	dd->flags = (dd->flags & ~FLAGS_MODE_MASK) | rctx->mode;
 
 	dd->ctx = ctx;
-	ctx->dd = dd;
+	rctx->dd = dd;
 
 	return omap_aes_write_ctrl(dd);
 }
@@ -652,9 +646,8 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 static int omap_aes_crypt_req(struct crypto_engine *engine,
 			      struct ablkcipher_request *req)
 {
-	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
-			crypto_ablkcipher_reqtfm(req));
-	struct omap_aes_dev *dd = ctx->dd;
+	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct omap_aes_dev *dd = rctx->dd;
 
 	if (!dd)
 		return -ENODEV;
@@ -725,7 +718,7 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 		skcipher_request_zero(subreq);
 		return ret;
 	}
-	dd = omap_aes_find_dev(ctx);
+	dd = omap_aes_find_dev(rctx);
 	if (!dd)
 		return -ENODEV;
 
-- 
1.9.1
