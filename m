From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/3] staging: ccree: simplify registers access
Date: Mon,  6 Nov 2017 06:55:51 +0000
Message-ID: <1509951354-16370-3-git-send-email-gilad@benyossef.com>
References: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The register offset calculation macro was taking a HW block base
parameter that was not actually used. Simplify the whole thing
by dropping it and rename the macro for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_regs.h         | 15 ++++--------
 drivers/staging/ccree/ssi_driver.c      | 42 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_fips.c        | 10 ++++----
 drivers/staging/ccree/ssi_pm.c          |  4 ++--
 drivers/staging/ccree/ssi_request_mgr.c | 33 +++++++++++++-------------
 drivers/staging/ccree/ssi_sysfs.c       | 10 ++++----
 6 files changed, 53 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
index 4a893a6..2a8fc73 100644
--- a/drivers/staging/ccree/cc_regs.h
+++ b/drivers/staging/ccree/cc_regs.h
@@ -25,18 +25,11 @@
 
 #include <linux/bitfield.h>
 
-#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
 #define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
+				    DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
+				    DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
 
-#define AXIM_MON_BASE_OFFSET CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_COMP)
-#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
-		DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
-
-/* Register Offset macro */
-#define CC_REG_OFFSET(unit_name, reg_name)               \
-	(DX_BASE_ ## unit_name + DX_ ## reg_name ## _REG_OFFSET)
+/* Register name mangling macro */
+#define CC_REG(reg_name) DX_ ## reg_name ## _REG_OFFSET
 
 #endif /*_CC_REGS_H_*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 135a7e2..1a9b9c9 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -99,22 +99,22 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
 
 	/* read the interrupt status */
-	irr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	irr = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
 	dev_dbg(dev, "Got IRR=0x%08X\n", irr);
 	if (unlikely(irr == 0)) { /* Probably shared interrupt line */
 		dev_err(dev, "Got interrupt with empty IRR\n");
 		return IRQ_NONE;
 	}
-	imr = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR));
+	imr = CC_HAL_READ_REGISTER(CC_REG(HOST_IMR));
 
 	/* clear interrupt - must be before processing events */
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), irr);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), irr);
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
 	if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
 		/* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_COMP_IRQ_MASK);
+		CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
 		irr &= ~SSI_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
@@ -122,7 +122,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	/* TEE FIPS interrupt */
 	if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
 		/* Mask interrupt - will be unmasked in Deferred service handler */
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
+		CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
 		irr &= ~SSI_GPR0_IRQ_MASK;
 		fips_handler(drvdata);
 	}
@@ -132,7 +132,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		u32 axi_err;
 
 		/* Read the AXI error ID */
-		axi_err = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+		axi_err = CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_ERR));
 		dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
 			axi_err);
 
@@ -155,43 +155,43 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* Unmask all AXI interrupt sources AXI_CFG1 register */
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG));
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
+	val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CFG));
+	CC_HAL_WRITE_REGISTER(CC_REG(AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
 	dev_dbg(dev, "AXIM_CFG=0x%08X\n",
-		CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CFG)));
+		CC_HAL_READ_REGISTER(CC_REG(AXIM_CFG)));
 
 	/* Clear all pending interrupts */
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	val = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
 	dev_dbg(dev, "IRR=0x%08X\n", val);
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), val);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), val);
 
 	/* Unmask relevant interrupt cause */
 	val = (unsigned int)(~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK |
 			       SSI_GPR0_IRQ_MASK));
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), val);
 
 #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
 #ifdef DX_IRQ_DELAY
 	/* Set CC IRQ delay */
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL),
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL),
 			      DX_IRQ_DELAY);
 #endif
-	if (CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)) > 0) {
+	if (CC_HAL_READ_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL)) > 0) {
 		dev_dbg(dev, "irq_delay=%d CC cycles\n",
-			CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRQ_TIMER_INIT_VAL)));
+			CC_HAL_READ_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL)));
 	}
 #endif
 
 	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
 
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CACHE_PARAMS));
 
 	if (is_probe)
 		dev_info(dev, "Cache params previous: 0x%08X\n", val);
 
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS),
+	CC_HAL_WRITE_REGISTER(CC_REG(AXIM_CACHE_PARAMS),
 			      cache_params);
-	val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_CACHE_PARAMS));
+	val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CACHE_PARAMS));
 
 	if (is_probe)
 		dev_info(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
@@ -280,7 +280,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	/* Verify correct mapping */
-	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
+	signature_val = CC_HAL_READ_REGISTER(CC_REG(HOST_SIGNATURE));
 	if (signature_val != DX_DEV_SIGNATURE) {
 		dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
 			signature_val, (u32)DX_DEV_SIGNATURE);
@@ -292,7 +292,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	/* Display HW versions */
 	dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
 		 SSI_DEV_NAME_STR,
-		 CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_VERSION)),
+		 CC_HAL_READ_REGISTER(CC_REG(HOST_VERSION)),
 		 DRV_MODULE_VERSION);
 
 	rc = init_cc_regs(new_drvdata, true);
@@ -411,7 +411,7 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 {
 	/* Mask all interrupts */
 	WRITE_REGISTER(drvdata->cc_base +
-		       CC_REG_OFFSET(HOST_RGF, HOST_IMR), 0xFFFFFFFF);
+		       CC_REG(HOST_IMR), 0xFFFFFFFF);
 }
 
 static void cleanup_cc_resources(struct platform_device *plat_dev)
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 15009a2..d424aef 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -36,7 +36,7 @@ static bool cc_get_tee_fips_status(struct ssi_drvdata *drvdata)
 	u32 reg;
 	void __iomem *cc_base = drvdata->cc_base;
 
-	reg = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
+	reg = CC_HAL_READ_REGISTER(CC_REG(GPR_HOST));
 	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
 }
 
@@ -51,7 +51,7 @@ void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool status)
 
 	val |= (status ? CC_FIPS_SYNC_MODULE_OK : CC_FIPS_SYNC_MODULE_ERROR);
 
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_GPR0), val);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_GPR0), val);
 }
 
 void ssi_fips_fini(struct ssi_drvdata *drvdata)
@@ -95,7 +95,7 @@ static void fips_dsr(unsigned long devarg)
 	irq = (drvdata->irq & (SSI_GPR0_IRQ_MASK));
 
 	if (irq) {
-		state = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, GPR_HOST));
+		state = CC_HAL_READ_REGISTER(CC_REG(GPR_HOST));
 
 		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
 			tee_fips_error(dev);
@@ -104,8 +104,8 @@ static void fips_dsr(unsigned long devarg)
 	/* after verifing that there is nothing to do,
 	 * unmask AXI completion interrupt.
 	 */
-	val = (CC_REG_OFFSET(HOST_RGF, HOST_IMR) & ~irq);
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR), val);
+	val = (CC_REG(HOST_IMR) & ~irq);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), val);
 }
 
 /* The function called once at driver entry point .*/
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 11bbdbe..73b31cd 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -41,7 +41,7 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
+	WRITE_REGISTER(drvdata->cc_base + CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
 	if (rc != 0) {
 		dev_err(dev, "ssi_request_mgr_runtime_suspend_queue (%x)\n",
@@ -60,7 +60,7 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 		(struct ssi_drvdata *)dev_get_drvdata(dev);
 
 	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
-	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+	WRITE_REGISTER(drvdata->cc_base + CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
 
 	rc = cc_clk_on(drvdata);
 	if (rc) {
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 942afe2..2f12ee2 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -123,7 +123,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	tasklet_init(&req_mgr_h->comptask, comp_handler, (unsigned long)drvdata);
 #endif
 	req_mgr_h->hw_queue_size = READ_REGISTER(drvdata->cc_base +
-		CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_SRAM_SIZE));
+		CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
 	dev_dbg(dev, "hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
 	if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
 		dev_err(dev, "Invalid HW queue size = %u (Min. required is %u)\n",
@@ -167,13 +167,13 @@ static inline void enqueue_seq(
 	int i;
 
 	for (i = 0; i < seq_len; i++) {
-		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 		wmb();
-		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base + CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 #ifdef DX_DUMP_DESCS
 		dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			i, seq[i].word[0], seq[i].word[1], seq[i].word[2],
@@ -222,8 +222,7 @@ static inline int request_mgr_queues_status_check(
 	/* Wait for space in HW queue. Poll constant num of iterations. */
 	for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
 		req_mgr_h->q_free_slots =
-			CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL,
-							   DSCRPTR_QUEUE_CONTENT));
+			CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
 		if (unlikely(req_mgr_h->q_free_slots <
 						req_mgr_h->min_free_hw_slots)) {
 			req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
@@ -422,8 +421,8 @@ int send_request_init(
 	enqueue_seq(cc_base, desc, len);
 
 	/* Update the free slots in HW queue */
-	req_mgr_h->q_free_slots = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL,
-								     DSCRPTR_QUEUE_CONTENT));
+	req_mgr_h->q_free_slots =
+		CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
 
 	return 0;
 }
@@ -487,7 +486,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 
 			dev_info(dev, "Delay\n");
 			for (i = 0; i < 1000000; i++)
-				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+				axi_err = READ_REGISTER(drvdata->cc_base + CC_REG(AXIM_MON_ERR));
 		}
 #endif /* COMPLETION_DELAY */
 
@@ -514,7 +513,7 @@ static inline u32 cc_axi_comp_count(void __iomem *cc_base)
 	 * a base MMIO register address variable named cc_base.
 	 */
 	return FIELD_GET(AXIM_MON_COMP_VALUE,
-			 CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
+			 CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_COMP)));
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
@@ -531,7 +530,7 @@ static void comp_handler(unsigned long devarg)
 
 	if (irq & SSI_COMP_IRQ_MASK) {
 		/* To avoid the interrupt from firing as we unmask it, we clear it now */
-		CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
+		CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
 
 		/* Avoid race with above clear: Test completion counter once more */
 		request_mgr_handle->axi_completed +=
@@ -548,7 +547,7 @@ static void comp_handler(unsigned long devarg)
 			} while (request_mgr_handle->axi_completed > 0);
 
 			/* To avoid the interrupt from firing as we unmask it, we clear it now */
-			CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_ICR), SSI_COMP_IRQ_MASK);
+			CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
 
 			/* Avoid race with above clear: Test completion counter once more */
 			request_mgr_handle->axi_completed +=
@@ -556,8 +555,8 @@ static void comp_handler(unsigned long devarg)
 		}
 	}
 	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
-	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
-			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
+	CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR),
+			      CC_HAL_READ_REGISTER(CC_REG(HOST_IMR)) & ~irq);
 }
 
 /*
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index c3c817a..b5bc5f8 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -32,15 +32,15 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 	void __iomem *cc_base = drvdata->cc_base;
 	int offset = 0;
 
-	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
+	register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_SIGNATURE));
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
-	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
+	register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
-	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN));
+	register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_POWER_DOWN_EN));
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
-	register_value =  CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
+	register_value =  CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_ERR));
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
-	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_CONTENT));
+	register_value = CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
 	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
 	return offset;
 }
-- 
2.7.4
