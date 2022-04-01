Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1CBC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349352AbiDAUVv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352352AbiDAUVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:21:22 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E38109D
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:36 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j18so5800952wrd.6
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4CfXM7leMN5pRFOjPHWHxGcJrApetL12geqzG0hLkdA=;
        b=xgTbv0BySELvx8Y6w1muFk/fSYXMJa+Ne1fthEts2plXS8pZu/NuZSx5P8+V5wIg+D
         n8UVA2MVIvhx9nfmseXaju/85nmFurPxGG//0WdLCecD62vejPXRW8CqUQrrL6fG0+VZ
         0+2f0vlHwtMaoV9YK5EM37kv26mif+jrfbWTVHHw1sxZj9ShApITGr1AuqZtg72gGrGi
         Kh5Ki1YJC+k2oFvkaGa25mQguTTrXVBkPtxPFpKZsnDcTSizxfQTCmpManurk2GVZ89F
         aaaC+ewHiIfQsmDUGSg6oiwzjTbKbAnhsefDal7jnShyMmml64ASz/BYNntU4d/Z5LSr
         fyfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CfXM7leMN5pRFOjPHWHxGcJrApetL12geqzG0hLkdA=;
        b=nOqJM1oMwkBM0HjdnFR8yfBE7rqy40WB3FWxM0v1wGrTbzy/wfMPGU58d2lsOummM3
         Q8IZt41KeLUBZUVzex6+KPy/p41OuPZyzr4tP44ukNe/Lk5LFnIZXsg1HQ16JVw5rnX0
         vOJDz8D7QnQfzKpVVlwUffsADNttLGGnfhIFAXzh/AfkMz2CKqqrLADY/9mlZFU7y88L
         pfMReX9c8G/NoJr4XTvppES+rywVQt1RrtUva/AKPIzE0lzrsDnqyAcnVXAkXZgU+33+
         f8wvAtQngvNqrvo8ie5pa+XEZ53eMZ1w7ySEQ+tZ4PefnlDvVMLUgYBkiRQONXqpIeem
         IP1A==
X-Gm-Message-State: AOAM533yTq4z+lpBDTF4+UBUG8+EmK7vDLT9MkHhWkAdEb7Ta942rJvy
        uHNN03p9UNdVdBkSvEW8bq0bTg==
X-Google-Smtp-Source: ABdhPJwL0g8nYklbcJJtem7pvN8rmEB5bnkJhEB8bG5p00EedbdcmqrsBo0vMQsd6IexZoar32yoIw==
X-Received: by 2002:adf:eb4d:0:b0:1ed:c1f7:a951 with SMTP id u13-20020adfeb4d000000b001edc1f7a951mr8648367wrn.454.1648844314873;
        Fri, 01 Apr 2022 13:18:34 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:34 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 33/33] crypto: rockchip: Check for clocks numbers and their frequencies
Date:   Fri,  1 Apr 2022 20:18:04 +0000
Message-Id: <20220401201804.2867154-34-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
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
 drivers/crypto/rockchip/rk3288_crypto.c | 56 +++++++++++++++++++++----
 drivers/crypto/rockchip/rk3288_crypto.h |  9 ++++
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 89a6aa65d2c1..f759ed7160d0 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -29,20 +29,63 @@ static struct rk_crypto_info *main;
 
 static const struct rk_variant rk3288_variant = {
 	.main = true,
+	.num_clks = 4,
+	.rkclks = {
+		{ "sclk", 150000000},
+	}
 };
 
 static const struct rk_variant rk3328_variant = {
 	.main = true,
+	.num_clks = 3,
 };
 
 static const struct rk_variant rk3399_variant0 = {
 	.main = true,
+	.num_clks = 3,
 };
 
 static const struct rk_variant rk3399_variant1 = {
 	.sub = true,
+	.num_clks = 3,
 };
 
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
@@ -266,6 +309,9 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
+	crypto_info->dev = &pdev->dev;
+	platform_set_drvdata(pdev, crypto_info);
+
 	crypto_info->variant = of_device_get_match_data(&pdev->dev);
 	if (!crypto_info->variant) {
 		dev_err(&pdev->dev, "Missing variant\n");
@@ -289,12 +335,9 @@ static int rk_crypto_probe(struct platform_device *pdev)
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
@@ -312,9 +355,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	crypto_info->dev = &pdev->dev;
-	platform_set_drvdata(pdev, crypto_info);
-
 	crypto_info->engine = crypto_engine_alloc_init(&pdev->dev, true);
 	crypto_engine_start(crypto_info->engine);
 	init_completion(&crypto_info->complete);
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 5662a1491a9e..b49bdc7541b1 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -188,9 +188,18 @@
 #define CRYPTO_WRITE(dev, offset, val)	  \
 		writel_relaxed((val), ((dev)->reg + (offset)))
 
+#define RK_MAX_CLKS 4
+
+struct rk_clks {
+	const char *name;
+	unsigned long max;
+};
+
 struct rk_variant {
 	bool main;
 	bool sub;
+	int num_clks;
+	struct rk_clks rkclks[RK_MAX_CLKS];
 };
 
 struct rk_crypto_info {
-- 
2.35.1

