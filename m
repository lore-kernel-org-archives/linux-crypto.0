From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 5/6] omap-aes: initialize aes module once per request
Date: Tue, 30 Nov 2010 10:13:31 +0200
Message-ID: <2756a865d1d272569f341891796b352853e6fd21.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:51665 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab0K3INC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 03:13:02 -0500
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AES module was initialized for every DMA transaction.
That is redundant.
Now it is initialized once per request.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   54 +++++++++++++++++++++++---------------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 0b21dce..b69da4f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -176,6 +176,11 @@ static int omap_aes_wait(struct omap_aes_dev *dd, u32 offset, u32 bit)
 
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
+	/*
+	 * clocks are enabled when request starts and disabled when finished.
+	 * It may be long delays between requests.
+	 * Device might go to off mode to save power.
+	 */
 	clk_enable(dd->iclk);
 
 	if (!(dd->flags & FLAGS_INIT)) {
@@ -190,10 +195,9 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 		__asm__ __volatile__("nop");
 
 		if (omap_aes_wait(dd, AES_REG_SYSSTATUS,
-				AES_REG_SYSSTATUS_RESETDONE)) {
-			clk_disable(dd->iclk);
+				AES_REG_SYSSTATUS_RESETDONE))
 			return -ETIMEDOUT;
-		}
+
 		dd->flags |= FLAGS_INIT;
 		dd->err = 0;
 	}
@@ -243,9 +247,19 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
 
 	omap_aes_write_mask(dd, AES_REG_CTRL, val, mask);
 
-	/* start DMA or disable idle mode */
-	omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_START,
-			    AES_REG_MASK_START);
+	/* IN */
+	omap_set_dma_dest_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_CONSTANT,
+				 dd->phys_base + AES_REG_DATA, 0, 4);
+
+	omap_set_dma_dest_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
+	omap_set_dma_src_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
+
+	/* OUT */
+	omap_set_dma_src_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_CONSTANT,
+				dd->phys_base + AES_REG_DATA, 0, 4);
+
+	omap_set_dma_src_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
+	omap_set_dma_dest_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
 
 	return 0;
 }
@@ -419,7 +433,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct omap_aes_dev *dd = ctx->dd;
 	int len32;
-	int err;
 
 	pr_debug("len: %d\n", length);
 
@@ -432,12 +445,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
 	/* IN */
-	omap_set_dma_dest_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_CONSTANT,
-				 dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_src_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-
 	omap_set_dma_transfer_params(dd->dma_lch_in, OMAP_DMA_DATA_TYPE_S32,
 				     len32, 1, OMAP_DMA_SYNC_PACKET, dd->dma_in,
 					OMAP_DMA_DST_SYNC);
@@ -446,12 +453,6 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 				dma_addr_in, 0, 0);
 
 	/* OUT */
-	omap_set_dma_src_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_CONSTANT,
-				dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_dest_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-
 	omap_set_dma_transfer_params(dd->dma_lch_out, OMAP_DMA_DATA_TYPE_S32,
 				     len32, 1, OMAP_DMA_SYNC_PACKET,
 					dd->dma_out, OMAP_DMA_SRC_SYNC);
@@ -459,13 +460,13 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	omap_set_dma_dest_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_addr_out, 0, 0);
 
-	err = omap_aes_write_ctrl(dd);
-	if (err)
-		return err;
-
 	omap_start_dma(dd->dma_lch_in);
 	omap_start_dma(dd->dma_lch_out);
 
+	/* start DMA or disable idle mode */
+	omap_aes_write_mask(dd, AES_REG_MASK, AES_REG_MASK_START,
+			    AES_REG_MASK_START);
+
 	return 0;
 }
 
@@ -545,6 +546,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
+	clk_disable(dd->iclk);
 	dd->flags &= ~FLAGS_BUSY;
 
 	req->base.complete(&req->base, err);
@@ -562,8 +564,6 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	omap_stop_dma(dd->dma_lch_in);
 	omap_stop_dma(dd->dma_lch_out);
 
-	clk_disable(dd->iclk);
-
 	if (dd->flags & FLAGS_FAST) {
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
@@ -629,7 +629,9 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	dd->ctx = ctx;
 	ctx->dd = dd;
 
-	err = omap_aes_crypt_dma_start(dd);
+	err = omap_aes_write_ctrl(dd);
+	if (!err)
+		err = omap_aes_crypt_dma_start(dd);
 	if (err) {
 		/* aes_task will not finish it, so do it here */
 		omap_aes_finish_req(dd, err);
-- 
1.7.0.4
