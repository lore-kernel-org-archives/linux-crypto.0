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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E34C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C79723358
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLGJAe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJAe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:00:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D244AC0613D1
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 00:59:51 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id n7so8353113pgg.2
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 00:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NzBxuchgBhXbhsOEbY1R6PmYAYkMhLDdWvlyeLY2vog=;
        b=DRtOO2F3FiNS2yenHS6AFnLnafKEylS3w29eKfoMABLwkaCMZSa/EV/19jC+/8t7HI
         eAEAOmyP40wMBwruw2IfT6AjI9M0WnXMgx0xXPljlN2YHykmzuHTpoO/IPYPpulxQeFb
         nnGkZWW/GUzB8gln1DYo/FlbpR2NW+3Exc7/TDEf2Hrp8TKHESYySnOkRN84PdoruxJH
         6v/QLhYYqLI3L2I172Pz5F/bRk+3Hs06CtlJ0h9lNipy9cDuPGZ3JRi5Z1wKxkmWoT0W
         GvY+d50L26ypxdIwbWCdjNw58SBwI4E3rXqj7xTxUQFJncV6WTHwieijECtAo6gj12x0
         x/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NzBxuchgBhXbhsOEbY1R6PmYAYkMhLDdWvlyeLY2vog=;
        b=qFsNPWnm1hOETYZRWyTMjDn/XcgaPLeIFTQqSybu0MTDmlioobdkYOoCGX4f2we6KG
         L2yzyS3ST52mduffZK9cWtR3eTUfq6KKSUBJAbyT0cQ4fAM9wxkI49EKCjqwGC9IEvPf
         DDuI25ca6MkDRD00IvH7Q/TY60iUf1C5K9XfhxgANEHolsHtXycgPK3cE8yMclNnyZmp
         rG3851vjbhmyV5QU6LcUpkyDiPc3oDElkr+D+nlW/EDVTdue8jTZDdD9AJ9ZX3aZb5Q0
         CJVsskXZmvPma9jB/XdsF7zLtBcgvD01O6BM54rK9jEdELPTR//KW2wmGxvHKR8sREbc
         /ORA==
X-Gm-Message-State: AOAM530ThtfkXXWEpunpAJCxvpkHJne3K/8zR3RXkIih9Hphf6r8yHai
        gbhW6BQEIQrXV/yU1Z4Hiw8=
X-Google-Smtp-Source: ABdhPJyWg0t8ZZLWemoqd7EqH04HVFTB+b26h2x0RS1jicddGF5M1Tp9w0YMKw1GZa7YztD3neF6zw==
X-Received: by 2002:a17:902:ee52:b029:da:4dee:1a54 with SMTP id 18-20020a170902ee52b02900da4dee1a54mr15113403plo.29.1607331591509;
        Mon, 07 Dec 2020 00:59:51 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.00.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 00:59:50 -0800 (PST)
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
Subject: [RESEND 01/19] crypto: amcc: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:13 +0530
Message-Id: <20201207085931.661267-2-allen.lkml@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 981de43ea5e2..3700446a99d8 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1072,9 +1072,9 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	}
 }
 
-static void crypto4xx_bh_tasklet_cb(unsigned long data)
+static void crypto4xx_bh_tasklet_cb(struct tasklet_struct *t)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = from_tasklet(dev, t, tasklet);
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
@@ -1452,8 +1452,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_build_sdr;
 
 	/* Init tasklet for bottom half processing */
-	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
-		     (unsigned long) dev);
+	tasklet_setup(&core_dev->tasklet, crypto4xx_bh_tasklet_cb);
 
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
-- 
2.25.1

