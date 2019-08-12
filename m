Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83382C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4940E214C6
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAdg+tjI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfHLUIS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38919 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfHLUIS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so46250775pfn.6;
        Mon, 12 Aug 2019 13:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TkVFUnWvJCHZSuz5kCJjBMCkT9Ucd3dtuxDhVNZWcP0=;
        b=eAdg+tjI3A7omgWRkKbaQG5PSDmWL8NOhp9uhbnpMX/+grYWEV3arx7AKWPITwJ6iS
         oc8jJ+6MZWy4u6F23V9c3CU5U71Ei+rmBLgd7hkL+vtZYbBnOeMzzqewPgT1CLE+O+LT
         /qlgQPvm0WVyt7Nb0dP9eJFi/oR3/StrhNV0tO5pQpUb/P6QYwt6rda2nMsifrTAdaE7
         dEYPmmVKQGAtW94sFG0E34MhjIv4L0rbyKPRf7A82Eip/23UMNdyQ6cVwgQ0gFJGo+if
         DGeEyme/w79NPLQQYcrUIfuztIak1e/8zNdvnaSn5ri+Ql9eWXUJoid4S7vMeqhbdGZU
         B67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TkVFUnWvJCHZSuz5kCJjBMCkT9Ucd3dtuxDhVNZWcP0=;
        b=dtQ4briB9tnWCLej8A0/aKbI2BChl6oirfzyP39D2Axev+tvaYw+AVL+7rCKJFnq4d
         FLXN9M9ZiLta0eOZCxB8XU9ue4tuXqcikpbDJW4F/jdSLQdOzXVoMRwSxUHyRvaX9enQ
         NBvnIXYlIQdpAceSsX2cO61MKTmMNr2nRe2Epz/BH9oGpt3PHDCI3i0KKYUm7jQEC4pV
         B8nFc3AiJQd4KYWwpyZn3V5HIY/2a6QUP1xIWolx4GpreFl4QaUoV1mlHp5mMeIXvaTg
         wwVFs+0O/xO0/ncsBwKmV1eN0edwAXIR75nKoRo3Wsa/2hWGDivV/mFTf8Og+4EJmfm9
         VC9g==
X-Gm-Message-State: APjAAAUfITz4nf+QZOWakWJHbo4WkXyXwwftkH2d4e6/nDn579rHvbRk
        brmJJwS9L70WqsoTI1bBJte3k66R
X-Google-Smtp-Source: APXvYqw5rP9UaDzJcbd3PRjBHqcx/piuWhD0oy+tYrfqUwOQd1xg7XSxvkv+nnEnf+o6cQH26N0DXg==
X-Received: by 2002:a17:90a:3321:: with SMTP id m30mr973297pjb.2.1565640496749;
        Mon, 12 Aug 2019 13:08:16 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:16 -0700 (PDT)
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
Subject: [PATCH v7 12/15] crypto: caam - don't hardcode inpentry size
Date:   Mon, 12 Aug 2019 13:07:36 -0700
Message-Id: <20190812200739.30389-13-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
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

