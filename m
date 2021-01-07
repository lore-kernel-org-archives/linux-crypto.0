Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FE8C4332D
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B1E2335A
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbhAGMal (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbhAGMal (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:30:41 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3898C0612F4;
        Thu,  7 Jan 2021 04:30:00 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id c132so4738321pga.3;
        Thu, 07 Jan 2021 04:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=H0SYn3zavUKS6x6UDhKNxQX8cw552XrJ/WIv8yRpRIM6sDKARzTk8yEKqCCKzEL7OZ
         Sqe2lyc88QLHWM7CCr2M//0J4DNWNtxS28SXcCB7UJ5dID9OCzEAcIv4JaHnq5lHgmgQ
         sgET4LPtv3JAqIE7o70L0OCCFn0KXXowlcTA1xUCm5ChdAd+757F4S2iJZS47qD5F7PY
         KAX+L9qLahgIkAr9XaXavaw81lYV9AEJ6o19/MZNYDN3ZwqsLEf4hiVKa70pM0eoIFko
         HItgzMuy7Wn4PFEnRymGiIjeu9ZTGEgiVO4ENgrgRMU4GygY5uxOiSCYhri8kBt+F246
         74Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=ESDMF6HjxBbs7dGCE/z0hsLxKJ/5DxVDrx3EuU19hADEn4HOjw0cfJtE8ieOLJe8hq
         /wWUrG6yj/SXrCp3lxLNaaLrUG9J6s+cfh0LL0l8PmHLb9C1QxLxXnCkgSkTXdQjoUs5
         bzoEB6FmkGbNytHjQM2gY/vLHVOzRzZh5ekl4zPGunqR2RNjhsBqM2wLcAMEXKVrGvDx
         x150b0XZmmWvpD1679Mkzj9cXGbQ4SjVd2VA9PuKP/H9biUjTe4eVokWRvph7ahy0CbW
         ZFjfBqpScohK9ted4dVIpujja43uvyRmxIlE28M1h0p0NfCV1zkClzyNvt0+i96ug5mB
         /LOw==
X-Gm-Message-State: AOAM533h2XCeEPhuEU9MgQuN5Z4u5St3Zv+kNmWftyWDQJd2Xc6Tgc+S
        FtBPZ+u+dRo3M74DYDo+58M=
X-Google-Smtp-Source: ABdhPJzT/YJktNDHrk/I8qZ8dAithbSQ7i/79m4+vWBw3oHcFA3VosHZj44pM2C/wLC4imXef32UQA==
X-Received: by 2002:aa7:8811:0:b029:1ab:9e4f:b8ea with SMTP id c17-20020aa788110000b02901ab9e4fb8eamr8543725pfo.78.1610022600501;
        Thu, 07 Jan 2021 04:30:00 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:29:59 -0800 (PST)
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
Subject: [PATCH v2 04/19] crypto: caam: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:29 +0530
Message-Id: <20210107122944.16363-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
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

