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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AA2C433E9
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C056422D6D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbhALBtG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732842AbhALBtF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:05 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EC0C061795;
        Mon, 11 Jan 2021 17:48:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n7so384697pgg.2;
        Mon, 11 Jan 2021 17:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=LEsRPUl3W7RrtlJCn/EYjcnFyXEEW56pYJRXcpibCLSs/FaVvKj+8jPsRbc8tCIufo
         u8JA5ti3/Ux5BF/nk87cbT3BFHaecGq9B5NV4obXhLeJihkhLhUqkXt+IFUo7Qu7O9CW
         BESrWTa2CrZgjderdqKn/y8VvF6He0j5l3t18fI3UPu6UBXKvDF1QCeSaw/3KrnpE8lV
         ELcX9dWNWAFhDewSF2lcwqTpB3daA4riRJjo8Kv73E1fYjTlSEDT32L8J44wYFM7wHxD
         gh4UICQ1hMRxgsiQtWev7pUTbRTnmj6Mq4wyAMw9VnnlU9ddDajMPiX6HPpdqygRC7sq
         AEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=OTL4gvbita/LQm0iKv21EJ3mtE8SNoL1t5BPstTXtVeomliTWTT3Psnzc8QieNu7zM
         yu3LqS0JSjMXQph7+u5NHaphvvuY8X21jBipWvUH9oMUFEF2tUlg3tLnYxfh45Pfyr2F
         vPjOrOQnuu3qrHW4ae1KSQuxtmz7s+R0uRkUXylPs/kE5WE3JyY1BS71ccvOKJGeBwva
         eNVu3YaJcelPcp5+QBAN83goSayrydaJlVMcIXDnqvdF2TgIuwM7s4hKYPs/qlnXxlnx
         tglWznf2FlDudvWFkoD9HkxxxbAYkh7qeHVOdTG8sI3PKeY/+O2wJN2Si/KWTgbsMPzo
         +sWA==
X-Gm-Message-State: AOAM532q1LOwdUA1wpVwBn+H/cBl2GLVVtE4U+CKHbRezEdukTYNJAwe
        40X9oEUM6xrGDTr0qXv1B78=
X-Google-Smtp-Source: ABdhPJzPX2YB9rom/mxYQLm3CNTkXAMDDEj/gkt391FUgLSnHxbf0yLblaNKx6qTICB2kx04ErzFMg==
X-Received: by 2002:a62:17c3:0:b029:19d:ce3b:d582 with SMTP id 186-20020a6217c30000b029019dce3bd582mr2207512pfx.18.1610416105136;
        Mon, 11 Jan 2021 17:48:25 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:48:24 -0800 (PST)
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
Subject: [PATCH v3 08/19] crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:39 +0530
Message-Id: <20210112014650.10887-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112014650.10887-1-allen.lkml@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
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

