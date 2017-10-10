From: Stephen Brennan <stephen@brennan.io>
Subject: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Mon,  9 Oct 2017 21:27:59 -0700
Message-ID: <20171010042759.14020-1-stephen@brennan.io>
Cc: Stephen Brennan <stephen@brennan.io>
To: gilad@benyossef.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21481 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdJJE1c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2017 00:27:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

---
I'm new to kernel development and hoping to start with some simple changes to
get familiar with the process. Please let me know if there's anything I can do
to improve this very trivial patch!

 drivers/staging/ccree/ssi_pm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 11bbdbeec22e..98ba9e918d2a 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -41,7 +41,9 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
 	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
+	WRITE_REGISTER(
+		drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN),
+		POWER_DOWN_ENABLE);
 	rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
 	if (rc != 0) {
 		dev_err(dev, "ssi_request_mgr_runtime_suspend_queue (%x)\n",
@@ -60,7 +62,9 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
 		(struct ssi_drvdata *)dev_get_drvdata(dev);
 
 	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
-	WRITE_REGISTER(drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
+	WRITE_REGISTER(
+		drvdata->cc_base + CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN),
+		POWER_DOWN_DISABLE);
 
 	rc = cc_clk_on(drvdata);
 	if (rc) {
-- 
2.14.2
