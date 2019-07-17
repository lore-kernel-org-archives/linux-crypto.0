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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CF6C76195
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B017821841
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tNI8nCv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfGQPZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46855 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfGQPZT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id i8so11310538pgm.13;
        Wed, 17 Jul 2019 08:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75RddUUYOCkJTxyQ1DWwpfzp/lCGZ4Ryw21Tf0UA6Hg=;
        b=tNI8nCv8AU0UUJ3gy/qCGOGpNatzJjVHjK027I8FfFAqzJS+xDpL/1jusxi2+nqJnI
         2dzvFf6wj5tcYqdjVjKaMY6mdRjPS3RnSpzKhA+ILpvmDoYEo8cel45T8FWsuJyKj6XX
         82X6Y7KR5cOHcrCWBpBoyYnFNNWvnbqgELCWEJza2Ckv7cOwjPUbKz26TSOeu69hMChi
         docAuMhR2yMs+Em+2C41ZSppkSegmCLkI5qk5BsQCiVbmmQOr9S2zIy3jmxFqP3nBhBL
         SqutFWqg0oefVuGgq15SsDN3W08lsq4Bi6PoN3lQdxXjvFLgKGF2yCMoJJOqp7oSXUw0
         OwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75RddUUYOCkJTxyQ1DWwpfzp/lCGZ4Ryw21Tf0UA6Hg=;
        b=tyx90d07DyLbnJi8Il9PlroI4PXTwTSMxEOD0H3wi56u9ft1svG9lnS6uxkehX7+jA
         mQL2csQ9UKw7TpqXPVyyd6kjI45m8jQllEOcTRruEiVp5EKZxLZCsHDD9t8T6DtjvO6Z
         bXMPfoX3p8gpwqXpBDlAoxqYMCnE4Vvg6/0QkCYEkAg69EcGVk8sItgGrtYW1AoasVTz
         m0TFYjGYjVBZjxYqZS2lK53QJ5BOmsTKHPaPDU80V2qRrWbXLWQJ0Tll7PYFXfRi64DJ
         e8RplqjDN0+mMoYlSmVePhYGivCoPbpxc7Bb83KOYyxpL8hLCxVBVwODlhA45nZqZaAU
         hKpA==
X-Gm-Message-State: APjAAAW9KgSBL4OkjAyPVnz+fw686b3SIuUQMRFAnFvxjEYgeG8cU0/K
        dYmfasz86viSvGP6rEMiHdsJeQ/b
X-Google-Smtp-Source: APXvYqw6UxhgUEcouVJ0obRew6hH0PqoSDXEJsFWyhkQIXt+lXEnZxUprtgq6gW2WEmcCuE+rkWjZw==
X-Received: by 2002:a63:2a08:: with SMTP id q8mr9757498pgq.415.1563377118235;
        Wed, 17 Jul 2019 08:25:18 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:17 -0700 (PDT)
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
Subject: [PATCH v6 04/14] crypto: caam - request JR IRQ as the last step
Date:   Wed, 17 Jul 2019 08:24:48 -0700
Message-Id: <20190717152458.22337-5-andrew.smirnov@gmail.com>
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

