Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA538C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F8364E9C
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhBHJtY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhBHJrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:07 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8498C06121F;
        Mon,  8 Feb 2021 01:44:17 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t11so6161775pgu.8;
        Mon, 08 Feb 2021 01:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=jwHt9cB/hvAN5MrrCMC6fwqHPDhreR+WCLYhSewq9xsRxuWLQdqyULHg6vKpD3Vchl
         D5a7wrmqyzXu1WzpgPr5kf2HpiXw+sRh1834qtJTvdD0aJUFMiB3LYfDU6WTEe0jZlv5
         hkg98ppXMxwpU3+mOXsiYl/Va7T8XJ4k0qD6kkRoDwQKGTw81pOekPUXL/FXYJpCra2q
         W+wBtdbtbcGZTJ30GrAq4gbRmISOIibABFn6dpVmSMpkTn8PUzVc49xIk0gXT158Edm7
         HNIjNUB88Rj/1Vfv2EkzSsX1TomqMeX1pMWw5y0tHEeRL4uk7M1RMzyMdDEr+47DEbLt
         hupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcYiMBsXjgXqsCUOACpj4n3qnT1OSjGqlWhB/zIbApI=;
        b=IWTQVmczURpjeHiD67VTs8yYjZV6DvwC2srWVweu8HJqONICchkTcmUqwf4DsjDJYc
         4RRbQi6Oh3b+6U/HGa+nNfj+h5iC7tSbPn4JuV6ReeDgLIa7JEXGeVEMYYO10sypk4l2
         VRL+aeDALIp6nEX7ZoSvIEARjfZ4LRvI686Am+WXTREO/WZ/AZJRQsvqtDW3hgVAStwD
         ZCHD+V5BitAyJ4ytYCMwAz72QPvfoFHox8PM1rz9FnBBDYHFI3DRNgd1VYZMkHZqpTWv
         k9+7jyiBhMcwM0gNFBAmyyYhFFeEXH8L08mBWnJ1y1+ekBpSprzww3ZwIWUCetLsqt+o
         xhZw==
X-Gm-Message-State: AOAM530ONBC56wITO9SFAskWugD/Wmkm/YrQchhW8V3+vkxrJD1FOIR2
        9h/x6ACrQNKs1P+HhdZ4a2g=
X-Google-Smtp-Source: ABdhPJxWIwHgr97+9Rx/z21GfgcB8MUOXefY1oiTlDyrjJ+4tQlyWpRXgMoWOM78yFdDOnVyZkv1tg==
X-Received: by 2002:a63:f60e:: with SMTP id m14mr16244534pgh.413.1612777457335;
        Mon, 08 Feb 2021 01:44:17 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:44:16 -0800 (PST)
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
Subject: [PATCH v5 08/19] crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:27 +0530
Message-Id: <20210208094238.571015-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
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

