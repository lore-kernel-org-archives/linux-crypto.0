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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3919BC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0151422D75
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbhAGM2R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbhAGM2R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:28:17 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E7BC0612F8;
        Thu,  7 Jan 2021 04:27:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w6so3775338pfu.1;
        Thu, 07 Jan 2021 04:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=LaJaOgUfS2mksDAvNuGS50zbrWlySONgVy1PzslszujiHDkOF+lvqfdh5d1kSYzWhu
         rVoVlpXMXQcDthXshz1ubbVcG7MrUqceN2dfemCxKLN3vXZX5EqLEpYkG3ZUlYMbHuMk
         9dTop92UA2q+KPmSduf/kIZea88rjWwp3SrJL6qyLoQKObqH9+e3OBJ1iz4ghvK8ceF9
         4po09vE/Y6xSYMFrm7gnjZfXAM/JWRn3WXuMXfxIQWAKPospD3EJDoejfDNifc+9M7Js
         AlKJ774etDCWZEenSrfCi/HcrxhYb79Uq0GMaaAYiiQeBB0ywMPZ+OPE+hSUjWzT3Fau
         Mi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=Pbk5KOEDFBDieY0ygADd2fT06HqJtGItfaay0W7tFIrF2dzutSGwSfuuDPr2/IEuSx
         8TyZGJJJ3pyiZ+d8mY7SXIXVZw1QylEx8xy4ymyXQ6oXRnjo2mwL/aimyKzzB/3k/YDi
         TpmxNvP0eJ6J9dWA4hsEBbQ0pf58omZrhSyNEFCdqvQotCVR3ZPbIQy+UXvBP1TJ0Vrk
         NKsWHzin3dy5LKffL2YuopxwbFBjTYFV5JuutcnPd7VV0O1qKh2OaoaajNlyzpL/CI54
         oUYmpMoMBTp/p02S0VY0UMQ5zcJp31R8+dwY4sAWtP3gPfjQKxdN8olHID3lapGvOK3P
         rTBA==
X-Gm-Message-State: AOAM5321HJZMWY/cr4x/b8ZYZWLjRIwPU/IeGPlhjhmH7313d9HO47Kl
        YwSDMVTv3UTJzPAk8g2lFVE=
X-Google-Smtp-Source: ABdhPJwkwRG30UkJgDKao5YgmvhJZh+Poyk8jdZdvUk5stX2bNOUPSkdSosxtH//b/GHsNL9xBR4/A==
X-Received: by 2002:a63:9811:: with SMTP id q17mr1651620pgd.238.1610022456221;
        Thu, 07 Jan 2021 04:27:36 -0800 (PST)
Received: from localhost.localdomain ([49.207.207.140])
        by smtp.gmail.com with ESMTPSA id x28sm5860403pff.182.2021.01.07.04.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:27:35 -0800 (PST)
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
Subject: [PATCH v2 03/19] crypto: axis: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:56:30 +0530
Message-Id: <20210107122646.16055-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122646.16055-1-allen.lkml@gmail.com>
References: <20210107122646.16055-1-allen.lkml@gmail.com>
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

