Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25A8C43381
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA0E764E9C
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhBHJse (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhBHJpp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:45:45 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BECDC06121D;
        Mon,  8 Feb 2021 01:43:40 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o63so9852300pgo.6;
        Mon, 08 Feb 2021 01:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=GQCluQJxJXU9uIGARRK+2GdtsN+NyXOuW/U2ccm33GGglLSogWbh5D5VtQmxM/E31U
         I7xCg7PyEbqoNcVzHtne/74YLLxgC82a1yHVRU09hWn83+P+g6l/xas/W8MYdfZoBuAw
         bpaz4N564ZDcqbEycWvbr4e7WScZ/41x/PuV0fWl53f9PJyAei/J1WV/zld4sLKHYFMV
         MqYqaIvsB+PzHeBna0n42H9H5BuAidKVJZBqAC3ZvhmBTM0q6jduudkK3ZeW9K+sPJwb
         8qPVdLqq5mTyRfMNFAtAxayXTvPMBN4tH7x6WTUqc+XNQOj39ap9bRBV7WmkRDIhl5dZ
         or6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIfhZma4t7M0QhjqQIwVj37Q6U0ytCyWa6sVJ86x3+E=;
        b=nsMsGZoFiHmj+9U8gHzzDuwM0N6UoosNGUIC1kCYzcWukXzBCNkPYadYL3d9U1Z6Ku
         yUviQEKkLRA75Y1lMTKSP/0CBycChcRxsPr8GW02C6X/6xyZqMbgYZqz9opUDkqC7NB+
         +91ysFxv7riAxvhrp88OG3iwRQTcJ2KMaJJ3jlpwPLQA0+wtzypeWLquyVrLIf013/4W
         7xZiiP2yjNnCtTlqXWjzX2iSzm7woWRWPCIbw2qNtXlhWNP8jHq8TFY+goNoCZor1LkD
         r3e4DaprpGIj42q6bCO1xJOpcAC+1AE8fFW4RuRNkYjlcUYSrIFfPKW8sgP8FFbzcrL+
         xOzA==
X-Gm-Message-State: AOAM53394HkPS8b3uHFGLgitdFGRWtiTGvTWlkD7gghSI/hF2VLZV9iv
        qUnCubVa9pGEGUUSwir3Hjw=
X-Google-Smtp-Source: ABdhPJyCi6H7A0+lSBpy0VXpnhSlJbVPtYI4IZSa+s8nFTsLOY3aaUqBz0iAZ7ZtST6WEnXqN3wlqA==
X-Received: by 2002:a62:2702:0:b029:1d1:b92a:ef2a with SMTP id n2-20020a6227020000b02901d1b92aef2amr16985867pfn.5.1612777420043;
        Mon, 08 Feb 2021 01:43:40 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:43:39 -0800 (PST)
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
Subject: [PATCH v5 04/19] crypto: caam: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:23 +0530
Message-Id: <20210208094238.571015-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
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

