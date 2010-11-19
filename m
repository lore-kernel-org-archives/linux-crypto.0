From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 2/8] omap-sham: DMA initialization fixes for off mode
Date: Fri, 19 Nov 2010 16:04:23 +0200
Message-ID: <63992389ec0d39e7aee4b02e059c52dfeb985c17.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:58021 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab0KSOD5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Nov 2010 09:03:57 -0500
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DMA parameters for constant data were initialized during driver probe().
It seems that those settings sometimes are lost when devices goes to off mode.
This patch makes DMA initialization just before use.
It solves off mode problems.

Fixes: NB#202786 - Aegis & SHA1 block off mode changes

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 2222370..9dfbc4a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -318,6 +318,16 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
 				dma_addr, 0, 0);
 
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
 	err = omap_sham_write_ctrl(dd, length, final, 1);
 	if (err)
 		return err;
@@ -1071,15 +1081,6 @@ static int omap_sham_dma_init(struct omap_sham_dev *dd)
 		dev_err(dd->dev, "Unable to request DMA channel\n");
 		return err;
 	}
-	omap_set_dma_dest_params(dd->dma_lch, 0,
-			OMAP_DMA_AMODE_CONSTANT,
-			dd->phys_base + SHA_REG_DIN(0), 0, 16);
-
-	omap_set_dma_dest_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_16);
-
-	omap_set_dma_src_burst_mode(dd->dma_lch,
-			OMAP_DMA_DATA_BURST_4);
 
 	return 0;
 }
-- 
1.7.0.4
