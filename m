Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD57C43217
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352201AbiDAUUv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352075AbiDAUUY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:20:24 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BAB5F4E5
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id p189so2423682wmp.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p55H6E0886aSJalxirRbnL3xLKJ1MG4FEZeIU1Ksblw=;
        b=s8Cu/rVKGMjrNEJCNpVM5WtrdVm4ROL8ZfqEDqFZAZfHalE22880Ztj4cVYjxzuYZl
         /GoQCP+5Rq9H4RWWAWCwa3q5JB2VUDIokmmHL8x9yIotCqPtUC9bYisvzJajCNG8v+gf
         suYSi9GzTyqmCm/AOD1K4f40yxAqd8fief4yzBvt5mcNieDwXaq2Neu8lMxD5QxYM46x
         ALySFfpHEBi4ANpWuxZV31bTiY8oPv1RxyJfMknJ/I6990S6O6jZYih58K78aebJFLOz
         fu/wKeOIfX6r+UeMkbvUTMuXO7GHPy1Ch3KqLEx/4GP+q2k9+Al0rIn3oMax4UWyZ7E7
         emxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p55H6E0886aSJalxirRbnL3xLKJ1MG4FEZeIU1Ksblw=;
        b=p8Cmg6/XkSEV3wO5VqTkpzqllaez12dcucpqgd9dcOJhYX9fOn31cAj9E0pu+trv1E
         4UMwuoIg5q5N+LYFu2RrM4cEJfZSeMVupJSEBh1r2lxZpz688KV0+hYOKGz06dbSHEgF
         /ac/+O70+8OlBB0k7Fp7bXATSRO48nkxO4TFKHCh8VKeeoV8JagfPyCT4ER3CPaOUbbh
         1Wp6g0vQc21bYssjpQoFHM3f322J2EtpUAU3VAS/61VCJIo+cz7LrKqJP2WIRvzUuSHj
         O+iws6T/CCI2AsI3Ct8Oxmc4zNsrTR9H17v1/+xQQ/44jWzZLz0Qag6tMxFe02J5BtKR
         FD2A==
X-Gm-Message-State: AOAM5309pKPe1FawA7mpXDsFpLjVh0sgpNIzykgnhHJbk8idQ+piXa27
        w8xEBBjEzMwbHNPnHvAmZt1WJA==
X-Google-Smtp-Source: ABdhPJwuUqNh9i8vH0ViWgv/pGUH26oWTravnWNZ8bFCmnKXXi7E8aVuxDjFAOpwq80dsKHCFJlHDg==
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id s25-20020a1cf219000000b0038c782c03bbmr9873410wmc.94.1648844301200;
        Fri, 01 Apr 2022 13:18:21 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:20 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 14/33] crypto: rockchip: handle reset also in PM
Date:   Fri,  1 Apr 2022 20:17:45 +0000
Message-Id: <20220401201804.2867154-15-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reset could be handled by PM functions.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index d9258b9e71b3..a11a92e1f3fd 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -73,6 +73,8 @@ static int rk_crypto_pm_suspend(struct device *dev)
 {
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
 
+	reset_control_assert(rkdev->rst);
+
 	rk_crypto_disable_clk(rkdev);
 	return 0;
 }
@@ -81,6 +83,8 @@ static int rk_crypto_pm_resume(struct device *dev)
 {
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
 
+	reset_control_deassert(rkdev->rst);
+
 	return rk_crypto_enable_clk(rkdev);
 }
 
@@ -222,13 +226,6 @@ static void rk_crypto_unregister(void)
 	}
 }
 
-static void rk_crypto_action(void *data)
-{
-	struct rk_crypto_info *crypto_info = data;
-
-	reset_control_assert(crypto_info->rst);
-}
-
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
 	{}
@@ -254,14 +251,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	reset_control_assert(crypto_info->rst);
-	usleep_range(10, 20);
-	reset_control_deassert(crypto_info->rst);
-
-	err = devm_add_action_or_reset(dev, rk_crypto_action, crypto_info);
-	if (err)
-		goto err_crypto;
-
 	crypto_info->reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(crypto_info->reg)) {
 		err = PTR_ERR(crypto_info->reg);
-- 
2.35.1

