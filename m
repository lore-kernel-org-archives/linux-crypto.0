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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DF1C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2680A64EA1
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhBHJuk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhBHJrc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:32 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB944C061225;
        Mon,  8 Feb 2021 01:45:23 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b145so9366342pfb.4;
        Mon, 08 Feb 2021 01:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=A3hAC2WJnvj0JnPzIYg6XVR2RbTYemoPhFpYlGmhRML8kEWdc6O34ZSjTz6JSs/CVo
         mreIe41ptn9ay3o326XfjefAqEsYrOaNbaR2NzsPvdJH3a/qhAHw9+E9tjw90t/L3GXk
         UJYpHTznGEd19p88KJKmn2Nq8b9Rqrt+HTbp/QTv5iHOMp6MToUKoxR5zFxjlq1b5iQL
         57EpCMHT/b6gNZhLD24D6NXBGWf1SWxxG/7b0g2d4XFe/79M8L2sJmkj/CbpBJTtRafI
         j2Scl7RFlh2iqk4aPSrd20AK6G/SOw2NCgC/z7CSxGJK50RMYNb45FpsIf/viXb83a8f
         rgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQh2IwNxftbR34HfI9l3nT7vPGQ8lmvW4dX0b9EAc7Y=;
        b=BdYF+e2GNgG9ew8oNOIcCBfGVq4mjYcMfXCcFq1XYGj08kdROsQZ+ecGURahkfaVB5
         Sa5XllctECZcAlnzkbbYW5bbKROIMrHEfhAVCf0MxTTwV9Vk63bI1xihfCHgYbxxVELj
         gbAc1FFVl3p4SLOHG/ayKp4w6+BhrSTG/KW/4LlybuS5O3VznMVJRfR8AyBswMnQq69E
         MBQKvEVWORxpKEPS7cXfK1OG3F0jenYkmZKXlkU6WyfRPaS3GURYATfWmYJhWns4H1mB
         deAzxf/K5Xkt4+du495/6P5Cxo3SQZol2736FyDLdqgOUZvhuENqphvbSuaGWyTPUvv1
         WB8Q==
X-Gm-Message-State: AOAM530LfvkYR/YypHPOmxxsmNb38YE+65DI1/deTQJE+WWUFVpqOAXI
        7XKVa2zvWOXTrvmY3/r1jk8=
X-Google-Smtp-Source: ABdhPJxqi3F7IE1oU5qYBa2zhUL4KqdMrmwE0b9P2NUYPGldVaqxzRGqsRLaDpJn7dsvuKF/4lhOGw==
X-Received: by 2002:aa7:8c12:0:b029:1b6:e47f:7458 with SMTP id c18-20020aa78c120000b02901b6e47f7458mr17015052pfd.67.1612777523449;
        Mon, 08 Feb 2021 01:45:23 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:45:22 -0800 (PST)
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
Subject: [PATCH v5 15/19] crypto: qce: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:34 +0530
Message-Id: <20210208094238.571015-16-allen.lkml@gmail.com>
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
 drivers/crypto/qce/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 80b75085c265..374281e9d6b9 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -116,9 +116,9 @@ static int qce_handle_queue(struct qce_device *qce,
 	return ret;
 }
 
-static void qce_tasklet_req_done(unsigned long data)
+static void qce_tasklet_req_done(struct tasklet_struct *t)
 {
-	struct qce_device *qce = (struct qce_device *)data;
+	struct qce_device *qce = from_tasklet(qce, t, done_tasklet);
 	struct crypto_async_request *req;
 	unsigned long flags;
 
@@ -235,8 +235,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		goto err_clks;
 
 	spin_lock_init(&qce->lock);
-	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
-		     (unsigned long)qce);
+	tasklet_setup(&qce->done_tasklet, qce_tasklet_req_done);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
-- 
2.25.1

