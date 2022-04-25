Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D842AC43219
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245419AbiDYUZh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245351AbiDYUZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:25:28 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6F312EB59
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v12so15672600wrv.10
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=oNa9cg5QsPwwP4uLrV+YbTdL9gqvb/dfY9l6gDFTVL86Z2ljrwrlOp+UqdK9YUYY5+
         8hyKkQM0y/sN2QGVNqYZVWZYA5tWkkkQFJ8vS0ebBlNGUfEkmMISnd+RUnLz+khNW1Fa
         ob1wL+3kdho0gYV+dOagIVU//4y+gbBWc45DbDRsciupfmFioao8ygk+3vUwnmnm2h70
         LS9l7pOZJVjbio9ScR2wpWVHN2KykUoEL6VCteLaIDYVWQCFmMxT1x/ox4H/kiIfSH5e
         rKzi+mrz/BycqwmKuYcURG2P7lGC8TqTaRspWC3UzAlp9B55VXupvcqdS1xfsTwQuxXB
         p7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ww46m6LdM7MaV4jgNKlRbRSwspMAPKBncRJe9WsCVsI=;
        b=0NDLF41c+lLMNSMUVzrw/rTgBBEIyj+n2BNQxzMerSVYmbdo/UMWPp6u+Zdfi0QIlM
         +Gu6CwS7EVriLECXzWk0xJETFcJGO+LLsR6Fw91pE/ZZrpgvivdv2+VJc41MRuvD6tS9
         nf49EtU14d9P9n5EHj77YHeHNbURtq9/I8XGi/0qeBwjAFyRgl4XO2Q3zo1Q314hQoi5
         7j+kQYphFCqhiUjRRuvlAWutrmHpk0869PihZG0iAN1hVg3dySrATb4gtw7CZu3i8TkI
         CHuBZHDyvK81Pw476IMXAz9FwcpjN2OTUKLjPnLQnrjebhS0XIY75i5zjxCSE9Xg9wQ1
         JOgQ==
X-Gm-Message-State: AOAM532SCJI3wuU2EMkQSMBsnXjzpYHpP00RXpIBfb9fZL1zqI7+JL0g
        fZZqMDmSBeucBOizqEWUFrWaMQ==
X-Google-Smtp-Source: ABdhPJzWVdJF9EEfqt9FZpmuVTK4chwSLrTU0dDvxl6PARMF3rJ1c+XK/DWisIC9K5f/fe3rM+8S7w==
X-Received: by 2002:adf:e289:0:b0:1e3:14ad:75fe with SMTP id v9-20020adfe289000000b001e314ad75femr15468017wri.685.1650918105802;
        Mon, 25 Apr 2022 13:21:45 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:45 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 19/33] crypto: rockchip: add support for rk3328
Date:   Mon, 25 Apr 2022 20:21:05 +0000
Message-Id: <20220425202119.3566743-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3328 could be used as-is by the rockchip driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 97ef59a36be6..6147ce44f757 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -197,6 +197,7 @@ static void rk_crypto_unregister(void)
 
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
+	{ .compatible = "rockchip,rk3328-crypto" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, crypto_of_id_table);
-- 
2.35.1

