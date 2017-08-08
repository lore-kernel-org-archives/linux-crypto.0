From: Doug Wilson <doug.lkml@gmail.com>
Subject: [PATCH] staging:ccree:constify dev_pm_ops
Date: Tue,  8 Aug 2017 16:49:12 +0530
Message-ID: <1502191152-3879-1-git-send-email-doug.lkml@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Wilson <doug.lkml@gmail.com>,
        Doug Wilson <doug.wilson@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

    dev_pm_ops is not supposed to change at runtime. Marking it
    constant.

Signed-off-by: Doug Wilson <doug.wilson@gmail.com>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 78709b92..778fbb2 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -546,7 +546,7 @@ static int cc7x_remove(struct platform_device *plat_dev)
 }
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
-static struct dev_pm_ops arm_cc7x_driver_pm = {
+static const struct dev_pm_ops arm_cc7x_driver_pm = {
 	SET_RUNTIME_PM_OPS(ssi_power_mgr_runtime_suspend, ssi_power_mgr_runtime_resume, NULL)
 };
 #endif
-- 
2.7.4
