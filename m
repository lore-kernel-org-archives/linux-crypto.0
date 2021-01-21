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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C1AC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B5B1238E2
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 04:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbhAUEvv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 23:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbhAUEoy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 23:44:54 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D83C061796;
        Wed, 20 Jan 2021 20:43:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 31so570408plb.10;
        Wed, 20 Jan 2021 20:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=YcZEALK88C6Ie3UfV/NxIVW467onUG7DeIDhOp7jC+bX302hPlWbEVlnebgdCBbwFj
         LOfHF9OGgUlWjLj4wIBvH5lDknvO/fNQBpFbxTx5hQvmZSvg2FI4T7wq1SWUY8IjDElq
         tBHXoMkG1PrFIM2bBualHC6DrvMNzuLL9tHtzO17KvRwOgIGCG+A2n3xsYGLTrmsLLtL
         FHVZQ9zJrNd9rMoLlJb4wRfv3cynMP8nKgEOaTz0LCxKtAv4ZNEvaaowW6LA42qsA6j2
         OvGmfqDHs0jWX+Zrk2Zl+2+I0+uX3UV62B0QiQn2Ff0gKlNEE9LyANJMLdDJvz9Hb2A1
         WuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u19NxDApfMXx+Y8pGP/iF30yq+dZf2FG4hiZfFrFBcE=;
        b=nt7Xx8RVEye0jjxnSl8dEKYVfhKeqBcKELefxzsbAvwVnbKjE70PMdWzmvbd225VcK
         IUMlmih1WnmzeXHNYnliJJTUoNuy23huoenHSpe51se/S1GJtJK2XzQaYcmgLfvMw1DO
         v+4sAgyND8+UR0qweoPQRGkgnpn3dDVRvAo19ndjPsw7pZzG3Qewl+UjgCNFFW2jwYq7
         n9AxibHGS6soXTK5/qrTHrqtUhhWlhNLB6/3ncOwDwTOUqENUbdJ4yC5oLNvJFHMU+y6
         B/7eTKNH7uBKwj2OgrW63fK/W+G/OaCNKzbBA9ZmoQpdu0K0q+EBqnoCdH3k5XEXbo54
         WPLQ==
X-Gm-Message-State: AOAM5316ar7fA2g+UbpDWRfEjtsl6e/QJMjdYf3j9JJtOefcp0nat5U/
        mfhB3p4J9VdSO7IIIDQshm8=
X-Google-Smtp-Source: ABdhPJz55X807cU8264jB4dLtQ3vVAqYFPxZ8roblYo9YlKQHa5BhE7/TMsNFZx5ohRE85FkNMi7zA==
X-Received: by 2002:a17:90a:9ac:: with SMTP id 41mr9635853pjo.46.1611204235611;
        Wed, 20 Jan 2021 20:43:55 -0800 (PST)
Received: from localhost.localdomain ([49.207.210.174])
        by smtp.gmail.com with ESMTPSA id jx15sm3916014pjb.17.2021.01.20.20.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:43:55 -0800 (PST)
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
Subject: [PATCH v4 13/19] crypto: picoxcell: convert tasklets to use new tasklet_setup() API
Date:   Thu, 21 Jan 2021 10:11:20 +0530
Message-Id: <20210121044126.152274-14-allen.lkml@gmail.com>
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

