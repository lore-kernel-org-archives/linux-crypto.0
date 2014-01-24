From: Nitesh Lal <NiteshNarayanLal@freescale.com>
Subject: [PATCH] crypto: caam - Fix job ring discovery in controller driver
Date: Fri, 24 Jan 2014 14:33:25 +0530
Message-ID: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nitesh Lal <NiteshNarayanLal@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:39898
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbaAXDuD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jan 2014 22:50:03 -0500
Received: from mail93-co9 (localhost [127.0.0.1])	by mail93-co9-R.bigfish.com
 (Postfix) with ESMTP id 2FB5E4A03C4	for <linux-crypto@vger.kernel.org>; Fri,
 24 Jan 2014 03:50:02 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SEC Controller driver creates platform devices for it's child job ring nodes.
Currently the driver uses for_each_compatible routine which traverses
the whole device tree to create the job rings for the platform device.
The patch changes this to search for the compatible property of job ring
only in the child nodes i.e., the job rings are created as per the number
of children associated with the crypto node.

Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 63fb1af..30f434f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -443,13 +443,10 @@ static int caam_probe(struct platform_device *pdev)
 	 * for all, then go probe each one.
 	 */
 	rspec = 0;
-	for_each_compatible_node(np, NULL, "fsl,sec-v4.0-job-ring")
-		rspec++;
-	if (!rspec) {
-		/* for backward compatible with device trees */
-		for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring")
+	for_each_available_child_of_node(nprop, np)
+		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
+		    of_device_is_compatible(np, "fsl,sec4.0-job-ring"))
 			rspec++;
-	}
 
 	ctrlpriv->jrpdev = kzalloc(sizeof(struct platform_device *) * rspec,
 								GFP_KERNEL);
@@ -460,18 +457,9 @@ static int caam_probe(struct platform_device *pdev)
 
 	ring = 0;
 	ctrlpriv->total_jobrs = 0;
-	for_each_compatible_node(np, NULL, "fsl,sec-v4.0-job-ring") {
-		ctrlpriv->jrpdev[ring] =
-				of_platform_device_create(np, NULL, dev);
-		if (!ctrlpriv->jrpdev[ring]) {
-			pr_warn("JR%d Platform device creation error\n", ring);
-			continue;
-		}
-		ctrlpriv->total_jobrs++;
-		ring++;
-	}
-	if (!ring) {
-		for_each_compatible_node(np, NULL, "fsl,sec4.0-job-ring") {
+	for_each_available_child_of_node(nprop, np)
+		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
+		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
 			ctrlpriv->jrpdev[ring] =
 				of_platform_device_create(np, NULL, dev);
 			if (!ctrlpriv->jrpdev[ring]) {
@@ -482,7 +470,6 @@ static int caam_probe(struct platform_device *pdev)
 			ctrlpriv->total_jobrs++;
 			ring++;
 		}
-	}
 
 	/* Check to see if QI present. If so, enable */
 	ctrlpriv->qi_present = !!(rd_reg64(&topregs->ctrl.perfmon.comp_parms) &
-- 
1.8.1.4
