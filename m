From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Thu, 27 Jul 2017 17:27:32 +0300
Message-ID: <1501165654-30601-1-git-send-email-gilad@benyossef.com>
References: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Suniel Mahesh <sunil.m@techveda.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47390 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbdG0O1n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2017 10:27:43 -0400
In-Reply-To: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Suniel Mahesh <sunil.m@techveda.org>

It is recommended to use managed function devm_kzalloc, which
simplifies driver cleanup paths and driver code.
This patch does the following:
(a) replace kzalloc with devm_kzalloc.
(b) drop kfree(), because memory allocated with devm_kzalloc() is
automatically freed on driver detach, otherwise it leads to a double
free.
(c) remove unnecessary blank lines.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
[gby: rebase on top of latest coding style fixes changes]
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 1cae2b7..97dfc2c 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -223,13 +223,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
-	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(*new_drvdata), GFP_KERNEL);
+	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
 	int rc = 0;
 
-	if (unlikely(!new_drvdata)) {
+	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(*new_drvdata),
+				   GFP_KERNEL);
+	if (!new_drvdata) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto init_cc_res_err;
@@ -434,10 +436,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 					   resource_size(new_drvdata->res_mem));
 			new_drvdata->res_mem = NULL;
 		}
-		kfree(new_drvdata);
 		dev_set_drvdata(&plat_dev->dev, NULL);
 	}
-
 	return rc;
 }
 
@@ -478,8 +478,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 		drvdata->cc_base = NULL;
 		drvdata->res_mem = NULL;
 	}
-
-	kfree(drvdata);
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
-- 
2.1.4
