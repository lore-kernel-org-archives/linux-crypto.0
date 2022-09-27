Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3309C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiI0H6N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiI0H5H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:57:07 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35156AE85E
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v28so846408wrd.3
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ScW8Amy0Gr2Hkf7kzoiIS1O1Eux9N8ylUQeMnxBh6Sw=;
        b=UQmQ/xlXPpyHldcxn/PuGfEV7YVvqScnEI7fG81jRWYyJeSazypmP3qGUp6/Thguux
         lE6mnyvwmO4ZxCqmPnqhbuaW/4dG8x2wennVoCU5rk4kWn29D2zmwwuJHVwRDzT4OSpu
         WosAKtddUB6u2evESxWJ3hyMAQnDvorHs6T4N+0YrBKKRRwYS0+cHgEqpDQv0L7wd7l0
         zoztjch6/vJ7Dyvf9UmOuw7Ea0gDEwTwkWT1SmphnnknYGsJh5+VEtYGewLzx/sLiHWo
         Fv5xv0y0fjvq9ZpqcqguqxDJTd/IZ6QKaWcli64po8sZMPbtP5UiDgULbJBcZwuyw28W
         GT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ScW8Amy0Gr2Hkf7kzoiIS1O1Eux9N8ylUQeMnxBh6Sw=;
        b=7ns7/pP2P78k6fTvSOaG7Xh/5E4Qo72c5Ono2SQK5jY/BFoyAXaET0C+LNJwc6BdF2
         xe4EyKhXnwqz5OrTqEbNGugngoCcYc/Hhya9rqgp/cR/DU8qG0OqEiv8qX+VSiP9abM/
         PhaXL6MhVtQrd/2G+XZUN7y/Ga/atrS4P5+ASQHcCWykOTqY0Uz4j/xk6c5TOULmnrpJ
         TNZlIpHPGqQLInYxjY73RUdbP0gmxUTMCxtR3/MJol2zbfgKcksf6PRNWaxzOWSWoW3J
         0J8pzNznDTEe2cSTiAF7G1LZUH+D17yy1Me0x+aX7V/Dwm8Y58Rtw9dKyKF/SJ3OA9vE
         DBrg==
X-Gm-Message-State: ACrzQf3ZPYlHMhfLltxoVLRMzKHPw/zYWLOOYBUTCqHVpw1WLAWHvqJt
        pdpDsWztOI7cSOzrCeEyrDAT0g==
X-Google-Smtp-Source: AMsMyM5+CRcmaAXQ4MD1KnJBzIjFb/gIaEASatDT+vc4tREVZLd/A+8DocqiRzm2Ws6lAbWTYTGwGQ==
X-Received: by 2002:a5d:648c:0:b0:22a:2c04:97a5 with SMTP id o12-20020a5d648c000000b0022a2c0497a5mr15951167wri.326.1664265367702;
        Tue, 27 Sep 2022 00:56:07 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:07 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v10 30/33] crypto: rockchip: Check for clocks numbers and their frequencies
Date:   Tue, 27 Sep 2022 07:55:08 +0000
Message-Id: <20220927075511.3147847-31-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
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
index c92559b83f7d..232dc625d6e5 100644
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
@@ -201,8 +249,12 @@ static void rk_crypto_unregister(void)
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
@@ -220,6 +272,15 @@ static int rk_crypto_probe(struct platform_device *pdev)
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
@@ -236,12 +297,9 @@ static int rk_crypto_probe(struct platform_device *pdev)
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
@@ -259,9 +317,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
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

