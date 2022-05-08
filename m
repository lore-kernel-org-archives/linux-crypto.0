Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC08C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbiEHTWl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiEHTEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:01 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52477BE16
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:06 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o12-20020a1c4d0c000000b00393fbe2973dso9661444wmh.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=7WVkQD9lHCDxKB1tD6Un3hFpvX4/cOE8DPsLwSHDOQ7kt6Z2YTDF0rFp5+4bJAtC7w
         DaON87xrGfLz4D/4CKcyMsiq3DL8xisQUHwdd09W40h4D5DFOHh0rizcHFtmOgZsV9c5
         cfnnG8lF+9r5eCrmwylUG43+huwETysAbw8WbNcl9x47hFGjbYfxAH1lyAvKSXHW3nSz
         BtI+lB1SU7EoSr+Uq8LSpCA6qZJ0RBGa2p2T5UufQsicJVKF7cfYMwInywjhKRxm4hiD
         +S2H5vkgIqpdY2JT4C3gsmXhX0XQLWVK2x3qDFWOhQ10NUuVJwxQ/sQifbz8Qly+MDjy
         AvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=rgyhSQkXAIxoKx85jJaRYTCB1nCiCuHk/YTdRglCf5NCqs5X9mgU2+WSvPCTpFm8v+
         sEjetlJWynOAi8iDREM3y34I1oKQevJYUGCzHrkSeV4kPjxZPZrccpBE28HxIMp3VZPH
         oHQh94jp8RkxNn7bHPH1Jf6aVwTKn4ySA7T7497491be5h0ux5796cTOlQ3UzDH4x3uh
         Utk0NG/H0cWn0YSGbZTQwZv9h7XuThpx9UXCuPXTQA/zMdGJ81eTBTJwIc07DoJcxRD0
         wuiMwudboupM5Qb4NX7XA0KrSB/SYcGT6HBDivua/Y3JV0/pCI+oFjtezMQAdrpj78jw
         HRlQ==
X-Gm-Message-State: AOAM531YLgTqVY3Pnnn961oraif9BHIFeOI2HBLvBT3s1fAoI/p0w2Du
        f/CHHJ5k4Fu5j4uaRVHZNPaTqw==
X-Google-Smtp-Source: ABdhPJyymoMl24/Hbyu/S0aD+hJRH2OFCmtyRq1xdU5U/WWO64hRsKGKdBVXoAmW0JTe54gXuOZHnA==
X-Received: by 2002:a1c:f30b:0:b0:380:e444:86b9 with SMTP id q11-20020a1cf30b000000b00380e44486b9mr12915348wmq.81.1652036404843;
        Sun, 08 May 2022 12:00:04 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:04 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 01/33] crypto: rockchip: use dev_err for error message about interrupt
Date:   Sun,  8 May 2022 18:59:25 +0000
Message-Id: <20220508185957.3629088-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

