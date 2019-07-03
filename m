Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B498EC06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0E5218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkeUm4vd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfGCIOC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33447 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfGCIOB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so819211plo.0;
        Wed, 03 Jul 2019 01:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OifUTPwtrbsJcu6VA62AeaQvTf5xpoAnkAcZtXAOudc=;
        b=RkeUm4vdTQplnZ0XHutG+0YjlWSYn2RR3xrnOtOpnjBHI5MrUr+EZ64nJqO3fiIMHW
         2I1GFBDlbXQ+bNqbrcKpbaUDkMSHnYzIFpmXlY1jc95gSKNtSbNyPgPVAtJraYNW3WeA
         Rexerdwa8iQwzLlg/n/1fW04icWqp9apaoJACzojiR17cvRlXWYCIJseh19PjwWHhwFE
         0tUSQpeLNj1sxU8dybDcSiiwO1bFFHJwj9sn+7uG5uunB8eg7LRQN4T0wKj2ASs9PuwR
         FYG9nLmr1cYV46fimhJgulDlLy7y3I5mCaJ0JSW9eL0ETLHDX0XjixwIEyi8Iyhapk4d
         H7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OifUTPwtrbsJcu6VA62AeaQvTf5xpoAnkAcZtXAOudc=;
        b=rzlACjUncwzQXCkYXo8jOi/CbXCLAdBvuh6cWqgFlKwINTc2rzTZrQogxynbSU8qnn
         UOVkIbxisWq7CVFKVbiEfKM6bdD8wwamv8B6Ji1PRF2Zwj5jxu6Y2X6UVayV/fxLhuPW
         qs3ACo8ImSfrXRM6ajBlNqX2P7f0D6bYMewo2pp7wttsOwf/QulcHKGsK3/PfEfCWXDE
         lYhCjxjDwHLR3CVrOqyqwO9nbHVG3AWeAHlLU6e5gYWSL/0VTKRbVVVI3nF6OzGa7p+g
         V8Cq/XnXOmFtoE9ztEcbGqgurHz+YJAm0b+BWsghtYPrs9sdAuFBqu8kEtsdXRPQhz0A
         Xlfg==
X-Gm-Message-State: APjAAAVDUHfDAPr7x4l9fGpfVidunzwFkxq1sQbnNDnjgpv44YwGqjoS
        nFqDc9yMFLrVcU83lBoPVoPCS7Jsb04=
X-Google-Smtp-Source: APXvYqw74n/nvcZTjUc0R/uZJgn2K8rJ499Jx4fuaW4NLJt2xKHFsoxoOr9HbTVDD1K+OVam/pJEvg==
X-Received: by 2002:a17:902:29a7:: with SMTP id h36mr41847886plb.158.1562141639924;
        Wed, 03 Jul 2019 01:13:59 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.13.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:13:59 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/16] crypto: caam - simplify clock initialization
Date:   Wed,  3 Jul 2019 01:13:13 -0700
Message-Id: <20190703081327.17505-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703081327.17505-1-andrew.smirnov@gmail.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simplify clock initialization code by converting it to use clk-bulk,
devres and soc_device_match() match table. No functional change
intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c   | 203 +++++++++++++++++------------------
 drivers/crypto/caam/intern.h |   7 +-
 2 files changed, 98 insertions(+), 112 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e674d8770cdb..908d3ecf6d1c 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -25,16 +25,6 @@ EXPORT_SYMBOL(caam_dpaa2);
 #include "qi.h"
 #endif
 
-/*
- * i.MX targets tend to have clock control subsystems that can
- * enable/disable clocking to our device.
- */
-static inline struct clk *caam_drv_identify_clk(struct device *dev,
-						char *clk_name)
-{
-	return caam_imx ? devm_clk_get(dev, clk_name) : NULL;
-}
-
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
  * load the JDKEK, TDKEK and TDSK registers
@@ -342,13 +332,6 @@ static int caam_remove(struct platform_device *pdev)
 	/* Unmap controller region */
 	iounmap(ctrl);
 
-	/* shut clocks off before finalizing shutdown */
-	clk_disable_unprepare(ctrlpriv->caam_ipg);
-	if (ctrlpriv->caam_mem)
-		clk_disable_unprepare(ctrlpriv->caam_mem);
-	clk_disable_unprepare(ctrlpriv->caam_aclk);
-	if (ctrlpriv->caam_emi_slow)
-		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
 	return 0;
 }
 
@@ -497,20 +480,102 @@ static const struct of_device_id caam_match[] = {
 };
 MODULE_DEVICE_TABLE(of, caam_match);
 
+struct caam_imx_data {
+	const struct clk_bulk_data *clks;
+	int num_clks;
+};
+
+static const struct clk_bulk_data caam_imx6_clks[] = {
+	{ .id = "ipg" },
+	{ .id = "mem" },
+	{ .id = "aclk" },
+	{ .id = "emi_slow" },
+};
+
+static const struct caam_imx_data caam_imx6_data = {
+	.clks = caam_imx6_clks,
+	.num_clks = ARRAY_SIZE(caam_imx6_clks),
+};
+
+static const struct clk_bulk_data caam_imx7_clks[] = {
+	{ .id = "ipg" },
+	{ .id = "aclk" },
+};
+
+static const struct caam_imx_data caam_imx7_data = {
+	.clks = caam_imx7_clks,
+	.num_clks = ARRAY_SIZE(caam_imx7_clks),
+};
+
+static const struct clk_bulk_data caam_imx6ul_clks[] = {
+	{ .id = "ipg" },
+	{ .id = "mem" },
+	{ .id = "aclk" },
+};
+
+static const struct caam_imx_data caam_imx6ul_data = {
+	.clks = caam_imx6ul_clks,
+	.num_clks = ARRAY_SIZE(caam_imx6ul_clks),
+};
+
+static const struct soc_device_attribute caam_imx_soc_table[] = {
+	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
+	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
+	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
+	{ .family = "Freescale i.MX" },
+};
+
+static void disable_clocks(void *data)
+{
+	struct caam_drv_private *ctrlpriv = data;
+
+	clk_bulk_disable_unprepare(ctrlpriv->num_clks, ctrlpriv->clks);
+}
+
+static int init_clocks(struct device *dev,
+		       struct caam_drv_private *ctrlpriv,
+		       const struct caam_imx_data *data)
+{
+	int ret;
+
+	ctrlpriv->num_clks = data->num_clks;
+	ctrlpriv->clks = devm_kmemdup(dev, data->clks,
+				      data->num_clks * sizeof(data->clks[0]),
+				      GFP_KERNEL);
+	if (!ctrlpriv->clks)
+		return -ENOMEM;
+
+	ret = devm_clk_bulk_get(dev, ctrlpriv->num_clks, ctrlpriv->clks);
+	if (ret) {
+		dev_err(dev,
+			"Failed to request all necessary clocks\n");
+		return ret;
+	}
+
+	ret = clk_bulk_prepare_enable(ctrlpriv->num_clks, ctrlpriv->clks);
+	if (ret) {
+		dev_err(dev,
+			"Failed to prepare/enable all necessary clocks\n");
+		return ret;
+	}
+
+	ret = devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
 	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
 	u64 caam_id;
-	static const struct soc_device_attribute imx_soc[] = {
-		{.family = "Freescale i.MX"},
-		{},
-	};
+	const struct soc_device_attribute *imx_soc_match;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_drv_private *ctrlpriv;
-	struct clk *clk;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
@@ -527,91 +592,25 @@ static int caam_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ctrlpriv);
 	nprop = pdev->dev.of_node;
 
-	caam_imx = (bool)soc_device_match(imx_soc);
-
-	/* Enable clocking */
-	clk = caam_drv_identify_clk(&pdev->dev, "ipg");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		dev_err(&pdev->dev,
-			"can't identify CAAM ipg clk: %d\n", ret);
-		return ret;
-	}
-	ctrlpriv->caam_ipg = clk;
-
-	if (!of_machine_is_compatible("fsl,imx7d") &&
-	    !of_machine_is_compatible("fsl,imx7s") &&
-	    !of_machine_is_compatible("fsl,imx7ulp")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "mem");
-		if (IS_ERR(clk)) {
-			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM mem clk: %d\n", ret);
-			return ret;
+	imx_soc_match = soc_device_match(caam_imx_soc_table);
+	if (imx_soc_match) {
+		if (!imx_soc_match->data) {
+			dev_err(dev, "No clock data provided for i.MX SoC");
+			return -EINVAL;
 		}
-		ctrlpriv->caam_mem = clk;
-	}
 
-	clk = caam_drv_identify_clk(&pdev->dev, "aclk");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		dev_err(&pdev->dev,
-			"can't identify CAAM aclk clk: %d\n", ret);
-		return ret;
-	}
-	ctrlpriv->caam_aclk = clk;
-
-	if (!of_machine_is_compatible("fsl,imx6ul") &&
-	    !of_machine_is_compatible("fsl,imx7d") &&
-	    !of_machine_is_compatible("fsl,imx7s") &&
-	    !of_machine_is_compatible("fsl,imx7ulp")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
-		if (IS_ERR(clk)) {
-			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM emi_slow clk: %d\n", ret);
+		ret = init_clocks(dev, ctrlpriv, imx_soc_match->data);
+		if (ret)
 			return ret;
-		}
-		ctrlpriv->caam_emi_slow = clk;
-	}
-
-	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
-		return ret;
-	}
-
-	if (ctrlpriv->caam_mem) {
-		ret = clk_prepare_enable(ctrlpriv->caam_mem);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
-				ret);
-			goto disable_caam_ipg;
-		}
-	}
-
-	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
-		goto disable_caam_mem;
-	}
-
-	if (ctrlpriv->caam_emi_slow) {
-		ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
-				ret);
-			goto disable_caam_aclk;
-		}
 	}
+	caam_imx = (bool)imx_soc_match;
 
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
 	if (ctrl == NULL) {
 		dev_err(dev, "caam: of_iomap() failed\n");
-		ret = -ENOMEM;
-		goto disable_caam_emi_slow;
+		return -ENOMEM;
 	}
 
 	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
@@ -899,16 +898,6 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 iounmap_ctrl:
 	iounmap(ctrl);
-disable_caam_emi_slow:
-	if (ctrlpriv->caam_emi_slow)
-		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
-disable_caam_aclk:
-	clk_disable_unprepare(ctrlpriv->caam_aclk);
-disable_caam_mem:
-	if (ctrlpriv->caam_mem)
-		clk_disable_unprepare(ctrlpriv->caam_mem);
-disable_caam_ipg:
-	clk_disable_unprepare(ctrlpriv->caam_ipg);
 	return ret;
 }
 
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index ec25d260fa40..1f01703f510a 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -94,11 +94,8 @@ struct caam_drv_private {
 				   Handles of the RNG4 block are initialized
 				   by this driver */
 
-	struct clk *caam_ipg;
-	struct clk *caam_mem;
-	struct clk *caam_aclk;
-	struct clk *caam_emi_slow;
-
+	struct clk_bulk_data *clks;
+	int num_clks;
 	/*
 	 * debugfs entries for developer view into driver/device
 	 * variables at runtime.
-- 
2.21.0

