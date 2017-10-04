From: sunil.m@techveda.org
Subject: [PATCH] staging: ccree: local variable "dev" not required
Date: Thu,  5 Oct 2017 00:42:10 +0530
Message-ID: <1507144330-1672-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

There is no need to create a local pointer variable "dev" and
pass it various API's, instead use plat_dev which is enumerated
by platform core on successful probe.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was tested and built(ARCH=arm) on staging-testing.
- No build issues reported, however it was not tested on
  real hardware.
---
 drivers/staging/ccree/ssi_driver.c | 63 +++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5f03c25..eb907ce 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -205,12 +205,11 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	struct ssi_drvdata *new_drvdata;
-	struct device *dev = &plat_dev->dev;
-	struct device_node *np = dev->of_node;
+	struct device_node *np = plat_dev->dev.of_node;
 	u32 signature_val;
 	int rc = 0;
 
-	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
+	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(*new_drvdata), GFP_KERNEL);
 	if (!new_drvdata) {
 		rc = -ENOMEM;
 		goto post_drvdata_err;
@@ -225,16 +224,16 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* First CC registers space */
 	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
 	/* Map registers space */
-	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
+	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev, req_mem_cc_regs);
 	if (IS_ERR(new_drvdata->cc_base)) {
-		dev_err(dev, "Failed to ioremap registers");
+		dev_err(&plat_dev->dev, "Failed to ioremap registers");
 		rc = PTR_ERR(new_drvdata->cc_base);
 		goto post_drvdata_err;
 	}
 
-	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
+	dev_dbg(&plat_dev->dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
 		req_mem_cc_regs);
-	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
+	dev_dbg(&plat_dev->dev, "CC registers mapped from %pa to 0x%p\n",
 		&req_mem_cc_regs->start, new_drvdata->cc_base);
 
 	cc_base = new_drvdata->cc_base;
@@ -242,120 +241,120 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* Then IRQ */
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
 	if (new_drvdata->irq < 0) {
-		dev_err(dev, "Failed getting IRQ resource\n");
+		dev_err(&plat_dev->dev, "Failed getting IRQ resource\n");
 		rc = new_drvdata->irq;
 		goto post_drvdata_err;
 	}
 
-	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
+	rc = devm_request_irq(&plat_dev->dev, new_drvdata->irq, cc_isr,
 			      IRQF_SHARED, "arm_cc7x", new_drvdata);
 	if (rc) {
-		dev_err(dev, "Could not register to interrupt %d\n",
+		dev_err(&plat_dev->dev, "Could not register to interrupt %d\n",
 			new_drvdata->irq);
 		goto post_drvdata_err;
 	}
-	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
+	dev_dbg(&plat_dev->dev, "Registered to IRQ: %d\n", new_drvdata->irq);
 
 	rc = cc_clk_on(new_drvdata);
 	if (rc)
 		goto post_drvdata_err;
 
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
+	if (!plat_dev->dev.dma_mask)
+		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
 
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+	if (!plat_dev->dev.coherent_dma_mask)
+              plat_dev->dev.coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
 	if (signature_val != DX_DEV_SIGNATURE) {
-		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+		dev_err(&plat_dev->dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
 			signature_val, (u32)DX_DEV_SIGNATURE);
 		rc = -EINVAL;
 		goto post_clk_err;
 	}
-	dev_dbg(dev, "CC SIGNATURE=0x%08X\n", signature_val);
+	dev_dbg(&plat_dev->dev, "CC SIGNATURE=0x%08X\n", signature_val);
 
 	/* Display HW versions */
-	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
+	dev_info(&plat_dev->dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
 		 SSI_DEV_NAME_STR,
 		 CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)),
 		 DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "init_cc_regs failed\n");
+		dev_err(&plat_dev->dev, "init_cc_regs failed\n");
 		goto post_clk_err;
 	}
 
 #ifdef ENABLE_CC_SYSFS
-	rc = ssi_sysfs_init(&dev->kobj, new_drvdata);
+	rc = ssi_sysfs_init(&plat_dev->dev.kobj, new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "init_stat_db failed\n");
+		dev_err(&plat_dev->dev, "init_stat_db failed\n");
 		goto post_regs_err;
 	}
 #endif
 
 	rc = ssi_fips_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "SSI_FIPS_INIT failed 0x%x\n", rc);
+		dev_err(&plat_dev->dev, "SSI_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
 	}
 	rc = ssi_sram_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_sram_mgr_init failed\n");
+		dev_err(&plat_dev->dev, "ssi_sram_mgr_init failed\n");
 		goto post_fips_init_err;
 	}
 
 	new_drvdata->mlli_sram_addr =
 		ssi_sram_mgr_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
 	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
-		dev_err(dev, "Failed to alloc MLLI Sram buffer\n");
+		dev_err(&plat_dev->dev, "Failed to alloc MLLI Sram buffer\n");
 		rc = -ENOMEM;
 		goto post_sram_mgr_err;
 	}
 
 	rc = request_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "request_mgr_init failed\n");
+		dev_err(&plat_dev->dev, "request_mgr_init failed\n");
 		goto post_sram_mgr_err;
 	}
 
 	rc = ssi_buffer_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "buffer_mgr_init failed\n");
+		dev_err(&plat_dev->dev, "buffer_mgr_init failed\n");
 		goto post_req_mgr_err;
 	}
 
 	rc = ssi_power_mgr_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_power_mgr_init failed\n");
+		dev_err(&plat_dev->dev, "ssi_power_mgr_init failed\n");
 		goto post_buf_mgr_err;
 	}
 
 	rc = ssi_ivgen_init(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_ivgen_init failed\n");
+		dev_err(&plat_dev->dev, "ssi_ivgen_init failed\n");
 		goto post_power_mgr_err;
 	}
 
 	/* Allocate crypto algs */
 	rc = ssi_ablkcipher_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_ablkcipher_alloc failed\n");
+		dev_err(&plat_dev->dev, "ssi_ablkcipher_alloc failed\n");
 		goto post_ivgen_err;
 	}
 
 	/* hash must be allocated before aead since hash exports APIs */
 	rc = ssi_hash_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_hash_alloc failed\n");
+		dev_err(&plat_dev->dev, "ssi_hash_alloc failed\n");
 		goto post_cipher_err;
 	}
 
 	rc = ssi_aead_alloc(new_drvdata);
 	if (unlikely(rc != 0)) {
-		dev_err(dev, "ssi_aead_alloc failed\n");
+		dev_err(&plat_dev->dev, "ssi_aead_alloc failed\n");
 		goto post_hash_err;
 	}
 
@@ -392,7 +391,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_clk_err:
 	cc_clk_off(new_drvdata);
 post_drvdata_err:
-	dev_err(dev, "ccree init error occurred!\n");
+	dev_err(&plat_dev->dev, "ccree init error occurred!\n");
 	return rc;
 }
 
-- 
1.9.1
