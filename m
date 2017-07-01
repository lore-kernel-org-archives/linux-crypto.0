From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 04/10] staging: ccree: Fix alignment issues in ssi_driver.c
Date: Sun,  2 Jul 2017 01:25:49 +0200
Message-ID: <20170701232555.5538-5-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33659 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdGAX0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:32 -0400
Received: by mail-lf0-f41.google.com with SMTP id z78so44764649lff.0
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:31 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_driver.c | 40 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 78709b92736d..e26cf174cf2b 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -85,8 +85,7 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 		return;
 	}
 
-	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ",
-		name, size);
+	ret = snprintf(line_buf, sizeof(line_buf), "%s[%lu]: ", name, size);
 	if (ret < 0) {
 		SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
 		return;
@@ -95,8 +94,8 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 	for (i = 0, cur_byte = the_array;
 	     (i < size) && (line_offset < sizeof(line_buf)); i++, cur_byte++) {
 			ret = snprintf(line_buf + line_offset,
-					sizeof(line_buf) - line_offset,
-					"0x%02X ", *cur_byte);
+				       sizeof(line_buf) - line_offset,
+				       "0x%02X ", *cur_byte);
 		if (ret < 0) {
 			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
 			return;
@@ -193,11 +192,11 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 #ifdef DX_IRQ_DELAY
 	/* Set CC IRQ delay */
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL),
-		DX_IRQ_DELAY);
+			      DX_IRQ_DELAY);
 #endif
 	if (CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)) > 0) {
 		SSI_LOG_DEBUG("irq_delay=%d CC cycles\n",
-			CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)));
+			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)));
 	}
 #endif
 
@@ -252,9 +251,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto init_cc_res_err;
 	}
 	SSI_LOG_DEBUG("Got MEM resource (%s): start=0x%llX end=0x%llX\n",
-		new_drvdata->res_mem->name,
-		(unsigned long long)new_drvdata->res_mem->start,
-		(unsigned long long)new_drvdata->res_mem->end);
+		      new_drvdata->res_mem->name,
+		      (unsigned long long)new_drvdata->res_mem->start,
+		      (unsigned long long)new_drvdata->res_mem->end);
 	/* Map registers space */
 	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
 	if (unlikely(!req_mem_cc_regs)) {
@@ -266,7 +265,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_base = ioremap(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem));
 	if (unlikely(!cc_base)) {
 		SSI_LOG_ERR("ioremap[CC](0x%08X,0x%08X) failed\n",
-			(unsigned int)new_drvdata->res_mem->start, (unsigned int)resource_size(new_drvdata->res_mem));
+			    (unsigned int)new_drvdata->res_mem->start,
+			    (unsigned int)resource_size(new_drvdata->res_mem));
 		rc = -ENOMEM;
 		goto init_cc_res_err;
 	}
@@ -284,15 +284,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 			 IRQF_SHARED, "arm_cc7x", new_drvdata);
 	if (unlikely(rc != 0)) {
 		SSI_LOG_ERR("Could not register to interrupt %llu\n",
-			(unsigned long long)new_drvdata->res_irq->start);
+			    (unsigned long long)new_drvdata->res_irq->start);
 		goto init_cc_res_err;
 	}
 	init_completion(&new_drvdata->icache_setup_completion);
 
 	irq_registered = true;
 	SSI_LOG_DEBUG("Registered to IRQ (%s) %llu\n",
-		new_drvdata->res_irq->name,
-		(unsigned long long)new_drvdata->res_irq->start);
+		      new_drvdata->res_irq->name,
+		      (unsigned long long)new_drvdata->res_irq->start);
 
 	new_drvdata->plat_dev = plat_dev;
 
@@ -313,7 +313,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
 	if (signature_val != DX_DEV_SIGNATURE) {
 		SSI_LOG_ERR("Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
-			signature_val, (u32)DX_DEV_SIGNATURE);
+			    signature_val, (u32)DX_DEV_SIGNATURE);
 		rc = -EINVAL;
 		goto init_cc_res_err;
 	}
@@ -428,7 +428,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 				new_drvdata->cc_base = NULL;
 			}
 			release_mem_region(new_drvdata->res_mem->start,
-				resource_size(new_drvdata->res_mem));
+					   resource_size(new_drvdata->res_mem));
 			new_drvdata->res_mem = NULL;
 		}
 		kfree(new_drvdata);
@@ -471,7 +471,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	if (drvdata->cc_base) {
 		iounmap(drvdata->cc_base);
 		release_mem_region(drvdata->res_mem->start,
-			resource_size(drvdata->res_mem));
+				   resource_size(drvdata->res_mem));
 		drvdata->cc_base = NULL;
 		drvdata->res_mem = NULL;
 	}
@@ -516,12 +516,12 @@ static int cc7x_probe(struct platform_device *plat_dev)
 	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
 	cacheline_size =  4 << ((ctr >> 16) & 0xf);
 	SSI_LOG_DEBUG("CP15(L1_CACHE_BYTES) = %u , Kconfig(L1_CACHE_BYTES) = %u\n",
-		cacheline_size, L1_CACHE_BYTES);
+		      cacheline_size, L1_CACHE_BYTES);
 
 	asm volatile("mrc p15, 0, %0, c0, c0, 0" : "=r" (ctr));
-	SSI_LOG_DEBUG("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X,"
-		     " Part 0x%03X, Rev r%dp%d\n",
-		(ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF, (ctr >> 20) & 0xF, ctr & 0xF);
+	SSI_LOG_DEBUG("Main ID register (MIDR): Implementer 0x%02X, Arch 0x%01X, Part 0x%03X, Rev r%dp%d\n",
+		      (ctr >> 24), (ctr >> 16) & 0xF, (ctr >> 4) & 0xFFF,
+		      (ctr >> 20) & 0xF, ctr & 0xF);
 #endif
 
 	/* Map registers space */
-- 
2.11.0
