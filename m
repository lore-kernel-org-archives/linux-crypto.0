Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A2CC433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 21:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E8EB23C44
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Dec 2020 21:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgLIVvF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Dec 2020 16:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388359AbgLIVvE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Dec 2020 16:51:04 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5B1C0613D6
        for <linux-crypto@vger.kernel.org>; Wed,  9 Dec 2020 13:50:24 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id s6so1410637qvn.6
        for <linux-crypto@vger.kernel.org>; Wed, 09 Dec 2020 13:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2j4efCb99IGeE7Lao722KUA6F+C0bnE0hR4URrzbDuM=;
        b=ay6s22JodcrhrTuTSb/f+PnrYs/b33tEtEJOnHTTcIj5AoWfAxIwLJP2U9FrQrsZJ0
         5KEEhKoxmJZCF50ZgyS823mzHQcs5z5YcYpimRoUAC0qPHNAQp4n5pwWKNs7B9DFYCFe
         Kab7+QsWkOrPJ02yq+NQqXqtju1eaw24bMYVp4x+9y7kIirOI6OXYE48h3Wso47iuOu2
         gixTp9s49C2hyPpeVfNctY9i0+e+VvJopBpZut6lemznIZx11eAXNCh3MHiikhkKBwmS
         euaTXblMjMF9RsZBlDpwVEPM3r7uELPHbQ38NE/eJU4JinW8Qn7svGYvWJ6awXkwSf/o
         9rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2j4efCb99IGeE7Lao722KUA6F+C0bnE0hR4URrzbDuM=;
        b=VxmiD+D5nzWikaz1fHIq8Xb4dY1dclMcFC7Je+NkTsbEqlss577/UaeuuRO5Iwk939
         JIs9kHOfENEPPaIaz99ZJitwWIaY8FArc/BqHmka+/73V8LQvJ/tP+35ov/iEPWUcOUJ
         LuJfPeDSdAEmlNJZ9URg0fwzePSzeiP4pgzhxAjR0ToD30BM56yauz4Q4m8Ta8Em7YFr
         RoyUhkiHqYrRXTk7YlAIevhQ8Sjv+KrHWaxCdCLIYnl4Ka1jynBx9A1LPRkcLV2EnfyH
         6BtSbCC44K4pkCJ2KxGAPwg3I4E2tB5qKT2mALNt1Lp/xSaZ9TLO64/oR2thoLHe7HKA
         9V+w==
X-Gm-Message-State: AOAM5309Gr/za77xFuDdoR5n4v2x+BOEh1LhnHdNSXZ7xgp+jEpili/2
        LSDViSxxrWwXLCXK8HCgJ74=
X-Google-Smtp-Source: ABdhPJzXS8IA1Co7S89BjuxruCkpKZ6p7Jwj6s2KNpzf559Lp+9+qgP46x5f8dzkUMRmlkA7Z5dWCw==
X-Received: by 2002:a05:6214:98d:: with SMTP id dt13mr1818754qvb.37.1607550623825;
        Wed, 09 Dec 2020 13:50:23 -0800 (PST)
Received: from localhost.localdomain ([177.194.79.136])
        by smtp.gmail.com with ESMTPSA id q194sm2184906qka.102.2020.12.09.13.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 13:50:23 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: sahara - Remove unused .id_table support
Date:   Wed,  9 Dec 2020 18:50:14 -0300
Message-Id: <20201209215014.15467-1-festevam@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since 5.10-rc1 i.MX is a devicetree-only platform and the existing
.id_table support in this driver was only useful for old non-devicetree
platforms.

Remove the unused .id_table support.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/sahara.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 8b5be29cb4dc..457084b344c1 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1350,12 +1350,6 @@ static void sahara_unregister_algs(struct sahara_dev *dev)
 			crypto_unregister_ahash(&sha_v4_algs[i]);
 }
 
-static const struct platform_device_id sahara_platform_ids[] = {
-	{ .name = "sahara-imx27" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(platform, sahara_platform_ids);
-
 static const struct of_device_id sahara_dt_ids[] = {
 	{ .compatible = "fsl,imx53-sahara" },
 	{ .compatible = "fsl,imx27-sahara" },
@@ -1540,7 +1534,6 @@ static struct platform_driver sahara_driver = {
 		.name	= SAHARA_NAME,
 		.of_match_table = sahara_dt_ids,
 	},
-	.id_table = sahara_platform_ids,
 };
 
 module_platform_driver(sahara_driver);
-- 
2.17.1

