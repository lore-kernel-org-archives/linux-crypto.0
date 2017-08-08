From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] staging: ccree: constify dev_pm_ops structures.
Date: Tue,  8 Aug 2017 14:53:59 +0530
Message-ID: <f5c0f0067e48080682bb68311d08a4c1d9a73cc4.1502183279.git.arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

dev_pm_ops are not supposed to change at runtime. All functions
working with dev_pm_ops provided by <linux/device.h> work with const
dev_pm_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index e0faca0..1753906 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -549,7 +549,7 @@ static int cc7x_remove(struct platform_device *plat_dev)
 }
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-static struct dev_pm_ops arm_cc7x_driver_pm = {
+static const struct dev_pm_ops arm_cc7x_driver_pm = {
 	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
 };
 #endif
-- 
1.9.1
