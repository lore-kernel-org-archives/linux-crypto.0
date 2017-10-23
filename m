From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 1/3] crypto: atmel-aes/tdes/sha - return appropriate error code
Date: Mon, 23 Oct 2017 18:34:39 +0300
Message-ID: <20171023153441.28825-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53762 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbdJWPeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 11:34:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return -ENODEV when dma_request_slave_channel_compat() fails.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c  | 3 +--
 drivers/crypto/atmel-sha.c  | 3 +--
 drivers/crypto/atmel-tdes.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 903fd43..9659759 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2383,7 +2383,6 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
 			      struct crypto_platform_data *pdata)
 {
 	struct at_dma_slave *slave;
-	int err = -ENOMEM;
 	dma_cap_mask_t mask;
 
 	dma_cap_zero(mask);
@@ -2408,7 +2407,7 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
 	dma_release_channel(dd->src.chan);
 err_dma_in:
 	dev_warn(dd->dev, "no DMA channel available\n");
-	return err;
+	return -ENODEV;
 }
 
 static void atmel_aes_dma_cleanup(struct atmel_aes_dev *dd)
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 3e2f41b..42c1f74 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2628,7 +2628,6 @@ static bool atmel_sha_filter(struct dma_chan *chan, void *slave)
 static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
 				struct crypto_platform_data *pdata)
 {
-	int err = -ENOMEM;
 	dma_cap_mask_t mask_in;
 
 	/* Try to grab DMA channel */
@@ -2639,7 +2638,7 @@ static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
 			atmel_sha_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
 	if (!dd->dma_lch_in.chan) {
 		dev_warn(dd->dev, "no DMA channel available\n");
-		return err;
+		return -ENODEV;
 	}
 
 	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index f4b335d..0ece4b8 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -720,7 +720,6 @@ static bool atmel_tdes_filter(struct dma_chan *chan, void *slave)
 static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 			struct crypto_platform_data *pdata)
 {
-	int err = -ENOMEM;
 	dma_cap_mask_t mask;
 
 	dma_cap_zero(mask);
@@ -765,7 +764,7 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 	dma_release_channel(dd->dma_lch_in.chan);
 err_dma_in:
 	dev_warn(dd->dev, "no DMA channel available\n");
-	return err;
+	return -ENODEV;
 }
 
 static void atmel_tdes_dma_cleanup(struct atmel_tdes_dev *dd)
-- 
2.9.4
