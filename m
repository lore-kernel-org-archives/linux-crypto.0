Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC141C43219
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245206AbiDYUYh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245195AbiDYUYg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:24:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3933A1240F7
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:31 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p189so9953232wmp.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yV669w6ThAcunb2ptGEHL08NqOMgexsX7UsYGNNFxgw=;
        b=dI5RMWQEfNwOiJWNjQByihhh2EF9r/7KiCccoj1Z85lHvuo2cKvBRm0C8hgIwI+UWQ
         ibGR/ObFkwHqTvrcVk9Z9zqn3MYPWvbjdOsZGzmHN30Hv5qKaMIw6pgYNWVi7mYoUQOp
         ggRUfIIO5YkvMWpRFwK3pD/riKDox7f9X00q6tsJnwhES1xCKTqRRr2V5QeznTCzGXKm
         30dLwbBr4gw9Sa5bGallbQTciVH2C4KbAq+OlDBuuVL1HqsH96f6X4HIC5Swce9imECd
         7v+Wx3FtNnjyWU95xp+wDeSeBZwJzpLFP7+LnXTE6/537Xl4nCzbSIjGMJNSB1F2bfDy
         B0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yV669w6ThAcunb2ptGEHL08NqOMgexsX7UsYGNNFxgw=;
        b=Kidf4RAgpfRVN5QYJQ8G9a4M6+xAi+HPm2wx5BpNV4ANjjh3l7l+vNQWXgYPQaLe74
         1JYnAqwDcMekq06lUf/SN6U96nbQljuH3hueJi93uS91UGTX5YsYH2+y8DZ2/Ed0rPMM
         0x1W6a2SkVbLTOkFfFQiD6VK3YBm5nO1bLmcu4U1XNreurrZwF4urxBiCoa9QAPw39er
         5IaK6hhVloeNjVYSfsuO5t2ft3z/bsvf0E2bii7h6vIwsYe7raIXtHL5fwiTsJMKxiUJ
         E/sXbXmJAamvVcnHvHULYDM0T8C7ZopcS1sc3hctBboVHtrBpnhrGsZE+gyS39kdeT5k
         0pDA==
X-Gm-Message-State: AOAM5339HJSas79GSFJ/ISA0JFHkK7Qg55nb4O6fPtIZmU2OD5saDASj
        TYx2I/FdGypQ+DoZYEJSzZECnQ==
X-Google-Smtp-Source: ABdhPJzf+IWyaPzP6ab2c63O2WXiPtIH/R7xsVInXnktPeeMpfP6sz3SI8RQ7FqDcmI0Jt60tCRbDQ==
X-Received: by 2002:a7b:c403:0:b0:38e:7c57:9af7 with SMTP id k3-20020a7bc403000000b0038e7c579af7mr17528292wmi.144.1650918089738;
        Mon, 25 Apr 2022 13:21:29 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:29 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 02/33] crypto: rockchip: do not use uninitialized variable
Date:   Mon, 25 Apr 2022 20:20:48 +0000
Message-Id: <20220425202119.3566743-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_info->dev is not yet set, so use pdev->dev instead.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 45cc5f766788..21d3f1458584 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -381,7 +381,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 			       "rk-crypto", pdev);
 
 	if (err) {
-		dev_err(crypto_info->dev, "irq request failed.\n");
+		dev_err(&pdev->dev, "irq request failed.\n");
 		goto err_crypto;
 	}
 
-- 
2.35.1

