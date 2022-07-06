Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED2CCCA473
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiGFJGF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiGFJFS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:05:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865112494D
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:04:48 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h17so7903202wrx.0
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5JnoAw4X1z7bCscIjsjfjSMoE54Bwt7ulA7ZsyJ5jyg=;
        b=xr0FpK5cwnCb0WOaO6y8mE+TkKYS/kzREEXHsfMULEMhvECHCj/xpm3tcmXurmGbP4
         67CBaXwsSyy+HadNjaLE5tn18Kzcs3ftlVqzg9UtTI5eBN1Cain3QkeuoXt5au1BDgvf
         MAq3p1njGNYdEFTmPZHhMK0640KejDHqEL7UEnnf9NjwomqWvcL3ZuYANJ19p7Br1+ye
         ao3UHr0Kfd3ChdaGisMDX89uwzJ7kvTjL10Wfyp/UliCxYV6AIxufOjfOkGgWk9+le/A
         r7leP/Z9IP7eeTX0+oyNpWOKy68v5TIWjBRSpNKNpM0VQZidMvoyC0xuzttKj65VcJa2
         sPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JnoAw4X1z7bCscIjsjfjSMoE54Bwt7ulA7ZsyJ5jyg=;
        b=wPnnXjSP2PBZzhnZwIjP6jMeiHIglfIAZI24HRDk/s73PCoRPsUsaP1ddFq44/LPEL
         Ow2H9tHSmP8n4vVzO8QfYLxem3vFaTZIhbuYxOe5vZdqX7i61wA4GkVqgcqi+xLZ9Cvh
         ky774Tn//gxIowM1Y225zeW3VuB493FfExp1/mQVkoUjyfB385QJieLHG/eW1CRJ02+M
         2ehGY05C57hwZZMF+fBxqwlZCoIySQmk3qasi67a1FxLwD/cyUhfJUceF1AfouJLo++B
         xP/ZuN4y2pPp0ZqRNSAxZJwLsREqIBRpv0A/0Uxfe7guyBvosNvih7kZSfM9GI9d+RKS
         1hZQ==
X-Gm-Message-State: AJIora9XLRbKN63rH3ckVlA5DzsxAWH9nJwRUoT3YxO4/Z9205whq66Y
        AOsnsfIiRoJ9zdveZibou3XyKA==
X-Google-Smtp-Source: AGRyM1sm1kYLskwNqIGQfOuVHXIP8ExmBLLxMmvsSYCpN0ZkgD54v+VH1c74YJg19nKmo4OTTKjbow==
X-Received: by 2002:a05:6000:69d:b0:21a:395e:572c with SMTP id bo29-20020a056000069d00b0021a395e572cmr35341384wrb.559.1657098287952;
        Wed, 06 Jul 2022 02:04:47 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:04:47 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 14/33] crypto: rockchip: handle reset also in PM
Date:   Wed,  6 Jul 2022 09:03:53 +0000
Message-Id: <20220706090412.806101-15-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reset could be handled by PM functions.
We keep the initial reset pulse to be sure the hw is a know device state
after probe.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index d9258b9e71b3..399829ef92e0 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -74,14 +74,23 @@ static int rk_crypto_pm_suspend(struct device *dev)
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
 
 	rk_crypto_disable_clk(rkdev);
+	reset_control_assert(rkdev->rst);
+
 	return 0;
 }
 
 static int rk_crypto_pm_resume(struct device *dev)
 {
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
+	int ret;
+
+	ret = rk_crypto_enable_clk(rkdev);
+	if (ret)
+		return ret;
+
+	reset_control_deassert(rkdev->rst);
+	return 0;
 
-	return rk_crypto_enable_clk(rkdev);
 }
 
 static const struct dev_pm_ops rk_crypto_pm_ops = {
@@ -222,13 +231,6 @@ static void rk_crypto_unregister(void)
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
@@ -258,10 +260,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 	usleep_range(10, 20);
 	reset_control_deassert(crypto_info->rst);
 
-	err = devm_add_action_or_reset(dev, rk_crypto_action, crypto_info);
-	if (err)
-		goto err_crypto;
-
 	crypto_info->reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(crypto_info->reg)) {
 		err = PTR_ERR(crypto_info->reg);
-- 
2.35.1

