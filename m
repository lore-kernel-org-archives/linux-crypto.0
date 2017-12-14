From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/10] staging: ccree: clean up PM registration
Date: Thu, 14 Dec 2017 14:02:39 +0000
Message-ID: <1513260170-26346-3-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Clean up power management registration.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 16 +++-------------
 drivers/staging/ccree/ssi_pm.c     |  4 ++++
 drivers/staging/ccree/ssi_pm.h     |  3 +++
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index fbf0338..ad02d92 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -500,18 +500,6 @@ static int cc7x_remove(struct platform_device *plat_dev)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static const struct dev_pm_ops arm_cc7x_driver_pm = {
-	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
-};
-#endif
-
-#if defined(CONFIG_PM)
-#define	CC_DRIVER_RUNTIME_PM	(&arm_cc7x_driver_pm)
-#else
-#define	CC_DRIVER_RUNTIME_PM	NULL
-#endif
-
 static const struct of_device_id arm_cc7x_dev_of_match[] = {
 	{.compatible = "arm,cryptocell-712-ree"},
 	{}
@@ -522,7 +510,9 @@ static struct platform_driver cc7x_driver = {
 	.driver = {
 		   .name = "cc7xree",
 		   .of_match_table = arm_cc7x_dev_of_match,
-		   .pm = CC_DRIVER_RUNTIME_PM,
+#ifdef CONFIG_PM
+		   .pm = &ccree_pm,
+#endif
 	},
 	.probe = cc7x_probe,
 	.remove = cc7x_remove,
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 3c4892b..0db935d 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -34,6 +34,10 @@
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
 
+const struct dev_pm_ops ccree_pm = {
+	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
+};
+
 int cc_pm_suspend(struct device *dev)
 {
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index a5f2b1b..91140a3 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -30,6 +30,9 @@ int cc_pm_init(struct cc_drvdata *drvdata);
 void cc_pm_fini(struct cc_drvdata *drvdata);
 
 #if defined(CONFIG_PM)
+
+extern const struct dev_pm_ops ccree_pm;
+
 int cc_pm_suspend(struct device *dev);
 
 int cc_pm_resume(struct device *dev);
-- 
2.7.4
