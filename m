From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/10] staging: ccree: drop ifdef CONFIG_OF in code
Date: Thu, 14 Dec 2017 14:02:38 +0000
Message-ID: <1513260170-26346-2-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As we already depend on CONFIG_OF via Kconfig no need to
support conditional build without it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 28cfbb4..fbf0338 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -512,20 +512,16 @@ static const struct dev_pm_ops arm_cc7x_driver_pm = {
 #define	CC_DRIVER_RUNTIME_PM	NULL
 #endif
 
-#ifdef CONFIG_OF
 static const struct of_device_id arm_cc7x_dev_of_match[] = {
 	{.compatible = "arm,cryptocell-712-ree"},
 	{}
 };
 MODULE_DEVICE_TABLE(of, arm_cc7x_dev_of_match);
-#endif
 
 static struct platform_driver cc7x_driver = {
 	.driver = {
 		   .name = "cc7xree",
-#ifdef CONFIG_OF
 		   .of_match_table = arm_cc7x_dev_of_match,
-#endif
 		   .pm = CC_DRIVER_RUNTIME_PM,
 	},
 	.probe = cc7x_probe,
-- 
2.7.4
