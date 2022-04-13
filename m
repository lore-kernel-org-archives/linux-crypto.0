Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C515C43219
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiDMTOZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238243AbiDMTMr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:12:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36E471ED2
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:57 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l9-20020a05600c4f0900b0038ccd1b8642so3478016wmq.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBfzxCMFwSqtUUAKgLYX1NAdCBaYrQJEwA5Wp5fjHpE=;
        b=yh8B4MA5+IIC0lL6pBWdPhs6d9WmcV3UPM/GHpIaYenQKbu/9Fa70KpToA2XQDr+Yg
         U9oU05mcUhaNNdu2BM7aJfgQCMyRA1nr6H0/T6urpImHNeJ7xa3de/rU2e1NkK5zRwA7
         UlbrPz6GNsAr8UytypSrhTBVM+Xht/FOXWY7m+8tawOZoSgerR3YJhf6SXMsgi//4f5d
         5985xj2AZJYpJHMQlkMrgZCxiC7kbDDqzPpDLMEZ+bhEJX/ELnPhmIGMHPGwkuZAn7Lu
         dsz6g7W0wSoS5gbs8tFrmepfmCMgF+s8d+zhTQ0FBuipmJNZ3OPeXkBc75OOimNYZX84
         Elxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBfzxCMFwSqtUUAKgLYX1NAdCBaYrQJEwA5Wp5fjHpE=;
        b=zClW1BVhZ1VopFuYx6nuHTUOWig3oh8iVbpfV4CipflFti8mtdUE3Y2reJzNbo4wvs
         KLFxvByYrNwHVByddq5qDa1Sbl34gy2eyWZsXxudYycMVqix1qG2gpbB+1VfQ3NUxpxv
         4VfCQMl+Cuj4m5YlkcWvDTjqP8ILOvUv6TnUJngKBgLLUYnwwTDSHJGfp41kwuE3Iqt9
         kRRJdkdTKpHO/TuT3EQhAWojLw53NPGJNWEPYc8d64Kr+lGCoeO9HeXZWMRYHXJTea6a
         qKAD5wRNuxkPmV16UafZZjshfW9P9HqkomoLnExO+aq0Hm8PDQsY1+MCxLGKgDTPZdV8
         R77w==
X-Gm-Message-State: AOAM533t/BXCCGB2yzLUpQ/AvXHnFDIduEzRkZjOLJKyRIcwZWW3MAv4
        6JGwp96Ii02IhvJMUNdUNPVFiw==
X-Google-Smtp-Source: ABdhPJyQ86GCiYzB29RlHiNKRPQcam5duoianBOXT2nFnR89sXRr77+hqM+vPCyb+YE2l+bErpELsw==
X-Received: by 2002:a05:600c:198f:b0:38c:a9e9:754a with SMTP id t15-20020a05600c198f00b0038ca9e9754amr166676wmq.146.1649876876246;
        Wed, 13 Apr 2022 12:07:56 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:55 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 32/33] crypto: rockchip: permit to have more than one reset
Date:   Wed, 13 Apr 2022 19:07:12 +0000
Message-Id: <20220413190713.1427956-33-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RK3399 has 3 resets, so the driver to handle multiple resets.
This is done by using devm_reset_control_array_get_exclusive().

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index d6d78b8af57c..9ba9b9e433c4 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -276,7 +276,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	crypto_info->rst = devm_reset_control_get(dev, "crypto-rst");
+	crypto_info->rst = devm_reset_control_array_get_exclusive(dev);
 	if (IS_ERR(crypto_info->rst)) {
 		err = PTR_ERR(crypto_info->rst);
 		goto err_crypto;
-- 
2.35.1

