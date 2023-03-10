Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B13C6FD19
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 22:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjCJWc1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 17:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjCJWcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 17:32:00 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B999148B55
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 14:30:37 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u9so26547633edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 14:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678487429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yodfxav1LXiUxle6XANNbX/Z+j2dWw1JGjEiKEmBNp0=;
        b=UCWCpQ8oJgeqcXREz++5NJvrbXoiC0M7OwNNlnPoXOrLkGYFBcoUqulhY07CyFHWzZ
         SVw+hPxFrTmvxO7R3h/FIFq5VyYipEDTZt8EPrUJ94Z6+d91jT0lN2rUERB/y5EytN++
         565dairF67j+QtmKmV+8Mx19RPWeUZI9UG7wHztVod3+Tcnp6LEju81bXMTbv83Y47Uj
         J6W1ulelNB1faXrBBd0x7/8fwJHoUDJxixfWx7tyAkHa4LymRXKPpLHrPOeW1RoHfjOs
         77ik5Yu1JyCGks4t95kzqqeJjF72DxfKUw5CuAL/a3sDlN89Dwpgppme9HWnH9T9R7jc
         6LOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678487429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yodfxav1LXiUxle6XANNbX/Z+j2dWw1JGjEiKEmBNp0=;
        b=fZljII4ZMO22z3VBK0j/ALfJ8j1b0xgJvy3b6ELWkrNxMBJLlnRcFDSok1rhC8bIlc
         xP4Er2Bv2wAR62kpeDl+nZc44SJmcpfo9JucwpT11wtLHXsAZLo7+o8aR0KjzfJ4XZhq
         sVOrarTDI5wdlQNxSWpUvM3BYAyMeZ/gu4tXVTzdE2Yh9DZ0Bc/gEoImWsloBIS5FpKL
         DZNR1d/LMnEkNX0N2gD6VQQAeWoNcmbyIQtaWWI5pnDQyD44nCPMawQiXFLwwwioJpGC
         GaiuyA96e2pGnJJE0l/zNppq/KBnElg1gFtDxfq4pehPHPwUvKXS/3TXzg04WultVRRV
         PHYw==
X-Gm-Message-State: AO0yUKVJvSPnpcJ3I/XWzsAmeK3zsHHkMxEPjlx136ddGJ4wyJK2aY/h
        2E1n09P8UexY5q7mIX+6hiLqsw==
X-Google-Smtp-Source: AK7set+ps51xBNBPOyAtywb3vPfqNJbgdWdpxP+Y3/NaogaVnf/jIYb2DNrPlGKZVVpge8s2McO0Rg==
X-Received: by 2002:a17:906:246:b0:8b1:fc1a:7d21 with SMTP id 6-20020a170906024600b008b1fc1a7d21mr33159524ejl.5.1678487429056;
        Fri, 10 Mar 2023 14:30:29 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id l23-20020a170906939700b008c5075f5331sm360279ejx.165.2023.03.10.14.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 14:30:28 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 1/2] crypto - atmel-sha204a: Mark OF related data as maybe unused
Date:   Fri, 10 Mar 2023 23:30:26 +0100
Message-Id: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/crypto/atmel-sha204a.c:129:34: error: ‘atmel_sha204a_dt_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/atmel-sha204a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 4403dbb0f0b1..44a185a84760 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -126,7 +126,7 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-static const struct of_device_id atmel_sha204a_dt_ids[] = {
+static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
 	{ .compatible = "atmel,atsha204", },
 	{ .compatible = "atmel,atsha204a", },
 	{ /* sentinel */ }
-- 
2.34.1

