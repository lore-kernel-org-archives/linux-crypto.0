From: sunil.m@techveda.org
Subject: [PATCH v2] staging: ccree: Convert to platform_{get,set}_drvdata()
Date: Thu, 21 Sep 2017 17:47:42 +0530
Message-ID: <1505996262-19137-1-git-send-email-sunil.m@techveda.org>
References: <1505993344-18304-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505993344-18304-1-git-send-email-sunil.m@techveda.org>
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
Changes for v2:
- Rebased on top of staging-testing.
---
Note:
- Patch was tested and built(ARCH=arm) on next-20170921.
  No build issues reported, however it was not tested on
  real hardware.
---
 drivers/staging/ccree/ssi_driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 6d16220..53b4a8c 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -236,7 +236,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		rc = -ENOMEM;
 		goto post_drvdata_err;
 	}
-	dev_set_drvdata(&plat_dev->dev, new_drvdata);
+	platform_set_drvdata(plat_dev, new_drvdata);
 	new_drvdata->plat_dev = plat_dev;
 
 	new_drvdata->clk = of_clk_get(np, 0);
@@ -415,7 +415,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_clk_off(new_drvdata);
 post_drvdata_err:
 	SSI_LOG_ERR("ccree init error occurred!\n");
-	dev_set_drvdata(&plat_dev->dev, NULL);
 	return rc;
 }
 
@@ -429,7 +428,7 @@ void fini_cc_regs(struct ssi_drvdata *drvdata)
 static void cleanup_cc_resources(struct platform_device *plat_dev)
 {
 	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(&plat_dev->dev);
+		(struct ssi_drvdata *)platform_get_drvdata(plat_dev);
 
 	ssi_aead_free(drvdata);
 	ssi_hash_free(drvdata);
@@ -445,7 +444,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 #endif
 	fini_cc_regs(drvdata);
 	cc_clk_off(drvdata);
-	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
 int cc_clk_on(struct ssi_drvdata *drvdata)
-- 
1.9.1
