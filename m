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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7838C43333
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D6D264E99
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhBHJsy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhBHJp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:45:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB56C06121C;
        Mon,  8 Feb 2021 01:43:30 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o21so8442526pgn.12;
        Mon, 08 Feb 2021 01:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=QhEV9FMXBvym/ARUTAOQRFT+VSGwsl+HFKUhZjk6UM9PU4Um8MSAEq5+EDwRqucqEY
         KB+KMqB66L+SkZrbcgoBoYwk09huncASO+rSBdiVdLeJ+Kfc4jIyl6ziOkJ8+p9DIKQD
         XaURfC5FDoO/ulyUauhjQJz3XGVZ+yOCxp8c6N5JNiGx2jV1cSH3wAP1XDVfIrBRNhON
         VfufsnT2Zxl6P4kRkJnU84TY8vkRxWlsnVOYffiAarN243ukvf6p9GRD+jXEuiITdmQC
         fwYttSWNPBMPvKn4J4nqTVvhc2GjC/qa2tqWSz0bW0YDaWAzAvmwdPIaGOyqyX+9c1AL
         mZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pt3Ra9o7wlpdpNYx3JDjTYF1o1dX6A0SMQwis6c4Pyw=;
        b=X8/2dQ1e69kUrkqH+Zkf6Uw9AEOjfDx7C62xeCgcVfajsauAu0zSCBvD2fVNoUefDM
         W+3zaaQAfemPfBJhIT2h+tjrJLIMBJo78dBVvosB57NbmctXQBi/T+QHaTn3FrzrOpwv
         i98YZiMWLBzdEFGz3LWP2EM9ZI+6IrvuvPW1ZQE01IdQ2Wbvth1C6wzpDp96UEcrLQjp
         rVLQItcO6JmDu/ikGsGYbHoWx94Wv6TTh815N4WthEujX71Qg6PGSnbZliThzTfCR7pq
         6dyfjW9Hr4hPHtLtkSsMeTTL8LK6b+qruD8uNQ/+5wAiHcAZzjVczfct7fTSRO8GrUkL
         FOEw==
X-Gm-Message-State: AOAM533ex2aY9ygsevKTvYZSpb7En7R6j4ZsoPzDouSCcPYzZO2WrQjN
        RXfDUaBYqcZZoeVXnm9rvYk=
X-Google-Smtp-Source: ABdhPJxFGWbnMXnrhMoIW3WHCggAdOTATl5cBsG/jL9ehDb2rVejdDgpbUztvsK8Q4PVA28zFFyc6g==
X-Received: by 2002:a63:505d:: with SMTP id q29mr16117823pgl.89.1612777410468;
        Mon, 08 Feb 2021 01:43:30 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:43:29 -0800 (PST)
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
Subject: [PATCH v5 03/19] crypto: axis: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:22 +0530
Message-Id: <20210208094238.571015-4-allen.lkml@gmail.com>
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

