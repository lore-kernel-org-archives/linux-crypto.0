Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7CAC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245197AbiDYUYg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245187AbiDYUYf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:24:35 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C31240E9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s21so7783556wrb.8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=iVygEJI5sek2lCtA59VX0g2JTIJPfOrprLb1yt1gSc9dKlRNF6I2HxVGvcgvHWQ5+C
         CVTZpYxmmAD90VQBw2Y7JOjoqSBExuo+c1v7tRMMiNhmYj7a+qBVKH/wLVLKybiHijS2
         aP/cqx5SBHi8lfTlWU+dbwlIx8Z4fX0o3gqObjYJ1RKSvRQEM/ws84ZfQB0gtaUx1466
         q1aHDyUYVAdvJY9hi5QKmoIaMnvweM44muPrdT7b55ziPfU1BEazN6/PXKKm+x5qbld2
         FEeqSN/bzwHM1wlVEHYOLRnKocb3EJHrXg2gB4H3S22jCZgxHJVArk/QCPhDzvqVAqQk
         2krw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=wcy97kBdKEg60o9M8ww8VRNCQGIfKvViwVFPXW5+1IaoiRSfBJC667+561L1B8goaD
         ThZsX0v8FiZAn87yU8CrTrDPw9QcFhQvO3XTYuWb99sw1WUUGsQwaMZgbQYHj8Oz89kU
         LSbAmX5S13Jcjrjm1tS4cfedgWGTzfEJ6JVV9BIOJ1Khz+TRIJC6x88PHLvx/nJwRpPq
         K/svwmpLd1usS2dtVd7AdwzmJbCmo9zvEfUJXqZpPBWCbYWWVLq85N2w48BJtGxXs5HU
         R/1hB0wZpbINZgUn/rJ5ca4gyFo/mnfguQnoayFkwmVdlG6j+5smL8SoayfDlqbxYmhx
         wtbA==
X-Gm-Message-State: AOAM530BqaecAnlCBYJ/7o7XKZTyZxiiitv+mFynmxdIw/k9HZ/UVQJp
        WpTT7Ri+T7EkFoSlR1G+Vjlks8GB4558Og==
X-Google-Smtp-Source: ABdhPJwFGMyIGVr2bDkLKpz3m2r4r/xoym7+kMDjAI//J76Valv15mCRD8UaLNFfa1MROLOkLnNQJA==
X-Received: by 2002:a05:6000:156d:b0:20a:e015:315f with SMTP id 13-20020a056000156d00b0020ae015315fmr2982111wrz.140.1650918088724;
        Mon, 25 Apr 2022 13:21:28 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 01/33] crypto: rockchip: use dev_err for error message about interrupt
Date:   Mon, 25 Apr 2022 20:20:47 +0000
Message-Id: <20220425202119.3566743-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Interrupt is mandatory so the message should be printed as error.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 35d73061d156..45cc5f766788 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -371,8 +371,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 
 	crypto_info->irq = platform_get_irq(pdev, 0);
 	if (crypto_info->irq < 0) {
-		dev_warn(crypto_info->dev,
-			 "control Interrupt is not available.\n");
+		dev_err(&pdev->dev, "control Interrupt is not available.\n");
 		err = crypto_info->irq;
 		goto err_crypto;
 	}
-- 
2.35.1

