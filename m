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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18607C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F070422E02
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbhALBtZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbhALBtZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:25 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440C8C061575;
        Mon, 11 Jan 2021 17:48:45 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id b3so81597pft.3;
        Mon, 11 Jan 2021 17:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=PNTUCk6geY5InMoWegd4R/7ONBmdHbmTHWHsRBWkvZ3kJmCcHaJmJ5QQkV/yeBWyez
         WPGP2fHvqagetLt99OfbaVvv7Y79YL8mW2shYT7OQzNWTFGUu0mzMYKK/j9vPkPK1nG8
         bY22R8x9E2Nw91rpxpQmIQ/uLbrsO9rvPP4cxl+Jghr6At5EXNPywimw+UJYhyOR7ViH
         t8SdsYEpKbgUC7ZL09cjpNxJeYQXxfjfDppZ+jWdZGZAwqanuz1bCiA/msIYOrCbvEy6
         4PkDV3HDHmuB7J+PxTcreaYcavADyXQEo7Fhf03R/hRO/z3I9AGEnnCN2ye6+qQUweMd
         YmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=dmrACQ4Pk1UMaSPw5eHn1QzVzXM7jIispON8Of0jXMJhWp44RoB94lb+sOZTERzHnK
         n2zmCVyInkR43MSN8bMWZM5afQVrSrt0sZeJ7IuT6d3smqpEqxD8FwjQKv7yFOYtJRm7
         ih6cnzYMDfvuVkpGQho3lDByDuczkzFjdgkptYNq8CA4SH9aNL03zIQL3PiBkaDfrN8B
         wd5BeO8yX0NJNgHE9ysQeiX1KuzhOp4V2tVdS0qVNd+ZQ7IkHzKLxBMBNPQxTbHPAl60
         nQiEO0MZRDPWvL3KIOh5ckMGxX3PYg0EciC73irb1WIvg85iX31oOV8TydlYDoLf2x59
         cGAQ==
X-Gm-Message-State: AOAM532NX8FEvpSQKIv4WO++ZvZ3DRKO0/noMIOezlTmIADB8F5zvo9v
        DZ4o+kvFi2kORjVwabvx1kw=
X-Google-Smtp-Source: ABdhPJzT18hj26phenaIO8NQZKd+sXCJ37xFRYlpef8kLeq1OsoWxGXLH5LS5CCM+il2Kc/v6f9kjA==
X-Received: by 2002:aa7:8c13:0:b029:1a1:e39e:dc29 with SMTP id c19-20020aa78c130000b02901a1e39edc29mr2438520pfd.64.1610416124911;
        Mon, 11 Jan 2021 17:48:44 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:48:44 -0800 (PST)
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
Subject: [PATCH v3 10/19] crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:41 +0530
Message-Id: <20210112014650.10887-11-allen.lkml@gmail.com>
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

