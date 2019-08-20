Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE196C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0CEF22DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smkmOYv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHTUYX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45137 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730681AbfHTUYX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so3845694pgp.12;
        Tue, 20 Aug 2019 13:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x765OFLB0P9m/pbBx527mO3B9e7m04LRo1RUV+KGNXI=;
        b=smkmOYv9E49f8UIn6zxq77bcSS/fQg7mT/BsReayeN2BLvvf9uNn7omzFtgkTxb7qF
         GVVZ8MaN9K7mNxMTd6qmJWo5UedWW+SBughNPFk+uJ6LJ2vt+N6b5L5EH/s5lMa1JeyY
         qI+Or75p+Df1haIfVsioQUB/5EV9LiE1q5tsCFBERZ8+zYxHHtypmMbI6U8yJDpp99D4
         B0tBv9IN8YkC7TAFs/vwUFOsZn+cUQywtJaXDUH+PKMEbr2dqc451XMzRTiWzL6hHIG0
         hsWhmdQfkecUNkzNLGLmKDW507Y//kpnE6OWrPaKdVbQniSMx8S9WS85FLjoPHiFOZYH
         ANCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x765OFLB0P9m/pbBx527mO3B9e7m04LRo1RUV+KGNXI=;
        b=MHKOQ+Zg6IVbNLbZ6SQ+iPrkVvXSJMWoNO87wbNuKi2adlShBB4qfFxFMp7hx5ub5J
         7p4YojF4NvP+0DYi4+OCo3H6rwuCSEWFbQYotFMUPnGq6CwyYNQ3Irkusd1g3P4QYtQ/
         D25jgFRChadFsD+n7ZZEvXwibqmpzLUA0JnXkEHAikw6FFA2gQmyx6SiWgDPGUWeeS/N
         yWWlORHmb071uGdJ2vg5V+O06TCWmupHyBxufA4MAwp3h7w51VPELA/s89iYf+/aLFMt
         vr76MPFwwAvXtz/2+tv3t9kuZoxcbeOL34nTuU8cD0PDlvhcVe90fm9ZT4v4hKMveclj
         j8IA==
X-Gm-Message-State: APjAAAV7e5srnMGbWmGlZP2eHs4hi0Yrpgx310CFPCcIThPpJNDNk6Qb
        6/PiD5Chx/gBUAixVGCMdspxHEk0Q+k=
X-Google-Smtp-Source: APXvYqyd+oP7G7ervttemxD8LiPVJBGhRa4rMdi+nIi3wuRnlmP49/PgpeM4u0Bk0LTaIbuER0Xfgg==
X-Received: by 2002:a63:c203:: with SMTP id b3mr26528399pgd.450.1566332661706;
        Tue, 20 Aug 2019 13:24:21 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:20 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 03/16] crypto: caam - convert caam_jr_init() to use devres
Date:   Tue, 20 Aug 2019 13:23:49 -0700
Message-Id: <20190820202402.24951-4-andrew.smirnov@gmail.com>
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

Use devres to allocate all of the resources in caam_jr_init() (DMA
coherent and regular memory, IRQs) drop calls to corresponding
deallocation routines. No functional change intended.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
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

