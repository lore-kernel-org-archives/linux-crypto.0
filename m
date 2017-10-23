From: Stephen Brennan <stephen@brennan.io>
Subject: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Mon, 23 Oct 2017 07:53:18 -0700
Message-ID: <20171023145318.8748-1-stephen@brennan.io>
Cc: Stephen Brennan <stephen@brennan.io>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21353 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932285AbdJWOwv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 10:52:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Simply break down some long lines and tab-indent them.

Signed-off-by: Stephen Brennan <stephen@brennan.io>
---
I'm learning the patch submission process, and this is my first patch. I know
it's trivial but I'm just trying to get my feet wet. Thanks in advance for
taking the time to review this!

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
