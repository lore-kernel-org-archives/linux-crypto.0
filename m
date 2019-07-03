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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D985CC5B578
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6CA0218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L77cWPHJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfGCIOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:14:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33761 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfGCIOO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:14:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so870309pfq.0;
        Wed, 03 Jul 2019 01:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JsaGYh5oI2Sxay5T/tRKxxVHI+1jxM9KtqCiKY4aPvk=;
        b=L77cWPHJSvrVFB2KVrUvLZ9y/iL2adGSp9JfyqbEC1s2i2CAxLaG/FZeX9YFC5W+Yz
         8nk6iRNqfD+hwA7hd4gr2ZY+BD/M5nUCvk3tiCLdl0KnFrMRaH5jlOG+x0bGsCgMde2R
         +A1Zoc0mRIp8DcAzzTD/HnY1S/FNolgFw5mcamdhioJnhnC3W6U0LG55ZeJ+9Wy3NDHe
         bgHu/8RQ/WtGITh66vy+yVvPA3kvD4nj/d6mtvUwppzy6ofjL5Q6chqi8Xy18Dem429J
         Dhhre45Jo2KdFqWgojiIOb6WvpqKGHFbzMtzkh4n35EH7IrQUQEd1wnbqZ2TFWADb55G
         YBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JsaGYh5oI2Sxay5T/tRKxxVHI+1jxM9KtqCiKY4aPvk=;
        b=gVsnMAqmgeyrkl/7pxrQndUSbUlvYJjR3Rj3Ti1Sxq9EjRKcufVmzpZWXLMQrjjVSG
         rdeJZbDy+kkVM6ogWvWwULtFVlv9fXPWucoUDgZV4Bwx22VCr6Pwp1w0aDgRZoPp1s2Y
         npGncaDAfVPk6CW4H4L8bS1B4hq5cpPsC0aKeuzZXZHs/JL8OqR9EnxJ4t/fKrTy8bHR
         jeJ0wwkMFABk5+MCuMq7cEG23D/tXN8qHimdgivOsRlG8QOjAE/PqUBturiQ61SRHRiK
         kgZvS6pDXkhl15XMNO6rbODqaCVL3baG3VzFkUNaT9fxcEvFSzjmb+gWtlTwmGegt2is
         9iiw==
X-Gm-Message-State: APjAAAXeeqYaJ/zm12tCfKkIMLNmVCKcba81FRI8L+Maeey0qaa8R3Ow
        /LA24/1lFFaSBo/9hvZDgse1tisdczE=
X-Google-Smtp-Source: APXvYqzTxcyuNBMV/+9ihTZG24HI2OA/zO6XuWoSz13tHX/TBVkjt6E9xuTbk6Nt3y4Ny+YtlDVwaw==
X-Received: by 2002:a63:221f:: with SMTP id i31mr29807587pgi.251.1562141653187;
        Wed, 03 Jul 2019 01:14:13 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id d2sm1445306pgo.0.2019.07.03.01.14.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:14:12 -0700 (PDT)
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
Subject: [PATCH v4 12/16] crypto: caam - drop explicit usage of struct jr_outentry
Date:   Wed,  3 Jul 2019 01:13:23 -0700
Message-Id: <20190703081327.17505-13-andrew.smirnov@gmail.com>
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

Using struct jr_outentry to specify the layout of JobR output ring is
not appropriate for all 64-bit SoC, since some of them, like i.MX8MQ,
use 32-bit pointers there which doesn't match 64-bit
dma_addr_t. Convert existing code to use explicit helper functions to
access any of the JobR output ring elements, so that the support for
i.MX8MQ can be added later. No functional change intended.

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
 drivers/crypto/caam/intern.h |  2 +-
 drivers/crypto/caam/jr.c     | 10 +++++----
 drivers/crypto/caam/regs.h   | 40 ++++++++++++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 1f01703f510a..081805c0f88b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -58,7 +58,7 @@ struct caam_drv_private_jr {
 	dma_addr_t *inpring;	/* Base of input ring, alloc DMA-safe */
 	int out_ring_read_index;	/* Output index "tail" */
 	int tail;			/* entinfo (s/w ring) tail index */
-	struct jr_outentry *outring;	/* Base of output ring, DMA-safe */
+	void *outring;			/* Base of output ring, DMA-safe */
 };
 
 /*
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 813e9135babd..88777cc8adcd 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -214,7 +214,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 		for (i = 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >= 1; i++) {
 			sw_idx = (tail + i) & (JOBR_DEPTH - 1);
 
-			if (jrp->outring[hw_idx].desc ==
+			if (jr_outentry_desc(jrp->outring, hw_idx) ==
 			    caam_dma_to_cpu(jrp->entinfo[sw_idx].desc_addr_dma))
 				break; /* found */
 		}
@@ -223,7 +223,8 @@ static void caam_jr_dequeue(unsigned long devarg)
 
 		/* Unmap just-run descriptor so we can post-process */
 		dma_unmap_single(dev,
-				 caam_dma_to_cpu(jrp->outring[hw_idx].desc),
+				 caam_dma_to_cpu(jr_outentry_desc(jrp->outring,
+								  hw_idx)),
 				 jrp->entinfo[sw_idx].desc_size,
 				 DMA_TO_DEVICE);
 
@@ -234,7 +235,8 @@ static void caam_jr_dequeue(unsigned long devarg)
 		usercall = jrp->entinfo[sw_idx].callbk;
 		userarg = jrp->entinfo[sw_idx].cbkarg;
 		userdesc = jrp->entinfo[sw_idx].desc_addr_virt;
-		userstatus = caam32_to_cpu(jrp->outring[hw_idx].jrstatus);
+		userstatus = caam32_to_cpu(jr_outentry_jrstatus(jrp->outring,
+								hw_idx));
 
 		/*
 		 * Make sure all information from the job has been obtained
@@ -451,7 +453,7 @@ static int caam_jr_init(struct device *dev)
 	if (!jrp->inpring)
 		goto out_free_irq;
 
-	jrp->outring = dmam_alloc_coherent(dev, sizeof(*jrp->outring) *
+	jrp->outring = dmam_alloc_coherent(dev, SIZEOF_JR_OUTENTRY *
 					   JOBR_DEPTH, &outbusaddr,
 					   GFP_KERNEL);
 	if (!jrp->outring)
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 511e28ba740a..0cc4a48dfc30 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -71,6 +71,7 @@
 
 extern bool caam_little_end;
 extern bool caam_imx;
+extern size_t caam_ptr_sz;
 
 #define caam_to_cpu(len)						\
 static inline u##len caam##len ## _to_cpu(u##len val)			\
@@ -208,10 +209,41 @@ static inline u64 caam_dma_to_cpu(u64 value)
  * jr_outentry
  * Represents each entry in a JobR output ring
  */
-struct jr_outentry {
-	dma_addr_t desc;/* Pointer to completed descriptor */
-	u32 jrstatus;	/* Status for completed descriptor */
-} __packed;
+
+static inline void jr_outentry_get(void *outring, int hw_idx, dma_addr_t *desc,
+				   u32 *jrstatus)
+{
+	struct {
+		dma_addr_t desc;/* Pointer to completed descriptor */
+		u32 jrstatus;	/* Status for completed descriptor */
+	} __packed *outentry = outring;
+
+	*desc = outentry[hw_idx].desc;
+	*jrstatus = outentry[hw_idx].jrstatus;
+}
+
+#define SIZEOF_JR_OUTENTRY	(caam_ptr_sz + sizeof(u32))
+
+static inline dma_addr_t jr_outentry_desc(void *outring, int hw_idx)
+{
+	dma_addr_t desc;
+	u32 unused;
+
+	jr_outentry_get(outring, hw_idx, &desc, &unused);
+
+	return desc;
+}
+
+static inline u32 jr_outentry_jrstatus(void *outring, int hw_idx)
+{
+	dma_addr_t unused;
+	u32 jrstatus;
+
+	jr_outentry_get(outring, hw_idx, &unused, &jrstatus);
+
+	return jrstatus;
+}
+
 
 /* Version registers (Era 10+)	e80-eff */
 struct version_regs {
-- 
2.21.0

