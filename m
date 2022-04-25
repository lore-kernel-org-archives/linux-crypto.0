Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BD3C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbiDYU0y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245447AbiDYU0X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:26:23 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32026132A5E
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:07 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b19so22452501wrh.11
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5M1EQ6WsDJDi9glkqW5UPCpOuBDX/AR7k6YyL2ZeXO8=;
        b=NWEtrMzZQb78/gHTZz2/xRrDhNHvIcWcioKa9osau53EDYQ5B8wG10RuuHkoo9ebgQ
         1Ixy28TUsyEKeIFPrSzTZbnwJIe96uoG4g+TIY4bf4LRyuGUk8wbQhzWgyV39E7409b+
         BYLserB1aYW9+sWZtBGYC9M4sZgJcvJw0ZertRkaf6zNCcT5/IhOqC8X4WGYczGaoRFK
         YzkbbogPGLEgfr+zRpw3M6BKRuOApSN3GPz801gzUqRNk9UC+5K3rGwF+uF8KOqjNUcS
         grNuZxSUjYa6lvykfYggeWgRCGRSaW8JXJ8NO9ddBGX4cOMxRwjj0qi4PDnBosQbOoQh
         VDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5M1EQ6WsDJDi9glkqW5UPCpOuBDX/AR7k6YyL2ZeXO8=;
        b=pA/VR7/nge1VCHAwISxWMZJR15B129LlgCzjnEVkDi+NS4Ui44u/vxX1sMSoI8CdLb
         J1FE0V7ekutGxG36abXSpOXc5uf6b1dzkLxTgdgYoqwcj/yiheOfP4tJu4ze9BpkOLgl
         tNNSc/7Fp0ppXQLKjjV5JZZk2XbJ3+3Crd2ycE30WqO1rAg5YsxILpBSKRPA4H/lrnpC
         H2aTuYK3VKsNbzuaQ9dvDyq+sgC0OfO1yutYUwCTl9g6YYEXXLu7hsLirGlF1Hc2dV5j
         9MCRHeWFs5xqjXBqcFWPchdkexXpSN/qY2PGkWW54zTfZwh9/7kkU0hlm0MrncNbkjjS
         0/mQ==
X-Gm-Message-State: AOAM531yHLAmciJOkWOhhv9+U11UfERioeThds6YMWwrHeIFJ77Kqzfn
        cUlL8n/zaMwTppTvEKs+3JQv/A==
X-Google-Smtp-Source: ABdhPJyA0N6S7uZoZLuQ/IsNwqaGX//V4SfZLnjf86U5qp3VVEgdxilTg0qv/uRwc9cHcaEmz37Wbw==
X-Received: by 2002:adf:e289:0:b0:1e3:14ad:75fe with SMTP id v9-20020adfe289000000b001e314ad75femr15468443wri.685.1650918116483;
        Mon, 25 Apr 2022 13:21:56 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 30/33] crypto: rockchip: Check for clocks numbers and their frequencies
Date:   Mon, 25 Apr 2022 20:21:16 +0000
Message-Id: <20220425202119.3566743-31-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the number of clocks needed for each compatible.
Rockchip's datasheet give maximum frequencies for some clocks, so add
checks for verifying they are within limits. Let's start with rk3288 for
clock frequency check, other will came later.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 75 +++++++++++++++++++++----
 drivers/crypto/rockchip/rk3288_crypto.h | 16 +++++-
 2 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 6147ce44f757..d6d78b8af57c 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -14,10 +14,58 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/reset.h>
 
+static const struct rk_variant rk3288_variant = {
+	.num_clks = 4,
+	.rkclks = {
+		{ "sclk", 150000000},
+	}
+};
+
+static const struct rk_variant rk3328_variant = {
+	.num_clks = 3,
+};
+
+static int rk_crypto_get_clks(struct rk_crypto_info *dev)
+{
+	int i, j, err;
+	unsigned long cr;
+
+	dev->num_clks = devm_clk_bulk_get_all(dev->dev, &dev->clks);
+	if (dev->num_clks < dev->variant->num_clks) {
+		dev_err(dev->dev, "Missing clocks, got %d instead of %d\n",
+			dev->num_clks, dev->variant->num_clks);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < dev->num_clks; i++) {
+		cr = clk_get_rate(dev->clks[i].clk);
+		for (j = 0; j < ARRAY_SIZE(dev->variant->rkclks); j++) {
+			if (dev->variant->rkclks[j].max == 0)
+				continue;
+			if (strcmp(dev->variant->rkclks[j].name, dev->clks[i].id))
+				continue;
+			if (cr > dev->variant->rkclks[j].max) {
+				err = clk_set_rate(dev->clks[i].clk,
+						   dev->variant->rkclks[j].max);
+				if (err)
+					dev_err(dev->dev, "Fail downclocking %s from %lu to %lu\n",
+						dev->variant->rkclks[j].name, cr,
+						dev->variant->rkclks[j].max);
+				else
+					dev_info(dev->dev, "Downclocking %s from %lu to %lu\n",
+						 dev->variant->rkclks[j].name, cr,
+						 dev->variant->rkclks[j].max);
+			}
+		}
+	}
+	return 0;
+}
+
 static int rk_crypto_enable_clk(struct rk_crypto_info *dev)
 {
 	int err;
@@ -196,8 +244,12 @@ static void rk_crypto_unregister(void)
 }
 
 static const struct of_device_id crypto_of_id_table[] = {
-	{ .compatible = "rockchip,rk3288-crypto" },
-	{ .compatible = "rockchip,rk3328-crypto" },
+	{ .compatible = "rockchip,rk3288-crypto",
+	  .data = &rk3288_variant,
+	},
+	{ .compatible = "rockchip,rk3328-crypto",
+	  .data = &rk3328_variant,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, crypto_of_id_table);
@@ -215,6 +267,15 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
+	crypto_info->dev = &pdev->dev;
+	platform_set_drvdata(pdev, crypto_info);
+
+	crypto_info->variant = of_device_get_match_data(&pdev->dev);
+	if (!crypto_info->variant) {
+		dev_err(&pdev->dev, "Missing variant\n");
+		return -EINVAL;
+	}
+
 	crypto_info->rst = devm_reset_control_get(dev, "crypto-rst");
 	if (IS_ERR(crypto_info->rst)) {
 		err = PTR_ERR(crypto_info->rst);
@@ -227,12 +288,9 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	crypto_info->num_clks = devm_clk_bulk_get_all(&pdev->dev,
-						      &crypto_info->clks);
-	if (crypto_info->num_clks < 3) {
-		err = -EINVAL;
+	err = rk_crypto_get_clks(crypto_info);
+	if (err)
 		goto err_crypto;
-	}
 
 	crypto_info->irq = platform_get_irq(pdev, 0);
 	if (crypto_info->irq < 0) {
@@ -250,9 +308,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	crypto_info->dev = &pdev->dev;
-	platform_set_drvdata(pdev, crypto_info);
-
 	crypto_info->engine = crypto_engine_alloc_init(&pdev->dev, true);
 	crypto_engine_start(crypto_info->engine);
 	init_completion(&crypto_info->complete);
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index ff9fc25972eb..ac979d67ced9 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -188,14 +188,26 @@
 #define CRYPTO_WRITE(dev, offset, val)	  \
 		writel_relaxed((val), ((dev)->reg + (offset)))
 
+#define RK_MAX_CLKS 4
+
+struct rk_clks {
+	const char *name;
+	unsigned long max;
+};
+
+struct rk_variant {
+	int num_clks;
+	struct rk_clks rkclks[RK_MAX_CLKS];
+};
+
 struct rk_crypto_info {
 	struct device			*dev;
 	struct clk_bulk_data		*clks;
-	int num_clks;
+	int				num_clks;
 	struct reset_control		*rst;
 	void __iomem			*reg;
 	int				irq;
-
+	const struct rk_variant *variant;
 	struct crypto_engine *engine;
 	struct completion complete;
 	int status;
-- 
2.35.1

