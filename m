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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA01C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42679238E9
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbhAUExM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbhAUEnD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:43:03 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F452C0613D3;
        Wed, 20 Jan 2021 20:42:22 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x18so586292pln.6;
        Wed, 20 Jan 2021 20:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=kdJKzr3/KOueUuqVKKq3BnshDzwd/M3QDO561oVCTojc/9EIA1jKGn1vXT6EHymB8b
         A8KEKLAEvfazNcpPYdlj/8uYF2qugJdamq+YWmDyIdTPHIZ+6dVV26Lc5t6suwcB9dY0
         RWGkFRKrKA5e/IAnNQIIZRh7MUBUkA/T7SJvNpoWvEO3aHNRhHElD3b5BkB6+yU+zony
         kfnVQihyKH3xYr25Pt7fooWFeyHilx9KSt21RSlEkJ+HW8Ss7JBZhsiNQjlOCT8R+v+m
         1nKJaP/w03tl7TOanwIxWQjrVud2NXEPN0wrikeR5LvZAw0ieDhlDBWByWnipQ/0Vlun
         hiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=OALiEgoR9SNIe7n5N0a4cVftUoYJ2qdi2VU9XULEGfYTQv5EpYwmqnrWaj7lvS1Bzd
         R0/AR4DA5mBCFptlhFkUOeyMjQtzbsn8wnriwX2gA3HDvsJ0aVUxRgxW3J0T9zj0uzmU
         1khNO9XSvYkPQrzpwuqFdbPuMNtDcuwLRvLjnyAagVP5dIjlaLl0xFHe9FLYtp1oEvvt
         K2I0HTm7qhdG12FsbRgrIbuK/rYdYMMKuKT7FVuefdBYz3b9RSkvRIc3c7Fz4/mZHSUu
         UMnWak49fR9YSHY3UWO0SA1X2jqW0JScZYVPfTmC63+Kb2tjVeAW4/Acgw1y4KspEqRk
         Nlfw==
X-Gm-Message-State: AOAM533wmEjEg/VRQXftwpZS06QjTMx42EjqoYchfuiw9KYMg2RCLPNM
        HqUeR+ztPrsYu7F0ETY4AJU=
X-Google-Smtp-Source: ABdhPJzdyVPYF5JUS+hIw72+TAWRW1DhenevRKGUa/SuUS3MpBtGL77FofUqOu7EUYe85JNKgNbU6Q==
X-Received: by 2002:a17:902:d481:b029:df:cfe4:362a with SMTP id c1-20020a170902d481b02900dfcfe4362amr1518763plg.37.1611204142162;
        Wed, 20 Jan 2021 20:42:22 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:42:21 -0800 (PST)
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
Subject: [PATCH v4 03/19] crypto: axis: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:10 +0530
Message-Id: <20210121044126.152274-4-allen.lkml@gmail.com>
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
 drivers/crypto/axis/artpec6_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 9ad188cffd0d..52e0c7fdbfa8 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2075,9 +2075,9 @@ static void artpec6_crypto_timeout(struct timer_list *t)
 	tasklet_schedule(&ac->task);
 }
 
-static void artpec6_crypto_task(unsigned long data)
+static void artpec6_crypto_task(struct tasklet_struct *t)
 {
-	struct artpec6_crypto *ac = (struct artpec6_crypto *)data;
+	struct artpec6_crypto *ac = from_tasklet(ac, t, task);
 	struct artpec6_crypto_req_common *req;
 	struct artpec6_crypto_req_common *n;
 	struct list_head complete_done;
@@ -2900,8 +2900,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	artpec6_crypto_init_debugfs();
 #endif
 
-	tasklet_init(&ac->task, artpec6_crypto_task,
-		     (unsigned long)ac);
+	tasklet_setup(&ac->task, artpec6_crypto_task);
 
 	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
-- 
2.25.1

