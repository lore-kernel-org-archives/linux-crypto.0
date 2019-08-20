Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D59C3A59E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D964E22DD3
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjpE8ERL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfHTUYV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38911 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTUYU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:20 -0400
Received: by mail-pg1-f196.google.com with SMTP id e11so3855061pga.5;
        Tue, 20 Aug 2019 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMRHsRrdWQ9wyMpX5xaU1FkT9DVUAf74SttoxrTFm+w=;
        b=fjpE8ERLTQcC1EbzuShQ4DkQIs7NFjYUZypX9w49Ps1pJC4QY+ro56bllgJc81dfwm
         Ye112Nwgel9z2MSBb5qUANCEMRORvzbd9LguguS69et6jqqA3vDAc08e+ya5otEZ2f9V
         kot647qPP/JRQoyLJTsH6ojzJOdueNya+2CiXAOZJxIeVjeu2OE2axS7agKUa336P1g/
         1FPfLi5PHJsiA3OAtExCBRkyoLyGgesihhOpC7SqbXoNxuJ2KgsSTj2EXXrTt+PjdpHK
         VoJI+FjkuTE0yiSmJx0UgIZ29fBVfMxKnxi0oee7Ldvp6Lp/LrMKCawwvQXlbSwHNdHz
         pjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMRHsRrdWQ9wyMpX5xaU1FkT9DVUAf74SttoxrTFm+w=;
        b=JBF0CD4v2ooXePWpzMxFoelOBPdemAaUuVdU8Y1NG/15cNRJhutgg9d/8kdxHrq32u
         WGxU67/Pxx5CpmWUkwdMMt+Snirzt4PVpBZ/yg0rKQiEWGH95tOAxtaffLtS8AuvkEe0
         ZA3A/roxMz1n/VCRTJI4HHGNM6jTqr5Aqw9XR+p3X9NWIcQXbKkqKwjFiPI3wbM+dWBS
         t/BW0BN1XyZlUpA+5tuGeXbuZ1CuGVHNPh5k+A6kQUgpLCGG7K+ZBGtEG913BLWnGoUu
         Rd0SDaghST7zJUY8s6fz7HRz/2cA2nOSFfYcDMaDJOhRADouy14jIq76aj5UTAM2KjKu
         3LgA==
X-Gm-Message-State: APjAAAWoXp06R8hSExCtisItvFU0YZX13Jwlm2XrMcPb00U0UtSH35D3
        aE1g5N/GilMr9h0XUt7bwn1nQRua/PQ=
X-Google-Smtp-Source: APXvYqxZAorpehERDDuNmqk4a4LfCccs8S/DB6HfEjTQDdOA/ybQNOk+Vk80i0u7zgtkJiDwNq1Png==
X-Received: by 2002:a63:550d:: with SMTP id j13mr26536721pgb.173.1566332658820;
        Tue, 20 Aug 2019 13:24:18 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:18 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 01/16] crypto: caam - move DMA mask selection into a function
Date:   Tue, 20 Aug 2019 13:23:47 -0700
Message-Id: <20190820202402.24951-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
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
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
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
 drivers/crypto/caam/ctrl.c   | 11 +----------
 drivers/crypto/caam/intern.h | 20 ++++++++++++++++++++
 drivers/crypto/caam/jr.c     | 15 +--------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e0590beae240..50336494f285 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -711,16 +711,7 @@ static int caam_probe(struct platform_device *pdev)
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
 		goto disable_caam_emi_slow;
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 6af84bbc612c..ec25d260fa40 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -10,6 +10,8 @@
 #ifndef INTERN_H
 #define INTERN_H
 
+#include "ctrl.h"
+
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
 
@@ -215,4 +217,22 @@ DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
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
index cea811fed320..4b25b2fa3d02 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -543,20 +543,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 
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

