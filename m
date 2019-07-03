Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD10C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B85218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKeKmBgH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfGCIPC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:15:02 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36469 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfGCIOG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so811648plt.3;
        Wed, 03 Jul 2019 01:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2h20kHGJbizKH54h9j83TWNj7oYw/atmUiwKwp86SnQ=;
        b=fKeKmBgH/r9868YdIKvLTA3k7CbTCv10o66dZK6ybUnyyvWVMD8R2TGU1qJh+hAnJp
         HrpDNCdtD8A7vfpn4ptaqEs/c829m0VMWfbzqUyj+9W+2VihboRzNBJG/SB4qUsKGk3o
         1hZ89ZtUcxPloAuxR/6QDl/k3Xanh5UMwgYmfEGclxWLcbFCBw1w5skOSPlE5+0DSKJI
         wp01QNb9PjRNTD8pt1iwpnv4DAaJre2FUE48GNbf1tDXfmAETLuoUOtbrTjn5WPy1xZ4
         sSirh2H87bN0hlye6RsmBvwVI1IGk8AIXN2G6Sg34rsvLzOB1NMy8XPZhmhVlWJD+Ahl
         MjUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2h20kHGJbizKH54h9j83TWNj7oYw/atmUiwKwp86SnQ=;
        b=l2gZRRXyws2jkXJE92PDkbgXPRmreMF8RZOA16BbiTyn19zhzjE2RMZqVWTd2kMOJl
         /OtDhkuqLHVjYPpP8NLKN6NF5DnxVFlcj9jRRgwgrJTY1gVwDGKQ3PxcfY+SDfWmRUHE
         x/pHgQLhawqxBj3J4f6l2aP3S8qzUZkssMIHsVrkOQDy3iAf3NpW2RLnLYC5xiuxsUgw
         G++LZODdB5IZwlkRp1PYoHq1Rswmq3WX2rz6Qv8bxkGLCdlBXPRl7qkoBIBgbtgSwIfi
         vRxiErgj3AvHg3EOkKUVWJftaFFsTlxOZt2/R1i3lIt/iF6Irc94mBaKKlishKty+kMC
         ji0A==
X-Gm-Message-State: APjAAAWquRsEi+MhO6JIbnlZvp/BQs56GAeSMUbMErxru1PncwKe7/r6
        sz1+iW/ncZrLRDmwXE9/eH4QjLAGjoE=
X-Google-Smtp-Source: APXvYqzjwjB4kCIa+danq4eu6nHIemNaNDAtFQxoSKzSjiWGZh7s0VOdA19bW6jxIk9Wz5V2GmjpuA==
X-Received: by 2002:a17:902:f213:: with SMTP id gn19mr42057694plb.35.1562141645054;
        Wed, 03 Jul 2019 01:14:05 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:04 -0700 (PDT)
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
Subject: [PATCH v4 06/16] crypto: caam - use devres to allocate 'inpring'
Date:   Wed,  3 Jul 2019 01:13:17 -0700
Message-Id: <20190703081327.17505-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190703081327.17505-1-andrew.smirnov@gmail.com>
References: <20190703081327.17505-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devres to allocate 'inpring' and drop corresponding
dma_free_coherent() call as well explicit references to size of
'inpring' elemet (needet in following commits). No functional change
intended.

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
 drivers/crypto/caam/jr.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 1eaa91dcc146..813e9135babd 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -108,7 +108,6 @@ static int caam_reset_hw_jr(struct device *dev)
 static int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	dma_addr_t inpbusaddr;
 	int ret;
 
 	ret = caam_reset_hw_jr(dev);
@@ -118,11 +117,6 @@ static int caam_jr_shutdown(struct device *dev)
 	/* Release interrupt */
 	free_irq(jrp->irq, dev);
 
-	/* Free rings */
-	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
-	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-			  jrp->inpring, inpbusaddr);
-
 	return ret;
 }
 
@@ -451,8 +445,9 @@ static int caam_jr_init(struct device *dev)
 		goto out_free_irq;
 
 	error = -ENOMEM;
-	jrp->inpring = dma_alloc_coherent(dev, sizeof(*jrp->inpring) *
-					  JOBR_DEPTH, &inpbusaddr, GFP_KERNEL);
+	jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
+					   JOBR_DEPTH, &inpbusaddr,
+					   GFP_KERNEL);
 	if (!jrp->inpring)
 		goto out_free_irq;
 
@@ -460,7 +455,7 @@ static int caam_jr_init(struct device *dev)
 					   JOBR_DEPTH, &outbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->outring)
-		goto out_free_inpring;
+		return -ENOMEM;
 
 	jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
 				    GFP_KERNEL);
@@ -493,10 +488,6 @@ static int caam_jr_init(struct device *dev)
 
 	return 0;
 
-out_free_inpring:
-	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
-			  jrp->inpring, inpbusaddr);
-	dev_err(dev, "can't allocate job rings for %d\n", jrp->ridx);
 out_free_irq:
 	free_irq(jrp->irq, dev);
 	return error;
-- 
2.21.0

