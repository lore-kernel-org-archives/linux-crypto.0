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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F7AC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E6FA22E02
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbhALBuU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbhALBuU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:50:20 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC752C061786;
        Mon, 11 Jan 2021 17:49:39 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so669992pjk.2;
        Mon, 11 Jan 2021 17:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YEPwpL8tIwFQ2pgUdTDSsmDRSKgoB9OQrqIbywK9g6k=;
        b=t/dea+HTFASqa+DkMZsvezWreLQct3An1am5aT7oeS9MCB7pE7WxwdqcAYpKjDnazl
         oozG5KS4nrETiFufl2+NAtyt8fONx5AyH2LnMK+GFXeTsO8GcEPBUOjPXAsPj1oveh8M
         UsxM2lHLkLGuTsSvHX+AXx7wvXVPnMH5fT6/RiO0ozm5VEqwZqvz7Co5GwHvh0x7kAiD
         6RB2x7VuY3tetfpgrZ4L2kdF98h3Vo+i51d8SyDIMXRilqkgaU+xkyCn723kBgE2uxne
         YjtfOmBfd40b1aeiijI/tth2gf0ls+AkjiI/q7c3nyWh72C3BWawI85v6HEc0Rt5p62H
         /Jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEPwpL8tIwFQ2pgUdTDSsmDRSKgoB9OQrqIbywK9g6k=;
        b=A2WyOvax7+Y6YKyLIU4jPyjakqdyjQ5J5KmHV9j1BZb5ynLMzQZ7BkKZYYPVUaWmDm
         QwsxgZkw7vgq4d9TM3BozXTIUs4h1dW0RUxBpMQbJE2IX2strcwupC1Mm3Wr5+X10MUi
         MFDwkg27KgB0hWk2uL4F2YQjRtNH5vrdYuNWYZ7jqwwFFR0G+6DjXJxCSkpaGkpqlnr/
         4VDH4nnaANgkQ6GzegZQqvncx8bwJ1Kh4BEzCL72/+QhyjsBZ4/C/Ly+Ddd//9GhWacH
         hVXMfBDAcDQdVfhqRiRbIctYEzynM0vQXW4Ern2G8VrbRmwVa3l+f+iOKJHTkO1b3jeW
         pOdg==
X-Gm-Message-State: AOAM533+ta0UFbkPHbMRoGYGCgynbUHhnSV1iQOtbEBpbWHtJv15+zs5
        vspXvdLqZswEjY892Y7+CIw=
X-Google-Smtp-Source: ABdhPJxZnxaAWP/2FGAGT++lMvv0ZGP+Z9EPfAeWUgayCc+yEPQmbSAcWNVVlzBYfOxK+hgjl8fMQQ==
X-Received: by 2002:a17:90a:6388:: with SMTP id f8mr1861750pjj.192.1610416179413;
        Mon, 11 Jan 2021 17:49:39 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:49:38 -0800 (PST)
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
Subject: [PATCH v3 16/19] crypto: rockchip: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:47 +0530
Message-Id: <20210112014650.10887-17-allen.lkml@gmail.com>
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

