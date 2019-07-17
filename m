Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46520C7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8B421841
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N8ClcGQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfGQPZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34410 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfGQPZS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so11008740pfo.1;
        Wed, 17 Jul 2019 08:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WduKFir23cMqtiuaBErd3lIuwGC1aKscMQdutJXoFO4=;
        b=N8ClcGQ0Vi8FknvOXfLU+liH6McIeIh8YjH7TKJRHoNrId/qKqgZpc/P0MVq1k1fbc
         jr1zmL5dWEU0xlaqZfl35TQY1VmLpE8B/NtucWU9ZIEyDBMDMn92voa1MxsikJcoJKmQ
         fgpkedT6OuyQxmVbMyWToB4GLFLeGFSAuBfaVGdqVLbTRuw8sxZCAjDCXgUCafLyjpi2
         dnBRcCVR4F/tH/P4LQ4ACR3kCqM6kAEEqqEPl4NzMlUCuhOkCHNp3XbVCBDYU76TsJgC
         8FJmiT/B2EusNLiR69guo4HYTYEaQZ1pFJXTaEsGA9jsmiHLFmlHe32Kh5xdkrz6DSCV
         1e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WduKFir23cMqtiuaBErd3lIuwGC1aKscMQdutJXoFO4=;
        b=qI9hyLiPQGBuRzljQhJa820BfATdBY8+Uht4f+QDIdTp2e2pNCsExBzII+cHdBCQb6
         KFmsLqmg/u44LsawIl2OTHUkuV387Tw6iXke9hmnbsgFVrj68v3Ib0JWsbDL9RXgKVsM
         aH6bUOFXhs1P/as5HEiRiIqTmrJ4Uei8tbJs1sJchfdg1C/AJevR+MLmjTEsy8bjnHYw
         niHklRnkQzSPuXd2H/zvtaLPnCSL2+eZcPNExS4hrdOlBwTpKE0uktUzwKoL2oZeW3Jh
         K8gOgviCwF3ecTasmaeCgs9TmMvVmgR8l8z1l2Bir5wurVM3Ev2TS3hiBB4ebjLBWOuv
         DSeA==
X-Gm-Message-State: APjAAAX2JU13lr4cpu6s38qzl6tcPeBqkagELsNEoNPQ6ankM/BiHySW
        2nG1KpIKeSP6rPOXIrNgyGbRio9S
X-Google-Smtp-Source: APXvYqwKCzM5hLgfZPU+iapfVHINn0/c+fhZCVxF/85t1/zdr9BZXlASkjCagaopLEJIequCrKh90Q==
X-Received: by 2002:a63:9e43:: with SMTP id r3mr16534620pgo.148.1563377116677;
        Wed, 17 Jul 2019 08:25:16 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:15 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 03/14] crypto: caam - convert caam_jr_init() to use devres
Date:   Wed, 17 Jul 2019 08:24:47 -0700
Message-Id: <20190717152458.22337-4-andrew.smirnov@gmail.com>
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

Use deveres to allocate all of the resources in caam_jr_init() (DMA
coherent and regular memory, IRQs) drop calls to corresponding
deallocation routines. No functional change intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/jr.c | 48 ++++++++++++----------------------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 4b25b2fa3d02..ea02f7774f7c 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -108,25 +108,12 @@ static int caam_reset_hw_jr(struct device *dev)
 static int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	dma_addr_t inpbusaddr, outbusaddr;
 	int ret;
 
 	ret = caam_reset_hw_jr(dev);
 
 	tasklet_kill(&jrp->irqtask);
 
-	/* Release interrupt */
-	free_irq(jrp->irq, dev);
-
-	/* Free rings */
-	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
-	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
-	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-			  jrp->inpring, inpbusaddr);
-	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
-			  jrp->outring, outbusaddr);
-	kfree(jrp->entinfo);
-
 	return ret;
 }
 
@@ -444,8 +431,8 @@ static int caam_jr_init(struct device *dev)
 	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
 
 	/* Connect job ring interrupt handler. */
-	error = request_irq(jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-			    dev_name(dev), dev);
+	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
+				 dev_name(dev), dev);
 	if (error) {
 		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
 			jrp->ridx, jrp->irq);
@@ -454,22 +441,25 @@ static int caam_jr_init(struct device *dev)
 
 	error = caam_reset_hw_jr(dev);
 	if (error)
-		goto out_free_irq;
+		goto out_kill_deq;
 
 	error = -ENOMEM;
-	jrp->inpring = dma_alloc_coherent(dev, sizeof(*jrp->inpring) *
-					  JOBR_DEPTH, &inpbusaddr, GFP_KERNEL);
+	jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
+					   JOBR_DEPTH, &inpbusaddr,
+					   GFP_KERNEL);
 	if (!jrp->inpring)
-		goto out_free_irq;
+		goto out_kill_deq;
 
-	jrp->outring = dma_alloc_coherent(dev, sizeof(*jrp->outring) *
-					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);
+	jrp->outring = dmam_alloc_coherent(dev, sizeof(*jrp->outring) *
+					   JOBR_DEPTH, &outbusaddr,
+					   GFP_KERNEL);
 	if (!jrp->outring)
-		goto out_free_inpring;
+		goto out_kill_deq;
 
-	jrp->entinfo = kcalloc(JOBR_DEPTH, sizeof(*jrp->entinfo), GFP_KERNEL);
+	jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
+				    GFP_KERNEL);
 	if (!jrp->entinfo)
-		goto out_free_outring;
+		goto out_kill_deq;
 
 	for (i = 0; i < JOBR_DEPTH; i++)
 		jrp->entinfo[i].desc_addr_dma = !0;
@@ -494,16 +484,6 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
 	return 0;
-
-out_free_outring:
-	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
-			  jrp->outring, outbusaddr);
-out_free_inpring:
-	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-			  jrp->inpring, inpbusaddr);
-	dev_err(dev, "can't allocate job rings for %d\n", jrp->ridx);
-out_free_irq:
-	free_irq(jrp->irq, dev);
 out_kill_deq:
 	tasklet_kill(&jrp->irqtask);
 	return error;
-- 
2.21.0

