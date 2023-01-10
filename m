Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14676C46467
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjAJTTs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbjAJTTh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:19:37 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7581253280
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:35 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id bu8so20015292lfb.4
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/o0PiJuOvWG4Quan3s3nxBl5R0QTcNbdsB/Kd9BP1AQ=;
        b=QvzRMTn4hye8yVLEuaUkyDFux8Hpv0eajm0LJm8GMTintGJx+1ujiclNrF/I6qEjJU
         dOs8yppVqBnHrv1mx2QAR6aePZxGxJxGTx1kMx2/NuONqaB3kaoyEgb1/R1O0cbmlqq2
         MtLTJ3vRqkxhzKkZS8c4etDgliJhzAXncvhubP6lkn11eNlyzHzV9gmIXnGoraF0dHuE
         omYXoRbzy0s3gLJEsdyKhI5BjryhaKblv09V7MQ+nrfi2jDCG0iIUbVEDetBsJBm5W8i
         txmuARCMDcCayPSmkKW00ELukdHIX40msCknwZCd3F92GI1fHpYKdcagynhNhw837Tvo
         MXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/o0PiJuOvWG4Quan3s3nxBl5R0QTcNbdsB/Kd9BP1AQ=;
        b=zS79lHrqL9P1tcOG9dI/36cWC3ZxyeAOKjMd3wX8pwoeMjMJ64PgZvvlUmDcr1dNcW
         +9iPBt9cqLFJbkfRQhw6WIRATREFSYA9asDTSRSAJmxbLZUlfCiQUOl7d16B41ll50RJ
         WgLw2ieAgaxraA5UkYDQd45sPTyPlztSGYpPuhIyDM+vVT9tvyoHUQRmM39CT9jV28yo
         uSb78VpGQUgsMj0LAFP/Q3ESZQ7ckDDweKkF6O5Ux0fDXPGM0d8yoGJSoJbNdt2oe119
         kIE3Nq7NmaLfDkwo6LKCuMkRx2H6+t5JG3XQUnxDyPtw7wrxrzxGGxa/B7xmDSar1IcN
         j0tQ==
X-Gm-Message-State: AFqh2ko9fSbw6rNv4ENqxipJkcBgurtOJxsh+5PkTn0d9H80ugQGCM2U
        HL/JygsWBUvwtNMYfYuhTROnTg==
X-Google-Smtp-Source: AMrXdXs6/SKNTCtGaClH++pUygPpcPqjxV2jEl7EmmiQq3LniMkvdIeZ5Ilrb8zDWZHWjgRBe05fTw==
X-Received: by 2002:a05:6512:693:b0:4cc:96fc:7b5d with SMTP id t19-20020a056512069300b004cc96fc7b5dmr78374lfe.52.1673378373701;
        Tue, 10 Jan 2023 11:19:33 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id x28-20020a056512131c00b004b549ad99adsm2297725lfu.304.2023.01.10.11.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:19:33 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 0/6] crypto: stm32 hash - reuse for Ux500
Date:   Tue, 10 Jan 2023 20:19:12 +0100
Message-Id: <20221227-ux500-stm32-hash-v2-0-bc443bc44ca4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADC6vWMC/32OQQ6CMBREr0K6tqb9IIgr72FYlPKhTbQl/ZVAC
 He3oGuXbzIvMysjDBaJ3bKVBZwsWe8SwClj2ig3ILddYgYCQAJU/D1fhOAUXzlwo8jwGhHKa15A
 DT1LWqsIeRuU02YXv/2IFH+SDsu498aAvZ2P6UeT2FiKPizHk0nu6Z/RSXLB2zKvlC50p4S8P61
 TwZ99GFizbdsHIyAPqtkAAAA=
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
Changes in v2:
- Use an else-clause in the DT bindings.
- Fix up issues pointed out by Lionel in the driver extension.
- Dropped the patch converting dma_mode to a bool after
  Lionel explained how this works.
- Link to v1: https://lore.kernel.org/r/20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org

---
Linus Walleij (6):
      dt-bindings: crypto: Let STM32 define Ux500 HASH
      crypto: stm32/hash: Simplify code
      crypto: stm32/hash: Use existing busy poll function
      crypto: stm32/hash: Wait for idle before final CPU xmit
      crypto: stm32/hash: Support Ux500 hash
      crypto: ux500/hash - delete driver

 .../devicetree/bindings/crypto/st,stm32-hash.yaml  |   23 +-
 drivers/crypto/Kconfig                             |   10 -
 drivers/crypto/Makefile                            |    1 -
 drivers/crypto/stm32/stm32-hash.c                  |  243 ++-
 drivers/crypto/ux500/Kconfig                       |   22 -
 drivers/crypto/ux500/Makefile                      |    7 -
 drivers/crypto/ux500/hash/Makefile                 |   11 -
 drivers/crypto/ux500/hash/hash_alg.h               |  398 ----
 drivers/crypto/ux500/hash/hash_core.c              | 1966 --------------------
 9 files changed, 227 insertions(+), 2454 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221227-ux500-stm32-hash-9ee26834292f

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>
