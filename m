Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3111BC433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7FA23C3F
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="LbyxmIdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbgFUTbU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730307AbgFUTbR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F0C061796
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:15 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so6862709wrv.9
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LFDRXwTitCs1nrRc2jOX6sWRaTpGwdnr5FsLJM6PpMw=;
        b=LbyxmIddIqVwlVyDrhBNdNJYWnIxcroyi8gEbTkbaVer9A2emoTWqlBqwN//azBoIs
         8RArNyjqMpHYjWHKa2HtU6yR53NGxHcb25cfKNwOltxxy1VLHPprDytFMVutQSW84bg4
         N/QDEcS+6oL8CiTIwD/9EurfZajZIYLyIcmcXcxhvJfJIqOGa5KxUZFyJ798/L2vSplN
         64ySfeFSa1b4SF/ZAcoP3Zs0wtasp7u+FivzahEwzvMlJ0QoyYwZZefeDGM8YineSMAO
         2yR3aCvt3abGlSVk/LM9hEMxB5zW7EUVjVegBrQSFngHFrbpQaw4fskRlbbLqCLsaIAu
         KQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LFDRXwTitCs1nrRc2jOX6sWRaTpGwdnr5FsLJM6PpMw=;
        b=SAHxzT9WBiKIckyXdy/gM+Is8UJh9OMdtLCncIF8rJCPkbEiGrNW+Deh89x6gWvkwL
         GaFMsAtpDWNWwPItiMZa+dQKjLHXsx9/3Kd+pU38JFswEBsGzcc316t0bX1ftvOJxRS+
         x6+z4Lbn3xlDDZUHS79R1F1zDHApmMMc1iqGF+gtBWTEPJ6OhRt4cCKxp7Yy0NescAqS
         2lq1jYxiHtPN8X4o1mf1twaPS64ew7mkjekp9Wnnh8Z6WHbIL0bkLKiJrHGBwDlrR5+1
         z1xFa1qznhjl48Mw5AhbnJRk/WDNT+bkS6Lz8xq4oB4SvBi1bX9he9EUP0Ab1ZvkhtRh
         FvKw==
X-Gm-Message-State: AOAM530beQNC76f5EHGKGbRoRY7nOWEGqrzQinrrM6LbEXxmHhD8vHdg
        C8kKzZLJstJY2SSOyyFjXzeAyQA7bTs=
X-Google-Smtp-Source: ABdhPJzH5Rl0vy2fvwdAWyfkHLzRKA42JFPpKgqIpR/JnM/nbm4j5KRCHFpd9pFsONa8AZQ4VctBrQ==
X-Received: by 2002:a5d:4f01:: with SMTP id c1mr14539533wru.190.1592767874285;
        Sun, 21 Jun 2020 12:31:14 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:13 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 01/14] crypto: sun8i-ss: Add SS_START define
Date:   Sun, 21 Jun 2020 19:30:54 +0000
Message-Id: <1592767867-35982-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an hardcoded value, let's use a defined value for
SS_START.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 5d9d0fedcb06..81eff935fb5c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -61,7 +61,7 @@ int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx
 		      const char *name)
 {
 	int flow = rctx->flow;
-	u32 v = 1;
+	u32 v = SS_START;
 	int i;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 29c44f279112..f7a64033fc03 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -13,6 +13,8 @@
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
 
+#define SS_START	1
+
 #define SS_ENCRYPTION		0
 #define SS_DECRYPTION		BIT(6)
 
-- 
2.26.2

