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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A5BC433E9
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D553722E03
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbhALBto (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbhALBtn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF8EC061794;
        Mon, 11 Jan 2021 17:49:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c12so402011pfo.10;
        Mon, 11 Jan 2021 17:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2LJpncxdzSbb/JP/0XuErEHxZj6Pmh4iBBisr0kOG4=;
        b=HmuAnrp1Otc9OjAqpif+aX+kkYFKS0Ir7QviklhzZ29YoEms4u10Ovm2XiE7pDImye
         /CYXpA3TYKw0n/zMCKi0n4aOdVE4tQmV/vQ0N9+Bd7TEA2Hk0uWFNMi82FoK7Hk+dvPb
         T+tQHYuEgVZdqj2dHocHnJitlKRxmizltWQWC99wQAV2a+DrmiGnWlrxlh+Iu1dSYncG
         EPxXmSoP0bbTqAOobAyT8KJHeAkIiRO1/doH9hlkMJVuPoTrzVUc6hxhAJUC2YYGEj8X
         +94OyAYBDk83//wonv/pxzBXkvrlIrt3/Y749csA1GdhgOqN4LVVD3phP4D4OL1cp7js
         2YwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2LJpncxdzSbb/JP/0XuErEHxZj6Pmh4iBBisr0kOG4=;
        b=iEkGlYfK5SVspAXcc59SPARCtGytEvlMMFWqw4FOsHDu3JxbLT85ORafsNqNBIRVzL
         7VgFx6LVJIfUk/rTmPDqbXfYtwxpVAEToE3GQhaqkicKfguokI4To7P1iqZdZoye2OPV
         QVYeslXrIMrugFGfRT2Ks81Rep3YC1tLD+vlNJJSUzyAeEJnuBdWicBFF7SA6HvuEwUj
         6pICE9r+sx0ohWjXMwhdm+F6KxXW5SS6GK/7Z/+oAqSDjwpSlLPxFeqUDP9UAUc4iCYz
         APNF7+psgRZ0USrKA8/DtxfkcnTc6saIlN3BSOeXAnKO7+Rl2o07xfxisdysiBJqX2iR
         7wfQ==
X-Gm-Message-State: AOAM531YCfmQhmnDHx7y4zqzFLgacnqkp2ufHnXMrxG6zkJA+swIT4pe
        xP7vNBJH9m040hTudPcRD40=
X-Google-Smtp-Source: ABdhPJwAVkTGU7VdKnWpjWrkka7l9NUTpAilXCO9WBxYiB3USQqO2rUoRU2hsywCWx8+oJRHIvI+tg==
X-Received: by 2002:a63:ec4d:: with SMTP id r13mr2276375pgj.53.1610416143044;
        Mon, 11 Jan 2021 17:49:03 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:49:02 -0800 (PST)
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
Subject: [PATCH v3 12/19] crypto: omap: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:43 +0530
Message-Id: <20210112014650.10887-13-allen.lkml@gmail.com>
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
 drivers/crypto/omap-aes.c  | 6 +++---
 drivers/crypto/omap-des.c  | 6 +++---
 drivers/crypto/omap-sham.c | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index a45bdcf3026d..7e4223716620 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -503,9 +503,9 @@ static void omap_aes_copy_ivout(struct omap_aes_dev *dd, u8 *ivbuf)
 		((u32 *)ivbuf)[i] = omap_aes_read(dd, AES_REG_IV(dd, i));
 }
 
-static void omap_aes_done_task(unsigned long data)
+static void omap_aes_done_task(struct tasklet_struct *t)
 {
-	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+	struct omap_aes_dev *dd = from_tasklet(dd, t, done_task);
 
 	pr_debug("enter done_task\n");
 
@@ -1151,7 +1151,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_aes_done_task);
 
 	err = omap_aes_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index c9d38bcfd1c7..fddcfc3ba57b 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -594,9 +594,9 @@ static int omap_des_crypt_req(struct crypto_engine *engine,
 	return omap_des_crypt_dma_start(dd);
 }
 
-static void omap_des_done_task(unsigned long data)
+static void omap_des_done_task(struct tasklet_struct *t)
 {
-	struct omap_des_dev *dd = (struct omap_des_dev *)data;
+	struct omap_des_dev *dd = from_tasklet(dd, t, done_task);
 	int i;
 
 	pr_debug("enter done_task\n");
@@ -1011,7 +1011,7 @@ static int omap_des_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_des_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_des_done_task);
 
 	err = omap_des_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ae0d320d3c60..5dc7e23879a5 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1725,9 +1725,9 @@ static struct ahash_alg algs_sha384_sha512[] = {
 },
 };
 
-static void omap_sham_done_task(unsigned long data)
+static void omap_sham_done_task(struct tasklet_struct *t)
 {
-	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
+	struct omap_sham_dev *dd = from_tasklet(dd, t, done_task);
 	int err = 0;
 
 	dev_dbg(dd->dev, "%s: flags=%lx\n", __func__, dd->flags);
@@ -2084,7 +2084,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dd);
 
 	INIT_LIST_HEAD(&dd->list);
-	tasklet_init(&dd->done_task, omap_sham_done_task, (unsigned long)dd);
+	tasklet_setup(&dd->done_task, omap_sham_done_task);
 	crypto_init_queue(&dd->queue, OMAP_SHAM_QUEUE_LENGTH);
 
 	err = (dev->of_node) ? omap_sham_get_res_of(dd, dev, &res) :
-- 
2.25.1

