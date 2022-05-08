Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D911C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiEHTWA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbiEHTEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:05 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B355BE3A
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso9671499wma.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yV669w6ThAcunb2ptGEHL08NqOMgexsX7UsYGNNFxgw=;
        b=Ki84OyQLc7pROgZxF1gnhF3jTMDMdtHA0MKpUpw5o9PWE0XLuWAk+sF8CCULMHACxQ
         lsT0XNnKNIEzzttaeTOE1QHk57B2KRoJepX1h+/Y5IYUkrtJPsEmb6I7ubPeD/bNzeKQ
         NVZk4mYcG4fMJURYZydF+07oax1jglMhdr3uu/QkPVPoEJ1MCFnjevtCeAHPcKuW16o3
         PclhGOU3Ls6QSpH9ouMbWl3pDOGVUAmmzpDyoNEgtShNx/yviW59rKQrr7fnKB0a6hCg
         WgLfueXyIDzsaWmbFvj+cpBFxTTVaLyR++wN9O6rfZzoziQZHR8rKAamJayV18ANqCvF
         moVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yV669w6ThAcunb2ptGEHL08NqOMgexsX7UsYGNNFxgw=;
        b=mOYsDbVC6Y8bPQv9BXrrAxA9ziomjy53YLHmxpdsFB/k64uzNrwhXO5p/a+9KBhydy
         eVKnL11tAXufkEq8LHpr57ozg26eyyV+6fAnCNuafLRXcPVWf9wtL/ncg9YD7zgC4jt6
         XTreSXoARGxYkHr4zGkzvHBfe0GTjpTycDNTNoBD3AjihJ1C+N1x0FiDyA3hxHTY/iLd
         FLisXkCoVZ8EUA+OYdn0hwlUddK7n+AhANqTre0rXhMa1/6XO3vFYADuzaSOxOByl9/B
         zMLXsMr4xSEH4REt6RYD8q1+S2EkcLi+6l9ECDpvMG/YwYf6t0Bkc6lldmj0bIYVMS5o
         MVIA==
X-Gm-Message-State: AOAM533RhDvpOByIz1BERjTLwsQoaBtkLdzTl2h/49KWiQPQBtmPC7GM
        kvFQfu7vFB8NZKedxm8QJVfQWg==
X-Google-Smtp-Source: ABdhPJxroBCDR5YqPv0VuwWLtpz8x0Z9sdjqxoHa4No5XKXjZtWbwMaPh4Aaq+tNaF5XRLLFHvYFHA==
X-Received: by 2002:a05:600c:3c9c:b0:394:8fb8:5589 with SMTP id bg28-20020a05600c3c9c00b003948fb85589mr2048195wmb.13.1652036405904;
        Sun, 08 May 2022 12:00:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:05 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 02/33] crypto: rockchip: do not use uninitialized variable
Date:   Sun,  8 May 2022 18:59:26 +0000
Message-Id: <20220508185957.3629088-3-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

