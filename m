Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E5EC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1387D208C4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 16:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RX8KQQEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfFQQEA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:04:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43837 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfFQQD7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 12:03:59 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so5922078pfg.10;
        Mon, 17 Jun 2019 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qCT86J/Gk2DiQZC997UBD+R6JZp+9bYykNhMYtNpqdg=;
        b=RX8KQQEvrdkDbaxVPTDb2mWgqXN97hSbMRr0FxisXNXmhg2ik2rt2X8QqI6+kFSyn4
         tLs+kInHIEcv0pdLrR0JVVX8NXPldGLFT+jhZMZGJGaYqzGQOzY8tkeNXCHb4MGbmHK+
         QsRYd2Nw8AlP4KeEnDVw0iHgWgbMPu86yT0yHpxYD1AEBGSvXR3AnA7CTuc4q6NrsJ4M
         iLiUpCwFqGWMPFHFO4/DgAx8+nXwlEDxp7faG2KqI9OQHi+/4aNYOcydk2l3AfSs5wuO
         Z1upcZCRH8jYMIVCYBrG6MQCam+gzmpbqi2VY43lbqPF51r2X4psA4Fjek+QGmF8KkXM
         ES0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qCT86J/Gk2DiQZC997UBD+R6JZp+9bYykNhMYtNpqdg=;
        b=JGAlN2Gfr6HXb4PjEP8DUwSRUWirSLjYNEterL9s9B98W1VRZNFG8cscHKJD5bpfdb
         03OjdOf39Z6PFF3noB1lczihGqJO6E+wIDsuSVgn+/WmDzceGZaE1WvVgt5bQa26IToZ
         W/42ZMlS9K5nkghczkXo1wHhPXpW+aMB8jdYWXBJ5En3S5EWh6TzACOh2xQRYiaHO668
         UzVswuUU2VKs8nw2csLtIAgaGaZ8u98Tg7mA043hJC6Sf7iuXGZBuPpvQhcANhSMzu54
         B63/vraVorxEKlOp2SkTpN4KS60+3jAdsPD0DZwWBapQus2/hb8IuhsbO2EPyeawovic
         LBSg==
X-Gm-Message-State: APjAAAV0f6kPpRCcmxmbLy/VY6g0a9X/2e3cdLOtMZ1m0qwSGx2dR0cO
        5FZ4u4SfT6785SqUuXhKZD4AVU+LwDw=
X-Google-Smtp-Source: APXvYqysH+RDBqcqgfsm0dJeKYPL/IwEL2AfEAPnVAnMtNVdkaKt+HfLVGzH9YZJ2kXdMVoEXyGpmg==
X-Received: by 2002:a65:4009:: with SMTP id f9mr19630848pgp.110.1560787437758;
        Mon, 17 Jun 2019 09:03:57 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id d187sm12834073pfa.38.2019.06.17.09.03.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:03:56 -0700 (PDT)
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
Subject: [PATCH v3 1/5] crypto: caam - move DMA mask selection into a function
Date:   Mon, 17 Jun 2019 09:03:35 -0700
Message-Id: <20190617160339.29179-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617160339.29179-1-andrew.smirnov@gmail.com>
References: <20190617160339.29179-1-andrew.smirnov@gmail.com>
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
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c   | 11 +----------
 drivers/crypto/caam/intern.h | 20 ++++++++++++++++++++
 drivers/crypto/caam/jr.c     | 15 +--------------
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 4e43ca4d3656..e674d8770cdb 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -688,16 +688,7 @@ static int caam_probe(struct platform_device *pdev)
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

