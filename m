From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 03/12] crypto: caam - fix JR IO mapping if one fails
Date: Fri, 10 Feb 2017 14:07:16 +0200
Message-ID: <1486728445-13047-4-git-send-email-horia.geanta@nxp.com>
References: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        "Cristian Stoica" <cristian.stoica@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0060.outbound.protection.outlook.com ([104.47.41.60]:50819
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753304AbdBJMHv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2017 07:07:51 -0500
In-Reply-To: <1486728445-13047-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

If one of the JRs failed at init, the next JR used
the failed JR's IO space. The patch fixes this bug.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index f825e3765a4b..579f8263c479 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -308,10 +308,8 @@ static int caam_remove(struct platform_device *pdev)
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 
 	/* Remove platform devices for JobRs */
-	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
-		if (ctrlpriv->jrpdev[ring])
-			of_device_unregister(ctrlpriv->jrpdev[ring]);
-	}
+	for (ring = 0; ring < ctrlpriv->total_jobrs; ring++)
+		of_device_unregister(ctrlpriv->jrpdev[ring]);
 
 	/* De-initialize RNG state handles initialized by this driver. */
 	if (ctrlpriv->rng4_sh_init)
@@ -423,7 +421,7 @@ DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int ret, ring, rspec, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	int ret, ring, ridx, rspec, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
 	u64 caam_id;
 	struct device *dev;
 	struct device_node *nprop, *np;
@@ -618,6 +616,7 @@ static int caam_probe(struct platform_device *pdev)
 	}
 
 	ring = 0;
+	ridx = 0;
 	ctrlpriv->total_jobrs = 0;
 	for_each_available_child_of_node(nprop, np)
 		if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
@@ -625,17 +624,19 @@ static int caam_probe(struct platform_device *pdev)
 			ctrlpriv->jrpdev[ring] =
 				of_platform_device_create(np, NULL, dev);
 			if (!ctrlpriv->jrpdev[ring]) {
-				pr_warn("JR%d Platform device creation error\n",
-					ring);
+				pr_warn("JR physical index %d: Platform device creation error\n",
+					ridx);
+				ridx++;
 				continue;
 			}
 			ctrlpriv->jr[ring] = (struct caam_job_ring __iomem __force *)
 					     ((__force uint8_t *)ctrl +
-					     (ring + JR_BLOCK_NUMBER) *
+					     (ridx + JR_BLOCK_NUMBER) *
 					      BLOCK_OFFSET
 					     );
 			ctrlpriv->total_jobrs++;
 			ring++;
+			ridx++;
 	}
 
 	/* Check to see if QI present. If so, enable */
-- 
2.4.4
