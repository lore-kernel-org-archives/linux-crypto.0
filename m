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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DB1C7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E2EF2173E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 20:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+1xk1Ef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbfGOUU2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 16:20:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35493 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732646AbfGOUUE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 16:20:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id u14so7958141pfn.2;
        Mon, 15 Jul 2019 13:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjkoz5FfLP6toRFqWP/+xlvUq5++XvAds3/6+Iry0Wc=;
        b=Y+1xk1Efayam/RGlrrXOiL6NKHkRki3fTyaKo2w4J7fD6uuul7dyae2MEdUMTLsWyM
         CkLbVaYOt6877lACC6cdoB+AV5ruCL4m2qoMCxbUw2HIT1/fU4NQ3pkrniW8nk04uGps
         u6ns4ueynlFv61UrO8sXyBKxK59PCFV7/fiex6oBk77h2OMf8jKMke2xaqo1Qs6PN3TH
         1BFtHrfNGidBJl2UeBEHhVJfdAHmSi6QqP6nF8Lkhk2eNtv2nVGdSxrVb/3PnQup9DOy
         MpNQ7V1Hpr8EXHGazKXKl+bsuEDfx1ihcxWBEi8EVCM8cgxb/yNfTI1e6K+x+ynwDl+U
         ezAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjkoz5FfLP6toRFqWP/+xlvUq5++XvAds3/6+Iry0Wc=;
        b=WIJ/B8HDOLUG/zjMWgoQQ+6uonZtA8gZGMZBQn8eicvyYGLDcUpAkVm/dI+hXebJjd
         +bQvJcN01i1oX+B4D4aH8rbKsfDBCnslJp8K36KpWmBxK+rHMX1OI/sIn+LnsPz3MMjL
         kqtg1zPgu38FUArWcTBtbMcKvk/uzQ+p5sS+N13KbaZSzBBMSkXRNtkOnfS8xKsBdvbh
         yBXMACiiddoMvFZOMODlAus5p/n3P3o+MluJy4Hv4zcgr2GFnLLDQDPT8beRwVowDZCE
         KABNS+6SkG3xYde89r59RcBttsJDi4gcLtBpBmvHcKdeCFE70PKdFzfF/FUX5eg6/tDY
         N97g==
X-Gm-Message-State: APjAAAWX49qoa+kU1CPxqD6+8n+AB4pzDBo6CVxC3UVQagFWAlQ59VO/
        kExBkljQZ7hv1zlE5h6+ZaYW2zVH
X-Google-Smtp-Source: APXvYqwHm5fcEmWVRcBVmAJ2kgGu9+h71HxhZRgZ6p6EUgyZDB9U6NCU80LG7A2vw0zzFtqHNhQYbA==
X-Received: by 2002:a63:124a:: with SMTP id 10mr28643439pgs.254.1563222003867;
        Mon, 15 Jul 2019 13:20:03 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id h1sm22730534pfg.55.2019.07.15.13.20.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:20:03 -0700 (PDT)
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
Subject: [PATCH v5 11/14] crypto: caam - don't hardcode inpentry size
Date:   Mon, 15 Jul 2019 13:19:39 -0700
Message-Id: <20190715201942.17309-12-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/jr.c     | 2 +-
 drivers/crypto/caam/regs.h   | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

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
index 138f71adb7e6..4f06cc7eb6a4 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -388,7 +388,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 	head_entry->cbkarg = areq;
 	head_entry->desc_addr_dma = desc_dma;
 
-	jrp->inpring[head] = cpu_to_caam_dma(desc_dma);
+	jr_inpentry_set(jrp->inpring, head, cpu_to_caam_dma(desc_dma));
 
 	/*
 	 * Guarantee that the descriptor's DMA address has been written to
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

