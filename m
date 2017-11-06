From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/3] staging: ccree: simplify error handling logic
Date: Mon,  6 Nov 2017 06:55:50 +0000
Message-ID: <1509951354-16370-2-git-send-email-gilad@benyossef.com>
References: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60134 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751695AbdKFG4H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 01:56:07 -0500
In-Reply-To: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Turn the code sites that don't require any special handling
on error return to a simple return.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1d4c7bb..135a7e2 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -212,10 +212,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	int rc = 0;
 
 	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
-	if (!new_drvdata) {
-		rc = -ENOMEM;
-		goto post_drvdata_err;
-	}
+	if (!new_drvdata)
+		return -ENOMEM;
+
 	platform_set_drvdata(plat_dev, new_drvdata);
 	new_drvdata->plat_dev = plat_dev;
 
@@ -229,8 +228,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
 	if (IS_ERR(new_drvdata->cc_base)) {
 		dev_err(dev, "Failed to ioremap registers");
-		rc = PTR_ERR(new_drvdata->cc_base);
-		goto post_drvdata_err;
+		return PTR_ERR(new_drvdata->cc_base);
 	}
 
 	dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
@@ -244,8 +242,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
 	if (new_drvdata->irq < 0) {
 		dev_err(dev, "Failed getting IRQ resource\n");
-		rc = new_drvdata->irq;
-		goto post_drvdata_err;
+		return new_drvdata->irq;
 	}
 
 	rc = devm_request_irq(dev, new_drvdata->irq, cc_isr,
@@ -253,7 +250,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc) {
 		dev_err(dev, "Could not register to interrupt %d\n",
 			new_drvdata->irq);
-		goto post_drvdata_err;
+		return rc;
 	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
 
@@ -271,15 +268,16 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 
 	if (rc) {
-		dev_err(dev, "Error: failed in dma_set_mask, mask=%par\n",
+		dev_err(dev, "Failed in dma_set_mask, mask=%par\n",
 			&dma_mask);
-		goto post_drvdata_err;
+		return rc;
 	}
 
 	rc = cc_clk_on(new_drvdata);
-	if (rc)
-		goto post_drvdata_err;
-
+	if (rc) {
+		dev_err(dev, "Failed to enable clock");
+		return rc;
+	}
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
@@ -406,8 +404,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	fini_cc_regs(new_drvdata);
 post_clk_err:
 	cc_clk_off(new_drvdata);
-post_drvdata_err:
-	dev_err(dev, "ccree init error occurred!\n");
 	return rc;
 }
 
-- 
2.7.4
