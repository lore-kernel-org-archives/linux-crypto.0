Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB60AC10F1B
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Dec 2022 23:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiL0XDp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiL0XDo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2022 18:03:44 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D36DF35
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:03:42 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id q2so15051954ljp.6
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gFNJ64ei6f6JXBXMe7Y3Zh4KDe6QIvYh6U+4hGCC6FQ=;
        b=fIhOFsQRiydhb2CCWZQCwv/VGzgvAH1Ekd94GUmxxTxucjdqiOe4BLy42SsbjHtmV/
         DW4wzE0jz6ZM1MRt+u10XXlGbv/NHvf5FboIU0qZ7sT4gMmxogOFCcClfUcQOJ04UIbL
         jCviVGiPhgDpecsycZqBSIFHn0LPrmOEYNal3XpGRK4Wp+mBkKF63gyA5zlfNUI/YafI
         jG2gxpAxtJibCqukuwW0opA8ZrynF4K6kx3xBC0IdCfZoI7HcxLwwI3c6IEN2db1pDWp
         KLXrlVG52HpxYAkZYZZIL4iAXx9YG4+9EcehmUj9SOkK2YGGu/EZQH6nhsJQPncjnJoV
         jX6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFNJ64ei6f6JXBXMe7Y3Zh4KDe6QIvYh6U+4hGCC6FQ=;
        b=QzGBxFxJhY7EPQ78LSq2txfQRva2MzhQwzngUFra9O1eKcxzShusXWCkE59rrjGi5s
         JccajjGIL+po54Jd8rzo529ELtKXMuhoW+i0cRjGJ9MdzI0mz38WHHkSn5yXJ+iDOn6K
         gVOd33Yu1YXYxH2bHf1JLrTctXqMtcDdlYbdT8PpEG93/BnP/JY4Mxq4oltYKRQE+GpE
         OLONZE7neyogKNmSS708c1PDhr3SsaTfO7waSL9VB7biXBsStT66WJEY/PywF99l3PaQ
         EHbmVg36Arogc5+Y8og11tseEX0miFGDn+u4mI7fteIvFUmUfF3mMO49v1IunMbpEiN0
         HsXw==
X-Gm-Message-State: AFqh2kpZ0x/iY5ErZkR8Vvfk0SXBDxtAq81VYUgI4B9qKZBBmWtRW/qp
        /UbVZpOHqaQIbhVnOmsq3RS6lA==
X-Google-Smtp-Source: AMrXdXsrl25KodHWZtqtUoAPjW154aVte57f4s+nAKl/36NjXoVykDg94a/092ij58D2CqGeYhKzrA==
X-Received: by 2002:a05:651c:148:b0:27f:c391:5a72 with SMTP id c8-20020a05651c014800b0027fc3915a72mr1761055ljd.50.1672182220783;
        Tue, 27 Dec 2022 15:03:40 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id bg25-20020a05651c0b9900b0027fbd4ee003sm876925ljb.124.2022.12.27.15.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:03:37 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/7] crypto: stm32 hash - reuse for Ux500
Date:   Wed, 28 Dec 2022 00:03:33 +0100
Message-Id: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMV5q2MC/y2Nyw6CMBAAf4Xs2U3Kgg/8FeOh1MXuwUp2q4EQ/
 t2iHieZySxgrMIG52oB5beYPFOBeldBiD7dGeVWGMgR1URHfE1759DyoyGM3iJ2zHQ4NS11NEDJ
 em+MvfoU4hb+/MyW/1HQedy8UXmQ6bu+XNf1A28Y85OKAAAA
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

By taking some small portions of the Ux500 HASH driver and
adding to the STM32 driver, it turns out we can support both
platforms with the more modern STM32 driver.

The STM32 driver is more modern and compact thanks to using
things like the crypto engine.

We add a polled mode since the Ux500 does not have any
interrupt. Incidentally, this could perhaps be re-used to
implement synchronous mode, if this is desireable.

To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Rob Herring <robh+dt@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
To: Alexandre Torgue <alexandre.torgue@foss.st.com>
To: Lionel Debieve <lionel.debieve@foss.st.com>
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

---
Linus Walleij (7):
      dt-bindings: crypto: Let STM32 define Ux500 HASH
      crypto: stm32/hash: Simplify code
      crypto: stm32/hash: Use existing busy poll function
      crypto: stm32/hash: Make dma_mode a bool
      crypto: stm32/hash: Wait for idle before final CPU xmit
      crypto: stm32/hash: Support Ux500 hash
      crypto: ux500/hash - delete driver

 .../devicetree/bindings/crypto/st,stm32-hash.yaml  |   30 +-
 drivers/crypto/Kconfig                             |   10 -
 drivers/crypto/Makefile                            |    1 -
 drivers/crypto/stm32/stm32-hash.c                  |  253 ++-
 drivers/crypto/ux500/Kconfig                       |   22 -
 drivers/crypto/ux500/Makefile                      |    7 -
 drivers/crypto/ux500/hash/Makefile                 |   11 -
 drivers/crypto/ux500/hash/hash_alg.h               |  398 ----
 drivers/crypto/ux500/hash/hash_core.c              | 1966 --------------------
 9 files changed, 239 insertions(+), 2459 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221227-ux500-stm32-hash-9ee26834292f

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>
