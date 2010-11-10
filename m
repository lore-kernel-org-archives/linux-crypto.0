From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 2/5] omap-aes: DMA initialization fixes for OMAP off mode
Date: Wed, 10 Nov 2010 19:26:53 +0200
Message-ID: <5625ae87a8364e1b10ebadfacbb7d27a5bcb12a5.1289409924.git.dmitry.kasatkin@nokia.com>
References: <y>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:20049 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab0KJR11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 12:27:27 -0500
In-Reply-To: <y>
In-Reply-To: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
References: <cover.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DMA parameters for constant data were initialized during driver probe().
It seems that those settings sometimes are lost when devices goes to off mode.
This patch makes DMA initialization just before use.
It solves off mode problems.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9d65611..04cab70 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -99,7 +99,7 @@ struct omap_aes_reqctx {
 struct omap_aes_dev {
 	struct list_head	list;
 	unsigned long		phys_base;
-	void __iomem 		*io_base;
+	void __iomem		*io_base;
 	struct clk		*iclk;
 	struct omap_aes_ctx	*ctx;
 	struct device		*dev;
@@ -341,18 +341,6 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
 		goto err_dma_out;
 	}
 
-	omap_set_dma_dest_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_CONSTANT,
-				 dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_src_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
-
-	omap_set_dma_src_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_CONSTANT,
-				dd->phys_base + AES_REG_DATA, 0, 4);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-	omap_set_dma_dest_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
-
 	return 0;
 
 err_dma_out:
@@ -445,6 +433,12 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
 	/* IN */
+	omap_set_dma_dest_params(dd->dma_lch_in, 0, OMAP_DMA_AMODE_CONSTANT,
+				 dd->phys_base + AES_REG_DATA, 0, 4);
+
+	omap_set_dma_dest_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
+	omap_set_dma_src_burst_mode(dd->dma_lch_in, OMAP_DMA_DATA_BURST_4);
+
 	omap_set_dma_transfer_params(dd->dma_lch_in, OMAP_DMA_DATA_TYPE_S32,
 				     len32, 1, OMAP_DMA_SYNC_PACKET, dd->dma_in,
 					OMAP_DMA_DST_SYNC);
@@ -453,6 +447,12 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
 				dma_addr_in, 0, 0);
 
 	/* OUT */
+	omap_set_dma_src_params(dd->dma_lch_out, 0, OMAP_DMA_AMODE_CONSTANT,
+				dd->phys_base + AES_REG_DATA, 0, 4);
+
+	omap_set_dma_src_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
+	omap_set_dma_dest_burst_mode(dd->dma_lch_out, OMAP_DMA_DATA_BURST_4);
+
 	omap_set_dma_transfer_params(dd->dma_lch_out, OMAP_DMA_DATA_TYPE_S32,
 				     len32, 1, OMAP_DMA_SYNC_PACKET,
 					dd->dma_out, OMAP_DMA_SRC_SYNC);
@@ -752,7 +752,7 @@ static struct crypto_alg algs[] = {
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
-	.cra_alignmask	 	= 0,
+	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= omap_aes_cra_init,
@@ -772,7 +772,7 @@ static struct crypto_alg algs[] = {
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
-	.cra_alignmask	 	= 0,
+	.cra_alignmask		= 0,
 	.cra_type		= &crypto_ablkcipher_type,
 	.cra_module		= THIS_MODULE,
 	.cra_init		= omap_aes_cra_init,
-- 
1.7.0.4
