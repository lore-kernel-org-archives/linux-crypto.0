Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E73C3A5A2
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE2722CF8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 02:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PIelyfrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfIDCfk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:35:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43241 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbfIDCfj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 22:35:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id u72so6147327pgb.10;
        Tue, 03 Sep 2019 19:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VBYI9fYSI2nwboVcyiJxwUOgiBRwP/UdUW2a0Ojdh5g=;
        b=PIelyfrAXDiumhGRN4EjKHVTz8kwW9LilaHYfvmElZBKbdCVullDzD9Ne6yDZZ1QOv
         Wiq/+ts2cQaODhSncAwQ62j3JAmwFPBEwh/B+7l8WrJO91+Otn2FiJx0Qd0Tp3S+Fcwf
         JnnEqzoMMSOqdFGe7nE7/t45YUHLSpiDIUsoNSLk/d4I8g3j4l2KgKA8UGf2bJ5q8glx
         IKmi1h+HFfhFdHVMh1mS+ZFf983QuMrVVqnRbp/WJ8OHXbuk2igaW/h0033f84aC2kUw
         09hA1ytd15j4zSVaag53xBnV/TnROOadTyxbleeyz7GDRmpPsQqtvBPpf/U2zxkwCyIV
         m/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VBYI9fYSI2nwboVcyiJxwUOgiBRwP/UdUW2a0Ojdh5g=;
        b=QcKcLyRFQbB9/XLB7Clp5EMobzq/jYLwAh3JrLCb0+mbPQ9xk5HM7w27aoKiXJyK4T
         byUMO4a5UhTu+XklrWlrik6LQ0PWLV/xaaVeS5yVv8KMyZy5hTx6Tl+e5vN9hcgZZqtj
         ZzgTkYVW6E3XWzGutzIvtaeNz7XQ69qdQrxyahCWFsCunz8H5bZivYMUYjgojIUrDLtI
         o1uoLdD5YT1d311M/ggddz56qCLRa+6PU7goZRt5PSfbvwZG9V7UfJ9yihfRN7qdvpfI
         B7iEciJUcaak0AoKw70I+27HdGhUHdLsHLgDJ2RqaR1E2QzwImIw/cL9psC/5gA/cwDE
         9lvw==
X-Gm-Message-State: APjAAAUmDJWYr9PcG00RHFSnob6pGITwN4xrksyny1CuBo5nXN+ghILa
        /tOnvp5tSUGZ1T8jmjsJcSIMCjHJFEE=
X-Google-Smtp-Source: APXvYqwbNaCiBRsKe1mxnFrqF9NZwtUDANOKU0kvpPSpBPZk6/adsZ8v83rhU3tryOl/O0h96Xch9w==
X-Received: by 2002:a62:63c1:: with SMTP id x184mr45048290pfb.11.1567564537345;
        Tue, 03 Sep 2019 19:35:37 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id i74sm7480250pfe.28.2019.09.03.19.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 19:35:36 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] crypto: caam - use devres to unmap memory
Date:   Tue,  3 Sep 2019 19:35:08 -0700
Message-Id: <20190904023515.7107-6-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904023515.7107-1-andrew.smirnov@gmail.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devres to unmap memory and drop corresponding iounmap() call.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index db22777d59b4..35bf82d1bedc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -308,11 +308,9 @@ static int caam_remove(struct platform_device *pdev)
 {
 	struct device *ctrldev;
 	struct caam_drv_private *ctrlpriv;
-	struct caam_ctrl __iomem *ctrl;
 
 	ctrldev = &pdev->dev;
 	ctrlpriv = dev_get_drvdata(ctrldev);
-	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
 
 	/* Remove platform devices under the crypto node */
 	of_platform_depopulate(ctrldev);
@@ -334,9 +332,6 @@ static int caam_remove(struct platform_device *pdev)
 	debugfs_remove_recursive(ctrlpriv->dfs_root);
 #endif
 
-	/* Unmap controller region */
-	iounmap(ctrl);
-
 	return 0;
 }
 
@@ -611,10 +606,11 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* Get configuration properties from device tree */
 	/* First, get register page */
-	ctrl = of_iomap(nprop, 0);
-	if (!ctrl) {
+	ctrl = devm_of_iomap(dev, nprop, 0, NULL);
+	ret = PTR_ERR_OR_ZERO(ctrl);
+	if (ret) {
 		dev_err(dev, "caam: of_iomap() failed\n");
-		return -ENOMEM;
+		return ret;
 	}
 
 	caam_little_end = !(bool)(rd_reg32(&ctrl->perfmon.status) &
@@ -632,22 +628,18 @@ static int caam_probe(struct platform_device *pdev)
 	if (ctrlpriv->qi_present && !caam_dpaa2) {
 		ret = qman_is_probed();
 		if (!ret) {
-			ret = -EPROBE_DEFER;
-			goto iounmap_ctrl;
+			return -EPROBE_DEFER;
 		} else if (ret < 0) {
 			dev_err(dev, "failing probe due to qman probe error\n");
-			ret = -ENODEV;
-			goto iounmap_ctrl;
+			return -ENODEV;
 		}
 
 		ret = qman_portals_probed();
 		if (!ret) {
-			ret = -EPROBE_DEFER;
-			goto iounmap_ctrl;
+			return -EPROBE_DEFER;
 		} else if (ret < 0) {
 			dev_err(dev, "failing probe due to qman portals probe error\n");
-			ret = -ENODEV;
-			goto iounmap_ctrl;
+			return -ENODEV;
 		}
 	}
 #endif
@@ -722,7 +714,7 @@ static int caam_probe(struct platform_device *pdev)
 	ret = dma_set_mask_and_coherent(dev, caam_get_dma_mask(dev));
 	if (ret) {
 		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
-		goto iounmap_ctrl;
+		return ret;
 	}
 
 	ctrlpriv->era = caam_get_era(ctrl);
@@ -927,8 +919,6 @@ static int caam_probe(struct platform_device *pdev)
 	if (ctrlpriv->qi_init)
 		caam_qi_shutdown(dev);
 #endif
-iounmap_ctrl:
-	iounmap(ctrl);
 	return ret;
 }
 
-- 
2.21.0

