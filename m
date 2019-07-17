Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FF2C76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ACCF21841
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oAwU80jT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfGQPZR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33364 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfGQPZQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id f20so2094989pgj.0;
        Wed, 17 Jul 2019 08:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bV3+vsfYdUaiz+6RF7MSLOXZxuAp9L2xuBfUpWj/9RU=;
        b=oAwU80jTOgg8Fc0/outMM6nhqVRm4mxmSVD47z4a6c5EXxiCRwUtV8XFQ4iW19CgTZ
         B9FBb/jFm2PRwUSoovDO07L1zIKu5/DzWXmw+1ZpTPLodujL9GFlzqrQoR17uB5LjZNX
         ca+C5xPRIYeu/T5vWRCswKEsjNxSzGK/v7NSeKurlVz1dBdV0mRh7HwVHfzvIw9zM/0P
         o3rBx8anNptrPDiOYRM3XMy9f7Z1HSutMeRMHwSKykd9NwnWnvcILYMZqUKZCSowxnkd
         Gwq/0XtWGBbbo4dZSpG/XslPVL78lxMkdr+gP9rF+qx8MUZjctCTMqK7fZXzX7qTq6Pd
         5zpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bV3+vsfYdUaiz+6RF7MSLOXZxuAp9L2xuBfUpWj/9RU=;
        b=j/PmMq5eMf5/Vo71TN9l28+T33jpDXiW1NxDyYK1KEVwxTEYGEYTYX42PfMpqmz7Td
         uuksQUSQsPPggCtbh1yfdZxV9xBNeKLe9pYNCFSlJVAS6oJ/RGNhRbFNNxZ4kQjlL4B1
         tAxcilSN4s5hnY/UIkKoS6fR+P/9q68anfnjEYR9wf4d9s26t78dpw+rWLIgAl7PP41v
         d4E1ix5o/VhM/HizYJG0t153vaT1fb8P3CLtiONF/5z2uqmlnYYSbD3hHLlSF6eLsj0X
         s6oljzTpDBadOTjcn6/rzGwyQRdm9jXji3MEZzu/A8WkbyDdvsrTlkNQWZmMnlMJx93N
         7pjg==
X-Gm-Message-State: APjAAAWXKs5w6iHbc/4RKH8aeYItndapBVc2cbFN0hgU7UNMmLU6njhT
        DkTES8Tpd1H7vTNc0UMIA6D+my0Q
X-Google-Smtp-Source: APXvYqywt+r+sIDM2/1gvtnoiPSQxa5oGVikbQtmghrkzA/L1H2w9NWyHEilwgML83QhwXn368VLag==
X-Received: by 2002:a63:ce01:: with SMTP id y1mr38299322pgf.389.1563377114991;
        Wed, 17 Jul 2019 08:25:14 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:14 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/14] crypto: caam - simplfy clock initialization
Date:   Wed, 17 Jul 2019 08:24:46 -0700
Message-Id: <20190717152458.22337-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
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
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Tested-by: Iuliana Prodan <iuliana.prodan@nxp.com>
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
 drivers/crypto/caam/ctrl.c   | 204 +++++++++++++++++------------------
 drivers/crypto/caam/intern.h |   7 +-
 2 files changed, 99 insertions(+), 112 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e674d8770cdb..592ce4a05db8 100644
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
 
@@ -497,20 +480,103 @@ static const struct of_device_id caam_match[] = {
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
+	{ /* sentinel */ }
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
@@ -527,91 +593,25 @@ static int caam_probe(struct platform_device *pdev)
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
@@ -899,16 +899,6 @@ static int caam_probe(struct platform_device *pdev)
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

