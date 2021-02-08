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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAE1C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C454464E9D
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhBHJuQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhBHJrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:32 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC22C0611C0;
        Mon,  8 Feb 2021 01:45:32 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e12so7525830pls.4;
        Mon, 08 Feb 2021 01:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YEPwpL8tIwFQ2pgUdTDSsmDRSKgoB9OQrqIbywK9g6k=;
        b=YJvUNAJ5yWFhEd1FkVQ6qf8rEdQqScIkeeQBVSNUj5gip2ZMX3Nmh8TkHYZvVL2eD8
         gM907Th6gGlpZMg1RHLSQk4Scfgu30CDgZZ0yrLoHlgO4bLoRzBovvZdQ+7igAtbXnJZ
         87Wnr1TTAKaxdSTeZ29gOyMEvNdOBa6nUKVajbeU+8A3cMrjugRHUWev5DQX1n9PHP5+
         F7be1ctOV3F05l8Idlmv5rFtb3SyhyqhqtCELmSVOwyaWpGLM4idq3vX4gcQznfil2FP
         zKeXVV9oGhAD3Rd4jK302fvRGzBacP5ZR8JNrX/0xrxZfP6Hte/ldS5nwYo3urGe2r7r
         hcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEPwpL8tIwFQ2pgUdTDSsmDRSKgoB9OQrqIbywK9g6k=;
        b=DRNdLCRfGuE+8LODFz6QLlAZytInlj4jLIKqYEWZt/UIC5oS+XSCWdIqm3k4CJuXZW
         HjLoUJl/hMs8YyV7VaenEKDbs2BCWEcBFf6GNZLf4csLnZCKQjhUWJAixDn7TfZfXBY/
         +MOASNdkpwS84qiiNRtI4VPym6qktJ87p7QRrxFoOdvzjKUItPXWh/qQt0510jP9bg42
         vf5PHFVUfO6Dd7PILQYJsuHZHVLX721sr0hh8YV2h6kElzV6cwIxD9cxJUmRdohk0Ufr
         VJki3B4jSBRHiEycw11UT+t4j6Vxqm9bVWBoSCYdzvu+NJhy7tc7SZiStVmlPdzlJLZN
         IS8Q==
X-Gm-Message-State: AOAM533VLCp6a3OoteW/7zZ8k2U3p8B/3I1iO+UG3IMrAy0TD8o/5Uo5
        HUzVDy1WI5AGPRAO1q7jEVQ=
X-Google-Smtp-Source: ABdhPJz7y1k4HMKwSV/qwtnFW2t8QcmgRok8+6x1gYzOq1twN+xAwp84b0pcXY3xoQs9EvkDcT8ZDw==
X-Received: by 2002:a17:902:fe09:b029:e1:6964:98dc with SMTP id g9-20020a170902fe09b02900e1696498dcmr16012094plj.24.1612777532604;
        Mon, 08 Feb 2021 01:45:32 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:45:32 -0800 (PST)
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
Subject: [PATCH v5 16/19] crypto: rockchip: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:35 +0530
Message-Id: <20210208094238.571015-17-allen.lkml@gmail.com>
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
 drivers/crypto/rockchip/rk3288_crypto.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 35d73061d156..85f314c79734 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -201,9 +201,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
 	return ret;
 }
 
-static void rk_crypto_queue_task_cb(unsigned long data)
+static void rk_crypto_queue_task_cb(struct tasklet_struct *t)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, queue_task);
 	struct crypto_async_request *async_req, *backlog;
 	unsigned long flags;
 	int err = 0;
@@ -231,9 +231,9 @@ static void rk_crypto_queue_task_cb(unsigned long data)
 		dev->complete(dev->async_req, err);
 }
 
-static void rk_crypto_done_task_cb(unsigned long data)
+static void rk_crypto_done_task_cb(struct tasklet_struct *t)
 {
-	struct rk_crypto_info *dev = (struct rk_crypto_info *)data;
+	struct rk_crypto_info *dev = from_tasklet(dev, t, done_task);
 
 	if (dev->err) {
 		dev->complete(dev->async_req, dev->err);
@@ -389,10 +389,8 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	crypto_info->dev = &pdev->dev;
 	platform_set_drvdata(pdev, crypto_info);
 
-	tasklet_init(&crypto_info->queue_task,
-		     rk_crypto_queue_task_cb, (unsigned long)crypto_info);
-	tasklet_init(&crypto_info->done_task,
-		     rk_crypto_done_task_cb, (unsigned long)crypto_info);
+	tasklet_setup(&crypto_info->queue_task, rk_crypto_queue_task_cb);
+	tasklet_setup(&crypto_info->done_task, rk_crypto_done_task_cb);
 	crypto_init_queue(&crypto_info->queue, 50);
 
 	crypto_info->enable_clk = rk_crypto_enable_clk;
-- 
2.25.1

