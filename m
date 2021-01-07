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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A23C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED9923356
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbhAGMbS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbhAGMbR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:31:17 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AE7C0612F9;
        Thu,  7 Jan 2021 04:30:37 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n7so4749512pgg.2;
        Thu, 07 Jan 2021 04:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=q1b14DkzpJRGPgQ2ngw61EBHyRojXOhmeARI7hubXPHWZuJ3ZbCQfQzA+Vg00Ji7oN
         eglKJajT/phzHNQdYRWyowE60icmapabNDIYHLcMsSGODXVR4fpdciDdCrO9q5WR2NbU
         Q9p/jU8+M97ZgPsiDx95fcTwUWO7Aj8NfhkPCmfEjaAehVV0TfU+lG8hYT0bH6zWhp0v
         e7EmYHPq+Pm8eCmjsyO8DmmO+Mp3YYK+9dT08gsLBSU8uvzy2wozGxVK4R+1O5tmkmvN
         VZSAcN/R5jx/0FmSw+VwcZ3O8gih4wxKUiKLLMVFbDRo19UMdcyq/Mc6JLZ8zr2v9UtP
         BmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=rlgrEL9WfMwLyZi6mb4mXhkxRdsAnNeOU8SsANUiEZg5zRbKuLlXBvO3XRs5uJ+rxs
         DVnHd0Ka1xFM/mOgiXeTt9N5uvR9R1ysVjigAMVi9jd8W6oc6s+cbPgWLd8Pfpp8tDQR
         bKFxYjHC46jtZT8vmnUKWuGJujBhwqSnxRAP3MJkZ+Aous7R8i07ZvDR9NLIKuY0+WHT
         eUxEN6nXMzRYa9wte9/rJjCkSd2qruCVCu2nYF9CsBQbeCeOhdCsbEAQD5D6rs2KuHbm
         2Af8HjDFVR79n7q4EBpfP0DCrlnUduI00gM596QFLZR4aoa9fxsObWE1VqYrYSEDp7gq
         G9Lw==
X-Gm-Message-State: AOAM531TPE3tVOWCDwOhOlZKTfYvxs5bEdFSf3jEMTYPvf5Q/YN1hF2n
        1x2XwvGsS6tnmOsIcaVAxvM=
X-Google-Smtp-Source: ABdhPJwRdfOyuDoYxkXBo3Lx4+KPzBzDxEcsdT+IBiU4+pw8wU/dgoW9f8IkVaCL9kQ9AK1QuLGQMg==
X-Received: by 2002:a63:605:: with SMTP id 5mr1620892pgg.144.1610022636869;
        Thu, 07 Jan 2021 04:30:36 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:30:36 -0800 (PST)
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
Subject: [PATCH v2 08/19] crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:33 +0530
Message-Id: <20210107122944.16363-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/hifn_795x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7e7a8f01ea6b..47f7bb43477e 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2445,9 +2445,9 @@ static int hifn_register_alg(struct hifn_device *dev)
 	return err;
 }
 
-static void hifn_tasklet_callback(unsigned long data)
+static void hifn_tasklet_callback(struct tasklet_struct *t)
 {
-	struct hifn_device *dev = (struct hifn_device *)data;
+	struct hifn_device *dev = from_tasklet(dev, t, tasklet);
 
 	/*
 	 * This is ok to call this without lock being held,
@@ -2533,7 +2533,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, dev);
 
-	tasklet_init(&dev->tasklet, hifn_tasklet_callback, (unsigned long)dev);
+	tasklet_setup(&dev->tasklet, hifn_tasklet_callback);
 
 	crypto_init_queue(&dev->queue, 1);
 
-- 
2.25.1

