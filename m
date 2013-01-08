From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v2 04/10] crypto: omap-aes - Add suspend/resume support
Date: Tue,  8 Jan 2013 11:57:41 -0700
Message-ID: <1357671467-32363-5-git-send-email-mgreer@animalcreek.com>
References: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, russ.dill@gmail.com,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m1plsmtpa01-01.prod.mesa1.secureserver.net ([64.202.165.173]:41519
	"EHLO m1plsmtpa01-01.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab3AHS56 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2013 13:57:58 -0500
In-Reply-To: <1357671467-32363-1-git-send-email-mgreer@animalcreek.com>
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
