From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 5/7] staging: ccree: add clock management support
Date: Thu, 22 Jun 2017 10:07:51 +0300
Message-ID: <1498115276-1601-6-git-send-email-gilad@benyossef.com>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some SoC which implement CryptoCell have a dedicated clock
tied to it, some do not. Implement clock support if exists
based on device tree data and tie power management to it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Makefile     |  2 +-
 drivers/staging/ccree/ssi_driver.c | 43 +++++++++++++++++++++++----
 drivers/staging/ccree/ssi_driver.h |  4 +++
 drivers/staging/ccree/ssi_pm.c     | 13 +++++----
 drivers/staging/ccree/ssi_pm_ext.c | 60 --------------------------------------
 drivers/staging/ccree/ssi_pm_ext.h | 33 ---------------------
 6 files changed, 50 insertions(+), 105 deletions(-)
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 delete mode 100644 drivers/staging/ccree/ssi_pm_ext.h

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index 44f3e3e..318c2b3 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o ssi_pm_ext.o
+ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
 ccree-$(CCREE_FIPS_SUPPORT) += ssi_fips.o ssi_fips_ll.o ssi_fips_ext.o ssi_fips_local.o
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5a62b4f..f1275a6 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -57,6 +57,7 @@
 #include <linux/sched.h>
 #include <linux/random.h>
 #include <linux/of.h>
+#include <linux/clk.h>
 
 #include "ssi_config.h"
 #include "ssi_driver.h"
@@ -269,6 +270,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	hw_rev = (struct cc_hw_data *)dev_id->data;
 	new_drvdata->hw_rev_name = hw_rev->name;
 	new_drvdata->hw_rev = hw_rev->rev;
+	new_drvdata->clk = of_clk_get(np, 0);
 
 	if (hw_rev->rev >= CC_HW_REV_712) {
 		new_drvdata->hash_len_sz = HASH_LEN_SIZE_712;
@@ -338,6 +340,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 
 	new_drvdata->plat_dev = plat_dev;
 
+	rc = cc_clk_on(new_drvdata);
+	if (rc)
+		goto init_cc_res_err;
+
 	if(new_drvdata->plat_dev->dev.dma_mask == NULL)
 	{
 		new_drvdata->plat_dev->dev.dma_mask = & new_drvdata->plat_dev->dev.coherent_dma_mask;
@@ -504,14 +510,11 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	ssi_sysfs_fini();
 #endif
 
-	/* Mask all interrupts */
-	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_IMR),
-		0xFFFFFFFF);
+	fini_cc_regs(drvdata);
+	cc_clk_off(drvdata);
 	free_irq(drvdata->res_irq->start, drvdata);
 	drvdata->res_irq = NULL;
 
-	fini_cc_regs(drvdata);
-
 	if (drvdata->cc_base != NULL) {
 		iounmap(drvdata->cc_base);
 		release_mem_region(drvdata->res_mem->start,
@@ -524,6 +527,36 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
+int cc_clk_on(struct ssi_drvdata *drvdata)
+{
+	int rc = 0;
+	struct clk *clk = drvdata->clk;
+
+	if (IS_ERR(clk))
+	/* No all devices have a clock associated with CCREE */
+		goto out;
+
+	rc = clk_prepare_enable(clk);
+	if (rc) {
+		SSI_LOG_ERR("error enabling clock\n");
+		clk_disable_unprepare(clk);
+	}
+
+out:
+	return rc;
+}
+
+void cc_clk_off(struct ssi_drvdata *drvdata)
+{
+	struct clk *clk = drvdata->clk;
+
+	if (IS_ERR(clk))
+		/* No all devices have a clock associated with CCREE */
+		return;
+
+	clk_disable_unprepare(clk);
+}
+
 static int ccree_probe(struct platform_device *plat_dev)
 {
 	int rc;
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 52ac43c..a59df59 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -36,6 +36,7 @@
 #include <crypto/authenc.h>
 #include <crypto/hash.h>
 #include <linux/version.h>
+#include <linux/clk.h>
 
 /* Registers definitions from shared/hw/ree_include */
 #include "dx_reg_base_host.h"
@@ -156,6 +157,7 @@ struct ssi_drvdata {
 	enum cc_hw_rev hw_rev;
 	u32 hash_len_sz;
 	u32 axim_mon_offset;
+	struct clk *clk;
 };
 
 struct ssi_crypto_alg {
@@ -201,6 +203,8 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size);
 
 int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct ssi_drvdata *drvdata);
+int cc_clk_on(struct ssi_drvdata *drvdata);
+void cc_clk_off(struct ssi_drvdata *drvdata);
 
 static inline void set_queue_last_ind(struct ssi_drvdata *drvdata,
 				      struct cc_hw_desc *pdesc)
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 5bfbdd0..67ae1dc 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -29,7 +29,6 @@
 #include "ssi_ivgen.h"
 #include "ssi_hash.h"
 #include "ssi_pm.h"
-#include "ssi_pm_ext.h"
 
 
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
@@ -52,9 +51,7 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 		return rc;
 	}
 	fini_cc_regs(drvdata);
-
-	/* Specific HW suspend code */
-	ssi_pm_ext_hw_suspend(dev);
+	cc_clk_off(drvdata);
 	return 0;
 }
 
@@ -66,8 +63,12 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 
 	SSI_LOG_DEBUG("ssi_power_mgr_runtime_resume , unset HOST_POWER_DOWN_EN\n");
 	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
-	/* Specific HW resume code */
-	ssi_pm_ext_hw_resume(dev);
+
+	rc = cc_clk_on(drvdata);
+	if (rc) {
+		SSI_LOG_ERR("failed getting clock back on. We're toast.\n");
+		return rc;
+	}
 
 	rc = init_cc_regs(drvdata, false);
 	if (rc !=0) {
diff --git a/drivers/staging/ccree/ssi_pm_ext.c b/drivers/staging/ccree/ssi_pm_ext.c
deleted file mode 100644
index 453151c..0000000
--- a/drivers/staging/ccree/ssi_pm_ext.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-
-#include "ssi_config.h"
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <crypto/ctr.h>
-#include <linux/pm_runtime.h>
-#include "ssi_driver.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_pm_ext.h"
-
-/*
- * This function should suspend the HW (if possiable), It should be implemented by
- * the driver user.
- * The reference code clears the internal SRAM to imitate lose of state.
- */
-void ssi_pm_ext_hw_suspend(struct device *dev)
-{
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(dev);
-	unsigned int val;
-	void __iomem *cc_base = drvdata->cc_base;
-	unsigned int  sram_addr = 0;
-
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_ADDR), sram_addr);
-
-	for (;sram_addr < SSI_CC_SRAM_SIZE ; sram_addr+=4) {
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_DATA), 0x0);
-
-		do {
-			val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, SRAM_DATA_READY));
-		} while (!(val &0x1));
-	}
-}
-
-/*
- * This function should resume the HW (if possiable).It should be implemented by
- * the driver user.
- */
-void ssi_pm_ext_hw_resume(struct device *dev)
-{
-	return;
-}
-
diff --git a/drivers/staging/ccree/ssi_pm_ext.h b/drivers/staging/ccree/ssi_pm_ext.h
deleted file mode 100644
index dbe658b..0000000
--- a/drivers/staging/ccree/ssi_pm_ext.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-/* \file ssi_pm_ext.h
- */
-
-#ifndef __PM_EXT_H__
-#define __PM_EXT_H__
-
-
-#include "ssi_config.h"
-#include "ssi_driver.h"
-
-void ssi_pm_ext_hw_suspend(struct device *dev);
-
-void ssi_pm_ext_hw_resume(struct device *dev);
-
-
-#endif /*__POWER_MGR_H__*/
-
-- 
2.1.4
