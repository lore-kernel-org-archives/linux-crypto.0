Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF64C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860A022DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o4TkNsG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbfHTUYg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:24:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38486 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731001AbfHTUYg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id m12so40149plt.5;
        Tue, 20 Aug 2019 13:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41CIshzGWkv7KtXuXJVjibF9O1EhLdAcmlG3QhRo590=;
        b=o4TkNsG4VKGXmj8YecwUAjiTxuLXqo5mRq+0lyNxOn/ihNYecJUEwCBzd5xoZPHnJG
         XCC2NM29L+STqa2/HODLoDePubSqmqpnmgFjWPuk3SSRMn1SLFPmrx7UpPC0KxQwZykn
         8E9oUCrzNL4sxwAZkwcFw/nZAFcAh5BjFQ8/byVTamR56VVMyMsbFNLeUyshNi2hQNy7
         b0yJwbRJnkJgpi5Ee4CLWDA8xszBN0LVMB2S2SfjhqrzAGd2OZ3cmwR3f+gmfiROkZpS
         Fnesxz3t8erJyvzCQdMyCayLlEyri4NmspQzL1LpN0XsK9s7QLGniZ15gtpv5m1b5wqj
         uNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41CIshzGWkv7KtXuXJVjibF9O1EhLdAcmlG3QhRo590=;
        b=el9SVmYDhQxECO4PC692r9A61DibWA2YV3tZu4wMUh87Q4eOGRAi5Fo+q5i+eWY6bo
         Q2+lbh0iZNf9fSVQGJfWAi5ZuhAy0jdpKFEX0xyZ5WNCKvGjhrytV9YRlZ7l9I0E2Zsc
         1hN2qN+IgbC7YgN7QRFlP5gNgMxZbIpD0NFuaOPqESm7uxQpEiLuKjR9UTYB7BYgWWXF
         9xlXms7VyXas10VHaIv9xH05Poen33jb+hmuZ//kIvMnRB7q+f55bYxChHvrbDUJxgJH
         Shw8sskuBTsXg55a4oR+Ul7mCFpVkC5X6+zu88Nx0CTe+OLWDkljEOgEYI+cElB0yTZt
         xJYA==
X-Gm-Message-State: APjAAAUlp/PwCn7XpqJvZdsYt6ooGhUdQBwwQbTA6HH9FTUooxEdiVjT
        5dv2TRe2NmksAEK9Kf6BzkT9pfYNnLc=
X-Google-Smtp-Source: APXvYqymvn8S+nzVlTObKe0xiL56gvAQoUZk+mP7jibvgl2vQtS/hfmAZat11FmbFBeNjIfo1bAPoQ==
X-Received: by 2002:a17:902:41:: with SMTP id 59mr7843549pla.268.1566332675116;
        Tue, 20 Aug 2019 13:24:35 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:34 -0700 (PDT)
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
Subject: [PATCH v8 12/16] crypto: caam - don't hardcode inpentry size
Date:   Tue, 20 Aug 2019 13:23:58 -0700
Message-Id: <20190820202402.24951-13-andrew.smirnov@gmail.com>
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

Using dma_addr_t for elements of JobR input ring is not appropriate on
all 64-bit SoCs, some of which, like i.MX8MQ, use only 32-bit wide
pointers there. Convert all of the code to use explicit helper
function that can be later extended to support i.MX8MQ. No functional
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
 drivers/crypto/caam/intern.h | 3 ++-
 drivers/crypto/caam/jr.c     | 4 ++--
 drivers/crypto/caam/regs.h   | 9 +++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 081805c0f88b..c00c7c84ec84 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -55,7 +55,8 @@ struct caam_drv_private_jr {
 	spinlock_t inplock ____cacheline_aligned; /* Input ring index lock */
 	u32 inpring_avail;	/* Number of free entries in input ring */
 	int head;			/* entinfo (s/w ring) head index */
-	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
+	void *inpring;			/* Base of input ring, alloc
+					 * DMA-safe */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
 	void *outring;			/* Base of output ring, DMA-safe */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6c91f38862e4..417ad52615c6 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -388,7 +388,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry->cbkarg = areq;
 	head_entry->desc_addr_dma = desc_dma;
 
-	jrp->inpring[head] = cpu_to_caam_dma(desc_dma);
+	jr_inpentry_set(jrp->inpring, head, cpu_to_caam_dma(desc_dma));
 
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
@@ -434,7 +434,7 @@ static int caam_jr_init(struct device *dev)
 	if (error)
 		return error;
 
-	jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
+	jrp->inpring = dmam_alloc_coherent(dev, SIZEOF_JR_INPENTRY *
 					   JOBR_DEPTH, &inpbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->inpring)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index cf73015b3be0..6dbb269a3e7e 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -244,6 +244,15 @@ static inline u32 jr_outentry_jrstatus(void *outring, int hw_idx)
 	return jrstatus;
 }
 
+static inline void jr_inpentry_set(void *inpring, int hw_idx, dma_addr_t val)
+{
+	dma_addr_t *inpentry = inpring;
+
+	inpentry[hw_idx] = val;
+}
+
+#define SIZEOF_JR_INPENTRY	caam_ptr_sz
+
 
 /* Version registers (Era 10+)	e80-eff */
 struct version_regs {
-- 
2.21.0

