From: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: [PATCH][upstream] powerpc/crypto: caam - add backward compatible string sec4.0
Date: Wed, 21 Mar 2012 14:09:10 +0800
Message-ID: <1332310150-8274-1-git-send-email-Shengzhou.Liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>,
	Shengzhou Liu <Shengzhou.Liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:48981
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab2CUGfP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Mar 2012 02:35:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In some device trees of previous version, there were string "fsl,sec4.0".
To be backward compatible with device trees, we have CAAM driver first
check "fsl,sec-v4.0", if it fails, then check for "fsl,sec4.0".

Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>
---
 drivers/crypto/caam/caamalg.c |   14 ++++++++++----
 drivers/crypto/caam/ctrl.c    |   16 ++++++++++++++++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e73cf2e..d10d00b 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2152,8 +2152,11 @@ static void __exit caam_algapi_exit(void)
 	int i, err;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node)
-		return;
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return;
+	}
 
 	pdev = of_find_device_by_node(dev_node);
 	if (!pdev)
@@ -2234,8 +2237,11 @@ static int __init caam_algapi_init(void)
 	int i = 0, err = 0;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node)
-		return -ENODEV;
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
 
 	pdev = of_find_device_by_node(dev_node);
 	if (!pdev)
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8ae3ba2..f078fa0 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -98,6 +98,12 @@ static int caam_probe(struct platform_device *pdev)
 	rspec = 0;
 	for_each_compatible_node(np, NULL, "fsl,sec-v4.0-job-ring")
 		rspec++;
+	if (!rspec) {
+		/* for backward compatible with device trees */
+		for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring")
+			rspec++;
+	}
+
 	ctrlpriv->jrdev = kzalloc(sizeof(struct device *) * rspec, GFP_KERNEL);
 	if (ctrlpriv->jrdev == NULL) {
 		iounmap(&topregs->ctrl);
@@ -111,6 +117,13 @@ static int caam_probe(struct platform_device *pdev)
 		ctrlpriv->total_jobrs++;
 		ring++;
 	}
+	if (!ring) {
+		for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring") {
+			caam_jr_probe(pdev, np, ring);
+			ctrlpriv->total_jobrs++;
+			ring++;
+		}
+	}
 
 	/* Check to see if QI present. If so, enable */
 	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
@@ -226,6 +239,9 @@ static struct of_device_id caam_match[] = {
 	{
 		.compatible = "fsl,sec-v4.0",
 	},
+	{
+		.compatible = "fsl,sec4.0",
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, caam_match);
-- 
1.7.0.4
