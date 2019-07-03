Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B700BC06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C2F218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lq1x3a+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfGCIOF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36464 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfGCIOF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so811616plt.3;
        Wed, 03 Jul 2019 01:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9WUDh01MjOopjE2651F/x1CBV/vDwEN3vFSVjbCfKwU=;
        b=Lq1x3a+QBg/bPxKkRGIQH/UAK1iYekfX7MVQv7letnQBccACuyCFvLD2qVTuuFZogz
         /FcNgnWnpj/a2NPZW0/tO0DZQDYKfZvD+02K9I/HBO1NLrv1pOv2c+WqDCcPdPQrgAmG
         pdKSios3ua9DEdcOrAC1Oh41B1lWYLZ80h2uTqtl8oDUGFws873ha8tNjwouYxPHyE5g
         znOgH2cqbld/afw/9vwVVCWGmzUV7zhRZmrs+/D2jc7ERbk5QlboxsrVthIG+YqkFU/K
         kIf2CXA4YkgjyghFJ2jVJnMuCsdoe+FiPOHyojlZKBwg6KOTi11OSu0Gppkr6ooM1TTz
         25Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9WUDh01MjOopjE2651F/x1CBV/vDwEN3vFSVjbCfKwU=;
        b=McbInfIBLP/RnpO/InIjePYLDMNtxi2dFRCXg/6IOsY+fUeMWoENjXtUv8dWr/tsGE
         QGOXZvgriUizi0txoTTvFBg2+GNkjLq0PLgalrIlBaODykX8nB6V7m61u4+7ePLrDyAF
         FRoC/saGiv72eH6+BkQeTCL6ym+i5JTyvx6tF6Tn4B2Jh/My2M3v6zrqv2+fb1cwmUq2
         HB2KiAcrZrHAtzWVF4smCBUqmHvYMM2oNGRHBD1sXD1M1cumykA5GsZhD+GByct4AB1n
         xbRgz47OpIjQYi3PyFj6qP38GKePw8ZvMdtAGSj+3cU2qF19cRRoyRb6l9tq9jEEw+Vv
         /vXg==
X-Gm-Message-State: APjAAAW5RUj1uS5Hsv12Uf5iatAMIOf6GA99lF8nbR75QLDYie8VOhuw
        UYnsmJPRt23aqKjgm0PwfSv2ExfgOak=
X-Google-Smtp-Source: APXvYqyS/mLU68zLObUvHEK0z68mtiUbdOO0ip92Wh2px534KXtR/5l/W1NpAs0gdeylAoUcJyB7yQ==
X-Received: by 2002:a17:902:1e6:: with SMTP id b93mr40713178plb.295.1562141643827;
        Wed, 03 Jul 2019 01:14:03 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:03 -0700 (PDT)
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
Subject: [PATCH v4 05/16] crypto: caam - use devres to allocate 'outring'
Date:   Wed,  3 Jul 2019 01:13:16 -0700
Message-Id: <20190703081327.17505-6-andrew.smirnov@gmail.com>
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

Use devres to allocate 'outring' and drop corresponding call to
dma_free_coherent() as well as extra references to 'struct
jr_outentry' (needed in following commits). No functional change
inteded.

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
 drivers/crypto/caam/jr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc7deb445aa8..1eaa91dcc146 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -108,7 +108,7 @@ static int caam_reset_hw_jr(struct device *dev)
 static int caam_jr_shutdown(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
-	dma_addr_t inpbusaddr, outbusaddr;
+	dma_addr_t inpbusaddr;
 	int ret;
 
 	ret = caam_reset_hw_jr(dev);
@@ -120,11 +120,8 @@ static int caam_jr_shutdown(struct device *dev)
 
 	/* Free rings */
 	inpbusaddr = rd_reg64(&jrp->rregs->inpring_base);
-	outbusaddr = rd_reg64(&jrp->rregs->outring_base);
 	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
 			  jrp->inpring, inpbusaddr);
-	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
-			  jrp->outring, outbusaddr);
 
 	return ret;
 }
@@ -459,15 +456,16 @@ static int caam_jr_init(struct device *dev)
 	if (!jrp->inpring)
 		goto out_free_irq;
 
-	jrp->outring = dma_alloc_coherent(dev, sizeof(*jrp->outring) *
-					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);
+	jrp->outring = dmam_alloc_coherent(dev, sizeof(*jrp->outring) *
+					   JOBR_DEPTH, &outbusaddr,
+					   GFP_KERNEL);
 	if (!jrp->outring)
 		goto out_free_inpring;
 
 	jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
 				    GFP_KERNEL);
 	if (!jrp->entinfo)
-		goto out_free_outring;
+		return -ENOMEM;
 
 	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
 
@@ -495,9 +493,6 @@ static int caam_jr_init(struct device *dev)
 
 	return 0;
 
-out_free_outring:
-	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
-			  jrp->outring, outbusaddr);
 out_free_inpring:
 	dma_free_coherent(dev, sizeof(dma_addr_t) * JOBR_DEPTH,
 			  jrp->inpring, inpbusaddr);
-- 
2.21.0

