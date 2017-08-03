From: Mogens Lauridsen <mlauridsen171@gmail.com>
Subject: [PATCH] crypto: sahara - Fix dma unmap direction
Date: Thu,  3 Aug 2017 15:34:12 +0200
Message-ID: <20170803133412.14322-1-mlauridsen171@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Mogens Lauridsen <mlauridsen171@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38430 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbdHCNeX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 09:34:23 -0400
Received: by mail-wm0-f68.google.com with SMTP id y206so2194952wmd.5
        for <linux-crypto@vger.kernel.org>; Thu, 03 Aug 2017 06:34:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The direction used in dma_unmap_sg in aes calc is wrong.
This result in the cache not being invalidated correct when aes
calculation is done and result has been dma'ed to memory.
This is seen as sporadic wrong result from aes calc.

Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>
---
 drivers/crypto/sahara.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c2174ec88e2a..474da36bdd2c 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -543,10 +543,10 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 
 unmap_out:
 	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_TO_DEVICE);
+		DMA_FROM_DEVICE);
 unmap_in:
 	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
-		DMA_FROM_DEVICE);
+		DMA_TO_DEVICE);
 
 	return -EINVAL;
 }
@@ -594,9 +594,9 @@ static int sahara_aes_process(struct ablkcipher_request *req)
 	}
 
 	dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
-		DMA_TO_DEVICE);
-	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
 		DMA_FROM_DEVICE);
+	dma_unmap_sg(dev->device, dev->in_sg, dev->nb_in_sg,
+		DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
2.13.4
