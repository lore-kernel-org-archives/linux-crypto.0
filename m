From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH v2 03/14] crypto: caam - Enable and disable clocks on Freescale i.MX platforms
Date: Wed, 5 Aug 2015 11:28:37 -0700
Message-ID: <1438799328-10757-4-git-send-email-vicki.milhoan@freescale.com>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>, <shawnguo@kernel.org>,
	<kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
	<robh+dt@kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:20154
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751712AbbHESoD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 14:44:03 -0400
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ARM-based systems may disable clocking to the CAAM device on the
Freescale i.MX platform for power management purposes.  This patch
enables the required clocks when the CAAM module is initialized and
disables the required clocks when the CAAM module is shut down.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/compat.h |  1 +
 drivers/crypto/caam/ctrl.c   | 88 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/intern.h |  5 +++
 3 files changed, 94 insertions(+)

diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index f57f395..b6955ec 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/circ_buf.h>
+#include <linux/clk.h>
 #include <net/xfrm.h>
 
 #include <crypto/algapi.h>
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 660cc3e..37c2d8d 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -16,6 +16,24 @@
 #include "error.h"
 
 /*
+ * ARM targets tend to have clock control subsystems that can
+ * enable/disable clocking to our device.
+ */
+#ifdef CONFIG_ARM
+static inline struct clk *caam_drv_identify_clk(struct device *dev,
+						char *clk_name)
+{
+	return devm_clk_get(dev, clk_name);
+}
+#else
+static inline struct clk *caam_drv_identify_clk(struct device *dev,
+						char *clk_name)
+{
+	return NULL;
+}
+#endif
+
+/*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
  * load the JDKEK, TDKEK and TDSK registers
  */
@@ -304,6 +322,12 @@ static int caam_remove(struct platform_device *pdev)
 	/* Unmap controller region */
 	iounmap(ctrl);
 
+	/* shut clocks off before finalizing shutdown */
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+	clk_disable_unprepare(ctrlpriv->caam_mem);
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
+
 	return ret;
 }
 
@@ -391,6 +415,7 @@ static int caam_probe(struct platform_device *pdev)
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_drv_private *ctrlpriv;
+	struct clk *clk;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
@@ -409,6 +434,69 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->pdev = pdev;
 	nprop = pdev->dev.of_node;
 
+	/* Enable clocking */
+	clk = caam_drv_identify_clk(&pdev->dev, "ipg");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev,
+			"can't identify CAAM ipg clk: %d\n", ret);
+		return -ENODEV;
+	}
+	ctrlpriv->caam_ipg = clk;
+
+	clk = caam_drv_identify_clk(&pdev->dev, "mem");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev,
+			"can't identify CAAM mem clk: %d\n", ret);
+		return -ENODEV;
+	}
+	ctrlpriv->caam_mem = clk;
+
+	clk = caam_drv_identify_clk(&pdev->dev, "aclk");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev,
+			"can't identify CAAM aclk clk: %d\n", ret);
+		return -ENODEV;
+	}
+	ctrlpriv->caam_aclk = clk;
+
+	clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev,
+			"can't identify CAAM emi_slow clk: %d\n", ret);
+		return -ENODEV;
+	}
+	ctrlpriv->caam_emi_slow = clk;
+
+	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
+		return -ENODEV;
+	}
+
+	ret = clk_prepare_enable(ctrlpriv->caam_mem);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
+			ret);
+		return -ENODEV;
+	}
+
+	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
+		return -ENODEV;
+	}
+
+	ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
+			ret);
+		return -ENODEV;
+	}
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 89b94cc..e2bcacc 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -91,6 +91,11 @@ struct caam_drv_private {
 				   Handles of the RNG4 block are initialized
 				   by this driver */
 
+	struct clk *caam_ipg;
+	struct clk *caam_mem;
+	struct clk *caam_aclk;
+	struct clk *caam_emi_slow;
+
 	/*
 	 * debugfs entries for developer view into driver/device
 	 * variables at runtime.
-- 
2.1.4
