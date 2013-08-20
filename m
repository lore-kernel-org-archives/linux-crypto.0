From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 2/2] crypto: omap-sham: correct dma burst size
Date: Tue, 20 Aug 2013 20:32:35 +0530
Message-ID: <1377010955-5605-3-git-send-email-lokeshvutla@ti.com>
References: <1377010955-5605-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<rnayak@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40778 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3HTPCr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Aug 2013 11:02:47 -0400
In-Reply-To: <1377010955-5605-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Each cycle of SHA512 operates on 32 data words where as
SHA256 operates on 16 data words. This needs to be updated
while configuring DMA channels. Doing the same.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-sham.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 0a2bd16..8bdde57 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -46,9 +46,6 @@
 
 #define MD5_DIGEST_SIZE			16
 
-#define DST_MAXBURST			16
-#define DMA_MIN				(DST_MAXBURST * sizeof(u32))
-
 #define SHA_REG_IDIGEST(dd, x)		((dd)->pdata->idigest_ofs + ((x)*0x04))
 #define SHA_REG_DIN(dd, x)		((dd)->pdata->din_ofs + ((x) * 0x04))
 #define SHA_REG_DIGCNT(dd)		((dd)->pdata->digcnt_ofs)
@@ -558,7 +555,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(dd->req);
 	struct dma_async_tx_descriptor *tx;
 	struct dma_slave_config cfg;
-	int len32, ret;
+	int len32, ret, dma_min = get_block_size(ctx);
 
 	dev_dbg(dd->dev, "xmit_dma: digcnt: %d, length: %d, final: %d\n",
 						ctx->digcnt, length, final);
@@ -567,7 +564,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 
 	cfg.dst_addr = dd->phys_base + SHA_REG_DIN(dd, 0);
 	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	cfg.dst_maxburst = DST_MAXBURST;
+	cfg.dst_maxburst = dma_min / DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	ret = dmaengine_slave_config(dd->dma_lch, &cfg);
 	if (ret) {
@@ -575,7 +572,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 		return ret;
 	}
 
-	len32 = DIV_ROUND_UP(length, DMA_MIN) * DMA_MIN;
+	len32 = DIV_ROUND_UP(length, dma_min) * dma_min;
 
 	if (is_sg) {
 		/*
@@ -729,7 +726,7 @@ static int omap_sham_update_dma_start(struct omap_sham_dev *dd)
 	 * the dmaengine infrastructure will calculate that it needs
 	 * to transfer 0 frames which ultimately fails.
 	 */
-	if (ctx->total < (DST_MAXBURST * sizeof(u32)))
+	if (ctx->total < get_block_size(ctx))
 		return omap_sham_update_dma_slow(dd);
 
 	dev_dbg(dd->dev, "fast: digcnt: %d, bufcnt: %u, total: %u\n",
-- 
1.7.9.5
