Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A71C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECDD723341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLGJCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgLGJCI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:02:08 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68174C0613D2
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:31 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id lb18so4439178pjb.5
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a0a+s8DfWmh39WSyDsFfhzIHFFGVsGTi08AQmbosj58=;
        b=q9ZQM37CmElJTky2NfOIFrcEZ3EPLdQ4nKPRicVUOVSUchKoqecobL7H8p56cAM66/
         JLdS/WCuH9mjY14lkLdeYOlLDZidyW09jgf2BlwKmQh8IjbAKS56QLFrXavHqf/ZvNmi
         Ag5uAb0a31GiEWBTTIiNdBhYQuPSLTY+Ch5WI+nMaohXAbzkJWy6m7SubwGsXLwfhR13
         CuFwhRczqCKTiYqwQDHj/wQM3+/600bW9KaW4+GUt6mVlOWHdWM4cNw7wmHp/eti3uDN
         4ehVxMYCd1f46y+e+cLNwztO+uGjR6dSAoABLaqBPXXUCrDxPVuamy9vYGhU5qjQkRA5
         nuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a0a+s8DfWmh39WSyDsFfhzIHFFGVsGTi08AQmbosj58=;
        b=GqTFqZ2yu+eQD3i7F5fKnEsKI3DNXdbHjnibDfjBdM4qQE8ytQ5iaqK4aqOOPU8piC
         21hTL1wer2jCFzxxvy60PQ8fqP1CfWvpxrJIjCa5ssHxVlNV5q3PA9af/ApRJUoFZVUa
         5394IY0RJ90tOq0KJQzwj3UnRSPeXa14ZCDwQE0myjO4bRsq0FSNHFY/Ue/3ZLpBrBby
         TuxTvsPfT3/WpiNRiWHFt5EiLRpw7s05Eeuv6gZDkdQ5dXA5HZw4op1sDBycmFfdFfPd
         ugSetyN+Jxh1s5Jdov4atrf7PBz8vDbGkwJjsBORW22UGynsfr/WqI103ChKUsghZWub
         UbVg==
X-Gm-Message-State: AOAM531z6iETMYMnAjJfBoAY50rXDsnCcIv3Hi9bk/eRMEcImdvCV2pL
        N04Rc6DM+tHUaCK7TcY5gt4=
X-Google-Smtp-Source: ABdhPJwGZer2FXc/4pJqfukARQ2Cq4qQYfAeJ5j7F8qsNFCGUryti8kBuKVXacQX5hlQcc1iaFErLA==
X-Received: by 2002:a17:90a:e005:: with SMTP id u5mr15445795pjy.64.1607331691057;
        Mon, 07 Dec 2020 01:01:31 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:30 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 16/19] crypto: rockchip: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:28 +0530
Message-Id: <20201207085931.661267-17-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 35d73061d156..af6ad9f49009 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -201,9 +201,9 @@ static int rk_crypto_enqueue(struct rk_crypto_info *dev,
 	return ret;
 }
 
-static void rk_crypto_queue_task_cb(unsigned long data)
+static void rk_crypto_queue_task_cb(struct tasklet_struct *T)
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

