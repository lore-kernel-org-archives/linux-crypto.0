From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 03/11] crypto: caam - Enable and disable clocks on Freescale i.MX platforms
Date: Mon, 15 Jun 2015 16:52:51 -0700
Message-ID: <1434412379-11623-4-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0112.outbound.protection.outlook.com ([157.56.111.112]:22863
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750911AbbFPAIn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:08:43 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ARM-based systems may disable clocking to the CAAM device on the
Freescale i.MX platform for power management purposes.  This patch
enables the required clocks when the CAAM module is initialized and
disables the required clocks when the CAAM module is shut down.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/compat.h |  4 +++
 drivers/crypto/caam/ctrl.c   | 81 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/intern.h |  7 ++++
 3 files changed, 92 insertions(+)

diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index acd7743..3148985 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -23,6 +23,10 @@
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/circ_buf.h>
+
+#ifdef CONFIG_ARM /* needs the clock control subsystem */
+#include <linux/clk.h>
+#endif
 #include <net/xfrm.h>
 
 #include <crypto/algapi.h>
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index efba4cc..3226eb8 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -303,6 +303,14 @@ static int caam_remove(struct platform_device *pdev)
 	/* Unmap controller region */
 	iounmap(&ctrl);
 
+#ifdef CONFIG_ARM
+	/* shut clocks off before finalizing shutdown */
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+	clk_disable_unprepare(ctrlpriv->caam_mem);
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
+#endif
+
 	return ret;
 }
 
@@ -408,6 +416,79 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->pdev = pdev;
 	nprop = pdev->dev.of_node;
 
+/*
+ * ARM targets tend to have clock control subsystems that can
+ * enable/disable clocking to our device. Turn clocking on to proceed
+ */
+#ifdef CONFIG_ARM
+	ctrlpriv->caam_ipg = devm_clk_get(&pdev->dev, "caam_ipg");
+	if (IS_ERR(ctrlpriv->caam_ipg)) {
+		ret = PTR_ERR(ctrlpriv->caam_ipg);
+		dev_err(&pdev->dev,
+			"can't identify CAAM ipg clk: %d\n", ret);
+		return -ENODEV;
+	}
+
+	ctrlpriv->caam_mem = devm_clk_get(&pdev->dev, "caam_mem");
+	if (IS_ERR(ctrlpriv->caam_mem)) {
+		ret = PTR_ERR(ctrlpriv->caam_mem);
+		dev_err(&pdev->dev,
+			"can't identify CAAM secure mem clk: %d\n", ret);
+		return -ENODEV;
+	}
+
+	ctrlpriv->caam_aclk = devm_clk_get(&pdev->dev, "caam_aclk");
+	if (IS_ERR(ctrlpriv->caam_aclk)) {
+		ret = PTR_ERR(ctrlpriv->caam_aclk);
+		dev_err(&pdev->dev,
+			"can't identify CAAM aclk clk: %d\n", ret);
+		return -ENODEV;
+	}
+
+	ctrlpriv->caam_emi_slow = devm_clk_get(&pdev->dev, "caam_emi_slow");
+	if (IS_ERR(ctrlpriv->caam_emi_slow)) {
+		ret = PTR_ERR(ctrlpriv->caam_emi_slow);
+		dev_err(&pdev->dev,
+			"can't identify CAAM emi slow clk: %d\n", ret);
+		return -ENODEV;
+	}
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
+	dev_info(dev, "%s caam_ipg clock:%d\n", __func__,
+		(int)clk_get_rate(ctrlpriv->caam_ipg));
+	dev_info(dev, "%s caam_mem clock:%d\n", __func__,
+		(int)clk_get_rate(ctrlpriv->caam_mem));
+	dev_info(dev, "%s caam_aclk clock:%d\n", __func__,
+		(int)clk_get_rate(ctrlpriv->caam_aclk));
+	dev_info(dev, "%s caam_emi_slow clock:%d\n", __func__,
+		(int)clk_get_rate(ctrlpriv->caam_emi_slow));
+#endif
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 89b94cc..54f82dd 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -91,6 +91,13 @@ struct caam_drv_private {
 				   Handles of the RNG4 block are initialized
 				   by this driver */
 
+#ifdef CONFIG_ARM
+	struct clk *caam_ipg;
+	struct clk *caam_mem;
+	struct clk *caam_aclk;
+	struct clk *caam_emi_slow;
+#endif
+
 	/*
 	 * debugfs entries for developer view into driver/device
 	 * variables at runtime.
-- 
2.1.4
