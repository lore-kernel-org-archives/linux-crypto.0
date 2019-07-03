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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E59C5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1132C218A4
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gf+EoZd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfGCIOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35504 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfGCIOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id d126so865787pfd.2;
        Wed, 03 Jul 2019 01:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=acSQGaqvkGp3mvounPRRghTuQfM60axtHBshvdJN2QY=;
        b=Gf+EoZd8jc+dZE7zFplsrWncC2B1ZpgPjad2XR5GG4L6GVTPyXVq5nCdQSNkbBydcy
         GIntxPFevORF2eYUEZ4fgGs20cVk1TEJSFRnoRJNWIfCVqxOZgZmsVxxNHe08T6AdiDg
         85nfeaYfeZqxbYfJibi+oAwYKDj21UO5hB72jSuSbvhNzZrhgTn+j8uvAMFA/u2fZu3k
         N8onOpoUSfUxCF7iwjTUgVTFW/H1AItQzDUpQhVF05P2MtlxsyCyuyu/Z6lEJugX8iZw
         gAAbHQzP3YRLtmm4SUbtJxztyPWmUg1REQRvqMiULzu8ZVp3UeSTDFNqNfvtUjqMlTni
         VHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=acSQGaqvkGp3mvounPRRghTuQfM60axtHBshvdJN2QY=;
        b=OIecWYKTuO3LcfhUR53wU1C3hhq55VrlUJc5L4yV9MgBcPfM63STNFyHpPAiOOW5Ya
         jIaOjV1Jaw6MmScPCmFl1QcL+DXAOZPI66178R3erYru98VP/p1CdVQ11Y05AaovZN2l
         vW3CrbuXhmthQ4hSG3yHKqg0YfhkM4s6V4/95zWX+iwk7l4imljuzMohGKml8mILbah/
         IMAZFbeF6gtJLTY6oTNPVCnd8fY7lzyo6Npcf6ZN6hoCRtJPUy/Fc8jgCb1DPIYRtE1f
         v1woibepdB8Fl0N4IByg5DvIYgSh/zY7DrqlkP5XPOqnf1uxVsSe3igimlXrDZzSsxDs
         pP0A==
X-Gm-Message-State: APjAAAXEmOD/yAAeyosc13Yx4sF0ntbuEjx4oJi03nGONcMAVi+qXLLL
        SW7oa/CtFHMdcYUUWCjvRzokR5Rv4mM=
X-Google-Smtp-Source: APXvYqw87H6zgg3sY9Oe8VuORrp7I9q422aqHXW/hcABMaqFiJ+EAzq1Pl5WOY4mXUql1/46mZBPjw==
X-Received: by 2002:a63:6986:: with SMTP id e128mr37215243pgc.220.1562141654777;
        Wed, 03 Jul 2019 01:14:14 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:13 -0700 (PDT)
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
Subject: [PATCH v4 13/16] crypto: caam - don't hardcode inpentry size
Date:   Wed,  3 Jul 2019 01:13:24 -0700
Message-Id: <20190703081327.17505-14-andrew.smirnov@gmail.com>
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
index 88777cc8adcd..fd20eee8169a 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -391,7 +391,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry->cbkarg = areq;
 	head_entry->desc_addr_dma = desc_dma;
 
-	jrp->inpring[head] = cpu_to_caam_dma(desc_dma);
+	jr_inpentry_set(jrp->inpring, head, cpu_to_caam_dma(desc_dma));
 
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
@@ -447,7 +447,7 @@ static int caam_jr_init(struct device *dev)
 		goto out_free_irq;
 
 	error = -ENOMEM;
-	jrp->inpring = dmam_alloc_coherent(dev, sizeof(*jrp->inpring) *
+	jrp->inpring = dmam_alloc_coherent(dev, SIZEOF_JR_INPENTRY *
 					   JOBR_DEPTH, &inpbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->inpring)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 0cc4a48dfc30..ec49f5ba9689 100644
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

