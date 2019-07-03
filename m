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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2D7C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46772218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXBXHY2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfGCIPJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:15:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33748 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbfGCIOD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so870044pfq.0;
        Wed, 03 Jul 2019 01:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6BcX9hRF1ZcJg0bLQVxEUNzqf7x1OYXFm4Avex33mzw=;
        b=NXBXHY2rOfDIIefdmLBUtihvwLxZoamAXmXEhzmcHgE1//wHqu3N1fJ0mn8cVhHOCY
         oEG9EAi5UrMAFjLuT380GshZwbi9WWx5FVLWdP/QZyW9ZAA6CmM3qbw/f1ahx9RcQLxR
         FYTyL4nso9PO/ba16bytiqE7aorc8O6S/c7ZG7OM023sGc1+izwyw7WiDvL9v4W1cKf4
         ZPBVAVDOOGRRfS7TyyW5v/plLynTgr+i6pL/B09mmY+WQOv9bmJkP46+e3MZTYcWPq2C
         xdcMXwaK6ASx+lfT91VB/cds4KVep1xnFDTRrWZSpQ/g+xIZYhkynwJ8X82KgADmODYy
         8DMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6BcX9hRF1ZcJg0bLQVxEUNzqf7x1OYXFm4Avex33mzw=;
        b=Q2EnOC8f1HTJluq2GyFhl+J0Ga5rVU/aBc+O1uR5IZ6XD/8wR+7ZZhRaxq4OYc/vZH
         rpENtXBCB8Y8jLCw2BwOC0Z0kOAkP6xCulZSIjvi0Q/LCGeHNElfpHBuCMKX76fZZzyI
         yzPBSZc5P/fQCRZt+LX7NKe0DVWO63x8uKPuxXiqCa59i28NwzhGFu6qRDqCFIgmypE7
         PlRkZzlsnYrszhlcr3DOMD/p3cqnyFxRaYPUz6mGDwqSNQGys6CbQe2g3BCBX8nj23qr
         r5bY/bMETOitxnFZ2mtMmbhRIyPtwW/aawWhVNRK4Y7P2ivuMjam2+x7RlXzTrshmnHj
         IHhw==
X-Gm-Message-State: APjAAAXtevJdkHSOe9Nq/vSOGeuNEhF8Why8c1k4e8W594K0SgkM5OZz
        vwd1iaDWRrdrexBH2yqVEK+dDTH6g6Y=
X-Google-Smtp-Source: APXvYqw8B01YxlWv3cdvdz1KbV9dJR9VvgR4WsLnkObSzKzJf+FzgcxEKHUe8Cq+m7lYJnf+Gu0+ww==
X-Received: by 2002:a63:3f84:: with SMTP id m126mr34593874pga.213.1562141642532;
        Wed, 03 Jul 2019 01:14:02 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:01 -0700 (PDT)
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
Subject: [PATCH v4 04/16] crypto: caam - use deveres to allocate 'entinfo'
Date:   Wed,  3 Jul 2019 01:13:15 -0700
Message-Id: <20190703081327.17505-5-andrew.smirnov@gmail.com>
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

Use deveres to allocate 'entinfo' and drop corresponding call to
kfree(). No functional change intended.

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
 drivers/crypto/caam/jr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index a7ca2bbe243f..fc7deb445aa8 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -125,7 +125,6 @@ static int caam_jr_shutdown(struct device *dev)
 			  jrp->inpring, inpbusaddr);
 	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
 			  jrp->outring, outbusaddr);
-	kfree(jrp->entinfo);
 
 	return ret;
 }
@@ -465,7 +464,8 @@ static int caam_jr_init(struct device *dev)
 	if (!jrp->outring)
 		goto out_free_inpring;
 
-	jrp->entinfo = kcalloc(JOBR_DEPTH, sizeof(*jrp->entinfo), GFP_KERNEL);
+	jrp->entinfo = devm_kcalloc(dev, JOBR_DEPTH, sizeof(*jrp->entinfo),
+				    GFP_KERNEL);
 	if (!jrp->entinfo)
 		goto out_free_outring;
 
-- 
2.21.0

