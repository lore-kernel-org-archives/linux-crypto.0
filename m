From: "NiteshNarayanLal@freescale.com" <NiteshNarayanLal@freescale.com>
Subject: RE: [PATCH] crypto: caam - Fix job ring discovery in controller
 driver
Date: Fri, 7 Feb 2014 04:42:09 +0000
Message-ID: <75a8dafd02624bb893e854f20b076afe@BY2PR03MB205.namprd03.prod.outlook.com>
References: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"yashpal.dutta@freescale.com" <yashpal.dutta@freescale.com>
To: "NiteshNarayanLal@freescale.com" <NiteshNarayanLal@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:26771
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbaBGE4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 23:56:30 -0500
In-Reply-To: <1390554205-19771-1-git-send-email-NiteshNarayanLal@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Can you please pick up this patch.

Regards
Nitesh

-----Original Message-----
From: Nitesh Lal [mailto:NiteshNarayanLal@freescale.com] 
Sent: Friday, January 24, 2014 2:33 PM
To: linux-crypto@vger.kernel.org
Cc: Lal Nitesh-B44382
Subject: [PATCH] crypto: caam - Fix job ring discovery in controller driver

The SEC Controller driver creates platform devices for it's child job ring nodes.
Currently the driver uses for_each_compatible routine which traverses the whole device tree to create the job rings for the platform device.
The patch changes this to search for the compatible property of job ring only in the child nodes i.e., the job rings are created as per the number of children associated with the crypto node.

Signed-off-by: Nitesh Lal <NiteshNarayanLal@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c index 63fb1af..30f434f 100644
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
