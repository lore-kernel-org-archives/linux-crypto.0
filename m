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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4552CC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 196C023358
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbhAGMbg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbhAGMbg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:31:36 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C66C0612F5;
        Thu,  7 Jan 2021 04:30:55 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j1so3414792pld.3;
        Thu, 07 Jan 2021 04:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=hbZxd8GMbWMwunv97wfH2Jf1oJf/8UcNY6xBKZcNSEUqzpSUI65LKuKQrxS91lf3JW
         Bupw/mebNEqeQTlLLVwWk16hsX081CmCeM3mCGPFqAIt6Y15WaGH/KwDFlvfhr1Hgg9Z
         XmJtwwBRs5RusKIVtDfejCw5hq1vLWEe1lHia/3otyEyWTKYI3bUsoZQF2D5pI0ztNQy
         0/6+Z3Om5i4sHkVm60WuZFrh8e9eyF3U8Mo1nCSfMgurTh2MkeWCP5UWfGjtMH2pbNlQ
         Pt9JtbYllg2QWQaoR9nfEhdPC6MM/gw25S4hDUm222XYCSreZw2frFc8N124MrS997zA
         oqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=nJsZgXJl58kihtvuLq5vsuKhOYDQ+cHnVAwhtkjA7/sC4WNGeEJbiC7sZPmbkqDpys
         pmv2V0mH9Yx0VA+A21ysLorPCQajQVkSyPnPjowt3sHy9rsRgXwdyeI2XzWoRXZnag7N
         prmTy2+lb0YTkZZNxgOLUAJ+D/TWFx7raa8lf72dM9FIynOv5oZYJYVZkMJssaRaqkak
         N0CEhmNECXD/pvIEnVGoetMWNlNNYhF0d2rP9hiAA3TIOmfD4U8zOvn73DeRCKLfRQ4n
         96UPuhubt3oO5gh/2NS/Ks/oPmy9K5HH8UIFxriOJmajZ1nACNVIib9QM6Bnbyd3dSdC
         NODg==
X-Gm-Message-State: AOAM53298L2bnAGQlxPdTGqCn2rMnapMqyLcykw4j2epBvhW+59VautZ
        JtEHjK2WZZ6yBL9ftjHGgFRNwOw8AoY=
X-Google-Smtp-Source: ABdhPJxNswk3UqAPRQFOECWMZZXKETLsDLgMohWjq2tJwnnMR19IXzXOUsAVBJnz8yZ5/DQIIMxoDA==
X-Received: by 2002:a17:90a:b90c:: with SMTP id p12mr8705424pjr.135.1610022654721;
        Thu, 07 Jan 2021 04:30:54 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.201])
        by smtp.gmail.com with ESMTPSA id h12sm6356014pgk.70.2021.01.07.04.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:30:54 -0800 (PST)
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
Subject: [PATCH v2 10/19] crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:59:35 +0530
Message-Id: <20210107122944.16363-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122944.16363-1-allen.lkml@gmail.com>
References: <20210107122944.16363-1-allen.lkml@gmail.com>
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

