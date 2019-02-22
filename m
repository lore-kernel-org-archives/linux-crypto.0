Return-Path: <SRS0=rdxF=Q5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA07C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79E92075C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Feb 2019 10:07:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rCFKWF51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfBVKH3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:07:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51830 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVKH3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Feb 2019 05:07:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id n19so1410050wmi.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 Feb 2019 02:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pmtnV0qppYAq+s99QeWge5xaI5j1Gnl6FwPPcwvmLus=;
        b=rCFKWF51ccaQ+XOaQitsNffWao/FwqBhvMTJSIziFN+cKFJNNsQStTYAGPVjNCoEvb
         p5Nm+sWG48iOYpY5t7/zZSDvxwmNi9uUmgTlCp0FbN6c5ZQm+MiY9GRP3oO+EjT97Cv6
         BE6u56ImGvbyA+JqhpouR09HLNFRoWUN9r8egonRAjWvF254f1tkiIKWRhAt7CftGwjV
         RrX0mBNfyerANfHWogjpqpzQklb4kAtFaIR85lowhSdAUYgTj1DKWZ3ouTztoFDuR5xb
         JHcFMvkN9EziFJRPsRAhHjLhvwlQIVujQKE7mjHO9xDit8gCqfIt9/SOfkhvG7yCJZgq
         P2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pmtnV0qppYAq+s99QeWge5xaI5j1Gnl6FwPPcwvmLus=;
        b=sSB0zh94YmwuDSNuu+pOkKmBRGect7EJMuYmlOn5mT9gn6EZs737rbX/ML0sofZ+SW
         NkimLRR+/zkC+bINwcGy/YIpplBZlYj6BGS7SEw28UdadGMUj324ddAZrHkVvHFXxXTq
         Sob4RLncT/07fhmU7zsQds4JFbZrf1cG/+AtwLVHaqLdmdNnadhAT5LUTuKWeghei8cm
         4kdt+zwojXUWT5odnk3hCdrY8DhAdveYSIJqbqFzHIE22jVZAJokQtyWw0HhLXDKtdro
         9sQCIenYnjCef8z8w5zNygiD6aA05oBFAqngZ8ZfYntihbcCpHxuiT93rdpYFofrlHKr
         mImg==
X-Gm-Message-State: AHQUAuZN6/6e2h3wVoZlFkqQLD5DqR8fndOwlnR9HzuN6oKXjRDVr4j7
        8icQJLtH+2z4IzlsCtA+dGK50HJlhnY=
X-Google-Smtp-Source: AHgI3IZObAPgZqZ5UTCs47t2iQRvay/1ooeTGRMXtDjIwlIlwvuCrzpjEUz4Z4TjupcEjbQin3/lsQ==
X-Received: by 2002:a1c:ef11:: with SMTP id n17mr1914157wmh.112.1550830046448;
        Fri, 22 Feb 2019 02:07:26 -0800 (PST)
Received: from roadflow-linux-dev.dtes.tfl.gov.uk (host81-149-116-186.in-addr.btopenworld.com. [81.149.116.186])
        by smtp.gmail.com with ESMTPSA id j41sm2094240wre.9.2019.02.22.02.07.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:07:25 -0800 (PST)
From:   spencercw@gmail.com
X-Google-Original-From: christopher.spencer@sea.co.uk
To:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     linux-crypto@vger.kernel.org,
        Chris Spencer <christopher.spencer@sea.co.uk>
Subject: [RFC 2/4] crypto: caam - do not initialise clocks on the i.MX8
Date:   Fri, 22 Feb 2019 10:06:11 +0000
Message-Id: <20190222100613.2290-3-christopher.spencer@sea.co.uk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

There are no clocks that the CAAM driver needs to initialise on the
i.MX8.

Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
---
 drivers/crypto/caam/ctrl.c   | 180 +++++++++++++++++++----------------
 drivers/crypto/caam/intern.h |   1 +
 2 files changed, 99 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 22cb7106133a..1f841f37ce3c 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -472,6 +472,91 @@ static int caam_get_era(struct caam_ctrl __iomem *ctrl)
 		return caam_get_era_from_hw(ctrl);
 }
 
+static int init_clocks(struct caam_drv_private *ctrlpriv)
+{
+	struct clk *clk;
+	struct device *dev = ctrlpriv->dev;
+	int ret = 0;
+
+	/* Enable clocking */
+	clk = caam_drv_identify_clk(dev, "ipg");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(dev, "can't identify CAAM ipg clk: %d\n", ret);
+		goto exit;
+	}
+	ctrlpriv->caam_ipg = clk;
+
+	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
+	if (ret < 0) {
+		dev_err(dev, "can't enable CAAM ipg clock: %d\n", ret);
+		goto exit;
+	}
+
+	clk = caam_drv_identify_clk(dev, "aclk");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(dev, "can't identify CAAM aclk clk: %d\n", ret);
+		goto disable_caam_ipg;
+	}
+	ctrlpriv->caam_aclk = clk;
+
+	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
+	if (ret < 0) {
+		dev_err(dev, "can't enable CAAM aclk clock: %d\n", ret);
+		goto disable_caam_ipg;
+	}
+
+	if (!of_machine_is_compatible("fsl,imx7d") &&
+	    !of_machine_is_compatible("fsl,imx7s")) {
+		clk = caam_drv_identify_clk(dev, "mem");
+		if (IS_ERR(clk)) {
+			ret = PTR_ERR(clk);
+			dev_err(dev, "can't identify CAAM mem clk: %d\n", ret);
+			goto disable_caam_aclk;
+		}
+		ctrlpriv->caam_mem = clk;
+
+		ret = clk_prepare_enable(ctrlpriv->caam_mem);
+		if (ret < 0) {
+			dev_err(dev, "can't enable CAAM secure mem clock: %d\n",
+				ret);
+			goto disable_caam_aclk;
+		}
+
+		if (!of_machine_is_compatible("fsl,imx6ul")) {
+			clk = caam_drv_identify_clk(dev, "emi_slow");
+			if (IS_ERR(clk)) {
+				ret = PTR_ERR(clk);
+				dev_err(dev,
+					"can't identify CAAM emi_slow clk: %d\n",
+					ret);
+				goto disable_caam_mem;
+			}
+			ctrlpriv->caam_emi_slow = clk;
+
+			ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
+			if (ret < 0) {
+				dev_err(dev,
+					"can't enable CAAM emi slow clock: %d\n",
+					ret);
+				goto disable_caam_mem;
+			}
+		}
+	}
+
+	goto exit;
+
+disable_caam_mem:
+	clk_disable_unprepare(ctrlpriv->caam_mem);
+disable_caam_aclk:
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+disable_caam_ipg:
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+exit:
+	return ret;
+}
+
 static const struct of_device_id caam_match[] = {
 	{
 		.compatible = "fsl,sec-v4.0",
@@ -496,7 +581,6 @@ static int caam_probe(struct platform_device *pdev)
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_drv_private *ctrlpriv;
-	struct clk *clk;
 #ifdef CONFIG_DEBUG_FS
 	struct caam_perfmon *perfmon;
 #endif
@@ -511,83 +595,16 @@ static int caam_probe(struct platform_device *pdev)
 
 	dev = &pdev->dev;
 	dev_set_drvdata(dev, ctrlpriv);
+	ctrlpriv->dev = dev;
 	nprop = pdev->dev.of_node;
 
 	caam_imx = soc_device_match(imx_soc) ||
 		of_machine_is_compatible("fsl,imx8mq");
 
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
-	    !of_machine_is_compatible("fsl,imx7s")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "mem");
-		if (IS_ERR(clk)) {
-			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM mem clk: %d\n", ret);
-			return ret;
-		}
-		ctrlpriv->caam_mem = clk;
-	}
-
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
-	    !of_machine_is_compatible("fsl,imx7s")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
-		if (IS_ERR(clk)) {
-			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM emi_slow clk: %d\n", ret);
-			return ret;
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
+	if (!of_machine_is_compatible("fsl,imx8mq")) {
+		ret = init_clocks(ctrlpriv);
+		if (ret)
+			goto exit;
 	}
 
 	/* Get configuration properties from device tree */
@@ -596,7 +613,7 @@ static int caam_probe(struct platform_device *pdev)
 	if (ctrl == NULL) {
 		dev_err(dev, "caam: of_iomap() failed\n");
 		ret = -ENOMEM;
-		goto disable_caam_emi_slow;
+		goto disable_clocks;
 	}
 
 	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
@@ -894,16 +911,15 @@ static int caam_probe(struct platform_device *pdev)
 
 iounmap_ctrl:
 	iounmap(ctrl);
-disable_caam_emi_slow:
-	if (ctrlpriv->caam_emi_slow)
+disable_clocks:
+	if (!of_machine_is_compatible("fsl,imx8mq")) {
 		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
-disable_caam_aclk:
-	clk_disable_unprepare(ctrlpriv->caam_aclk);
-disable_caam_mem:
-	if (ctrlpriv->caam_mem)
+		clk_disable_unprepare(ctrlpriv->caam_aclk);
 		clk_disable_unprepare(ctrlpriv->caam_mem);
-disable_caam_ipg:
-	clk_disable_unprepare(ctrlpriv->caam_ipg);
+		clk_disable_unprepare(ctrlpriv->caam_ipg);
+	}
+
+exit:
 	return ret;
 }
 
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index babc78abd155..a4baa6a3d2f1 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -68,6 +68,7 @@ struct caam_drv_private {
 #ifdef CONFIG_CAAM_QI
 	struct device *qidev;
 #endif
+	struct device *dev;
 
 	/* Physical-presence section */
 	struct caam_ctrl __iomem *ctrl; /* controller region */
-- 
2.17.1

