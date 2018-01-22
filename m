From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 6/7] crypto: ccree: add FIPS support
Date: Mon, 22 Jan 2018 09:27:04 +0000
Message-ID: <1516613230-4524-7-git-send-email-gilad@benyossef.com>
References: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55460 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbeAVJ2C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jan 2018 04:28:02 -0500
In-Reply-To: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add FIPS mode support to CryptoCell driver

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/Makefile    |   1 +
 drivers/crypto/ccree/cc_driver.c |  29 +++++++++-
 drivers/crypto/ccree/cc_driver.h |   1 +
 drivers/crypto/ccree/cc_fips.c   | 111 +++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccree/cc_fips.h   |  37 +++++++++++++
 5 files changed, 177 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccree/cc_fips.c
 create mode 100644 drivers/crypto/ccree/cc_fips.h

diff --git a/drivers/crypto/ccree/Makefile b/drivers/crypto/ccree/Makefile
index 7cb3082..bdc2797 100644
--- a/drivers/crypto/ccree/Makefile
+++ b/drivers/crypto/ccree/Makefile
@@ -2,5 +2,6 @@
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
 ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_ivgen.o cc_sram_mgr.o
+ccree-$(CONFIG_CRYPTO_FIPS) += cc_fips.o
 ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
 ccree-$(CONFIG_PM) += cc_pm.o
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 8a530a4..827e329 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -25,6 +25,7 @@
 #include "cc_ivgen.h"
 #include "cc_sram_mgr.h"
 #include "cc_pm.h"
+#include "cc_fips.h"
 
 bool cc_dump_desc;
 module_param_named(dump_desc, cc_dump_desc, bool, 0600);
@@ -78,7 +79,17 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		irr &= ~CC_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
-
+#ifdef CONFIG_CRYPTO_FIPS
+	/* TEE FIPS interrupt */
+	if (irr & CC_GPR0_IRQ_MASK) {
+		/* Mask interrupt - will be unmasked in Deferred service
+		 * handler
+		 */
+		cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | CC_GPR0_IRQ_MASK);
+		irr &= ~CC_GPR0_IRQ_MASK;
+		fips_handler(drvdata);
+	}
+#endif
 	/* AXI error interrupt */
 	if (irr & CC_AXI_ERR_IRQ_MASK) {
 		u32 axi_err;
@@ -243,10 +254,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_regs_err;
 	}
 
+	rc = cc_fips_init(new_drvdata);
+	if (rc) {
+		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
+		goto post_debugfs_err;
+	}
 	rc = cc_sram_mgr_init(new_drvdata);
 	if (rc) {
 		dev_err(dev, "cc_sram_mgr_init failed\n");
-		goto post_debugfs_err;
+		goto post_fips_init_err;
 	}
 
 	new_drvdata->mlli_sram_addr =
@@ -301,6 +317,12 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_hash_err;
 	}
 
+	/* If we got here and FIPS mode is enabled
+	 * it means all FIPS test passed, so let TEE
+	 * know we're good.
+	 */
+	cc_set_ree_fips_status(new_drvdata, true);
+
 	return 0;
 
 post_hash_err:
@@ -317,6 +339,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_req_mgr_fini(new_drvdata);
 post_sram_mgr_err:
 	cc_sram_mgr_fini(new_drvdata);
+post_fips_init_err:
+	cc_fips_fini(new_drvdata);
 post_debugfs_err:
 	cc_debugfs_fini(new_drvdata);
 post_regs_err:
@@ -345,6 +369,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_buffer_mgr_fini(drvdata);
 	cc_req_mgr_fini(drvdata);
 	cc_sram_mgr_fini(drvdata);
+	cc_fips_fini(drvdata);
 	cc_debugfs_fini(drvdata);
 	fini_cc_regs(drvdata);
 	cc_clk_off(drvdata);
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 0109c64..9cc488f 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -116,6 +116,7 @@ struct cc_drvdata {
 	void *hash_handle;
 	void *aead_handle;
 	void *request_mgr_handle;
+	void *fips_handle;
 	void *ivgen_handle;
 	void *sram_mgr_handle;
 	void *debugfs;
diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
new file mode 100644
index 0000000..de08af9
--- /dev/null
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#include <linux/kernel.h>
+#include <linux/fips.h>
+
+#include "cc_driver.h"
+#include "cc_fips.h"
+
+static void fips_dsr(unsigned long devarg);
+
+struct cc_fips_handle {
+	struct tasklet_struct tasklet;
+};
+
+/* The function called once at driver entry point to check
+ * whether TEE FIPS error occurred.
+ */
+static bool cc_get_tee_fips_status(struct cc_drvdata *drvdata)
+{
+	u32 reg;
+
+	reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
+	return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
+}
+
+/*
+ * This function should push the FIPS REE library status towards the TEE library
+ * by writing the error state to HOST_GPR0 register.
+ */
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
+{
+	int val = CC_FIPS_SYNC_REE_STATUS;
+
+	val |= (status ? CC_FIPS_SYNC_MODULE_OK : CC_FIPS_SYNC_MODULE_ERROR);
+
+	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
+}
+
+void cc_fips_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_fips_handle *fips_h = drvdata->fips_handle;
+
+	if (!fips_h)
+		return; /* Not allocated */
+
+	/* Kill tasklet */
+	tasklet_kill(&fips_h->tasklet);
+
+	kfree(fips_h);
+	drvdata->fips_handle = NULL;
+}
+
+void fips_handler(struct cc_drvdata *drvdata)
+{
+	struct cc_fips_handle *fips_handle_ptr = drvdata->fips_handle;
+
+	tasklet_schedule(&fips_handle_ptr->tasklet);
+}
+
+static inline void tee_fips_error(struct device *dev)
+{
+	if (fips_enabled)
+		panic("ccree: TEE reported cryptographic error in fips mode!\n");
+	else
+		dev_err(dev, "TEE reported error!\n");
+}
+
+/* Deferred service handler, run as interrupt-fired tasklet */
+static void fips_dsr(unsigned long devarg)
+{
+	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct device *dev = drvdata_to_dev(drvdata);
+	u32 irq, state, val;
+
+	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
+
+	if (irq) {
+		state = cc_ioread(drvdata, CC_REG(GPR_HOST));
+
+		if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
+			tee_fips_error(dev);
+	}
+
+	/* after verifing that there is nothing to do,
+	 * unmask AXI completion interrupt.
+	 */
+	val = (CC_REG(HOST_IMR) & ~irq);
+	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
+}
+
+/* The function called once at driver entry point .*/
+int cc_fips_init(struct cc_drvdata *p_drvdata)
+{
+	struct cc_fips_handle *fips_h;
+	struct device *dev = drvdata_to_dev(p_drvdata);
+
+	fips_h = kzalloc(sizeof(*fips_h), GFP_KERNEL);
+	if (!fips_h)
+		return -ENOMEM;
+
+	p_drvdata->fips_handle = fips_h;
+
+	dev_dbg(dev, "Initializing fips tasklet\n");
+	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
+
+	if (!cc_get_tee_fips_status(p_drvdata))
+		tee_fips_error(dev);
+
+	return 0;
+}
diff --git a/drivers/crypto/ccree/cc_fips.h b/drivers/crypto/ccree/cc_fips.h
new file mode 100644
index 0000000..0d52003
--- /dev/null
+++ b/drivers/crypto/ccree/cc_fips.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
+
+#ifndef __CC_FIPS_H__
+#define __CC_FIPS_H__
+
+#ifdef CONFIG_CRYPTO_FIPS
+
+enum cc_fips_status {
+	CC_FIPS_SYNC_MODULE_OK = 0x0,
+	CC_FIPS_SYNC_MODULE_ERROR = 0x1,
+	CC_FIPS_SYNC_REE_STATUS = 0x4,
+	CC_FIPS_SYNC_TEE_STATUS = 0x8,
+	CC_FIPS_SYNC_STATUS_RESERVE32B = S32_MAX
+};
+
+int cc_fips_init(struct cc_drvdata *p_drvdata);
+void cc_fips_fini(struct cc_drvdata *drvdata);
+void fips_handler(struct cc_drvdata *drvdata);
+void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
+
+#else  /* CONFIG_CRYPTO_FIPS */
+
+static inline int cc_fips_init(struct cc_drvdata *p_drvdata)
+{
+	return 0;
+}
+
+static inline void cc_fips_fini(struct cc_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
+					  bool ok) {}
+static inline void fips_handler(struct cc_drvdata *drvdata) {}
+
+#endif /* CONFIG_CRYPTO_FIPS */
+
+#endif  /*__CC_FIPS_H__*/
+
-- 
2.7.4
