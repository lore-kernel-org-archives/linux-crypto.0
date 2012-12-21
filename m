From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 04/10] crypto: omap-aes - Add suspend/resume support
Date: Fri, 21 Dec 2012 10:04:54 -0700
Message-ID: <1356109500-11719-5-git-send-email-mgreer@animalcreek.com>
References: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:49712 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2LURFM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Dec 2012 12:05:12 -0500
In-Reply-To: <1356109500-11719-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Mark A. Greer" <mgreer@animalcreek.com>

Add suspend/resume support to the OMAP AES driver.

CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-aes.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index c229852..3262139 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -891,12 +891,31 @@ static int omap_aes_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int omap_aes_suspend(struct device *dev)
+{
+	pm_runtime_put_sync(dev);
+	return 0;
+}
+
+static int omap_aes_resume(struct device *dev)
+{
+	pm_runtime_get_sync(dev);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops omap_aes_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(omap_aes_suspend, omap_aes_resume)
+};
+
 static struct platform_driver omap_aes_driver = {
 	.probe	= omap_aes_probe,
 	.remove	= omap_aes_remove,
 	.driver	= {
 		.name	= "omap-aes",
 		.owner	= THIS_MODULE,
+		.pm	= &omap_aes_pm_ops,
 	},
 };
 
-- 
1.7.12
