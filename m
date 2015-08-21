From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 1/3] crypto: caam: ctrl: Fix the error handling
Date: Fri, 21 Aug 2015 13:51:58 -0300
Message-ID: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:36201 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbHUQwY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 12:52:24 -0400
Received: by ykfw73 with SMTP id w73so76260160ykf.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 09:52:23 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

In the error path we should disable the resources that were previously
acquired, so fix the error handling accordingly.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v2:
- Add a missing "ret = -ENOMEM"

 drivers/crypto/caam/ctrl.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 81b552d..cd22849 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -474,27 +474,27 @@ static int caam_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 
 	ret = clk_prepare_enable(ctrlpriv->caam_mem);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
 			ret);
-		return -ENODEV;
+		goto disable_caam_ipg;
 	}
 
 	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
-		return -ENODEV;
+		goto disable_caam_mem;
 	}
 
 	ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
 			ret);
-		return -ENODEV;
+		goto disable_caam_aclk;
 	}
 
 	/* Get configuration properties from device tree */
@@ -502,7 +502,8 @@ static int caam_probe(struct platform_device *pdev)
 	ctrl = of_iomap(nprop, 0);
 	if (ctrl == NULL) {
 		dev_err(dev, "caam: of_iomap() failed\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto disable_caam_emi_slow;
 	}
 	/* Finding the page size for using the CTPR_MS register */
 	comp_params = rd_reg32(&ctrl->perfmon.comp_parms_ms);
@@ -586,8 +587,8 @@ static int caam_probe(struct platform_device *pdev)
 					sizeof(struct platform_device *) * rspec,
 					GFP_KERNEL);
 	if (ctrlpriv->jrpdev == NULL) {
-		iounmap(ctrl);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto iounmap_ctrl;
 	}
 
 	ring = 0;
@@ -627,8 +628,8 @@ static int caam_probe(struct platform_device *pdev)
 	/* If no QI and no rings specified, quit and go home */
 	if ((!ctrlpriv->qi_present) && (!ctrlpriv->total_jobrs)) {
 		dev_err(dev, "no queues configured, terminating\n");
-		caam_remove(pdev);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto caam_remove;
 	}
 
 	cha_vid_ls = rd_reg32(&ctrl->perfmon.cha_id_ls);
@@ -685,8 +686,7 @@ static int caam_probe(struct platform_device *pdev)
 		} while ((ret == -EAGAIN) && (ent_delay < RTSDCTL_ENT_DLY_MAX));
 		if (ret) {
 			dev_err(dev, "failed to instantiate RNG");
-			caam_remove(pdev);
-			return ret;
+			goto caam_remove;
 		}
 		/*
 		 * Set handles init'ed by this module as the complement of the
@@ -790,6 +790,20 @@ static int caam_probe(struct platform_device *pdev)
 						 &ctrlpriv->ctl_tdsk_wrap);
 #endif
 	return 0;
+
+caam_remove:
+	caam_remove(pdev);
+iounmap_ctrl:
+	iounmap(ctrl);
+disable_caam_emi_slow:
+	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
+disable_caam_aclk:
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+disable_caam_mem:
+	clk_disable_unprepare(ctrlpriv->caam_mem);
+disable_caam_ipg:
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+	return ret;
 }
 
 static struct of_device_id caam_match[] = {
-- 
1.9.1
