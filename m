Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7FDC43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D3FA21741
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="aS4oaZpG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgIRHX3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgIRHX2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C49AC061788
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l15so6032001wmh.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=aS4oaZpGgF5Yx/SjMNO4D1dl1r2QPritaZqtlULED7sRG0zDx0BocoRRJiEl6ArjM2
         y3Whw2VQSIreWxm7uQES/cw4FoZJpkVTJMZIDUjU0plhB6fDQ/qR9vcKVBO2x0TCY3dk
         3O310FYCGDJH1Og8IcSuHlugHCPjYWEpE3dO7PY+a6B1aKionlSIJ+urdFjock0pW3+4
         iw5KDDqDvzV1umXS9x4+GSGkBv0MOgiNn6FKjZRkAL162npzPHTyH3fktrTpV7Tx2K13
         n3FBPE2tl9G8h71rL0VXAR76J77g1Ns0SkxiDHhrAW4iFhwEcyvQFwWZQ0pmVfOFo8DZ
         MIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=JwMydJ4M/Q3Jp1xJgNMUH2XMzUp58amhwCuk5cCECBkGz6SdslXm1eGl59dXdJduwg
         2//hu+tglid4Kq74jCKCoh1xRXTjpiK8WHE2ZPCQgmKYjIzB9gVseuqZ4S9fosLtN0h5
         j3v3EHLbyzV/QfrpkEAGepUUy+f0hqFaUHZ4iU8Sq0Bb+d/qxxjNRw+TjRLknR3LIER4
         2+UkFWIhs3MpH/WQ7KEC3WPQ0H4vKZ75Be/VqxDankwhuXM6N+7BB2G/Yz5ZAD6CXFwl
         Pe/dCHwLc3Lm5hsvwlcsYM+kuySm/4iCzW9s++3220vkmX6q/ndOsU+A/pOVaC2LBCI4
         DtAg==
X-Gm-Message-State: AOAM532u1MvOvwKHLa+8JDlod6Bs8p9b9jIXlEUIfhzZbHAxCXhh5rPM
        oNEiIHPAgLrOXhgmqyY6PNx5UQ==
X-Google-Smtp-Source: ABdhPJzDdfjoN4lKQgPDS0TV0at1cUlFXtL5wmDVSacIiOJLSNjIUz+GXZ+jG0BdRCNzSSojhweMjQ==
X-Received: by 2002:a1c:6445:: with SMTP id y66mr14714398wmb.12.1600413806507;
        Fri, 18 Sep 2020 00:23:26 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:25 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 01/17] crypto: sun8i-ss: Add SS_START define
Date:   Fri, 18 Sep 2020 07:22:59 +0000
Message-Id: <1600413795-39256-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
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
index 9a23515783a6..97012128385f 100644
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

