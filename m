Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BC3C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245268AbiCBVMl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245193AbiCBVMf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:35 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAF3DE2EA
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:33 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bk29so4750009wrb.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mq94Dr5+JVccORut3g3YoAFCHNwJha9oYdYCZSmtj94=;
        b=U0DTL4S6GNXCxomapNhQbk6QlG9hRPJv1j5HQJ0h09vEfdgbVOM7InDA3E6lUAdTrz
         uRqA9AxWXGRWAporGp8wFF71zA/8cO4jaRJAMomxRx/5b3yOIiw3cUEl6eBy0NyeIbP3
         G682W5sAueKScefqW0j5QuAPnx5vYhXW0wmSF+vzvUHpP/JUIWGKhUbv5RAus3Mhtim0
         C98fu98v22ASVbY9MBUXeo9MUKM5g0ZKZowOQZQkkebVmJlCFGOw693/tQ/c0TScfHf3
         D1gpk6n6UHErJxZz0XhgwkjyJzEiP4U+v/bZsagYAs84CFffnWvq7elwEuKrUcyLx+T3
         DiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mq94Dr5+JVccORut3g3YoAFCHNwJha9oYdYCZSmtj94=;
        b=avs88bdL6w6Zu3+Ts5SNK7/VjcM+jHSFLXkseTL83ytk1D81v5hK9FgXQ/EARqucbU
         +YrXdkxde6P567eW9zMg/BluhYv2RO8NnUbWTy47gzspvl53KNVw9ckSM3qriplOzK8t
         pb/M7i8qULZtrgqnJNkqo7zsfVQ3NYSPXl0RBrQEr9XjpDySeEvdp160vax8E8L4tnSJ
         3qRSEgmi2DicHP2zsaK+U/lQGcqiieEfV1xNAYqN5QJAAYQJUVAjwuSqtWaw60RbVEid
         Zx550XrF/6ctLUIo2wXXz3OAyxz+q6YaxZu/z2dDaUbe2kgBQ01L0euaZI0pD56Wh5vE
         U5QA==
X-Gm-Message-State: AOAM532pH0ViOCEFF6tN69kIveIYjPG6QIBNdc6aQYEEdns+E5UDs7BA
        P2n4F89w65mcChz5NQlgA1KEZQ==
X-Google-Smtp-Source: ABdhPJzNrviGuhF6beRfYB3gHyxCFqqZ+/HGFHv0JfNIUXWA3/kfT5jahwXLRaO3xGZoJD2iUvKvtw==
X-Received: by 2002:a05:6000:3cc:b0:1ef:9b6d:60c6 with SMTP id b12-20020a05600003cc00b001ef9b6d60c6mr13743574wrg.480.1646255491524;
        Wed, 02 Mar 2022 13:11:31 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:31 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 11/18] crypto: rockhip: do not handle dma clock
Date:   Wed,  2 Mar 2022 21:11:06 +0000
Message-Id: <20220302211113.4003816-12-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DMA clock is handled by the DMA controller, so the crypto does not
have to touch it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 16 +---------------
 drivers/crypto/rockchip/rk3288_crypto.h |  1 -
 2 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 94ef1283789f..645855d2651b 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -40,15 +40,8 @@ static int rk_crypto_enable_clk(struct rk_crypto_info *dev)
 			__func__, __LINE__);
 		goto err_hclk;
 	}
-	err = clk_prepare_enable(dev->dmaclk);
-	if (err) {
-		dev_err(dev->dev, "[%s:%d], Couldn't enable clock dmaclk\n",
-			__func__, __LINE__);
-		goto err_dmaclk;
-	}
+
 	return err;
-err_dmaclk:
-	clk_disable_unprepare(dev->hclk);
 err_hclk:
 	clk_disable_unprepare(dev->aclk);
 err_aclk:
@@ -59,7 +52,6 @@ static int rk_crypto_enable_clk(struct rk_crypto_info *dev)
 
 static void rk_crypto_disable_clk(struct rk_crypto_info *dev)
 {
-	clk_disable_unprepare(dev->dmaclk);
 	clk_disable_unprepare(dev->hclk);
 	clk_disable_unprepare(dev->aclk);
 	clk_disable_unprepare(dev->sclk);
@@ -199,12 +191,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	crypto_info->dmaclk = devm_clk_get(&pdev->dev, "apb_pclk");
-	if (IS_ERR(crypto_info->dmaclk)) {
-		err = PTR_ERR(crypto_info->dmaclk);
-		goto err_crypto;
-	}
-
 	crypto_info->irq = platform_get_irq(pdev, 0);
 	if (crypto_info->irq < 0) {
 		dev_err(&pdev->dev, "control Interrupt is not available.\n");
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index c741e97057dc..963fbfc4d14e 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -191,7 +191,6 @@ struct rk_crypto_info {
 	struct clk			*aclk;
 	struct clk			*hclk;
 	struct clk			*sclk;
-	struct clk			*dmaclk;
 	struct reset_control		*rst;
 	void __iomem			*reg;
 	int				irq;
-- 
2.34.1

