Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DA3C76195
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B34920665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUIdG9L6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbfGOUTz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:19:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39178 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732281AbfGOUTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:19:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id f17so3958702pfn.6;
        Mon, 15 Jul 2019 13:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WduKFir23cMqtiuaBErd3lIuwGC1aKscMQdutJXoFO4=;
        b=JUIdG9L6rymIMjbvHghd9E/GJUA75D93UKuez9Sx3FObklviC6DSA9LOMHotqbqWn3
         Gveo9vYGxVX1aayJ1xS8XH6XhxLBxKCjyFfBC9lCV2M9v6chZOPSoQOj3/0ChavtVUoz
         rYPhYqNHh283Hhd+Z89AjkNUfWt0PQeqkdI61alSW5ZPMvF7yZKDAESSMQ9mZELvbt9c
         hgcNV+Q+sPnXFeEe5zsBffWOrAHmVgXl5wzsChU8/y4troHLa40TRiSlgV7ogJBcR4YB
         dUIqiRdhxRvM+0E3610olzlWjKVeqMjBV21uWSL2LhGqGocXoUt+q6IJiWfgcgpEnKje
         uBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WduKFir23cMqtiuaBErd3lIuwGC1aKscMQdutJXoFO4=;
        b=EU+e+pF71EDyp9S5rvXEMDDzJA6GLQJCasYWTrCLaHomflxxIAxmOsohmHbqEZc/oD
         VeVPdre6h1xZ2kv2EW3NcJiHnswNZ1rCQI/nan0MJ18wKfPVgqnBlCU3fqEmpls8epwj
         bsynMFZ3d9TSCRxtkqSOU4xnZRic2BFcvtAKVyHLMcG18DnZwyp3IpwCkfUKlUdBQV21
         I5vXAZrOQ/za2Qd0LDnEPg83oORTTwuNK5T+/+W/e4JIPzzL697QyFMxlapsM5UkrCIK
         hADXl2/KJhReVk6pIw+/rFiqmii5c56RzVMQZw1j7EIRqIHsl9HiQSuw8e5SYL0YrQtH
         2i+A==
X-Gm-Message-State: APjAAAXH8vY07LDix415YlA7t0JwgYm/UM8ZR/YReinSXNMt3zVQGRvg
        fHWnIz6fmvqCmirjFym2J9BI4viB
X-Google-Smtp-Source: APXvYqxC3l9yFQZVlww/JJFXVnU6M4stbz07jpbS7uG/vUSEsK0D+hWzGV72GOWJ+Yu91Qhi1bu3yQ==
X-Received: by 2002:a63:f304:: with SMTP id l4mr28598972pgh.66.1563221993235;
        Mon, 15 Jul 2019 13:19:53 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:52 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/14] crypto: caam - convert caam_jr_init() to use devres
Date:   Mon, 15 Jul 2019 13:19:31 -0700
Message-Id: <20190715201942.17309-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190715201942.17309-1-andrew.smirnov@gmail.com>
References: <20190715201942.17309-1-andrew.smirnov@gmail.com>
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

