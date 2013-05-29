From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 4/4] crypto: dcp: Staticize local symbols
Date: Wed, 29 May 2013 17:09:12 +0530
Message-ID: <1369827552-28373-4-git-send-email-sachin.kamat@linaro.org>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, tobias.rauter@gmail.com,
	sachin.kamat@linaro.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51825 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab3E2LxS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 07:53:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so9049088pbb.5
        for <linux-crypto@vger.kernel.org>; Wed, 29 May 2013 04:53:18 -0700 (PDT)
In-Reply-To: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These symbols are referenced only in this file and hence
should be static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/crypto/dcp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/dcp.c b/drivers/crypto/dcp.c
index 49dd560..a8a7dd4 100644
--- a/drivers/crypto/dcp.c
+++ b/drivers/crypto/dcp.c
@@ -195,7 +195,7 @@ struct dcp_hw_packet {
 	uint32_t stat;
 };
 
-struct dcp_dev *global_dev;
+static struct dcp_dev *global_dev;
 
 static inline u32 dcp_chan_reg(u32 reg, int chan)
 {
@@ -227,14 +227,14 @@ static inline unsigned int dcp_read(struct dcp_dev *dev, u32 reg)
 	return readl(dev->dcp_regs_base + reg);
 }
 
-void dcp_dma_unmap(struct dcp_dev *dev, struct dcp_hw_packet *pkt)
+static void dcp_dma_unmap(struct dcp_dev *dev, struct dcp_hw_packet *pkt)
 {
 	dma_unmap_page(dev->dev, pkt->src, pkt->size, DMA_TO_DEVICE);
 	dma_unmap_page(dev->dev, pkt->dst, pkt->size, DMA_FROM_DEVICE);
 	dev_dbg(dev->dev, "unmap packet %x", (unsigned int) pkt);
 }
 
-int dcp_dma_map(struct dcp_dev *dev,
+static int dcp_dma_map(struct dcp_dev *dev,
 	struct ablkcipher_walk *walk, struct dcp_hw_packet *pkt)
 {
 	dev_dbg(dev->dev, "map packet %x", (unsigned int) pkt);
@@ -413,7 +413,7 @@ static void dcp_done_task(unsigned long data)
 	tasklet_schedule(&dev->queue_task);
 }
 
-void dcp_watchdog(unsigned long data)
+static void dcp_watchdog(unsigned long data)
 {
 	struct dcp_dev *dev = (struct dcp_dev *)data;
 	dev->ctx->stat |= dcp_read(dev,
-- 
1.7.9.5
