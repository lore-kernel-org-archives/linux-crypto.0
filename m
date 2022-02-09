Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66CDC433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 11:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiBILXN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiBILXN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 06:23:13 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BA5E08FBD2
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 02:17:30 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id o24so472384wro.3
        for <linux-crypto@vger.kernel.org>; Wed, 09 Feb 2022 02:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vfAV7F+Ro4DbSdjhHkusaJBb3PiMNKM76wOprs+NcNM=;
        b=ny9ULsL/xMEXFfNXPt20i+xiJxpkX2dV9SayL9TBFHnQZRFvyPp0T00z/YJrWXCNrL
         B0x8FxZfCdLVm3CW4kS/+7tgqqUiYKSPATkRb6BF9/tnoNqwZv/b11y/6rIZgRXHpArU
         5ZrEiJM4nHjULj3695Qcc3hqXjmarVseMpa3GxX8WqLmB15DbGwufz+iUoU/ghEJguzj
         cDquRy5IkmwC/jRm7sFTgzlmYvH8aZgZCKq5YnuHF+UFWVn4BrRSvA0mziIkSLydOE98
         sZ68twH4yfcSEuLLynk+EdDdPxZhn45IYbtbIpmC1lWwSRqQk7Bx4jLyBW1ImXROWCFw
         mW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vfAV7F+Ro4DbSdjhHkusaJBb3PiMNKM76wOprs+NcNM=;
        b=J1NbdfK+ihGMZWr+0KS4tQiQ8C8RDERbsMhXmKFtHOfg4wJ2qDUoTk2acGEE+KPoHJ
         HYd0NDoOLRKo3VdxzB/JznM2CvpWC/0z8BSimICQuOXg7nNslG9aC8qLkF1AfU4x/g9x
         NMwoD1bAFIasX50qI18ugNaudQdwqF7dOXn04ysTb8G7CdFHxRSwC4zAFJy+/D+XnrYm
         Uta/wquj0gpwyDVOW+t+nbM1d89LLhqN7CuIzHM7vwO83XdHe45+P4LDOtAevEXGaZCR
         GpSt6lIASnZTu1watZau6c4Dw8QLc1HApxDozFU/YnGUcmhlqUZgjzEKXs+j1RYhb7FB
         H6JQ==
X-Gm-Message-State: AOAM532KsriK48XpQOcI0XCJ5G5dRQyxWwD6+tcwGzXKxlzxcU5LFvaZ
        sQCWbSUKyK4ZsCaa12ECfbXDsg==
X-Google-Smtp-Source: ABdhPJy0UdpjCxyiilvCKFqjSjmlR/q7Psi0zrmsidgeyfsV9G3fsYdDsqE4HZdrlSWv1cvyhkKIIg==
X-Received: by 2002:a5d:6d05:: with SMTP id e5mr1504960wrq.214.1644401848828;
        Wed, 09 Feb 2022 02:17:28 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id e13sm17740929wrq.35.2022.02.09.02.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 02:17:28 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] dt-bindings: crypto: rockchip: fix a typo on crypto-controller
Date:   Wed,  9 Feb 2022 10:17:21 +0000
Message-Id: <20220209101721.1659574-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto-controller had a typo, fix it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 Documentation/devicetree/bindings/crypto/rockchip-crypto.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
index 5e2ba385b8c9..53e39d5f94e7 100644
--- a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
@@ -16,7 +16,7 @@ Required properties:
 
 Examples:
 
-	crypto: cypto-controller@ff8a0000 {
+	crypto: crypto-controller@ff8a0000 {
 		compatible = "rockchip,rk3288-crypto";
 		reg = <0xff8a0000 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.34.1

