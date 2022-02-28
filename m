Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046ECC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiB1Tq4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiB1Tqy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:46:54 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B992D1FE027
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:39 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j17so17163516wrc.0
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4Tf8ps8Giknxs7LQki4ZGeia2acPTQFjucag6hcCiQ=;
        b=pQfYzu5gQGvtExS8j6V0wQbX2h22JXAb4mWQmJesNVD6fgWAPw1kFTsYkVzLiIlPjR
         f64bL1c3Gx57wujouE3pi/q6ZFyeIfh9mZaDu5taM5uqrE+/hrhnYPjtUMTg6sS3KWk7
         zQlWSwvAKT0x9YyxhP74uQJnwI2tcuPC4OO3zI1W0eeHqO/JAjPZPkIVzEfVo2ewffjS
         YotD0QLOikj/Tv9v9RtkR3bS10GHMmzOaER/9W7st5PdjApjSLnKA4BFWB+o1AogRxmJ
         EmGM/V/K/4dbOlP2lq4lqt4FtBhH7c2hLG4VNVqia9cfSWk7ivxc+dRc+HYlqZhMoQrt
         t67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4Tf8ps8Giknxs7LQki4ZGeia2acPTQFjucag6hcCiQ=;
        b=siAM+WuBrsV9BLVYsasfWefWGdk0kz32JiZCZgnEt1LCL1oPTl3Uec2LoFTN8wC+Ss
         dpDf8MAEFBDDgQiij+wvYCDMlQh2UF4kkQ9esjhLgnqYWbQAEm8Fd3V42TT99lvULDsW
         LuUAwlO+2khbBum+ZULfqAlHU7+IV+dMk7f4n7aaGQ3jgYaYV6TDw6ow/0ScTX4pjPBr
         bvI2wcbXfxGLNCy3IOGfdUoxU2XSBn87zHhAs3i5jwQOSSphgQ1Q2NEh46ClkidPQ9ee
         ga4vHsMXfqYcHCwl4QO+Zd+mHp8bNrP9ljEomOJZ8259xpAK0JqwSe2ogEDSk9aJSTBp
         O8MA==
X-Gm-Message-State: AOAM5324uOABkEUDJ55FHu91u5uF4HslILIbhrXNNEwAvuUKhm3Ojg+Q
        SrvaeO9OyBZmtpCswuGeSWMjhw==
X-Google-Smtp-Source: ABdhPJyCQQtSseZ8J+9GAAAPOG5gkjAhg6vVntdlKc/MqESku4jC3awvJmxxKGnA8cIqcferj+ON6Q==
X-Received: by 2002:adf:fc8c:0:b0:1ed:f5af:f7c6 with SMTP id g12-20020adffc8c000000b001edf5aff7c6mr16818211wrr.386.1646077244429;
        Mon, 28 Feb 2022 11:40:44 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:44 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 01/16] crypto: rockchip: use dev_err for error message about interrupt
Date:   Mon, 28 Feb 2022 19:40:22 +0000
Message-Id: <20220228194037.1600509-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
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

