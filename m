Return-Path: <SRS0=rw2L=VZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F49C433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 19:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC3BC20679
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 19:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfG1T06 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jul 2019 15:26:58 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49018 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbfG1T05 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jul 2019 15:26:57 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D4E3D201290;
        Sun, 28 Jul 2019 21:26:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C5A9320128B;
        Sun, 28 Jul 2019 21:26:55 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 607002060A;
        Sun, 28 Jul 2019 21:26:55 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - defer probing until QMan is available
Date:   Sun, 28 Jul 2019 22:26:38 +0300
Message-Id: <20190728192638.1929-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When QI (Queue Interface) support is enabled on DPAA 1.x platforms,
defer probing if dependencies (QMan drivers) are not available yet.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
This patch was previously submitted as part of IOMMU support series:
https://patchwork.kernel.org/cover/10928833/

Re-sending since the compile dependency:
commit 1c8f39946c03 ("soc: fsl: qbman_portals: add APIs to retrieve the probing status")
is now available in cryptodev-2.6 tree.

 drivers/crypto/caam/ctrl.c | 74 ++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4e43ca4d3656..e0590beae240 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -527,15 +527,54 @@ static int caam_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ctrlpriv);
 	nprop = pdev->dev.of_node;
 
+	/* Get configuration properties from device tree */
+	/* First, get register page */
+	ctrl = of_iomap(nprop, 0);
+	if (!ctrl) {
+		dev_err(dev, "caam: of_iomap() failed\n");
+		return -ENOMEM;
+	}
+
+	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
+				  (CSTA_PLEND | CSTA_ALT_PLEND));
 	caam_imx = (bool)soc_device_match(imx_soc);
 
+	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
+	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
+	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
+
+#ifdef CONFIG_CAAM_QI
+	/* If (DPAA 1.x) QI present, check whether dependencies are available */
+	if (ctrlpriv->qi_present && !caam_dpaa2) {
+		ret = qman_is_probed();
+		if (!ret) {
+			ret = -EPROBE_DEFER;
+			goto iounmap_ctrl;
+		} else if (ret < 0) {
+			dev_err(dev, "failing probe due to qman probe error\n");
+			ret = -ENODEV;
+			goto iounmap_ctrl;
+		}
+
+		ret = qman_portals_probed();
+		if (!ret) {
+			ret = -EPROBE_DEFER;
+			goto iounmap_ctrl;
+		} else if (ret < 0) {
+			dev_err(dev, "failing probe due to qman portals probe error\n");
+			ret = -ENODEV;
+			goto iounmap_ctrl;
+		}
+	}
+#endif
+
 	/* Enable clocking */
 	clk = caam_drv_identify_clk(&pdev->dev, "ipg");
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM ipg clk: %d\n", ret);
-		return ret;
+		goto iounmap_ctrl;
 	}
 	ctrlpriv->caam_ipg = clk;
 
@@ -547,7 +586,7 @@ static int caam_probe(struct platform_device *pdev)
 			ret = PTR_ERR(clk);
 			dev_err(&pdev->dev,
 				"can't identify CAAM mem clk: %d\n", ret);
-			return ret;
+			goto iounmap_ctrl;
 		}
 		ctrlpriv->caam_mem = clk;
 	}
@@ -557,7 +596,7 @@ static int caam_probe(struct platform_device *pdev)
 		ret = PTR_ERR(clk);
 		dev_err(&pdev->dev,
 			"can't identify CAAM aclk clk: %d\n", ret);
-		return ret;
+		goto iounmap_ctrl;
 	}
 	ctrlpriv->caam_aclk = clk;
 
@@ -570,7 +609,7 @@ static int caam_probe(struct platform_device *pdev)
 			ret = PTR_ERR(clk);
 			dev_err(&pdev->dev,
 				"can't identify CAAM emi_slow clk: %d\n", ret);
-			return ret;
+			goto iounmap_ctrl;
 		}
 		ctrlpriv->caam_emi_slow = clk;
 	}
@@ -578,7 +617,7 @@ static int caam_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
-		return ret;
+		goto iounmap_ctrl;
 	}
 
 	if (ctrlpriv->caam_mem) {
@@ -605,25 +644,10 @@ static int caam_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* Get configuration properties from device tree */
-	/* First, get register page */
-	ctrl = of_iomap(nprop, 0);
-	if (ctrl == NULL) {
-		dev_err(dev, "caam: of_iomap() failed\n");
-		ret = -ENOMEM;
-		goto disable_caam_emi_slow;
-	}
-
-	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
-				  (CSTA_PLEND | CSTA_ALT_PLEND));
-
-	/* Finding the page size for using the CTPR_MS register */
-	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
-	pg_size = (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT;
-
 	/* Allocating the BLOCK_OFFSET based on the supported page size on
 	 * the platform
 	 */
+	pg_size = (comp_params & CTPR_MS_PG_SZ_MASK) >> CTPR_MS_PG_SZ_SHIFT;
 	if (pg_size == 0)
 		BLOCK_OFFSET = PG_SIZE_4K;
 	else
@@ -648,7 +672,6 @@ static int caam_probe(struct platform_device *pdev)
 	 * In case of SoCs with Management Complex, MC f/w performs
 	 * the configuration.
 	 */
-	caam_dpaa2 = !!(comp_params & CTPR_MS_DPAA2);
 	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
 	ctrlpriv->mc_en = !!np;
 	of_node_put(np);
@@ -700,7 +723,7 @@ static int caam_probe(struct platform_device *pdev)
 	}
 	if (ret) {
 		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
-		goto iounmap_ctrl;
+		goto disable_caam_emi_slow;
 	}
 
 	ctrlpriv->era = caam_get_era(ctrl);
@@ -719,7 +742,6 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 
 	/* Check to see if (DPAA 1.x) QI present. If so, enable */
-	ctrlpriv->qi_present = !!(comp_params & CTPR_MS_QI_MASK);
 	if (ctrlpriv->qi_present && !caam_dpaa2) {
 		ctrlpriv->qi = (struct caam_queue_if __iomem __force *)
 			       ((__force uint8_t *)ctrl +
@@ -906,8 +928,6 @@ static int caam_probe(struct platform_device *pdev)
 	if (ctrlpriv->qi_init)
 		caam_qi_shutdown(dev);
 #endif
-iounmap_ctrl:
-	iounmap(ctrl);
 disable_caam_emi_slow:
 	if (ctrlpriv->caam_emi_slow)
 		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
@@ -918,6 +938,8 @@ static int caam_probe(struct platform_device *pdev)
 		clk_disable_unprepare(ctrlpriv->caam_mem);
 disable_caam_ipg:
 	clk_disable_unprepare(ctrlpriv->caam_ipg);
+iounmap_ctrl:
+	iounmap(ctrl);
 	return ret;
 }
 
-- 
2.17.1

