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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7E3C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5A4214C6
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Spq27TAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfHLUJA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:09:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40628 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfHLUIF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so48240915pla.7;
        Mon, 12 Aug 2019 13:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x765OFLB0P9m/pbBx527mO3B9e7m04LRo1RUV+KGNXI=;
        b=Spq27TAslUeLVI9WFsDPPuJ0MfRsVdB4IFY1be3v2/7cX9YBIgYKORrLuq0fZhcdo2
         4hQOJ6oIbwLI8UN+cokVgbTYeBY0Vs7ksgjIfaJKfwpyr4AfVEXWun7xeR/QHugUxQgS
         yOLqCv9Bj9M7jdGwl7WnuMnVKuQFGDo2AhT67MvqYUC0OODHFjRMaMkLoARFBVrDDKHe
         +GnHL5lIvHeqGsnhEuIkJ4RRl+47wniE4NJz496jFg9pZibhBqW5OEP08C1Aa0yFTHLR
         42kPjsyIHFi4QN0yKX7hvYk3IBojhkXOmpn3xL124qYnyyChTL/wf7E1OsTNrmHgjxj2
         KVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x765OFLB0P9m/pbBx527mO3B9e7m04LRo1RUV+KGNXI=;
        b=GpmKpu9RRet3CsUozoBW1o3XKgDbaSiI/7HPJ2vz4LZjMgw1VGmB+hUdPcvx0JTJnk
         /EcVSnhMv9NjC6xx/EoPNHJx54B0UGhgSMwVZliVtxAw0sGKm8ltY9vVFOaxHKSe5/4F
         9VcIkhOJsFI2NhWSVPg0uiU9w9HLPLxdjKHhCe2hs7OYaKpUFeMqF5KyRtX4C34lDY2U
         Lw2R93/EDCy+XnfZfJyU0ckHmrRuQj4JiduwtFAsPJ5esEsE4Ti0mGsu36XUSl957rPX
         xGXyG88BaLld15L9/4lUyrtbrIj96FbPV6Qggem2OS+0vJ187Jh/K2s7Qg/GTwMsrf3F
         tOlg==
X-Gm-Message-State: APjAAAUHyqZTE0SPWnrveGWgEUNbX5sAfb+f5pB/YI+AhAlLQkL53qLs
        vFMGt5U/sxnidK2m7qQ3V7JvwRNv
X-Google-Smtp-Source: APXvYqwxJ43J243ace515kBBgbwck7VZsCIDJQRU3eoa1g4Q/Du1jjMFkkNcByixazAd+SSch6BwIA==
X-Received: by 2002:a17:902:e30d:: with SMTP id cg13mr34623128plb.173.1565640484383;
        Mon, 12 Aug 2019 13:08:04 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:03 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 03/15] crypto: caam - convert caam_jr_init() to use devres
Date:   Mon, 12 Aug 2019 13:07:27 -0700
Message-Id: <20190812200739.30389-4-andrew.smirnov@gmail.com>
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

