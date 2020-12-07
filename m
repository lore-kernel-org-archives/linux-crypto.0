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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F7AC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80D423341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgLGJAl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJAk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:00:40 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6903C0613D3
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:03 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id s21so9160568pfu.13
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xNg8pNNWaksnY+6lDZvyxPvu8HjE3EZxEQZ5eEG5LTs=;
        b=JUEMDpGBsD+4TbFIlDTozsCnEXlshfWWGUCv9uTlgDPTRox1UvN9XRQ+h8C0g1eT3q
         P9dgi3Vt2bcR4vAQA9CI4NZ4J1F/PKgkHmY4Rod+sb+RwPTqUvpSZNePs4FztXPfIIT9
         Y8TTh/3GQpMj7ttAFHHhqwlP/HO5yHjw8AievCm9STMCbmhpUJIUuKjD2fkk3CK0C7ax
         oQC/4aGTTq4+WL8WPWWAqwR3KxxGIR83BA+bhN/5u4sJsFa+SjiQOSavwWpU4tFopP8G
         GdvyTAErFxFuinB6+b0d+C3EYkENV/Kn2vPHa4O32MmKAdHRyY2Be3jI1S7ttMwNkauj
         ze+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xNg8pNNWaksnY+6lDZvyxPvu8HjE3EZxEQZ5eEG5LTs=;
        b=S36Sp+S6nkiAo7FJCkU7/b8xWFz34uEKWakG9eGzOF7ec2T01hNrNaEPXMPyWVyK6J
         ixFD7QnnMXOZ6TP3j/5sno8LtsMnjwvZFYnVy4OYJBLsUIcbJIeKoq/rlcHAlqkzTo7q
         2Rt9/HU/UqnO1grJpyBmSQvG5Xwa7Y6Bd3S1NgS69K7RVI9+U6rQjyy1IlpDXicZg5Vs
         snoRgumV2KDmpQXv7nI9yt09nthNOlqNjmtqQJjKOByjMeUqlbDl4+n4p+Lei+ChqrtB
         OIXBvwVExmvIOCRm5ziZeyvsVpBYWG0iikdcIxDoJk6h67gnFJpYVf3pjuHyeZNwksei
         NdvQ==
X-Gm-Message-State: AOAM531T+dPpJLz3YBrbmOn37YcDruW+b4qXzKv34eljJi8f1sjPh//p
        Gk0FGZRiEUYZ4/koMVZdbCU=
X-Google-Smtp-Source: ABdhPJwkzh+08sxL7KcKdqnLkBNyw/K0UA+5XzzMxAxxlf/b6v5U1/hmxmxXN/2PxXkohgsxkyCSSQ==
X-Received: by 2002:a62:2ad5:0:b029:19b:38af:83e0 with SMTP id q204-20020a622ad50000b029019b38af83e0mr15270217pfq.54.1607331603516;
        Mon, 07 Dec 2020 01:00:03 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.00.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:02 -0800 (PST)
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
Subject: [RESEND 03/19] crypto: axis: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:15 +0530
Message-Id: <20201207085931.661267-4-allen.lkml@gmail.com>
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
 drivers/crypto/axis/artpec6_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 809c3033ca74..d24658f6c496 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2074,9 +2074,9 @@ static void artpec6_crypto_timeout(struct timer_list *t)
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
@@ -2899,8 +2899,7 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 	artpec6_crypto_init_debugfs();
 #endif
 
-	tasklet_init(&ac->task, artpec6_crypto_task,
-		     (unsigned long)ac);
+	tasklet_setup(&ac->task, artpec6_crypto_task);
 
 	ac->pad_buffer = devm_kzalloc(&pdev->dev, 2 * ARTPEC_CACHE_LINE_MAX,
 				      GFP_KERNEL);
-- 
2.25.1

