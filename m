From: sunil.m@techveda.org
Subject: [PATCH v2 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Tue, 18 Jul 2017 16:28:44 +0530
Message-ID: <1500375526-12973-1-git-send-email-sunil.m@techveda.org>
References: <20170717123306.GF24503@kroah.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gregkh@linuxfoundation.org, gilad@benyossef.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170717123306.GF24503@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
---
Changes for v2:

- Changes done as suggested by Greg-KH.
- Rebased on top of next-20170718.
---
Note:

- Patch was tested and built(ARCH=arm) on next-20170718.
  No build issues reported, however it was not tested on
  real hardware.
---
 drivers/staging/ccree/ssi_driver.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index d7b9a63..e918cf4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -223,13 +223,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
-	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
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
1.9.1
