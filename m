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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9AFC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 16:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0142220693
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 16:14:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSv5WuBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfFFQOJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 12:14:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33071 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfFFQOJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 12:14:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id 14so3359958qtf.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Jun 2019 09:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KC6gNLUrrGz38loFr/g6746DdtqSbAUJ+54d4evf4OQ=;
        b=bSv5WuBs9s7Rd6sXtvzjt6choe5fjtl7obvAXWZPWetl29Oxx25wKkg8KY8TXMcshL
         PbqaO2fgTdadTbiCFBBmDnp5OIG796n7uF6izDlHuIprprGnICn3NR6g7xGSwVIIRLPL
         LSF8LB8AD0bL8PuQGiU3oudHY/l5p+p4ZyXlqKfeHBXaX/HTXZ3qyNHk15ztVWk7vEVK
         5eD8ch7wHv/iV2IMND/waCfAOxmsk09DouQUtnE/K2r2UDVWIzyV1UfaOr+V/MOWUoJK
         3QUOEZR9Y0wPnQMJ/wTcVJPvh95OSdINEXC+Da/Tx+0iLosoPNVMVUm+jymYhqGvzSPP
         kvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KC6gNLUrrGz38loFr/g6746DdtqSbAUJ+54d4evf4OQ=;
        b=iifqXlHFwUj8A9l//PfCtvBMx3C4mXNVjuYVbR8s4g/kBlQXLWAhTSE3L39iS2OtTr
         EQDNI/3o7jLW7A3mIIBeH9ELLEcbjLbsGBUDaba2we48AHb8YnnUGAuxkgk2AW4fiKd8
         j/jZfCHN9c+6ajYhQZJd3yTT+AQo7f/qqymAsDn/XlVJiqY+5grZu5ZIK9fMkEtFVm2W
         VySknEOQt50V3w+R2Eey2lvyCWWLFpDrsjmFU0k5i2C4DuaIWRs9cmarQBj9z2NM8B/h
         1EcNUczH+LaWrrA9aHFJdC8btgrLx6UE16ibdrMEqeoOJXtPoAHuoD79bG7oySgVP9bP
         jzHQ==
X-Gm-Message-State: APjAAAXS5VlvxAg0J1msH4oDI7kPROsZnNgi6KGM+yBt3BcwAWbcRE+m
        49fUqhZobl9nxVp2FdjrQFc=
X-Google-Smtp-Source: APXvYqymYsRTVplbcMSxla1xo/TK+qZ4Rlx25gyS+Z0Q60h5AH37MaRZNWjCNduQB+dUJ1/3qM1E0A==
X-Received: by 2002:aed:378a:: with SMTP id j10mr42113030qtb.6.1559837648547;
        Thu, 06 Jun 2019 09:14:08 -0700 (PDT)
Received: from fabio-Latitude-E5450.am.freescale.net ([177.221.114.206])
        by smtp.gmail.com with ESMTPSA id u26sm604337qtc.33.2019.06.06.09.14.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:14:07 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, horia.geanta@nxp.com,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 2/2] crypto: sahara - Use devm_platform_ioremap_resource()
Date:   Thu,  6 Jun 2019 13:13:49 -0300
Message-Id: <20190606161349.5227-2-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606161349.5227-1-festevam@gmail.com>
References: <20190606161349.5227-1-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/sahara.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index fd11162a915e..616fdc9f1816 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1387,7 +1387,6 @@ MODULE_DEVICE_TABLE(of, sahara_dt_ids);
 static int sahara_probe(struct platform_device *pdev)
 {
 	struct sahara_dev *dev;
-	struct resource *res;
 	u32 version;
 	int irq;
 	int err;
@@ -1401,8 +1400,7 @@ static int sahara_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 
 	/* Get the base address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dev->regs_base = devm_ioremap_resource(&pdev->dev, res);
+	dev->regs_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(dev->regs_base))
 		return PTR_ERR(dev->regs_base);
 
-- 
2.17.1

