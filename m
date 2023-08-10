Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4AFC04A94
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Aug 2023 10:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjHJKCv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Aug 2023 06:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235241AbjHJKC3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2023 06:02:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CDB30ED
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 03:00:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3fe45481edfso6752605e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 03:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691661627; x=1692266427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EJpAe1JQRQzLr4HpWXO5enRMUdenJgniTKPQuT4aMag=;
        b=o2Xu3N8gsBKbsUqsqPOXA90TMKTtooEE7vy7ZbyqxPNFgdRjzYSFaAJfNIzfu9fb3G
         uwi1FMmAHBaxrClDBQKIiW19XCbK/z9Ct5iVUJT1IQmgR1hQbFTm90SFm6FjlUnIqoY0
         OY/ZpgkJPiqTqLwu0lA99ZB0NXyEGI7YEfGay/HSXJo0Z3g7u1ghsjthdKEAYJQjqVf9
         UqPWePVhZ1WqT0ofoLzCOBcj+Jv7VntvDl36Hj3eOyA8+WJIqqkD0ro7TPEXBc2v4vWT
         AUJhC4uBq1gmhf8T6LyjTJ5Drh3gT4rtJzsCLFGXcIA0IWcLSjZt/XZibqPUdJUGj3tY
         ZgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691661627; x=1692266427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EJpAe1JQRQzLr4HpWXO5enRMUdenJgniTKPQuT4aMag=;
        b=emhPfwBysTA8/OadqgoxVCfOeOuq9tQ8tFT4inhsZSzKnb8qTPJiSSd/iRM2SiQFbS
         ILfRUkZg3ZYqBfesEQvmVIS57ax31tfLtST5B4rah2fursuOK4y+u0m2KiFL8ywkYpis
         TmWTnHejCbAR32f8p15yy4BNKHsX6he5THwJOh2Q0QrawYu7CKnLLWDn9kTFVrXmmGNy
         umMCsxVAulcBkJ86r0O7PzTODV8GhW2QXMc5wpvDt+mXiVwi737ccdPtdGmcFx4+ppdk
         GDOJrCwITIH5a39fZEVkEids2eWR1FG9aSnX03Xp534KcAFn8KpQ3B6FSxbrbK2xY6Ez
         ZNKQ==
X-Gm-Message-State: AOJu0YyegXTZL4E5NkRS70iLptxDCIFpVlU2QrwqkMxP6+4MwrY23ogB
        fzENjlJ+2PawKIocTkx6WE9MKg==
X-Google-Smtp-Source: AGHT+IHxqMT31Sy/C+YwIQaVLuwACdfzqMWxRxpt+agaXRC3ydv+UIu51hWX4dWN7D0RnMHVf8X0Eg==
X-Received: by 2002:a05:600c:204e:b0:3fb:e643:1225 with SMTP id p14-20020a05600c204e00b003fbe6431225mr1448299wmg.13.1691661627238;
        Thu, 10 Aug 2023 03:00:27 -0700 (PDT)
Received: from krzk-bin.. ([178.197.222.113])
        by smtp.gmail.com with ESMTPSA id f2-20020a7bcd02000000b003fe210d8e84sm4569498wmj.5.2023.08.10.03.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 03:00:26 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH] crypto: exynos - fix Wvoid-pointer-to-enum-cast warning
Date:   Thu, 10 Aug 2023 12:00:23 +0200
Message-Id: <20230810100023.123557-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  exynos-rng.c:280:14: error: cast to smaller integer type 'enum exynos_prng_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/exynos-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index cbd8ca6e52ee..b1df66be9adc 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -277,7 +277,7 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	if (!rng)
 		return -ENOMEM;
 
-	rng->type = (enum exynos_prng_type)of_device_get_match_data(&pdev->dev);
+	rng->type = (uintptr_t)of_device_get_match_data(&pdev->dev);
 
 	mutex_init(&rng->lock);
 
-- 
2.34.1

