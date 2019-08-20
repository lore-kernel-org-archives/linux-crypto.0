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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC361C3A59E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B21A822DA9
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uQfWzKk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbfHTUYZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42216 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbfHTUYY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so3849166pgb.9;
        Tue, 20 Aug 2019 13:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lf1Bp+42OlJDYkDhdg78vigaCDh56XZkLKRQRM+cZOU=;
        b=uQfWzKk4/exNSmXVoTi0sdiRboZcm0YTiaHYEQl0Ynx8Rxmb1IgBu3KfR+xxc9QPf9
         YYcXugUHHKGkY6kpQ3b0b2Rg4cJmhYAGvvVSeXuPw7i5wwzsYjLutxYIlNDI0If6yBZc
         DT6seOWzzep2/1ei9WIg8RJnca/Yw9JOex1tgbxsn4e3R3rwHz7q4tx1QsbSkWGz605t
         IKwaPNacPkNU2shoO9gaZ8HiFRqrTOlhdeCLBT4xIFjmfPKrcOzHTqMR3XZ+PZgOtoqA
         K4IHp/1NuOMU9sr9Zr1Yapzu/G2px6k6gI/WMwYh4Aefc4NNmfHgx10gZWUYS1rQeZUP
         9cXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lf1Bp+42OlJDYkDhdg78vigaCDh56XZkLKRQRM+cZOU=;
        b=T1lcce7T387pwCQxhUjVZ3unORPRf3cGYP/i7y9qmBULH9qMsq/8vVYgZXzuygtgKQ
         hCk6SwKhh//DPzAg/05I88JWuonDNh/w+gF2Zq9c7YRP8vEcOdNE+9BNGY0PF6xlGCXm
         lhlLE4ZDsa8sRNaQftizKS5AwYr06aCUIEMIoDC0260klMaqN6CaGWV8niB+PmLD6WXj
         qU90PBOF7NLICBGli9tXb77VPYxGGB/fmTmxi0pvhAy5mFdjiDCX7mRUoBUCu4wSYb1a
         tXhEQd6Q6zWdkPGEOW/r599J1uuVq13RGTAzv2r7kaDmt1SqZ44aU4K3oE9HBAsBevkm
         Q4vA==
X-Gm-Message-State: APjAAAVeryWenR7Zq0rKwPddxNXTT/E7TGIEZKhIHPldhmoM8NxZvYPN
        GDmSdIHVXL1PitvGOMH4gKiDQRshl7E=
X-Google-Smtp-Source: APXvYqxjCJ7AnJn4jlprGGGPEBDYjsqIk7oqgNpUsERxWgf7wIEfPq9WrFo/mwsIk/O0b5hhAh0aMg==
X-Received: by 2002:a63:724f:: with SMTP id c15mr26831330pgn.257.1566332663210;
        Tue, 20 Aug 2019 13:24:23 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:22 -0700 (PDT)
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
Subject: [PATCH v8 04/16] crypto: caam - request JR IRQ as the last step
Date:   Tue, 20 Aug 2019 13:23:50 -0700
Message-Id: <20190820202402.24951-5-andrew.smirnov@gmail.com>
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

In order to avoid any risk of JR IRQ request being handled while some
of the resources used for that are not yet allocated move the code
requesting said IRQ to the endo of caam_jr_init().

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
 drivers/crypto/caam/jr.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ea02f7774f7c..98b308de42c0 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -428,38 +428,26 @@ static int caam_jr_init(struct device *dev)
 
 	jrp = dev_get_drvdata(dev);
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
-
-	/* Connect job ring interrupt handler. */
-	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-				 dev_name(dev), dev);
-	if (error) {
-		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
-			jrp->ridx, jrp->irq);
-		goto out_kill_deq;
-	}
-
 	error = caam_reset_hw_jr(dev);
 	if (error)
-		goto out_kill_deq;
+		return error;
 
-	error = -ENOMEM;
 	jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
 					   JOBR_DEPTH, &inpbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->inpring)
-		goto out_kill_deq;
+		return -ENOMEM;
 
 	jrp->outring = dmam_alloc_coherent(dev, sizeof(*jrp->outring) *
 					   JOBR_DEPTH, &outbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->outring)
-		goto out_kill_deq;
+		return -ENOMEM;
 
 	jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
 				    GFP_KERNEL);
 	if (!jrp->entinfo)
-		goto out_kill_deq;
+		return -ENOMEM;
 
 	for (i = 0; i < JOBR_DEPTH; i++)
 		jrp->entinfo[i].desc_addr_dma = !0;
@@ -483,9 +471,17 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	return 0;
-out_kill_deq:
-	tasklet_kill(&jrp->irqtask);
+	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+
+	/* Connect job ring interrupt handler. */
+	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
+				 dev_name(dev), dev);
+	if (error) {
+		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
+			jrp->ridx, jrp->irq);
+		tasklet_kill(&jrp->irqtask);
+	}
+
 	return error;
 }
 
-- 
2.21.0

