Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32700C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 22:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiKYWc6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 17:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiKYWcn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 17:32:43 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D900058026
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 14:32:25 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id z24so6604771ljn.4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 14:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hbzo+NbmLokJWoaf53jWJ1PlLdMPH3z8QwlWnFJHboQ=;
        b=qAMiBcBCA6ZC2vDgjzxeetijB5hgzgtmDp0EGZw9Y1f/3QPX+lOTup0cSIgTpzai4P
         xBgkbnT3DdXeZI75ps9S5WhMhYC+KFcv//WX7CiE+x6uHjNuytH/BPAkDT4ppEoVFpWa
         LHRH4BEPiorU0h6wA2lRjpOX81VwtG+0tXiJ48i5qZ6+F724HY3qx4cQyYLAUagqP6jK
         XRgp/gDUY3iYmCKRpn0LEzVaxTQIteUJFImFZ2C5uWLHuW1y5oSdfoHqaOyZPHn9WDjT
         4iNTz7jlBV9wLFKHnOdZguv9dga58PIaZcui/rJ+KuUbwdmiLHnZyctmGZleFAOjw/Iz
         /ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hbzo+NbmLokJWoaf53jWJ1PlLdMPH3z8QwlWnFJHboQ=;
        b=tWIItnkJiitmaPFrewTMThBRsLmoxKXuWcqpTf4Mr4bMF77UqtYNnLoNDtDKI8XA00
         QaeqXMO5YMNQJ5m76312ERq4zJ85dlgZJ51jzaS+KpUQ/PoA+U0Ng3dbnkYwAie0QSTS
         2Kg1HJNbHZPt2rc6UGdKNeRt5bxvWHObnGRHoGRkFmFfifB6iHG6LO+V4cNQXL2BflQu
         Sx4tKwPw+AhixKHaUi9WXA/EZ7uhbHwLq+CGatRSDc9TPzWfSBK6HPN8luNdEdGz6nkG
         9qiLiv0TgQ5cjG/gt0h5V1qGel0Bj5TvH8TBNdFTsDWJ0fG+nlfjZVIm/ujYxe/MFAzA
         lKLA==
X-Gm-Message-State: ANoB5pkLCKcH/vhBrodcEXN46PgnAYjNmH2WjHgD6tE+h7w41Lk3ae/w
        W3JJS85OznLyiScCQbbNCGxIq3FbMQ5LQw==
X-Google-Smtp-Source: AA0mqf4nALAFRo+i9Lt2nEWIV3o/WiUXRn7SPSrmkJSeSX79ggmnK5QrKHcoydhJaIcIZ/mSOufVnQ==
X-Received: by 2002:a05:651c:10af:b0:277:3046:3d1c with SMTP id k15-20020a05651c10af00b0027730463d1cmr12443609ljn.422.1669415543990;
        Fri, 25 Nov 2022 14:32:23 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id f7-20020a05651201c700b004b4e9580b1asm676582lfp.66.2022.11.25.14.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 14:32:23 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: [PATCH v2 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
Date:   Fri, 25 Nov 2022 23:32:14 +0100
Message-Id: <20221125223217.2409659-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125223217.2409659-1-linus.walleij@linaro.org>
References: <20221125223217.2409659-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the Ux500 CRYP block
as a compatible in the STM32 CRYP bindings.

The Ux500 CRYP binding has been used for ages in the kernel
device tree for Ux500 but was never documented, so fill in
the gap by making it a sibling of the STM32 CRYP block,
which is what it is.

The relationship to the existing STM32 CRYP block is pretty
obvious when looking at the register map, and I have written
patches to reuse the STM32 CRYP driver on the Ux500.

The two properties added are DMA channels and power domain.
Power domains are a generic SoC feature and the STM32 variant
also has DMA channels.

Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Lionel Debieve <lionel.debieve@foss.st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Drop the second (new) example.
---
 .../bindings/crypto/st,stm32-cryp.yaml        | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
index ed23bf94a8e0..6759c5bf3e57 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
@@ -6,12 +6,18 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: STMicroelectronics STM32 CRYP bindings
 
+description: The STM32 CRYP block is built on the CRYP block found in
+  the STn8820 SoC introduced in 2007, and subsequently used in the U8500
+  SoC in 2010.
+
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
     enum:
+      - st,stn8820-cryp
+      - stericsson,ux500-cryp
       - st,stm32f756-cryp
       - st,stm32mp1-cryp
 
@@ -27,6 +33,19 @@ properties:
   resets:
     maxItems: 1
 
+  dmas:
+    items:
+      - description: mem2cryp DMA channel
+      - description: cryp2mem DMA channel
+
+  dma-names:
+    items:
+      - const: mem2cryp
+      - const: cryp2mem
+
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
-- 
2.38.1

