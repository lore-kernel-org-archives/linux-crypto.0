From: sunil.m@techveda.org
Subject: [PATCH v3] staging: ccree: Convert to platform_{get,set}_drvdata()
Date: Wed,  4 Oct 2017 13:15:37 +0530
Message-ID: <1507103137-9016-1-git-send-email-sunil.m@techveda.org>
References: <20171003162920.GA11186@kroah.com>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003162920.GA11186@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

Platform devices are expected to use wrapper functions,
platform_{get,set}_drvdata() with platform_device as argument,
for getting and setting the driver data. dev_{get,set}_drvdata()
are using &plat_dev->dev.
For wrapper functions we can directly pass a struct platform_device.

dev_set_drvdata() is redundant and therefore removed. The driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Changes for v3:
- Rebased on top of staging-testing as suggested by Greg KH.
- Patch was tested and built(ARCH=arm) on staging-testing.
---
Changes for v2:
- Rebased on top of staging-testing.
---
Note:
- No build issues reported, however it was not tested on
  real hardware.
---
 drivers/staging/ccree/ssi_driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 795a087..5f03c25 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -215,7 +215,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		rc = -ENOMEM;
 		goto post_drvdata_err;
 	}
-	dev_set_drvdata(dev, new_drvdata);
+	platform_set_drvdata(plat_dev, new_drvdata);
 	new_drvdata->plat_dev = plat_dev;
 
 	new_drvdata->clk = of_clk_get(np, 0);
@@ -393,7 +393,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_clk_off(new_drvdata);
 post_drvdata_err:
 	dev_err(dev, "ccree init error occurred!\n");
-	dev_set_drvdata(dev, NULL);
 	return rc;
 }
 
@@ -407,7 +406,7 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 static void cleanup_cc_resources(struct platform_device *plat_dev)
 {
 	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
+		(struct ssi_drvdata *)platform_get_drvdata(plat_dev);
 
 	ssi_aead_free(drvdata);
 	ssi_hash_free(drvdata);
@@ -423,7 +422,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 #endif
 	fini_cc_regs(drvdata);
 	cc_clk_off(drvdata);
-	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
 int cc_clk_on(struct ssi_drvdata *drvdata)
-- 
1.9.1
