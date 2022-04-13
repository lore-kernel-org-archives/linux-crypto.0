Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FECC4167D
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiDMTO2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbiDMTMA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:12:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A9171A28
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o20-20020a05600c511400b0038ebbbb2ad8so1788348wms.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5M1EQ6WsDJDi9glkqW5UPCpOuBDX/AR7k6YyL2ZeXO8=;
        b=6gBHQf0KiSTvpnZIg6JgOOwXVAw4V8HH2ialLWZqaWZgQHL4vFoBh17Gjn2ePsQStu
         YQmoTPquXa5la6sOlbdP/QRDLYwYs/yk9HlEvNlXfZCdxeaGDUDXZcuG3OOaGU7XEXz7
         T52Ki9Ivt9F7HHIe9jgXcU8swny27CQ8ea0CZB1zDAJ1nobj5e5ma3zxLGzok33Tk/6R
         9Fq2hSNvyybocBdgNz3w81LSZcketCR3WvMXjKqFk1v5Zpr+ThsYCg/9IZAb0TvuKWoW
         JlGNSC9b9g0OVEU8EMJIvKhjrCawM93qhHAH7PennK6igFMAu5+4eteLqrv1KAEIcQDJ
         PMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5M1EQ6WsDJDi9glkqW5UPCpOuBDX/AR7k6YyL2ZeXO8=;
        b=1MLolrdh2Cpp9EzVFXMBpfMw1NOKADbuVySx0wiMuWZil009CEHw1sCmAu+Jo/I+kZ
         rIjz9bnKid3nA8yxpVe7MtDXEX9pzHlxiiiforDJ1cSiil+Yt1yacziEMpkX6VS2rlWg
         8xKAIRyJmaRD3nkZ4r2XYFdDDqD+Vh33nEEXdfWI0xq8bHgCNO9idp9J5p2L1bta9QPq
         gSneZxfBKjjPp1Zn8vmY9NVIXXeIbwzSe5ewvsxOVnS0fMBijpMC4/zL4Kwt588pg92z
         GBVMRjaUIdBulaVW9k7zlX+XlIY+3dSfq1Nsy/ssI1328dmNuVbAmVdmzSZ4YFrs2msE
         4rOw==
X-Gm-Message-State: AOAM533deG1XemdX0f5cC6YxP9oeCVf1jtPfevN22TLXA2QLPBHjEn/5
        hZPDE1fO43CSv8jOH8j0/FXTQQ==
X-Google-Smtp-Source: ABdhPJzTDELPPMBoRkmCWIdVyyjSt9kfpmbEbURRbVlCcX769NS5AWz3O9nT0xuj+BPXpgIg29N7EA==
X-Received: by 2002:a1c:acc6:0:b0:38e:b184:7721 with SMTP id v189-20020a1cacc6000000b0038eb1847721mr168777wme.94.1649876874207;
        Wed, 13 Apr 2022 12:07:54 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:53 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 30/33] crypto: rockchip: Check for clocks numbers and their frequencies
Date:   Wed, 13 Apr 2022 19:07:10 +0000
Message-Id: <20220413190713.1427956-31-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
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

