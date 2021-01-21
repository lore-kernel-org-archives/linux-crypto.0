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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F306C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F5E238E2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbhAUEpB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbhAUEoI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:44:08 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A7FC061793;
        Wed, 20 Jan 2021 20:43:28 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id be12so596820plb.4;
        Wed, 20 Jan 2021 20:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=topJBmTZuunqbvTDzVdkBfh9P8KCyWEnAtWWRNR9932PVRZx3eYWs3SxndCP1iHYi8
         WR7bGw+WjM4BMLhKJNR5CtmbFMfX7ZNVRn7NVu34LQsll2C29ne2NjiI67aPjyGNBJgd
         lsNuO8pBwS2moiAgBFO1EtsMwvx2F/9sX4RUIy1gqAAkctztFwAjMsjL5AnYx7MwDNsm
         TdrFx1WT+Ys7g3fgcVaXuUqrVVn22GLSI6Lde/kroqU1rDx70K45VNqKIrBiFot2F177
         w/ZN43BAAdbW7968mn8kZy6TBVfg1oVMQRu62HY5VMUC4Psy/axK/+LQv0dOyMmY1eHT
         ufeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=VLmoUnptFrcPN84xaWWd0FE8n4b/DOc5CJpf1peP6ynj1eOmHfmmTeWSD1zaEMmSfU
         buktDFGPn2T/3/IKzzc0zm+XyAJKg1AfvLFfuXaV6xDy+whOXnvVJ0RGqLEqsHJ8egJR
         taSFF8URmxMo/VxYBAkaA5zrjC1Jh69oIWf1VgL9cO7G0gKqJZ2A5qskQOjK65/bkWfL
         b8rZbS0k5O5HcMGBtDD9xekQnLKlnCTCi5PF7cPQaaii3PuGIFhXb1Z6NDxqg4YvSSAu
         Hs+G7q5ldtUrVKvsXS/P+TDJkjycvskYJHzR+1HxIklrTquv6B8hcPUBEtiBQWWw/r9b
         eMrQ==
X-Gm-Message-State: AOAM5316uXNuVkhcY/5Vk53nyyojOzeVnOML7xyg3/8SvYeHfuZU9ZfB
        bpuDp1RYMk3/jrb/j44QURA=
X-Google-Smtp-Source: ABdhPJy41DiXk+Qf+MzisRUhFu9MMpeTc+QZ9UkJGMoATJGG6zWsX7eb6sh1HezenmZ65yENeI9Ysg==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr9468737pjb.232.1611204207952;
        Wed, 20 Jan 2021 20:43:27 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:43:27 -0800 (PST)
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
Subject: [PATCH v4 10/19] crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:17 +0530
Message-Id: <20210121044126.152274-11-allen.lkml@gmail.com>
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
 drivers/crypto/ixp4xx_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 8b0f17fc09fb..b783ab58d718 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -414,7 +414,7 @@ static void irqhandler(void *_unused)
 	tasklet_schedule(&crypto_done_tasklet);
 }
 
-static void crypto_done_action(unsigned long arg)
+static void crypto_done_action(struct tasklet_struct *unused)
 {
 	int i;
 
@@ -497,7 +497,7 @@ static int init_ixp_crypto(struct device *dev)
 		goto err;
 	}
 	qmgr_set_irq(RECV_QID, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
-	tasklet_init(&crypto_done_tasklet, crypto_done_action, 0);
+	tasklet_setup(&crypto_done_tasklet, crypto_done_action);
 
 	qmgr_enable_irq(RECV_QID);
 	return 0;
-- 
2.25.1

