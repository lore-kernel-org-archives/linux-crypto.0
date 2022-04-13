Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E685C43217
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbiDMTJt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiDMTJr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:09:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF4D6E4FC
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c10so4011406wrb.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=VYNvVfTkDsS2GrZecgJ4GpodMXD4vwGRpH5f6fSEdCuOongHsWNf84yDBtLMfZpCh/
         bP/TUsh0Q4kp2FgAq1vxWG8dYmA5buAK9Bg3fehnNA3oI0F/SBENezK39wwQD04oKScC
         j2wf+dGY8pzeVQe/CungYvO95ijHs+X1EwbGHZLyXNi6ja4lwh2vCN3REwR60vJey/Ql
         llTjFB5wnjf4SQ3m8/Mm5oPJm/CsXvGqWgVOIoeu4BUZmuUYKUu+z/kiSyxz2at8nCsx
         eKm/1okCDZUsEjkQPL1p7RKhjElkzqlXXMKPQULRiNSzh9V+pKAuGw2ZScnfcKA8HQvS
         Hd4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6k9bKJA41frCR0pmOk9SA+9AKNxBSbRS1tpgQTa/e4I=;
        b=X9r7L8fr1gHP2Ec7rr2ZGt6FVBRIJlXApR6H3NQIonvxP86UEa0M0BvEKL9mNWkTbM
         MTfP6jMrpSLiMnVkRZic012XQBtRxOMZuxzzfU52mbjFwyVNKk2ek/ccPCFgXZbj057W
         3T+BeWXdveRTQFLQXlQy9CLEWRYVQznXs2m1C4EdcSfnn2Ehlkrd48afHU8S2jSGTn2d
         GUT7eezZnpD1+tOyxxk0iFhtesSXci6aWnRh6K8m/Fy8cx7OWWDiX0kMz+8MpyIX+vR7
         MZLeTS65KvX6ZJhjmlFggLdmwCs7x6YvPZl42Wgv0RHSdQr9UMVqR1uKBbrdLJyP3EOj
         smYw==
X-Gm-Message-State: AOAM533NrKBi+xCw2BBea9EBZPoiNyQonVwcv1fLYa+ONWOfuwBFy7NN
        tEZHEATHNtAPfxb+bplB3e1Beg==
X-Google-Smtp-Source: ABdhPJyII1J5W8VWBLKAspEHoqtylYWUh8tT0Az0Bc4V8OU2/VVFPwdptvVPdB1L4uaAVEEjl9swvg==
X-Received: by 2002:a05:6000:70a:b0:207:a120:bfbd with SMTP id bs10-20020a056000070a00b00207a120bfbdmr258416wrb.142.1649876842619;
        Wed, 13 Apr 2022 12:07:22 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 01/33] crypto: rockchip: use dev_err for error message about interrupt
Date:   Wed, 13 Apr 2022 19:06:41 +0000
Message-Id: <20220413190713.1427956-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
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

