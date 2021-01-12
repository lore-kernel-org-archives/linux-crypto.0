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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBEAC4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F14422E01
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbhALBtx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbhALBtx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:49:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219CC06179F;
        Mon, 11 Jan 2021 17:49:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s15so514217plr.9;
        Mon, 11 Jan 2021 17:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=r7tiML4ldoBRZewsCdlsIV37ZV7wOsjcdFkiCWIJlW4dJGMEnuIDE00L4+ytt5m+hX
         C/awc06j554FRO8V8FZYFZXYddwTZ3EGIqObWoYWePASAo882MdkP7AdNmTEONiZFoib
         9rmfSsqtBxZZRKuoNt0YbNcdnYE9hoSUaHaU6Je0lQ+5q2XWrJZIBTrmokDu4kf33xgj
         jC0L9Pt5VoFOscfFs2gbhZGAdHSbdFn4/kU3qYPs9NZcK2U7JN6albjOgNUy0fzAJ08V
         55zd1mlgI/34wcWNoR/S7NhMGvNuDGnl9VQcvtv8yTm1FuiRPP4mA4jFaos8rBgVRfjM
         mHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=Mo+elN+sZU2gnkzn8pSUyWQEjjlyRJLqzFdtWprXJQ4RsUBKpQrJsYcbXxVCKrM1vG
         ODZpFvjqAiedC/FD2ZOzQI5wt8pGu7x2QyUEJuUGt+tSg7QQTZQvLA06wpBpeC4wr4l6
         COs8KQxO8gHDbC0Y0ccq67OxSP8dj1Oc0Kj67JyP7FZBiQ1KoaYlIakpiXe/OE8ty3iQ
         w2AzMvxw1uPR/wCcYaT3BW9wjA7uQx1iOr5X4CeSp8JzfcxY9vAkNO2SVNS4hJDxZUFO
         rkPxDO4rj44zD5mQcJhVXsMxuSSM8ITP/Q6jqiT6mg/bj449j6MHeCOy1lAenXK/62gN
         d+ig==
X-Gm-Message-State: AOAM5317qUHKgv1iD9DHmqHnLjFjFe8B0pPOOOebmzA+Q3vfElVvbemM
        vYwrAdMe//IHyK0X5eXqeLA=
X-Google-Smtp-Source: ABdhPJwKgC3RH1nzB1/rKwmkmK9arutqt+9MvkjsAmm3hSY7v3qXi7pI9NIkUqME31+Bp+viPElEwQ==
X-Received: by 2002:a17:90a:734c:: with SMTP id j12mr1747988pjs.201.1610416152388;
        Mon, 11 Jan 2021 17:49:12 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:49:11 -0800 (PST)
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
Subject: [PATCH v3 13/19] crypto: picoxcell: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:44 +0530
Message-Id: <20210112014650.10887-14-allen.lkml@gmail.com>
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
 drivers/crypto/picoxcell_crypto.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 84f9c16d984c..e64fa3e22521 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1137,9 +1137,9 @@ static int spacc_req_submit(struct spacc_req *req)
 		return spacc_ablk_submit(req);
 }
 
-static void spacc_spacc_complete(unsigned long data)
+static void spacc_spacc_complete(struct tasklet_struct *t)
 {
-	struct spacc_engine *engine = (struct spacc_engine *)data;
+	struct spacc_engine *engine = from_tasklet(engine, t, complete);
 	struct spacc_req *req, *tmp;
 	unsigned long flags;
 	LIST_HEAD(completed);
@@ -1649,8 +1649,7 @@ static int spacc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	tasklet_init(&engine->complete, spacc_spacc_complete,
-		     (unsigned long)engine);
+	tasklet_setup(&engine->complete, spacc_spacc_complete);
 
 	ret = devm_add_action(&pdev->dev, spacc_tasklet_kill,
 			      &engine->complete);
-- 
2.25.1

