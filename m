Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1EEC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 16:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15F020693
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 16:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tokbpkE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfFFQOG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 12:14:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34195 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfFFQOG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 12:14:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id m29so3356303qtu.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jun 2019 09:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3pUyKz+cgfJSIYJH5CSG3LK8DCCSkGfDGktfMqsXauk=;
        b=tokbpkE8SkO2KvucEaK+J9Q3coW5TOoBG+YuT9aLXFinup+SHPjugYyRKE10Qczn+6
         yIuex4e8+ZA9Ikq1bHnavZ+iCeJscxhh4sTIleOXvuv1d6a4hVqHvk8ZwAihJ/+od5tJ
         Ku7WsVY0ZxdVjhvHIKpnaDR3hdsGZBf/6axPpYRL44GZi2uHyJfewOFoDsVBFiR7INE+
         jxiZwm0/aooddxSwdQuoX8Yy0tFcyBAJdOXJDqM72nB/eSYXOLy1U2DsHdKskZ/I/Bu6
         0iKZUkUMnEQDWvvcmza9F5a2ordQFLti/QJfINAoB18nlsJJQuH8fdUKuAcSsYYQTNcT
         Vb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3pUyKz+cgfJSIYJH5CSG3LK8DCCSkGfDGktfMqsXauk=;
        b=oTiTvBb0MeOAQz/xvLUI37WatEwhzGV6t1Pggyo3tWp2GD/LN1/ePuSmj0oZ/Az0zd
         9+6dTNKb2o82e2Vm9Vb8PH+bXZ2o+6YCZ7IOZjm7H86zZn79x3zvTb/IEfzYSEsFImgN
         3dghMgmnzKesicQtk1hapEEsf3wKQW685bK0Hx56K00MgRBEwIe78+l8sIEnQYiSVwO1
         xZJM93X5RPWXuXOctsw+lBX44o8dxDU2ippMi52absIgoX+2WdQd5XKySrWdLNwAlbN6
         IKxjNTD1TyMV0HAP/c9iHF7om6K/VH9yjq397ZBN4iDSTS4LHZZTKF0UJDw/W8jXGJ4Z
         qoJg==
X-Gm-Message-State: APjAAAVUM9tuf+hr6QhDtHNrYpLE2Jd4jZa9bICCBZ69gSB2ejk7vSfm
        3Ynh5rn95EJn0RkMB7SBDNE=
X-Google-Smtp-Source: APXvYqzsXUBcmxxB61eBhi9+hRSHs6HB64RrmJ8qa6CwhX8m37ofpc6FlZrVve/2IMSI/amX+rH90Q==
X-Received: by 2002:a0c:ad53:: with SMTP id v19mr40280752qvc.40.1559837645613;
        Thu, 06 Jun 2019 09:14:05 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id u26sm604337qtc.33.2019.06.06.09.14.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:14:04 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, horia.geanta@nxp.com,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 1/2] crypto: mxs-dcp - Use devm_platform_ioremap_resource()
Date:   Thu,  6 Jun 2019 13:13:48 -0300
Message-Id: <20190606161349.5227-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/mxs-dcp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index bdc4c42d3ac8..f1fa637cb029 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -986,8 +986,6 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct dcp *sdcp = NULL;
 	int i, ret;
-
-	struct resource *iores;
 	int dcp_vmi_irq, dcp_irq;
 
 	if (global_sdcp) {
@@ -995,7 +993,6 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	dcp_vmi_irq = platform_get_irq(pdev, 0);
 	if (dcp_vmi_irq < 0) {
 		dev_err(dev, "Failed to get IRQ: (%d)!\n", dcp_vmi_irq);
@@ -1013,7 +1010,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	sdcp->dev = dev;
-	sdcp->base = devm_ioremap_resource(dev, iores);
+	sdcp->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(sdcp->base))
 		return PTR_ERR(sdcp->base);
 
-- 
2.17.1

