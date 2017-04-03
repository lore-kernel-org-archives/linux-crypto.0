From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam - fix JR platform device subsequent (re)creations
Date: Mon, 3 Apr 2017 18:12:04 +0300
Message-ID: <20170403151204.27488-1-horia.geanta@nxp.com>
References: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Ruchika Gupta <ruchika.gupta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0081.outbound.protection.outlook.com ([104.47.34.81]:41952
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752076AbdDCPNY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 11:13:24 -0400
In-Reply-To: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way Job Ring platform devices are created and released does not
allow for multiple create-release cycles.

JR0 Platform device creation error
JR0 Platform device creation error
caam 2100000.caam: no queues configured, terminating
caam: probe of 2100000.caam failed with error -12

The reason is that platform devices are created for each job ring:

        for_each_available_child_of_node(nprop, np)
                if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
                    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
                        ctrlpriv->jrpdev[ring] =
                                of_platform_device_create(np, NULL, dev);

which sets OF_POPULATED on the device node, but then it cleans these up:

        /* Remove platform devices for JobRs */
        for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
                if (ctrlpriv->jrpdev[ring])
                        of_device_unregister(ctrlpriv->jrpdev[ring]);
        }

which leaves OF_POPULATED set.

Use of_platform_populate / of_platform_depopulate instead.
This allows for a bit of driver clean-up, jrpdev is no longer needed.

Logic changes a bit too:
-exit in case of_platform_populate fails, since currently even QI backend
depends on JR; true, we no longer support the case when "some" of the JR
DT nodes are incorrect
-when cleaning up, caam_remove() would also depopulate RTIC in case
it would have been populated somewhere else - not the case for now

Fixes: 313ea293e9c4d ("crypto: caam - Add Platform driver for Job Ring")
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Suggested-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
Not sending this directly to -stable, since it does not apply cleanly.

 drivers/crypto/caam/ctrl.c   | 64 ++++++++++++++------------------------------
 drivers/crypto/caam/intern.h |  1 -
 2 files changed, 20 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b3a94d5eff26..f7792a99469a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -305,15 +305,13 @@ static int caam_remove(struct platform_device *pdev)
 	struct device *ctrldev;
 	struct caam_drv_private *ctrlpriv;
 	struct caam_ctrl __iomem *ctrl;
-	int ring;
 
 	ctrldev = &pdev->dev;
 	ctrlpriv = dev_get_drvdata(ctrldev);
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 
-	/* Remove platform devices for JobRs */
-	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++)
-		of_device_unregister(ctrlpriv->jrpdev[ring]);
+	/* Remove platform devices under the crypto node */
+	of_platform_depopulate(ctrldev);
 
 #ifdef CONFIG_CAAM_QI
 	if (ctrlpriv->qidev)
@@ -410,10 +408,21 @@ int caam_get_era(void)
 }
 EXPORT_SYMBOL(caam_get_era);
 
+static const struct of_device_id caam_match[] = {
+	{
+		.compatible = "fsl,sec-v4.0",
+	},
+	{
+		.compatible = "fsl,sec4.0",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, caam_match);
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ret, ring, ridx, rspec, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
 	u64 caam_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
@@ -589,21 +598,9 @@ static int caam_probe(struct platform_device *pdev)
 		goto iounmap_ctrl;
 	}
 
-	/*
-	 * Detect and enable JobRs
-	 * First, find out how many ring spec'ed, allocate references
-	 * for all, then go probe each one.
-	 */
-	rspec = 0;
-	for_each_available_child_of_node(nprop, np)
-		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
-		    of_device_is_compatible(np, "fsl,sec4.0-job-ring"))
-			rspec++;
-
-	ctrlpriv->jrpdev = devm_kcalloc(&pdev->dev, rspec,
-					sizeof(*ctrlpriv->jrpdev), GFP_KERNEL);
-	if (ctrlpriv->jrpdev == NULL) {
-		ret = -ENOMEM;
+	ret = of_platform_populate(nprop, caam_match, NULL, dev);
+	if (ret) {
+		dev_err(dev, "JR platform devices creation error\n");
 		goto iounmap_ctrl;
 	}
 
@@ -618,29 +615,19 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
 	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
 #endif
+
 	ring = 0;
-	ridx = 0;
-	ctrlpriv->total_jobrs = 0;
 	for_each_available_child_of_node(nprop, np)
 		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
-			ctrlpriv->jrpdev[ring] =
-				of_platform_device_create(np, NULL, dev);
-			if (!ctrlpriv->jrpdev[ring]) {
-				pr_warn("JR physical index %d: Platform device creation error\n",
-					ridx);
-				ridx++;
-				continue;
-			}
 			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
 					     ((__force uint8_t *)ctrl +
-					     (ridx + JR_BLOCK_NUMBER) *
+					     (ring + JR_BLOCK_NUMBER) *
 					      BLOCK_OFFSET
 					     );
 			ctrlpriv->total_jobrs++;
 			ring++;
-			ridx++;
-	}
+		}
 
 	/* Check to see if QI present. If so, enable */
 	ctrlpriv->qi_present =
@@ -849,17 +836,6 @@ static int caam_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static struct of_device_id caam_match[] = {
-	{
-		.compatible = "fsl,sec-v4.0",
-	},
-	{
-		.compatible = "fsl,sec4.0",
-	},
-	{},
-};
-MODULE_DEVICE_TABLE(of, caam_match);
-
 static struct platform_driver caam_driver = {
 	.driver = {
 		.name = "caam",
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c334df638ff6..85b6c5835b8f 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -66,7 +66,6 @@ struct caam_drv_private_jr {
 struct caam_drv_private {
 
 	struct device *dev;
-	struct platform_device **jrpdev; /* Alloc'ed array per sub-device */
 #ifdef CONFIG_CAAM_QI
 	struct device *qidev;
 #endif
-- 
2.12.0.264.gd6db3f216544
