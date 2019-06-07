Return-Path: <SRS0=RoO8=UG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E6CC468BC
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C19208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Jun 2019 20:03:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUsnAS4q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfFGUDK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Jun 2019 16:03:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44697 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbfFGUDJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jun 2019 16:03:09 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so1759432pfe.11;
        Fri, 07 Jun 2019 13:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aYZSfsRzRqOrI6qY0NWyqSfMDNB1pcr696hD5QwTSek=;
        b=TUsnAS4qPplCViRIOaq3wcbYSN3h/DpMQJxMcB1RI+7y8W9o+NocJJXehhEFDClZM9
         k4l5FHkOvyGvuwgx6pqw3Ufd+FTvsgLrXT51Uif0Lu4d2eBc2Lw30LSeCjh9tK1udCW1
         IHowS6VNZNw4idseyC+m54T/uSPfNSsAUvkdUlfWoIjVLGkP+r56pfui65EauL7T1KpO
         TwXDe0JxziGErxvuc9KWURQxkZ1B2jXhaO83Z/qm88nj3zU1ZNLdUeMLuzlNRqHkjrh+
         ZKpN2xPDqLvBY/ag3z5Sg08C6oSBIjeqc22vVolVAkhuponfbne4dEpXBZKMkRES8L1V
         QCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aYZSfsRzRqOrI6qY0NWyqSfMDNB1pcr696hD5QwTSek=;
        b=ptWr9ZAexXOMWx2M75xDeSdtM5hLRfCMoNK4WrhulnyvqDMFA02hacxaOWKAiXdC1P
         q4nBwi5CRRwJZoaXDJrGAWVoPHwniUXlfWeMwlMGm3zC2nwRA5hfrkgWq3Q+jUgpPMRM
         kyYDukJxb8jEDy06mcV40j/PGi+jKIICSid7mtB+eixstGgWEZ7AVYJ1sajmSsnD3zBV
         5I59KqSZtGfdZd7RUpA4AIXtzcZ9hO+CnOnDxdKSEOSnRXZ/L2FejcIcw/qhtlR/zTDt
         mZcAUB7JrRssXWkAeKp8Jlgi/AdCNVhemWAadXn5Iw2IuwSSlE1xdKwJgFd/6OR4p9Sg
         NndA==
X-Gm-Message-State: APjAAAX0KdSWBth+oxp3NMtdfR6TM+XNCLvaUVts65ve0JZXsg+93grn
        yodCLMCn5PqHxZtuq5+dsVWI3vywSR0=
X-Google-Smtp-Source: APXvYqw2LL3D+toFpTvOuTc3ick8bMhfJmNpzlnyKoY/gwRAAF64aknY57YOUbHkyP/vyf//k4Xq9g==
X-Received: by 2002:a65:60d2:: with SMTP id r18mr4595209pgv.217.1559937787700;
        Fri, 07 Jun 2019 13:03:07 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id s5sm3289405pgj.60.2019.06.07.13.03.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:03:06 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] crypto: caam - move DMA mask selection into a function
Date:   Fri,  7 Jun 2019 13:02:23 -0700
Message-Id: <20190607200225.21419-3-andrew.smirnov@gmail.com>
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

Exactly the same code to figure out DMA mask is repeated twice in the
driver code. To avoid repetition, move that logic into a standalone
subroutine in intern.h. While at it re-shuffle the code to make it
more readable with early returns.

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
 drivers/crypto/caam/ctrl.c   | 11 +----------
 drivers/crypto/caam/intern.h | 20 ++++++++++++++++++++
 drivers/crypto/caam/jr.c     | 15 +--------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 39334e71a14f..9750fcfd37fc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -717,16 +717,7 @@ static int caam_probe(struct platform_device *pdev)
 			      JRSTART_JR1_START | JRSTART_JR2_START |
 			      JRSTART_JR3_START);
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		if (caam_dpaa2)
-			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(49));
-		else if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
-			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(40));
-		else
-			ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(36));
-	} else {
-		ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
-	}
+	ret = dma_set_mask_and_coherent(dev, caam_get_dma_mask(dev));
 	if (ret) {
 		dev_err(dev, "dma_set_mask_and_coherent failed (%d)\n", ret);
 		goto iounmap_ctrl;
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 3392615dc91b..b0e32a91cdea 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -10,6 +10,8 @@
 #ifndef INTERN_H
 #define INTERN_H
 
+#include "ctrl.h"
+
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
 
@@ -127,4 +129,22 @@ DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
 DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
 #endif
 
+static inline u64 caam_get_dma_mask(struct device *dev)
+{
+	struct device_node *nprop = dev->of_node;
+
+	if (sizeof(dma_addr_t) != sizeof(u64))
+		return DMA_BIT_MASK(32);
+
+	if (caam_dpaa2)
+		return DMA_BIT_MASK(49);
+
+	if (of_device_is_compatible(nprop, "fsl,sec-v5.0-job-ring") ||
+	    of_device_is_compatible(nprop, "fsl,sec-v5.0"))
+		return DMA_BIT_MASK(40);
+
+	return DMA_BIT_MASK(36);
+}
+
+
 #endif /* INTERN_H */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1de2562d0982..c2b99139a10a 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -502,20 +502,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	jrpriv->rregs = (struct caam_job_ring __iomem __force *)ctrl;
 
-	if (sizeof(dma_addr_t) == sizeof(u64)) {
-		if (caam_dpaa2)
-			error = dma_set_mask_and_coherent(jrdev,
-							  DMA_BIT_MASK(49));
-		else if (of_device_is_compatible(nprop,
-						 "fsl,sec-v5.0-job-ring"))
-			error = dma_set_mask_and_coherent(jrdev,
-							  DMA_BIT_MASK(40));
-		else
-			error = dma_set_mask_and_coherent(jrdev,
-							  DMA_BIT_MASK(36));
-	} else {
-		error = dma_set_mask_and_coherent(jrdev, DMA_BIT_MASK(32));
-	}
+	error = dma_set_mask_and_coherent(jrdev, caam_get_dma_mask(jrdev));
 	if (error) {
 		dev_err(jrdev, "dma_set_mask_and_coherent failed (%d)\n",
 			error);
-- 
2.21.0

