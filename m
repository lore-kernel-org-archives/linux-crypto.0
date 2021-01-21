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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139E9C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6EE238E2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732501AbhAUEpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732421AbhAUEnu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:43:50 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477FC0613CF;
        Wed, 20 Jan 2021 20:43:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n25so602453pgb.0;
        Wed, 20 Jan 2021 20:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=Bng3BsGk+C8xyT/tdfY1mg36WQRvRfp+hn0N4TAQOl6zzjWnogwce20ioIBmtwVYHu
         0QfGZFBkMasK3JbJORN8sjQD4LAhBc3il+zzdSWfofpRbL44uKINPjAwdlUW3AO8/eqw
         u2aP4wKc56/Q45TYbGi1nogwjvZ+5p/73MFSqillVMqLhqiw4v36M1HarMS2pLhtoqzx
         BsF4+BKRNrDzicRUQIWo9cq/8rSYIl0bUcFgHGI6DxNtwxDRwod/kzRexZUmeOsQae2D
         NZcbzrT66+ixLhF4aT0Edzs2ayKGCVrTODnjtpNNvEG4jJyNFPbiDN5H0I9IqbEb2egX
         Jo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=eL8440UaU05zNwxAfBihtZL6aoJzwFeBLGwjazrKy5hpxYvH3aooBHc5QKIT92qNsO
         sBmyI+GCQt1z8O3UYr0vEJTbJYQrjPz9j5UF8Z8ehXHWvqIxDKJ19hHWfXGz2kErJhPp
         egqVLO3d7U+stV/v1X3/f5XYxsB7Sf3kon1geFLKih5QsOtEBG5cPzEVUYaw+jNgXE/Q
         TtN43tdWFBnIrqgY9aoDvKpJKY8u22MZwquxnibgRa5TDLo4dl0RSwJs29l7VKdvD5p6
         Y+9JJlxGHF8I5dTe4+fNpDzcs03RIldEog6g6bN8DH9WjylDY5xDAX4sGWH/diQRnGNt
         S3Tg==
X-Gm-Message-State: AOAM5325HtGXIeJwiPJcqKnM24oDICUfSVn0ZQsrohtZbCcFb9K9oTda
        nRxCDgorklX26xtliNZz/r8=
X-Google-Smtp-Source: ABdhPJy31Jui6z63cGBX2FIWsvZJsQOR36SUcBgxzABGGw4ToD/zOTXFb8AWe7UJjFlBSFEMvOW8Wg==
X-Received: by 2002:a65:5ac1:: with SMTP id d1mr6123421pgt.447.1611204189442;
        Wed, 20 Jan 2021 20:43:09 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:43:08 -0800 (PST)
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
Subject: [PATCH v4 08/19] crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:15 +0530
Message-Id: <20210121044126.152274-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121044126.152274-1-allen.lkml@gmail.com>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
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

