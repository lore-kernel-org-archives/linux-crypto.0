From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/39] dmaengine: ste_dma40: Remove redundant address fetching function
Date: Wed, 15 May 2013 10:51:31 +0100
Message-ID: <1368611522-9984-9-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, vinod.koul@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39930 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab3EOJw2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 05:52:28 -0400
Received: by mail-wi0-f180.google.com with SMTP id hn14so1416428wib.7
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 02:52:26 -0700 (PDT)
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Addresses are now stored in local data structures and are easy to
obtain, thus a specialist function used to fetch them is now surplus
to requirement.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 57a127e..6ed7757 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2267,24 +2267,6 @@ err:
 	return NULL;
 }
 
-static dma_addr_t
-d40_get_dev_addr(struct d40_chan *chan, enum dma_transfer_direction direction)
-{
-	struct stedma40_platform_data *plat = chan->base->plat_data;
-	struct stedma40_chan_cfg *cfg = &chan->dma_cfg;
-	dma_addr_t addr = 0;
-
-	if (chan->runtime_addr)
-		return chan->runtime_addr;
-
-	if (direction == DMA_DEV_TO_MEM)
-		addr = plat->dev_rx[cfg->dev_type];
-	else if (direction == DMA_MEM_TO_DEV)
-		addr = plat->dev_tx[cfg->dev_type];
-
-	return addr;
-}
-
 static struct dma_async_tx_descriptor *
 d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	    struct scatterlist *sg_dst, unsigned int sg_len,
-- 
1.7.10.4
