From: Colin King <colin.king@canonical.com>
Subject: [PATCH] staging: ccree: remove unused pointer cc_base
Date: Thu,  9 Nov 2017 08:13:05 +0000
Message-ID: <20171109081305.3659-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48605 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753124AbdKIINH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 03:13:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer cc_base is being assigned but is never read, hence it is
redundant and can be removed. Cleans up clang warning:

drivers/staging/ccree/ssi_driver.c:235:2: warning: Value stored to
'cc_base' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/ccree/ssi_driver.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1a3c481fa92a..f4c0af8047e4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -199,7 +199,6 @@ int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
 static int init_cc_resources(struct platform_device *plat_dev)
 {
 	struct resource *req_mem_cc_regs = NULL;
-	void __iomem *cc_base = NULL;
 	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
@@ -232,8 +231,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	dev_dbg(dev, "CC registers mapped from %pa to 0x%p\n",
 		&req_mem_cc_regs->start, new_drvdata->cc_base);
 
-	cc_base = new_drvdata->cc_base;
-
 	/* Then IRQ */
 	new_drvdata->irq = platform_get_irq(plat_dev, 0);
 	if (new_drvdata->irq < 0) {
-- 
2.14.1
