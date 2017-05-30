From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 17/27] Drivers: ccree: ssi_driver.h - align block comments
Date: Tue, 30 May 2017 18:14:38 +1200
Message-ID: <20170530061438.13768-1-robsonde@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Derek Robson <robsonde@gmail.com>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33216 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbdE3GOt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:14:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_driver.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 45fc23fe169f..e034b0987137 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -15,7 +15,7 @@
  */
 
 /* \file ssi_driver.h
-   ARM CryptoCell Linux Crypto Driver
+ * ARM CryptoCell Linux Crypto Driver
  */
 
 #ifndef __SSI_DRIVER_H__
@@ -86,7 +86,8 @@
 #define NS_BIT 1
 #define AXI_ID 0
 /* AXI_ID is not actually the AXI ID of the transaction but the value of AXI_ID
-   field in the HW descriptor. The DMA engine +8 that value. */
+ * field in the HW descriptor. The DMA engine +8 that value.
+ */
 
 /* Logging macros */
 #define SSI_LOG(level, format, ...) \
@@ -108,9 +109,11 @@
 struct ssi_crypto_req {
 	void (*user_cb)(struct device *dev, void *req, void __iomem *cc_base);
 	void *user_arg;
-	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES]; /* For the first 'ivgen_dma_addr_len' addresses of this array,
-					 generated IV would be placed in it by send_request().
-					 Same generated IV for all addresses! */
+	dma_addr_t ivgen_dma_addr[SSI_MAX_IVGEN_DMA_ADDRESSES];
+	/* For the first 'ivgen_dma_addr_len' addresses of this array,
+ 	 * generated IV would be placed in it by send_request().
+ 	 * Same generated IV for all addresses!
+ 	 */
 	unsigned int ivgen_dma_addr_len; /* Amount of 'ivgen_dma_addr' elements to be filled. */
 	unsigned int ivgen_size; /* The generated IV size required, 8/16 B allowed. */
 	struct completion seq_compl; /* request completion */
@@ -136,7 +139,8 @@ struct ssi_drvdata {
 	u32 irq_mask;
 	u32 fw_ver;
 	/* Calibration time of start/stop
-	*  monitor descriptors */
+	 * monitor descriptors
+	 */
 	u32 monitor_null_cycles;
 	struct platform_device *plat_dev;
 	ssi_sram_addr_t mlli_sram_addr;
-- 
2.13.0
