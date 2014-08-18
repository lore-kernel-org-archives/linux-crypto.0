From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH 1/2] crypto: sahara - add support for i.MX53
Date: Mon, 18 Aug 2014 15:13:38 +0200
Message-ID: <1408367619-3436-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43339 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHRNNx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Aug 2014 09:13:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Sahara on the i.MX53 is of version 4. Add support for probing the
device.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
---
 .../devicetree/bindings/crypto/fsl-imx-sahara.txt       |  2 +-
 drivers/crypto/sahara.c                                 | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
index 5c65ecc..e8a35c7 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
@@ -1,5 +1,5 @@
 Freescale SAHARA Cryptographic Accelerator included in some i.MX chips.
-Currently only i.MX27 is supported.
+Currently only i.MX27 and i.MX53 are supported.
 
 Required properties:
 - compatible : Should be "fsl,<soc>-sahara"
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 164e1ec..85df5b5 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -24,10 +24,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #define SAHARA_NAME "sahara"
 #define SAHARA_VERSION_3	3
+#define SAHARA_VERSION_4	4
 #define SAHARA_TIMEOUT_MS	1000
 #define SAHARA_MAX_HW_DESC	2
 #define SAHARA_MAX_HW_LINK	20
@@ -860,6 +862,7 @@ static struct platform_device_id sahara_platform_ids[] = {
 MODULE_DEVICE_TABLE(platform, sahara_platform_ids);
 
 static struct of_device_id sahara_dt_ids[] = {
+	{ .compatible = "fsl,imx53-sahara" },
 	{ .compatible = "fsl,imx27-sahara" },
 	{ /* sentinel */ }
 };
@@ -971,10 +974,18 @@ static int sahara_probe(struct platform_device *pdev)
 	clk_prepare_enable(dev->clk_ahb);
 
 	version = sahara_read(dev, SAHARA_REG_VERSION);
-	if (version != SAHARA_VERSION_3) {
+	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx27-sahara")) {
+		if (version != SAHARA_VERSION_3)
+			err = -ENODEV;
+	} else if (of_device_is_compatible(pdev->dev.of_node,
+			"fsl,imx53-sahara")) {
+		if (((version >> 8) & 0xff) != SAHARA_VERSION_4)
+			err = -ENODEV;
+		version = (version >> 8) & 0xff;
+	}
+	if (err == -ENODEV) {
 		dev_err(&pdev->dev, "SAHARA version %d not supported\n",
-			version);
-		err = -ENODEV;
+				version);
 		goto err_algs;
 	}
 
-- 
2.1.0.rc1
