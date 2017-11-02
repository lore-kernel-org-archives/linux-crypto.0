From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/3] staging: ccree: handle limiting of DMA masks
Date: Thu,  2 Nov 2017 08:10:22 +0000
Message-ID: <1509610224-14708-3-git-send-email-gilad@benyossef.com>
References: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Properly handle limiting of DMA masks based on device and bus
capabilities.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5f03c25..1d4c7bb 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -208,6 +208,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
+	dma_addr_t dma_mask;
 	int rc = 0;
 
 	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
@@ -256,15 +257,29 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
 
+	if (!plat_dev->dev.dma_mask)
+		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
+
+	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
+	while (dma_mask > 0x7fffffffUL) {
+		if (dma_supported(&plat_dev->dev, dma_mask)) {
+			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
+			if (!rc)
+				break;
+		}
+		dma_mask >>= 1;
+	}
+
+	if (rc) {
+		dev_err(dev, "Error: failed in dma_set_mask, mask=%par\n",
+			&dma_mask);
+		goto post_drvdata_err;
+	}
+
 	rc = cc_clk_on(new_drvdata);
 	if (rc)
 		goto post_drvdata_err;
 
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
-- 
2.7.4
