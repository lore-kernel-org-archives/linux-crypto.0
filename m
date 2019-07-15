Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326F8C76191
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C2FE20665
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZpn52iX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732345AbfGOUUw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37175 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732301AbfGOUTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:19:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so8868725plr.4;
        Mon, 15 Jul 2019 13:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75RddUUYOCkJTxyQ1DWwpfzp/lCGZ4Ryw21Tf0UA6Hg=;
        b=eZpn52iXsuoEIujdpqRqu/LCGLvJ5SfZKDd7S3PSKd/uYTDGzgfeOf832yb8fBQZIY
         Q2dXbyhF7tA9LmU2vfxszMVlPNRbQNnAuEOMM392KyxA4IXzw8rkxzBVITo6kyt9zrYo
         gmd6VSdIuby5/pI+t4NMZvgsSfteleW9bvdbFhYkVOBSql4pFlvIt5OwigC8jppHBxVM
         /C/pyawFMBDyNktDoxi7hoGDcs9ZZFFoELQhnkfJyYDjQ2nRtQ/Sg2+WeA04VdrsocsX
         nOl27xjjMBh/wRJBiEg9glvLU9YkCNkvCpK2aYRRD5DbpMhn2CkYD7Jc1Dt9b+lA4c3N
         TFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75RddUUYOCkJTxyQ1DWwpfzp/lCGZ4Ryw21Tf0UA6Hg=;
        b=Z+/Fu6kLswjP6DNJ0JTpCe7gkSb8z6nNf/VL41u2k22Hl+jdAXKYjaroj+OIsoc2DL
         AgOU054tLmTm4yCJ8gVhST9jomvozPWLw/h6is5m/+X3sGguL7lFLOcXMS0jF7z2GW4z
         srIVWQmCoYQilqnRBlx3WYn5TVER18gvauCqaSsfmGcw5w09zOmlR+/diO0t5aCsRC8t
         6MtJAH498sDpHdZ4S9NWDXCHJZnj1ysXelAutTBcA5MEBg9ZxazKJHulpU+Vr/PUsXs8
         ZYWYooSHbS5VRqom6KRQtZZqzgzr6hLNM2k5mFsFdC2hnNxwV/aCQN86AxXxRSVyZJa6
         PgCQ==
X-Gm-Message-State: APjAAAXdax3J8bqLnbVAp48i1N8rjn7twNGxyEbBOcmBugFwa78UbEZ/
        rgMiHNy5I2TxlXntNt9/Ce5xM3qL
X-Google-Smtp-Source: APXvYqyk5eyfGdrXXSGEnPDGTs38Am93SwoIjsI5JXk+V3H2FxvQuOr1PNL0eAZcfef887hqzpnC2Q==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr30787778plv.106.1563221994613;
        Mon, 15 Jul 2019 13:19:54 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.19.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:19:53 -0700 (PDT)
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
Subject: [PATCH v5 04/14] crypto: caam - request JR IRQ as the last step
Date:   Mon, 15 Jul 2019 13:19:32 -0700
Message-Id: <20190715201942.17309-5-andrew.smirnov@gmail.com>
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

In order to avoid any risk of JR IRQ request being handled while some
of the resources used for that are not yet allocated move the code
requesting said IRQ to the endo of caam_jr_init(). No functional
change intended.

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
 drivers/crypto/caam/jr.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ea02f7774f7c..98e0a504322f 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -428,38 +428,27 @@ static int caam_jr_init(struct device *dev)
 
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
 
 	error = -ENOMEM;
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
@@ -483,10 +472,19 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
+	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+
+	/* Connect job ring interrupt handler. */
+	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
+				 dev_name(dev), dev);
+	if (error) {
+		dev_err(dev, "can't connect JobR %d interrupt (%d)\n",
+			jrp->ridx, jrp->irq);
+		tasklet_kill(&jrp->irqtask);
+		return error;
+	}
+
 	return 0;
-out_kill_deq:
-	tasklet_kill(&jrp->irqtask);
-	return error;
 }
 
 
-- 
2.21.0

