Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C5EECAAD1
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 12:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiIAM5Z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiIAM5X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:57:23 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6170061702
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:19 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v16so19520280wrm.8
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2nwWkT4441Zvq5igIAOKA8C0HAjPPXDmTRADPlAyhok=;
        b=basRl/C6QptrvQbTpk+LkAHZh/MQJacL+ZAGvkDnh7vGFvFVx3cZ7eoHvSXNXOEMVW
         A4/IH1a11cZI4vc/n4x/VucSGHK99YV85DWyCtXisj+J/mQ6xmVjDBUuHl/Kco27tSwI
         nqblv1KDC35mISIbMzGoWcfd96GO8QAzNAwZg0QExhm6WokwnnSBXXpqXkhFPx1ekAfG
         fcqmxQdL3+pJETQVLfLTg76nse9tFnjPYwwdXKyxU0pZne2j5YF/m22/3GUTt/+uLpBl
         MyenoYaM3m+G+t6Nkho53sd12AD2vB8eOCRsV0hceISDDgdaEDPogkiYeqSNAODuzdbo
         aalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2nwWkT4441Zvq5igIAOKA8C0HAjPPXDmTRADPlAyhok=;
        b=j7X+/HCCoIQ7CqnwEYA1Keq2/BTOFx33bVHLAbfpyxpyCgK7QmHwyTojHpnPD5g7pO
         B3fuPOt3cwha7dKa66VEV/xHw7BhYywwL8T+lNIWS8QRRRDuTuS5Wk1lP3W5rRjLWRsf
         Vomeg436vKk8k0EsqbEwZz0lpe045tBonRoLhqZ8GNNIBlXCpYy9yHuQYlFDGv97+gIA
         DeYMLP2YSDmq9s6r3ibhyzseRBL31CpeamAa0JcA4va1m6Z9lTmzaluwvlQ7PnUOZ6mY
         QUUIZf7cP4cVoU39Ra8B13uGEijikFH26TjoDYpUEiG6l1c+wCoHNDy/iiNuIHDKMTI9
         J/Hw==
X-Gm-Message-State: ACgBeo3rSKBCWMK0rWv4Fgt2GFwNNhUTfZDeEn4Hv0pngUCT+gigy3u3
        1sb5a3koaLXxXlISUtnCFSPjgg==
X-Google-Smtp-Source: AA6agR4IYKknEQA+lBEG/42xj8hTQq56MSul1p6lQ4/KRXttWn5L3gn9Kon82s1xc34ZKvNatRXxcQ==
X-Received: by 2002:a5d:6b09:0:b0:225:37cf:fb8b with SMTP id v9-20020a5d6b09000000b0022537cffb8bmr14603530wrw.179.1662037037975;
        Thu, 01 Sep 2022 05:57:17 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:17 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v9 01/33] crypto: rockchip: use dev_err for error message about interrupt
Date:   Thu,  1 Sep 2022 12:56:38 +0000
Message-Id: <20220901125710.3733083-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Interrupt is mandatory so the message should be printed as error.

Reviewed-by: John Keeping <john@metanate.com>
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

