From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 4/7] crypto: caam - split RNG4 instantiation function
Date: Mon, 9 Sep 2013 18:56:31 +0300
Message-ID: <1378742194-32194-5-git-send-email-alexandru.porosanu@freescale.com>
References: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>, <horia.geanta@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:9035
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab3IIP70 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Sep 2013 11:59:26 -0400
In-Reply-To: <1378742194-32194-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch splits the RNG4 state handle instantiation
function into two parts: one that handles the creation
of the descriptor which instructs the CAAM to perform
the instantiation of the state handle and another
function that performs the running of the said descriptor
using the DECO debug mechanism.

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |  140 +++++++++++++++++++++++++++++---------------
 1 files changed, 92 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d5fe5f5..3ad032f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -13,39 +13,6 @@
 #include "error.h"
 #include "ctrl.h"
 
-static int caam_remove(struct platform_device *pdev)
-{
-	struct device *ctrldev;
-	struct caam_drv_private *ctrlpriv;
-	struct caam_drv_private_jr *jrpriv;
-	struct caam_full __iomem *topregs;
-	int ring, ret = 0;
-
-	ctrldev = &pdev->dev;
-	ctrlpriv = dev_get_drvdata(ctrldev);
-	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
-
-	/* shut down JobRs */
-	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
-		ret |= caam_jr_shutdown(ctrlpriv->jrdev[ring]);
-		jrpriv = dev_get_drvdata(ctrlpriv->jrdev[ring]);
-		irq_dispose_mapping(jrpriv->irq);
-	}
-
-	/* Shut down debug views */
-#ifdef CONFIG_DEBUG_FS
-	debugfs_remove_recursive(ctrlpriv->dfs_root);
-#endif
-
-	/* Unmap controller region */
-	iounmap(&topregs->ctrl);
-
-	kfree(ctrlpriv->jrdev);
-	kfree(ctrlpriv);
-
-	return ret;
-}
-
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
  * load the JDKEK, TDKEK and TDSK registers
@@ -77,21 +44,23 @@ static void build_instantiation_desc(u32 *desc)
 	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
 }
 
-static int instantiate_rng(struct device *ctrldev)
+
+/*
+ * run_descriptor_deco0 - runs a descriptor on DECO0, under direct control of
+ *			  the software (no JR/QI used).
+ * @ctrldev - pointer to device
+ * Return: - 0 if no error occurred
+ *	   - -ENODEV if the DECO couldn't be acquired
+ *	   - -EAGAIN if an error occurred while executing the descriptor
+ */
+static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc)
 {
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
 	struct caam_full __iomem *topregs;
 	unsigned int timeout = 100000;
-	u32 *desc, deco_dbg_reg;
+	u32 deco_dbg_reg, flags;
 	int i, ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL | GFP_DMA);
-	if (!desc) {
-		dev_err(ctrldev, "can't allocate RNG init descriptor memory\n");
-		return -ENOMEM;
-	}
-	build_instantiation_desc(desc);
-
 	/* Set the bit to request direct access to DECO0 */
 	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
 	setbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
@@ -102,14 +71,23 @@ static int instantiate_rng(struct device *ctrldev)
 
 	if (!timeout) {
 		dev_err(ctrldev, "failed to acquire DECO 0\n");
-		ret = -EIO;
-		goto out;
+		clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
+		return -ENODEV;
 	}
 
 	for (i = 0; i < desc_len(desc); i++)
-		topregs->deco.descbuf[i] = *(desc + i);
+		wr_reg32(&topregs->deco.descbuf[i], *(desc + i));
 
-	wr_reg32(&topregs->deco.jr_ctl_hi, DECO_JQCR_WHL | DECO_JQCR_FOUR);
+	flags = DECO_JQCR_WHL;
+	/*
+	 * If the descriptor length is longer than 4 words, then the
+	 * FOUR bit in JRCTRL register must be set.
+	 */
+	if (desc_len(desc) >= 4)
+		flags |= DECO_JQCR_FOUR;
+
+	/* Instruct the DECO to execute it */
+	wr_reg32(&topregs->deco.jr_ctl_hi, flags);
 
 	timeout = 10000000;
 	do {
@@ -129,9 +107,75 @@ static int instantiate_rng(struct device *ctrldev)
 		ret = -EIO;
 	}
 
+	/* Mark the DECO as free */
 	clrbits32(&topregs->ctrl.deco_rq, DECORR_RQD0ENABLE);
-out:
+
+	if (!timeout)
+		return -EAGAIN;
+
+	return 0;
+}
+
+/*
+ * instantiate_rng - builds and executes a descriptor on DECO0,
+ *		     which initializes the RNG block.
+ * @ctrldev - pointer to device
+ * Return: - 0 if no error occurred
+ *	   - -ENOMEM if there isn't enough memory to allocate the descriptor
+ *	   - -ENODEV if DECO0 couldn't be acquired
+ *	   - -EAGAIN if an error occurred when executing the descriptor
+ *	      f.i. there was a RNG hardware error due to not "good enough"
+ *	      entropy being aquired.
+ */
+static int instantiate_rng(struct device *ctrldev)
+{
+	u32 *desc;
+	int ret = 0;
+
+	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+	/* Create the descriptor for instantiating RNG State Handle 0 */
+	build_instantiation_desc(desc);
+
+	/* Try to run it through DECO0 */
+	ret = run_descriptor_deco0(ctrldev, desc);
+
 	kfree(desc);
+
+	return ret;
+}
+
+static int caam_remove(struct platform_device *pdev)
+{
+	struct device *ctrldev;
+	struct caam_drv_private *ctrlpriv;
+	struct caam_drv_private_jr *jrpriv;
+	struct caam_full __iomem *topregs;
+	int ring, ret = 0;
+
+	ctrldev = &pdev->dev;
+	ctrlpriv = dev_get_drvdata(ctrldev);
+	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
+
+	/* shut down JobRs */
+	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
+		ret |= caam_jr_shutdown(ctrlpriv->jrdev[ring]);
+		jrpriv = dev_get_drvdata(ctrlpriv->jrdev[ring]);
+		irq_dispose_mapping(jrpriv->irq);
+	}
+
+	/* Shut down debug views */
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(ctrlpriv->dfs_root);
+#endif
+
+	/* Unmap controller region */
+	iounmap(&topregs->ctrl);
+
+	kfree(ctrlpriv->jrdev);
+	kfree(ctrlpriv);
+
 	return ret;
 }
 
@@ -333,7 +377,7 @@ static int caam_probe(struct platform_device *pdev)
 			kick_trng(pdev, ent_delay);
 			ret = instantiate_rng(dev);
 			ent_delay += 400;
-		} while ((ret == -EIO) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
+		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
 		if (ret) {
 			dev_err(dev, "failed to instantiate RNG");
 			caam_remove(pdev);
-- 
1.7.7.6
