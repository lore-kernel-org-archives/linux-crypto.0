Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD913C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67B023341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgLGJAy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJAx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:00:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CC8C0613D4
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v1so6972803pjr.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYFZGtLuk72sYVLmu7rAbpM8KMBKDbH9+vOX7LfurE0=;
        b=IpnVdSiSemytDcytJ/5iu7FzpsyNRWhYZE2qMPN2PEOIzGIirH/N2n7MwgZ33xOFU4
         EncwQQk1z/FTFpmv+XQyY4Ev34A5wIKzSPO5/GU+FKE4av2/CKnEJcgk9l3lC1ulTV3E
         120TL4CPYg9p9Bl/opZdRcF95O0qDwKi9zuUHadSVGpeAFPG7HLKSB4FvQnS5Ndituho
         6cr6dqSOK0px3ATrHP2j3m43O+Mf1mrMFA6zeUFzy6iz7zsffmlL2Ummkx1lkljxSrb1
         dHkIoyEqj/yLlvfovox2lSX/2WjIvnEJoyk86SIg3U18XnippUvXHUGpSvWSyWu0BZCS
         82eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYFZGtLuk72sYVLmu7rAbpM8KMBKDbH9+vOX7LfurE0=;
        b=i2io2i63jS96UUDzYs7G2Byn7Th1NZLP2L8fpyrWagSS58aKUO0zl7tJciSJe7JAFY
         LTdBRl+cMr9QMh3dbfT2vuVmxDPERHku/WAbOXdYwE8d98nd68sNiV32jm3hBRSZzmxf
         ngsggkSLcY52bj+KzR902tLSXBR76MfcvMQ9kIY+RUYAPCrd4NkUoXPtglq6zLcC7KzY
         TjzqwWL0HYBiN/mkadOuGwAvKJm6qEBI9JucX6Rm1vYghQKgI3MH54bu6lJ61fVSI280
         4zDaChywXPBFKhmpE6fiexKP9ZnMrvvNW5hm/wX8WwlAX5HP8X0rPFSX5XLA5fF7IWCX
         X5Uw==
X-Gm-Message-State: AOAM5318+EE9ZWE0qEMPV9f/0v2fkWqdblBMq0Fn+da4Ztb9geIeO0tr
        YKthb8UxfqslQ0jKJrpnero=
X-Google-Smtp-Source: ABdhPJypQnGHb6Koy+LvWz3rGHdxoNLT3V6GHblscF+Ke6QXc2UaGU7WVh0KcaohTb7qVbU3V1njVw==
X-Received: by 2002:a17:90a:7101:: with SMTP id h1mr15269864pjk.26.1607331610345;
        Mon, 07 Dec 2020 01:00:10 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:09 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 04/19] crypto: caam: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:16 +0530
Message-Id: <20201207085931.661267-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/caam/jr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6f669966ba2c..1b5939e42e67 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -9,6 +9,7 @@
 
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
+#include <linux/interrupt.h>
 
 #include "compat.h"
 #include "ctrl.h"
@@ -201,11 +202,11 @@ static irqreturn_t caam_jr_interrupt(int irq, void *st_dev)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void caam_jr_dequeue(unsigned long devarg)
+static void caam_jr_dequeue(struct tasklet_struct *t)
 {
 	int hw_idx, sw_idx, i, head, tail;
-	struct device *dev = (struct device *)devarg;
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct caam_drv_private_jr *jrp = from_tasklet(jrp, t, irqtask);
+	struct device *dev = jrp->dev;
 	void (*usercall)(struct device *dev, u32 *desc, u32 status, void *arg);
 	u32 *userdesc, userstatus;
 	void *userarg;
@@ -483,7 +484,7 @@ static int caam_jr_init(struct device *dev)
 		      (JOBR_INTC_COUNT_THLD << JRCFG_ICDCT_SHIFT) |
 		      (JOBR_INTC_TIME_THLD << JRCFG_ICTT_SHIFT));
 
-	tasklet_init(&jrp->irqtask, caam_jr_dequeue, (unsigned long)dev);
+	tasklet_setup(&jrp->irqtask, caam_jr_dequeue);
 
 	/* Connect job ring interrupt handler. */
 	error = devm_request_irq(dev, jrp->irq, caam_jr_interrupt, IRQF_SHARED,
-- 
2.25.1

