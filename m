Return-Path: <SRS0=RoO8=UG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5694AC2BCA1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B024208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX7vZuOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfFGUDG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jun 2019 16:03:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38827 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfFGUDF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jun 2019 16:03:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so1778728pfa.5;
        Fri, 07 Jun 2019 13:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Snb3+O5MUDSAg7K6dE+Xn6x9pSvoO9OAjunZXuIUolc=;
        b=aX7vZuOffMBEb7QHm9P2ZvMB757LCoczbzACEb+BaGJZyucgM2Il8qSNuf9XPln1Bq
         wFn2rfcQXqFfd//Sca2ijdVRE4xAIwkuAs+1rpo+KM0ljBiUmv0bK6O1NzW0OMJ2JXe+
         2AcP6kn9pd8xPlE4qfutdZQ9XvnwuVp9zY8NATsSDBCBHaYldKoT0KnY7uOh0S+yX1Sq
         z2wgpW9Ts7H1gaB3fBokpbK3ZKQGk+01Dbesgff/tFEoPAcfh3dLmLyaOU+TSnvq6b3s
         uZWkkixtcI3fRU5Mjt3L92Bzqs+u3k41/5SyIzwDemJOFi8/8fC/ABs8hJvSyZXqfg4B
         hXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Snb3+O5MUDSAg7K6dE+Xn6x9pSvoO9OAjunZXuIUolc=;
        b=UpnWdjYCc5/4jPpyCY1leCjX8zzyYpDjcGpy1YnLAeagaBD0CP1eUU/JBlYp5MIpXe
         WsYfwGc5FUO0HZmnw+avC3gItSs+6KUE9VbUnLMLAjsKxo98opm2pPF5ttpY55qlB/dh
         YB/5azAP05ulRJW9b1j14BIPWQ/EtUmRu/kps6Ns4h4bXs/JfJNe7DdguGKJToUQrsIS
         u84bq7v3ohov7t03Nki+Ug9pLc0bpyH2xOgLeRwq+qwfvziAXynwUmYYZ/+HmX5tPabh
         uuFec3ijyOKU53b9RkpZZ6K5407+28/eE5ghCp560DxGkL5BjVe5E6RGNwA8500vSnLo
         6lxQ==
X-Gm-Message-State: APjAAAVGpSo3rvgfHdhfU5WJUG4cs8FvzA7Er7PKtR98OgHDzib1CIO2
        DFfDkRPT8sliKTiQhy0whMSxJxG+ocQ=
X-Google-Smtp-Source: APXvYqz7eHciydu3nDxS7Ch2n5zg7fCi7u9lAMXmxBKx1lVUI9G19W08YcXjCxfF3Vra5HI/68qB3A==
X-Received: by 2002:a63:144e:: with SMTP id 14mr4593978pgu.304.1559937784484;
        Fri, 07 Jun 2019 13:03:04 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id s5sm3289405pgj.60.2019.06.07.13.03.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:03:03 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the i.MX8
Date:   Fri,  7 Jun 2019 13:02:22 -0700
Message-Id: <20190607200225.21419-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607200225.21419-1-andrew.smirnov@gmail.com>
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Chris Spencer <christopher.spencer@sea.co.uk>

There are no clocks that the CAAM driver needs to initialise on the
i.MX8.

Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Chris Spencer <christopher.spencer@sea.co.uk>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 146 +++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index fec39c35c877..39334e71a14f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -309,6 +309,19 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 	return ret;
 }
 
+static void disable_clocking(struct caam_drv_private *ctrlpriv)
+{
+	if (of_machine_is_compatible("fsl,imx8mq"))
+		return;
+
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+	if (ctrlpriv->caam_mem)
+		clk_disable_unprepare(ctrlpriv->caam_mem);
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+	if (ctrlpriv->caam_emi_slow)
+		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
+}
+
 static int caam_remove(struct platform_device *pdev)
 {
 	struct device *ctrldev;
@@ -343,12 +356,8 @@ static int caam_remove(struct platform_device *pdev)
 	iounmap(ctrl);
 
 	/* shut clocks off before finalizing shutdown */
-	clk_disable_unprepare(ctrlpriv->caam_ipg);
-	if (ctrlpriv->caam_mem)
-		clk_disable_unprepare(ctrlpriv->caam_mem);
-	clk_disable_unprepare(ctrlpriv->caam_aclk);
-	if (ctrlpriv->caam_emi_slow)
-		clk_disable_unprepare(ctrlpriv->caam_emi_slow);
+	disable_clocking(ctrlpriv);
+
 	return 0;
 }
 
@@ -497,65 +506,38 @@ static const struct of_device_id caam_match[] = {
 };
 MODULE_DEVICE_TABLE(of, caam_match);
 
-/* Probe routine for CAAM top (controller) level */
-static int caam_probe(struct platform_device *pdev)
+static int init_clocking(struct device *dev, struct caam_drv_private *ctrlpriv)
 {
-	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
-	u64 caam_id;
-	static const struct soc_device_attribute imx_soc[] = {
-		{.family = "Freescale i.MX"},
-		{},
-	};
-	struct device *dev;
-	struct device_node *nprop, *np;
-	struct caam_ctrl __iomem *ctrl;
-	struct caam_drv_private *ctrlpriv;
 	struct clk *clk;
-#ifdef CONFIG_DEBUG_FS
-	struct caam_perfmon *perfmon;
-#endif
-	u32 scfgr, comp_params;
-	u8 rng_vid;
-	int pg_size;
-	int BLOCK_OFFSET = 0;
-
-	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
-	if (!ctrlpriv)
-		return -ENOMEM;
-
-	dev = &pdev->dev;
-	dev_set_drvdata(dev, ctrlpriv);
-	nprop = pdev->dev.of_node;
+	int ret;
 
-	caam_imx = (bool)soc_device_match(imx_soc);
+	if (of_machine_is_compatible("fsl,imx8mq"))
+		return 0;
 
 	/* Enable clocking */
-	clk = caam_drv_identify_clk(&pdev->dev, "ipg");
+	clk = caam_drv_identify_clk(dev, "ipg");
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
-		dev_err(&pdev->dev,
-			"can't identify CAAM ipg clk: %d\n", ret);
+		dev_err(dev, "can't identify CAAM ipg clk: %d\n", ret);
 		return ret;
 	}
 	ctrlpriv->caam_ipg = clk;
 
 	if (!of_machine_is_compatible("fsl,imx7d") &&
 	    !of_machine_is_compatible("fsl,imx7s")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "mem");
+		clk = caam_drv_identify_clk(dev, "mem");
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM mem clk: %d\n", ret);
+			dev_err(dev, "can't identify CAAM mem clk: %d\n", ret);
 			return ret;
 		}
 		ctrlpriv->caam_mem = clk;
 	}
 
-	clk = caam_drv_identify_clk(&pdev->dev, "aclk");
+	clk = caam_drv_identify_clk(dev, "aclk");
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
-		dev_err(&pdev->dev,
-			"can't identify CAAM aclk clk: %d\n", ret);
+		dev_err(dev, "can't identify CAAM aclk clk: %d\n", ret);
 		return ret;
 	}
 	ctrlpriv->caam_aclk = clk;
@@ -563,11 +545,11 @@ static int caam_probe(struct platform_device *pdev)
 	if (!of_machine_is_compatible("fsl,imx6ul") &&
 	    !of_machine_is_compatible("fsl,imx7d") &&
 	    !of_machine_is_compatible("fsl,imx7s")) {
-		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
+		clk = caam_drv_identify_clk(dev, "emi_slow");
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
-			dev_err(&pdev->dev,
-				"can't identify CAAM emi_slow clk: %d\n", ret);
+			dev_err(dev, "can't identify CAAM emi_slow clk: %d\n",
+				ret);
 			return ret;
 		}
 		ctrlpriv->caam_emi_slow = clk;
@@ -575,14 +557,15 @@ static int caam_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
+		dev_err(dev, "can't enable CAAM ipg clock: %d\n", ret);
 		return ret;
 	}
 
 	if (ctrlpriv->caam_mem) {
 		ret = clk_prepare_enable(ctrlpriv->caam_mem);
 		if (ret < 0) {
-			dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
+			dev_err(dev,
+				"can't enable CAAM secure mem clock: %d\n",
 				ret);
 			goto disable_caam_ipg;
 		}
@@ -590,26 +573,74 @@ static int caam_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
+		dev_err(dev, "can't enable CAAM aclk clock: %d\n", ret);
 		goto disable_caam_mem;
 	}
 
 	if (ctrlpriv->caam_emi_slow) {
 		ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
 		if (ret < 0) {
-			dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
+			dev_err(dev, "can't enable CAAM emi slow clock: %d\n",
 				ret);
 			goto disable_caam_aclk;
 		}
 	}
 
+	return 0;
+
+disable_caam_aclk:
+	clk_disable_unprepare(ctrlpriv->caam_aclk);
+disable_caam_mem:
+	if (ctrlpriv->caam_mem)
+		clk_disable_unprepare(ctrlpriv->caam_mem);
+disable_caam_ipg:
+	clk_disable_unprepare(ctrlpriv->caam_ipg);
+
+	return ret;
+}
+
+/* Probe routine for CAAM top (controller) level */
+static int caam_probe(struct platform_device *pdev)
+{
+	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
+	u64 caam_id;
+	static const struct soc_device_attribute imx_soc[] = {
+		{.family = "Freescale i.MX"},
+		{},
+	};
+	struct device *dev;
+	struct device_node *nprop, *np;
+	struct caam_ctrl __iomem *ctrl;
+	struct caam_drv_private *ctrlpriv;
+#ifdef CONFIG_DEBUG_FS
+	struct caam_perfmon *perfmon;
+#endif
+	u32 scfgr, comp_params;
+	u8 rng_vid;
+	int pg_size;
+	int BLOCK_OFFSET = 0;
+
+	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
+	if (!ctrlpriv)
+		return -ENOMEM;
+
+	dev = &pdev->dev;
+	dev_set_drvdata(dev, ctrlpriv);
+	nprop = pdev->dev.of_node;
+
+	caam_imx = (bool)soc_device_match(imx_soc);
+
+	ret = init_clocking(dev, ctrlpriv);
+	if (ret)
+		return ret;
+
 	/* Get configuration properties from device tree */
 	/* First, get register page */
 	ctrl = of_iomap(nprop, 0);
 	if (ctrl == NULL) {
 		dev_err(dev, "caam: of_iomap() failed\n");
 		ret = -ENOMEM;
-		goto disable_caam_emi_slow;
+		goto disable_clocks;
 	}
 
 	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
@@ -900,16 +931,9 @@ static int caam_probe(struct platform_device *pdev)
 
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
+disable_clocks:
+	disable_clocking(ctrlpriv);
+
 	return ret;
 }
 
-- 
2.21.0

