From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 11/22] staging: ccree: fix line indentation and breaks
Date: Tue, 15 Aug 2017 09:26:39 +0300
Message-ID: <1502778412-16255-12-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fix wrong indentation and line breaks, including missing tabs,
breaking lines longer then 80 char or wrongly broken.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 107 +++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 81cb63d..0ce2f57 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -87,27 +87,31 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 
 	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ", name, size);
 	if (ret < 0) {
-		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
+		SSI_LOG_ERR
+		    ("snprintf returned %d . aborting buffer array dump\n",
+		     ret);
 		return;
 	}
 	line_offset = ret;
 	for (i = 0, cur_byte = the_array;
 	     (i < size) && (line_offset < sizeof(line_buf)); i++, cur_byte++) {
-			ret = snprintf(line_buf + line_offset,
-				       sizeof(line_buf) - line_offset,
-				       "0x%02X ", *cur_byte);
+		ret = snprintf(line_buf + line_offset,
+			       sizeof(line_buf) - line_offset,
+			       "0x%02X ", *cur_byte);
 		if (ret < 0) {
-			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
+			SSI_LOG_ERR
+			    ("snprintf returned %d . aborting buffer array dump\n",
+			     ret);
 			return;
 		}
 		line_offset += ret;
-		if (line_offset > 75) { /* Cut before line end */
+		if (line_offset > 75) {	/* Cut before line end */
 			SSI_LOG_DEBUG("%s\n", line_buf);
 			line_offset = 0;
 		}
 	}
 
-	if (line_offset > 0) /* Dump remaining line */
+	if (line_offset > 0)	/* Dump remaining line */
 		SSI_LOG_DEBUG("%s\n", line_buf);
 }
 #endif
@@ -124,7 +128,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* read the interrupt status */
 	irr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
 	SSI_LOG_DEBUG("Got IRR=0x%08X\n", irr);
-	if (unlikely(irr == 0)) { /* Probably shared interrupt line */
+	if (unlikely(irr == 0)) {	/* Probably shared interrupt line */
 		SSI_LOG_ERR("Got interrupt with empty IRR\n");
 		return IRQ_NONE;
 	}
@@ -137,7 +141,8 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* Completion interrupt - most probable */
 	if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
 		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_COMP_IRQ_MASK);
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
+				      imr | SSI_COMP_IRQ_MASK);
 		irr &= ~SSI_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
@@ -145,7 +150,8 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* TEE FIPS interrupt */
 	if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
 		/* Mask interrupt - will be unmasked in Deferred service handler */
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
+		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
+				      imr | SSI_GPR0_IRQ_MASK);
 		irr &= ~SSI_GPR0_IRQ_MASK;
 		fips_handler(drvdata);
 	}
@@ -155,14 +161,18 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		u32 axi_err;
 
 		/* Read the AXI error ID */
-		axi_err = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
-		SSI_LOG_DEBUG("AXI completion error: axim_mon_err=0x%08X\n", axi_err);
+		axi_err =
+		    CC_HAL_READ_REGISTER(CC_REG_OFFSET
+					 (CRY_KERNEL, AXIM_MON_ERR));
+		SSI_LOG_DEBUG("AXI completion error: axim_mon_err=0x%08X\n",
+			      axi_err);
 
 		irr &= ~SSI_AXI_ERR_IRQ_MASK;
 	}
 
 	if (unlikely(irr != 0)) {
-		SSI_LOG_DEBUG("IRR includes unknown cause bits (0x%08X)\n", irr);
+		SSI_LOG_DEBUG("IRR includes unknown cause bits (0x%08X)\n",
+			      irr);
 		/* Just warning */
 	}
 
@@ -176,8 +186,11 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 
 	/* Unmask all AXI interrupt sources AXI_CFG1 register */
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG));
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
-	SSI_LOG_DEBUG("AXIM_CFG=0x%08X\n", CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG)));
+	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG),
+			      val & ~SSI_AXI_IRQ_MASK);
+	SSI_LOG_DEBUG("AXIM_CFG=0x%08X\n",
+		      CC_HAL_READ_REGISTER(CC_REG_OFFSET
+					   (CRY_KERNEL, AXIM_CFG)));
 
 	/* Clear all pending interrupts */
 	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
@@ -194,22 +207,27 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL),
 			      DX_IRQ_DELAY);
 #endif
-	if (CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)) > 0) {
+	if (CC_HAL_READ_REGISTER
+	    (CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)) > 0) {
 		SSI_LOG_DEBUG("irq_delay=%d CC cycles\n",
-			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)));
+			      CC_HAL_READ_REGISTER(CC_REG_OFFSET
+						   (HOST_RGF,
+						    HOST_IRQ_TIMER_INIT_VAL)));
 	}
 #endif
 
 	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
 
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	val =
+	    CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
 
 	if (is_probe)
 		SSI_LOG_INFO("Cache params previous: 0x%08X\n", val);
 
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS),
 			      cache_params);
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	val =
+	    CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
 
 	if (is_probe)
 		SSI_LOG_INFO("Cache params current: 0x%08X (expect: 0x%08X)\n",
@@ -282,31 +300,37 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_drvdata_err;
 
 	if (!new_drvdata->plat_dev->dev.dma_mask)
-		new_drvdata->plat_dev->dev.dma_mask = &new_drvdata->plat_dev->dev.coherent_dma_mask;
+		new_drvdata->plat_dev->dev.dma_mask =
+		    &new_drvdata->plat_dev->dev.coherent_dma_mask;
 
 	if (!new_drvdata->plat_dev->dev.coherent_dma_mask)
-		new_drvdata->plat_dev->dev.coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+		new_drvdata->plat_dev->dev.coherent_dma_mask =
+		    DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 
 	/* Verify correct mapping */
-	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
+	signature_val =
+	    CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
 	if (signature_val != DX_DEV_SIGNATURE) {
-		SSI_LOG_ERR("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-			    signature_val, (u32)DX_DEV_SIGNATURE);
+		SSI_LOG_ERR
+		    ("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
+		     signature_val, (u32)DX_DEV_SIGNATURE);
 		rc = -EINVAL;
 		goto post_clk_err;
 	}
 	SSI_LOG_DEBUG("CC SIGNATURE=0x%08X\n", signature_val);
 
 	/* Display HW versions */
-	SSI_LOG(KERN_INFO, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n", SSI_DEV_NAME_STR,
-		CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)), DRV_MODULE_VERSION);
+	SSI_LOG(KERN_INFO,
+		"ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
+		SSI_DEV_NAME_STR,
+		CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)),
+		DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("init_cc_regs failed\n");
 		goto post_clk_err;
 	}
-
 #ifdef ENABLE_CC_SYSFS
 	rc = ssi_sysfs_init(&plat_dev->dev.kobj, new_drvdata);
 	if (unlikely(rc != 0)) {
@@ -327,7 +351,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	new_drvdata->mlli_sram_addr =
-		ssi_sram_mgr_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
+	    ssi_sram_mgr_alloc(new_drvdata, MAX_MLLI_BUFF_SIZE);
 	if (unlikely(new_drvdata->mlli_sram_addr == NULL_SRAM_ADDR)) {
 		SSI_LOG_ERR("Failed to alloc MLLI Sram buffer\n");
 		rc = -ENOMEM;
@@ -395,7 +419,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_power_mgr_err:
 	ssi_power_mgr_fini(new_drvdata);
 post_buf_mgr_err:
-	 ssi_buffer_mgr_fini(new_drvdata);
+	ssi_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
 	request_mgr_fini(new_drvdata);
 post_sram_mgr_err:
@@ -426,7 +450,7 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 static void cleanup_cc_resources(struct platform_device *plat_dev)
 {
 	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
+	    (struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
 
 	ssi_aead_free(drvdata);
 	ssi_hash_free(drvdata);
@@ -478,15 +502,17 @@ static int cc7x_probe(struct platform_device *plat_dev)
 #if defined(CONFIG_ARM) && defined(CC_DEBUG)
 	u32 ctr, cacheline_size;
 
-	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
-	cacheline_size =  4 << ((ctr >> 16) & 0xf);
-	SSI_LOG_DEBUG("CP15(L1_CACHE_BYTES) = %u , Kconfig(L1_CACHE_BYTES) = %u\n",
-		      cacheline_size, L1_CACHE_BYTES);
-
-	asm volatile("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
-	SSI_LOG_DEBUG("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X, Part 0x%03X, Rev r%dp%d\n",
-		      (ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF,
-		      (ctr >> 20) & 0xF, ctr & 0xF);
+	asm volatile ("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	cacheline_size = 4 << ((ctr >> 16) & 0xf);
+	SSI_LOG_DEBUG
+	    ("CP15(L1_CACHE_BYTES) = %u , Kconfig(L1_CACHE_BYTES) = %u\n",
+	     cacheline_size, L1_CACHE_BYTES);
+
+	asm volatile ("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
+	SSI_LOG_DEBUG
+	    ("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X, Part 0x%03X, Rev r%dp%d\n",
+	     (ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF,
+	     (ctr >> 20) & 0xF, ctr & 0xF);
 #endif
 
 	/* Map registers space */
@@ -512,7 +538,8 @@ static int cc7x_remove(struct platform_device *plat_dev)
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 static struct dev_pm_ops arm_cc7x_driver_pm = {
-	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend,
+			   ssi_power_mgr_runtime_resume, NULL)
 };
 #endif
 
-- 
2.1.4
