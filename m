From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 1/1] crypto: omap-sham: Adjust DMA parameters
Date: Thu,  2 Sep 2010 17:17:35 +0300
Message-ID: <018d83bcce6fea623a9c7d19b3739ec7b54610c5.1283436919.git.dmitry.kasatkin@nokia.com>
References: <cover.1283436919.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Samu Onkalo <samu.p.onkalo@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:65463 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0IBORq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Sep 2010 10:17:46 -0400
In-Reply-To: <cover.1283436919.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1283436919.git.dmitry.kasatkin@nokia.com>
References: <cover.1283436919.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Samu Onkalo <samu.p.onkalo@nokia.com>

DMA is set to use burst mode also for source channel. It should
descrease memory bandwidth needs.

DMA synchronization is set to use prefetch mechanism. SHAM block is behind
L4 bus and it doesn't have fifo. SHAM block is stalling as long as the new
data is available. It takes time to fetch data from memory and transfer it
via L4 bus. With prefetch enabled, data is waiting in DMA fifo and SHAM block
receives new data block faster.
This increases SHA processing speed up to 30 percent depending on the
bus / memory load.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 7d14856..a081c7c 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -311,7 +311,8 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 	len32 = DIV_ROUND_UP(length, sizeof(u32));
 
 	omap_set_dma_transfer_params(dd->dma_lch, OMAP_DMA_DATA_TYPE_S32, len32,
-			1, OMAP_DMA_SYNC_PACKET, dd->dma, OMAP_DMA_DST_SYNC);
+			1, OMAP_DMA_SYNC_PACKET, dd->dma,
+				OMAP_DMA_DST_SYNC_PREFETCH);
 
 	omap_set_dma_src_params(dd->dma_lch, 0, OMAP_DMA_AMODE_POST_INC,
 				dma_addr, 0, 0);
@@ -1072,6 +1073,9 @@ static int omap_sham_dma_init(struct omap_sham_dev *dd)
 	omap_set_dma_dest_burst_mode(dd->dma_lch,
 			OMAP_DMA_DATA_BURST_16);
 
+	omap_set_dma_src_burst_mode(dd->dma_lch,
+			OMAP_DMA_DATA_BURST_4);
+
 	return 0;
 }
 
-- 
1.7.0.4
