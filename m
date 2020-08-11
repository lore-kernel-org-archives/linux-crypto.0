Return-Path: <SRS0=IiXH=BV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437E3C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 12:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19FB620756
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Aug 2020 12:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S5RKRAOe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgHKMa7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 08:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbgHKMa4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 08:30:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8D3C06174A;
        Tue, 11 Aug 2020 05:30:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z20so6741658plo.6;
        Tue, 11 Aug 2020 05:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3XX9yDBRTZL+T/pjwN944z7PGV7W0j24B30SMgNKaTY=;
        b=S5RKRAOeAfBV3RSsMwhWdYdu1TEZhqfyIrc1nMqcLIt1/ZOTGJb+4PNYJRFWSmi0iK
         V0qFIiW4Kb0h/jhTZhxt4bG3B17sjub9t+bIEnz2oeWCYnRUeTslctgNfUSsSsXOB6SQ
         TkE5zLvRB1dkCzDeFaEcfzELMWJlzs+jyfpG2YQYk0v+YOztD/Q53urFhIC4pnEPfjjt
         13pgTPu7iKV1WDkHMmfLySuK6+HLZrfRaV1JgOClw0QwM8DEuonuAO79g7ESfLciNJnx
         mO5Q1rG6wd277EuWKp8K4st2srHgJl2nHYqijwsuND06Se/AH6Exedf46Mv/49hZIAtU
         ZVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3XX9yDBRTZL+T/pjwN944z7PGV7W0j24B30SMgNKaTY=;
        b=i3D1EEgWgxWh3zuod41eTgdJqKyLflkfdQ2RU0d7Z/HRfv/2hHwx63971MfcwWe5iD
         AjQMjleNpQDbam30bDH0K7tdHPnwSl+vuJTNSx2sFyVg3pXEdPU7IlAGVC4KRymZvDyS
         T9kIzL3woXivT9uk4FMHZFxvOGFwOvQGQjPp8iLj1FCnjo3OqQ6JljeGzWkKF5rgTf1d
         FQICyIgZWoF+l+cfV7sNEHEpQ7pGclisBixcIp4WDeHYY55Uk9RVMCL4ejiDiyywobXp
         AcMiZdpFCTS1qmNZWeXWMJNatyjkAmafqImDjeik3kOn7kOGkdPib+rpzXQLYwWhLhoS
         neRw==
X-Gm-Message-State: AOAM533wNwI85ruosgkVbz+rfq2qYx3GERGGMv9p6IY/+tMISeRGvFXh
        iC5rajOXP9oMo/G7BC3BZA==
X-Google-Smtp-Source: ABdhPJySeojQ1Efm0gNatgwnk5Z2M6FSxf81DVjF4PnSZNhWgbKScK5Y1QVSTbgg8wtbdafaJbwH9Q==
X-Received: by 2002:a17:902:fe0d:: with SMTP id g13mr651862plj.287.1597149055765;
        Tue, 11 Aug 2020 05:30:55 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:d23:8b8d:155f:b85f:bf0a:1250])
        by smtp.gmail.com with ESMTPSA id b15sm25015117pft.116.2020.08.11.05.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 05:30:54 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     jamie@jamieiles.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrianov@ispras.ru,
        ldv-project@linuxtesting.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] drivers: crypto: picoxcell_crypto: Fix potential race condition bug
Date:   Tue, 11 Aug 2020 18:00:24 +0530
Message-Id: <20200811123024.14501-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

engine->stat_irq_thresh was initialized after device_create_file() in
the probe function, the initialization may race with call to
spacc_stat_irq_thresh_store() which updates engine->stat_irq_thresh,
therefore initialize it before creating the file in probe function.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 drivers/crypto/picoxcell_crypto.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index dac6eb37fff9..fb34bf92861d 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1685,11 +1685,6 @@ static int spacc_probe(struct platform_device *pdev)
 		goto err_clk_put;
 	}
 
-	ret = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
-	if (ret)
-		goto err_clk_disable;
-
-
 	/*
 	 * Use an IRQ threshold of 50% as a default. This seems to be a
 	 * reasonable trade off of latency against throughput but can be
@@ -1697,6 +1692,10 @@ static int spacc_probe(struct platform_device *pdev)
 	 */
 	engine->stat_irq_thresh = (engine->fifo_sz / 2);
 
+	ret = device_create_file(&pdev->dev, &dev_attr_stat_irq_thresh);
+	if (ret)
+		goto err_clk_disable;
+
 	/*
 	 * Configure the interrupts. We only use the STAT_CNT interrupt as we
 	 * only submit a new packet for processing when we complete another in
-- 
2.17.1

