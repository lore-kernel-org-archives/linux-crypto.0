From: Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH] hwrng: imx-rngc: simplify the power management definitions
Date: Thu, 11 Jan 2018 22:06:39 +0100
Message-ID: <1515704804-19468-1-git-send-email-martin@kaiser.cx>
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use the SIMPLE_DEV_PM_OPS() macro instead of populating a struct
dev_pm_ops directly. The suspend and resume functions will now be used
for both hibernation and suspend to ram.

If power management is disabled, SIMPLE_DEV_PM_OPS() evaluates to
nothing, The two functions won't be used and won't be included in the
kernel. Mark them as __maybe_unused to clarify that this is intended
behaviour.

With these modifications in place, we don't need the #ifdefs for power
management any more.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/imx-rngc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 88db42d..eca8724 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -282,8 +282,7 @@ static int __exit imx_rngc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int imx_rngc_suspend(struct device *dev)
+static int __maybe_unused imx_rngc_suspend(struct device *dev)
 {
 	struct imx_rngc *rngc = dev_get_drvdata(dev);
 
@@ -292,7 +291,7 @@ static int imx_rngc_suspend(struct device *dev)
 	return 0;
 }
 
-static int imx_rngc_resume(struct device *dev)
+static int __maybe_unused imx_rngc_resume(struct device *dev)
 {
 	struct imx_rngc *rngc = dev_get_drvdata(dev);
 
@@ -301,11 +300,7 @@ static int imx_rngc_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops imx_rngc_pm_ops = {
-	.suspend	= imx_rngc_suspend,
-	.resume		= imx_rngc_resume,
-};
-#endif
+SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
 
 static const struct of_device_id imx_rngc_dt_ids[] = {
 	{ .compatible = "fsl,imx25-rngb", .data = NULL, },
@@ -316,9 +311,7 @@ MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
 static struct platform_driver imx_rngc_driver = {
 	.driver = {
 		.name = "imx_rngc",
-#ifdef CONFIG_PM
 		.pm = &imx_rngc_pm_ops,
-#endif
 		.of_match_table = imx_rngc_dt_ids,
 	},
 	.remove = __exit_p(imx_rngc_remove),
-- 
2.1.4
