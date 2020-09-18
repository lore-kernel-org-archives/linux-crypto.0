Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3FBC43465
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76CB921734
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="nEd5IltD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIRHXo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgIRHXd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C58BC06174A
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id s13so4281085wmh.4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CfYFcq4WmzTE0aAQvo/9AeYUJUnGPZBDIaHQZNs9Mgk=;
        b=nEd5IltDBdUSHbm07wMr7LvoJGzjdNmXylW+OHgUIxnQ89Yqvb7J3fUDo8tBikl/r0
         23IJ1OgJ0kvIarbQMSfid+KKo4UuQseo/LCOs9P4lNZ+P4cha45+xeM2pWWt8j91n9x6
         t14vvUGDBeRL91O9AIG01H3icP1SbbivM++LGSa6hU7Uua/SeDglM0aM9ZZzxd90p8RT
         fCitut9jKFlbOqUY64hHcc90Fpz8IZvxgnnuq5T/Z7H74ruoCIqPegIntGwZ0to5U/Kn
         tBs7ez5hQRRkbCPH4bQCEKcqHbYlxFA7SyYReSH72tHs4cv26hwyt/ipXBbFUCyUxD89
         7UoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CfYFcq4WmzTE0aAQvo/9AeYUJUnGPZBDIaHQZNs9Mgk=;
        b=sotrvJ8cyvJbzqdEARnozOiomHxANuPG2Al7NotBwg2pyrjZhYWsR4fWfo8/I99bMS
         XDQ7iYFUUpJvsd3ThW9vceWgCyKhnaLGh6EC9SREx3nAzplebKS0XclYTaD9xH6/VQ6L
         SfzBXwYXDecQZaSWZmti+hIbeRlEJR0JsAqkAJZePOvw4nWj//IAjjlR9fGfuGZBQdD9
         ej+9+JISCwB+afZptfsRpCQeYjgIM1Eeyc+UOhmMdvtx5iqdgXO0v4iAVIHiNOo1zCyl
         FkadniSykW4O1jL5P+URMbliwwiBG56eXLzA/vbPY9vHtq1+SWo/pJ+kxQZpw+Ij9Hbm
         v0nA==
X-Gm-Message-State: AOAM5301WxNgWxvFDTEqEm8W7bIODFD675SfgBe4huVuM9eeCk4XjM64
        ysKFX8Cn2su8peV8HOthYZ7Oyw==
X-Google-Smtp-Source: ABdhPJz6m5FuRYaqZ13wDfBXsixZ1yXZMXt1WLC+PsXPd5EBEIvaGVKKm6T8wmYp97Y2FF9w1eyk0g==
X-Received: by 2002:a1c:a5c8:: with SMTP id o191mr14424889wme.127.1600413812092;
        Fri, 18 Sep 2020 00:23:32 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:31 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 06/17] crypto: sun8i-ss: better debug printing
Date:   Fri, 18 Sep 2020 07:23:04 +0000
Message-Id: <1600413795-39256-7-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch reworks the way debug info are printed.
Instead of printing raw numbers, let's add a bit of context.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 5cf00d03be1f..739874596c72 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -424,19 +424,19 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 			continue;
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ss_algs[i].alg.skcipher.base.cra_driver_name,
 				   ss_algs[i].alg.skcipher.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 			break;
 		case CRYPTO_ALG_TYPE_RNG:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
 				   ss_algs[i].alg.rng.base.cra_driver_name,
 				   ss_algs[i].alg.rng.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
 				   ss_algs[i].alg.hash.halg.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
-- 
2.26.2

