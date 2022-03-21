Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA4AC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352922AbiCUUJW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352908AbiCUUJU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:09:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1D3103BB5
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:07:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v22so8307894wra.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4Tf8ps8Giknxs7LQki4ZGeia2acPTQFjucag6hcCiQ=;
        b=a5sdYH/JpduGpHD1tJRBR8er5IEbsClNfH4hgpWRK5s0+TXOINVNN1DNWc4QM5y0cz
         JH6/NV5PqdZ1ky07vprQy7CVZz+/Wq35BT81QdG6z3kTRWl/mFF1tbvyb5U5lkph+rGa
         DCznuSr+wpfwfCTRtEYMSF2uJFLVckT2GtBapFEGR7cMQ4FAVNxhnxjfandRUP94E43J
         TV6jkc64qtNCwBd2Abay8L3GUGgych7CpLkh7HYaLRkGBNxZvnIV6VTRYD7vqxSMB/RB
         vPUIqL/+XVdFYhuz4BxNljahR/VYlwTEWvz5zvoWvB+uNrG1o4EIiKWX8nCrUBtNRBj1
         FqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4Tf8ps8Giknxs7LQki4ZGeia2acPTQFjucag6hcCiQ=;
        b=YcvZXO+zTK2hx/QOHP6Xa9L9LOH58nd/0KKeReHddZFfzDIzIRbkv7N+Nj7qkQyXsr
         dCa3U0XSrPUxiyx0rAz7V1P5HJLi5uH7lZ61TGqPfVR/Pwi2TUXdz25IWMuCw9U1RL5U
         6xpzNQC4AppcczJbvQn2nYZvExOdVjs1qU20IbIZNxWvm9/BiTJE14t6I4lo28HuN3UO
         KssGIe9rPwBxTV54Ci03xPBCyqap+QQiD2/zmEgCNO31l8Hjg+FtL5QlD7ERVJj5cyG/
         LlXNLqSju4uifVwdPYXTyWa6I2t6nfVGp4WgWTpOrU1+isnh4ajWGOK/7GceGSR84LE8
         52Zw==
X-Gm-Message-State: AOAM530u0N+6ruw6iZuoe3M9BADfvDPa+Gf8yb17gxvVSI7+4Q4dmLlC
        Ug96tluuoqQklmo4uLSZb81ymg==
X-Google-Smtp-Source: ABdhPJwYTWhzkN17VaZNGiC+QJK17xaCo3Z3qvpMMvQ6vPT24W5CB9Yg+9XGiJtSQblUoHYogJ4VkQ==
X-Received: by 2002:adf:df8c:0:b0:203:e4f3:920 with SMTP id z12-20020adfdf8c000000b00203e4f30920mr19304734wrl.461.1647893269753;
        Mon, 21 Mar 2022 13:07:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:07:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 01/26] crypto: rockchip: use dev_err for error message about interrupt
Date:   Mon, 21 Mar 2022 20:07:14 +0000
Message-Id: <20220321200739.3572792-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
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
2.34.1

