From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCHv2 1/6] omap-aes: DMA initialization fixes for OMAP off mode
Date: Tue, 30 Nov 2010 10:13:27 +0200
Message-ID: <6acc6d289f5a7bc795ecd1c7df9355a1723092dd.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
References: <cover.1291104329.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

DMA parameters for constant data were initialized during driver probe().
It seems that those settings sometimes are lost when devices goes to off mode.
This patch makes DMA initialization just before use.
It solves off mode problems.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 799ca51..41c91f3 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -339,18 +339,6 @@ static int omap_aes_dma_init(struct omap_aes_dev *dd)
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
@@ -443,6 +431,12 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
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
@@ -451,6 +445,12 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm, dma_addr_t dma_addr_in,
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
-- 
1.7.0.4

