Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82BCC433E9
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6982F238E5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbhAUExK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731609AbhAUEnN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:43:13 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AE3C061575;
        Wed, 20 Jan 2021 20:42:33 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id t6so608044plq.1;
        Wed, 20 Jan 2021 20:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=kQ4IBs5RGnxInr65CELhjNbEAk272NcmVxA31yPCdWxsh8gHBtj49IutKuAasFo3yv
         IdtGcXx3Q3UWwDKkTnk2CAP1OAQ7GGFvE40J/YUquxFskntsW1qmjzmfRDT+S5zcS13y
         Bo6ZYhPz6IxuWtNbFtn71VbgYkYbSDIslmydhy28FcpM1O5hc67TIljw08KXfEdfWXkx
         6REi5dh3N+ob5S1rWMXej9sjVQx/3gZoF1ozlxRVY5otuV/EbVRfZdpBS1a1Y/rUflCr
         p8HeKv4E87J1PPExxLRnR+984RSHIJF44bnmjvs/mUwjJjHpZeQhmqHqjiT12urkowrr
         dVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=LDDyd4KPmaMaFB4PmvwDOpKdxXhNdGXO18UJbVVP3aNq0zfxL1KGZ2efNuoYGfdxkZ
         VJQR+/1D5qFKpRIstOiP8YJwp2l7SBCQigQHxEw761UznGrQCiv9A4aAizVX7TLte4D5
         UgjySTeaJmFkk8FDxdul7xfNRV6Z3bOOUxaqxwUH9HvgBXGsnUytZ/W5yPLYlV061zRp
         qkMGM9AZc1y4+u54yQiLUcspMosRg6xivpwbK3YKAcbdEd8xrV5aEq7bSGdZMplGRZ2P
         xWvdihrcek5HxSL4/0goEbCc+Ld4I4mjSGbX+F+f+fiZPPoqFn8MJgEUrfQSEnZTSkxm
         sPrQ==
X-Gm-Message-State: AOAM532CYCcfA5cz4EsqI75DxohNbnqqdxCaJxsPoxir09mqAoiuAZ4T
        fkd/8QAXsSa6/ogz/IRW7TM=
X-Google-Smtp-Source: ABdhPJz3gROHw2YBVyuK/onSBCkTE15+V84IiSlj0HhFbNpYb33RBgymr84d61EoU4s8NU2jWYoi2g==
X-Received: by 2002:a17:902:7088:b029:df:cbdb:a0a6 with SMTP id z8-20020a1709027088b02900dfcbdba0a6mr3010271plk.17.1611204152572;
        Wed, 20 Jan 2021 20:42:32 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:42:32 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v4 04/19] crypto: caam: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:11 +0530
Message-Id: <20210121044126.152274-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121044126.152274-1-allen.lkml@gmail.com>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/caam/jr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 7f2b1101f567..2903e1af0a56 100644
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

