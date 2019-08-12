Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258B0C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28E3208C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJYRznlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfHLUID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34950 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfHLUID (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so48286962plp.2;
        Mon, 12 Aug 2019 13:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6x6jWn1arFYtCfxNQ45HZjLDVkH250RmOZOdF+kQcoI=;
        b=PJYRznlxL0VeXnkGUFm9XT4yRiHKP23qWD00ALeK6ioMlmpIURc892o6HXnyR7KfIH
         6CbltQBtKQDolzQEG+po1g5JcbFUOAjFNodgK8iCnrJykOyDuA/PLEELJa4L1IX6vezb
         69WhjAZWJ8t0ItWCF7wjtr9H/fvxOwmQ5vsMhQ3uREudKPjcDRKSKW0+LLVykERNpxRA
         eSnp2ctWXEQGTY3fG4Hcz1ILzoEe4AXV5IbPcOFmWtWO1N7PS4ki7lQS1pV6MEa0xvbt
         +WYmDrGwvWGTgcObpdDOh1SJd5QIlrbLCBGWdzXYIhnbE2rt9uub4conkpXy6NZr8/WP
         SxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6x6jWn1arFYtCfxNQ45HZjLDVkH250RmOZOdF+kQcoI=;
        b=CNs/3P8LcC1wZuOQuxKJi0TIKhv+UuB7SHSWPur+56uq8ygacMUTuoJYkjbubF62JJ
         tW9AilFwEVvTt7W7I4UvuaIw+1+eNjjHtuGc5tbrpNK/Q1QTUtPcY/PyR7AXr0yWOZNz
         Jao/eoEmnoJvrNnKPgyW3BDxtaADVIk+N6Sw2rVJ+d5PVvhGTSr//+PpgXufiwWWVg+W
         Zo1HHpthHDwLmP946kXbXoYPEIbp5DvzkViIotoVrxbSU6kGNQXZzJWLdYSwzNi/eeZB
         YCu0iBAXLWrGeqWPpyC+oLZRqPqbREHB7DFhUoqidWvGcmN4BnSQ6TniP73f8CBTx6R9
         6Auw==
X-Gm-Message-State: APjAAAU9fTUo5gKQzYXTS3KpraJE8EKl6Gu857sd+5ukXUB/9U+4JZPj
        bgAkUEcLvim5/sZJ1ruEO5DYh0gz
X-Google-Smtp-Source: APXvYqzzRVdrygTg90yQc/eHwvD5s55dQrJ/JAAtS25b+D9bH5jrnitKW0n2hxmguHOU9py5BFsRNw==
X-Received: by 2002:a17:902:524:: with SMTP id 33mr22156644plf.27.1565640481908;
        Mon, 12 Aug 2019 13:08:01 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:01 -0700 (PDT)
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
Subject: [PATCH v7 01/15] crypto: caam - move DMA mask selection into a function
Date:   Mon, 12 Aug 2019 13:07:25 -0700
Message-Id: <20190812200739.30389-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
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

