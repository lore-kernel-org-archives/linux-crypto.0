Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB1BC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC84B207DF
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="VupcTfHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgHUNnw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728723AbgHUNnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:43:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC30C061575
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p20so2012172wrf.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=VupcTfHvtOM3OqYqFKTzWoJX6b0VQKA/XU+uQbm++069aCLbi5DJj0dk82uanW01lL
         N5AzLXKz69tzblUHvIByN4Sybc6lxZOY6s4zz4LVZIV7GKTQwT680oaAmhrsiExqQsT0
         pt7/4Vf5zUoahz8FsEV6e7ixBc35Ur6erUqifHvnhQTFiIrxeiba6VacQQ+1OysEkYau
         W0cEzV391BlTlhd0HjV4OApkPsRiklKBosJTD2SEqQyay1SSENtQzy0ItYtrGb3fQvFW
         Hpt3vKCtofcR2a9jCC5W14LbNmqXNh9IYLqs725tHNSiDdcq9HvbDOeIzo1El1TTvZ4+
         Bv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=an/ZItpIvdsXZ+dkCGTRBp4WyvhqN2ZXif9hZg0TSV0=;
        b=mmGAfElTLtwL13z+eueMYWXgCy/tRCxUo5tK8+Y+fI0aK2vL8N9V99FICKQOWZE09X
         b1Ro44NTi5mks3jFtbgsXosCj/opZciWmdo4FqwEqm48SbpljjAPnvAACH/b5+4it6Fa
         3tCU4H1o7QmbNekQ/rGGwPCUSF/3D86Yvc50ncawBn7OyFub+OHLl/fdsiKAh+y1C9UI
         GziPBYtg/KmKV/7dH+kEKyuOMuvZ9jWMe95pN4EO76ZnG6RB4RSFPVlrbZ4Muz2s6WEL
         4JdEQfGrsrFy8PRcb44z0cshoTYWcvnGzMWd77yh0DEdwnk4BPwRRfB89b5x0z4PRoOu
         ZdOQ==
X-Gm-Message-State: AOAM5311AaXuROCt0ASh39hf06fklXkRfyuf6q5AwtTsnHguUdz4dn9T
        vtphrNwKhg4Z5DKWciYUO6/jpw==
X-Google-Smtp-Source: ABdhPJw6tis5ZR2fR5im6CyO9RyII+xiyyyVuOWW8nErWFZhdZ2AurjWD9xmeY8mAvJx8ACVUr6LVQ==
X-Received: by 2002:adf:ec10:: with SMTP id x16mr2704963wrn.74.1598017424244;
        Fri, 21 Aug 2020 06:43:44 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 202sm5971179wmb.10.2020.08.21.06.43.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 06:43:43 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 01/18] crypto: sun8i-ss: Add SS_START define
Date:   Fri, 21 Aug 2020 13:43:18 +0000
Message-Id: <1598017415-39059-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
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

