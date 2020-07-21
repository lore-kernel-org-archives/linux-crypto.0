Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213A6C433E7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D192068F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="CeNN48cI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbgGUTIX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgGUTGo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669DAC0619DB
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:44 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f18so22277218wrs.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SEES3ktE4nrApq3IspxeRlC1T/Hc5+7zUjeO1iyCzPo=;
        b=CeNN48cIQg9J/jUgHmlkl32S6rXiii0xJjYwQWm+JbckhqZA1xJ6pzL2TpkCH2goEQ
         W2WsxMvXVQjXC/RD38Oi+X3JhygCY3WG3WzGFd34V3Eax9HYDOYmgr+ugGfqaz+Rut+q
         7KOctci+QG2wgGYyILeepOkVKAx8paW0GnJTLJZ7lnd+r4xVZz68ScYtl6z54FCEANpy
         iwX+jjzTC7ftelZAMmSFYFwJNY8OkUGrGKOZU79uvpzoAkZSMssPafKT8Al5LBtyAq25
         aqxjkeVwGTRjvVChmOGSvUcf4N4/Gc8fO/vmRdYf7LEBc1yh2bMfeAxtJhJKg9Wr7G0C
         53VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SEES3ktE4nrApq3IspxeRlC1T/Hc5+7zUjeO1iyCzPo=;
        b=VIj/B7Oi3FoxhFFIH+TFdsKY/iUj58rYIfg5AnMBvjosGbBUpV2oNDX4eMoMeSrMYs
         1ye63qj8HJO96gpaxkf70H/9Kcb/OldqByeqx239hdd71Pnwu2auhZa3+w4IJTfkfZQv
         VWY3IxoZvOshzfAYYqKkCQS2T9LL7ZVBA3iiwtPKKZfb0+JuKQyXlfUPfEAcoPk5FagA
         V0r6Cdnd9dzQ0VSQvNeXZJakk/sTkdztDaJ3Dg97v+5VDlHHaR70+0NdN+bMtLTRO2Nk
         1sY9Xj8a3hOKf0VfcMwbvFSeNoGKFiNmrMl1K5IzhoTW5F8kjzTL7QOGumY0uLdB8fyL
         LiYg==
X-Gm-Message-State: AOAM532vTAlvW9qzhS+wvHTtfAgr+P7u5Iyg+bkbIs3LxSDJZT/J7afF
        4EOnxRQGFofDOUsPwaBuoV7qjQ==
X-Google-Smtp-Source: ABdhPJyGUFdzX4+aI0jvRZaJbT79LA1FWVquoBcG+mi4ZY59xNf8s8+pbkIWWaHsgeNMOP1Ubo+XNA==
X-Received: by 2002:adf:ee05:: with SMTP id y5mr28843483wrn.185.1595358403150;
        Tue, 21 Jul 2020 12:06:43 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:42 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 01/17] crypto: sun8i-ss: Add SS_START define
Date:   Tue, 21 Jul 2020 19:06:15 +0000
Message-Id: <1595358391-34525-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
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
index d9767e2c84d9..3a9723441e46 100644
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
index 0405767f1f7e..f3ffaea3a59f 100644
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

