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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AAAC433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26022238E5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAUEoC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbhAUEmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:42:44 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E229FC0613CF;
        Wed, 20 Jan 2021 20:42:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id i7so569462pgc.8;
        Wed, 20 Jan 2021 20:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=f1FiW3GfAm0rwczLRVaetfeMzJ8o510yCF13Hy1+MSxlrS2n8x/H6cuh9f5KjEXxq8
         WvhixgV9T17sKJN7ifrgTlconwMjrMe1IcroSM8gW3Et2o4PflsY3eEfJ1TDjEje7KDR
         g4hb3FCppsyzQeoVwZkZLMqFyw9q8C/1Hna6V3BARgmL6EsfTG0EMS2hKNQz8rY906ry
         /jiZbmD4r50/fN4P1mjdSQPenDGpylA5/Xwrb3uBJbK9Y4jeqQBKdzdlWGqWlAoEoY/W
         0m3p+YeZSZRe9RqHBF+bqm6EmtPmhmG8X6NSbssQ0caTqE4EZ7rnqzBKyG9uAwqACc9z
         59WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=pmR5QcUaBfVyDmKbXuEuba+kGODisKR8o/AoyGo7Isq3okGur/qqMwwZ5LRH6f+Hls
         P5/ilEfY9lGqSLqeq5Eb85xpemEdmLuC7IVx7a2JtkILKiUv9CiW6F7tAq1UImOLvd0j
         Bm5zU3vwZEMHPB0xp2iECcD2LccgI5Fv6xU1QkI9fOoNViS5iGRFD44wRU/3GmLPILqJ
         n5GSch0xS3aPmdGr+uDsLfALAJQ1ONFWPadu+yoaXJcGpYYJBLYHMfHLoC0hivmAogzG
         SDHEQjAErYRLP4iPaGHAUOZvdlq9cej4zOSmc4RWNBHGENZvbCy4GBwS0HoUm0RZGDIW
         4noA==
X-Gm-Message-State: AOAM530kja67ktaEhwhFXKprvkTIXvYUWmSpyTmj81ydDK2O8vMBSAV9
        VgEvFsA0WBIvD/eFAH7KX2w=
X-Google-Smtp-Source: ABdhPJyLMm7H/FaTax/nz30O7Prof4o8UmbaC75S/EmM87QIur+1h8r9VSHwMKgnivf3lp2EFzv72g==
X-Received: by 2002:a62:2bd4:0:b029:1ae:4d9f:60da with SMTP id r203-20020a622bd40000b02901ae4d9f60damr12562238pfr.20.1611204123500;
        Wed, 20 Jan 2021 20:42:03 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:42:02 -0800 (PST)
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
Subject: [PATCH v4 01/19] crypto: amcc: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:08 +0530
Message-Id: <20210121044126.152274-2-allen.lkml@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8d1b918a0533..0e13430a5b9b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1072,9 +1072,9 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	}
 }
 
-static void crypto4xx_bh_tasklet_cb(unsigned long data)
+static void crypto4xx_bh_tasklet_cb(struct tasklet_struct *t)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = from_tasklet(dev, t, tasklet);
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
@@ -1452,8 +1452,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_build_sdr;
 
 	/* Init tasklet for bottom half processing */
-	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
-		     (unsigned long) dev);
+	tasklet_setup(&core_dev->tasklet, crypto4xx_bh_tasklet_cb);
 
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
-- 
2.25.1

